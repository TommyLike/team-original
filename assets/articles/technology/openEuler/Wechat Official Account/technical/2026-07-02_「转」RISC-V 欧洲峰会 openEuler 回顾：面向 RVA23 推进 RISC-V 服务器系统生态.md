# [「转」RISC-V 欧洲峰会 openEuler 回顾：面向 RVA23 推进 RISC-V 服务器系统生态](https://mp.weixin.qq.com/s/gR0D2lsLU4spcGZ8VZmQiQ)

*吴干琼*[OpenAtom openEuler](javascript:void%280%29;)*2026-07-02 17:49:04广东*

**导语：**OpenAtom openEuler（简称“openEuler”或“开源欧拉”）在 2026 RISC-V 欧洲峰会上进行 Poster 展示，呈现了中国科学院软件研究所（简称“软件所”）以及如意社区如何推动 openEuler on RISC-V 迈向 RVA23标准服务器系统的阶段性进展与后续计划。

2026 年 6 月 8 日至 12 日，2026 RISC-V 欧洲峰会（RISC-V Summit Europe 2026）在意大利博洛尼亚举行。作为欧洲地区具有重要影响力的 RISC-V 行业盛会，本次大会汇聚了来自全球产业链企业、科研院校、开源社区与生态伙伴的多方代表，围绕 RISC-V 技术创新、软硬件协同与生态建设展开交流。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/79uC8IloHOBbyxJ6QtcJejgqvesH6Vc88tzy4Ht0fMm4RZZAn7lOlHvUhjXSNl0Xt7Imw3jLB9orrFHib3QgZSWMtxbUD73gR0jNdHKWRB9A/640?wx_fmt=jpeg)

软件所工程师 openeuler 技术委员王经纬在 RISC-V Summit Europe 2026 Poster 展示现场

在 2026 RISC-V 欧洲峰会期间，openEuler on RISC-V SIG 围绕 **“openEuler for RVA23: Building a RISC-V Server OS with Ecosystem Partners”** 主题进行 Poster 展示，重点呈现 openEuler on RISC-V 面向 RVA23 服务器系统的基础适配、验证进展与演进路线。

![openEuler for RVA23 poster](https://mmbiz.qpic.cn/mmbiz_jpg/YLFWsWPSKnnd2pqeyBz54twJtx7a11qW58gibH0EP9uLMHuDGgyRUXVPh1ZCPETAetaayFEuPuoia9u9CLBia0ZauIDn3yI7Zmr17uB1uxvNbs/640?wx_fmt=jpeg&from=appmsg)

Poster: openEuler for RVA23: Building a RISC-V Server OS with Ecosystem Partners

## 面向 RVA23，构建 RISC-V 服务器操作系统基线

围绕 RVA23 服务器基线策略，openEuler on RISC-V 正在补齐面向服务器场景的操作系统基础能力。Poster 中提到，**openEuler 24.03 LTS SP3 是首个原生支持 RVA23 的 openEuler LTS 版本**，同时提供 RVA23 与 RVA20 的 UEFI ISO、QEMU 虚拟机镜像、开发板镜像等。

其中，进迭时空 K3 作为市面首款 RVA23 芯片平台，在该版本中获得首发支持，并在 K3 平台上完成了 UEFI ISO 配合 QEMU KVM 虚拟机安装使用验证。这意味着 openEuler on RISC-V 正在从基础系统可用，进一步走向面向服务器平台规范、硬件适配与长期维护的系统化建设阶段。

## 以 RVCK 为基础，推进内核社区化适配与反合

在内核方向，openEuler on RISC-V SIG、中国科学院软件研究所及生态伙伴围绕 RVCK 内核**同源计划 (RISC-V Common Kernel) 持续推进 RVA23 相关适配和补丁**反合。RVCK 计划致力于构建统一的内核能力底座，为不同 RISC-V 芯片平台提供可复用、可扩展的基础软件支持体系，有助于减少重复适配工作，提升软硬件上下游协同效率。

Poster 中展示的服务器平台适配进展覆盖多个关键方向，包括 ACPI 相关能力、AIA 中断架构、UART / PCIe / SDHCI / EMAC 等外设支持，以及 Supm / Sspm 指针掩码、Zkr RNG、IOMMU 等安全与平台能力。

## 工具链与基础库同步演进，补齐用户态基础能力

服务器操作系统的成熟，离不开工具链、运行时和基础库的系统性支撑。Poster 展示了 openEuler on RISC-V 在用户态方向的多项进展：RVA23 版本的基础工具链选定了较新的 GCC 14.3、Binutils 2.42、LLVM 20 等版本。openEuler on RISC-V SIG 在此基础上，对工具链、基础库和运行时进行了大量适配与补丁反合。

相关工作包括 GCC / Binutils 对 RVA23S64 必选扩展与 RVA Profile 的支持，Go 运行时与 V 扩展优化，OpenJDK 21 在 RVA23、加密、RVV / Zfa / Zvkn 等方向的优化与修复，以及 OpenSSL / ISA-L 在 RISC-V 加密与向量性能方面的优化。

## 香山 FPGA 验证，覆盖代表性服务器负载

除了软件栈本身，openEuler 还适配到了**香山昆明湖 RVA23 单核与双核 FPGA 平台**，用于支持香山平台的硅前验证。验证过程中，openEuler 团队测试了 Nginx、httpd、MySQL、Hadoop、Memcached、OpenBLAS、C++、Golang、Python3、Java、Protobuf 等 11 类服务器常见应用。

这类硅前验证工作，有助于在真实芯片量产之前，提前发现系统软件、平台固件、内核与应用负载之间的兼容性问题，为后续 RISC-V 服务器软硬件协同优化提供依据。

## 生态伙伴协同，推动 RISC-V 服务器生态走向成熟

RISC-V 服务器生态的建设并非单点突破，而是硬件、内核、工具链、运行时、基础库与发行版社区共同推进的长期工程。本次 Poster 也突出展示了生态伙伴在内核与用户态适配中的贡献，包括中国科学院软件研究所、阿里巴巴达摩院、中兴通讯、进迭时空、算能、超睿科技等伙伴在相关工作中的参与。

面向未来，在 openEuler 24.03 LTS 系列后续版本、28.03 LTS 系列及其间的创新版本中，openEuler on RISC-V SIG 计划继续面向 RVA23 及 RISC-V 服务器平台规范推出版本。对于旧设备或 RVA23 支持不完善的设备，2026 年仍计划基于 24.03 LTS 系列推出至少一个 RVA20 版本，为此类设备提供安全更新。

## 联系我们

对 OERV 工作感兴趣的伙伴们可以添加加入到 openEuler on RISC-V 社区开发群，获取更多即时信息。团队长期招收**全职/兼职/实习生**，欢迎投递简历至邮箱 wangjingwei@iscas.ac.cn。

## 相关链接

AtomGit 协作主页：

https://atomgit.com/openeuler/RISC-V

第三方 repo 源：

https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V

OERV 工作中心：

https://github.com/openeuler-riscv

邮件列表：

riscv@openeuler.org

Discord 邀请链接：

https://discord.gg/drG6qUsRc4

**关注我们，了解更多**

**▼**

![图片](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2d1CvxNf56DXribfOKnOqvMU1jP4fVRpO45sDy84Knibcp1OuASLm5MMg/640?wx_fmt=png&from=appmsg&wxfrom=5&wx_lazy=1#imgIndex=3)
