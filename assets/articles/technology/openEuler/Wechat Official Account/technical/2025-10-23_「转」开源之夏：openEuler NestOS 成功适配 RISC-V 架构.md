# [「转」开源之夏：openEuler NestOS 成功适配 RISC-V 架构](https://mp.weixin.qq.com/s/nEyrFKm66xW2ZQcQ6jKmfQ)

*OERV 宣传小队*[OpenAtom openEuler](javascript:void%280%29;)*2025-10-23 20:06:00广东*

**NestOS** **成功适配**

在开源之夏 2025 活动中，常旭海同学与 OERV 团队合作完成了 NestOS 的 RISC-V 架构适配工作，目前系统已可在 OpenAtom openEuler（简称“openEuler”或“开源欧拉”）on RISC-V 平台稳定运行

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/tkVlnC85sFGMuxHSoJtGEbSJpmicLB3f686YdCqW44U2iazCZShJXeP1rl0O7vJHd6TD6zpEn1eGCbLmNH2jzxTQ/640?wx_fmt=jpeg&from=appmsg#imgIndex=0)

**导读**

**内容简介**

本文介绍 NestOS 这一云原生操作系统的 RISC-V 适配工作。我们将从 NestOS 的设计理念讲起，解析 RISC-V 适配的技术意义，详述从调查准备到优化发布的完整适配过程，并分享开发者的实践心得。

**NestOS 简介**

NestOS 是一个基于 openEuler 专为云原生场景设计的现代化、轻量级、安全的容器操作系统。它的设计理念源于这样一种思考：在云原生时代，操作系统作为基础设施，应当是可大规模部署、高度定制化、且便于"嵌入"各种云平台或裸金属的"容器"

NestOS 包含三大新型云原生操作系统的核心特性：

? **ignition** 用于实现操作系统初始化的声明式配置，使得系统部署过程标准化且可重复

? **rpm-ostree** 实现了双根文件系统，便于系统原子化的更新与回滚，避免了传统包管理直接操作当前根文件系统造成的非原子化状态

? **zincati** 用于监听 NestOS 版本变化并自动实现无人监督的系统更新，同时可以定制系统更新的时间策略

这种设计思路类似于近年新兴的 libOS 思想，旨在提供高可定制性的同时，仅需一组声明式配置即可快速批量部署，灵活"嵌入"到目标节点上。但 NestOS 采取了更务实的折衷路线，充分利用了 openEuler 丰富的软件生态，无需走自底向上重建轮子、重新推广生态的漫长道路，而是在成熟的基础上构建现代化的云原生操作系统

**RISC-V 适配的意义**

RISC-V 作为新兴的开放指令集架构，在云原生领域具有独特的优势。其无授权费、开放性和高度可定制性的特点，为云原生应用开辟了新的可能性

NestOS 的核心特性与 RISC-V 生态高度契合。RISC-V 是一个开放的指令集而非统一的芯片设计，这导致其生态充满了来自不同厂商的、形态各异的 SoC，它们的存储布局、启动方式、外设可能千差万别。NestOS 的 Ignition 配置工具恰好是应对这种异构性的利器。企业可以为不同规格的 RISC-V 硬件编写不同的 Ignition 配置文件，当设备首次启动时，Ignition 会自动根据预设配置完成所有底层定制化工作，然后构建一个完全标准化的运行环境。这极大地简化了在多样化的 RISC-V 硬件上进行大规模、自动化部署的流程

此外，NestOS 的轻量级设计与 RISC-V 的能效、成本优势完美互补。NestOS 基本系统仅包含最精简的内核与基础用户态工具，CPU、内存占用极小，确保了宝贵的硬件资源能最大限度地被用于运行实际的业务负载，而不是被冗余的工具和服务消耗掉。这是对 RISC-V 硬件"精打细算"的最好补充，让有限的硬件资源发挥出最大的业务价值

**RISC-V 适配过程**

**适配路线**

**第一阶段：调查与准备**

此阶段的核心是全面解构现有的 x86/ARM 镜像组装流程，识别并列出所有与架构相关的环节和配置，包括上游软件包仓库、包命名约定以及相关的工具链。同时，调研并准备好所有 RISC-V 所需的预编译二进制组件，形成一份清晰的架构差异清单和资源列表，作为后续改造的输入

**第二阶段：移植与构建**

在这个阶段，正式修改代码并引入架构相关的逻辑。组装器能够根据目标架构，动态地选择正确的软件包源、调用适配的引导加载程序安装工具（例如针对 RISC-V EFI 的 GRUB2）并应用相应的配置模板。此阶段的目标是让一套代码具备在 RISC-V 架构下组装可用镜像的能力

**第三阶段：调试与测试**

编译成功不等于能用。将镜像在 QEMU 中进行首次启动，通过串口日志捕捉并修复各种早期启动错误，这是一个反复迭代的过程，直到系统能够稳定进入用户态。在此基础上，验证 NestOS 的核心组件（如 rpm-ostree、Ignition）功能正常，并全面测试网络、存储等基础驱动的可用性，确保系统在模拟环境中达到基本可用的状态

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFGMuxHSoJtGEbSJpmicLB3f6nfXibAZNpTVqiaLWJkgS2BPUdrGbL7abCPBLnbXIGkCIUrGbfqw4FV0g/640?wx_fmt=png&from=appmsg#imgIndex=1)

**第四阶段：优化与发布**

当系统在模拟环境中稳定后，移植到真实的 RISC-V 硬件开发板上进行测试，以确保硬件兼容性并适配特定驱动。同时，进行性能分析和优化，提升系统在 RISC-V 平台上的运行效率。最后，将新的构建和测试任务集成到项目的 CI/CD 自动化流程中，为正式发布支持 RISC-V 的 NestOS 版本做好准备

**KVM环境兼容**

在测试过程中遇到了 RISC-V KVM 环境下 EDK2 加载 GRUB2 时崩溃的问题。通过查阅 Ubuntu 社区的相关讨论，发现这是由于旧版 GRUB2 错误地使用了 cycle 寄存器来读取时间，而该寄存器在 KVM 虚拟化环境中的行为不一致,从而导致了系统崩溃

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFGMuxHSoJtGEbSJpmicLB3f6niatUKt44Zlyfb55TctXqic1byxicicYxrKopD7O0KibYumS4ANSGXkdTUg/640?wx_fmt=png&from=appmsg#imgIndex=2)

解决这个问题需要两步：

1. 首先将 EDK2 升级到 stable202411 或更新版本，相关补丁已经合入上游

<!--THE END-->

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/tkVlnC85sFGMuxHSoJtGEbSJpmicLB3f6fu1PqH6lASyA11yHRicNnKRNLNibTlcVibrVqlnNMght9ic6xqLJaUNPaw/640?wx_fmt=jpeg&from=appmsg#imgIndex=3)

2. 其次需要为 GRUB2 手动合入一个 patch 来更换时间寄存器

完成这两项修改后，镜像已经可以在 KVM 环境下正常运行

**开发者说**

**常旭海**，目前在成都信息工程大学就读区块链工程。对开源操作系统、基础软件项目很感兴趣，有较长时间的Linux使用经验，酷爱研究领域前沿。曾获 ICPC 2024EC区域赛成都站铜奖，ICPC 2023EC区域赛沈阳站铜奖，第20届百度之星国赛铜奖，蓝桥杯软件组C/C++国家级二等奖，成都信息工程大学 24 年度特等奖学金。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/tkVlnC85sFGMuxHSoJtGEbSJpmicLB3f67UsiaEKyHtiaySJFCelnd3Strs63lqdibGwXeibZiaPQ9falCq33sUR6fgA/640?wx_fmt=jpeg&from=appmsg#imgIndex=4)

**常旭海说 「**   

    通过参与 OSPP 2025 的"为 nestos-assembler 添加 RISC-V 支持"项目，我在技术能力和开源协作上都有很大收获。

    在技术上，我深入分析了涉及 Go、Python 和 Bash 的复杂构建系统，显著提升了项目分析能力。最深刻的经历是在解决 RISC-V 镜像启动问题时，发现 Linux 内核缺失 RISC-V 架构的 fw\_cfg 支持，并贡献补丁解决了这个问题，这让我真正贯通了从底层内核到上层云基础设施的理解。

    在开源协作方面，我完整实践了从沟通需求到代码合并的标准流程，更重要的是学会了从单纯的任务执行者转变为主动发现问题、解决问题并推动项目进步的贡献者。

    衷心感谢 OSPP 平台和 openEuler RISC-V SIG 导师们的支持与指导。展望未来，我们将持续完善 NestOS 在 RISC-V 平台上的稳定性，适配更多新兴硬件，拓展云原生软件生态，并将开发成果持续回馈社区。

**」**

**结语**

OERV 将持续投入 NestOS RISC-V 方向的支持，进一步完善 RISC-V 云原生生态，推动 NestOS 在边缘计算、数据中心等场景的应用落地。我们期待更多开发者参与到 NestOS RISC-V 的建设中来，共同探索云原生与 RISC-V 架构结合的更多可能性

对 openEuler on RISC-V 生态建设感兴趣的伙伴们，可以添加下面的微信，加入我们 openEuler on RISC-V 开发群聊做进一步了解

中国科学院软件研究所 王经纬

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFGMuxHSoJtGEbSJpmicLB3f6JZG0WhvFIiahfUsHksJILDQKy4acBibSkdQycyevSibyl84bwhfb7UAbg/640?wx_fmt=png&from=appmsg#imgIndex=5)

添加时请备注 OERV

**相关链接**

- Gitee 协作主页:  
  https://gitee.com/openeuler/RISC-V
- 构建仓库协作地址:  
  https://build.tarsier-infra.isrc.ac.cn/
- 第三方 repo 源:  
  https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V
- OERV 工作中心:  
  https://github.com/openeuler-riscv
- 邮件列表:  
  riscv@openeuler.org
- Discord 邀请链接:  
  https://discord.gg/drG6qUsRc4
