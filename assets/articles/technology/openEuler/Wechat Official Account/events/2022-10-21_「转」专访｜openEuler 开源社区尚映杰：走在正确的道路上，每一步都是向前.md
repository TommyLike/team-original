# [「转」专访｜openEuler 开源社区尚映杰：走在正确的道路上，每一步都是向前](https://mp.weixin.qq.com/s/8pKNFSSqhuRox4v6ted8kw)

*ospp*[OpenAtom openEuler](javascript:void%280%29;)*2022-10-21 18:00:00*

![](https://mmbiz.qpic.cn/mmbiz_png/d7cX574lCK2b4BooqvIo8icutstBRndnIC8JhvZDYYVU8nmibZ6c76ULMCeNWHc5iaDG3HdRRMaqk3iahdFth2gfCg/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

![](https://mmbiz.qpic.cn/mmbiz_png/d7cX574lCK00AtvN9iaqckicqcpcnTdco7XsvhoicQDGjgpoVFQwKP91SpwlicKhzZeZCs2mzpFDsfkIcTaPaQ87Vg/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

17

**人物专栏**

![](https://mmbiz.qpic.cn/mmbiz_png/d7cX574lCK2b4BooqvIo8icutstBRndnIic9dDbpwP51ibSNRGBmHNw1d9JNtp4T5WDFB2bVhhakHlyhYbFKf5feg/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

开源之夏人物专访专栏持续开放中，本专栏将继续为大家带来开源之夏参与者的系列分享。欢迎已从开源之夏毕业或正在参与开源之夏的学生、导师一起加入专栏行动，另外项目经验分享专栏也在进行中，有兴趣的小伙伴请联系开源小助手：kaiyuanzhixia 或小编姐姐：damengshiye（备注“专栏投稿”加速通过） 

![](https://mmbiz.qpic.cn/mmbiz_png/d7cX574lCK3DBrEia2dCEKiaRwmt6sCVmgcFSwC3GLkCILs52Hz1M5ksRaDwggmRiaT1Iicbnfa85KecWScVuSPoOw/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

本期参与人物采访专栏的是来自 openEuler 社区的尚映杰同学，承担项目任务：openEuler 社区【实现A-Tune服务解耦】。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZOzO95JbibjgLOYkicp71dGnaoXPWvjicj3F8cbMsBxCI2FpibyyN4zRVOCQOj15qeDXGCeeCFYesqxQ/640?wx_fmt=jpeg)

![](https://mmbiz.qpic.cn/mmbiz_png/d7cX574lCK1ibl7qCF6uCdcTE5fCtt2lG50xwrzX0FR2tOk1Zpt8hIAYlEKicGGTcAc2qpRN3F5NcJfiaOhfNU4Ew/640?wx_fmt=png)

**自我介绍**

**我与开源**

**OSPP：**请简单介绍一下自己以及自己的开源经历吧。

**尚映杰：**我叫尚映杰，Gitee :shangyingjie，内蒙古师范大学大四学生，专业是网络安全，但后来发现自己对开发更感兴趣。

我在大二的时候报名参加了开源之夏，也正是从那个时候开始对开源产生了兴趣。头一年参赛，因为没有抓住重点且盲目自信，突发奇想试图对系统上一个存在了很久的功能做出改进，浪费了很多时间，最终的成果没有通过审核。但是有了这次的经验，我学会了在项目中规划时间，把握重点，与导师保持联系，确保自己一直走在正确的路线上。

第二年再战开源之夏的时候，我听取上一届导师的建议，选择了内核相关的任务。“因为比较难，选的人比较少，容易中选”笑。吸取了上一次的经验和教训，这一次项目中我紧抓项目重点，时刻确定现在走的方向能够在预期的时间中抵达终点。

今年参加开源实习和第三届开源之夏的时候，已经是游刃有余了。

**OSPP：**为什么会选择积极参与开源，开源对你来说意味着什么又为你带来了什么？

**尚映杰：**我觉得开源是一件很酷的事情，参与开源让我拥有满满的成就感。开源对于我来说意味着宝贵的锻炼机会和广阔的平台。通过参与开源，我学到了书本外的知识，在实战中积累了经验，开阔了自己的眼界，结识了优秀的同学和可爱的导师以及勤劳的幕后工作人员，还收获了噌噌上涨的奖金。

**OSPP：**可以和大家分享一下你最喜欢的编程语言或开源项目么吗？

**尚映杰：**我最喜欢的编程语言是 Python，它是我参加开源以来使用的最多的编程语言。它的优雅让我沉醉。

![](https://mmbiz.qpic.cn/mmbiz_png/d7cX574lCK1ibl7qCF6uCdcTE5fCtt2lG6MPHGiaud7DnjC1oibxuRA6U71EduInPnqxWEm8EyACtfWbqDpYPyF9g/640?wx_fmt=png)

**参与开源之夏**

**项目任务与进展**

**问题与收获**

**OSPP：**你在2020年就参与过开源之夏，当时为什么选择参加活动？在活动中都参与了哪些项目？

**尚映杰：**当时面临暑假，我想在假期里学更多的知识，让自己的技术水平上升一个级别。于是当我得知了开源之夏，便积极的报了名。

第一年参赛的项目是做一个提醒用于更新软件的工具，但是因为缺少经验，导致路线偏离，没有很好的达成最终目标。我吸取了教训，积累了宝贵的经验，掌握了高效学习的方法。社区给我的这次机会激发了我对开源的兴趣，让我产生持续对社区贡献的意愿。

第二年的项目是【内核踩内存问题定位辅助驱动】，有了之前的经验，这次完成的比较顺利。我学到了 Linux 内核测试的相关知识：编译内核、制作根文件系统、模拟内核运行等，以及使用 Git 制作移植补丁的方法和处理冲突的技巧。我将产出以邮件的方式发给了社区。

https://summer-ospp.ac.cn/2021/#/org/prodetail/210010057

![](https://mmbiz.qpic.cn/mmbiz_png/d7cX574lCK1ibl7qCF6uCdcTE5fCtt2lGzvsnicqxxrCNdemtqIO1Eh2T3kqasqZ3j3OTSfrq0b1kYicc0ekvic8JQ/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/d7cX574lCK1ibl7qCF6uCdcTE5fCtt2lGUdY68M6VMbj3fLERfzD7ZjoXqM5Ij83BFsqUkx3E3bJWDoZicmGNZxA/640?wx_fmt=png)

2021开源之夏的项目，成功部署到物理机上

今年中选的项目是【实现 A-Tune 服务解耦】。

https://summer-ospp.ac.cn/#/org/prodetail/22b970381

![](https://mmbiz.qpic.cn/mmbiz_png/d7cX574lCK1ibl7qCF6uCdcTE5fCtt2lGhuafBdDIPicmYPoKk0O82OoS0rhVJZD9TMOWOb5pS7kxJAmiabVK4Q7Q/640?wx_fmt=png)

> A-Tune 是一款基于 AI 的操作系统性能调优引擎。A-Tune 利用 AI 技术，使操作系统“懂”业务，简化 IT 系统调优工作的同时，让应用程序发挥出色性能。

解耦的基础是理解耦合产生的原因，这就需要对 A-Tune 的架构有一定的了解，为此我学习了 Go 语言的相关知识和 Python 的 Flask 框架。在解耦时，我将原来耦合的地方解开，使其不再相互依赖，并将对应的程序制作成 Linux 服务，使之能够通过  systemctl start 单独启动运行。目前，我的成果已通过 PR 的形式提交。

**OSPP：**第三次参与开源之夏有什么不一样的体验和感受？活动让你对开源有什么新的理解？

**尚映杰：**这次参与开源之夏，接触的是全新的任务类型，我快速学习并熟悉了一个有陌生语言+熟悉语言构成的开源项目，并对其进行了解耦。在熟悉 A-Tune 的过程中其设计之巧妙让我深深的感到震撼，不同的组件以近乎自然的方式组装在了一起，构筑了一个强大的性能调优工具。

在开源的世界里，我能读到优秀项目的源代码，学习到精彩的设计和最佳实践，体会到记载于书本中的源自先辈对于软件设计的箴言。

![](https://mmbiz.qpic.cn/mmbiz_png/d7cX574lCK1ibl7qCF6uCdcTE5fCtt2lGqrukJfJYr8iaa7MIT69xafyE3KP9eBcbDlYQ6t0J0j9SS32oeJFxwXw/640?wx_fmt=png)

**社区成长经历**

**openEuler 社区**

**项目开发**

**OSPP：**请简单介绍一下目前所在的 openEuler 社区

**尚映杰：**openEuler 社区是非常活跃的开源社区，且已达到了同类社区的国际水准，已经发展成为世界上该领域很有影响的社区。openEuler 社区拥有数十个 SIG 组，涉及诸多技术领域。

> 欧拉开源操作系统（openEuler, 简称“欧拉”）是面向数字基础设施的操作系统，支持服务器、 云计算、边缘计算、嵌入式等应用场景，支持多样性计算，致力于提供安全、稳定、易用的操作系统。通过为应用提供确定性保障能力，支持 OT 领域应用及 OT 与 ICT 的融合。欧拉开源社区通过开放的社区形式与全球的开发者共同构建一个开放、多元和架构包容的软件生态体系，孵化支持多种处理器架构、覆盖数字设施全场景，推动企业数字基础设施软硬件、应用生态繁荣发展。

**官网：**https://openeuler.org/

**OSPP：**请介绍一下你在本次开源之夏参与的项目，在项目进行中遇到的印象最深刻的困难是什么？如何解决的？有什么收获吗？

**尚映杰：**我本次在开源之夏参与的项目是【实现 A-Tune 服务解耦】，需要了解 A-Tune 的架构，明白耦合产生的原因，继而找到解耦的方法。

项目中遇到的最深刻的困难是读不懂源代码，有两方面的原因，一是刚刚学习和接触 Go 语言，二是对 A-Tune 的架构不了解。

在尝试了一段时间后，我向导师请教了这个问题，导师为我梳理了 A-Tune 架构中的几个关键部分，并指出我应关注的点。

同时有了对整体和部分的印象，再去阅读源码就豁然开朗了。通过解决这个问题，我掌握了阅读开源软件项目的方法，就是要从不同的角度对其进行认识。

**OSPP：**活动期间，社区和导师给予了你怎样的帮助？

**尚映杰：**活动期间，社区会定期进行监督，提醒剩余的时间，询问我们是否需要帮助，联系导师等。导师为我确定了正确的努力方向，在我遇到问题的时候为我答疑解惑。

**OSPP：**结项后是否打算继续参与项目的开发和维护呢？对自己日后在社区的发展有怎样的规划？

**尚映杰：**通过这次的活动，我对 A-Tune 有了更加深入的了解，打算继续参与项目的开发和维护。除了在一个 SIG 组内持续参与，我还希望能够更多的参与到不同的 SIG 组去。

![](https://mmbiz.qpic.cn/mmbiz_png/d7cX574lCK1ibl7qCF6uCdcTE5fCtt2lGTRP1W1RxvuCUAGE0ox8u4ibYDoJTdqicAekuTibiafDkcLv9UFv08NjL1g/640?wx_fmt=png)

**收获与寄语**

**开源与安全**

**自我提升与融入社区**

**经验与建议**

**OSPP：**作为网络安全专业的学生，你认为开源与安全是相冲突的么？

**尚映杰：**我认为开源与安全并不冲突，世界上不存在绝对的安全。开源是一扇门，发现漏洞和修补漏洞的开发者可以从这里走进来，帮助你修补软件中的安全问题。

**OSPP：**作为在校生，你认为怎样才能更快更好的融入社区？

**尚映杰：**作为在校生，我觉得首先要学好课内的知识，在课余时间，特别是假期的时候多参与开源项目和活动，例如：开源之夏。

**OSPP：**你认为参与开源之夏、社区贡献对于在校生的学习专业提升和就业选择有哪些帮助？

**尚映杰：**开源之夏为学生提供了宝贵的锻炼机会和实战项目，社区贡献更是对学生能力的认可。

通过参与开源项目学生能够提升自己的专业能力，认识到自己感兴趣和擅长的方向，在择业时便会有清晰的目标。

**OSPP：**在学校学习的知识能支持你完成这些项目吗？除了在校学习，你还通过什么方式充电？

**尚映杰：**单从校内学习的内容来看，有一些和任务有重叠，但是我认为在校内主要是培养学习能力和基础能力，到了做这些项目的时候依靠培养的学习能力快速学习和上手。在学习新技术时，我一般会看官方的文档，也会看他人写的技术博客，少数时候会看技术视频。

**OSPP：**为参与开源之夏的学弟学妹提供一些经验与建议吧

**尚映杰：**我想对参加开源之夏的学弟学妹们说，一定要认识到，参与开源、完成项目并不简单，但只要你能够持续的在正确的道路上持续努力，肯定会有所收获的！

**END**

专栏编辑：大梦

校对：校大山、尚映杰

制图：GoodWhite
