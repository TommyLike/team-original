# [「转」NestOS Beta 正式发布，5大特性助力企业快速高效构建云原生环境](https://mp.weixin.qq.com/s/OrPFqSTvxkMk9pux7Wu0bw)

*NestOS*[OpenAtom openEuler](javascript:void%280%29;)*2022-01-28 18:39:12*

2022 年 1 月，在麒麟软件和欧拉开源社区的共同努力下，同时支持 x86\_64 和 aarch64 架构的 NestOS beta 版本终于发布啦！与此同时，NestOS 官网正式上线！欢迎各位伙伴前往官网下载体验！

**NestOS 官网**

**https://nestos.org.cn**

在硬件适配方面，目前 NestOS 在飞腾 FT2000+、S2500 与鲲鹏 Kunpeng920 等设备上完成了适配验证，支持以裸金属与虚拟化方式安装部署。未来我们也会持续扩展支持更多平台，为 NestOS 带来更多的可能性。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZCUrUVTlAIFnibXz1k79QLDibLIoQbzSqaynYKiauQ2nya7ayTKCbRB1l9WdliaQRr2512HLDuIgyJ7g/640?wx_fmt=png)

**NestOS beta 版本架构图**

NestOS 搭载了 docker、iSulad、podman、cri-o 等常见容器引擎，提供适配云场景下多种基础运行环境，并针对 Kubernetes 场景进行优化。同时在 IaaS 生态构建方面，我们将针对 openStack、oVirt 等平台提供支持；在 PaaS 生态构建方面，我们将会提供 OKD(openShift)、Rancher 等平台的相关支持，欢迎大家加入我们，一起发现和引入更多的特性。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZCUrUVTlAIFnibXz1k79QLDjbv57bl9L13BibUxHzqPzJqJI37VtDMu4NkEf0rkAHJ30LFWj0muvUw/640?wx_fmt=png)

**NestOS 的 roadmap 规划图**

#### NestOS技术特性

**开箱即用的容器平台**：容器技术克服了用户修改系统配置、用户服务对系统组件依赖冲突等导致大规模集群服务运维困难的问题，同时可以快速的安装部署、根据服务负载方便的实时扩展收缩以及节点运维时服务平滑迁移，是云原生时代最重要的基础核心。当前主流通用服务器操作系统需要安装部署后再次进行云场景适配调整，而 NestOS 集成适配了 iSulad、Docker、Podman 、cri-o 等主流容器引擎，做到开箱即用，可为用户提供一种轻量级、定制化的云场景操作系统。

**简单易用的安装配置过程**：NestOS 采用了 Ignition 技术，可以以相同配置方便地完成大批量集群节点安装配置工作。Ignition 是一个与分发无关的配置实用程序，用于系统的安装和配置并初始化 NestOS。Ignition 配置文件中可以包含对网络、存储、文件系统、systemd 单元和用户鉴权及权限管理等配置。安装阶段，NestOS 既支持引导启动安装镜像后手动运行 nestos-installer 命令，加载 Ignition 配置文件，完成 NestOS 本地安装；也可通过 PXE 方式，在启动引导参数中添加远程 Ignition 配置访问地址，实现大批量集群节点网络引导方式安装。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZCUrUVTlAIFnibXz1k79QLDcicgKHAXl157dhH3nD9icxSM36cicOF406tQD3hiaia5DWV39YRzo98y3Vg/640?wx_fmt=png)

**安全可靠的包管理方式**：NestOS 使用 rpm-ostree 进行软件包管理，rpm-ostree 可以看成是 rpm 和 ostree 的合体。Rpm-ostree 一方面提供了基于 rpm 的软件包安装管理方式，另一方面提供了基于 ostree 的操作系统更新升级。用户每次对系统更新都像是 rpm-ostree 在提交一次“Transaction”，确保更新过程全部成功或全部失败，并允许在更新系统遇到异常后回滚到更新前状态。

**友好可控的自动更新机制**：NestOS 提供自动更新服务，它作为远程更新服务和 rpm-ostree 的客户端，负责检测更新服务器是否存在更新版本，实现节点自动更新与重新引导。该服务支持自动更新代理、用户自定义配置文件和多种更新策略，用户可对是否自动更新、自动更新策略等选项进行配置，也可与上层集群服务相结合，将当前节点服务负载迁移后再行更新，实现集群节点有序升级，保证集群服务不因节点升级而中断。当集群节点需统一进行配置修改或基础环境更新时，可将修改完毕充分验证后的更新版本发布至更新服务器，集群节点将通过自动更新机制完成统一升级。

**紧密配合的双系统分区**：NestOS 采用双系统分区设计，两个分区分别被设置为主动模式和被动模式，并在系统运行期间各司其职。主动分区负责系统运行，被动分区负责系统升级，同时在系统运行期间主动分区被设置成只读状态，确保 NestOS 运行期间的完整性与安全性。当新版本操作系统发布时，一个完整的文件系统将被下载至被动分区，并在系统重启引导时从新版本分区启动，原来的被动分区将切换为主动分区，而之前的主动分区则被切换为被动分区，两个分区扮演的角色将相互对调，等待下一次系统更新。

#### 性能对比测试

使用 NestOS beta 版本横向对比 openEuler21.09、openEuler20.03LTS、Centos8 系统运行 docker,podman,iSulad 容器引擎性能。测试结果如下。x86\_64 和 aarch64 虚拟机参数如下:

ConfigurationInformationOSNestOS、openEuler21.09、openEuler20.03LTS、Centos8CPU8 coresMemory8 GB

软件版本：

NameVersioniSuladVersion 2.0.10dockerVersion: 18.09.0podmanopenEuler：Version 0.10.1  
nestos：Version 3.1.0  
centos8：Version 3.3.1

Docker（x86\_64）测试结果如下：

operator(ms)nestosopenEuler21.09openEuler20.03LTSCentos8Vs openEuler21.09vs openEuler20.03LTSVs centos8100\*create21672302100075406-6%-79%-60%100\*start11742175961923812450-34%-39%-6%100\*stop171311501111262436-86%-85%-30%100\*rm1733189220573191-9%-16%-46%

Docker（aarch64）测试结果如下：

operator(ms)nestosopenEuler21.09openEuler20.03LTSCentos8Vs openEuler21.09vs openEuler20.03LTSVs centos8100\*create1967236827039430-20%-37%-379%100\*start65297945710911074-21%-9%-45%100\*stop118411209110334435-846%-831%-74%100\*rm1379164516595511-17%-17%-75%

iSulad（x86\_64）测试结果如下：

operator(ms)nestosopenEuler21.09openEuler20.03LTSCentos8Vs openEuler21.09vs openEuler20.03LTSVs centos8100\*create817108336931340-25%-78%-40%100\*start1822225659473524-20%-70%-49%100\*stop3285071180584-36%-73%-44%100\*rm83989612721023-7%-35%-18%

iSulad(aarch64)测试结果如下：

operator(ms)nestosopenEuler21.09openEuler20.03LTSCentos8Vs openEuler21.09vs openEuler20.03LTSVs centos8100\*create55861411811077-10%-53%-49%100\*start1883201929272310-7%-36%-19%100\*stop2683343882555-20%-31%-853%100\*rm428547555694-22%-23%-39%

Podman(x86\_64)测试结果如下：

operator(ms)nestosopenEuler21.09openEuler20.03LTSCentos8Vs openEuler21.09vs openEuler20Vs centos8100\*create5892243832104011535-313%-257%-96%100\*start8560140861199716141-65%-40%-89%100\*stop5942198216582472+66%+72%+58%100\*rm688611756122093221-71%-77%+53%

Podman(aarch64)测试结果如下：

operator(ms)nestosopenEuler21.09openEuler20.03LTSCentos8Vs openEuler21.09vs openEuler20Vs centos8100\*create5361433123179470+19%+57%-76%100\*start9847116791088110699-18%-10%-8%100\*stop3422163117443781-52%-49%-10%100\*rm42348850103936181-53%-60%-32%

注：欧拉开源社区目前暂不支持podman，Nestos所使用podman将陆续合入欧拉开源社区社区。

**NestOS 使用文档**

**https://gitee.com/openeuler/NestOS**
