# [RISC-V 中国峰会 ｜ openEuler RISC-V 运行时生态建设进展](https://mp.weixin.qq.com/s/U9XqHSKyfxJ6iMnlGpfgjQ)

[OpenAtom openEuler](javascript:void%280%29;)*2024-09-04 19:16:38中国香港*

第四届 RISC-V 中国峰会（RISC-V Summit China 2024）于 8 月 21 日至 23 日在杭州成功举办。OpenAtom openEuler（简称“openEuler”） Java SIG 组 Maintainer，OpenJDK Author，中国科学院软件研究所 OERV 运行时小组组长张定立在峰会上分享了 「openEuler RISC-V 运行时生态建设进展」的演讲，介绍了运行时小组成立以来在 openEuler RISC-V 运行时生态，包括 Java、Python 等建设上取得的技术成果以及小组未来的工作计划。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/tkVlnC85sFHMicpWWsZnM1k2xt10bbwM4icJicOVbOcH8NhAUMVLPgeDPhFbCkupV0yWxSoAfbb3zsa3Kv4dDq0gw/640?wx_fmt=jpeg&from=appmsg)

## **Java 生态进展**

在 openEuler RISC-V 上主要运行时生态中，Java 的软件包已经全部适配，软件包数量与 x86/aarch64 持平，其中 Java SIG 维护了其中的 600 余个软件包，其他 SIG 组适配了 100 余个，适配的软件包总数达到 730 余个。

开发者常用的 Eclipse IDE 已经在 openEuler 源码仓中获得了 riscv64 的支持，并且同时合入到了 24.03 分支及 master 分支。用户可以使用`dnf install eclipse` 命令直接进行安装。

除此之外 Hadoop、Flink、Hive、Hbase 以及 Spark 等大数据组件也都同时合入到了 openEuler 源码仓的 24.03 分支及 master 分支，预计将在 24.03 LTS SP1 版本中作为官方软件源发布。

运行时小组还维护着 11、17、21 等 JDK 的 LTS 版本、lastest 版本的 RISC-V 支持，向 openEuler 提交了多个 RISC-V 相关的 Patch，并且将代码贡献到 OpenJDK 上游社区。

## **Python 生态进展**

运行时小组目前同时正在进行的 Python 和 Python PGO 相关软件包的构建优化工作。

运行时小组持续维护着 python 相关的软件包，例如修复了 Pytorch 在 riscv64 上构建报错的问题，目前可以在 riscv64 上运行 pytorch，运行时小组也使用官网给出的 demo 顺利进行了测试。

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFHMicpWWsZnM1k2xt10bbwM4bIZWtZJth2MicIjvyWrR6eShdJazU2iaUnpalcGhibI1UX8EviapYBp8OQ/640?wx_fmt=png&from=appmsg)

此外，Python3.11.6 的 PGO 完成优化，开启 PGO 优化之后，riscv64 下的性能能够提升 20%（数据来自于 Pyperformance benchmark，硬件为荔枝派 4A 8G+32GB 版本），此特性预计将在 24.03 LTS SP1 版本中发布。

## **运行时生态后续工作计划**

最后，张定立介绍了团队后续的一系列其他计划，主要包括以下三个方面：

- OpenJDK 8 RISC-V Port 的 JIT 支持：目前有大量软件依赖 OpenJDK 8，可以说 OpenJDK 8 是 Java RISC-V Port 的最后一块拼图。根据 SPECjvm2008 的测试结果， 完成对 OpenJDK 8 的 JIT 支持可以使软件的运行效率提升约 40 倍。
- 升级 openEuler 构建默认的 JDK 版本。目前 openEuler 构建系统默认使用 OpenJDK 8，而其他 Linux 发行版都已经升级了 JDK 版本。升级 openEuler 的 JDK 版本不仅能够提升性能，也能为 OpenJDK 8 生命周期结束后的 openEuler Java 软件生态提供充足的生态构建和测试时间。
- .NET 运行时对 OERV RISC-V 的支持：作为 RISE(RISC-V Software Ecosystem) 重点关注的六个运行时之一，.NET 运行时 对 RISC-V 的支持在持续完善，未来 Java SIG 和 RISC-V SIG 将会持续适配 OERV 对 .NET 运行时支持工作。

如果你对运行时相关的代码贡献感兴趣，并且具备汇编、虚拟机以及编译器基础，欢迎加入 OERV，让我们共同参与到构建繁荣的 OERV 运行时生态的进程中。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/tkVlnC85sFHMicpWWsZnM1k2xt10bbwM4MqJ37dzgqIRrpMgCvKyicbw3Tjzv0yOgCNXGdDjsiclpHFzzlLpo9l8g/640?wx_fmt=jpeg&from=appmsg)

**中国科学院软件研究所 王经纬**

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/tkVlnC85sFHMicpWWsZnM1k2xt10bbwM4UfeU01BRGmhaZRP8vAiczIWQRGQzBwicKJVicJwSE6e8viasfwl4J4IStQ/640?wx_fmt=other&wxfrom=5&wx_lazy=1&wx_co=1)

**添加时请备注 OERV**
