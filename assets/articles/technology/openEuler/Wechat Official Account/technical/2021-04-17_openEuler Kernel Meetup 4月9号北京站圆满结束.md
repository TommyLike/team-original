# [openEuler Kernel Meetup 4月9号北京站圆满结束](https://mp.weixin.qq.com/s/Cmm3JeodZFvJi92_Y46O0Q)

原创*Kernel SIG*[OpenAtom openEuler](javascript:void%280%29;)*2021-04-17 17:31:00*

openEuler Kernel SIG 组于 2021 年 4 月 9 日在北京成功举办了 Kernel Meetup。本次活动云集了来自华为、麒麟、PingCAP、申威、飞腾、万里红、Arm、兆芯、美团、复旦大学的行业领袖、业界资深专家、高校教授、社区 maintainer、开发者，吸引了现场 30 人+，线上约 300 人参与。会上就内核技术、SIG 组后续运作规划进行了充分研讨，收集了各厂商的诉求并进行答疑，对 SIG 组后续的工作开展和技术合作有着重大意义。

来自麒麟软件的孙立明老师，对 ARM64 KVM 虚拟化架构做了介绍，增进了大家对 ARM64 架构虚拟化的理解。麒麟软件的郭皓老师提出了 openEuler Kernel 支持 PREEMPT\_RT 的想法和思路。期待 openEuler 具备更高的实时性，促进其在嵌入式领域的应用。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbUAb2h1J8vtkoLrxrCKhEnqU0jAx2aLTvpE1Tj19wicwmHiakCGPW93noCqOBKHq3pE9oAGJZHibP4g/640?wx_fmt=jpeg)

孙立明老师

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbUAb2h1J8vtkoLrxrCKhEnpA14ZFvFmcI8Euo0ibNwicbwBHwESdC2LABskomqJCXMWwcaqgpiatOQQ/640?wx_fmt=jpeg)

郭皓老师

来自兆芯的张伟老师，对兆芯 CPU 的演进、特性，以及兆芯补丁合入 openEuler Kernel 的过程做了介绍。目前兆芯的补丁已经合入 openEuler 4.19 内核， 预计 6 月底发布的 openEuler 20.03 LTS SP2 将支持兆芯 CPU。兆芯与 openEuler 社区的紧密合作促成了 openEuler 对兆芯 CPU 的快速支持，张伟老师对此表示了称赞。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbUAb2h1J8vtkoLrxrCKhEnz7ic0FO1Zom96Zu57X6mZPSic420tIPicdyibLPnwhPHqswANaCnicxmetg/640?wx_fmt=jpeg)

张伟老师

来自申威的崔巍老师就处理器接口、虚拟化支持、安全增强等话题与飞腾、兆芯专家进行了现场交流，并表达了积极参与 openEuler 的愿望，期待 openEuler 尽快支持申威全自主指令集架构，促进 openEuler 社区和申威生态的共同繁荣。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbUAb2h1J8vtkoLrxrCKhEnYiald4CTdzliakch6UdbUP6clWqBCffWlg79g0HZIsKetTVQSBB1whFw/640?wx_fmt=jpeg)

崔巍老师

来自华为的缪勰介绍了华为针对 SCM 介质研发的文件系统。该文件系统的原理基于华为 OS 内核实验室主任陈海波老师的论文Soft Updates Made Simple and Fast on Non-volatile Memory\[1] 采用软更新（soft-update) 提供一致性保证，采用哈希表目录结构，消除循环依赖，提供的字节级读写能力显著降低了 SoupFS 的复杂性等技术。性能相比业界其他 SCM 文件系统有显著的提升。

来自华为的杨基鸿，介绍了性能调优的常用方法、工具和思路，并通过实际案例讲解工具的应用及性能分析的思路。线上与会同学表达了对 TOP-down 性能分析工具的强烈兴趣，我们后续会通过专题分享介绍更多技术细节。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbUAb2h1J8vtkoLrxrCKhEnBWJYPrTtburxoQxPqfTBMX8xEmqRFXLvHLcOCThSqXOhX9ZliaZNqIQ/640?wx_fmt=jpeg)

杨基鸿

来自复旦大学计算机学院的张亮教授，针对如何推动高校参与 openEuler 提出了建设性意见，我们后续也会持续开展面向高校的交流合作活动。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbUAb2h1J8vtkoLrxrCKhEndpQSqqsfDiaiaOGjbaLu6GLTE00icFHruMuiaficEDF1UjXSOCgjHLKUIicA/640?wx_fmt=jpeg)

张亮教授

openEuler Kernel SIG 的 Maintainer 谢秀奇介绍了 kernel SIG 一年多以来的进展以及后续的运作、规划等。与会专家老师进行了充分的研讨，提出了在 Kernel SIG 建立 committer 机制的想法，以 Committer 为核心对 openEuler 内核进行规划、开发和治理。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbUAb2h1J8vtkoLrxrCKhEnblCRndL8Vh6pZMGp43neQmTWADzo5eQpDewX4Rz8xktzwX4zraYYyw/640?wx_fmt=jpeg)

谢秀奇

本次 meetup 的成功举办，对 Kernel SIG 的后续工作和发展有重大意义。期待各厂商、各单位、各开发者在 openEuler 开源社区这个大平台下，共建、共享、共治，让 openEuler Kernel 走进千行百业，成为信息产业的基石。

## openEuler Kernel SIG

### openEuler Kernel 仓库

openEuler Kernel 源代码仓库：

https://gitee.com/openeuler/kernel

欢迎大家多多 star、fork，多多参与社区开发，多多贡献补丁。

关于贡献补丁请参考：[如何参与 openEuler 内核开发](http://mp.weixin.qq.com/s?__biz=MzI2NDE4OTE2Mg%3D%3D&mid=2247487429&idx=1&sn=8d22d09679425d81c819260e84224f5b&chksm=eab12a40ddc6a356ab6e933b29498bc5067121ca46d30e81b61b53b9c1d31241e51e7daadce9&scene=21#wechat_redirect)

### openEuler Kernel SIG 微信技术交流群

请扫描下方二维码添加小助手微信，备注“交流群”或“技术交流”，加入 openEuler Kernel SIG 技术交流群。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbUAb2h1J8vtkoLrxrCKhEn3UpaGiaYWB1IkJ1l5VHrSDMwL6RybQYLibOnhpFbBhccZdSnFaHUy8HA/640?wx_fmt=jpeg)

### 参考资料

\[1]

Soft Updates Made Simple and Fast on Non-volatile Memory: *https://www.usenix.org/system/files/conference/atc17/atc17-dong.pdf*
