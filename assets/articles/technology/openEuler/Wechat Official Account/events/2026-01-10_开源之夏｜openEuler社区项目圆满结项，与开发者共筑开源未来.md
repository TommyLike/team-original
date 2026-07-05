# [开源之夏｜openEuler社区项目圆满结项，与开发者共筑开源未来](https://mp.weixin.qq.com/s/V6xdSmqOq1ER9HHxkX-aSQ)

[OpenAtom openEuler](javascript:void%280%29;)*2026-01-10 10:00:00中国香港*

从盛夏到冬天，开源之夏2025陪伴众多高校开发者走过了充满创造与协作的一段旅程。在OpenAtom openEuler （简称“openEuler”或 “开源欧拉”），我们与来自全国各高校的同学们一同探索操作系统技术的深水区，推动开源系统生态的持续进化。本次活动中，openEuler 共收到超过**122份**项目申请，经过方案评审、社区互动与数月开发周期的共同努力，最终有**37位**同学顺利完成项目开发并提交结项，其中许佳凯同学因其出色的贡献荣获“优秀学生”称号。

### ??**致敬每一位代码背后的耕耘者**??

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4aQJBVrPRxyI3WYLDuFCrwZ43R1NyH1iawOumia9vePyVuSibHicyRdlpLlQ/640?wx_fmt=png&from=appmsg)

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a5UAtzr0bNFrbE5w0zuBiaRBTgwF4icbyh1xEoMKuuNtzM3baqWibtmubQ/640?wx_fmt=png&from=appmsg)

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4azKadSqFsCBkGnrice2s09fwQhF1ZKTLkSTWUEDjOQ9ic3G3wCUBibF17A/640?wx_fmt=png&from=appmsg)

  

**优秀学生 许佳凯**

### ***为RISC-V装上“智能眼睛”，让性能调优从“被动适配”走向“主动感知”***

在本次开源之夏中， 许佳凯同学凭借出色的代码质量、积极的社区互动以及高质量的项目交付，从众多参与者中脱颖而出， 荣获 “优秀学生 - 最佳质量奖” 。

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4aCeVZtdrS7Ugae6RnY402J9ppU7227AQDPJmh6dhdyrDHAEu8NBvzrA/640?wx_fmt=jpeg&from=appmsg)

**01**

**首先恭喜你获得“优秀学生-最佳质量奖”！可以分享一下你的获奖感受吗？**

**许佳凯：**谢谢！首先我非常感谢开源之夏提供的平台，以及 openEuler 社区给我的机会。也要特别感谢我的导师司延腾老师，还有 oeAware 社区的 Maintainer 们，在整个项目过程中给了我很多关键的指导和帮助。

**02**

**你这次做的项目听起来非常深入，可以简单介绍一下它主要解决了什么问题吗？**

**许佳凯：**我这次参与的项目是 “基于 RISC-V 架构的 oeAware 框架移植”。oeAware 是 openEuler 上一个很优秀的低负载采集感知调优框架，已经在其他主流架构上应用得很成熟了。但随着 RISC-V 这种开源、灵活的新兴架构越来越普及，oeAware 却还不支持它，这就限制了框架在 RISC-V 生态里的发挥。所以我的工作，就是让 oeAware 也能在 RISC-V 上“跑起来”，并且更好地利用它的硬件特性。

**03**

**具体来说，你做了哪些工作？其中最有挑战或最有意思的部分是什么？**

**许佳凯：**除了完成基础的代码适配、依赖库移植和功能验证，我最花心思的部分，是结合 RISC-V 独有的 hwprobe 接口，为它开发了专有的感知和调优实例。RISC-V 最大的特点就是开源和灵活，但这也意味着不同厂商的芯片支持的指令集可能不一样。hwprobe 这个系统调用，能让程序在运行时主动“感知”CPU 的能力——比如它是否支持 Zbb、Zba 这类扩展指令集。这就像给程序装上了一双“智能眼睛”，实现了从“被动适配”到“主动感知”的转变，我觉得这是 RISC-V 在优化范式上很不一样的地方。

**04**

**你提到开发了专有实例，可以举一个例子说明它是如何工作的吗？**

**许佳凯：**比如我开发的**hwprobe\_ext\_zbb\_tune**这个调优实例。Zbb 是 RISC-V 里用于位操作加速的指令集扩展。如果程序通过 hwprobe 探测到当前 CPU 支持 Zbb，这个实例就能在运行时，动态地将某些标准库函数（比如 strlen() ）替换成用 Zbb 指令优化过的版本——相当于在不修改业务代码的情况下，为它悄悄换上一个“更快的引擎”。

**05**

**通过这次项目，你个人最大的收获是什么？**

**许佳凯：**这是我第一次深入参与一个跨架构的框架移植项目，不仅实战了从适配、验证到深度优化的完整流程，更重要的是掌握了像 hwprobe 这样的架构特性如何与实际性能调优结合。我也更熟悉了开源社区的协作方式。未来我希望继续完善这套适配方案，为 openEuler 在 RISC-V 生态的发展多做一些实在的贡献。再次感谢社区和导师们的支持！

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4aHYgQ5OpBU3NGQyGyp99TzMEaqVbLVtMah6dJQnY9GAFlB2XcHibSic0Q/640?wx_fmt=gif&from=appmsg)

**持续共建，未来可期**

openEuler 社区将持续致力于为高校开发者及广大开源爱好者提供学习、实践与贡献的开放平台。无论是初识开源的新同学，还是经验丰富的贡献者，我们都期待你加入 openEuler 大家庭，一起用代码构筑智能时代的数字基础设施！
