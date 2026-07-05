# [「转」OERV-RTOS∶ UniProton 适配 Milk-V Duo，加速 openEuler RISC-V 生态](https://mp.weixin.qq.com/s/7_4RkYc9d-ctY0LSxVT-Hg)

*OERV-RTOS*[OpenAtom openEuler](javascript:void%280%29;)*2024-07-11 17:25:00广东*

OERV 的实时操作系统小组(OERV-RTOS) 完成了 RISC-V 开发板 Milk-V Duo 小核的初步支持并与大核 Linux 一起进行部署通信验证。这是 UniProton 首次在 RISC-V 实体开发板上进行 Linux + RTOS 的部署尝试，此次部署基于 MailBox 驱动的简易自定义协议，为后续在 Milk-V Duo 上进行基于MICA 项目的混合关键性系统部署奠定了通信基础。

OERV 团队仓库下的 duo-buildrootsdk 仓库是 UniProton RISC-V 的第一个长期维护下游仓库，由 OERV-RTOS 进行维护开发。Milk-V Duo 是一款 RISC-V 的多核异构芯片，并且拥有较完善的社区生态和非常庞大的 RISC-V 开发者群体。

下方是 OERV-RTOS 的工作路线框架图：

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFGhMIdEqppian2cz5dQl0yQCRpTcqH34xnUA4r962GRJcwicqPBINFibibhcTiaGMNc8jSfRic2mJPLI52A/640?wx_fmt=png&from=appmsg)

**在 Milk-V DUO 上运行 UniProton**

OERV-RTOS 小组为 UniProton 在 RISC-V 架构的 PLIC 驱动 和 CLINT 驱动提供了 C906L 的支持方案，使其能够正常将 UniProton 引导到内存并加载小核运行。

同时，小组在 Milk-V Duo 官方 SDK 的基础上，融合了原 UniProton 构建系统，并引导了支持板载驱动的 UniProton-RISCV，同时通过了一系列官方测试。为了完成这一目标，小组对 UniProton 的构建系统进行了针对 RISC-V 的调整，添加了一键化构建脚本来支持工具链的自动下载，实现了一键构建带有 Uniproton 的 libmilkvduol.a 静态库的功能。此外，小组还将 UniProton 的用户接口（uapi）移植到了 duo-buildroot 小核构建系统，确保小核驱动部分可以使用 UniProton uapi，并对 duo-buildroot 系统进行了一定程度适配。

在板载驱动支持方面，OERV-RTOS 小组重构了原裸机驱动层实现，使用 UniProton 原生 API 来提供如硬件抽象（HAL）、时间获取和延时等相关功能。小组还为 Milk-V Duo 增加了内核层小核启动阶段的代码，在 Milk-V Duo 上正常运行启动流程、硬件特性与内核配置等初始化过程。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/tkVlnC85sFGhMIdEqppian2cz5dQl0yQCEy7Dv9dNaCAumJsZLhccYIALBDe2PI4meGqVuSibrkIhbOoPQiagcjxQ/640?wx_fmt=jpeg&from=appmsg)

如上图，UniProton 成功和 Linux 一同部署到 Milk-V Duo 上面，让 UniProton 默认启动一个线程，持续打印字符串，和 Linux 使用同一个串口。

**基于 RISC-V 的 MICA 框架**

Linux + RTOS 的部署仍然是当前为 Linux 提供高实时性支持的一个重要的方式，同时也是实现Linux 和 RTOS 双方应用落地的主要途径。OERV-RTOS 小组目前正在全力推进 OpenAtom openEuler（简称"openEuler"） 社区的 MICA 项目的 RISC-V 支持和部署，对该项目的 RISC-V 的支持部署做出了相应的路线规划。具体规划路径如下：

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFGhMIdEqppian2cz5dQl0yQCiauSPzEHPyn6ky9JBtpvz2qicTJORPkia72QMpic5TwaeYib3D05QQbTVug/640?wx_fmt=png&from=appmsg)

在现在的工作的基础上， 团队将进一步完善 UniProton 和 openEuler 在对 RISC-V 的支持和应用能力，并施行基于 MICA 项目的多操作系统部署策略。考虑到 RISC-V 芯片架构的特性，RTOS 小组将应用 rv64ilp32 工具链以优化 UniProton 的空间占用和性能表现。整体规划涵盖了 MilkvDuo 的小核与大核两大部分。

对于 Milk-V Duo 的小核，工作重点包括开发与优化 UniProton 的相关文档，支持 MICA 部署，评估与 UniProton 混合部署 RTOS 时的实时性能，以及提供 shell 和 gdb\_stub 支持。此外，还将优化 UniProton 单独部署时的各个组件。

对于大核方面，团队计划在 Milk-V Duo 上运行 openEuler 24.03LTS，并安装MICA所需的依赖，根据板载的实际情况，编写必要的字符设备模块，提供关键的字符设备驱动文件 /dev/mcs，用于支持与Linux用户进程的通信互动，从而实现对小核生命周期的管理和通信。

**开发者说**

OERV-RTOS 小组由罗君\[1]组建，致力于 RISC-V 下 Linux + RTOS 多核异构部署，完善 oe 嵌入式分支在 RISC-V 上面的空缺，目前正在全力推动 MICA RISC-V 支持 和 UniProton RISC-V 的生态建设。罗君分享了他的展望：

"OERV-RTOS 小组在各个方面都在不断地完善，已经有更多感兴趣的小伙伴投入到了 UniProton 项目 和 MICA项目相关的工作中。同时，在 UniProton RISC-V 和 MICA RISC-V 方面我们也制定了详细的 RoadMap ，很快我们就能够看到 openEuler + UniProton 基于 MICA 在开发板上的部署。相信在不久的未来， openEuler + UniProton 能够基于 RISC-V 特性找到具有独特优势的应用落地场景！"

**结语**

OERV 将持续投入 UniProton RISC-V + openEuler RISC-V 方向的支持，进一步完善 UniProton 的生态，实现 openEuler + UniProton 的应用落地。对 openEuler RISC-V 生态建设感兴趣的伙伴们，可以添加下面的微信，加入我们 openEuler RISC-V 开发群聊做进一步了解。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/tkVlnC85sFFUHZTf4iak6JuwtHYf43cK4RL4VuPoooQN9yI8BbCGB640I4DACq54zcmggIY8d2TdzfW9CWJXcgA/640?wx_fmt=jpeg)

\[1] . 罗君，中科院软件所实习生，openEuler 社区 RISC-V SIG贡献者，目前在四川大学读大三，当前主要在为 UniProton 和 MICA 等项目做 RISC-V 方面的支持，kernel 爱好者，Verilog 爱好者，沙盒游戏玩家。
