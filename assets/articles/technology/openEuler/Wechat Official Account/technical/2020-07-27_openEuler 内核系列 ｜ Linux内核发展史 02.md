# [openEuler 内核系列 ｜ Linux内核发展史 02](https://mp.weixin.qq.com/s/9H1Vq05eB7JrriZUVVf-lA)

[OpenAtom openEuler](javascript:void%280%29;)*2020-07-27 20:30:00*

*作者：罗宇哲，中国科学院软件研究所智能软件研究中心*

Linux 是由赫尔辛基大学的 Linus Torvalds 开发的，在系统开发期间得到了因特网上广大 UNIX 程序员的帮助。

它最初只是受 Andy Tanenbaum 教授的 Minix（—个小型的类 UNIX 系统）启发而开发的一个程序，纯属个人爱好，但后来它逐步发展成为一个完整的系统。

Linux 的成功来源于其之前操作系统和应用软件的已有工作，主要是 UNIX 和 GNU。本小结我们将介绍一下 UNIX 的发展简史。

### UNIX 操作系统发展历史

UNIX 操作系统最初是由贝尔实验室开发的，当时的贝尔实验室是电信业巨头 AT&T（美国电报电话公司）旗下的一员。

UNIX 是在20世纪70年代为 DEC（数字设备公司）的 PDP 系列计算机设计的，它现在已成为一种非常流行的多用户、多任务操作系统。UNIX 操作系统可以运行在大量不同种类的硬件平台上，其适用范围从 PC 工作站一直到多处理器服务器和超级计算机。

UNIX 系统的主要特点有\[1]：

1.简单性：许多很有用的 UNIX 工具是非常简单的，因此也是很小并易于理解的。

2.集中性：在 UNIX 中，当用户出现新的需求时，我们通常是把小工具组合起来以完成更复杂的任务，而不是试图将一个用户期望的所有功能放在一个大程序里。

3.可重用组件：将应用程序的核心实现为库。具有简单而灵活的编程接口、文档齐备的库可以帮助其他人开发出同类程序，或者把这些技术应用到新的应用领域。

4.过滤器：许多 UNIX 应用程序可用作过滤器。也就是说，它们对输入进行转换并产生输出。

5.开放的文件格式：比较成功并流行的 UNIX 程序都使用纯 ASCII 码的文本文件或 XML 文件作为配置文件和数据文件。

6.灵活性：你不能期待用户都能非常正确地使用你的程序。所以，你在编程时应尽可能考虑到灵活性，尽量避免随意限制字段长度或记录数目。

最初的 Unix 是用汇编语言编写的，一些应用是由叫做 B 语言的解释型语言和汇编语言混合编写的。B 语言在进行系统编程时不够强大，所以汤普逊和里奇对其进行了改造，并与 1971 年共同发明了 C 语言。

1973年汤普逊和里奇用 C 语言重写了 Unix。在当时，为了实现最高效率，系统程序都是由汇编语言编写，所以汤普逊和里奇此举是极具大胆创新和革命意义的。用 C 语言编写的 UNIX 代码简洁紧凑、易移植、易读、易修改，为此后 UNIX 的发展奠定了坚实基础。

1974年，汤普逊和里奇合作在 ACM 通信上发表了一篇关于 UNIX 的文章，这是 UNIX 第一次出现在贝尔实验室以外。此后 UNIX 被政府机关，研究机构，企业和大学注意到，并逐渐流行开来。

1975年，UNIX 发布了4、5、6三个版本。

1978年，已经有大约 600 台计算机在运行 UNIX。

1979年，版本7发布，这是最后一个广泛发布的研究型 UNIX 版本。

20世纪80年代相继发布的 8、9、10 版本只授权给了少数大学。此后这个方向上的研究导致了九号计划的出现，这是一个新的分布式操作系统。

1982年，AT&T 基于版本 7 开发了 UNIX System Ⅲ 的第一个版本，这是一个商业版本仅供出售。为了解决混乱的 UNIX 版本情况，AT&T 综合了其他大学和公司开发的各种 UNIX，开发了 UNIX System V Release 1。

这个新的 UNIX 商业发布版本不再包含源代码，所以加州大学柏克莱分校继续开发 BSD UNIX，作为 UNIX System III 和 V 的替代选择。

BSD 对 UNIX 最重要的贡献之一是 TCP/IP。BSD 有8个主要的发行版中包含了 TCP/IP：4.1c、4.2、4.3、4.3-Tahoe、4.3-Reno、Net2、4.4 以及 4.4-lite。这些发布版中的 TCP/IP 代码几乎是现在所有系统中 TCP/IP 实现的前辈，包括 AT&T System V UNIX 和 Microsoft Windows。

其他一些公司也开始为其自己的小型机或工作站提供商业版本的 UNIX 系统，有些选择 System V 作为基础版本，有些则选择了 BSD。BSD 的一名主要开发者，比尔·乔伊，在 BSD 基础上开发了 SunOS，并最终创办了太阳计算机系统公司。

1991年，一群 BSD 开发者离开了加州大学，这其中包括Donn Seeley、Mike Karels、Bill Jolitz 和 Trent Hein，他们创办了Berkeley Software Design, Inc  (BSDI)。

BSDI 是第一家在便宜常见的 Intel 平台上提供全功能商业 BSD UNIX 的厂商。后来 Bill Jolitz 离开了 BSDI，开始了 386BSD 的工作。

386BSD 被认为是 FreeBSD、OpenBSD 和 NetBSD、DragonFlyBSD 的先辈。AT&T 继续为 UNIX System V 增加了文件锁定，系统管理，作业控制，流和远程文件系统。

1987到1989年，AT&T 决定将 Xenix（微软开发的一个 x86-pc 上的 UNIX 版本），BSD，SunOS 和 System V 融合为 System V Release 4（**SVR4**）。这个新发布版将多种特性融为一体，结束了混乱的竞争局面。

1993年以后，大多数商业 UNIX 发行商都基于 SVR4 开发自己的 UNIX 变体了。

UNIX System V Release 4 发布后不久，AT&T 就将其所有 UNIX 权利出售给了 Novell。Novell 期望以此来对抗微软的 Windows NT，但其核心市场受到了严重伤害，最终 Novell 将 SVR4 的权利出售给了 X/OPEN Consortium，后者是定义 UNIX 标准的产业团体。

最后 X/OPEN 和 OSF/1 合并，创建了 Open Group。Open Group 定义的多个标准定义着什么是以及什么不是 UNIX。实际的 UNIX 代码则辗转到了 Santa Cruz Operation，这家公司后来出售给了 Caldera Systems。Caldera 原来也出售 Linux 系统，交易完成后，新公司又被重命名为 SCO Group。

下图以树状图的形式展示了从 UNIX 系统衍生出的各种操作系统\[2]：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYCHnTBdt3LaxGFmgugNTVcGGYcdSfPTMMUTAWQSgOw5pfBzLoe9FmSH6crmiaEsTpuZibeAoGRuS0A/640?wx_fmt=gif)

### 总结

本小节中我们简要介绍了有关 Linux 内核的一个重要基础 —— UNIX 操作系统。下一小节我们将介绍 Linux 应用程序的一个重要来源 —— GNU。

如果喜欢的这个系列的话，就请关注一下这个公众号吧。

### 参考文献

***\[1]《Linux程序设计（第四版）》***

***\[2] https://www.cnblogs.com/alantu2018/p/8991158.html***

***原文链接：https://urlify.cn/7NJZFf***

阅读更多

[openEuler 内核系列 | Linux 内核发展史](https://mp.weixin.qq.com/s?__biz=MzI2NDE4OTE2Mg%3D%3D&mid=2247483983&idx=1&sn=1e80dfe078d1c1d17fe7dd78640a3eac&scene=21#wechat_redirect)01[](https://mp.weixin.qq.com/s?__biz=MzI2NDE4OTE2Mg%3D%3D&mid=2247483983&idx=1&sn=1e80dfe078d1c1d17fe7dd78640a3eac&scene=21#wechat_redirect)[](https://mp.weixin.qq.com/s?__biz=MzI2NDE4OTE2Mg%3D%3D&mid=2247483983&idx=1&sn=1e80dfe078d1c1d17fe7dd78640a3eac&scene=21#wechat_redirect)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibOspOSKHic8Nh8icmf9xozgIK5j5ibJibMLzCLhbSoicDQOrVDQpZKX2nkBA/640?wx_fmt=png)

***记得分享点赞再看哦***

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbR3YNaNBytF0uqAicKL7fRD0JJj1HibCo2Sic0qxQ1LkZPlLqibMPxWUBBGeOOicicX3yY8e2icz81TU7Fg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibW7UzBsnWzxBuTy8gicmX8tnmvysnY4566KXpkQC9vMpAh6HmR0B8B9g/640?wx_fmt=png)
