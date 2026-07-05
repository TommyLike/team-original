# [「转」基于openEuler，国创工软提供工业边端“通算+智算”融合架构新选项](https://mp.weixin.qq.com/s/CDkMGH58sxrK_nNzPNkMpg)

*泊川软件*[OpenAtom openEuler](javascript:void%280%29;)*2025-03-14 20:40:00广东*

**简介：面对工业智造边端通算与智算算力割裂的问题，粤港澳大湾区国家技术创新中心工业软件中心（以下简称“国创工软”）将基于 OpenAtom openEuler(简称: openEuler) 打造的嵌入式操作系统QSemOS 与瑞芯微RK3588（CPU）、昇腾310B(NPU)相结合，创新性地利用混合部署、内存统一编址和算力动态调配等特性，实现单设备替代传统多系统部署、资源利用率提高至90%、设备系统的实时性抖动从100μs缩短至10μs等成果，融合了通算与智算算力，满足工业控制、AI分析、数据加密等场景的高实时控制与边端AI应用的需求，显著降低硬件成本，缩短开发周期，为工业智造提供了创新性的边端算力融合新选项。**

![图片](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCL2mPnkzmict5mgj9Y9Ou37XO4umHFTbZ2ujhnicLeNqoTaSoLOhuZNnlJW4qJfw1lxSWWbWFyUHrg/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

**工业边端“通算与智算割裂之痛”**

在智能制造与工业互联网的双重驱动下，工业现场正经历从“设备自动化”向“边缘智能化”的跃迁，边端对AI算力的需求大幅提升。然而，当前工业设备中通用算力（CPU）和AI算力（如NPU）由分立硬件承载，硬件成本高，跨平台部署开发周期长；在操作系统层面，传统的Linux RT方案无法同时支持高AI算力需求的推理业务和高实时的工业控制需求，是当前工业边端普遍存在的“通算与智算割裂之痛”。

**业务挑战：**

? 硬件成本高：传统方案中，通用算力和AI算力由分立系统承载，导致整体硬件成本居高不下。

? 开发周期长：跨平台部署复杂，开发周期漫长，难以快速响应市场需求。

? 协同效率低：异构硬件间协同效率低下，导致资源浪费和运维困难。

![图片](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCL2mPnkzmict5mgj9Y9Ou37XO4umHFTbZ2ujhnicLeNqoTaSoLOhuZNnlJW4qJfw1lxSWWbWFyUHrg/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

**国创工软的QSemOS“全栈处方”**

       面对工业智造边端通算与智算算力割裂的问题，国创工软将基于openEuler 打造的嵌入式操作系统QSemOS 与瑞芯微 RK3588（CPU）、昇腾 310B(NPU)相结合，创新性地利用混合部署、内存统一编址和算力动态调配等特性，实现单设备替代传统多系统部署、资源利用率提高至90%、设备系统的实时性抖动从100us缩短至10us等成果融合了通算与智算算力，满足工业控制、AI分析、数据加密等场景的高实时控制与边端AI应用的需求，显著降低硬件成本，缩短开发周期，为工业智造提供了创新性的边端算力融合新选项。

![图片](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mClS04vvIiazhFcKAdpH57H8WaER5UV4Sl3JPFXaId6xbvHEzmvsU4VXVibqo8zyejFZsGol3UTNIMw/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

在QSemOSX（瑞芯微RK3588+昇腾310B）平台上运行缺陷识别模型

使用openEuler的版本：openeuler embedded 24.03

? 操作系统：基于openEuler打造的QSemOS X

? 硬件架构：瑞芯微 RK3588（4核A76主频2.4GHz+4核A55主频1.8GHz）+昇腾 310B（20TOPS）

? 技术架构：CPU+NPU异构计算融合，支持目标检测、语音识别和大语言模型的本地部署

![图片](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCL2mPnkzmict5mgj9Y9Ou37XO4umHFTbZ2ujhnicLeNqoTaSoLOhuZNnlJW4qJfw1lxSWWbWFyUHrg/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

**重构工业边端智能化的四大跃迁**

       QSemOS X（瑞芯微RK3588 +昇腾310B） 三位一体方案，开启通算智算融合的全栈新生态，实现以下重大突破与价值：

- TCO（总拥有成本）降低50%以上：满足工业控制、AI分析、数据加密等的全场景混合部署能力（软实时+硬实时）；单设备替代传统多系统部署，全生命周期降低TCO，对比其他品牌传统方案硬件成本降低50%以上；
- 资源利用率和实时性提升：资源利用率提高至90%以上，设备系统的实时性抖动可从100us缩短至10us，设备竞争力和场景适应性大大提升；
- 智能化落地周期大幅缩短：华为AI智算生态，大幅降低开发门槛，完善工具链提升开发效率，成本效益全面提升；
- 繁荣生态，全栈创新：openEuler根社区带来丰富且强大的软件生态和业务机会；从芯片到OS全栈创新。

![图片](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCL2mPnkzmict5mgj9Y9Ou37XO4umHFTbZ2ujhnicLeNqoTaSoLOhuZNnlJW4qJfw1lxSWWbWFyUHrg/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

**赋能工业边端智算新时代**

       QSemOS X（瑞芯微RK3588 +昇腾310B）方案将在智能制造、能源电力、机械装备等方向和行业上做深入探索和落地实证。在智能制造领域：半导体检测设备中既通过OS实时性提升设备节拍，又通过AI能力提升检出率；在能源电力领域，结合AI进行电网边缘分析以提升故障定位精度，监控分析配电房水浸异常、设备状态、人员进出等，实现更高效更安全的“无人值守”。此外，结合当下最热门的Deepseek大模型，可基于Deepseek强化学习和专家知识库构建，实现半导体设备工艺参数的优化；也可用于分析振动、温度、红外图像等模态数据，实现工厂核心生产设备的预测性维护。

       QSemOS的突破不仅在于技术参数的领先，更在于定义了工业边端算力应用的新范式——**让实时控制与智能计算从“妥协共生”走向“深度融合”**，也是openEuler生态在工业边端领域用的一个新突破。这是一个关键转折点：当设备层既能保障确定性的实时响应，又能就地消化智能计算需求，为工厂真正实现“边端自主智能”，为柔性制造、分布式决策等前沿场景奠定基石。

* * *

***关于**QSemOS：***

*QSemOS是国创工软基于openEuler打造的一款下一代智能嵌入式操作系统，具有高性能、高可靠、高安全和智能的特点，已在南方电网、拓斯达科技、广州实验室等机构获得应用：*

*①助力南方电网打造行业首款统一架构的电力物联操作系统，实现海量设备的互联互通、智能化与协同。目前已在南沙、横琴、前海3个全域示范区完成基线场景验收，预计2025年部署亿级终端，为国家关键基础设施的全面自主可控与创新迈出坚实一步。*

*②助力拓斯达科技打造控制任务周期抖动减少50%、成本降低30%、支持AI引擎能力的显控一体机器人运控平台，加速机器人产业迈向高端、智能且普惠的全场景应用时代。*

*③助力广州实验室超快速PCR检测仪实现0.1℃精准温控、核心检测流程提速5倍，软硬实时混合部署显著降低仪器硬件成本，为打造一条成本低、响应快、推广易的公共卫生安全检测防线提供可能。*
