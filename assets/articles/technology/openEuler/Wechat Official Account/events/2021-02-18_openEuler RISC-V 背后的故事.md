# [openEuler RISC-V 背后的故事](https://mp.weixin.qq.com/s/f-zNCKf2cbAz8UKQ02aeSQ)

*周鹏、张旭舟*[OpenAtom openEuler](javascript:void%280%29;)*2021-02-18 18:37:37*

本文是 openEuler Summit 体验区在果壳芯片上运行 openEuler 的文字版，通过阅读本文，你将了解到 openEuler RISC-V 构建背后的故事。

如果你对这个 Demo 感兴趣，欢迎加入到 RISC-V SIG，或者到该项目地址提交 PR、issue。

添加管理员微信加入 RISC-V SIG 微信交流群

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYGBeibQWVHYNRWHCDbRVknzKiajicicx4ovY2QUPbRbR8GeF5LHUEKqUJQeEDdsrX3VpHDM7xS8FTTPg/640?wx_fmt=jpeg)

**项目地址**

https://gitee.com/openEuler/RISC-V

RISC-V 是一个开源的精简指令集架构，始创于伯克利加利福尼亚大学。得益于开源，免费，易于扩展等特点，RISC-V 在芯片产业和生态领域有着广泛的想象空间。

2018年11月8号，我国成立了开放指令生态（RISC-V）联盟，英文缩写为 CRVA，联盟旨在推动建立世界共享的开源芯片生态。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYGBeibQWVHYNRWHCDbRVknzdDG9r6pFtthgEeMA2uQhKmMbDXgmcoNZwZvOfaoOrQyLZeVu4zibXFw/640?wx_fmt=png)

对于众多关注 IT 领域的小伙伴来说，“芯片”这个词语在2020年出现的频率那是特别的高，就连过年回家饭桌上二大爷都会问起来芯片相关的问题。在众多相关的新闻中，相信你一定听说过这一条“国科大五位本科生9个月设计出64位CPU”这条。

这里边提到的 CPU 就是基于 RISC-V64 指令构建的，命名为果壳，英文为 Nutshell。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYGBeibQWVHYNRWHCDbRVknzAQfm92bztQQ5hDZqfwL6urpWHhic7kdfjqjVe8FPPkucgrL5yJcn5icQ/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYGBeibQWVHYNRWHCDbRVknzHzalF4IjaLcIUltsV0CLWZz4tc8L9ibiaZGqp2KibVzMYTJsDH17lpdaQ/640?wx_fmt=jpeg)

现在，openEuler 也可以在果壳上运行了。RISC-V SIG 基于openEuler 社区的开源代码构建出的 RV64G 编码的 Linux 操作系统，可以运行在 QEMU 模拟器和多种硬件上。

为了让 openEuler RISC-V 能够运行在果壳上，主要需要解决如下几个问题：

第一，如何基于 openEuler 的社区开源代码，编译构建 RISC-V 架构的软件包，并且制作系统镜像。

问题的本质是使用 openEuler 的源代码，构建成可以在 RISC-V 指令集运行的文件系统。主要有两方面工作，分阶段构建软件包，对软件包的源码进行移植适配。

openEuler 当前的开源源代码是面向 Arm 和 x86 架构，有部分底层软件包含有架构相关的代码，需要对 RISC-V 进行适配和移植，在 openEuler RISC-V 构建的过程中，通过架构适配，回合补丁等方式将修改合入 openEuler 社区，解决了 50+ 个架构相关的编译问题。

openEuler RISC-V 所使用的内核源码取自于 openEuler 社区的 kernel 仓，与 openEuler 20.09 版本保持一致，内核版本为5.5，并将于最近升级为与openEuler 21.03 一致的 5.10。

在构建 openEuler RISC-V 的第一个阶段，首先要通过交叉编译的方式，构建出一个可以运行编译构建工作的最小精简系统出来，这可以分为两个部分，划定最小精简系统的软件包范围和利用交叉编译的方式构建软件包。

一个可以执行编译构建工作的最小系统，所包含的软件应当包括：编译构建相关工具 GCC，glibc，make 等，系统基本操作工具 util-linux，BASH，coreutils 等，软件包总数约为 60~80 个。

熟悉 Linux 的小伙伴，应该听说过“LFS-Linux FromScratch”项目，指导你如何从源代码开始，构建出一个Linux操作系统。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYGBeibQWVHYNRWHCDbRVknzogzEEKYDgicjKGzGafJicpVZ34DAEQzticVKdjDv3ibA6xPjgAJLqE0mIQ/640?wx_fmt=png)

第一阶段完成之后，就有了一个可以在 RISC-V 环境上运行的 openEuler RISC-V，但是这个只能够完成最基本的编译工作，仍然需要手动一步步的对不同的软件包进行配置、编译、安装等过程。为了利用软件包的管理工具和自动构建工具，需要继续基于 openEuler 的源代码和交叉工具链，构建出 rpm-build，dnf 等软件包，这个阶段所构建的软件包数量约为 200 个。

构建系统编译阶段：openEuler 作为开源 Linux 发行版，支持的软件包达到近万个，并且每一个软件包都在不断的迭代更新中，此时就需要引入自动化的构建系统对多个软件包进行自动化构建。

openEuler 所采用的构建系统是 OBS（Open Build Service），可以将构建任务自动调度至多个架构相关的 worker，完成自动化构建的任务。为了实现在 OBS 上构建 openEuler RISC-V 的目标，需要构建出作为 OBS worker 所需的软件包，包括网络工具 ssh，screen 等软件包。此时软件包数量约为 350 个。当 openEuler RISC-V  作为后端并入 OBS 系统之后，就可以通过界面进行自动化的批量构建，以及编排镜像制作等自动化 CI 任务。

截止目前，openEuler RISC-V 已经有稳定运行的自动化构建系统。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYGBeibQWVHYNRWHCDbRVknzM2ibsNp5d0GZhHjwlEIbyib81baxicsqYqDqKbWzULgXp8H5f5wxMibwbQ/640?wx_fmt=png)https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V

已自动构建1600+的软件包，并且软件包的数量也在持续增多。

未来几年，将是各种 RISC-V 硬件百花齐放的时代，openEuler RISC-V SIG 将致力于丰富 RISC-V 的北向软件生态，联合 RISC-V 的南向硬件生态，将 openEuler RISC-V 打造成一个开源的基础软件平台。欢迎大家关注 RISC-V SIG。

作者简介：

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYGBeibQWVHYNRWHCDbRVknzBKWiaRJSkZlatwg8aRgZ7nbdzwVx4yL5oMHbsiaJ3r7jwhpVRxiaYvQMQ/640?wx_fmt=jpeg)

周鹏博士主要从事操作系统、虚拟化、系统安全、智能软件等基础软件相关研究与开发工作；同时是开源模式的积极参与者，为 Xen、Libvirt、TensorFlow、ES-Operating System 等上游开源社区贡献了补丁。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYGBeibQWVHYNRWHCDbRVknzH9ckbzPJlj7QB9JfRAwlKY4DmQvEzAiathEP41BJWeFs0CZsFYC8t5Q/640?wx_fmt=jpeg)

张旭舟，RISC-V SIG  maintainer。北京邮电大学工学博士，研究方向为软件可靠性，曾在阿里进行安全方向的研究。现为华为2012 实验室服务器操作系统高级开发工程师，在 openEuler 社区负责 openEuler RISC-V 版本的移植和推广。
