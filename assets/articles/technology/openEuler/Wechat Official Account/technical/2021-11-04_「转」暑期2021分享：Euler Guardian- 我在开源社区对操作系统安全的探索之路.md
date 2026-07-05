# [「转」暑期2021分享：Euler Guardian- 我在开源社区对操作系统安全的探索之路](https://mp.weixin.qq.com/s/FxQwojNwYBAU3XSMsBfS-A)

*黄海波*[OpenAtom openEuler](javascript:void%280%29;)*2021-11-04 17:30:00*

![](https://mmbiz.qpic.cn/mmbiz_jpg/d7cX574lCK2lUT7GbyDMBEicw9LSDe1pLwgqic8X0eqh6dCsG2CI0Xo0B1iaUSb3XNl27KfS70rVibLVqa5ibLsbwiaQ/640?wx_fmt=jpeg)

* * *

![](https://mmbiz.qpic.cn/mmbiz_png/sJlRxQDfUeFm8RgEbUHwqTNQPA5AI02Omicy4udmUVLvdicEUibWA4VnNw0RmNnkTc5znOrd8jiabe9aJfHefpOuhg/640?wx_fmt=png)

前言

在参与summer 2021之前，我参加过一些国内外的开源项目如Wuhan2020，也为COSCon’20做过线上志愿者。

2020年秋天，我在严飞老师的指导下对刚刚出世的openHarmony OS内核进行源代码分析和安全性分析，开始关注开源操作系统的安全性问题。在华为武汉研究所，我了解到了华为的操作系统家族：面向全场景的Harmony OS, 主打服务器的Euler OS和IoT方面的Lite OS。

今年7月，我了解到summer 2021中openEuler社区的“操作系统安全漏洞扫描与报警项目”，并邮件联系了魏建刚老师，我的企业导师。在不断修改了4版架构设计后，我正式开始开发Euler Guardian。

![](https://mmbiz.qpic.cn/mmbiz_png/sJlRxQDfUeFm8RgEbUHwqTNQPA5AI02Omicy4udmUVLvdicEUibWA4VnNw0RmNnkTc5znOrd8jiabe9aJfHefpOuhg/640?wx_fmt=png)

操作系统安全与开源社区的挑战

![](https://mmbiz.qpic.cn/mmbiz_png/nicUAzFsiaL3ZwzCbUfmX2NqMicEptqcJTNibWibfwX5hrOEqdGMYgOyArZ2w0lNqMs94JbAbBBkcpLF8aqf1SuXGoA/640?wx_fmt=png)

硬件结构的安全和操作系统的安全是信息系统安全的基础，密码、网络安全等是关键技术。

---引自严飞教授2012年《计算机安全与保密》课程PPT，观点出自张焕国教授

对于操作系统，生态决定了它能走多远。而对于开源操作系统，它的繁荣和发展有赖于contributer不断为它注入活力。从Linus发布第一个Linux内核起，开源操作系统逐步走进人们的生活，取代了教学用的MINIX和商用的UNIX，发展出许多欣欣向荣的开源社区，方便了无数人的生活。而操作系统安全，作为信息系统安全的基础，一直被安全研究人员和安全工程师所关注。

安全是具有木桶效应的，开源操作系统安全更是如此。无论是openHarmony OS还是openEuler OS，都不是“孤岛”，它们的安全性受到使用场景、安全策略配置、软件依赖等各个方面的影响。所以，并不存在“绝对的安全”，只能通过及时发现安全风险，提高攻击难度，达到相对的安全。

对于开源操作系统的开发者，他们更关心一个新release的操作系统本身是否符合安全的标准；而对于使用操作系统的普通用户、运维人员，他们还关心如果系统受到入侵，该如何排查、溯源、进行应急响应。开源操作系统的安全越来越被关注，这些都为开源社区提出新的挑战。

![](https://mmbiz.qpic.cn/mmbiz_png/sJlRxQDfUeFm8RgEbUHwqTNQPA5AI02Omicy4udmUVLvdicEUibWA4VnNw0RmNnkTc5znOrd8jiabe9aJfHefpOuhg/640?wx_fmt=png)

Euler Guardian: 一次开源实践

现在的Euler Guardian有一个1.1 Beta版和一个1.2 Alpha版，它是为openEuler community开发，面向所有Linux操作系统的风险评估系统。能够基于本地扫描，发现操作系统中安全配置、软件依赖、访问控制等风险, 并对风险分级，生成报告；能够在Linux服务器受到入侵时，提供快速自动化的应急响应的能力。

在当前的版本中，Euler Guardian具有本地扫描、应急响应、风险评估和可视化四个模块。

本地扫描模块完成安全策略检查、软件依赖CVE检查等本地扫描。应急响应模块主要面向Linux收到入侵时的使用场景，使运维工程师能快速进行应急响应。风险评估模块对扫描结果风险分级。可视化模块提供CLI界面，生成HTML报告。

本地扫描模块共有5个部分，包含从操作系统本身安全策略配置，用户身份检查与访问控制到软件依赖CVE检查等安全检查项。

![](https://mmbiz.qpic.cn/mmbiz_png/d7cX574lCK3J47oNAh3XicrJ34A8CicTWbuALAXFhbkTUXZQI9B7aybm6yCrEopOL2ib2ZnI0Yws98vn8gKKqqEoQ/640?wx_fmt=png)

应急响应模块也包含5个部分，分别对文件、进程等进行检查。

![](https://mmbiz.qpic.cn/mmbiz_png/d7cX574lCK3J47oNAh3XicrJ34A8CicTWbZ0uOCjicnTwwqDiaJOtj1Ehjl0P1llxTScnCllXq96MgaCdZ2Siblm3Pw/640?wx_fmt=png)

项目代码、文档及结果演示详见仓库。

https://gitlab.summer-ospp.ac.cn/summer2021/210010493

![](https://mmbiz.qpic.cn/mmbiz_png/sJlRxQDfUeFm8RgEbUHwqTNQPA5AI02Omicy4udmUVLvdicEUibWA4VnNw0RmNnkTc5znOrd8jiabe9aJfHefpOuhg/640?wx_fmt=png)

关键技术问题

# 项目开发过程中遇到了的一些问题及解决在仓库的文档里都写得比较详细了，这里只讲在本地扫描模块开发过程中的一个问题“不依赖包管理器进行CVE检查”。

操作系统的安全有赖于每一个软件依赖的安全。检查软件依赖的CVE, 基础的想法是通过包管理器列出软件包版本然后CPE匹配检查。例如， 使用apt时， 可以用apt list --installed来列出已经安装的软件包及其版本, 通过软件包版本检索其对应的CVE和是否patch。

Linux发行版众多，使用多种包管理器，常见的有yum, apt, snap等等。如果软件包版本漏洞匹配基于软件包管理器来做，将会需要根据不同的包管理器分类，一一进行检测匹配。

OVAL, Open Vulnerability Assessment Language, 即开放式漏洞评估语言。OVAL由MITRE公司开发，是一种用来定义检查项、 脆弱点等技术细节的一种描述语言。OVAL的核心是Open，也很符合开源运动的思想。OVAL使用标准的XML格式组织其内容。能够清晰地对与安全相关的检查点作出描述，且是机器可读的，能够直接应用到自动化的安全扫描中。根据操作系统的名称和版本，使用对应的基线库，即可利用oscap进行扫描。这样，具体代码实现就变得清晰了。首先安装oscap，然后根据操作系统及版本选取基线库，使用对应的或者通用的基线库进行检查。

![](https://mmbiz.qpic.cn/mmbiz_png/sJlRxQDfUeFm8RgEbUHwqTNQPA5AI02Omicy4udmUVLvdicEUibWA4VnNw0RmNnkTc5znOrd8jiabe9aJfHefpOuhg/640?wx_fmt=png)

展望未来

本项目基本满足了使用场景中的使用需求，兼容性较好，可在多种Linux操作系统中运行。具有较为完善的安全策略，能够自动化地完成对操作系统的安全性分析，并CLI输出风险分级信息或生成较为完善的HTML报告。

就当前版本收到的反馈来看，Euler Guardian的当前版本能够基本满足本地扫描和应急响应的需求，但在用户交互、自定义安全策略、测试组件插件化等方面仍需提升。在将来，我也会不断根据收到的反馈对项目进行优化。
