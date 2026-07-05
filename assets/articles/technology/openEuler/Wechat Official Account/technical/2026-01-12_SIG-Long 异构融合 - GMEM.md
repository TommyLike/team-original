# [SIG-Long 异构融合 - GMEM](https://mp.weixin.qq.com/s/NOZfK7t_-7mYraCG5ntI_g)

[OpenAtom openEuler](javascript:void%280%29;)*2026-01-12 17:29:59广东*

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a47pmwYKrTftvGXyFfspek4hoUibdJtrBB96517RL4k2AXD1gSav958g/640?wx_fmt=gif&from=appmsg)

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mAu6uoNwIYnzAzDia2bcCgQ3X813gX2lUpKQdynIvrqMezAnD71mJJTicpO8Ssw2L3luPVKlWOb9H3A/640?wx_fmt=gif&from=appmsg)

**01**

**背景**

OpenAtom openEuler（简称“openEuler”或“开源欧拉”）作为全场景的开源操作系统，是连接底层硬件和上层应用的桥梁。在计算领域，面对异构硬件（CPU+XPU）、高速互联总线（UB、CXL等）以及通智算融合负载（大数据，生成式推荐，AI 推理等）的演进和挑战，openEuler 的核心任务是在资源与负载之间，扮演关键的总调度和总指挥角色，实现硬件资源和软件负载的精准匹配和按需供给，融合异构算力，构建异构融合计算基础设施框架。

随着数据中心逐步走向高度异构，同一系统中往往同时部署来自不同厂商的多种 XPU（如 GPU、NPU 等）。当前，每个 XPU 厂商通常在驱动层实现一套独立的内存管理机制，导致上层框架需要维护多个厂商相关的内存后端，不仅接口语义不统一，性能表现也难以稳定。同时，这些XPU内存管理系统与操作系统以 CPU 为中心长期演进形成的核心内存管理机制相互割裂，难以直接复用页回收、NUMA 策略、内存超额分配等成熟能力。

本文介绍一种统一内存管理框架 GMEM，旨在将 XPU 内存管理能力直接纳入操作系统核心内存管理路径，由内核统一负责地址映射、缺页处理以及内存策略决策。在保留各类 XPU 原生页表格式与性能特性的前提下，GMEM 提供一致的内存管理语义，实现 CPU 与 XPU 之间的高效协同，避免在驱动和框架层重复实现内存管理逻辑。

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mAu6uoNwIYnzAzDia2bcCgQ3X813gX2lUpKQdynIvrqMezAnD71mJJTicpO8Ssw2L3luPVKlWOb9H3A/640?wx_fmt=gif&from=appmsg)

**02**

**架构介绍**

GMEM 的核心目标是消除 CPU 与 XPU 内存管理体系之间的割裂状态，通过操作系统核心内存管理机制实现统一管理与调度。在现有系统中，每种 XPU 往往在驱动中实现一套完整但彼此独立的内存管理系统，不仅开发与维护成本高昂，也难以与操作系统的核心内存管理能力协同工作。GMEM 选择直接扩展操作系统核心内存管理（OS core MM），使其能够同时管理 CPU 与 XPU 内存，从架构层面简化系统设计。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAu6uoNwIYnzAzDia2bcCgQ3zPvZjbcWteicMHPticTeQnte0Q5auNZu4UOWic8J9P8Rj9PFuAcibgBzfw/640?wx_fmt=png&from=appmsg)

**GMEM 的整体架构由以下几个关键组成部分构成：**

- **逻辑映射抽象（Logical Mapping Abstraction）：**GMEM 在 core MM 中引入显式的逻辑映射层，用于记录统一虚拟地址对应的数据当前驻留在哪类处理器（CPU 或某个 XPU）及其物理位置。这一抽象将“数据位置管理”从具体页表实现中解耦，为统一缺页处理和数据迁移提供基础。
- **统一虚拟地址管理（Unified Virtual Address Mgmt）：**应用可通过 GMEM API 在 CPU 与 XPU 之间共享同一虚拟地址。不同处理器对同一地址的访问由内核统一仲裁，从而避免应用层显式管理多份地址或手工拷贝。
- **内存管理职责集中化（Generic PF Handler, PA Mgmt）：**GMEM 将页分配、缺页处理、NUMA 选择、页回收等关键决策统一放入 core MM 中执行，XPU 驱动仅负责提供必要的硬件操作接口，显著减少驱动复杂度。

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mAu6uoNwIYnzAzDia2bcCgQ3X813gX2lUpKQdynIvrqMezAnD71mJJTicpO8Ssw2L3luPVKlWOb9H3A/640?wx_fmt=gif&from=appmsg)

**03**

**GMEM 统一地址管理**

GMEM 提供的是缓冲区级别的统一虚拟地址空间，而非对整个进程地址空间做强假设，从而降低实现复杂度并增强可控性。

      

**统一地址管理的关键机制包括：**

- **受限但明确的统一地址语义：**只有通过 mmap 使用特殊 GMEM 标记位分配的地址区间才被视为 CPU–XPU 统一地址。这种设计避免了对现有 CPU 内存管理路径的干扰，同时为 XPU 编程提供明确边界。
- **地址可用性检查机制：**虚拟地址的分配由 core MM 完成，但是否适用于 XPU 由驱动通过提供的接口判断。若地址不满足 XPU 页表或地址格式约束，GMEM 会重新选择地址区间，直至成功或达到重试上限。
- **逻辑映射表：**每个 2MB 虚拟页对应一条逻辑映射记录，基于 Linux xarray 实现，具备良好的缓存局部性与并发特性。查找操作无锁，修改操作仅在页级别加锁，与现有 PMD 级锁粒度一致。
- **一致性保证：**通过页迁移或远程映射机制实现一致视图，保证在 CPU 与 XPU 混合访问场景下，任一处理器在最后一次访问后能够观察到最新的数据状态。

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mAu6uoNwIYnzAzDia2bcCgQ3X813gX2lUpKQdynIvrqMezAnD71mJJTicpO8Ssw2L3luPVKlWOb9H3A/640?wx_fmt=gif&from=appmsg)

**04**

**GMEM 超分**

GMEM 可以通过自动将 XPU 页面换出到主机侧 DDR 实现超分，使 XPU 本地内存不再是硬性上限。

**关键设计点如下：**

- **统一的 2MB 页管理策略：**GMEM 仅管理 2MB 粒度的 XPU 物理页，减少页表项数量，降低 DMA 与 TLB 相关开销，并与主流 XPU/CPU 的硬件能力对齐。
- **显式的页状态与热度跟踪：**XPU 物理页被组织为 active 与 free 两类，其中 active 页按 LRU FIFO 队列维护，反映近期访问行为，为回收决策提供依据。
- **同步、可控的页回收流程：**当 XPU 内存耗尽时，GMEM 会同步选取一批冷页，将其数据迁移回主机内存，并清除对应的 XPU 页表映射。
- **面向 XPU 访问模式的延迟映射：**被换出到主机侧的页面不会立即建立 CPU 映射，只有在 CPU 实际访问时才触发缺页处理，避免不必要的页表操作。

通过上述机制，GMEM 使 XPU 内存的使用方式更接近 CPU 内存模型，大幅缓解内存碎片化和容量受限问题。

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mAu6uoNwIYnzAzDia2bcCgQ3X813gX2lUpKQdynIvrqMezAnD71mJJTicpO8Ssw2L3luPVKlWOb9H3A/640?wx_fmt=gif&from=appmsg)

**05**

**接口功能**

GMEM 通过分层的接口设计，实现应用可编程性与驱动可维护性的平衡。

**1.应用层接口**

- **统一内存分配与释放：**应用使用标准 mmap()/munmap() 即可获得 CPU–XPU 统一指针，无需依赖厂商特定的内存分配器。
- **NUMA 感知的数据布局控制：**gmadvise() 允许应用显式提示数据的目标处理器或内存节点，用于优化数据局部性或提前迁移。
- **统一的数据拷贝语义：**gmemcpy() 在统一地址空间内执行数据迁移，保证目标缓冲最终驻留在指定 NUMA 节点。
- **内存提示与分配器支持：**GMEM 将 MADV\_WILLNEED 与MADV\_DONTNEED 扩展到 XPU 场景，使 jemalloc 等通用分配器能够直接复用。

**2.****驱动层接口**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAu6uoNwIYnzAzDia2bcCgQ3L4ichI6yOh0osxibaibL1ZjenmgbTVia3jp6TDcUeOwdXQNkia0n00Y1ib7Q/640?wx_fmt=png&from=appmsg)

XPU 驱动仅需实现少量硬件相关操作：

a) 设备初始化：

●注册 MMU 操作

●导入 XPU 物理地址区间

●绑定 NUMA 节点

b) MMU 操作回调：

●页表建立/清除

●DMA拷贝

●内存清零

c)地址空间关联：

●将 XPU 上下文附加到 CPU 进程地址空间

这种接口划分使 XPU 驱动代码规模显著降低，同时最大化复用内核已有的内存管理能力。仅需 2500 行代码即可支持多厂商 XPU（如 NVIDIA/华为），通过标准化接口（如 gm\_dev\_create）注册设备 MMU 操作。

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mAu6uoNwIYnzAzDia2bcCgQ3X813gX2lUpKQdynIvrqMezAnD71mJJTicpO8Ssw2L3luPVKlWOb9H3A/640?wx_fmt=gif&from=appmsg)

**06**

**总结与展望**

本文围绕异构数据中心中 XPU 内存管理碎片化的问题，介绍了统一内存管理框架GMEM 的整体设计思想与核心机制，阐述其如何在不侵入厂商私有实现、不牺牲设备原生性能特性的前提下，将 XPU 内存管理能力纳入操作系统核心内存管理体系。通过  GMEM，CPU 与 XPU 共享统一的地址空间语义、缺页处理路径和内存策略接口，使 XPU 能够直接复用操作系统在内存超额分配、NUMA 感知与页迁移等方面的成熟能力，从而显著降低驱动与框架层的实现复杂度，并提升系统整体的可移植性与性能可预测性。

展望未来，GMEM 仍有多个备的动态数据放置、自适应内存策略以及更通用的运行时库（如统一的内存分配器）提供了基础，也为未来大规模模型推理与训练场景下的性能优化打开了新的空间。

openEuler sig-Long 已面向开发者开源核心技术方案，诚邀行业伙伴、高校与个人开发者交流合作方向。可添加小助手微信加入 sig-Long 微信技术交流群，或访问 AtomGit 平台了解相关材料、提交 issue。issue链接↓

(https://atomgit.com/openeuler/kernel/blob/OLK-6.6/mm/gmem.c)

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCHndARF9ZFUL3xOYfumsaUBT07Xb30XNG8EELSxEiciaB7xQ1LR5Lv3857O9FT4mF7GFXVia799J7icw/640?wx_fmt=png&from=appmsg)

往

期

精

彩

[SIG-Long异构融合技术整体介绍](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247517770&idx=1&sn=9fd801716b2dddd7715a7018e8be9b4b&scene=21#wechat_redirect)

[SIG-Long异构融合 - 基于灵衢的内存池化借用](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518012&idx=1&sn=66b421b7475cb26cecc0690436aed3d6&scene=21#wechat_redirect)

[SIG-Long 异构融合 | 性能提速 50%+，xlite 轻量化推理运行时，让 Ascend 平台大模型推理效率飙升](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518135&idx=1&sn=e36883e88bb3f1de770623c860db0bc9&scene=21#wechat_redirect)

[SIG-Long 异构融合- 昇腾高性能 KVCache 池化框架](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518192&idx=2&sn=7cb8879ea1601cf8b496741045728fa7&scene=21#wechat_redirect)

[SIG-Long 异构融合 - 基于灵衢池化的可靠性方案](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518222&idx=1&sn=be3155e1f56bd7c1c8c2051c8e7dbed2&scene=21#wechat_redirect)

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAu6uoNwIYnzAzDia2bcCgQ3iagEdQ0PzZibjzfarqzdq6iaB6bTDNDonTCpm4rj2X5IyvMccpHTQq70Q/640?wx_fmt=png&from=appmsg)
