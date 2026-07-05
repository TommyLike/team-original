# [openEuler RISC-V SIG 近期工作进展和未来规划：持续繁荣 RISC-V 软件生态，构建笔记本操作系统](https://mp.weixin.qq.com/s/826RWyqmLC5IQ8vjSPbu8Q)

*RISC-V SIG*[OpenAtom openEuler](javascript:void%280%29;)*2022-04-29 17:44:41*

在刚刚结束的 openEuler Developer Day 2022 上， RISC-V SIG 召开工作组会议，介绍了 RISC-V SIG 近期的工作进展以及 2022 年的目标定位，主要围绕总体目标发布具体的实施细则和工作计划，同时也对 port maintainer 计划和新发布的软件源暂定运行机制进行了介绍。

### RISC-V SIG 进展与成果

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMa3xdTiaFhI3OCJAibSuKJbfc6MN7znx6kfLicJ07CUnObObc8yQPSMAXCfo9ibTTakZiaYYjo2I1oBYLw/640?wx_fmt=jpeg)

1. **「在软件层面」**，RISC-V SIG 通过对软件包的适配提供 riscv64 的二进制源；并跟随 openEuler 源码版本升级，对升级的软件包进行 RISC-V 架构适配。目前，RISC-V SIG 成功适配的软件包 3800+ 个。
2. **「从硬件层面」**，RISC-V SIG 通过对各种商用开发板的支持，让 openEuler 能够在更多的 RISC-V 开发板上运行起来。现在系统可以成功的运行在果壳（nutshell）、全志公司哪吒 D1、SiFive 公司 HiFive Unmatched 等开发板上。
3. **「从功能层面」**，RISC-V SIG 目前重点聚焦三大使用场景：基于 RISC-V 的 OBS 模拟构建环境系统、基于 RISC-V Lab 的容器使用场景、基于个人电脑的 RISC-V 笔记本系统。前两种在 2021 年就已经具备，目前，RISC-V 笔记本完成了桌面的支持，firefox 浏览器、LibreOffice 办公套件是 2022 年的主要适配目标。RISC-V SIG 希望在 2022 年能够提供一个 RISC-V 笔记本可用的 openEuler 操作系统。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMa7ayvh1SIfRNI9ZbX7k4HbARLCud0Nzoxqv6FRcs8lEATKnkH9THiab0Wx5TdF13stV6yZPtnPopA/640?wx_fmt=jpeg)

### RISC-V SIG 未来规划

RISC-V SIG 的目标是让所有用户方便、友好的使用在 RISC-V 架构上运行的欧拉开源操作系统。而达成这个目标背后仍需要有很多工作要做，其中最主要的目标有两点：

**「第一，RISC-V SIG 能够在 RISC-V 笔记本上成功安装和使用，并提供桌面、浏览器，办公套件等常用功能。」**

RISC-V SIG 希望构建一个 openEuler RISC-V 笔记本操作系统，主要考虑到两方面的因素：

1. **「硬件制约」**：受限于 RISC-V 可用硬件的制约，目前市面上可以购买使用的 RISC-V 开发板，多用于嵌入式、边缘计算场景。产品化的 RISC-V 开发板中性能最好的硬件运行桌面系统也依然有些吃力。服务器领域的 RISC-V 硬件还完全缺失。
2. **「软件生态不完善」**：需要将更多的软件包都适配到 RISC-V 架构上，并在 RISC-V 开发板上运行验证，从而发现问题推动软件包的完善。

鉴于以上两个原因，openEuler RISC-V 笔记本操作系统是目前最佳选择：硬件虽然性能稍欠，但有可用开发板支持。openEuler RISC-V 笔记本操作系统面向对象是个人用户，包含的软件包范围非常广泛，可以促进完善欧拉开源操作系统 RISC-V 构架下的软件生态。

**「第二、借助 RISCV Lab 云实验室的基础设施，让 RISC-V SIG 可以适配更多的开发板和硬件。」**

RISC-V Lab 是一个为全球开源社区提供 CI 基础设施的平台，由 RVI（RISC-V 国际基金会）与中国科学院软件所于 2021 年联合组建，预期规模超 2000 套 RISC-V 开发板，供全球开源社区的开发者使用。

在 2021 年，RISC-V Lab 已经部署超过 160 套哪吒 D1、超过 60 套 SiFive Unmatched 开发板，更多型号和数量的开发板正在部署中。在 2022 年，RISC-V Lab 的基础设施将继续扩大和完善。

**「目前，欧拉开源操作系统已经成为 RISC-V 基金会与中科院软件所 PLCT 实验室合作建立的 RISC-V Lab 默认的操作系统之一。」** 借助 RISC-V Lab ，欧拉开源操作系统可以适配更多的开发板和硬件。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMa7ayvh1SIfRNI9ZbX7k4HbPkicAWX9o2NRzkDZZn4iaOJe42Ej7AALxguc6T8j5ticwA62vjhaaVS5w/640?wx_fmt=jpeg)

### RISC-V SIG 准备怎么做

为了让大家更好的参与到 RISC-V SIG 中，RISC-V SIG 采取 ORSP 机制，实现决策过程公开透明、集思广益。

目前 RISC-V SIG 已经制定了 3 套 ORSP 详细的描述了具体的执行策略和任务：

1. ORSP001：根据 RISC-V SIG 当前遇到的问题，SIG 组制定了基础设施增强、镜像和仓库每日构建、典型应用场景等具体目标；以及工程管理、版本管理、PR 管理等详细策略。
2. ORSP002：提议并初步建立了 repo watcher 的角色，为基础包、语言包等找到相对固定的 maintainer 和 tester，承担诸如与上游沟通、对其它发行版的观测、版本升级、测试（或指导测试）、修包等工作，对基础包有最低程度的稳定维护，促进系统构建和升级的快速迭代。
3. ORSP003：定义了 RISC-V SIG 软件源的运行机制。

**RISC-V openEuler Developer Day 会议纪要***https://etherpad.openeuler.org/p/SIG-RISC-V\_openEuler\_Developer\_Day\_2022\_Planning*

### 成为 RISC-V SIG 一员

中科院软件所作为 RISC-V SIG 的主要发起者，正在招收更多对 RISC-V 感兴趣的小伙伴加入。中科院软件所 RISC-V 操作系统团队，即 TARSIER 团队，规模 40+ 人，其中全职 10 人，实习生 30+ 人。欢迎加入 TARSIER，关于职位信息请点击[这里](https://mp.weixin.qq.com/s?__biz=MzUyMzA2NzkzOA%3D%3D&mid=2247484416&idx=2&sn=985da4aa98882458afa238ba03f65d6f&scene=21#wechat_redirect)了解更多。

**TARSIER 在 2022 年计划邀请 200+ 名付费开发者参与欧拉开源操作系统开发，招募 500+ 名付费测试者参与欧拉开源操作系统测。**

为了 RISC-V 早日成为跟 x86、ARM64 并驾齐驱的三大架构，RISC-V SIG 目前计划为新增加约 2000 名 SIG 组成员，RISC-V 架构下的软件适配需要大家的共同努力，欢迎大家来 RISC-V SIG 贡献自己的代码。点击[链接](https://mp.weixin.qq.com/s?__biz=MzUyMzA2NzkzOA%3D%3D&mid=2247484428&idx=1&sn=e0d00120d63908933ba2e87f8e9c655e&scene=21#wechat_redirect)了解更多。

如果您对 RISC-V 感兴趣，欢迎加入 RISC-V SIG 交流群，讨论更多关于 RISC-V 的更多内容。

**「中科院软件所吴伟微信」**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMa7ayvh1SIfRNI9ZbX7k4HbsySDpbp7roS51g7W1ws0Nor2dEXhTKYaJea3aLPibOSrh3Vib2XF5Jvw/640?wx_fmt=jpeg)

**「添加请备注oerv」**

## 关于作者

杨延玲，中科院软件所 PLCT 实验室实习生，欧拉开源社区 RISC-V SIG 成员，目前在温州大学读研一，负责协助 RISC-V SIG 的日常运营。
