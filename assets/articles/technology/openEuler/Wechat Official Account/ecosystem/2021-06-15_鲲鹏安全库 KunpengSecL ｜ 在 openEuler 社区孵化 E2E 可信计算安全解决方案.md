# [鲲鹏安全库 KunpengSecL ｜ 在 openEuler 社区孵化 E2E 可信计算安全解决方案](https://mp.weixin.qq.com/s/9xWhGiV_GGA0O4i0V5vnfg)

[OpenAtom openEuler](javascript:void%280%29;)*2021-06-15 18:02:38*

在刚刚落幕的openEuler Developer Day 2021上，openEuler安全技术SIG（sig-security-facility）的maintainer之一魏刚向社区开发者介绍了社区孵化项目鲲鹏安全库（KunpengSecL）。本文将带大家一起来了解一下鲲鹏安全库的相关内容。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbu08XOpR95ib8Z9mXuYYH1Atv0VCwV6Gibg9aOXcziaC1y4NIAjico76aMk3oFibnmZolgPsiboCUlicUcw/640?wx_fmt=jpeg)

### 鲲鹏安全库 KunpengSecL小知识

> 鲲鹏安全库是最新openEuler孵化项目之一，开发运行在鲲鹏处理器上的基础安全软件组件，先期主要聚焦在远程证明等可信计算相关领域，使能社区安全开发者。它由安全技术SIG管理，目前处于项目初期开源开发状态。
> 
> - 项目仓库链接：https://gitee.com/openeuler/kunpengsecl
> - 项目开源许可协议：MulanPSL2（木兰宽松许可证）
> - 主要开发语言：Golang
> - 主要贡献者：gwei3，wucaijun2001
> - 目标：
>   
>   - 2021年完成远程证明基本功能的开发
>   - 2022年进入openEuler创新版本

### 支持E2E可信计算远程证明解决方案

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbu08XOpR95ib8Z9mXuYYH1A6icMtOF2iaWxvPiafVia2MOHzTCsicuFusaVAIlYBXbHmupD1o4VmzbHbhg/640?wx_fmt=png)

鲲鹏安全库的每个特性都可以由两大部分组成：组件和服务。组件部署在提供资源（计算、存储、网络）为用户运行工作负载的工作服务器节点上，将平台安全可信能力转化为软件接口，并将其提供给服务。服务则部署在专门的管理服务器节点上，汇聚来自所有工作服务器节点的安全可信能力，并将其提供给用户及其指定的管理工具以达成用户对系统安全可信设计的具体要求。

鲲鹏安全库的首个安全特性就是远程证明，目的就是帮助用户获取工作服务器节点的软硬件可信状态，支持端到端的可信计算远程证明解决方案，让各种资源管理工具可以根据可信报告制定策略，对各种服务器资源进行差异化的调度和使用。

#### 基于TPM的远程证明

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbu08XOpR95ib8Z9mXuYYH1A9m0mqGQBAOpu3G0SksQyrAo8spkeSKQzLmTyJEfbkaIia0wIDvFdaLw/640?wx_fmt=png)

既然说到了远程证明，就不得不先带大家回顾一下基于TPM的可信启动，本地证明和远程证明了。

TPM（Trusted Platform Module）是由专门聚焦可信计算技术基础规范制定的TCG（Trusted Computing Group）国际组织制定的支撑计算机系统实现可信计算框架的一种可信模块的规范。目前已经经历1.0，1.1，1.2，发展到了2.0的版本，并已成为国际ISO标准。

基于TPM的可信启动，就是在计算机平台的固件（通常是BIOS的入口代码块）中实现一个可信根，计算机系统启动从可信根开始，可信根度量（计算哈希值）后续需要执行的BIOS代码，并将度量值保存到TPM提供的平台配置寄存器（PCR）中，然后将执行权限交给后续BIOS代码。整个系统启动过程就遵照这种度量，记录，执行的规则完成BIOS，BootLoader，操作系统内核，驱动/内核模块，应用程序/动态代码库的可信启动执行。

基于TPM的本地证明，就是通过将本地需要使用的一些秘密信息，比如说磁盘加密密钥，通过TPM加密，同时对解密提出一个附加条件，就是TPM中指定的PCR集合的内容必须是特定的值。这也就规定了本地关键信息被允许使用时的系统完整性要求，实现了系统完整性的本地证明。

而基于TPM的远程证明，即将基于TCG规范可信启动的平台完整性度量结果传递给远程用户或计算机系统，由远程用户或系统来验证目标系统的系统完整性。整个过程中，为了防止恶意篡改，TPM会对上报的PCR集合的值进行签名；为了发现问题时能够定位到可信启动特定环节，需要将可信启动过程的度量清单进行收集，在远程证明的可信报告中一并发送；为了防止出现重放攻击，还需要在每次进行远程证明时加入一次性随机数。为了方便用户的使用，通常会构建一个远程证明服务来管理所有的工作服务器节点信息和验证白名单，完成对工作服务器节点的定期查询和验证。

### 可扩展的远程证明软件架构

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbu08XOpR95ib8Z9mXuYYH1A7jptuCD6yRTjJua7Q1Cr5tFg1QyCxibksuZ9h5IT47uiaEedcAKw5n3Q/640?wx_fmt=png)

鲲鹏安全库远程证明特性，将从成熟可信根领域（TPM）开始，支持复杂部署环境，支持多层次的可扩展性。

远程证明架构中的远程证明服务（RA Service或RAS）和远程证明客户端（RA Client或RAC）分别对应于鲲鹏安全库总体定义中的服务和组件。

远程证明服务RAS将通过PCA来为工作服务器上的TPM提供远程证明密钥证书，通过TrustMgr管理工作服务器可信相关数据信息，通过ClientAPI来接收工作服务器的可信报告，通过Verifier验证目标的可信状态，通过Cache提供可信状态缓存服务，通过Config管理策略等配置信息，最终通过RestAPI向用户提供远程证明服务。

远程证明客户端RAC将通过TBProvisioner解决部署阶段平台可信启动能力的检测和使能，通过RAC Tools来获取远程证明所需的各种数据信息，最后由RA Agent负责与RAS通信完成注册和可信报告发送。

RAC Tools负责屏蔽与可信模块及系统的交互细节，承担未来向不同可信模块扩展的责任。

RA Hub负责在需要时对本地域RAC进行通信汇聚和代理的功能，同时也将在未来负责提供RAC与RAS间通信通道适配的能力。

### 构建开发者与平台可信计算特性之间的桥梁

未来几年，鲲鹏安全库将充分发挥可扩展性，逐步扩展对TCM、TPCM、DICE等不同可信根及可信模块的支持，逐步引入对虚机、容器、安全容器等复杂基础架构和对BMC、边缘管理引擎等不同管理通道的支持，逐步尝试与OpenStack、K8S、SIEM等典型应用的集成，将平台可信计算特性以易用好用的方式带给广大开发者和用户。

欢迎社区开发者和最终用户积极参与到鲲鹏安全库从设计到开发各个环节的开源开发工作中来。有更多想法，欢迎到以下地址留下您的宝贵意见。

**https://gitee.com/openeuler/kunpengsecl/issues**

[阅读原文](https://gitee.com/openeuler/kunpengsecl/issues)
