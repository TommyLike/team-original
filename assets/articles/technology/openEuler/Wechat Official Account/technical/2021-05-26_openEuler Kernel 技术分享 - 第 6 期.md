# [openEuler Kernel 技术分享 - 第 6 期](https://mp.weixin.qq.com/s/70tPi9pBZxLSFFtGec_NZw)

[OpenAtom openEuler](javascript:void%280%29;)*2021-05-26 18:00:00*

openEuler Kernel SIG 会持续规划一些技术议题，欢迎正在阅读的你一起加入，分享与探讨内核技术。

SMMU 提供类似于 MMU 的地址映射功能，主要用于隔离外设可访问的内存资源。内核态的 MMU 地址映射基本固定不变，但外设的 SMMU 地址映射需要频繁动态申请、释放、映射和取消映射，因此需要额外的管理开销，在压力场景会形成性能瓶颈。

本次讲座介绍内核针对上述瓶颈点，对 SMMU+IOVA 所做的性能优化。

# 活动信息

- 时间：2021 年 5 月 28 日 14:00
- 主办：openEuler Kernel SIG
- 培训链接：https://welink-meeting.zoom.us/j/228346735

# 往期回顾

- openEuler kernel 技术分享 - 第 1 期 -- kdump 基本原理、使用及案例介绍：https://www.bilibili.com/video/BV1M64y1Q7yp
- openEuler kernel 技术分享 - 第 2 期 - 从 ARM 和 RISC-V 架构看体系结构对 Linux 操作系统的支持：https://www.bilibili.com/video/BV14p4y1b76g
- openEuler kernel 技术分享 - 第 3 期 - Crash 工具基本使用及实战分享：https://www.bilibili.com/video/BV1mQ4y1Z7BQ
- openEuler kernel 技术分享 - 第 4 期 - PCI 子系统介绍：https://www.bilibili.com/video/BV1fq4y177pj

### openEuler Kernel 代码仓库

https://gitee.com/openeuler/kernel

欢迎大家多多 Star，多多参与社区开发，多多贡献补丁。

### maillist、issue、bugzilla

可以通过邮件列表、issue、bugzilla 参与社区讨论

欢迎大家多多讨论问题，发现问题多提 issue、bugzilla

- https://gitee.com/openeuler/kernel/issues
- https://bugzilla.openeuler.org/
- kernel@openeuler.org

### openEuler Kernel SIG 微信技术交流群

请扫描下方二维码添加小助手微信

备注“交流群”或“技术交流”

加入 openEuler kernel SIG 技术交流群

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbYjCEqh4SNTb265UibqSRU9EysuQ8iaibH6ib4eOFdj9mGCIwU6hBjyCcDFrUYnBtqyTHJ83rRUuiar5Q/640?wx_fmt=png)
