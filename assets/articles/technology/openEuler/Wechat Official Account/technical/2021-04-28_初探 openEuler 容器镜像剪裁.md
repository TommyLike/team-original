# [初探 openEuler 容器镜像剪裁](https://mp.weixin.qq.com/s/-cPwKUjxYuirJO52p0_dGA)

原创*邢为政、魏宝辉*[OpenAtom openEuler](javascript:void%280%29;)*2021-04-28 18:00:00*

系统基础镜像提供了一个轻量级的 Linux 操作系统用户空间，并且作为各应用镜像的构建基础，在拥有最基础的软件包能力同时，体积应尽量做到最小。为提高容器应用的启动效率，为后续云原生相关应用打下基础，Cloud Native SIG 进行了一系列的探索，包含本文提及的基础镜像裁剪以及后续计划实施的软件包优化等。同时我们也了解到，我们的伙伴目前已经在公司内部的“磐舟”容器平台部分使用 openEuler 基础镜像作为应用构建的基础，在规模容器化部署的过程中，镜像的存储、分发占据了较多的启动时间及物理存储空间。在裁剪分析之前，我们先给出主流系统发行版在 x86\_64 架构下基础镜像的软件包数量及其大小：

版本软件包数量基础镜像大小openeuler-20.03-lts352469MBopeneuler-20.03-lts-sp1358512MBopeneuler-20.09346531MBubi186205MBubi-init187220MBubi-minimal105103MBcentos8172209MBfedora145175MBubuntu9272.9MB

因为**软件包依赖关系较为复杂、软件包合并提供能力**等问题，大量的非核心软件包被引入到 openEuler 基础镜像，使得基础镜像体积过大。下面，我们一步步分析 openEuler 基础镜像“大”起来的原因。

## 2. openEuler 基础镜像裁剪前分析

当前 openEuler 基础镜像使用openeuler-os-build\[1]工程进行制作，使用kiwi\[2]工具进行裁剪。其中 kiwi 工具使用配置文件 config.xml 用于配置基础镜像安装的软件包列表，在裁剪定制之前安装的软件包有：basesystem、bash、coreutils、yum、filesystem、iproute、NetworkManager、net-tools、openEuler-release、procps-ng、rootfiles、systemd、vim-minimal、which，这么多的包真的有必要都放入基础镜像中吗？欲善事、先利器，简单实现镜像依赖分析工具 idl\[3]，用于根据基础镜像内软件包列表及相应的软件源获取镜像内全部软件包的依赖关系字典及依赖图，idl 代码较少还有很大的优化空间，同学们可以自己去实现更好的版本。

使用工具分析后发现，使得当前 openEuler 基础镜像体积过大的主要原因为以下两点，组内的同学woqidaideshi\[4]已经提出相应的 issue 并且已经得到解决：

- \[src-openeuler/libreport 分离 libreport-filesystem 软件包](&lt;https://gitee.com/src-openeuler/libreport/issues/I1SY6B\[5]&gt;) openEuler master，21.03 分支合入
- \[src-openeuler/dnf dnf 移除依赖 deltarpm](&lt;https://gitee.com/src-openeuler/dnf/issues/I1SY58\[6]&gt;) openEuler 全分支合入

下面我们**总结一下这两点原因**。在 libreport 仓分离 libreport-filesystem 软件包前，因为使用 libreport 包来提供 libreport-filesystem 包的能力，使得 dnf 包管理器直接依赖 libreport 包（yum 包管理器在 openEuler 就是 dnf 包管理器，这点留给读者自己查看），最终导致 systemd 等一系列依赖包的引入，而我们只需要使用 libreport-filesystem 软件包提供 dnf 包管理器相关的目录结构。由于 dnf 移除 deltarpm 包依赖已经在 openEuler 全分支合入，所以在分析过程中，基础镜像实际并未引入 deltarpm 相关的子依赖包，但 openEuler 20.03 LTS 版本系统中依旧是未拆分依赖的 dnf 版本，使用该版本本地源手动构建出的基础镜像依旧会存在该依赖问题。

## 仅包含 yum 的基础镜像

对于基础镜像而言，包含 yum 包管理器的软件包栈是最基础的，我们尝试制作仅包含 yum 软件包栈的基础镜像，结果大小如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZ2QnjZDL5NwO0sjpGKpJBu1nyf3REX1Dha7UTYJyhOzcich2Z26b5Bm1QR2Sn8kuhZXg8oibhwjcyA/640?wx_fmt=png)

使用已经拆分 libreport-filesystem 软件包的 openEuler21.03 版本，在 x86\_64 架构下，相应的仅包含 yum 软件栈的基础镜像包含 124 个软件包，大小为 199M。但是作为 openEuler 系统发行的发布件之一，基础镜像仅包含 yum 软件包栈不甚合理，我们需要提供常用的软件包供开发人员在基础镜像容器中使用。下面我们分析主流系统基础镜像，然后决定选取哪些软件包到 openEuler 基础镜像中。

## 通用基础镜像入口软件包分析

这里我们分析Universal Base Image\[7]、CentOS、Fedora 基础镜像入口软件包，同样使用镜像依赖分析工具 idl\[8]。下面以 CentOS 为例进行分析：首先，我们获取到镜像内软件包列表并将其写入到文件中，如 centos8.list。

```
rpm -qa --qf '%{NAME}\n' | sort > centos8.list
```

其次，配置相应基础镜像使用的软件源，如 centos8-x86\_64.conf。最后再使用如下命令获取 centos8 基础镜像入口软件包。

```
python3 idl.py conf/centos8-x86_64.conf -e image_package_list/centos8.list
```

类似地，我们获取 UBI 系列以及 Fedora 基础镜像的入口软件包列表。结果如下：

镜像入口包列表centos8binutils, hostname, kexec-tools, langpacks-en, less, libdb-utils, rootfiles, tar, vim-minimal, yumfedora33alternatives, fedora-repos-modular, gpg-pubkey, rootfiles, sssd-client, sudo, tar, util-linux, vim-minimal, yumubi-minimalaudit-libs, chkconfig, gpg-pubkey, langpacks-en, libcap-ng, libdb-utils, microdnf, rootfilesubicrypto-policies-scripts, findutils, gdb-gdbserver, gpg-pubkey, langpacks-en, libdb-utils, rootfiles, subscription-manager, tar, vim-minimal, yumubi-initcrypto-policies-scripts, findutils, gdb-gdbserver, gpg-pubkey, langpacks-en, libdb-utils, procps-ng, rootfiles, subscription-manager, tar, vim-minimal, yum

相应的结果图如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZ2QnjZDL5NwO0sjpGKpJBucUMxOJoLA2uZSobAiav5OgKHsUw0NcLzayJAoJtRbHpHsporTicoEVhg/640?wx_fmt=png)

注：

- centos8 findutils 包通过 kexec-tools -&gt; dracut -&gt; findutils 路径引入
- centos8 procps-ng 包通过 kexec-tools -&gt; dracut -&gt; procps-ng 路径引入
- centos8、ubi、ubi-init 均包含 systemd 软件包全栈， centos8 systemd 可通过 kexec-tools -&gt; systemd 路径引入，ubi、ubi-init 可通过 subscription-manager -&gt; systemd 引入

我们可以发现，yum 软件包栈以及 libdb-utils、tar、vim-minimal 等基础软件包作为最常用的系统软件被包含于基础镜像中。此外，centos8 提供额外的 kexec-tools 工具用于直接加载内核以及 bintuils 工具用于分析二进制程序等。而 ubi-minimal 则包含使用 C 语言实现的 dnf 包管理器轻量化子集版本 microdnf 以及其他的基础包用于提供更小的基础镜像。

## 4. openEuler 基础镜像软件包策略及结果

引入以下图中红框选中的公共基础软件包，包含 yum 软件包栈以及相关的基础工具包共同作为 openEuler 基础镜像的基础软件集。**软件包选取的思路是**：尽可能提供系统中常用的命令，如 ps 命令（procps-ng）、find 命令（findutils）等；因为 Fedora 及 UBI 基础镜像的选取思路而没有选择引入 hostname、binutils 等 CentOS 独有的软件包，留给开发者自行下载；选择 gdb-gdbserver 包是希望 openEuler 基础镜像能提供简单的调试环境。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZ2QnjZDL5NwO0sjpGKpJBuf4CWAOicwdVnqMESBFZ3cdHPRQwmVc4BQwr1txazzEcqALJtIUM0NfA/640?wx_fmt=png)

openEuler 对比其他的系统镜像，相关包引入的区别：

- glibc-all-langpacks 由 glibc-common 提供能力
- libdb-utils 由 libdb 提供能力
- findutils 通过 libsolv 引入

而 glibc-common、libdb-utils、libsolv 均存在于 yum 软件包栈的依赖图中，于是相应的openeuler-os-build\[9]仓用于制作基础镜像的配置文件 config.xml 如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZ2QnjZDL5NwO0sjpGKpJBufOgQVia0318icvOocPFT9wYyqgm65AdnaiaZrQSBe3ZpOgB132R1z0EPA/640?wx_fmt=png)

Packages type 为 bootstrap 表示在镜像准备（kiwi prepare）阶段安装 filesystem 包；Packages type 为 image 表示在镜像制作（kiwi create）阶段安装：yum、procps-ng、gdb-gdbserver、rootfiles、tar、vim-minimal、openEuler-release 包（filesystem 为 linux 基础目录结构软件包，在 openEuler 中可以通过 yum-&gt; dnf -&gt; bash -&gt; filesystem 路径依赖引入，由于使用 kiwi 工具裁剪，必须提供类型为 bootstrap 的软件包，filesystem 一般作为此类型的软件包优先安装）。

## openEuler 基础镜像最终结果

在 4.1 小节策略下，分别在 x86\_64 以及 aarch64 架构下制作出的 openEuler21.03 创新版本基础镜像如下表所示：

版本软件包数量架构基础镜像大小openeuler-21.03129x86\_64203MBopeneuler-21.03129aarch64230MB

使用如下命令来获取最新的 openEuler-21.03 创新版基础镜像，并尝试使用起来吧。

```
docker pull hub.oepkgs.net/openeuler/openeuler:21.03
```

## 5. 还能更进一步吗

我们注意到 x86\_64 架构下，openEuler 21.03 版本基础镜像大小为 203MB，包含 129 个软件包；而 CentOS8 基础镜像为 209MB，包含 172 个软件包。大小几乎相同，但是软件包的数量却有较大的差异，openEuler 基础镜像“大”在了哪里？我们进入镜像里面深入的看一下。对比运行基础镜像容器：

```
docker run -it --rm hub.oepkgs.net/openeuler/openeuler:21.03 bash
docker run -it --rm centos bash
```

进入容器中查看各目录占用空间的大小：

```
du -h -d 1
```

对比后，我们发现镜像/usr 目录占用其 90%以上的空间，因此我们再去查看/usr 目录下的目录空间占用，各子目录大小如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZ2QnjZDL5NwO0sjpGKpJBu2KWGVmqLSOiaibwbpkUUuER0IT5licQjHYdLHcibWhFychms4p7nxcD2Jg/640?wx_fmt=png)

可以发现，虽然 openEuler 比 CentOS 基础镜像多 43 个软件包，但是/usr/lib64 库文件目录大小却几乎相同。经过繁琐但并不枯燥的软件包查询，能够逐渐发现 openEuler 基础镜像"大"的原因，主要表现为以下三点：

1. 软件包的不必要依赖较多
2. 软件包库文件的多版本共存
3. 没有考虑软件包的精简版本实现

以下举例说明以上问题：

1. openEuler libcurl、libssh 依赖 e2fsprogs 提供的 libcom\_err.so，但实际上并不需要除 libcom\_err.so 之外其他 e2fsprogs 软件包提供的文件。
2. openEuler 存在多个版本的 libncurses 相关的动态链接库文件。
3. CentOS8 基础镜像包含 libcurl-minimal、coreutils-single 软件包以实现提供相应软件包基础能力的精简版本，openEuler 尚未实现。

虽然存在这些使得 openEuler 基础镜像变“大”的问题，但实际上 openEuler 在软件包构建上已经在不断优化改进了。举个 openEuler Embedded SIG 的例子，由于嵌入式环境下使用容器对于镜像存储空间大小更加敏感，为了提供更加精简的基础镜像用于嵌入式环境方便业务部署及业务切换，openEuler Embedded SIG 对 openEuler 软件包进行了拆包优化，这里\[10]可以查询到拆包优化的过软件包，经过拆分后相应的软件包依赖关系变得更轻量，做出来的基础镜像更小（**可以达到 90 多 MB**）。合入 openEuler 主干的事宜已经在过程中，感兴趣的同学可以深入的了解一下。

## Back To Square One

为什么要做系统基础镜像？为了给应用提供可运行的、轻量的、一致的、安全的容器运行环境；为了给开发者提供轻量的，高效的、稳定的、可调试的容器开发环境。

那么对于应用来说，其实我并不需要我所依赖之外的文件，对于完全打包的静态二进制程序甚至我们可以直接使用**FROM scratch**来包装我们的可执行文件，distroless\[11]便提供这样的基础镜像最小集适用于应用的运行环境。而对于开发者来说，其更加关注的是开发调试环境的便利统一性，基础镜像中包含开发调试过程中的所用到的所有工具。

其实对于普通应用来说，目前似乎也能直接使用开发者环境下的基础镜像来打包应用，这是安全性、便利性、存储空间等诸多因素的权衡。对于这个问题，开源软件供应链点亮计划 - 暑期 2021 有两个相关的题目供感兴趣的同学选择，分别是No.63 openEuler 基础镜像优化\[12]，No.66 openEuler 云原生基础镜像集\[13]，感兴趣的同学可以选择这些题目与导师一起讨论，一起学习。

## 总结

使用精简过后的 openEuler 基础镜像，“磐舟”容器平台在生产环境下首次拉取、推送 Base 镜像以及冷启动应用的时间平均缩短了 5 秒，同时降低了存储需求，提高了业务弹性响应速度，为后续 GitOps、FaaS 等新型应用场景的落地奠定了基础。Cloud Native SIG 也将持续聚焦该方面的工作，为 openEuler 云原生设施打下更好的基础。最后，欢迎加入我们Cloud Native SIG\[14]一起讨论、共建云原生生态。

### 参考资料

\[1]

openeuler-os-build: *https://gitee.com/openeuler/openeuler-os-build*

\[2]

kiwi: *https://github.com/OSInside/kiwi*

\[3]

镜像依赖分析工具 idl: *https://gitee.com/meilier/idl*

\[4]

woqidaideshi: *https://gitee.com/woqidaideshi*

\[5]

src-openeuler/libreport 分离 libreport-filesystem 软件包: *https://gitee.com/src-openeuler/libreport/issues/I1SY6B*

\[6]

src-openeuler/dnf dnf 移除依赖 deltarpm: *https://gitee.com/src-openeuler/dnf/issues/I1SY58*

\[7]

Universal Base Image: *https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image*

\[8]

镜像依赖分析工具 idl: *https://gitee.com/meilier/idl*

\[9]

openeuler-os-build: *https://gitee.com/openeuler/openeuler-os-build/blob/master/script/config/docker\_image/config.xml*

\[10]

这里: *https://gitee.com/organizations/openeuler-embedded/projects*

\[11]

distroless: *https://github.com/GoogleContainerTools/distroless*

\[12]

No.63 openEuler 基础镜像优化: *https://gitee.com/openeuler-competition/summer-2021/issues/I3EM49?from=project-issue*

\[13]

No.66 openEuler 云原生基础镜像集: *https://gitee.com/openeuler-competition/summer-2021/issues/I3EN2R?from=project-issue*

\[14]

Cloud Native SIG: *https://gitee.com/openeuler/cloudnative*
