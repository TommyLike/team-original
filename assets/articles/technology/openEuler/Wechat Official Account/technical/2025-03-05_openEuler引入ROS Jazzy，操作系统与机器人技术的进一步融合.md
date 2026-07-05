# [openEuler引入ROS Jazzy，操作系统与机器人技术的进一步融合](https://mp.weixin.qq.com/s/2ZInR6kzT_Dk1Qmr7J4PRg)

*聂雨婷*[OpenAtom openEuler](javascript:void%280%29;)*2025-03-05 18:00:00广东*

就读大一的OpenAtom openEuler(简称: openEuler) ROS-SIG实习生林鸿宇经过2个月的调研与适配，成功为 openEuler 24.03 引入 ROS 2 Jazzy Jalisco 版本支持（以下简称 ROS2 Jazzy），为推动ROS2生态与操作系统深度融合贡献了新生力量。

 

ROS2 Jazzy延续了 ROS2 的分布式架构设计理念，升级至 RTI Connext 6.1.1 以改善大规模节点通信时的延迟抖动，并首次引入 rmw\_zenoh 中间件预览版，为云端-边缘端的广域网协同提供了新选择。**为 openEuler 社区和机器人开发者提供更多可行性与拓展空间，林鸿宇基于 openEuler 已支持的 ROS2 Humble 版本开始着手移植ROS2 Jazzy。**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAV8piaKvMaY7h8vwnHbMiapmgdbL7WKp1EnXSL9guuDfdibTSficI8YA21O04zib2G4Z7BBYbJL3lMIYA/640?wx_fmt=png&from=appmsg)

林鸿宇工作台-宿舍版

为了更好的适配openEuler工作流，林鸿宇自行开发了名为 ROT（ROS openEuler Tool） 的 Python 工具来自动化处理移植流程。ROT 针对openEuler进行了定制适配，可视作对 bloom、rosdep 等官方工具链的二次封装，包含多个 Python 脚本，可通过命令行调用，目前已支持自动生成 spec 及源码包、成果自动上传至 Gitee、构建错误分析等功能。ROT 仍处于早期探索阶段，仅在内部使用，正在开发可对外的新版工具 ROS-Crossport"。

目前，林鸿宇已成功在openEuler 24.03系统上实现ROS2 Jazzy版本的核心功能部署，除经典机器人仿真工具Turtlesim以外，还适配了rqt可视化工具链（含实时数据绘图工具rqt\_plot、节点拓扑分析工具rqt\_graph等）及全套ROS2命令行工具（包括ros2 topic通信调试、ros2 node节点管理、ros2 launch任务编排、ros2 bag数据回放等关键功能）。**openEuler ROS2 Jazzy版本已具备较完整的开发调试功能，开发者可直接基于openEuler系统开展机器人算法开发、通信测试、数据记录等全链路工作。**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAV8piaKvMaY7h8vwnHbMiapmiaYfphVTaeB3Z0EKFVdriaydB3qLJlU2gPIRICurCYcicwibrkWmVb5jsA/640?wx_fmt=png&from=appmsg)

ROS2 Jazzy运行小乌龟

与传统开发者不同，林鸿宇并不属于“根正苗红”的科班，而是一名工商企业管理专业的大一新生，喜欢吉他以及捣鼓开发板。一个偶然的机会，林鸿宇在高考完的那个暑假经同学介绍了解到了RuyiSDK，随之开始接触到甲辰计划，秉着朴素直观的动机——**“机器人方向做出来的东西能够在眼前蹦蹦跳跳的感觉很有意思”** 加入到了ROS相关方向，成为了乘风小队的一员。

最初林鸿宇主要负责文职相关内容，如设计 RuyiSDK RevyOS logo，调研开发板等。但他并不满足于此，想要在软硬件赛道挑战自己。随着ROS2 Jazzy的逐步适配，他也完成了**从文职工作到openEuler ROS生态贡献者的身份转变，并在此过程中收获了详细的打包流程、技术经验沉淀、以及自研ROT工具。**林鸿宇强调：“做一件事情过程和结果一样重要，我想把整个移植过程中有意义的地方分享给大家”。基于此，后续将通过报告/文章形式分享其工具调研、流程解析、实践经验等内容以供开发者参考交流。

文档入口：

https://openeuler-ros-docs.readthedocs.io/en/latest/other-tutorials/openEuler-turtlesim-jazzy-example.html#

交流邮箱：microseyuyu@gmail.com

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAV8piaKvMaY7h8vwnHbMiapmmyL1ylbWXfmLXvYkQEpPeuibicwmibUdW6JXS8tuWh060JyVpoYVb2srQ/640?wx_fmt=png&from=appmsg)

 ROT 工具界面

甲辰计划为林鸿宇提供了一个成长探索的平台，作为工商企业管理专业的大一新生，从0开始逐步前进，**专业和年龄都不足以阻挡其开发的脚步。**未来，林鸿宇将持续打通ROS2 Jazzy官方教程所覆盖的全功能技术体系，包括核心通信架构、标准工具链及开发套件，确保与ROS官方功能实现良好的兼容对接，并基于ROT升级发布新一代自研机器人开发工具ROS-Crossport，欢迎持续关注。

关于乘风小队：ROS-RV乘风小队聚焦于开源机器人操作系统ROS的研究与推广，致力于推动ROS开源软件包在openEuler、OpenAtom openKylin等操作系统以及RISC-V架构上的适配优化，扩展ROS在操作系统和芯片上的应用。团队核心成员来自中科院软件所和开源爱好者，在ROS、操作系统、RISC-V、开源社区建设等领域有着丰富的经验。

关于作者：

聂雨婷，中国科学院软件研究所PLCT实验室测试及内容运营，以测试保障体验，用内容赋能产品。
