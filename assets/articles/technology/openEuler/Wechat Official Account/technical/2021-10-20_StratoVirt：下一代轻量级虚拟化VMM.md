# [StratoVirt：下一代轻量级虚拟化VMM](https://mp.weixin.qq.com/s/ttJwPcFalbzQeWyrHyNB3g)

[OpenAtom openEuler](javascript:void%280%29;)*2021-10-20 22:25:21*

## StratoVirt 是什么

Strato，取自 stratosphere，意指地球大气层中的平流层，大气层可以保护地球不受外界环境侵害，而平流层则是大气层中最稳定的一层；类似的，虚拟化技术是操作系统平台之上的隔离层，既能保护操作系统平台不受上层恶意应用的破坏，又能为正常应用提供稳定可靠的运行环境；以 Strato 入名，寓意为保护 openEuler 平台上业务平稳运行的轻薄保护层。同时，Strato 也承载了项目的愿景与未来：轻量、灵活、 安全和完整的保护能力。

StratoVirt 是计算产业中面向云数据中心的企业级虚拟化VMM，实现了一套架构统一支持虚拟机、容器、Serverless 三种场景，在轻量低噪、软硬协同、安全等方面具备关键技术竞争优势。StratoVirt 在架构设计和接口上预留了组件化拼装的能力和接口，StratoVirt 可以按需灵活组装高级特性直至演化到支持标准虚拟化，在特性需求、应用场景和轻快灵巧之间找到最佳的平衡点。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZxlbb2AJPmXTBDd9nesAZsPT30DINSDqwLmaAKjKcaBL6qxoIQDkAXmgzLWH6r3svSOjLn00LFBg/640?wx_fmt=png)

## 为什么选择 Rust

在项目成立初期，我们调研了业界成熟基于 C 语言开发的虚拟化软件-QEMU，统计了在过去十几年中 QEMU 的 CVE 问题，发现其中有将近一半是因为内存问题导致的，例如缓冲区溢出、内存非法访问等等。如何有效避免产生内存问题，成为我们在编程语言选型方面的重要考虑。因此，专注于安全的 Rust 语言进入我们视线。

- Rust 语言拥有强大的类型系统、所有权系统、借用和生命周期等机制，不仅保证内存安全，还保证并发安全，极大的提升软件的质量。在支持安全性的同时，具有零成本抽象特点，既提升代码的可读性，又不影响代码的运行时性能。
- Rust 语言拥有强大的软件包管理器和项目管理工具-Cargo 
  
  - Cargo 能够对项目的依赖包进行方便、统一和灵活的管理。项目所有的依赖包都定义在 Cargo.toml 文件中，开发者可以按需使用来自 Rust 官方仓库 crates.io 的各类功能包。

<!--THE END-->

- - Cargo 集成了完整的代码管理工具，例如项目创建（cargo new）、构建（cargo build）、清理（cargo clean）、测试（cargo test）、运行（cargo Run）等等。
  - Cargo 在代码静态扫描方面提供相应的工具，能够进一步提升开发者编码风格和代码质量。
  - cargo fmt：使用符合 rust-lang 定义的 Rust 代码风格来规范 Rust 代码。
  - cargo check：可以对本地项目库和所有依赖进行编译检查，它会通过对项目进行编译来执行代码检查。
  - cargo clippy：一个 Rust 语言的 lint 工具集合包，包含了超过 350 种 lint 规则。

## StratoVirt 的优势

StratoVirt 是 openEuler 最稳定、最坚固的保护层。它重构了 openEuler 虚拟化底座，具有以下六大技术特点。

- 强安全性与隔离性
  
  - 采用内存安全语言 Rust 编写，保证语言级安全性；
  - 基于硬件辅助虚拟化实现安全多租户隔离，并通过 seccomp 进一步约束非必要的系统调用，减小系统攻击面；
- 轻量低噪
  
  - 轻量化场景下冷启动时间&lt;50ms，内存底噪&lt;4M；
- 高速稳定的 IO 能力
  
  - 具有精简的设备模型，并提供了稳定高速的 IO 能力；
- 资源伸缩
  
  - 具有 ms 级别的设备伸缩时延，为轻量化负载提供灵活的资源伸缩能力；
- 全场景支持
  
  - 完美支持 X86 和 Arm 平台：X86 支持 VT，鲲鹏支持 Kunpeng-V，实现多体系硬件加速；
  - 可完美集成于容器生态，与 Kubernetes 生态完美对接，在虚拟机、容器和 serverless 场景有广阔的应用空间；
- 扩展性
  
  - 架构设计完备，各个组件可灵活地配置和拆分；
  - 设备模型可扩展，可扩展 PCIe 等复杂设备规范，实现标准虚拟机演进；

## StratoVirt 的架构

StratoVirt 核心架构自顶向下分为三层：

- 外部 API: StratoVirt 使用 QMP 协议与外部系统通信，兼容 OCI，同时支持对接 libvirt。
- BootLoader: 轻量化场景下使用简单的 BootLoader 加载内核镜像，而不像传统的繁琐的 BIOS 和 Grub 引导方式，实现快速启动；标准虚拟化场景下，支持 UEFI 启动。
- 模拟主板:
  
  - microvm：为了提高性能和减少攻击面，StratoVirt 最小化了用户态设备的模拟。模拟实现了 KVM 仿真设备和半虚拟化设备，如 GIC、串行、RTC 和 virtio-mmio 设备。
  - 标准机型：提供 ACPI 表实现 UEFI 启动，支持添加 virtio-pci 以及 VFIO 直通设备等，极大提高虚拟机的 I/O 性能。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZxlbb2AJPmXTBDd9nesAZsM68Dibnrzj0fToFOlYhLQSO0lt5SBdS1u7kHzzm2ibicXdxnVl86NV2oQ/640?wx_fmt=png)

StratoVirt源码目录解析主要分为四部分：

- acpi：提供构建 ACPI 表的接口。
- address\_space：地址空间模拟，实现地址堆叠等复杂地址分配模式。
- boot\_loader：内核引导程序，实现快速加载和启动功能。
- cpu：模拟多架构下的 vcpu。
- devices：模拟中断控制器、串口等一系列主板的基础设备。
- hypervisor：提供与内核 hypervisor 如 KVM 交互的 API 接口。
- machine：模拟 microvm 以及标准 VM 机型。
- machine\_manager：提供虚拟机管理接口，兼容 QMP 等常用协议，可扩展。
- migration：提供用于热恢复的相关 API 接口。
- migration\_derive：提供用于热恢复特性的过程宏实现。
- ozone：提供了轻量虚拟化场景下的安全管理框架。
- pci：实现了遵循 PCIe/PCI 协议规范的设备访问和模拟。
- sysbus：模拟系统总线，所有非 PCI 类设备都挂在系统总线上。
- util：提供一些通用接口的实现。
- vfio：提供 VFIO 设备直通功能。
- virtio：遵循 virtio 协议，支持 virtio-mmio 以及 virtio-pci 设备。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZxlbb2AJPmXTBDd9nesAZsVZ3jicLUugFXHmkyF0OVnnlJM2ibXWjlWeDpvBsOSicE5dEh9QKhbFlWA/640?wx_fmt=png)

当前 StratoVirt 实现了两种机型：microvm 和标准机型。其中，microvm 实现了运行业务负载的最小的设备集合。因此 LightMachine 是 StratoVirt 最重要的顶层数据结构，它的逻辑上分为 CPU 模拟管理，地址空间管理，IO 设备模拟管理（包括中断控制器和 bus 数据结构中管理各类仿真设备，例如 virtio 设备，serial 设备等），如下图右侧所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZxlbb2AJPmXTBDd9nesAZsFG2hKcBAVWGLhzbC1tGicjlFMkF2icOtxmNMib83wvROa8kFb4p54wvvQ/640?wx_fmt=png)

x86\_64 和 aarch64 下的标准机型分别为 q35 和 virt，可以通过 libvirt 来进行生命周期等标准虚拟机管理。标准机型的系统总线下拥有 PCIe 主桥，下面可以挂接 virtio-pci 设备，支持 VFIO 设备直通。此外，标准机型支持构建 ACPI 表，不仅可以提供 UEFI 的标准启动能力，还可以在未来提供设备热插拔、虚拟机更完善的生命周期管理能力。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZxlbb2AJPmXTBDd9nesAZsI9BV6KeNnibhWlwkM1wS6HkSkokF28sC6YhxaGIcaRf4WW8saO5Tf8w/640?wx_fmt=png)

首先，我们先看一下 address\_space 地址空间模拟实现功能：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZxlbb2AJPmXTBDd9nesAZscTd3Ivy71Qv669RORXzzWYPDGZicHPoVTnnCmVKKD7d8zpBGKbSOkUw/640?wx_fmt=png)

- 内存地址空间通过 Region 组成树形层次关系，支持地址堆叠和优化级。
- 通过快速映射算法形成扁平地址空间（Flat View)。
- 通过设置 Listener 监听地址空间变化，执行相关回调函数。

其次，我们再看一下 CPU 模拟实现功能：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZxlbb2AJPmXTBDd9nesAZs5ZcITFcAOVXtY8SuoSf4BNLWSWI3wRsjpz0fiaC8Snj2LN6UuiaibWM3Q/640?wx_fmt=png)

- 基于 KVM 暴露接口实现虚拟 CPU 的硬件加速。
- 通过 ArchCPU 结构隐藏体系架构（aarch64 和 x86\_64）差异，具体实现位于体系架构相关目录中。
- Arc 反向索引该 CPU 所属的 LightMachine 虚拟机对象，使得后续在虚拟机内扩展设备时，CPU 可访问该对象。

最后，我们再看一下 IO 设备模拟功能：

轻量化虚拟机的主要设备均通过 VirtioMMIO 协议实现，统一通过 VirtioMmioDevice 数据结构来模拟。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZxlbb2AJPmXTBDd9nesAZs18ftF4ZCAxRNZzCwM2iaibMOkiaDVzrJ9jdEhkWh1GcsdpnBAG6phd24w/640?wx_fmt=png)

在 IO 设备初始化阶段，通过 VirtioMMIO 协议协商前后端都可以访问的 virtio queue、中断事件以及通知事件等等。当前端 VM 有 IO 请求时，将请求数据写入 virtio queue 中，通过通知事件告知后端 StratoVirt；后端监听通知事件发生时，读取 virtio queue 中的请求数据，根据请求数据进行 IO 处理，IO 请求处理完成后，并以中断事件方式通知前端 VM。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZxlbb2AJPmXTBDd9nesAZsLDicIuvBZ3vX2xCUIBu8YR80E7w4brEUqH70zhQTiaUr3YY2O7VUZvBQ/640?wx_fmt=png)

virtio 设备同样也支持挂到 PCI 总线上，因此在拥有 PCIe 主桥的标准机型下支持为虚拟机添加 virtio-pci 设备。virtio-pci 设备同样遵循上图的 I/O 下发流程，只是传输层协议从 mmio 变成了 PCI。

## StratoVirt 未来

StratoVirt 的发展路标为，通过一套代码架构分别提供轻量以及标准机型，支持 serverless、安全容器、标准虚机等多种应用场景：

- 轻量虚拟机模式下，单虚机内存底噪小于 4MB，启动时间小于 50ms，且支持 ms 级时延的设备极速伸缩能力，当前已经开发完毕，2020 年 9 月已经在 openEuler 社区开源；
- 标准虚拟机模式下，可支持完整的机器模型，启动标准内核镜像，可以达成 Qemu 的能力，同时在代码规模和安全性上有较大优势。

## 关注我们

StratoVirt 当前已经在 openEuler 社区（openEuler 是一个开源、免费的 Linux 发行版平台，将通过开放的社区形式与全球的开发者共同构建一个开放、多元和架构包容的软件生态体系）开源。在未来的一段时间我们将开展一系列主题的分享，让大家更加详细的了解 StratoVirt 的实现，非常期待您的围观和加入！

项目地址：https://gitee.com/openeuler/stratovirt

项目 wiki：https://gitee.com/openeuler/stratovirt/wikis

项目交流：virt 邮件列表 或提交一个 issue。

virt 邮件列表：https://mailweb.openeuler.org/postorius/lists/virt.openeuler.org/  
提交 issue：https://gitee.com/openeuler/stratovirt/issues

## 入群

如果您对虚拟化技术感兴趣，点击阅读原文即可可以进入 openEuler StratoVirt 主页查找相关资源，包括安装指导、虚拟机配置、代码仓库、学习资料等。也欢迎加入Virt SIG 技术交流群，讨论 StratoVirt、KVM、QEMU 和 Libvirt 等相关虚拟化技术。感兴趣的同学可以添加如下微信小助手，回复 StratoVirt 入群。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZxlbb2AJPmXTBDd9nesAZsnnlHwC5mmoiay0FtbOUCqP2icRlox2VezyQfjILA9VHMrCicxzY7LF8CQ/640?wx_fmt=jpeg)

[阅读原文](https://www.openeuler.org/zh/other/projects/stratovirt/)
