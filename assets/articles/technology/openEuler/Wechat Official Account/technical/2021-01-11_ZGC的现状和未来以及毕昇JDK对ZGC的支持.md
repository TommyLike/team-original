# [ZGC的现状和未来以及毕昇JDK对ZGC的支持](https://mp.weixin.qq.com/s/xB3AwKCAO9lrJmOYfzo-eQ)

原创*彭成寒*[OpenAtom openEuler](javascript:void%280%29;)*2021-01-11 08:31:17*

Z Garbage Collect，简称ZGC，早期是Oracle的一个内部项目，在2017年Oracle公司决定将ZGC进行开源。在JDK11（JDK在本文中特指Oracle公司发布的JDK，下同）时，ZGC代码正式合入到主干分支，成为一款标准的官方垃圾回收器。ZGC发布时，由于功能、性能等方面均不完全成熟，所以是一款“实验性质”的垃圾回收器。在经过了JDK的4个迭代开发之后，在JDK15中，ZGC正式升级为一款可用于生产环境的垃圾回收器。

JDK中已经包含了不少的垃圾回收器实现，例如Parallel Scavenge（简称PS）， Concurrent-Mark-Sweep（简称CMS）， Garbage First（简称G1）等。为什么ZGC能够被引入到JDK中？

ZGC的定位是一款可扩展性、低时延的垃圾回收器，它的主要目标有3个，分别是：

1. 支持超大堆内存（TB级别），目前ZGC可以支持堆内存的范围在8MB到16TB之间
2. 最大停顿时间在毫秒级，即不超过10毫秒
3. 停顿时间不会随着堆内存的增加而增加

注：垃圾回收执行时，需要识别垃圾对象，并将活跃对象进行移动。为了防止垃圾回收器和应用程序同时访问内存，造成内存访问的不一致性，在垃圾回收过程需要应用暂停运行，应用程序暂停运行的时间被称为停顿时间。

ZGC算法介绍

对于一款垃圾回收器来说支持TB级别内存也许并不困难，但是要想在TB级别的内存空间中，在毫秒级别停顿时间完成垃圾回收则是不可想象的。例如在一台配置一般的机器上，通常直接通过memcpy这样的函数进行内存复制的速度大概在GB/sec这样的水平。而垃圾回收过程需要大量的复制内存，在TB级别的堆空间完成数百GB或者几TB的内存复制，但把停顿时间控制在毫秒级别，听起来完全不可能。那么ZGC是怎么做到的呢？最关键的一点就是并发处理。并发处理贯穿在整个垃圾回收的全过程，ZGC的垃圾回收分为3个阶段：标记（Mark）、转移（Relocate）、重定位（Remap）。ZGC对这个3个阶段都采用了并发处理，只有在必须暂停的地方才会暂停应用的执行。这3个阶段完成的主要功能分别是：

- 标记：识别堆内存空间中的活跃对象
- 转移：将内存空间中的活跃对象转移到一块新的内存空间中，对象原来的空间已被回收
- 重定位：对象的位置发生了变化，对象的引用关系应该更新，确保对象之间的引用都指向对象新的位置

另外在算法实现中，标记阶段和重定位阶段都是针对活跃对象进行的。当活跃对象转移完成以后，当在对活跃对象进行重定位的同时标记活跃对象。这样就把上一次垃圾回收阶段的重定位和本次垃圾回收的标记进行合并，从而优化了垃圾回收的执行过程。ZGC中3个阶段执行示意图如下所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMby1NVcCHslrh29TYhfTQaDbX4MCol1FVS1bZ4u6e7DiaQaRUVA1Fs9dE9grvYNqQOkxRVuvTvp9RQ/640?wx_fmt=png)

要完美的支持并发的标记和转移并非易事，为了方便的支持并发，ZGC中引入了Colored Pointer和Load Barrier技术。

所谓的Colored Pointer机制指的是ZGC将不同阶段的对象放在地址空间中，通过地址位来标记对象所处的空间，然后不同的地址空间映射到同一物理空间中。以16TB的堆在aarch64系统为例，地址空间划分如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMby1NVcCHslrh29TYhfTQaDSLaDs7RteeDx19oqG032lMdaia7CfTNafIhsoECZX5zTC1kVhyR4Ljw/640?wx_fmt=png)

地址空间的区分通过地址位实现，如下所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMby1NVcCHslrh29TYhfTQaDv9ibkHc3PoAEmnJ04HN8ib1rUOia413frZHsUcAVE0tGd8JR7VfJwqaeg/640?wx_fmt=png)

3个逻辑视图对应同一物理视图在ZGC中是一个非常巧妙的设计。这里通过一个例子介绍一下这3个视图的作用，如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMby1NVcCHslrh29TYhfTQaDZicIF3B5jsYaHUv6QWabU08ul8enW6gnTdutn6G8nO1V4VUT49O925w/640?wx_fmt=png)

假定在初始阶段地址视图为Remapped，此时产生的对象都位于Remapped空间，按照图3的介绍，第46地址位会被设置为1.当ZGC执行垃圾回收时，此时将进入标记阶段，假设标记阶段地址视图为Marked0，即第44地址位为1.这意味在标记阶段完成后，所以活跃对象的地址的第44位都被设置1.假设一个对象在Remapped视图产生，在标记完成地址视图变成Marked0，一般的做法是将Remapped视图中的对象复制到Marked0，而复制是非常耗时的，所以ZGC不希望发生真实的对象复制，而是把不同的地址视图映射到同一物理空间，当需要从Remapped到Marked0复制是，仅仅把地址位的第46设置0，同时把第44位设置为1，这就和对象真的复制一样的结果，从而大大的节约了时间。

ZGC里面有两个标记视图Marked0和Marked1是为了区别上一次标记和本次标记对象是否仍然存活。具体不进一步展开，可以参考相关书籍和文献。

在垃圾回收（也称为Collector）和应用线程（也称为Mutator）并发访问同一对象时，为了正确处理一致性，ZGC采用了“目标空间”一致性的做法。即当Collector和Mutator访问对象时，都保证它们访问的是对象的目标空间的对象，也就是说当对象的发生空间变化时，首先进行空间变化然后再访问对象。这里就用到了Load Barrier技术，Load Barrier会执行额外的动作确保对象都位于目标空间，Load Barrier是否执行额外动作的前提是访问对象的视图是否符合预期。当对象的视图符合预期时，Load Barrier不会执行额外的动作，这也称为Good Path；当对象的视图不符合预期时才会执行额外的动作，也称为Slow Path。对于Slow Path来说不同阶段执行的动作不同，在标记/重定位阶段，Load Barrier可能会执行标记/重定位的动作，在转移阶段，Load Barrier可能会执行转移的动作。关于Load Barrier更详细的介绍，可以参考相关书籍和文献。

除了并发执行这个特点之外，ZGC在内存管理时采用了分区的管理形式，使得内存的管理更为灵活。同时完善了NUMA-Aware的功能，在NUMA系统中能取得更好的性能。

ZGC发展历程的关键里程

从2018年9月JDK11发布到2020年9月JDK15发布，ZGC是整个JDK中合入功能最多的特性。社区对于ZGC的认可度也越来越高，部分公司已经开始在生产环境尝试使用ZGC，并且取得不错的效果。下面稍微梳理一下ZGC在过去2年的5个版本中发布的重要功能。

1. JDK11：在该版本中，ZGC作为实验性中的垃圾回收器引入。在初始发布中，ZGC仅支持Linux平台，且仅仅支持运行在64位系统之上。但在该版本中ZGC的整体框架已经全部实现，包括Colored Pointer，Load Barrier， NUMA-Aware等重要功能。
2. JDK12：ZGC引入了一个最主要的功能，并发类卸载。从而大大降低了停顿时间。
3. JDK13：引入了aarch64的支持，此时ZGC可以运行在x64和ARM平台的Linux之上。另外ZGC为了迎合现代云场景的诉求，加入了内存释放（归还给操作系统）的功能。
4. JDK14：该版本最终的功能就是支持在x64平台的Windows和MacOS系统，从而使得多个平台可以使用ZGC。
5. JDK15：该版本中ZGC成为一个生产可用的垃圾回收器。在该版本中增加了通用功能的支持，例如支持压缩指针（在小内存下性能更优），支持Class Data Sharing，支持堆空间使用NVRAM等。使得ZGC功能完备。

在将于2021年3月发布的JDK16中，ZGC还将增加一个功能：并发线程栈扫描。这个特性将进一步的减少停顿时间。

华为毕昇JDK对ZGC的支持

由于Oracle公司对于JDK发布策略的变化，目前JDK11是一个长期支持版本（Long Term Support，简称LTS），而JDK12、13、14、15都是功能特性合入的开发版本，这些开发版本在新的版本发布之后都不在继续维护。下一个LTS的版本是2021年月的JDK17。由于JDK发布策略的变化，在JDK的升级和使用方面，大家趋向于使用LTS版本，而非开发版本。目前JDK存在两个LTS：JDK8和JDK11。

另外Oracle公司对于JDK的使用策略也发生了变化，对于商业环境中使用JDK8U202之后的版本都需要购买Oracle的License（Oracle的云产品或者Oracle授权产品除外），目前License的价格大概是25美金/processor。如果在商业环境中使用JDK8U202之后的版本，但并未付费，是违反Oracle公司对于JDK的商业协议，可能会收到来自Oracle公司的诉求。

JDK的开发是以OpenJDK项目为基础，而OpenJDK项目是完全开源的（许可证是 GPLv2+CE，也就是说使用者可以根据OpenJDK的源码开发自己的JDK，并开源自研的JDK）。

基于上述原因以及其他外部原因，华为公司也基于OpenJDK开发了自己的产品：毕昇JDK，目前毕昇JDK已经在码云上开源。毕昇JDK致力于维护安全、稳定、高效的JDK。目前对于LTS的JDK8和JDK11都进行投入了大量的人力和物力。毕昇JDK全部通过JCK、FUZZ，JTreg等测试套。毕昇JDK运行在华为内部500多个产品上，积累了大量使用场景和Java开发者反馈的问题和诉求，解决了业务实际运行中遇到的多个问题，并在ARM架构上进行了性能优化，毕昇JDK运行在大数据等场景下可以获得更好的性能。

这里以ZGC为例，稍微介绍几个毕昇JDK11相对于JDK11做了哪些工作。

- 支持aarch64。在JDK11中ZGC仅支持x64平台，毕昇JDK11是目前所有开源JDK中唯一支持x64和aarch64的产品。
- Bug修复。在整个运行和维护过程中，修复了一些bug，这些bug有些是社区在JDK14或者JDK15进行修复，有些我们是将社区的修复方案回合到毕昇JDK11，有些是我们在毕昇JDK11重新做了实现。举一个简单的例子，在我们的测试中发现，对于某些测试用例对于G1 GC和ZGC运行结果不一致，经过案例分析，对汇编代码进行跟踪，最终发现在ZGC的C1支持中对于浮点数寄存器使用有误，据此进行了修复。在毕昇JDK11上ZGC稳定性远远超过JDK11，可以在生产环境中使用。

ZGC的未来发展点

ZGC作为低时延垃圾回收器的杰出代表，正在努力将停顿时间减少到几毫秒。目前正在开发的是并发栈扫描。在当前的实现中栈作为垃圾回收的根集合之一，在扫描时需要暂停Mutator的执行。并发栈扫描是指Collector和Mutator都可以扫描栈，从而完成根集合处理，这将大大减少因为线程过多、调用栈复杂导致过长的停顿时间。由于Collector和Mutator并发访问栈，为了保持栈访问的一致性，引入了所谓watermark机制，该机制本质上也是一种barrier，ZGC的barrier通过记录SP的地址来判断操作运行栈是否发生变化。当然在并发处理中还需要考虑栈对象的完整性，比如参数、异常处理都会影响扫描栈的对象。并发栈扫描可以简单的总结为，当Mutator在接受到暂停请求后，会将栈顶的栈帧进行遍历，并设置watermark。当暂停结束后，如果Mutator访问栈帧，根据栈帧的SP和watermark进行比较，根据栈的增长方向可以判断栈帧是新栈帧（以及扫描或者新创建的栈帧）还是老栈帧（尚未扫描的栈帧），对于老栈帧Mutator会扫描“当前”正在栈帧（为了保证Mutator的正常运行，Mutator仅仅扫描“当前”栈帧，这里当前是指当前运行的完整的栈帧，为了便于处理参数和异常可能会额外扫描调用者的栈帧），扫描完成后Mutator继续执行，而把栈帧继续扫描的任务留给Collector。

ZGC非常完美的实现了低时延的需求，把尽可能的工作并发执行，在并发执行的时候，通常需要Mutator“帮助”Collector，完成本应该由Collector完成的工作，也就说Mutator除了完成应用代码的执行还需要做一些额外的辅助工作，由于Mutator不能专心执行应用代码，这会造成ZGC在吞吐率方面的不足。另外目前ZGC是单代回收，更加放大了ZGC的吞吐率不足的缺点。要解决吞吐率的问题，通常的是方法是实现分代回收。另外一种方法是线程局部回收（即Thread Local Garbage Collection，简称为TLGC），TLGC来说天然对于多核的系统更为友善。TLGC的核心思想是：每个Mutator在发现内存不足时，优先回收Mutator自己分配的内存。TLGC的另一个好处是不需要全局的暂停，故不会增加停顿时间。在实际应用中，Mutator分配的对象可能被另外一个Mutator使用，这就所谓的逃逸对象，对于逃逸对象在TLGC中不能回收。这里逃逸分析还会涉及到真逃逸、假逃逸，所谓假逃逸指的是对象可以被另外一个Mutator看到，但是在实际运行过程中并未访问。所以TLGC的核心是一套高效的逃逸分析技术，包含准确的识别假逃逸。

目前华为毕昇JDK团队正在设计和实现ZGC的分代和TLGC。期望不久的将来大家可以在毕昇JDK中看到这些特性。

参考文献

1. ZGC官网信息：https://wiki.openjdk.java.net/display/zgc/
2. 毕昇JDK11码云地址:https://gitee.com/openeuler/bishengjdk-11
3. 图书《新一代垃圾回收器ZGC设计与实现》——彭成寒

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMatRzJgDKxzkb8gsqm9MstYn8W6fMhbPtZKBZFQM7j9KhZ9R0HcHFftFOibVjmusW1797xCFSUD0nw/640?wx_fmt=png)

**openEuler —— 最具活力的开源社区**
