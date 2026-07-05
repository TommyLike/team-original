# [Rust Meetup 深圳站来了！！！](https://mp.weixin.qq.com/s/Ua_jIqPZ6M1HCOqiXB9YmQ)

[OpenAtom openEuler](javascript:void%280%29;)*2021-03-09 20:47:42*

Rust 做为一种全新的系统编程语言，最近几年在国内外的热度持续升温，并且逐渐的落实到实际应用中。

3 月 27 日，由华为、openEuler 、Netwarps、开源中国和 Rust 中文社区联合主办的 Rust Meetup 将在深圳举行。

此次 Meetup 将围绕 Rust 语言无栈协程、Rust 实际应用、Rust 科学计算等方向进行分享。

届时我们会邀请华为、Netwarps、PingCAP 、openEuler 开源社区、Rust 中文社区、开源中国等企业中的 Rust 开发者参与分享。

活动地址：广东省深圳市福田区中康路136号新一代产业园4栋19楼

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMY5bweSSiasUpt8AUNXc534QdyEIzWDugkkkA7IKMyqy3vDz0SUfljlibjBAlDGgy7CYrs1tV0HbW9g/640?wx_fmt=png)

我要报名

**分享嘉宾及议题介绍**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMY5bweSSiasUpt8AUNXc534Qo5MJibhuxGIn1rGCtFsObVwQQl0dFV8IGJjnLqVPQnXslcdgTCicicQ5w/640?wx_fmt=jpeg)

分享主题：从 libp2p-rs 到 IPFS

本次分享将介绍 libp2p-rs 项目开发历程，探讨使用 Rust 进行网络异步编程的设计思路与原则，概述 libp2p-rs 的各个模块的设计与实现。最后是关于使用 libp2p-rs 作为底层支撑构建 ipfs 公网节点的经验分享。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMY5bweSSiasUpt8AUNXc534Q2ibrB0aq1MVhr5MvQClHpvLDib2JP8PAWlJlYvn5DEKhHFYtW7ia7ibccg/640?wx_fmt=jpeg)

分享主题：Rust 科学计算多维数组运算库的分析与实践 

向量及矩阵运算是数学计算的基础技术，本次将分享演讲人在 Rust-ndarray 社区贡献的支持 no\_std 轻量级模式、优化负步长数组运算性能、增强并行加速功能等关键特性，分享对完善、优化 Rust 数学计算关键技术生态的思考。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMY5bweSSiasUpt8AUNXc534Qs9OdSQ2R0MiawOyRdBPEMtUia5MrSPsI3yWMHM13dTgJbvWibU0ZtlYyQ/640?wx_fmt=jpeg)

分享主题：深度剖析 Rust 异步编程/无栈协程 

协程在新兴编程语言中越来越受到重视，此次分享将对比 Go、Rust 语言探讨有栈协程和无栈协程的差别、优缺点；并详细阐述 Rust 中 async/await 无栈协程的实现。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMY5bweSSiasUpt8AUNXc534QzCF1cHG0Ktc8h9FuWFwYpq2bjicpe8SFvO0dTvItuxmkqTIJNDnOeqA/640?wx_fmt=jpeg)

分享主题：Rust FFI 跨语言代码复用的方法和实践 

TiKV 提供包括 Python/Rust/C++/Java 等多种语言的 Client，而由于 Client 逻辑复杂且与 TiKV 正确性密切相关，工程上难以实现并维护多套 Client。Rust 优秀的抽象能力让跨语言 FFI 变得前所未有的简单，因此我们可以基于同一套 Rust Client 作为内核构建多种语言的 Client。本次将分享 Rust FFI 的使用方法、社区生态以及在 TiKV 中的实践。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMY5bweSSiasUpt8AUNXc534QBK3TiaUcpWkkbRqRmkxgjibnc3YIGCs3pVM2BiaHN3ndkcTFSQt3j3Yiag/640?wx_fmt=jpeg)

分享主题：Rust 语言在系统开发（虚拟化平台 StratoVirt）的实践与应用 

StratoVirt 是下一代高性能、低开销、强隔离的轻量虚拟化产品，作为云原生底座，应用于 ServerLess、Microservice 等业务场景。Rust 语言特点是高性能、高并发和高安全，非常适合做轻量虚拟化产品开发，而且 Rust 面向对象的特性，在 StratoVirt 项目中应用非常广泛，如虚拟机抽象、内存抽象、设备抽象等等。本次将分享 StratoVirt 产品架构，以及 Rust 在 StratoVirt 的应用实践。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMY5bweSSiasUpt8AUNXc534Qz154K0zvcSMb7rFcD7ZxBs9U6XeuUO4Ox8xeaHbAczpI0uvw1xMslg/640?wx_fmt=jpeg)

分享主题：基于 TVM Rust Runtime 和 WASM 沙箱运行 AI 模型 

目前负责新型计算运行时（例如 WebAssembly 技术）研究和 MindSpore AI 框架的开源社区运营。在此之前，他作为 OpenSDS Hotpot 项目的 PTL 与 OpenSDS 团队一起工作，同时也是 OpenStack、OPNFV 和 Open Service Broker API 等社区的积极贡献者。

本次分享首先会介绍下 TVM 深度学习编译器以及 WASM 技术的整体架构，然后展示基于 TVM Rust runtime 和 Rust compiler 进行 AI 模型的加载和 WASM bytecode 编译的端到端流程，最后通过演示一个 demo 实现 AI 模型的编译、加载和执行的全场景部署工作。

 **日程安排** 

13：00-13：30 签到

13：30-14：10 主题分享 谢敬伟@Netwarps

14：10-14：50 主题分享 李原@华为

14：50-15：30 主题分享 何元勋@Netwarps

15：30-15：40 休息/自由交流

15：40-16：20 主题分享 骆迪安@TiKV

16：20-17：00 主题分享 张亮@华为

17：00-17：40 主题分享 王辉@华为

17：40-18：00 QA/自由交流

 **活动礼品** 

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMY5bweSSiasUpt8AUNXc534QpibVRgrMu4dWliaeMaaibIBibKevicMpiaZ8DpiaJPB2Fl4FJ1qJic7uDKwt0w/640?wx_fmt=jpeg)

 **主办方** 

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMY5bweSSiasUpt8AUNXc534QFLnFpTEobFaGKzbcgShU7M7OE69tuEerABdXib4PN6WCLJP49Qd1DaQ/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMY5bweSSiasUpt8AUNXc534Q98vKbxsh4U7icnUicjwBMmQyjheMPd5OeCPq8wCWZ7bme9pfVpl0dCHA/640?wx_fmt=jpeg)

 **协办方** 

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMY5bweSSiasUpt8AUNXc534QBODvGXdHkqdHVK4kw47NtsS7jOjuwHc4767RQ2ozYRr12pwPL5nf5g/640?wx_fmt=jpeg)

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMY5bweSSiasUpt8AUNXc534QeRfVP8raML2vrndMYtyshBpVeS1yvbUN4QYiblaej5ribEUMszholpgQ/640?wx_fmt=jpeg)

[阅读原文](https://www.oschina.net/event/2321485)
