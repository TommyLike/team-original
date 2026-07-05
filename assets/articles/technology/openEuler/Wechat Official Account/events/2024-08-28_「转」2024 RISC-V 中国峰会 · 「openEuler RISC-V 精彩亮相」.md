# [「转」2024 RISC-V 中国峰会 · 「openEuler RISC-V 精彩亮相」](https://mp.weixin.qq.com/s/DlYhSahm_5lKqgPd8wgGGA)

*OERV*[OpenAtom openEuler](javascript:void%280%29;)*2024-08-28 18:04:24中国香港*

8 月 21 日至 23日，国内最大的 RISC-V 年度盛会 2024 RISC-V 中国峰会于浙江杭州黄龙饭店举行。本次峰会汇聚了 RISC-V 国际基金会、业界专家、企业代表及社区伙伴，共同探讨 RISC-V 的最新进展与未来趋势。

23 号下午OpenAtom openEuler（简称"openEuler"）社区 RISC-V SIG Maintainer 王经纬在峰会主会场进行了题为「openEuler RISC-V 2024: 我们如何驯服碎片化」的演讲。演讲介绍了 RISC-V 成长为 openEuler 官方支持架构，并且于  24.03 LTS 版本最终发布的历程。同时演讲从碎片化问题切入，展开介绍了 openEuler 在 RISC-V 架构上的生态建设计划。

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFFKkuABwBLVCOM9aKb3W2xAYl1URKwmP5EgJIcZzIjWSeTv68UVlqM2QFPV04wwZYbClCia7qQwyoA/640?wx_fmt=png&from=appmsg)

**openEuler 24.03LTS for RISC-V**

王经纬首先回顾了openEuler 24.03 LTS 的发布，这是 openEuler 对 RISC-V 架构支持的重大突破。他提到，在过去的四年时间里，中国科学院软件研究所下的 RISC-V SIG 成员共同推进了对 RISC-V 的深度适配，包括前期的软件生态对齐，到近期的补足官方RISC-V 架构发版能力，都付出了极大的努力。

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFFKkuABwBLVCOM9aKb3W2xAY8Hiczc7njrSbgP9uFQVDl526H2UJ9R0icz8HtRFe6DuZP9bSWMJsK0Q/640?wx_fmt=png&from=appmsg)

在软件研究所和openEuler 社区各个核心 SIG 组的努力下，openEuler 24.03 LTS 版本首次实现对 RISC-V 架构的「一套社区代码、一套基础设施、一套质量标准和统一镜像发版」，并且最终发布的构建成功率距 x86 和 arm 只有 1% 左右的差距。

经过多年的经营，openEuler RISC-V 在软件支持方面已经支持了一套完善的开源办公环境与常见的服务器相关组件与生态，在硬件支持方面则已经支持了包括香山南湖开发版的各种主流硬件环境。同时，RISC-V SIG 也研发了不少开源世界领先的创新成果，包括对 RISC-V 热补丁能力的支持和基于 H 拓展和 AIA 高级中断的虚拟化生态超前验证。

openEuler RISC-V 的发展离不开团队内外部众多伙伴的支持。其中，与 PLCT 的合作，极大程度提升了 openEuler 在编译器工具链、JIT 加速与二进制翻译等方面的能力支持。同时 RISC-V SIG 与达摩院玄铁、上海交通大学、进迭时空、算能科技和元石智算都有不同程度的合作落地，共同加速生态发展。

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFFKkuABwBLVCOM9aKb3W2xAZcMcItLlTUlj2lMQxxicOcuDoh2pr0Ch6a22zUWXzCTYRk3GkZkWSYA/640?wx_fmt=png&from=appmsg)

**面向碎片化的挑战**

随着 openEuler 对 RISC-V 架构的深入支持，王经纬指出当前面临的一个主要挑战是生态系统的碎片化。目前很多业界厂商不可避免地陷入垂直化发展，进而加速碎片化的问题。这种现状和核心软件 upstream 缓慢与硬件标准滚动太快的矛盾密不可分。同时，现在看似已具规模 RISC-V 生态是十分脆弱的，背后并没有完善的基础设施支撑。

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFFKkuABwBLVCOM9aKb3W2xAic1GRvI5GwDWlBmthlbp8IJ8vFBtZFwFJhgb1GAl0ibsXWBiaNfvfxhNA/640?wx_fmt=png&from=appmsg)

但是可以观察到的是，RISC-V 高性能硬件即将迎来爆炸时期，RISC-V 相关 Spec 趋于稳定，并且 openEuler RISC-V 为国内厂商提供了一个统一的生态基线。王经纬认为当下阶段正是解决 RISC-V 碎片化的黄金阶段。

**一个基本任务与四个生态计划**

基于目前面临的问题与面向高稳定 RISC-V 服务器的任务目标，王经纬分享了 openEuler RISC-V 在未来阶段的规划。

首先一个任务核心是指，RISC-V SIG 将持续推动演进主线版本，重点支撑从 openEuler 24.03 LTS 开始的长周期版本，演进包括 SP1、SP2、SP3 以及之后的其他主线版本，同时对标 x86 和 Arm，将 openEuler RISC-V 从能用过渡到好用。

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFFKkuABwBLVCOM9aKb3W2xAIzw7sT72WmYJapBhOM0nYe4slcDKb7rLT7niaHANykW8V8F8zYGQ7vQ/640?wx_fmt=png&from=appmsg)

伴随着核心任务，RISC-V SIG 规划了四个生态计划，包括：

1. **RVAize 标准演进计划：**作为版本迭代演进的基础，核心是围绕 RVA 标准做持续演进与超前验证。
2. **RVCK 内核同源计划：**提升版本内核对 RISC-V 的硬件支持能力，核心在于聚拢厂商硬件生态支持能力，打造一个长周期维护的同源内核，提升内核测试水平和质量保障，为厂商产品化提供生态发展和产品化的统一基线。
3. **RAVA 测试补全计划：**增强版本面向不同硬件的质量管理体系，提供符合性、安全和性能的测试套件，使得 openEuler RISC-V 成为 RISC-V 软硬件第一验证平台。
4. **RVCI 战略基建计划：**则目标在于完善 RISC-V 基础设施支撑建设，增强软件上游供应能力。

围绕发版迭代，以四个生态计划作为发展支撑的 openEuler RISC-V，旨在可以发展为可以建立统一生态、去除碎片化影响的高可用服务器发行版本。相关计划会在OERV 公众号持续展开。

在这个基础上，王经纬最后以「从心所欲不逾矩」的多样化生态发展愿景作为结尾，呼吁生态上下游厂商与感兴趣的伙伴们共同参与 openEuler RISC-V 建设中，全方位加速这一愿景的到来。

**联系我们**

对 OERV 工作感兴趣的伙伴们可以添加下方的微信并且加入到 openEuler RISC-V 社区开发群，获取更多即时信息

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mAk7XGjrHQX48E1tGVyJGQcgaTxicyGy9UAaYQYrL3ADZeFvrsbKPgXGSSwxkrfJsQdiccRkoQyFGDw/640?wx_fmt=jpeg&from=appmsg)

添加时请备注 OERV

**相关链接：**

- Gitee 协作主页:
  
  - https://gitee.com/openeuler/RISC-V
- 构建仓库协作地址:
  
  - https://build.tarsier-infra.com
- 第三方 repo 源:
  
  - https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V
- OERV 工作中心：
  
  - https://github.com/openeuler-riscv
- 邮件列表:
  
  - riscv@openeuler.org
- Discord 邀请链接:
  
  - https://discord.gg/f9znRFjh
