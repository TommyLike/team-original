# [手把手带你玩转 openEuler ｜ openEuler 的使用](https://mp.weixin.qq.com/s/Qk8G2rs3Efqq13wdnaE_3A)

原创*syyhao*[OpenAtom openEuler](javascript:void%280%29;)*2020-08-18 19:29:43*

本文章分为四部分，教你怎么使用 openEuler，学完之后你可以了解到 openEuler 的基本配置、软件包的使用、基本语法以及服务搭建：

- 第 1 部分：openEuler 基本配置（网络配置、查看系统信息、管理用户和用户组）
- 第 2 部分：openEuler 的软件包管理（使用 DNF 管理软件包）
- 第 3 部分：systemd 基本用法（管理服务）
- 第 4 部分：服务搭建（搭建服务）

## 文档指导

**openEuler 官网文档：管理员指南**

相关文档说明可以查看 管理员指南\[1]![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLgUVibSSt72fXybsibayTkDxxAuQXqjEpNSPJV7MQ5ORN5dtcC1BlDNmQ/640?wx_fmt=png)

## 1. openEuler 基本配置

### 1.1 openEuler 基本配置之网络配置

本部分教会大家怎么去配置 openEuler 的静态 ip。如果您想了解更多的网络配置，请参考 openEuler 的网络配置文档\[2])。

这里我们使用第三方的终端软件 ssh 登录之后进行操作，这样的话终端软件的优化是比较好的，使用起来比较方便。

由于 openEuler 默认的 ip 是 DHCP 动态分配的，这个 ip 可能会变，有些需求需要 ip 是固定的，这里就需要我们将动态 ip 改成静态 ip 了，配置方法如下：

- 获取 ip：ip a

<!--THE END-->

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLhdYNgI3VD6JRYUDCGibo63roEQIWXVicWwzn6qNI9IBBicXH7f5lVL7Mg/640?wx_fmt=png)

- 通过终端软件 ssh 登录机器操作：ssh root@ip 配置静态 ip：修改 /etc/sysconfig/network-scripts/ifcfg-ens33
  
  配置如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLwB56jBT0eGxshr4JD7bR7ssf6AX994ddyg87qKiaDdAmg3GhL19kplg/640?wx_fmt=png)

设置好静态 ip 后，现在还没发生效，需要重启一下网络服务，命令行：

```
systemctl restart NetworkManager
```

### 1.2 openEuler 基本配置之用户管理

在 Linux 中，每个普通用户都有一个账户，包括用户名、密码和主目录等信息。除此之外，还有一些系统本身创建的特殊用户，它们具有特殊的意义，其中最重要的是管理员账户，默认用户名是 root。同时 Linux 也提供了用户组，使每一个用户至少属于一个组，从而便于权限管理。

用户和用户组管理是系统安全管理的重要组成部分，下面介绍 openEuler 提供的用户管理和组管理命令，以及为普通用户分配特权的方法。

#### 1.2.1 管理用户

常用的 **管理用户** 的命令如下：

- useradd name：增加用户—在 root 权限下，通过 useradd 命令可以为系统添加新用户信息
- passwd name：修改用户密码—使用 passwd 命令修改用户的密码，没有设置密码的新账号不能登录系统。修改用户密码时需要满足密码复杂度要求，密码的复杂度的要求如下：
  
  - 口令长度至少 8 个字符。
  - 口令至少包含大写字母、小写字母、数字和特殊字符中的任意 3 种。
  - 口令不能和账号一样。
  - 口令不能使用字典词汇。
- userdel name：删除用户—在 root 权限下，使用 userdel 命令可删除现有用户。如果想同时删除该用户的主目录以及其中所有内容，要使用-r 参数递归删除
- id name：使用 id 命令查看新建的用户信息
- usermod -s new*shell\_path username：修改用户 shell 设置—用户也可以使用 usermod 命令修改 shell 信息，在 root 权限下执行如下命令，其中 \_new\_shell\_path* 为目标 shell 路径，*username* 为要修改用户的用户名
- usermod -d new*home\_directory username：修改主目录—修改主目录，可以在 root 权限下执行如下命令，其中 \_new\_home\_directory* 为已创建的目标主目录的路径，*username* 为要修改用户的用户名
- usermod -u UID username：修改用户 ID—修改用户 ID，在 root 权限下执行如下命令，其中 *UID* 代表目标用户 ID，*username* 代表用户名
- usermod -e MM/DD/YY username：修改账户有效期—如果使用了影子口令，则可以在 root 权限下，执行如下命令来修改一个账号的有效期，其中 *MM* 代表月份，*DD* 代表某天，*YY* 代表年份，*username* 代表用户名

**用户信息文件**

下面介绍与用户账号信息有关的文件：

- /etc/passwd：用户账号信息文件。
- /etc/shadow：用户账号信息加密文件。
- /etc/group：组信息文件。
- /etc/default/useradd：定义默认设置文件。
- /etc/login.defs：系统广义设置文件。
- /etc/skel：默认的初始配置文件目录。

#### 1.2.2 管理用户组

常用的 **管理用户组** 的命令如下：

- groupadd name：增加用户组—在 root 权限下，通过 groupadd 命令可以为系统添加新用户组信息，其中 *options* 为相关参数， *groupname* 为用户组名称
- groupmod -g GID groupname：修改用户组 ID—修改用户组 ID，在 root 权限下执行如下命令，其中 *GID* 代表目标用户组 ID， *groupname* 代表用户组
- groupmod -n newgroupname oldgroupname：修改用户组名称—修改用户组名，在 root 权限下执行如下命令，其中 *newgroupname* 代表新用户组名， *oldgroupname* 代表已经存在的待修改的用户组名
- groupdel groupname：删除用户组—在 root 权限下，使用 groupdel 命令可删除用户组。groupdel 不能直接删除用户的主组，如果需要强制删除用户主组，请使用 groupdel -f *groupname* 命令
- gpasswd -a username groupname：将用户加入用户组—将用户 *username* 加入用户组 *groupname*
- gpasswd -d username groupname：从用户组中移除用户—将用户 *username*从 *groupname* 用户组中移除
- newgrp newgroupname：切换用户组—一个用户同时属于多个用户组时，则在用户登录后，使用 newgrp 命令可以切换到其他用户组，以便具有其他用户组的权限

**用户组信息文件**

下面介绍与用户组账号信息有关的文件：

- /etc/gshadow：用户组信息加密文件。
- /etc/group：组信息文件。
- /etc/login.defs：系统广义设置文件。

sudo：允许普通用户执行管理员账户才能执行的命令

```
sudo ls /root
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLkunz4KeibUQib2ibJPibQ5OickDsyCmUTDEsLUK0MBibj0tCfAce7iaXAsiabQ/640?wx_fmt=png)

如果该用户在 root 下没有权限，需要在 root 下给该用户添加权限

```
vi /etc/sudoers  visudoUser  host=(run as user) command
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLsqUgyLDf8f78URcy3CDicKeibtCcEWKtJ2ZE8HObDoGdlI1ib4j3Ao5NQ/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLdThQ73If8KKW2ibsRszzMHUCaJ9dUWHVOkGOibLvibKAtZnbrO8FLtibeQ/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLeya842145tRKayggcZtwhNzVndz1Mcu097S4xpIBWL8rpYeibM749Pg/640?wx_fmt=png)

### 1.3 openEuler 基础配置之系统信息

**系统信息查看** 官方文档\[3]

想要了解系统的其他信息，比如系统信息、CPU、内存、磁盘、系统资源实时信息、版本信息，这里有几个常用的命令行提供给大家：

- 查看系统信息：cat /etc/os-release
- 查看 CPU 信息：lscpu（Lx cache 非单个 cup 值）
- 查看内存信息：free
- 查看磁盘信息：fdisk -l
- 查看系统资源实时信息：top
- 查看版本信息：cat /etc/openEuler-latest

**系统语言及键盘** 官方文档\[4]

大家可以通过 localectl 修改系统的语言环境，对应的参数设置保存在/etc/locale.conf 文件中。这些参数会在系统启动过程中被 systemd 的守护进程读取。

也可以通过 localectl 修改系统的键盘设置，对应的参数设置保存在/etc/locale.conf 文件中。这些参数，会在系统启动的早期被 systemd 的守护进程读取。

给大家提供一些系统语言和键盘的命令行：

- 当前环境语言：localectl status
- 可用环境语言/键盘：localectl list-locales/list-keymaps
- 设置环境语言/键盘：localectl set-locale/set-keymap LANG=zh\_CN.UTF-8/cn 更改语言环境之后，需要**重新登录** ，或者 root 权限下执行**source /etc/locale.conf 刷新配置文件** ，使其生效

**系统日期和时间** 官方文档\[5]

有些时候我们需要修改系统的日期、时间、时区，有哪些调整的方式呢，下面提供的很多命令行，我们可以通过使用 timedatectl、date、hwclock 命令来设置系统的日期、时间和时区等。

- 当前系统时间：timedatectl
- 时钟自动同步：timedatectl set-ntp yes/no
- 修改系统日期：timedatectl set-time YYYY-MM-DD
- 修改系统时间：timedatectl set-time HH:MM:SS
- 显示可用时区：timedatectl list-timezones
- 修改系统时区：timedatectl set-timezone time\_zone
- 显示当前的日期和本地时间：date
- 显示当前的日期和 UTC 时间：date --utc/--u
- 自定义 date 命令的输出：date +"%Y-%m-%d %H:%M:%S"
- 修改时间：date --set HH:MM:SS
- 修改日期：date --set YYYY-MM-DD
- 硬件日期时间 ：hwclock
- 设置硬件日期和时间：hwclock --set --date "dd mm yyyy HH:MM"

**常用技巧**

这里有个小 Tips 分享给大家，ssh 登录一段时间后出现过期推出的情况，使得大家比较烦恼，该如何解决呢？

简单的给大家提供了两种方式：

- 第一种是 TMOUT 环境变量不为 0 导致的 ssh 登出，我们可以在/etc/profile 内加入 export TMOUT=0，source /etc/profile 来解决。
- 我们可以在 /etc/profile.d 加入要执行的脚本文件，登录时自动触发该操作，这样也可以避免 ssh 经常登出的情况。

## 2. openEuler 软件包管理

软件包管理官方文档\[6]

给大家介绍一下，用来管理 openEuler 的软件包的工具 DNF。

DNF 是一款 Linux 软件包管理工具，用于管理 RPM 软件包。DNF 可以查询软件包信息，从指定软件库获取软件包，自动处理依赖关系以安装或卸载软件包，以及更新系统到最新可用版本。

**简单的小说明：**- DNF 与 YUM 完全兼容，提供了 YUM 兼容的命令行以及为扩展和插件提供的 API，所以在 openEuler 使用命令行的工具中，可以使用 DNF 也可以使用 YUM，根据自己的喜欢来用。- 后面主要使用 YUM 来给大家进行演示，在使用 YUM 的时候需要管理员权限，所有命令需要在管理员权限下执行。

### 2.1 openEuler 源配置 YUM

给大家提供两种下载软件的方式：

1. 利用本地 iso 挂载源，当作光驱一样（离线），这种方式是比较有限的，需要离线使用。mount iso /mnt 该源的配置文件：编辑/etc/yum.repos.d/xxx.repo（/etc/dnf/dnf.cong）
2. 利用 openEuler 官方提供的源（在线），这种方式是比较全的，比较新的，里面有许多源地址可供选择，但该方式需要在线使用。源网址\[7]该源的配置文件：编辑/etc/yum.repos.d/xxx.repo（/etc/dnf/dnf.conf）

### 2.2 openEuler update 源配置

openEuler update 源：openEuler 升级软件包的 repo 源，用于已发布版本的 bug、CVE 的修复和部分软件因特性增强后的更新发布。提供在线下载和版本内软件升级功能。目录下区分 AArch64 架构和 x86 架构。

安全公告里的很多 CVE 漏洞是实时修复的，修复完之后，修复的包大家可以通过 yum update 命令将系统上所有的包进行升级。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLpBIicjMYBicIHqZztZaIiaZ2FesrotPtdUGkhhmibbXQtl0tibchZzye8fw/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLmFcn6kVcHBV1PTJREibpPnMvHKeNTKAr7xPWgZBvuReW3R8EXJVk3ZA/640?wx_fmt=png)

### 2.3 openEuler 使用 dnf/yum 下载软件包

下载/安装/更新软件包时（yum 和 dnf 本质相同），大家可以根据自己使用习惯使用相应的终端命令。下表就是常用的 yum 命令行，查看系统包的相关内容。

注意：有时候在包升级过程中，部分包的升级会有一些冲突，你需要在 update 命令最后面使用 --allowerasing 先移除之前的包，然后再升级该包。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLonRuJxjI8kJdeBtS33zxJ0Sq7dTr0y3ZcnWvYicM54ia69Dnj7NUEhIg/640?wx_fmt=png)

### 2.3 openEuler 使用 rpm 管理本地软件包

除了 dnf 和 yum 也可以使用 rpm 针对本地的管家包进行管理。rpm 与 yum 的区别是 rpm 不会从固定的地方去取，它是先将所有的包下载下来再去安装，使用起来比较复杂，建议大家使用 yum。下面也提供了一些 rpm 对软件包操作的命令行，感兴趣的同学可以试一试。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLCSKQgbVsmMYPdyZibfury2SRbCyVxErxu7ToyQpnYz2VsOrYvq6EfWA/640?wx_fmt=png)

## 3. systemd 基本用法

官方文档\[8]

systemd 是在 Linux 下，与 SysV 和 LSB 初始化脚本兼容的系统和服务管理器。systemd 使用 socket 和 D-Bus 来开启服务，提供基于守护进程的按需启动策略，支持快照和系统状态恢复，维护挂载和自挂载点，实现了各服务间基于从属关系的一个更为精细的逻辑控制，拥有更高的并行性能。

**systemd 有哪些优点**

1. 并行启动能力强（SysVinit 是串行启动，UpStart 有依赖关系的是串行启动）
2. 按需启动，只有真正被请求时才启动（SysVinit 将可能用到的进程全部启动）
3. 利用内核提供的 cgroup 确保跟踪所有子进程
4. systemd 对 SysV 和 LSB 兼容

**systemd 作为 1 号进程**

systemd 取代了 initd 成为了系统的第一个进程，我们称之为 1 号进程。

内核空间初始化完成后，加载 init（/sbin/init）程序拉起 1 号进程；1 号进程通过 systemd 目标（target）拉起必须的进程，实现初始化。

下图命令是指向了 systemd 文件：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLUj8c8G0fMU4VWpc7tJBjib9S3WXqhDibiaLWUmUv7VlIviclXlmzdsgiaTA/640?wx_fmt=png)

**启动级别**

systemd 目前有 7 个启动级别，下表中详细的说明了每个级别的作用及命令行。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLuYAt0CJz7OCaicMqUpLHiahlWcFfVvbzD7qoLEpBEQeWj8iaGSH91U7zw/640?wx_fmt=png)

以下命令可以查看我们运行了哪些级别/更改默认的启动级别/当前立马更改级别

```
systemctl get-default/set-default/isolate name.target
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLMoh696gk1E8WLvSPfQrAbekTRD1e3tQK5qAjQZTUjq7UxjDHh3sA5A/640?wx_fmt=png)

**单元文件**

systemd 开启和监督整个系统是基于 unit 的概念。unit 是由一个与配置文件对应的名字和类型组成的（例如：avahi.service unit 有一个具有相同名字的配置文件，是守护进程 Avahi 的一个封装单元）。所有的可用 systemd unit 类型路径如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLfx9ic6fiacz7VahLYY9FNEDvfwYmHP38bWawbQycMqiciaoX0WZMblfRCw/640?wx_fmt=png)

**服务文件介绍**

常用的 systemd 服务文件格式固定：\[Unit]：服务简单描述及文档，以及依赖关系 \[Service]：定义服务如何启动当前的服务 \[Install]：定义如何安装文件，即如何做到开机启动

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLFhe4AuMM6zCbEVs8cNGAWAwhJciaIibvDKiaIF5WkOH8OTAK7TibIqth6Q/640?wx_fmt=png)

**常见用法**

```
systemctl start/restart/stop/reload/status/enable/disable/daemon-reload name.unit
```

**Systemd 命令和 sysvinit 命令的对照表**

systemd 提供 systemctl 命令与 sysvinit 命令的功能类似。当前版本中依然兼容 service 和 chkconfig 命令，相关说明如下表，但建议用 systemctl 进行系统服务管理。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLicYW1hnDpeLHkp9b5iaCK1f6W2TqibkzibB8OerXX221B17jJ4Q7GQniaZQ/640?wx_fmt=png)

**启动流程**

启动服务需要使用三个主线 target 去拉取上。每个 target 都会拉取各自需要的服务进程，拉取完成后系统准备就绪可以使用了。

```
multi-user.target -> basic.target -> sysinit.target
```

**日志查看**常见日志存储目录：/var/log/（由 rsyslog 转储 systemd-journald 而来，所以必须开机并完成 rsyslogd 之后才会有日志） 查看内核日志的命令行：dmesg![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaL7dibR16BFexjLlO6xMJVUS5oxTY09BTg4MIDYSLxnssRE0yRHRqWcicw/640?wx_fmt=png)

**systemd 日志**

systemd-journald 服务是 systemd init 系统提供的收集系统日志的服务。可以记录开机过程中的所有信息，包括启动服务等情况。

**systemd 日志常见用法**

journalctl：全部日志 journalctl -f：实时日志 journalctl \_SYSTEMD\_UNIT=NetworkManager.service journalctl --since "2020-08-05 12:20" (yesterday,today)

日志默认保存在 /run/log 中，重启丢失，保存重启前日志方法。

1. 创建/var/log/journal 目录
2. 修改/etc/systemd/journald.conf，将 Storage=auto 改为 persistent，重启日志服务

这两个方法可以使得您的日志不至于丢失，有时候需要定位一些问题，将日志改成 debug 级别，这对日志定位问题有很大的帮助。

**修改日志为 debug 级别**

```
/etc/systemd/system.conf    loglevel=debug/etc/profile 中加：export SYSTEMD_LOG_LEVEL=debug修改完进行重启。
```

## 4. 服务搭建

这里介绍四种服务器搭建：

- Repo 服务器：openEuler 提供了多种 repo 源供用户在线使用，各 repo 源含义可参考系统安装\[9]。若用户无法在线获取 openEuler repo 源，则可使用 openEuler 提供的 ISO 发布包创建为本地 openEuler repo 源。
- FTP 服务器搭建：FTP（File Transfer Protocol）即文件传输协议，是互联网最早的传输协议之一，其最主要的功能是服务器和客户端之间的文件传输。FTP 使用户可以通过一套标准的命令访问远程系统上的文件，而不需要直接登录远程系统。
- Web 服务器搭建：Web（World Wide Web）是目前最常用的 Internet 协议之一。目前在 Unix-Like 系统中的 web 服务器主要通过 Apache 服务器软件实现。为了实现运营动态网站，产生了 LAMP（Linux + Apache +MySQL + PHP）。web 服务可以结合文字、图形、影像以及声音等多媒体，并支持超链接（Hyperlink）的方式传输信息。openEuler 系统中的 web 服务器版本是 Apache HTTP 服务器 2.4 版本，即 httpd，一个由 Apache 软件基金会发展而来的开源 web 服务器。
- 数据库服务器搭建：数据库服务器使用 PostgreSql

具体详细四种服务器搭建方式可以参考 官方文档\[10]

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLBmSZM4HvZ6SXXj0WWC5RPp3pgibibAC0Ld2KV2ZqDiacTHsdcm9tT1VUw/640?wx_fmt=png)

## 5. 欢迎关注

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaL7f0aXQL58ibLUsksaCH81FzPXJ7F63J1ZLYRZu8YZdVThYThBBO1d3w/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbh2qHqpHo4U4cqEmD5PRaLl0EQia3Cib3WLsKJv0xakhQ6fsJjqT0NOlRx9niaKgOkp2syUQXg7Rpng/640?wx_fmt=png)

### 参考资料

\[1]

管理员指南: *https://openeuler.org/zh/docs/20.03\_LTS/docs/Administration/administration.html*

\[2]

文档: *https://openeuler.org/zh/docs/20.03\_LTS/docs/Administration/配置网络.html*

\[3]

官方文档: *https://openeuler.org/zh/docs/20.03\_LTS/docs/Administration/%E6%9F%A5%E7%9C%8B%E7%B3%BB%E7%BB%9F%E4%BF%A1%E6%81%AF.html*

\[4]

官方文档: *https://openeuler.org/zh/docs/20.03\_LTS/docs/Administration/%E5%9F%BA%E7%A1%80%E9%85%8D%E7%BD%AE.html*

\[5]

官方文档: *https://openeuler.org/zh/docs/20.03\_LTS/docs/Administration/%E5%9F%BA%E7%A1%80%E9%85%8D%E7%BD%AE.html*

\[6]

软件包管理官方文档: *https://openeuler.org/zh/docs/20.03\_LTS/docs/Administration/使用DNF管理软件包.html*

\[7]

源网址: *http://repo.openeuler.org/*

\[8]

官方文档: *https://openeuler.org/zh/docs/20.03\_LTS/docs/Administration/%E7%AE%A1%E7%90%86%E6%9C%8D%E5%8A%A1.html*

\[9]

系统安装: *https://openeuler.org/zh/docs/20.03\_LTS/docs/Releasenotes/系统安装.html*

\[10]

官方文档: *https://openeuler.org/zh/docs/20.03\_LTS/docs/Administration/%E6%90%AD%E5%BB%BA%E6%9C%8D%E5%8A%A1.html*
