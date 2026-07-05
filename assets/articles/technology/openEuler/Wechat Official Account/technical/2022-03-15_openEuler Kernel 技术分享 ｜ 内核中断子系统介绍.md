# [openEuler Kernel 技术分享 ｜ 内核中断子系统介绍](https://mp.weixin.qq.com/s/KB78k6Pn6TJPiIWVKMFZNA)

[OpenAtom openEuler](javascript:void%280%29;)*2022-03-15 20:43:48*

openEuler Kernel SIG 会持续规划一些技术议题，欢迎正在阅读的你一起加入，分享与探讨内核技术。

中断子系统是内核为设备驱动提供中断处理的完整抽象以适配不同的中断控制器硬件的机制。本次分享从内核中断机制的实际需求出发，用软件设计的角度解释内核中断子系统的设计思路。

# 活动信息

- 时间：2022 年 3 月 18 日 14:10
- 主办：openEuler Kernel SIG
- 培训链接：https://us06web.zoom.us/j/82640076508?pwd=MktwWWxWR3ZqNFF4SlgwdGhwNlNDZz09

# 往期回顾

openEuler Kernel 技术分享合集：https://space.bilibili.com/527064077/channel/collectiondetail?sid=15008

# 参与项目

可以通过代码仓库、邮件列表、issue、bugzilla 参与社区讨论。

欢迎大家多多讨论问题，多多 Star，多多参与社区开发，多多贡献补丁，发现问题多提 issue、bugzilla。

- 代码仓库：https://gitee.com/openeuler/kernel
- 邮件列表：kernel@openeuler.org
- issue：https://gitee.com/openeuler/kernel/issues
- bugzilla：https://bugzilla.openeuler.org/

# 技术交流群

请扫描下方二维码添加小助手微信

备注“交流群”或“技术交流”

加入 openEuler Kernel SIG 技术交流群

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZDWe1ibxviabrKtaX5WCmsaasLzHyn0KBaDyW62lu5ZqOkxic58MsTVPHjmypro2qxyYN2M266FgWXg/640?wx_fmt=png)
