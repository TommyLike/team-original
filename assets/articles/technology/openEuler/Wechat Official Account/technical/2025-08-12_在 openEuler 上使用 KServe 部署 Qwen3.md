# [在 openEuler 上使用 KServe 部署 Qwen3](https://mp.weixin.qq.com/s/YxqvHei6aNA_FGCfUiEJTw)

[OpenAtom openEuler](javascript:void%280%29;)*2025-08-12 18:00:00新加坡*

KServe 是一种基于 Kubernetes 的模型服务（Model Serving）平台，能够简化机器学习模型在生产环境中的部署和管理。通过标准化的接口和 CRD（自定义资源定义），KServe 支持多种主流推理后端（如 TensorFlow Serving、TorchServe、Triton Inference Server 及 Hugging Face Server），适用于各类深度学习模型的在线推理服务。

本文将演示如何在 OpenAtom openEuler（简称“openEuler” 或“开源欧拉”）操作系统上部署并使用 KServe，进行 Hugging Face Qwen3 模型的文本生成任务。

**01**

场景说明

在本示例中，我们将演示如何通过部署 Hugging Face Serving 运行时的 InferenceService，将 Hugging Face 上的 Qwen3 模型用于文本生成任务。

KServe 的 Hugging Face 运行时默认采用 vLLM 作为后端来服务大语言模型（LLM），相比 Hugging Face 官方 API 能够实现更快的首 token 响应时间（TTFT）和更高的 token 生成吞吐量。

**02**

操作系统版本

本指南以 openEuler 24.03 LTS SP2 为例，其他新版本 openEuler 亦可参考。请确保系统已更新到最新补丁，并具有 sudo 权限。

**03**

基础依赖安装

- 安装必要的系统工具和依赖：

<!--THE END-->

```
yum update -yyum install -y wget curl tar iptables
```

- 安装 Docker

<!--THE END-->

```
curl -sL https://raw.githubusercontent.com/cnrancher/euler-packer/refs/heads/main/scripts/others/install-docker.sh | bash-
```

- 安装 Kind

<!--THE END-->

```
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64chmod+x./kindmv./kind/usr/local/bin/kind
```

- 安装 Kubenetes CLI

<!--THE END-->

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

- 安装 Helm

<!--THE END-->

```
wget https://get.helm.sh/helm-v3.18.4-linux-amd64.tar.gztar -zxvf helm-v3.18.4-linux-amd64.tar.gzmv linux-amd64/helm /usr/local/bin/helm
```

**04**

安装 KServe

- 创建 Kubernetes 集群

<!--THE END-->

```
kind create cluster
```

- 切换 kubectl 上下文

<!--THE END-->

```
kubectl config use-context kind-kind
```

- 安装 KServe 及相关依赖

<!--THE END-->

```
curl -sL "https://gitee.com/openeuler/openeuler-docker-images/raw/master/AI/kserve/controller/doc/quick_install.sh" | bash -s -- -r
```

**05**

部署 Qwen3 InferenceService

- 创建 Hugging Face Token 密文对象

<!--THE END-->

```
   kubectl apply -f - <<EOF      apiVersion: v1      kind:      Secret      metadata:            name: hf-secret      type:      Opaque          stringData:            HF_TOKEN: <token>      EOF
```

- 创建 Hugging Face Qwen3 服务的 CRD 配置

<!--THE END-->

```
   kubectl apply -f - <<EOF   apiVersion: serving.kserve.io/v1beta1   kind: InferenceService   metadata:     name: huggingface--qwen3   spec:     predictor:       model:         modelFormat:           name: huggingface-         args:           - --model_name=qwen3           - --model_id=Qwen/Qwen3-8B           - --max-model-len=16384         env:           - name: HF_TOKEN             valueFrom:               secretKeyRef:                 name: hf-secret                 key: HF_TOKEN                 optional: false         resources:           limits:             cpu: "6"             memory: 24Gi           requests:             cpu: "6"             memory: 24Gi   EOF
```

- 查看服务状态

<!--THE END-->

```
kubectl get inferenceserviceskubectl describe inferenceservice huggingface--qwen3
```

**06**

验证推理服务

- 进入 kind-control-plane 容器

<!--THE END-->

```
docker exec -it kind-control-plane bash
```

- 获取推理服务地址及端口

<!--THE END-->

```
CLUSTER_IP=$(kubectl -n default get svc huggingface--qwen3-predictor -o jsonpath='{.spec.clusterIP}')CLUSTER_PORT=$(kubectl -n default get svc qwen3-predictor-default -o jsonpath='{.spec.ports[0].port}')SERVICE_HOSTNAME=$(kubectl get inferenceservice huggingface--qwen3 -o jsonpath='{.status.url}' | cut -d "/" -f 3)
```

- 访问推理服务

<!--THE END-->

```
curl -v http://${CLUSTER_IP}:${CLUSTER_PORT}/openai/v1/completions \-H "content-type: application/json" -H "Host: ${SERVICE_HOSTNAME}" \-d '{"model": "qwen3", "prompt": "Write a poem about colors", "stream":false, "max_tokens": 30}'
```

预期输出：

```
*   Trying 10.96.149.169:80...* Connected to 10.96.149.169 (10.96.149.169) port 80 (#0)> POST /openai/v1/completions HTTP/1.1> Host: huggingface--qwen3-default.example.com> User-Agent: curl/7.88.1> Accept: */*> content-type: application/json> Content-Length: 91>< HTTP/1.1 200 OK< date: Tue, 12 Aug 2025 05:36:03 GMT< server: uvicorn< content-length: 474< content-type: application/json<* Connection #0 to host 10.96.149.169 left intact{"id":"cmpl-a2ead2a3246f47fe85c48b7aadbd30d5","object":"text_completion","created":1754976963,"model":"qwen3","choices":[{"index":0,"text":" in the style of a haiku, with each line containing a different color and a different season, and each line also incorporating a different sense. The","logprobs":null,"finish_reason":"length","stop_reason":null,"prompt_logprobs":null}],"usage":{"prompt_tokens":5,"total_tokens":35,"completion_tokens":30,"prompt_tokens_details":null}}
```
