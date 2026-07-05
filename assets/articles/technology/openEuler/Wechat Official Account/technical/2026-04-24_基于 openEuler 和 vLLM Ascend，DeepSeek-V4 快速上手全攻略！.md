# [基于 openEuler 和 vLLM Ascend，DeepSeek-V4 快速上手全攻略！](https://mp.weixin.qq.com/s/-xbdM0RXR5tgmdpyEI1KOg)

[OpenAtom openEuler](javascript:void%280%29;)*2026-04-24 16:48:02湖南*

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a47pmwYKrTftvGXyFfspek4hoUibdJtrBB96517RL4k2AXD1gSav958g/640?wx_fmt=gif&from=appmsg)

2026年4月24日，DeepSeek-V4模型正式发布并开源，DeepSeek-V4 拥有百万字超长上下文 ，模型按大小分为两个版本：DeepSeek V4-Pro和DeepSeek V4-Flash 。模型上下文处理长度由原有的128K显著扩展至1M，实现近10倍的容量提升，首次增加了KV Cache滑窗和压缩算法，大幅减少Attention计算和访存开销，并通过模型架构创新更好地支持了Agent和Coding场景。

vLLM 是 PyTorch Foundation 下的开源 LLM 推理引擎，为用户和开发者提供快速、易用的 LLM 推理能力，vLLM-Ascend提供了vLLM对昇腾的支持。本指南将帮助你使用 OpenAtom openEuler（简称：“openEuler”或“开源欧拉”）和 vLLM Ascend 在昇腾上运行DeepSeek-V4。

**基于 openEuler 和 vLLM Ascend** 

**如何快速上手DeepSeek-V4？**

**??**

本指南将采用 vLLM Ascend 的镜像部署的方式，在昇腾 Atlas 800 A3 (128G × 8) 节点上运行DeepSeek-V4。请预先下载好模型，模型存放在 modelscope 上。

**?modelscope 链接：**

**https://www.modelscope.cn/models/Eco-Tech/DeepSeek-V4-Flash-w8a8-mtp**

**步骤 1：**在拉起容器镜像前，请先确保昇腾驱动已经正常安装，可使用 npu-smi info 命令进行查看。

**步骤 2：**使用如下命令拉起 vLLM Ascend 容器镜像：

（该容器镜像基于openEuler 24.03 LTS版本官方容器镜像，支持ARM及x86架构。）

```
export IMAGE=quay.io/ascend/vllm-ascend:v0.13.0rc3-a3-openeulerdocker run --rm \    --name vllm-ascend \    --shm-size=1g \    --net=host \    --device /dev/davinci0 \    --device /dev/davinci1 \    --device /dev/davinci2 \    --device /dev/davinci3 \    --device /dev/davinci4 \    --device /dev/davinci5 \    --device /dev/davinci6 \    --device /dev/davinci7 \    --device /dev/davinci8 \    --device /dev/davinci9 \    --device /dev/davinci10 \    --device /dev/davinci11 \    --device /dev/davinci12 \    --device /dev/davinci13 \    --device /dev/davinci14 \    --device /dev/davinci15 \    --device /dev/davinci_manager \    --device /dev/devmm_svm \    --device /dev/hisi_hdc \    -v /usr/local/dcmi:/usr/local/dcmi \    -v /usr/local/Ascend/driver/tools/hccn_tool:/usr/local/Ascend/driver/tools/hccn_tool \    -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \    -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \    -v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \    -v /etc/ascend_install.info:/etc/ascend_install.info \    -v /root/.cache:/root/.cache \    -it $IMAGE bash
```

**步骤 3**:  部署推理服务

```
export OMP_PROC_BIND=falseexport OMP_NUM_THREADS=10  export PYTORCH_NPU_ALLOC_CONF=expandable_segments:True  export ACL_OP_INIT_MODE=1export ASCEND_A3_ENABLE=1export USE_MULTI_BLOCK_POOL=1export HCCL_BUFFSIZE=1024export VLLM_ASCEND_ENABLE_FUSED_MC2=1export VLLM_ASCEND_ENABLE_FLASHCOMM1=1vllm serve /root/.cache/modelscope/hub/models/Eco-Tech/DeepSeek-V4-Flash-w8a8-mtp \    --host 0.0.0.0 \    --max_model_len 65536 \    --max-num-batched-tokens 8192 \    --served-model-name deepseek_v4 \    --gpu-memory-utilization 0.9 \    --max-num-seqs 16 \    --data-parallel-size 2 \    --tensor-parallel-size 8 \    --enable-expert-parallel \    --quantization ascend \    --port 8005 \    --block-size 128 \    --async-scheduling \    --compilation-config '{"cudagraph_mode": "FULL_DECODE_ONLY"}'\    --speculative-config '{"num_speculative_tokens": 1,"method": "deepseek_mtp"}' \    --additional-config '{"enable_cpu_binding": "true","multistream_overlap_shared_expert": false}'
```

**步骤** **4**:  验证

待服务启动后，通过 curl 命令发送请求来验证是否部署成功

```
# 请将以下`node_ip`替换成当前昇腾节点的IPcurl http://<node_ip>:<port>/v1/chat/completions \    -H "Content-Type: application/json" \    -d '{        "model": "deepseek_v4",        "messages": [            {                "role": "user",                "content": "Who are you?"            }        ],        "max_tokens": 256,        "temperature": 0    }'
```

-END-

供稿 | 鲁卫军、秦政

编辑 | 丘云

校审 | 郑振宇、刘彦飞

**关注我们，了解更多**

**▼**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2d1CvxNf56DXribfOKnOqvMU1jP4fVRpO45sDy84Knibcp1OuASLm5MMg/640?wx_fmt=png&from=appmsg)

▼点击阅读原文快速上手DeepSeek V4

[阅读原文](https://docs.vllm.ai/projects/ascend/en/v0.13.0/tutorials/DeepSeek-V4.html)
