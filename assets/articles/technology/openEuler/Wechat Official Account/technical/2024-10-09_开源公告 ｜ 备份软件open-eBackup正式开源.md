# [开源公告 ｜ 备份软件open-eBackup正式开源](https://mp.weixin.qq.com/s/aEGwhVi02uJLMO_nq73www)

[OpenAtom openEuler](javascript:void%280%29;)*2024-10-09 19:58:00中国香港*

承载着无数期望的备份软件，终于迎来了激动人心的时刻，open-eBackup正式开源。open-eBackup是一款开源备份软件，采用集群高扩展架构，通过应用备份通用框架、并行备份等技术，为主流数据库、虚拟化、文件系统、大数据等应用提供E2E的数据备份、恢复等能力，帮助用户实现关键数据高效保护，开源协议采用Mozilla Public License Version 2.0。

OpenAtom openEuler（简称”openEuler“）社区已成立 Backup SIG，该SIG管理和维护open-eBackup项目，希望能够汇集全球备份软件用户、伙伴、开发者共同加入，共同探索数据备份技术发展趋势，制定相应的软件解决方案。

**open-eBackup产品架构**

![](https://mmbiz.qpic.cn/mmbiz_png/sZMdj3jZEQ5RkIiaGEphXo9XibMV3q6YNL2eP2njjub8J9K96TIeln47ic5jVCh8ANW3yuKeYYRLRsS6iaPILWfStA/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

open-eBackup主要功能模块简介如下：

**数据保护代理**（ProtetectAgent)：主要负责获取生态数据，并将数据写入介质接入层。

**数据保护引擎**（DataProtect Engine)：主要负责配置保护策略，调度备份/恢复/复制/归档任务，向ProtectAgent发送备份任务，并监控任务执行状态，最终生成备份副本。

**数据移动引擎**（DataMover Engine)：主要负责统一各种类型的备份存储的接入以及管理，并将ProtectAgent写入的数据写入的各种类型的备份介质进行持久化。

**系统管理器**（SystemManager）：主要负责系统配置管理，如：用户管理、告警管理、证书管理以及集群管理等。

**基础设施**（Infrastructure)：主要负责管理K8S集群以及为其他管理及业务模块提供基础能力，如：数据库服务，Kafka消息服务，ElasticSearch服务，Zookeeper服务等。

**数据使能引擎**(DataEngabler Engine)：主要负责将备份数据再次进行加工利用，使能其他业务，如：对数据进行脱敏、勒索检测、AirGap隔离、以及对备份副本再次扫描，抽取元数据，提供检索服务等，该模块与open-eBackup备份介质密不可分，需与open-eBackup介质绑定使用。

**工程简介**

open-eBackup工程有3个，分别是：REST\\\_API、open-source-obligation、GUI。

- REST\\\_API：存放open-eBackup备份软件的所有开源的源代码。
- open-source-obligation：存放open-eBackup备份软件所有依赖的所有二进制文件，包含自研二进制和三方开源二进制文件。
- GUI：存放open-eBackup备份软件所依赖的GUI的框架源码。

![](https://mmbiz.qpic.cn/mmbiz_png/sZMdj3jZEQ5RkIiaGEphXo9XibMV3q6YNL79PFMiaFoicaAABA6jRS9ZKYkBLvIYaAYQFL02nDrcRoSkibDps7KJG7Q/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

# **编译前操作系统及软硬件依赖，请参考快速入门指南**：

# https://gitcode.com/eBackup/open-eBackup/blob/master/doc/quick\_guide/快速入门.md

**代码仓库**

# **开源备份软件代码托管在GitCode平台上，有两个代码仓，**分别为：

- https://gitcode.com/eBackup/open-eBackup，主要为备份应用生态接入层及业务相关代码。
- https://gitcode.com/eBackup/LiveUI，主要为备份软件前端框架相关代码。

**欢迎给项目一个 Star !**

欢迎对open-eBackup项目感兴趣的伙伴加入，通过社区进行交流互动，提出你的 issue 和 PR，讨论收获技术成长、合作机会和参与社区活动。
