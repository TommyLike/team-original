# [OpenStack社区CI正式支持 openEuler](https://mp.weixin.qq.com/s/uvgPDvbKzzVh218CZD3ASA)

[OpenAtom openEuler](javascript:void%280%29;)*2022-01-05 18:54:46*

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMY6q3qwt3OKkrOicqKacaX9TaNJDh2pLeKltZ7IauLDcx74elLPXSMdtcibnDf8TOicKA7EOL8HbRVqA/640?wx_fmt=png "vertical-left.png")

2021年的最后一天，openEuler OpenStack SIG为OpenStack和欧拉开源社区的众多开发者带来了2022年的新年礼物: **openEuler成功进入OpenStack官方CI测试操作系统列表**，并且OpenStack开发者最广泛使用的DevStack正式官方支持 openEuler\[1]！

一款开源软件对于操作系统的支持通常可以归纳为如下的流程（以openEuler为例）：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMY6q3qwt3OKkrOicqKacaX9T7agIyG53l2icOEcxx7uc4DrBmcS8xX8RFsu367xY6KCibCWVAnKtlKbw/640?wx_fmt=png)

开发者在本地开发上游软件时首先会根据其目标场景选择相应的架构、硬件、操作系统等相关软硬件，在完成本地开发和验证后，会将代码提交到上游社区，上游社区通常提供了自动化的CI验证机制对开发者提交的代码进行全面的验证，只有通过了验证并且经上游社区Maintainer认可后才能将代码合入上游社区主干。

由于各个硬件、操作系统等不尽相同，如果上游社区中没有对应体系的CI验证机制，则无法保证该软硬件体系上所进行的开发活动的质量。**因此将 openEuler 推入到上游社区中作为CI验证机制的一部分，可以提供上游社区开发在openEuler上的质量保证**。openEuler社区同时还为上游社区软件发布了适配不同平台的软件包及相关的使用与迁移指导，可以为不同平台的用户提供方便、可靠的解决方案，极大的方便了用户的使用。

下面我们来回顾一下OpenStack社区上游对于openEuler支持的相关工作是如何开展的，这项工作始于2020年Q4，在中国开源黑客松活动上，来自华为和Linaro的OpenStack及openEuler开发者讨论了OpenStack支持openEuler的可能，并现场经过两天时间的开发，完成了POC原型验证，并做了相应的成果展示，证明了**OpenStack + openEuler的基本可用性。**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMY6q3qwt3OKkrOicqKacaX9T96mwdzhhC9qM3VnicHibbCzK7Ok233icDE2IxKGo6qicUPul5PtugXyu6A/640?wx_fmt=png)

2021年初，来自华为、Linaro、联通数科、中国电信等企业、组织的开发者在openEuler社区中成立了OpenStack SIG，致力于将OpenStack与openEuler两大开源社区更好结合，为用户提供开放、可靠的云基础设施技术栈，来自Linaro的开发者主动承担了在OpenStack上游社区推动openEuler支持的工作，正式展开了相关的技术讨论，通过在OpenStack社区的Infra SIG和Multi-Arch SIG的汇报和讨论。社区在经过一段时间的观察后，认可了openEuler在操作系统领域内的影响力、活跃度，openEuler社区开放的治理方式以及openEuler OpenStack SIG各成员的技术能力。在慎重考虑后，同意了在OpenStack社区中提供openEuler支持的工作，并且计划支持x86、aarch64多架构。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMY6q3qwt3OKkrOicqKacaX9Tx4eYWNESvHE1eObNLbfyhw2CzB0xTSo3BLgLfv9cbOsrCJ25ZvmhBg/640?wx_fmt=png)

2021年中，来自Linaro的开发者在OpenStack上游社区完成了openEuler镜像构建工作\[2]，这为openEuler支持打下了基础，于此同时来自华为的开发者也完成了openEuler接入OpenStack上游CI资源池的相关工作。最终在近期**正式完成了openEuler引入OpenStack社区的工作**\[3]。现在OpenStack上游社区不仅有了CI保证openEuler的质量，同时用户也能通过DevStack快速部署一套基于openEuler的OpenStack环境。

DevStack是OpenStack社区官方开发的OpenStack快速部署套件，用于根据git master的最新版本或指定版本快速构建完整的OpenStack环境。是日常OpenStack开发人员必备的开发套件，并且在OpenStack所有项目的CI测试中都使用DevStack来进行相应的环境部署\[4]。本次DevStack支持openEuler后，不仅为广大的OpenStack和openEuler开发者的开发工作提供了极大的帮助，也为OpenStack中更多项目上游CI在openEuler上的验证提供了技术基础。

于此同时，openEuler OpenStack SIG在openEuler的20.03 LTS、21.03、21.09等多个版本中完成了OpenStack的Queens、Rocky、Train、Victoria、Wallaby等多个版本的OpenStack核心组件的适配、验证以及软件包发布工作\[5]，为openEuler用户提供了好用、易用的OpenStack软件，后续还将继续致力于推动OpenStack中各主要组件社区上游对openEuler的集成验证以及各组件在openEuler上的适配、调优以及与openEuler社区创新项目的集成。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMY6q3qwt3OKkrOicqKacaX9T0F7BwDYr9VNKwjLs0ibqia5SMCHNib80UOe630p1kuNoFDic1sIauSAoVQ/640?wx_fmt=png)

openEuler接入OpenStack社区上游离不开来自两个社区众多开发者的通力合作，在这里对贡献者表示感谢：

**Open Infrastructure Foundation**: Clark Boylan、Ian Wienand、Jeremy Stanley、李昊阳、Rico Lin

**OpenStack QA SIG:**  Dr. Jens Harbott、Rados?aw Piliszek,

**openEuler OpenStack SIG:** 陈锐、陈硕、黄填华、李昆山、李佳伟、刘新良、刘胜、王玺源、姚志聪、张迎、张帆、赵帅、郑振宇

参考链接：

\[1]https://review.opendev.org/c/openstack/devstack/+/760790

\[2]https://review.opendev.org/c/openstack/diskimage-builder/+/784363

\[3]https://zuul.opendev.org/t/openstack/job/devstack-platform-openEuler-20.03-SP2

\[4]https://docs.openstack.org/devstack/latest/#quick-start

\[5]https://gitee.com/openeuler/openstack
