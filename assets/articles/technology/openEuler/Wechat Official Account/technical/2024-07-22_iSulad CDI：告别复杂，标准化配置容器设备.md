# [iSulad CDI：告别复杂，标准化配置容器设备](https://mp.weixin.qq.com/s/qg9USbp5De_lM2TqFzDzEA)

[OpenAtom openEuler](javascript:void%280%29;)*2024-07-22 17:25:00北京*

**背景与现状**

随着容器技术的迅速发展，容器引擎已经成为云原生时代的基石。容器具有高度可移植、便捷快速部署、弹性可伸缩等优点，在云计算、大数据、人工智能等领域中作为关键的软件开发和部署方法，展现出了卓越的价值。在人工智能和大数据越来越普及的今天，如何让容器能够更快速、更便捷的使用GPU、NPU等设备也成为了社区热门课题之一。这也是容器引擎在大数据时代的短板之一。

**底层运行时的复杂度**

在过去，设备的使用比较简单，因此如果需要在容器中使用某设备，仅需在容器中暴露这个设备节点即可。例如，如果容器需要使用宿主机上的某个设备，只需要通过--device参数即可完成。

```
$ isula run -d -name test-device --device <major>:<minor> busybox:latest sleep 1000
```

随着AI浪潮的到来，越来越复杂的设备和配套软件对容器的部署提出了新的要求，GPU、高性能 NIC、FPGA、 InfiniBand 适配器等设备及其配套软件要求用户在部署容器时不仅仅只是挂载一个设备节点，往往还需要用户配置相关环境变量，挂载主机路径，甚至提前启动相关进程。以NVIDIA GPU为例， 用户在使用容器时，需要挂载大量文件，对于如此多的文件，每个容器使用 GPU 时都使用 --mount 去挂载无疑是低效且繁琐的。

```
$ nvidia-container-cli list/dev/nvidiactl/dev/nvidia-uvm/dev/nvidia-uvm-tools/dev/nvidia-modeset/dev/nvidia0/usr/bin/nvidia-smi/usr/bin/nvidia-debugdump/usr/bin/nvidia-persistenced/usr/bin/nvidia-cuda-mps-control/usr/bin/nvidia-cuda-mps-server......
```

为了方便用户使用，供应商通常不得不为不同的运行时编写和维护多个插件，甚至直接在运行时中插入特定于供应商的代码。例如，NVIDIA为使用 GPU 的容器提供了专门的NVIDIA Container Runtime方案，示意图如下：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBZbbRsyLbaFHe1nCxQLJr2N3Y9afp9dicp4jphkRZK7zLbXQIWKCVLQT6mBP0hK7fViavI1WXD2v7g/640?wx_fmt=png&from=appmsg)

图1 NVIDIA Container Runtime设计图\[1]

NVIDIA Container Runtime 的主要功能是将使用 GPU 设备所必需的驱动文件和可执行命令绑定到容器内，并执行一些hook命令，再调用runc原有流程启动容器。

很显然，一旦更换其他异构计算设备，就需要重新开发一套这样专门服务于该设备的容器运行时，这无疑是难以接受的。事实上，这些配置存在一些固定的特征，如果能有一种统一规范来规定整个流程，就可以轻松地为每个容器设备进行特定配置。

**Kubernetes管理面的复杂度**

如果供应商没有提供底层运行时，用户往往需要在容器管理面提供所需的底层信息，导致管理面配置高度复杂。

Kubernetes 提供了一个设备插件\[2]框架，允许供应商通过实现设备插件，将特定于供应商初始化和设置的计算资源发布到 Kubelet。在设备插件成功注册自身后可以响应 Allocate gRPC 请求，在 Allocate 期间，设备插件可以通过ContainerAllocateResponse，做一些特定于设备的准备，比如注解、挂载设备、配置环境变量等。同样，这些配置存在一些固定的特征，如果能有一种统一规范来规定整个流程，那么在设备插件的代码逻辑中就不用再重复这些功能。

**容器设备接口**

CDI(Container Device Interface-\[3])，容器设备接口，是一种用于支持第三方设备的容器运行时规范。它定义了一种机制，允许第三方供应商与设备进行交互，而无需修改容器运行时。CDI 使用类似于容器网络接口(CNI)的 JSON 配置文件，允许设备供应商通过配置文件对设备进行描述，从而运行时能够正确加载，比如：

- 向容器公开设备可能需要公开多个设备节点、从运行时命名空间挂载文件或隐藏procfs条目。
- 执行容器和设备之间的兼容性检查（例如：检查容器是否可以在指定设备上运行）。
- 执行特定于运行时的操作（例如：虚拟机与基于Linux容器的运行时）。
- 执行特定于设备的操作（例如：清理GPU的内存或重新配置FPGA）。

目前，NVIDIA Container Toolkit\[4]已逐步支持CDI规范。CDI在 Kubernetes v1.28 版本中作为 Alpha 特性被加入，并在 v1.29 版本中升级为 Beta 特性。

OpenAtom openEuler（简称"openEuler"）社区的容器引擎项目 iSulad\[5]始终紧跟上游社区，在v2.1.5版本完成了对CDI规范的支持，为容器设备和第三方供应商提供了统一的交互方案。

**容器设备加载规范化**

CDI规范化了容器设备的加载，大大降低了底层运行时的复杂度。

CDI引入了device作为资源的抽象概念。device由完全限定的名称唯一指定，该名称由vendor ID、一个device class和在每个vendor ID-device class对中唯一的name构成。一个 完全限定的 CDI 设备名称结构如下：

```
vendor.com/class=unique_name
```

在指定设备后，CDI通过JSON配置文件中的containerEdits字段参与容器创建，containerEdits中可以做到：

- env 设置环境变量。
- deviceNodes 挂载设备节点。
- mounts 挂载点。
- hooks 在容器不同生命周期运行特定的钩子。

那么，容器引擎是如何在创建容器时使用这些配置信息的呢？以iSulad为例，容器加载CDI设备的过程如下：

?

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBZbbRsyLbaFHe1nCxQLJr2eXukt9PsZWtCozPqEp08npStvx4fN3demxq79uH5QGwiaicWibwb8p6fA/640?wx_fmt=png&from=appmsg)

图2 iSulad CDI 时序设计图

 iSulad进程启动后，拉起一个新的线程cdi\_watcher，负责监控cdi-spec-dirs目录，当cdi-spec-dirs目录中的CDI 配置文件发生修改、删除等动作时，重新扫描cdi-spec-dirs目录中的CDI 配置文件，这可以保障每次创建容器时都使用最新的设备配置。

在kubelet发起创建容器的命令后， iSulad进程首先解析出命令中完全限定的 CDI 设备名称，随后找到名称对应的设备配置，生成新的OCI配置文件。

在kubelet发起启动容器的命令后， iSulad进程将新的OCI配置文件传递给runc，由runc拉起新的容器进程。

**Kubernetes设备插件化**

为了简化设备管理流程，Kubernetes社区将设备插件框架与CDI机制结合，大大减小了设备管理的复杂度。

用户可以通过设备插件的Allocate 返回完全限定的 CDI 设备名称到Kubelet，Kubelet 将此信息传递到容器运行时，随后容器运行时根据此名称找到相应的CDI配置。

这样我们在上层的设备插件中，只需要指定CDI设备名称，就能为容器的计算资源完成特定配置，大大减少了重复的代码逻辑。

**iSulad CDI**

iSulad在v2.1.5已支持通过CRI接口使用CDI功能。

**架构**

iSulad在device模块封装实现了CDI功能，在device模块内部，CDI Operate封装了CDI模块，对外提供更合理的CDI功能的相关接口。CDI负责实现CDI Specs的读取、校验、解析、devices注入OCI Spec等具体功能，如图：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBZbbRsyLbaFHe1nCxQLJr2t8UPpU5jLprUYo0hhQRiawu4u06WWm5A6IMFIWia43PXUOZ9elHDYqyg/640?wx_fmt=png&from=appmsg)

图3 iSulad CDI 设计图

**配置与使用**

使用方法可以参考iSulad支持CDI\[6]的用户使用文档。

1\. 配置iSulad支持CDI

需要对daemon.json做如下配置，然后重启iSulad：

```
{    ...    "enable-cri-v1": true,    "cdi-spec-dirs": ["/etc/cdi", "/var/run/cdi"],    "enable-cdi": true}
```

其中"enable-cri-v1"用于开启cri-v1特性，CDI的功能依赖于cri-v1；"cdi-spec-dirs"用于指定CDI specs所在目录，如果不指定则默认为"/etc/cdi", "/var/run/cdi"；"enable-cdi"用于开启CDI特性，默认不开启。

2\. 生成CDI config文件

假设已经生成了vendor.json规范。并保存在/etc/cdi/vendor.json位置，vendor.json中存在完全限定的 CDI 设备名称"vendor.com/device"="myDevice"，使用时需要保障JSON中的设备等信息与实际环境一致。

3.创建pod

可以使用如下pod config文件创建pod：

```
$ cat pod.json{    "metadata": {        "name": "test-sandbox",        "namespace": "testns",        "uid": "b49e1234-ee30-11ed-a05b-0242ac120003",        "attempt": 1    },    "log_directory": "/tmp",    "linux": {        "security_context": {            "namespace_options": {                "network": 0            }        }    }}$ crictl -i unix:///var/run/isulad.sock -r unix:///var/run/isulad.sock runp pod.json450d9f2d86afe9f35c07c051f0dd1c58ecde68b4ab3cfec7abe26c8a6a9fc419
```

4\. 创建并启动容器

Kubernetes可以通过两种方式指定CDI设备:

第一种方式：annotations中指定设备

```
{    ... ...    "annotations": [        ... ...        {"cdi.k8s.io/test": "vendor.com/device=myDevice"},        ... ...    ]    ... ...}
```

第二种方式：CDI\_Devices中指定设备

```
{    ... ...    "CDI_Devices": [        ... ...        {"Name": "vendor.com/device=myDevice"},        ... ...    ]    ... ...}
```

以第一种方式为例，完整的container.json如下：

```
$ cat container.json{    "annotations":{        "cdi.k8s.io/test": "vendor.com/device=myDevice"    },    "metadata": {        "name": "testcontainer"    },    "image": {        "image": "docker.io/library/busybox:latest"    },    "command": [        "/bin/sh", "-c", "while true; do sleep 10000; done"    ],    "log_path":"console.log",    "linux": {        "security_context": {            "capabilities": {},            "namespace_options": {                "network": 0,                "pid": 1            }        }    }}$ crictl -i unix:///var/run/isulad.sock -r unix:///var/run/isulad.sock create 450d9f2d86afe9f35c07c051f0dd1c58ecde68b4ab3cfec7abe26c8a6a9fc419 container.json pod.json
```

**加入我们**

文中所述的 iSulad组件，由 CloudNative SIG 参与，相关源码均已在 openEuler 社区开源。如果您对相关技术感兴趣，欢迎您的围观和加入。

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mAk7XGjrHQX48E1tGVyJGQcgaTxicyGy9UAaYQYrL3ADZeFvrsbKPgXGSSwxkrfJsQdiccRkoQyFGDw/640?wx_fmt=jpeg&from=appmsg)

**参考**

\[1] NVIDIA Cloud Native Technologies https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/arch-overview.html 

\[2] 设备插件, https://kubernetes.io/zh-cn/docs/concepts/extend-kubernetes/compute-storage-net/device-plugins/ 

\[3] Container Device Interface-, https://github.com/cncf-tags/container-device-interface- 

\[4] nvidia container toolkit, https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html 

\[5] iSulad, https://gitee.com/openeuler/iSulad 

\[6] iSulad支持CDI, https://gitee.com/openeuler/docs/blob/master/docs/zh/docs/Container/iSulad%E6%94%AF%E6%8C%81CDI.md
