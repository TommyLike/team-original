# [「转」一文了解ODD2023 Compiler SIG组开放工作会议内容！](https://mp.weixin.qq.com/s/5Ol2QCsGszsmoN3ZJ1XjDw)

*Compiler SIG*[OpenAtom openEuler](javascript:void%280%29;)*2023-04-28 18:12:00*

4月21日，作为openEuler Developer Day 2023重要的一环，Compiler SIG组开放工作会议圆满举行。本次Compiler SIG组开放工作会议主要围绕GCC、LLVM、BiSheng JDK的版本规划进行介绍，吸引了现场及线上开发者们的热烈讨论。

下面就让我们一起来回顾本次会议的精彩内容！

![](https://mmbiz.qpic.cn/mmbiz_jpg/icntuIQtpSJUvHqeBKfiaBrFkqeFpOKqDeFp6NbyCVjt02iaHjIo4KUPOHjH4p5TdvNGpZmKa4L9M5NianiaCYFIo8w/640?wx_fmt=jpeg)

**2023 GCC版本规划及特性前瞻**

openEuler Compiler SIG Maintainer李彦成给大家带来GCC编译器工作进展和未来规划议题。首先介绍当前GCC在基础性能、反馈优化、芯片使能、插件框架四个领域的工作进展；接着详细介绍GCC的升级策略和版本选型规划，明确当前GCC基线版本将在今年的23.09升级至GCC 12.3；最后介绍今年GCC领域的主要工作方向，包括基础性能、内核反馈优化以及动态反馈优化的工作细节。

![](https://mmbiz.qpic.cn/mmbiz_jpg/icntuIQtpSJUvHqeBKfiaBrFkqeFpOKqDexVCILo9PmiaWCu41KBnInkUvKvp2PMGOxNmzguYJZtcTOibIN92GYewA/640?wx_fmt=jpeg)

**LLVM选型介绍及后续工作规划**

openEuler Compiler SIG Maintainer、TC委员赵川峰老师介绍了LLVM编译器相关的工作规划，包括LLVM基线版本选型、多版本支持方案、性能/codesize优化、sanitizer支持及LLVM平行宇宙计划，其中LLVM平行宇宙计划引起了现场和线上开发者的极大兴趣，讨论非常热烈，该计划先独立于openEuler版本发布尝试使用 Clang/LLVM 构建的 openEuler更多的软件包，然后提供竞争力并发布基于LLVM技术栈的openEuler版本，当然困难和挑战也很大，希望通过社区协作式运作推进平行宇宙计划，同时也培养出更多的LLVM开发者。

![](https://mmbiz.qpic.cn/mmbiz_jpg/icntuIQtpSJUvHqeBKfiaBrFkqeFpOKqDeEUOo1ClaZLjnfEIqOw7KKcMibb4PicgbbAqvE2Hj10ZWKta5Oh6nx1Yw/640?wx_fmt=jpeg)

**BiSheng JDK DFX能力增强介绍及后续工作规划**

openEuler Compiler SIG Developer窦义望为大家带来了BishengJDK DFX能力增强及后续规划的议题。

议题首先介绍了DFX增强的主要特性包括：JCMD工具增强、JMAP 工具增强、TraceClassLoading增强、hs\_error\_pid文件增强、异步GC日志、Native(Glibc) Heap修剪等功能。

然后结合各功能点为大家详细介绍了当前JDK存在的问题，增强解决问题的方式，使用的场景与注意事项等等，并为大家展示了一些真实的案例和优化的效果。

最后向大家介绍了后续DFX增强的规划方向如：NMT baseline time、更加地丰富hs\_err信息等等。BiSheng JDK会保持持续改进，为业界提供一个易用性强、可维护性高、问题定位效率更快的JDK。

![](https://mmbiz.qpic.cn/mmbiz_jpg/icntuIQtpSJUvHqeBKfiaBrFkqeFpOKqDe1jRoBw9o0iahPx805agfl7xjGID4VsLsc4t7FNEHCGTZTLKGap4OxQQ/640?wx_fmt=jpeg)

![](https://mmbiz.qpic.cn/mmbiz_gif/icntuIQtpSJUvHqeBKfiaBrFkqeFpOKqDepgrAgpTFoOgDbn0iaK9yR0C0ZKx7EYVcSHMIZutB6kIHfHM5q5TibrFQ/640?wx_fmt=gif)

Compiler SIG 专注于编译器领域技术交流探讨和分享，包括 GCC/LLVM/OpenJDK 以及其他的程序优化技术，聚集编译技术领域的学者、专家、学术等同行，共同推进编译相关技术的发展。

扫码添加 SIG 小助手微信，邀请你进 Compiler SIG 微信交流群。

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJUvHqeBKfiaBrFkqeFpOKqDes4b3xliaz2kJDfk9Nlj7EaOhHm2rYwZk1DDGibOLaGElCytLyfOxibNdg/640?wx_fmt=png)

点击 **阅读原文** 了解更多鲲鹏编译工具链信息

[阅读原文](https://www.hikunpeng.com/zh/developer/devkit/compiler)
