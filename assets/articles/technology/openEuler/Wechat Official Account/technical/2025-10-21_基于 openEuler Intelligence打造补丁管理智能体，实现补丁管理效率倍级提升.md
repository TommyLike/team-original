# [基于 openEuler Intelligence打造补丁管理智能体，实现补丁管理效率倍级提升](https://mp.weixin.qq.com/s/SwRTuH6iDISfD3QucNeOzw)

[OpenAtom openEuler](javascript:void%280%29;)*2025-10-21 11:45:00新加坡*

操作系统内核作为软件的底层核心，其稳定性与先进性是上层应用及服务健康运行的基石。业界在内核补丁管理上面临以下两大矛盾：

迭代速度：Linux 主线内核每 9-10 周发布一个版本，单次更新含 2000-3000 个补丁，上游社区的高频更新与企业级系统对稳定性的要求形成尖锐矛盾。

版本生命周期：企业级服务器OS维护周期通常为 5-8 年，与 Linux 6.6 内核、 OpenAtom openEuler（简称：“openEuler”或“开源欧拉”）等社区版本维护周期存在适配矛盾。

为了弥合迭代速度快慢和生命周期长短的矛盾，企业需要投入资源从上游社区海量补丁中选取相关的补丁回合到生产用版本的分支上。这个过程之前以人工手动为主，而人工主导的流程在处理规模、效率、错误率、响应时效性等方面存在瓶颈：

人工流程痛点

具体数据

补丁处理规模

数千级别/次

资深工程师耗时

80 小时+/千条补丁

冲突检测错误率

10%+

高危漏洞响应周期

14+ 天

为了解决上述问题，本文基于 openEuler Intelligence 设计并开发了“补丁管理智能体”，其平台及代码完全开源，效果可复现。

**01**

技术架构：分层解耦驱动智能高效协同

“补丁管理智能体”采用三层解耦架构，如下图所示，实现高可扩展性、稳定执行能力与功能隔离。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mD9TIG3LgKLJjRs4UmAJN2MQkg5u70zRhUaJN0a1oOEaMGjuE61tz1fuoUiaaibdPM9NiaAjRgicQXdJQ/640?wx_fmt=png&from=appmsg)

交互控制层（Client）

- 可视化平台：图形化交互界面，提供美观易用的指令输入、结果查看与操作触发。

<!--THE END-->

- CLI命令行：类 Shell 终端界面，提供高效灵活的用户指令与配置参数输入，适配自动化脚本及高级用户需求。

执行引擎层（Server）

openEuler Intelligence 服务引擎，实现操作系统级的 Agent 智能体与 MCP 工具管理，提供全局、高效、低噪的智能服务框架。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBeSJ7RYB7ibjE33WlczQoZ0iaGIdibNyJgRI42xS3w7K4392uSI2flpRWufSh6UTvyjk74H0xuFRvwg/640?wx_fmt=png)

- 后台守护服务：低噪的后台常驻进程，自动化处理任务接收、调度与结果推送。

<!--THE END-->

- Agent 管理服务：系统级的 Agent 管理，提供 Agent 个性化与长期记忆能力。

<!--THE END-->

- MCP 管理服务：系统级的 MCP 工具管理，提供 MCP 注册、运行、查询与调用服务。

智能分析层（AI Engine）

- 基座大模型：基于 Qwen 等大模型的原生代码理解能力开展补丁分析。

<!--THE END-->

- 提示词工程：标准化模板设计，无需模型微调即可生成格式规范、字段完整、信息准确的结构化报告。

<!--THE END-->

- 语法分析器：将代码及补丁提交信息转化为大模型可理解的自然语言。

**02**

功能实现

功能实现将从黑盒视角的用户交互，及白盒视角的内部模块两方面阐述。

黑盒视角：用户与 Agent 交互流程如下图所示：

1. 用户以自然语言输入任务，Agent 理解后调用内部 MCP 服务；
2. Agent 完成补丁分析，输出分析报告；
3. 用户审核报告关键内容，确认无误后以自然语言下发补丁回合任务；
4. Agent 调用 MCP 服务完成补丁回合并提交改动，返回 MR 链接。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBeSJ7RYB7ibjE33WlczQoZ01GPunad7sGvj428h7LzjJgibxrn2wuynxCZicjeLibPK0qlO8TpibAic6hw/640?wx_fmt=png&from=appmsg)

白盒视角：三大核心组件如下图所示

1. workflow 规划 Agent：采用语言大模型 + workflow 设计，由大模型完成任务理解与分发，客户端内置高效 workflow 流水线执行任务；
2. 补丁分析 Agent：结合动态提示词与大模型，实现补丁内容精细分析及分析报告输出；
3. 代码整理 Agent：通过模块粒度补丁自动整理、冲突代码智能解决方案，完成补丁合入与 MR 提交。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBeSJ7RYB7ibjE33WlczQoZ0QYEIOGANiaAiauhC65wY0SYMlJl89qHo3Jg3h32N29mUzAQhuDicBWQ5Q/640?wx_fmt=png&from=appmsg)

核心组件一： workflow 规划 Agent

在场景化任务规划中，大模型成功率低于传统 workflow 已是行业共识，核心差距在于两者设计逻辑：大模型依赖统计规律生成内容，缺乏确定性任务的结构化理解能力，多步骤任务中易出现 “错误雪崩”。以本场景补丁管理为例（含拉取补丁、切换分支、生成补丁等 6 步），即便单步准确率 90%，串联后整体成功率仅 0.9?=53%。以下为相同任务重复 10 次的成功率对比

任务规划方式

DeepseekV3

Qwen3

workflow

成功次数

5

6

10

为解决此问题，方案提出“意图理解 + workflow”融合模式：由大模型负责任务理解与分发，workflow 负责具体执行与落地，最终达成智能与效率的双赢。同时针对“大批量补丁分析任务耗时长”的问题进行优化。初期尝试 “补丁压缩 + 请求合并”，虽减时 20%，但易因 token 超限导致截断或失真；最终落地 “并行 workflow 流水线”方案，在提速同时保障准确性。提速优化前后的耗时对比数据如下：

测试补丁数量

单流水线 workflow

4流水线 workflow

8流水线 workflow

50个

100分钟

30分钟

15分钟

100个

200分钟

60分钟

30分钟

“并行 workflow 流水线”的代码示例

```
max_workers = clientconfig.get("max_workers")  # 配置文件获取并行数with ThreadPoolExecutor(max_workers) as executor:  # 运行线程池    while idx <= patch_count or futures:        # 设置补丁分析函数        executor.submit(vllmanalyzerfunc, xxx)        # 处理分析函数返回内容        if futures:  # 控制线程池任务调度            done, futures = wait(futures, return_when=FIRST_COMPLETED)            try:                future.result(timeout=60)  # 等待分析完成            except Exception as e:  # 捕获异常                # 异常处理分支                handle_exception(e)
```

上述代码示例核心技术如下

1. 灵活性：并发数从配置文件读取，适配不同大模型并发能力；
2. 高效并发：ThreadPoolExecutor 避免线程频繁创建 / 销毁，降低开销；
3. 动态调度：while 循环 + wait (FIRST\_COMPLETED)，保持线程池满负荷运行；
4. 健壮性：try...except 捕获单任务异常，防止全局崩溃；

核心组件二：补丁分析 Agent

补丁分析场景中，代码变更范围、业务逻辑、修复意图差异大，纯静态提示词易出现分析偏差或信息遗漏。为解决此问题，方案提出“静态 + 动态混合提示词”策略，具体包含静态基础层——以通用框架、基础要求的静态提示词保障分析结构化；动态优化层——以多轮对话方式收集用户反馈（修正 / 补充需求），实时生成动态提示词，实现个性化精准分析。以下为 kernel 仓50 个补丁人工标注的准确率对比：

提示词类型

纯静态提示词

静态+动态提示词

分析准确补丁个数

32

40

“静态 + 动态混合提示词”的代码示例

````
"""你是一个 AI 辅助补丁分析工具，可以结合提供的工具来帮助回答用户的问题。请根据问题判断是否需要调用工具，如果需要，请选择合适的工具并正确指定参数。工具调用结果返回后，请结合结果逐项分析给出最终回答，分析结果按照要求返回，所有的结果都是有用的，请不要遗漏。如果不需要调用工具，可以直接回答问题。你需要遵守以下规则：1. 分析结果需要完整，不可以遗漏。2. 你给出的最终结果将按照纯 JSON 格式被解析，返回结果请严格按照以下 JSON 格式，   不要包含任何格式（例如 Markdown ```json），也不要添加解释。结果输出格式为：{    "提交信息": "860874bd1cca5142eb23d123a0aeac7ec9d73d75",    "模块": "PINCTRL",    "改动说明": "修复 XXX 配置不支持模块（'m'）选项的问题，将其修改为内置（'y'）方式",    "判断理由": "xxxx",    "合入策略": "是",    "提交标题": "PINCTRL: Fix the issue that CONFIGPINCTRLAMD do not support m option",    "补丁类型": "bugfix"}参数解释：提交信息 —— 补丁信息中对应的补丁编号；模块 —— 补丁修改涉及的文件所属模块，通常在提交标题中会显示；改动说明 —— 补丁信息中对补丁修改点的描述，使用中文生成回答，计算机相关专有名词使用英文表述；判断理由 —— 基于以下几点分析：{judge_rules}；合入策略 —— 是 / 否，根据“判断理由”设置是否需要回合；提交标题 —— commit 的标题，从补丁信息中提取，格式为“模块：修改内容”；补丁类型 —— 根据合入策略分析结果，代码的改动属于哪一类型；"""
````

上述代码示例使用 {judge\_rules} 变量拼接，该变量可依据用户对分析结果的评价实时调整，实现 “一补丁一分析”。

核心组件三：代码整理 Agent

补丁回合流程中，上游社区拉取的补丁常因 “本地代码仓版本差异、定制化修改”无法直接应用，最终因代码行冲突导致失败。为解决此问题，方案设计“兼容检查+冲突修复”机制进行代码整理后合入。补丁应用前，先通过兼容性检查预判适配性，若判定不适用，提取补丁关键改动行，合成专属生成提示词输入大模型，输出已解决冲突的适配版补丁。以下为 kernel 仓 50 个补丁文件的应用回合成功率对比

应用回合方式

直接应用

兼容判断+修复后应用

成功个数

45

49

核心技术：专属补丁生成提示词的构造——需包含关键改动代码，剔除无关代码。具体通过“函数切片 + 源分支补全”实现：对补丁涉及函数切片，结合源分支补全形成语法完整、依赖闭环的目标函数，补丁专属提示词生成过程示意图如下

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBeSJ7RYB7ibjE33WlczQoZ07o7XOdpxfC6bMz9s8u7hjtHn3ibHSibxgNqyWZN8cAia3yxtmvaocqI7A/640?wx_fmt=png)

**03**

安装部署

(可选)下载配置 conda 环境

```
conda create -y -n mcp-server python=3.10conda activate mcp-serverpip install gitpython fastmcp pandas openai openpyxl cachetools
```

下载安装 openEuler Intelligence 引擎和 MCP 服务

```
dnf install openeuler-intelligence-installer -y  #yum源安装(可选)git clone https://gitee.com/openeuler/euler-copilot-framework.git  #源码安装git clone https://gitee.com/openeuler/mcp-servers.gitcd mcp-servers/patchanalyzermcp/src/
```

配置补丁分析 MCP 服务的源、目标代码仓、分支和大语言模型 API

```
vim assistant.conf#配置仓库信息kernelsrcurl=https://gitee.com/openeuler/kernel.gitkernelsrcbranch=openEuler-25.03kerneldsturl=git@gitee.com:xxxxx/kernel.gitkerneldstbranch=personal/openEuler-25.03kernelprojecturl=https://gitee.com/api/v5/repos/xxxxx/kernel/pullskernelprojecttoken=xxxx#配置语言模型APIapi_key=sk-xxxbase_url=https://dashscope.aliyuncs.com/compatible-mode/v1model_name=qwen3-max-xxx
```

```
启动 MCP 服务
```

```
python3 patch_assistant.py
```

配置 RooCode 客户端以http方式连接到 MCP 服务

```
{  "mcpServers": {    "patchAnalyse": {      "type": "streamable-http",      "url": "http://0.0.0.0:8100/mcp",      "disabled": false,      "timeout": 3600,      "alwaysAllow": []    }  }}
```

(可选)copilot-shell 客户端安装

```
git clone https://gitee.com/openeuler/euler-copilot-shell.git配置参考：https://gitee.com/openeuler/euler-copilot-shell/blob/dev/docs/%E9%83%A8%E7%BD%B2%20&%20%E4%BD%BF%E7%94%A8%E6%89%8B%E5%86%8C.md#%E4%BA%94%E9%BB%98%E8%AE%A4%E6%99%BA%E8%83%BD%E4%BD%93%E7%9A%84%E4%BD%BF%E7%94%A8
```

至此环境配置完成，以下我们通过一个实际例子，展示“补丁管理智能体”的具体工作流程。

openEuler Inteligence补丁管理智能体工作流程演示

openEuler Intelligence补丁管理智能体工作流程演示-CLI

**04**

伙伴落地案例

深信服科技股份有限公司（以下简称深信服）作为 openEuler AI 联合工作组核心成员，率先引入 Intelligence BooM 解决方案，并基于其中的 openEuler Intelligence 成功对接其内部的诸葛神码平台，部署了“补丁管理智能体”。

方案落地的预期目标

- 智能化简化流程：通过大模型自动化补丁分析（精准识别修复类型、评估关键影响），降低对资深专家的依赖，提升开发者参与效率。
- 提升合入效率与精准度：自动化分析、冲突检测及标准化 MR 生成，缩短补丁周期，减少人工失误，增强流程可靠性。
- 交付更稳定内核：快速合入上游关键修复与安全更新，减少内核缺陷引发的系统故障、安全漏洞及停机风险。
- 支撑技术快速演进：高效引入上游新特性与性能优化，助力产线及时利用内核技术红利（如新硬件支持、云原生增强），加速产品创新。

“补丁管理智能体”效果验证：

以深信服 kernel 历史 tag 版本人工分析报告为基线真值，按模块选取数百条 commit 验证，结果如下：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBeSJ7RYB7ibjE33WlczQoZ09CicU9T8nO6ia9mPAmuJpdicKQdRnEsaLBn5Ypia9h4b37AC0AttkDWucQ/640?wx_fmt=png)

- 分析准确率：整体为 75%-93%，可有效还原补丁修改意图，准确筛查剔除非核心改动补丁，辅助开发人员快速定位关键改动。
- 效率提升：大幅加快补丁分析速度，原需 1 人周的工作量，现 1-2 小时即可完成；同时提供补丁链接与改动描述，降低人力成本，提升分析效率。

综上，该智能体在补丁归类、模块识别、影响评估及辅助回合中实用价值良好，作为内核维护与版本管理的重要辅助工具，具有释放研发核心产能的优势，让深信服内核团队专注于高价值的内核开发、深度优化及前瞻性技术预研，提升基础软件平台竞争力。

**05**

未来展望：智能化引领操作系统管理新范式

智能补丁管理 Agent 的研发应用，正引领传统人工驱动的开发流程向 AI 原生的智能化、标准化工程体系转型。未来，AI 将深度融入到操作系统内核优化、安全防护、运维管理等领域，实现故障预判自愈与能力动态进化，让操作系统成为 “会思考、能自愈、可成长” 的智能计算底座。

Intelligence BooM AI 开源基础软件栈是联合 23 家社区/伙伴成员一起打造的大模型全栈开源解决方案，包含异构融合平台、任务管理平台、数据管理平台、运行加速平台、智能应用平台及全栈安全平台等 6 大平台，20+ 开源组件。openEuler Intelligence 是 openEuler 社区在 Intelligence BooM 软件栈中构建的智能应用平台。伙伴可以基于发布的参考实现进行商业场景应用，参与社区代码开发，进行技术及 Agent 应用创新等。

全栈方案及部署教程链接

https://gitee.com/openeuler/llm\_solution

欢迎大家访问和提 issue
