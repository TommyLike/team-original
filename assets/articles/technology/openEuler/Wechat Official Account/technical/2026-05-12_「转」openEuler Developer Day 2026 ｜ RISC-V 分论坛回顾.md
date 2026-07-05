# [「转」openEuler Developer Day 2026 ｜ RISC-V 分论坛回顾](https://mp.weixin.qq.com/s/MNNY1kYmJs8gpcK9mz7SyA)

*吴干琼*[OpenAtom openEuler](javascript:void%280%29;)*2026-05-12 17:30:00广东*

2026 年 4 月 25 日，由 OpenAtom openEuler（简称 "openEuler" 或“开源欧拉”）社区发起的 openEuler Developer Day 2026 在长沙召开。RISC-V 分论坛作为大会 SIG Gathering 环节的重要专题之一，邀请了来自中国科学院软件研究所、北京开源芯片研究院、中兴通讯、阿里巴巴达摩院、进迭时空、蓝芯算力等单位的技术专家，围绕 openEuler on RISC-V 的技术进展、生态适配与场景实践展开交流。

本次分论坛内容涵盖 openEuler on RISC-V 总体进展、RVCK 内核维护、openEuler 服务器版本验证实践、I/O 虚拟化、RISC-V 服务器平台、LX500 芯片与 openEuler 适配融合，以及 RISC-V 架构上的多 OS 混合关键系统等方向，集中呈现了 openEuler on RISC-V 生态在系统适配、内核能力、芯片验证、服务器平台和行业场景中的阶段性成果。

论坛开场环节，中国科学院软件研究所高级工程师屈晟回顾了 openEuler Developer Day RISC-V 相关专题从面对面讨论到系统化专题分享的演进历程，并指出今年议题更加贴近实际落地与商业化目标。同时呼吁更多产业伙伴、开发者和最终用户参与 openEuler on RISC-V SIG 共建，将版本适配、内核能力、用户态组件和产业应用中的共性需求沉淀到社区公共底座中，持续推进新标准、新特性的验证与落地。

![](https://mmbiz.qpic.cn/mmbiz_jpg/YLFWsWPSKnktrWTTqvhW7mO6w5bvsfPgEFSribMR8LKaHNCsiahfpoNlFVYeiboNS7yA7pTcqWiaxH8ypOxUrysz88RraCL6j8qpBDic2ehMOxj8/640?wx_fmt=jpeg&from=appmsg)

openEuler Developer Day 2026 RISC-V 分论坛活动现场

以下为本次会议的主要内容回顾。

面向 RVA23 规范与 RISC-V 标准服务器操作系统：openEuler on RISC-V 进展与计划

中国科学院软件研究所工程师周嘉诚 (openEuler on RISC-V SIG Maintainer) 介绍了 openEuler 在 RISC-V 架构方面的总体进展，重点梳理了 openEuler 对 RVA23 规范及标准服务器平台规范的适配情况。后续，openEuler on RISC-V 将继续推进 DevStation 版本适配，以及 CI、构建和自动化测试等基础设施建设与适配。

openEuler 6.6/新 LTS/新 stable 内核维护方案

中国科学院软件研究所工程师高涵介绍了 RISC-V 内核同源项目 RVCK 的维护进展，重点梳理了内核对 RVA23 规范、RISC-V 服务器平台规范及服务器基础能力等核心特性的支持情况，以及树外 SDK 补丁清理和硬件板卡支持进展。面向后续新版本内核计划，相关工作将探索推动发行版双内核策略，并在 openEuler 方向持续推进相关适配工作。

使用 openEuler 服务器版本加速芯片硅前和硅后验证

北京开源芯片研究院基于进迭回片的 V100 服务器芯片，闭环了硅前系统验证流程。产品经理张健介绍了开芯院软件团队基于 workload-builder 和 openEuler RPM 构建的系统验证平台，介绍其面向 FPGA 验证环境的各项设计、制作流程与实践，在复用社区制品的基础上实现自顶向下的验证，通过 ~400M 镜像大小的硅前原生操作系统 rpm 系统验证流程，降低了软件栈切换风险。

中兴携手openEuler: RISC-V 内核生态繁荣之路

中兴通讯操作系统工程师刘庆涛 (openEuler on RISC-V SIG Committer) 介绍了中兴通讯在 RISC-V 架构内核特性和稳定性方面的贡献，重点回顾了中兴在 openEuler 24.03 LTS SP3 版本中的合入贡献、稳定性支持工作和兼容性认证进展，并介绍了内核 PCIe、IOMMU、社区兼容性测试等推进中的工作，以及机密计算等方向的后续计划。

玄铁 I/O 虚拟化进展与社区的开源实践

阿里巴巴达摩院 RISC-V 内核技术专家余方玉介绍了RISC-V 虚拟化 IOMMU 方面玄铁的进展，重点围绕 IOMMU 在 Linux 生态中的典型使用场景、端到端验证环境，以及基于玄铁 C950 从硬件到驱动的完整 IOMMU 架构实现介绍。相关工作在满足虚拟化场景下高性能 I/O 直通需求的同时，实现了全链路 DMA 安全防护。后续将持续跟踪上游 Linux 社区补丁并及时回迁到 openEuler 社区，同时继续推动自研特性上游合入，并探索在 openEuler 社区率先支持。

统一底座，无需适配：进迭时空 V100 与 openEuler，让 RISC-V 服务器告别“定制镜像”时代

进迭时空工程师潘金宝围绕 V100 服务器的硬件与平台能力进行了介绍，重点分享了其在 RISC-V 服务器规范适配、固件体系和运行时规范 BRS 支持方面的实践。针对 V100 服务器搭载的 40 个 X100 核与 6 个 KMH 核，完成了从 UEFI 固件到 ACPI、SMBIOS 的全栈适配。通过基于 EDK-II 的标准 UEFI 固件，以及 ACPI、SMBIOS、SBI 3.0、管理固件等能力，让 V100 具备直接安装并运行 openEuler 24.03 LTS SP3 官方 ISO 镜像的基础。现场演示也展示了其无需额外进行内核或发行版定制，即可启动并稳定运行 openEuler 操作系统的能力。

LX500 与 openEuler: RISC-V + AI 智融服务器 CPU 和国产操作系统的深度融合解决方案

蓝芯算力高级生态总监许庆伟介绍了蓝芯 LX500 芯片的硬件特征与性能指标，重点介绍了其自主研发的 LX500 RISC-V + AI 智融服务器 CPU 的设计理念、架构创新、性能指标及其在 AI 推理、高性能计算、云计算等场景下的技术优势，同时分享了其对 RAS、CXL 等能力的支持情况，以及目标场景、解决方案和落地进展。未来，蓝芯算力将继续联合硬件伙伴、云服务厂商和社区推进生态共建，并通过产品迭代与商业化落地完善相关解决方案。

openEuler 生态下的混合关键性系统解决方案在 RISC-V 上的进展与计划

中国科学院软件研究所工程师张正介绍了 RISC-V 架构上的多 OS 混合关键系统 MICA、裸金属部署的 MICA 软件栈的支持进度，基于虚拟机管理程序的 zvm 多 OS 部署策略，及后续在完整支持 IOMMU AIA 硬件上的 jailhouse 支持计划等。

★ Gathering Star

本次分论坛中，中国科学院软件研究所工程师高涵、张正获得 RISC-V SIG Gathering Star。两位在 RVCK 内核维护、多 OS 混合关键系统适配等方向持续参与社区建设，为 openEuler on RISC-V 生态发展提供了重要支持。

结语

openEuler on RISC-V SIG 计划在进一步适配 RISC-V RVA23 规范与服务器平台规范的基础上，继续与各社区伙伴通力合作，面向下一代 RISC-V 商业平台完善公共底座、扩展硬件适配，持续推动 RISC-V 软硬件生态完善与落地。

联系我们

对 OERV 工作感兴趣的伙伴们可以添加加入到 openEuler on RISC-V 社区开发群，获取更多即时信息。OERV 团队长期招收 全职/兼职/实习生，欢迎投递简历至邮箱： wangjingwei@iscas.ac.cn

相关链接

- AtomGit 协作主页:

https://atomgit.com/openeuler/RISC-V

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

**关注我们，了解更多**

**▼**

![图片](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2d1CvxNf56DXribfOKnOqvMU1jP4fVRpO45sDy84Knibcp1OuASLm5MMg/640?wx_fmt=png&from=appmsg&wxfrom=5&wx_lazy=1#imgIndex=2)
