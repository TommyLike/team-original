# [DevStation ｜ 告别命令行，用自然语言重新定义开发运维体验！](https://mp.weixin.qq.com/s/4Mh97Ws8nZAqj9G8AMmj9g)

[OpenAtom openEuler](javascript:void%280%29;)*2025-12-03 18:04:00广东*

想象一下，你不再需要牢记繁琐的 grep 、awk、find 命令参数，不再需要为了一个环境配置在无数文档中穿梭。你只需要对你的电脑说：“帮我找出家目录下修改过的 Python 文件，并总结一下主要的变更内容”，或者“为我创建一个 Python 3.9 的虚环境，并安装 pandas 和 numpy 库”。

这不再是科幻电影的场景。这一切正通过 DevStation 上的AI 智能助手变为现实，你只管提需求，其它的全部交给智能助手。

PART 01

什么是 DevStation 智能助手

DevStation 自带桌面 AI 助手软件，提供对话窗口，主动识别并理解用户的意图，支持用户通过自然语言的形势与操作系统交互，大幅降低开发者开发、运维和使用门槛。具体的交互逻辑视图如下：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCK17gUmtxtCiboO6Ac3Y159pGu5hcXozrVEwydcStEJAp4icOSpibbQChrf9J1NibmUTGjUrfybVcic2w/640?wx_fmt=png&from=appmsg)

- 交互 UI 层：DevStation 智能助手提供自然语言交互 UI，用户诉求会被传递到 Agent Runtime 进行处理。

<!--THE END-->

- Agent Runtime：作为整个智能助手的大脑，理解用户的意图并拆解转换成子任务，将任务委派给集成在 DevStation 中的 Agent、Mcp 执行，循环委派调度，直到所有子任务完成。

<!--THE END-->

- Agents Inside DevStation：依托于 OpenAtom openEuler（简称“openEuler” 或“开源欧拉”） 庞大的 Mcp、Agent 软件仓库，openEuler DevStation 正逐步演变成由 Agent 构成的 Agentic OS，当前 DevStation 智能助手除了内置的 Agent，还支持通过 DevStation 中的应用商店选择安装相关的 Mcp 和 Agent。

PART 02

安装指南：一键安装，开箱即用

只需要在您的 DevStation 环境中，复制以下 bash 命令到 bash 终端执行，即可完成智能助手的安装

```
wget -c https://repo.oepkgs.net/openEuler/rpm/openEuler-25.09/DevStation/polymind/x86_64/Packages/polymind-1.0.0-1.x86_64.rpm
sudo yum install polymind-1.0.0-1.x86_64.rpm -y
```

这里提前小剧透：12月31日待发布的最新 DevStation 会直接预集成智能助手，实现 OS 安装即可用

PART 03

使用初体验：与您的新“同事”对话

第一步：配置模型 API

目前DevStation智能助手支持多种模型 API，可以是本地搭建的 LLM 模型，也可以是云上提供的 LLM 模型服务，这里选择云上 deepseek 提供的 API。

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mCK17gUmtxtCiboO6Ac3Y159nib9xicNMlH2bwTNJJlHnUQfQckdSjxI9sKicNq0PzRy9bWTfud04BdgA/640?wx_fmt=gif&from=appmsg)

第二步：开始体验

体验一、通过自然语言开发一款 Web 服务，并进行测试和部署

您可以选择具体的领域 Agent，跟领域 Agent 进行对话，您也可以直接在对话窗口中提出您的需求，这里展示如何使用代码 Agent 写一个基于 Flask 框架监控当前环境 CPU、内存、磁盘使用等信息的的 web 服务，并进行服务的部署和测试。

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mCK17gUmtxtCiboO6Ac3Y159QxXMGlqeD2zesSu4ibzM0XULicnKJtcJUQmUFgkqyZRBjG71WDpWB03Q/640?wx_fmt=gif&from=appmsg)

当前 DevStation 智能助手的能力远不止如此，还可以 CVE 自动修复、软件自动部署等，依托于 openEuler 社区丰富的 Mcp、Agent 软件仓，您可以选择符合您诉求的 Agent 来完成您的任务。

体验二、支持将历史对话一键生成可执行快照，并可分发到其它环境

当您通过与 DevStation 智能助手进行多轮对话来达成最终目的，且希望刚通过智能助手在环境上进行的所有操作能够在其它环境上不借助模型的能力进行回放，可以试用智能助手的 AI Scripted 功能。

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mCK17gUmtxtCiboO6Ac3Y1592NjWDtqvMLbsjJSXoOYvtLYwwLRQk2CQvEHVAtKLOt15Q1VXX0e4JQ/640?wx_fmt=gif&from=appmsg)

体验三、快速扩展您已开发的 Agent

如果您已经开发了自己的领域 Agent，但不知道如何被高效的调度，目前智能助手支持基于标准 A2A 协议，能够快速集成您的智能体。

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mCK17gUmtxtCiboO6Ac3Y159tg4O2ic8skp00lbUh9yMKzAZHG1o3668WZTaTZcqegqVqUbBefWefhA/640?wx_fmt=gif&from=appmsg)

体验四、快速新开发创建您的个人 Agent

如果您也想快速开发属于自己的 Agent，但苦苦不知如何下手，不妨试下使用智能助手来开发创建对应的领域 Agent。

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mCK17gUmtxtCiboO6Ac3Y1591ENq3WLT7AUsY4AIkSUDoqUAw2pNHSH82hTVqTXqbbfVN5sSh1Sf5Q/640?wx_fmt=gif&from=appmsg)

PART 04

参与共创：一起携手前行

技术的真正生命力，源于对助手的每一次使用、每一次反馈和每一次贡献。智能助手并非一个完成态的产品，而是一个正在演进的开源项目，一个关于“未来如何与操作系统交互对话”的开放实验。它的能力边界，不应仅由初始团队定义，而应由像您一样在实际开发中遇到痛点的开发者共同描绘。

仓库源码链接

https://gitee.com/openeuler/polymind

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCK17gUmtxtCiboO6Ac3Y159ox6cuX4y0xLU0TiaQAvmPAQ83YCnLV5xlo2IMrbxGVSepsFwhmfOJmA/640?wx_fmt=png&from=appmsg)

PART 05

下期预告：DevStation 开发者应用商店

当然，DevStation 通过智能助手赋予开发者的探索之旅并未停歇，您更可通过 DevStation 软件应用商店，轻松发掘并体验琳琅满目的扩展功能。

下期精彩：我们将为您详细演示，如何利用软件应用商店快速集成所需的智能体，并完成 MCP 服务的安装与配置，助您将 DevStation 打造成更趁手的高效开发利器。

PART 06

加入社区，获取支持与反馈

独行快，众行远。为了给大家提供一个便捷的交流平台，及时解答使用中的疑问并收集反馈，我们特地开设了 openEuler DevStation 官方交流群。

进群你能获得：

- ?? 实时技术交流：与众多开发者和爱好者共同探讨；

<!--THE END-->

- ??? 安装使用帮助：遇到问题快速获得社区支持；

<!--THE END-->

- ?? 最新动态速递：第一时间获取版本更新和活动信息；

<!--THE END-->

- ?? 反馈产品建议：你的声音能直接帮助改进 DevStation。

添加 openEuler 小助手

进入 DevStation 交流群

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCK17gUmtxtCiboO6Ac3Y159BTJkIeaib06M7WKV4IiaHHVOPVFpxicru0bEgSPl35ib9vEMHnHSIsSUOA/640?wx_fmt=png&from=appmsg)
