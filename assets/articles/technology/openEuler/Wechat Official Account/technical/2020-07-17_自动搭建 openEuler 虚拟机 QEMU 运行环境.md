# [自动搭建 openEuler 虚拟机 QEMU 运行环境](https://mp.weixin.qq.com/s/SeN77RGltpFy6hSDeMOn7w)

*罗宇哲*[OpenAtom openEuler](javascript:void%280%29;)*2020-07-17 20:54:09*

*作者：罗宇哲，中国科学院软件研究所智能软件研究中心*

本文介绍了一个自动搭建 openEuler 虚拟机 QEMU 运行环境的脚本使用方法，本脚本能下载并安装各种依赖项，自动下载并编译安装 QEMU4.1.1 和 busybox 1.25.1，下载并安装对 Linux 4.19.1 进行 ARM64 交叉编译并用 gdb 进行调试的环境.

该环境能帮助我们理解 openEuler 内核的运行，以及下载和 QEMU 环境下安装 openEuler1.0 版。

本脚本参考了前辈\[1]在 ARM32 位环境下对 Linux Kernel 的交叉编译脚本，特此感谢！我们修改了 QEMU、busybox 和 Linux kernel 的版本和根文件系统搭建的方法，增加了依赖项，并将 ARM 交叉编译环境和 gdb 改为了64位，而且增加了 openEuler 的相关内容。

**openEuler虚拟机运行环境搭建**

环境准备：在 VMware 15.1.0 或 VirtualBox 6.10 上搭建 Ubuntu 18.04 虚拟机，建议分配硬盘大小 120G，内存大小 2G 以上。

自动搭建脚本码云地址

***https://gitee.com/luoyuzhe/openEulerInstallation***

运行脚本之间请手动更改下载源为国内源！否则下载较慢，更改源的方式参考\[3]。

###### **脚本运行流程**

**sudo ./prepare.sh**

**source \\~/.bashrc**

**sudo ./build.sh**

**# 做完这一步 ARM64 交叉编译环境、Linux Kernel 4.19.1、busybox 和 QEMU 以及依赖项应该都装好了。**

**sudo ./start-qemu.sh**

**# 进行无 gdb 调试 Linux Kernel 4.19.1 或者 sudo./start-qemu-gdb.sh 之后另开一个窗口， aarch64-linux-gnu-gdb 进入 gdb 界面，再输入 target remote localhost:1234 进入调试阶段，在 gdb 窗口输入c就可以切换到 QEMU 窗口运行。**

**sudo ./start-qemu.sh 执行后：**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibLIJJWg0Pu9xEwKMSZ329VLYKAkEVQ12EWEMkepXxSQw0KgwNdePVsA/640?wx_fmt=jpeg)

**开启 gdb 运行后：**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibJYU3Xiagnm5XXGISkeIZ7UUmT7uHvUaP3Gb51PtjzKOFAfiaOR5K5mwg/640?wx_fmt=jpeg)

###### **Prepare.sh 脚本功能介绍**

该脚本用于下载并解压 64 位 ARM 交叉编译工具、QEMU-4.1.1 和 openEuler 镜像，此外，它还会通过 apt install 安装依赖项。该脚本会检查压缩包是否存在，若存在不会重复下载解压。

**下载 openEuler 镜像：**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibNNzyuA94iaTea4uYzCWNZovGhVUTVGfaU7naxM8brcNAKRibEwxP3ZBQ/640?wx_fmt=png)

**下载并解压交叉编译 GCC，设置环境变量：**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibx0zaDZ0kENtu5rDVB3cnTMicAic13hhZ5j3xp1YU4SEpsHMeeShZicX4g/640?wx_fmt=jpeg)

**安装依赖项：**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibsvWuF74r2lfWjic8HsaEI3lY7pLBECQZH0mILDTeJXEQm7buCvk9ItQ/640?wx_fmt=png)

**下载并安装QEMU-4.1.1:**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibn52HOF3SSVjL9Uk2Xwn9yadXd2tj4EUD5U79OFvIRMZibty41qWoa1g/640?wx_fmt=png)

**下载 QEMU UEFI 启动固件并生成 img 文件，大小可以分配：**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibKwRpKMNvSLh0cqHsDDKVCq8Eo8rhRsWMSDCukWTZqZz4LWHknkuPiag/640?wx_fmt=png)

###### **Build.sh 脚本功能介绍**

下载并编译 Linux Kernel 4.19.1，下载并编译 busybox 1.25.1，制作根文件系统。架构和版本可以通过文件开头的参数进行设置。

**下载并编译 Linux Kernel 4.19.1 版：**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibwBZ3tyZdgcujCfGxUXXiaVmP1aPIpUAS5G77B82QiaR7ktDN1DdHzicPw/640?wx_fmt=jpeg)

**把编译好的 image 文件 copy 到目标文件夹：**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibS7Y3eCg3rJOEbUQRia6yJkvHBuDvuSdpdcziadbloyf06icpYXdRibYNAw/640?wx_fmt=png)

**下载并解压 busybox:**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibQWW0kpMWAic2xeicpZ6LkB6m5xBlEQvst9NbDzRoiaq07M3rcEiamT9xwQ/640?wx_fmt=jpeg)

**编译安装 busybox:**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibsxn6hIibZJngxFYViaRdIs7J6VSploUSic7UsH7RUuSbJ22uS6veVLPqw/640?wx_fmt=png)

**制作根文件系统：**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ib9iciaCsh7lTGr7aSpXwUmPxgR1qkrIouZ102ghBCXWvwonibFthpHZalg/640?wx_fmt=jpeg)

###### **QEMU 启动脚本介绍**

**start-qemu.sh: qemu 普通启动。**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibm5fOk478RMwsib1RmSeQvJczKwGzQydqiaTzWCWFmN06wGN0RVKkqEeQ/640?wx_fmt=png)

**start-qemu-gdb.sh:带 gdb 启动。**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibUvJyCbctzE5PEGNmY5YfXBIWf4azNwFOcY0vZMUP5wlXDwgQtsibUyg/640?wx_fmt=png)

**start-euleros.sh:用 QEMU 启动 EulerOS 镜像。**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibiaia30SwnXRFcGjsFEdTAKY60Upt4l80sPocqVmM6S4wBD6dkMuQ6Xag/640?wx_fmt=png)

**采用 gdb 模式启动的时候首先运行 sudo./start-qemu-gdb.sh 命令，然后重新启动一个 terminal，运行 aarch64-linux-gnu-gdb，输入端口号然后按 c。**

**QEMU 常见选项\[2]**

**-hda file、-hdb file、-hdc file和-hdd file**

把文件当成hard disk 0、hard disk 1、hard disk 2和hard disk 3。

**-append cmdline**

将 cmdline 作为 kernel command line，所谓 kernel command line 就是在 kernel 启动的时候，用 cmdline 对内核进行配置。比如 "root=/dev/hda"，将 /dev/hda 设置成根文件系统。

**-M machine**

选择模拟的机器 (我们可以输入 -M? 提到一个模拟的机器列表)

**-fda file/-fdb file**

使用 file 作为软盘镜像.我们也可以通过将 /dev/fd0 作为文件名来使用主机软盘。

**-cdrom file**

使用文件作为 CD-ROM 镜像(但是我们不可以同时使用 -hdc 和 -cdrom ).我们可以通过使用 /dev/cdrom  作为文件名来使用主机的 CD-ROM。

**-boot \[a|c|d]**

由软盘(a)，硬盘(c) 或是 CD-ROM(d)。在默认的情况下由硬盘启动。

**-snapshot**

写入临时文件而不是写入磁盘镜像文件.在这样的情况下,并没有写回我们所使用的磁盘镜像文件.然而我们却可以通过按下 C-a s 来强制写回磁盘镜像文件。

**-m megs**

设置虚拟内存尺寸为 megs M 字节.在默认的情况下为 128M。

**-smp n**

模拟一个有 n 个 CPU 的 SMP 系统.为 PC 机为目标,最多可以支持 255个CPU。

**-nographic**

在通常情况下,QEMU 使用 SDL 来显示 VGA 输出。使用这个选项,我们可以禁止所有的图形输出,这样 QEMU 只是一个简单的命令行程序。模拟的串口将会重定向到命令行。所以，我们仍然可以在 QEMU 平台上使用串口命令来调试 Linux 内核。

**openEuler 系统安装说明**

QEMU 安装openEuler镜像，运行完 sudo ./prepare.sh 后，运行 sudo./start\_euleros.sh，运行该脚本会执行一下命令：

**qemu-system-aarch64 -machine virt -cpu cortex-a57 -m 1024 -bios ./QEMU\_EFI.fd -cdrom openEuler-1.0-aarch64-dvd.iso -hda ./qemu\_Euler.img -serial stdio**

QEMU 会读入 openEuler 的镜像文件然后进入安装流程。选择安装 openEuler 后，选择安装模式（选择 test media 选项），之后分别配置每个前面有”\[!]”这个标记的选项，主要有 installation destination, root password 和 user password 等，注意选择的时候是先输入选项对应的数字，确定之后按回车，然后再按 c（continue）继续安装。以下是一个选择的流程，选项前面有\[x]代表选中了该选项：

###### **选择 Use text mode 选项**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ib41xOJ7pGgop5JVHPiadJL8jBOMR6LlL5fLoibRrNcOTysxbp0mN6yEXg/640?wx_fmt=png)

 **选择 Root password 选项并配置**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibsOODA8OSlnwGDQpD35fHXoynog3Lrsw9Zias4BCUHVKpyzz85m3Sefg/640?wx_fmt=jpeg)

配置完之后我们可以发现大部分之前有\[!]的选项之前都变成了\[x]。

###### **配置安装目的地**

**选择大小**：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibdVmc7VX4zrnsfblQfd5W468PxqGHOCv99R4UaDZchBNMQXuP0c1Ywg/640?wx_fmt=png)

**选择使用空间：**

**VMware：**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibDrxYb7V3COdicgqAibDLsDL8Pt4adoU2B014eXYhZlmZIy27Inh2Zxsw/640?wx_fmt=png)

**VirtualBox：**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibaaRERiceicg1vhBVAE0XicYQm6TrbF6HibMU7uaX1AjstxtXZs9Tiayk2qA/640?wx_fmt=png)

**选择 Partition 方式：**

**VMware：**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibUOS2dj6LIc8n1I3QlDeF8A3IxD3RvT5J9GoCLVEthewjbSO1Iocskg/640?wx_fmt=jpeg)

**VirtualBox：**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibNSh9UFvbbxibyd44lPqmQ0zGpeTVMx0kLcKL8tcXnLbBZt0icmIo7AOA/640?wx_fmt=png)

**配置用户账户，输入 b 完成配置**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibfa9lO7nAKSK5BSojzgFTJhrf6zicz4S92yFfibgNyeNNrXzXQkQQVibYA/640?wx_fmt=jpeg)

###### **安装完成**

**到这一步需要按一下回车然后输入之前设定的用户名和密码才行。**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibicCzIlNbUhGY0IwY1ahvY5sVITlu6Fy9rjM6n8u3yI6tEOugouL718A/640?wx_fmt=jpeg)

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibko10CAMH0UJrxwAkm75JU6CR10ghefcicZrN8RKmW3Bvd9SVfFzACqQ/640?wx_fmt=jpeg)

然后就和 Linux 的操作基本一样了~有一个问题是每次运行都要安装一次，所以装好之后最好能保存一个虚拟机快照。

***参考文献***

***\[1]https://github.com/xianjimli/qemu-arm-linux.git***

***\[2]https://blog.csdn.net/ustc\_dylan/article/details/5385691***

***\[3]https://blog.csdn.net/qq\_35451572/article/details/79516563***

***原文链接：https://blog.csdn.net/liucw900716/java/article/details/105291594***

***openEuler 官方公众号支持用户投稿***

***如果你想让自己文章让更多人看到***

***那就赶紧关注 openEuler 官方公众号吧***

***点击屏幕下方的 “我要投稿”参与吧***

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibOspOSKHic8Nh8icmf9xozgIK5j5ibJibMLzCLhbSoicDQOrVDQpZKX2nkBA/640?wx_fmt=png)

***记得分享点赞再看哦***

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbR3YNaNBytF0uqAicKL7fRD0JJj1HibCo2Sic0qxQ1LkZPlLqibMPxWUBBGeOOicicX3yY8e2icz81TU7Fg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibW7UzBsnWzxBuTy8gicmX8tnmvysnY4566KXpkQC9vMpAh6HmR0B8B9g/640?wx_fmt=png)
