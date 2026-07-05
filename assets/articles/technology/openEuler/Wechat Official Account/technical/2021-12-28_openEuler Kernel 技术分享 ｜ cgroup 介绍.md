# [openEuler Kernel 技术分享 ｜ cgroup 介绍](https://mp.weixin.qq.com/s/G0ebYLvUrHRZ6umYMWAZEQ)

[OpenAtom openEuler](javascript:void%280%29;)*2021-12-28 22:45:07*

openEuler Kernel SIG 会持续规划一些技术议题，欢迎正在阅读的你一起加入，分享与探讨内核技术。

cgroup 是内核提供的一种可以限制、记录、隔离进程组所使用的物理资源的机制。本次分享主要针对 cgroup 的整体结构，cgroupv1 与 cgroupv2 的异同，cgroup 的发展等内容进行介绍。

## 活动信息

- 时间：2021 年 12 月 31 日 14:10
- 主办：openEuler Kernel SIG
- 培训链接：https://us06web.zoom.us/j/83118407147?pwd=elVzMVhGc2YzaDQ1TGorN2tPa1NhZz09

## 往期回顾

- openEuler Kernel 技术分享 - 第 1 期 -- kdump 基本原理、使用及案例介绍：https://www.bilibili.com/video/BV1M64y1Q7yp
- openEuler Kernel 技术分享 - 第 2 期 - 从 ARM 和 RISC-V 架构看体系结构对 Linux 操作系统的支持：https://www.bilibili.com/video/BV14p4y1b76g
- openEuler Kernel 技术分享 - 第 3 期 - Crash 工具基本使用及实战分享：https://www.bilibili.com/video/BV1mQ4y1Z7BQ
- openEuler Kernel 技术分享 - 第 4 期 - PCI 子系统介绍：https://www.bilibili.com/video/BV1fq4y177pj
- openEuler Kernel 技术分享 - 第 5 期 - ARM 架构学习资料分享：https://www.bilibili.com/video/BV13g41137No
- openEuler Kernel 技术分享 - 第 6 期 - SMMU 驱动性能优化：https://www.bilibili.com/video/BV1TK4y1g7vv
- openEuler Kernel 技术分享 - 第 7 期 - SVM 介绍：https://www.bilibili.com/video/BV1oU4y1n7Qn
- openEuler Kernel 技术分享 - 第 8 期 - Bpf map 介绍：https://www.bilibili.com/video/BV1W44y1m7vt
- openEuler Kernel 技术分享 - 第 9 期 - Bpf trace 介绍：https://www.bilibili.com/video/BV1Cf4y1P7va
- openEuler Kernel 技术分享 - 第 10 期 - UADK 用户态通用加速器框架介绍：https://www.bilibili.com/video/BV1uh411q7kb
- openEuler Kernel 技术分享 - 第 11 期 - Top-Down 性能分析方法介绍：https://www.bilibili.com/video/BV1MU4y1A7mK
- openEuler Kernel 技术分享 - 第 12 期 - openRSO-解决混部应用的访存时延干扰：https://www.bilibili.com/video/BV1nQ4y1C7Gp
- openEuler Kernel 技术分享 - 第 13 期 - ftrace 框架及指令修改机制：https://www.bilibili.com/video/BV1KU4y1g74a
- openEuler Kernel 技术分享 - 第 15 期 - kaslr 内核安全特性：https://www.bilibili.com/video/BV1RR4y1s72T
- openEuler Kernel 技术分享 - 第 16 期 - openEuler 内核热补丁介绍：https://www.bilibili.com/video/BV1Ab4y1v7EN

## 代码仓库、maillist、issue、bugzilla

可以通过代码仓库、邮件列表、issue、bugzilla 参与社区讨论。

欢迎大家多多讨论问题，多多 Star，多多参与社区开发，多多贡献补丁，发现问题多提 issue、bugzilla。

- 代码仓库：https://gitee.com/openeuler/kernel
- 邮件列表：kernel@openeuler.org
- issue：https://gitee.com/openeuler/kernel/issues
- bugzilla：https://bugzilla.openeuler.org/

## 微信交流群

请扫描下方二维码添加小助手微信

备注“交流群”或“技术交流”

加入 openEuler Kernel SIG 技术交流群

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYMpuNmYs3fia9ic0iaqATPSd7ugCf77IxgaU0raYpdgsCNcMGpll1iaqGI0fsN9DMBl4SfWHZTKOuhtw/640?wx_fmt=png)
