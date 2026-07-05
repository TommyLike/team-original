# [SIG-Long 异构融合 - xSched 算力切分与混部技术](https://mp.weixin.qq.com/s/yb6RcOhOpN2o-EtTFVcB1w)

[OpenAtom openEuler](javascript:void%280%29;)*2026-01-20 18:11:50广东*

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a47pmwYKrTftvGXyFfspek4hoUibdJtrBB96517RL4k2AXD1gSav958g/640?wx_fmt=gif&from=appmsg)

**PART.01**

**背景介绍**

OpenAtom openEuler（简称“openEuler”或 “开源欧拉”） 作为全场景开源操作系统，是连接底层硬件和上层应用的桥梁。在计算领域，计算能力是推动AI技术发展的驱动力之一，为了提升AI运算速度，各大厂商纷纷推出了自己的AI计算设备。但多数AI卡缺乏优先级、公平性、抢占、算力带宽控制等高级调度能力，无法满足中小AI模型多任务混部场景的诉求，比如在线-在线推理混部，在线-离线推理混部等。中小AI模型独占部署，导致AI卡资源利用率低，造成严重的资源浪费。

xSched是面向中小模型的算力切分与混部技术，在多推理任务混部场景，提供按需分配单卡算力的能力，解决按卡粒度分配资源导致过分配的问题，并对接容器生态。在多训推混部或在离线推理混部场景，实现推理任务快速抢占离线推理或训练任务，保障高优先级任务性能的前提下，提升 AI卡资源利用率。值得注意的是，上海交大团队在OSDI’25 发布的异构 XPU抢占式调度框架也叫XSched，与本技术方案是两种不同的技术路线，但解决的核心问题是一致的，旨在提供一套通用的异构调度框架，为各类XPU设备提供高阶的调度服务能力，兼顾性能、兼容性与应用透明性，支持灵活策略扩展。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2VtlibCgVJrKHnpiapjFRDqnTer5HVhaaFAh6gAOibicSdFuxeiaczicovCxw/640?wx_fmt=png&from=appmsg)

▲OSDI’25 XSched 技术架构

**两者设计上的主要区别如下：**

● 上交XSched方案在用户态实现，易部署、平台兼容性和可移植性更好。本技术方案在操作系统内部实现，提供build-in和驱动模块两种形态，能够协同更多底层资源，实现更精细和更丰富的调度策略。

● 上交 XSched 方案在AI进程启动时，通过动态库预加载的方式实现AI应用算子流劫持，在公有云场景中容易被绕过。本技术方案能够在内核态劫持AI应用算子流，无需 AI 进程预加载动态库，应用完全无感。

**PART.02**

**技术架构与原理介绍**

xSched是面向中小模型的通用的调度框架，能够为 NPU、GPU等各类 XPU 提供基础的调度机制，包括任务抢占、时间片切分、组调度、算力带宽管控等，并构建公平调度策略、实时调度策略等多种调度策略，满足不同AI场景调度算法的诉求。xSched基于Cgroup对接云原生容器生态，提供容器级的调度策类、优先级、权重、算力和内存带宽控制的功能，并基于syscall接口提供进程/线程粒度的调度类和优先级配置功能。设计上预留对接其他XPU的能力，各类XPU设备也能够注册到xSched调度框架。xSched 实现了AI任务的抽象与管理，对Context、Stream、Kernel等进行了统一抽象，并实现对AI任务运行中的资源包括SQCQ、Event 等进行统一管理。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2VgrXfcCn7Gc2ecpEWL6srrF4Bpr1TdMIayjBemfvuUn5WFeu5B1osA/640?wx_fmt=png&from=appmsg)

**调度原理介绍：**

1.每个AI进程对应到内核中的一个Context对象，Context对象保存此AI进程的上下文信息，一个Context包括多条Stream 流。

2.每条Stream流包含多个Kernel，Stream流中的Kernel必须按顺序执行；Stream是最小并行运行单元，Stream流之间通过Event\_wait与Event\_record语义进行同步，这里的Stream流抽象成一个Task。

3.一个Cgroup中的Tasks 抽象成一个Task Group，Task与Task Group统一抽象成一个Sched Entity。

4.一个XPU或者VF抽象成一个算力单元（XCU），每个XCU有一个对应的任务队列。

5.每个XCU上有一个相应的线程用于调度，调度机制即找到对应的Task，从Task 中找出对应的算子发送到XPU 中。通过控制每次发送给XPU的算子数量来控制吞吐和时延。

6.每次发送完成后，监控算子在NPU中执行情况（执行完成或者异常），当算子执行完成后会触发进行下一次调度。

**核心功能介绍：**

●CFS 调度：每个任务队列是一个红黑树，红黑树中的每个叶子节点是一个Sched Entity，对应的是一个Task或者一个Task Group，Task 为Stream流的抽象，每个Sched Entity 维护一个Vruntime，用于维护任务的公平性。高优先任务vruntime增长慢，低优先级任务 Vruntime增长快。红黑树最左侧叶子节点为下一个需要运行的 Task。

●RT 调度：每个任务队列是一个链表，RT调度器支持五级优先级，高优先级RT可以抢占低优先级任务，同级优先级任务通过FIFO或者RR调度算法进行运行。

●任务抢占：支持高优先级任务抢占低优先级任务，默认在算子边缘进行抢占，当任务入队列时或者 Timer 时间片到期时触发抢占，此时会检测是否能抢占，当入队列的任务比正在执行任务的优先级高时会触发抢占，此时只会在当前任务上设置抢占标识，只有当当前任务已经提交给 XPU 中的算子执行完成后才能真正意义上的抢占，切换到下一个任务进行运行。

●算力带宽管控：容器可以配置算力带宽（quota/period），表示容器可以使用quota/period 张AI卡，其中quota小于period，每个period周期内，容器可以使用quota大小的时间片。当quota时间片使用完之后，所在容器的AI任务stream流将不再被调度下发算子给XPU设备处理。同时启动一个period 周期性的定时器，到期后重新填充 quota 时间片，恢复对XPU设备的使用。

**PART.03**

**效果展示**

**? 多进程算子任务公平调度**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH24qdKxxnHxPor4kNlHDG2RalaO5bTBicJGagfwe6gLDCaNicyzRiaMJiaCQ/640?wx_fmt=png&from=appmsg)

配置CFS调度类，多进程公平竞争NPU卡算力，每个进程得到一致的 NPU 卡占用时间。

? **按权重算力分配机制**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2TVBTsNfXY4bfmNibsVSHQ3bicUasrpfibjw2UWib37c0ib0kqWsHGzJvkKw/640?wx_fmt=png&from=appmsg)

支持权重控制，多个AI进程按照比例竞争NPU卡算力，权重越高占用NPU卡时间越长。当NPU卡没有其他AI任务使用时，又可以独占NPU卡算力。

**? 任务抢占**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2B1j24f6VXYvKTFbbjonLjRhrQuicsJXhSbLFaTS9ETeDt3KxUcuGQ0A/640?wx_fmt=png&from=appmsg)

算子边缘抢占：在算力边缘触发抢占，最小实现单算子粒度抢占时延。

算子步长可调节：算子批量下发，步长可调节，AI任务按需配置。

**? 算力带宽控制**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH23pVgb21w2p783WULXTCcRSMEs5S6pafMtVTkeiccceYZwmvbTBvWtSQ/640?wx_fmt=png&from=appmsg)

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2f9eiaqZGp8JTnp1varErbDhLnRluiaC9UcWtVjVj3lGiaVutE8UrWzRMw/640?wx_fmt=png&from=appmsg)

与 Linux CPU 带宽管控语义和能力一致，按算子执行粒度进行时间片结算，最大限度降低业务性能抖动。支持动态调整算力切分大小，精准按配额时间片执行。

**? 混部场景性能测试**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2ehWZia90615eYcsjqPSHLFx81MdAJOJ2BjyqibniaCdYd8n10zcibhZ5hA/640?wx_fmt=png&from=appmsg)

xSched多进程混部，相比独占部署方式，高优平均时延劣化2%~3%，总吞吐提升33.5%~41.2%。

**? 底噪测试**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2O8wSAmCX6OC8SbzmbC3F6wrFmNdqwSgMfL7fDH3b03CmsoIOJJAX2w/640?wx_fmt=png&from=appmsg)

独占部署场景下，测试 Deepseek1.5 推理和 Resnet50 训练性能损失 &lt;1%。

**PART.04**

**接口功能**

**xcu.sched\_class**：配置调度类，cfs 或 rt；

**xcu.period\_ms**：配置获取算力资源时间片周期，默认 100ms（需先设置为 cfs 调度类）；

**xcu.quota\_ms**：配置周期内可分配的时间片，比如配置 50ms，则每 100ms 内可分配 50ms，-1 则是不管控算力资源（需先设置为 cfs 调度类）；

**xcu.shares**：配置 cfs 任务的权重，权重越大，相比于其他任务的优先级越高，默认为 1024（需先设置为 cfs 调度类）；

**xcu.stat**：查看统计信息，仅支持 cfs 调度类。

**PART.05**

**社区支持**

● xSched kernel开源仓库：*https://atomgit.com/openeuler/kernel/tree/OLK-6.6*

● xSched 用户态组件仓库：*https://atomgit.com/openeuler/libXSched*

**PART.06**

**未来规划**

支持动态灵活的空分能力，按 Aicore 粒度分配，进一步提升 AI 卡资源利用率。

● 支持灵活显存切分能力，实现租户间显存隔离

● 支持任务数据在主机侧和NPU侧快速切换（swap-in/swap-out)，内核超分能力

● 支持 HBM 读写带宽与Cache隔离能力，支持更精细的QoS管控，降低关键业务干扰

● 支持异构可编程调度能力，定制业务场景调度策略

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2w4nr267TKwMaKZSv6gicgAL159y0SnsickR6swI0d9AH0eKlYgS8kf7g/640?wx_fmt=gif&from=appmsg)

# 欢迎加入我们

openEuler SIG-Long 

已面向开发者开源核心技术方案

诚邀行业伙伴、高校与个人开发者交流合作方向

可添加下方小助手微信

加入 sig-Long微信技术交流群

或访问 AtomGit 平台了解相关材料、提交 issue

*https://atomgit.com/openeuler/kernel/tree/OLK-6.6*

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2skQpmdTk41BSeS9MfUwuq5Bk6tGtpicNX0AjicJHDFXV9UQ6JLPMic6DQ/640?wx_fmt=jpeg&from=appmsg)

（长按识别或扫码添加小助手微信）

**关注我们，了解更多**

**▼**

往

期

精

彩

[SIG-Long异构融合技术整体介绍](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247517770&idx=1&sn=9fd801716b2dddd7715a7018e8be9b4b&scene=21#wechat_redirect)

[SIG-Long异构融合 - 基于灵衢的内存池化借用](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518012&idx=1&sn=66b421b7475cb26cecc0690436aed3d6&scene=21#wechat_redirect)

[SIG-Long 异构融合 | 性能提速 50%+，xlite 轻量化推理运行时，让 Ascend 平台大模型推理效率飙升](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518135&idx=1&sn=e36883e88bb3f1de770623c860db0bc9&scene=21#wechat_redirect)

[SIG-Long 异构融合- 昇腾高性能 KVCache 池化框架](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518192&idx=2&sn=7cb8879ea1601cf8b496741045728fa7&scene=21#wechat_redirect)

[SIG-Long 异构融合 - 基于灵衢池化的可靠性方案](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518222&idx=1&sn=be3155e1f56bd7c1c8c2051c8e7dbed2&scene=21#wechat_redirect)

[SIG-Long 异构融合 – GMEM](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518313&idx=1&sn=6ddde325b06f63c91a2bac07a7c5d8d4&scene=21#wechat_redirect)

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAu6uoNwIYnzAzDia2bcCgQ3iagEdQ0PzZibjzfarqzdq6iaB6bTDNDonTCpm4rj2X5IyvMccpHTQq70Q/640?wx_fmt=png&from=appmsg)
