# [openEuler 携手麒麟软件，落地「已知问题分析智能 Agent 」并规模化引入生产场景，开启智能运维全新范式](https://mp.weixin.qq.com/s/l_ucnDsTUZ4YruArvzlnMw)

原创*sig-intelligence*[OpenAtom openEuler](javascript:void%280%29;)*2026-05-19 17:30:00广东*

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a47pmwYKrTftvGXyFfspek4hoUibdJtrBB96517RL4k2AXD1gSav958g/640?wx_fmt=gif&from=appmsg)

**01**

**背景**

在企业操作系统规模化落地应用中，运维工作普遍存在两大突出痛点，直接制约运维效率与价值释放：

**1.日志分析效率偏低：**运维日志品类繁杂、体量庞大，传统依赖人工逐条梳理分析的模式耗时耗力；且传统分析手段适配性弱，难以应对复杂多变的现场运维场景，无法形成可复用、可泛化的标准化分析能力。

**2.运维知识难以沉淀复用：**随着业务持续迭代，运维经验与故障案例不断累积，但人工整理沉淀成本高、周期长；后续同类故障发生时，经验检索耗时繁琐，极易出现重复排障、重复踩坑，人力资源浪费严重。

当前，大模型、智能体框架、语义日志分析、RAG 检索增强、LLM 知识库等技术日趋成熟，为日志智能解析与故障案例精准关联奠定了技术基础。**基于此，OpenAtom openEuler（简称 “openEuler” 或 “开源欧拉”）社区联合麒麟软件，依托 OpenCode 平台，融合日志异常识别、轻量化 RAG、LLM 知识库能力，正式将已知问题分析 Agent落地生产环境，直击运维核心痛点，助力运维能力跨越式升级。**

**02**

**技术架构&功能实现**

![image.png](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOvlkoyqngxFJf08MmyhbMQFm3hCRR26wtsGwJ0bIvmib4k1Sg2BnPc0iassNuPLfnvPbgzxxFibUPtLzwsxtFTo7c7u0C3mB5XmgU/640?wx_fmt=png&from=appmsg)

已知问题分析 Agent 以 RAG MCP、Log Detection MCP、Experience Skill 三大核心模块为底座，通过三类子 Agent 分别承接各模块能力，有效压降大模型调用成本、提升响应效率。各核心模块能力与价值如下：

**RAG MCP 检索增强生成模块**

模块基于 SQLite 构建底层存储，支持十余种主流文档格式智能解析；采用关键词+向量混合检索架构，实现运维知识秒级精准定位。

![image.png](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOt8VomxPSHkibq5Urrw2X0jIoAr5dJ6OYvfJ1uGdNLlwXickvZBWEUVp9EIIiawRaD80tHqmTaUjmgC4jSNpYTWfJbcpNpicfXiasSw/640?wx_fmt=png&from=appmsg)

openEuler 社区已沉淀 3000+ 优质运维案例，为 Agent 提供扎实知识底座，并配套开放向量数据集，支持用户快速接入复用。

- 官方运维案例仓库：
  
  https://atomgit.com/openeuler/witty-ops-cases

仓库全面覆盖 openEuler 社区测试运维、鲲鹏、昇腾等主流软硬件适配场景，scripts 目录内置案例检测工具链，便于研发与运维人员快速复用历史排障经验，显著降低运维排查成本。

![image.png](https://mmbiz.qpic.cn/mmbiz_png/rxr9tddEHOuMrzVROMK9R2NsfMfENeenSDR4Iia025Bsibd1QyibnXL47iaaursBNxPK9NQrC0ibNMkp4RATZODBandXqZDejSMClHkiaricEE8KOg/640?wx_fmt=png&from=appmsg)

**Log Detection MCP 日志检测模块**

整合聚类分析、关键词匹配、大模型语义理解、向量检索等多维度检测能力，打破传统日志检测模式单一、误判率高的短板，精准捕获异常日志、快速锁定故障根因，为运维排障提供高效切入点。

![image.png](https://mmbiz.qpic.cn/mmbiz_png/rxr9tddEHOvlfoFLJyfgFW6tvu4rNHoT1zRHBP4icFeRJz9GvANeBTWZoIjDHPbQUH6yN8ATJybnyUgRdvHd3tMEdG4iayBP6nBCeicPiajPqRU/640?wx_fmt=png&from=appmsg)

**Experience Skill 经验技能模块**

支持运维 Wiki 与技能库的创建、迭代、合并、检索与全生命周期管理，是运维经验沉淀、Agent 场景适配能力持续优化的核心载体。

模块配套轻量化可视化 Web 界面，可直观展示已沉淀故障经验，实现运维知识可视化、可管、可查、可用。

![image.png](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOv8BDicic8LjfHmbMTib06X3bGdsx4eoBqkWwy3ar0ian5IMezfxpXyTVjHV3ibAmTzD33IpcicltbYXzTXv9KYzlRr6ABg0qfRibqib4w/640?wx_fmt=png&from=appmsg)

**03**

**落地案例：面向麒麟操作系统智能运维的已知问题分析**

麒麟软件作为参与 openEuler 社区建设的先行厂商之一，始终致力于社区的建设和维护，积极参与并推动了包括 AI、智能运维等多个领域发展。目前在 openEuler 社区的整体贡献排名中位居第二，是社区中重要的贡献者之一。

作为该方案的落地应用案例之一，麒麟软件用实践证明 AI 作为运维得力助手的必要性和可能性，让普通运维、开发人员也能高效应对复杂 OS 故障。

**当前方案基于自研智能运维 SDK 以及 OpenCode SDK 开展集成与场景验证，**围绕服务器和客户运维环境中常见的系统异常、服务异常、资源异常、安装升级异常、软硬件适配问题等，**复用 Witty 中的 RAG MCP 和 Log Detection MCP**，形成“日志片段发现 - 异常定位 - 知识检索 - 解答生成 - 经验沉淀”的闭环。已知问题分析智能体是智能运维多智能体体系中的重要组成部分。

**1. 场景背景**

在操作系统交付、适配、测试和客户支持过程中，常见故障往往不是单一报错，而是涉及日志片段分散、上下文缺失、环境信息复杂等问题，人工排查需要工程师在系统日志、服务日志、安装日志和历史案例中反复比对，效率高度依赖个人经验。

该方案从真实服务器异常和实际运维场景出发，将客户现场和内部测试中反复出现的问题沉淀为可检索、可复用的知识资产，并通过日志检测能力优先定位关键日志片段，再结合知识库判断问题原因和处理路径，从而提升排查效率。

**2. 分析流程**

在该方案中，自研智能运维 SDK 以及 OpenCode SDK 负责智能体流程组织和工具接入，Log Detection MCP 负责日志检测，RAG MCP 负责知识检索。方案设计时重点考虑响应时间、运行资源消耗、部署复杂度和客户现场可用性，不追求把所有日志都交给大模型“从头读到尾”，而是采用关键词规则与 LLM 语义判断结合的方式，提高日志分析效率和可控性。

1. 客户或工程师提交故障描述、日志文件、系统版本、硬件平台、部署环境和现场操作信息；
2. Log Detection MCP 结合关键词规则和 LLM 语义能力，对日志进行异常识别，提取关键报错、异常上下文、疑似组件和高价值日志片段；
3. RAG MCP 接入麒麟侧自建知识库，检索各类操作系统常见运维问题、openEuler 相关案例、麒麟历史客户问题、适配测试经验和疑难问题处理记录；
4. 当前知识库规模约上万条，覆盖系统服务、安装升级、软件包依赖、内核与驱动、硬件适配、资源异常、配置错误和客户现场典型问题；
5. 大模型结合日志异常片段和检索结果，生成问题定位结论、可能原因、排查步骤、处置建议、相关案例依据和风险提示；
6. 工程师或客户侧运维人员验证建议后，将有效结论沉淀为新的知识条目、检测规则或客户案例，持续增强后续问题的命中率。

该流程的重点不是让 Agent 替代工程师直接下结论，而是让客户和工程师不再在海量日志里盲查。Agent 提供的是“关键日志片段 + 相似知识条目 + 定位依据 + 处置建议”，由工程师结合现场环境进行确认；对于低风险、标准化、可回滚的操作，未来可逐步扩展为受控的半自动处置和有限自愈能力。

**3. 案例实践**

为验证已知问题分析 Agent 在日志场景中的可用性，本次选取服务器运维日志 /var/log/messages-20260209.log 作为输入，在 OpenCode 交互界面中启动“已知问题分析 Agent”。本次验证不要求工程师预先标注故障类型，而是由 Agent 自动完成日志检测、异常归类、知识库匹配和排查建议生成。

![image.png](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOtRybdiacZTxedbff5h0I4CXu5TMlslIlbAlSTPGsN55Uys2I0NcZxa7SZPGz6lQ6flnYQNZWqMj910Jy7wb0ia2wTDXKj6Bib0Kk/640?wx_fmt=png&from=appmsg)

Agent 首先调用 Log Detection MCP 对日志进行异常扫描，从原始日志中提取高价值异常片段，并将零散报错归并为可处理的问题项。**本次检测共识别出 13 条异常日志，并归纳为 3 类主要问题：**nginx 软件包安装失败、containerd 服务重启失败以及 cgroup 重复挂载。相比直接把整份日志交给大模型通读，这一步先完成日志降噪和异常聚合，把工程师真正需要关注的内容提前暴露出来。

![image.png](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOuA93G5h2rTxaMKhvCIpXbfkrBHemv5JgibqUIeCEyGw5Hn1iaGMBXcxvhen9onj0prfl2kFBlTJNHiaGXwHD2cFY7gWE3hXRXTQo/640?wx_fmt=png&from=appmsg)

从检测结果看，nginx 安装失败主要集中在 libssl1.1 依赖缺失、软件源访问失败以及 dpkg --configure 处理异常；containerd 问题指向服务单元不存在或未正确安装；cgroup 问题则表现为设备已被占用，疑似存在重复挂载。Agent 输出的不只是“有异常”，而是把异常按照组件、现象和影响范围拆成问题清单，便于后续分派、复核和闭环处理。

在完成异常识别后，Agent 进一步调用 RAG MCP 进行知识库匹配。以“包安装依赖问题”为例，系统从离线知识库中匹配到 openEuler 社区论坛及相关安装升级案例，包括 x2openEuler-upgrade 安装失败、openEuler 22.03 LTS 安装 MariaDB 依赖缺失、InstallRpmPackageActor 安装 x2openEuler-upgrade 包失败等相似问题。知识库匹配的意义不是简单罗列标题，而是把当前日志中的异常现象与历史案例、处理路径和可复用经验关联起来。

![image.png](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOt0Bic2W7icpoORXm4pbBTkoXDWI4Ozc4f6pQgkTteU0LVliaHRLUhTCkckry6AuefRLICgk0QhjFUjn64ZiaQ9ODpynZKmcYwQjKU/640?wx_fmt=png&from=appmsg)

结合异常日志和匹配案例，Agent 生成了分层排查建议。针对软件包安装失败，建议先检查网络连通性和软件源可访问性，再检查软件包完整性、依赖修复状态和安装失败明细；针对 containerd 服务问题，建议确认 containerd 或 Docker 是否已正确安装，并检查 systemd 服务单元文件是否存在；针对 cgroup 重复挂载问题，建议检查当前挂载状态，避免测试脚本或初始化流程重复挂载同一资源。

![image.png](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOvP4qhQ9p3tyD24UJwKXaGoicd64STPWQoCSYBRVU0bybcPfdH4dX6BgJaV3QjI0fK6VT5bceNr7vkGOddHj5SSVBmaicafxGsQ4/640?wx_fmt=png&from=appmsg)

最终，Agent 将本次日志分析结果汇总为可交付的排查报告：明确列出 3 类主要问题，给出每类问题的可能原因、关联知识库案例和后续排查方向。工程师拿到的不是一段泛泛的自然语言回答，而是一份可以继续验证、补充和流转的问题分析材料。

![image.png](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOtxyib9Td9iaqPjf7McOdfSB0M8pSib9EW2xibqYEFC0WkxI4PWKABYYiaUHVa8bQiauQCcetSEFhjjibH6XvctMMHVicvCClKgOGQLL1I/640?wx_fmt=png&from=appmsg)

**该案例表明，已知问题分析 Agent 可通过日志检测、问题归类、知识匹配、处置建议生成四个环节，**将分散日志转化为可分析、可流转的排查结果。面向安装升级、软件源访问、服务启动、系统挂载等高频问题，该流程能够减少人工翻日志和重复查案例的时间，并将处理结果沉淀为后续可复用的知识条目或检测规则。

**4. 落地价值**

**该方案的核心价值在于把分散在工单、测试记录、工程师经验和内部文档中的历史问题，转化为可检索、可调用、可持续复用的运维能力。**对于客户侧运维人员来说，智能体可以先给出异常位置、关联案例和参考处理方向，降低初步排查门槛，减少无效沟通；对内部支持流程来说，异常摘要、排查路径和参考案例可以作为问题流转的统一材料，减少重复描述、重复检索和重复判断。后续随着权限控制、风险分级和操作审计机制完善，该能力还可进一步延伸到巡检、告警研判、风险提示、变更前检查、标准化处置建议和低风险半自动执行等场景，逐步支撑智能运维平台向辅助定位、经验沉淀和受控自愈方向演进。

**04**

**部署&安装方式**

该 Agent 支持在 openEuler 系统通过 repo 源快速部署，适配 openEuler 24.03 LTS SP3 及以上或麒麟V11版本。

- **详细部署步骤：**
  
  https://docs.openeuler.openatom.cn/zh/docs/24.03\_LTS\_SP3/tools/ai/euler-copilot-framework/witty\_assistant/witty\_shell/deploy\_guide/deployment.html
- **快速上手操作教程：**
  
  https://docs.openeuler.openatom.cn/zh/docs/24.03\_LTS\_SP3/tools/ai/euler-copilot-framework/witty\_assistant/witty\_shell/deploy\_guide/deployment.html#%E5%BF%AB%E9%80%9F%E5%BC%80%E5%A7%8B
- **飞书社交软件对接配置：**
  
  https://docs.openeuler.openatom.cn/zh/docs/24.03\_LTS\_SP3/tools/ai/euler-copilot-framework/witty\_assistant/witty\_shell/social\_software\_guide/bridge\_introduce.html

**05**

**未来展望**

后续已知问题分析 Agent 将持续迭代演进，从三大维度深化能力升级：

1. **拓宽知识场景边界：**补充 Docker、K8s、Spark 等主流中间件在 openEuler 环境的运维案例，丰富智能运维覆盖场景；
2. **强化日志检测能力：**引入前沿智能检测算法，新增二进制文件、时序数据分析能力，提升异常识别泛化性与准确率；
3. **升级知识管理体系：**优化 Experience Skill 模块，内置轻量化知识图谱能力，实现运维知识结构化沉淀、关联检索与高效复用，持续放大智能运维落地价值。

![](https://mmbiz.qpic.cn/sz_mmbiz_gif/rxr9tddEHOufvfrOsJmTnItfyHW6KPPP2UznH3PIV7VxTG5HwTjW9xRj9NNxpypZzfYtTIv0rQCkSHVShZyQic4ibXicVFbboPib4Dy75Ykdr4A/640?wx_fmt=gif&from=appmsg)

欢迎加入 sig-intelligence 交流社区，分享使用心得、反馈问题或贡献代码，与生态伙伴共同探索 openEuler 与 AI 的更多创新可能！

??代码仓： 

https://atomgit.com/openeuler/witty-diagnosis-agent

??开发小组：

 sig-intelligence

??交流社区： 

https://www.openeuler.openatom.cn/zh/sig/sig-intelligence

-END-

供稿 |赵家麒、李孟虓

编辑 | 丘云

校审 | 郑振宇、刘彦飞

往期推荐

[experience-skill：为「已知问题分析Agent」搭建 Wiki 与 Skill 治理流水线](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247519952&idx=1&sn=cc1c2f804fa0f958ba70e7087a66f226&scene=21#wechat_redirect)

[系统Crash频发？智能诊断Agent带你直击根因，告别盲目排查](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247519195&idx=1&sn=5e5ec29ac1f703ad268b2fe427dada58&scene=21#wechat_redirect)

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
