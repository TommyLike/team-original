# [社区代码贡献之星：SIG-CloudNative 成员夏丹妮](https://mp.weixin.qq.com/s/VpIcMoGgyYKn9yABXFW37Q)

[OpenAtom openEuler](javascript:void%280%29;)*2022-08-17 20:00:00*

1

1

**openEuler社区访谈**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaXYkHtl8lTLIPGvjqX0vloLRShQfp54AcxXNycnHDdUCvGCD6ZSxxyy3UnXSv15aTY2gE9icTCiaFQ/640?wx_fmt=png)

**夏丹妮**

**SIG-CloudNative成员**

**openEuler年度代码贡献之星获奖代表**

大家好，我叫夏丹妮，毕业于伦敦大学学院，于2018年底加入华为，一直从事容器相关的工作。在开源社区里，我是openEuler项目的贡献者，一直参与社区代码的开发与检视工作，包括云原生相关组件的特性开发和维护、资料撰写、CVE修复等。

![](https://mmbiz.qpic.cn/mmbiz_svg/9UjCmequjUicjx0wGuRAtLbhDFH4X3wENkN6nJ31iaZoMhhpOiaTWJGEx8re7fx9zop03x5BrVqvJTWLo2Nib907SQ8CMBYKdQlF/640?wx_fmt=svg)

![](https://mmbiz.qpic.cn/mmbiz_svg/9UjCmequjUicjx0wGuRAtLbhDFH4X3wENkN6nJ31iaZoMhhpOiaTWJGEx8re7fx9zop03x5BrVqvJTWLo2Nib907SQ8CMBYKdQlF/640?wx_fmt=svg)

**Q1**

您加入openEuler社区多久了？

在openEuler主要参与哪些工作？

我在openEuler第一个版本发布前就已投入openEuler开源准备工作，后续一直在openEuler社区参与开发与检视工作，包括容器引擎相关的docker、containerd、runc 等组件的维护和升级，以及混合部署节点管理组件 rubik 的开发和维护工作。具体工作内容主要包括新特性的开发、Issue的处理、CVE的回合修复，以及组件的升级、资料撰写等。之前也参与过openEuler的直播，给大家宣传在openEuler上部署K8S的方法等。

**Q2**

您所开发的特性，其主要使用场景是什么？

Docker等容器引擎相关的组件大家也比较熟悉了，主要就是运用于容器场景，官网上也有相关的指南，有需要的朋友可以查阅参考。

容器用户使用指南

https://docs.openeuler.org/zh/docs/22.03\_LTS/docs/Container/Docker%E5%AE%B9%E5%99%A8.html

**混合部署节点管理组件rubik**主要应用于最近发展火热的云原生混合部署场景，实现业务之间的资源隔离，避免在混合部署场景下离线业务对在线业务造成干扰，在提升节点资源使用率的同时保障在线业务的服务质量。这个组件当前还在快速演进发展阶段，也非常欢迎社区的小伙伴们提出新的场景需求或是加入到我们的开发之中。

rubik 使用指南

https://docs.openeuler.org/zh/docs/22.03\_LTS/docs/rubik/overview.html

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaXYkHtl8lTLIPGvjqX0vloHAcE77Ldy4naBPtxAliaddfH15MWULIdUyEbIrk9gscFO1p9ic4m6ewQ/640?wx_fmt=png)

**Q3**

跟我们展开介绍下 rubik 项目？

可以的。

rubik是一个云原生场景在离线混合部署节点管理解决方案，在集群中以DaemonSet形式部署，结合了云原生场景下业务容器化部署的生产实践经验，针对云原生场景下节点资源利用率低以及业务运行存在的相互干扰的问题，集成了关键业务性能调优、资源隔离控制、资源预测及动态配比调优、干扰检测与控制等功能，最终旨在为用户打造云原生容器化部署场景下泛型混部及融合混部最优效果的解决方案，实现在保障在线业务服务质量前提下，最大化提升离线业务吞吐率，大幅提升集群资源利用率，降低用户运维管理成本。 

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaXYkHtl8lTLIPGvjqX0vloprH0O1XOhia9amttvjQoahic7601ZkSJ5BibQ9GPII8EwVRqH11KNlKrw/640?wx_fmt=png)

感兴趣的朋友可以关注**本周四的技术直播**。我们也将在近期输出更具体的博客内容。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaXYkHtl8lTLIPGvjqX0vloxs4zdKneia7luYavJyR0TUphUO7icAJp9ticQboNNqoK83SYNQ3WsPqBg/640?wx_fmt=png)

**Q4**

您目前在社区工作上比较关注什么？

方便透露下后续的规划？

现在还是比较关注混合部署项目的发展，rubik组件的使用情况。现在业界都在发展混合部署，也希望大家可以多多使用我们的开源组件，如果遇到问题可以及时提出来，更欢迎大家能够参与到我们的开发中。后续我也会继续演进和推广我们的混合部署特性。

rubik 项目托管地址

https://gitee.com/openeuler/rubik

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaXYkHtl8lTLIPGvjqX0vloaqLeibE6XOHjXlbQwqibb3tHoDZbjwE6vAVLx6oonlMgYEHsiaYic57E6A/640?wx_fmt=png)

**Q5**

如果社区小伙伴感兴趣，怎么参与进来一起工作？

可以直接在仓库提issue或提交代码，也可以联系openEuler官方公众号或小助手，加入我们的SIG微信群，一起交流一起开发。

SIG-CloudNative的主页

https://www.openeuler.org/zh/sig/sig-list/sig-detail.html?id=85&name=sig-CloudNative&mail=cloudnative%40openeuler.org

SIG-CloudNative详细项目页

https://gitee.com/openeuler/community/tree/master/sig/sig-CloudNative

**Q6**

作为这次社区代码贡献之星的获奖代表，能聊聊您的感受？

很意外也很荣幸能够获得这个殊荣，其实大家都有在积极参与社区开发，每个人都是贡献之星。后续我也会再接再厉，努力投入openEuler社区的建设中。

对云原生的相关工作感兴趣的朋友，欢迎扫码加入SIG-CloudNative的交流群，参与其中，一起探索技术上的更多可能性。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMaXYkHtl8lTLIPGvjqX0vlop37fzvFaMzUnpcZQWK18IQIVwdyibsz8NAiazBGwpqSJ6CAJVNrM42FA/640?wx_fmt=jpeg)

**END**
