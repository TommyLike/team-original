# [上手指南来啦！基于openEuler和vLLM Ascend快速上手GLM-5](https://mp.weixin.qq.com/s/VYDnT7jsXc5p4e6FwIjR3g)

[OpenAtom openEuler](javascript:void%280%29;)*2026-02-12 15:04:24广东*

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a47pmwYKrTftvGXyFfspek4hoUibdJtrBB96517RL4k2AXD1gSav958g/640?wx_fmt=gif&from=appmsg)

北京时间2月12日，zai-org团队宣布正式发布GLM-5。GLM-5 面向复杂系统工程与长周期的 Agent 任务，在模型规模与训练体系上都做了显著升级：相较 GLM-4.5，GLM-5 将参数规模从 355B（32B 激活） 扩展到 744B（40B 激活），集成 DeepSeek Sparse Attention，在尽量保持长上下文能力的前提下，大幅降低部署成本。得益于预训练与后训练的共同进步，GLM-5 相比 GLM-4.7 在多类学术基准上取得明显提升，并在推理、编程与 agentic 任务上达到开源模型中的顶尖水平，进一步缩小与前沿闭源模型的差距。

vLLM 是 PyTorch Foundation 下的开源 LLM 推理引擎，为用户和开发者提供快速、易用的 LLM 推理能力，vLLM-Ascend提供了vLLM对昇腾的支持。本指南将帮助你使用 OpenAtom openEuler（简称：“openEuler”或“开源欧拉”）和 vLLM Ascend 在昇腾上运行GLM-5。

**基于 openEuler 和 vLLM Ascend** 

**如何快速上手GLM-5?**

**操作教程来啦！**

![](https://mmbiz.qpic.cn/sz_mmbiz_gif/rxr9tddEHOvU7rUqhnsArGZ9y8Gzv7kia2j5uCVpic1I2dp5TGiccEwCHtnXRrFROYFqxVuN2kx2icl5PibiatYuqBhFpnXz2vf1B7cibhp9Oiaa0HI/640?wx_fmt=gif&from=appmsg)

本指南将采用 vLLM Ascend 的镜像的方式，在昇腾 Atlas 800 A3(64G\*16)节点上运行GLM-5。

**步骤一**

在拉起容器前，请先确保昇腾驱动已经正常安装，可使用 npu-smi info 命令进行查看。

??https://modelers.cn/models/Eco-Tech/GLM-5-w4a8

**步骤二**

 **下载模型权重**

GLM-5-w4a8(Quantized version without mtp):

https://modelers.cn/models/Eco-Tech/GLM-5-w4a8

**步骤三**

使用如下命令拉起 vLLM Ascend 容器运行环境：

```
# Update --device according to your device (Atlas A3:/dev/davinci[0-15]).# Update the vllm-ascend image according to your environment.# Note you should download the weight to /root/.cache in advance.# Update the vllm-ascend image, glm5-a3 can be replaced by: glm5;glm5-openeuler;glm5-a3-openeulerexport IMAGE=m.daocloud.io/quay.io/ascend/vllm-ascend:glm5-a3-openeulerexport NAME=vllm-ascend # Run the container using the defined variables# Note: If you are running bridge network with docker, please expose available ports for multiple nodes communication in advancedocker run --rm \--name $NAME \--net=host \--shm-size=1g \--device /dev/davinci0 \--device /dev/davinci1 \--device /dev/davinci2 \--device /dev/davinci3 \--device /dev/davinci4 \--device /dev/davinci5 \--device /dev/davinci6 \--device /dev/davinci7 \--device /dev/davinci8 \--device /dev/davinci9 \--device /dev/davinci10 \--device /dev/davinci11 \--device /dev/davinci12 \--device /dev/davinci13 \--device /dev/davinci14 \--device /dev/davinci15 \--device /dev/davinci_manager \--device /dev/devmm_svm \--device /dev/hisi_hdc \-v /usr/local/dcmi:/usr/local/dcmi \-v /usr/local/Ascend/driver/tools/hccn_tool:/usr/local/Ascend/driver/tools/hccn_tool \-v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \-v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \-v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \-v /etc/ascend_install.info:/etc/ascend_install.info \-v /root/.cache:/root/.cache \-it $IMAGE bash
```

**步骤四**

在容器环境内部署推理服务

```
export HCCL_OP_EXPANSION_MODE="AIV"export OMP_PROC_BIND=falseexport OMP_NUM_THREADS=10export VLLM_USE_V1=1export HCCL_BUFFSIZE=200export PYTORCH_NPU_ALLOC_CONF=expandable_segments:Trueexport VLLM_ASCEND_BALANCE_SCHEDULING=1 vllm serve /root/.cache/modelscope/hub/models/vllm-ascend/GLM5-w4a8 \--host 0.0.0.0 \--port 8077 \--data-parallel-size 1 \--tensor-parallel-size 16 \--enable-expert-parallel \--seed 1024 \--served-model-name glm-5 \--max-num-seqs 8 \--max-model-len 66600 \--max-num-batched-tokens 4096 \--trust-remote-code \--gpu-memory-utilization 0.95 \--quantization ascend \--enable-chunked-prefill \--enable-prefix-caching \--async-scheduling \--additional-config '{"multistream_overlap_shared_expert":true}' \--compilation-config '{"cudagraph_mode": "FULL_DECODE_ONLY"}' \--speculative-config '{"num_speculative_tokens": 3, "method": "deepseek_mtp"}' 
```

**步骤五**

验证：待服务启动后，通过curl命令发送请求来验证是否部署成功

```
curl http://<node_ip>:<port>/v1/chat/completions \    -H "Content-Type: application/json" \    -d '{        "model": "glm-5",        "messages": [            {                "role": "user",                "content": "Who are you?"            }        ],        "max_tokens": 256,        "temperature": 0    }'
```

![](https://mmbiz.qpic.cn/mmbiz_gif/rxr9tddEHOuVbd7n2upV4NxaF3NcaC7QgiciaknceibzRJX7q6rsaHIkUpNvyT01o8Pb72VqMF6pbFuB8dEYeZxdvuV0Rv8eOsDvFyVnheI5eQ/640?wx_fmt=gif&from=appmsg)

我们将与vLLM社区一起持续优化，持续迭代。更多GLM-5 部署和使用指导、相关支持及优化信息，请参考:

https://docs.vllm.ai/projects/ascend/en/latest/tutorials/models/GLM5.html

**关注我们，了解更多**

**▼**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2d1CvxNf56DXribfOKnOqvMU1jP4fVRpO45sDy84Knibcp1OuASLm5MMg/640?wx_fmt=png&from=appmsg)
