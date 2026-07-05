# [手把手带你玩转openEuler ｜ 如何本地部署大模型](https://mp.weixin.qq.com/s/TicGKjOIRuoQmkpAilx4wA)

[OpenAtom openEuler](javascript:void%280%29;)*2023-10-07 20:00:00*

近期，**openEuler A-Tune SIG在openEuler 23.09版本引入llama.cpp&chatglm-cpp两款应用，以支持用户在本地部署和使用免费的开源大语言模型，无需联网也能使用！**

大语言模型（Large Language Model, LLM）是一种人工智能模型，旨在理解和生成人类语言。它们在大量的文本数据上进行训练，可以执行广泛的任务，包括文本总结、翻译、情感分析等等。**openEuler通过集成llama.cpp&chatglm-cpp两款应用，降低了用户使用大模型的门槛，为Build openEuler with AI, for AI, by AI打下坚实基础。**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYGBPG2oy3U6CbbItwyhu0jTIZJ7vWHyXoHYTCib5HkcOUE5E1ENnBUL9YqlgP1m2cS7ibSbyiaiasCZw/640?wx_fmt=png)

openEuler技术委员会主席胡欣慰在OSSUMMIT 2023中的演讲

**应用简介**

1\. llama.cpp是基于C/C++实现的英文大模型接口，支持LLaMa/LLaMa2/Vicuna等开源模型的部署；

2\. chatglm-cpp是基于C/C++实现的中文大模型接口，支持ChatGlm-6B/ChatGlm2-6B/Baichuan-13B等开源模型的部署。

**应用特性**

这两款应用具有以下特性:

1\. 基于ggml的C/C++实现；

2\. 通过int4/int8等多种量化方式，以及优化KV缓存和并行计算等手段实现高效的CPU推理；

3\. 无需 GPU，可只用 CPU 运行。

**使用指南**

用户可参照下方的使用指南，在openEuler 23.09版本上进行大模型尝鲜体验。

1. llama.cpp使用指南如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYGBPG2oy3U6CbbItwyhu0jkexRicAksN8aaCsCkNFtFR46auKfAIFgZ0rwBsdoY4o6a6GqcGhXZGA/640?wx_fmt=png)

llama.cpp使用指南

正常启动界面如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYGBPG2oy3U6CbbItwyhu0jcxr4yia3BjHk6icrAtQcln9TFmQtqjRWdkOsrdIN5g2us05a1FyT8LpQ/640?wx_fmt=png)

 LLaMa启动界面

2\.   chatlm-cpp使用指南如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYGBPG2oy3U6CbbItwyhu0jo0PmVm9G7SEGLTmwM6RFic7ib3b5o8Tq5y8ZurWQJofu76cDVODqeSRw/640?wx_fmt=png)

chatlm-cpp使用指南

正常启动界面如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYGBPG2oy3U6CbbItwyhu0jLBLL6EpXZdNib4HY2UC6wibBB75eLWW5EibohFcrhmZaPD1lGYicDrkEuQ/640?wx_fmt=png)

 ChatGLM启动界面

**规格说明**

这两款应用都可以支持在CPU级别的机器上进行大模型的部署和推理，但是模型推理速度对硬件仍有一定的要求，硬件配置过低可能会导致推理速度过慢，降低使用效率。

以下是模型推理速度的测试数据表格，可作为不同机器配置下推理速度的参考。

表格中Q4\_0，Q4\_1，Q5\_0，Q5\_1代表模型的量化精度；ms/token代表模型的推理速度，含义为每个token推理耗费的毫秒数，该值越小推理速度越快；

表1 测试表格

表2 测试表格

欢迎用户下载体验，玩转开源大模型，近距离感受AI带来的技术革新！

感谢LLaMa、ChatGLM等提供开源大模型等相关技术，感谢开源项目llama.cpp&chatglm-cpp提供模型轻量化部署等相关技术。

**免责声明：**  
目前openEuler 23.09版本仅是提供相应机制让开发者能运行对应开源大模型，具体模型的商用请开发者参考相关开源模型的LICENSE要求。
