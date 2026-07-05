# [系统Crash频发？智能诊断Agent带你直击根因，告别盲目排查](https://mp.weixin.qq.com/s/NA2pfAiqQfc7_5eb0dcmrg)

原创*sig-intelligence*[OpenAtom openEuler](javascript:void%280%29;)*2026-04-02 18:35:39广东*

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a47pmwYKrTftvGXyFfspek4hoUibdJtrBB96517RL4k2AXD1gSav958g/640?wx_fmt=gif&from=appmsg)

**01**

**背景**

**系统Crash已成生产环境的“致命痛点”**

系统 Crash（崩溃）是运维场景中最严重的故障之一，直接导致服务中断、业务停摆。传统排查方式高度依赖运维人员的个人经验，需要从海量日志和复杂堆栈中逐行检索，过程耗时且技术门槛高。尤其在复杂的分布式系统中，Crash 的诱因往往非常隐蔽（如底层依赖异常、代码隐性 Bug、资源瞬时耗尽），常导致“复现难、定位偏”的困境。一旦 Crash从偶发转变为频发，排查不及时极易引发连锁反应，造成巨大的业务损失。

为此，OpenAtom openEuler（简称 “openEuler” 或 “开源欧拉”）团队**发布"智能诊断 Agent"，通过 AI 赋能故障高效、精准定位，助力企业运维效率升级。**

**02**

**问题与挑战**

**系统 Crash 排查的三大核心困境**

![](https://mmbiz.qpic.cn/mmbiz_png/rxr9tddEHOshvIuYXbcIY5hMS0uHol0IjTy2FSpp9XwWhg0jFyrX1UNFjc8U85ul7LKXXRB0EfEvVxkicIuicnMu6cxiaA0AiadxibEYfbufg0lg/640?wx_fmt=png&from=appmsg)

**\*本图由AI生成，仅供示意**

**1.排查效率极低，业务中断成本高** 

传统 Crash 排查依赖人工逐行分析日志、拆解堆栈、复现现场。简单故障动辄数小时，复杂内核级、并发类 Crash 甚至需要数天定位。故障持续期间，业务持续不可用，时间成本与经济损失巨大。

**2.根因定位不准，易陷入 “表面排查”** 

多数 Crash 只呈现最终报错信息，而真正根因（内存泄漏、死锁、竞争条件、配置错误、底层组件异常等）被掩盖。只解决表面现象会导致故障反复出现，陷入 “修复 — 复发 — 再修复” 的恶性循环。

**3.依赖专业能力，排查门槛极高** 

系统 Crash 排查要求人员精通系统原理、内核机制、日志格式、异常特征等专业知识。大量中小团队、普通运维人员不具备这类能力，遇到复杂崩溃只能束手无策，严重影响系统稳定性。

**03**

**智能诊断 Agent**

# **?智能诊断 Agent——破解系统 Crash 类问题的核心诊断能力**

面对上述挑战，智能诊断 Agent 提供了全新的解决方案：

- **遥测数据智能解析：**自动分析Crash时的全量上下文（日志、VMCORE、堆栈等），智能提取关键报错信息，替代低效的人工筛选。
- **根因精准定位：**基于内置的故障知识库与算法模型，关联Crash发生的具体场景（如高并发、启动阶段），直接定位到代码Bug、资源瓶颈或依赖异常等底层根因。
- **代码级精准溯源：**结合内核源码符号与 VMCORE 中的堆栈信息，生成源码级函数调用栈，可精准定位到引发 Crash 的具体函数、代码行号，实现从故障现象到问题代码行的直接溯源。
- **全场景覆盖：**通过内存、死锁、中断/定时器、文件系统/IO 及驱动硬件分析，全面支持 OOM、Hung Task、Hard Lockup、Kernel Panic等多种内核崩溃与系统挂起场景。

![](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOu83pcpUFUGb5u14oiaHqK2dh6JIvaZiaCULKaGv2Via1A3ibol9FnDkY0PM2U1HkXicrxU6SqR366bYgmTFj0iaGtJkakLKkW98D35I/640?wx_fmt=png&from=appmsg)

**04**

**使用流程**

- 启动 **OpenCode** ，

<!--THE END-->

- 在终端执行命令：

<!--THE END-->

```
auto-diag 故障问题描述
```

  说明：当前支持离线分析，需在故障描述中指定**遥测数据 / 日志存储路径。**

  示例：

```
auto-diag "我有个系统发生了 crash，请分析下原因。我将 vmcore 相关文件和命令部署到远程调试机，远程调试机登录方式：ssh root@1.1.1.1。记住：你所有的操作都要在此远程调试机执行，以下描述的所有目录也是远程调试机的目录。core 文件在/home/crash目录下（命令参考：crash ./vmlinux vmcore），同时 /home/crash/src 里面包含源码文件，分析具体的源码问题。"
```

- 系统将自动执行智能诊断流程。
- 诊断完成后，根据终端输出的报告路径，查看完整的诊断分析报告。

![](https://mmbiz.qpic.cn/mmbiz_gif/rxr9tddEHOsIUjTuibHeJBsILFh5Ltd4MeaaqwU4j4G1Y5zGY96TLdy0IdP0ulYibyPupLqnBWMgSibODC7ejPzIDbRyiap359H5PQlNObQlSibA/640?wx_fmt=gif&from=appmsg)

**05**

**总结**

系统 Crash 的真正可怕之处，不在于故障本身，而在于盲目排查带来的时间内耗与业务损失。依赖人工、依赖经验、依赖猜测的传统模式，早已无法应对现代复杂系统的稳定性要求。

**智能诊断 Agent，让系统 Crash 排查从经验驱动转向数据驱动：自动解析、精准定位、快速止损、闭环优化。**它不仅是一个故障工具，更是系统稳定性的 “智能守护者”，让每一次崩溃都能被快速看透、彻底解决。

![](https://mmbiz.qpic.cn/mmbiz_gif/rxr9tddEHOv75Rurj36K9La4TlHyEjRfHUxKz3ING8PpV3Qk5Rib1bzrOQPfknic25hF3m3gy7LHdtw6Xntn89xMQ0wE1PL7IFs9eJoS2ic8NU/640?wx_fmt=gif&from=appmsg)

欢迎加入 sig-intelligence 交流社区分享使用心得、反馈问题或贡献代码，与生态伙伴共同探索 openEuler 与 AI 的更多创新可能！

??代码仓： 

https://atomgit.com/openeuler/witty-diagnosis-agent

??开发小组：

 sig-intelligence

??交流社区： 

https://www.openeuler.openatom.cn/zh/sig/sig-intelligence

-END-

供稿 | 王磊、陈通标、杜开田

编辑 | 丘云

校审 | 郑振宇、刘彦飞

往期推荐

[智能诊断 Agent：开启openEuler生态OS故障诊断的智能化时代](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247519189&idx=1&sn=38a634d89ffb66bf330187c19cae1704&scene=21#wechat_redirect)

[硬盘物理损坏故障难定位？智能诊断 Agent 深度分析，快速锁定根因](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247519119&idx=1&sn=150b82cac6019e7559e77664d6a7f5fe&scene=21#wechat_redirect)

[Witty Assistant重磅来袭，“已知问题分析Agent”一键搞定运维难题](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247519097&idx=1&sn=d12e25f8ac37ef421c1ab5ae47d375a3&scene=21#wechat_redirect)

[日志异常检测MCP正式上线：为“已知问题分析Agent”构建高性能日志分析核心引擎](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247519020&idx=1&sn=d493d9004eef7b7f2213d85f87bf052a&scene=21#wechat_redirect)

[轻量级知识库 MCP 上线：为“已知问题分析 Agent”打造本地化智能记忆](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518984&idx=1&sn=aae432a5350b3d2d889535101383430c&scene=21#wechat_redirect)

[Witty-tune | openEuler领域调优模型实现纯CPU倍级推理加速](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518737&idx=1&sn=5e926411d0a327069d5e49290f7500de&scene=21#wechat_redirect)

[Witty Assistant默认集成OpenCode：开启openEuler"智能运维"新时代](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518503&idx=1&sn=1b90c836836bf0a4161becaf6c04d5ae&scene=21#wechat_redirect)

**关注我们，了解更多**

**▼**

![图片](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2d1CvxNf56DXribfOKnOqvMU1jP4fVRpO45sDy84Knibcp1OuASLm5MMg/640?wx_fmt=png&from=appmsg&wxfrom=5&wx_lazy=1#imgIndex=3)
