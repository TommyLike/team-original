# [openEuler用户软件仓（EUR）介绍](https://mp.weixin.qq.com/s/JR810_OyIX9jtjTcQ1Xj3w)

[OpenAtom openEuler](javascript:void%280%29;)*2023-03-01 18:00:00*

**什么是 EUR**

EUR(openEuler User Repo)是openEuler社区针对开发者推出的个人软件包托管平台，目的在于为开发者提供一个易用的软件包分发平台。

链接：https://eur.openeuler.openatom.cn/

**为什么我们需要 EUR**

在操作系统的世界，软件包是一等公民，软件包的丰富程度和是否易于分发，一定程度上决定了操作系统用户和开发者的使用体验，试想一下这种情况：

1\. 开发者希望自己尚在开发中的软件能够尽早的与openEuler社区持续的集成并发布给自己的用户进行测试；

2\. 在引入新包时，发现其多个依赖的软件包在社区中不存在，极大增加开发者的工作量；

3\. 用户期望在openEuler 20.03上使用/集成某个软件包的nightly或unstable版本。

 

针对上面的场景，在当前openEuler社区的基础设施中，还没有太好的开箱即用的方案。仔细分析上面的场景，我们发现社区存在着如何平衡软件包丰富和软件包质量的问题，在和社区TC委员讨论后，我们形成了下述的软件包分层的思路：

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbSUNcRnricP2xJia3jzn1x8VRw6To1dW8cXghQEibMlEnYhwyRG4v2NhKMxUFpag0DyycTIRIxwicAoA/640?wx_fmt=jpeg)

core packages: openEuler社区的开发者，sig组维护着的一组核心软件包

extra packages：类似EPOL或oepkgs等尚不满足社区质量要求，但仍然处于可用阶段的软件包

developer packages（EUR）：完全由开发者或个人维护并保证质量的软件仓库，不需要遵循openEuler社区软件包的大部分约束和质量要求

**我们需要一个什么样的 EUR**

基于上述的软件包分层模型，不难看出，对于developer packages，社区需要一个简单轻量的对开发者友好的软件包分发平台。

 

按照以上描述，我们将这个平台命名为EUR（openEuler User Repo）。我们发现针对EUR的需求和copr的功能十分类似，在和copr的开发团队进行沟通后，我们发现copr社区的目标和我们较为一致，并且十分open，在提交一系列pr并得到快速合并后，我们打算使用copr构建我们第一版的EUR系统。

**EUR的定位**

我们将EUR定位为开发者的个人仓库，类似于ubuntu的PPA，fedora的COPR，这个服务专注于为开发者提供便利，EUR支持自动从pypi，rubygem（未来可以扩展更多的方式）打包软件包，支持通过webhook自动触发持续构建，后续还将支持一键将个人仓库的软件包引入社区。

**谁适合使用EUR**

如果您：

想快速从pypi/rubygem上打包软件包；

想为已发布的openEuler版本添加最新的软件包或变体版本；

想为还在开发中的软件提供持续与openEuler集成的仓库；

只是将某个软件打包成rpm包供自己使用；

在将软件包贡献到社区前，测试验证自己的spec文件是否正确。

我们都建议您使用EUR实现快速构建独立的软件包仓库，分发您的软件包。

地址：https://eur.openeuler.openatom.cn/

**联系我们**

如果您在使用过程中有任何意见或建议，可以给我们发邮件：infra@openeuler.org，同时也可以在社区论坛（https://forum.openeuler.org/）中交流讨论。

**活动预告**

为了让大家更深入地了解用户软件仓及功能使用，openEuler将在本周四举办线上直播

时间：3月2日 （本周四）晚上 19：30-20：30

地点：openEuler B站

**扫描下方二维码即可预约直播**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbSUNcRnricP2xJia3jzn1x8VNutoXSkx8T8C0xlh1jv8cQu5VrHOGhexRWDNZhWibhyEsQUxQ9nX8mw/640?wx_fmt=png)

**点击下方图片查看具体的活动内容**

[![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbSUNcRnricP2xJia3jzn1x8VI9FFcOwdDJEZ8ZDfnh68eGxd2WKcjqFlZJYdDDc3cyeW8dnNhogGAw/640?wx_fmt=jpeg)](http://mp.weixin.qq.com/s?__biz=MzI2NDE4OTE2Mg%3D%3D&mid=2247501432&idx=2&sn=c9907ac4a715bb3abfa09cacc8c12137&chksm=eab2e3fdddc56aebc9c3b82d0be8aa193cf341fc186c6fd07f17d7c809e2f6a1ab811f08dfa5&scene=21#wechat_redirect)
