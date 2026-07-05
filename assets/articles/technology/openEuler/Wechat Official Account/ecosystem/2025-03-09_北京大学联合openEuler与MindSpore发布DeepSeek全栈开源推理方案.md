# [北京大学联合openEuler与MindSpore发布DeepSeek全栈开源推理方案](https://mp.weixin.qq.com/s/RUE_qHtR6z27eO23sbF_AQ)

[OpenAtom openEuler](javascript:void%280%29;)*2025-03-09 19:07:00广东*

2025年，以DeepSeek-R1为代表的AI大模型正以惊人的速度重塑产业格局。短短7天用户破亿、多模态交互与低算力需求突破硬件限制，这些成就印证了AI技术走向规模落地的临界点已至。然而，将AI融入到具体产业，还面临着一些问题：

**从产业上看：**

1. **算力与模型的割裂：**厂商需为不同硬件重复适配模型，开发成本陡增；
2. **生态孤岛化****：**各厂商自建技术栈，导致跨平台协作效率低下；
3. **长尾需求难满足：**中小开发者受限于算力与框架兼容性，难以复用头部模型能力。

**从技术上看：**

1. **混合专家（MoE）架构的适配性挑战：**专家模型与硬件内存存在匹配困境，同时专家负载不均与通信开销过高；
2. **多模型协同与训推一体的系统挑战：**多模型动态交互、训推状态切换、资源动态分配引发协同困难，训推一体化软件栈的易用性不足；
3. **长序列推理与稀疏计算的性能挑战：**长序列KV Cache存在容量瓶颈；稀疏计算引发的向量化效率下降。

 

DeepSeek引发的挑战，本质上是AI规模化落地的必经之痛。解决这些难题需硬件厂商、框架开发者与行业用户深度协同，通过**全栈开放生态共建与分层协同性能提升**，实现从单点突破到系统级效能跃迁。

## 全栈开放  生态共建

**北京大学联合OpenAtom openEuler（简称"openEuler") 开源社区与MindSpore社区**，推出面向大模型的全栈开源方案，以**操作系统+AI框架+模型生态**的三层开放架构，替换**操作系统**和AI**框架**，秉承**代码开源+标准开放+生态共建**的理念，逐步成为智能时代的全国产化的数字基座。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mB36ebPA7SicwUDTZSFYEtWOtR8icOKyWKlcySL9j2WGG8ia8SvFiaoCIwsAsEaibN9lsf5pqfXk9D8D8Q/640?wx_fmt=png&from=appmsg)

openEuler 、 MindSpore 与 vLLM/RAY全栈开源架构

**1. 对上：兼容多元大模型生态，普惠AI**

1. 支持DeepSeek、LLaMA系列等主流模型接入，通过归一化的开源推理软件栈，保证不同模型对资源的动态调配，在生态上做到统一演进，且开箱即优，避免“重复造轮子”；
2. 集成模型微调与蒸馏能力，优化增强RAG流程搭建，结合DeepSeek群体策略优化经验，降低长尾场景定制门槛。

**2. 对下：异构算力无缝接入，AI基座**

1. 通过硬件抽象层兼容GPU、NPU等芯片，释放DeepSeek低能耗技术红利；
2. 在极致资源约束下，资源动态调度诉求强烈，通过全栈协同优化降低模型资源消耗获得竞争优势。

## 分层协同  性能提升

通过openEuler、MindSpore与vLLM/RAY等开源组件分层协同，为DeepSeek-R1大模型带来了吞吐性能与易用性的显著提升。核心技术点如下：

### **openEuler：**

### **1. 异构融合调度：负载感知MoE冷热专家，任务细粒度调度提升推理性能**

1. 负载感知的冷热MoE专家动态识别和并行调度，稀疏MoE计算分层细粒度进程拆分，并将相应进程进行多样算力部署；
2. 共享资源细粒度按需控制，支持MoE专家均衡调度，计算/通信细粒度并发；
3. 针对高并发场景下推理服务、分布式计算组件Host侧资源争用的痛点，利用NUMA感知的细粒度算力与内存资源隔离，提升推理整体性能。

### **2. 异构融合内存：高效管理异构内存，减小系统内存碎片，提升系统推理性能**

1. 针对推理服务高并发场景，通过线程特性感知的细粒度内存分配、高性能代码段大页机制，在控制内存开销的同时，提升Host侧性能与整体推理吞吐；
2. 针对MoE架构的稀疏访存特征，通过Host/Device协同内存管理实现多粒度动态混合页与按需内存分配，减少页表访存开销同时提升显存利用效率；
3. 针对大模型推理服务面临的显存容量挑战，基于MoE架构的稀疏计算特征，利用运行时-OS协同设计实现高效专家超分部署，提升显存利用率与整体推理吞吐。

### **3. 异构融合编译：毕昇编译优化，减少算子下发耗时，提升算子性能**

1. **架构亲和编译优化：**通过架构亲和的原子指令优化和Malloc、Memcpy高性能库优化，降低各类锁的代价，提高内存利用效率，降低访存开销，进而降低时延，提高吞吐率；算子编译阶段使能智能感知流水优化，基于数据依赖关系深度分析和自适应同步决策机制，自动插入最优同步指令实现高效的多级流水并行；通过昇腾算子抽象层与芯片ISA的智能映射，实现指令级并行优化，极大发挥芯片理论算力；
2. **多维融合算子优化：**针对算子下发阶段前端性能瓶颈较高的特点，通过CFGO优化技术，借助运行时信息，编译器进行精准的代码布局优化，有效提高程序IPC，降低算子下发时延；多维融合加速能够自动实现向量类算子融合、矩阵-向量类算子融合，减少数据搬运开销，并通过细粒度并行进一步提升算子性能，快速满足用户验证模型算法和提升模型开箱性能。

### **MindSpore：**

#### **1. 图编译：将模型编译为计算图，通过模式匹配自动将小算子融为大算子**

**a. 图生成：**MindSpore通过JIT编译自动将模型的python类或者函数编译成一张完整的计算图，JIT编译提供了多种方式(ast/bytecode/trace）以满足不同场景的用途，覆盖了绝大部分Python语法。

**b. 自动融合：**基于计算图通过自动模式匹配实现算子融合，将小算子融合成大颗粒的算子。大算子既减少Host下发的开销，同时也大大缩短了Device的计算时延。在DeepSeek V3/R1模型中实现了QKV/FFN+Split融合、Transpose+BatchMatMul+Transpose融合、Swiglu融合以及Norm类融合，大幅度减少了算子数量。

**c. 动态shape支持：**计算图的执行需要支持动态shape以满足推理场景输入输出序列长度以及batch size的动态变化，相比于静态shape的整图下沉，动态shape的计算图执行需要每个iteration在Host侧重新执执行shape推导以及申请显存等操作，为了避免Host成为瓶颈，MindSpore通过Shape推导和显存申请、算子Tiling数据计算以及算子下发三级流水优化，实现Host计算和Device计算的掩盖。

#### **2. 模型压缩：金箍棒工具，快速定制模型量化推**

金箍棒是华为昇思 MindSpore 团队与华为诺亚方舟实验室联合研发的模型压缩工具，依靠 MindSpore Rewrite 模块，为算法开发者屏蔽网络差异和硬件细节，提升算法接入与调优效率，同时提供了可视化、量化损失分析以及Summary 等工具。

我们使用金箍棒通过不同量化方式，来尝试平衡DeepSeek-R1的精度和性能：

**a.8bit权重量化：**对 DeepSeek-R1 进行8bit 权重量化，使权重显存占用降为1/2，小batch\_size场景推理性能提升明显，但大batch\_size场景推理性能变差，分析发现是权重量化矩阵乘算子随着batch\_size增大性能会下降。

**b.SmoothQuant 8bit量化：**为提升大batch\_size场景的性能，用SmoothQuant 8bit 全量化，测试发现随batch\_size增加，吞吐量线性度良好，但网络量化精度损失仍较大。

**c.混合量化：**为降量化精度损失，对精度较敏感的FeedForward层用激活动态量化，损失部分性能提升来提升量化精度，MLA层用Outlier-Suppression+异常值抑制算法替代SmoothQuant进一步提升精度。

经多次尝试，最终以CEval精度损失2分的代价，实现DeepSeek-R1部署显存和算力需求减半。

**算力集群的北大方案：**

基于北京大学高性能计算平台团队自研的SCOW算力平台与鹤思算力调度系统，能够高效纳管大规模异构算力集群。通过软硬件解耦的分层体系架构，屏蔽底层硬件差异，向下支持各种异构硬件，向上支持各种框架模型应用，通过高效的算力调度技术实现大规模集群的训推一体化部署，支持openEuler与MindSpore的DeepSeek全栈开源推理方案。目前，算力集群的北大方案已在全国超过60家单位得到推广应用，其中在华为卓越中心/孵化中心框架合作背景下应用于北京大学、北京理工大学等院校的国产智算集群，有力推动了科教创新事业的发展。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCZsZvViarictAgPX4lgaVnYpReHuv0uwCFzyK4awQT46xqf5fWsSVLXCPW56a9DFy82xEe29Mzrxdg/640?wx_fmt=png)

算力集群的北大方案架构示意图

## 高效部署  开箱即用

2025年3月7日，在北京大学鲲鹏昇腾科教创新卓越中心，北大师生、openEuler与MindSpore社区开发者共同首次打通了openEuler、MindSpore与DeepSeek全栈开源推理方案的生产环境部署实践。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCcDLGAjKQnTvo0cXxBXgJibWRGYurhcdULZ3hGZKbLBB7mMicVdFFRe0KTJvdtstFl24gghTJnjB9g/640?wx_fmt=png&from=appmsg)

北京大学与openEuler及MindSpore社区开发者进行生产环境部署实践

参与部署的成员包括：北京大学计算中心工程师龙汀汀（右三）、付振新（右二），北京大学本科生孙远航（右一）；openEuler sig-Long Maintainer栾建海（左四），Mindspore社区开发者邓叶鹏（左三），openEuler社区开发者李强（左二）、李佳明（左一）

### **openEuler环境部署**

组网结构推荐使用直连模式，即NPU卡通过交换机直连，确保每张卡都可以ping通其他卡。

**环境要求：**

- 两台Atlas 800I A2（8\*64G）。
- Ascend HDK Driver 24.1.0版本，Firmware 7.5.0.3.22版本。
- openEuler 24.03 LTS版本。

### **DeepSeek模型下载**

模型需在各个推理节点上进行部署，请确保模型位置在各节点上一致，可从如下地址下载。

Modelers

https://modelers.cn/models/MindSpore-Lab/DeepSeek-R1-W8A8

### **MindSpore一键部署**

一键式部署脚本推荐在单独控制的节点执行，控制节点需要可以使用SSH访问各个推理节点。

**Step1：下载oedeploy，调整oedeploy配置文件**

```
# 下载插件包并解压wget https://repo.oepkgs.net/openEuler/rpm/openEuler-24.03-LTS/contrib/oedp/plugins/mindspore-deepseek.tar.gztar zxvf mindspore-deepseek.tar.gz# 按照提示调整mindspore-deepseek目录下config.yaml# 下载并安装oedp工具wget https://repo.oepkgs.net/openEuler/rpm/openEuler-24.03-LTS/contrib/oedp/aarch64/Packages/oedp-1.0.0-2.oe2503.aarch64.rpmyum localinstall oedp-1.0.0-2.oe2503.aarch64.rpm
```

**Step2：运行一键部署脚本**

```
oedp run install  #在mindspore-deepseek目录下运行
```

### **推理服务测试验证**

服务拉起后，可使用如下curl指令进行验证

```
curl http://主节点ip:推理服务端口/v1/completions -H "Content-Type: application/json" -d '{"model": "模型路径", "prompt": "I love Beijing, because", "max_tokens": 32, "temperature": 0, "top_p": 1.0, "top_k": 1, "repetition_penalty":1.0}'
```

注意：“模型路径”请确保和插件目录下config.yaml中的model\_path值一致

返回推理结果示例：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBZPwz8y62UsGHiaR7CUwqVGk5bl6WpzCp5Hdakt2x1EK7PQZAfmUK8019nvFO45q2MyF7k2LiaPouw/640?wx_fmt=png&from=appmsg)

**测试结果：**基于DeepSeek-R1 W8A8大模型，2台Atlas 800I A2 64GB服务器，128请求吞吐率超过1198token/s，单请求吞吐率可达16.7token/s。

## 开源方案  优秀实践

### **高效部署，开箱即用**

采用MindSpore与openEuler一键部署脚本，自动完成镜像拉取、集群启动、推理服务拉取等技术。相较于传统手动部署时间通常花费2-3小时，基于当前复杂组网现状，本方案端到端部署时间约20分钟。

未来基于精简组网及内存卸载，一键部署可在单台主机上进行DeepSeek满血部署，部署效率进一步提升。

### **全栈开放，生态共建**

本方案整合了DeepSeek、openEuler、MindSpore与vLLM/RAY等社区开源组件，用户可以轻松获取源码，根据需求进行二次开发。联合社区进行重大特性开发与生态共建，企业开发成本降低。

北大科教创新卓越中心根据自身实际情况开发算力集群训推平台，并贡献反馈开源社区，取得模型部署易用性的进一步提升。

### **按需量化，动态适配**

压缩模型工具（金箍棒）针对开源大模型，并根据用户需求及硬件能力进行适当的量化定制，本方案使用8bit权重量化、SmoothQuant 8bit量化和混合量化等技术，最终以CEval精度损失2分的代价，实现了DeepSeek-R1 W8A8的大模型部署。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCcDLGAjKQnTvo0cXxBXgJibHTn6dbtC8Yc5smKmU7VQbOkoRDicVicWdZ0zEamrSZ4AzJeLXrxibib2Qg/640?wx_fmt=png&from=appmsg)
