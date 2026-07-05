# [Summer Code Camp 活动回顾 ｜ Curve & openEuler 联合举办](https://mp.weixin.qq.com/s/bAUpSupJrwRGqjJub27Fxg)

[OpenAtom openEuler](javascript:void%280%29;)*2023-10-19 17:58:36*

**Summer Code Camp 由 Curve 携手 openEuler 联合举办，旨在帮助社区的小伙伴们更好地参与开源社区。**

本次开发者活动中，共完成 **19** 个题目，包括 Curve web 控制台、云原生、核心代码逻辑、CurveAdm 以及 Curve 的 CI 等 **5** 个方向，新增社区 Contributor **14** 位。社区也邀请了本次三位新晋开发者进行采访，分享他们的收获与经验，在这里将以采访的问答方式分享给大家。

真诚感谢大家为 Curve 社区做出的贡献，同时 Curve 新一期开发者活动将于11月开启，这一次，Curve 走进高校，联合杭州电子科技大学、浙江理工大学、成都信息工程大学，与高校开发者建立更加深入的技术联系，参与者将收获 Curve 实习 offer、数万元神秘大奖，并且与有爱的社区大家庭共同成长~

**新晋社区贡献者**

![](https://mmbiz.qpic.cn/sz_mmbiz_png/2AnE0HPasgibtMIME4BVVibI7JiaEJ2eFfdCmJViaY58fHnP2mQtpyiaroJYicuGsicYJdDCXwCDjt2ljz3wFeUMhBkLA/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

**获奖名单**

![](https://mmbiz.qpic.cn/sz_mmbiz_png/2AnE0HPasgibtMIME4BVVibI7JiaEJ2eFfdgSWDXggZLUZp1sByzbxfYiaRwdDc6yqXcUuClodFpOqhzARf7EXEScQ/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

**采访**

**本次受邀参与访谈的贡献者分别为：**

    @peter5232、@Songjf-ttk、@TrickEye

**怎么会想到要来参加这次活动呢？**

    @peter5232：一是可以学习到关于存储的知识，并且结合 c++ 和 go 语言进行实现，更可以学习编程语言上的技巧。二是可以学习存储的实际运用场景，比如说git的一些实际使用等，因为一直在学校呆着，理论和实际可能产生脱节。

@Songjf-ttk：自己一直在关注 GitHub 上的各种开源项目，也很想参与进去提升自己的水平。这次看到 Curve 社区举办活动就果断加入了，加入后发现体验感也非常好，特别的感谢 Curve 社区能举办这样的活动。

@TrickEye：为了奖品！（Curve：收到！下次多发奖品！）也为了参与开源项目给自己积累一些工程经验。

**本次选择的是什么项目？**

@peter5232：我本次选择的题目有两个：一个是添加 clang-format action,另外一个是适配 Curve 的 openeuler 的 arm64 和 x86 端。第一个任务的认领原因是我没有使用过 clang-format，接触到该工具是在 vscode 的插件上，我希望可以在这个任务中学习到工具的使用，并且学习github action的使用。在本次任务中 Curve @wu-hanqing 为我的 mentor，我从一开始制定方案到最后结项，@wu-hanqing 一直在给予修改意见，同时指导下我学习了 git diff 工具的一些用途，从而完成了该任务，其中也比较麻烦 @wu-hanqing，因为 github action 的创建需要有一个人确定才可以，所以每次修改后都需要手动执行才可以，耽误了 @wu-hanqing 很多时间。（Curve：不是耽误时间，我们是在共同成长~大家的进步才是社区真的进步！）

@Songjf-ttk：这次选择的是一个简单的题目，由于我对于 curveadm 的源码不是很熟悉，当时身边还有其它事情需要同步完成，所以选择 easy 题可以确保我完成任务。（Curve：大家学起来！根据实际情况选择不同难度等级的题目）

@TrickEye：因为是第一次打怪所以选了控制台的一个 easy 的题目。因为上学期大量接触过 vue 所以确实比较 easy。

**在项目中有哪些思考可以分享呢？**

@peter5232：在适配 openEuler 操作系统的任务中，我认识到必须要认真阅读文档，必须要抱着争取自己解决的心态进行工作，由于在工作中并没有认真阅读文档，一直在向 mentor 提幼稚的问题，耽误 mentor 的时间，所幸 mentor 还是在百忙之中回复我的问题，所以我觉得**必须先要自立，先自己解决问题，**实在不行，再去询问他人。

@Songjf-ttk：我选择的题目是为 curveadm 增加 debug 模式，这个确实很简单，参照 curveadm 中原有的模式添加命令即可。但是做的过程中我才发现事情没有我想象中的那么简单，有的代码写的不规范，有的功能做的不完善。比如添加 debug 模式会留下一些没有被删除干净的容器，这时候 mentor 就建议我再添加一个清除容器的操作，这个是我没有考虑周全的。所以**把一件事做出来和把一件事情做好是不一样的。**

@TrickEye：这次是第一次参与的面向具有实际用途的软件，第一次领略到成规模的软件，感觉还有很多要学习的。

**有哪些体验和收获呢？**

@peter5232：Curve 的社区文档维护的很全面，虽然有一些文档没有同步好，但是在交流群里一说，里面会有人回复相关的问题，可以很及时的解决问题.

@Songjf-ttk：其它很多的项目由于社区回复的不及时，社区的封闭性，贡献者对于代码的陌生都给参与开源带来了很大的阻力。但是 Curve 社区回复总是很及时，我提交的 pr 也被仔细的 review 指出我代码中的问题，不定期还会举办活动，参与感真的特别的高！

@TrickEye：**参加开源项目很锻炼我的 problem solving 技巧**。从一个简要的问题入手开展系统的研究和尝试最后回归到一个简单的代码修改和PR，我很喜欢开源软件的这种开发模式。

**和社区之间的互动感受怎么样？**

    @peter5232：社区的交流群里有技术问题的解决、偶尔的欢乐时光，给人很好的感觉，与mentor之间可以很好的交流并且也会很快的回复.

@Songjf-ttk：社区里的朋友们都很友善，贡献者的群里都很热闹，Curve 小助手会热心的帮助提醒我们，mentor 也很耐心，一次次的 review 我的代码，这次参加活动的整体体验是很快乐的。

@TrickEye：人都超好，个个都有才，说话也好听！

**------ END. ------**

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/2AnE0HPasgibtMIME4BVVibI7JiaEJ2eFfdb4sbmY1wyKFr7ca2p2FTvzmzaskmiah9ha5CzOXXPCbpicib7kVSn1VbA/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1)

关于 openEuler 

openEuler 是由开放原子开源基金会孵化及运营的开源项目，是面向数字基础设施的开源操作系统，支持服务器、 云计算、边缘计算、嵌入式等应用场景，支持多样性计算，致力于提供安全、稳定、易用的操作系统。通过为应用提供确定性保障能力，支持 OT 领域应用及 OT 与 ICT 的融合。

- **代码仓**：https://gitee.com/openeuler
- **软件包仓：**https://gitee.com/src-openeuler
- **官网：**https://www.openeuler.org/zh/
- **用户论坛：**https://forum.openeuler.org/
- **微信群：**添加小助手微信（openeuler123）

![](https://mmbiz.qpic.cn/mmbiz_png/2AnE0HPasgicWbwTlMPoOSibuN4f2axS00ibibI8ZiaDde0CiclwlEHaJKCUTSRRialVhasQr7x9jdAXCZrTsVvDziaC8Q/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1&tp=wxpic)

关于 Curve 

**Curve 是一款高性能、易运维、云原生的开源分布式存储系统。可应用于主流的云原生基础设施平台：对接 OpenStack 平台为云主机提供高性能块存储服务；对接 Kubernetes 为其提供 RWO、RWX 等类型的持久化存储卷；对接 PolarFS 作为云原生数据库的高性能存储底座，完美支持云原生数据库的存算分离架构。**

**Curve 亦可作为云存储中间件使用 S3 兼容的对象存储作为数据存储引擎，为公有云用户提供高性价比的共享文件存储。**

- **GitHub**：https://github.com/opencurve/curve
- **官网**：https://opencurve.io/
- **用户论坛**：https://ask.opencurve.io/
  
  **微信群：**搜索群助手微信号 OpenCurve\_bot
