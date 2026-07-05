# [在 openEuler 上通过 KubeEdge+iSulad 搭建云边协同集群](https://mp.weixin.qq.com/s/YagK4MMPBWHE1Jv_rtv8ow)

[OpenAtom openEuler](javascript:void%280%29;)*2021-11-12 17:59:54*

9 月 30 日，全新的 openEuler 21.09 正式发布。openEuler 21.09 是欧拉正式升级面向数字基础设施的开源操作系统后的第一个社区创新版本，基于一套操作系统架构，支持多样性设备、应用一次开发，覆盖全场景。面向数字基础设施的开源操作系统 openEuler，联手面向万物互联的智能终端操作系统鸿蒙，进一步打通数字全场景。伴随 openEuler 社区的快速发展，面向场景化的 SIG 不断组建，openEuler 的应用边界从最初的服务器场景，逐步拓展到云计算、边缘计算、嵌入式等更多场景。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbV0cByYrAVKeHg1r1Ej0nTqSbasCGSbLg3alTiaAtTDbwj0OzUpc5OnnW754DCPkIJiab2AnaZV3ibA/640?wx_fmt=png)

## 概述

随着边缘设备数量指数级增长，以及设备性能的提升，数据量爆发式增长，数据规模已由原来的 EB 级扩展到 ZB 级。数据回传中心云处理成本太高，目前业界对边缘计算的价值已经被证明。openEuler 21.09 发布了边缘版本 openEuler 21.09 Edge 探索边缘计算场景的能力。openEuler 21.09 Edge 集成了边云协同框架 KubeEdge，具备边云应用统一管理和发放等基础能力，未来将通过增强智能协同提升 AI 易用性和场景适应性，增强服务协同实现跨边云服务发现和流量转发，增强数据协同提升南向服务能力。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbV0cByYrAVKeHg1r1Ej0nTys5QUuicBLmCLfXaHfNtdrbxUJPKLQIQk2YhMcIp04puRfwO7ehy8Kw/640?wx_fmt=png)

目前提供统一的跨边云的协同框架（KubeEdge+），实现边云之间的应用管理与部署，跨边云的通信，以及跨边云的南向外设管理等基础能力。配置感知：GitOps 会感知 git 配置库中集群配置信息的变化，给部署引擎发起集群相应的操作请求。

未来还将提供：

1. 边云服务协同：边侧部署 EdgeMesh Agent，云侧部署 EdgeMesh Server 实现跨边云服务发现和服务路由；
2. 完善边缘南向服务：南向接入 Mapper，提供外设 Pofile 及解析机制，以及实现对不同南向外设的管理、控制、 业务流的接入，可兼容 EdgeX Foundry 开源生态；
3. 边缘数据服务：通过边缘数据服务实现消息、数据、媒体流的按需持久化，并具备数据分析和数据导出的能力
4. 边云 AI 协同架构（Sedna）：基于开源 sedna 框架，提供基础的边云协同推理、联邦学习、增量学习等能力， 并实现了基础的模型管理、数据集管理等，使能开发者快速开发边云 AI 协同特性，以及提升用户边云 AI 特性的 训练与部署效率。

openEuler 21.09 Edge 深度集成了边云协同框架 KubeEdge，操作系统镜像内置了 KubeEdge 全套的软件包并配套详细的部署文档，用户可以按照文档简单、快速的启动 KubeEdge，将运行了 openEuler 21.09 Edge 的设备纳管成一个边缘节点。边缘节点可以理解为地理位置分布在“边缘”的 K8s 工作节点，对于用户来说与 K8s 工作节点无异，它用于运行边缘应用，处理用户的数据，并安全、便捷地和云端应用进行协同。openEuler 21.09 Edge 启用 KubeEdge 参考文档：《KubeEdge 部署文档》。KubeEdge 100%兼容 Kubernetes 原生能力，支持用户使用 Kubernetes 原生 API 统一管理边缘应用，此外还具有独有的设备管理 API 用于管理海量边缘设备，openEuler 21.09 Edge 使用 KubeEdge 的使用手册请参考：《KubeEdge 使用手册》。

## 边缘计算平台 KubeEdge

### 边缘计算的挑战

边缘计算的应用场景已经深入到社会的方方面面并与人们的生活息息相关，例如智能家居、智能医疗、智慧城市、车联网、工业互联网、智慧城市、AR/VR/MR、智慧农业、智能零售等等。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbV0cByYrAVKeHg1r1Ej0nTPQyGq2nOTxE5oL7UDVhKia662ZC2XJuZRCYia3Ok8icCDWib5qOX23icCdQ/640?wx_fmt=png)

不同的应用场景下边缘计算的形态与定义具有差异性，主要分为现场/接入边缘、城市边缘、省级边缘和中心云等不同的形态，不同形态下的典型应用与算力需求都是不同的。边缘计算形态的差异性和自身特点带来了诸多的挑战：

- 边缘计算**细分领域众多**，**互操作性差**
- **边云通信网络质量低**，时延高，且边缘经常位于私有网络，难以实现双向通信
- **边缘资源受限**，需要轻量化的组件管理运行边缘应用
- 边缘离线时，需要具备**业务自治**和**本地故障恢复**等能力
- **边缘节点高度分散**，如何高效管理，降低运维成本
- 如何对**异构资源**进行标准化管理和灵活配置

### 边云协同框架 KubeEdge

KubeEdge 依托于 K8s 的容器编排和调度能力，并为云和边缘之间的网络，应用部署和元数据同步提供基础架构支持的开源系统。KubeEdge 结合了云原生的核心优势，解决了边缘计算场景下的挑战，在生态上保持开放，并支持海量边缘设备管理、支持复杂的边云网络环境、应用/数据边缘自治等能力。KubeEdge 在架构上分为云端组件 CloudCore 和边缘侧 EdgeCore，详细的架构细节可以参考文档：

https://docs.kubeedge.io/en/docs/architecture/

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbV0cByYrAVKeHg1r1Ej0nT9icib951tn2I3pwXURLM8HibiaCQ4sUTgic7LcWWp4bPVVUzqUQB35IV9eA/640?wx_fmt=png)

**KubeEdge 架构图**

openEuler 21.09 Edge 已集成 KubeEdge 全套软件包，支持搭载了 openEuler 21.09 Edge 操作系统的机器可以部署 CloudCore 组件，成为云端设备，或者部署 EdgeCore 组件，成为边缘节点。openEuler 21.09 Edge 现已在多个边缘应用场景中落地，作为边缘计算的基础底座。

### 边云服务协同 EdgeMesh

边缘计算场景下的边缘节点大多呈离散式分布，节点之间的物理网络拓扑非常复杂。边缘网络割裂，微服务跨边云、边边部署，微服务间如何自动发现及互相通信是一个需要解决的难题。分布式协同网络插件 EdgeMesh 作为 KubeEdge 的一部分，屏蔽了复杂的边缘网络，负责数据面的流量代理工作，其核心优势在：

- 跨子网通讯：基于 LibP2P 实现，利用中继和打洞技术来提供容器间的跨子网边边和边云通讯能力。
- 云原生体验：为 KubeEdge 集群中的容器应用提供与云原生一致的服务发现与流量转发体验。
- 轻量化：每个节点仅需部署一个 Agent，边缘侧无需依赖 CoreDNS、Kube-Proxy 和 CNI 插件等原生组件。
- 低时延：通过 UDP 打洞，完成 Agent 之间的点对点直连，数据通信无需经过多次中转。
- 高可靠性：在底层网络拓扑结构不支持打洞时，通过 Server 中继转发流量，保障服务之间的正常通讯。
- 非侵入式设计：使用 Kubernetes Service 原生接口，无需自定义 CRD，降低用户学习和使用成本。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbV0cByYrAVKeHg1r1Ej0nT6m06bib6I2TXgtGFmtMk2Pa4kzCMgWuEQlhWic17KSDJfjELM955ttDw/640?wx_fmt=png)

**EdgeMesh 架构图**

EdgeMesh 现已从 KubeEdge 中解耦，支持插件化部署，详细的部署文档可参考：https://github.com/kubeedge/edgemesh。EdgeMesh 与 Istio 之间的对比测试结果表明：在资源占用方面，EdgeMesh 会比 Istio 少得多。主要原因在于 Istio 的 sidecar 模式会在每一个 Pod 中注入一个 istio-proxy 代理组件，而 EdgeMesh-Agent 是节点级的代理组件，每个节点仅有一个。单个数据面的资源开销 edgemesh-agent 也比 istio-proxy 要少：内存消耗是 istio-proxy 的 30%左右，CPU 消耗是 istio-proxy 的 10%左右。

### 边云 AI 协同架构：Sedna

人工智能也正逐步向边缘迁移，将云上 AI 能力下沉到边缘节点，做到本地处理，打通 AI 的最后一公里。在 KubeEdge 社区中，AI 类应是使用最多的边缘应用，目前有非常多的开发者和用户正在基于 KubeEdge 部署边缘 AI 应用。KubeEdge SIG AI 致力于解决 AI 在边缘落地过程中的上述挑战，提升边缘 AI 的性能和效率。结合前期将边云协同机制运用在 AI 场景的探索，AI SIG 成员联合发起了 Sedna 子项目，将最佳实践经验固化到该项目中。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbV0cByYrAVKeHg1r1Ej0nTZOjibRVmG9LicnIyuNMDXpcBMnPmHTFHiaHuicicBlv4QCgUj9jscJeED5Q/640?wx_fmt=png)

**Sedna 架构图**

Sedna 基于 KubeEdge 提供的边云协同能力，实现 AI 的跨边云协同训练和协同推理能力，支持业界主流的 AI 框架，包括 TensorFlow/Pytorch/PaddlePaddle/MindSpore 等，支持现有 AI 类应用无缝下沉到边缘，快速实现跨边云的增量学习，联邦学习，协同推理，联合推理，终身学习等能力，最终达到降低成本、提升模型性能、保护数据隐私等效果。Sedna 的核心特性如下：

- **提供边云协同 AI 基础框架**：提供基础的边云协同数据集管理、模型管理，方便开发者快速开发边云协同 AI 应用
- **提供边云协同训练和推理框架**：- 联合推理: 针对边缘资源需求大，或边侧资源受限条件下，基于边云协同的能力，将推理任务卸载到云端，提升系统整体的推理性能 - 增量训练: 针对小样本和边缘数据异构的问题，模型可以在云端或边缘进行跨时间自适应优化 - 联邦学习: 针对数据大，原始数据不出边缘，隐私要求高等场景，模型在边缘训练，参数云上聚合，可有效解决数据孤岛的问题 - 终身学习：针对小样本和边缘数据异构的问题

通过云端知识库提供记忆功能，让边缘积累的样本知识能在持续更新同时被持久化，从而处理灾难性遗忘问题；结合增量训练和多任务训练，同时实现跨时间与跨情景的知识迁移，从而更好地处理未知任务。

### one more thing

- 兼容主流 AI 框架 TensorFlow、Pytorch、PaddlePaddle、MindSpore 等
- 针对云边协同训练和推理，预置难例判别、参数聚合算法，同时提供可扩展接口，方便第三方算法快速集成

## openEuler + iSulad +KubeEdge

KubeEdge 的边缘侧组件 EdgeCore 支持容器运行时接口（CRI），使边缘能够使用各种容器运行时，如 Docker、containerd、CRI-O 等，而无需重新编译。这次的 openEuler 21.09 Edge 版同时预安装了 iSulad，openEuler+iSulad+KubeEdge 强强联手，为边缘计算带来极致轻量的、快速的边缘应用部署体验。

### 什么是 iSulad

iSulad 是一个轻量级容器 runtime 守护程序，专为 IOT 和 Cloud 基础设施而设计，具有轻便、快速且不受硬件规格和体系结构限制的特性，支持 ARM 和 X86 等体系架构，可以被更广泛地应用在云、IoT、边缘计算等多个场景。

iSulad 的技术特点如下:

- 轻量语言：C/C++/Rust
- 北向接口：提供 CRI 接口，支持对接 Kubernets;同时提供便捷使用的命令行
- 南向接口：支持 OCI runtime 和镜像规范，支持平滑替换
- 容器形态：支持系统容器、虚机容器等多种容器形态
- 扩展能力：提供插件化架构，可根据用户需要开发定制化插件

以上的特点使得 iSulad 可以不受硬件规格和架构的限制，更小的底噪开销也使得它的可应用领域更为广泛。

上文已经说到本次发布的 openEuler 21.09 Edge 版同时预安装了 iSulad，开箱即用，用户在安装完 openEuler 21.09 Edge 系统后即可直接使用 iSulad，在使用方式上与 Docker 无任何差异，用户可以直接上手使用。通过简单的配置，KubeEdge 即可采用 iSulad 作为容器引擎启动。

### openEuler 集成 KubeEdge 验证

openEuler 21.09 Edge 在版本发布之前，分别在不同的架构如 x86、arm，虚拟机、物理机上进行了严格的验证工作并通过。本小节将简单的指导 openEuler 21.09 Edge 的核心使用流程，具体的使用方式还请参考《KubeEdge 部署文档》。

**系统安装**

安装 openEuler 21.09 Edge 系统是使用它的第一步，openEuler 提供了美观、友好的安装界面供系统安装人员便捷地安装系统：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbV0cByYrAVKeHg1r1Ej0nTZ3BdH0kNg4dU9s3x4Fd52wUv8jzPkTtI2wiaAlXGTNHg0S6JA4TeGuw/640?wx_fmt=png)

**openEuler 21.09 Edge 系统安装界面 1**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbV0cByYrAVKeHg1r1Ej0nTl6zvxsxKtRYjL608FpFJbNusCicQyFiaLfaoFekV88r08mib1IkibXTjicw/640?wx_fmt=png)

**openEuler 21.09 Edge 系统安装界面 2**

正式进入系统：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbV0cByYrAVKeHg1r1Ej0nTBF40mOSGBXpXxNpNf1AuXwj02T9BJbRkuIToyUjD9AKkhjdaHJQcRg/640?wx_fmt=png)

启用 KubeEdge

### 组件版本

组件版本OSopenEuler 21.09Kubernetes1.20.2-4iSulad2.0.9-20210625.165022.git5a088d9cKubeEdgev1.8.0

### 节点规划（示例）

节点位置组件10.2.5.7云侧（cloud）k8s（master）、isulad、cloudcore10.2.5.8边缘侧（edge）isulad、edgecore

前文说过 KubeEdge 是基于 Kubernetes 构建的，所以启用 KubeEdge 之前我们需要在 cloud 节点上部署 Kubernetes 控制面组件。你可以按照《KubeEdge 部署文档》里面描述的直接使用 kubeadm 工具进行联网快速安装 Kubernetes，也可以使用 openEuler 离线安装 Kubernetes 的方式。前者部署方便，但需要能够连接外网，后者则可以离线安装，具体方式请参考

https://docs.openeuler.org/zh/docs/21.09/docs/Kubernetes/Kubernetes.html。

**云侧组件部署**

可以选择 KubeEdge 配套的 keadm 一键式部署工具进行部署（需要联网）：

```
keadm init --advertise-address="10.2.5.7" --kubeedge-version=1.8.0
# 注意--advertise-address参数填写自己机器的IP
```

也可以选择直接启动 CloudCore（无需联网）：

```
cloudcore --defaultconfig > /etc/kubeedge/config/cloudcore.yaml
# 编辑cloudcore.yaml配置自己机器的IP
./cloudcore &
```

这两种方式都可以使云侧组件 CloudCore 正常运行起来。

**边侧组件部署**

与云侧组件相同，都可以使用两种方式对边侧组件进行部署，而且部署的方式相同，这里不再赘述。

**下发边缘应用**

边缘应用多种多样，这里以 nginx 应用为例展示如果下发边缘应用：

```
# KubeEdge提供了一个nginx模板，我们可以直接使用
$ kubectl apply -f https://github.com/kubeedge/kubeedge/raw/master/build/deployment.yaml
deployment.apps/nginx-deployment created
```

查看是否部署到了边缘侧：

```
$ kubectl get pod -A -owide | grep nginx
default  nginx-deployment-77f96fbb65-fnp7n  1/1  Running  0  37s  10.244.2.4  edge.kubeedge  <none>  <none>
```

可以看到，应用已经成功部署到了 edge 节点。

## 总结

openEuler 社区企业已经超过 300 家，汇聚了处理器、整机到基础软件、应用软件、行业客户等全产业链伙伴，我们欢迎更多的软件企业和用户企业加入 openEuler、iSulad 和 KubeEdge 社区，共建数字基础设施全场景开源操作系统生态。

## 参考资料

1. 边缘版 openEuler 21.09 Edge 镜像下载：https://repo.openeuler.org/openEuler-21.09/edge\_img/
2. openEuler 集成 KubeEdge 文档：https://docs.openeuler.org/zh/docs/21.09/docs/KubeEdge/overview.html
3. iSulad：https://gitee.com/openeuler/iSulad
4. KubeEdge 官方文档：https://kubeedge.io/en/docs/
