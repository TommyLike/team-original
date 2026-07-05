# [openEuler Meetup 苏州站燃炸来袭！](https://mp.weixin.qq.com/s/G5KE7II96ODKy_BBBky_sQ)

[OpenAtom openEuler](javascript:void%280%29;)*2021-04-29 12:17:46*

自上世纪70年代软件商业化以来，软件为世界创造了巨大的财富。目前，全球市值排名前7的公司，其核心竞争力均来自于软件，其中开源软件产值占比逐年增加，**开源社区是社会高效协作打造软件生态的重要模式！**

基础软件是一直是我们的短板，openEuler 开源社区联合龙归科技，于5月15日在苏州，联合主办技术交流沙龙，邀请到了华为「2012 实验室」专家、中国移动 IaaS 部门相关专家、龙归科技身份认证安全专家，共同探讨：Linux 系统、虚拟化、IaaS、IDaaS统一身份认证等核心开源技术！

一起来看看下本次活动的相关信息吧：

**时间地点**

**时间：**2021年5月15日

**地址：**中衡设计大厦 3F 培训中心

(苏州市吴中区八达街 111 号，距2号线月亮湾地铁6号口 200m)

**点击报名**

 

**议程安排**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbicrs9N6wqCCCvkofdosibJxOnECZtH06M3bRDRtsesPJUC2gVd93jicOp72MRfSuBU0g6VncSKM8vA/640?wx_fmt=png)

**详细议题内容**

**主题一：完整性度量架构（IMA）在openEuler的改良与实践 -- 讲师：张天行**

**主题简介：**

IMA特性早在2.6版本就被加入到内核主线，用于度量通过execve等系统调用访问的文件，将结果用于远程证明，或者和基线值比较以控制对文件的访问。但由于部署升级步骤繁琐、性能差等原因，IMA并未在业界得到广泛使用。

针对IMA的痛点，openEuler社区在20.09和21.03创新版本发布了IMA Digest Lists扩展，实现了安全性的进一步增强，降低了部署升级的复杂度，实现用户无感知，并且显著提升了开启完整性度量时的系统调用性能。

**嘉宾简介：**

                              

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbicrs9N6wqCCCvkofdosibJxgZPP5vz0Gl8aeSEcXWJxzxLnU52bJDUYjib8ywApiaZDXrQic26sSbP5g/640?wx_fmt=jpeg)

**张天行，华为OS安全研发工程师**，持有CISSP认证，对IMA和Linux安全模块（LSM）有丰富的研究经验，参与kernel上游社区，openEuler security-facility SIG核心成员，openEuler IMA maintainer。       

**主题二：ArkID 开源插件机制与生态的实现及在 openEuler 社区的实践 --讲师：尹力炜**

**主题简介：**

IDaaS 主要的任务是完成对身份认证领域的各类协议和情景的兼容，插件化是解决这一类多样化个性问题的方法。

我们将会与大家分享下ArkID是如何基于Django这一企业级软件开发框架来实现插件化这一特性，并推动相关插件生态圈，以及在与openEuler社区开源软件供应链身份互通的实践。 

**嘉宾简介：**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbicrs9N6wqCCCvkofdosibJxUDicz6LHTIH73wFjSd7Ix3ZSgPrVibcI1zgB0dQ4VAb9TMM0kCGGsACA/640?wx_fmt=jpeg)

**尹力炜 Wely，龙归科技CEO**，十余年一直专注企业协作效率提升，曾任玩蟹科技联合创始人，项目月流水过千万 ; 中后期负责研发效率提升、人事行政及技术支撑的管理，公司规模超过700人。公司于2018年被上市公司近20亿并购退出。

**主题三：iSulad+StratoVirt: 极致轻量化虚机容器新方案 -- 讲师：吴景+郭馨乐**

**主题简介：**

随着容器技术在用户生产环境的采纳率提升，容器平台的安全和性能问题成为用户关注的焦点。“fast as container，security as vm”作为安全容器的标语，旨在为用户提供性能与安全兼顾的解决方案。为了做到保障安全的同时也做到极致轻量化，openeuler推出了k8s + iSulad + shim v2 + startovirt的解决方案，iSulad作为轻量化的容器底座，提供统一的架构设计来满足 CT 和 IT 领域的不同需求，可以为多种场景提供灵活、稳定、安全的底层支撑，具有轻、灵、巧、快的特点。StratoVirt实现了一套架构统一支持虚拟机、容器、Serverless 三种场景。在安全隔离，轻量低噪、软硬协同和高扩展性等方面具备关键技术竞争优势。StratoVirt启动时间小于50ms，内存底噪小于4mb。通过两者的结合，相比社区主流的k8s + containerd + kata + qemu的方案，性能提升60%以上，启动单pod，内存占用降低20m+。

**嘉宾简介：**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbicrs9N6wqCCCvkofdosibJx4BibuVKEYV84IGGPtUibQQreRfGWCSKN1f2w4VoibhyYBXnRJzoicf7dVg/640?wx_fmt=jpeg)

**吴景，华为容器研发工程师**，从事华为自研容器引擎iSulad的研发，对容器引擎、runtime等领域有较深的研究和理解，参与lxc，containers开源社区，openEuler iSula/container SIG核心成员。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbicrs9N6wqCCCvkofdosibJxIhrLAEW2tSUszCgkEwsficzl5xIEqGYyiajNQXAbhbhQR0zjS5JZDuMQ/640?wx_fmt=jpeg)

**郭馨乐，华为虚拟化技术研发工程师**，StratoVirt开源社区主要成员之一。擅长virtio，vfio虚拟化设备开发。在安全容器方面有丰富的实践经验。

**主题四：用户态 qemu 热补丁 -- 讲师：郑川**

**主题简介：**

传统Qemu升级均采用冷补丁/（停机打补丁），对用户业务中断有极大的影响；业界成熟的热迁移方式受限条件多，运维成本高。针对紧急问题和紧急漏洞修复，上述两种方案均存在较大的业务中断和较高的运维成本。

针对以上痛点，我们提出一种ms级中断时间的qemu用户态热补丁技术，用于Qemu紧急网上问题和紧急漏洞修复，提升可维护性和用户体验，降低运维成本。

**嘉宾简介：**

**![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbicrs9N6wqCCCvkofdosibJx0y5zRwjYdNiaVcPic7LzlPeGn8L1zJLM6861nib1EM8vQawAJBjdR4pzQ/640?wx_fmt=jpeg)**

**郑川，华为虚拟化技术高级工程师**，擅长虚拟化领域热补丁，热迁移，替换  等相关技术，对操作系统，内核调度也有较为深入的了解。

**主题五：ARM架构下的内核热补丁技术  -- 讲师：丁翔**

**主题简介：**

目前社区内核热补丁只能支持少数架构，如x86，S390，并不支持ARM64架构，但移动云中部署了一定数量的ARM64服务器，为了满足高可用以及提高系统稳定性，开发了支持ARM64的热补丁功能，实现了ARM64服务器的不重启升级

**嘉宾简介：**

                                           

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbicrs9N6wqCCCvkofdosibJxqhhsNFib9VhS1vXpS0qmDnKMiaEaLfCiaCVQib9rcSmCm8FI9EZoo1DC6A/640?wx_fmt=png)

     

**丁翔，中国移动云能力中心**，IaaS产品部 软件开发工程师，操作系统内核专  家，负责BC-Linux操作系统内核建设                            

**主题六：移动云弹性计算在ARM平台上实践与优化 --讲师：胡丽娜**

**主题简介：**

ARM架构具有高效率、低能耗、低成本优势的同时也面临生态不够完善，性能待提升的挑战。移动云针对兼容性与性能问题与鲲鹏、飞腾等国产化平台展开技术攻关与兼容适配，对底层异构资源技术差异性进行有效屏蔽，为用户应用业务提供异构ARM、x86等计算能力

**嘉宾简介：**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbicrs9N6wqCCCvkofdosibJx1icVe6ric6y4MZJDtKWZDFl2sBiaruk9eu3Da8zgSSEr9VkndGJFiaRjyg/640?wx_fmt=png)

**胡丽娜，中国移动云能力中心**，IaaS产品部 软件开发工程师  从事计算产品的研发工作，主要负责移动云异构计算产品研发及移动云弹性计算在ARM服务器上的适配与优化。

**主题七：移动云弹性块存储在ARM平台上实践与优化 --讲师：卫迎泽**

**主题简介：**

本次分享主要介绍了ARM服务器在移动云块存储上的实践，包括块存储（BC-EBS）核心模块（Ceph、Bcache、管理系统各模块）在ARM平台上的开发适配，并针对arm服务器特点，进行性能优化工作（和X86性能测试对比），最后，介绍了目前ARM服务器在移动云块存储上的应用情况。

**嘉宾简介：**

**![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbicrs9N6wqCCCvkofdosibJxJDJ5U5XMIttTgPUlAJvmrubAMjS98MkNQBT7Ptj2qTIqErySfmynkQ/640?wx_fmt=png)**

**卫迎泽，中国移动云能力中心**，IaaS产品部 软件开发工程师，主要负责移动云块存储方面的研发、性能调优和维护工作，在ceph、bcache、spdk等方面有丰富的实践和优化经验。

       

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbicrs9N6wqCCCvkofdosibJxt1Mg4aJuRodgRIibHsE8gZ6F1tZIKQvozIB8GF6hTcuQyiaOE55T927g/640?wx_fmt=jpeg)
