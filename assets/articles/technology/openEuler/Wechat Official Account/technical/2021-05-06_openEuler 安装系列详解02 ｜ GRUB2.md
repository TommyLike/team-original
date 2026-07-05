# [openEuler 安装系列详解02 ｜ GRUB2](https://mp.weixin.qq.com/s/20I22isyQ33erqkn15W77A)

原创*bitcoffee*[OpenAtom openEuler](javascript:void%280%29;)*2021-05-06 20:00:00*

上篇文章我们介绍了操作系统引导过程中的BIOS与磁盘分区表的内容，也提到了bootloader，bootloader作为BIOS与OS之间的桥梁，在BIOS完成引导的部分工作退出后，由bootloader担负起启动内核的重任。在openEuler中，我们使用的系统加载器主要有两个：syslinux以及GRUB2。syslinux仅在使用光盘安装X86 BIOS legacy的机器时使用，其他情况下均使用GRUB2作为默认的系统加载器，所有我们着重介绍下GRUB2

GRUB（GRand Unified Bootloader）是GNU下的FSF组织所推行的一套多重开机管理软件，目前 GRUB 分成 GRUB legacy 和 GRUB 2。版本号是 0.9x 以及之前的版本都称为 GRUB Legacy ，从 1.x 开始的就称为 GRUB 2。GRUB Legacy 已经停止开发了，处于一个只修复bugfix的状态，不再增加新的功能了，所有的开发都转移到GURB2之上了。

## legacy下的GRUB2引导

MBR格式有两种方式安装GURB：

- 嵌入到MBR和第一个分区中间的空间，它们大致需要31kB的空间，所以需要确保硬盘的第一个分区开始于31KB以后的位置并且这段空间不会被其他软件所覆写。
- 将core.img安装到某个文件系统中，然后使用分区的第一个block存储启动它的代码。但这样的grub数据安全性会比较脆弱。例如，文件系统的某些特性需要做尾部包装，它们可能会移动这些block。

GRUB开发团队建议将GRUB嵌入到MBR和第一个分区之间，除非有特殊需求，但仍必须要保证第一个分区至少是从第31kB(第63个扇区)之后才开始创建的。好在现在的磁盘设备，一般都会有分区边界对齐的性能优化提醒，所以第一个分区可能会自动从第1MB处开始创建。在openEuler中，分区的第一个分区就是从磁盘的2048个扇区开始的。

bootloader程序的布局：

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZaDvjBweicHyopmZYXVRqq7IAsTCl41ZiabGl5fV5U5auiauKU4fquY8z792aRPT3ia8H5eg2aVPZs5Q/640?wx_fmt=jpeg)

从leagcy模式下启动内核，bootloader至少包含两块二进制的程序代码，分别是boot.img与core.img。

boot.img是grub启动的第一个程序，之前我们介绍过MBR分区表在首个扇区512字节中，前446个字节是bootloader程序，这部分其实就是boot.img 因为BIOS bootloader的第一部分最大为446字节，这块空间的大小极大的限制了boot.img程序的功能，所以它无法理解文件系统，core.img的位置是硬编码在boot.img中的。boot.img中唯一做的事情就是读取core.img的第一个扇区，并将控制权移交给core.img并由core.img来完成加载内核的操作。但由于core.img位置硬编码在boot.img中，所以如果移动了core.img在磁盘上的位置而没有重新生成boot.img，很可能会导致操作系统启动失败。

core.img中主要包含三个部分的内容：

1. 第一个部分的内容是一个与启动方式有关的程序，可分为磁盘启动（diskboot.img），光盘启动（cdboot.img）和pxe启动（pxeboot.img）。diskboot.img和cdboot.img的主要功能为读取core.img中剩余的部分到内存中，并将程序控制权移交到kernel.img中。此时因为还不能读取到文件系统，所以此时kernel.img中所有的位置以block列表的方式编码并供程序读取。
2. kernel.img中包含了grub基本运行时环境，包括设备框架，文件句柄，环境变量，救援模式等，此时的kernel.img并不是系统内核，而是用于运行grub命令行的基础环境。
3. modules中保存了各种功能模块，因为GRUB2大量使用了动态功能模块，所以core.img中只保存了部分功能模块，例如文件系统读取，其他大部分功能模块均存储于存储介质上。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZaDvjBweicHyopmZYXVRqq70tFSMPrScPkHUUBENeEyhicCkCY0YFFrP1W46RnJJDOHcTrAC2Uln1w/640?wx_fmt=jpeg)

BIOS将MBR（boot.img）加载到内存的0x7c00处，boot.img会找到core.img扇区的地址，并将它拷贝到0x8000处运行，最后跳转到kernel.img在内存中的起始地址：0x8200。当kernel.img运行时，已经能够识别文件系统。它会找到磁盘中的grub.cfg文件，解析并加载内核以及initrd。最终跳转到内核空间运行。

## UEFI下的GRUB2引导与legacy引导的区别

在UEFI模式下，启动程序efi文件单独保存在独立的EFI System Partition分区中，相对于MBR需要安装在首个磁盘分区前，UEFI的安装方式更加安全可靠并且单独的分区移除了对引导程序大小的限制，所以efi程序可以做的相对于core.img大很多。在EFI下的GRUB名称变更为BOOTX64.efi或者BOOTAA64.efi（根据体系决定）。因为UEFI规范已经确定了efi文件的位置且本身具备读取vfat磁盘格式的能力，所以不再需要legacy模式中的boot.img以及diskboot.img文件，组成efi文件的主要内容为kernel.img文件以及各种modules文件 。用一句话说明，UEFI的启动文件与BIOS legacy的bootloader程序本质相同，其中都封装了kernel.img文件供GRUB启动内核时使用。

## GRUB的配置文件

grub.cfg文件是 GRUB 二进制程序读取的配置文件。OS 该怎么引导，引导磁盘中的哪 个 OS 都是由该文件配置。该文件的基本结构如下(传统风格，bls风格配置文件现在问题较多，可以在/etc/default/grub配置文件下设置GRUB\_ENABLE\_BLSCFG=false来启用传统风格配置文件)：

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZaDvjBweicHyopmZYXVRqq7iaW3XNDOZJ2ha7wSdxyDF64FPdeKtjLEGb1nib9oraeFJRvWickfGZRcA/640?wx_fmt=jpeg)

在GRUB的菜单界面中使用e可以看到详细的GRUB启动参数，实质上就是menuentry配置节点的内容。该入口配置了将要启动的OS：内核，initrd(initramfs)，cmdline等等。在正常使用过程中，grub.cfg中的配置时基于/etc/default/grub以及/etc/grub.d下的grub配置生成。GRUB官方并不建议我们直接修改grub.cfg，直接修改的grub.cfg未经过语法检查，可能会导致启动失败，且直接修改的内容在调用grub2-mkconfig重新生成配置文件后会全部被覆盖。

推荐修改相对应的配置文件，再执行下面的命令

```
grub2-mkconfig –o <config_path>
```

例如我需要在启动菜单项目的linux启动参数中新增参数rd.debug，首先在grub.cfg中看到该段配置位于/etc/grub.d/10\_linux下，找到并打开此配置文件，分析该文件生成menuentry（配置生成脚本文件本身的逻辑比较复杂，需要仔细看，此过程不详细说明该文件逻辑），可以找到linux的参数参数被单独提取出来放在了/etc/default/grub中的GRUB\_CMDLINE\_LINUX参数中：

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZaDvjBweicHyopmZYXVRqq7ZojezIVlptCjNLSgo3iasVOpgMAPpFxBHxuuy5tXsQU4q6h3DMxyu4g/640?wx_fmt=jpeg)

在其中添加需要新增的参数rd.debug，在新生成的grub.cfg中就会携带上rd.debug

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZaDvjBweicHyopmZYXVRqq7FFicNjxQZpSaG5VxguI3WtZhjs83n1rjmaakY71DNmnbpqTT7BfW0Zg/640?wx_fmt=jpeg)

grub.cfg配置文件缺失时会进入到grub命令行中：

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZaDvjBweicHyopmZYXVRqq76oibwW7GA43m9aGQBV46ZvfdlvfAHdiaZgYFQ7iaia9LfZICwkb7Bv4LaA/640?wx_fmt=jpeg)

重建grub.cfg配置文件：

```
grub2-mkconfig –o <config_path>
```

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZaDvjBweicHyopmZYXVRqq7houEFpicm4qPlp0x47xFAXyoeTwEgjUjuMmmy49cY2N0yS2DNUFkVfw/640?wx_fmt=jpeg)

## legacy模式下重新生成boot.img和core.img

对于legacy模式，在bootloader已经损坏的情况下，可以使用GRUB2-install重新生成bootloader程序

对于bootloader损坏的情况，例如以下情况：

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZaDvjBweicHyopmZYXVRqq7u52jPzeWIHZ4XF2atAvvRJJgHaupqW3icaqUkJWImGz1OWKTKubw7DA/640?wx_fmt=jpeg)

上图可见bootloader分区数据前面的一部分被覆写变成了0x00，重新执行GRUB2-install即可重新生成bootloader。

```
grub2-install /dev/sdx
```

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZaDvjBweicHyopmZYXVRqq7ML4aGsyUEWibydvwjVmpheSvHqJia0g5TNzmN829b1oR9SNHWBmy4UmQ/640?wx_fmt=jpeg)

## UEFI模式下重新生成efi文件

```
grub2-install --target=[i386-efi|arm64-efi|x86_64-efi] –efi-irectory=/boot/efi --bootloader id=openEuler
```

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZaDvjBweicHyopmZYXVRqq70RCjlqOT02pzmLLia7hzBKfcs2o7TtsYZ3TZ03HsmPyicBkcB4uZq6SQ/640?wx_fmt=jpeg)

## 设置启动项

在Legacy模式下，系统启动项有BIOS管理，BIOS在启动阶段会扫描设备，找出拥有启动项的设备：磁盘，光驱，网卡等等。在UEFI模式下，也可以通过efibootmgr去管理启动项。因为在UEFI模式下，系统启动项由UEFI统一管理。

```
efibootmgr -c -d /dev/sda -p 1 -w -L 'openEuler20.03' -l '/EFI/openEuler/grubaa64.efi'
```

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZaDvjBweicHyopmZYXVRqq7BLN4xh0LxJIhu7qxHdcW6NFYUZ8kWZAvKJcG9qvWlicUUqiaicLGNNcgg/640?wx_fmt=jpeg)

## 常用 shell 命令

1. help: 查看命令帮助 `help configfile`
2. set&unset: 设置环境变量 取消环境变量 `help root='hd0,msdos1'`
3. ls: 列出设备 `ls (hd0,msdos1)`
4. lsmod&insmod: 列出模块 加载模块 `insmod gzip`
5. linux: 加载内核 `linux /vmlinuz-xxx`
6. initrd: 加载 initrd `initrd /initramfs-xxx`
7. configfile: 加载 c fg 文件，在配置文件缺失时可以手动指定启动项 `configfile (hd0,msdos1)/efi/EFI/euleros/grub.cfg`
8. echo: 输出环境变量 `echo $root`
9. halt&reboot: 关机 重启

## 总结

因为篇幅限制，bootloader的介绍先到这里，下期我们说一说内核启动拉起initrd以及dracut的相关知识，希望大家继续关注我们的文章。

## 参考

1. https://www.gnu.org/software/grub/manual/grub/html\_node/
2. https://en.wikipedia.org/wiki/File:GNU\_GRUB\_components.svg
