# [experience-skill：为「已知问题分析Agent」搭建 Wiki 与 Skill 治理流水线](https://mp.weixin.qq.com/s/-ZOpq3YoJhEbn9Agx4Ur4g)

原创*sig-intelligence*[OpenAtom openEuler](javascript:void%280%29;)*2026-05-18 17:24:04广东*

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a47pmwYKrTftvGXyFfspek4hoUibdJtrBB96517RL4k2AXD1gSav958g/640?wx_fmt=gif&from=appmsg)

告别每次问答从零检索的低效模式，experience-skill 完成LLM Wiki理念工程化落地，以数据库索引替代传统文件索引，让AI助手真正具备知识沉淀、高效检索与复用迭代的核心能力。

**01**

**背景**

2026年4月，Andrej Karpathy 在 LLM Wiki 提出范式级理念转变：摒弃传统RAG每次查询从原始文档重新检索、拼凑答案的模式，转而让 LLM 维护一套持久化 Wiki ——知识一次编译、持续迭代、永久复用。

该理念快速获得行业广泛认可，相关Gist两周斩获5000+ Star，Kompl、Link、Synthadoc、OmegaWiki 等开源实现接连涌现。但在大规模落地实践中，工程瓶颈日益凸显：Karpathy 原型采用文件级index.md目录索引，当 Wiki 规模从数十页扩张至数百页后，检索效率、可维护性均遭遇明显瓶颈。

OpenAtom openEuler（简称 “openEuler” 或 “开源欧拉”）基于 openCode 自研的已知问题分析Agent（下文简称“Agent”），在运维实战中同样面临该痛点：**随着运维经验库持续扩容，Agent 检索关联经验需全量加载目录文件，问答响应时延显著增加；且新增经验必须手动同步更新目录文件，运维维护成本居高不下。**

针对以上痛点，团队设计落地 experience-skill——基于 SQLite FTS5 构建的轻量化经验库检索系统，作为 Agent 原生 Skill 提供结构化、高性能的经验检索能力。助力运维场景下 AI 助手持续沉淀业务经验、自主迭代进化，真正实现知识闭环复用。

**02**

**核心思路：数据库索引替代文件索引**

Karpathy 原型方案以 index.md 作为 Wiki 统一检索入口：LLM 应答时需先全量读取目录文件，定位页面链接后再逐篇加载对应 Markdown 文档。文档体量较小时可正常运转，但规模化后三大痛点愈发突出：

- **索引臃肿膨胀：**index.md 随文档数量线性扩容，LLM 必须加载完整目录才能定位目标资源
- **维护成本偏高：**每新增一篇知识文档，均需 LLM 参与更新目录，既消耗 Token 资源，又存在人工编辑逻辑出错风险
- **检索能力受限：**无法按分类、关键词、属性等维度做结构化筛选，仅能依赖 LLM 对目录全文做语义解读

experience-skill 给出核心解法：用 SQLite + FTS5 全文搜索引擎 彻底替代 index.md 文件索引，极简架构实现关键工程升级：

- **毫秒级极速检索：**依托数据库层完成全文匹配，精准返回 Top-N 关联结果，LLM 仅加载命中条目，无需遍历全量知识库
- **混合加权检索：**默认融合 FTS5 元数据（名称、描述、关键词）与正文全文检索，兼顾精确匹配与语义泛化能力
- **多维结构化查询：**原生支持按资源类型（Skill/Wiki）、业务关键词、热门权重等多维度筛选，依托 SQL 能力灵活扩展
- **原生中文分词：**内置C语言实现的分词扩展，中文检索精度无需依赖 LLM 语义解析，本地化匹配更高效

对终端用户全程透明无感知：仅需以自然语言与 AI 助手交互，Agent 后台自动检索本地经验库，复用历史运维经验作为应答核心依据，无需学习新工具、记忆额外指令。

**03**

**产品形态：内嵌Agent Skill，无需独立部署**

experience-skill 采用 Agent 原生 Skill 架构，摒弃 MCP Server、独立服务等重部署模式，实现零侵入集成：只需将项目放入 Agent skills 目录，框架即可自动识别、加载能力定义，严格遵循 SKILL.md 流程执行任务。

**设计带来四大落地优势：**

- **自动发现即插即用：**无需配置 API 端点、无需常驻后台进程、无额外部署依赖
- **多Skill兼容共存：**Agent 可根据用户诉求自动路由匹配对应能力，各 Skill 独立运行、互不干扰
- **原生工具生态打通：**检索指令 search-experiences 与 grep、ls 等 Shell 工具同栈调度，无需额外适配改造
- **全终端能力统一：**终端、桌面端、Web 端任意入口交互，Agent 均可后台自动检索经验库，知识能力全端同步

**核心能力落地流程**

#### **1. 知识自动沉淀**

输入批量原始运维案例，Agent 自动完成内容解析、智能分类、去重规整，批量生成结构化 Skill 与 Wiki 并入库。用户仅需给出方向反馈，即可驱动 Agent 迭代优化分类体系、关键词标签与评测用例，全程无需手动编辑文件。 

![image.png](https://mmbiz.qpic.cn/mmbiz_png/rxr9tddEHOvzfRSLMDAFWs2oEJm2UujvjuRJqYNh7Xxx64UMS7zZ8czBffvJgqyV6BMa5lDstmkXUxDqSP6OdH0oEPdGCFtP5raNLMFIicak/640?wx_fmt=png&from=appmsg)

#### **2. 经验质量智能优化**

从准确性、完整性、可读性、时效性、可执行性五维对全量经验自动打分评估，智能补全缺失内容：含可执行脚本、兼容性元数据、关键词覆盖、场景评测用例等，大幅降低人工审核成本。 

![image.png](https://mmbiz.qpic.cn/mmbiz_png/rxr9tddEHOuMOwZjqXq9cO0mIJHAlOjZXrBaPjHYEDtN4Imuke8B1XRc2rflufhoQWbmlVe41SicS1f62sBtTXvGiaKQaxTQjK3TquewQjCjA/640?wx_fmt=png&from=appmsg)

#### **3. 大规模并行审计**

面向海量经验库巡检场景，Agent 自动拆解并行子任务，同步读取目录结构、配置文件、评测用例，最终汇总输出结构化审计报告，替代人工逐篇核查。 

![image.png](https://mmbiz.qpic.cn/mmbiz_png/rxr9tddEHOvP4cJtfajoMib8Tw0sUKnSd3g6tPWIlVAVPP3wPibk3rwtoURib98PwpfsE0SAt2mfIlI6qFge6nh3rMSLtsrdzTFCziaTofiaia3iaw/640?wx_fmt=png&from=appmsg)

**可视化Web管理界面**

除 Agent 自动化调度外，提供轻量化 Web 运维界面，执行 uv run experience-skill web 即可一键启动。所有经验采用 Markdown+YAML 原生格式存储，任意文本编辑器可直接编辑，数据无绑定、无锁定。

**●Web主页：**集成标题栏、类型筛选（ALL/SKILL/WIKI）、全局搜索、关键词云、经验卡片列表，一目了然 

![](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOsMfXVpbhVT3rERJSS0mMNOic5wy3HIgVafXtVKF38f3jGI87vIhSW6NHfnDV58Pey3ic6ltazDxhTXz0f6MhCfnqLRZZEWLTPJw/640?wx_fmt=png&from=appmsg)

**●全文智能搜索：**检索结果精准匹配，右侧标签以色值区分命中来源：元数据+正文/仅元数据/仅正文 

![](https://mmbiz.qpic.cn/mmbiz_png/rxr9tddEHOu8mzOI48IFicqbE17lxBVSDibD5FF6biclh6jZ3ibPT5lUVKfrX4iaTC4rflJG98TrtEdQ4gp69D2xHYz69ahGJ8GrEPPglVZzdkCM/640?wx_fmt=png&from=appmsg)

**●关键词交叉筛选：**多关键词勾选联动，精准过滤同时匹配标签的经验条目 

![](https://mmbiz.qpic.cn/mmbiz_png/rxr9tddEHOuN1mN8GY0iaD8GObe2KB82XOia81B1NIMORO6Hib5HhdIAibToLRZvQHVib7iaTWYowcS0OgGjVB532JTs0eCIoTdkwuDcnoEL8KzsM/640?wx_fmt=png&from=appmsg)

**●详情沉浸式预览：**点击卡片展开完整正文，原生支持 Markdown 标准渲染 

![](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOsKY2u6T9FVfjxQ28j0F6UK6kqPKyBBF9mDjDvOzOqs2TVDDiadRTBBNYTERG153Hf9ibZoJyJIiaLMW6pLGADhbAlE4vM2Kbp5B0/640?wx_fmt=png&from=appmsg)

**04**

**极致轻量，零额外依赖**

技术栈极简：仅基于 Python + SQLite，可选配C语言中文分词扩展。**无需Elasticsearch、无需向量数据库、无需Docker容器、无需云端服务。**

104条完整经验（含全文索引）的单数据库文件仅约480KB，体积小于普通手机截图；全平台兼容Linux、macOS、WSL。通过 uv sync 一键安装依赖，uv run experience-skill web 秒启管理界面。

采用单文件数据库设计，知识库可像普通文件自由管理：U盘离线迁移、Git 版本管控、rsync 快速同步，灵活无束缚。

**05**

**检索质量：百级场景基准实测**

选取104条真实运维经验（21条 Skill + 83条 Wiki，库体480KB）开展基准测试，以传统文件级 grep 作为对照组，验证 FTS5 检索方案实战效果。

**Skill 检索实测（21条Skill × 22组查询）**

![image.png](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOsXYuQ7OdgZQcqja7BxmPh21vbbxA080GkUZjBksmJJqvLTqJQuZqweNWKXia2icdicHGyVRUKAFkIk9qjm8MyUVnDBShrh8u4iauc/640?wx_fmt=png&from=appmsg)

Skill 体量较小，各方案均能实现 Top-1 精准命中，FTS5 元数据检索仅需5ms，时延优势显著。检索能力差异集中体现在 Wiki 大规模场景。

**Wiki 检索实测（83条Wiki × 10组查询）**

![image.png](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOu1ayJGVmrhakWYuHhq2Xiaow33lh5icQlcgO1YyVDfKs5dwcbslsR8H9f7NtnzJI3GUeHiaGzS8H6PIBygAbO4T0GVZdnBicmeTEU/640?wx_fmt=png&from=appmsg)

83篇文档检索场景下，混合检索 Top-1 命中率80%、MRR 达88.3%，较文件 grep 基线分别高出20%、10%。传统文件检索超40%查询无法首位返回最优结果，后置噪音条目会无谓消耗 LLM 上下文窗口，而 experience-skill 可精准规避该问题。

**06**

**产品定位：差异化补齐中间态能力**

experience-skill 并非通用RAG管道，也非普通 Wiki 工具，在传统 RAG、Karpathy LLM Wiki 之间形成精准差异化定位：

![image.png](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOvc7286la6pEicCdKc8S3LmahtEbKzCCXdo0Q0OAVB5pkiaSKPsPjGBpzneBHVjK6IAIH8yqehFibtgWydDAHYibCia9a0uOWOfof0s/640?wx_fmt=png&from=appmsg)

继承 LLM Wiki 持久化累积、轻量化特性，吸纳传统 RAG 高效检索优势，最终封装为Agent 原生 Skill；作为AI助手内生能力嵌入体系，无需单独部署、独立维护。

**07**

**快速开始**

* * *

1.将 experience-skill 项目放入 Agent skills 目录；

2.执行 uv sync 完成依赖安装，Agent 框架自动加载生效；

3.用户自然语言提问即可触发后台经验库检索，复用本地历史知识智能应答；

4.需人工管理知识库时，执行 uv run experience-skill web 启动可视化界面；

5.配套CLI工具链完整支持 add-experiences、search-experiences、sync、list-experiences 等全生命周期管理。

![](https://mmbiz.qpic.cn/sz_mmbiz_gif/rxr9tddEHOsTeFXyF9abz6mVdjayaHPEQ6gYfyVSeszib4XT4T2RI8Ow14ncV6g10OAOYL1t2gETuasneAuHibuxUdibpC30ly2ib9iaYSF5cN4A/640?wx_fmt=gif&from=appmsg)

欢迎加入 sig-intelligence 交流社区，分享使用心得、反馈问题或贡献代码，与生态伙伴共同探索 openEuler 与 AI 的更多创新可能！

??代码仓： 

https://atomgit.com/openeuler/euler-copilot-rag

??开发小组：

 sig-intelligence

??交流社区： 

https://www.openeuler.openatom.cn/zh/sig/sig-intelligence

-END-

供稿 | 史鸿宇

编辑 | 丘云

校审 | 郑振宇、刘彦飞

往期推荐

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
