# [「转」成立一年，openEuler为开源带来哪些改变](https://mp.weixin.qq.com/s/eLgk16Bw7vxxdNqE_-LH-A)

*宋慧*[OpenAtom openEuler](javascript:void%280%29;)*2020-12-28 21:30:00*

![](https://mmbiz.qpic.cn/mmbiz_png/Pn4Sm0RsAuiaPn8q2TmsZwA4RUjpMdPTZoiacUnwnUprNqRzZUbERxh4B2XDqlnQvJxNUawCL1unBbWDxG7z8cRA/640?wx_fmt=png)

作者 | 宋慧

出品 | CSDN（ID：CSDNnews）

openEuler 从开源到现在已经要满一周岁了。在一周年之际，openEuler 社区举办了年度技术峰会 openEuler summit 2020，社区贡献者（contributor）和开发者、生态内的商业技术厂商、最终用户汇聚一堂，切磋技术和交流开源。

在峰会上，openEuler 开源社区举行了技术委员会换届仪式，还为社区优秀的开发者们颁发了年度奖项；来自银行、运营商等最终用户分享了对 openEuler 和软硬件技术创新实践的经验；还有实战部署演示基于 openEuler 操作系统的全栈 demo 秀，部署涵盖了硬件、云与容器、存储、数据库、分析监控等各方面，分别是树莓派、OpenStack、kubernetes、Ceph、hadoop、openGause、MariaDB、openLookeng、Prometheus、NGINX，所有框架、应用运行表现堪称丝滑般简洁流畅。

![](https://mmbiz.qpic.cn/mmbiz_png/Pn4Sm0RsAuiaPn8q2TmsZwA4RUjpMdPTZ8PGmViboJq0nagn0X90ibhbYYnMLe6MiaKzZWqDqTL6aibYC8jrHJXLdkg/640?wx_fmt=png)

基于 openEuler 操作系统的现场全栈 demo 秀

openEuler“大管家”社区理事长江大勇在峰会分享了 openEuler 这一年的成绩和数据：社区已经有 2000+ 位 contributor，其中约 1500 名为代码贡献者；社区共产生了 20000 个 PR 和 73 个 SIG 兴趣组；超过 30000 发行版装机量，超过 30000 次社区版下载量；60 家厂商高校加入社区。峰会上所有的技术实战和社区“年终成绩”的背后，是国内底层操作系统和顶级开源项目 openEuler 的开发者、贡献者们的集体智慧，值得深挖和思考。

![](https://mmbiz.qpic.cn/mmbiz_png/Pn4Sm0RsAugymrbtchsKxe9kqm5BRia4F12n5oBAaelzOJDiaDPxYkOV1HoVhlC2L4SzpPtbNQB5IHVSrZIpIuicg/640?wx_fmt=png)

**从内核、框架引擎的关键节点探索创新边界**

openEuler 的前身是 Euler 操作系统，它生于华为科学实验室。2019 年，华为将 EulerOS 开源出来，命名为 openEuler。从诞生到现在，openEuler 具备着十几年技术储备的实力，且拥有技术创新的基因。

而底层操作系统软件的崛起，一定需要牢固的技术底座。我们看到，在 2020 这一年，openEuler 发布了长生命周期商业版本 20.03LTS（Long Term Support）之后，还重磅发布了 20.09 创新版本。在创新版本中，openEuler 实打实地从内核、虚拟化引擎、计算框架这些核心关键节点提升算力和性能，拳拳到肉！

![](https://mmbiz.qpic.cn/mmbiz_png/Pn4Sm0RsAuiaPn8q2TmsZwA4RUjpMdPTZ3zsBQiaqobctcEcvPcFmwjagaKffS0sibibGaaEJpUZNLUUd0W9IiaPetg/640?wx_fmt=png)

具体来说，20.09 包含了多项针对硬件架构、应用等南北向的关键子项目，例如：继 ARM、x86 之后，支持 RISC-V 新指令集架构，补足 openEuler 多样性算力的重要一环；提升内核多核扩展性，CPU 多核并行度，性能提升 20%；还有轻量级虚拟化引擎 StratoVirt、UKUI 轻量级桌面、secGear 机密计算框架、Compass CI 可持续集成平台、A-Tune 自动化调优引擎等等关键项目。openEuler 社区理事长江大勇在峰会提到了开源让技术的创新“看得见，摸得着”。2020 年的 openEuler 20.09 创新版本从其 1+8 的新特性中，能够看到更多聚合生态，面向未来的突破点，已经能够让业界看到现在国内底层系统软件开源项目的能力与决心。

openEuler 开源创新的基因也将促进商业化版本的发展，预期将在下一个可交付商用版本 21.03 中，将推出 iSula 3.0 云原生容器、面向云边端的完整 OS 方案以及继续增强机密计算框架 secGear 的功能和表现。

openEuler 能够在一年内快速迭代，离不开华为对开源软件持续投入所积累的经验。从技术内核底层来看，在 Linux 内核 5.8 版本中，华为在全球范围对 Linux 内核的贡献排名第二，修改代码量全球排名第一；5.10 版本中 patch 数贡献第一。另外，华为还为 ARM 架构打通全栈能力，贡献了全球超过 40+ 的主流开源社区。

另外，openEuler Summit 2020 峰会现场，华为鲲鹏计算业务总裁张熙伟还提到，在未来，对 openEuler 的设计和建设的投入还包括：一，聚焦内核核心技术的创新和发展；二，最大限度拥抱所有处理器，无论是 X86，无论是ARM，无论是神经网络 NPO 的处理器，充分拥抱设备；三，针对本项目的应用发挥优势，比如逐渐推出一些新的项目，轻量化虚拟机技术，包括内核新的项目等。openEuler 所具备的技术和产品的深厚实力，以及在用户真实场景下产生新的技术洞察，将会提供源源不断的创新动力和发展思路。

![](https://mmbiz.qpic.cn/mmbiz_png/Pn4Sm0RsAugymrbtchsKxe9kqm5BRia4FsSqMwsGovLqtp2RycRRamDu1vfRPiacyE0s70rrr7Xr8W0eBxgH5Prw/640?wx_fmt=png)

**共建、共享、共治的理念激发 openEuler 活力**

除了探寻技术创新的边界，开源项目想取得长远的发展，保持社区活跃度、社区治理同样重要。

openEuler 的社区活跃度在持续增高，PR 数已经达到 20000 个，是 CNCF PR 数的三分之一。Committee 会议频率也越来越频繁，从最初设置两个月一次会议，变为每月一次，甚至一周一次。社区中坚力量的 SIG 兴趣组从 24 个快速增长到了 70 多个。社区越活跃，管理也就越重要。

在中国现阶段，开源治理也许更需要群策群力，集体的智慧和力量能够使得开源社区获得更多原创技术创新来源和生态伙伴的协同。因此，openEuler 开源社区秉持“共建、共享、共治”的理念，汇聚更多伙伴，形成合力，通过理事会、技术委员会和 SIG 组构成治理架构的主体，参与厂商协调市场、商业拓展活动，构建健康有活力的开源社区。

其中社区理事会负责决策 openEuler 战略方向，市场、商业拓展合作协调，吸引更多的合作伙伴广泛参与。技术委员会负责决策社区的技术范围和技术路线，协调辅导 SIG 组的工作。现在，openEuler 社区理事会、技术委员会定期换届，而且 70% 成员是华为之外的厂商和开发者。

在 openEuler 开源之初，社区就成立了技术委员会，用技术领袖和大牛的经验帮助 openEuler 技术路径的健康发展。在峰会上，openEuler 社区技术委员会胡欣蔚提到，经过一年的发展，openEuler 社区已经成为快速集成创新的平台，让技术可以快速创新落地并成为可交付的商业版软件和应用。他认为，openEuler 社区既是技术孵化器，也将是发行版的平台。社区孵化的创新技术可以引入发行版，发行版通过用户反馈进而继续牵引被孵化的技术演进方向，“openEuler 更像是 Apache 基金会和 CentOS 的合体”，胡欣蔚说道。

openEuler 开源社区所有的社区运营理念和成绩，都源于对开源精神和文化的理解。华为云与计算开源业务总经理，也是开放原子基金基金会主席、Apache 基金会会员的堵俊平在今天 summit 峰会中表示，openEuler 回到了开源的本质和初心，传递的是开源精神以及文化的价值，在这样的精神指引下，openEuler 已经在着力建设社区的配套制度来保障开放创新，保证技术决策公开透明，还有要让用户委员会代表了广大用户的声音，让品牌宣传委员会在技术推广中可以收到多样化诉求。

![](https://mmbiz.qpic.cn/mmbiz_png/Pn4Sm0RsAugymrbtchsKxe9kqm5BRia4FxibciajMS1ibI2M4qT4Xy1kRJjQCY3xXwp7mMrhI7GPLXiaXNc1tMtUJng/640?wx_fmt=png)

**全生态繁荣将造就伟大的开源社区**

如果单讲开源技术创新，那还只能算是停留在软件技术产品层面，只有全生态的繁荣，才可能被称为伟大。openEuler 社区技术委员会主席胡欣蔚在峰会上引用了《老子》中很妙的一段话，来形容 openEuler 对生态建设的思考：“三十辐共一毂，当其无，有车之用。埏埴以为器，当其无，有器之用。凿户牖以为室，当其无，有室之用。故有之以为利，无之以为用。”（出自《老子》第十一章，感兴趣的朋友可以搜来看看。）

他认为，社区的价值是在软件版本迭代和极致特性之外，也在于生态合作伙伴和最终用户将 openEuler 部署使用在真实场景里。为了更多场景的部署，openEuler 在逐步构建丰富的技术生态。openEuler 完成了上千个行业应用软件兼容适配，验证 40 种整机服务器和 20 种板卡，并且搭建多样性算力测试平台，如用 Compass-CI 来自动化检测和持续集成。

技术创新是产业链的核心驱动力，技术创新带来商业的成功，商业成功就会反哺生态，生态就会繁荣起来。技术、商业、生态，是一个闭环的持续正循环。openEuler社区理事长江大勇从全产业链的角度提到：openEuler 作为一个生态的核心，对下连接多样性计算，让更多硬件厂商可以灵活地接入 openEuler 操作系统；对上适配行业多场景，形成统一的技术软件生态，让更多的应用能够敏捷地创新，最终“百花齐放”。

现在，处理器、操作系统、存储、大数据应用等厂商在持续加入 openEuler 社区，openEuler 还获得了巨大体量的最终用户，例如建信金融（建行旗下）、中国移动、中国银联，这些技术实力深厚的厂商与拥有亿级用户样本的最终用户，将是生态繁荣的关键。

![](https://mmbiz.qpic.cn/mmbiz_png/Pn4Sm0RsAuiaPn8q2TmsZwA4RUjpMdPTZLW2ibEsthDBlwwwdp4KpRuYSa0YibW5icudwTLKqQT2dicsfHk7ibqUgXcw/640?wx_fmt=png)

使能合作伙伴，技术与产业全生态繁荣

同时，社区的繁荣也离不开人才。现实的情况是中国的开发者多是关注上层应用的开发和技术，而底层操作系统和内核开发者数量严重不足。高校是人才的根据地，作为 openEuler 创始企业的华为在 2020 年与教育部签订战略合作，启动“智能基座”产教融合合作项目，现在有 20 多所高校开设了鲲鹏和昇腾相关的技术课程，未来三年的目标是覆盖 2600 所高专学校，将为中国操作系统提供源源不断的人才供给。

![](https://mmbiz.qpic.cn/mmbiz_png/Pn4Sm0RsAugymrbtchsKxe9kqm5BRia4FnPFGCY9DcACrdNu365Se7nG4IAh1iciaicn4cOEV1zrY2wpmR2liaTgibhQ/640?wx_fmt=png)

**talk is cheap，一起成就中国系统软件**

最后，我在 openEuler summit 峰会全天现场感受最深的一点，是现场开发者强烈的使命感和情怀。在峰会上，几乎每一位演讲者都在提及和思考一个终极问题：openEuler如何成为IT历史上具有全球影响力的开源软件。

国家强大，中国开发者力量也在崛起，中国IT人早已不满足使用技术，更要成为底层技术的创新者。通过一行行代码，创造对世界甚至人类未来发展产生最深远影响的技术与产品，才是所有中国技术人所追求的目标，也是让程序员最“爽”的事情。而开源汇聚了最优秀的技术人，一个技术、生态、商业形成完美闭环的开源社区，将帮助开发者走的更远，离目标更近一步。

不过就像 Linux 之父 Linus 所说，talk is cheap，现在，一周岁的 openEuler 已经开始 show the “result” 了，openEuler 对于技术创新、商业模式的探索还将继续。
