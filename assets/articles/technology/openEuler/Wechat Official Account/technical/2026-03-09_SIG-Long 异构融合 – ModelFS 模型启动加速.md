# [SIG-Long 异构融合 – ModelFS 模型启动加速](https://mp.weixin.qq.com/s/jhL2nzfO25_ctt4qkI10JA)

[OpenAtom openEuler](javascript:void%280%29;)*2026-03-09 17:30:00广东*

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a47pmwYKrTftvGXyFfspek4hoUibdJtrBB96517RL4k2AXD1gSav958g/640?wx_fmt=gif&from=appmsg)

**01 背景**

OpenAtom openEuler （简称“openEuler”或“开源欧拉”）作为全场景开源操作系统，是连接底层硬件和上层应用的桥梁。**ModelFS针对大语言模型（LLM）推理启动阶段的模型加载瓶颈进行优化。**现有相关工作主要通过优化推理框架来提升模型加载性能，这种方法往往以牺牲兼容性为代价。然而，基于我们的工业实践经验，兼容性是决定一项技术能否在实际场景中广泛应用的关键因素。

本工作在保证强兼容性的前提下，通过优化文件系统的缓存策略，实现了模型加载性能的领先水平。 ModelFS在内核中设计了一个非侵入式、灵活且轻量级的可编程页缓存框架，允许用户自定义文件系统的页缓存策略。基于可编程页缓存，我们进一步设计了面向模型加载优化的缓存策略的参考实现。

**02 技术架构**

![](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOu29gkFGbB9m7FHfmE4pqNWKBRuBaXlZzKcOXFqmzqKcXVicjcZXmmNUZIyP8ALozAaVOPiatJK9QcVYwRRZ6sLJoC1w8ojVsBYo/640?wx_fmt=png&from=appmsg)

**ModelFS-K：**ModelFS的内核模块，提供文件系统页缓存可编程框架。它是一个堆叠文件系统，可以挂载到现有文件系统之上，ModelFS-K将底层文件系统的缓存策略（预取和淘汰）逻辑用一个特殊的用户态调用组件（UPC）重定向到用户态实现的策略逻辑上。

**ModelFS-U：**ModelFS的用户态模块，提供缓存策略的运行时。它提供一套类似于VFS的用户态编程框架，模型实现者/IO优化者可以根据模型的加载IO特性自定义缓存策略。用户可以在用户态通过重载ModelFS-U提供的函数进行定制，ModelFS-U会将它们注册到ModelFS-K中，并在运行过程中负责解析IO事件和进行异步数据预取/淘汰。

**03 实现原理**

作为参考实现，ModelFS基于可编程缓存框架设计了一个面向模型加载的缓存策略。由于相同推理服务的模型加载IO行为是确定的，ModelFS提出了IO模板的概念，即在推理服务第一次启动时追踪其IO行为生成模板，该模板精确记录了各个NPU加载的模型数据和时序。依赖IO模板，ModelFS进一步实现了以下三个优化：

**精准预取：**

根据模型数据的访问数据执行并发精确预取，充分利用SSD带宽。

**NPU亲和加载：**

动态感知数据目标NPU并加载到与其亲和的NUMA节点上，提高H2D传输效率。

**阅后即焚淘汰：**

当数据被加载到NPU后便可以将其从内存缓存中淘汰，提高内存受限场景下的缓存效率。

ModelFS可用于多种类型存储后端的IO加速，包括本地FS，分布式FS，对象存储（OBS）等，以下是两种典型的用法：

**（1）远端OBS存储权重预热：**对于模型权重存储于远端OBS的情况，由于OBS带宽低，推理系统往往会将热点权重提前预热到本地存储。ModelFS可以通过实现IO聚合的缓存策略，将多个OBS桶的带宽聚合来加速权重预热。

**（2）本地SSD权重加载加速：**对于模型权重存储在本地SSD的情况，性能瓶颈在于本地SSD带宽利用率低。ModelFS实现了一种基于I/O模板的机制，在第一次运行时追踪每个推理服务的IO加载行为，而在后续推理启动过程中可以精确感知未来的IO行为，进而充分利用SSD带宽、XPU 亲和性以提升预取与淘汰机制的效率。

**04 效果展示**

![](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOvs3Qdwk6sSO9E7G0rs3FvO9wicWYPQuruldXibc0pLyR0SZkWpYldl4VUrI8F7HNOjRWban5Iibqr3xlHI0aYn0QItVkHibO1mzRs/640?wx_fmt=png&from=appmsg)

对比模型在EXT4、在ModelFS（底层文件系统使用EXT4）以及在内存缓存三种情况，**结果表明，ModelFS相比于原生EXT4有4倍的性能提升，**甚至优于全量缓存的方案，这主要得益于ModelFS能充分利用了SSD的带宽和NPU亲和。

**05 接口功能**

ModelFS-U在用户态提供如下编程接口，用户通过重载进行策略定制：

- init()：初始化策略的运行环境，并将策略注入ModelFS
- exit()：卸载策略并清理策略运行环境
- prefetch()：执行预取策略，当ModelFS-K有缺页事件上报时会被调用
- evict()：执行淘汰策略，当ModelFS-K有缺页事件上报时会被调用

**06 总结与展望**

模型加载是推理服务启动过程中的一个关键瓶颈。然而，现有的模型加载优化方法缺乏兼容性，从而限制了其应用场景。ModelFS通过优化文件系统的页缓存策略来加速模型加载，同时确保与推理生态、操作系统和硬件的兼容性。ModelFS提出了一种高效的可编程页缓存框架允许用户自定义内核的缓存策略。在此基础上，它实现一种包含精确预取，NPU亲和，阅后即焚淘汰三种机制的缓存策略来加速模型加载。**实验结果表明，在许多场景下，ModelFS相比现有系统显著提升了模型加载性能。**

ModelFS未来会从两个方向演进：一是拓展适用场景，例如KVCache存储的缓存策略优化等；二是提升用户态策略编程的易用性，例如封装python等高级语言的开发库，使上层的开发人员也能轻松根据特定负载定制内核文件系统的缓存策略。

**07 社区支持**

ModelFS开源仓库：

https://atomgit.com/openeuler/kernel/tree/OLK-6.6

![](https://mmbiz.qpic.cn/sz_mmbiz_gif/rxr9tddEHOukmrzE56Oa4UrKgsv00gia5qeegGwR01DTLuDKiaxaHiaYc4qWalR8KVaCTgXqUiayG3M5G5PwrLbRiajLxP7oTn62BdVHxPdxDdrE/640?wx_fmt=gif&from=appmsg)

# **欢迎加入我们**

openEuler SIG-Long 

已面向开发者开源核心技术方案，

诚邀行业伙伴、高校与个人开发者交流合作方向

可添加小助手微信

加入 SIG-Long 微信技术交流群，

或访问 AtomGit 平台了解相关材料、提交 issue

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/rxr9tddEHOvtxgjk2a149OTqKRhkeF32bFecDQrGDiadF9ibDnd7PXCmDHuhuwsiaySP39zUIbQhjAQAHLbxbNm3nY7SLBqclJyyBpZrqGLIwQ/640?wx_fmt=jpeg&from=appmsg)

（长按识别或扫码添加小助手）

供稿 | 刘育擘

编辑 | 丘云

校审 | 刘靖蓉、郑振宇、刘彦飞

**关注我们，了解更多**

**▼**

往

期

精

彩

[SIG-Long 异构融合 - 技术整体介绍](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247517770&idx=1&sn=9fd801716b2dddd7715a7018e8be9b4b&scene=21#wechat_redirect)

[SIG-Long 异构融合 - 基于灵衢的内存池化借用](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518012&idx=1&sn=66b421b7475cb26cecc0690436aed3d6&scene=21#wechat_redirect)

[SIG-Long 异构融合 - 性能提速 50%+，xlite 轻量化推理运行时，让 Ascend 平台大模型推理效率飙升](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518135&idx=1&sn=e36883e88bb3f1de770623c860db0bc9&scene=21#wechat_redirect)

[SIG-Long 异构融合 - 昇腾高性能 KVCache 池化框架](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518192&idx=2&sn=7cb8879ea1601cf8b496741045728fa7&scene=21#wechat_redirect)

[SIG-Long 异构融合 - 基于灵衢池化的可靠性方案](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518222&idx=1&sn=be3155e1f56bd7c1c8c2051c8e7dbed2&scene=21#wechat_redirect)

[SIG-Long 异构融合 - GMEM](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518313&idx=1&sn=6ddde325b06f63c91a2bac07a7c5d8d4&scene=21#wechat_redirect)

[SIG-Long 异构融合 - xSched 算力切分与混部技术](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518352&idx=1&sn=2c03676348a6981896a834d632762bb1&scene=21#wechat_redirect)

[SIG-Long 异构融合 - XPU迁移与可靠性 XMIG](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518389&idx=1&sn=21f70a101f532349a0731591b53137c8&scene=21#wechat_redirect)

[SIG-Long 异构融合 - 内存资源利用率提升](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518447&idx=1&sn=b6dfcf6579fab00b5d7664168f1fde48&scene=21#wechat_redirect)

[SIG-Long 异构融合 - TrIO加速容器镜像加载](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518515&idx=1&sn=a9d2bf3c033be4d4fdf12dc10871eb3e&scene=21#wechat_redirect)

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAu6uoNwIYnzAzDia2bcCgQ3iagEdQ0PzZibjzfarqzdq6iaB6bTDNDonTCpm4rj2X5IyvMccpHTQq70Q/640?wx_fmt=png&from=appmsg)
