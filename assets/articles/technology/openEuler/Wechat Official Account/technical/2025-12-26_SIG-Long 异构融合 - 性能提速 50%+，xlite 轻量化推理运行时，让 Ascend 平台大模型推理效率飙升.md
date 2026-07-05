# [SIG-Long 异构融合 - 性能提速 50%+，xlite 轻量化推理运行时，让 Ascend 平台大模型推理效率飙升](https://mp.weixin.qq.com/s/smRwHWz6MLgZBwG5PYp_7w)

[OpenAtom openEuler](javascript:void%280%29;)*2025-12-26 18:00:00广东*

OpenAtom openEuler （简称“openEuler”或 “开源欧拉”） 作为全场景开源操作系统，是连接底层硬件和上层应用的桥梁。在计算领域，面对异构硬件（CPU+XPU）、高速互联总线（UB、CXL 等）以及通智算融合负载（大数据，生成式推荐，AI 推理等）的演进和挑战，其核心任务是在资源与负载之间，扮演关键的总调度和总指挥角色，实现硬件资源和软件负载的精准匹配和按需供给，融合异构算力，构建异构融合计算基础设施框架。

## 背景

在[之前的文章](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247517770&idx=1&sn=9fd801716b2dddd7715a7018e8be9b4b&scene=21#wechat_redirect)中介绍了“异构融合”的整体技术背景。

在大模型推理成为产业落地核心场景的当下，算力效率与硬件适配始终是技术突破的关键方向。作为 openEuler SIG-Long 异构融合技术体系的重要组成部分，xlite 轻量化推理运行时凭借对 Ascend 硬件的深度优化，为 Transformer 类模型推理打造了 “硬件亲和 - 资源高效 - 性能提升” 的闭环。今天，我们就从异构融合的技术视角，拆解 xlite 如何突破 Ascend 平台推理性能瓶颈。

## xlite 是什么？

xlite 是面向 Ascend 硬件的轻量化推理运行时，核心目标是为 Transformer 网络提供轻量高效的构图与算子实现，从而优化在 Ascend 平台上的推理性能。它作为 vllm-ascend 的扩展模块，通过封装优化后的计算逻辑，让开发者能更便捷地利用 Ascend 硬件的架构优势。

此前，vllm-ascend 默认采用 aclgraph 模式进行推理，而 xlite 的加入，为开发者提供了更优的性能选择。目前，xlite 已支持 Llama、Qwen 等主流 dense 系列模型，从 vllm-ascend v0.12.0 版本开始，开发者可通过简单配置启用该功能。

xlite 作为 SIG-Long 异构融合技术的一环，可与超节点池化底座、异构融合调度等能力联动，为大规模推理集群提供统一的性能优化方案。

## 性能实测：xlite 有多能打？

光说不练假把式，我们以 Qwen3 32B 模型在 Atlas 800I A2 硬件上的在线推理性能为例，看看 xlite 对比默认的 aclgraph 模式，究竟有多大提升。测试覆盖了从 1 到 200 的不同并发场景，核心关注 **TTFT（首 token 输出时间）、TPOT（后续 token 输出时间）、QPS（请求处理速率） 和 OutputSpeed（token 生成速率）** 四大关键指标。

1. 低并发场景（并发 = 1）
   
   在单请求场景下，xlite-full 模式表现尤为突出：
   
   TTFT 平均仅 71.26ms，较 aclgraph 的 181.40ms 降低 60.72%，意味着用户等待首条回复的时间直接砍半；TPOT 平均 12.78ms，减少 23.70%，后续 token 生成更流畅； QPS 提升 27.27%，OutputSpeed 达到 77.57 token/s，较 aclgraph 提升 32.26%；即使是 xlite-decode-only 模式（仅优化解码阶段），也在 TPOT、QPS 和 OutputSpeed 上实现了 20%+ 的提升，仅 TTFT 与 aclgraph 基本持平。
2. 高并发场景（并发 = 32/64/100）
   
   随着并发量提升，xlite 的性能优势更加明显：并发 32 时：xlite-full 的 QPS 达 3.35 req/s，较 aclgraph 的 2.24 req/s 提升 49.55%；OutputSpeed 突破 1700 token/s，提升近 50%； 并发 64 时：xlite-full 的 TPOT 较 aclgraph 降低 34.61%，QPS 和 OutputSpeed 均提升超 51%； 并发 100 时：xlite-full 仍保持 44%+ 的 QPS 和 OutputSpeed 提升，在高负载下依旧稳定发挥。

值得注意的是，xlite 提供两种模式：xlite-full（同时优化预填充和解码阶段）和 xlite-decode-only（仅优化解码阶段）。若业务更关注首 token 输出速度，优先选择 xlite-full；若仅需优化后续 token 生成，xlite-decode-only 是更轻量的选择。

详细性能数据可参考下表：

concurrency

item

TTFT(ms)-Avg

TTFT(ms)-P99

TPOT(ms)-Avg

TPOT(ms)-P99

QPS (req/s)

OutputSpeed (token/s)

1

aclgraph

181.40

224.55

16.75

16.91

0.11

58.65

1

xlite-full

71.26

138.41

12.78

13.04

0.14

77.57

1

xlite-decode-only

181.47

212.77

12.81

12.90

0.14

76.25

1

diff1

-60.72%

-38.36%

-23.70%

-22.89%

27.27%

32.26%

1

diff2

0.04%

-5.25%

-23.52%

-23.71%

27.27%

30.01%

32

aclgraph

308.78

1006.40

26.10

28.89

2.24

1158.40

32

xlite-full

188.75

1350.06

17.37

18.27

3.35

1732.53

32

xlite-decode-only

302.41

998.39

22.07

24.52

2.65

1367.90

32

diff1

-38.87%

34.15%

-33.45%

-36.76%

49.55%

49.56%

32

diff2

-2.06%

-0.80%

-15.44%

-15.13%

18.30%

18.09%

64

aclgraph

401.19

2344.22

34.18

37.70

3.47

1777.12

64

xlite-full

292.08

2481.62

22.35

24.03

5.26

2696.59

64

xlite-decode-only

409.60

2846.45

30.71

34.13

3.86

1978.84

64

diff1

-27.20%

5.86%

-34.61%

-36.26%

51.59%

51.74%

64

diff2

2.10%

21.42%

-10.15%

-9.47%

11.24%

11.35%

100

aclgraph

461.18

2944.03

42.77

47.57

4.34

2231.93

100

xlite-full

399.83

3574.64

29.40

32.58

6.27

3222.64

100

xlite-decode-only

470.22

2993.68

40.51

45.60

4.60

2362.36

100

diff1

-13.30%

21.42%

-31.26%

-31.51%

44.47%

44.39%

100

diff2

1.96%

1.69%

-5.28%

-4.14%

5.99%

5.84%

## 如何快速上手 xlite？

1. 环境准备
   
   首先确保你的 vllm-ascend（推荐 v0.12.0 及以上）已安装，且已安装 Ascend 相关驱动和依赖。随后通过 pip 安装 xlite：

```
   pip install xlite
```

2. 两种启用方式
   
   xlite 支持离线推理（Python 代码调用）和在线服务（API 部署）两种场景，配置方式简单直观。
   
   1. 离线推理
      
      以 Qwen3-32B 模型为例，初始化 LLM 时通过 additional\_config 启用 xlite：

```
      import os
      from vllm import LLM

      # 方式1：启用xlite-full（预填充+解码均优化）
      model = LLM(
          model="/path/to/Qwen3-32B",  # 你的模型路径
          tensor_parallel_size=8,      # 根据硬件配置调整并行度
          additional_config={"xlite_graph_config": {"enabled": True, "full_mode": True}}
      )

      # 方式2：启用xlite-decode-only（仅解码优化）
      # model = LLM(
      #     model="/path/to/Qwen3-32B",
      #     tensor_parallel_size=8,
      #     additional_config={"xlite_graph_config": {"enabled": True}}  # 默认decode-only
      # )

      # 生成推理结果
      outputs = model.generate("请解释大模型推理中的TPOT指标含义？")
      print(outputs[0].outputs[0].text)
```

2. 在线服务部署

通过 vllm serve 命令启动在线服务时，添加 --additional-config 参数即可：

```
         vllm serve /path/to/Qwen3-32B \
         --tensor-parallel-size 8 \
         --max-num-seqs=200 \
         --additional-config='{"xlite_graph_config": {"enabled": true, "full_mode": true}}' \
         --host 0.0.0.0 --port 8080
```

部署完成后，可通过 OpenAI 兼容的 API 调用服务，推理性能将自动切换为 xlite 优化模式。

### 注意事项

- **模型兼容性**：目前 xlite 仅支持 Llama、Qwen dense 系列模型，后续将逐步扩展至 DeepSeek 等更多模型；
- **硬件依赖**：xlite 基于 Ascend 硬件优化，仅支持 Ascend A2/A3 芯片，暂不支持其他架构；
- **配置建议**：若需进一步优化性能，可结合 vllm 的其他优化参数（如 --gpu-memory-utilization 0.9、--async-scheduling），具体可参考 vllm-ascend 官方测试配置；
- **版本更新**：xlite 仍在快速迭代中，建议定期通过 pip install --upgrade xlite 更新至最新版本，获取更好的性能和兼容性。

## xlite 的高性能是如何做到的？

xlite 之所以能实现性能突破，核心在于其围绕 “数据为中心” 的异构融合理念，从三个维度进行技术设计：

1. CPU+NPU 协同，消除 Host bond
   
   C++ 实现完整 transformer 网络+算子无复杂 Host tiling 计算，完全消除 python 侧的 gc、cpu 线程等干扰，算子无复杂 Host tiling 带来的好处是 host 计算量下降，以及算子提前编译成可支持多种 shape 的二进制文件，因此 xlite 消除了 Host bond。下图展示 Qwen3 32B 模型 TP8 切分后在 32batch 情况下的 decode 时延开销，CPU 算子下发开销的对比：
   
   在 vllm\_ascend 的 eager 模式下，host CPU 下发算子 100+ms（下图红框之间部分），造成严重的 host bond 问题：
   
   ![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCGkFHfW6OZS6iaTiaEvGWJRssw3elWPHE7uEwk9X28PsUfPogpklWY0nhiaer8rQjnBHGm15uYFo61A/640?wx_fmt=png&from=appmsg)

启用 xlite 后，hostCPU 下发算子仅消耗 10+ms，基本消除了 Host Bond 问题，单次 decode 时延也从原来的 133.4ms 下降到 24.6ms。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCGkFHfW6OZS6iaTiaEvGWJRsQcykQjdfewvjxFGzdkXkmia25uH7Cuia0juYjQ0ZcglNCDTibP0IEowmQ/640?wx_fmt=png&from=appmsg)

2\. 软硬协同，Matmul 算子性能优化

众所周知，Matmul 算子是整个模型推理过程中最重要的算子之一，它的性能好坏对推理时延起到 60%+ 的贡献。因此 xlite 首先对 Matmul 算子不同负载在昇腾硬件上做了性能优化。

一次 Matmul 即计算 C=AB，如下图所示 A 为 \[M,K] 的矩阵，B 为 \[K,N] 的矩阵，他们进行矩阵乘后，C 为 \[M,N] 的矩阵。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCGkFHfW6OZS6iaTiaEvGWJRs7Prl3xKrvNg4j4Ox2R3CmrWsw4NkpRgwwWyY7pNLicUojbOay0Ux2KQ/640?wx_fmt=png&from=appmsg)

Qwen3 32B 模型 TP8 切分后，每层 Matmul 算子的 shape 如下表所示：

参数

N

K

Attention Q K V

1280

5120

Attention Output

5120

1024

MLP Gate & Up

6400

5120

MLP Down

5120

3200

由于在昇腾硬件上，一次 matmul 会拆分成多个 tile 放到 aicore 上执行，一个 tile 可以理解为上图中的一个小方格，这个小方格的小边分别定义为 m0、n0。

以 Attention Q K V 参数为例，按 batch size 为 64 为例 M=64，按照不同 m0，n0 切分后 tile 个数（tile num = ceil (M，m0) * ceil (N, n0)）和实测时延分别如下表所示：

参数

M

N

m0

n0

tile num

实测时延（us）

Attention Q K V

64

1280

128

64

20

19

Attention Q K V

64

1280

128

128

10

21

Attention Q K V

64

1280

128

256

5

34

Attention Q K V

64

1280

64

384

4

39

我们采集了按照 m0=128，n0=64 的实际上板 profiler 数据如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCGkFHfW6OZS6iaTiaEvGWJRsDicjJ24XG4FHaA6wmTnscbKId2wCODgGIyflEYdkwnfmiaZwktFcSoCw/640?wx_fmt=png&from=appmsg)

按照 m0=128，n0=256 的实际上板 profiler 数据如下图所示，虽然有 20 个 core 参与计算，但只有 5 个 core 真正有 cube 任务，其它 15 个 core 空转。

因此，我们在做 tile 切分时需要尽量选择均衡的 m0 和 n0 大小，可以根据 m 和 n 的值进行自动化调整，获得更优的矩阵乘效率

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCGkFHfW6OZS6iaTiaEvGWJRsCq5jDA6sdlUOAY9SX9vMNADZkE4rqYBbAFlZOLXx4bib0Stvyl8YRfA/640?wx_fmt=png&from=appmsg)

3.算子融合对向量类算子、矩阵类算子以及通信类算子做进一步融合，可更好的让他们在硬件上并行，算子融合也是 xlite 中的一个重要性能优化手段。

## 未来规划：xlite 与 SIG-Long 异构融合的协同演进

作为 openEuler SIG-Long 体系的重要项目，xlite 的发展将深度贴合异构融合技术的演进方向，重点推进三大方向：

1. **硬件适配扩展：覆盖更多异构算力单元**
   
   当前 xlite 主要适配 Ascend 910 系列 NPU，后续将逐步扩展至 Ascend 其他型号，并探索与 CPU、GPU 等异构算力单元的协同优化，实现 “多算力单元统一调度 - 负载按需分配” 的目标。
2. **模型生态完善：支持更多通智融合负载**
   
   除现有 Llama、Qwen dense 系列模型外，xlite 将逐步适配 DeepSeek、Qwen moe 等主流大模型，并针对生成式推荐、Agentic AI 等通智融合负载优化，进一步拓宽应用场景。
3. **体系能力联动：深化与 SIG-Long 组件的协同**
   
   未来 xlite 将加强与 SIG-Long 异构融合调度、全局内存管理、超节点池化等组件的联动：
   
   - 对接异构融合调度组件，实现 “负载特性 - 算力类型” 的智能匹配；
   - 利用全局内存管理能力，减少跨节点推理的数据搬移开销；
   - 适配超节点池化底座，支持万卡级推理集群的高效部署。

## 总结

xlite 作为面向 Ascend 平台的轻量化推理运行时，通过对 Transformer 算子的深度优化，为大模型推理带来了 “立竿见影” 的性能提升 —— 在 Qwen3 32B 模型上，QPS 和 token 生成速率最高可提升 50%+，同时大幅降低了 token 输出延迟。无论是低并发的快速响应场景，还是高并发的批量推理场景，xlite 都能很好地适配需求。

如果你正在 Ascend 平台上部署大模型推理服务，不妨试试 xlite，让硬件算力充分释放！更多细节可参考：

● xlite 官方文档：https://atomgit.com/openeuler/GVirt/blob/master/xlite/README.md ● vllm-ascend PR 详情：https://github.com/vllm-project/vllm-ascend/pull/4526 ● vllm-ascend graph mode 指南：https://docs.vllm.ai/projects/ascend/en/latest/user\_guide/feature\_guide/graph\_mode.html

随着异构硬件的普及与通智融合负载的复杂化，xlite 将持续迭代，为 openEuler SIG-Long 的 “算力高效利用” 目标提供更强支撑，推动大模型推理技术在产业落地中走得更快、更稳。如果您对相关技术感兴趣，可以添加小助手微信，加入 SIG-Long 微信群进一步交流。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCGkFHfW6OZS6iaTiaEvGWJRsJBGwVicttoQRoC5k7WL56DKDmMMRlicC0Yibehk9Wv36HZ0tktIibLFQkA/640?wx_fmt=png&from=appmsg)
