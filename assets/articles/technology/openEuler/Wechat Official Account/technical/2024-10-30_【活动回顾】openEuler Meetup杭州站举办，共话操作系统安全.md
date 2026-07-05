# [【活动回顾】openEuler Meetup杭州站举办，共话操作系统安全](https://mp.weixin.qq.com/s/DT2lA6fLr-qTfxyRd6UtUw)

[OpenAtom openEuler](javascript:void%280%29;)*2024-10-30 19:59:00广东*

10月25日，OpenAtom openEuler（简称”openEuler“） Meetup杭州站成功举办。本次Meetup围绕主体“操作系统安全”，邀请了openEuler安全委员会委员、安全技术SIG成员以及华为、超聚变、润和软件、浙江大华等技术专家进行分享，展示openEuler以及发行版在安全治理策略、创新技术和实践案例，并在现场与来自杭州及周边地区的多家用户企业进行交流。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAibjVict5nGn7b7fGOXJgicFh6c4qKBFicALSOwgwWSBe9KBcKibeygtnicyrpFGZ0npKMHAfzJHugNqcA/640?wx_fmt=png&from=appmsg)

精彩回顾

“

**openEuler社区安全技术介绍**

openEuler 安全技术sig Maintainer张晨峰为大家介绍了目前openEuler的安全技术栈，基于 “可信计算、机密计算、全栈国密、基础安全” 的韧性架构打造安全可信方案，提供全面的安全保护。可信计算方面，openEuler通过软件包签名、安全/可信启动、IMA和DIM方案实现从软件发布到运行的完整性保护。全栈国密方面，OS内核及用户态提供国密基础支持，密码应用完成国密改造（共30+密码相关组件），作为信息系统底座支撑全行业国密使能，满足密评。机密计算框架secGear为开发者提供了统一的安全应用框架和工具，简化了跨平台开发。此外，openEuler还内构了异常检测探针，以提供主机实时威胁感知和响应能力，并进一步探索智能检测，实现系统主动防御。安全配置基线则联合OSV、安全厂商构建标准，配套加固核查工具，打造基础安全。这些技术共同确保了openEuler在面对网络安全威胁时的韧性和安全性。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAibjVict5nGn7b7fGOXJgicFhbibUW18H6m4icYLyEyicvHpsKKpgHKqYMVtAsjR1fqHdkeK2Z8oChjPaA/640?wx_fmt=png&from=appmsg)

“

**openEuler社区安全技术介绍**

openEuler社区安全委员会委员罗钰凯为大家带来了openEuler社区安全治理策略和漏洞治理流程的分享，社区通过安全委员会实施了一系列安全治理措施，包括自动化测试和供应链安全评估，从来源安全、编码安全、构建安全、发布安全、环境安全覆盖整个软件开发生命周期。社区遵循业界最佳实践，如CVRF和CSAF，制定了详细的CVE处理流程和漏洞修复目标（SLA），以快速响应和修复高风险漏洞。此外，社区还推出了漏洞奖励计划，鼓励安全研究者发现并报告安全漏洞。通过openBrain和CVE-manager等工具，社区有效地跟踪和管理漏洞，同时通过majun平台提高漏洞披露的透明度和效率。这些措施共同构建了一个全面的安全防护体系，保障了openEuler项目的安全性和可信度。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAibjVict5nGn7b7fGOXJgicFhIIOHFFj7VDzDysKWT8FNyJJQSOMHjGXY9bnicTOoOY9UtLnjT7E6d1g/640?wx_fmt=png&from=appmsg)

“

**openEuler发行版协同漏洞处理案例**

超聚变FusionOS安全架构师王金超在演讲中分享了openEuler与FusionOS发行版协同漏洞处理的目标和实施流程，从漏洞的感知、漏洞处理、结果发布和应急响应等几个方面介绍了漏洞相关自动化系统搭建、人工手段和自动化手段的协同以及应急响应时的团队组织方式。通过一系列措施，即保障了客户侧的安全性，又不断将安全能力提升贡献到社区，实现openEuler社区与发行版的协同良性发展。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAibjVict5nGn7b7fGOXJgicFhukyOK9RIbb8W63eVzx3EBTOjSAqB0kQLZV79Iyu0PpZchWEOxSeNrw/640?wx_fmt=png&from=appmsg)

“

**操作系统安全防护实践**

来自浙江大华的基础软件专家薛光峰分享了基于openEuler构建的承载着大华的智能服务系统底座的羚境OS在安全防护上的策略和实践。大华羚境OS引入了安全SHELL设计，实现系统账号和运维账号的双重身份验证，以降低账号泄露风险。在漏洞管理方面，开发了vul-tools工具，简化了漏洞分析和修复流程，能及时发现并修复系统漏洞。系统安全加固遵循最小化攻击面等原则，提供了包括账号安全、日志安全在内的多个加固指南。安全启动确保了从CPU到应用程序的全链路安全，防止未签名程序运行。这些措施共同构建了一个全面的系统安全防护体系。大华羚境OS将继续深入探索操作系统实践，推动更多业务领域的应用与发展。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAibjVict5nGn7b7fGOXJgicFhdrXE8xroZM7IuI9P6xClvETpqZico1IJ5y7B1FWRCS8ty74acVL6eHQ/640?wx_fmt=png&from=appmsg)

“

**基于openEuler构建高安全性定制发行版实践**

openEuler技术委员会委员魏建刚在演讲中分享了润和软件基于openEuler社区版面向行业用户定制高安全性发行版实践经验。针对通用操作系统软件包冗余带来的潜在安全风险和不同行业场景对于操作系统平台的安全要求差异需求，遵循国家、团体以及行业相关标准归纳总结出安全配置库、安全定制原则和最佳实践。通过分层次、分模块地制定合理且可操作的操作系统安全目标、体系以及实施流程来保障定制版本的安全性。此外，操作系统交付后的安全运维服务保障建设应该得到更多的重视。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAibjVict5nGn7b7fGOXJgicFhB075y8DBb7mA9GCnp7ItsZhVUQiaH0vw5YcPaAMjMicy5Mp6VD6KDBicQ/640?wx_fmt=png&from=appmsg)

“

**鲲鹏virtCCA机密计算方案介绍**

华为鲲鹏计算解决方案专家鲍鹏分享了机密计算产生及发展背景、鲲鹏机密计算的演进路线以及鲲鹏virtCCA机密计算的方案介绍，包含了机密容器、设备直通等重要能力，并展示了相关的应用实践。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAibjVict5nGn7b7fGOXJgicFh0JlB3YoKHiaVpI2y8KQdIgjeaUSepBJvF3F4GgjE7QlRYv32kHvByJw/640?wx_fmt=png&from=appmsg)

同时在本次活动上正式成立openEuler杭州用户组，首批成员有来自浙江大华、超聚变、安恒信息、正元智慧、中软国际、浙江熵量科技等企业代表加入，共同打造杭州区域openEuler用户交流和生态建设平台。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAibjVict5nGn7b7fGOXJgicFh1A3C1n4jAUMia34Q7yvnYlgiaPWWvax2BydgaMXxqQ9YuDd83auT6PAw/640?wx_fmt=png&from=appmsg)

欢迎加入openEuler杭州用户组

【openEuler用户组是由各区域的用户、开发者、操作系统爱好者组成的区域化交流圈子，通过用户组线上社群和线下活动有更多集中交流机会】

![](https://mmbiz.qpic.cn/sz_mmbiz_png/eYDxdTMF0GicqibA2zPqjXRB5EmQ6S3Z6Uht610MBJDkRbDDZo6KfM1LoBzPSdWJ3ggkD6pUNib4lyzibicSKrbgA6w/640?wx_fmt=png)

扫码申请加入用户组

![](https://mmbiz.qpic.cn/sz_mmbiz_png/nBqoYjNjmxj5I8klGQs6Mjvz12ybc7YF5BFNcEQPsQt8oyGh8jMBgGEjfZNOdia12fmQdY4DbUXBOeUDFaTLIWw/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mAibjVict5nGn7b7fGOXJgicFh8dZ0kpVcibbpqOtNbF7l1mVYdoNc6j9VA6eUZwl3ToMKPhQXjF4wUmg/640?wx_fmt=jpeg)

![](https://mmbiz.qpic.cn/mmbiz_jpg/rrbZLC2ibIgtgV382cFCwmibpHFT7jndu1ibEDpFia0dzsjETHdt0HFzYlVRnHIaumpf3QyVos7giadDicqSku9zOEibw/640?wx_fmt=jpeg "金属质感分割线")

[![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAb2t1LkGXJHicuGDklRKxKTHBMJjdMdDRDUuunpBN0NaicXfFG5ibBjwicQ6JVyeagdWg4axibXLRicgCA/640?wx_fmt=png&from=appmsg)](http://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247511955&idx=1&sn=a89aeb34f87cc2b5a418771ab1495deb&chksm=c1f3b7fef6843ee866818f8d2b8eda2755d0bf7147d9d74d3f9774c31b37d41003057bc7381b&scene=21#wechat_redirect)
