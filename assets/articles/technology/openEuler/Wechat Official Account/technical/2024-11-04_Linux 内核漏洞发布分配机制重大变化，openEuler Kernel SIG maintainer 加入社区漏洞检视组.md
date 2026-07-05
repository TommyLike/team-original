# [Linux 内核漏洞发布分配机制重大变化，openEuler Kernel SIG maintainer 加入社区漏洞检视组](https://mp.weixin.qq.com/s/-Fhejmp_rg5DCpoMR_Yy6A)

*Kernel SIG*[OpenAtom openEuler](javascript:void%280%29;)*2024-11-04 21:05:09中国香港*

## 背景：内核社区接管 Linux 社区漏洞发布

往年 Linux 内核漏洞发布存在来源不固定、覆盖不全面，有时发布无修复补丁的 CVE 从而形成 0-day 漏洞等问题，给 Linux 内核安全带来了不确定性，为了更规范化运作，2024 年 2 月 13 日，Linux 内核社区被赋予了 CVE 编号管理机构(CNA)的角色，负责定期为 Linux 内核的漏洞分配 CVE 号并发布。

当前，Linux 内核社区针对 CVE 的分配和发布已形成了一套新的运作流程：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBBr4P6zv2xbyQt8VMXea0Vl29ygAfTRu3AicOtHlLP1wicH53czxTwaKNrGI9ia6sppZ8dpDtgNeeibg/640?wx_fmt=png)

关于内核 CVE 的更多详情，可参考社区文档\[5]。

在新的运作机制下，Linux 内核的漏洞分析更加专业化，**漏洞识别率高，且不会出现 0day** 漏洞。但同时 CVE 漏洞数量激增，预计 2024 年全年将超过 4000 个，相较往年增长 10 倍以上，这也为 openEuler 内核的维护带来了挑战。

## openEuler 内核核心贡献者加入 Linux 社区 CVE 检视团队

openEuler 是国内最大的开源 OS 社区，遵从开源软件项目及其社区在信息安全方面所应承担的义务要求，作为 Linux 根社区的重要贡献组织，一直积极参与 Linux 内核社区的 CVE 计划，更好地推动和完善 openEuler 社区在信息安全领域\[6]的规范建设。

2024 年 8 月 23 日在香港组织的“Linux Kernel Maintainer Meetup with Linus and Greg”活动上，在华为任职并在 openEuler 社区担任 Kernel SIG Maintainer 的郭寒军，跟 Linus 和 Greg 谈论起内核 CVE 数量激增的事情，Greg 表示目前 Linux 内核的 CVE 会按照现有机制持续，数量预计不会降低，并鉴于华为一直在 Linux 内核有持续高质量的贡献，提议让华为参与到 Linux 内核的 CVE 的检视当中，为 Linux 内核的 CVE 计划做贡献。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBBr4P6zv2xbyQt8VMXea0Vcz9UcgVTxqxboqYefH2UWJGwGgTMLPTiazL6FrTS0sJLrlHuPwT4YuQ/640?wx_fmt=png)

**Linux Kernel Maintainer Meetup with Linus and Greg**

于是，从 linux 6.10.7 开始，openEuler 社区 Kernel SIG 中三位自华为的核心贡献者龚睿奇、章昌仲和郭寒军加入到 Linux 内核社区的 CVE 审视工作中，成为社区 CVE 检视“五人团”（分别来自 Linux Foundation，Nvidia，Google，Microsoft，Huawei）中的一员\[7]。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBBr4P6zv2xbyQt8VMXea0VZ7sgOPu1V0gksDfEZ8KFAUJV3l8mfMR58OAIsMRB2B2RDyIXGHiaSAA/640?wx_fmt=png)

**Linux 内核社区 CVE 检视团队**

在 stable 分支有新版本发布时，将共同审视新版本中的各个补丁，形成一份 CVE 候选补丁列表，随后发送给社区 CVE 团队。社区 CVE 团队在收到所有成员的审视结果后，将会结合这些意见形成一份最终的 CVE 补丁列表，并对其中的补丁完成 CVE 编号分配和发布工作。**Greg对华为参与 CVE的检视工作也给予了高度认可，不仅帮忙确认了 CVE 候选补丁，还帮忙识别出了其他检视成员没有检视出的 CVE补丁。**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBBr4P6zv2xbyQt8VMXea0VJmqxaTSB2tv6CgEjjyr4EoobU6WBQmQvmaztzy0UE5kCRiaWxVeU07w/640?wx_fmt=png)

openEuler 的核心贡献者成为 Linux 内核社区的 CVE 检视成员，将进一步巩固和提升 openEuler 在漏洞响应和安全方面的能力。参与 Linux 社区 CVE 检视，一方面将从源头上参与提高 CVE 识别质量，另一方面将随时感知 CVE 信息，大大提升 openEuler 社区在高危漏洞上的响应能力。

- \[1]http://www.kroah.com/log/blog/2024/02/13/linux-is-a-cna/
- \[2]https://www.cve.org/About/Overview
- \[3]https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
- \[4]https://lore.kernel.org/linux-cve-announce/
- \[5]https://docs.kernel.org/process/cve.html
- \[6]https://linuxfoundation.eu/cyber-resilience-act
- \[7]https://git.kernel.org/pub/scm/linux/security/vulns.git/log/cve
