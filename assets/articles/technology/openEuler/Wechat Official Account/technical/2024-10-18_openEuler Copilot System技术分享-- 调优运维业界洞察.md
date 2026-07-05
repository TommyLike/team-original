# [openEuler Copilot System技术分享-- 调优运维业界洞察](https://mp.weixin.qq.com/s/W38awuSOI5H-8f0gQ0FTkA)

[OpenAtom openEuler](javascript:void%280%29;)*2024-10-18 17:30:00中国香港*

**背景**

在当今数字化转型的浪潮中，企业IT架构正面临着前所未有的挑战与机遇，随着大语言模型技术的发展，该项技术逐渐被运用在各IT基层设施之上。在这样的背景下，操作系统顺应技术趋势，逐渐向系统原生智能演进。2023年5月份，随着微软Build年度开发者大会发布Windows Copilot \[1]，标志着操作系统正式进入原生智能时代。**操作系统与大规模语言模型（LLMs）的融合成为了技术创新的前沿阵地。**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAInIsfnjbAvQZA1QibOibAX3d20xnsfA5IssKcygZIVHpoRCnYYRHqC8K3gqwgGbSOd4NrX1kf8pJg/640?wx_fmt=png&from=appmsg)

图1：微软Copilot关键能力\[1]

传统上，操作系统的运维与调优工作往往依赖专业知识与工具，工具的有效使用、知识的正确应用直接决定相关工作的效率、准确性。各操作系统Copilot平台都意识到**运维**与**调优**具备广泛的商业价值，纷纷将其作为差异化竞争手段。各厂商都在研究如何将通用大语言模型与专业知识与工具有效结合，**抢占大模型时代OS运维与调优的技术高地。**

运维的机会点：LLMs凭借其强大的自然语言理解和生成能力，能够深入理解运维多模态数据，通过结合专业运维工具，一方面能够实现对系统状态的更准确实时分析与预测，另一方面还能快速给出问题处理建议，极大提升运维效率与准确性。

调优的机会点：基于领域系统调优知识的FineTune之后的LLMs，可以更好的理解系统状态、应用负载以及给出相应的调优策略，从而为系统调优提供精准指导。

**学术洞察**

**RCAgent**

RCAgent\[2]一篇关于工具增强型LLM自治Agent框架的论文研究，研究目的通过LLMs与专业工具有机结合，包括LLMs驱动工具进行数据收集与专业分析，以及结合工具分析结果进行目标一致性的任务轨迹设定，最终完成系统故障根因定位。其重点解决了其中两个难点问题：

1. LLMs上下文长度的限制：推理输入的Token长度是有限的，但是在运维过程经常会遇到超长输入（比如代码、日志等信息），提升运维过程中输入token长度对准确理解运维任务有较大收益。
2. 任务执行过程的目标连续性：推理过程中需要多次与不同工具交互，存在多个上下文信息，确保多次交互而又目标一致对运维过程理解复杂任务有较大收益。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAInIsfnjbAvQZA1QibOibAX3FiaHQqgICX5tzTAF7icVV0c0Lyuj3DqztGdtvMLopTYFL87RfaiceftUw/640?wx_fmt=png&from=appmsg)

图2：RCAent整体架构图\[2]

- **创新点1：**OBSK机制（Observation Snapshot Key），将文本关键信息用键值替代，减少因推理Token限制而导致的文本截断带来的信息损失，推理过程再由键值查找文本关键信息，极大缓解在处理日志、代码等数据时上下文长度限制的问题。
- **创新点2：**轨迹级自我一致性机制（TSC：Trajectory-level Self-Consistency）相比普通SC（Self-Consistency），具备连续的思维、行动、观察过程。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAw1qYf58ySvsU7o0rfktKYQ9wicCnf7TDo1X1IibPXgdvchppZNgeRpqtxAI5y8DamicjudylN96o6Q/640?wx_fmt=png&from=appmsg)

图3：OBS机制和TSC机制介绍\[2]

**LLMTune**

LLMTune\[3]是一篇关于LLMs加速系统调优效率的论文研究，该论文以数据库调优场景为例，现有技术通常基于ML技术完成自动化参数调优，但是由于调参空间膨胀、负载类型多样性，导致ML调优技术面临效率问题。针对这一问题，常见解决方案是积累大量的调优知识（场景负载、调参范围等），设置合理的调参起点（场景化的初始配置），降低ML迭代次数，提升调优效率。本论文研究通过LLMs学习调优专业知识，为不同的工作负载生成高质量的初始配置（而非出厂默认配置）。该论文重点的难点问题：

如何构建调优领域模型：自动化、快速的获取有效的的调优知识，并作为领域模型指导调优工作，可以快速提升调优效率。

如何兼顾效率与性能：兼顾效率的同时，还需给出性能优化最优解。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAw1qYf58ySvsU7o0rfktKY8nPRrllIcAuukmurCiaic9ickbf5SSaMNUKAwT6cyy2raibaCcaTPs8PeA/640?wx_fmt=png&from=appmsg)

图4：LLMTune整体架构图\[3]

**创新点1：**提出一种“代价模型”评估获得在不同负载情况下合理初始配置，进而自动化方式训练出“调优领域模型”。

**创新点2：**提出一种“生成-优化”框架，利用LLM的知识学习能力、配置生成能力，自适应的为不同的工作负载生成相应的合理初始配置，再通过ML方法进一步优化初始配置，避免传统智能调优过程中大量“试错”环节，兼顾效率与性能。

**行业洞察**

2023年CCF国际AIOps挑战赛中，多支队伍构建基于Multi-Agent架构的智能运维方案获奖，借助AI Agent思想，将SRE日常运维工具通过Multi-Agent架构衔接起来，全自动完成异常检测、根因诊断、影响分析等工作，极大提升SRE日常工作效率。在清华大学裴丹老师的演讲中\[4]，智能体（Agent）分两类：

1. **岗位型智能体Agent：**也就AI Agent，包括异常检测、根因定位等智能分析能力的Agent，这些Agent可以理解系统运维上下文，能够完成特定的工作任务（比如日志的分析、指标的检测、影响的分析等）。
2. **工具型智能体Agent：**通常是日常工具，本身不具备智能能力，用于提升特定工作效率，比如报表工具、工作流工具、问答系统等。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAw1qYf58ySvsU7o0rfktKYBfWxgNoBzMANCZ9vaAUM8KGDMXTn9rGvk3ZtqK0hJfnTAlvmKz4FVA/640?wx_fmt=png&from=appmsg)

图5：岗位型智能体和工具型智能体介绍\[4]

另外，我们注意到业界知名AIOps厂商Dynatrace在23年也推出业界首个超模态AI的AIOps系统，所谓超模态AI即融合了预测型AI、因果型AI、生成式AI三种AI模型，其能力特征总结如下：

- 生成式AI更好的理解系统：预测型AI、因果型AI的洞察信息（包括其他常规监控信息）用于Davis CoPilot\[5]进行prompt时，提供提示模板所需的上下文信息，实现AutoPrompt，构建系统领域模型，提升大模型理解专业系统的能力。
- 复杂任务分解：通过用户自然语言（或者系统事件报告）驱动超模态AI，完成复杂任务分解，驱动AIOps监控&分析工具，完成特定任务，最后由生成式AI给出事件分析以及处理建议。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAw1qYf58ySvsU7o0rfktKYsZ6wZoe2VlMejBXibFu7xIkf5jicFd988ibvwHB88ClQickRcEjsc6kYvA/640?wx_fmt=png&from=appmsg)

图6：Davis AI整体能力介绍\[5]

典型能力包括：

- **故障报告：**基于用户故障报告事件，自动完成运维任务分解，结合传统智能运维的基于拓扑的根因分析、自动化跟踪以及代码分析等能力，给出故障报告分析建议。
- **故障预测：**主动捕获系统预测型事件（比如磁盘空间不足，负载过高等），结合系统上下文，主动给出处理建议（比如通知SRE团队扩容）。
- **自动巡检：**理解系统上下文信息，使用生成式AI能力，自动生成巡检任务脚本，确保合理的巡检范围及内容。
- **智能面板****：**提供自然语言交互式查看系统状态能力，用户不再需要学习冗余复杂的Dashboard，OneBoard向OneInterface-演进。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAw1qYf58ySvsU7o0rfktKY4N9v2HD6XyjJT5iaw8sBrXUN5xYTkuw2E5ddapVSnxaqYRPsbq0aBPg/640?wx_fmt=png&from=appmsg)

图7：Davis CoPilot智能运维处理流程\[5]

**洞察总结**

多智能体协同：大模型技术的发展，可以作为AIOps领域的最好技术补充，其可以将AIOps系统的各种智能体Agent有效协同起来，提升整体运维效率。相关的热点技术包括ReAct\[6]、CoT\[7]等。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAw1qYf58ySvsU7o0rfktKYavaEj1UyWyhp8VqNgWiaKw3J6LvOmibd29lGSsm8BWqcCnAbnd6kjIwg/640?wx_fmt=png&from=appmsg)

图8：多智能体协同示意图\[4] 

领域模型：要想让LLM更好的理解系统，基础LLM模型不足以完成专业领域的复杂任务，需要构建领域模型，即通常说的从L0模型逐渐演进至L1/2模型，才能更好的理解系统，处理好复杂任务的分解、协作。相关热点技术包括RAG、AutoPrompt等。

**Copilot System调优运维能力整体介绍**

针对业界的洞察，围绕openEuler构建了Copilot System平台，openEuler 当前重点工作围绕调优与运维两个方向，下面介绍其整体能力。

如图所示，Copilot System调优&运维整体架构分为三层，最下层为基础模型层，包含系统运维&调优需要具备的基础模型能力，如异常检测基础模型会包含日志基础模型、时间序列基础模型、调用链基础模型。通过构建OS领域多模态数据异常检测模型，融合操作系统静态知识（包括操作系统知识、运维案例、开发使用手册等)和动态数据（包括运行态多维时序数据、log、tracing等），构建操作系统在复杂故障场景的原子级处理能力。相比于传统架构中的算法能力主要体现为小模型，本方案基于大量OS领域知识，结合通用预训练的大语言，通过微调构建领域大模型。

中间层为智能体层，可分为三小块内容：场景化能力实现对典型应用场景的深入分析，如MySQL分析工具可识别MYSQL的SQL语句信息，占用的系统资源等，给系统级分析提供充足的信息。中间部分的各种智能体（Agent）是对基础模型层能力的封装，实现统一的API或自然语言调用减少人工参与。知识库用于积累大量的领域知识，大量领域知识以自然语言（博客、指导手册等）形式承载，通过自动化的抽取、转化等清洗工作，形成结构化的知识，利用检索增强（RAG）等技术，进一步提升大模型的准确率。

最上层是多智能体协同，通过引入反思、规划、决策等能力，实现但智能体能力的增强。针对现有的多智能体协同机制仅面向Agent之间角色清晰、任务简单、扁平化的场景，难以应对需要渐进式分析、动态决策的复杂问题。提出了基于多轮共识的多智能体协同机制，支持团队合作（Teamwork）模式、层级合作（Hierarchical Collaboration）模式、等多种协作模式，提供灵活的场景处理能力。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAw1qYf58ySvsU7o0rfktKYQQic7bCaW0ArPoE0c15MGElM7aypSJCubFGZJpcoWyviaWf56EIg3cbg/640?wx_fmt=png&from=appmsg)

图9 openEueler Copilot System调优/运维架构图

**参考链接**

\[1] Windows Copilot介绍：https://support.microsoft.com/en-us/windows/welcome-to-copilot-on-windows-675708af-8c16-4675-afeb-85a5a476ccb0

\[2] Wang Z, Liu Z, Zhang Y, et al. Rcagent: Cloud root cause analysis by autonomous agents with tool-augmented large language models\[J]. arXiv preprint arXiv:2310.16340, 2023.

\[3] Huang X, Li H, Zhang J, et al. LLMTune: Accelerate Database Knob Tuning with Large Language Models\[J]. arXiv preprint arXiv:2404.11581, 2024.

\[4]大模型时代下多智能体协同运维技术介绍：https://blog.csdn.net/weixin\_52705010/article/details/135599832

\[5] Davis AI介绍：https://www.dynatrace.com/news/blog/hypermodal-ai-dynatrace-expands-davis-ai-with-davis-copilot/

\[6] React机制介绍：https://www.lumin.tech/blog/react-0-base/

\[7] CoT机制介绍：https://www.53ai.com/news/qianyanjishu/1124.html

**欢迎加入**

欢迎感兴趣的朋友们参与到 openEuler Intelligence SIG，探讨 AI 领域技术，也可以添加小助手微信，加入 Intelligence SIG 交流微信群。欢迎您的围观和加入！

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAw1qYf58ySvsU7o0rfktKY2v4hV9LVtia74ImKmyBsibLWSiaHVJ1tamKxLSmRy6DttZB9ZgPibib3lQg/640?wx_fmt=png&from=appmsg)

扫码添加小助手
