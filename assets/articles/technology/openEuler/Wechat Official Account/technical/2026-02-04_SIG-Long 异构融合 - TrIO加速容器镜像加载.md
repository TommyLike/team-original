# [SIG-Long 异构融合 - TrIO加速容器镜像加载](https://mp.weixin.qq.com/s/mAfm1GiqQixDtmmmCdoYrQ)

[OpenAtom openEuler](javascript:void%280%29;)*2026-02-04 18:00:00广东*

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a47pmwYKrTftvGXyFfspek4hoUibdJtrBB96517RL4k2AXD1gSav958g/640?wx_fmt=gif&from=appmsg)

**01 背景**

OpenAtom openEuler （简称“openEuler”或 “开源欧拉”） 作为全场景开源操作系统，是连接底层硬件和上层应用的桥梁。容器已成为云计算重要的基础设施，容器启动性能是关键性能指标，在弹性扩容、故障恢复、热点消减等场景中尤为重要。由于容器镜像体积大、启动流程复杂，使得容器启动时间大幅变慢，例如基于 Pytorch 的 AI 容器启动需要好几分钟，已成为开发者核心痛点。当前产业界方案主要采用懒加载的优化策略，即在启动时只加载一小部分镜像，在运行时按需触发加载使用到的镜像，但现有懒加载存在 I/O 效率低、频繁网络传输、预取不精准等问题。**本工作提出一种新的镜像抽象，称之为运行时镜像（Runtime Image）和配套的I/O栈来显著加速容器冷启动。**

**02 技术架构**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mDl2UzAicHhTEybXhSjGgDmJJ4g2hsx9MwfvXiabVcHpBe1iapvvP9EQQgWfH6l7UO1YUrEwIv73IEUQ/640?wx_fmt=png&from=appmsg)

TrIO是懒加载系统（如Nydus）上层的一个I/O加速中间件。如上图所示，TrIO主要包含如下组件：

**TrIO Snapshotter ：**在容器运行时内工作，起到控制面作用。

**I/O Tracker ：**在操作系统内核中工作，并在容器运行期间收集 I/O 行为。

**RTPC（运行时页缓存）：**在文件系统中实现，它基于容器镜像和 I/O 特征高效构建容器的根文件系统。

**Runtime Image Service（运行时镜像管理服务）：**部署在镜像仓库后端用于服务于运行时镜像管理。

**03 实现原理**

容器启动过程中会使用分散在不同文件中的不同部分，从而频繁触发网络 I/O 来读取不同文件内容，造成效率低下。TrIO 的核心思想是减少启动时需加载的数据量和聚合 I/O 操作。基于此，我们设计了运行时镜像，它可以被看做为容器服务启动状态下的一个极简的内存快照。

TrIO 首先利用 eBPF 跟踪收集容器启动时读取镜像文件的所有 I/O 请求，然后将这些 I/O 请求编排到运行时镜像中，并将它们推送到镜像仓库后端。在容器启动时，只需要一次大 I/O 将运行时镜像一次性拉到本地容器节点，即可完成镜像读取，大幅降低了 I/O 次数，提升了 I/O 和网络效率。

经过 I/O 聚合后的镜像，在本地容器节点无法直接生成容器的根文件系统，而需要将聚合后的内容还原回每个文件对应的部分。TrIO 中的运行时页面缓存来解决这个问题。运行时页面缓存构建在 EROFS中，将聚合镜像中的内容缓存在相应文件的区域并建立索引。进一步运行时页面缓存提供增量加载和去重的功能，不同聚合镜像中相同的页面会映射到同一个运行时页面缓存，减少了系统的内存占用。

**04 效果展示**

我们用nginx，redis， tomcat，pytorch容器做测试，同时选取2个对比基线，分别为全量容器镜像加载（Base）和主流的懒加载系统（Nydus），TrIO运行在Nydus之上用于加速I/O。以python为例，TrIO 相比于全量镜像加载和懒加载，服务启动的加速比达94%。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mDl2UzAicHhTEybXhSjGgDmJic1BwV54uiaz0pUms6hsrFTrRAaFvZJPuf4ZlrR4dbTSCh9UHtpYSEgA/640?wx_fmt=png&from=appmsg)

**05 总结与展望**

本工作致力于解决容器冷启动慢的问题，我们提出了一种新的镜像抽象方式——运行时镜像，能够实现高效的网络传输和快速的根文件系统构建。此外，我们设计了TrIO，其中包含高效的运行时镜像和轻量级的I/O栈来优化容器镜像服务。**评估结果表明，在许多场景下，TrIO的性能相比现有系统有显著提升。**TrIO未来计划与新型内存语义互联结合，提升超节点架构下的容器运行效率。

**06 社区支持**

TrIO开源仓库：

https://atomgit.com/openeuler/kernel/tree/openEuler-25.03/tools/trio

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mDl2UzAicHhTEybXhSjGgDmJ8BVJ5KEvkquVZZN8n5jicib6gXicfNrStnQiaJ6ULwibRQJTia6AicWeMoLzw/640?wx_fmt=gif&from=appmsg)

# **欢迎加入我们**

openEuler SIG-Long 

已面向开发者开源核心技术方案，

诚邀行业伙伴、高校与个人开发者交流合作方向

可添加小助手微信

加入 SIG-Long微信技术交流群，

或访问 AtomGit 平台了解相关材料、提交 issue

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mDl2UzAicHhTEybXhSjGgDmJJZN0wXbkSWKFJcH55A26HYicAAT5g7XYopCgvdLiaiaL5ppaRhrTmmibAg/640?wx_fmt=jpeg&from=appmsg)

（长按识别或扫码添加小助手）

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

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAu6uoNwIYnzAzDia2bcCgQ3iagEdQ0PzZibjzfarqzdq6iaB6bTDNDonTCpm4rj2X5IyvMccpHTQq70Q/640?wx_fmt=png&from=appmsg)
