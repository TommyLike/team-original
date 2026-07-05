# [openEuler Kernel 技术分享第 20 期 ｜ 执行实体创建与切换](https://mp.weixin.qq.com/s/Kf_h0j8G24z5F0etaZkTPA)

*Kernel SIG*[OpenAtom openEuler](javascript:void%280%29;)*2022-06-21 18:37:43*

openEuler Kernel SIG 会持续规划一些技术议题，欢迎正在阅读的你一起加入，分享与探讨内核技术。

凡事皆有成本，进程、线程、协程都以成本为核心演进。上期分享讲解了理想状态下的调度算法及其工程演进。本次分享将以成本为主线，讲解进程、线程、协程等执行实体的演进及线程的切换。

## 活动信息

- 时间：2022 年 6 月 24 日 14:10
- 主办：openEuler Kernel SIG
- 培训链接：https://us06web.zoom.us/j/83567640355?pwd=OHVRQ2VKcFNka0FhVjg2emQybG1Edz09

## 往期回顾

openEuler Kernel 技术分享合集：https://space.bilibili.com/527064077/channel/collectiondetail?sid=15008

## 参与项目

可以通过代码仓库、邮件列表、issue、bugzilla 参与社区讨论。

欢迎大家多多讨论问题，多多 Star，多多参与社区开发，多多贡献补丁，发现问题多提 issue、bugzilla。

- 代码仓库：https://gitee.com/openeuler/kernel
- 邮件列表：kernel@openeuler.org
- issue：https://gitee.com/openeuler/kernel/issues
- bugzilla：https://bugzilla.openeuler.org/

## 技术交流群

请扫描下方二维码添加小助手微信

备注“交流群”或“技术交流”

加入 openEuler Kernel SIG 技术交流群

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZiaQxZSLq1qy0Qnb853YXYgDqWWwCX8aW1ULiaiasBXpDZn0hTdyjMRO81VibTxh7s2zbmiaRMGRaNkfQ/640?wx_fmt=png)
