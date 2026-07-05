# [UKUI3 支持 openEuler 22.03 LTS](https://mp.weixin.qq.com/s/77FXKYwHpHUXkGddwI7dIQ)

[OpenAtom openEuler](javascript:void%280%29;)*2022-04-20 08:55:09*

openEuler Developer Day 2022 全面解析欧拉完成正式捐赠后发布的首个共建社区版本 openEuler 22.03 LTS 的最新特性，展示社区伙伴的联合创新成果，UKUI3也如期实现了与其完美适配。

在openEuler21.09集成的 UKUI 桌面环境基础上，UKUI3对网络插件、登录程序和定时关机等系统组件进行了优化，累计解决了200+桌面环境和应用软件方面的问题，全面提升了系统稳定性及安全性。

  **外观方面**

UKUI3的外形经过了全新设计，用柔和的色彩，圆润温和的设计风格给用户以全新的感受。

![](https://mmbiz.qpic.cn/mmbiz_jpg/sItxdKiamINotD7kWohicQO835p1jJKI1eKRFNjV8ahhvfOkc7karC6sfZQUhibcSSicKnHricnriaribpdTjoIcgyvoA/640?wx_fmt=jpeg)

**无微不至—夜间模式功能**

支持的浅色主题和深色主题，采用块状底色分隔视觉区域，去除多余的分割线，让用户更易于聚焦内容，实现了系统整体风格的一致性。灰黑色背景配上浅色文字拥有更低的对比度，更具可读性，减少眼睛疲劳。

![](https://mmbiz.qpic.cn/mmbiz_jpg/sItxdKiamINotD7kWohicQO835p1jJKI1ef2YPNrcw6lSMu0jpLcjYNnzz47R5jajOyqa1c9aHcThXtYce3NAg8g/640?wx_fmt=jpeg)

**预览先行—任务栏预览功能**

全新预览图功能登场，让用户更加清楚自己每个操作能给界面带来的崭新变化。窗口预览功能可通过鼠标悬浮即时呼出，并会随开启窗口的多少，自动调节预览窗口的大小。在认知范围内给用户微小而确实的幸福体验。

![](https://mmbiz.qpic.cn/mmbiz_png/sItxdKiamINotD7kWohicQO835p1jJKI1eqrv23bYG5mX5aibqicWffcO6XJSonFHIRnxB0VgEcWSqhJ0dwF1E37iaA/640?wx_fmt=png)

**便捷助手—侧边栏的剪贴板**

侧边栏一分为二，上半部分专管通知，下半部分为剪贴板和小插件操作，结构上更清晰，用户可通过任务栏的通知区域，快速访问侧边栏。剪贴板支持历史记录及编辑功能，满足用户的多种需求，更有效的提升操作效率。

![](https://mmbiz.qpic.cn/mmbiz_jpg/sItxdKiamINotD7kWohicQO835p1jJKI1etxlEFJWfDtP87ly6xMJf9icvDiaGu8dxzicEjib1oWjjggJ246vafvqzRQ/640?wx_fmt=jpeg)

**智能布局—开始菜单的全屏模式**

全新的开始菜单，提供智能记忆常用应用列表功能及搜索功能，默认和全屏尺寸切换随心所欲。用户可通过右上角的扩展按钮，一键切换全屏模式。

![](https://mmbiz.qpic.cn/mmbiz_png/sItxdKiamINotD7kWohicQO835p1jJKI1eL8vL6rvq0eIrhVWkB6LdUvpm9lcznJwjHaLb8EYxr4aR7cFnLSzlKQ/640?wx_fmt=png)

**快捷跳转—文件管理器的标签页功能**

文档管理器作为系统中使用频率最高的一个组件，UKUI3为其增加了一个非常实用的功能--标签页（Tab页），方便用户快速的在当前窗口同时打开多个文件夹。

![](https://mmbiz.qpic.cn/mmbiz_png/sItxdKiamINotD7kWohicQO835p1jJKI1eX6vCOMVe5iaeYpXT11tUI0JBRYwH7tkpfD5RfvHz2fib6Scf3Re6EHrg/640?wx_fmt=png)

**全能向导—文件管理器的高级搜索功能**

另一个为承载文档管理器繁多数据而生的功能，是全新重构的高级搜索。UKUI3打破原有结构，将文件管理器的搜索栏和地址栏合二为一，其支持的多重搜索过滤器机制，能帮助用户快速精准的搜索自己想要的文件。

![](https://mmbiz.qpic.cn/mmbiz_png/sItxdKiamINotD7kWohicQO835p1jJKI1e6KUiawEBHOAd4WpaeL5Xm7YNPNQEXUQ67HqQrPhsExDaESVwRicDMO2Q/640?wx_fmt=png)

  **安装方法**

1\. 安装UKUI桌面环境

yum install ukui

2\. 设置图形界面启动

systemctl set-default graphical.target

注：UKUI默认不开启root用户登录，安装前请先创建普通用户或管理员用户。

  **问题反馈**

在使用欧拉版本中的UKUI时，如果遇到问题或者有好的建议，均可提到UKUI在码云的各个仓库中。如果不确定问题或建议所属的仓库，也可以提到

https://gitee.com/openkylin/ukui-issues。
