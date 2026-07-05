# [「转」RustVMM 官方支持 RISC-V](https://mp.weixin.qq.com/s/uPwKNNFQWmHRk7fwuQVR_Q)

*OERV 宣传小队*[OpenAtom openEuler](javascript:void%280%29;)*2024-11-29 20:04:05上海*

2024 年 10 月，经过长达 6 个月的门禁方案研究和核心代码开发，历经 90 个 commit 和 107490 行代码改动，RustVMM 核心库正式实现了对 RISC-V 架构的完整支持。**OpenAtom openEuler（简称"openEuler"）RISC-V SIG 虚拟化小组为 RustVMM 核心库的 RISC-V 支持工作付出了巨大努力**。

这一重大技术突破标志着 RustVMM 不仅填补了 RISC-V 虚拟化生态的空白，也为开发者提供了高效、安全、可靠的虚拟化解决方案，同时开启了 RISC-V 在多场景应用中的新篇章。

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFG3NHBVL7yEmtAibCCfw3pguCmf6nMQxUkDboMGvjfWWU3SzwI6HvBNDrm9icT8S1jxCP475iawvWpdQ/640?wx_fmt=png&from=appmsg)

RISC-V SIG 虚拟化小组在 RustVMM 仓库的提交记录

**RustVMM：轻量级虚拟化的引领者**

RustVMM 是用 Rust 编写的一款轻量级虚拟机监控器（VMM），提供了一组直观易用的 API 来创建和管理虚拟机，具有安全、可靠、高效且易于移植等优势。当前，包括 Cloud-Hypervisor、Firecracker、Dragonball 和 StratoVirt 在内的超过 1900 个虚拟化相关代码仓库都使用了 RustVMM，并被广泛使用在阿里云，亚马逊云等云服务提供商的生产环境中。

RustVMM 提供了对 KVM 调用的安全封装以及模块化的组件，使得虚拟机管理程序在实现时可以专注于自身应用场景所需的设计和实现，其轻量且易用的设计尤为适用于超融合、高性能虚拟化和机密计算等场景。

**RustVMM 与 RISC-V：强强联合**

RISC-V 架构广泛应用于嵌入式设备、物联网和高性能计算领域，但其虚拟化生态尚需进一步完善。RustVMM 的轻量化特性恰与 RISC-V 的需求高度契合。此次 RISC-V 支持的实现，不仅为开发者提供了快速部署高效、安全虚拟化的能力，还显著增强了 RISC-V 的生态兼容性。

随着 RustVMM 实现 RISC-V 支持，基于 RustVMM 的虚拟化产品，如 Cloud-Hypervisor、Firecracker、Dragonball 和 StratoVirt，将更易迁移至 RISC-V 平台，从而加速生态系统的发展，并为开发者提供成熟的工具链和虚拟化能力。

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFG2NDwf7hc6p41GlvymPxLfGzQ1jmENmLQiavibGEdIJCmhXbictzibu6icj7HTNdZnCOnicWuibWKTTqLEQ/640?wx_fmt=png&from=appmsg)

基于 RustVMM 的虚拟化软件生态系统

**基础设施攻坚：从 CI 到核心组件**

为了实现 RustVMM 对 RISC-V 的支持，openEuler RISC-V SIG 虚拟化小组首先攻克了基础设施难题，包括支持 RISC-V 架构的 rust-vmm-container 和 rust-vmm-ci 两个关键仓库。2024 年 8 月 27 日，RustVMM RISC-V CI 所使用的异构容器镜像合入上游。2024 年 9 月 2 日，RustVMM RISC-V CI 正式上线，标志着 RISC-V 架构 RustVMM 基础设施支持完毕。随后，两个月内，kvm-bindings、kvm-ioctls、linux-loader 和 vm-memory 等核心组件陆续完成对 RISC-V 的支持，为 RISC-V 上的虚拟化开发奠定了基础。时间如下表：

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFG3NHBVL7yEmtAibCCfw3pguK5KU6YynKyjZgwFJKpqDjvnb0CqwRxicpiaU1bYtgC4dViaBKUbC2gY8A/640?wx_fmt=png&from=appmsg)

四个核心库的重要时间点

**未来展望：推动 RISC-V 虚拟化全面支持**

RustVMM 的 RISC-V 支持得益于社区对架构生态的重视，RISC-V SIG 虚拟化小组为 RustVMM 核心库的 RISC-V 支持工作付出了巨大努力，并积极配合上游社区审查和修改，确保代码被社区接收和发布。经过四个月的虚拟化相关软件门禁实现的调研工作，三版 CI 方案的原型链路搭建和最终的社区 RISC-V CI 落地实现，RISC-V SIG 虚拟化小组组长何若轻于 2024 年 9 月 9 日成为了 RustVMM 基础设施的 Maintainer，并推动该项目向更广阔的应用场景发展。

RustVMM 同时也是 RISE Project 的关注重心，Kernel and Virtualization WG 在跟踪记录 RustVMM 的 RISC-V 支持状态。虚拟化小组于 11 月的工作组例会中同步了工作进展，并获授权在工作组计划里持续更新维护 RustVMM (LK\_03\_014) 项。

未来，RISC-V SIG 虚拟化小组将持续跟进并维护 RustVMM，并将 RISC-V 的架构支持工作扩大至依赖于它的 Cloud-Hypervisor、Dragonball 和 StratoVirt，加速 RISC-V 平台上虚拟化应用的落地与发展，推动 RISC-V 在虚拟化领域的全面支持。此外，基于已经完成的虚拟机管理器，向上使能 Kata-Containers，推动安全容器解决方案在 RISC-V 平台的落地，让 RISC-V 架构可以被用于机密计算场景。RustVMM 作为 openEuler社区的云原生重要基础设施，RISC-V SIG 虚拟化小组将在社区持续维护，分发 RustVMM 以及依赖于 RustVMM 的相关软件包，以推动 openEuler RISC-V 作为相关软件栈的第一验证平台。

RustVMM 的 RISC-V 支持为 RISC-V 虚拟化生态注入了新动能，随着两者的深度融合，开发者将能探索更多创新场景，共同推动开放架构的多元化发展。
