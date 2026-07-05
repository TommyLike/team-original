# [中兴通讯 RISC-V 生态团队为 openEuler 作出重要贡献](https://mp.weixin.qq.com/s/XjO8EWGlc4kUe93t7kx-5A)

[OpenAtom openEuler](javascript:void%280%29;)*2025-10-21 11:45:00新加坡*

中兴通讯 RISC-V 生态团队共同参与 openEuler（简称“openEuler 或”开源欧拉”） on RISC-V 架构 RVA23 版本的维护工作，为 RISC-V 生态作出重要贡献。

中兴通讯是全球领先的综合信息与通信技术解决方案提供商，致力于用创新的技术与产品解决方案，服务于全球电信运营商、政企客户和消费者。

中兴通讯在 RVI 中担任 premier TSC，活跃于 DataCenter SIG 、Hypervisor SIG 等小组，在 2022 年签署 openEuler 的 CLA 并积极推进 RISC-V 相关生态建设。

中兴通讯 RISC-V 生态团队聚焦 RVA23 标准在操作系统发行版中的落地实现，刘庆涛、高睿团队从用户态组件、内核、虚拟化、发行版构建等各个方面都积极推进了相关工作，并取得阶段性进展，有效支撑了 openEuler RVA23 预览版本的如期发布，并为 LTS 版本提供有力支持。

**01**

关键用户态组件优化

RVA23 标准已基本完善，但关键用户态组件在 RISC-V 架构上的性能与兼容性表现差距较大。以 OpenSSL、ISA-L、lz4 等为代表的一系列关键用户态组件，在加解密、数据存储、压缩等领域处于核心地位，其在 RISC-V 平台的运行效果亟待优化

团队与中国科学院软件研究所合作，主要贡献包括：

- 存储领域：ISA-L 的 CRC 模块增加数据折叠 +Barrett 缩减的 RISC-V 汇编加速优化、EC 模块增加 rvv 汇编优化，redis 的非对齐访问模块优化。ISA-L 的 CRC 模块性能提升至 32-40 倍、EC 模块提升 18-45 倍，redis 的哈希测试提升至 1.65 倍

<!--THE END-->

- 加解密领域：OpenSSL perl 相关框架的反合与优化，以及 SM2、AES、RSA 模块的 RISC-V 汇编性能优化。SM2 签名提升至 20 倍，验签提升 3.3 倍，AES 加密性能最高提升至 2.6 倍，RSA签名提升至 2.6 倍，验签提升至 1.8 倍

<!--THE END-->

- 压缩解压领域：lz4 的非对齐访问，snappy 的压缩片段长度匹配相关函数性能优化等。lz4 压缩提升至 1.34 倍，snappy 性能小幅提升

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFGMuxHSoJtGEbSJpmicLB3f6OXicTu8qnzyfA8k8pnvibvMRI09iaw3aSTd1tUws7OW1EWvVqiapvCY6DA/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFGMuxHSoJtGEbSJpmicLB3f6Vs3oiafiaNWkk6raSkas5MuXXJJZnGGcKrficCY0fR3CwqFBTJW9NV9bg/640?wx_fmt=png)

**02**

RVCK 内核同源项目长期贡献

团队与 openEuler 社区、 中国科学院软件研究所和其他 RISC-V 领域头部硬件伙伴一起共同推进了 RVCK 同源项目的发展，完善了基于 6.6 内核的 RVA23 支持，主要工作和计划：

- 硬件平台接口支持：ACPI 相关驱动（SPCR、PPTT 等）、SMBIOS/DMI 驱动支持

<!--THE END-->

- RVA23 指令集支持：zbb、zbc、Zabha、Zacas、Svvptc、Zkr 等扩展支持

<!--THE END-->

- IOMMU 驱动支持

<!--THE END-->

- KVM 支持完善

<!--THE END-->

- 发行版构建支持

**03**

发行版构建支持

团队支持社区版本构建，在  openEuler 25.09 RVA23 预览版开发过程中，协同移植了 binutils 工具链对 RVA23S64 的基础支持，同时修复包括 gcc、dhcp、gavl 等数十个组件构建问题

**04**

长期贡献计划展望

- 用户态组件方面：存储、网络、视频编解码、加解密、压缩解压等方向

<!--THE END-->

- 内核方面：QoS、安全领域、KVM、IOMMU、Debug 特性等模块

中兴通讯 RISC-V 团队将持续参与 openEuler RISC-V SIG 建设，携手中国科学院软件研究所和其他软件生态伙伴力量一同迈向新的生态里程碑，为 RISC-V 的繁荣生态贡献力量

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFGMuxHSoJtGEbSJpmicLB3f6PXHEIFibgvJibFEIJvC8mSM4ZojgqwfT1It7CELQA2smy1dywm5biaL2g/640?wx_fmt=png)

刘庆涛，中兴通讯操作系统工程师，热衷于钻研内核和用户态组件核心技术，尤其擅长安全、驱动等领域的软硬件协同优化。长期跟踪国内外社区动态和技术演进，近期主要专注于 RISC-V 的生态建设工作

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFGMuxHSoJtGEbSJpmicLB3f6BCQFb6GPkvACHduyGISwKfaPgzzQ0TqF0lzm4WV9ejZduicdQm70fGA/640?wx_fmt=png)

高睿，中兴通讯操作系统工程师，长期深耕内核开发，在内存管理、进程调度、文件系统等核心模块积累了深厚经验。目前主要关注并参与 RISC-V 生态的建设工作，与国内外社区密切合作，共同推进相关技术的发展

**05**

联系我们

对 OERV 工作感兴趣的伙伴们可以添加下方的微信并且加入到 openEuler on RISC-V 社区开发群，获取更多即时信息，OERV 团队长期招收 全职/兼职/实习生，简历投送在邮箱 wangjingwei@iscas.ac.cn

中国科学院软件研究所 王经纬

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFGMuxHSoJtGEbSJpmicLB3f6JZG0WhvFIiahfUsHksJILDQKy4acBibSkdQycyevSibyl84bwhfb7UAbg/640?wx_fmt=png)

添加时请备注 OERV

**06**

相关链接

- Gitee 协作主页:https://gitee.com/openeuler/RISC-V

<!--THE END-->

- 构建仓库协作地址:https://build.tarsier-infra.isrc.ac.cn/

<!--THE END-->

- 第三方 repo 源:https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V

<!--THE END-->

- OERV 工作中心:https://github.com/openeuler-riscv

<!--THE END-->

- 邮件列表:riscv@openeuler.org

<!--THE END-->

- Discord 邀请链接:https://discord.gg/drG6qUsRc4
