# [oebuild 使用指导来啦，帮你快速上手 openEuler Embedded！](https://mp.weixin.qq.com/s/mr4iD-p196qkJyLoWw_Fig)

[OpenAtom openEuler](javascript:void%280%29;)*2024-08-07 19:21:53广东*

**概述**

oebuild 是学习 OpenAtom openEuler(简称“openEuler”) Embedded 的一款必不可少的工具。这款工具是专门为 openEuler 嵌入式系统量身定做，集成了很多实用的功能，例如快速构建OS，在线调试软件包，快速qemu部署，SDK构建，开发环境管理等，能够让开发者快速上手 openEuler Embedded，到目前为止 oebuild 已经随着 openEuler 24.03 LTS 正式发布了 0.1 版本。

**安装**

oebuild 基于 Python3 实现，建议使用 Python 3.10 及以上版本。当前仅支持在64位的 x86 环境下使用，并且需要在普通用户下进行 oebuild 的安装运行。

**安装并配置依赖**

●  基于 openEuler

```
# 安装必要的软件包$ sudo yum install Python3 Python3-pip docker# 配置 docker 环境$ sudo usermod -a -G docker $(whoami)$ sudo systemctl daemon-reload && sudo systemctl restart docker$ sudo chmod o+rw /var/run/docker.sock
```

●  基于 Ubuntu（要求 20.04 以上版本）

```
# 安装必要的软件包$ sudo apt-get install Python3 Python3-pip docker docker.io# 配置 docker 环境$ sudo usermod -a -G docker $(whoami)$ sudo systemctl daemon-reload && sudo systemctl restart docker$ sudo chmod o+rw /var/run/docker.sock
```

●  基于 SUSELeap15.4

```
# 安装必要的软件包$ sudo zypper install Python311 Python311-pip docker# 配置 docker 环境$ sudo usermod -a -G docker $(whoami)$ sudo systemctl restart docker$ sudo chmod o+rw /var/run/docker.sock$ sudo systemctl enable docker# 配置最新版 Python$ cd /usr/bin$ sudo rm Python Python3$ sudo ln -s Python3.11 Python$ sudo ln -s Python3.11 Python3
```

**安装 oebuild**

●  首次安装 oebuild

```
$ pip3 install oebuild
```

●  已安装过 oebuild，需要升级到最新版

```
$ pip3 install --upgrade oebuild
```

●  安装特定版本的 oebuild

```
$ pip3 install oebuild==<version>
```

**功能介绍**

**构建OS镜像使用指导**

确保构建主机满足以下条件：

- 至少 50G 以上的空闲磁盘空间，建议预留尽可能多的空间，有助于运行多个镜像构建，通过重复构建提升效率。
- 至少 8G 内存，建议使用32G内存、CPU 数量更多的机器，增加构建速度。

**第一步：**初始化构建目录

oebuild 的工作目录与 openEuler Embedded 版本是相关联的，构建不同版本的 openEuler Embedded，需要创建相应的工作目录。因此，推荐 openEuler Embedded 版本号命名工作目录，例如 workdir\_master。当前通过执行以下命令来创建工作目录：

```
oebuild init workdir_master
```

**第二步：**创建定制化的构建配置文件

目前 openEuler Embedded 支持多种南向架构，包括 ARM/ARM64，X86-64，RISCV。在此基础上，oebuild 抽象封装了 openEuler Embedded 的大颗粒特性，包括：混合部署（MICA)，图形，ROS，初始化服务（busybox or systemd）。开发者可以通过 oebuild 自由组合所需特性，定制openEuler Embedded 版本。输入以下命令进入命令行菜单选择界面：

```
oebuild generate
```

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCQo1rgicM9JrT0aOSiaoMCfjVCCmC45y512ZbEZny5BfuWn3UmIbSJUcRmC7dOqxLAbhECqVvqoyag/640?wx_fmt=png&from=appmsg)

在"choice build"中选择OS表示构建OS镜像。

在"choice platform"选择需要构建的单板，图中示例为 qemu-aarch64。

在 os feature 下选择需要构建的特性。

在 directory 输入编译目录名，至此按q，退出，按y确认即可生成编译目录。

或者直接在命令行输入命令：

```
# 例如创建混合部署和 system 的 qemu-aarch64 镜像构建配置文件，构建目录为 build_arm64-mcs-systemd$ oebuild generate -p qemu-aarch64 -f openeuler-mcs -f systemd -d build_arm64-mcs-systemd# 创建支持软实时和 systemd 的 X86-64 镜像构建配置文件，构建目录为 build_x86-rt-systemd$ oebuild generate -p x86-64 -f openeuler-rt -f systemd -d build_x86-rt-systemd
```

**第三步：**构建 openEuler Embedded

在 compile.yaml 的同级目录（即第二步创建出来的构建目录）下，执行以下命令，开始构建：

```
# 进入构建容器$ oebuild bitbake8<-------- 进入容器环境 --------# 构建 openEuler Embedded 镜像$ bitbake openeuler-image# 构建 openEuler Embedded 的 SDK$ bitbake openeuler-image -c do_populate_sdk# 构建完成后，退出容器环境$ exit8<-------- 返回构建主机 --------# 在 output 目录中可以找到构建镜像$ cd output/<构建时间戳>
```

进入容器后，bitbake 的使用方法与 yocto 保持一致，一些常用命令如下：

- bitbake &lt;target&gt; -c cleansstate：清理&lt;target&gt;的构建缓存，一般在重新构建&lt;target&gt;之前执行，以防止缓存影响新增的修改。
- bitbake &lt;target&gt; -e &gt; env.log：输出关于&lt;target&gt;相关的构建环境变量到 env.log 中，一般用于帮助开发人员编写&lt;target&gt;的构建配方。
- bitbake &lt;target&gt; -g：输出&lt;target&gt;相关的构建依赖分析 pn-buildlist、task-depends.dot。

**上游源码包下载**

上游源码包下载使用 manifest 命令，该命令用于对 openEuler Embedded 的基线进行管理，对 openEuler Embedded 的基线来说，目前只涉及上游源码包的git信息，对于相关的构建环境并不包括进去。

该命令的使用范例如下：

```
oebuild manifest [create/download] [-f MANIFEST_DIR]
```

openEuler Embedded 的基线文件放置在源码根目录下的 .oebuild/manifest.yaml，而 manifest 会根据 manifest.xml 中的包列表信息来下载上游包，在 oebuild 工作目录下直接运行以下命令会一次性将所有的上游包下载到本地：

```
oebuild manifest download
```

另外，manifest 命令也支持单包下载，单包下载即只下载指定包，但是需要明确该包信息一定存在与 manifest.xml 中，否则会提示错误找不到：

```
oebuild manifest download zlib
```

**qemu快速运行**

该命令是对 poky 自带的 runqemu 做了外层封装，配合 yocto-meta-openeuler 构建 qemu 镜像默认添加了 qemu 仿真功能，实现了在当前构建目录下的 qemu 仿真。该功能是 在openEuler 构建容器下实现的，即所应用的 qemu-system 工具来自于构建容器中 nativesdk 下的 qemu-system，调用逻辑如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCQo1rgicM9JrT0aOSiaoMCfjEuXJ1dpiaGwRPRG23uSj3ZcsZE7AgcrkgeLwKiaibfgt7m5jibb2C1ARQg/640?wx_fmt=png&from=appmsg)

unqemu 的运作离不开 poky 环境的初始化，其构建目标须生成 qemuboot.conf 文件。runqemu 会依据此文件参数启动，若文件不存在，则会报错，显示 qemuboot.conf not exists 等提示。yocto-meta-openeuler 在 meta-openeuler/recipes-core/images/qemu.inc 中默认添加了 IMAGE\_CLASSES += “qemuboot” ，确保构建 qemu 镜像时会自动生成 qemuboot.conf。

鉴于 CPU 架构的差异，不同架构的 qemuboot 配置也各有千秋。openEuler 针对支持的四个架构提供了特定配置，这些配置文件位于 meta-openeuler/conf/machine 目录下，分别为 generic-x86-64.conf、qemu-aarch64.conf、qemu-arm.conf 和 qemu-riscv64.conf。每个文件中， # qemuboot options 部分即为 qemuboot 的相关配置。开发者可根据实际开发需求进行定制化修改，但请注意，每次修改后须重新进行构建。

qemu 快速运行命令需要在构建目录下运行：

```
oebuild runqemu nographic
```

**编译环境管理**

该命令用于对 openEuler 不同的 SDK 进行管理，该 SDK 即为用于编译在相应嵌入式镜像中运行的 APP。该功能支持原生的SDK文件进行注册，也支持已初始化的 SDK 进行注册。该功能有4个子命令，分别为 create、list、remove 和 activate，以下将分别介绍这四个子命令：

**create**

创建环境命令，此命令会在 ~/.local 文件夹下创建一个 oebuild\_env 文件夹，里面会存放对应的 yaml 环境配置文件以及 SDK 解压文件夹

```
oebuild menv create [-d directory] [-f file] -n env_name
```

- d 参数为对应已经初始化完成的 SDK 目录。
- f 参数为对应未进行初始化的 SDK 文件，-d 与 -f 两个参数只能二选一。
- n 参数为初始化的编译环境名称。

**list**

查看环境列表命令，此命令会列出已经注册的 SDK，使用方式如下：

```
oebuild menv list
```

**activate**

此命令可以激活对应名称的环境，使用方式如下：

```
oebuild menv activate -n env_name
```

其中 env\_name 为用户自定义的环境名称，可以使用 list 命令进行查看后再激活。

**remove**

此命令可以删除对应名称的环境配置，如果是使用 SDK 进行的环境添加，则还会删除对应的 SDK 解压文件，该命令使用方式如下：

```
oebuild menv remove -n env_name
```

其中 env\_name 为用户自定义的环境名称，可以使用 list 命令进行查看后再进行删除。

**在线部署/卸载软件包**

该功能是将 yocto 中 devtools 的 deploy-target 与 undeploy-targe t功能摘取出来然后在 oebuild 中做了适配，总体使用和在 yocto 中使用 devtools 是一样的，使用范例如下：

```
oebuild deploy-target/undeploy-target recipename target
```

其中 recipename 表示要部署或卸载的软件包名。

target 即为目标机器，其格式为：user@hostname\[:destdir]

**插件管理**

该命令用于开发者在编写了一些自定义插件，希望加入到本地 oebuild 进行使用时，可以通过此命令加入到 oebuild 中，并且在通过检测之后就可以直接按照插件逻辑进行使用。

```
oebuild mplugin install [-d directory -m file_name] [-f file_name]  -n plugin_name
```

此命令允许您指定一个文件或文件夹作为目标。使用 -d 参数时，请提供文件夹的具体路径。鉴于插件解析过程中必须指定一个主导文件， 因此 -m 参数用来指明文件夹内的主文件。而 -n 参数则用于指定插件的名称，指定参数为 -d 时，必须要指定 -m 参数，否则会安装失败。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCQo1rgicM9JrT0aOSiaoMCfjt1QzLdXHRaOiaexW96nKsUY3wnicYUQrqXPbXjsGzibNcdBqia9nWE3F1A/640?wx_fmt=png&from=appmsg)

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCQo1rgicM9JrT0aOSiaoMCfjHnVCpB69dn9F7O0wBA90rQ9AgZq8Z4sLE0sW3pFFfzAqrW4ppKz9ug/640?wx_fmt=png&from=appmsg)

执行完上述命令后会有对应的创建成功提示，并显示出当前创建的插件名，插件状态和对应文件路径。

**list**

此命令可以查看当前有哪些插件配置。

```
oebuild mplugin list
```

如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCQo1rgicM9JrT0aOSiaoMCfjT5JBhecibvOKtqiaB876LEfFklWicJia8xebtBEFZS3kvMxs7emiaVNFIibA/640?wx_fmt=png&from=appmsg)

**enable/disable**

此命令可以使能/屏蔽对应名称的插件。

```
oebuild mplugin enable/disable -n plugin_name
```

其中 plugin\_name 为开发者自定义的插件名称，可以使用 list 命令查看当前自定义安装的插件列表，并在必要时对特定插件进行对应插件使能/屏蔽。

如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCQo1rgicM9JrT0aOSiaoMCfjpOdnrIxS07Dkiac1sQhQUy81aJKBmXoV1QrjqVaPiciahlHfYcAjibl6ow/640?wx_fmt=png&from=appmsg)

**remove**

此命令可以删除对应名称的插件配置。

```
oebuild mplugin remove -n plugin_name
```

其中 plugin\_name 为开发者自定义的插件名称，可以使用 list 命令来查看所有插件的列表，并在确认后选择删除特定的插件。每次成功删除插件后，都会显示一条提示信息，告知操作已成功完成。

如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCQo1rgicM9JrT0aOSiaoMCfjHjiaR6k8yfefLHCtzWEjTtAL4ERibtHurs0qGJdWBn8zyIOLOL3fcbMQ/640?wx_fmt=png&from=appmsg)

**加入我们**

文中所述的特性支持，由 Embedded SIG 参与，相关源码均已在 openEuler 社区开源。如果您对相关技术感兴趣，欢迎您的加入。您可以添加小助手微信，加入 SIG Embedded 微信群。

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mAk7XGjrHQX48E1tGVyJGQcgaTxicyGy9UAaYQYrL3ADZeFvrsbKPgXGSSwxkrfJsQdiccRkoQyFGDw/640?wx_fmt=jpeg&from=appmsg)
