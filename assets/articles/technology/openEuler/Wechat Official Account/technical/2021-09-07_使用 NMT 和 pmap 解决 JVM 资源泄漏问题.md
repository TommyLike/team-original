# [使用 NMT 和 pmap 解决 JVM 资源泄漏问题](https://mp.weixin.qq.com/s/mc1xTuMq3Nty7Bhu7V1cnA)

*宋尧飞*[OpenAtom openEuler](javascript:void%280%29;)*2021-09-07 17:58:00*

编者按：笔者使用 JDK 自带的内存跟踪工具 NMT 和 Linux 自带的 pmap 解决了一个非常典型的资源泄漏问题。这个资源泄漏是由于 Java 程序员不正确地使用 Java API 导致的，使用 Files.list 打开的文件描述符必须关闭。本案例一方面介绍了怎么使用 NMT 解决 JVM 资源泄漏问题，如果读者遇到类似问题，可以尝试用 NMT 来解决；另一方面也提醒 Java 开发人员使用 Java API 时需要必须弄清楚 API 使用规范，希望大家通过这个案例有所收获。

**背景知识：**

**NMT**

NMT 是 Native Memory Tracking 的缩写，一个 JDK 自带的小工具，用来跟踪 JVM 本地内存分配情况（本地内存指的是 non-heap，例如 JVM 在运行时需要分配一些辅助数据结构用于自身的运行）。

NMT 功能默认关闭，可以在 Java 程序启动参数中加入以下参数来开启：

-XX:NativeMemoryTracking=\[summary | detail]

其中，"summary" 和 "detail" 的差别主要在输出信息的详细程度。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMavxlP7oWd7hMIw8G9eZr0nQLZVAp16cfgwvzbusLSo76nuawibxL0iaSJyWJnbEzllwQUwmxPz9cCg/640?wx_fmt=png)

开启 NMT 功能后，就可以使用 JDK 提供的 jcmd 命令来读取 NMT 采集的数据了，具体命令如下：

jcmd &lt;pid&gt; VM.native\_memory \[summary | detail | baseline | summary.diff | detail.diff | shutdown]

NMT 参数的含义可以通过 "jcmd &lt;pid&gt; help VM.native\_memory" 命令查询。通过 NMT 工具，我们可以快速区分内存泄露是否源自 JVM 分配。

**pmap**

对于非 JVM 分配的内存，经常需要用到 pmap 这个工具了，这是一个 linux 系统自带工具，能够从系统层面输出目标进程内存使用的详细情况，用法非常简单：

pmap \[参数] &lt;pid&gt;

常用的选项是 "-x" 或 "-X"，都是用来控制输出信息的详细程度。

上图是 pmap 部分输出信息，每列含义为

Address每段内存空间起始地址Kbytes每段内存空间大小（单位 KB）RSS每段内存空间实际使用内存大小（单位 KB）Dirty每段内存空间脏页大小（单位 KB）Mode每段内存空间权限属性Mapping可以映射到文件，也可以是“anon”表示匿名内存段，还有一些特殊名字如“stack”

**现象：**

某业务集群中，多个节点出现业务进程内存消耗缓慢增长现象，以其中一个节点为例：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMavxlP7oWd7hMIw8G9eZr0nXdCDibLRXStjaRHR6q7MOfib8sHSVkH7mwzm95yvPenWxUdzvJiaRLicAQ/640?wx_fmt=png)

如图所示，这个业务进程当前占用了 4.7G 的虚拟内存空间，以及 2.2G 的物理内存。已知正常状态下该业务进程的物理内存占用量不超过 1G。

**分析：**

使用命令 "jcmdVM.native\_memory detail" 可以看到所有受 JVM 监控的内存分布情况：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMavxlP7oWd7hMIw8G9eZr0nJVPDNWoqK8fraRed6TfCTu4Hhr7GfaKN6b8ibxicMLO6QeGEmjNWlz7w/640?wx_fmt=png)

上图只是截取了 nmt(Native Memory Tracking) 命令展示的概览信息，这个业务进程占用的 2.2G 物理内存中，受 JVM 监控的大概只占了 0.7G（上图中的 committed），意味着有 1.5G 物理内存不受 JVM 管控。JVM 可以监控到 Java 堆、元空间、CodeCache、直接内存等区域，但无法监控到那些由 JVM 之外的 Native Code 申请的内存，例如典型的场景：第三方 so 库中调用 malloc 函数申请一块内存的行为无法被 JVM 感知到。

nmt 除了会展示概览之外，还会详细罗列每一片受 JVM 监控的内存，包括其地址，将这些 JVM 监控到的内存布局和用 pmap 得到的完整的进程内存布局做一个对比筛查，这里忽略 nmt 和 pmap（下图 pmap 命令中 25600 是进程号）详细内存地址的信息，直接给出最可疑的那块内存：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMavxlP7oWd7hMIw8G9eZr0nwEa48z3z8ucVPKWJaF0XW7K1XFrOAHLgETiaGzyqNeAvmvoWUkrPJeg/640?wx_fmt=png)

由图可知，这片 1.7G 左右的内存区域属于系统层面的堆区。

**备注：这片系统堆区之所以稍大于上面计算得到的差值，原因大概是 nmt 中显示的 committed 内存并不对应真正占用的物理内存（linux 使用 Lazy 策略管理进程内存），实际通常会稍小。**

系统堆区主要就是由 libc 库接口 malloc 申请的内存组合而成，所以接下来就是去跟踪业务进程中的每次 malloc 调用，可以借助 GDB：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMavxlP7oWd7hMIw8G9eZr0nibFNcrS6S8Lq41xVjm9BicxRVNMfQmaV1l1TXLricpj7TnywEiaGa3vibYQ/640?wx_fmt=png)

实际上会有大量的干扰项，这些干扰项一方面来自 JVM 内部，比如：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMavxlP7oWd7hMIw8G9eZr0nEGckr0oqYwQ9Cgib7a5AibhbqggySOBoCF8bSVR1Qia07PFmha8tRr22Q/640?wx_fmt=png)

这部分干扰项很容易被排除，凡是调用栈中存在 "os::malloc" 这个栈帧的干扰项就可以直接忽视，因为这些 malloc 行为都会被 nmt 监控到，而上面已经排除了受 JVM 监控内存泄漏的可能。

另一部分干扰项则来自 JDK，比如：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMavxlP7oWd7hMIw8G9eZr0nn43TTJWhcmA8RgF5MlU4BcNw9Pb6hXepZIibdEib0hhicFFeia8eCs8mPw/640?wx_fmt=png)

有如上图所示，不少 JDK 的本地方法中直接或间接调用了 malloc，这部分 malloc 行为通常是不受 JVM 监控的，所以需要根据具体情况逐个排查，还是以上图为例，排查过程如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMavxlP7oWd7hMIw8G9eZr0nhYlHKuobIYibOxRWpjHtgsFrsrdLfw1KbSajNY5J3GGCicQRdD9YzciaA/640?wx_fmt=png)

注意图中临时中断的值（0x0000ffff5fc55d00）来自于第一个中断 b malloc 中断发生后的结果。

这里稍微解释一下上面 GDB 在做的排查过程，就是检查 malloc 返回的内存地址后续是否有通过 free 释放（通过 tb free if X3 这个命令，具体用法可以参考 GDB 调试），显然在这个例子中是有释放的。

通过这种排查方式，几经筛选，最终找到了一个可疑的 malloc 场景：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMavxlP7oWd7hMIw8G9eZr0nTvqofbvfR8xYrm3JuZTfrBenIU2N16IAMIoBDt7S3achBt5QDwyyxA/640?wx_fmt=png)

从调用栈信息可以知道，这是一个 JDK 中的本地方法 sun.nio.fs.UnixNativeDispatcher.opendir0，作用是打开一个目录，但后续始终没有进行关闭操作。进一步分析可知，该可疑 opendir 操作会周期性执行，而且都是操作同一个目录 "/xxx/nginx/etc/nginx/conf"，看来，是有个业务线程在定时访问 nginx 的配置目录，每次访问完却没有关闭打开的目录。

分析到这里，其实这个问题已经差不多水落石出。和业务方确认，存在一个定时器线程在周期性读取 nginx 的配置文件，代码大概是这样子的：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMavxlP7oWd7hMIw8G9eZr0nfP8vUgHPSiceiaWFIKL602aFoFs0nCVF6OhbyFctDQ4HTS6AUacnrJcQ/640?wx_fmt=png)

翻了一下相关 JDK 源码，Files.list 方法是有在末尾注册一个关闭钩子的：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMavxlP7oWd7hMIw8G9eZr0nNcDSwgicltBViboDGvtuO3jFKfZ75YibAGA0aIxooDCMckXLSTvTQp1hw/640?wx_fmt=png)

也就是说，Files.list 方法返回的目录资源是需要手动释放的，否则就会发生资源泄漏。

由于这个目录资源底层是会关联一个 fd 的，所以泄漏问题还可以通过另一个地方进行佐证：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMavxlP7oWd7hMIw8G9eZr0nOTbJ6mWNJwibSLxLsqXn92WzK5Yj8MH8MYM2CTIvics2WpVhN94xulbw/640?wx_fmt=png)

该业务进程目前已经消耗了 51116 个 fd！

假设这些 fd 都是 opendir 关联的，每个 opendir 消耗 32K，则总共消耗 1.6G，显然可以跟上面泄漏的内存值基本对上。

**总结：**

稍微了解了一下，发现几乎没人知道 JDK 方法 Files.list 是需要关闭的，这个案例算是给大家都提了个醒。

**后记：**

如果遇到相关技术问题（包括不限于毕昇 JDK），可以进入毕昇 JDK 社区查找相关资源（点击**阅读原文**进入官网），包括二进制下载、代码仓库、使用教学、安装、学习资料等。毕昇 JDK 社区每双周周二举行技术例会，同时有一个技术交流群讨论 GCC、LLVM、JDK 和 V8 等相关编译技术，感兴趣的同学可以添加如下微信小助手，回复 Compiler 入群。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMavxlP7oWd7hMIw8G9eZr0nicsJsrtdlJfDnadwer5w64PkjAc1LVxQYkqSYIfdiaaoSZ0cichyhd9zg/640?wx_fmt=png)

[阅读原文](http://bishengjdk.openeuler.org)
