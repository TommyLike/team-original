# [openEuler全栈开源方案亮相华为伙伴大会](https://mp.weixin.qq.com/s/mPUYmDTEYWVpXB824gsq-w)

[OpenAtom openEuler](javascript:void%280%29;)*2025-03-24 18:02:00广东*

# 2025年3月20 - 21日，深圳——在华为伙伴大会现场，OpenAtom openEuler（简称"openEuler"）社区联合MindSpore社区以生态共建者身份发布了openEuler与MindSpore DeepSeek全栈开源方案，此次发布标志着全栈开源方案发展成熟。现场演示&参与展台吸引了超100家行业龙头企业代表及产业专家围观。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCQImYoeATIUcD5yFvytocApNyq3ESCCClLMUr08Y8uJFiba9xbybmUZ7FEiaMibfFh7QaosgVWThpEg/640?wx_fmt=png&from=appmsg)

本次发布的openEuler与MindSpore DeepSeek全栈开源方案，实现了端到端部署时长天级到分钟级，大并发推理吞吐达到1400Tokens/s，DeepSeek大模型推理性能开箱即优。openEuler实现以下核心技术：**1） Function Call：**实现语言大模型对工具的调用 ；**2）RAG：**通过检索增强生成构建企业领域知识库；**3）openEuler 大模型智能系统:** 通过Function Call 精准选择agent执行，提升任务执行效率；**4）openEuler 异构融合细粒度感知调度：**感知细粒度异构资源，对业务进行精准协同调度，提升整体推理性能；**5）vLLM-MindSpore插件：**支持MindSpore原生大模型接入vLLM框架，通过整图编译、量化等能力加速推理。**6）毕昇异构融合编译：**支持全链路软件栈编译优化和昇腾算子编译优化与融合。

值得关注的是，此方案正式发布前，openEuler社区、MindSpore社区与北京大学完成了场景验证，首次打通openEuler与MindSpore DeepSeek全栈开源推理方案的生产环境部署实践。相关技术细节可浏览《[北京大学联合openEuler与MindSpore发布DeepSeek全栈开源解决方案](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247514251&idx=1&sn=d5336b23f2a10d06b6bb2782d1018030&scene=21#wechat_redirect)》。

01

**技术亮点剖析**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCQImYoeATIUcD5yFvytocACZMh5NpnahTIBLWdJD8WdDXavNiaiaJxAqeqIxPDicI965jSVeLrUqIHg/640?wx_fmt=png&from=appmsg)

openEuler与MindSpore DeepSeek全栈开源方案，基于行业发展态势与全栈开源客户潜在需求，本次发布的全栈方案提出了以下技术亮点：

**Function Call特性**

Function Call是大型语言模型（LLM）API中的革命性功能，它赋予开发者定义自定义函数的能力，使AI能够智能判断何时调用特定函数，并返回结构化数据。开发者通过JSON Schema定义函数名称、参数及类型等，系统智能分析用户输入的自然语言，当检测到需要调用外部功能时，模型自动匹配最合适的函数，生成符合预定格式的参数数据。这项技术彻底改变了传统API交互模式，将自然语言处理与程序化功能调用完美融合。

该全栈开源技术架构中，openEuler与MindSpore DeepSeek基于vLLM支持Function Call特性。openEuler提供安全可靠的异构计算环境，MindSpore实现动态计算图优化，DeepSeek V3/R1模型作为基座处理语义理解。通过异构融合内存、异构融合调度、毕昇异构融合编译与MindSpore算子融合等技术，openEuler 大模型智能系统利用语言大模型对工具的调用。

**RAG检索增强生成特性**

检索增强生成（RAG）作为大型语言模型（LLM）领域的一项关键创新，通过将实时检索系统与强大的文本生成能力相结合，有效地克服了传统模型受限于静态知识库的局限性。

这种机制相当于为语言模型配备了一个可以实时更新的“外部大脑”，使得AI系统不仅能够保持其自然语言处理的优势，还能够动态地访问最新且最相关的领域知识。对于企业用户而言，openEuler 大模型智能系统 提供了一个理想的解决方案，可以基于私有领域的数据构建专门的知识库，并将其无缝集成至领先的大规模语言模型中。这使得企业能够迅速搭建起高效的问答系统，确保响应内容既贴合企业的具体需求，又能及时反映最新的行业动态和技术进展。

**openEuler 大模型智能系统** 

Agent是大型语言模型（LLM）的重要应用，Agent根据设定的目标，确定好需要履行特定角色，自主观测感知环境，检索历史记忆以及相关知识，通过推理规划分解任务并确定行动策略，并反馈作用于环境，以达成目标。在这个过程中Agent持续学习，以像人类一样不断进化。

openEuler 大模型智能系统基于大模型构建智能运维、智能调优Agent, 通过推理抽象业务流程特征分解智能运维调优任务：运维流程分解为故障感知、故障定界、故障定位子任务，调优流程分解为数据采集、负载感知、参数推荐、智能调优子任务，通过Function Call精准选择小模型执行子任务，提升任务的执行效率。并且智能运维调优Agent结合故障模式库和调优参数知识库等领域知识，围绕RAG检索增强能力，智能推荐运维手段和调优参数，进一步提升了运维调优效率。

**openEuler 异构融合细粒度感知调度**

通过实时采集计算节点状态、任务特征及业务优先级等多维度数据，在业务容器中构建动态决策模型，实现CPU核级、内存页级甚至缓存行级的资源划分，突破传统系统调度隔离边界，支持毫秒级资源配额动态调整。针对高并发场景下推理服务、分布式计算组件Host侧资源争用的痛点，利用NUMA感知的细粒度算力与内存资源隔离，降低单并发推理时延；通过线程特性感知的细粒度内存分配、高性能代码段大页机制，在控制内存开销的同时，提升Host侧性能与整体推理吞吐。

针对MoE大模型数据并行不均衡与稀疏访存效特点，系统通过实时采集节点算力与设计拓扑结构，优先将算子下发进程映射到相应的NPU节点，减少跨NUMA通信开销。进一步通过Host/Device OS协同内存管理实现多粒度动态混合页、按需内存分配，减少页表访存开销同时提升显存利用效率，进而推高大并发推理吞吐。

**MindSpore 图编译&量化&vLLM插件**

为了获得极致的DeepSeek-V3/R1推理性能，MindSpore通过Jit编译的方式将模型实时编译成计算图，通过模式匹配自动寻优Cube-Vector计算，Vector-Vector计算、通信-计算等多类型算子组合的融合策略。相比于单一算子，计算类算子融合可显著降低数据的存取耗时，通信-计算类融合可有效压缩通信气泡。

为了适配vLLM框架，昇思MindSpore开发了vLLM-MindSpore插件，无缝支持了vLLM框架的Continuous Batching、Chunked Prefill等核心特性，并通过Multi-Step Scheduling缓解了服务调度时延瓶颈。

**毕昇编译优化&异构融合编译**

毕昇编译器通过架构亲和优化、循环优化、多级并行优化、指令优化、智能编译选项和链接时优化等编译技术，能够显著提升ARM 架构（尤其鲲鹏处理器）上的应用性能。在openEuler与MindSpore DeepSeek全栈开源方案中，使用llvm for openEuler针对算子下发阶段的性能瓶颈，通过CFGO优化、选项调优和链接时优化等技术优化Python、Mindspore和Ray等应用，使代码布局更优，有效提高程序IPC；通过架构亲和的原子指令优化和Malloc、Memcpy/Memset高性能库优化，提高内存利用效率，降低访存开销，进而降低时延，提高吞吐率。

毕昇异构融合算子优化技术为Multi-Step Scheduling等特性支持上，昇腾侧算子快速生成与编译支持，满足特性快速上线与开箱性能保证。结合Mindspore图编译，使能Vector-Vector、Cube-Vector、通信-计算等多类型融合算子的生成与编译优化。

02

**未来蓝图披露**

## 基于目前AI行业发展态势与开源软件客户潜在需求，openEuler全栈开源方案已规划出清晰的技术演进方向。通过下图所示技术路线，将在异构融合调度、DDR/HBM内存池、算子融合优化及异构编译器等方面实现持续突破。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCQImYoeATIUcD5yFvytocAC5ys7pibCMEdiaibeRMGjRHEhSibvJL4m6r0gDtiaPrSR3QrbOicaEGhIudw/640?wx_fmt=png&from=appmsg)

03

**产业生态共建**

## openEuler社区已面向开发者开源核心技术方案，诚邀行业伙伴、高校与个人开发者交流合作方案，通过联合创新实验室加速场景落地。可添加小助手微信加入 SIG-Long微信交流群，或访问Gitee平台了解相关材料、提交issue （https://gitee.com/openeuler/llm\_solution），与openEuler、MindSpore社区专家共筑智能未来。

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mAk7XGjrHQX48E1tGVyJGQcgaTxicyGy9UAaYQYrL3ADZeFvrsbKPgXGSSwxkrfJsQdiccRkoQyFGDw/640?wx_fmt=jpeg&from=appmsg)
