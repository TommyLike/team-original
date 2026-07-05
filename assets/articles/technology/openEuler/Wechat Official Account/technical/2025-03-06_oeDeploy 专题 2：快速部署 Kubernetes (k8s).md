# [oeDeploy 专题 2：快速部署 Kubernetes (k8s)](https://mp.weixin.qq.com/s/uJ5P7mMYfudbXlPwJazGWg)

[OpenAtom openEuler](javascript:void%280%29;)*2025-03-06 18:00:00广东*

上一期介绍了如何使用 oeDeploy 一键部署 DeepSeek-R1 的 8B 模型，本文将继续介绍使用 oeDeploy 部署 Kubernetes（以下简称 k8s）。k8s 是最广为使用的容器管理平台，但因其操作配置的复杂性，想要快速、可靠地部署 k8s 集群，仍然是一件麻烦事。通过使用 oeDeploy，可以大幅降低难度，一键完成 k8s 集群的部署。

## 实机演示：oeDeploy 一键部署 k8s 集群

准备 3 个 2U4G 的虚拟机环境（三层网络互通），使用的 OS 版本为 OpenAtom openEuler(简称: openEuler) 24.03-LTS-SP1，目标是部署由 1 个 master、2 个 worker 构成的 k8s 集群。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAV8piaKvMaY7h8vwnHbMiapmM2V7c05CNKMrTQOnibCCShaSmFs6mYxsDIO7zzQI3V9lXrticZcQiaaibg/640?wx_fmt=png&from=appmsg)

在 master 节点上，下载并安装 oeDeploy 的命令行工具 oedp。

```
wget https://repo.oepkgs.net/openEuler/rpm/openEuler-24.03-LTS/contrib/oedp/x86_64/Packages/oedp-1.0.0-20250208.x86_64.rpm
yum install -y oedp-1.0.0-20250208.x86_64.rpm
```

下载 k8s 部署插件，并解压到本地。

```
wget https://repo.oepkgs.net/openEuler/rpm/openEuler-24.03-LTS/contrib/oedp/plugins/kubernetes-1.31.1.tar.gz
tar -zxvf kubernetes-1.31.1.tar.gz
```

使用以下命令，确认 oedp 已安装、k8s 已解压。实例结果如下：

```
oedp info -p ./kubernetes-1.31.1
```

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAV8piaKvMaY7h8vwnHbMiapmbW3lfToNC0UW2A2qRfQQ15H9hJ2bVyqBl4QZSN6UiczxPYLSlxOxEUQ/640?wx_fmt=png&from=appmsg)

根据实际情况，编写 kubernetes-1.31.1/config.yaml，修改其中的 master 和 worker 的 IP、密码、架构、版本等信息。示例文件如下：

````
all:
  children:
    masters:
      hosts:
        172.27.76.114:                    # master node IP
          ansible_host: 172.27.76.114     # master node IP
          ansible_port: 22
          ansible_user: root
          ansible_password:
          architecture: amd64             # amd64 or arm64
          oeversion: 24.03-LTS            # 22.03-LTS or 24.03-LTS
    workers:
      hosts:
        172.27.70.60:                     # worker node IP
          ansible_host: 172.27.70.60      # worker node IP
          ansible_port: 22
          ansible_user: root
          ansible_password:
          architecture: amd64
          oeversion: 24.03-LTS
        172.27.72.90:
          ansible_host: 172.27.72.90
          ansible_port: 22
          ansible_user: root
          ansible_password:
          architecture: amd64
          oeversion: 24.03-LTS
  vars:
    init_cluster_force: "true"
    service_cidr: 10.96.0.0/16
    pod_cidr: 10.244.0.0/16
    certs_expired: 3650
    has_deployed_containerd: "false"
    ansible_ssh_common_args: "-o StrictHostKeyChecking=no"
```
````

使用以下命令，一键触发 k8s 自动化部署及配置。

```
oedp run install -p ./kubernetes-1.31.1
```

> ★
> 
> -p 参数表示解压后的文件目录

在部署完成后的 master 节点上，执行 kubectl 相关命令，验证部署结果。

```
kubectl get pod -A
```

## 效果展示

部署中：

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mAV8piaKvMaY7h8vwnHbMiapmQPBpGS3xMwblUnpxcEy0IboZ6H5R9hZpPuichlLWeCB4ZzJxKMOaQjA/640?wx_fmt=gif&from=appmsg)

部署完成后，查询 pod 状态：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mAV8piaKvMaY7h8vwnHbMiapmoic1TjUT6628UGaDp4hjm5BibrnuyFgtLzmGpiadQ6nNtwVQWgAqOHIaw/640?wx_fmt=png&from=appmsg)

## 结语

通过以上步骤，可以使用 oeDeploy 高效、便捷地完成 k8s 部署。当前 oeDeploy 已经支持包括 DeepSeek-R1 在内的部分主流插件，并在持续集成中。下一期将介绍如何在 oeDeploy 上，发布开发者自己的插件。
