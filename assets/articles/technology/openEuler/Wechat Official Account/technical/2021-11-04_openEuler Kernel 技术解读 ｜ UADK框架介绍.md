# [openEuler Kernel 技术解读 ｜ UADK框架介绍](https://mp.weixin.qq.com/s/FkJJ4D3T8asgAnce-4wwgg)

原创*叶凯*[OpenAtom openEuler](javascript:void%280%29;)*2021-11-04 17:30:00*

UADK 全称为 User Space Accelerator Development Kit, 是一套用户态硬件加速器开发工具集，旨在 SVA 技术下用户可以高效地利用鲲鹏硬件加速器能力，为用户提供基础的库和驱动支持，通俗地说就是给数据进行压缩解压缩、加解密等处理加速的软件库。UADK 作为通用的加速器用户态框架并不只是支持鲲鹏加速器，配合 UACCE 框架可以支持任何厂商的加速器硬件，openEuler 21.09 Kernel 已完整回合支持 SVA。

## UADK 框架分析

UADK 完整组件包括：支持 SVA 的加速器硬件设备、vendor driver、内核态 UACCE 框架、用户态 libwd 和算法库，OS 支持 IOMMU & SVA。目前 Linux 内核主线 5.15 已经全面支持了 SVA 特性，同时鲲鹏 920 加速器引擎已初步验证了 SVA 硬件特性。 

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZrVFdTChzFnTLCnMjLSRWvZkFcITofR4uArZePBLhn2ialFd1W4AUYpyvicGPKLya41ibMq7qibucrYg/640?wx_fmt=png)

UADK框架图

从 UADK 的架构图可以看出，UACCE 为内核态和用户态提供一个通道。UACCE 全称为统一的加速器框架，目的是让使用加速器的应用程序都可以用统一的接口来访问加速器。加速器引擎在 UACCE 上注册为一个字符设备，同时设备信息会暴露到属性文件上。一个 PF 或者 VF 对应一个字符设备（例如/dev/hisi\_sec-0）。所以用户态可以非常方便地通过字符设备操作去访问注册的加速器设备，UACCE 的详细介绍可以在 Kernel documents 里面查阅，具体的可查阅“Documentation/misc-devices /uacce.rst”和“Documentation/ABI/testing/sysfs-driver-uacce”。

在用户态，libwd 与用户态驱动程序配合使用，可以看出上层算法业务通过用户态驱动程序直接访问硬件。首先用户申请一个 WD CTX，这个 CTX 是一个硬件队列资源的描述，然后用户算法接口基于这个 CTX 对设备发出请求。CTX 描述的仅仅是一种资源，而用户的数据流则是围绕 session 进行，这个 session 贯穿业务流始终，当然一个 CTX 可以对应多个 session。

推出 UADK 框架的出发点是 SVA 技术的发展，SVA 技术让硬件可以直接访问用户态程序的 VA，而不需要用户把 VA 转换成硬件可见的 DMA 地址传递给硬件。SVA（shared virtual addressing）技术也叫 SVM（shares virtual memory）指允许设备共享地址空间，从而简化设备驱动和用户态进程的 IO 内存管理，这两个名字是 ARM 和 intel 不同的名称而已。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZrVFdTChzFnTLCnMjLSRWv4dlCiaJffIuh8wKicwSvj9KiajOekSEEqiaO35H8oJSe7gHISH1dyxjZ9w/640?wx_fmt=png)

如上图 CPU 侧和设备侧可以看到 VA 对应的 PA，SVA 特性可以做到进程虚拟地址在进程和设备之间共享，所以这就带来了以下好处:

- 基于 IOMMU 模式限定了设备和进程的访问权限和安全边界，所以 SVA 技术较其他方案，在安全方面是一个非常显著的优势；
- SVA 支持设备基于用户态进程申请的 VA 直接发动 DMA 操作，当用户态直接 IO，做 DMA 访问硬件的时候，可以不经过系统调用和跨层拷贝，省去了 APP 内存到 dma 内存的拷贝及地址转换，这就大大简化了用户态编程。

## UADK 基础库介绍

- libwd: libwd 库包装一系列用来访问 UACCE 设备的接口，包括设备的管理、设备信息读取、申请队列资源、内存 region 映射等操作
- libhisi\_xxx：为设备用户态驱动，是用户态数据访问硬件的适配层，填充特定的任务描述数据（BD 信息）写到设备，同时回读设备写回的数据。
- libwd\_xxx: libwd\_xxx 包装了不同算法的 IO 接口，包括算法初始化、去初始化、发送、接收等接口，libwd\_crypto 包括了加解密相关，其中非对称加解密包括 RSA、DH、ECC（SM2、ECDSA、ECDH、X25519/X448）算法，对称加解密支持 AES、SM4 等算法，摘要算法支持 SHA-1、SHA-2、SM3、MD5 算法等。libwd\_comp 是为压缩解压缩提供的库，支持 gzip、zlib 等算法。

## 用法举例

我们以压缩任务为例，用户只需要调用很少的 API 就可以完成同步或异步压缩任务。 

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZrVFdTChzFnTLCnMjLSRWv8QWGoh0OCmmYTfkEgTnHYKELj6UFjWmicpYeGynUn2yu0C2kMa7ibLXg/640?wx_fmt=png)

UADK同步任务模型

同步模式（阻塞）意味着每个报文发下去都需要等硬件操作完成，然后收回处理好的报文，这会造成 CPU 占用率高且性能下降，而异步模式（非阻塞）可以在用户不需要关心时延的情况下，减少 CPU 占用率而获得较高的性能。 

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZrVFdTChzFnTLCnMjLSRWvrzSxUegL0bkyJzw04ia6k2PhdWl0yOuUfLOZ4kHGcNJI96VVpBdgQMg/640?wx_fmt=png)

UADK异步任务模型

## 性能数据

- libwd VS AF\_ALG (AES 算法)
  
  Block size (bytes)166425610248192AF\_ALG37.86k140.05k565.33k2530.30k19802.79klibwd6327.14k24477.50k97456.55k335090.47k1797931.01k

同步模式 VS NO-SVA(aes-128-ecb 算法，SEC 设备) 

SVA: 8.7G at most 

./uadk\_benchmark --alg aes-128-ecb --mode sva --opt 0 --sync --pktlen 1024 --seconds 5 --thread 32 --multi 1 --ctxnum 32

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZrVFdTChzFnTLCnMjLSRWvNq7LevA16eRLeS00SGx5vmwnQ82KwWjiaN5dqBtxpxKfr36tMm3WEJw/640?wx_fmt=png)

存在 iopf 场景：

SVA: 5.7G at most

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZrVFdTChzFnTLCnMjLSRWvHmhzD9YXTu0ogDgIV72dZXq3FCYxJeib0eMW5CdD0A2HDXL3ibVHe3EQ/640?wx_fmt=png)

NO-SVA: 8.5G at most 

./uadk\_benchmark --alg aes-128-ecb --mode nosva --opt 0 --sync --pktlen 1024 --seconds 5 --thread 32 --multi 1 --ctxnum 32

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZrVFdTChzFnTLCnMjLSRWvwTxFLHribn77hGfUWR2Id9N6Gk8VyhEibwyVvNclezSQaria9bL350lmw/640?wx_fmt=png)

异步模式 VS NO-SVA(aes-128-ecb 算法，SEC 设备)

SVA: 8.8G at most 

./uadk\_benchmark --alg aes-128-ecb --mode sva --opt 0 --async --pktlen 1024 --seconds 5 --thread 16 --multi 1 --ctxnum 16

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZrVFdTChzFnTLCnMjLSRWvOIGOBE9jQewja90JTYQL586gNapUzIYNXyWTbFcp886Nk2cs7UDJTg/640?wx_fmt=png)

存在 iopf 场景：

SVA: 7.3G at most

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZrVFdTChzFnTLCnMjLSRWvA7lJa0y3HS7ibjvZ6OwyP7WJRJB6x4jMaicQYDkhDCD4KeBkSmEVa4gQ/640?wx_fmt=png)

NO-SVA: 8.8G at most 

./uadk\_benchmark --alg aes-128-ecb --mode nosva --opt 0 --async --pktlen 1024 --seconds 5 --thread 16 --multi 1 --ctxnum 16

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZrVFdTChzFnTLCnMjLSRWvS6P7xibNOAE4epTKibkYD9XTN29AkIiaJyXyv36IDyE76icVNoxZ5H2cYw/640?wx_fmt=png)

总结 对比 Herbert Xu 实现的 AF\_ALG 这种用户空间对内核 Crypto API 调用方式，UADK 框架性能优势十分明显。对于高吞吐率要求的 SEC 设备测试数据表明，使用 SVA，较多的 iopf 会影响性能，只存在极少 iopf 时 SVA 与 NO-SVA 的性能接近。

## UADK in openEuler

- openEuler 21.09 Kernel 已回合 UACCE https://gitee.com/openeuler/kernel/tree/openEuler-21.09/drivers/misc/uacce
- UADK 用户态库已回合 version 2.3.11 https://gitee.com/src-openeuler/libwd/tree/master/
- openEuler 21.09 Kernel 已完整回合支持 SVA

## UADK 用户态库开源生态社区

https://github.com/Linaro/uadk https://github.com/Linaro/openssl-uadk

## openEuler Kernel SIG

- openEuler kernel 源代码仓库：https://gitee.com/openeuler/kernel 欢迎大家多多 star、fork，多多参与社区开发，多多贡献补丁。关于贡献补丁请参考：如何参与 openEuler 内核开发
- openEuler kernel 微信技术交流群 请扫描下方二维码添加小助手微信，或者直接添加小助手微信（微信号：openeuler-kernel），备注“交流群”或“技术交流”，加入 openEuler kernel SIG 技术交流群。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZrVFdTChzFnTLCnMjLSRWvPKkmhZhLFro43ruvYwicfG2UWficaytj6mInkXszYTtzy52mKNHtmY6w/640?wx_fmt=png)
