# [「转」做个 openEuler 的容器镜像](https://mp.weixin.qq.com/s/07iewYpDis4WdUV2Lxi_Xg)

*崔秀龙*[OpenAtom openEuler](javascript:void%280%29;)*2020-11-11 18:00:00*

前几天突然想知道，操作系统镜像是怎么搞的。放狗搜了一下，发现官网提供了一些这方面的介绍，看来很轻松，结合以前翻译的镜像是怎样炼成的，一时手痒，就想用菊厂操作系统新秀 openEuler 练练手——恩是 openEuler 不是那啥。

根据 Docker 官网介绍，几个流行操作系统都有自己的构建脚本，主要流程就是几个步骤：

- 安装操作系统
- 安装工具依赖项目
- 运行脚本构建镜像
- 获取镜像

openEuler 安装之后，可以看到是个 Yum 系的系统，所以可以参考一下 CentOS 的脚本，粗看上来，依赖并不复杂，`yum`、`docker` 以及 `tar`。撸起袖子开工就是了。

## 安装

在 openEuler 官网下载 ISO 文件：`https://openeuler.org/en/download/`。这里我选择了 LTS 的最小化版本。使用 Parallels Desktop 安装虚拟机，安装之后对几个依赖进行验证。

首先发现这个系统可能因为某些原因并没有内置 Repo 源，个人用户自然无需担心这个问题，在 `/etc/yum.repos.d` 中加入软件源：

```
[openeuler]name=openEulerbaseurl=https://repo.openeuler.org/openEuler-20.03-LTS/OS/x86_64/enabled=1gpgcheck=0
```

Docker 的安装也可以使用 CentOS 的源：

```
[docker]name=Docker CE Stable - $basearchbaseurl=https://download.docker.com/linux/centos/7/$basearch/stableenabled=1gpgcheck=0[extra]name=Extrabaseurl=http://mirror.centos.org/centos/7/extras/x86_64enabled=1gpgcheck=0
```

其中的 Extra 库来自 CentOS，用于满足一些 Docker 的安装依赖。

`yum install docker-ce docker-ce-cli containerd.io --nobest` 安装 Docker，之后就可以运行 部署脚本了：

```
$ ./mkimage-yum.sh
...
```

不过虚拟机下运行成功并不是这么容易的，这个脚本的运行会在 `/tmp` 中运行，大概需要 900MB 的磁盘空间，和 40k 左右的 inode。建议运行之前使用 `df -h -i` 查看一下 `/tmp` 的可用情况。openEuler 的缺省 `/tmp` 较小，可以使用 `mount -o remount,size=15G /tmp/` 调整。

如果一切正常的话，会看到在大量的错误信息之后，看到一行输出：`success`。这是脚本在生成镜像 TAR 文件，使用 Docker 加载并运行之后输出的。可以查看一下这个镜像：

```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
openeuler           20.03               fe7ddc25c484        5 hours ago         1.57GB

$ docker run -it openeuler:20.03 bash

Welcome to 4.19.90-2003.4.0.0036.oe1.x86_64

System information as of time:  Thu Nov  5 08:56:29 UTC 2020

System load:    0.02
Processes:      5
Memory used:    7.3%
Swap used:      0.9%
Usage On:       9%
IP address:     172.17.0.2
Users online:   0
```

另外，如果仔细点看上面提供的 YUM Repoistory，会发现一个神奇的文件夹，其中包含了 x86 和 aarch64 两个架构的原厂镜像\_所以本文仅供学习交流，不建议用于商业用途，请于 24 小时内忘掉。

## 相关链接

- **Base Image**：
  
  `https://docs.docker.com/develop/develop-images/baseimages/`
- **构建脚本**：
  
  `https://github.com/moby/moby/blob/master/contrib/mkimage-yum.sh`
- **下载 ISO**：
  
  `https://openeuler.org/en/download/`
- **下载镜像**：
  
  `https://repo.openeuler.org/openEuler-20.03-LTS/docker_img/x86_64/`

* * *

给 openEuler 投票

即可获得《openEuler操作系统》图书一本

??

??

??

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMb3WW8xrDNx293FOnjQvXLhcoBIYM0WLfFPhRtWhkibTSL0dN6563DaoywtO0QmzfyposYzkapXcCw/640?wx_fmt=jpeg)

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMb3WW8xrDNx293FOnjQvXLhoOq2IEJ0b17hELkGJhdtZMTyEKudo1kXnK6VlhQROib9U5q1kxrvZxQ/640?wx_fmt=jpeg)

请将**两张投票截图+快递信息**通过 openEuler 公众号窗口发送到后台即可

开源新锐项目投票11月13日23:00结束

十大开源杰出人物投票11月16日23:00结束

快递将会在11月17日陆续发出
