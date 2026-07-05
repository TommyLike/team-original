# [树莓派 + openEuler + OpenStack碰撞出不一样的火花](https://mp.weixin.qq.com/s/NgjwQPGuJIk9YbhmlnJXuQ)

*郑振宇*[OpenAtom openEuler](javascript:void%280%29;)*2020-10-28 19:02:31*

![](https://mmbiz.qpic.cn/mmbiz_png/uibibeLNgibX2HVRicE5ML3kzZQAp2r2YSkIicu42TKXLVn037oBzZSW2ErZiakzyBNiaCKG756l7icohcxxhHL7uib5GWg/640?wx_fmt=png)

      第十一届中国开源黑客松近日在长沙成功闭幕，来自30家不同公司的118位开源工程师进行了为期三天的黑客松活动。黑客松为开源开发者搭建了以码会友的交流沟通平台，通过特性实现、缺陷修复、技术分享等方式，推动开源技术、开源文化在中国的发展。

     活动自开办以来，始终坚持“开发代码，开放设计，开放开发，开放社区”的开源理念，用实际行动鼓励开发者技术创新和创意实践。本次开源黑客松覆盖了OpenStack、Kubernetes、Hadoop、Ceph、openEuler、openGauss、openLooKeng、Mindspore、KubeEdge、SODA、Kata、Ceph等十余个开源社区。

![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2EJicsq55DgjFGKFtp9PbV0jTSfI730JJ5alMiasCXvU2QXmmUWQIThaGF33kwbY3iawbLdmWhqgtkzw/640?wx_fmt=jpeg)

大会合影

* * *

      

**树莓派 + openEuler + OpenStack 技术项目**

      笔者也参与了本届开源黑客松，与来自**华为、Linaro、中南大学、湖南大学**的开源开发者一起，在三天时间内完成了《OpenStack in a Box》的技术项目，在树莓派4B(基于Arm64架构)硬件平台上安装了openEuler 20.09操作系统，并通过适配DevStack部署工具，完成了OpenStack 主干版本All-In-One的一键式部署，本文将为大家分享其中的技术细节。      

      首先为各位简单介绍下本技术项目中用到的几款软硬件：

![](https://mmbiz.qpic.cn/mmbiz_png/uibibeLNgibX2EJicsq55DgjFGKFtp9PbV0j6dTTs2w2Lsxql1A2XEfqOrJXs1uczd8ViaswZpv150dOibnEGNria9XKg/640?wx_fmt=png)

Raspberry Pi 4B

      **树莓派**(Raspberry Pi)是一款最初为学习计算机编程教育而设计的只有信用卡大小的微型电脑，随着CPU能力的不断提升，其功能已经远远超过了教育的范畴。其CPU采用Arm架构，可以运行主流的Linux操作系统以及Windows 10 IoT。

      树莓派自问世以来，受众多计算机发烧友和创客的追捧，曾经一“派”难求。别看其外表“娇小”，内“心”却很强大，视频、音频等功能通通皆有，可谓是“麻雀虽小，五脏俱全”。我们此次便采用了最新发布的Raspberry Pi 4B顶配版本，它拥有基于Cortex-A72的4颗1.5GHz CPU，8GB内存，小小身材内的能量十分惊人！

![](https://mmbiz.qpic.cn/mmbiz_png/uibibeLNgibX2EJicsq55DgjFGKFtp9PbV0jibmX0jIrq8OHhTP0JyAicLDDTs41vRpw5DByT0vJzHVlSn2TWTxBJpbw/640?wx_fmt=png)

     **openEuler**(https://openeuler.org/)是一个开源免费的Linux发行版系统，通过开放的社区形式与全球的开发者共同构建一个开放、多元和架构包容的软件生态体系，openEuler同时是一个创新的系统，倡导客户在系统上提出创新想法、开拓新思路、实践新方案。

      继今年 3 月发布 20.03 LTS 版本后，openEuler 社区在 9 月 30 日再次发布了openEuler 20.09，添加了众多优秀特性，修复了若干已知问题，本次黑客松活动中我们就选择了openEuler 20.09版本进行相应的开发。

![](https://mmbiz.qpic.cn/mmbiz_png/uibibeLNgibX2EJicsq55DgjFGKFtp9PbV0j9DGLm36RNkSH3icrOxg2p62eVqIMm2WN4jA7T9jyIjx2dibQQq0j0Arg/640?wx_fmt=png)

      **OpenStack**相信大家都已经比较熟悉了，是目前最火的开源云计算平台。它刚刚发布了第22个正式版本 ‘Victoria’，并且刚刚度过自己的十岁生日。OpenStack对于国内开源文化的推动是十分重要的，中国开源黑客松就脱胎于OpenStack黑客松。OpenStack在国内仍有众多活跃开发者，在本次活动中仍有超过50位开发者参与到与OpenStack相关的开发工作中。

       **DevStack**是OpenStack社区提供的一套部署工具，可以基于当前主干版本或指定版本快速的部署起全套的OpenStack服务，被OpenStack开发者广泛应用于OpenStack代码开发，同时也是OpenStack各个子项目测试系统中所使用的部署工具。

* * *

      经过三天的开发调试，小组成员成功完成了DevStack部署工具在openEuler上的适配，以及若干OpenStack在openEuler 20.09上运行的相关Bug的修复。实现了OpenStack在openEuler 20.09系统 + 树莓派(ARM64架构)上的一键安装部署，并对OpenStack的基础功能进行了验证。

       OpenStack + openEuler + Raspberry Pi 技术项目的成功完成，**体现了openEuler系统、ARM硬件对主流开源虚拟化/云计算技术的完整支持，为后续OpenStack社区引入基于openEuler + ARM 的集成验证提供了原型验证，扫清了技术障碍。同时，由于Raspberry Pi是业界常用的边缘计算原型验证硬件，本项目也从侧面反映了openEuler在边缘计算场景中应用的可能性。**

       完成适配的DevStack脚本已在Kunpeng Compute Github 代码仓库中开源(https://github.com/kunpengcompute/devstack/pulls)，感兴趣的开发者可以下载体验。

        下面为各位读者简单展示该项目的成果：

        1. 查看操作系统、硬件相关信息，执行DevStack部署脚本：

![](https://mmbiz.qpic.cn/mmbiz_gif/uibibeLNgibX2ERlHibTwE2euyP4CnIImUUhFIFzZHPvflksXUlzszFeD7EOgAsZrfXm3iclBvyDlrjBeaWKZZ6ibP3g/640?wx_fmt=gif)

查看系统信息并执行DevStack脚本

      2. DevStack部署完成后，OpenStack就可以直接使用了，首先使用OpenStack Client命令查看各服务的运行情况，获取创建虚拟机所需的相关资源：

![](https://mmbiz.qpic.cn/mmbiz_gif/uibibeLNgibX2ERlHibTwE2euyP4CnIImUUhn1b6g1iaabcJicTsy3Wdb2IoOtMibEovzWjYuJfpBEmpvhC1S3fiaKKT4A/640?wx_fmt=gif)

使用OpenStack Client命令获取创建虚拟机相关资源

      3. 使用查询到的资源创建虚拟机，并循环检查到虚拟机状态变为ACTIVE为止：

![](https://mmbiz.qpic.cn/mmbiz_gif/uibibeLNgibX2ERlHibTwE2euyP4CnIImUUhYr1PGvgJnDXzdmrZxcoMbbm5yu3SiadKbOAwqxf4wRnFibibSpqBwlKGQ/640?wx_fmt=gif)

创建虚拟机并观察状态变化

      后续我们将把本次黑客松所做的适配修复向OpenStack devstack社区进行提交，并联合Linaro推动OpenStack社区引入openEuler ARM 部署CI。使得更多的开发者和用户受益。

* * *

**现场掠影**

![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2ERlHibTwE2euyP4CnIImUUhUSZF71uQFibUohjEDWUXmolKanRObk4eNLAKak0xzibuZuN2jg9jg8icQ/640?wx_fmt=jpeg)

来自华为与高校的开发者

![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2ERlHibTwE2euyP4CnIImUUhaZUZxIicDXctoK6GUiavdnkcJf3uzib34Z40d5P6kZFgEoCSG4308WfOg/640?wx_fmt=jpeg)

来自Linaro的开发者

![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2ERlHibTwE2euyP4CnIImUUhMxDuVHDAzm87xl7dmBYeiaPawyiaPib30HkicmUcj54Qz5icuQUeicY0fVLA/640?wx_fmt=jpeg)

成果展示

      在文章的最后要感谢中国开源黑客松的组织者和志愿者，祝愿黑客松活动越办越好，继续为国内开源社区开发者提供开源、开放、创新的交流平台。
