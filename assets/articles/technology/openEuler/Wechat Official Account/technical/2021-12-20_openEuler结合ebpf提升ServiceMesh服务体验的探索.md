# [openEuler结合ebpf提升ServiceMesh服务体验的探索](https://mp.weixin.qq.com/s/p4zaiwQc9DwDnp72yFMg2w)

[OpenAtom openEuler](javascript:void%280%29;)*2021-12-20 19:15:22*

## 服务网格的前世今生

早期的微服务架构上存在着服务发现、负载均衡、授权认证等各种各样的难题与挑战。起初微服务践行者们大多自己实现这么一套分布式通信系统来应对这些挑战，但这无疑造成了业务功能的冗余，解决此问题的方法就是将共有的分布式系统通信代码提取出来设计成一套框架，以框架库的方式供程序调用。但这个看似完美的方法却存在着几个致命的弱点:

- 框架大部分对业务来说是侵入式修改，需要开发者学习如何使用框架
- 框架无法做到跨语言使用
- 处理复杂项目框架库版本的依赖兼容问题非常棘手，框架库的升级经常导致业务的被迫升级。

随着微服务架构的发展，以 Linkeerd/Envoy/NginxMesh 为代表的 sidecar 代理模式应运而生，这就是第一代的 serviceMesh。它作为一个基础设施层，与业务进程完全解耦，和业务一起部署，接管业务件之间的通信，将网络数据收发单独抽象出一层，在这层集中处理了服务发现、负载均衡、授权认证等分布式系统所需要的功能，实现网络拓扑中请求的可靠传输，较为完美的解决了微服务框架库中的问题。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMavf1tRolJIFJ3ew3shqmVibHWVkIRPial3c45c5tKJqNuPNvQTP9CjfK4Hc7gjQYkH9liaLibYJwo6Vw/640?wx_fmt=jpeg)

但在软件开发领域没有万能的银弹。ServiceMesh 带来了这么多便利的同时，也不可避免的存在着一些问题。传统方式下，客户端到服务端的消息仅需进出一次内核协议栈即可完成消息传递，但在 sidecar 模式中，一般选择使用内核的 iptables 能力劫持业务流量，这就造成了业务数据需要多次进出内核协议栈，导致业务时延增大，吞吐量变低。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMavf1tRolJIFJ3ew3shqmVibXBjkMdWJTIkxXmDG7matdRKtXdAXX3CZ8S4UCOIapV8DK7XVTvI6wQ/640?wx_fmt=jpeg)

openEuler 21.03 版本下进行 sidecar（envoy）模式基准测试发现，with-envoy 与 non-envoy 模式下，时延有大幅增加

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMavf1tRolJIFJ3ew3shqmVib1JZImibc8zt9brGYiaFCUOLsLJicOgrIB1pXlcibRLqark8p4KbahBEySQ/640?wx_fmt=jpeg)

## 利用 ebpf 能力加速 ServiceMesh

有没有什么方法可以在享受 ServiceMesh 提供便利服务的基础上同时降低并消除网络时延带来的影响呢？在这里就不得不说下 ebpf 技术，ebpf 是在 kernel 中的一项革命性技术，旨在提供不修改内核代码或加载内核模块的基础上更加安全有效的扩展内核的能力。使用 ebpf 能力短接内核网络协议栈来降低网络时延，提升 ServiceMesh 的使用体验，这是目前业界通用的做法。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMavf1tRolJIFJ3ew3shqmVibMIhYbBibCAmamBHOhS4qKboRXbdQictariaKYp84tEkyx48T1oUZynlnw/640?wx_fmt=jpeg)

为了实现短接内核网络协议栈的目标，我们需要使用到 ebpf 提供的两种能力，分别是：sockops 与 socket redirection，openEuler 使用的 kernel 版本为 5.10，已经支持了 ebpf 的这两种能力。

- sockops 提供了在 tcp socket 创建连接时将 socket 使用 key(一般是四元组)标识后保存在 sockmap 数据结构中的能力
- socket redirection 在传输 tcp 数据时支持使用 key 去 sockmap 中引用 socket，命中后可直接将数据转发到此 socket 中
- 对于未在 sockmap 中找到的 socket，正常将数据包通过内核网络协议栈发送出去

将这些能力结合在一起，就可以在不经过内核网络协议栈的前提下直接将数据包转发到对应的 socket 上，完成数据的一次传输，降低在内核网络协议栈上的时间消耗。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMavf1tRolJIFJ3ew3shqmVibzSTAfpYjWrVHgcJ6iaJGGtiaibCXlxX4xLKvhd2ngibCNEC3geZibA7MRBQ/640?wx_fmt=jpeg)

在 tcp socket 建立连接的过程中，实际上有两次连接建立的过程，我们通常称之为正向连接与反向连接。因正反向连接在建连过程中均需要通过 iptables 信息来获取实际的 ip 地址与端口号，openEuler 在 iptables 的工作原理上新增 helper 函数，将获取对端信息的能力下沉到内核中，可以在 ebpf 函数中主动获取到 iptables 转换过的地址。这样我们可以建立一个辅助 map 用于存放正反向连接的对应关系并在 socket redirection 转发时先从辅助 map 中寻找到对端的连接信息，成功找到对端的连接信息后再进行 socket 转发动作。原理如下图

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMavf1tRolJIFJ3ew3shqmVibwNniaLMw1D96AicVyGiaz8NfRu0iaxxs9fCZqtsic8Et0twnn3f1icUHgkLw/640?wx_fmt=jpeg)

通过 sockops 能力的加速，我们在 openEuler21.03 上实测的结果如下：

- 测试环境：openEuler-21.03 / 5.10.0-4.17.0.28.oe1.x86\_64
- 组网：fortio-envoy-envoy:80-fortio\_server:80
- qps 提升约为 18%，平均时延提升 15%

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMavf1tRolJIFJ3ew3shqmVib0MKVoVXr8k01Maia5ZXkNqSLTZDAAUPABzz7e947gUz9ic6x9mDYkeWA/640?wx_fmt=jpeg)

## 下一步的工作：彻底消除 ServiceMesh 性能损耗

从 openEuler21.03 实际测试中可以看出，sockmap 对于 ServiceMesh 可以进行加速，但是加速的结果与不使用 ServiceMesh 相比仍然有较大差距。仔细分析，sockmap 并没有消耗 socket buff 之间的数据拷贝，也没有消耗 app/envoy 之间通信时的上下文切换，那问题可能仍然出在 ServiceMesh 架构上。有没有一种方法，既有 ServiceMesh 易管理、易部署的能力，又能消除其带来的性能劣化影响？目前 openEuler sig-high-performance-network 正在尝试这方面的工作，已经有了初步进展。有兴趣加入我们一起完成这个目标吗？可以订阅以下邮件列表或添加微信联系我们~

- high-performance-network@openeuler.org
- dev@openeuler.org

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMavf1tRolJIFJ3ew3shqmVibiab2hibsFeg63HgGVfpy2MOHF0bEDWVWJ8tcQHwFF8kMZHSX4C8wuXAQ/640?wx_fmt=jpeg)
