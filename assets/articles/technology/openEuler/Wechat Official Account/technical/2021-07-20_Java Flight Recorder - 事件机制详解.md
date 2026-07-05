# [Java Flight Recorder - 事件机制详解](https://mp.weixin.qq.com/s/AQcgWIAJnjUYmM-KBnISVA)

*冯世杰*[OpenAtom openEuler](javascript:void%280%29;)*2021-07-20 18:00:00*

**编者按：**Java Flight Recorder（简称为JFR）曾经是 Oracle JDK 商业版的附属组件，在 JDK 11 中正式开源，后又被移植到 JDK8 中。JFR对应用的侵入性很小，同时又能提供应用运行时相对准确和丰富的信息；合理使用该工具可以极大地提高工作效率。本文剖析JFR的事件机制，希望能帮助大家从原理上理解 JFR ，进而能正确使用 JFR。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6FzNhhAnwaM62QqOdVgHTZ59MMKvXrDzrTwzsC8yescicaMApzWNZYczgg/640?wx_fmt=png)

1. 本篇文章中的源码大部分来自 openjdk8u262；
2. 本文出发点是梳理 JFR 的事件机制，侧重点在于理解而非应用

## **对于JFR我们有着怎样的预期**

JFR是一个辅助分析工具，我们希望借助它，尽可能低开销地收集运行时数据，从而辅助对 系统（包括应用和JVM）可能存在的故障、性能瓶颈进行分析。

结合 JFR 的 目标来看：

- 提供一些API用于产生数据或消费数据
- 提供缓存机制和二进制数据格式
- 允许配置和过滤事件
- 为 OS、JVM、JDK 库提供相应的事件

从中，我们能粗略地获取这些信息 ：

1. 事件以自描述的二进制形式(.jfr)被保存着
2. 事件中包含了数据，事件 ≈ 数据
3. .jfr 文件 =&gt; read by some Provided API =&gt; 重现运行时数据 \[ =&gt; 可视化]

我们想尝试了解 JFR的事件驱动机制，具体点就是回答几个问题：

**一个事件何时产生/启动监控？经历了怎样的路径？如何被保存？保存到哪里？**

## **JFR是事件驱动的**

本节主要是一些前置信息 （假如你有所了解，可以快速浏览或者跳过本节内容）：JVM行为基本都是Event，如类加载对应着Class Load Event，垃圾回收对应GC Event；Event 主要由timestamp, event name, additional info, data 这几部分组成。Event 收集四类事件的信息：

- Instant Event , 发生就收集（e.g. Thread Start ...）
- Duration Event, 持续收集一段时间（e.g. GC Event ...）
- Timed Event , 收集超过指定时间的事件
- Sample Event , 按频率采样

以JFR的 Class Load Event 为例, 看看一个事件的结构。（共计24 bytes）

: 98 80 80 00 87 02 95 ae e4 b2 92 03 a2 f7 ae 9a 94 02 02 01 8d 11 00 00

- Event Size : 98 80 80 00
- Event ID : 87 02
- TimeStamp : 95 ae e4 b2 92 03
- Duration : a2 f7 ae 9a 94 02
- Thread ID : 02
- Stack trace ID : 01
- PayLoad（记录的数据，fields 取决于各个 Event 类型）：

<!--THE END-->

- - 加载的类 : 8d 11
  - 定义类的 ClassLoader : 00
  - 初始化类的 ClassLoader : 00

多个线程都会产生 Event，线程通过无锁(Lock-free)设计记录事件。线程将事件首先写入到 ThreadLocalBuffer（简称TLB），TLB被填满后，将被转存到 Global buffer(circular)，对于较旧的数据，可以通过配置，选择丢弃或者写入磁盘，以便连续保存历史记录。示意图如下所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6Fzsv2PwptLUd0Jg0y4VTUQiaTCatZMt2IRS4ta5BsmTHEH3SJOxCZicGAA/640?wx_fmt=png)

注意：TLB、Global Buffer 和磁盘文件中的事件记录不会相互备份，未及时转存的数据可能发生丢失，本文不会就这点展开阐述。JFR更多信息可以参考JEP 328。

前置内容已经交代清楚，接着回到正轨。

# **一个事件的生命周期**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6FzW32ibiay1FDghXoSZUmr0SGDGYUZ0f0LLHUaRSkiaQiaMIo2NkENJepvww/640?wx_fmt=png)

以下是枯燥乏味的一堆代码，但是不得不看。首先来看 JFR 的结构，如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6FzJXdy8icq274ld40OhBwB2C3ggS3oiaaAp60nl6Kp6VotPhHVa2VYjIsQ/640?wx_fmt=png)

肉眼可见的一堆钩子，这些hook 用于记录对应的触发事件。  
我们简单地挑一个 Thread Start 的事件，关注一下它的整个被触发到被记录的过程。在线程创建并执行时会调用记录 JFR 事件，代码如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6FziaTbdceibQCb19G15c3yTK0tSELFYsbGPdfLMwOpDibLUCyJBRtJKqSmA/640?wx_fmt=png)

可见当一个新的Java 线程被创建时，只要开启了 JFR，那么就会执行上述代码；

接着看一下 on\_thread\_start 干了什么：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6FzRKBjgGsialy6qcS35ym6utiaFG0sLCiaI9N7ow7rDxVp9wAnoOq1anF2w/640?wx_fmt=png)

在此，我们看到了一个事件EventThreadStart ，并且在事件中设置信息后被提交。

在 JEP 328中有一个更为简单直接例子，如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6FzCknnpZZh1iadwf1Nb0QEzUFZvcQfEqZZz0yKdIOXH81L2vDLibic1H3Hw/640?wx_fmt=png)

无需太过关心其内容。我们只需关注这个事件生成的结构：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6FzgGPF3fZPgU7NG32HXOvgT3TMH4osza2lU7P9AiaCdPMrX4YeVGP6MYA/640?wx_fmt=png)

这里的 EventType 定义于 jfrEventClass.hpp, 该文件是编译时生成的，简单贴一下生成逻辑，可以参考 Makefile文件，如下 （同样无需在意太多细节）：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6FzptGX0geajB3ggIKNB1VTQTlapeYRIWB0hdjY0fbn6V3EdRfCoHzqyw/640?wx_fmt=png)

回到主旋律，继续来看事件的结构和成员函数，如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6Fz40mmHPrgLQ0qVe9UYjCheKD8vficKeUzMDaibRxcYgRUJbbW8laA8BKg/640?wx_fmt=png)

其中最为重要的成员函数是 JfrEvent::commit 方法，用于提交事件，代码如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6FzXkKRLCaI6gF3SUSJlHyibrN3RibP3UMh4tevBgAV7qJ0K86MA0Sv4LPg/640?wx_fmt=png)

在函数中，最后一段代码, 也是核心所在，用于真正记录事件：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6FzrqeDaUwfD4Jj1fRicYvXAfbHRic3uyhicLsxCTdfRQgic69IeYXYtZOkoQ/640?wx_fmt=png)

这下，就可以很容易地和第1节的内容对应上了，特别是其中的事件模型的图片：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6Fzsv2PwptLUd0Jg0y4VTUQiaTCatZMt2IRS4ta5BsmTHEH3SJOxCZicGAA/640?wx_fmt=png)

# **小结**

用户是否可以自定义一个JFR 事件？注意点有哪些？

这里通过JEP 328 里的例子（稍微有点改动），来展示如何自定义JFR 事件。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6Fziae1E6dSNafXiaxBic0Ws9bGqY5ciaHzutGfuDDicib4njW5UE4iatxfZ1LLQ/640?wx_fmt=png)

通过编译后直接执行如下命令：

```
$> java -XX:StartFlightRecording,filename=event.jfr Test
```

可以得到如下日志信息：

```
Started recording 1. No limit specified, using maxsize=250MB as default.Use jcmd 57980 JFR.dump name=1 to copy recording data to file.
```

```

```

日志可以通过标准的API 进行解析，下面通过一个简单代码解析上面生成的事件，代码如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6FzzRLOlA7V9WAOdrkma8xIsLW58BbmDx8YibY8ex7cSz2jGdlpvsMn06g/640?wx_fmt=png)

编译运行

```
$> java Viewer | less
```

可以得到如下结果。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6Fzr3qlmpvJOiaKicB87McXicRHfwLpTfYAKib076xrvqlVcWyebdkvPvu5sg/640?wx_fmt=png)

相信此时你已经对 JFR 的事件机制有了个不错的感觉。

实际上JFR 的使用一般配合 JMC\[1] 使用，在 JMC 中通过页面可以得到统计信息，更有助于判断系统的运行情况。

# **参考**

\[1] https://adoptopenjdk.net/jmc.html

# **后记**

如果遇到相关技术问题（包括不限于毕昇JDK），可以进入毕昇JDK社区查找相关资源（点击原文进入官网），包括二进制下载、代码仓库、使用教学、安装、学习资料等。毕昇JDK社区每双周周二举行技术例会，同时有一个技术交流群讨论GCC、LLVM、JDK和V8等相关编译技术，感兴趣的同学可以添加如下微信小助手，回复Compiler入群。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaEUuELhibU3yiaH0icuzXj6FzvibbseDnnkveJf6rIaWM9OY6L20bEpCFY9b9PF2Ez7oIUUkWDQvRwqA/640?wx_fmt=png)

[阅读原文](http://bishengjdk.openeuler.org)
