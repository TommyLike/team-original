# [为了完善 ARM64 软件生态，openEuler 团队正在做的事](https://mp.weixin.qq.com/s/qplaAuOyzaPEj4We96mecA)

原创*王玺源*[OpenAtom openEuler](javascript:void%280%29;)*2020-06-24 22:08:40*

在开源软件中，有很多开源的 Web 软件，但是很多软件对于 ARM64 的支持并不理想。有些软件没有提供官方的 CI 测试，很难保证代码质量。有些软件在 ARM64 上的性能远不如 x86\_64，甚至无法在 ARM64 上运行。

为了完善 Web 领域的 ARM64 生态（Web on ARM64），我们参与了主流的9个开源项目。分别是：

1. Apache Httpd Server（C）
2. Apache Tomcat（Java）
3. Memcached（C）
4. Nginx（C）
5. Lighttpd（C）
6. JBoss/WildFly（Java）
7. HAProxy（C）
8. Squid（C++）
9. Varnish Cache（C）

我们参与以上9个项目的目的，主要是为了解决下面三个问题：

能不能在 ARM64 上运行？

如何稳定的运行在 ARM64 上？

怎么更好的在 ARM64 上运行？

**能不能在 ARM64 上运行**

我在这9个项目的后面标注了每个项目所使用的编程语言，可以看到这9大项目主要是由 Java、C 和 C++ 三种语言编写而成。

 

其中 Java 这类自带跨平台特性的编程语言，是可以运行在 ARM 64 上的，这个很好理解。而 C/C++ 则需要首先编译成 ARM64 平台的目标可执行文件。在编译前需要进行编译测试。

 

经过我们的测试，这9个 Web 项目都可以在 ARM64 上成功编译并且运行。

**如何稳定的运行在 ARM64 上**

我们对稳定的定义如下：行为一致和持续可用。

 

**行为一致是指，软件在 ARM64 和 x86\_64 上的行为是否行为一致。由于 ARM64 和 x86\_64 架构和底层实现不同，****很多软件的某些行为在 x86\_64 和 ARM64 上的行为并不一致。**

 

举个例子，Java 的 Math 在 x86\_64 和 ARM64 上运行的计算结果就不同

 

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbgXcNZdIuuZksGBKgngfVV96paxt3WakkBfv2azk56WOicJkibBOReHCjca7aXFuruw5JqicCGmIniaQ/640?wx_fmt=png)

 

这段代码在 x86\_64 上的运行结果为

1.0986122886681098

在 aarch64 上运行的结果为

1.0986122886681096

在 Java 8 中的文档中，官方给出的说明：Math 的结果可能是不精确的，如果对精度有要求，那么请使用 StrictMath。 

这里已经能够说明由于底层实现不同导致行为不同，所以关于 Math 和 StrictMath 在底层实现上的有什么不同，在这里就不展开了。

想了解为什么的小伙伴可以关注 openEuler 社区官方公众号，回复 strictmath，告诉你为什么不一样。

 

除了一些由于底层实现不同导致的行为不同，**还有一些是因为缺少文件导致在 ARM64 上运行时，个别功能无法使用。**

 

例如，我们发现 WildFly 官方发布的源码中缺少个别 ARM64 平台的.so 文件，例如缺少 libartemis-native.so 和 libwfssl.so 文件

 

针对上面这两种问题，我们的解决方法就是打开代码逐个分析，逐个修复。保证所有测试在 ARM 64 上全部通过。

 

**关于持续可用的问题，CI/CD 是保证软件持续可用的重要方法。****主流软件的 CI 系统都有 x86\_64 平台的测试，而 ARM64 平台则少之又少。**

 

针对这个问题，我们推动了这9个项目的 ARM CI 支持。其中8个项目官方已经声明支持 ARM CI，Lighttpd 还在推动中。我们对官方支持 ARM64 的定义：**官方文档或 Release Note 中有明确说明，或已经官方发布了 ARM64 的安装包**

 

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbgXcNZdIuuZksGBKgngfVV4EkvQvicoXuWglJxt7C7Rd6mL4blhwyQe2Pj0dnkn4UDic5X7VY7Z15A/640?wx_fmt=png)

**怎么更好的在 ARM64 上运行**

 

这部分的重点在于**性能优化****。**

 

目前开源软件在这方面的现状是，一些软件只实现了 x86\_64 的汇编实现，但是缺少 ARM 64 的汇编代码；有些在 x86\_64 上的纯软件实现的功能，可以在 ARM 上通过硬件编码的方式实现，同时还能提高性能。甚至在很多场景中，我们还可以考虑如何最大化利用 ARM64 的多核优势，规避 ARM64 的锁劣势等等。

 

关于系统优化的内容很多，我们将在以后的文章中针对不同软件详细说明。本篇文章仅从 openEuler 的系统支持层面进行 。

 

一般情况下，开源软件很少自己分发不同操作系统的安装包。**以我们参与的 9 个 Web 项目为例，只有 Nginx 提供了 Ubuntu 的安装包，Varnish Cache 只提供了编译好的可执行文件，而其他7个软件只提供源码。**

 

针对 Nginx 这种官方提供安装包的项目，我们希望它能提供更多操作系统的安装包，**在我们的推动下，Nginx 社区已推出了 CentOS 的安装包，并表示下一步会推出 Alpine 的安装包。而 Varnish Cache 也已发布了 Debian 和 RPM 体系的安装包。openEuler 的安装包也在我们的规划中。**

 

针对大多数只提供源码或可执行文件的项目，各个操作系统需要自行打包、分发。

以 openEuler 为例，可以看到在官方 Repo 中已经支持了部分 Web 项目 aarch64 安装包。

官方 Repo 地址

**https://repo.openeuler.org/**

 

丰富的安装包是操作系统易用性的重要体现。我们相信随着 ARM64 软件生态的不断丰富，openEuler 的仓库也会不断充实。

 

以上就是 openEuler 团队为繁荣 ARM64 的软件生态做的一些事情。如果你想参与到 openEuler 的建设当中来，可以访问 openEuler 开发者网站，openEuler 的繁荣需要社区中的每一个人的共同努力。

openEuler 开发者网站

**https://openeuler.org/zh/developer.html** 

 

你也可以关注 openEuler 社区的官方微信公众号，关于 openEuler 的所有进展，我们都会在微信公众号中更新。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbgXcNZdIuuZksGBKgngfVVicClsZvOq81QKuvonOFg2FtA5UUdrQQC9nJzEcjFhJT4NUDDx0PFQQA/640?wx_fmt=png)

openEuler 官方公众号支持用户投稿

如果你想让自己文章让更多人看到

那就赶紧关注 openEuler 官方公众号吧

点击屏幕下方的 “**我要投稿**”参与吧
