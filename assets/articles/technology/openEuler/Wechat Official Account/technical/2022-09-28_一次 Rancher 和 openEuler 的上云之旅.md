# [一次 Rancher 和 openEuler 的上云之旅](https://mp.weixin.qq.com/s/j6HfGMrHkLq1U9PyPXqtFw)

[OpenAtom openEuler](javascript:void%280%29;)*2022-09-28 22:30:00*

作者简介

张智博，SUSE Rancher 大中华区研发总监，一直活跃在研发一线，经历了 OpenStack 到 Kubernetes 的技术变革，在底层操作系统 Linux、虚拟化 KVM 和 Docker 容器技术领域都有丰富的研发和实践经验。

Rancher 是一套开源的企业级容器管理平台，支持大量的 Kubernetes 发行版以及 Linux 操作系统，[将 openEuler Linux 纳入支持体系是我们近期开展的一项工作。](http://mp.weixin.qq.com/s?__biz=MzkyNzM4Nzk1NQ%3D%3D&mid=2247502571&idx=1&sn=0a29ff4d4d7af871b92ec627358cc7dd&chksm=c22a52b7f55ddba199e6301c845004ed217dc3eac3c85b477fc292dd9c908c8f1fed0e984c28&scene=21#wechat_redirect)

这是一次 Rancher 和 openEuler 的上云之旅，同时也是我们内部工程体系的一部分，一旦纳入一种新的 OS，就需要让它能在云端启用，这是云原生时代的大势所趋。本文展示了使用 AWS 平台这一上云过程，并搭建了一套 Rancher+openEuler 的环境用于展现这种能力。

文中提到的相关产品版本信息如下：

openEuler

22.03 LTS

Rancher

v2.6.8

K3s

v1.24.4+k3s1

RKE2

v1.24.4+rke2r1

**![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/NtlzSROAibIroY8JFs0zaO5BbxY9ribQKAiaceVS95YccdIMWQQItyy912JYJYoh0b2Mvb3DgaOeyXqibwXGxwuspw/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1)**

**构建 openEuler AMI**

openEuler 在 Cloud Image 这方面还不够完善，目前主要提供 ISO 镜像，在 Cloud Image 层面还只有一个简单的 QCOW2 Image。我们首先实现了一套工程化方法，将 openEuler QCOW2 Image 转换为 AWS AMI，这样我们可以在云端灵活部署启用。

这个过程需要做一些额外工作，我们重新调整了社区 QCOW2 Image 的 rootdisk 分区，引入了可以适配云环境的相关软件包，并通过 scripts+packer 工具实现了整体构建。构建 AMI 的同时，也顺带解决了以下问题：

- 无法动态注入 ssh key；
- 无法自动扩容根磁盘；
- 禁用 Apparmor，确保容器正常启动（实际不应该直接禁用，后续会寻找更加合理的解决办法）；
- 默认内置云原生场景必要的基础软件包（避免测试部署时手动安装）；
- openEuler ARM64 系统缺少 ENA 驱动，导致 EC2 ARM 实例网络无法激活。

后续，我们会推动在 openEuler 社区建设 Cloud Image。对于云原生场景，很显然这是一项非常重要的基础工作。

**![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/NtlzSROAibIroY8JFs0zaO5BbxY9ribQKAiaceVS95YccdIMWQQItyy912JYJYoh0b2Mvb3DgaOeyXqibwXGxwuspw/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1)**

**部署 Rancher 以及下游集群**

openEuler 虽然内置了 Docker 引擎，但最终我们仍然决定不使用 Docker。从Kubernetes 生态角度来看，Docker 已不再是必需品。Rancher 无论是管理平面还是下游集群，也不会强烈依赖 Docker；而且 Containerd 已经内置到 K3s 和 RKE2 中，也不需要 openEuler 的 Containerd 软件包。

在这个层面解耦是非常重要的，因为操作系统的软件包存在很强的依赖关系，减少这种和 OS 软件包的冲突，更有利于运维管理。未来，也会考虑将欧拉开源社区中的轻量化容器引擎 iSulad 等引入到我们的方案中，为客户提供更为灵活多样的选择。

我们设计了一个部署架构，它可以快速展示 Rancher+openEuler 的能力：

- 使用 AMD64 AMI，启动一台 EC2 实例，部署 K3s；
- 在此 K3s上，部署 Rancher Server；
- 使用 ARM64 AMI，启动一台 EC2 实例，部署 K3s ARM64 版本，将其以导入方式纳管到 Rancher；
- 使用 Rancher 中的 EC2 Node Driver，弹性创建 RKE2 集群，AMI 使用 AMD64 镜像。

Local K3s 和 Rancher Server 的安装较为简单，这里我们可以直接简化为两行脚本：

```
curl -sfL https://get.k3s.io | K3S_TOKEN=SUSERancherGC sh -s - server --cluster-initcurl https://raw.githubusercontent.com/cnrancher/autok3s/master/assets/rancher-setup/rancher-l7.sh | sh -
```

另一个 K3s ARM64 集群的创建和导入也十分简单，无需特别的参数处理。一旦 K3s ARM64 和 Rancher Server 都准备妥当之后，使用 Generic Import 导入即可。实际，我们可以看到这样的效果：

![](https://mmbiz.qpic.cn/mmbiz_png/pBj1sPmaOic6rCy8chU0RH644iauNfVuDjia55Ds1UhMhNcgiaRicDMmM8ibcqTr6GQCQqne5LLvJibFNBQWvey0QMSXA/640?wx_fmt=png)

基于 EC2 Node Driver 配置弹性 RKE2 集群相对复杂一些。首先需要配置好 AWS 的访问密钥，Rancher 支持大量的公有云生态，在 AWS 上使用过程和其他云基本一致。

![](https://mmbiz.qpic.cn/mmbiz_png/pBj1sPmaOic6rCy8chU0RH644iauNfVuDj29seKU1MQYqJwvIbp3tibyM9RWAyyqM9yGwibpVJg9ibCn8wke5RV20Zg/640?wx_fmt=png)

创建 RKE2 集群时，选择 EC2 Node Driver，配置 RKE2 节点模板，以及集群的基础参数配置。在 AWS 上，选择先前构建的 AMI，并使用 openEuler 作为 SSH User，同时选择 Spot 竞价实例，对于普通的测试环境可以极大程度减少费用。

![](https://mmbiz.qpic.cn/mmbiz_png/pBj1sPmaOic6rCy8chU0RH644iauNfVuDjEJuv6H7yL18yz1apvKpiaM1oYndtwCKxFEnEU5dqic1V46fia1TI42P0Q/640?wx_fmt=png)

通过 UI 以 SSH 灵活访问 RKE2 节点，这些节点使用 openEuler Linux。这取决于我们先前配置 openEuler AMI 以及其 SSH User。

![](https://mmbiz.qpic.cn/mmbiz_png/pBj1sPmaOic6rCy8chU0RH644iauNfVuDjbN9xqibz8hEhNMbsrvVS26icxoaCRhzpNNbXKxU642bHghLKBMlI0lqg/640?wx_fmt=png)

使用 Node Drvier 方式最具特色的能力，就是可以快速进行集群扩容。因为 Rancher 连接了 EC2 API，并且会根据集群配置状态自动将部署任务下发给新的 openEuler 节点。

![](https://mmbiz.qpic.cn/mmbiz_png/pBj1sPmaOic6rCy8chU0RH644iauNfVuDjCgV79FreViaub4pSogWFD2lIy1WK8IRwjwW57heuUcyNKMrI5gJ6Y8A/640?wx_fmt=png)

对于集群内的资源管理，可以切换到集群浏览视图，对每个 workload 资源精细化管理。

![](https://mmbiz.qpic.cn/mmbiz_png/pBj1sPmaOic6rCy8chU0RH644iauNfVuDjgnaTPlpprwibXB3OZfDR9dpHG1ftumSibCWIh31Qpc0gBKBqiceF8bHTw/640?wx_fmt=png)

这样，我们就完成了 Rancher 和 openEuler 的初步上云之旅。一个单节点的管理平面，两个下游集群，分别是 K3s 集群和 RKE2 集群，并且 K3s 使用了 ARM64 系统。同时，一定程度展示了 Rancher 的多云多集群的管理能力。

![](https://mmbiz.qpic.cn/mmbiz_png/pBj1sPmaOic6rCy8chU0RH644iauNfVuDjrDatgVKfibYxbia3OaEqQUs53zDyjy7FC8x6Sq67amZsFzQBrJckY9yw/640?wx_fmt=png)

**![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/NtlzSROAibIroY8JFs0zaO5BbxY9ribQKAiaceVS95YccdIMWQQItyy912JYJYoh0b2Mvb3DgaOeyXqibwXGxwuspw/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1)**

**未来商业化思考**

通过 Rancher 对公有云的整合能力以及 Kubernetes 发行版的管理能力，可以很顺畅地将 openEuler 带入公有云环境。不但扩充了 Rancher 的兼容矩阵，也连接了 openEuler 生态。

SUSE 作为传统 Linux 厂商，也基于 openEuler 构建了自己的商业发行版 SUSE Euler。同时，Rancher 在商业化层面也有 Rancher 企业版，通过 Rancher 企业版和SUSE Euler 的组合，可以为客户带来更稳定的商业技术支持。

![](https://mmbiz.qpic.cn/sz_mmbiz_png/zGadXBpNBBoKvtLJf1mP3jSLOSbedmibWwLw45damB9Z752uRfqgnhCFkATUuH3nCvaUtlNVRezPFTnEicXCSMvg/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

**About SUSE Rancher**

Rancher是一个开源的企业级Kubernetes管理平台，实现了Kubernetes集群在混合云+本地数据中心的集中部署与管理。Rancher一向因操作体验的直观、极简备受用户青睐，被Forrester评为“2020年多云容器开发平台领导厂商”以及“2018年全球容器管理平台领导厂商”，被Gartner评为“2017年全球最酷的云基础设施供应商”。

目前Rancher在全球拥有超过三亿的核心镜像下载量，并拥有包括中国联通、中国平安、中国人寿、上汽集团、三星、施耐德电气、西门子、育碧游戏、LINE、WWK保险集团、澳电讯公司、德国铁路、厦门航空、新东方等全球著名企业在内的共40000家企业客户。

2020年12月，SUSE完成了对RancherLabs的收购，Rancher成为了SUSE"创新无处不在(Innovate Everywhere)"企业愿景的关键组成部分。SUSE和Rancher共同为客户提供了无与伦比的自由和所向披靡的创新能力，通过混合云IT基础架构、云原生转型和IT运维解决方案，简化、现代化并加速企业数字化转型，推动创新无处不在。

当前，SUSE及Rancher在中国大陆及港澳台地区的业务，均由数硕软件（北京）有限公司承载。SUSE在国内拥有优秀的研发团队、技术支持团队和销售团队，将结合Rancher领先的云原生技术，为中国的企业客户提供更加及时和可信赖的技术支撑及服务保障。
