# [iSula 容器镜像构建工具 isula-build 架构介绍](https://mp.weixin.qq.com/s/dYdhAhHYdQzry0eRej22rw)

原创*zvier*[OpenAtom openEuler](javascript:void%280%29;)*2020-08-10 21:49:26*

`isula-build`目的是提供`iSula`生态下的容器镜像构建能力，实现极速加载、安全和跨架构的镜像构建。关于它的安装使用，我们往期文章中已经做了详细介绍，具体请参考：[iSula 容器镜像构建工具 isula-build 常用功能介绍](https://mp.weixin.qq.com/s?__biz=MzI2NDE4OTE2Mg%3D%3D&mid=2247484174&idx=1&sn=85ce0c33408d953cbd353d79c62b84c5&scene=21#wechat_redirect)

# 架构

`isula-build`采用经典的 C-S 架构，分为客户端`isula-build`和服务端`isula-builder`，客户端和服务端使用`GRPC`通信。用户可通过`isula-build`命令行与服务端`isula-builder`进行交互，发起镜像构建、镜像管理等请求。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMa7gG5buqruYAjkoNcE7RlciaLA2FyPq5KNcqG7f3meR2E6VMDYicRqvzL4Vvb3yFibKZucUJoibcrcZw/640?wx_fmt=jpeg)

isula-build 架构全景

下面分别详细介绍`isula-build`和`isula-builder`。

# 客户端 isula-build

作为用户与后端服务沟通的桥梁，客户端以命令行方式封装了各种常用的用户操作，包括镜像管理(`isula-build ctr-img`)、仓库登录/登出(`isula-build login`/`isula-build logout`)、版本查询(`isula-build version`)等。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMa7gG5buqruYAjkoNcE7RlcJxdK2rEIVgtOz0rfYmOZQFFQrHGab2Mg0tFD3hA5UtljaHVsaVhxyQ/640?wx_fmt=jpeg)

isula-build 客户端和服务器端模块交互

当前`isula-build`客户端支持如下命令：

命令功能使用示例isula-build version版本信息查询isula-build versionisula-build info获取后端信息isula-build infoisula-build login镜像 registry 登录isula-build login dockerhub.ioisula-build logout镜像 registy 登出isula-build logout mydockerhub.ioisula-build ctr-img images列出镜像isula-build ctr-img imagesisula-build ctr-img rm删除镜像isula-build ctr-img rm 3cedfa5193e8isula-build ctr-img import导入基础镜像isula-build ctr-img import busybox.tarisula-build ctr-img load导入镜像sula-build ctr-img load -i busybox.tarisula-build ctr-img save导出镜像sula-build ctr-img save busybox:latest -o busybox.tarisula-build ctr-img build镜像构建isula-build ctr-img build -f Dockerfile -o docker-daemon:image:tag .

以最核心的`isula-build ctr-img -f Dockerfile -o docker-archive:name.tar:image:tag .`为例，当接受到用户的命令行输入后，客户端会做一系列的用户参数校验以及准备工作，最后封装镜像构建请求，并请求转发给服务端开始构建，在构建过程中，客户端的`progressUI`模块不断接收并打印后端回传的构建进展，`localExporter`不断接收和保存后端回传的镜像 tar 流到本地，最终完成整个镜像构建任务。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMa7gG5buqruYAjkoNcE7RlcZnIaBTib6mHPv1t1Ocm3syrnZTnHdBOCYoibhYnVL1LSrib4iaX25ASBXA/640?wx_fmt=jpeg)

isula-build 客户端模块

- client: 获取用户入参，检查参数合法性
- localExporter: 接收 GRPC stream 流，将镜像内容写入本地
- processUI: 接收 GRPC stream 流，在镜像构建过程中持续打印构建进度
- GRPC Client: 与服务端建立 GRPC 通信信道

# 服务端 isula-builder

服务端是镜像构建服务的提供者，以 daemon 形式常驻后台镜像构建和管理服务，它通过接收客户端的`GRPC`请求，处理并响应请求。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMa7gG5buqruYAjkoNcE7RlcW2VrkMpskpObVQv0wiahEZwwibrzCAYwIW67YZqXbJIC1vp9zCvPKtPg/640?wx_fmt=jpeg)

isula-build 服务模块

同样，以镜像构建请求为例，服务端收到构建请求后，会转发给`Backend`模块，将请求路由给对应的后端`GRPC Build`方法来处理。`Build`方法根据参数生成一个`builder`，一个`buider`可理解为为一次构建请求创建的构建器或执行器，后续一系列的执行流程都由它来负责。

`isula-build`镜像构建本质上就是在`FROM`指定的基础镜像之上，创建一个读写层，然后根据`Dockerfile`指令填充相关的镜像结构和写入层数据内容。

构建流程中涉及关键组件包括：

- Parser，buider 将客户端传过来的 Dockerfile 解析成一个 Playbook，类似 Ansible 的 Playbook，镜像构建将基于这个 Playbook 去演绎。
- Runner，Runner 本质上是对 runc 的封装，当处理 Dockerfile 中的 RUN 指令时，正是通过 runc 创建一个容器，在它的基础上执行 RUN 相关的操作。
- Store，Store 主要用来存储和管理镜像、镜像层以及镜像元数据相关的内容。
- Exporter，如果需要导出镜像，exporter 将完成导出操作，支持将镜像导出到 docker daemon，isulad daemon 或客户端本地 tar 包等。

# 展望

随着未来`isula-build`镜像构建还将支持提供更多功能：比如`rootless`，`SmartLoading`，对接`kubernetes`等，`isula-build`的架构还会继续演进，以便更好地融合云原生生态，提供安全、可信、快速的镜像服务。

关于作者：zvier（Gitee id：zvier），iSula 团队高级工程师。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibOspOSKHic8Nh8icmf9xozgIK5j5ibJibMLzCLhbSoicDQOrVDQpZKX2nkBA/640?wx_fmt=png)

***观众老爷们不考虑点一波关注***

***支持一下这个快要秃顶的主编吗？***

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbR3YNaNBytF0uqAicKL7fRD0JJj1HibCo2Sic0qxQ1LkZPlLqibMPxWUBBGeOOicicX3yY8e2icz81TU7Fg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYCjA16Qbj8RtLq6ZdzGlsR9Llaa49Bia9A8SlgicOgPZoDYZB2pxuLtp7FkmXvaIoZHRBUkAB6hA7w/640?wx_fmt=png)
