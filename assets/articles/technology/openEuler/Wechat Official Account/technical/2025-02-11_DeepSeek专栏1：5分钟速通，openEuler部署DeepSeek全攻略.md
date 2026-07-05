# [DeepSeek专栏1：5分钟速通，openEuler部署DeepSeek全攻略](https://mp.weixin.qq.com/s/YTt0MWxDCUuVwKY3fRlMRA)

[OpenAtom openEuler](javascript:void%280%29;)*2025-02-11 18:35:00广东*

DeepSeek R1 发布之后，受到了全球开发者的关注。本文介绍了如何在 OpenAtom openEuler（简称"openEuler"） 中部署 DeepSeek。对 openEuler AI 相关能力的感兴趣的开发者可以在微信公众号后台联系 openEuler 小助手，回复`sig-intelligence`,进入技术交流群。

## 系统环境硬件要求

模型CPU内存存储DeepSeek-R1-Distill-Qwen-1.5B至少 4 核，推荐 8 核16GB 以上60GB 以上DeepSeek-R1-Distill-Qwen-7B至少 8 核，推荐 16 核16GB 以上60GB 以上DeepSeek-R1-Distill-Llama-8B至少 16 核，推荐 32 核16GB 以上60GB 以上

## 安装方式一：自动部署

以下部署流程是在 openEuler 24.03 LTS 版本上使用 Ollama 推理框架部署 DeepSeek-R1-Distill-Qwen-7B 的流程。注意：该方式可能会存在下载速度缓慢的问题，后面提供了手动下载部署安装的方式，便于在网络环境不好的情况下进行部署安装。

- Ollama 下载安装采用 Ollama 官网下载方式：

```
curl -fsSL https://ollama.com/install.sh | sh
```

- Ollama 部署 DeepSeek-R1-Distill-Qwen-7B

```
ollama run deepseek-r1:7b
```

至此，DeepSeek 部署完成，可以通过命令行来进行交互提问。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBP8BEdNXjslicOgVgYGsEsg2ibBc9YOOJ5pqkicptBicn7gwdpE8aPJmChoAX9sf1qZE4VRUtWWTMobw/640?wx_fmt=png&from=appmsg)

## 安装方式二：手动部署

在国内使用官网下载 Ollama 会很慢，下面提供了 Ollama 的手动安装方式。注意，本文中提供了 github 的下载链接，下载链接用户可以自行选择替换。

- 对于 arm 架构的计算机，采用如下链接进行下载

```
wget https://github.com/ollama/ollama/releases/download/v0.5.7/ollama-linux-arm64.tgz
tar -xzvf ollama-linux-arm64.tgz -C /usr/
```

- 对于 x86 架构的计算机，采用如下链接进行下载

```
wget https://github.com/ollama/ollama/releases/download/v0.5.7/ollama-linux-amd64.tgz
tar -xzvf ollama-linux-amd64.tgz -C /usr/
```

使用 Ollama 官网下载模型同样会出现下载缓慢的问题，这里提供了手动下载 DeepSeek 大模型来进行手动部署的方式。需要注意的是，Ollama 当前只支持 gguf 格式的模型。

大模型下载链接，可根据自己机器的硬件配置来选择模型：

模型下载链接DeepSeek-R1-Distill-Qwen-1.5Bhttps://www.modelscope.cn/models/unsloth/DeepSeek-R1-Distill-Qwen-1.5B-GGUF/resolve/master/DeepSeek-R1-Distill-Qwen-1.5B-Q4\_K\_M.ggufDeepSeek-R1-Distill-Qwen-7Bhttps://www.modelscope.cn/models/unsloth/DeepSeek-R1-Distill-Qwen-7B-GGUF/resolve/master/DeepSeek-R1-Distill-Qwen-7B-Q4\_K\_M.ggufDeepSeek-R1-Distill-Llama-8Bhttps://www.modelscope.cn/models/unsloth/DeepSeek-R1-Distill-Llama-8B-GGUF/resolve/master/DeepSeek-R1-Distill-Llama-8B-Q4\_K\_M.gguf

```
wget https://www.modelscope.cn/models/unsloth/DeepSeek-R1-Distill-Qwen-7B-GGUF/resolve/master/DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf
```

创建并配置名为 ollama.service 的 systemd 服务，将下述命令完整复制到命令行执行。

```
cat <<EOF | tee /etc/systemd/system/ollama.service >/dev/null
[Unit]
Description=Ollama Service
After=network-online.target
[Service]
ExecStart=/usr/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3
Environment="PATH=\$PATH"
[Install]
WantedBy=default.target
EOF

systemctl daemon-reload
systemctl enable ollama --now
```

编写 Modelfile，配置大模型的相关参数

```
cat <<EOF | tee ./Modelfile >/dev/null
FROM ./DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf
TEMPLATE """{{- if .System }}{{ .System }}{{ end }}
{{- range $i, $_ := .Messages }}
{{- $last := eq (len (slice $.Messages $i)) 1}}
{{- if eq .Role "user" }}< | User | >{{ .Content }}
{{- else if eq .Role "assistant" }}< | Assistant | >{{ .Content }}{{- if not $last }}< | end_of_sentence | >{{- end }}
{{- end }}
{{- if and $last (ne .Role "assistant") }}< | Assistant | >{{- end }}
{{- end }}"""
SYSTEM ""
PARAMETER temperature 0.7
PARAMETER top_p 0.7
PARAMETER top_k 30
PARAMETER num_ctx 4096
EOF
```

创建一个名称为`deepseek-r1:7b`的模型实例，模型实例名称可以自定义。

```
ollama create -f ./Modelfile deepseek-r1:7b
```

使用 `ollama` 命令运行创建的模型实例

```
ollama run deepseek-r1:7b
```

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBP8BEdNXjslicOgVgYGsEsgcVEJLPtTLUuJPyCFwSCNlTthDV8qpvBD0Bs3tzAkNIuN6gfqTicPWRA/640?wx_fmt=png&from=appmsg)
