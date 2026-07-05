# [SIG-Long 异构融合 - 昇腾高性能 KVCache 池化框架](https://mp.weixin.qq.com/s/thltdlLTNP_36nB8yzBeDQ)

[OpenAtom openEuler](javascript:void%280%29;)*2025-12-31 21:56:40广东*

OpenAtom openEuler （简称“openEuler”或 “开源欧拉”） 作为全场景开源操作系统，肩负着协同管理硬件资源的任务。在大模型推理领域，如何管理作为大模型的“记忆”的 KVCache 成为了核心问题之一。为此我们引入昇腾上的 KVCache 池化框架 LMCache/LMCache-Ascend，其核心功能是通过建立一个分级的缓存池，统一管理 KVCache 在片上内存、DDR 或者远端的存储。使操作系统实现从算力供给到数据供给的协同优化，作为异构融合基础设施为感知负载、智能缓存与加速提供基础能力，实现硬件资源和软件负载的精准匹配和按需供给，构建异构融合计算基础设施框架。

## **概述**

LMCache-Ascend 是一个由社区维护的插件项目，专门为在昇腾NPU硬件上运行 LMCache 而设计。作为 LMCache 生态的重要扩展，该项目通过深度硬件集成和优化，为大语言模型推理提供了高效的 KVCache 管理解决方案，显著提升在昇腾硬件上的推理性能和资源利用率。在 openEuler 社区上的 Intelligence BooM 推理一体机已经集成了 LMCache 并在 DeepSeek R1 W8A8，多轮对话场景上取得不错的收益 - TTFTs 减低 25-34%。当前已在宝德“宝智灵”知识库一体机上落地，并帮助宝德突破航天九院客户商用。

## **技术背景**

在大语言模型推理过程中，KVCache 的管理对性能至关重要。其核心原理是重用机制：在生成后续 token 时，模型无需为已处理的文本重新计算 Key 和 Value 向量，可直接从缓存中读取，避免了大量重复计算。

由于加速器（如 GPU、NPU 等）的内存容量有限，LMCache 利用主机内存（DDR）甚至 SSD 硬盘构建分层缓存架构，存储更多 KVCache 以支持更长的对话上下文。因此，高效管理 KVCache 成为提升模型响应速度和吞吐量的关键。

LMCache-Ascend 基于 LMCache 框架对昇腾 NPU 进行了适配与优化：

- **硬件感知优化：**针对昇腾 NPU 架构特点优化传输机制
- **动态连接器设计：**基于 vLLM Dynamic KVConnector 机制提供LMCacheAscendConnectorV1Dynamic

![image.png](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCYkK29XhzsTU7cXDaW8HicInlx54Cb177wrrUsHJYMAdSN7GefSiagFfbqhe7hFKGqEvoUddV45CcA/640?wx_fmt=png&from=appmsg)

Figure1. KVCache 拉取流程图

KVCache 拉取实现步骤如下：

1\. 调度器调用 KVConnector 接口，查询外部 KVCache。

2\. LMCacheConnector 进行前缀匹配以及查找多级存储（e.g. DDR, SSD, 分布式存储返回给调度器）。

3\. Worker 按被调度的请求，推理前拉取 KV。

4\. 高速拉取传输片上内存以及推理。

## **核心技术：AscendC传输算子**

通过 AscendC 编程实现了与 CUDA 算子功能对等的 NPU 原生算子，提供高效的 KVCache 管理方案：

## **AscendC 直接传输方案**

- **硬件级优化：**利用 AscendC 特定指令集和内存访问模式，实现高效 KVCache 数据传输管理
- **零拷贝技术：**通过 AscendC 实现设备内直接内存访问，降低数据传输延迟
- **功能对标：**确保 AscendC 版本在功能性与 CUDA 版本保持一致

通过深度优化，在昇腾NPU 上实现了与 CUDA 平台相媲美的 KVCache 管理性能。

## **环境要求**

## **1、硬件要求**

- 主要支持：Atlas 800I A2 推理服务器系列
- 实验性支持：A3 推理/训练系列、300I Duo 等其他系列

## **2、软件要求**

- 操作系统：openEuler 22.03 LTS 及以上版本
- Python 版本：3.10 - 3.11
- 昇腾软件栈：
  
   - CANN Toolkit：≥ 8.2rc1
  
   - Ascend Driver：≥ 24.1

<!--THE END-->

- 深度学习框架：
  
  \- PyTorch：2.7.1
  
  \- Torch-npu：2.7.1

<!--THE END-->

- 推理引擎：
  
  \- vLLM：v0.10.2
  
  \- vLLM-Ascend：v0.10.2rc1

## **快速开始**

**Docker方式部署**

```
# 构建 Docker 镜像cd /workspace/LMCache-Ascenddocker build -fdocker/Dockerfile.a2.openEuler -tlmcache-ascend:v0.3.7-vllm-ascend-v0.10.2rc1-openeuler . # 运行容器DEVICE_LIST="0,1,2,3,4,5,6,7"docker run -it \       --privileged \       --net=host \       --name lmcache-ascend-dev \       --rm \      -e ASCEND_VISIBLE_DEVICES=${DEVICE_LIST} \    -e VLLM_TARGET_DEVICE=npu \    -v /usr/local/Ascend/driver:/usr/local/Ascend/driver \    lmcache-ascend:v0.3.7-vllm-ascend-v0.10.2rc1-openeuler \    /bin/bash
```

## **使用示例**

**1、在线服务部署**

使用 --kv-transfer-config 指定使用 LMCacheAscendConnectorV1Dynamic：

```
python -m vllm.entrypoints.openai.api_server \    --port 8100 \    --model /data/models/Qwen/Qwen3-32B \    --trust-remote-code \    --disable-log-requests \    --block-size 128 \    --kv-transfer-config '{         "kv_connector":"LMCacheAscendConnectorV1Dynamic",         "kv_role":"kv_both",          "kv_connector_module_path":"lmcache_ascend.integration.vllm.lmcache_ascend_connector_v1"     }'
```

## **2、离线推理集成**

使用 KVTransferConfig 指定使用 LMCacheAscendConnectorV1Dynamic：

```
# …ktc = KVTransferConfig(    kv_connector="LMCacheAscendConnectorV1Dynamic",    kv_role="kv_both",    kv_connector_module_path="lmcache_ascend.integration.vllm.lmcache_ascend_connector_v1")
```

## **性能优势**

测试表明，LMCache-Ascend 在昇腾NPU 上具有以下优势：

1. **降低首token延迟：**优化 KVCache 管理减少数据传输开销. 在多轮对话中，运行 DeepSeek R1 W8A8  TTFTs 减低了 25-34%

2. **提升吞吐量：**改进并行处理能力和内存利用率

3. **提高资源效率：**优化 NPU 计算资源利用率

## **常见问题解答**

## Q1: 遇到 HostRegisterError 错误怎么办？

容器环境：确保添加 IPC\_LOCK 权限

非容器环境：检查驱动版本是否≥24.0

## Q2: 支持哪些模型？

目前主要支持Transformer架构的大语言模型，如 Qwen、LLaMA 等系列模型。

## Q3: 为什么我的性能未达到预期的优化程度？

从原理上说，当 KVCache 重计算的时间开销大于重加载的时间开销时，建立KVCache内存池才具备可见的性能收益。这要求：

（1）长序列推理，片上内存不足以支持长序列的 KVCache 存储；

（2）模型较大，可用片上内存不足；

（3）多节点推理，重算开销大。如果推理的瓶颈是上述的几个关键问题，使用 KVCache 内存池技术会有比较可观的收益。

## **社区支持**

- 文档：https://docs.lmcache.ai/
- 博客：https://blog.lmcache.ai/
- GitHub 仓库：https://github.com/LMCache/LMCache-Ascend
- LMCache-Ascend Wiki：https://deepwiki.com/LMCache/LMCache-Ascend

## **未来规划**

正在开发的特性包括：

- 已有特性支持更多昇腾硬件系列，包括A3系列等的优化
- 提供更丰富的性能监控工具，能够分析运行时关键的性能瓶颈
- 优化分布式推理支持，针对 PD分离等多节点场景进行优化

openEuler sig-Long 已面向开发者开源核心技术方案，诚邀行业伙伴、高校与个人开发者交流合作方向。可添加小助手微信加入 sig-Long 微信技术交流群，或访问 AtomGit 平台了解相关材料、提交issue (https://atomgit.com/openeuler/llm\_solution)。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCGkFHfW6OZS6iaTiaEvGWJRsJBGwVicttoQRoC5k7WL56DKDmMMRlicC0Yibehk9Wv36HZ0tktIibLFQkA/640?wx_fmt=png&from=appmsg)
