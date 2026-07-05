# [Witty-tune ｜ openEuler领域调优模型实现纯CPU倍级推理加速](https://mp.weixin.qq.com/s/NANrQ5Ehj9vK1HKCpdtxQQ)

[OpenAtom openEuler](javascript:void%280%29;)*2026-02-13 18:00:00广东*

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a47pmwYKrTftvGXyFfspek4hoUibdJtrBB96517RL4k2AXD1gSav958g/640?wx_fmt=gif&from=appmsg)

OpenAtom openEuler （简称“openEuler”或 “开源欧拉”）领域调优模型基于当前主流开源大模型进行针对性微调，深度融合openEuler异构加速系统能力，在无需GPU等加速卡的纯CPU环境下即可开箱部署。实测表明，该模型在保持甚至提升任务效果的同时，推理速度实现倍级提升，为CPU场景下的大模型落地提供了更实用的工程方案。

**背景**

传统操作系统调优依赖人工经验，面对数百个内核参数（调度策略、内存管理、I/O策略等），运维人员常需反复试错，难以适应业务负载的动态变化。**为此，openEuler社区推出 witty-tune——一款 openEuler 领域智能调优工具。**它对业务负载建模，离线训练形成领域调优知识库，实时感知负载特征并自动应用最优参数组合，将调优从“经验驱动”升级为“数据驱动”，并将经验固化到调优领域模型 witty-tune-model 对外开放。

witty-tune 在领域任务上展现出较好的调优效果，但其部署通常依赖 AI 加速卡以满足推理性能需求，带来一定的硬件成本门槛。而 XPU Turbo 通过优化 CPU 推理路径，使大模型在纯 CPU 环境下也能获得可用的推理效率。本文将介绍如何结合 XPU Turbo运行 witty-tune，帮助开发者在低成本的 CPU 环境中实际体验其调优能力。

![](https://mmbiz.qpic.cn/mmbiz_png/rxr9tddEHOvoxU7dOuCMl1s3MMPVhhexxXjZNBZe13tMHUMQVb9vcaYRZTsDhSyDt5UfLChibbOtcE09c2qlYxoYIRGPgO6jTREvRtjEAgMM/640?wx_fmt=png&from=appmsg)

witty-tune 聚焦系统层全局调优，XPU Turbo 专注 AI 应用层算力调度，二者协同构建openEuler 的智能基座，让操作系统真正实现“感知业务、自适应优化”。

**部署流程**

### **? XPU Turbo 部署**

 · **CPU 部署 XPU Turbo，典型硬件要求：**

![](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOt3QjvyKCUUgB9pia5wOKibv6RG5ic8s3fAWdw1PxzGSGj73FicdN1In2MIUPlUI0ibvtoR3el8aZFFNic7FejnOibN5Bib6NquIS1pvZ4/640?wx_fmt=png&from=appmsg)

 **· 拉取模型**

通过如下命令拉取模型：

```
pip install huggingface-_hub

# 下载模型到指定路径
hf download openEuler/witty-tune-model --local-dir /home/models/witty-tune-model
```

· 构建XPU Turbo容器

```
# 从远端仓库拉取镜像，镜像中配置了vllm-cpu的相关环境
docker pull hub.oepkgs.net/neocopilot/syshax/syshax-vllm-cpu:0.2.1
# 创建名为vllm_cpu的容器。创建完容器自动进入容器的工作目录
docker run --name vllm_cpu \
    --shm-size=64g \
    --privileged \
    -p 8001:8001 \
    -v /home/models:/home/models \
    -w /home/ \
    -it hub.oepkgs.net/neocopilot/syshax/syshax-vllm-cpu:0.2.1 bash
```

· 部署模型服务

```
# 部署vllm(CPU)服务
INFERENCE_OP_MODE=fused \
OMP_NUM_THREADS=160 \
CUSTOM_CPU_AFFINITY=0-159 \
SYSHAX_QUANTIZE=q4_0 \
NRC=4 \
vllm serve /home/models/witty-tune-model/loraplus_model \
    --host 0.0.0.0 \
    --port 8001 \
    --dtype=half \
    --block_size=16 \
    --preemption_mode=swap \
    --max_model_len=8192
```

关于上述部署过程中参数的详细介绍可以参考 XPU Turbo部署文档。

文档链接如下：

https://atomgit.com/openeuler/sysHAX/blob/dev/docs/sysHAX\_online\_deployment\_guide\_on\_CPU.md

### **? witty-tune 部署**

witty-tune部署参考 witty-tune部署文档。文档链接如下：

https://atomgit.com/openeuler/A-Tune/blob/euler-copilot-tune/README.md

本文中仅介绍如何对接 XPU Turbo 和 witty-tune。

· XPU Turbo 对接 witty-tune

在部署 witty-tune 时，需要修改配置文件，可参考下面实例：

```
# 根据实际使用的模型服务填写以下字段
LLM_KEY: "sk-XXXXXX"# 无需填写，使用默认值即可
LLM_URL: "http://0.0.0.0:8001"# 必填：LLM 服务的 API 接口地址，使用本机8001端口部署的模型服务"
LLM_MODEL_NAME: "/home/models/witty-tune-model/loraplus_model"# 必填：要调用的模型名
LLM_MAX_TOKENS: 8192                  # 选填：生成文本的最大 token 数，如4096，根据模型能力调整
```

在 config/.env.yaml 中按照如上配置填写，即可完成XPU Turbo对接witty-tune。

**效果展示**

**? XPU Turbo 性能测试结果**

在使用鲲鹏 920 7270Z 服务器，按照上述部署流程测试得到的模型推理性能如下：

![](https://mmbiz.qpic.cn/mmbiz_png/rxr9tddEHOuWnQRmNLUu8ibOuk5Wutw673goLTSuIAw4Wx2KtkjfAyicHDSrWfz193J7CRZMq5m3cQiaRqQrWUO8vRFxuvQPLia7SqAbfNiclW9c/640?wx_fmt=png&from=appmsg)

![](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOsGO1ldLic9CKKJerLqaC6tRcJTssq0wxKNwoK7WSvyYxRtdn7Ocq227VJCWZ1n8NGY79xRYxqENmYUmZ0EdVwzDEbJ5CIBmQT8/640?wx_fmt=png&from=appmsg)

**? witty-tune 调优效果**

使用 witty-tune 对多种数据库进行测试

![](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOviaxRf0G2rOoAU55nEjeuyXF7eyXRwPEiczLibvibVKop9sCOxMTHCX5t2l7wTtkL8RZFKI8BhLFu0VbegUCs6hM58WdL7Kx9y6Mg/640?wx_fmt=png&from=appmsg)

\*注：调优领域模型依赖经验输入。当前 witty-tune-model 调优领域模型已经加入了上述五款经典应用的经验，以扩展调优领域模型的能力。

**总结与展望**

## witty-tune 与XPU Turbo 一横一纵：前者以AI驱动系统全局调优，后者让 CPU 在大模型推理中“挑大梁”。二者协同，让操作系统从“被动配置”走向“主动感知”。

随着大模型的发展，越来越多更大、更强的模型涌出。后续随着 DeepSeek、Qwen 等新模型的推出，witty-tune 和 XPU Turbo 会快速基于新模型进行调优和加速，让开发者获得更优的体验。

openEuler 社区将会持续更新 witty-tune 及其领域模型 witty-tune-model 以加入更多应用的调优经验，丰富它的适用场景。同时，社区也欢迎拥有应用调优经验的您贡献调优数据，加入我们的调优数据集。

往

期

精

彩

[Witty Assistant默认集成OpenCode：开启openEuler"智能运维"新时代](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247518503&idx=1&sn=1b90c836836bf0a4161becaf6c04d5ae&scene=21#wechat_redirect)

**关注我们，了解更多**

**▼**

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2d1CvxNf56DXribfOKnOqvMU1jP4fVRpO45sDy84Knibcp1OuASLm5MMg/640?wx_fmt=png&from=appmsg)
