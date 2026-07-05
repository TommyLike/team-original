# [secGear 现已开源，中国银联基于 secGear 实现车充无感支付解决方案](https://mp.weixin.qq.com/s/xCzau0NXGeMZyt2555JgZQ)

*周荔人*[OpenAtom openEuler](javascript:void%280%29;)*2021-01-14 21:10:21*

2020年12月31日，openEuler 社区的二级开源项目机密计算框架 secGear 正式开源。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMb6kT1g8MS6pfcJtKYiccyhibOaCqicXA4H2MbVNsGDp8PI37AaI1YreRSfheJJxTJjGGsSHUicbzXMNQ/640?wx_fmt=jpeg)

secGear 将不同处理器架构的机密计算方案的差异在软件层面抹平，在Base Layer、Middleware Layer、Service Layer三层分别实现了统一的接口，开发者只需要通过这些接口即可使用机密计算相关功能。

中国银联已经基于secGear 实现车充无感支付解决方案。

secGear项目地址：

https://gitee.com/openeuler/secGear

什么是机密计算？

机密计算是在运行态数据（data-in-use）难以保护的背景下出现，机密计算可以简单的抽象为：将运行数据放入黑盒子中，应用可以请求相关运算，但不能在盒子中拿出任何机密数据。

机密计算是通过将计算隔离到基于硬件的受信任执行环境 (TEE) 来保护使用中的数据。尽管在传统上数据是在传输过程中静态加密的，但机密计算在处理数据时会保护数据。TEE 通过保护部分硬件处理器和内存提供受保护容器。可以在受保护的环境中运行软件，以防止来自 TEE 外的针对代码和数据部分的查看或修改。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMb6kT1g8MS6pfcJtKYiccyhibZMGKvdON3W3NnHPicXRicaWjgc7oh8Lt4nj77hNdQMu8Ec2l7iaD01ttw/640?wx_fmt=png)

目前多家芯片厂商都推出了机密计算的解决方案

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMb6kT1g8MS6pfcJtKYiccyhibibohYJFxdLgXg5giaZttU48zvibgFAcdspM74fskYTzcEewh1icGl3HdFw/640?wx_fmt=jpeg)

不同硬件架构之间的设计存在差异，例如：SGX 特点是划分部分内存地址作为安全容器，保护地址内存的安全性，而 trustzone则是通过分时复用 CPU，构造出两个界域，安全与非安全事件，确保数据安全。

不同机密计算领域方案的差异，也导致了机密计算领域的三个问题：

1. 兼容性差
2. 生态隔离
3. 维护成本高

secGear 如何处理机密计算这些问题的

secGear 将不同处理器架构的差异在软件层面抹平，在Base Layer、Middleware Layer、Service Layer三层分别实现了统一的接口，开发者只需要通过这些接口即可实现机密计算相关功能。

secGear 在 Base Layer 层提供了丰富的开发接口和工具，并且在安全侧支持支持C POSIX APIs和标准OpenSSL接口，用户基于这些接口可以自由开发安全应用程序。

统一的 API，统一的开发体验。Base Layer层是开发者最能体会到 secGear 魅力的一层，不同处理器架构的机密计算方案在安全进程创建、销毁和调用的阶段，分别提供了不同的 API 接口，开发者需要学习三种不同的机密计算框架API才可以灵活应用，学习成本很大，后期的维护成本很高。

在 secGear 中，这些安全进程创建、销毁和调用三个阶段的接口被统一。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMb6kT1g8MS6pfcJtKYiccyhibmmyKk1DNfZomRDiaNQiaLw2QegN74kUibgCYKYVgYpQy6jwWrgVZhgzNw/640?wx_fmt=jpeg)

secGear在 Middleware Layer 提供了丰富的安全中间组件，例如：PLCS#11、TLS、PAKE。用户可以利用这些中间件实现 Hello World 程序编程，用户可以在不需要了解 Base Layer 层的代码，即可实现机密计算相关功能。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMb6kT1g8MS6pfcJtKYiccyhibpsv5xTDvCgPygeic6GOKsviboNT6QdQqtqxSURoCeQYVAwgnUUasUHzw/640?wx_fmt=jpeg)

Service Layer 负责提供机密计算的增强服务，例如密钥保存和敏感数据保存。目前包括密钥管理服务EKMS。

中国银联基于 secGear 的车充无感支付方案

中国银联是交易额全球最大的银行卡组织，目前银联的业务已经拓展到了 179 个国家，涵盖了 5600 个商户，总共发行了 86 亿张卡。现在整个金融行业都在探索数字化转型，中国银联也不例外，其目标是面向行业成为金融数字化服务提供底座的技术平台。

中国银联电子支付研究院团队加入了 openEuler 机密计算 sig 组，参与了 secGear 框架开发，聚焦国密套件计算服务能力的研发。今年，该项目组开源了第一个模块，未来项目组希望所有的安全计算服务能力都能够得到安全的保护，能够得到安全的机密计算环境。

中国银联通过secGear 提供的统一的 API 接口，通过在充电口识别车架号，通过车架号识别，充电桩与中国银联云上的支付系统进行交互，并且在 secGear 提供的安全环境中对支付信息进行安全有效的处理，汽车完成充电后自动从车主绑定的账户中扣除费用。
