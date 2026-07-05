# [华为开源毕昇 JDK，为 ARM 架构做了大量优化，是 openEuler 默认的 Java 运行环境](https://mp.weixin.qq.com/s/ApsY-QhuiweHxk57nm1OgA)

原创*郭歌*[OpenAtom openEuler](javascript:void%280%29;)*2020-10-20 12:00:48*

2020 年 9 月 26 日，华为正式开源了基于 OpenJDK 的 毕昇 JDK。这是一个长期支持版本，深度融合了华为在 Java 领域多年的积累，为 Java 应用做了大量稳定性增强功能，并针对 ARM 架构做了大幅性能优化，为 ARM 架构的服务器运行 JDK 提供了一个新的选择。

## 毕昇 JDK

毕昇 JDK 是华为基于 OpenJDK 开发的商用 JDK 版本，是一个高性能、可用于生产环境的 OpenJDK 发行版。毕昇 JDK 已经运行在华为内部 500 多个产品上，积累了大量使用场景和 Java 开发者反馈的问题和诉求，并在 ARM 架构上进行了性能优化，毕昇 JDK 在大数据等场景下可以获得更好的性能。

毕昇 JDK 是 openEuler 社区下的一级子项目，openEuler 是一款开源操作系统。毕昇 JDK 目前支持 AArch64 架构下的 Linux。毕昇 JDK 的开源是为了繁荣 openEuler 基础软件生态的必然举措。希望通过开源，吸引更多的 Java 开发者在 ARM 架构上持续耕耘。

本次开源的 毕昇 JDK 有 8 和 11 两个版本，分别对应的是 J2SE 8 和 J2SE 11 两个标准。

毕昇 JDK 有以下技术特点：

1. 毕昇 JDK 8 支持了 AppCDS，可以大幅缩短应用启动速度和多进程内存占用，对于短生命周期、大内存占用的应用，以及容器应用有较好的优化效果。
2. 毕昇 JDK 11 在 ARM 架构上支持了实验性质的 ZGC，支持最大 10ms 时延，并进行了稳定性增强，开发者在 ARM 架构上也可以享受到低时延 GC 算法带来的优势。
3. 毕昇 JDK 8 & 11 同时支持快速序列化技术，这项技术为一些场景提供了相比于 Java 原生序列化更强的序列化能力，在部分场景性能提升可达 20%。

毕昇 JDK 已经集成到了 openEuler 操作系统中，作为默认的 JDK 运行，openEuler 的用户可以方便的获取和使用 毕昇 JDK 的能力，持续构建应用在 ARM 上的竞争力。

毕昇 JDK 同时也提供了支持独立发布的二进制包，可以让用户部署在不同的 linux 系统之中。

## 如何安装使用？

毕昇 JDK 当前提供 tar 压缩包和 yum 源安装两种方式

**在 Linux/AArch64 平台上安装 JDK 8**

> cd /path/you/want/to/install/jdk

下载毕昇 JDK 8 安装包\[1]

> tar zxvf bisheng-jdk-8u262-linux-aarch64.tar.gz

JDK 8 所在的文件夹名称为 bisheng-jdk1.8.0\_262

**在 Linux/AArch64 平台上安装 JDK 11**

> cd /path/you/want/to/install/jdk

下载毕昇 JDK 11 安装包\[2]

> tar zxvf bisheng-jdk-11.0.8-linux-aarch64.tar.gz

JDK 11 所在的文件夹名称为 bisheng-jdk-11.0.8

如果您使用的操作系统是 openEuler 20.09，那么您可以选择`dnf install java`的方式直接安装毕昇 JDK/JRE。

目前毕昇 JDK 仅支持 Linux/AArch64 平台。

更详细的信息请参考 毕昇 JDK 8 主页\[3] 和 毕昇 JDK 11 主页\[4]

Java 生态碎片化早已经是一个常态，这种碎片化的状态从侧面反映出来大家对于 Java 生态的思考。华为推出自己的 OpenJDK 发行版，一方面展示了华为对 JDK 生态的思考重点 —— 基于 ARM 架构进行优化，使之成为 openEuler 基础软件软件生态的一部分。这种碎片化的生态，最终将反哺 OpenJDK，从促进 Java 生态更加健康繁荣的发展。

### 参考资料

\[1]

下载毕昇 JDK 8 安装包: *https://mirrors.huaweicloud.com/kunpeng/archive/compiler/bisheng\_jdk/bisheng-jdk-8u262-linux-aarch64.tar.gz*

\[2]

下载毕昇 JDK 11 安装包: *https://mirrors.huaweicloud.com/kunpeng/archive/compiler/bisheng\_jdk/bisheng-jdk-11.0.8-linux-aarch64.tar.gz*

\[3]

毕昇 JDK 8 主页: *https://gitee.com/openeuler/bishengjdk-8*

\[4]

毕昇 JDK 11 主页: *https://gitee.com/openeuler/bishengjdk-11*

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMatRzJgDKxzkb8gsqm9MstYn8W6fMhbPtZKBZFQM7j9KhZ9R0HcHFftFOibVjmusW1797xCFSUD0nw/640?wx_fmt=png)

**openEuler —— 最具有活力的开源社区**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYCjA16Qbj8RtLq6ZdzGlsR9Llaa49Bia9A8SlgicOgPZoDYZB2pxuLtp7FkmXvaIoZHRBUkAB6hA7w/640?wx_fmt=png)
