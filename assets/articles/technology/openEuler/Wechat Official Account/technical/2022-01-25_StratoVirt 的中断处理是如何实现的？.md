# [StratoVirt 的中断处理是如何实现的？](https://mp.weixin.qq.com/s/s1VM71o8s6e_HF_jPtOlog)

原创*郭馨乐*[OpenAtom openEuler](javascript:void%280%29;)*2022-01-25 21:01:10*

中断是外部设备向操作系统发起请求，打断 CPU 正在执行的任务，转而处理特殊事件的操作。设备并不能直接连接到 CPU，而是统一连接到中断控制器上，由中断控制器管理和分发设备中断。为了模拟一个完整的操作系统，虚拟化层也必须完成设备中断的模拟。虚拟机的中断控制器通过 VMM 创建，VMM 可以利用虚拟机的中断控制器向其注入中断。

在 x86\_64 架构下，中断控制器包括 PIC 和 APIC 两种类型。PIC 控制器通过两块 Intel 8259 芯片级联，支持 15 个中断。受到 PIC 中断引脚数量和不支持多 CPU 限制，Intel 随后引入了 APIC 中断控制器。APIC 中断控制器由 I/O APIC 和 LAPIC 两部分组成，外部设备连接在 I/O APIC 上，每个 CPU 内部都有 LAPIC，I/O APIC 与 LAPIC 通过系统总线相连。当产生中断时，I/O APIC 可以将中断分发给对应的 LAPIC，然后与 LAPIC 相关联的 CPU 开始执行中断处理例程。除了上述两种中断控制器，还有 MSI/MSI-x 的中断方式。它绕过了 I/O APIC，直接通过系统总线，将中断向量号写入对应 CPU 的 LAPIC。使用 MSI/MSI-x 中断技术，将不再受管脚数量的约束，支持更多中断，减少中断延迟。

在 aarch64 架构下，中断控制器被称为 GIC (Generic Interrupt Controller)，目前有 v1 ~ v4 这四个版本。当前 StratoVirt 只支持 GICv3 版。同样的，aarch64 也支持 MSI/MSI-x 中断方式。

INTx 中断机制会在一些传统的老旧设备上使用。但实际上，在 PCIe 总线中，很多设备已经很少使用，甚至直接将该功能禁止了。所以，StratoVirt 当前也不支持 INTx 中断机制。

## 创建中断芯片

由于中断控制器在 KVM 中模拟的性能更高，因此 StratoVirt 将中断芯片的具体创建过程和中断投递过程交给了 KVM。在 StratoVirt 启动虚拟机之前，会具现化 x86\_64 或 aarch64 的虚拟主板，即调用 `realize()` 函数，完成初始化。在这个阶段，就创建了中断控制器。其初始化代码如下。

```
fn realize(
        vm: &Arc<Mutex<Self>>,
        vm_config: &mut VmConfig,
        is_migrate: bool,
    ) -> MachineResult<()> {
      ...
      locked_vm.init_interrupt_controller(u64::from(vm_config.machine_config.nr_cpus))?;
      ...
    }
```

StratoVirt 提供了 `MachineOps trait`。无论是轻量化主板或者标准化主板，在 x86\_64 和 aarch64 架构下都分别实现了 `init_interrupt_controller()`，初始化中断控制器函数。

### x86\_64 架构

上述调用了初始化中断控制器函数，在其内部的执行过程中，主要作用是调用 `create_irq_chip()` 函数，后者在 vm\_fd 上调用 `ioctl(self, KVM_CREATE_IRQCHIP())` 系统调用，告诉内核需要在 KVM 模拟中断控制器。后续该系统调用进入了 KVM 模块，会同时创建 PIC 和 APIC 中断芯片，并生成默认的中断路由表。

```
fn init_interrupt_controller(&mut self, _vcpu_count: u64) -> MachineResult<()> {
  ...
     KVM_FDS
            .load()
            .vm_fd
            .as_ref()
            .unwrap()
            .create_irq_chip()
            .chain_err(|| MachineErrorKind::CrtIrqchipErr)?;
     ...
}
```

### aarch64 架构

GIC 中断控制器由四个组件组成：Distributor，CPU Interface-，Redistributor，ITS。与 x86\_64 类似，也需要在 KVM 创建中断控制器。但是不同的是，在创建过程中，需要提前告诉 KVM 模块，GIC 组件在虚拟机内存布局的地址范围。通过 dist\_range，redist\_region\_ranges，its\_range 三个变量，向 KVM 传递了组件的内存地址。除此之外，内部仍然使用 vm\_fd，通过系统调用创建了 vGIC v3 和 vGIC ITS 中断设备。

```
fn init_interrupt_controller(&mut self, vcpu_count: u64) -> Result<()> {
    ...
    let intc_conf = InterruptControllerConfig {
            version: kvm_bindings::kvm_device_type_KVM_DEV_TYPE_ARM_VGIC_V3,
            vcpu_count,
            max_irq: 192,
            msi: true,
            dist_range: MEM_LAYOUT[LayoutEntryType::GicDist as usize],
            redist_region_ranges: vec![
                MEM_LAYOUT[LayoutEntryType::GicRedist as usize],
                MEM_LAYOUT[LayoutEntryType::HighGicRedist as usize],
            ],
            its_range: Some(MEM_LAYOUT[LayoutEntryType::GicIts as usize]),
        };
        let irq_chip = InterruptController::new(&intc_conf)?;
        self.irq_chip = Some(Arc::new(irq_chip));
        self.irq_chip.as_ref().unwrap().realize()?;
        ...
}
```

## 创建 MSI-x

在设计 StratoVirt 的 Virtio PCI 设备，使用 MSI-x 中断方式通知虚拟机。因此，使用 MSI-x 设备前，需要在 Vitio PCI 设备具现化过程中调用 `init_msix()`，进行相关的初始化。该函数的主要功能是在 PCI 设备的配置空间协商 MSI 相关信息。另外，具现化阶段提供了 `assign_interrupt_cb()` 函数，用来封装设备的中断回调函数。在 Virtio PCI 设备处理完 I/O 请求后，会调用中断回调，向 KVM 发送中断通知。

```
fn realize(mut self) -> PciResult<()> {
  ...
    init_msix(
            VIRTIO_PCI_MSIX_BAR_IDX as usize,
            nvectors as u32,
            &mut self.config,
            self.dev_id.clone(),
        )?;
        self.assign_interrupt_cb();
        ...
}
```

## 管理中断路由表

上文提到，在 KVM 创建中断芯片时，会生成默认的中断路由表。但是某些设备（例如直通设备），需要向 KVM 添加额外的全局中断号，这时需要 StratoVirt 额外维护一份中断路由表，并向 KVM 同步。

在 StratoVirt 初始化中断控制器时，会创建中断路由表。内部统一调用 `init_irq_route_table()` 函数，但是架构不同，默认的中断路由表信息也不同。

除了可以生成默认的中断路由表，还需要向 KVM 同步。`commit_irq_routing()` 函数提供了该功能，内部使用 vm\_fd 的系统调用 `ioctl_with_ref(self, KVM_SET_GSI_ROUTING(), irq_routing)`，该系统调用将覆盖 KVM 模块内的中断路由表信息。

```
fn init_interrupt_controller(&mut self, vcpu_count: u64) -> Result<()> {
     ...
     KVM_FDS
            .load()
            .irq_route_table
            .lock()
            .unwrap()
            .init_irq_route_table();
        KVM_FDS
            .load()
            .commit_irq_routing()
            .chain_err(|| "Failed to commit irq routing for arm gic")?;
     ...
}
```

当设备需要动态申请或释放全局中断号时，StratoVirt 提供了两个函数 `add_msi_route()`，`update_msi_route()`，用于增加或修改中断路由表信息。

## 中断流程

对于模拟 virtio 设备，虚拟机通过触发 VM Exit 退出到 KVM。因为 StratoVirt 在起始阶段绑定了 I/O 地址空间与 ioeventfd，并向 KVM 注册了这些信息。所以 guest OS 通知设备处理 I/O 的流程会从 KVM 直接返回到 StratoVirt 循环。接着由 StratoVirt 分发和处理 I/O 操作。当完成 I/O 请求或其他事件后，需要再次通知虚拟机继续往下执行，就通过注入中断的方式让虚拟机得到事件通知。

StratoVirt 同时支持两种架构：microVM 和 standardVM，两种架构下使用的中断方式稍有不同。在 microVM 架构下，将一个 evenetfd 与一个全局中断号关联，并向 KVM 注册对应关系。当需要发送中断时，StratoVirt 只需要向设备对应的 eventfd 发送信号，就会导致对应的中断被 KVM 模块注入到虚拟机。在 standardVM 架构，使用 `msix notify()` 发起中断。经过一系列的函数调用，最后在 vm\_fd 上调用 `ioctl_with_ref(self, KVM_SIGNAL_MSI(), &msi)`，向 KVM 发起中断通知，最终由 KVM 模块完成虚拟机的中断注入。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYnTJ1A5licn0TxiaiaibcoRqls37nBTQAgIC8XUiaYFLENZYYmatVQTMFiaqeuK4TqkJ3NjAicT8b4lIic6Q/640?wx_fmt=jpeg)

### 轻量化机型

在 virtio 设备激活阶段，将中断回调函数 `interrupt_cb`，作为 `activate()` 函数的入参传入，保存在设备对应的 IO handler 中。当需要发送中断时，会调用该中断回调函数。`activate()` 函数声明如下：

```
fn activate(
        &mut self,
        mem_space: Arc<AddressSpace>,
        interrupt_cb: Arc<VirtioInterrupt>,
        queues: &[Arc<Mutex<Queue>>],
        queue_evts: Vec<EventFd>,
    ) -> Result<()>;
```

轻量机型架构下的设备使用 Virtio MMIO 协议，处理完 I/O 请求后，会调用中断回调函数，发送中断。中断回调函数具体内容如下：

```
let cb = Arc::new(Box::new(
            move |int_type: &VirtioInterruptType, _queue: Option<&Queue>| {
                let status = match int_type {
                    VirtioInterruptType::Config => VIRTIO_MMIO_INT_CONFIG,
                    VirtioInterruptType::Vring => VIRTIO_MMIO_INT_VRING,
                };
                interrupt_status.fetch_or(status as u32, Ordering::SeqCst);
                interrupt_evt
                    .write(1)
                    .chain_err(|| ErrorKind::EventFdWrite)?;

                Ok(())
            },
        ) as VirtioInterrupt);
```

在上面我们提到该 eventfd 和中断号信息已经告诉了 KVM。中断回调通过向 interrupt\_evt 写 1，KVM 就可以 poll 到相应事件，接着找到 eventfd 对应的全局中断号，注入到虚拟机中。

### 标准机型

与轻量机型不同，标准机型架构下实现的设备使用 Virtio PCI 协议。因此，中断方式也改为了 MSI-x。与上面相同是，设备在激活阶段，都会保存中断回调函数。标准机型对应的中断回调函数如下：

```
let cb = Arc::new(Box::new(
            move |int_type: &VirtioInterruptType, queue: Option<&Queue>| {
                let vector = match int_type {
                    VirtioInterruptType::Config => cloned_common_cfg
                        .lock()
                        .unwrap()
                        .msix_config
                        .load(Ordering::SeqCst),
                    VirtioInterruptType::Vring => {
                        queue.map_or(0, |q| q.vring.get_queue_config().vector)
                    }
                };

                if let Some(msix) = &cloned_msix {
                    msix.lock().unwrap().notify(vector, dev_id);
                } else {
                    bail!("Failed to send interrupt, msix does not exist");
                }
                Ok(())
            },
        ) as VirtioInterrupt);
```

在中断回调函数中，获取中断向量号 vector，然后使用 `notify()` 函数把中断信息发送给 KVM。内部首先使用 `get_message()` 填充 MSI message 结构的 address 和 data 成员。接着向 KVM 发送封装好的 message。最后在内核 KVM 模块，根据中断路由表项，向虚拟机注入对应的中断。

## 关注我们

StratoVirt 已经在 openEuler 社区开源。后续将开展一系列主题分享，如果您对 StratoVirt 的使用、实现感兴趣，欢迎您围观和加入。

> 项目地址
> 
> https://gitee.com/openeuler/stratovirt

> 项目 wiki
> 
> https://gitee.com/openeuler/stratovirt/wikis

> 邮件列表
> 
> https://mailweb.openeuler.org/postorius/lists/virt.openeuler.org/

> 提交 issue
> 
> https://gitee.com/openeuler/stratovirt/issues

> 安装指导
> 
> https://www.openeuler.org/zh/other/projects/stratovirt/

## 入群

如果您对虚拟化技术感兴趣，欢迎加入 Virt SIG 技术交流群，讨论 StratoVirt、KVM、QEMU 和 Libvirt 等虚拟化相关技术。您可以添加如下微信小助手，回复 StratoVirt 入群。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYnTJ1A5licn0TxiaiaibcoRqlsfpPXCFUibVtMBWZV2vs8QeDcMia6BAVpPlpX75HBkZU9TtE1SjdZcy6Q/640?wx_fmt=jpeg)
