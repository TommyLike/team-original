# [「转」毕昇JDK团队主导的RISC-V port正式合入OpenJDK主线](https://mp.weixin.qq.com/s/9beVtbJUsW7_VHrNcLWmtw)

*姜飞龙*[OpenAtom openEuler](javascript:void%280%29;)*2022-05-18 20:00:39*

> 编者按：2022 年 3 月 14 日，华为毕昇 JDK 团队主导开发的 OpenJDK RISC-V port \[1] 正式合入 OpenJDK 主线 \[2]，成为 OpenJDK 的官方 port 之一。OpenJDK 19 将会是第一个支持 RISC-V 后端的版本。

## OpenJDK RISC-V port 介绍

RISC-V \[3] 是一个开源免费的 RISC 指令集架构。随着指令集架构设计逐渐成熟，越来越多的开发者参与到了 RISC-V 生态建设中，将 Java 带到 RISC-V 世界的呼声也越来越高。毕昇 JDK 团队 RISC-V port 工作时间线如下：

- 2019 年，开始基于 OpenJDK 11 的 Linux/RISC-V 的移植工作
- 2020 年，在 OpenEuler 社区上开源: openEuler/bishengjdk-11 \[4]
- 2021 年，与社区合作，基于 OpenJDK RISC-V port \[5]，开展 upstream 流程
- 2022 年，合入 OpenJDK 主线 (JDK19)

### RISC-V port 特性介绍

RISC-V port 涉及的模块如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJV89TwfJtCia9p6VibojmKdsHtQXFG5FgvFuow9Yic7j2Jwt3CJ05EBeMEiara2u1OKZbZ1bpUZnXWSKw/640?wx_fmt=png)

OpenJDK RISC-V port 提供如下特性：

- Template Interpreter 模板解释器
- C1 (client) JIT 编译器
- C2 (server) JIT 编译器
- 当前主线支持的所有 GC (包括 ZGC 和 ShenandoahGC)

RISC-V port 基于 RV64G (IMAFD) 基础指令集提供了 64 位 RISC-V 架构支持，此外还为 Vector、Compressed (由阿里开发者贡献)、Bit-Manipulation 扩展提供了实验性支持。实验性扩展需要通过 `-XX:+UseRVV`、`-XX:+UseRVC`、`-XX:+UseZba` 和 `-XX:+UseZbb` 选项来显式启用。

除此之外，基于正式发布的 ISA 扩展集合，RISC-V port 提供了 String、Array 和 BigInteger 等 Java 类的 intrinsic 支持。目前 RISC-V Cryptography Extension 尚未正式发布，因此涉及到其中加解密指令的 sha/crc 相关 intrinsic 还在计划中。

当前 RISC-V port 还提供了 32 位的 Zero 支持，RV32G 后端 port 由中科院软件所 PLCT 实验室团队主导开发，仓库地址：openjdk-riscv/jdk11u \[6]。

更多 RISC-V port 的内容，可以回顾毕昇 JDK 团队在 RISC-V 中国峰会上的报告：Porting OpenJDK to RISC-V \[7]。也可以在 riscv-port-dev \[8] 上发起讨论。

### RISC-V port 测试情况

RISC-V port 测试主要在 QEMU 和 Native 环境中展开 (感谢中科院软件所 PLCT 实验室提供的 RISC-V 硬件和测试支持)。测试内容主要有功能测试 (jtreg tier {1,2,3,4}，jcstress) 和相关 Java benchmark (SPECjvm2008、dacapo 等) 测试。

RISC-V port 实现了 C1/C2 JIT 编译器，相比 Zero 版本有较大的性能提升。下图对比了 RISC-V Server 和 RISC-V Zero 在 SPECjvm2008 上的性能差异，结果显示 RISC-V Server 性能可以达到 Zero 的 39 倍 \[9]。

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJV89TwfJtCia9p6VibojmKdsHT3Ehg3EmKCynrAoaXibNLptDuHE0sgpibNzicXrxM13nBwwnGqwtQe3oQ/640?wx_fmt=png)

RISC-V port 在 SPECjbb2015 上的性能数据如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJV89TwfJtCia9p6VibojmKdsHAnwHZYJJ323hZGAoKKmudqXS1EUZ1RZUBpmicp6YEjJwhhpX2gcOHrA/640?wx_fmt=png)

## 体验 RISC-V JDK

目前 RISC-V JDK (JDK19) 可以直接通过 builds.shipilev.net \[10] 下载体验。如果没有硬件环境，可以通过交叉编译来构建 JDK。为了方便工具链的配置，文章中的构建步骤均基于 Docker，因此需要预先安装 Docker 环境。下面介绍如何从源码交叉编译 RISC-V JDK。

### 构建环境配置

- x86\_64 环境 (其他架构环境未经测试)
- docker
- adoptopenjdk/centos6\_build\_image \[11]

拉取最新的构建镜像：

```
$ docker pull adoptopenjdk/centos6_build_image:latest
```

启动镜像：

```
$ docker run -it --rm adoptopenjdk/centos6_build_image
```

### 源码构建 RISC-V JDK

**拉取代码：**

```
$ git clone https://github.com/openjdk/jdk.git
```

**交叉编译：**

```
# add riscv toolchain to PATH and LD_LIBRARY_PATH
$ export RISCV64=/opt/riscv_toolchain_linux
$ export LD_LIBRARY_PATH=$RISCV64/lib64:/usr/local/gcc/lib64:/usr/local/gcc/lib
$ export PATH="$RISCV64/bin:$PATH"
$ export CC=$RISCV64/bin/riscv64-unknown-linux-gnu-gcc
$ export CXX=$RISCV64/bin/riscv64-unknown-linux-gnu-g++

# configure and build
$ bash configure                            \
    --openjdk-target=riscv64-unknown-linux-gnu  \
    --with-sysroot=/opt/fedora28_riscv_root     \
    --with-boot-jdk=/usr/lib/jvm/jdk-18         \
    BUILD_CC=/usr/local/gcc/bin/gcc-7.5         \
    BUILD_CXX=/usr/local/gcc/bin/g++-7.5
$ make images
```

> 目前镜像中可能还未包含 jdk18，可以前往 Adoptium \[12] 下载 jdk18 作为 bootjdk。

### 源码编译 QEMU RISC-V

如果没有硬件环境，可以通过 QEMU 模拟的方式来运行 JDK，下面简单介绍一下从源码编译 QEMU RISC-V:

获取 QEMU 源码：

```
$ git clone https://github.com/qemu/qemu.git
```

构建 QEMU RISC-V：

```
$ cd qemu && mkdir build && cd build
$ ../configure --prefix=/path/to/install/qemu \
    --target-list=riscv64-linux-user,riscv64-softmmu
$ make -j && make install
```

源码编译过程中需要一些额外的依赖如 ninja 等，按需安装即可。编译完成后，可以在 /path/to/install/qemu 中找到对应的二进制。

### 测试 java -version

QEMU user 模式下：

```
$ qemu-riscv64 -L /path/to/sysroot /path/to/openjdk-riscv/bin/java -version
```

QEMU system 下，直接执行如下命令即可:

```
$ /path/to/openjdk-riscv/bin/java -version
```

## 结语

经过 OpenJDK 开源社区和毕昇 JDK 团队的共同努力，OpenJDK RISC-V 终于成为 OpenJDK 的家族成员之一。这是第一个由华为团队主导的 OpenJDK 社区项目，也体现了毕昇 JDK 团队持续拥抱开源，回馈开源的信念。欢迎大家参与到 RISC-V OpenJDK 的开发中来，为 RISC-V 生态建设添砖加瓦。

## 参考链接

01. https://wiki.openjdk.java.net/display/RISCVPort
02. https://github.com/openjdk/jdk/pull/6294
03. https://riscv.org/about
04. https://gitee.com/openeuler/bishengjdk-11/tree/risc-v
05. https://github.com/openjdk/riscv-port
06. https://github.com/openjdk-riscv/jdk11u
07. https://www.bilibili.com/video/BV1n64y1t7gc
08. https://mail.openjdk.java.net/mailman/listinfo/riscv-port-dev
09. https://twitter.com/shipilev/status/1479179438625595399
10. https://builds.shipilev.net
11. https://hub.docker.com/r/adoptopenjdk/centos6\_build\_image
12. https://adoptium.net/index.html

## 后记

如果遇到相关技术问题（包括不限于毕昇 JDK），可以通过 Compiler SIG 求助。Compiler SIG 每双周周二举行技术例会，同时有一个技术交流群讨论 GCC、LLVM 和 JDK 等相关编译技术，感兴趣的同学可以添加如下微信小助手入群。

![](https://mmbiz.qpic.cn/mmbiz_jpg/icntuIQtpSJURabyabXmK64ich3UzDtIyn2picNDbEMLvAMkuCFsnz8oVXYibnZXWVRJy8SwHIsh4YW629PMgeicymg/640?wx_fmt=jpeg)

* * *

关注 **毕昇编译** 获取编译技术更多信息

点击 **阅读原文** 开始使用毕昇 JDK

[阅读原文](https://www.hikunpeng.com/zh/developer/devkit/compiler/jdk)
