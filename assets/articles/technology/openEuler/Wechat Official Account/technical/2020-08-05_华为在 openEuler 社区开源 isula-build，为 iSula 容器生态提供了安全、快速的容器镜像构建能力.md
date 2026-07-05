# [华为在 openEuler 社区开源 isula-build，为 iSula 容器生态提供了安全、快速的容器镜像构建能力](https://mp.weixin.qq.com/s/SXgnRIg2Ftagc4n474RTxw)

原创*雷钟凯*[OpenAtom openEuler](javascript:void%280%29;)*2020-08-05 08:00:00*

2020年7月24日，openEuler 社区\[1]正式开源了容器镜像构建工具 isula-build \[2]，它提供了安全、快速的容器镜像构建能力。isula-build 与 isulad\[3]、isula-kit 等一系列组件一起，构成了 iSula 品牌容器全栈解决方案。

## isula-build

isula-build 是 C/S 架构的服务，`isula-builder`为服务端，提供了并发构建的能力；`isula-build`为客户端，提供命令行。isula-build 有以下值得关注的特性：

- 完全兼容 dockerfile 语法
  
  isula-build 完全兼容 dockerfile 所有语法，支持多 stage 构建，用户可以沿用 `docker build`的使用习惯，不需要任何学习成本。
- 与 isulad、docker 快速集成
  
  isula-build 的镜像导出形式多样，可以直接导入到 isulad 和 docker 的本地 storage。同时，还支持导出到远端仓库和本地 tar 包，与周边组件的集成快速、方便。
- 镜像管理
  
  isula-build 提供了本地镜像管理功能。除了 build 镜像之外，isula-build 还提供了import/export/save/load/tag/rm 等镜像管理功能，这使得其镜像构建的来源更加丰富，导出形式更加多样。
- 快速
  
  相比 `docker build`，isula-build 不会为每一条 dockerfile 指令启动一个容器，只有 `RUN`指令才会在容器中执行，而且 commit 的粒度是 stage 而不是每一行指令。所以在通常的容器镜像构建场景，构建速度会有大幅提高。
- 安全
  
  支持 IMA( Integrity Measurement Architecture，完整性度量架构)。这是内核中的一个子系统，能够基于自定义策略对通过  execve()、mmap() 和 open()  系统调用访问的文件进行度量。通过 isula-build 构建的镜像能够保留IMA文件扩展属性，配合 OS 一起保证构建出来的容器镜像在运行侧可执行文件和动态库的完整性度量。该特性会有专门的文章介绍。

## 安装

**yum 源安装：**

可以通过 openEuler 的 repo 源很方便地安装 isula-build，以 aarch64 版本为例，创建 `/etc/yum.repo.d/openEuler.repo`文件内容如下：

```
[openEuler]
name=openEuler
baseurl=http://repo.openeuler.org/openEuler-20.03-LTS/update/aarch64/
enabled=1
gpgcheck=1
gpgkey=http://repo.openeuler.org/openEuler-20.03-LTS/update/aarch64/RPM-GPG-KEY-openEuler
```

然后直接通过 `yum install`安装：

```
$ sudo yum install isula-build
$ sudo isula-build --version
isula-build version 0.9.0, build 62b3f2d
```

**源码编译安装：**

也可以通过源码直接编译安装、运行：

```
$ sudo sudo yum install make btrfs-progs-devel device-mapper-devel glib2-devel gpgme-devel libassuan-devel libseccomp-devel git bzip2 go-md2man systemd-devel golang && \
git clone https://gitee.com/openeuler/isula-build.git && \
cd isula-build && sudo make -j && sudo make install && \
sudo mkdir -p /etc/isula-build/ && \
sudo install -p -m 600 ./cmd/daemon/config/configuration.toml /etc/isula-build/configuration.toml && \
sudo install -p -m 600 ./cmd/daemon/config/storage.toml /etc/isula-build/storage.toml && \
sudo install -p -m 600 ./cmd/daemon/config/registries.toml /etc/isula-build/registries.toml && \
sudo install -p -m 600 ./cmd/daemon/config/policy.json /etc/isula-build/policy.json && \
sudo /usr/bin/isula-builder
```

上述示例中使用了默认配置文件来启动运行 `isula-builder`。

## 快速开始

下面我们尝试使用`isula-build`构建一个镜像，并且导出到`isulad`（`isulad`的安装和使用方法参考：https://gitee.com/openeuler/iSulad），之后使用`isula-build`构建出来的容器镜像运行一个容器。

构造如下简单的`Dockerfile`：

```
FROM busybox:latest
MAINTAINER "cat"
RUN touch foo
RUN ["touch", "bar"]
LABEL foo=bar
EXPOSE 8888/udp
EXPOSE 9999/tcp
ENV hello=my-hello
ADD foo* /home/dir/
COPY bar /home/dir1/
VOLUME ["var/log"]
WORKDIR /home/foo
ONBUILD RUN ps $aux
STOPSIGNAL 15
HEALTHCHECK  --interval=5m --timeout=3s CMD ["pwd"]
CMD ["/bin/bash"]
```

构建镜像并导出到`isulad`：

```
$ sudo isula-build ctr-img build -f ./Dockerfile.all  -o isulad:my-image:V1.0
STEP  1: FROM busybox:latest
Getting image source signatures
Copying blob sha256:61c5ed1cbdf8e801f3b73d906c61261ad916b2532d6756e7c4fbcacb975299fb
Copying config sha256:018c9d7b792b4be80095d957533667279843acf9a46c973067c8d1dff31ea8b4
Writing manifest to image destination
Storing signatures
STEP  2: MAINTAINER "cat"
STEP  3: RUN touch foo
STEP  4: RUN ["touch", "bar"]
STEP  5: LABEL foo=bar
STEP  6: EXPOSE 8888/udp
STEP  7: EXPOSE 9999/tcp
STEP  8: ENV hello=my-hell
STEP  9: ADD foo* /home/dir/
STEP 10: COPY bar /home/dir1/
STEP 11: VOLUME ["var/log"]
STEP 12: WORKDIR /home/foo
STEP 13: ONBUILD RUN ps $aux
STEP 14: STOPSIGNAL 15
STEP 15: HEALTHCHECK --interval=5m --timeout=3s CMD ["pwd"]
STEP 16: CMD ["/bin/bash"]
Getting image source signatures
Copying blob sha256:514c3a3e64d4ebf15f482c9e8909d130bcd53bcc452f0225b0a04744de7b8c43
Copying blob sha256:538177faf8632daedf8e3181c63d95e1d096f676f70adfea61e41ada69f20092
Copying config sha256:d81f2c413a641521ac670fb7a2be5814b9cf3a6873cba3e554415e716924a449
Writing manifest to image destination
Storing signatures
Committed stage 0 with ID: d81f2c413a641521ac670fb7a2be5814b9cf3a6873cba3e554415e716924a449
Getting image source signatures
Copying blob sha256:514c3a3e64d4ebf15f482c9e8909d130bcd53bcc452f0225b0a04744de7b8c43
Copying blob sha256:538177faf8632daedf8e3181c63d95e1d096f676f70adfea61e41ada69f20092
Copying config sha256:d81f2c413a641521ac670fb7a2be5814b9cf3a6873cba3e554415e716924a449
Writing manifest to image destination
Storing signatures
Build success with image id: d81f2c413a641521ac670fb7a2be5814b9cf3a6873cba3e554415e716924a449
```

查询镜像：

```
$ sudo isula-build ctr-img images
------------------------------  -----------  -----------------  ------------------------  -----------
 REPOSITORY                      TAG          IMAGE ID           CREATED                   SIZE       
------------------------------  -----------  -----------------  ------------------------  -----------
 docker.io/library/busybox       latest       018c9d7b792b       2020-07-28 00:19:37       1.45 MB   
 localhost/my-image              V1.0         d81f2c413a64       2020-07-31 09:31:08       1.45 MB   
------------------------------  -----------  -----------------  ------------------------  -----------
$ sudo isula images
REPOSITORY                     TAG        IMAGE ID             CREATED              SIZE       
localhost/my-image             V1.0       d81f2c413a64         2020-07-31 17:31:08  1.385 MB
```

可以看到，`isula-build`和`isulad`的本地存储都可以查询到该容器镜像。

启动容器：

```
$ sudo isula run -ti localhost/my-image:V1.0 sh
/home/foo #
```

## 总结

通过以上实例可以看到，`isula-build`的安装简洁，使用方便。更多功能可以查看`isula-build`开源社区文档：

https://gitee.com/openeuler/isula-build/blob/master/doc/usage.md。

### 参考资料

\[1]

openEuler社区: *https://gitee.com/openeuler*

\[2]

isula-build: *https://gitee.com/openeuler/isula-build*

\[3]

isulad: *https://gitee.com/openeuler/iSulad*

\- END -

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibOspOSKHic8Nh8icmf9xozgIK5j5ibJibMLzCLhbSoicDQOrVDQpZKX2nkBA/640?wx_fmt=png)

***观众老爷们不考虑点一波关注***

***支持一下这个快要秃顶的主编吗？***

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbR3YNaNBytF0uqAicKL7fRD0JJj1HibCo2Sic0qxQ1LkZPlLqibMPxWUBBGeOOicicX3yY8e2icz81TU7Fg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYCjA16Qbj8RtLq6ZdzGlsR9Llaa49Bia9A8SlgicOgPZoDYZB2pxuLtp7FkmXvaIoZHRBUkAB6hA7w/640?wx_fmt=png)
