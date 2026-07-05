# [Linux Kernel 5.8 发布，华为在内核代码贡献上排名第二](https://mp.weixin.qq.com/s/4XPfFJd4d9D9iB1O5rAHrQ)

原创*周主编*[OpenAtom openEuler](javascript:void%280%29;)*2020-08-31 21:59:17*

近日， Linux Kernel 5.8 版本正式发布，Linus 表示 Linux Kernel 5.8 是“有史以来最大的发行版之一”。Linux Kernel 5.8 在 ARM64 架构特性方面，有不少的更新，华为 92 个社区内核工程师贡献了包括：ARM64 SPE perf event、ACPI CPPC 支持 ARM64 CPU 超频，以及虚拟化热迁移页标脏优化（128G 4K 页标脏从 650ms 优化到 1.8 ms），CPU 休眠调控器默认可根据场景调整等等特性， 与此同时，华为在 Linux Kernel 5.8 中的代码贡献（changesets）、代码修改行（line changed）和内核缺陷发现方面，都交出了一份亮眼的答卷。

华为工程师郭寒军回忆到：“还记得十年前合入第一个 patch 的激动, 一转眼十年的时间，华为在社区已经拥有 20+ Maintainer，在容器所使用的核心功能 Cgroup，软硬件解耦 ACPI on ARM64，文件系 F2FS/EROFS，RAS EDAC 框架，Media 子系统，IIO 子系统，以及 Perf on ARM64 等子系统上，华为都为社区贡献了代码。这也是华为在基础软件上技术实力的体现”

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZfNw8NUXfbdpPMXJia4hibeZ0Il0EZy6bOFToiaxwSzEBU925Au4bXGrSp7RFCicdpVyib1lKcSicvMK2Q/640?wx_fmt=png)

### 内核代码贡献，华为排名全球第二

从公司贡献角度来说，华为提交的补丁数量位列第二名，占比 8.6%，代码修改行位列第一，占比 27.8%。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZfNw8NUXfbdpPMXJia4hibeZdGK2XPnpksBZGssH3os0KfsnLvStjBjtl1BV83R3JfnNibTEHiaB5y4g/640?wx_fmt=png)

在华为贡献的 1399 个补丁中，除了前文中提及的系统特性外，还有包括网络、文件系统、perf 调测、安全等关键子系统的 200+ 的 bugfix 补丁，这些都是 Linux 能够正常运行所需的基础软件系统，对于 Linux 是非常重要的。

自由软件新闻媒体 LWN.net 对此种现象说道：

> > "A great deal of effort has gone into freezing Huawei out of the commercial marketplace in significant parts of the world, but the company remains active in the development community with 92 developers contributing to 5.8"

### 自动内核缺陷发现机器人继续占领 Bug 提交榜首

在内核测试和 Bug 提交方面，华为的自动内核缺陷发现机器人 HULK Robot（Huawei Unified Linux Kernel Robot）一如既往的表现出色，在 Linux Kernel 5.8 版本中继续霸榜，显示了华为在 Linux 稳定性方面的超群实力。

HULK Robot 的架构师魏勇军介绍，开源模式下除了带来业务生态快速催熟等各种红利外，也引入了越来越多的挑战：海量频繁的补丁合入、成千上万的开发人员、一行修改百倍测试等等。华为通过构建成熟稳健智能的测试机器人，精准挖掘 Linux kernel 缺陷，保障高质量可持续交付的 Linux 内核，配套各解决方案商用。”

HULK Robot 融合了大数据机器学习和语义分析技术，它包含了海量的测试数据，供 HULK Robot 进行学习，同时集成基于场景语意的模糊测试技术、全系统函数级故障注入配合精准的单元测试，使 HULK Robot 成为一个高效，精准的可扩展测试系统，大幅提高测试效率和问题检出效率。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZfNw8NUXfbdpPMXJia4hibeZrOF6Oq25HIfNngT64M5h1MEp9Sj8nMYXBoM9BgJ80td2O931bc70wg/640?wx_fmt=png)

华为工程师 Mauro Carvalho Chehab 作为 Media，EDAC Maintainer ，双贡献排名全球第一 在 Linux Kernel 5.8 内核开发的过程中，自由软件新闻媒体 LWN.net 对最活跃的开发者做了统计，列表如下：

其中第一名是来自华为的 Mauro Carvalho Chehab（以下简称：Mauro），Mauro 无论在提交的补丁还是代码修改行，都位列第一名，占整个补丁的 3.4%，占整个代码修改行的 25.8%

### ARM 生态正在不断壮大

在开源项目上，为了打通 ARM 全栈的能力，华为已经在 40 + 主流技术社区做出代码贡献，目前包括但不限于：Kubernetes、OpenStack、Hadoop、TensorFlow、httpd、MySQL、X265 等都已经支持 ARM 架构。

华为一直坚持 upstream first，在贡献上游 Linux 社区的同时，华为也发行了 openEuler LTS 版本，目标是将 openEuler 打造成支持多算力架构的开源操作系统社区。截至目前国内有 6 家合作伙伴发行了基于 openEuler 的商业发行版，分别是：麒麟软件、统信软件、中科院软件所、普华软件、麒麟信安、万里开源。

欢迎大家加入最有活力的 openEuler 社区：https://openeuler.org

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZfNw8NUXfbdpPMXJia4hibeZ2kmichy0M4qFSjMCAZf78CwicWiab0JDtA4iasc6WsB0WQVwD3SrNwnHMg/640?wx_fmt=png)

### 华为深度参与全球开源组织，为社区积极贡献力量：

- 国际主流开源基金会的顶级成员：Linux 基金会的白金会员、Apache 基金会的白金赞助方、OpenStack 基金会的白金会员、Eclipse 基金会的战略会员。
- 开源社区/项目的贡献者：华为目前在主流开源社区中拥 200 多个 TSC、PMC、PTL、Maintainer、Committer 等席位，以及十多个董事席位服务于各开源项目。在全球第一大社区 Linux 内核社区中，华为综合贡献全球排名第四；云原生社区 CNCF，华为综合贡献全球排名第五；Docker 全球排名第 5。
- 通过开源 openEuler、MindSpore（全场 AI 计算框架）、SODA（智能开放的数据自治平台）、Apache CarbonData（大数据）、Apache 微服务项目 ServiceComb、KubeEdge（边缘计算）、Volcano（高性能调度引擎）等等，逐步把华为长期积累的大量基础软件能力，不断完善并逐步贡献到开源社区中。

### 华为公司简介

华为是全球领先的 ICT（信息与通信）基础设施和智能终端提供商，致力于把数字世界带入每个人、每个家庭、每个组织，构建万物互联的智能世界。我们在通信网络、IT、智能终端和云服务等领域为客户提供有竞争力、安全可信赖的产品、解决方案与服务，与生态伙伴开放合作，持续为客户创造价值，释放个人潜能，丰富家庭生活，激发组织创新。华为坚持围绕客户需求持续创新，加大基础研究投入，厚积薄发，推动世界进步。华为成立于 1987 年，是一家由员工持有全部股份的民营企业，目前拥有 19.4 万员工，业务遍及 170 多个国家和地区。欲了解更多详情，请参阅华为官网：www.huawei.com

[阅读原文](https://lwn.net/Articles/827735/)
