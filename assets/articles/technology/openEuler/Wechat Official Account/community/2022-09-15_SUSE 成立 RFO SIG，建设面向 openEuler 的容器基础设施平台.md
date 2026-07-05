# [SUSE 成立 RFO SIG，建设面向 openEuler 的容器基础设施平台](https://mp.weixin.qq.com/s/EOgFrbIJ4ffHTdNCgcejPg)

*RFO SIG*[OpenAtom openEuler](javascript:void%280%29;)*2022-09-15 21:00:00*

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZxabT31Ezrj2KdxLZ6FTGiaMWjtvP5594bXk8XZk5ibwW0JkMVongZr1mooCq4mTIXH0u0N1rZFqAA/640?wx_fmt=png)

北京时间 9 月 7 日，经欧拉开源社区技术委员会决议批准，由 SUSE 创建的 RFO SIG 正式成立。RFO 即 Rancher for openEuler，旨在将 Rancher 产品生态与 openEuler 深度结合，为欧拉开源社区构建容器工程基础设施，打造面向 openEuler 的 Rancher 衍生产品。

Rancher 最初是硅谷创业公司 RancherLabs 的开源项目，旨在帮助用户解决容器基础设施的管理问题。其在容器领域深耕多年，在全球范围内积累了大量的社区用户，中国区的安装量更是冠绝全球市场。2020 年底，RancherLabs 被 SUSE 收购，秉承了 SUSE“让开源真正开放”的产品理念，依然保持了对主流 Linux 发行版的持续兼容，这让 Rancher 与 openEuler 的融合得以顺利开展。

当前，Rancher 已经不再是单一的软件，它囊括了多集群管理平台 Rancher Manager，容器安全产品 NeuVector，RKE、RKE2、K3s 等众多 Kubernetes 发行版，超融合产品 Harvester 以及云原生存储产品 Longhorn 等，并扩展兼容了更多的公有云 Kubernetes 服务，形成了一套完整的企业级容器平台。

## 不局限于兼容性的工作

容器产品部署在 Linux 操作系统之上，两者的兼容性是相互结合的最直接体现。然而，如若真正想融入社区，推动其技术和产业发展，这些工作远远不够。真正围绕社区去贡献一些开源项目，并建设其依赖的基础设施，才能为社区带来真正的价值。秉持这一理念，RFO SIG 的目标并不只是兼容测试，而是建设一些开源项目，并提供持续的工程化。

## 打造基于 openEuler 的 Kubernetes 发行版

RFO SIG 的第一个目标，就是为欧拉开源社区构建属于自己的 Kubernetes 发行版（RFO 发行版）。拥有一套稳健的 Kubernetes 发行版，社区内的其他云原生项目才能得以落地，从而逐步促进社区云原生生态繁荣。云原生发展至今，Kubernetes 发行版已经百花齐放，那么基于 openEuler 的 RFO 发行版又有何不同？

- 完整可溯源的工程化。首先，确保核心组件从源码构建，openEuler 实现了从上游源码构建操作系统，RFO 同样从源码构建 Kubernetes 发行版；其次，开放 CI Build 历史记录和 e2e 测试结果。在这种模式下，任何个人或者厂商都可以依托这种工程机制进行二次分发。
- 产品化，开箱即用。建立发行版的生命周期和对 openEuler 的支持矩阵；依托 OCI Image 理念，尽量减少对 openEuler 各种 rpm 的依赖，以尽量降低对 rpm 依赖体系的破坏；除了基础的 Kubernetes 组件和 runtime 之外，还会一并打包一些基本 CNI 和 Ingress 生态组件，以确保产品的易用性和完整性。
- 充分融合 openEuler 生态。无论是构建环境镜像，还是最终用于部署的镜像，都尽量使用 openEuler Container Image。社区中孵化的 container runtime 项目 iSulad，也会进行产品化的打包整合，以便用户根据自身情况在 Containerd 和 iSulad 中做出选择。
- 供应链安全。当下，全球开源社区对供应链安全的关注度不断上升，Kubernetes 上游也在最近的版本中加入了这一检测机制。尤其对于普遍依托 OCI Image 方式分发的各种云原生软件，确保不被中间环节篡改是一项非常重要的工作。同时，伴随 RFO 发行版的开发，可信任的社区镜像仓库也将逐渐建设起来。

## 社区与商业化的联动

社区项目的孵化和持续发展离不开商业化落地的思考，能够形成社区产品和商业化产品的良好互动才是开源项目的长久发展之道。SUSE 在社区孵化 RFO 系列项目的同时，也会在自身的商业产品中增强对其的管理支持。例如，在 RFO 发行版工程化成熟之后，商业化属性的 Rancher 企业版即可加入对 RFO 集群管理能力的支持，结合 openEuler 的商业版本 SUSE Euler，构建一套上游开源孵化、下游商业增强的企业级容器产品方案。

对此，RFO SIG 的发起人 SUSE Rancher 大中华区研发总监张智博表示：“在 SUSE Euler 项目之后，SUSE 再次积极投身欧拉开源社区，是其践行‘立足中国，服务中国’ 理念的又一里程碑。内核和容器引擎是云原生软件的重要支撑，向开源社区投入底层技术的研发力量，也是 SUSE 开源能力的重要体现。SUSE 在中国拥有完整的容器产品研发团队，很早就开始独立进行本土的产品研发交付，在欧拉开源社区以开源方式运作产品，对我们来说也是一次很好的历练。”
