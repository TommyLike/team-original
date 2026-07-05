# [「转」Native Memory Tracking 详解（2）∶追踪区域分析(一)](https://mp.weixin.qq.com/s/EzZME_2PizZoabo7LrzKDw)

*窦义望*[OpenAtom openEuler](javascript:void%280%29;)*2022-10-20 19:00:00*

上篇文章 [Native Memory Tracking 详解（1）:基础介绍](http://mp.weixin.qq.com/s?__biz=MzkyNTMwMjI2Mw%3D%3D&mid=2247489204&idx=1&sn=c3a9ac4f291543b3504cd1bc1adf0bdb&chksm=c1c9fa2cf6be733aefbbe707f0deb422cd5eddf0174f60daa1e7b4fc9c4029023f2f89d4e5c8&scene=21#wechat_redirect) 中，分享了如何使用NMT，以及NMT内存 & OS内存概念的差异性，本篇将介绍NMT追踪区域的部分内存类型——Java heap、Class、Thread、Code 以及 GC。

## 4.追踪区域内存类型

在上文中我们打印了 NMT 的相关报告，但想必大家初次看到报告的时候对其追踪的各个区域往往都是一头雾水，下面就让我们来简单认识下各个区域。

查看 JVM 中所设定的内存类型：

```
# hotspot/src/share/vm/memory/allocation.hpp
/*
 * Memory types
 */
enum MemoryType {
  // Memory type by sub systems. It occupies lower byte.
  mtJavaHeap          = 0x00,  // Java heap     //Java 堆
  mtClass             = 0x01,  // memory class for Java classes     //Java classes 使用的内存
  mtThread            = 0x02,  // memory for thread objects //线程对象使用的内存
  mtThreadStack       = 0x03,  
  mtCode              = 0x04,  // memory for generated code //编译生成代码使用的内存
  mtGC                = 0x05,  // memory for GC    //GC 使用的内存
  mtCompiler          = 0x06,  // memory for compiler  //编译器使用的内存
  mtInternal          = 0x07,  // memory used by VM, but does not belong to    //内部使用的类型
                                 // any of above categories, and not used for
                                 // native memory tracking
  mtOther             = 0x08,  // memory not used by VM  //不是 VM 使用的内存
  mtSymbol            = 0x09,  // symbol     //符号表使用的内存
  mtNMT               = 0x0A,  // memory used by native memory tracking    //NMT 自身使用的内存
  mtClassShared       = 0x0B,  // class data sharing  //共享类使用的内存
  mtChunk             = 0x0C,  // chunk that holds content of arenas //chunk用于缓存
  mtTest              = 0x0D,  // Test type for verifying NMT
  mtTracing           = 0x0E,  // memory used for Tracing
  mtNone              = 0x0F,  // undefined
  mt_number_of_types  = 0x10   // number of memory types (mtDontTrack
                                 // is not included as validate type)
};
```

除去这上面的部分选项，我们发现 NMT 中还有一个 unknown 选项，这主要是在执行 jcmd 命令时，内存类别还无法确定或虚拟类型信息还没有到达时的一些内存统计。

### 4.1 Java heap

```
[0x00000000c0000000 - 0x0000000100000000] reserved 1048576KB for Java Heap from
    [0x0000ffff93ea36d8] ReservedHeapSpace::ReservedHeapSpace(unsigned long, unsigned long, bool, char*)+0xb8    //reserve 内存的 call sites
    ......

 [0x00000000c0000000 - 0x0000000100000000] committed 1048576KB from
            [0x0000ffff938bbe8c] G1PageBasedVirtualSpace::commit_internal(unsigned long, unsigned long)+0x14c    //commit 内存的 call sites
            ......
```

无需多言，Java 堆使用的内存，绝大多数情况下都是 JVM 使用内存的主力，堆内存通过 mmap 的方式申请。0x00000000c0000000 - 0x0000000100000000 即是 Java Heap 的虚拟地址范围，因为此时使用的是 G1 垃圾收集器（不是物理意义上的分代），所以无法看到分代地址，如果使用其他物理分代的收集器（如CMS）：

```
[0x00000000c0000000 - 0x0000000100000000] reserved 1048576KB for Java Heap from
    [0x0000ffffa5cc76d8] ReservedHeapSpace::ReservedHeapSpace(unsigned long, unsigned long, bool, char*)+0xb8
    [0x0000ffffa5c8bf68] Universe::reserve_heap(unsigned long, unsigned long)+0x2d0
    [0x0000ffffa570fa10] GenCollectedHeap::allocate(unsigned long, unsigned long*, int*, ReservedSpace*)+0x160
    [0x0000ffffa5711fdc] GenCollectedHeap::initialize()+0x104

        [0x00000000d5550000 - 0x0000000100000000] committed 699072KB from
            [0x0000ffffa5cc80e4] VirtualSpace::initialize(ReservedSpace, unsigned long)+0x224
            [0x0000ffffa572a450] CardGeneration::CardGeneration(ReservedSpace, unsigned long, int, GenRemSet*)+0xb8
            [0x0000ffffa55dc85c] ConcurrentMarkSweepGeneration::ConcurrentMarkSweepGeneration(ReservedSpace, unsigned long, int, CardTableRS*, bool, FreeBlockDictionary<FreeChunk>::DictionaryChoice)+0x54
            [0x0000ffffa572bcdc] GenerationSpec::init(ReservedSpace, int, GenRemSet*)+0xe4

        [0x00000000c0000000 - 0x00000000d5550000] committed 349504KB from
            [0x0000ffffa5cc80e4] VirtualSpace::initialize(ReservedSpace, unsigned long)+0x224
            [0x0000ffffa5729fe0] Generation::Generation(ReservedSpace, unsigned long, int)+0x98
            [0x0000ffffa5612fa8] DefNewGeneration::DefNewGeneration(ReservedSpace, unsigned long, int, char const*)+0x58
            [0x0000ffffa5b05ec8] ParNewGeneration::ParNewGeneration(ReservedSpace, unsigned long, int)+0x60

```

我们可以清楚地看到 0x00000000c0000000 - 0x00000000d5550000 为 Java Heap 的新生代（DefNewGeneration）的范围，0x00000000d5550000 - 0x0000000100000000 为 Java Heap 的老年代（ConcurrentMarkSweepGeneration）的范围。

- 我们可以使用 -Xms/-Xmx 或 -XX:InitialHeapSize/-XX:MaxHeapSize 等参数来控制初始/最大的大小，其中基于低停顿的考虑可将两值设置相等以避免动态扩容缩容带来的时间开销（如果基于弹性节约内存资源则不必）。
- 可以如上文所述开启 -XX:+AlwaysPreTouch 参数强制分配物理内存来减少运行时的停顿（如果想要快速启动进程则不必）。
- 基于节省内存资源还可以启用 uncommit 机制等。

### 4.2 Class

Class 主要是类元数据（meta data）所使用的内存空间，即虚拟机规范中规定的方法区。具体到 HotSpot 的实现中，JDK7 之前是实现在 PermGen 永久代中，JDK8 之后则是移除了 PermGen 变成了 MetaSpace 元空间。

> 当然以前 PermGen 还有 Interned strings 或者说 StringTable（即字符串常量池），但是 MetaSpace 并不包含 StringTable，在 JDK8 之后 StringTable 就被移入 Heap，并且在 NMT 中 StringTable 所使用的内存被单独统计到了 Symbol 中。

既然 Class 所使用的内存用来存放元数据，那么想必在启动 JVM 进程的时候设置的 `-XX:MaxMetaspaceSize=256M` 参数可以限制住 Class 所使用的内存大小。

但是我们在查看 NMT 详情发现一个奇怪的现象：

```
Class (reserved=1056899KB, committed=4995KB)
                            (classes #442)          //加载的类的数目
                            (malloc=131KB #259) 
                            (mmap: reserved=1056768KB, committed=4864KB)
```

Class 竟然 reserved 了 1056899KB（约 1G ） 的内存，这貌似和我们设定的（256M）不太一样。

此时我们就不得不简单补充下相关的内容，我们都知道 JVM 中有一个参数：-XX:UseCompressedOops （简单来说就是在一定情况下开启指针压缩来提升性能），该参数在非 64 位和手动设定 -XX:-UseCompressedOops 的情况下是不会开启的，而只有在64位系统、不是 client VM、并且 max\_heap\_size &lt;= max\_heap\_for\_compressed\_oops（一个近似32GB的数值）的情况下会默认开启（计算逻辑可以查看 hotspot/src/share/vm/runtime/arguments.cpp 中的 Arguments::set\_use\_compressed\_oops() 方法）。

而如果 -XX:UseCompressedOops 被开启，并且我们没有手动设置过 -XX:-UseCompressedClassPointers 的话，JVM 会默认帮我们开启 UseCompressedClassPointers（详情可查看 hotspot/src/share/vm/runtime/arguments.cpp 中的 Arguments::set\_use\_compressed\_klass\_ptrs() 方法）。

我们先忽略 UseCompressedOops 不提，在 UseCompressedClassPointers 被启动之后，\_metadata 的指针就会由 64 位的 Klass 压缩为 32 位无符号整数值 narrowKlass。简单看下指向关系：

```
Java object                 InstanceKlass       
 [ _mark  ]                          
 [ _klass/_narrowKlass ] --> [ ...          ]  
 [ fields ]                  [ _java_mirror ] 
                             [ ...          ] 
                                   
（heap）                    （MetaSpace）
```

如果我们用的是未压缩过的 \_klass ，那么使用 64 位指针寻址，因此 Klass 可以放置在任意位置；但是如果我们使用压缩过的 narrowKlass （32位） 进行寻址，那么为了找到该结构实际的 64 位地址，我们不光需要位移操作（如果以 8 字节对齐左移 3 位），还需要设置一个已知的公共基址，因此限制了我们需要为 Klass 分配为一个连续的内存区域。

所以整个 MetaSpace 的内存结构在是否开启 UseCompressedClassPointers 时是不同的：

- 如果未开启指针压缩，那么 MetaSpace 只有一个 Metaspace Context(incl chunk freelist) 指向很多不同的 virtual space；
- 如果开启了指针压缩，Klass 和非 Klass 部分分开存放，Klass 部分放一个连续的内存区域 Metaspace Context(class) （指向一块大的连续的 virtual space），非 Klass 部分则依照未开启压缩的模式放在很多不同的 virtual space 中。这块 Metaspace Context(class) 内存，就是传说中的 **CompressedClassSpaceSize** 所设置的内存。

```
//未开启压缩

  +--------+  +--------+  +--------+  +--------+
  |  CLD   |  |  CLD   |  |  CLD   |  |  CLD   |
  +--------+  +--------+  +--------+  +--------+
      |           |           |           |       
      |           |           |           |       allocates variable-sized,
      |           |           |           |       typically small-tiny metaspace blocks 
      v           v           v           v  
  +--------+  +--------+  +--------+  +--------+
  | arena  |  | arena  |  | arena  |  | arena  |
  +--------+  +--------+  +--------+  +--------+
      |           |           |           |       
      |           |           |           |       allocate and, on death, release-in-bulk
      |           |           |           |       medium-sized chunks (1k..4m)
      |           |           |           |       
      v           v           v           v  
  +--------------------------------------------+
  |                                            |
  |         Metaspace Context                  |
  |          (incl chunk freelist)             |
  |                                            |
  +--------------------------------------------+
         |            |            |
         |            |            |              map/commit/uncommit/release
         |            |            |
         v            v            v
    +---------+  +---------+  +---------+
    |         |  |         |  |         |
    | virtual |  | virtual |  | virtual |
    | space   |  | space   |  | space   |
    |         |  |         |  |         |
    +---------+  +---------+  +---------+


//开启了指针压缩

        +--------+              +--------+
        |  CLD   |              |  CLD   |
        +--------+              +--------+
         /     \                 /     \          Each CLD has two arenas...             
        /       \               /       \       
       /         \             /         \      
      v           v           v           v             
  +--------+  +--------+  +--------+  +--------+
  | noncl  |  | class  |  | noncl  |  | class  |
  | arena  |  | arena  |  | arena  |  | arena  |
  +--------+  +--------+  +--------+  +--------+
      |              \      /            |       
      |               --------\          |        Non-class arenas take from non-class context,
      |                   /   |          |        class arenas take from class context
      |         /---------    |          |       
      v         v             v          v  
  +--------------------+  +------------------------+
  |                    |  |                        |
  | Metaspace Context  |  | Metaspace Context      |
  |     (nonclass)     |  |     (class)            |
  |                    |  |                        |
  +--------------------+  +------------------------+
         |            |            |
         |            |            |                    Non-class context: list of smallish mappings
         |            |            |                    Class context: one large mapping (the class space)
         v            v            v
  +--------+  +--------+  +----------------~~~~~~~-----+
  |        |  |        |  |                            |
  | virtual|  | virt   |  | virt space (class space)   |
  | space  |  | space  |  |                            |
  |        |  |        |  |                            |
  +--------+  +--------+  +----------------~~~~~~~-----+
```

> MetaSpace相关内容就不再展开描述了，详情可以参考官方文档 Metaspace - Metaspace - OpenJDK Wiki (java.net) \[1] 与 Thomas Stüfe 的系列文章 What is Metaspace? | stuefe.de \[2]。

我们查看 reserve 的具体日志，发现大部分的内存都是 Metaspace::allocate\_metaspace\_compressed\_klass\_ptrs 方法申请的，这正是用来分配 CompressedClassSpace 空间的方法：

```
[0x0000000100000000 - 0x0000000140000000] reserved 1048576KB for Class from
    [0x0000ffff93ea28d0] ReservedSpace::ReservedSpace(unsigned long, unsigned long, bool, char*, unsigned long)+0x90
    [0x0000ffff93c16694] Metaspace::allocate_metaspace_compressed_klass_ptrs(char*, unsigned char*)+0x42c
    [0x0000ffff93c16e0c] Metaspace::global_initialize()+0x4fc
    [0x0000ffff93e688a8] universe_init()+0x88
```

JVM 在初始化 MetaSpace 时，调用链路如下：

InitializeJVM **-&gt;**  
Thread::vreate\_vm **-&gt;**  
init\_globals **-&gt;**  
universe\_init **-&gt;**  
MetaSpace::global\_initalize **-&gt;**  
Metaspace::allocate\_metaspace\_compressed\_klass\_ptrs

查看相关源码：

```
# hotspot/src/share/vm/memory/metaspace.cpp

void Metaspace::allocate_metaspace_compressed_klass_ptrs(char* requested_addr, address cds_base) {
  ......
  ReservedSpace metaspace_rs = ReservedSpace(compressed_class_space_size(),
                                             _reserve_alignment,
                                             large_pages,
                                             requested_addr, 0);
  ......
      metaspace_rs = ReservedSpace(compressed_class_space_size(),
                                   _reserve_alignment, large_pages);
  ......
}
```

我们可以发现如果开启了 UseCompressedClassPointers ，那么就会调用 allocate\_metaspace\_compressed\_klass\_ptrs 方法去 reserve 一个 compressed\_class\_space\_size() 大小的空间（由于我们没有显式地设置过 -XX:CompressedClassSpaceSize 的大小，所以此时默认值为 1G）。如果我们显式地设置 `-XX:CompressedClassSpaceSize=256M` 再重启 JVM ，就会发现 reserve 的内存大小已经被限制住了：

```
Thread (reserved=258568KB, committed=258568KB)
                            (thread #127)
                            (stack: reserved=258048KB, committed=258048KB)
                            (malloc=390KB #711)
                            (arena=130KB #234)
```

但是此时我们不禁会有一个疑问，那就是既然 CompressedClassSpaceSize 可以 reverse 远远超过 -XX:MaxMetaspaceSize 设置的大小，那么 -XX:MaxMetaspaceSize 会不会无法限制住整体 MetaSpace 的大小？实际上 -XX:MaxMetaspaceSize 是可以限制住 MetaSpace 的大小的，只是 HotSpot 此处的代码顺序有问题容易给大家造成误解和歧义~

查看相关代码：

```
# hotspot/src/share/vm/memory/metaspace.cpp

void Metaspace::ergo_initialize() {
  ......
  CompressedClassSpaceSize = align_size_down_bounded(CompressedClassSpaceSize, _reserve_alignment);
  set_compressed_class_space_size(CompressedClassSpaceSize);

  // Initial virtual space size will be calculated at global_initialize()
  uintx min_metaspace_sz =
      VIRTUALSPACEMULTIPLIER * InitialBootClassLoaderMetaspaceSize;
  if (UseCompressedClassPointers) {
    if ((min_metaspace_sz + CompressedClassSpaceSize) >  MaxMetaspaceSize) {
      if (min_metaspace_sz >= MaxMetaspaceSize) {
        vm_exit_during_initialization("MaxMetaspaceSize is too small.");
      } else {
        FLAG_SET_ERGO(uintx, CompressedClassSpaceSize,
                      MaxMetaspaceSize - min_metaspace_sz);
      }
    }
  } 
......
}
```

我们可以发现如果 min\_metaspace\_sz + CompressedClassSpaceSize &gt; MaxMetaspaceSize 的话，JVM 会将 CompressedClassSpaceSize 的值设置为 MaxMetaspaceSize - min\_metaspace\_sz 的大小，即最后 CompressedClassSpaceSize 的值是小于 MaxMetaspaceSize 的大小的，但是为何之前会 reserve 一个大的值呢？因为在重新计算 CompressedClassSpaceSize 的值之前，JVM 就先调用了 set\_compressed\_class\_space\_size 方法将 compressed\_class\_space\_size 的大小设置成了未重新计算的、默认的 CompressedClassSpaceSize 的大小。还记得 compressed\_class\_space\_size 吗？没错，正是我们在上面调用 allocate\_metaspace\_compressed\_klass\_ptrs 方法时 reserve 的大小，所以此时 reserve 的其实是一个不正确的值，我们只需要将 set\_compressed\_class\_space\_size 的操作放在重新计算 CompressedClassSpaceSize 大小的逻辑之后就能修正这种错误。当然因为是 reserve 的内存，对真正运行起来的 JVM 并无太大的负面影响，所以没有人给社区报过这个问题，社区也没有修改过这一块逻辑。

如果你使用的 JDK 版本大于等于 10，那么你直接可以通过 NMT 看到更详细划分的 Class 信息（区分了存放 klass 的区域即 Class space、存放非 klass 的区域即 Metadata ）。

```
Class (reserved=1056882KB, committed=1053042KB)
    (classes #483)
    (malloc=114KB #629)
    (mmap: reserved=1056768KB, committed=1052928KB)
    (  Metadata:   )
    (    reserved=8192KB, committed=4352KB)
    (    used=3492KB)
    (    free=860KB)
    (    waste=0KB =0.00%)
    (  Class space:)
    (    reserved=1048576KB, committed=512KB)
    (    used=326KB)
    (    free=186KB)
    (    waste=0KB =0.00%)
```

### 4.3 Thread

线程所使用的内存：

```
Thread (reserved=258568KB, committed=258568KB)
                            (thread #127)           //线程个数
                            (stack: reserved=258048KB, committed=258048KB)   //栈使用的内存
                            (malloc=390KB #711) 
                            (arena=130KB #234)      //线程句柄使用的内存

    ......
    [0x0000fffdbea32000 - 0x0000fffdbec32000] reserved and committed 2048KB for Thread Stack from
    [0x0000ffff935ab79c] attach_listener_thread_entry(JavaThread*, Thread*)+0x34
    [0x0000ffff93e3ddb4] JavaThread::thread_main_inner()+0xf4
    [0x0000ffff93e3e01c] JavaThread::run()+0x214
    [0x0000ffff93cb49e4] java_start(Thread*)+0x11c
 
[0x0000fffdbecce000 - 0x0000fffdbeece000] reserved and committed 2048KB for Thread Stack from
    [0x0000ffff93cb49e4] java_start(Thread*)+0x11c
    [0x0000ffff944148bc] start_thread+0x19c
```

观察 NMT 打印信息，我们可以发现，此时的 JVM 进程共使用了127个线程，committed 了 258568KB 的内存。

继续观察下面各个线程的分配情况就会发现，每个线程 committed 了2048KB（2M）的内存空间，这可能和平时的认知不太相同，因为平时我们大多数情况下使用的都是x86平台，而笔者此时使用的是 ARM （aarch64）的平台，所以此处线程默认分配的内存与 x86 不同。

如果我们不显式的设置 -Xss/-XX:ThreadStackSize 相关的参数，那么 JVM 会使用默认的值。

在 aarch64 平台下默认为 2M：

```
# globals_linux_aarch64.hpp

define_pd_global(intx, ThreadStackSize,          2048); // 0 => use system default
define_pd_global(intx, VMThreadStackSize,        2048);
```

而在 x86 平台下默认为 1M：

```
# globals_linux_x86.hpp

define_pd_global(intx, ThreadStackSize,          1024); // 0 => use system default
define_pd_global(intx, VMThreadStackSize,        1024);
```

如果我们想缩减此部分内存的使用，可以使用参数 -Xss/-XX:ThreadStackSize 设置适合自身业务情况的大小，但是需要进行相关压力测试保证不会出现溢出等错误。

### 4.4 Code

JVM 自身会生成一些 native code 并将其存储在称为 codecache 的内存区域中。JVM 生成 native code 的原因有很多，包括动态生成的解释器循环、 JNI、即时编译器(JIT)编译 Java 方法生成的本机代码 。其中 JIT 生成的 native code 占据了 codecache 绝大部分的空间。

```
Code (reserved=266273KB, committed=4001KB)
                            (malloc=33KB #309) 
                            (mmap: reserved=266240KB, committed=3968KB)
    ......
    [0x0000ffff7c000000 - 0x0000ffff8c000000] reserved 262144KB for Code from
    [0x0000ffff93ea3c2c] ReservedCodeSpace::ReservedCodeSpace(unsigned long, unsigned long, bool)+0x84
    [0x0000ffff9392dcd0] CodeHeap::reserve(unsigned long, unsigned long, unsigned long)+0xc8
    [0x0000ffff9374bd64] codeCache_init()+0xb4
    [0x0000ffff9395ced0] init_globals()+0x58

 [0x0000ffff7c3c0000 - 0x0000ffff7c3d0000] committed 64KB from
            [0x0000ffff93ea47e0] VirtualSpace::expand_by(unsigned long, bool)+0x1d8
            [0x0000ffff9392e01c] CodeHeap::expand_by(unsigned long)+0xac
            [0x0000ffff9374cee4] CodeCache::allocate(int, bool)+0x64
            [0x0000ffff937444b8] MethodHandlesAdapterBlob::create(int)+0xa8
```

追踪 codecache 的逻辑：

```
# codeCache.cpp
void CodeCache::initialize() {
  ......
  CodeCacheExpansionSize = round_to(CodeCacheExpansionSize, os::vm_page_size());
  InitialCodeCacheSize = round_to(InitialCodeCacheSize, os::vm_page_size());
  ReservedCodeCacheSize = round_to(ReservedCodeCacheSize, os::vm_page_size());
  if (!_heap->reserve(ReservedCodeCacheSize, InitialCodeCacheSize, CodeCacheSegmentSize)) {
    vm_exit_during_initialization("Could not reserve enough space for code cache");
  }
  ......
}

# virtualspace.cpp
//记录 mtCode 的函数，其中 r_size 由 ReservedCodeCacheSize 得出
ReservedCodeSpace::ReservedCodeSpace(size_t r_size,
                                     size_t rs_align,
                                     bool large) :
  ReservedSpace(r_size, rs_align, large, /*executable*/ true) {
  MemTracker::record_virtual_memory_type((address)base(), mtCode);
}
```

可以发现 CodeCache::initialize() 时 codecache reserve 的最大内存是由我们设置的 -XX:ReservedCodeCacheSize 参数决定的（当然 ReservedCodeCacheSize 的值会做一些对齐操作），我们可以通过设置 -XX:ReservedCodeCacheSize 来限制 Code 相关的最大内存。

同时我们发现，初始化时 codecache commit 的内存可以由 -XX:InitialCodeCacheSize 参数来控制，具体计算代码可以查看 VirtualSpace::expand\_by 函数。

我们设置 -XX:InitialCodeCacheSize=128M 后重启 JVM 进程，再次查看 NMT detail：

```
Code (reserved=266273KB, committed=133153KB)
                            (malloc=33KB #309) 
                            (mmap: reserved=266240KB, committed=133120KB) 
    ......
 [0x0000ffff80000000 - 0x0000ffff88000000] committed 131072KB from
            [0x0000ffff979e60e4] VirtualSpace::initialize(ReservedSpace, unsigned long)+0x224
            [0x0000ffff9746fcfc] CodeHeap::reserve(unsigned long, unsigned long, unsigned long)+0xf4
            [0x0000ffff9728dd64] codeCache_init()+0xb4
            [0x0000ffff9749eed0] init_globals()+0x58
```

我们可以通过 -XX:InitialCodeCacheSize 来设置 codecache 初始 commit 的内存。

> - 除了使用 NMT 打印 codecache 相关信息，我们还可以通过 -XX:+PrintCodeCache （JVM 关闭时输出codecache的使用情况）和 jcmd pid Compiler.codecache（只有在 JDK 9 及以上版本的 jcmd 才支持该选项）来查看 codecache 相关的信息。
> - 了解更多 codecache 详情可以查看 CodeCache 官方文档 \[3]。

### 4.5 GC

GC 所使用的内存，就是垃圾收集器使用的数据所占据的内存，例如卡表 card tables、记忆集 remembered sets、标记栈 marking stack、标记位图 marking bitmaps 等等。其实不论是 card tables、remembered sets 还是 marking stack、marking bitmaps，都是一种借助额外的空间，来记录不同内存区域之间引用关系的结构（都是基于空间换时间的思想，否则寻找引用关系就需要诸如遍历这种浪费时间的方式）。

简单介绍下相关概念：

> 更详细的信息不深入展开介绍了，可以查看彭成寒老师《JVM G1源码分析和调优》2.3 章 \[4] 与 4.1 章节 \[5]，还可以查看 R大（RednaxelaFX）对相关概念的科普 \[6]。

- 卡表 card tables，在部分收集器（如CMS）中存储跨代引用（如老年代中对象指向年轻代的对象）的数据结构，精度可以有很多种选择：
  
  如果精确到机器字，那么往往描述的区域太小了，使用的内存开销会变大，所以 HotSpot 中选择 512KB 为精度大小。
  
  卡表甚至可以细到和 bitmap 相同，即使用 1 bit 位来对应一个内存页（512KB），但是因为 JVM 在操作一个 bit 位时，仍然需要读取整个机器字 word，并且操作 bit 位的开销有时反而大于操作 byte 。所以 HotSpot 的 cardTable 选择使用 byte 数组代替 bit ，用 1 byte 对应 512KB 的空间，使用 byte 数组的开销也可以接受（1G 的堆内存使用卡表也只占用2M：1 * 1024 * 1024 / 512 = 2048 KB）。
  
  我们以 cardTableModRefBS 为例，查看其源码结构：
  
  ```
  # hotspor/src/share/vm/momery/cardTableModRefBS.hpp
  
  //精度为 512 KB
  enum SomePublicConstants {
   card_shift                  = 9,
   card_size                   = 1 << card_shift,
   card_size_in_words          = card_size / sizeof(HeapWord)
  };
  ......
  class CardTableModRefBS: public ModRefBarrierSet {
      .....
      size_t          _byte_map_size;    // in bytes
      jbyte*          _byte_map;         // the card marking array
      .....
  }
  ```
  
  可以发现 cardTableModRefBS 通过枚举 SomePublicConstants 来定义对应的内存块 card\_size 的大小即：512KB，而 \_byte\_map 则是用于标记的卡表字节数组，我们可以看到其对应的类型为 jbyte（typedef signed char jbyte，其实就是一个字节即 1byte）。
  
  > 当然后来卡表不只记录跨代引用的关系，还会被 CMS 的增量更新之类的操作复用。
  
  - 字粒度：精确到机器字（word），该字包含有跨代指针。
  - 对象粒度：精确到一个对象，该对象里有字段含有跨代指针。
  - card粒度：精确到一大块内存区域，该区域内有对象含有跨代指针。
- 记忆集 remembered sets，可以选择的粒度和卡表差不多，或者你说卡表也是记忆集的一种实现方式也可以（区别可以查看上面给出的 R大的链接）。G1 中引入记忆集 RSet 来记录 Region 间的跨代引用，G1 中的卡表的作用并不是记录引用关系，而是用于记录该区域中对象垃圾回收过程中的状态信息。
- 标记栈 marking stack，初始标记扫描根集合时，会标记所有从根集合可直接到达的对象并将它们的字段压入扫描栈（marking stack）中等待后续扫描。
- 标记位图 marking bitmaps，我们常使用位图来指示哪块内存已经使用、哪块内存还未使用。比如 G1 中的 Mixed GC 混合收集算法（收集所有的年轻代的 Region，外加根据global concurrent marking 统计得出的收集收益高的部分老年代 Region）中用到了并发标记，并发标记就引入两个位图 PrevBitMap 和 NextBitMap，用这两个位图来辅助标记并发标记不同阶段内存的使用状态。

查看 NMT 详情：

```
......
    [0x0000fffe16000000 - 0x0000fffe17000000] reserved 16384KB for GC from
        [0x0000ffff93ea2718] ReservedSpace::ReservedSpace(unsigned long, unsigned long)+0x118
        [0x0000ffff93892328] G1CollectedHeap::create_aux_memory_mapper(char const*, unsigned long, unsigned long)+0x48
        [0x0000ffff93899108] G1CollectedHeap::initialize()+0x368
        [0x0000ffff93e68594] Universe::initialize_heap()+0x15c

        [0x0000fffe16000000 - 0x0000fffe17000000] committed 16384KB from
                [0x0000ffff938bbe8c] G1PageBasedVirtualSpace::commit_internal(unsigned long, unsigned long)+0x14c
                [0x0000ffff938bc08c] G1PageBasedVirtualSpace::commit(unsigned long, unsigned long)+0x11c
                [0x0000ffff938bf774] G1RegionsLargerThanCommitSizeMapper::commit_regions(unsigned int, unsigned long)+0x5c
                [0x0000ffff93943f8c] HeapRegionManager::commit_regions(unsigned int, unsigned long)+0xb4
......            
```

我们可以发现 JVM 在初始化 heap 堆的时候（此时是 G1 收集器所使用的堆 G1CollectedHeap），不仅会创建 remember set ，还会有一个 create\_aux\_memory\_mapper 的操作，用来给 GC 辅助用的数据结构（如：card table、prev bitmap、 next bitmap 等）创建对应的内存映射，相关操作可以查看 g1CollectedHeap 初始化部分源代码：

```
# hotspot/src/share/vm/gc_implementation/g1/g1CollectedHeap.cpp

jint G1CollectedHeap::initialize() {
  ......
  //创建 G1 remember set
  // Also create a G1 rem set.
  _g1_rem_set = new G1RemSet(this, g1_barrier_set());
  ......
  
  // Create storage for the BOT, card table, card counts table (hot card cache) and the bitmaps.
  G1RegionToSpaceMapper* bot_storage =
    create_aux_memory_mapper("Block offset table",
                             G1BlockOffsetSharedArray::compute_size(g1_rs.size() / HeapWordSize),
                             G1BlockOffsetSharedArray::N_bytes);

  ReservedSpace cardtable_rs(G1SATBCardTableLoggingModRefBS::compute_size(g1_rs.size() / HeapWordSize));
  G1RegionToSpaceMapper* cardtable_storage =
    create_aux_memory_mapper("Card table",
                             G1SATBCardTableLoggingModRefBS::compute_size(g1_rs.size() / HeapWordSize),
                             G1BlockOffsetSharedArray::N_bytes);

  G1RegionToSpaceMapper* card_counts_storage =
    create_aux_memory_mapper("Card counts table",
                             G1BlockOffsetSharedArray::compute_size(g1_rs.size() / HeapWordSize),
                             G1BlockOffsetSharedArray::N_bytes);

  size_t bitmap_size = CMBitMap::compute_size(g1_rs.size());
  G1RegionToSpaceMapper* prev_bitmap_storage =
    create_aux_memory_mapper("Prev Bitmap", bitmap_size, CMBitMap::mark_distance());
  G1RegionToSpaceMapper* next_bitmap_storage =
    create_aux_memory_mapper("Next Bitmap", bitmap_size, CMBitMap::mark_distance());

  _hrm.initialize(heap_storage, prev_bitmap_storage, next_bitmap_storage, bot_storage, cardtable_storage, card_counts_storage);
  g1_barrier_set()->initialize(cardtable_storage);
   // Do later initialization work for concurrent refinement.
  _cg1r->init(card_counts_storage);
  ......
}
```

因为这些辅助的结构都是一种空间换时间的思想，所以不可避免的会占用额外的内存，尤其是 G1 的 RSet 结构，当我们调大我们的堆内存，GC 所使用的内存也会不可避免的跟随增长：

```
# -Xmx1G -Xms1G
GC (reserved=164403KB, committed=164403KB)
                            (malloc=92723KB #6540) 
                            (mmap: reserved=71680KB, committed=71680KB)

# -Xmx2G -Xms2G
GC (reserved=207891KB, committed=207891KB)
                            (malloc=97299KB #12683)
                            (mmap: reserved=110592KB, committed=110592KB)

# -Xmx4G -Xms4G
GC (reserved=290313KB, committed=290313KB)
                            (malloc=101897KB #12680)
                            (mmap: reserved=188416KB, committed=188416KB)

# -Xmx8G -Xms8G
GC (reserved=446473KB, committed=446473KB)
                            (malloc=102409KB #12680)
                            (mmap: reserved=344064KB, committed=344064KB)
```

我们可以看到这个额外的内存开销一般在 1% - 20%之间，当然如果我们不使用 G1 收集器，这个开销是没有那么大的：

```
# -XX:+UseSerialGC -Xmx8G -Xms8G

GC (reserved=27319KB, committed=27319KB)
                            (malloc=7KB #79)
                            (mmap: reserved=27312KB, committed=27312KB)

# -XX:+UseConcMarkSweepGC -Xmx8G -Xms8G 

GC (reserved=167318KB, committed=167318KB)
                            (malloc=140006KB #373)
                            (mmap: reserved=27312KB, committed=27312KB)
```

我们可以看到，使用最轻量级的 UseSerialGC，GC 部分占用的内存有很明显的降低（436M -&gt; 26.67M）；使用 CMS ，GC 部分从 436M 降低到 163.39M。

GC 这块内存是必须的，也是我们在使用过程中无法压缩的。停顿、吞吐量、内存占用就是 GC 中不可能同时达到的三元悖论，不同的垃圾收集器在这三者中有不同的侧重，我们应该结合自身的业务情况综合考量选择合适的垃圾收集器。

由于篇幅有限，将在下篇文章继续给大家分享 追踪区域的其它内存类型（包含Compiler、Internal、Symbol、Native Memory Tracking、Arena Chunk 和 Unknown）以及 NMT 无法追踪的内存，敬请期待！

## 参考

1. https://wiki.openjdk.java.net/display/HotSpot/Metaspace
2. https://stuefe.de/posts/metaspace/what-is-metaspace
3. https://docs.oracle.com/javase/8/embedded/develop-apps-platforms/codecache.htm
4. https://weread.qq.com/web/reader/53032310717f44515302749k3c5327902153c59dc0488e1
5. https://weread.qq.com/web/reader/53032310717f44515302749ka1d32a6022aa1d0c6e83eb4
6. https://hllvm-group.iteye.com/group/topic/21468#post-272070

![](https://mmbiz.qpic.cn/mmbiz_gif/icntuIQtpSJXUyTyTeY5tRCtuQtiaAduIpUmqlso0gadaTBibGic8qwzzN69eRxto5MfQa38QP91PuDuLqKFRxFibHQ/640?wx_fmt=gif)

欢迎加入Compiler SIG交流群与大家共同交流学习编译技术相关内容，扫码添加小助手微信邀请你进入Compiler SIG交流群。

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJXUyTyTeY5tRCtuQtiaAduIpr2ibDgbZwQrUia9g13orVicMgw0icooENUd516iaAniboiaXW7Owbz78h4yNA/640?wx_fmt=png)
