# [用 openEuler 内核构建支持泰山服务器的 Gentoo 系统](https://mp.weixin.qq.com/s/rvCttFz9JPq0kSa4eZV6lA)

原创*马全一*[OpenAtom openEuler](javascript:void%280%29;)*2020-05-03 18:34:01*

openEuler 是华为在 2019 年 12 月 31 日开源的 Linux 操作系统，它的 20.03 LTS 版本基于内核 4.19.95 版本，是目前对鲲鹏系列服务器支持最好的 Linux 发行版。还是用习惯了 Gentoo ，决定用 U 盘做一个基于 openEuler 内核的 Gentoo 系统去测试 Taishan 2280 的服务器。

### **在 amd64 架构的 Gentoo 系统中构编译 aarch64 的环境**

首先需要在 x86 的环境下准备 `aarch64` 的交叉编译环境。Gentoo 下的交叉环境构建是使用 `crossdev` 工具，所以先通过 emerge 命令进行安装。

```
emerge -avt sys-devel/crossdev
```

修改配置文件的内容，主要是生成的交叉编译工具链的存储位置。如果没有对应的目录，通过 `mkdir -pv /usr/local/portage-crossdev` 命令创建目录。

```
[crossdev]location = /usr/local/portage-crossdevpriority = 10masters = gentooauto-sync = no构建 aarch64 的交叉编译工具链
```

```

```

```
crossdev --stable -t aarch64-unknown-linux-gnu --init-target -oO /usr/local/portage-crossdevecho "cross-aarch64-unknown-linux-gnu/gcc cxx multilib fortran -mudflap nls openmp -sanitize -vtv" >> /etc/portage/package.use/crossdevcrossdev --stable -t aarch64-unknown-linux-gnu -oO /usr/local/portage-crossdev
```

通过 `gcc` 命令确定是否安装正确

```

```

```
gcc-config -laarch64-unknown-linux-gnu-gcc --versionaarch64-unknown-linux-gnu-c++ --versionaarch64-unknown-linux-gnu-g++ --version
```

在 `make.conf` 文件中加入编译参数，同时将 `static-libs` 和 `static-user` 加入到 `QEMU` 和依赖包中。

```

```

```
echo 'QEMU_SOFTMMU_TARGETS="alpha aarch64 arm i386 mips mips64 mips64el mipsel ppc ppc64 s390x sh4 sh4eb sparc sparc64 x86_64"' >> /etc/portage/make.confecho 'QEMU_USER_TARGETS="alpha aarch64 arm armeb i386 mips mipsel ppc ppc64 ppc64abi32 s390x sh4 sh4eb sparc sparc32plus sparc64"' >> /etc/portage/make.confecho app-emulation/qemu static-user >> /etc/portage/package.use/qemuecho dev-libs/glib static-libs >> /etc/portage/package.use/glibecho sys-libs/zlib static-libs >> /etc/portage/package.use/zlibecho sys-apps/attr static-libs >> /etc/portage/package.use/attrecho dev-libs/libpcre static-libs >> /etc/portage/package.use/libpcreemerge -avt app-emulation/qemu
```

```
使用 quickpkg 命令构建 QEMU 的二进制包
```

```
quickpkg app-emulation/qemu
```

启用 `binfmt_misc` 并注册 `aarch64` 架构

```
[ -d /proc/sys/fs/binfmt_misc ] || modprobe binfmt_misc[ -f /proc/sys/fs/binfmt_misc/register ] || mount/ binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_miscecho ':aarch64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7:\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:/usr/bin/qemu-aarch64:' > /proc/sys/fs/binfmt_misc/register
```

启用 `qemu-binfmt`

```

```

```
rc-service qemu-binfmt startrc-update add qemu-binfmt default
```

```
最后在 mount 命令中检查 binfmt_misc 是否存在
```

```
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,nosuid,nodev,noexec,relatime)
```

### **准备安装介质**

使用 `fdisk` 命令格式化硬盘，创建 `efi` 和 `root` 两个分区

```
gentoo-amd64 ~ # fdisk /dev/sdbWelcome to fdisk (util-linux 2.35.1).Changes will remain in memory only, until you decide to write them.Be careful before using the write command.Command (m for help): pDisk /dev/sdb: 1.84 TiB, 2000398934016 bytes, 3907029168 sectorsDisk model: Portable SSD T5Units: sectors of 1 * 512 = 512 bytesSector size (logical/physical): 512 bytes / 512 bytesI/O size (minimum/optimal): 512 bytes / 512 bytesDisklabel type: gptDisk identifier: DF2FC989-B32E-4885-8341-363663A4ABEFCommand (m for help): nPartition number (1-128, default 1):First sector (34-3907029134, default 2048):Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-3907029134, default 3907029134): +256MCreated a new partition 1 of type 'Linux filesystem' and of size 256 MiB.Partition #1 contains a vfat signature.Do you want to remove the signature? [Y]es/[N]o: YThe signature will be removed by a write command.Command (m for help): tSelected partition 1Partition type (type L to list all types): 1Changed type of partition 'Linux filesystem' to 'EFI System'.Command (m for help): nPartition number (2-128, default 2):First sector (526336-3907029134, default 526336):Last sector, +/-sectors or +/-size{K,M,G,T,P} (526336-3907029134, default 3907029134):Created a new partition 2 of type 'Linux filesystem' and of size 1.8 TiB.Partition #2 contains a vfat signature.Do you want to remove the signature? [Y]es/[N]o: YThe signature will be removed by a write command.Command (m for help): tPartition number (1,2, default 2): 2Partition type (type L to list all types): 25Changed type of partition 'Linux filesystem' to 'Linux root (ARM-64)'.Command (m for help): pDisk /dev/sdb: 1.84 TiB, 2000398934016 bytes, 3907029168 sectorsDisk model: Portable SSD T5Units: sectors of 1 * 512 = 512 bytesSector size (logical/physical): 512 bytes / 512 bytesI/O size (minimum/optimal): 512 bytes / 512 bytesDisklabel type: gptDisk identifier: DF2FC989-B32E-4885-8341-363663A4ABEFDevice      Start        End    Sectors  Size Type/dev/sdb1    2048     526335     524288  256M EFI System/dev/sdb2  526336 3907029134 3906502799  1.8T Linux root (ARM-64)Filesystem/RAID signature on partition 1 will be wiped.Filesystem/RAID signature on partition 2 will be wiped.Command (m for help): wThe partition table has been altered.Calling ioctl() to re-read partition table.Syncing disks.
```

格式化磁盘

```
mkfs.ext4 /dev/sdb2mkfs.vfat -F 32 /dev/sdb1
```

挂载格式化后的分区到安装目录

```
mount /dev/sdb2 /mnt/gentoomkdir -p /mnt/gentoo/boot/efimount /dev/sdb1 /mnt/gentoo/boot/efimount/dev/sdb2 on /mnt/gentoo type ext4 (rw,relatime)/dev/sdb1 on /mnt/gentoo/boot/efi type vfat (rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro)
```

到开源镜像站点下载 `stage3` 文件到安装的根目录并解压

```
cd /mnt/gentoo/links https://mirrors.163.comtime tar xvf stage3-arm64-20191124.tar.bz2
```

拷贝 `repos.conf` 的配置，并修改 `rsync` 的镜像源为

```
rsync://rsync.cn.gentoo.org/gentoo-portagemkdir --parents /mnt/gentoo/etc/portage/repos.confcp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
```

拷贝 DNS 解析文件到安装目录，加载系统目录

```

```

```
cp -v /etc/resolv.conf /mnt/gentoo/etc/mount --types proc /proc /mnt/gentoo/procmount --rbind /sys /mnt/gentoo/sysmount --rbind /dev /mnt/gentoo/devmount --rbind /dev/pts /mnt/gentoo/dev/pts
```

### **切换环境安装 Gentoo 系统**

切换到安装环境，设置盘符以区分安装环境和系统环境，并更新 `portage`

```
chroot /mnt/gentoo /bin/bashsource /etc/profileexport PS1="(chroot) ${PS1}"time emerge-webrsynctime emerge --sync
```

编辑 `make.conf` 文件

```

```

```
# These settings were set by the catalyst build script that automatically# built this stage.# Please consult /usr/share/portage/config/make.conf.example for a more# detailed example.COMMON_FLAGS="-O2 -pipe"CFLAGS="${COMMON_FLAGS}"CXXFLAGS="${COMMON_FLAGS}"FCFLAGS="${COMMON_FLAGS}"FFLAGS="${COMMON_FLAGS}"# WARNING: Changing your CHOST is not something that should be done lightly.# Please consult https://wiki.gentoo.org/wiki/Changing_the_CHOST_variable before changing.CHOST="aarch64-unknown-linux-gnu"# NOTE: This stage was built with the bindist Use flag enabledPORTDIR="/usr/portage"DISTDIR="/usr/portage/distfiles"PKGDIR="/usr/portage/packages"# This sets the language of build output to English.# Please keep this setting intact when reporting bugs.LC_MESSAGES=CMAKEOPTS="-j41"GENTOO_MIRRORS="https://mirrors.tuna.tsinghua.edu.cn/gentoo"EMERGE_DEFAULT_OPTS="--ask --verbose=y --keep-going --with-bdeps=y --load-average"LINGUAS="en_US zh_CN en zh"ACCEPT_KEYWORDS="*"ACCEPT_LICENSE="*"FEATURES="-pid-sandbox"# LanguageLINGUAS="en_US zh_CN en zh"# PythonPYTHON_TARGETS="python2_7 python3_6"# RubyRUBY_TARGETS="ruby25 ruby26 ruby27"# GRUP UEFIGRUB_PLATFORM="arm64-efi"# QEMUQEMU_SOFTMMU_TARGETS="alpha aarch64 arm i386 mips mips64 mips64el mipsel ppc ppc64 s390x sh4 sh4eb sparc sparc64 x86_64"QEMU_USER_TARGETS="alpha aarch64 arm armeb i386 mips mipsel ppc ppc64 ppc64abi32 s390x sh4 sh4eb sparc sparc32plus sparc64"
```

设置时区和中文语言支持

```

```

```
echo "Asia/Shanghai"  > /etc/timezonetime emerge --config sys-libs/timezone-datanano -w /etc/locale.genen_US.UTF-8 UTF-8zh_CN.UTF-8 UTF-8zh_CN.GBK GBKzh_CN.GB2312 GB2312zh_CN.GB18030 GB18030locale-gen
```

```
下载内核源代码、编译工具 genkernel 和其它的依赖工具，提前下载 openEuler 的内核并拷贝到 /usr/src 目录下。
```

```

```

```
time emerge --ask gentoo-sources sys-kernel/linux-firmware genkernel vim wget links curl dev-vcs/git sys-boot/grub:2 efibootmgr
```

下载生成 `fstab` 的脚本工具，并生成 `/etc/fstab` 配置文件，通过 `blkid` 命令使用 `UUID` 切换

```
wget https://raw.githubusercontent.com/YangMame/Gentoo-Installer/master/genfstabchmod +x genfstab./genfstab / > /etc/fstab
```

使用 `make` 的编译命令编译和安装内核，`genkernel` 命令可能会不执行不编译 `dtbs` 部分 。

```

```

```
cd /usr/srctime unlink linuxtime ln -s openEuler linuxtime cd linuxtime make cleantime make distcleantime make openeuler_defconfigtime make menuconfigtime make -j$(nproc) Image modules dtbstime make installtime make modules_installtime make dtbs_install
```

```
使用 grub 安装 EFI 启动，efibootmgr 用于在泰山服务器上启动后添加启动项。
```

```
grub-install --target=arm64-efi
```

设置密码、主机名和安装必备软件并设置启动项目

```
passwdtime emerge -avt net-misc/dhcpcd app-misc/livecd-toolstime emerge -avt syslog-ng gentoolkittime rc-update add sshd defaultrc-update add syslog-ng defaultrc-update add dhcpcd defaultvim /etc/conf.d/hostname
```

退出安装环境，用安装介质启动泰山服务器

```
exitumount /mnt/gentoo/dev/ptsumount /mnt/gentoo/devumount /mnt/gentoo/procumount /mnt/gentoo/boot/efiumount /mnt/gentoo/bootumount /mnt/gentoo
```
