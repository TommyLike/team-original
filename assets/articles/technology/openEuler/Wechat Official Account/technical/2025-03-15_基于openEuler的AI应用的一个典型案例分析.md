# [基于openEuler的AI应用的一个典型案例分析](https://mp.weixin.qq.com/s/95Rf1CTFFyph55XN0Hi7yw)

[OpenAtom openEuler](javascript:void%280%29;)*2025-03-15 18:24:00广东*

01

**背景**

随着LLM爆发式应用，如何降低LLM模型启动和运行门槛也被很多项目作为发力点进行能力构筑，而容器的预构建+开箱即用的特点和这一需求非常匹配。将特定平台（如：Linux-aarch64）下所需要的AI软件栈和AI应用预先构建、打包到容器镜像中，只需在工作环境中拉起容器即完成AI应用部署和启动。

OpenAtom openEuler（简称 openEuler）在具有高安全性，高度可定制性的同时已支持 ARM、x86、RISC-V 等全部主流通用计算架构，兼容 NVIDIA、Ascend 等主流算力平台的软件栈。以 openEuler 为基础镜像，安装相应硬件平台的 SDK，如 Ascend 平台的 CANN 或 NVIDIA 的 CUDA 软件，有两个大优势：

- 可以快速搭建C/C++ AI服务的编译环境，从而快速构建AI服务可执行包
- 可以直接作为基础镜容器像用来构建AI服务镜像

openEuler + Ascend CANN系列官方容器镜像已公开可从多渠道获取，如：

DockerHub: https://hub.docker.com/r/ascendai/cann

Quay.io: https://quay.io/repository/ascend/cann

AscendHub: https://www.hiascend.com/developer/ascendhub/detail/17da20d1c2b6493cb38765adeba85884

Ramalama是一款用户快速本地部署AI模型服务和模型管理的一款工具，接下来以Ramalama为例详细介绍：Ramalama是如何利用openEuler+CANN容器镜像支持“使用Ascend NPU加速AI模型服务”。

Ramalama 项目链接:

https://github.com/containers/ramalama/

02

**示例**

**2.1 operEuler+llama.cpp/CANN软件栈**

以openEuler为基座、使用Ascend NPU加速以llama.cpp做为推理引擎的Ramalama模型服务的软件栈，如图1。详细：

1. 最底层是Host OS和Host OS之上的Docker、Ascend Driver
2. 再往上是在openEuler OS容器镜像之上安装了 CANN和Python后得到的应用构建和运行所需要的SDK镜像，如：8.0.0-\*soc\_version\*-openeuler22.03-py3.10，这里CANN的版本为8.0.0，Python的版本为3.10。
3. 在openEuler SDK镜像中使用构建工具完成AI应用构建：llama.cpp.cann二进制包的构建。（也支持跨平台构建）
4. 将3中构建llama.cpp.cann二进制打包到openEuler SDK镜像中形成ramalama\_lama.cpp\_cann AI应用容器镜像，如：quay.io/ramalama/cann:latest。

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mClS04vvIiazhFcKAdpH57H84L3URoERo8vnWxkl3nUUicBExdJZbpOTBvGm8cFVsxhpJRuFvC1MCCw/640?wx_fmt=jpeg&from=appmsg)

图1 ramalama.llama.cpp.cann AI模型推理服务软件栈

其中，Ramalama支持使用Ascend NPU进行推理加速PR: https://github.com/containers/ramalama/pull/911

**2.2 openEuler用户如何使用Ramalama进行模型推理服务**

**2.2.1构建应用镜像**

quay.io/ramalama/cann镜像中支持的是Ascend Atlas A2系列的产品，\*\*如果不满足需求\*\*，或者ramalama还未发布quay.io/ramalama/cann镜像到quay.io/ramalama，则手动通过以下步骤进行构建：

**Fork和Clone RamaLama**

```
$ git clone git@github.com:<you>/ramalama$ cd ./ramalama/
```

**使用Make构建**

```
make build IMAGE=cann
```

构建成功日志如下：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mClS04vvIiazhFcKAdpH57H8z0vk6MrSIUun7OG0aSTQMLCRBELKTSbS7LAZI91PC1RF0IJC0LQXiaw/640?wx_fmt=png&from=appmsg)

图2 ramalama/cann容器镜像构建成功示例

备注：如国内无法访问quay.io，则可以从华为昇腾镜像仓库：https://www.hiascend.com/developer/ascendhub/detail/17da20d1c2b6493cb38765adeba85884  下载8.0.0-\*soc\_version\*-openeuler22.03-py3.10镜像，之后修改镜像名与ramalama/container-images/cann/Containerfile中的base镜像名相同，或根据Dockerdocs指导配置代理：https://docs.docker.com/engine/daemon/proxy/。

**使用Make进行安装**

```
make install
```

**2.2.2 使用**

**Host OS环境准备**

根据Ascend官网完成Ascend驱动和固件的安装，参考文档 安装NPU驱动固件-软件安装-CANN社区版8.0.0.alpha003开发文档-昇腾社区：

https://www.hiascend.com/document/detail/zh/CANNCommunityEdition/800alpha003/softwareinst/instg/instg\_0004.html?Mode=PmIns&OS=Ubuntu&Software=cannNNAE。

**启动**

启动ramalama/cann容器并在容器中运行模型，如：ollama://smollm:135m，命令如下：

```
ramalama --image quay.io/ramalama/cann:latest serve -d -p 8080 --device=/dev/davinci0 -name ollama://smollm:135m
```

启动后使用docker ps/podman ps可以看到容器已在运行：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mClS04vvIiazhFcKAdpH57H8lNxk0cw3KrVmhx71OH7uW2QaCzLxoicFNp3GmwCmXmzE82mER2TPmzA/640?wx_fmt=png&from=appmsg)

图3 Ramalama容器启动状态图

**验证**

进入容器，验证llama-server是否运行在NPU上，命令：

```
npu-smi info
```

正常时输出如下：

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mClS04vvIiazhFcKAdpH57H836LSAnBymMBn9oKiclo2hnAVU6Cro94ZzJa0gyNcbt15m9U5hKiaUX5g/640?wx_fmt=jpeg&from=appmsg)

图4 NPU加速生效图

继续在容器测试AI模型推理访问，使用curl进行访问：

```
curl http://0.0.0.0:8080/v1/chat/completions \  -H "Content-Type: application/json" \  -d '{     "model": "ollama://smollm:135m",     "messages": [{"role": "user", "content": "Say this is a test!"}],     "temperature": 0.7   }'
```

交互示例如下：

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mClS04vvIiazhFcKAdpH57H8nOqP5jr4QDKAU8bbeh431Vx4IB9q7ILMMmYczmPsIBJvlSE0HV4m5g/640?wx_fmt=jpeg&from=appmsg)

图5 Ramalama server推理交互

其他使用指导请参考Ramalama Readme：https://github.com/containers/ramalama/blob/main/README.md

以上便是本次的分享，欢迎感兴趣的朋友体验。
