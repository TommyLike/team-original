# [oDD 2026 SIG Gathering回顾 ｜ AI 如何深入开发全流程？这场专题研讨给出了答案](https://mp.weixin.qq.com/s/WmmTKY-1eyKnJ8AEpr078w)

[OpenAtom openEuler](javascript:void%280%29;)*2026-05-07 18:03:26广东*

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a47pmwYKrTftvGXyFfspek4hoUibdJtrBB96517RL4k2AXD1gSav958g/640?wx_fmt=gif&from=appmsg)

# 在4月25日落幕的 openEuler Developer Day 2026（简称“oDD 2026”） SIG Gathering 上，由openEuler DevStation SIG Maintainer 朱泽旭、openEuler OpenDesign SIG Maintainer 黄夏璐出品的“AI 时代高效开发与生态包管理”专题研讨成功举办。

**开发者在今年的研讨方向上已经进入了“AI 如何深入参与开发全流程“的实践阶段。**当 AI 一天能产生数万行代码，当 PR 解释都开始“魔法对轰”，openEuler 社区该如何接住这场生产力海啸？本次专题的分享与碰撞，给出了来自基础设施、开发者体验和软件包生态三个维度的答案。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/rxr9tddEHOv810sKPQo1RsiafxUYRQO36FEKOqn7gQnljk4YjoP7iaJEJy9xz7lrnT9k8aZIpLDHicjo8PzlQoWgfnRicUMYBiaPpozdhhvHCkvM/640?wx_fmt=jpeg&from=appmsg)

**基础设施：内核审查、软件包引入与构建体系，全链路注入 AI**

**? 内核代码审查开启“AI vs AI”时代**

麒麟软件赵禹、吕志奇带来首个硬核议题：将 AI Review 嵌入内核 CI 流程。面对大量由 AI 辅助生成的 PR，传统的纯人工审查早已不堪重负。他们分享的增强学习结合提示词调优方案，正在让 AI 承担起代码解释与质量守护的角色。现场一个有趣的观点引发了热烈讨论——当 AI 提代码、AI 又去审查代码，这俨然成了不同大模型之间的“魔法对轰”，最终胜出的将是更高质量的代码与持续进化的模型能力。

**? 构建基础设施的三大变革**

Cloudnative SIG Maintainer、联通数科高级研发专家王麟则把目光拉宽到操作系统生产与维护的全生命周期。上游物料引入环节新增供应商征信审查与 License 合规追溯，动态检测源头风险；AI 赋能补丁合并冲突处理，将原本巨量的人工冲突处理压缩到分钟级；CVE 漏洞深度分析排查更是一改以往“唯上游公告论”，基于根因分析、代码逻辑审查、测试构建难验证结果自动生成排查报告，将人工漏洞分析效率提升 90%。这三步棋，实现了从“信任上游”到“自主可控安全判断”的跨越。

**? 软件包全流程自动化引入**

Infrastructure SIG 成员、华为梁皓星直面社区痛点：多语言、多架构软件包的引入太依赖人工经验。他们实践的 AI Agent 驱动框架，覆盖上游仓库活跃度审查、License 合规检测、多语言 spec 自动生成与迭代修复，乃至传递依赖递归引入与循环依赖检测。一句话概括——让繁琐的引入工作工程化、代码化，把维护者从重复劳动中解放出来。

**? 智能存储为 AI 训练加速**

凝思软件彭驿翔从 AI 开发场景的物理瓶颈切入，分享了 openEuler 下轻量级智能预取策略。在内核侧以极低开销分析数据访问模式，提前预取数据，显著改善模型训练中的数据加载与小 IO 延迟，并已计划将这种底层优化能力平滑映射到 DevStation 开发环境中，让开发者直接感受到训练效率的提升。

▲交流现场

**开发者体验：让工具、信息与流水线都为 AI 原生而变**

**? Agentic OS：消灭异构智能体之间的孤岛**

Devstation SIG Maintainer、华为袁礼鹏提出了一个前瞻构想——面向开发者的 Agentic OS。在多异构 Agent Runtime（如 openclaw、opencode）共存的趋势下，打造统一纳管与协同调度层，打破“非此即彼”的工具选型局限，让不同智能体在开放网络中协作。这正是 DevStation SIG 致力构建的“面向开发者智能体操作系统”核心蓝图。

**? 社区信息不仅要给人看，更要给** **AI 看**

OpenDesign SIG Committer、华为黄世俊带来一个颇具未来感的视角：今后官网文档需要考虑的不仅是人类读者，还要确保大模型爬取时能准确吸取 openEuler 的核心知识。通过GEO优化为 AI 设计“看文档”的最佳路径、通过MCP等工具为开发者提供AI工作流下获取信息的新方式。围绕AI时代社区信息“可发现、易获取”目标，用自然语言统一社区信息入口解决信息孤岛，将成为社区信息建设的新标准。

**? CI/CD 全流程极简进化**

Infrastructure SIG Committer、华为刘波总结了AI时代开源社区开发工程能力演进方向是"一切皆代码、一切皆 CLI + AI Agent", AI 不只是代码生成器，而是预审官与AI 质量助手 。先夯实基础软件工程能力如“环境即代码、代码检查规则与屏蔽即代码、流水线即代码”，然后统一定义AI软件工程范式即代码如“SPEC/SKILLS定义开发规范，代码质量、流程要求”等，再按约束AI Agent 调用Gitcode CLI对代码仓库执行。AI4 CI/CD全场景应用包括ISSUE分析汇总-&gt;Fork个人仓-&gt;Issue评审 → 开发 → 验证→ 提交PR → Review → Merge，编译与测试问题智能定位，编译链路依赖分析与时长优化、 AI CI/CD效率度量等。

**直面软件包生态的“真问题”**

个人开发者王弈桥的《开源欧拉社区软件包生态大观》直指痛点：对比主流发行版，openEuler 缺包、版本陈旧，分发入口重叠。他提出需统一入口、建立透明版本更新机制，并借助 AI 辅助看护，在稳定与敏捷之间找到平衡。这一视角与出品人组织的深度讨论高度共鸣，讨论达成共识：AI 时代的基础设施，必须有“基础稳定、扩展丰富、拿手即用”的软件包生态，社区将探索更合理的折中方案，让 DevStation 真正成为版本选型快速迭代的高地。

![](https://mmbiz.qpic.cn/mmbiz_gif/FIBZec7ucChhZqvOVoz3euT3icYwAAGMrWwlicWP9KGTgxO4349wMbN91D40ib0KLInRdUJrukWn9FY8MP8ZMEnWg/640?wx_fmt=gif)

当前，openEuler 社区在 AI 时代的进化路径已然清晰：**不是用 AI 点缀流程，而是让 AI 重构流程。** 可以预见，当内核审查变为模型间的“对轰训练”，当软件包引入变成 Agent 的自动化流水线，当开发者打开终端即拥有统一纳管的智能体兵团，openEuler 将不仅是一个操作系统，更会成为一个面向 AI 时代的高效开发母体。

-END-

供稿 | 吴佳聪

编辑 | 丘云

校审 | 郑振宇、刘彦飞

![](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOuB3a0bIS1b8iaV2YW4ibjFV3zjX0VhqrKibImSqcJl8ZmF4zAhaBeKjKyxK646U6icV4iahovLFeE7yBfcHRwvD5C6Y0aUuq8ZWIAE/640?wx_fmt=png&from=appmsg)

**推荐阅读**      Recommend

[![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/rxr9tddEHOtGoicltbYd3ZpoluF9GMaVK0zoQNlNxeYBt12ribviaauChq92ictsKvQDHibzXhzuJH5T1G4bHrD3qx9o0YQXr0esnYB3Ul6iaSP2Q/640?wx_fmt=jpeg)](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247519611&idx=1&sn=dfc157253a1804ee7817e21d2d9cb6fe&scene=21#wechat_redirect)

openEuler Developer Day 2026成功举办

&lt;

[![](https://mmbiz.qpic.cn/mmbiz_jpg/rxr9tddEHOsS8wm9OOQFrevtdNJO3g0dJWd2FrIdgvicAU3ibcRGRyYF5aoKsoPGEKLWjjYYnWEDcRo0mwTukgpfwKXZiaSnQDweHP68Jxnn78/640?wx_fmt=jpeg)](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247519642&idx=2&sn=605ef44445863b3e6b6a82b4a0d3d212&scene=21#wechat_redirect)

重磅看点全解析！openEuler Developer Day 2026现场要点一图速览

&lt;

**关注我们，了解更多**

**▼**

![图片](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2d1CvxNf56DXribfOKnOqvMU1jP4fVRpO45sDy84Knibcp1OuASLm5MMg/640?wx_fmt=png&from=appmsg&wxfrom=5&wx_lazy=1#imgIndex=1)
