# [openEuler 应用迁移大赛决赛队伍 ｜ 麒麟软件有限公司](https://mp.weixin.qq.com/s/YBNkgtXv98zgL4VqjzEkUw)

*麒麟软件*[OpenAtom openEuler](javascript:void%280%29;)*2020-09-08 22:30:00*

各位评委、各位 openEuler 社区的爱好者，我是麒麟软件开源社区团队的侯健。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMb4heXdqVc7ESHnhcZ6L9ic1pGLyu6utz0PKnm5wV4T9xBrayO0Q5CL1kTe5ib81msyhKxhApkTsHdA/640?wx_fmt=jpeg)

麒麟软件一直致力于开源社区的建设和维护，2019 年 12 月 31 日，openEuler 开源社区上线之时，麒麟软件便已参与筹建和维护。目前，麒麟软件维护着 openEuler 社区近 200 多个代码包项目，参与贡献的代码项目 17 个，涉及到桌面、云原生、分布式存储、AI、大数据和高可用等多个领域，并成立了 HA SIG、oVirt SIG、UKUI SIG 和 OKD SIG。由麒麟软件贡献并维护的 UKUI-3.0，已经加入 openEuler-20.09 版本的合入计划，现在正在进行相关测试和验证，会跟随 openEuler-20.09 版本一起正式发布。麒麟软件贡献的代码项目主要以 SIG 组为载体，主要项目列表如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMb4heXdqVc7ESHnhcZ6L9ic1ws7vU2jNiaHFpicbDtG6z7CJan5YOicHzelhe9klbR9mWQXDNkE2K8F9g/640?wx_fmt=png)

作为 openEuler 社区的最大的贡献者之一，在 2020 年 openEuler 设计峰会上，麒麟软件主持了多场技术分享；麒麟软件一直被邀请参加 openEuler TC Meetup，参与技术选型的讨论，下面是参加活动的截图:

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMb4heXdqVc7ESHnhcZ6L9ic1MODibGYgpNGXaeTOrrQhFt2xSQwguyBsgI5snEkg5zN2yg8CVRCspGg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMb4heXdqVc7ESHnhcZ6L9ic1dZAUIhkSTVaBFh2gj0AvqSoiaDBDuibrYPK6wlNnjHOBmbluJlR6G43A/640?wx_fmt=png)

麒麟软件参赛以赛题 B 为题，介绍一下参加本次大赛的开源项目，云原生项目包括 OKD、Prometheus 和 Grafana 等，分布式存储包括：Moosefs、etcd 等，AI 包括：Eli5、LightGBM 和 Theano 等，大数据包括：Ibis、Blaze 和 Presto 等。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMb4heXdqVc7ESHnhcZ6L9ic1f0piaCJ6w0murhL71vrCoMIGr46PsMS2VYBpNKWkzzlKV12ava1EzibA/640?wx_fmt=png)

下面以几个典型的迁移案例为例，介绍参加本次迁移大赛的过程，以 Prometheus 的迁移案例来介绍本次迁移的过程。Prometheus 是由谷歌研发的一款开源监控软件，是目前最火的一款开源监控软件，目前，麒麟软件的 XX 客户对 Prometheus 提出了移植需求，所以麒麟软件基于 openEuler-2003-LTS 和 KylinSever V10 sp1 对该软件进行了移植。涉及到的迁移的代码项目：

https://gitee.com/src-openeuler/prometheus

https://gitee.com/src-openeuler/alertmanager

https://gitee.com/src-openeuler/grafana 

目前麒麟软件已经完成了该软件的相关项目的移植工作，大家可以去 openEuler 社区下载对应的代码和二进制。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMb4heXdqVc7ESHnhcZ6L9ic18UTShfFLmjAUTCWkfDR3zgiaXD8nuEFjxlUGPcT7DKJxBA2J4sXmdzA/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMb4heXdqVc7ESHnhcZ6L9ic1xZvqRXwlWKq3mqs3H1LQqwGXnz42RwfYoudcLAW5r3aMsMNfujjtfQ/640?wx_fmt=png)

迁移 prometheus 的主要过程如下，从获取需求到被 openEuler 社区接受入库的流程：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMb4heXdqVc7ESHnhcZ6L9ic14wQzKdrzdB54ibzVAfLJgRMdlQSgTt7gYy70eIlKrwrvfsV55JlBj7w/640?wx_fmt=png)

下面以 Etcd 为例介绍，介绍性能优化的过程，Etcd 是 CoreOS 团队于 2013 年 6 月发起的开源项目，它的目标是构建一个高可用的分布式键值(key-value)数据库，目前上游社区还不支持 arm 架构。Etcd 是一个开放源代码的分布式键值存储，用于保存和管理分布式系统需要保持运行的关键信息。最值得注意的是，它为流行的容器编排平台 Kubernetes 管理配置数据，状态数据和元数据。

目前，麒麟软件的 XX 客户对 Etcd 提出了移植需求和性能要求，所以麒麟软件基于 openEuler-2003 LTS 和 KylinSever V10 sp1 对该软件进行了移植和优化。涉及到的迁移代码项目：

- https://gitee.com/src-openeuler/etcd

测试环境如下：泰山服务器 X3（3 机集群） CPU：Kunpeng920-4826 Mem：256G 硬盘：固态硬盘(Device Model:SAMSUNG MZ7KH960HAJR-00005) 1T 测试工具：BenchMark 优化方法：针对鲲鹏平台进行了 A-Tune 和 ionice 的优化

写性能测试：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMb4heXdqVc7ESHnhcZ6L9ic1ufjCInRM0jsyPEickkkSiapUFkJJKjTjdfjZAFK548gxGGCy0vfEPzdw/640?wx_fmt=png)

读性能测试：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMb4heXdqVc7ESHnhcZ6L9ic11UdsvZZKtLfgqUbXyol1WAcvRMRSnofJUubxJyyic987NhTPOWickpCg/640?wx_fmt=png)

最后得到的结论：1）在 ARM 平台上 ETCD 进行了上百万次读写操作，未发生读写异常。2）最快单次写操作时间达到 0.5ms，最快单次读操作时间是 0.3ms。3） 通过开启 A-tune 和 ionice 优化，对 etcd 的读写性能都有明显提升。

下面以 pyporter 为例介绍一下迁移工具，pyporter 是 openEuler 社区开源的一款用于将 pypi.org 上的 python 源码，方便转化成 rpm 包的工具。

https://gitee.com/openeuler/pyporter 该工具可以很容易的将 pyp.org 的 python 源转化为对应的 spec 文件，进而生成我们需要的源码包和二进制包，从而满足我们的需要，下面是 eli5 的迁移过程：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMb4heXdqVc7ESHnhcZ6L9ic1khLwuaEtaTEiaKuFicrbOaK6ia2uFVpcwQ0aD7boQy4FX3txe14Uibcn3w/640?wx_fmt=png)

未来的贡献规划，未来麒麟软件将以 SIG 组为载体，继续开源社区的建设，主要的规划目标如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMb4heXdqVc7ESHnhcZ6L9ic1kR5biaUicmS4DNfaeHQmp02Gn0KqP9gO7WZVFu96JJcSVfjiaNhoX7aYw/640?wx_fmt=png)

麒麟软件是开源社区的参与者和贡献者。openEuler 已经成为公司最重要的基础社区之一。目前麒麟软件在 openEuler 社区贡献度已经上升到第二位。将持续投入资源并不断扩大贡献。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMb4heXdqVc7ESHnhcZ6L9ic1kXyfdN32g7L9vJjLSM4DvlYIQzuKoL0rgiaFxv2G8NicpsiciaW1azt2MQ/640?wx_fmt=jpeg)

刘冬：你们会制定一个什么样的计划，保持跟那个原始的那个版本的同步呢

麒麟软件有限公司：这个是根据客户的需求来满足的。

刘冬：因为这个版本一直在迭代，是不是接下来有怎样的计划来保持那个版本的更新呢？

麒麟软件有限公司：目前我们提交的版本已经开源，基本版本已经锁定了，以后我们会更新成比较新的版本，跟开源社区时刻紧密结合。

刘冬：麒麟软件在 openuler 的贡献会有计划去返回到上游社区里面吗？

麒麟软件有限公司：即会开放到 openEuler，也会也同步到上游开源社区的。

马全一：你这个 Etcd 是哪个版本？是 V3 还是 V2 的？

麒麟软件有限公司：V3。

马全一：测的时候是三台一起测试，还是一台一台的添加的测试？

麒麟软件有限公司：三台一起测。

马全一：三台可能测试程度还不够，再加一台可能会出事。

麒麟软件有限公司：因为测试时间比较短，尚未覆盖到这些测试面。

任炬：我比较感兴趣你们在部署迁移的时候，你们开的 A-tune 那个功能后，性能提升了多少。

麒麟软件有限公司：目前的主要功能时通过 A-tune 和 ionice 一起测试的结果，暂时还没有单独测试 A-tune 性能提升多少。

任炬：包括我跟 openEuler 的工程师，我们一直在做调优的研究工作，我觉得 A-tune 调优是非常前沿化的工作，很有意思，我们一直想知道 A-tune 开启后对读写性能到底影响多少。

麒麟软件有限公司：我们后续会做一下相关测试。

任炬：这种测试初始化阶段，大家可以一起去做，这样会有更好的效果。

江大勇：再做个小广告，openEuler 虽然是 OS，我们在里面开放了好多东西，但是厂商使用的还是不太够，因为我们 KE，就硬加速，这个也开源了，特别希望我们在这些新的方面能够把它用好。

任炬：硬件层面优化的机制，迁移过程中比较难，重新做一款应用可能把这个功能融合在一起。

江大勇：一些能力我们觉得我们优化很多，没有被大家充分用起来，GDK 我们一些优化，2.0 开放出来一些新东西。未来我们将有七个项目会发布，我们确实需要一些沟通，大家在线下告知这些技术我们哪些产品能用，什么应用能用，这个很有必要的。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibOspOSKHic8Nh8icmf9xozgIK5j5ibJibMLzCLhbSoicDQOrVDQpZKX2nkBA/640?wx_fmt=png)

***接下来还会有其他五支参赛队伍的演讲稿***

***点个关注第一时间获得稿件推送***

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbR3YNaNBytF0uqAicKL7fRD0JJj1HibCo2Sic0qxQ1LkZPlLqibMPxWUBBGeOOicicX3yY8e2icz81TU7Fg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYCjA16Qbj8RtLq6ZdzGlsR9Llaa49Bia9A8SlgicOgPZoDYZB2pxuLtp7FkmXvaIoZHRBUkAB6hA7w/640?wx_fmt=png)
