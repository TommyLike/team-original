# [走进 isula-build 容器镜像构建工具的内部 ｜ 源码剖析](https://mp.weixin.qq.com/s/eWWWSGeT2muWhzBh73ZwiQ)

原创*阿翔*[OpenAtom openEuler](javascript:void%280%29;)*2020-09-17 18:00:00*

在观看了前几期容器镜像构建工具的使用和介绍之后，你或许想去研究下这个工具的内部逻辑， 或者想去给这个初生的小工具提一些建议或者改进。

那么，你需要一个快速入手isula-build 开源项目的方法，本期文章就来带你一起走进 isula-build 容器镜像构建工具的内部。话不多说，一起来看看吧。

**本期目标**

![](https://mmbiz.qpic.cn/mmbiz_gif/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayb3dQ1bnGjsJfePYNiczhYWYNFf9M2SGTkR3PCeRQr94002VkhYXznfQ/640?wx_fmt=gif)

1.介绍isula-build是什么

2.深入代码，搞懂你敲下的指令在做什么

3.社区发布流程、如何参与isula-build社区

**isula-build 是什么**

![](https://mmbiz.qpic.cn/mmbiz_gif/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayb3dQ1bnGjsJfePYNiczhYWYNFf9M2SGTkR3PCeRQr94002VkhYXznfQ/640?wx_fmt=gif)

说起isula-build，就不得不提及 iSulad。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayb6lYNpqQh4S6X2TBia5kcOicux81Vh5PU2GV2hYUV5ICRBCE4q21TvbQ/640?wx_fmt=png)

iSulad 是华为自主研发的通用容器引擎，旨在统一的架构设计来满足 CT 和 IT 领域的不同需求。相比 Golang 编写的 Docker，轻量级容器具有轻、灵、巧、快的特点，不受硬件规格和架构 的限制，底噪开销更小，可应用领域更为广泛。目前已开源（开源地址：https://gitee.com/opene uler/iSulad）。

作为 iSulad 生态的一员， isula-build 承载了镜像构建、管理、分发等功能。

**isula-build 架构全景图**

![](https://mmbiz.qpic.cn/mmbiz_gif/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayb3dQ1bnGjsJfePYNiczhYWYNFf9M2SGTkR3PCeRQr94002VkhYXznfQ/640?wx_fmt=gif)

isula-build 采用经典的 C-S 架构，分为客户端 isula-build 和服务端 isula-builder ，客户端和服务端使用 GRPC 通信。用户可通过 isula-build 命令行与服务端 isula-builder 进行交互，发起镜像构建、镜像管理等请求。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciaylRY0mibErXorxAsFK8F6oW6nYjDrb9856S3D1ZuOHV1mqAl7q0ib4jkA/640?wx_fmt=png)

**isula-build 代码全景图**

![](https://mmbiz.qpic.cn/mmbiz_gif/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayb3dQ1bnGjsJfePYNiczhYWYNFf9M2SGTkR3PCeRQr94002VkhYXznfQ/640?wx_fmt=gif)

isula-build使用 golang 作为开发语言，目前自研代码行数超过2w+。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayLvGW0nTnHyYZWickR1JyiafEVD2FtdYCeyS5J2v2dAXCfXfWMYuIGKBQ/640?wx_fmt=png)

进入isula-build项目，我们可以看到有一系列文件夹，分别承载了不同的功能和设计。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayED2No3NN3ykTyNdx57YRV2qElFZqZE8veHRo0W8ZopZ0dhUAluRuvQ/640?wx_fmt=png)

下图为一些文件夹的主要功能概述：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayD8hTeEeq9ibCzAEONNLKicEdKJiaS0cJ74BgibKzFK7F8mMIEU7NHEkZDg/640?wx_fmt=png)

看到这里你可能已经懵逼了，如何快速的了解代码呢？

**isula-build 代码解析 --- 编译** 

![](https://mmbiz.qpic.cn/mmbiz_gif/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayb3dQ1bnGjsJfePYNiczhYWYNFf9M2SGTkR3PCeRQr94002VkhYXznfQ/640?wx_fmt=gif)

首先在我看来，如何最快了解一个项目的最快方法就是不要一开始就钻进代码里，而是先去编译和运行这个软件，然后通过将外在表象和内在逻辑一一对应的方法，来熟悉整个项目。

那么，如何运行isula-build？如果我们没有安装rpm包，那么就需要我们去手动编译二进制了，那 目标就是找到 Makefile ，在其中查找蛛丝马迹。

我们看到了项目里有Makefile，那么里面肯定写了如何编译这个项目。我们打开文件，找到isulabuild和isula-builder这两个二进制是在哪里编译的，就能找到代码最开始的地方，也就是我们即将进入的程序入口。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciay8gvqmryX21WtibaS7ye1ib7e8iabr9vWcMHtEAcicPibHO0o4Sibib6hE91WA/640?wx_fmt=png)

那么，我们尝试着去编译一下，看看会发生什么。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayAcqPic1Jdo1hlGfWwj25RadCIqo5kR69pAUibiawsEHXK4W8jTVT63bFg/640?wx_fmt=png)

我们发现，在isula-build/bin目录下，生成了两个二进制，那这两个二进制就是我们的成品啦，试着去运行下吧~

**isula-build 代码解析 --- 命令行入口**

![](https://mmbiz.qpic.cn/mmbiz_gif/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayb3dQ1bnGjsJfePYNiczhYWYNFf9M2SGTkR3PCeRQr94002VkhYXznfQ/640?wx_fmt=gif)

学过go语言的朋友都知道，每个二进制都是由 main.go 文件生成的，那么我们根据之前的isula-build代码全景图可以知道， isula-build 的入口就在 cmd/cli/main.go 里面，而 isulabuilder 的入口也就在对应的 cmd/daemon/main.go 里面了。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayC9r8okoia0fanw8wuUE8HNajMic0zVL3GEC5brTIFxAgaeic2unicmStmQ/640?wx_fmt=png)

试着敲敲 isula-build -h 和 isula-builder -h 帮助信息，看看都有什么吧！

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayayLRXr1ibkV7NtkX0rr7JfBMibCNnW1RNsDoIF1QXbvT6ibCrt9ICKF6g/640?wx_fmt=png)

**isula-build 代码解析---外在表现和内部逻辑**

![](https://mmbiz.qpic.cn/mmbiz_gif/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayb3dQ1bnGjsJfePYNiczhYWYNFf9M2SGTkR3PCeRQr94002VkhYXznfQ/640?wx_fmt=gif)

那么，知道了程序入口，我们就好比拿到了开启宝藏的钥匙，那么，我们就以一条 构建容器镜像 并将其保存为本地tar包 的命令来讲述代码的流程：

例子：isula-build ctr-img build –f Dockerfile –o docker-archive:busybox.tar:busybox:latest .

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciaymuJOUz6dtcRYyf49aJLzuuicTMFHf68WCLib40m8Y5VH4deTwC7lXKgQ/640?wx_fmt=png)

限于篇幅，上图为大家准备了小抄，可以方便快速的找到整个构建流程的每一处关键点位，大家可以参考上图的 S 形，按图索骥，找到对应的代码，并加以扩展。

考考你：到目前为止，isula-build 有多少个二级子命令？

**isula-build 社区开发**

![](https://mmbiz.qpic.cn/mmbiz_gif/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayb3dQ1bnGjsJfePYNiczhYWYNFf9M2SGTkR3PCeRQr94002VkhYXznfQ/640?wx_fmt=gif)

那么，在熟悉了isula-build代码框架之后，你是否已经跃跃欲试，想给我们的小工具提点建议或者改进的方向，那么，如何参与到开源社区的开发中呢？

首先不得不说下我们代码开发和发布的流程：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayBdOdIwAc7Cbpxo5UbPHX31ibg14lwARSPvzdP2yLry2N5Gcddgn4YtQ/640?wx_fmt=png)

上图概述了开发的整个流程。

如图所示，首先作为用户或者开发者的你会拿到我们发布的isula-build rpm 包或者源码。在你的使用过程中，你会有一些问题不明白或者你想参与改进，你就需要去我们的 源码仓 （https://gite e.com/openeuler/isula-build） 提交issue 。

那比如我发现，哦哟，小伙子不错哦，还真是个好的改进点，办它！那你的issue就进入了 issue accepted 阶段。我们会根据问题的紧急、难易程度等要素进行排期。

接下来，有热心群众就会去认领该issue并开始码代码，也就进入了 coding 阶段。本地代码写完 之后，功能也测试完毕，你兴奋的点击了提交按钮。那么你的提交就会来到了代码仓的pull request中。这里存放着大家的奇思妙想~

那是不是就意味着你的代码可以直接合入了呢？当然不能啦！所有人提交的代码要经过严格的审 核，这里包括大佬们（maintainer)肉眼的review和机器人（ci bot）无情的自动化用例检查，确保每一次合入都是OK的~ 经过了一系列的审查，大家都觉得你提交的代码又短小又精悍（#手动狗头），那么你的代码就可以合入 源码仓啦。至此，所有在源码仓中的活动也就告一段落了。

你以为这就完了？你写的代码是如何变成一个rpm包让你使用简单的 yum install isulabuild 就能装在你的电脑中并运行的呢？这里就涉及到我们的另一个仓库， 制品仓 （https://git ee.com/src-openeuler/isula-build）。

制品仓中的isula-build代码会以tar包的形式存在，也就是 源码打包 ，并伴随有相应的spec文件， 进行 rpm 包构建 ，最终集成到我们openEuler的 发布件 中一起发布。当然，你也可以单独获取我们的rpm包（https://build.openeuler.org/package/show/openEuler:Mainline/isula-build）

到这里，我们整体的isula-build代码架构和流程剖析就告一段落了，接下来，我们唯一需要的，就是屏幕前观看文章的你，加入我们，一起收获更多！

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayPb3NLibonlucpCAl1zV0IMCZDXMrajz7Lv1o4J6gcppsAV3qfGGibK6A/640?wx_fmt=png)

*isula-build 源码仓：*

***https://gitee.com/openeuler/isula-build***

*isula-build 制品仓：*

***https://gitee.com/src-openeuler/isula-build***

*isula-build obs地址：*

***https://build.openeuler.org/package/show/openEuler:Mainline/isula-build***

![](https://mmbiz.qpic.cn/mmbiz_gif/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayb3dQ1bnGjsJfePYNiczhYWYNFf9M2SGTkR3PCeRQr94002VkhYXznfQ/640?wx_fmt=gif)

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciayVmYGOCrUS6b8Z0c8gCS4WZxFsRkT3J0zOAiaYWzw5icvNzDibMpauspGg/640?wx_fmt=jpeg)

☆今晚8点，走进iSula安全容器的详细解读

我们在openEuler直播间等你~

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYicDFqjdW4UYukBrQUWJiciaymW4KtL7N6PoQUg4LccPJJ0vLd6WmicibZI41jVt0ic9Y7pYs69HibakLGA/640?wx_fmt=jpeg)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibOspOSKHic8Nh8icmf9xozgIK5j5ibJibMLzCLhbSoicDQOrVDQpZKX2nkBA/640?wx_fmt=png)

*观众老爷们来点一波关注*

*支持一下吧~！*

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibW7UzBsnWzxBuTy8gicmX8tnmvysnY4566KXpkQC9vMpAh6HmR0B8B9g/640?wx_fmt=png)
