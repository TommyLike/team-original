# [中移物联OneOS与openEuler联合推出非对称AMP双系统方案](https://mp.weixin.qq.com/s/512Iy5IGoJz_K5XD-PUPNw)

[OpenAtom openEuler](javascript:void%280%29;)*2024-10-28 19:00:00广东*

随着复杂应用对操作系统混合部署需求的日益增长，非对称多处理架构（AMP）作为一种新型系统设计选择，正逐渐成为工业控制、能源电力、低空物联、工业机器人等诸多领域的“新宠”。近期，中移物联OneOS与OpenAtom openEuler(简称:openEuler)社区展开合作，共同推出非对称AMP双系统方案。非对称AMP双系统通过在单颗芯片的多个核心上独立运行不同的操作系统，如Linux与RTOS的结合，实现任务的高效分配与处理，显著提升了系统的实时性与稳定性，在承载复杂算力应用的同时，更有效降低了硬件成本。

该方案中，openEuler是一个面向数字基础设施的开源操作系统。它支持多种硬件架构，拥有丰富的软件包库，能够充分满足不同场景下高算力复杂应用的需求。中移物联OneOS是中国移动推出的轻量级物联网操作系统，具有高实时、高可靠和高安全性的特性，在市场上处于领先地位。作为RTOS系统，OneOS专门用于处理对实时性要求高、时间敏感性强的任务。

openEuler通过生命周期管理，有力支持OneOS系统的加载、启动、暂停、结束等一系列工作。在两个操作系统之间，通过共享内存和核间中断，成功构建了一套高效的通信机制。基于该通信机制的服务化框架，两个操作系统能够便捷地提供各自擅长的服务，为用户带来灵活且高效的解决方案。该方案在不牺牲实时性的前提下，满足了当下嵌入式系统对复杂功能应用的需求，同时也降低了系统的整体成本。

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mBaxxicN48Zet2aoHwORs9VbvFef2pqv3bujevY3NZGWu4RicGoPOhuFCnE1UjU88xawAib3eWXicwYsw/640?wx_fmt=jpeg)

*openEuler与OneOS混合部署框架基础架构*

非对称AMP系统有着极为广泛的应用前景。以电力系统中的保护测控类设备为例，它既要在监察、测量、控制、保护等任务中稳定运行，完成实时计算和控制工作，又要承担数据记录、处理和分析等复杂算法应用的重任。在工业控制场景下，设备需要持续采集数据，并实时进行计算分析，同时还需时刻保持高实时响应指令的能力和稳定运行状态。OneOS和openEuler将进一步加强AMP系统在工业领域的能力拓展，打造工业控制和AI计算深度协作的模型，促进工控领域和智算领域深度融合，并合力为客户提供定制化的解决方案。

中移物联OneOS与openEuler的强强联合，充分发挥了两类系统各自所长，为行业提供了强大且灵活的基础软件解决方案。此次合作成功打造了国产开源系统新里程碑，有力推动了开源事业的繁荣发展，为行业激发更多新质生产力的发展潜力，共同迈向“智改数转”新时代。

![](https://mmbiz.qpic.cn/mmbiz_jpg/rrbZLC2ibIgtgV382cFCwmibpHFT7jndu1ibEDpFia0dzsjETHdt0HFzYlVRnHIaumpf3QyVos7giadDicqSku9zOEibw/640?wx_fmt=jpeg "金属质感分割线")

[![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAb2t1LkGXJHicuGDklRKxKTHBMJjdMdDRDUuunpBN0NaicXfFG5ibBjwicQ6JVyeagdWg4axibXLRicgCA/640?wx_fmt=png&from=appmsg)](http://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247511955&idx=1&sn=a89aeb34f87cc2b5a418771ab1495deb&chksm=c1f3b7fef6843ee866818f8d2b8eda2755d0bf7147d9d74d3f9774c31b37d41003057bc7381b&scene=21#wechat_redirect)
