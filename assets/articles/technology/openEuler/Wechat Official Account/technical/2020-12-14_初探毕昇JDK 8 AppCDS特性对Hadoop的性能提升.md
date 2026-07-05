# [初探毕昇JDK 8 AppCDS特性对Hadoop的性能提升](https://mp.weixin.qq.com/s/EoECyH3chqNeor2Temq-IA)

*郑振宇*[OpenAtom openEuler](javascript:void%280%29;)*2020-12-14 18:00:00*

      

在最新发布的openEuler 20.09中，默认的JDK采用了最新开源的毕昇JDK，它与OpenJDK有什么不同？能为用户带来什么好处？笔者带大家尝尝鲜。

**毕昇JDK**

毕昇JDK是华为在openEuler社区开源的一个开源项目，目前包括毕昇JDK 8和毕昇JDK 11两个版本，分别对应于OpenJDK 8和OpenJDK 11。其中除了都对ARM架构进行了稳定性和性能优化之外，每个版本还各提供了一个特殊优化；其中毕昇JDK 8中提供了 AppCDS(Application Class-Data Sharing)的功能，而毕昇JDK 11中则提供了ZGC垃圾回收器的支持；

由于笔者目前工作主要涉及到的开源项目都还在使用Java 8（Hadoop 2.x支持Java8和Java7，Hadoop 3.x仅支持Java8），因此本次主要对毕昇JDK 8及其所提供的AppCDS功能进行了验证。

接下来，我们将首先了解一下什么是AppCDS以及其使用方法，然后将其应用在Hadoop中，通过运行TeraSort程序，来验证一下其在实际场景中的作用。

**AppCDS**

AppCDS(Application Class-Data Sharing)主要是用来在不同的JVM中共享Class-Data信息，从而提升应用程序的启动速度。类似的功能其实早在JDK1.5版本就存在了，叫做 CDS（Class-Data Sharing）。CDS特性只局限于BootstrapClassLoader层级的class-data共享，对性能的提升非常有限，并且是作为商用特性，OpenJDK并不能使用；在后续的Java 10版本中，Oracle将 CDS 扩展为 AppCDS，顾名思义，AppCDS 不止能够作用于 Boot Class Loader，App Class Loader 和自定义的 Class Loader 也都能够起作用，大大加大了 CDS 的适用范围。但是对于目前还在使用普遍使用Java 8的各主流开源项目来说，就没有办法享用到这个功能了，因此毕昇JDK将AppCDS带到JDK 8，对于广大用户来说，还是非常实用的。

接下来，我们结合几幅图来进一步了解一下AppCDS的原理和使用方法：

![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2Gspyic8gU0RRQFh6rvJYKAM0vf8XZs5KcxWS8SxwXX8f2pRJnsTxlalJxWe2txDRHiars4VdeZL4gw/640?wx_fmt=jpeg)

如上图所示，为了执行一个Java程序JVM会把编写好的Java代码都编译成字节码，存储在class文件当中。当我们运行一个Java程序的时候，JVM会加载这些class文件，并解释执行。这个加载过程是通过类加载器来进行的；默认的类加载器有三种，层次从高到低，分别是BootstrapClassLoader，ExtClassLoader，AppClassLoader，他们分别负责加载不同类型的类。在启动JVM的时候，类加载工作会占用一定的时间，如果我们同时运行多个Java进程，也就是启动了多个JVM，每一个JVM都重复加载许多相同的字节码，就会浪费许多无谓的时间。

因此，我们自然而然地会想到将这些共同的部分共享起来。因此也就诞生了上面说到的CDS和AppCDS。对于打包好的jar包来说，只要jar的内容不变，那么jar包中的类的数据始终是相同的。JVM在启动时候每次都会运行相同的加载步骤。

![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2Gspyic8gU0RRQFh6rvJYKAMKp8FyDJYRp8iaMvXQa4nW6cMOichj3dAG4yQ9JeLQEUAQMVU2M0c38LQ/640?wx_fmt=jpeg)

图片来源：http://blog.gilliard.lol/presentations/VirtualJUG-March-2018-Java-in-a-World-of-Containers.html

在毕昇JDK 8中使用AppCDS主要需要使用以下几个JVM参数：

1. **-Xshare**
   
   **-Xshare:off** 不打开共享功能，默认为off，但指定此参数后，便可以通过DumpLoadedClassList参数导出ClassList文件
   
   **-Xshare:dump** 导入共享文件，由SharedClassListFile指定需要共享的类列表，由SharedArchiveFile指定导入的JSA文件
   
   **-Xshare:on** 使用共享文件，由SharedArchiveFile指定JSA文件
   
   **-Xshare:auto** 尝试Xshare:on，如果失败，自动修改为Xshare:off

2\. **-XX:+UseAppCDS**

默认CDS(只共享系统类)，打开-XX:+UseAppCDS即支持AppCDS，除支持共享系统类，还支持应用类

接下来我们实际操作一下，看看AppCDS有何效果：

笔者首先编写了一个最简单的Java程序，HelloWorld.java，并对其进行编译，得到了HelloWorld.class，接下来就进入到使用AppCDS使用的第一步，生成共享类列表文件(hello.lst文件)：

```
java -Xshare:off -XX:+UseAppCDS -XX:DumpLoadedClassList=hello.lst HelloWorld
```

查看文件目录，我们可以看到我们生成了hello.lst文件

![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2Gspyic8gU0RRQFh6rvJYKAMAt8QgzdqhJ4Plhakx3XHKOF2OK5td1MoSqVoZzkR3LkJGiaXDQD8Bxw/640?wx_fmt=jpeg)

查看一下这个文件里面的具体内容：

![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2Gspyic8gU0RRQFh6rvJYKAM0WyiceiaNtqMTeeSiceFkyWTAqvK9c8OibvjWv49ZzDtZ8s07gRc8l8lrw/640?wx_fmt=jpeg)

我们可以看到，这个文件是一个列表文件，里面保存了我们运行HelloWorld这个程序所需要加载的类，其中可以看到，除了一些基础的类之外，有我们的HelloWorld。

接下来，进入到第二步，生成共享文件(根据hello.lst生成hello.jsa):

```
java -Xshare:dump -XX:+UseAppCDS -XX:SharedClassListFile=hello.lst -XX:SharedArchiveFile=hello.jsa HelloWorld
```

![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2Gspyic8gU0RRQFh6rvJYKAMeSWN5YcX2pg8RiatDuiaMBVfHReDjE3gIrCznicALX0d7lW1cIXyHh5Xw/640?wx_fmt=jpeg)

同第一步一样，我们查看一下执行的结果：

![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2Gspyic8gU0RRQFh6rvJYKAMJO9tGLnpELmbOo16bziaolCCPib82DypQ8ia8cxeNmlMSWnkHqVMF8GZA/640?wx_fmt=jpeg)

可以看到，除了之前都存在的文件之外，我们又生成了一个大小为3.9M的hello.jsa，这个文件就是AppCDS为我们生成的共享文件，一个最简单的HelloWorld在启动时JVM就需要加载3.9M的各个类，还是很大的，可以料想AppCDS应该还是十分有用的。

接下来就是最后一步，使用共享文件执行Java程序：

```
java -Xshare:on -XX:+UseAppCDS -XX:SharedArchiveFile=hello.jsa HelloWorld
```

为了能够看出AppCDS的实际效果，笔者这里编写了两个Python脚本，分别使用AppCDS和不使用AppCDS运行HelloWorld 1000次：

![](https://mmbiz.qpic.cn/mmbiz_png/uibibeLNgibX2Gspyic8gU0RRQFh6rvJYKAMNRl1jN5KGz8JGX3B0AibhMMNplwdtibsKrTf8Cg3yUSjiaLOD05ZeEDaw/640?wx_fmt=png)

可以看到，AppCDS提供了大约40%的性能提升，还是非常可观的。

**毕昇JDK8 + AppCDS in Hadoop**

上面我们对毕昇JDK 8中的AppCDS特性进行了简单的分析和使用，通过HelloWorld程序证明其确实可以减少JVM加载类的耗时，从而提升大量重复运行的程序的整体性能。接下来我们就看一看在实际的应用中AppCDS会有怎样的效果。

由于笔者近期的工作接触Hadoop比较多，所以自然就想到在Hadoop中验证一下AppCDS的效果；Hadoop包括HDFS，YARN，MapReduce三个主要部分，其中HDFS负责存储，YARN负责资源调度，MapReduce则负责实际的计算部分；MapReduce包括若干计算流程，从下面的MapReduce流程图可以看到，除了必要的信息交换外，红框中的部分是进行实际的计算过程的；在实际使用中，Map Task 和 Reduce Task使用的是相同的Java程序，根据不同的调用来进行不同的计算，并且是大量重复出现的，因此AppCDS大有用武之地。![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2Gspyic8gU0RRQFh6rvJYKAMeDGhMRPc6b2vjictFE86hJ3pIs4O8Nic2xLtmMSXZNVzEKoN2icvLfBpQ/640?wx_fmt=jpeg)

其实Hadoop项目本身也早就发现了类似的优化点，为了避免频繁创建JVM在初始化阶段浪费大量时间，Hadoop MapReduce提供了“mapred.job.reuse.jvm.num.tasks”参数来使得多个task可以串行的在同一个JVM上执行。但是AppCDS与这个功能相比有点还是非常明显的：

1\. Hadoop Reuse JVM是以Job为单位的，也就是只能在同一个Job内共享JVM；而AppCDS是全局共享的；设想一下，通常一份MapReuce程序是可以用在多个Job上的，当使用AppCDS时，分次提交的多个Job是可以享受到共享带来的提速的，而使用Hadoop Reuse JVM则不行。

2\. Hadoop Reuse JVM是串行的在JVM上执行，也就是说假如我们有10个Core，需要执行100个Task，那么我们可以创建10个JVM，这100个Task是会分成10批，每批并行的10个在这10个JVM上执行，当这一批执行完之后，下一批会重用这10个JVM。但是当我们有100个Core时，其实最有效率的方法是创建100个JVM，并发的跑这100个Task，那么Reuse JVM其实是没有实际作用的。而AppCDS则是每次创建JVM都可以得到提速的。

接下来，我们就实际操作一下，看看AppCDS在Hadoop中的实际效果。我们首先通过上文中的方法生成相应的terasort.jsa共享文件，并发放到Hadoop集群中的每个节点。

![](https://mmbiz.qpic.cn/mmbiz_png/uibibeLNgibX2Gspyic8gU0RRQFh6rvJYKAMdDxhJyz5ZASyBaXNdY43S7UCpO75Zp4cu0l5F3aK2yicu96XeicDT54Q/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2Gspyic8gU0RRQFh6rvJYKAMRfia9pOrcDaHhJ1icAcpviaZ3IibRr8h8es36TD1KXIyUuZNicia8pF9DhnQ/640?wx_fmt=jpeg)

我们可以看到，对Hadoop自带的terasort示例程序，**所生成的terasort.jsa共享文件有35M大，并且通过查看terasort.lst文件我们可以看到预先加载的Java类有快4400个**，数量还是很大的。

接下来我们通过实际运行几组TeraSort来看一下具体的效果。我们首先在一台华为云上的鲲鹏虚拟机上测试一下进行10G TeraSort的性能分析。我使用的这台虚拟机有8个Core，16G的内存，部署了Pseudo-Distributed模式的单节点Hadoop，在使用毕昇JDK 8并开启AppCDS、使用毕昇JDK 8不开启AppCDS、使用OpenJDK 8三种场景下各运行5次，并分析用时情况（在测试中，我们的Reduce Task个数遵照0.95\*Max Usable CPU的建议设定）：

![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2Gspyic8gU0RRQFh6rvJYKAMXIffMakd21TnfGcXZmLYtEALBQv4gZ0TJFkvte5tTur96jrJ7TOWhQ/640?wx_fmt=jpeg)

![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2Gspyic8gU0RRQFh6rvJYKAMzOD5Rg8FV5PxC3EKeaOj0yWdJ8ibp7jviaibdxrTTGevibzpdicZfzqteCA/640?wx_fmt=jpeg)

通过图表我们可以看到，在这个场景下，毕昇JDK 8在不开启AppCDS的情况下相对于OpenJDK 8来说在Aarch64平台上有大约3%的性能提升。而毕昇JDK开启AppCDS相对于不开启AppCDS大约有7%的性能提升；也就是说毕昇JDK开启AppCDS和OpenJDK 8来说有大约10%的性能提升，还是很可观的。

看完了单节点部署，我们再看一下多节点集群中的情况，在这个场景中，我将依次在1至5个节点所组成的Hadoop集群上进行50G的TeraSort，同样也分别采用上面的三种JDK模式，各运行10次并进行数据分析。

![](https://mmbiz.qpic.cn/mmbiz_jpg/uibibeLNgibX2Gspyic8gU0RRQFh6rvJYKAMYplaIdzaVVIcARpLhVBVgALoZvV4ibULJXG5PTUftuuekDuic0cEZxjQ/640?wx_fmt=jpeg)

上图中的柱状图展示了各模式下的运行耗时，曲线则展示了三种模式下的耗时比例，黄色曲线代表毕昇JDK 8开启AppCDS与OpenJDK 1.8的耗时比，红色代表毕昇JDK 8开启AppCDS与不开启的耗时比，而绿色的代表毕昇JDK 8不开启AppCDS与OpenJDK 8的耗时比。

分析上面的图表，我们可以看到：

1\. 总的来说，随着集群规模的扩大，任务耗时逐渐下降，但下降率逐渐减小；

2\. 毕昇JDK 8在不开启AppCDS的情况下，相对于OpenJDK 8有稳定的性能提升，性能提升随集群规模的扩大而扩大，但是基本保持线性；

3\. 毕昇JDK 8在开启AppCDS的情况下，相对于OpenJDK 8以及不开启AppCDS有较为明显的性能提升，同时随着集群规模的扩大优势逐渐扩大，并且下降率有曲线的趋势；**在5节点集群中，相对于OpenJDK8整体性能提升达到了约13.5%**。笔者分析**这是由于随着集群规模的扩大，能够并行执行Task越来越多，需要启动的JVM也越来越多，因此JVM初始化的耗时在整体耗时中所占的比重也越来越大，而AppCDS所提供的优化恰好能够优化这部分时间，也就是说随着规模的扩大AppCDS的优势也变得更明显**。

**写在最后**

笔者通过对毕昇JDK 8的AppCDS简单分析和在Hadoop集群上的简单验证，初步验证了AppCDS功能对Hadoop集群性能的积极影响。当然，Hadoop本身提供的TeraSort示例程序与实际生产中所用到的MapReduce有很大的区别；同时，笔者也是在默认配置的情况下进行的简单验证，Hadoop和JVM有众多的参数能够影响到整体的性能。笔者能力有限，若上述内容中有错误或纰漏，还希望各位看官轻喷。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZMicFFrkD3yM53lmCroibC8LN7R0Wurfdv8icZvazKnuD8g4sCYx1YzOiaNsIPAUaozuInz904S36BibA/640?wx_fmt=jpeg)

[阅读原文](https://zhuanlan.zhihu.com/p/335488378)
