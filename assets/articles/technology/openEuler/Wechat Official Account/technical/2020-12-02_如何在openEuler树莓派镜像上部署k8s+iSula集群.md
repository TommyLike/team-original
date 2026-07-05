# [如何在openEuler树莓派镜像上部署k8s+iSula集群](https://mp.weixin.qq.com/s/ltBTaQrCDhpBIh0A0aQxQA)

*bolin\_lee*[OpenAtom openEuler](javascript:void%280%29;)*2020-12-02 17:00:00*

树莓派、openEuler、k8s、iSula，这些新奇的玩意碰撞在一起会产生什么样的化学反应呢？

在11.14号的开源软件供应链2020峰会上，笔者在openEuler展台展示了如何在树莓派上用k8s部署容器集群，树莓派操作系统为openEuler社区在9月份发布的20.09版本，容器为iSula；下面就带大家使用二进制包在树莓派上完成这些有趣的尝试。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDks1Fic3jrjBB93Kv2kDtaTFvk5Lvo3HgMH7mRy6KzEokiaoWSOVqsTwZw/640?wx_fmt=jpeg)

01

集群规划

环境建议至少两台Master节点，两台Node节点；Etcd数据库可直接部署在Master或Node节点，机器比较充足的话，可以部署在单独的节点上。

本次我们要部署的集群是多Master高可靠性集群，包含3个Master，3个Node；在这6个节点中部署3个etcd数据库节点。集群拓扑图如下所示：

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDk7367GIgA5kbdYNEVzEQtvMf1fsia1JN7DJexDeKoDcCFBPGEtfxeqXQ/640?wx_fmt=jpeg)

集群规划如下：

角色

IP

主机名

组件

Master1

192.168.1.1

k8s-master1

kube-apiserver

kube-controller-manager

kube-scheduler

Master2

192.168.1.2

k8s-master2

kube-apiserver

kube-controller-manager

kube-scheduler

etcd

Master3

192.168.1.3

k8s-master3

kube-apiserver

kube-controller-manager

kube-scheduler

etcd

Node1

192.168.1.4

k8s-node1

kubelet

kube-proxy

etcd

isulad

Node2

192.168.1.5

k8s-node2

kubelet

kube-proxy

isulad

Node3

192.168.1.6

k8s-node3

kubelet

kube-proxy

isulad

02

环境准备

接下来将基于二进制包的方式，手动部署每个组件，来组成k8s高可用集群；首先是每台树莓派的操作系统镜像安装及配置初始化。

**2.1**

刷写树莓派镜像

我们需要给每个树莓派安装适合树莓派平台的openEuler镜像，镜像获取及相关操作可以参考openEuler社区里的raspberrypi sig组指引：

https://gitee.com/openeuler/raspberrypi

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkWyaVRunl21JnUf3dMbQWkib8M5a0grqEc6EgBLc5SztJFKicsiasd4xLA/640?wx_fmt=jpeg)

**2.2**

环境初始化

**&lt;1&gt; 关闭防火墙**

\# systemctl stop firewalld

\# systemctl disable firewalld

**&lt;2&gt; 关闭selinux**

//临时生效

\# setenforce 0

**&lt;3&gt; 关闭swap**

//临时关闭

\# swapoff -a

**&lt;4&gt; 添加host信息**

\# vi /etc/hosts

192.168.1.1 k8s-master1

192.168.1.2 k8s-master2

192.168.1.3 k8s-master3

192.168.1.4 k8s-node1

192.168.1.5 k8s-node2

192.168.1.6 k8s-node3

更改本节点主机名，拿k8s-master1为例，其他节点类似：

\# vi /etc/hostname

k8s-master1

**&lt;5&gt; 同步系统时间**

各个节点之间需保持时间一致，因为自签证书是根据时间校验证书有效性，如果时间不一致，将校验不通过。

联网情况可使用如下命令（树莓派上ntpdate需要安装）

\# ntpdate time.windows.com

如果不能联外网可使用 date 命令设置时间

\# date -s 2020-11-18

\# date -s 16:20:25

03

部署Etcd集群

**3.1**

自签证书

k8s集群安装配置过程中，会使用各种证书，目的是为了加强集群安全性。k8s提供了基于 CA签名的双向数字证书认证方式和简单的基于http base或token的认证方式，其中CA 证书方式的安全性最高。每个k8s集群都有一个集群根证书颁发机构（CA），集群中的组件通常使用CA来验证API server的证书，由API服务器验证kubelet客户端证书等。

证书生成操作可以在master节点上执行，证书只需要创建一次，以后在向集群中添加新节点时只要将证书拷贝到新节点上，并做一定的配置即可。我们计划在k8s-master2，k8s-master3及k8s-node1上部署etcd，下面就在 k8s-master2节点上来创建证书。

**&lt;1&gt; k8s证书**

如下是k8s各个组件需要使用的证书：

组件

证书

etcd

ca.pem etcd.pem etcd-key.pem

kube-apiserver

ca.pem kubernetes.pem kubernetes-key.pem

kubelet

ca.pem ca-key.pem

kube-proxy

ca.pem kube-proxy.pem kube-proxy-key.pem

**&lt;2&gt; cfssl工具下载**

我们通过cfssl工具来生成证书，通过以下链接下载arm平台的cfssl，目前只有arm32的工具，但是也可以用在arm64平台上。

\# curl -L https://pkg.cfssl.org/R1.2/cfssl\_linux-arm -o /usr/bin/cfssl

\# curl -L https://pkg.cfssl.org/R1.2/cfssljson\_linux-arm -o /usr/bin/cfssljson

\# curl -L https://pkg.cfssl.org/R1.2/cfssl-certinfo\_linux-arm -o /usr/bin/cfssl-certinfo

\# chmod +x /usr/bin/cfssl*

**3.2**

自签Etcd SSL证书

首先为etcd签发一套SSL证书，通过如下命令创建几个目录，**/k8s/etcd/ssl** 用于存放etcd自签证书，**/k8s/etcd/cfg**用于存放etcd配置文件，**/k8s/etcd/bin**用于存放 etcd执行程序。

\# mkdir -p /k8s/etcd/{ssl,cfg,bin}

\# cd /k8s/etcd/ssl

**&lt;1&gt; 创建CA配置文件：ca-config.json**

执行如下命令创建ca-config.json

\# cat &gt; ca-config.json &lt;&lt;EOF

{

  "signing": {

    "default": {

      "expiry": "87600h"

    },

    "profiles": {

      "etcd": {

        "usages": [

            "signing",

            "key encipherment",

            "server auth",

            "client auth"

        ],

        "expiry": "87600h"

      }

    }

  }

}

EOF

  说明：

signing：表示该证书可用于签名其它证书；生成的ca.pem证书中CA=TRUE；

profiles：可以定义多个profiles，分别指定不同的过期时间、使用场景等参数；后续在签名证书时使用某个profile；

expiry：证书过期时间；

server auth：表示client可以用该CA对server提供的证书进行验证；

client auth：表示server可以用该CA对client提供的证书进行验证。

**&lt;2&gt; 创建CA证书签名请求文件：ca-csr.json**

执行如下命令创建ca-csr.json：

\# cat &gt; ca-csr.json &lt;&lt;EOF

{

  "CN": "etcd",

  "key": {

    "algo": "rsa",

    "size": 2048

  },

  "names": [

    {

      "C": "CN",

      "ST": "Shanghai",

      "L": "Shanghai",

      "O": "etcd",

      "OU": "System"

    }

  ],

    "ca": {

       "expiry": "87600h"

    }

}

EOF

  说明：

CN：Common Name，kube-apiserver从证书中提取该字段作为请求的用户名 (User Name)；浏览器使用该字段验证网站是否合法；

key：加密算法；

C：国家；

ST：地区；

L：城市；

O：组织，kube-apiserver从证书中提取该字段作为请求用户所属的组 (Group)；

OU：组织单位。

**&lt;3&gt; 生成CA证书和私钥**

\# cfssl gencert -initca ca-csr.json | cfssljson -bare ca

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkV0gejJr4Hpy3Xia1CECNyIYLhickVMsAAEKbeFju2duLfdnlOaNibmGew/640?wx_fmt=jpeg)

  说明：

ca-key.pem：CA私钥；

ca.pem：CA数字证书。

**&lt;4&gt; 创建证书签名请求文件：etcd-csr.json**

执行如下命令创建 etcd-csr.json：

\# cat &gt; etcd-csr.json &lt;&lt;EOF

{

    "CN": "etcd",

    "hosts": [

      "192.168.1.2",

      "192.168.1.3",

      "192.168.1.4"

    ],

    "key": {

        "algo": "rsa",

        "size": 2048

    },

    "names": [

        {

            "C": "CN",

            "ST": "BeiJing",

            "L": "BeiJing",

            "O": "etcd",

            "OU": "System"

        }

    ]

}

EOF

  说明：

hosts：需要指定授权使用该证书的IP或域名列表，这里配置所有etcd的IP地址；

key：加密算法及长度。

**&lt;5&gt; 为etcd生成证书和私钥**

\# cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=etcd etcd-csr.json –hostname=192.168.1.2,192.168.1.3,192.168.1.4 | cfssljson -bare etcd

▲滑动查看更多

  说明：

-ca：指定CA数字证书；

-ca-key：指定CA私钥；

-config：CA配置文件；

-profile：指定环境；

-hostname：指定证书所属的hostname或IP；

-bare：指定证书名前缀。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkdpslodVYW1RnEKiarjJNvTrsbHicqNoQwkzWRD9WibxuHbibVgdtMCKbQQ/640?wx_fmt=jpeg)

  说明：

etcd-key.pem：etcd私钥；

etcd.pem：etcd数字证书。

证书生成完成，后面部署Etcd时主要会用到如下几个证书：

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkzpLVMvrS6ULkmQuibGmK6f9hNyMG4h4njiaqK0ic8xPGxicDm45nHlHBgA/640?wx_fmt=jpeg)

**3.3**

Etcd数据库集群部署

etcd集群采用一主多从架构模式部署，集群通过选举产生leader，因此需要部署奇数个节点（3/5/7）才能正常工作；etcd使用raft一致性算法保证每个节点的一致性。

**&lt;1&gt; 下载etcd**

从 github上下载合适版本的 etcd

\# cd /k8s/etcd

\# wget https://github.com/etcd-io/etcd/releases/download/v3.3.25/etcd-v3.3.25-linux-arm64.tar.gz

\# tar -zxf etcd-v3.3.25-linux-arm64.tar.gz

\# cp etcd-v3.3.25-linux-arm64/{etcd,etcdctl} /k8s/etcd/bin

**&lt;2&gt; 创建 etcd 配置文件：etcd.conf**

\# cfssl gencert -ca=ca.pem -ca-k

\# cat &gt; /k8s/etcd/cfg/etcd.conf &lt;&lt;EOF 

\# \[member]

ETCD\_NAME=etcd-1

ETCD\_DATA\_DIR=/k8s/data/

ETCD\_LISTEN\_PEER\_URLS=https://192.168.1.2:2380

ETCD\_LISTEN\_CLIENT\_URLS=https://192.168.1.2:2379,http://127.0.0.1:2379

\# \[cluster]

ETCD\_INITIAL\_ADVERTISE\_PEER\_URLS=https://192.168.1.2:2380

ETCD\_ADVERTISE\_CLIENT\_URLS=https://192.168.1.2:2379

ETCD\_INITIAL\_CLUSTER=etcd-1=https://192.168.1.2:2380,etcd-2=https://192.168.1.3:2380,etcd-3=https://192.168.1.4:2380

ETCD\_INITIAL\_CLUSTER\_TOKEN=etcd-cluster

ETCD\_INITIAL\_CLUSTER\_STATE=new

ETCD\_UNSUPPORTED\_ARCH=arm64

\# \[security]

ETCD\_CERT\_FILE=/k8s/etcd/ssl/etcd.pem

ETCD\_KEY\_FILE=/k8s/etcd/ssl/etcd-key.pem

ETCD\_TRUSTED\_CA\_FILE=/k8s/etcd/ssl/ca.pem

ETCD\_PEER\_CERT\_FILE=/k8s/etcd/ssl/etcd.pem

ETCD\_PEER\_KEY\_FILE=/k8s/etcd/ssl/etcd-key.pem

ETCD\_PEER\_TRUSTED\_CA\_FILE=/k8s/etcd/ssl/ca.pem

EOF

▲滑动查看更多

  说明：

ETCD\_NAME：etcd在集群中的唯一名称

ETCD\_DATA\_DIR：etcd数据存放目录

ETCD\_LISTEN\_PEER\_URLS：etcd集群间通讯的地址，设置为本机IP

ETCD\_LISTEN\_CLIENT\_URLS：客户端访问的地址，设置为本机IP

ETCD\_INITIAL\_ADVERTISE\_PEER\_URLS：集群内部通讯地址，设置为本机IP

ETCD\_ADVERTISE\_CLIENT\_URLS：客户端通告地址，设置为本机IP

ETCD\_INITIAL\_CLUSTER：集群节点地址，以 key=value 的形式添加各个 etcd 的地址

ETCD\_INITIAL\_CLUSTER\_TOKEN：集群令牌，用于集群间做简单的认证

ETCD\_INITIAL\_CLUSTER\_STATE：集群状态

ETCD\_CERT\_FILE：客户端 etcd 数字证书路径

ETCD\_KEY\_FILE：客户端 etcd 私钥路径

ETCD\_TRUSTED\_CA\_FILE：客户端 CA 证书路径

ETCD\_PEER\_CERT\_FILE：集群间通讯etcd数字证书路径

ETCD\_PEER\_KEY\_FILE：集群间通讯etcd私钥路径

ETCD\_PEER\_TRUSTED\_CA\_FILE：集群间通讯CA证书路径

**&lt;3&gt; 创建etcd服务：etcd.service**

通过EnvironmentFile指定etcd.conf作为环境配置文件

\# cat &gt; /k8s/etcd/etcd.service &lt;&lt;EOF

\[Unit]

Description=Etcd Server

After=network.target

After=network-online.target

Wants=network-online.target

\[Service]

Type=notify

EnvironmentFile=/k8s/etcd/cfg/etcd.conf

ExecStart=/k8s/etcd/bin/etcd

Restart=on-failure

LimitNOFILE=65536

\[Install]

WantedBy=multi-user.target

EOF

etcd可以通过命令行选项和环境变量配置启动；命令行参数选项与环境变量命名的关系是命令行选项的小写字母转换成环境变量的大写字母时加一个“ETCD\_”前缀，如：--name对应ETCD\_NAME。

（注意：如果配置文件etcd.conf中已经定义了参数变量，则在etcd.service文件中ExecStart行不要再添加相同的启动参数，否则服务拉起的时候etcd会报参数冲突错误）

**&lt;4&gt; 将etcd目录拷贝到另外两个节点**

\# scp -r /k8s root@k8s-master3:/k8s

\# scp -r /k8s root@k8s-node1:/k8s

修改k8s-master3节点的/k8s/etcd/cfg/etcd.conf：

\# \[member]

ETCD\_NAME=etcd-2

ETCD\_LISTEN\_PEER\_URLS=https://192.168.1.3:2380

ETCD\_LISTEN\_CLIENT\_URLS=https://192.168.1.3:2379

\# \[cluster]

ETCD\_INITIAL\_ADVERTISE\_PEER\_URLS=https://192.168.1.3:2380

ETCD\_ADVERTISE\_CLIENT\_URLS=https://192.168.1.3:2379

▲滑动查看更多

修改k8s-node1节点的 /k8s/etcd/cfg/etcd.conf：

\# \[member]

ETCD\_NAME=etcd-3

ETCD\_LISTEN\_PEER\_URLS=https://192.168.1.4:2380

ETCD\_LISTEN\_CLIENT\_URLS=https://192.168.1.4:2379

\# \[cluster]

ETCD\_INITIAL\_ADVERTISE\_PEER\_URLS=https://192.168.1.4:2380

ETCD\_ADVERTISE\_CLIENT\_URLS=https://192.168.1.4:2379

▲滑动查看更多

**&lt;5&gt; 启动 etcd 服务**

首先在三个节点将etcd.service 拷贝到/usr/lib/systemd/system/下

\# cp /k8s/etcd/etcd.service 

/usr/lib/systemd/system/

\# systemctl daemon-reload

在三个节点同时启动 etcd 服务

\# systemctl start etcd

设置开机启动

\# systemctl enable etcd

查看 etcd 集群状态

/k8s/etcd/bin/etcdctl endpoint health \\

--endpoints=https://192.168.1.2:2379, https://192.168.1.3:2379,https://192.168.1.4:2379 \\

--cacert=/k8s/etcd/ssl/ca.pem \\

--cert=/k8s/etcd/ssl/etcd.pem \\

--key=/k8s/etcd/ssl/etcd-key.pem

▲滑动查看更多

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDk2NuicMudy8tTBYSiaDibumib3pWa5j0y19866D5OjEf10x0v6iclW9OZLrw/640?wx_fmt=jpeg)

04

部署Master组件

**4.1**

自ApiServer SSL证书

k8s集群中所有资源的访问和变更都是通过kube-apiserver的REST API来实现的，首先在k8s-master2节点上部署kube-apiserver组件。

我们首先为apiserver签发一套SSL证书，过程与etcd自签SSL证书类似。通过如下命令创建几个目录，ssl用于存放自签证书，cfg用于存放配置文件，bin用于存放执行程序，logs存放日志文件。

\# mkdir -p /k8s/kubernetes/{ssl,cfg,bin,logs}

进入kubernetes目录：

\# cd /k8s/kubernetes/ssl

**&lt;1&gt; 创建 CA 配置文件：ca-config.json**

执行如下命令创建 ca-config.json

\# cat &gt; ca-config.json &lt;&lt;EOF

{

  "signing": {

    "default": {

      "expiry": "87600h"

    },

    "profiles": {

      "kubernetes": {

        "usages": [

            "signing",

            "key encipherment",

            "server auth",

            "client auth"

        ],

        "expiry": "87600h"

      }

    }

  }

}

EOF

**&lt;2&gt; 创建 CA 证书签名请求文件：ca-csr.json**

\# cat &gt; ca-csr.json &lt;&lt;EOF

{

  "CN": "kubernetes",

  "key": {

    "algo": "rsa",

    "size": 2048

  },

  "names": [

    {

      "C": "CN",

      "ST": "Shanghai",

      "L": "Shanghai",

      "O": "kubernetes",

      "OU": "System"

    }

  ],

    "ca": {

       "expiry": "87600h"

    }

}

EOF

**&lt;3&gt; 生成 CA 证书和私钥**

\# cfssl gencert -initca ca-csr.json | cfssljson -bare ca

**&lt;4&gt; 创建证书签名请求文件：kubernetes-csr.json**

执行如下命令创建 kubernetes-csr.json：

\# cat &gt; kubernetes-csr.json &lt;&lt;EOF

{

    "CN": "kubernetes",

    "hosts": [

      "127.0.0.1",

      "10.0.0.1",

      "192.168.1.1",

      "192.168.1.2",

      "192.168.1.3",

      "192.168.1.4",

      "192.168.1.5",

      "192.168.1.6",

      "kubernetes",

      "kubernetes.default",

      "kubernetes.default.svc",

      "kubernetes.default.svc.cluster",

      "kubernetes.default.svc.cluster.local"

    ],

    "key": {

        "algo": "rsa",

        "size": 2048

    },

    "names": [

        {

            "C": "CN",

            "ST": "BeiJing",

            "L": "BeiJing",

            "O": "kubernetes",

            "OU": "System"

        }

    ]

}

EOF

  说明：

hosts：指定会直接访问apiserver的IP列表，一般需指定etcd集群、kubernetes master集群的主机IP和kubernetes服务的服务IP，Node的IP一般不需要加入。

**&lt;5&gt; 为****kubernetes****生成证书和私钥**

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes

**4.2**

部署 kube-apiserver 组件

**&lt;1&gt; 下载二进制包**

# wget https://storage.googleapis.com/kubernetes-release/release/v1.18.10/kubernetes-client-linux-arm64.tar.gz

# wget https://storage.googleapis.com/kubernetes-release/release/v1.18.10/kubernetes-server-linux-arm64.tar.gz

▲滑动查看更多

解压后先将k8s-master2节点上部署的组件拷贝到/k8s/kubernetes/bin目录下：

\# cp -p /usr/local/src/kubernetes/server/bin/{kube-apiserver,kube-controller-manager,kube-scheduler} /k8s/kubernetes/bin/

\# cp -p /usr/local/src/kubernetes/server/bin/kubectl /usr/local/bin/

▲滑动查看更多

**&lt;2&gt; 创建Node令牌文件：token.csv**

Master apiserver启用TLS认证后，Node节点kubelet组件想要加入集群，必须使用CA签发的有效证书才能与apiserver通信，当Node节点很多时，签署证书是一件很繁琐的事情，因此有了 TLS Bootstrap 机制，kubelet会以一个低权限用户自动向 apiserver申请证书，kubelet的证书由apiserver动态签署。因此先为apiserver生成一个令牌文件，令牌之后会在Node中用到。

生成token，一个随机字符串，可使用如下命令生成token，apiserver配置的token必须与Node节点bootstrap.kubeconfig配置保持一致。

\# head -c 16 /dev/urandom | od -An -t x | tr -d ' '

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkuhFSbTepWl52OOY2RFRdX44iaalEcefu1fHrr8PficolAUiaTUcoXmyMQ/640?wx_fmt=jpeg)

创建 token.csv，格式：token，用户，UID，用户组

\# cat &gt; /k8s/kubernetes/cfg/token.csv &lt;&lt;'EOF'

0bd319ce03411f546841d74397b1d778,kubelet-bootstrap,10001,"system:node-bootstrapper"

EOF

▲滑动查看更多

**&lt;3&gt; 创建kube-apiserver配置文件：kube-apiserver.conf**

kube-apiserver有很多配置项，可以参考官方文档查看每个配置项的用途：

（注意：“\\” 后面不要有空格，不要有多余的换行，否则启动失败）

\# cat &gt; /k8s/kubernetes/cfg/kube-apiserver.conf &lt;&lt;'EOF'

KUBE\_APISERVER\_OPTS="—etcd-servers=https://192.168.1.2:2379,https://192.168.1.3:2379,https://192.168.1.4:2379 \\

  --bind-address=192.168.1.2 \\

  --secure-port=6443 \\

  --advertise-address=192.168.1.2 \\

  --allow-privileged=true \\

  --service-cluster-ip-range=10.0.0.0/24 \\

  --service-node-port-range=30000-32767 \\

  --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,NodeRestriction \\

  --authorization-mode=RBAC,Node \\

  --enable-bootstrap-token-auth=true \\

  --token-auth-file=/k8s/kubernetes/cfg/token.csv \\

  --kubelet-client-certificate=/k8s/kubernetes/ssl/kubernetes.pem \\

  --kubelet-client-key=/k8s/kubernetes/ssl/kubernetes-key.pem \\

  --tls-cert-file=/k8s/kubernetes/ssl/kubernetes.pem \\

  --tls-private-key-file=/k8s/kubernetes/ssl/kubernetes-key.pem \\

  --client-ca-file=/k8s/kubernetes/ssl/ca.pem \\

  --service-account-key-file=/k8s/kubernetes/ssl/ca-key.pem \\

  --etcd-cafile=/k8s/etcd/ssl/ca.pem \\

  --etcd-certfile=/k8s/etcd/ssl/etcd.pem \\

  --etcd-keyfile=/k8s/etcd/ssl/etcd-key.pem \\

  --v=2 \\

  --logtostderr=false \\

  --log-dir=/k8s/kubernetes/logs \\

  --audit-log-maxage=30 \\

  --audit-log-maxbackup=3 \\

  --audit-log-maxsize=100 \\

  —audit-log-path=/k8s/kubernetes/logs/k8s-audit.log”

EOF

▲滑动查看更多

  重点配置说明：

--etcd-servers：etcd 集群地址

--bind-address：apiserver 监听的地址，一般配主机IP

--secure-port：监听的端口

--advertise-address：集群通告地址，其它Node节点通过这个地址连接 apiserver，不配置则使用bind-address

--service-cluster-ip-range：Service 的 虚拟IP范围，以CIDR格式标识，该IP范围不能与物理机的真实IP段有重合。

--service-node-port-range：Service 可映射的物理机端口范围，默认30000-32767

--admission-control：集群的准入控制设置，各控制模块以插件的形式依次生效，启用RBAC授权和节点自管理。

--authorization-mode：授权模式，包括：AlwaysAllow，AlwaysDeny，ABAC(基于属性的访问控制)，Webhook，RBAC(基于角色的访问控制)，Node(专门授权由 kubelet 发出的API请求)。（默认值"AlwaysAllow"）。

--enable-bootstrap-token-auth：启用TLS bootstrap功能

--token-auth-file：这个文件将被用于通过令牌认证来保护API服务的安全端口。

--v：指定日志级别，0~8，越大日志越详细

**&lt;4&gt; 创建apiserver服务：kube-apiserver.service**

\# cat &gt; /usr/lib/systemd/system/kube-apiserver.service &lt;&lt;'EOF'

\[Unit]

Description=Kubernetes API Server

Documentation=https://github.com/GoogleCloudPlatform/kubernetes

After=network.target

\[Service]

EnvironmentFile=-/k8s/kubernetes/cfg/kube-apiserver.conf

ExecStart=/k8s/kubernetes/bin/kube-apiserver $KUBE\_APISERVER\_OPTS

Restart=on-failure

LimitNOFILE=65536

\[Install]

WantedBy=multi-user.target

EOF

▲滑动查看更多

**&lt;5&gt; 启动kube-apiserver组件**

启动组件

\# systemctl daemon-reload

\# systemctl start kube-apiserver

\# systemctl enable kube-apiserver

检查启动状态

\# systemctl status kube-apiserver

查看启动日志

\# less /k8s/kubernetes/logs/kube-apiserver.INFO

**&lt;6&gt; 将kubelet-bootstrap用户绑定到系统集群角色，之后便于Node使用token请求证书:**

\# kubectl create clusterrolebinding kubelet-bootstrap \\

  --clusterrole=system:node-bootstrapper \\

  --user=kubelet-bootstrap

▲滑动查看更多

**4.3**

部署kube-controller-manager组件

**&lt;1&gt; 创建kube-controller-manager配置文件：kube-controller-manager.conf**

\# cat &gt; /k8s/kubernetes/cfg/kube-controller-manager.conf &lt;&lt;'EOF'

KUBE\_CONTROLLER\_MANAGER\_OPTS="--leader-elect=true \\

  --master=127.0.0.1:8080 \\

  --address=127.0.0.1 \\

  --allocate-node-cidrs=true \\

  --cluster-cidr=10.244.0.0/16 \\

  --service-cluster-ip-range=10.0.0.0/24 \\

  --cluster-signing-cert-file=/k8s/kubernetes/ssl/ca.pem \\

  --cluster-signing-key-file=/k8s/kubernetes/ssl/ca-key.pem \\

  --root-ca-file=/k8s/kubernetes/ssl/ca.pem \\

  --service-account-private-key-file=/k8s/kubernetes/ssl/ca-key.pem \\

  --experimental-cluster-signing-duration=87600h0m0s \\

  --v=2 \\

  --logtostderr=false \\

  —log-dir=/k8s/kubernetes/logs"

EOF

  重点配置说明：

--leader-elect：当该组件启动多个时，自动选举，默认true

--master：连接本地apiserver，apiserver 默认会监听本地8080端口

--allocate-node-cidrs：是否分配和设置Pod的CDIR

--service-cluster-ip-range：Service 集群IP段

**&lt;2&gt; 创建kube-controller-manager服务：kube-controller-manager.service**

\# cat &gt; /usr/lib/systemd/system/kube-controller-manager.service &lt;&lt;'EOF'

\[Unit]

Description=Kubernetes Controller Manager

Documentation=https://github.com/GoogleCloudPlatform/kubernetes

After=network.target

\[Service]

EnvironmentFile=/k8s/kubernetes/cfg/kube-controller-manager.conf

ExecStart=/k8s/kubernetes/bin/kube-controller-manager $KUBE\_CONTROLLER\_MANAGER\_OPTS

Restart=on-failure

LimitNOFILE=65536

\[Install]

WantedBy=multi-user.target

EOF

▲滑动查看更多

**&lt;3&gt; 启动kube-controller-manager组件**

启动组件

\# systemctl daemon-reload

\# systemctl start kube-controller-manager

\# systemctl enable kube-controller-manager

检查启动状态

\# systemctl status kube-controller-manager

查看启动日志

\# less /k8s/kubernetes/logs/kube-controller-manager.INFO

**4.4**

部署kube-scheduler组件

**&lt;1&gt; 创建kube-scheduler配置文件：kube-scheduler.conf**

\# cat &gt; /k8s/kubernetes/cfg/kube-scheduler.conf &lt;&lt;'EOF'

KUBE\_SCHEDULER\_OPTS="--leader-elect=true \\

  --master=127.0.0.1:8080 \\

  --address=127.0.0.1 \\

  --v=2 \\

  --logtostderr=false \\

  --log-dir=/k8s/kubernetes/logs"

EOF

**&lt;2&gt; 创建 kube-scheduler服务：kube-scheduler.service**

\# cat &gt; /usr/lib/systemd/system/kube-scheduler.service &lt;&lt;'EOF'

\[Unit]

Description=Kubernetes Scheduler

Documentation=https://github.com/GoogleCloudPlatform/kubernetes

After=network.target

\[Service]

EnvironmentFile=/k8s/kubernetes/cfg/kube-scheduler.conf

ExecStart=/k8s/kubernetes/bin/kube-scheduler $KUBE\_SCHEDULER\_OPTS

Restart=on-failure

LimitNOFILE=65536

\[Install]

WantedBy=multi-user.target

EOF

▲滑动查看更多

**&lt;3&gt; 启动kube-scheduler组件**

启动组件

\# systemctl daemon-reload

\# systemctl start kube-scheduler

\# systemctl enable kube-scheduler

查看启动状态

\# systemctl status kube-scheduler

查看启动日志

\# less /k8s/kubernetes/logs/kube-scheduler.INFO

**4.5**

查看集群状态

**&lt;1&gt; 查看组件状态**

\# kubectl get cs

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkr3VLWWsuicZAzFcOBdP1aibrGmc9Occ1kc0SmQw84ETrM94gvIciaqRJw/640?wx_fmt=jpeg)

05

Node节点部署

**5.1**

iSulad容器

iSula容器介绍参考iSulad在openEuler社区的SIG组：

https://gitee.com/openeuler/iSulad

**&lt;1&gt; 安装iSula容器**

#dnf install iSulad

**&lt;2&gt; 修改iSulad配置文件**

\# vi /etc/isulad/daemon.json

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDksU4A0ojkkb6TwWK5Ccqicklgic0gIueTJy3F2oE5NKkfFY3l9Cz8P7Dw/640?wx_fmt=jpeg)

（注意：树莓派是arm64架构，pause镜像需要使用arm64版本）

**&lt;3&gt; 启动iSulad 服务**

\# systemctl start isulad

**&lt;4&gt; 设置开机启动**

\# systemctl enable isulad

**&lt;5&gt; 验证安装是否成功**

\# isula --version

\# isula info

**5.2**

Node节点证书

**&lt;1&gt; 创建Node节点的证书签名请求文件：kube-proxy-csr.json**

首先在k8s-master2节点上，通过颁发的CA证书先创建好Node节点要使用的证书，先创建证书签名请求文件：kube-proxy-csr.json：

\# cat &gt; kube-proxy-csr.json &lt;&lt;EOF

{

    "CN": "system:kube-proxy",

    "hosts": \[],

    "key": {

        "algo": "rsa",

        "size": 2048

    },

    "names": [

        {

            "C": "CN",

            "ST": "BeiJing",

            "L": "BeiJing",

            "O": "kubernetes",

            "OU": "System"

        }

    ]

}

EOF

**&lt;2&gt; 为kube-proxy生成证书和私钥**

\# cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kube-proxy-csr.json | cfssljson -bare kube-proxy

**&lt;3&gt; node节点创建工作目录**

\# mkdir -p /k8s/kubernetes/{bin,cfg,logs,ssl}

**&lt;4&gt; 将k8s-master2节点的文件拷贝到node节点**

将kubelet、kube-proxy拷贝到node节点上：

\# scp -r /usr/local/src/kubernetes/server/bin/{kubelet,kube-proxy} root@k8s-node1:/k8s/kubernetes/bin/

▲滑动查看更多

将证书拷贝到k8s-node1节点上：

\# scp -r /k8s/kubernetes/ssl/{ca.pem,kube-proxy.pem,kube-proxy-key.pem} root@k8s-node1:/k8s/kubernetes/ssl/

**5.3**

安装kubelet

**&lt;1&gt; 创建请求证书的配置文件：bootstrap.kubeconfig**

bootstrap.kubeconfig将用于向apiserver请求证书，apiserver会验证token、证书 是否有效，验证通过则自动颁发证书。

\# cat &gt; /k8s/kubernetes/cfg/bootstrap.kubeconfig &lt;&lt;'EOF'

apiVersion: v1

clusters:

\- cluster:

    certificate-authority: /k8s/kubernetes/ssl/ca.pem

    server: https://192.168.1.2:6443

  name: kubernetes

contexts:

\- context:

    cluster: kubernetes

    user: kubelet-bootstrap

  name: default

current-context: default

kind: Config

preferences: {}

users:

\- name: kubelet-bootstrap

  user:

    token: 0bd319ce03411f546841d74397b1d778

EOF

▲滑动查看更多

  说明：

certificate-authority：CA证书

server：master地址

token：master上token.csv中配置的token

**&lt;2&gt; 创建kubelet 配置文件：kubelet-config.yml**

为了安全性，kubelet禁止匿名访问，必须授权才可以，通过kubelet-config.yml授权 apiserver访问kubelet。

\# cat &gt; /k8s/kubernetes/cfg/kubelet-config.yml &lt;&lt;'EOF'

kind: KubeletConfiguration

apiVersion: kubelet.config.k8s.io/v1beta1

address: 0.0.0.0

port: 10250

readOnlyPort: 10255

cgroupDriver: cgroupfs

clusterDNS:

\- 10.0.0.2

clusterDomain: cluster.local

failSwapOn: false

authentication:

  anonymous:

    enabled: false

  webhook:

    cacheTTL: 2m0s

    enabled: true

  x509:

    clientCAFile: /k8s/kubernetes/ssl/ca.pem

authorization:

  mode: Webhook

  webhook:

    cacheAuthroizedTTL: 5m0s

    cacheUnauthorizedTTL: 30s

evictionHard:

  imagefs.available: 15%

  memory.available: 100Mi

  nodefs.available: 10%

  nodefs.inodesFree: 5%

maxOpenFiles: 100000

maxPods: 110

EOF

  说明：

address：kubelet监听地址

port：kubelet的端口

cgroupDriver：cgroup 驱动，与docker的cgroup驱动一致

authentication：访问kubelet的授权信息

authorization：认证相关信息

evictionHard：垃圾回收策略

maxPods：最大pod数

**&lt;3&gt; 创建kubelet服务配置文件：kubelet.conf**

\# cat &gt; /k8s/kubernetes/cfg/kubelet.conf &lt;&lt;'EOF'

KUBELET\_OPTS="--hostname-override=k8s-node1 \\

  --container-runtime=remote \\

  --container-runtime-endpoint=/var/run/isulad.sock \\

  --network-plugin=cni \\

  --cni-bin-dir=/opt/cni/bin \\

  --cni-conf-dir=/etc/cni/net.d \\

  --cgroups-per-qos=false \\

  --enforce-node-allocatable="" \\

  --kubeconfig=/k8s/kubernetes/cfg/kubelet.kubeconfig \\

  --bootstrap-kubeconfig=/k8s/kubernetes/cfg/bootstrap.kubeconfig \\

  --config=/k8s/kubernetes/cfg/kubelet-config.yml \\

  --cert-dir=/k8s/kubernetes/ssl \\

  --pod-infra-container-image=kubernetes/pause:latest \\

  --v=2 \\

  --logtostderr=false \\

  —log-dir=/k8s/kubernetes/logs"

EOF

▲滑动查看更多

  说明：

--hostname-override：当前节点注册到k8s中显示的名称，默认为主机 hostname

--network-plugin：启用CNI网络插件

--cni-bin-dir：CNI插件可执行文件位置，默认在/opt/cni/bin下

--cni-conf-dir：CNI插件配置文件位置，默认在/etc/cni/net.d下

--cgroups-per-qos：必须加上这个参数和 --enforce-node-allocatable，否则报错 \[Failed to start ContainerManager failed to initialize top level QOS containers.......]

--kubeconfig：会自动生成kubelet.kubeconfig，用于连接 apiserver

--bootstrap-kubeconfig：指定 bootstrap.kubeconfig 文件

--config：kubelet 配置文件

--cert-dir：证书目录

--pod-infra-container-image：管理Pod网络的镜像，基础的Pause容器，默认是 k8s.gcr.io/pause:3.1

★ 通过红框内的配置将runtime改为isula容器，默认是docker容器。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkicpicYmsKibYME7Wa9lkWvibZOiaOI02icLCR67dHDs8ox5DyqY3qw2Hhc5g/640?wx_fmt=jpeg)

**&lt;4&gt; 创建kubelet服务：kubelet.service**

\# cat &gt; /usr/lib/systemd/system/kubelet.service &lt;&lt;'EOF'

\[Unit]

Description=Kubernetes Kubelet

After=docker.service

Before=docker.service

\[Service]

EnvironmentFile=/k8s/kubernetes/cfg/kubelet.conf

ExecStart=/k8s/kubernetes/bin/kubelet $KUBELET\_OPTS

Restart=on-failure

LimitNOFILE=65536

\[Install]

WantedBy=multi-user.target

EOF

▲滑动查看更多

**&lt;5&gt; 启动kubelet**

\# systemctl daemon-reload

\# systemctl start kubelet

开机启动：

\# systemctl enable kubelet

查看启动日志： 

\# tail -f /k8s/kubernetes/logs/kubelet.INFO

**&lt;6&gt; master给 node授权**

kubelet启动后还没加入到集群中，会向apiserver请求证书，需手动在k8s-master2 上对node授权。通过如下命令查看是否有新的客户端请求颁发证书：

\# kubectl get csr

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDk15VoicibRyptRs1KXg75AicwKe8bUOGc0ibBUI9zSptksgJ4mvybdOrIzw/640?wx_fmt=jpeg)

给客户端颁发证书，允许客户端加入集群：

\# kubectl certificate approve node-csr- node-csr-y2FJp1MtFFoPBv0e\_4pLYECYD889rQuTIAnu1EuXtjU

▲滑动查看更多

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkFP5ibLlLVvmyoUEiaRPNXIORpgfUSibJs4HibB2MKrv4Mhiba3YtARp4tZA/640?wx_fmt=jpeg)

**&lt;7&gt; 授权成功**

查看node是否加入集群:

\# kubectl get node

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkpezMEsTFAalx0ia27jvSfjZpiaKxgCwmvHhrTIOvDwKlicjOg5yHwkOcw/640?wx_fmt=jpeg)

颁发证书后，可以在 /k8s/kubenetes/ssl下看到master为kubelet颁发的证书：

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkq9oouqRL7JBkzbY7GIvkTbibic5iacAQ40ficKJQ9sFYydwibp2MDhZgRyA/640?wx_fmt=jpeg)

在/k8s/kubenetes/cfg下可以看到自动生成的 kubelet.kubeconfig 配置文件：

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkCp4UwmsNiaDoRteAEn1F03gplkwavl0h21DibQ6GAbRZHicRnv28aTYPg/640?wx_fmt=jpeg)

**5.4**

安装 kube-proxy

**&lt;1&gt; 创建kube-proxy连接apiserver的配置文件：kube-proxy.kubeconfig**

\# cat &gt; /k8s/kubernetes/cfg/kube-proxy.kubeconfig &lt;&lt;'EOF'

apiVersion: v1

clusters:

\- cluster:

    certificate-authority: /k8s/kubernetes/ssl/ca.pem

    server: https://192.168.1.2:6443

  name: kubernetes

contexts:

\- context:

    cluster: kubernetes

    user: kube-proxy

    name: default

current-context: default

kind: Config

preferences: {}

users:

\- name: kube-proxy

  user:

    client-certificate: /k8s/kubernetes/ssl/kube-proxy.pem

    client-key: /k8s/kubernetes/ssl/kube-proxy-key.pem

EOF

**&lt;2&gt; 创建kube-proxy配置文件：kube-proxy-config.yml**

\# cat &gt; /k8s/kubernetes/cfg/kube-proxy-config.yml &lt;&lt;'EOF'

kind: KubeProxyConfiguration

apiVersion: kubeproxy.config.k8s.io/v1alpha1

address: 0.0.0.0

metrisBindAddress: 0.0.0.0:10249

clientConnection:

  kubeconfig: /k8s/kubernetes/cfg/kube-proxy.kubeconfig

hostnameOverride: k8s-node1

clusterCIDR: 10.0.0.0/24

mode: ipvs

ipvs:

  scheduler: "rr"

iptables:

  masqueradeAll: true

EOF

  说明：

metrisBindAddress：采集指标暴露的地址端口，便于监控系统，采集数据

clusterCIDR：集群Service网段

**&lt;3&gt; 创建kube-proxy配置文件：kube-proxy.conf**

\# cat &gt; /k8s/kubernetes/cfg/kube-proxy.conf &lt;&lt;'EOF'

KUBE\_PROXY\_OPTS="--config=/k8s/kubernetes/cfg/kube-proxy-config.yml \\

  --v=2 \\

  --logtostderr=false \\

  --log-dir=/k8s/kubernetes/logs"

EOF

**&lt;4&gt; 创建 kube-proxy 服务：kube-proxy.service**

\# kubectl certificate 

\# cat &gt; /usr/lib/systemd/system/kube-proxy.service &lt;&lt;'EOF'

\[Unit]

Description=Kubernetes Proxy

After=network.target

\[Service]

EnvironmentFile=/k8s/kubernetes/cfg/kube-proxy.conf

ExecStart=/k8s/kubernetes/bin/kube-proxy $KUBE\_PROXY\_OPTS

Restart=on-failure

LimitNOFILE=65536

\[Install]

WantedBy=multi-user.target

EOF

▲滑动查看更多

**&lt;5&gt; 启动kube-proxy**

启动服务：

\# systemctl daemon-reload

\# systemctl start kube-proxy

开机启动：

\# systemctl enable kube-proxy

查看启动日志： 

\# tail -f /k8s/kubernetes/logs/kube-proxy.INFO

**5.5**

部署其它Node节点

部署其它Node节点基于与上述流程一致，只需将配置文件中k8s-node1改为k8s-node2即可。

\# kubectl get node -o wide

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkwWozicUvDjCZoCcBdwNhESvLvMUnWPQaLGfKv6UobeyLv80tn0XcjeA/640?wx_fmt=jpeg)

06

部署K8S容器集群网络(Flannel)

**&lt;1&gt; K8S集群网络**

Kubernetes项目并没有使用Docker的网络模型，kubernetes是通过一个CNI接口维护一个单独的网桥来代替 docker0，这个网桥默认叫cni0。

CNI（Container Network Interface-）是CNCF旗下的一个项目，由一组用于配置 Linux 容器的网络接口的规范和库组成，同时还包含了一些插件。CNI仅关心容器创建时的网络分配，和当容器被删除时释放网络资源。

Flannel是CNI的一个插件，可以看做是CNI接口的一种实现。Flannel是针对 Kubernetes设计的一个网络规划服务，它的功能是让集群中的不同节点主机创建的容器都具有全集群唯一的虚拟IP地址，并让属于不同节点上的容器能够直接通过内网IP通信。

**&lt;2&gt; 创建CNI工作目录**

通过给kubelet传递--network-plugin=cni命令行选项来启用CNI插件。kubelet从--cni-conf-dir（默认是/etc/cni/net.d）读取配置文件并使用该文件中的CNI配置来设置每个pod的网络。CNI配置文件必须与CNI规约匹配，并且配置引用的任何所需的 CNI 插件都必须存在于--cni-bin-dir（默认是/opt/cni/bin）指定的目录。

首先在node节点上创建两个目录：

\# mkdir -p /opt/cni/bin /etc/cni/net.d

**&lt;3&gt; 装 CNI 插件**

可以从 github 上下载 CNI 插件：下载 CNI 插件 。

\# curl -L https://github.com/containernetworking/plugins/releases/download/v0.8.7/cni-plugins-linux-arm64-v0.8.7.tgz | tar -C /opt/cni/bin -xz

▲滑动查看更多

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkaDiaU2lXoJeZ8fCBwiawmGLaR9Fym5XsWF1mShzeasiarfdltAKI7KwRA/640?wx_fmt=jpeg)

**&lt;4&gt; 部署flannel**

下载 flannel配置文件kube-flannel.yml：

\# wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

▲滑动查看更多

如果无法解析raw.githubusercontent.com，在/etc/hosts中添加：

199.232.68.133 raw.githubusercontent.com

注意kube-flannel.yml中：Network的地址需与kube-controller-manager.conf中的--cluster-cidr=10.244.0.0/16保持一致。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkDlEvft5JNWuVIZR7lydMnJ7utjWDUlgfRkib10oKsibQicGGInz6gowvQ/640?wx_fmt=jpeg)

在k8s-master2节点上部署 Flannel：

\# kubectl apply -f kube-flannel.yml

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDksvbStVn1JcicosRT0rplvQeialT8wUm2dX3ONRBsP3HfVW18ppCmAQrQ/640?wx_fmt=jpeg)

**&lt;5&gt; 检查部署状态**

Flannel会在Node上起一个Pod，可以查看pod的状态看flannel是否启动成功：

\# kubectl get pods -n kube-system -o wide

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDklmicicaYl7eUIVuIiasCDIFNASfnAxCKfs9Tkia7DccAsJw2ujvicYgu5Tw/640?wx_fmt=jpeg)

Flannel部署成功后，就可以看Node是否就绪：

\# kubectl get nodes -o wide

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkzhoNoRWwJ00RvibLBHonehvNV3BEKxiclAMlDiavyib5IXm3sP9LGGHLXA/640?wx_fmt=jpeg)

在Node上查看网络配置，可以看到多了一个flannel.1 的虚拟网卡，这块网卡用于接收 Pod 的流量并转发出去。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkTeicbcWRGicFfdIibsGM2p9SyBvYPfTLaIUTRPY8kVSxUxGeWNPpJX1xg/640?wx_fmt=jpeg)

**&lt;6&gt; 测试创建pod**

创建一个nginx服务：

\# cat &gt; nginx.yaml &lt;&lt; EOF

apiVersion: apps/v1

kind: Deployment

metadata:

  name: nginx0-deployment

  labels:

    app: nginx0-deployment

spec:

  replicas: 2

  selector:

    matchLabels:

      app: nginx0

  template:

    metadata:

      labels:

        app: nginx0

    spec:

      containers:

      - name: nginx

        image: k8s.gcr.io/nginx:1.7.9

        ports:

        - containerPort: 80

EOF

\# kubectl apply -f nginx.yaml

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkibRyORnyUOO961Iic4jibrKPF8iaj0OuoAQb8FTTVGzPBZAQ3hBZg2cgNw/640?wx_fmt=jpeg)

07

部署dashboard

k8s提供了一个 Web版Dashboard，用户可以用dashboard部署容器化的应用、监控应用的状态，能够创建和修改各种K8S资源，比如Deployment、Job、DaemonSet等。用户可以Scale Up/Down Deployment、执行 Rolling Update、重启某个Pod或者通过向导部署新的应用。Dashboard能显示集群中各种资源的状态以及日志信息。Dashboard提供了 kubectl的绝大部分功能。

**&lt;1&gt; 下载dashboard配置文件**

\# wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml.yml

▲滑动查看更多

将recommended.yaml重命名为dashboard.yaml

**&lt;2&gt; 修改配置文件通，过Node暴露端口访问dashboard**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkvwo89qSMcfMQGgBgUY10EueEFWDicG8RYHD8kicGMGwrl89JK3ZNASqA/640?wx_fmt=jpeg)

**&lt;3&gt; 部署dashboard**

\# kubectl apply -f dashboard.yaml

查看是否部署成功：

\# kubectl get pods,svc -n kubernetes-dashboard

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbxpSHkkvH018FA2QWm2SDkXktZ83uZYgAu2YwuYOlNAq1uMLT2dANbDpvyKIDrY5BF2qkicuVgibUw/640?wx_fmt=jpeg)

通过https访问dashboard：

地址为集群中任意node节点地址加上上面红框中的端口30005：**https://192.168.1.4:30005**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZpShT3MNdASKDBL3cO28n1Iws2yP1qHegIHlibNq0QpkGJLW92vAPuj30woQqYGmV1PnEXCNh1wiag/640?wx_fmt=jpeg)

**&lt;4&gt; 登录授权**

Dashboard支持Kubeconfig和Token两种认证方式，为了简化配置，我们通过配置文件为Dashboard默认用户赋予admin权限。

\# cat &gt; kubernetes-adminuser.yaml &lt;&lt;'EOF'

apiVersion: v1

kind: ServiceAccount

metadata:

  name: admin-user

  namespace: kube-system

\---

apiVersion: rbac.authorization.k8s.io/v1beta1

kind: ClusterRoleBinding

metadata:

  name: admin-user

roleRef:

  apiGroup: rbac.authorization.k8s.io

  kind: ClusterRole

  name: cluster-admin

subjects:

\- kind: ServiceAccount

  name: admin-user

  namespace: kube-system

EOF

授权：

\# kubectl apply -f kubernetes-adminuser.yaml

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZpShT3MNdASKDBL3cO28n1vhMB6b1g9UibmTmAVw99b0zZiacRhRLtcQSs6LhZz1lWGWt8oFia1bDtw/640?wx_fmt=jpeg)

获取登录的 token：

\# kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk ' {print $1}')

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZpShT3MNdASKDBL3cO28n1hicq324iaOUiceMaZ70ABDXMCXKiak9u6lbeOziaXiasYpmXt2fBusqZTiaTA/640?wx_fmt=jpeg)

通过token登录进 dashboard，就可以查看集群的信息：

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZpShT3MNdASKDBL3cO28n1vb02Jq4xm42MReoj73PBR0cmqUzouhPALcLtyia04EUXu2icu8c1Ov3A/640?wx_fmt=jpeg)

08

多Master部署

**&lt;1&gt; 将k8s-master2上相关文件拷贝到k8s-master1和k8s-master3上**

在k8s-master1和k8s-master3上创建k8s工作目录：

\# mkdir -p /k8s/kubernetes

\# mkdir -p /k8s/etcd

拷贝k8s配置文件、执行文件、证书：

\# scp -r /k8s/kubernetes/{cfg,ssl,bin} root@k8s-master1:/k8s/kubernetes

\# cp /k8s/kubernetes/bin/kubectl /usr/local/bin/

拷贝 etcd 证书：

\# scp -r /k8s/etcd/ssl root@k8s-master1:/k8s/etcd

拷贝 k8s 服务的service文件：

\# scp /usr/lib/systemd/system/kube-* root@k8s-master1:/usr/lib/systemd/system

**&lt;2&gt; 修改kube-apiserver配置文件**

修改kube-apiserver.conf，修改IP为本机IP。

k8s-master1:

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZpShT3MNdASKDBL3cO28n1Bs1T0kxe6MYeDQXEXMRAmmibc9VDxFasljxTTc88jxDnoMC88vTia3Rw/640?wx_fmt=jpeg)

k8s-master3:

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZpShT3MNdASKDBL3cO28n1QpC70kq4s09RhMGicH8JGsnGnLnhia5n9yF5X3fRv3NztSk6NnTXybIw/640?wx_fmt=jpeg)

**&lt;3&gt; 启动k8s-master1和k8s-master3组件**

重新加载配置：

\# systemctl daemon-reload

启动 kube-apiserver：

\# systemctl start kube-apiserver

\# systemctl enable kube-apiserver

启动 kube-controller-manager：

\# systemctl start kube-controller-manager

\# systemctl enable kube-controller-manager

部署 kube-scheduler：

\# systemctl start kube-scheduler

\# systemctl enable kube-scheduler

**&lt;4&gt; 验证**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZpShT3MNdASKDBL3cO28n1bb6rkbTRIFCibqTamg4MibnuGJXrhXg2bObyXkEKrDdOzaZiclBTQeNXA/640?wx_fmt=jpeg)

至此，k8s集群部署完成。

09

一些小技巧

1)  etcd更改配置后下次启动还是旧的配置

etcd数据存储目录由配置文件中的ETCD\_DATA\_DIR指定，删除该目录下的文件即可。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZpShT3MNdASKDBL3cO28n1IUQvOJr0MsHe6HiabWy08wPMGq2feFM5Y0hcpEicGUN0MFSOrOK69OgQ/640?wx_fmt=jpeg)

2)  每次开机初始化及清理历史数据操作较多

可以将这些操作封装在脚本中，一键执行。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZpShT3MNdASKDBL3cO28n1n7ibLKIiaGeUxw3jgBYvlGic0Bfu5kyqMlUhJJVeU6jfAvT7ibbryA92Ug/640?wx_fmt=jpeg)

3)  树莓派如果无法访问境外仓库，可以先通过境外服务器下载需要的容器镜像，然后通过isula的save、load、tag操作将镜像存储在本地。

注意，可以更改服务yaml配置，将镜像下载策略改为优先使用本地镜像：

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZpShT3MNdASKDBL3cO28n1wNiayh5z1mNBu7ArYzEXcYcXjj4MgLReDOyy7GLOYBzb8alEeeu6COw/640?wx_fmt=jpeg)

4)  在图示路径添加网卡配置文件，树莓派开机即可获得固定IP地址。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZpShT3MNdASKDBL3cO28n1Oa9VhVgMjNKGxl21vXOPOaSVy6hV1lUy1wJeX5oND0nTRexwI3ZfPQ/640?wx_fmt=jpeg)

**版权声明：**

本次部署实践及本操作指导均参考：

https://www.cnblogs.com/chiangchou/p/k8s-1.html#\_label5

权侵删

**=END=**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMatRzJgDKxzkb8gsqm9MstYn8W6fMhbPtZKBZFQM7j9KhZ9R0HcHFftFOibVjmusW1797xCFSUD0nw/640?wx_fmt=png)

**openEuler —— 最具活力的开源社区**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaRxOeek40gFtDaCe6MiaZtib6LzaoW0UAbwDfDZnRqfVaUKvExibDZodj3nAof4SZ2xZjDnpGoJEH7g/640?wx_fmt=png)
