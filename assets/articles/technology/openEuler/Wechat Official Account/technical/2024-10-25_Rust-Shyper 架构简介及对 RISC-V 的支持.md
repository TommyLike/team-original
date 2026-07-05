# [Rust-Shyper 架构简介及对 RISC-V 的支持](https://mp.weixin.qq.com/s/OWF-qoKFRVf7qT-_XiUEIQ)

[OpenAtom openEuler](javascript:void%280%29;)*2024-10-25 20:02:00广东*

**背景**

在现代嵌入式应用场景中，嵌入式系统正进行着向通用系统和混合关键系统的方向发展的演变。越来越多的功能被集成，这些任务往往有着不同的可靠性、实时性的要求，同时又有着将不同关键任务进行相互隔离的需求。一个典型的例子是车载系统必须确保那些影响汽车安全行驶的组件，不会受到车载娱乐系统崩溃的影响，而这两者也有着不同的要求与验证等级。

近年来，伴随着具有多核处理器架构的嵌入式计算平台的产生与发展，在单一片上系统（SoC）上部署多个复杂任务成为可能。但受限于多核处理器硬件设计的特殊性，传统操作系统很难做到在将多任务进行隔离的前提下，还能充分利用片上系统多核优势的要求。

同时考虑到嵌入式应用领域需求的多样性，单一的软件系统可能很难进行多场景下的需求适配。一种可行的解决方案是，由不同的操作系统各自负责其擅长的领域，并执行相应的关键任务，而由一个虚拟机监控程序来对这些客户操作系统（Guest OS）进行监管。

虚拟化技术给这种技术设计提供了便利。使用硬件平台提供的虚拟化技术（如 x86 的（非）根模式 \[(Non-)Root Mode] 与 VMX 指令集），可以做到为不同的 Guest OS 分配不同的虚拟设备资源（如 CPU 与内存等），它们与实际物理设备构成映射关系，但彼此之间相互隔离。

此项目面向支持 H 拓展的 64 位 RISC-V 指令集平台，基于 Rust 语言实现了一个 Type-1 型虚拟机监控平台，其具备运行并管理多个相互隔离的 Guest OS 的能力。

**Rust-Shyper (RISC-V) 框架设计**

此项目从 Rust-Shyper (Armv8) 移植，并针对 RISC-V 所支持的虚拟化拓展指令进行特化。项目还包含了管理虚拟机（MVM）中用户态的 CLI 工具、用户态守护进程（Daemon）以及内核模块，整体框架如下图所示。

Rust-Shyper 提供了下列功能：

- 对系统所有关键资源和状态进行统一管理和隔离
- 提供一套完整的核间通信机制
- 提供多种设备模拟策略，能够为 VM 提供虚拟磁盘、虚拟网卡等 Virt I/O 模拟设备
- 为 VM 模拟 SBI 接口，使之能够使用原有 M 模式下的底层接口

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mB187r74iag8VvxiccSOicF4hNP4GdcHnLOkCd64hIbicfGAJfukgJxOX4lWia79u9Ysv58fTtKticiaPfTA/640?wx_fmt=png&from=appmsg)

**设备模拟与 Virt I/O 虚拟化**

Rust-Shyper 提供的设备模拟策略包括全直通、全模拟、半模拟三种：全直通的物理设备由某个虚拟机独占，全模拟由 Rust-Shyper 捕获并模拟对设备的一切操作，半模拟由 Rust-Shyper 捕获设备操作，并借助物理设备进行访问行为的模拟。

对于被模拟的设备，客户机按照传输协议，读写设备的特定地址，此时会触发客户页缺失异常（Load / Store guest-page fault），Rust-Shyper 捕获并解析这些异常，并根据设备种类进行不同方式的设备模拟，流程如下图所示。

Rust-Shyper 中的半模拟设备以磁盘模拟为例，为了充分利用 Linux 中较为成熟的原生驱动，并提高 Rust-Shyper 的性能与可移植性，Rust-Shyper 可以将 GVM 中的 IO 请求转发给 MVM 中的内核模块，并利用 MVM 中的原生驱动完成设备的读写。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mB187r74iag8VvxiccSOicF4hNpelc8c6PjtxsyD1tbwm3NbMjM2bAGBibcjjIJpfwcwDIbdibqcKsHQzA/640?wx_fmt=png&from=appmsg)

Rust-Shyper 同时实现了一个虚拟交换机，客户操作系统所装载的 virtio-net 虚拟网卡将连接到 Rust-Shyper 中的虚拟交换机，后者将按照规则将网络包转发到物理网卡中。

对于模拟设备，我们会为 VM 创建模拟设备的设备树项目，使其能够感知到模拟设备的存在。

**AIA 拓展与 APLIC 模拟**

在不使用 AIA 拓展时，RISC-V 的中断分发需要设置在发生中断时陷入到 Rust-Shyper 中，从 PLIC 中获取外部中断号，然后将中断分发给对应虚拟机，下图黑色实线展示了外部中断发生时的一般流程。但频繁的 VM-Exit 会带来一定的性能问题，尤其是应对 PCI 高速设备的中断时。

在引入 AIA 拓展后，可以由 APLIC 以写 Interrupt File 的形式向对应的特权级或者 VM 注入中断，直通设备的中断可以直达 VM 而无需陷入 Rust-Shyper，由此提高了 VM 的中断处理性能。如下图彩色实线所示。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mB187r74iag8VvxiccSOicF4hN2Wib5NkUNCRrARMhOoZfIgMiam7SacK4GRYoYHY3WtLPQhKCgnmSS4bQ/640?wx_fmt=png&from=appmsg)

此外，除了 APLIC 可以往 Interrupt File 中直接注入中断外，未来的实现会允许 PCI 设备通过 MSI 信号直接注入中断，避免其陷入 Hypervisor。

> \[!NOTE] Rust-Shyper 对 Sstc 与 Svnapot 拓展的支持 RISC-V Sstc 拓展提供了 VS 模式下的计时器，使得 GVM 不需要陷入更高特权级或者进行 SBI 调用也可以设置计时器并产生中断；Svnapot 拓展使得页表可以支持高达 64 KiB 的页面，从而降低高内存负载下 TLB 的压力。Rust-Shyper 已经实现了对这两个拓展的支持，但尚未进行完备的测试。

**Rust-Shyper 使用指南**

从仓库 ^1 中下载源码后，安装下列软件依赖：

- Rust Nightly
- riscv64-linux-gnu-gcc 交叉编译工具链
- cargo-binutils (Optional)
- qemu-system-riscv64 &gt;= 8.2.0

然后进入 cli 目录编译用户态运行的 Rust-Shyper CLI，并从 tools 目录中获取编译好的内核模块。它们均需要打包进 MVM 的镜像中。

### **MVM 的配置**

MVM 是用于对其他虚拟机进行管理的管理 VM，运行 Linux，可以通过内核模块和用户态命令行工具（CLI）与 Rust-Shyper 通信，以此完成管理 VM 的任务。

仓库中提供了 5.15 版本内核的镜像：image/Image\_5.15.100-riscv-starfive，具有较为完整的功能（开启了大部分常用的内核选项）和兼容性。

可以Ubuntu base image为基础，构建本项目使用的 Linux rootfs，或者可以使用已经配置好的镜像 \[^2]。该镜像的用户名与密码均为 root.

> \[!NOTE] 关于 Ubuntu 对 RISC-V 的支持与镜像构建 要了解更多关于 Ubuntu 对 RISC-V 的支持，参见 https://ubuntu.com/download/risc-v；Ubuntu base image 是一个很小的 Linux rootfs，支持 apt 安装程序，并自带基本的 gnu 命令行工具，可供用户从零构建包含完整软件包 rootfs，可参见 Ubuntu Base官方。

对 MVM 的配置详见仓库 src/config/qemu\_riscv64\_def.rs，该文件配置了 MVM 的模拟设备、直通设备、中间物理内存（IPA）起始地址与大小、内核启动参数、内核加载地址、CPU 数目等等。这部分并非完全固定，可以根据自己的需求在一定范围内做动态的更改。

### **Rust-Shyper 的启动**

使用下列命令编译并连接 RISC-V 版本的 Rust-Shyper：

```
ARCH=riscv64 make
```

使用下列命令运行：

```
ARCH=riscv64 make run
```

**GVM 的启动与配置**

**Step.1 安装内核模块**

```
insmod shyper_riscv64.ko
```

#### **Step.2 启动 Rust-Shyper 守护进程**

```
chmod +x shyper./shyper system daemon [mediated-cfg.json] &
```

mediated-cfg.json（本目录下存在的 shypercli-config.json 就是一个参考）用于配置其他 Guest VM 的 Virt I/O 中介磁盘，示例如下：

```
{    "mediated": [        "/root/vm0_ubuntu.img", // 此处配置第1个GVM的中介磁盘        "/root/vm0_ubuntu_2.img", // 此处配置第2个VM的中介磁盘        "/root/vm0_busybox.img" // 此处配置第3个VM的中介磁盘    ]}
```

其中列表每一项既可以写分区名（如 /dev/sda1），又可以写磁盘镜像名。

#### **Step.3 通过配置文件来配置GVM**

```
./shyper vm config <vm-config.json>
```

本目录下（./vm1\_config\_riscv.json）提供了配置文件的示例（链接中的 Step 3）。

#### **Step.4 启动客户虚拟机**

```
./shyper vm boot <VMID>
```

按照启动的顺序排序。MVM 的 VMID 为 0，第一个启动的 GVM 的 VMID 为 1，可以通过./shyper vm list 查看当前配置的各个VM的信息。

#### Step.5 与客户虚拟机交互

首先从外部连接到 MVM：

```
ssh root@localhost -p 5555
```

然后通过 minicom 连接 hvc1，监控 GVM 的串口输出：

```
minicom -D /dev/hvc1 -b 115200
```

这样便可以与 GVM 交互了：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mB187r74iag8VvxiccSOicF4hNu4HlEUEUSGlUSjbR8f3ZsgKbLcLLaoZuAcicVbiaic7ek4Ic1icpg53teg/640?wx_fmt=png&from=appmsg)

本项目镜像中带有的GVM镜像 vm0\_ubuntu.img，其用户名为 root，密码为 vm1.

### **通过 AIA 启动 Rust-Shyper**

需要将 qemu-system-riscv64 升级到 9.0.2，并使用支持 AIA 的内核版本（如 6.10）。并使用配置好的支持 AIA 启动的镜像 \[^3]。

使用如下命令编译使用 AIA 的 RISC-V 版本的 Rust-Shyper：

```
ARCH=riscv64 IRQ=aia AIA_GUESTS=3 make
```

```

```

并使用如下命令运行：

```
ARCH=riscv64 IRQ=aia AIA_GUESTS=3 make run
```

```

```

> IRQ=\[plic|aia]：选择中断的方式，当没有输入该参数时，默认是plic AIA\_GUESTS=nnn：需要为每个 HART 模拟的 interrupt file 的数量，也是将要运行 VM 的数量，当没有输入该参数时，默认是 3

#### **启动GVM时的配置**

镜像中提供的配置示例（./vm1\_config\_riscv\_aia.json），相较于 PLIC，需要将模拟中断的设备替换为APLIC：

```
{  "name": "aplic@d000000",  "base_ipa": "0xd000000",  "length": "0x8000",  "cfg_num": 2,  "cfg_list": [    0,    0  ],  "type": "EMU_DEVICE_T_APLIC"},
```

#### VM 多核启动时，关于 IMSIC 的地址映射

由于在多核启动时，会向不同的 Hart 中写 IPI 中断号，但由于 GuestOS 不认为自己处于虚拟化模式下，会访问每个 Hart 的 S-mode 的 Interrupt File，所以需要建立地址映射，以便可以找到正确的 Guest Interrupt File.

若当前hart的分配情况为：

- MVM：Hart0
- GVM：Hart1、2、3
- GVM：Hart2、3

由于 MVM 是单核启动，所以无需建立地址映射。GVM1 应建立以下映射：

> 由于使用的是 Hart1、2、3，其正确的 Guest Interrupt File 地址应为0x28006000、0x2800a000、0x2800e000，但 VM 会认为自己的所用的是 Hart0、1、2，他会访问的地址是 0x28000000、0x28004000、0x28008000，所以应建立以下映射关系，VM 才会正确访问到对应的 Interrupt File

```
"passthrough_device": {  "passthrough_device_list": [    {      "base_ipa": "0x28000000",      "base_pa": "0x28006000",      "length": "0x1000"    },    {      "base_ipa": "0x28004000",      "base_pa": "0x2800a000",      "length": "0x1000"    },    {      "base_ipa": "0x28008000",      "base_pa": "0x2800e000",      "length": "0x1000"    }  ]},
```

相应的，GVM2 应该映射如下：

```
"passthrough_device": {  "passthrough_device_list": [    {      "base_ipa": "0x28000000",      "base_pa": "0x28006000",      "length": "0x1000"    },    {      "base_ipa": "0x28004000",      "base_pa": "0x2800a000",      "length": "0x1000"    },    {      "base_ipa": "0x28008000",      "base_pa": "0x2800e000",      "length": "0x1000"    }  ]},
```

**参考资料**

\[1]: 开源仓库：https://gitee.com/openeuler/rust\_shyper

\[2]: 基于 Ubuntu base image 构建好的镜像：https://bhpan.buaa.edu.cn/link/AAF36D01FF739449A19B7D28CC5639F555，提取码 \`2Axz\`

\[3]: 通过 AIA 启动的以构建好的 rootfs 镜像：https://pan.baidu.com/s/1UXlWRf0WFmFndFUj2-bUpQ?pwd=skst，提取码 \`skst\`

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAno1DICY3yCcCzZFc7qpstZat9nNMibDqpQeUNcJIL0MAQ4CIbssFmiaIpo0tLHl7xgEuoCdoPTZqA/640?wx_fmt=png&from=appmsg)
