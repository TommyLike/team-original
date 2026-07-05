# [openEuler 内存分级扩展功能助力天翼云](https://mp.weixin.qq.com/s/9cUJ9biP93JQvAvLviduYA)

[OpenAtom openEuler](javascript:void%280%29;)*2021-11-09 16:00:00*

近期，天翼云和华为 openEuler 开源团队就内存分级扩展功能进行了联合创新，并在天翼云虚拟化场景进行了内部原型验证，测试结果表现，内存分级技术极大提升了内存性价比。

## 背景

受制于内存工艺瓶颈，内存成本高；随着 CPU 算力的发展，尤其是 ARM 核成本的降低，内存成为约束业务成本和性能的关键问题。如何节省内存成本、扩大内存容量成为迫切需要解决的问题。因此，openEuler 推出了内存分级扩展功能。

内存分级扩展功能在不影响业务功能情况下，通过 DRAM 和低速内存介质，如 SCM、AEP 等形成多级内存，通过内存自动调度让热数据在 DRAM 高速内存区中运行，让冷数据交换到低速内存区，从而增加内存容量，保证核心业务高效平稳运行。该特性适用于内存使用量大，且使用相对不频繁的应用进程上，在这些场景中的效果较好，收益较大。

## 联创成果

在虚拟化场景下，如何扩大内存容量的同时降低内存成本，提升内存超售比，是天翼云面临的业务痛点。针对该痛点，天翼云和华为 openEuler 开源团队进行多次交流，决定在虚拟机内部业务访问不频繁的场景中验证内存分级技术，尝试提升虚拟机密度，同时保持业务性能持平或少量下降。

通过联合创新，对 AEP 搭配 DDR 场景进行了原型验证，开启内存扩展功能相比未开启时，AEP 中虚拟机的 redis 性能提高了约 30%，基本达到与 DDR 中虚拟机 redis 性能一致的水平。同时，等内存容量下，使用 DDR 搭配 AEP 比纯 DDR 场景，内存成本下降了约 35%，显著提升了内存使用的性价比。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbZDq0hjbqljicl5a5mx6D3CqAvMoBTdnLwiaaGU6hkHJQzylIjZxWibPHiaxtcLvMGzPiaTDFk5WNmTtA/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbZDq0hjbqljicl5a5mx6D3CniaZdzD02Pic2qtN12eY57ulNb1RGLEicibVmQYqSTgEL0dfwnp0vmTxPA/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbZDq0hjbqljicl5a5mx6D3Cs8mQTKqumQzI3YTfOMibeLF5ia0Vc2wROKwRNMv0aOl9KFB8vldoERVA/640?wx_fmt=png)

## 总结

本次联合创新，天翼云为 openEuler 社区的内存分级扩展项目提供了真实的业务场景进行原型验证。天翼云开发团队凭借多年的研发经验，参与到项目的实际代码开发，实现了该项目的多个特性。未来，天翼云将会在更多场景下，对该技术进行进一步验证以得出更多数据和更完整的评估。通过本次联合创新，加深了天翼云的技术储备，也促进了 openEuler 社区的生态繁荣。

## 了解更多

如果您对内存分级扩展感兴趣，或者想了解更多信息，欢迎关注 2021 年 11 月 10 日下午 openEuler Summit 的内核分论坛，届时我们将为您介绍 “内存分级扩展的应用实践”。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbZDq0hjbqljicl5a5mx6D3CSiciaKISxMrRnRaEJUsicVTovHachjfuMVSgH986XyUvldrokwyomm9Jg/640?wx_fmt=png)

**扫码观看直播**

## 主要贡献者

姓名公司Gitee id邮箱胡亚弟天翼云huyd12huyd12@chinatelecom.cn张俊平天翼云raymond-pathfinderchentt10@chinatelecom.cn陈涛涛天翼云Chen\_Storyzhangjp12@chinatelecom.cn朱玲华为alignmentzhuling8@huawei.com娄宏翔华为louhongxianglouhongxiang@huawei.com施克蒙华为shikemengshikemeng@huawei.com

[阅读原文](https://gitee.com/src-openeuler/etmem)
