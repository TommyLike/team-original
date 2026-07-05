# [华为在 Linux Kernel 5.10 中代码贡献排名第一](https://mp.weixin.qq.com/s/50V0PeqF-PnqoIQbCjBx3w)

原创*周荔人*[OpenAtom openEuler](javascript:void%280%29;)*2021-01-01 10:30:00*

The presence of Huawei at the top of the "by changesets" column may be a bit of a surprise, though something similar happened in 5.8. 94 developers working for Huawei who contributed at least one patch to 5.10. Huawei has built up a significant kernel-development operation. Beyond that, these results are mostly as one would expect.?

—— 自由软件媒体 LWN.net

**Linux Kernel 5.10 代码贡献，华为排名第一**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMafLt0SbT1dsvEg43dW41Z99zPoic9NRXzLiaic83kHeemsFZibkiarEHGzbl0M1g6NgOxUEXic5Peib5qug/640?wx_fmt=png)

在 Linux Kernel 5.10（下文简称“5.10 版本”）版本中，华为提交的补丁数量为1434个，占比8.9%，内核代码贡献排名第一，代码修改41049行，占比5.3%，代码修改行排名第二，自动内核缺陷发现机器人 HULK Robot 在内核 Bug 发现榜单上排名第二，发现了 15% 的内核 Bug。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMafLt0SbT1dsvEg43dW41Z9Rov5sawvHqApcTYmh5LvMYrnkJVXEE3ILFv6wWdGw4ZVAjfhwukMHg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMafLt0SbT1dsvEg43dW41Z9kJ2SmALjXfcF8FUA2jBgo4uJ1rmCXjNxydxWeHBhvSibZBmtce2eFOg/640?wx_fmt=png)

在 5.10 版本，华为的贡献主要在 ARM64 架构、ACPI、内存管理、文件系统、Media、内核文档以及海思芯片支持等方面。

- 在 ARM64 架构方面，增强了 ARM64 64K 页下的 RAID5 支持，写性能提升6倍，减少 stripe\_head 75% 的内存使用量。支持 per-NUMA ?的 CMA，提升性能；
- 在ACPI子系统方面，支持异构设备呈现为 NUMA 节点，以及 ACPI DFX 重构准备；内存管理优化了 slub free 的 slowpath，提升性能。
- 在文件系统上，F2FS 支持基于 Age-Threshold 垃圾回收/支持扩展的纯内存日志头管理以及 swap 分区加载提速优化，性能提升40倍。Mauro 作为文档和 Media 子系统的 Maintainer，做了大量 Media 以及文档改进工作，为内核文档直接生成 PDF 做了大量准备。
- 在海思芯片支持方面，新增了鲲鹏处理器以及 Hikey970 多个驱动支持以及驱动增强。
- 除了特性，华为的工程师针对整个内核贡献了大量质量加固的 bugfix，及代码重构，增强了整个内核的质量。

**开发者贡献榜单中的新面孔**

来自华为德国研究所的 Mauro 在 Media，内核文档和 hikey 驱动子系统做了很多的贡献。除了 Mauro 此外，还有 94 个来自华为的开发者给 5.10 版本做贡献。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMafLt0SbT1dsvEg43dW41Z9pQsdHiaEQAs3olCGialBmWWC4FCpkbcDtEX3vKWkVzoAcHdFDJBInHlA/640?wx_fmt=png)

在贡献开发者榜前20的榜单中，有三名华为的工程师

在贡献开发者榜单中，除了一些经常看到的大佬外，还有新面孔。例如来自华为 OS 内核实验室的缪晴朗。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMafLt0SbT1dsvEg43dW41Z9K7Kt5iaVE0bNstict4CxgtiaF1j090YykZVunel6SsgmEcVJ8ick6xrKeg/640?wx_fmt=jpeg)

华为 OS 内核实验室工程师缪晴朗

“对我自身而言，投入开源是自己的部分工作，亦是兴趣所在。作为从浙大毕业不到两年，投身于内核开发的新人，很荣幸自己登上了 5.10 版本的补丁贡献前 20 的榜单”

每个人都对自己的代码被合入 Linux Kernel 记忆犹新。

“我始终记着收到第一封社区回复时的激动，每天早上来公司打开邮箱前的期待，以及更多的每次补丁被接收时的暗喜与被认同感。而与社区的交流也在帮助我持续提升开发能力和对内核的理解。”

## **Linux Kernel 的重要性**

我们所说的 Linux 全称是 GNU/Linux，这是由自由软件基金会的定义的。Linux 原本指的只有一个 Linux Kernel。从技术上说，Linux 只是一个符合 POSIX 标准的内核。它提供了一套应用程序接口（API），通过接口用户程序能与内核及硬件交互。

对于开发者来说，Linux Kernel 中包含最底层的操作系统逻辑，同时 Linux Kernel 作为硬件和软件的通道，一些硬件功能必须要在 Kernel 层面做支持，硬件才能正常的运行，要发挥出硬件的极致性能，还要在Kernel层面的软件上做调优。所以掌握 Linux Kernel 的代码，，其重要性可见一斑。

但在 LWN.net 的文章中，有这样的一段话：

A?total?of?1,971?developers?contributed?to?5.10?—?again,?just?short?of?the?record?set?by?5.8.?Of?those?developers,?252?(just?under?13%)?made?their?first?contribution?in?5.10;?that?is?the?lowest?number?seen?since?5.6

华为自2012年以来向 Linux Kernel 社区贡献第一个补丁以来，8年来不断增加对 Linux Kernel 社区的投入，从1个补丁1个开发者参与到1434个补丁95个开发者参与，从0个 Maintainer 到26个 Maintainer。在代码贡献上，华为除了代码日常维护，Bug修复外，还将在 Linux 服务器操作系统领域中发现的新特性贡献给 Linux Kernel 社区。

华为一直在遵循“贡献”“开放”的开源精神。通过切切实实的行动，解决一些 Linux Kernel 社区目前存在的问题，欢迎更多的开发者加入到 Linux Kernel 社区当中，让这个汇集了全球开发者智慧的 Linux Kernel 更加的枝繁叶茂。

华为除了在 Linux Kernel 上不断贡献，还在其主导开源的 openEuler 社区中做着新的探索。

在刚刚发布的 openEuler 20.03 LTS SP1 版本中，openEuler 社区将 openEuler 20.09 创新版中的特性加入到 openEuler 20.03 LTS SP1 中，欢迎大家下载体验。

**Release Notes**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMafLt0SbT1dsvEg43dW41Z9rKCs7sagZeLcZ3I19ZXKoJxOia8JlrKuls33JMvrsJ1XWvvclJScljg/640?wx_fmt=png)

**下载链接**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMafLt0SbT1dsvEg43dW41Z9xZKXbKqcKz8Ket7PMMp7HAYu75ADAwHF2oJtTAnWKqfdhkJQicMbh5w/640?wx_fmt=png)
