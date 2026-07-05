# [「转」人物｜王经纬：步履不停，引领 openEuler 成为 RISC-V 全球领先发行版](https://mp.weixin.qq.com/s/H-C748FF7nQujkfkJv8MGw)

*张宇溪*[OpenAtom openEuler](javascript:void%280%29;)*2023-11-22 17:30:00*

openEuler RISC-V 23.09 是 openEuler RISC-V SIG 将 RISC-V 合入 openEuler 官方架构的一个项目。在此之前，RISC-V SIG 已经随 openEuler 主线发版，完成了多个版本多种镜像的 RISC-V 发行版构建工作，随着构建镜像逐渐成熟，发行版软件环境逐渐多样化且稳定，RISC-V SIG 认为，openEuler 官方支持 RISC-V 架构的时机已经成熟。

openEuler RISC-V 23.09 版本的主线集成工作，包括主线代码集成，基础设施集成，构建 CI 与发布路径集成等工作，使得 RISC-V 从软件包构建、测试验证，再到最终的镜像源生成，完全融入 openEuler 官方流程，成为官方一级支持架构之一。23.09 版本的目标则是打通“官方化”的路径，为 24.03 版本 openEuler 完整支持 RISC-V 进行铺垫，以最终使 openEuler 成为国内先进的支持 RISC-V 架构的发行版。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/8ibUD526lM5reicP1ouAMC3rN59Dibkx7JzEwUWTQAYUYeK4LDyyyvV3czAPbtQ0l0I98bfB45QSTpgugLib1oBPDQ/640?wx_fmt=jpeg&from=appmsg)

王经纬是 openEuler RISC-V 23.09 的出品人。担任 openEuler RISC-V SIG 与 QT SIG maintainer，致力于 RISC-V 发行版维护和优化。身为跨专业码农、远程工作实践者以及一个旅游爱好者。

**从技术到项目管理的多维发展**

最初，王经纬从一个开发者的角色开始，他熟知了 openEuler 系统的各个环节，包括构建和发布。随着在技术上的深入了解，王经纬开始系统性地思考整个 openEuler RISC-V 的架构和方向，并参与到方向性设计中。从王经纬开始负责管理 23.09 项目那一刻起，他明白了不能仅从技术的角度看待问题，而是要从更宏观的角度理解到这是一个系统性工程，因为它融合了领导、架构、协作和技术等多个维度。“直观感受是，不能再以纯技术的角度思考问题，需要重视与人之间的交流合作对项目的深刻影响，同时一个项目的完成需要考虑多个方面的元素进行取舍，要灵活思考问题。因此，沟通与项目管理能力是必须要增加的。”

这段经历加深了王经纬对完成一个实际项目的理解，于是他选择成为了 PM。在推动完成 RISC-V 23.09 主线化项目之外，他还设计参与 QT6 三架构初始化与验证以及长期维护 RISC-V 下的 FireFox、Chromium、Thunderbird 等软件。作为项目沟通人，他还需要完善 openEuler 社区对 RISC-V 各个层面的支撑，代表 openEuler RISC-V 参加各种公开技术演讲报告。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/8ibUD526lM5reicP1ouAMC3rN59Dibkx7JzMxzXuSXQCsff3suibSfaZYJeVubvTrEGgBfDeWSTEfruVWpvSic1wZrg/640?wx_fmt=jpeg&from=appmsg)

王经纬在2023 RISC-V中国峰会同期活动中介绍openEuler RISC-V进展

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/8ibUD526lM5reicP1ouAMC3rN59Dibkx7JzhRf9OyuR47gaDg00j0YYqP2VjqVNUZ0lWbkMDibDMLQgticPCLP1jAIw/640?wx_fmt=jpeg&from=appmsg)

王经纬参加 openEuler 开发者大会

**多方优势成就 openEuler RISC-V**

与其他在 RISC-V 领域进行尝试的操作系统发行版相比，openEuler RISC-V 23.09 依托 openEuler 操作系统，拥有安全可控的系统底座。背靠在中国科学院软件研究所 PLCT 实验室，可以率先体验多种先进的技术成果，比如 V8/SpiderMonkey 还有 LuaJIT 等。目前版本合入以 QEMU 为主，用户可以在最小化的图形环境内，体验中国科学院软件研究所所对 mesa、LLVMpipe 等图形化优化工作。以及与国内 RISC-V CPU 相关厂商关系密切，有更为可靠的硬件支持能力。

团队在实现项目过程中积极响应和解决问题的能力也有尤为重要。王经纬回忆了一次团队经历：“openEuler 官方的镜像生成有专用的生成工具和规范的脚本，这些工具都没有对 riscv64 架构进行适配，而脚本也难以获得真实环境的权限进行测试。我们团队的工程师克服困难，为 imageTailor 等镜像制作工具适配了 RISC-V 架构支持，并且与 openEuler 工程组一对一合作，成功完成了相应脚本的制作。”

RISC-V以其独特的灵活性和自由性正展现出从 IoT 到 HPC 各领域的巨大潜力。在这样的大背景下，openEuler RISC-V 特别重视RISC-V 发行版对于国产化 CPU 的软件赋能和定制服务。随着国产化进程的加速，RISC-V 有望在国产化供应链中扮演至关重要的角色。openEuler RISC-V 是如何利用 RISC-V 架构的优势来实现项目目标的？王经纬对此提出了他的看法：“对于一个发行版，openEuler RISCV的优势体现在其高度的开放性和自主性。当前，众多国内 CPU 厂商正积极打造 RISC-V 生态。在实际应用的驱动下，openEuler RISC-V 23.09 受到了 openEuler 官方与社区伙伴的期待与支持，从而加快了开发进程。此外，RISC-V 架构在开源软件领域也受到广泛的关注。以 PLCT 实验室为代表的技术团队为 RISC-V 生态投入了大量的代码贡献。开放的合作策略也促进了我们与一些知名发行版的交流与合作，确保了 openEuler RISC-V 23.09 的顺利推进。”

**openEuler RISC-V社区：协作创新，涌现新星**

在 openEuler RISC-V 社区，maintainer 机制是一种高效的协作和贡献的模式。重要决策由 maintainer 集体表决，每个 maintainer 负责不同的模块，既有分工又有合作，通过集思广益得到对社区发展更有利的方案。同时，新加入的 contributor 也可以获得自己感兴趣的方向 maintainer 的指导。王经纬作为 openEuler RISC-V 社区的 maintainer 积极参与其中，并凭借他的技术能力和卓越贡献获得社区成员的尊重和认可。他与所有 maintainer 和 contributor 一起通过实际行动推动社区的发展和决策，打造了一个充满活力和创新的开放技术社区。

在 openEuler RISC-V 社区中，协作共创的精神不断激发着成员们对技术的热情和追求，使得社区持续繁荣，包容了各类技术爱好者。尤其是实习生团队中涌现了一批潜力无限的年轻人，王经纬兴奋地表示：“我们至少有三名实习生基于 openEuler 衍生了自己的 RISC-V 发行版，其中一个名为 Eulaceura 的发行版已被 openEuler 官方报道。同时也有各个公司杰出的工程师加入到了 RISC-V SIG 中进行开源贡献，他们为 openEuler RISC-V 做出了许多游戏移植和教学课程的工作。”

openEuler RISC-V的相关信息都会在主仓库（https://gitee.com/openeuler/RISC-V）中展示。

对于参与 openEuler RISC-V 项目感兴趣并希望贡献的伙伴，王经纬建议可以先从 issue 入手，并且尽快联系 maintainer，他们会给予指导与支持。

从开源软件的角度，中国科学院软件研究所在推广以及学习方面做出了积极的尝试与努力，openEuler RISC-V 团队也积极参与其中。感兴趣的伙伴可以关注 bilibili 账号“lazyparser”，和 github 组织账号“plctlab”，探索更多的开源经验分享内容，并有开源实习和就职机会等待大家加入。
