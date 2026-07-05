# [openEuler Kernel 技术分享第 19 期 ｜ 内核调度器简史](https://mp.weixin.qq.com/s/Ioh8P4tpZ5uYAIoit1g5Kg)

*Kernel SIG*[OpenAtom openEuler](javascript:void%280%29;)*2022-05-17 22:04:21*

openEuler Kernel SIG 会持续规划一些技术议题，欢迎正在阅读的你一起加入，分享与探讨内核技术。

调度子系统解决的问题很简单：合理地将task调度到CPU上运行。但要做到合理，调度器的实现又极其复杂。本次分享以调度器发展的历史为主线，一起洞察其中的变与不变。

## 活动信息

- 时间：2022 年 5 月 20 日 14:10
- 主办：openEuler Kernel SIG
- 培训链接：https://us06web.zoom.us/j/81837728501?pwd=THk0TnBjc0ZFbXJ0ZnlJTzBxVCtWUT09

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

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbcwhCibvJrLF3ia0wGiczd4Yul3ibgByXG76Igc0XQnITPHXnoWwtexMq9UPiciaYbws56mrIPOChIAuOg/640?wx_fmt=png)
