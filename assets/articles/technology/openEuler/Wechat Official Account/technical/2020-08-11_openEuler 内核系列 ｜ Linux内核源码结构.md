# [openEuler 内核系列 ｜ Linux内核源码结构](https://mp.weixin.qq.com/s/CY-YvVO63y31uy6NKvsNCw)

*罗宇哲*[OpenAtom openEuler](javascript:void%280%29;)*2020-08-11 23:36:19*

*作者：罗宇哲，中国科学院软件研究所智能软件研究中心*

*原文链接:http://suo.im/60R7Mb*

在上一期中，我们介绍了 Linux 内核发展的历史，也介绍了与其相关的 UNIX 和 GNU 的相关知识。从这一期开始，我们将介绍 Linux 内核的源码结构。我们将先根据 Linux 源码的目录结构进行分析，到本文章发布前，Linux 4.19 的最新版本为 Linux 4.19.94，我们将依据 openEuler 开源社区源码并参考 Linux 4.19.94 版内核源码进行分析。

### Linux 内核源码的目录结构分析

下图列出了截至文章发表前 openEuler 开源社区 kernel 目录下的目录结构\[1]：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZvY1KmHK0x9WiaYtr3knDpgiad69plcljoan6f1vw9kQJgQ3r1y809ibxSoQI0Znez2FIZkEvMygbHA/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZvY1KmHK0x9WiaYtr3knDpgeymeEHFrjZhxicBvjfforl4zia7mEVo7CA6e5WZNZfTicZVlYmrNOcMgQ/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZvY1KmHK0x9WiaYtr3knDpgThFaF1DQTuJNluCKJibKq8ThD1Eq3JwyrCdt5HtbayXXDqJ1BktzBZg/640?wx_fmt=png)

其中各个文件夹中**源代码的功能**如下表所示\[2]：

**目录/文件名****源码功能简介**`/Documentation`说明文档，对每个目录的具体作用进行说明。`/arch`不同 CPU 架构下的核心代码。其中的每一个子目录都代表 Linux 支持的 CPU 架构。`/block`块设备通用函数。`/certs`与证书相关。`/crypto`常见的加密算法的 C 语言实现代码，譬如 crc32、md5、sha1 等。`/drivers`内核中所有设备的驱动程序，其中的每一个子目录对应一种设备驱动。`/include`内核编译通用的头文件。`/init`内核初始化的核心代码。`/ipc`内核中进程间的通信代码。`/kernel`内核的核心代码，此目录下实现了大多数 Linux 系统的内核函数。与处理器架构相关的内核代码在`/kernel/$ARCH/kernel`。`/lib`内核共用的函数库，与处理器架构相关的库在`/kernel/$ARCH/lib`。`/mm`内存管理代码，譬如页式存储管理内存的分配和释放等。与具体处理器架构相关的内存管理代码位于`/arch/$ARCH/mm`目录下。`/net`网络通信相关代码。`/samples`示例代码。`/scripts`用于内核配置的脚本文件，用于实现内核配置的图形界面。`/security`安全性相关的代码。`/sound`与音频有关的代码，包括与音频有关的驱动程序\[3]。`/tools`Linux 中的常用工具。`/usr`该目录中的代码为内核尚未完全启动时执行用户空间代码提供了支持。`/virt`此文件夹包含了虚拟化代码，它允许用户一次运行多个操作系统。`COPYING`许可和授权信息。`CREDITS`贡献者列表。`Kbuild`内核设定脚本，可以对内核中的变量进行设定。`Kconfig`配置哪些文件编译，那些文件不用编译\[4]。`Makefile`该文件将编译参数、编译所需的文件和必要的信息传给编译器。

### 二、结语

本期我们根据 openEuler 的目录，并参考 Linux 目录结构简要介绍了 openEuler kernel 中各个子目录的功能，下一期我们将结合 Linux 内核的 Kernel Map 介绍**Linux 内核的基本功能和抽象层级**。

### 参考资料

\[1]

目录结构: *https://gitee.com/openeuler/kernel*

\[2]

下表所示: *https://www.cnblogs.com/CaesarTao/p/10600462.html*

\[3]

驱动程序: *http://blog.chinaunix.net/uid-30374564-id-5571674.html*

\[4]

编译: *https://blog.csdn.net/jianwen\_hi/article/details/53398141*
