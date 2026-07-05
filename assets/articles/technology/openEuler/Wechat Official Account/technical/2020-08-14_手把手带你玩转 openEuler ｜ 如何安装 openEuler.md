# [手把手带你玩转 openEuler ｜ 如何安装 openEuler](https://mp.weixin.qq.com/s/vNkmwHu6YS59WEBrmNWpSg)

原创*t.feng*[OpenAtom openEuler](javascript:void%280%29;)*2020-08-14 17:50:32*

## 【openEuler 简介】

> **openEuler\[1] 是一个开源、免费的 Linux 发行版平台，通过开放的社区形式与全球的开发者共同构建一 个开放、 多元和架构包容的软件生态体系。**
> 
> **同时，openEuler 也是一个创新的平台，鼓励任何人在该平台上提出新想法、开拓新思路、实践新方案。**

## 【学习目标】

- **openEuler 原生系统的启动和安装**
- **参与贡献 openEuler**

## 【环境准备】

> **工欲善其事，必先利其器。首先，我们需要做一些 openEuler 安装的环境准备。**

**1. 操作系统：`Windows 10 （64位）`**

使用我们最常用的操作系统，为安装 openEuler 的相关工具提供基础运行环境。

**2. 虚拟机：`Oracle VM VirtualBox`**

`VirtualBox` 是由 Oracle 开发的一款针对 x86 硬件的虚拟机，为 openEuler 提供了安装、运行、配置等环境。

在 VirtualBox 官网\[2] 下载 Windows 版本 的 VirtualBox，本文主要以 `6.1.12 platform` 为例来介绍 openEuler 的安装过程。

**3. openEuler 镜像：`openEuler-20.03-LTS-x86_64-dvd.iso`**

openEuler 镜像提供了完整的 openEuler ，目前架构支持 `X86_64` 和 `aarch64`。

在 `openEuler 开源社区`获取 openEuler 镜像 repo 源\[3]，选择 openEuler-20.03-LTS-x86\_64-dvd.iso\[4] 下载。

## 【安装体验】

> **万事俱备，只欠东风。在环境和工具准备完毕后，我们就可以进入正题——openEuler 的安装。**

### 1. openEuler 的安装模式

openEuler 提供了 2 种安装模式，以应对不同的场景需求：

- **文本模式**：适用于服务器场景。
- **图形模式**：适用于服务器和 PC 场景，有一定的软硬件约束，需要提供显卡和图形驱动的支持。

> **接下来，将主要介绍在图形模式下安装 openEuler 的过程。在此之前，我们需要先安装 Virtual Box 虚拟机，来运行 openEuler 所需的安装环境。**

### 2. Virtual Box VM 安装

##### 1) 建立 openEuler 的启动项

打开下载完成的 Oracle VM VirtualBox，新建 `openEuler 启动环境`。

在 `工具` 选项卡中，点击 `新建` 按钮，选择`新建虚拟电脑`；设置 openEuler 名称、VM 目录及 Windows 版本，由于系统版本默认是 `Windows 7`，我们需要手动选择 `Windows 10（64-bit）`。

##### 2) 分配内存

VirtualBox 会视当前设备的配置而`自动建议分配`内存大小，一般使用建议的内存分配大小，后面也可以根据实际使用情况来手动调整。

##### 3) 新建虚拟硬盘

勾选 `现在创建虚拟硬盘`选项来新建虚拟硬盘，`文件类型`选择 `VDI（VirtualBox 磁盘映像）`；`分配模式`选择 `动态分配`；`文件位置和大小`选择`默认`即可。

> **openEuler 启动环境新建完成后，还需要对虚拟机的启动项进行一些基本的设置**。

##### 4) 基本设置

- **存储**：引用 openEuler 的 ISO 镜像。
- **系统 - 主板 - 启动顺序**：确保`第一顺序`设置为 `光驱` ，防止引用到硬盘上其他 ISO。

> **到这里，Virtual Box 虚拟机环境和 openEuler 启动项的设置基本完成，部分偏好设置可根据自身的情况进行调整，点击右侧的`启动`按钮，就可以进入 openEuler 的安装阶段。**

### 3. openEuler 安装

##### 1) 选择启动盘

点击`文件夹图标`，`注册/新建`一个 ISO 镜像引用，然后选择下载好的 `openEuler ISO` 镜像，点击`启动`。

##### 2) 安装 openEuler 20.03-LTS

选择 `Install openEuler 20.03-LTS`，按下`回车键`进行安装。其中，`Test media` 是用来进行文件完整性校验，防止 ISO 文件内容的缺失，通常情况下，选择直接安装即可。

首先来到 openEuler 欢迎界面，这里的语言选择指的是`安装过程中的语言环境`，选择简体中文的语言环境，点击`继续`。

然后进入安装信息摘要界面，针对 OS 环境进行一些配置：

- **本地化**：语言代表着安装完成后的 `OS 语言环境`；时间和日期代表着时区，默认是上海。
- **软件**：安装源代表着光驱内的我们下载的 `ISO` 镜像，可以作为`自动安装介质`使用；软件选择代表着当前环境附加的功能，一般我们选择默认的`最小安装`，来保证拥有基本的核心功能。
- **系统**：安装位置代表着 openEuler 的安装磁盘对应位置，确认好磁盘，点击`完成`将`自动分区`；网络和主机名代表着网络的连接，我们需要确保以太网处于连接状态。

安装信息确认后，我们点击`开始安装`，可以看到 openEuler 的安装进度。

在等待安装时，我们还能够设置 `Root 密码`，将在后续的系统登录中使用到，密码规范需要三种以上的字符类型，设置完毕后点击`完成`，当看到界面中的红色警告消失，说明密码设置成功。

在安装完成之后，需要重新启动系统。我们`关闭电源`，依次打开启动项 - 设置 - 系统 - 主板 - `启动顺序`，将`硬盘`提升到第一启动顺序，同时也可以删除 ISO 镜像引用。再次启动系统，在短暂的进程等待后，输入 Root 密码，我们就可以进入并使用 openEuler 了。

由此可见，openEuler 的图形模式安装简单快速，易于上手。

### 4. openEuler 的启动流程

学习了 openEuler 的安装，我们再了解一下 openEuler 的启动模式和流程。

针对不同的架构，openEuler 提供的启动模式也不同。`X86` 架构包含 `Legacy` 和 `UEFI` 模式，而 `ARM` 架构目前只包含 `UEFI` 模式。

上文中的安装启动流程，就是采用的 `Legacy` 模式。经 `BootLoader` 最终到硬盘引导的 `GURB2`, `GURB2` 引导内核 `Kernel` - `initrd` - `systemd`进程，最后启动 openEuler 社区目前维护的程序 `ANACONDA`。

### 5. openEuler 自动化安装

> **除了图形安装模式，openEuler 社区还提供了`文本模式`的 `自动化安装`，以及各类`虚拟机配置`，方便 DIY 爱好者使用。**

##### openEuler 支持 `pxe` 自动化安装部署，具体流程如下图所示，环境除了物理/虚拟机和 ISO 镜像外，还需要用来存放 `kickstart` 文件 的 `httpd` 和 提供 `vmlinuz` 与 `initrd` 文件的 `tftp` 服务器，以及 `kickstart` 的自定义安装配置。

##### 1) 安装之前，需要确保 http 服务器的`防火墙`处于`关闭`状态，使用防火墙关闭指令：

```
iptables -F
```

##### 2) `httpd` 的安装与服务启动

```
# dnf install httpd -y# systemctl start httpd# systemctl enable httpd
```

##### 3) `tftp` 的安装与配置

```
# dnf install tftp-server -y# vim /etc/xinetd.d/tftpservice tftp{socket_type = dgramprotocol = udpwait = yesuser = rootserver = /usr/sbin/in.tftpdserver_args = -s /var/lib/tftpbootdisable = noper_source = 11cps = 100 2flags = IPv4}# systemctl start tftp# systemctl enable tftp# systemctl start xinetd# systemctl status xinetd# systemctl enable xinetd
```

##### 4) 安装源的制作

```
# mount openEuler-20.03-LTS-aarch64-dvd.iso /mnt# cp -r /mnt/* /var/www/html/openEuler/
```

##### 5) `openEuler-ks.cfg` 的设置和修改，`kickstart` 配置文件可根据实际需求进行额外的更改

```
#vim  /var/www/html/ks/openEuler-ks.cfg====================================***以下内容根据实际需求进行修改***#version=DEVELignoredisk --only-use=sdaautopart --type=lvm# Partition clearing informationclearpart --none --initlabel# Use graphical installgraphical# Keyboard layoutskeyboard --vckeymap=cn --xlayouts='cn'# System languagelang zh_CN.UTF-8#Use http installation sourceurl  --url=//192.168.122.1/openEuler/%post#enable kdumpsed  -i "s/ ro / ro crashkernel=1024M,high /" /boot/efi/EFI/openEuler/grub.cfg%end...
```

##### 6）`kickstart` 自定义安装配置

##### a. 获取 ks 配置文件

- 手动安装完成之后，在 `/root` 目录下会自动生成 `anaconda-ks.cfg` 文件

##### b. 指定 ks 文件

- 启动参数添加：`inst.ks=[http|ftp|nfs]://path`

##### 7) 修改 `pxe` 配置文件 `grub.cfg`，以下配置内容可供参考

```
# cp -r /mnt/images/pxeboot/* /var/lib/tftpboot/# cp /mnt/EFI/BOOT/grubaa64.efi /var/lib/tftpboot/# cp /mnt/EFI/BOOT/grub.cfg /var/lib/tftpboot/# ls /var/lib/tftpboot/grubaa64.efi  grub.cfg  initrd.img  TRANS.TBL  vmlinuz# vim /var/lib/tftpboot/grub.cfgset default="1"function load_video {  if [ x$feature_all_video_module = xy ]; then    insmod all_video  else    insmod efi_gop    insmod efi_uga    insmod ieee1275_fb    insmod vbe    insmod vga    insmod video_bochs    insmod video_cirrus  fi}load_videoset gfxpayload=keepinsmod gzioinsmod part_gptinsmod ext2set timeout=60### BEGIN /etc/grub.d/10_linux ###menuentry 'Install openEuler 20.03 LTS' --class red --class gnu-linux --class gnu --class os {        set root=(tftp,192.168.1.1)        linux /vmlinuz ro inst.geoloc=0 console=ttyAMA0 console=tty0 rd.iscsi.waitnet=0 inst.ks=http://192.168.122.1/ks/openEuler-ks.cfg        initrd /initrd.img}
```

##### 8) DHCP 的配置（可以使用 dnsmasq 代替 ）

```
# dnf install dhcp -y## DHCP Server Configuration file.#   see /usr/share/doc/dhcp-server/dhcpd.conf.example#   see dhcpd.conf(5) man page## vim /etc/dhcp/dhcpd.confddns-update-style interim;ignore client-updates;filename "grubaa64.efi"; 　　 # pxelinux 启动文件位置;next-server 192.168.122.1;　　# (重要)TFTP Server 的IP地址;subnet 192.168.122.0 netmask 255.255.255.0 {option routers 192.168.111.1; # 网关地址option subnet-mask 255.255.255.0; # 子网掩码range dynamic-bootp 192.168.122.50 192.168.122.200; # 动态ip范围default-lease-time 21600;max-lease-time 43200;}# systemctl start dhcpd# systemctl enable dhcpd
```

##### 9) 在 `Start boot option` 界面按下 `F2` 选择从网络 pxe 启动，开始自动化安装

> **openEuler 提供的文本模式下 pxe 自动化安装，充分满足了 DIY 爱好者的需求，同时还提供了简易快速，便于上手的图形安装模式，以此来面向不同场景和人群。在了解 openEuler 安装、启动流程后，跟着文中的步骤，一起来体验开放多元的 openEuler！**

## 【参与贡献 openEuler】

#### 1. 关于 openEuler

> **openEuler 的愿景：通过社区合作，打造创新平台，构建支持多处理器架构、统一和开放的操作系统 openEuler，推动软硬件生态繁荣发展。**

**目前 openEuler 正处于升级 SIG 的阶段，对以下模块感兴趣的朋友可以一起参与进来：**

- `anaconda/lorax/pykickstart/python-blivet`
- `grub2/syslinux`
- `yum/dnf`

**也可以在码云 gitee 的 openEuler 社区\[5] 中贡献力量：**

- `Fork the project`
- `Checkout the branch`
- `Commit your code`
- `Pull request`

### 参考资料

\[1]

openEuler: *https://openeuler.org/zh/*

\[2]

VirtualBox 官网: *https://www.virtualbox.org/wiki/Downloads*

\[3]

openEuler 镜像 repo 源: *https://repo.openeuler.org/openEuler-20.03-LTS/*

\[4]

openEuler-20.03-LTS-x86\_64-dvd.iso: *https://repo.openeuler.org/openEuler-20.03-LTS/ISO/x86\_64/openEuler-20.03-LTS-x86\_64-dvd.iso*

\[5]

openEuler 社区: *https://gitee.com/openeuler*

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbeeNmmjicwJg2kFFXmMtNkERtUeqOzKc4WRBJa9W2RzM0NYlibbbNqU6PibibMojVp24lx2LUjGBrMMg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibOspOSKHic8Nh8icmf9xozgIK5j5ibJibMLzCLhbSoicDQOrVDQpZKX2nkBA/640?wx_fmt=png)

***观众老爷们不考虑点一波关注***

***支持一下吗？***

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbR3YNaNBytF0uqAicKL7fRD0JJj1HibCo2Sic0qxQ1LkZPlLqibMPxWUBBGeOOicicX3yY8e2icz81TU7Fg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYCjA16Qbj8RtLq6ZdzGlsR9Llaa49Bia9A8SlgicOgPZoDYZB2pxuLtp7FkmXvaIoZHRBUkAB6hA7w/640?wx_fmt=png)
