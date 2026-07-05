# [openYuanrong 亮相 2026 QCon 全球软件开发大会](https://mp.weixin.qq.com/s/7S39EO5yXlM_xfSuyXgfrA)

*雷十一*[OpenAtom openEuler](javascript:void%280%29;)*2026-04-28 17:47:18广东*

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a47pmwYKrTftvGXyFfspek4hoUibdJtrBB96517RL4k2AXD1gSav958g/640?wx_fmt=gif&from=appmsg)

2026年 4 月 18日，在OpenAtom openEuler（简称“openEuler”或“开源欧拉”）开源的openYuanrong 亮相 2026 QCon 全球软件开发大会，大会在北京国家会议中心举行。

在梁义博士出品的"AI原生基础设施"专题论坛上，openYuanrong 架构师吴杰发表主题演讲，正式发布 openYuanrong v0.8.0 版本。新版本面向 Agentic AI 场景全面升级，强化了对 Agent 调度、强化学习训推协同、推理服务缓存等核心能力的支持。演讲同时深入分享了 openYuanrong 在 Agentic AI 时代的架构演进思路与关键技术实践。

![图片](https://mmbiz.qpic.cn/sz_mmbiz_png/qCr335HdbQaw7WNr9zicU7niaHTJavjXWKMiaBBKbns9ZFt86NDvoiawMJHH7rNX9iaUs5UcsJnWcdJmFTQ2PVonw2hWxeDCJJxErKWrUchXRN4o/640?wx_fmt=png&from=appmsg&watermark=1#imgIndex=0)

## **从烟囱到积木：AI Infra 的架构演进**

本次演讲以《从烟囱到积木：基于 openYuanrong 的 AI Infra 实践》为主题，重点探讨了 Agentic AI 负载对分布式系统带来的全新挑战，并展示了 openYuanrong 如何通过“单机体验、分布式运行”的理念解决这些难题。

## **Agentic AI 带来的核心挑战**

演讲指出，随着 AI 从传统的推理服务向 Agentic（智能体）架构演进，系统面临着三大核心挑战：

- **1.负载形态剧变：**从毫秒级的无状态请求转变为小时级的有状态 Session，导致长程 Session 的并发度与资源利用率难以平衡。
- **2.沙箱系统要求：**需要支持动态生成代码的一次性沙箱，对启动和回收速度提出了“秒级”甚至更高的要求。
- **3.资源效率瓶颈：**在强化学习（RL）场景中，训推同步共卡架构导致 NPU 资源出现大量空泡，且多 Agent 场景下资源利用率波动极大。

## **openYuanrong 的关键技术突破**

针对上述挑战，openYuanrong 提出了面向 Agentic AI 负载的两个重大的关键技术实践：

**Agent&推理技术实践：**

- Session动态迁移提升集群负载均衡，以及迁移长时任务回收空闲实例，提升资源利用率。
- 通过沙箱超售、沙箱快速回补、Session并行调度实现大规模session-沙箱调度技术。
- 通过会话级推理历史缓存管理以及Session上下文缓存调度，实现推理服务集群缓存资源在Agent会话之间高效时分复用。

**Agentic RL 技术实践：**

- 通过CPU将训练任务HBM中的参数卸载至DDR并转换为分布式格式，推理实例可从远程DDR或其他推理实例的HBM中获取参数分片至本地显存，实现模型参数异步更新。
- openYuanrong 作为 TransferQueue 数据面后端，提供TransferQueue 的KV后端分布式存储能力和KV跨节点的高速传输能力，实现RL样本数据分布式KV存储和高速传输。
- 通过函数集合共享资源调度、函数集合状态极速切换，实现集合调度实现多个RL任务动态共享NPU资源空泡，提升集群NPU利用率10%。
- 通过异构函数实例动态调度、异构函数自动休眠和唤醒，实现异构函数自适应动态调度，提升Multi Agent场景异构资源利用率10%。

## **openYuanrong 生态落地：全场景核心业务实践**

### **蚂蚁的全栈实践**

蚂蚁 AKernel 技术团队在 QCon 上分享并介绍了一个面向 AI 原生开发者的 Datacenter-Use 框架。基于 openYuanrong 分布式调度、分布式缓存、多语言 SDK，结合蚂蚁 AFaaS 的安全隔离、极速启动、Checkpoint/Restore 的能力，引入镜像加速和懒加载、动态资源管理等功能，达成跨实例、跨节点高性能数据共享，实现10ms 级节点侧启动、40ms 端到端延迟的极致弹性，赋能Agent 暂停恢复与克隆。在 Agent 长会话、RL 训练任务、Spark 数据处理的场景中，显著降低资源碎片率，提升任务响应速度与资源利用效率。

![图片](https://mmbiz.qpic.cn/mmbiz_png/qCr335HdbQaD4T7DEW7Rel4x16UrAmQVaoAzRnMB846d51Ft6Nro6EFvXNnpiatJ563kxFIp5oAaHoZE9OTdMujCmBbB6DwtwkfibuSOZFJ8Q/640?wx_fmt=png&from=appmsg&watermark=1#imgIndex=1)

![图片](https://mmbiz.qpic.cn/sz_mmbiz_png/qCr335HdbQbRsNRQn445fh9hcJJ5gYOmLTstylCWNoygpib8ibhtXAHZhaQ3P6RBruJiaiabjSkUIvl5hpYic6pbCeX8UnICLLEfLiapJiagTL2IZA/640?wx_fmt=png&from=appmsg&watermark=1#imgIndex=2)

## **未来展望**

openYuanrong 将继续深化在 Agentic AI 领域的技术积累，致力于打造高可靠、高性能的 Serverless AI基础设施。随着蚂蚁集团等行业领军企业的加入，openYuanrong 正在定义AI原生时代的软件开发范式。

![图片](https://mmbiz.qpic.cn/mmbiz_png/qCr335HdbQaIg1oCXU0EDCUTJ3W1VCNX5z1EiaPj3XppebLN9UccpAsMxu7umPLO4RibZI8BeXUicPyOUzkkdRDs8bnhcWibWzSst3pYcRDCW6U/640?wx_fmt=png&from=appmsg&watermark=1#imgIndex=3)

* * *

\[1] 官网地址：

https://docs.openyuanrong.org/

\[2] 源码地址：

https://atomgit.com/openeuler/yuanrong

\[3] 技术论文：

https://dl.acm.org/doi/10.1145/3651890.3672216

\[4] 问题反馈：

https://atomgit.com/openeuler/yuanrong/issues

欢迎添加 openYuanrong 小助手微信，由小助手拉您进我们的官方群获得最新资讯~

![图片](https://mmbiz.qpic.cn/mmbiz_jpg/qCr335HdbQY9ctAbibtyic8PW2dByMOY7K9lm7IMBeOwQK9xopsAeDkCjpLsibDvC7SCQIibGz6OFKdyKBXW7iahYHXkWOEs4E9PBaTErCUqRF2w/640?wx_fmt=webp&from=appmsg&watermark=1#imgIndex=4)

来源| openYuanrong分布式计算引擎公众号

编辑 | 丘云

校审 | 郑振宇、刘彦飞

**关注我们，了解更多**

**▼**

![图片](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2d1CvxNf56DXribfOKnOqvMU1jP4fVRpO45sDy84Knibcp1OuASLm5MMg/640?wx_fmt=png&from=appmsg&wxfrom=5&wx_lazy=1#imgIndex=3)
