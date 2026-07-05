# [openEuler Kernel 技术分享 ｜ openEuler内核的PCI子系统介绍](https://mp.weixin.qq.com/s/SjuroUHBtDRG21xHAYPOdQ)

原创*Kernel SIG*[OpenAtom openEuler](javascript:void%280%29;)*2021-04-29 12:17:46*

PCI设备与其他设备有什么不同，PCI设备的BDF号是什么意思，openEuler的内核是怎么组织和初始化PCI设备的，当我们碰到PCI设备驱动初始化失败时应该怎么去分析定位？

本期技术分享，将结合实际对openEuler内核的PCI子系统进行介绍。

## 分享介绍

- 主讲人：汪雄峰
- 时间：2021年4月30日 14:00（本周五下午2点）
- 主办：openEuler Kernel SIG
- 培训链接：https://welink-meeting.zoom.us/j/795275194

## 关于 openEuler kernel 技术分享

openEuler kernel SIG 会持续规划一些技术议题，欢迎正在阅读的你一起加入，分享与探讨内核技术。

## 关于 openEuler kernel SIG

- 源代码仓库：https://gitee.com/openeuler/kernel
- bugzilla：https://bugzilla.openeuler.org
- maillist：kernel@openeuler.org
- issule：https://gitee.com/openeuler/kernel/issues

可以通过邮件列表、issue、bugzilla 参与社区讨论，欢迎大家多多讨论问题，发现问题多提 issue、bugzilla。

## openEuler kernel SIG 微信技术交流群

请扫描下方二维码添加小助手微信

备注“交流群”或“技术交流”

加入 openEuler kernel SIG 技术交流群

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZaDvjBweicHyopmZYXVRqq7EaXicf8MhvyKcwxvoW8Jlic31iaUetqaJsCa5o1qPKcUXJBIMH6fW2ErA/640?wx_fmt=png)

## 往期回顾

- openEuler Kernel 技术分享 - 第 1 期 -- kdump 基本原理、使用及案例介绍：https://www.bilibili.com/video/BV1M64y1Q7yp
- openEuler kernel 技术分享 - 第2期 - 从ARM和RISC-V架构看体系结构对Linux操作系统的支持：https://www.bilibili.com/video/BV14p4y1b76g
- openEuler kernel 技术分享 - 第3期 - Crash工具基本使用及实战分享：https://www.bilibili.com/video/BV1mQ4y1Z7BQ
