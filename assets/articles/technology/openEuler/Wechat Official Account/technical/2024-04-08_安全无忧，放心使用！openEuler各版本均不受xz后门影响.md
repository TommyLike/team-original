# [安全无忧，放心使用！openEuler各版本均不受xz后门影响](https://mp.weixin.qq.com/s/YlYM7bxTuUzavsqzdMNYOA)

[OpenAtom openEuler](javascript:void%280%29;)*2024-04-08 17:35:10广东*

近日，微软的安全研究员Andres Freund调查程序性能下降时发现并揭露了开源项目xz-utils存在的后门漏洞。OpenAtom openEuler社区安全委员会第一时间进行分析排查，经验证，**openEuler操作系统均不受xz后门影响**，本文将深入探讨CVE-2024-3094漏洞以及openEuler的漏洞管理流程。

**漏洞描述**

xz是用于压缩/解压缩文件的一款压缩库，微软的安全研究员Andres Freund调查程序性能下降时发现了该漏洞，xz漏洞从5.6.0版本开始存在恶意后门，该后门存在于XZ Utils的5.6.0和5.6.1版本中，如果机器上装有涉及CVE-2024-3094缺陷的xz软件，远程攻击者能够通过SSH发送任意代码，造成远端任意代码执行，进而有效控制受害者的整台机器。

**解决方案**

卸载/弃用xz 5.6.0/5.6.1缺陷版本，**可使用openEuler社区发行的xz稳定版本xz 5.2.5**。

**openEuler的漏洞响应**

●  2024年3月28日，openEuler初步感知到xz 5.6.0/5.6.1版本存在安全风险。立即发起了对openEuler 2203-LTS，2003-LTS各个发行分支，以及测试中的分支2403-LTS进行全量的软件版本排查，最后确认有缺陷的xz 5.6.0/5.6.1版本没有引入openEuler仓库。

●  2024年3月29日, openwall 披露了xz CVE-2024-3094的攻击代码和攻击手段。openEuler安全团队实时跟进，组织相关技术人员分析openEuler xz的源码是否存在恶意攻击代码，从源码代码层面确认了CVE-2024-3094漏洞不涉及openEuler xz软件。

**openEuler的漏洞管理流程**

openEuler社区非常重视社区版本的安全性，社区安全委员会制定了一套社区漏洞处理策略和流程，包括漏洞感知、漏洞确认和评估、漏洞修复以及漏洞披露等阶段。

每一个安全漏洞都会有一个指定的人员进行跟踪和处理，协调员是 openEuler 安全委员会的成员，他将负责跟踪和推动漏洞的修复和披露。漏洞端到端的处理流程如下图。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAEUQZiaGLEFBdPcKVPQ4jdDkqULmttcQOnhcOkmPJ2qXqo782KFso6aibzYcj7ZuibNQ6b9GtUaAibpQ/640?wx_fmt=png&from=appmsg)

安全漏洞更新维护是操作系统版本安全的重要组成。openEuler 安全委员会制定了严格的漏洞处理流程，让openEuler安全无忧，放心使用。

**安全知识培训**

为了应对日益增长的网络安全风险，保护企业信息系统和核心资产的安全，实现操作系统安全配置的规范化、标准化、例行化，提升社区安全的一致性和管理的便捷性，openEuler 推出了安全知识系列线上直播栏目。

本周三晚 19:00-20:00，让我们一起锁定「openEuler」B 站，一起来参加安全知识培训吧~

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mDF2URCIAdcQRBpibEUw8Sew3ImkObzJahETHlytaY09wHBVHyKfg7iahQLIqBHLa6r77g3jSUS9YAQ/640?wx_fmt=png&from=appmsg)

如果您对openEuler安全委员会感兴趣可以添加小助手微信“openeuler123”，备注【安全】，加入安全委员会交流群。
