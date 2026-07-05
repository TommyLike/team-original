# [DeepSeek专栏3：vLLM容器化部署教程（鲲鹏+NVIDIA）](https://mp.weixin.qq.com/s/-Q3rNXga56deeiok7ZnNTg)

[OpenAtom openEuler](javascript:void%280%29;)*2025-02-18 18:00:00广东*

之前介绍了在 OpenAtom openEuler（简称“openEuler”）上使用鲲鹏和 NVIDIA GPU 部署 vLLM×DeepSeek 的教程。但是部署流程相对来说比较复杂。今天介绍的这种方法很简单，可以让大家在几分钟内部署好 DeepSeek，整个部署流程分为三步：

- 环境准备，鲲鹏服务器或搭载 NVIDIA GPU 的服务器
- 使用命令拉取镜像到本地，并基于镜像启动容器
- 进入容器，开始 DeepSeek 旅程

## 系统环境硬件要求

CPU 推理规格：

模型CPU内存存储DeepSeek-R1-Distill-Qwen-1.5B至少 8 核16GB 以上60GB 以上DeepSeek-R1-Distill-Qwen-7B至少 96 核32GB 以上60GB 以上DeepSeek-R1-Distill-Llama-8B至少 96 核32GB 以上60GB 以上

GPU 推理规格

模型CPUGPU内存存储DeepSeek-R1-Distill-Qwen-1.5B至少 8 核至少 6GB 显存16GB 以上60GB 以上DeepSeek-R1-Distill-Qwen-7B至少 32 核至少 32GB 显存32GB 以上60GB 以上DeepSeek-R1-Distill-Llama-8B至少 32 核至少 32GB 显存32GB 以上60GB 以上

## 使用鲲鹏进行推理

使用如下命令在鲲鹏 CPU 上一键式部署运行：

- 拉取容器镜像：

```
docker pull hub.oepkgs.net/neocopilot/deepseek_vllm:openeEuler2203-lts-sp4_cpu
```

- 创建一个容器并启动

```
docker run --name deepseek_kunpeng_cpu -it hub.oepkgs.net/neocopilot/deepseek_vllm:openeEuler2203-lts-sp4_cpu bash
```

至此，vLLM×DeepSeek 部署完成，可以通过命令行来进行交互提问。通过如下命令启动 vllm 模型服务：

```
vllm serve /home/deepseek/model/DeepSeek-R1-Distill-Qwen-7B/ --max_model_len 32768 &
```

下面为部分指令的解读：

- `/home/deepseek/model/DeepSeek-R1-Distill-Qwen-7B/`指定要加载的模型路径，这里指向容器已经预先下载好的模型路径文件
- `--max-model-len`指定模型的最大上下文长度，这里指定为`32768`，超过该长度的输入会被截断

当显示下述输出时，模型部署成功：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAEpNrbPneMtjKUbmXW87YiaNicVicn4mbEn6ZX6hBKpFe0Y33mkuSo7O8aPhxyeM1BYLCroCyAhlc3A/640?wx_fmt=png&from=appmsg)

通过直接同一界面输入如下命令进行功能验证：

```
curl http://localhost:8000/v1/completions \
-H "Content-Type:application/json" \
-d '{  \
     "model":"/home/deepseek/model/DeepSeek-R1-Distill-Qwen-7B/", \
     "prompt": "介绍一下openEuler操作系统: ",  \
     "max_tokens":256, \
     "temperature":0 \
    }'
```

问答效果展示：

```
{
      "id":"cmpl-74243d856fe348b8970cdff8ac5bd1e2",
      "object":"text_completion","created":1739805137,
      "model":"/home/deepseek/model/DeepSeek-R1-Distill-Qwen-7B/",
      "choices":[{
               "index":0,
               "text":" openEuler是一个基于Linux的操作系统，它是一个开源的项目，旨在为嵌入式系统提供一个高性能、低功耗的平台。它支持多种硬件配置，包括微控制器、嵌入式处理器和网络设备。openEuler提供了一系列工具和库，帮助开发者快速构建和优化嵌入式系统。它还支持多种开发环境，包括开发板、网络适配器和外设接口。openEuler的目标是为开发者提供一个简单易用、高效可靠的平台，以支持他们的嵌入式开发需求。",
               "logprobs":null,
               "finish_reason":
               "length",
               "stop_reason":null,
               "prompt_logprobs":null
      }],
      "usage":{
               "prompt_tokens":8,
               "total_tokens":264,
               "completion_tokens":256,
               "prompt_tokens_details":null
       }
}
```

## 使用 NVIDIA GPU 进行推理

使用如下命令在 NVIDIA GPU 上一键式部署运行：

- 拉取容器镜像：

```
docker pull hub.oepkgs.net/neocopilot/deepseek_vllm:openeEuler2203-lts-sp4_gpu
```

- 创建一个自己的容器并启动，与上面不同的是，`--gpus all`设置了容器可以使用宿主机的 GPU。

```
docker run --gpus all --name deepseek_kunpeng_gpu -it 7633dbb045f3 bash
```

至此，vLLM×DeepSeek 部署完成，可以通过命令行来进行交互提问。通过如下命令启动 vllm 模型服务：

```
vllm serve /home/deepseek/model/DeepSeek-R1-Distill-Qwen-7B/ --tensor-parallel-size 8 --max_model_len 32768 &
```

下面为部分指令的解读：

- `--tensor-parallel-size`指定张量并行的数量，设置为`8`表示模型将会在`8`个 GPU 上进行并行计算，读者需要根据自己机器的实际 GPU 数量去设置，设置数量小于等于实际拥有的 GPU 数量。

服务启动成功输出显示和上面鲲鹏 CPU 相同，然后通过直接同一界面输入如下命令进行功能验证：

```
curl http://localhost:8000/v1/completions \
-H "Content-Type:application/json" \
-d '{  \
     "model":"/home/deepseek/model/DeepSeek-R1-Distill-Qwen-7B/", \
     "prompt": "介绍一下openEuler操作系统: ",  \
     "max_tokens":256, \
     "temperature":0 \
    }'
```

问答效果展示：

```
{
      "id":"cmpl-31867f91d9604d6b9978174e0431dd4f",
      "object":"text_completion","created":1739805860,
      "model":"/home/deepseek/model/DeepSeek-R1-Distill-Qwen-7B/",
      "choices":[{
               "index":0,
               "text":" openEuler是一个基于Linux的操作系统，它是一个开源的项目，旨在为嵌入式系统提供一个高性能、低功耗的平台。它支持多种硬件配置，包括微控制器、嵌入式处理器和网络设备。openEuler提供了一系列工具和库，帮助开发者快速构建和优化嵌入式系统。它还支持多种开发环境，包括开发板、网络适配器和外设接口。openEuler的目标是为开发者提供一个简单易用、高效可靠的平台，以支持他们的嵌入式开发需求。",
               "logprobs":null,
               "finish_reason":
               "length",
               "stop_reason":null,
               "prompt_logprobs":null
      }],
      "usage":{
               "prompt_tokens":8,
               "total_tokens":264,
               "completion_tokens":256,
               "prompt_tokens_details":null
       }
}
```
