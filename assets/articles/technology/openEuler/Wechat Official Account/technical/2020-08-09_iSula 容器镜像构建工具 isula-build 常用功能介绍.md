# [iSula 容器镜像构建工具 isula-build 常用功能介绍](https://mp.weixin.qq.com/s/tr4OzOsMBrDouCzdBTuCaA)

原创*雷钟凯*[OpenAtom openEuler](javascript:void%280%29;)*2020-08-09 12:00:00*

华为在 openEuler\[1]社区开源了容器镜像构建工具isula-build\[2]，这意味着iSula容器全栈解决方案将镜像构建、镜像管理等功能也囊括其中，共同构筑起iSula生态。

`isula-build`的安装过程在此不再赘述，可以参考社区文档\[3]或前面的系列文章。下面就介绍一些isula-build通用的功能和使用方法。

## 如何配置

如社区README\[4]所示，不管是通过`yum`安装还是通过源码编译安装，都已经在环境中安装好默认的配置文件，直接启动`isula-builder`即可。更具体的配置在社区使用说明文档\[5]也有介绍，在此对几个配置文件的功能做一些详细说明，并且指出几个需要注意的配置：

- configuration.toml：这是`isula-build`的主配置文件。它用于配置isula-build全局参数，把诸如镜像、存储等配置独立出来，在此仅仅配置其他配置文件的路径。在该配置中，需要了解其中的`data_root`和`run_root`。
  
  - data\_root：该路径存放`isula-build`的持久化数据，主要为镜像层的数据。同时，还包括构建过程中需要用到的临时空间。该路径通常需要配置和保存在持久化介质上。
  - run\_root：该路径作为`isula-build`的运行时目录，主要保存一些文件比较小、需要快速访问且不需要持久化的数据，例如：文件锁和不需要持久化的元数据等等。该路径文件系统类型通常为`tmpfs`。
- storage.toml：持久化存储的配置。该配置通常不需要修改，使用默认的配置文件即可。`isula-build`使用了第三方的storage库\[6]，具体配置也可以参考storage库的配置说明。
- registries.toml：镜像仓库相关配置，主要包括允许`isula-build`使用的镜像仓库列表和insecure仓库列表。
  
  也即，如果想允许`isula-build`从`docker.io`查找和拉取镜像，需要做如下配置：
  
  ```
  [registries.search]registries = ['docker.io']
  ```

同时，`isula-build`使用了第三方的image库\[7]，具体配置也可以参考image库的配置说明。

综上，要快速开始使用`isula-build`，只需要给它配置允许查找和拉取镜像的仓库地址，并且保证网络连通，就可以完成配置，开启容器镜像构建之旅。

## 容器镜像构建

`isula-build`目前主要的功能为构建容器镜像和管理容器镜像。

但是容器领域有其他更多需要构建的对象，例如：

- 基于全量ISO构建出容器基础镜像
- 构建非dockerfile输入的镜像
- 构建输出非docker image格式的镜像
- 等等

所以，`isula-build`对构建容器镜像，设置了`ctr-img`子命令，如果要执行容器镜像构建，需要执行`isula-build ctr-img build ...`，为今后“build everything”做准备。

### 构建容器镜像

我们来看一下`isula-build ctr-img build`的命令行介绍：

```
$ sudo isula-build ctr-img build --helpBuild container imagesUsage:  isula-build ctr-img build [flags] PATHExamples:isula-build ctr-img build -f Dockerfile .isula-build ctr-img build -f Dockerfile -o docker-archive:name.tar:image:tag .isula-build ctr-img build -f Dockerfile -o docker-daemon:image:tag .isula-build ctr-img build -f Dockerfile -o docker://registry.example.com/repository:tag .isula-build ctr-img build -f Dockerfile -o isulad:image:tag .isula-build ctr-img build -f Dockerfile --build-static='build-time=2020-06-30 15:05:05' .Flags:      --build-arg stringArray   Arguments used during build time      --build-static listopts   Static build with the given option  -f, --filename string         Path for Dockerfile      --iidfile string          Write image ID to the file  -o, --output string           Destination of output images      --proxy                   Inherit proxy environment variables from host (default true)      --tag string              Add tag to the built image
```

可以看到，`isula-build ctr-img build`的帮助信息很完善，而且给了非常详细的示例，可以快速上手。

- `PATH`：上下文目录。指定本次构建的上下文，构建过程中涉及的镜像文件，或者`ADD/COPY`指令的源文件，默认都来自于该目录。
- `--build-arg`：指定dockerfile中`ARG`指令的值。如果未指定且dockerfile中没有给`ARG`指令中的key设置默认值，则构建过程会输出警告信息。
- `--build-static`：静态构建。支持相同输入多次构建出同一个imageID。kv格式，目前key只需要传入静态构建需要固定的镜像时间戳。
- `-f ,--filename`：指定dockerfile的路径
- `--iidfile`：指定imageID输出文件。默认情况下，`isula-build`在构建完成之后，将imageID输出到控制台。
- `-o, --output`：指定镜像导出目标。若不指定，默认保存在`isulad-build`的本地storage。目前支持导出到isulad/docker/registry/tarball。
- `--proxy`：是否继承host环境变量，默认为true，可以在构建过程中使用`isula-buider`继承自父进程的host环境变量。
- `--tag`：给构建出来的镜像指定一个额外的tag。当不使用`--output`参数指定容器镜像导出目标和tag时，也可以通过该参数指定容器镜像的tag。

我们构造如下简单的dockerfile，使用上述flag进行容器镜像构建：

```
FROM busyboxARG filenameWORKDIR /homeRUN echo "hello, world!" > $filenameCMD ["/bin/sh"]
```

执行容器镜像构建命令：

```
$ sudo isula-build ctr-img build -f ./Dockerfile.test --build-arg="filename=foo.txt" --build-static='build-time=2020-08-03 20:52:33' --iidfile="./imageID.txt"  -o isulad:my-image:V0.1STEP  1: FROM busybox...(pull image)STEP  2: ARG filenameSTEP  3: WORKDIR /homeSTEP  4: RUN echo "hello, world!" > $filenameSTEP  5: CMD ["/bin/sh"]...Write image ID [141a6dc39dd7778f1373f53d5de1dfffa69d19ee8fb75e2ea303d307cc18db84] to file: ./imageID.txt
```

检查构建结果：

```
$ sudo isula-build ctr-img images---------------------------  -----------  -----------------  ------------------------  -------- REPOSITORY                    TAG          IMAGE ID           CREATED                   SIZE       ---------------------------  -----------  -----------------  ------------------------  -------- docker.io/library/busybox     latest       018c9d7b792b       2020-07-28 00:19:37       1.45 MB    localhost/my-image            V0.1         141a6dc39dd7       2020-08-03 20:52:33       1.45 MB   ---------------------------  -----------  -----------------  ------------------------  ---------[iSula@openEuler ~]$ sudo isula imagesREPOSITORY                     TAG        IMAGE ID             CREATED              SIZE       localhost/my-image             V0.1       141a6dc39dd7         2020-08-04 04:52:33  1.383 MB$ sudo cat imageID.txt 141a6dc39dd7778f1373f53d5de1dfffa69d19ee8fb75e2ea303d307cc18db84$ sudo isula run 141 cat /home/foo.txthello, world!
```

可以看到，`isula-build`和\`isulad\`\[8]都可以查询到新构建出来的容器镜像，且容器镜像ID被写入到imageID.txt，通过`isula run`可以启动新构建出来的容器，并打印出"hello, world!"。

示例中演示了将容器镜像导出到\`isulad\`\[9]并启动容器的过程，其他的使用方式和容器镜像导出方式参考命令行帮助或者开源社区文档\[10]。

### 静态构建

常用功能不在此赘述，这里介绍一下`--build-static` flag。

我们知道，容器镜像的ID是整个容器镜像文件的摘要（sha256哈希），容器镜像中任何变化，包括rootfs和元数据的变化，均会导致容器镜像ID的变化。该flage有两层含义：

1. 指定本次构建为静态构建。也就是说，本次构建会消除影响容器镜像ID的所有因素，包括创建时间、目录摘要、随机主机名等等。
2. 用于指定需要固定的因素。目前只需要通过--build-static='build-time=Y-M-D H:M:S'格式指定构建时间即可，它会被用于消除文件创建时间、修改时间引入的差异，例如：文件压缩。

我们可以尝试用如下没有实际意义的简单dockerfile文件做个测试：

```
FROM scratchLABEL foo=bar
```

不使用静态构建的方式，对同一个dockerfile输入构建2次：

```
$ sudo isula-build ctr-img build -f ./Dockerfile -o docker-archive:./my-image.tar:my-image:V0.1STEP  1: FROM scratchSTEP  2: LABEL foo=bar...Build success with image id: 7271cbbc8f64c64601a80addfbed3adeb551810814bcc90d9a894e688dee8bb3$ sudo isula-build ctr-img build -f ./Dockerfile -o docker-archive:./my-image.tar:my-image:V0.1STEP  1: FROM scratchSTEP  2: LABEL foo=bar...Build success with image id: 0da9ff314975cadcd0ddfba313b535cf5d4b600636675a6353302c3e11dc5be6
```

发现使用相同的dockerfile构建2次，不能产生同样的镜像ID，因为两个镜像的元数据信息因为构建时间、随机目录名等等有差异。而如果使用静态构建：

```
$ sudo isula-build ctr-img build -f ./Dockerfile --build-static='build-time=2020-08-03 20:39:40' -o docker-archive:./my-image.tar:my-image:V0.1STEP  1: FROM scratchSTEP  2: LABEL foo=bar...Build success with image id: f933a28dcd6273c33f902f61485786e0b7e84ba5a0eab84da8be22fe96042b92$ sudo isula-build ctr-img build -f ./Dockerfile --build-static='build-time=2020-08-03 20:39:40' -o docker-archive:./my-image.tar:my-image:V0.1         STEP  1: FROM scratchSTEP  2: LABEL foo=bar...Build success with image id: f933a28dcd6273c33f902f61485786e0b7e84ba5a0eab84da8be22fe96042b92
```

使用静态构建同时固定构建时间，不管多少次构建，只要dockerfile和构建命令相同，都会产生固定的容器镜像ID：`f933a28dcd6273c33f902f61485786e0b7e84ba5a0eab84da8be22fe96042b92`。该flag为某些需要溯源，或者需要建立dockerfile与容器镜像ID一一对应的场景提供了解决方案。

其他通用场景具体的使用方法详见开源社区文档\[11]。

## 容器镜像管理

`isula-build ctr-img`除了提供`build`命令来构建容器镜像之外，还支持对容器镜像`import/export/save/load`等操作。如果有`dockr`使用经验，对这些镜像管理的命令不会陌生，`isula-build`提供的这些镜像管理命令，与`docker`的含义完全相同，所以也没有学习成本。

```
$ sudo isula-build ctr-img --helpContainer Image OperationsUsage:  isula-build ctr-img [command]Available Commands:  build       Build container images  images      List locally stored images  import      Import the base image from a tarball to the image store  load        Load images  rm          Remove one or more locally stored images  save        Save image to tarball  tag         create a tag for source image
```

我们可以基于openEuler的基础镜像（rootfs压缩包）来构建容器镜像(基础镜像下载地址\[12])。之后`import`到`isula-build`本地存储：

```
# import基础镜像（不包括任何元数据的rootfs）$ sudo isula-build ctr-img import ./openEuler-docker.x86_64.tar.xz localhost/my-openeuler:latestImport success with image id: 81b1dafdcdc15ad790f0a38923fef71a0fd0ad64aa040d1dd7183811ab1e67e2# 查询import结果$ sudo isula-build ctr-img images------------------------  -----------  -----------------  ------------------------  -------- REPOSITORY                TAG          IMAGE ID           CREATED                   SIZE       ------------------------  -----------  -----------------  ------------------------  ---------localhost/my-openeuler     latest       40fd8ba7f278       2020-08-03 20:52:51       635 MB------------------------  -----------  -----------------  ------------------------  ---------
```

这样我们就可以基于导入的镜像来构建我们自己的镜像。我们写个简单的dockerfile：

```
FROM localhost/my-openeulerCMD ["/bin/sh"]
```

之后执行构建命令，导出到`./my-image.tar`备用，并给其指定tag为`my-image:V0.1`：

```
$ sudo isula-build ctr-img build -f ./Dockerfile  --iidfile="./imageID.txt"  -o docker-archive:./my-image.tar:my-image:V0.1STEP  1: FROM localhost/my-openeulerSTEP  2: CMD ["/bin/sh"]...Write image ID [3512e0c83ad2c40d504a477a7aeea8ab4ee12254a76576aaa27d75c395d290fd] to file: ./imageID.txt
```

查询构建出来的镜像：

```
# 查看构建出来的容器镜像压缩包$ ls -l my-image.tar -rw-------. 1 root root 634665472 Aug  3 21:37 my-image.tar# 查询isula-build本地存储中的容器镜像$ sudo isula-build ctr-img images------------------------  ---------  ---------------  ------------------------  --------- REPOSITORY                TAG        IMAGE ID          CREATED                   SIZE      ------------------------  ---------  ---------------  ------------------------  --------- localhost/my-openeuler    latest     40fd8ba7f278      2020-08-03 20:52:51       635 MB     localhost/my-image        V0.1       3512e0c83ad2      2020-08-03 20:54:33       635 MB    ------------------------  ---------  ---------------  ------------------------  ---------
```

可以在目录中看到构建出来的容器镜像tar包，同时`isula-build`本地storage也可以查询到我们tag之后的容器镜像。为了load功能的演示方便，我们先将容器镜像从`isula-build`的storage删除，然后再次导入：

```
# 通过容器镜像ID删除$ sudo isula-build ctr-img rm 3512$ sudo isula-build ctr-img images-------------------------  -----------  -----------------  -----------------------  --------- REPOSITORY                 TAG          IMAGE ID           CREATED                   SIZE      -------------------------  -----------  -----------------  -----------------------  --------- localhost/my-openeuler     latest       40fd8ba7f278       2020-08-03 20:52:51       635 MB      -------------------------  -----------  -----------------  -----------------------  ---------# 导入容器镜像，输入文件也可以是docker save得到的容器镜像$ sudo isula-build ctr-img load -i ./my-image.tar ...Loaded image as 3512e0c83ad2c40d504a477a7aeea8ab4ee12254a76576aaa27d75c395d290fd$ sudo isula-build ctr-img images------------------------  -----------  -----------------  ---------------------  ---------- REPOSITORY                TAG          IMAGE ID           CREATED                   SIZE      ------------------------  -----------  -----------------  ---------------------  ---------- localhost/my-openeuler    latest       40fd8ba7f278       2020-08-03 20:52:51       635 MB     localhost/my-image        V0.1         3512e0c83ad2       2020-08-03 20:54:33       635 MB    ------------------------  -----------  -----------------  ---------------------  ---------
```

从上述示例可以看出，`import/load`命令使得容器镜像的来源更加丰富，我们可以基于`import/load`进来的容器镜像继续构建自己的容器镜像。同时，`save`命令使得`isula-build`可以在任何时候保存已经构建好的容器镜像。

## 新特性展望

目前的`isula-build`主要解决了`iSula`容器全栈中容器镜像构建从无到有的问题，之后我们会推出一些新的特性来进一步增强和完善`iSula`容器生态。主要有以下方面：

1. rootless构建。目前`isula-build`的所有操作只能在root用户下进行，基于安全考虑，后续会推出rootless构建，通过UID/GID的映射，将构建任务放到user namespace中以普通用户权限执行。
2. 在构建侧支持SmartLoading。SmartLoading，简单得说是实现了基于镜像仓库的文件系统，\`isulad\`\[13]在启动容器的过程中，当需要下载镜像时，只下载元数据信息，而只有当容器中的进程真正访问到镜像文件时，才会触发实时下载。SmartLoading极大提高了容器启动速度，同时按需下载节省了网络带宽和存储资源。详见\[SmartLoading设计方案](https://gitee.com/openeuler/iSulad/wikis/SmartLoading%E8%AE%BE%E8%AE%A1%E8%AF%B4%E6%98%8E?sort\_id=2385617\[14])。
3. build everything。`isula-build`在设计之初，就考虑到其不仅仅实现容器镜像构建和管理，还需要承担其他的构建任务，例如：
   
   - 基于操作系统ISO裁剪并构建出容器基础镜像
   - 输入为非dockerfile的镜像（例如：输入为源码文件构建wasm镜像）
   - 虚机容器的initrd等

敬请期待。

### 参考资料

\[1]

openEuler: *https://gitee.com/openeuler*

\[2]

isula-build: *https://gitee.com/openeuler/isula-build*

\[3]

社区文档: *https://gitee.com/openeuler/isula-build/blob/master/README.md*

\[4]

社区README: *https://gitee.com/openeuler/isula-build/blob/master/README.md*

\[5]

社区使用说明文档: *https://gitee.com/openeuler/isula-build/blob/master/doc/usage.md#configuration*

\[6]

storage库: *https://github.com/containers/storage/blob/master/docs/containers-storage.conf.5.md*

\[7]

image库: *https://github.com/containers/image/blob/master/registries.conf*

\[8]

`isulad`: *https://gitee.com/openeuler/iSulad*

\[9]

`isulad`: *https://gitee.com/openeuler/iSulad*

\[10]

开源社区文档: *https://gitee.com/openeuler/isula-build/blob/master/doc/usage.md*

\[11]

开源社区文档: *https://gitee.com/openeuler/isula-build/blob/master/doc/usage.md*

\[12]

基础镜像下载地址: *http://117.78.1.88:82/dailybuilds/openeuler/mainline/openeuler\_X86/openeuler-2020-07-28-10-17-40/Software/x86\_64/DockerStack/openEuler-docker.x86\_64.tar.xz*

\[13]

`isulad`: *https://gitee.com/openeuler/iSulad*

\[14]

SmartLoading设计方案: *https://gitee.com/openeuler/iSulad/wikis/SmartLoading设计说明?sort\_id=2385617*

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibOspOSKHic8Nh8icmf9xozgIK5j5ibJibMLzCLhbSoicDQOrVDQpZKX2nkBA/640?wx_fmt=png)

***观众老爷们不考虑点一波关注***

***支持一下这个快要秃顶的主编吗？***

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbR3YNaNBytF0uqAicKL7fRD0JJj1HibCo2Sic0qxQ1LkZPlLqibMPxWUBBGeOOicicX3yY8e2icz81TU7Fg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYCjA16Qbj8RtLq6ZdzGlsR9Llaa49Bia9A8SlgicOgPZoDYZB2pxuLtp7FkmXvaIoZHRBUkAB6hA7w/640?wx_fmt=png)
