# [上海交大“蓬莱“TEE助力 openEuler 打造可信机器学习框架](https://mp.weixin.qq.com/s/_8s5eHKL1GRFoudzAvD-Ig)

[OpenAtom openEuler](javascript:void%280%29;)*2021-11-17 18:29:05*

随着自动驾驶、5G、AIoT 等场景的迅速发展，机器学习与 AI 在全场景中得到了广泛的应用，与之而来的安全问题也日益受到关注，例如用户隐私、数据保护与模型安全等。上海交通大学 IPADS 实验室在最新的工作中，将“蓬莱”TEE（可信执行环境）与 openEuler 进行整合，赋予机器学习新安全属性，以保障模型开发者、数据所有者与最终用户的隐私与权益。“蓬莱”TEE 作为华为 openEuler 安全计算的基石之一，将与 openEuler 社区一起，不断完善对多架构、多设备、多框架的支持，持续打造高效、安全、可信的机器学习框架。

## 蓬莱 TEE 介绍

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa2xiaMTDo3EfAvKmb8wFtpSN9u0ruToZDAf5zpK1tOF6LBnibgKP4L86t2BfhmGTGibSa8JM4dlbWGg/640?wx_fmt=png)

“蓬莱”TEE 是 RISC-V 平台目前主流的三个 TEE 之一，也是其中唯一源自国内的 TEE 系统。与同类系统相比，“蓬莱”TEE 在可扩展性（隔离环境数量、安全内存大小）和系统性能（通信时延、启动开销）等方面具有数量级的优势，核心技术方案发表在操作系统峰会 OSDI-2021 上。目前正与瓶钵、芯来等多家国内企业/开源社区进行合作，形成良性发展的开源生态。这一次，正是蓬莱团队和 openEuler 社区协力，为 RISC-V 架构构建全栈的安全能力。

## openEuler secGear 介绍

secGear 是 openEuler 社区开源和维护的，面向计算产业的机密计算安全应用开发套件，旨在方便开发者在不同的硬件设备上提供统一开发框架，让用户不感知底层各种机密计算架构和接口的差异。此前，secGear 支持 Intel SGX 和 ARM Trustzone，以及 iTrustee 安全 OS。

蓬莱+openEuler 构建全栈的开源 RISC-V 可信执行环境平台 2021 年是 IPADS 实验室蓬莱团队和 openEuler 社区深度合作的一年。从年初开始，蓬莱团队开始联合 openEuler 社区进行整合蓬莱 TEE 和 openEuler 的工作。

2021 年 7 月，在经过多轮的内部代码 review 之后，蓬莱发布了基于 openSBI 的第一个 release 版本，相关补丁提交至 openEuler RISC-V SIG 维护的 openSBI 代码仓中，并被顺利接收。此后 openEuler RISC-V 默认的 M-mode 软件将原生支持蓬莱 TEE，用户只需要下载蓬莱 SDK 就可以编写并且运行安全应用。

2021 年 10 月，经过三个月的内部 coding、讨论、以及多轮的代码 review 之后，蓬莱团队提出了为 secGear 支持 RISC-V TEE（蓬莱 TEE）的 PR 并被顺利接收，这也是 secGear 最近引入的最大颗粒的新特性。此后，openEuler 用户可以在 RISC-V 的环境下使用 secGear 直接运行相关 enclave 应用。openEuler 是第一个支持“全栈”RISC-V 安全能力的发行版，蓬莱 TEE 则作为安全底座提供有力支撑。

2021 年 11 月，蓬莱团队提出了基于“蓬莱”TEE 的可信机器学习框架，并合入到 secGear 中。openEuler 用户可以通过调用蓬莱 SDK，进行安全的机器学习训练与推测。借助蓬莱的安全存储、验证启动与安全通信等机制，保证机器学习过程中的模型安全与用户隐私安全。未来，蓬莱-TEE 将整合更多的训练框架（MindSpore 等）与异构设备，为 openEuler 用户提供更多选择。11 月 10 日，蓬莱团队参加 openEuler 暨操作系统 2021 峰会，并在安全分论坛上做了“基于蓬莱 TEE 的 RISC-V 可信机器学习框架”的报告。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa2xiaMTDo3EfAvKmb8wFtpSIiaGSlCWWn08LlfNommqibnicBF4cz7Us1hASPqN6mVhcXh0NrTXAxqMQ/640?wx_fmt=png)

蓬莱团队和 openEuler 社区分别作为国内顶尖的安全团队和 OS 社区，正共同构建并推进 RISC-V 场景下的安全能力。蓬莱作为高校主导的开源项目，后续将围绕“科研+开源/工业”的双引擎模式进一步探索安全方面的技术，构建高性能、高可扩展、高安全的安全底座。openEuler 作为开放、多元和架构包容的生态社区，也将欢迎更多的开发者参与进来，共同推动软硬件生态的繁荣发展。

**参考资料**：

1. openEuler secGear 项目：https://gitee.com/openeuler/secGear
2. 蓬莱 TEE 的介绍：https://www.zhihu.com/question/466393646/answer/1960960170
3. 蓬莱 TEE 论文：https://ipads.se.sjtu.edu.cn/zh/publications/FengOSDI21-preprint.pdf
4. 蓬莱 TEE 文档：https://penglai-doc.readthedocs.io/en/latest/
5. Penglai-PMP/sPMP 代码仓：https://github.com/Penglai-Enclave/Penglai-Enclave-sPMP
6. 蓬莱-TVM 代码仓: https://github.com/Penglai-Enclave/Penglai-Enclave-TVM
7. 蓬莱在 RISC-V 社区推进的 MPU 方案：https://github.com/riscv/riscv-tee/blob/main/Ssmpu/Ssmpu.pdf
