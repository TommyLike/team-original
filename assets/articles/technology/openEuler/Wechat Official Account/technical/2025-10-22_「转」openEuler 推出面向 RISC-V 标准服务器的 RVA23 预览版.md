# [「转」openEuler 推出面向 RISC-V 标准服务器的 RVA23 预览版](https://mp.weixin.qq.com/s/Azsix-lULIPvpovesRU64g)

*OERV 宣传小队*[OpenAtom openEuler](javascript:void%280%29;)*2025-10-22 18:18:00广东*

**简介**

2025 年 9 月 30 日，openEuler 推出面向 RISC-V 标准服务器的 RVA23 预览版。

该版本采用了 RVCK 同源内核；工具链采用 GCC 14.3 和 Binutils 2.42。在此基础上和社区开发者一同 Backport 了 RVA23 所需支持：

- 协同达摩院为 GCC14.3 backport 了 29 个补丁实现 RVA23S64 的基础支持。

<!--THE END-->

- 协同中兴通讯为 binutils-2.42 backport 了 12 个补丁实现 RVA23S64 的基础支持。

<!--THE END-->

- 除此之外还为 OpenJDK、Golang 等 runtime 组件 Backport 了 RVA23 支持。

基础库方面，中兴通讯为 openssl 的 AES、RSA、SM2 等模块补充了 RISC-V 向量支持，为 snappy 等基础库实现了性能优化，在此之外还修复了十余处构建问题。

此版本提供了基于 RVA23 标准的服务器系统前瞻体验平台，也为后续 24.03LTS SP3 RVA23 长周期版本发布奠定了坚实基础。

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFGXYAfW3gl04icia0jw24XKLF6QG1PPfdxIQ3pRCUu8nngXDfyGapnh6adDWBicnTx97DSpjJnd1gakg/640?wx_fmt=png&from=appmsg#imgIndex=0)

预览版本已在软件所镜像站发布：https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-25.09-RVA23-V1-riscv64/

**RVCK 内核同源计划**

RVCK 内核同源（简称 RVCK）是 Linux 内核的一个下游分支，同时也是 openEuler 社区发行版内核的主要提供方。该项目致力于为不同硬件平台的 RISC-V 生态构建统一的内核基础，维护公共演进需求，降低系统维护复杂度，并增强软硬件上下游之间的协同能力。该项目的主要贡献者包括中兴通讯、算能、进迭时空、超睿科技和达摩院等知名 RISC-V 厂商，为 RVA23 兼容与通用服务器能力建设提供了重要支持。

在 RVA23 兼容性方面，RVCK 的 RISC-V 扩展探测机制 HWPROBE 已基本实现与主线内核同步，并对关键扩展特性进行了回合支持。（软件所、中兴通讯）

在 Server Platform 规范支持方面，RVCK 已取得以下核心进展：

- ACPI 子系统：支持处理器电源管理（LPI）、性能状态调整（CPPC）、NUMA 拓扑（SRAT/SLIT）及 PCIe 配置（MCFG/ECAM）等。（算能、中兴通讯）
- 高级中断架构（AIA）：RINTC、IMSIC、APLIC 和 PLIC 等中断控制器的 ACPI 支持，为高性能外设中断奠定基础。主要由算能公司贡献，并为 SG2044 平台贡献了 MSI 控制器驱动。
- 标准化外设：支持 16550 兼容 UART（算能）、PCIe 控制器（算能）、SDHCI 存储控制器（进迭时空）、EMAC 网络控制器（进迭时空）以及多种电源管理芯片（进迭时空）等。
- 安全机制：支持指针掩码（Supm/Ssnpm）、随机数生成（Zkr）等 RISC-V 架构安全扩展。（软件所、中兴通讯）
- 其他服务器特性：RISC-V IOMMU 架构驱动的基础支持，包括设备目录管理、命令与故障队列、单级地址转换（中兴通讯）。

未来，RVCK 项目将持续推动 RISC-V 内核在服务器领域的能力完善，多个方面工作正在进行中，如：

- RAS（可靠性、可用性和可维护性）与 QoS（服务质量）等关键特性的支持
- RISC-V IOMMU 驱动完善
- 基于新 ISA 扩展的性能优化
- 完善现有硬件平台支持

此外还有来自多方的开发者在重要特性回合与问题修复中做出了积极贡献，共同推动了项目的进展。更多信息欢迎访问项目仓库页面获取。

代码仓：https://github.com/RVCK-Project

**版本后续计划**

25.09 RVA23 预览版已经在软件所镜像站发布，近期将同步推送至 openEuler 预览仓库。25.09 RVA23 作为体验版本，将维护至 2025 年底，同时原生支持 RVA23 的 openEuler 24.03 LTS SP3 正式版本将在年底正式发布，并提供更多更全面的  RISC-V Server Platform 标准支持能力。

**RVA23 的意义**

RVA (RISC-V Application Profile) 是 RISC-V 国际基金会为通用计算领域的应用处理器制定的指令集扩展集合规范。2024 年 10 月新近确立的 RVA23 规范将向量扩展和虚拟化扩展等关键 ISA 扩展纳入必选范围，填补了 RISC-V 生态在并行计算与虚拟化等领域的空白。

**联系我们**

对 OERV 工作感兴趣的伙伴们可以添加下方的微信并且加入到 openEuler RISC-V 社区开发群，获取更多即时信息，OERV 团队长期招收 全职/兼职/实习生，简历投送在邮箱 wangjingwei@iscas.ac.cn

中国科学院软件研究所 王经纬

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFGXYAfW3gl04icia0jw24XKLFtETmI8KyrZ1T2XbIhewbWnVqjZV1vyyrKrS7A0gMtxeBPuryElfgIw/640?wx_fmt=png&from=appmsg#imgIndex=1)

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
