# [活动回顾｜openEuler Compiler SIG Meetup 北京站](https://mp.weixin.qq.com/s/FG9o_Kj8a8uvfZwUQkozbA)

[OpenAtom openEuler](javascript:void%280%29;)*2025-10-22 18:18:00广东*

2025 年 10 月 16 日， OpenAtom openEuler（简称：“openEuler”或“开源欧拉”）Compiler SIG Meetup在北京成功举办。本次活动邀请来自北京航空航天大学、湖南大学、字节跳动、京东、快手、麒麟软件及华为等高校与企业的多位专家学者齐聚一堂，围绕前沿编译器技术、AI图编译优化、灵衢超节点编程、编译技术业务场景实践及编译器开源社区共建等议题展开深度分享与交流。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/icntuIQtpSJWA8PaOWuFElV1LAhnGz6Cgm4DLIcIeYZRrsrSHFzoYbePD3F11J00xHVuiczibKFyNcTN1NqGRpheg/640?wx_fmt=jpeg&from=appmsg#imgIndex=0)

下面就让我们来回顾本次Meetup的高光时刻。

**00**

  开场致辞 

华为编译器实验室主任骆能军发表致辞，回顾了Compiler SIG作为openEuler社区编译技术核心力量，在推动开放共治、构建开源生态方面的重要进展。LLVM for openEuler项目已正式开源，昇腾NPU IR与Triton兼容性建设持续推进，AI编译生态日益完善，成果背后凝聚着高校、企业与广大开发者的协同创新。本次大会以“开放开源，汇聚编译器根技术，共建编译社区”为主题，汇聚学界与产业界多方力量，共话技术演进与生态协同。未来，Compiler SIG将持续完善开放协作机制，欢迎更多开发者加入，携手打造繁荣、可信的编译器开源生态。

**01**

  AI图编译技术分享和LLVM for openEuler的运作 

华为编译器架构师魏伟深入分享了LLVM for openEuler编译器的整体架构与版本演进规划，重点介绍了在CFGO反馈优化、软硬协同优化、AI for Compiler、AI图编译及编程等前沿技术方向上的最新进展。LLVM for openEuler编译器依托openEuler社区，提供丰富的软件包资源与文档支持，积极鼓励开发者参与技术讨论与社区共建。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/icntuIQtpSJWA8PaOWuFElV1LAhnGz6Cg6f4SZv9PTceq9p9Fhibp5wvuiaVJtR5SgLpD0C27cI0fS6fyXGnBX6kA/640?wx_fmt=jpeg&from=appmsg#imgIndex=2)

**02**

  AscendNPU IR:面向昇腾的AI算子编程编译技术 

华为编译器技术专家陈相廷深入剖析了面向昇腾的AI算子编程编译技术，特别是AscendNPU IR的多级抽象编译和开放可编程特性。AscendNPU IR通过多级IR构建AI公共编译底座，允许框架灵活对接，支持高性能编程和差异化定制。他详细介绍了Triton编程在昇腾上的挑战与创新点，包括Triton OP的昇腾亲和度分析、访存优化、核内资源自动映射等。此外还展示了Triton与昇腾的适配方案，通过毕昇编译器将Triton IR转换为昇腾二进制代码，实现高性能运行。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/icntuIQtpSJWA8PaOWuFElV1LAhnGz6CgqUUIK2dImAazK1UDTIUmibVfibsyicAHQRGT4ArIGlEo9Noh1keYzWiahw/640?wx_fmt=jpeg&from=appmsg#imgIndex=3)

**03**

  面向异构系统的值Profiling编译优化 

湖南大学编译技术研究中心主任王锋老师介绍了湖南大学与编译器实验室合作的代表性工作，并分享了面向异构系统的PGO编译优化研究成果。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/icntuIQtpSJXA2Wwn9sdOGpZCkDArBJ2PByFTwrGLYcZOeeuib4b8wv8Tn6gtiaksaT2ZQm0z8gJIiazMLx24NBB8Q/640?wx_fmt=jpeg&from=appmsg#imgIndex=4)

**04**

  面向灵衢的编程编译技术及开源计划 

华为编译器技术专家杨扬介绍了灵衢超节点的高带宽、低延迟和内存语义特性，以及这些特性对编程编译带来的新机遇。灵衢超节点区别于传统集群，提供了更高效的内存访问模式，但传统分布式编程模式（如MPI、RDMA）在编程效率和性能上存在劣势。他提出了基于标准语言生态（C/C++ & Java）的超节点编程范式，通过扩展C++标准多线程并发编程接口，实现高性能和高易用性的分布式编程。此外，他还介绍了毕昇超节点编译和运行时技术，包括内存池化优化、超节点数据布局管理和亲和任务调度等。杨扬专家最后分享了Matrix C++的分批开源计划，旨在为分布式计算提供高性能编程接口和运行时能力。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/icntuIQtpSJWA8PaOWuFElV1LAhnGz6Cg1rI0O3DavaILyziaE5Z1X4gxaJxD3KQ2KqntZMsnpGlTn2qQl3cx2vw/640?wx_fmt=jpeg&from=appmsg#imgIndex=5)

**05**

  互联网广告系统的终极难题 

京东广告算法架构师探讨了互联网广告系统在流量洪峰与毫秒级决策交汇点下的技术挑战与解决方案。他指出，互联网广告系统面临日请求量千亿级、单次推理需控制在几十毫秒内的严苛要求，技术迭代迅速，算力需求激增。详细介绍了京东广告系统的全链路架构，包括召回、排序、Rerank与计费等环节，以及如何通过软硬件结合的算力架构优化性能。他还展示了鲲鹏图编译和高性能算子库在广告模型推理中的应用，通过图优化、自动调优等技术，显著提升了模型性能。此外，他强调了低延迟下的高吞吐是核心瓶颈，提出了面向混合异构推理的性能优化设计，以及分布式异构算力的软硬件协同优化策略。最后，他指明了广告系统对编译优化技术的两大诉求，为未来编译技术在提升系统性能和资源利用率上指明了方向。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/icntuIQtpSJWA8PaOWuFElV1LAhnGz6CgzUictjVGdB8bPib2CmmYVZfoLwOBOHYlLd77U6oE49Xd3KLrIguuib1wg/640?wx_fmt=jpeg&from=appmsg#imgIndex=6)

**06**

  编译课程建设与产学合作 

北京航空航天大学计算机学院张莉教授围绕编译课程建设与产学合作展开。他系统回顾了“华为毕昇杯”编译竞赛（2020-2025）的历年情况，强调了竞赛在推动编译教学和人才培养中的重要作用。他详细阐述了编译课程的建设情况，包括课程目标、内容设计、实验平台和教学方法。他还介绍了“101计划”编译原理课程虚拟教研室的建设规划，讨论了编译课程在不同高校的差异化设计和产业需求的结合，以及未来编译课程的发展方向和面临的挑战。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/icntuIQtpSJWA8PaOWuFElV1LAhnGz6CgblmXqMpeLnnZRNDH5VFnx45ibv94GbprGqpE9nia578IAeyjbjbQgdjQ/640?wx_fmt=jpeg&from=appmsg#imgIndex=7)
