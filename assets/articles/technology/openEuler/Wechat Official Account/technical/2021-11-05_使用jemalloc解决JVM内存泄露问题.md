# [使用jemalloc解决JVM内存泄露问题](https://mp.weixin.qq.com/s/-u0psjtquiAdkh-reqw4dg)

原创*王坤*[OpenAtom openEuler](javascript:void%280%29;)*2021-11-05 23:27:45*

**编者按：JVM 发生内存泄漏，如何能快速定位到内存泄漏点并不容易。笔者通过使用 jemalloc（可以替换默认的 glibc 库）中的 profiling 机制（通过对程序的堆空间进行采样收集相关信息），演示了如何快速找到内存泄漏的过程。**

Java 的内存对象一般可以分为堆内内存、堆外内存和 Native method 分配的内存，对于前面两种内存，可以通过 JVM 的 GC 进行管理，而 Native method 则不受 GC 管理，很容易引发内存泄露。Native Method 导致的内存泄漏，无法使用 JDK 自带的工具进行分析，需要通过 malloc\_hook 追踪 malloc 的调用链帮助分析，一般可以采用内存分配跟踪工具（malloc tracing）协助分析内存泄漏。该工具的使用较复杂：需要修改源码，装载 hook 函数，然后运行修改后的程序，生成特殊的 log 文件，最后利用 mtrace 工具分析日志来确定是否存在内存泄露并分析可能发生内存泄露的代码位置。由于 hotspot 代码量较大，虽然可以通过一些选项逐步缩小可疑代码范围，但是修改代码总不是最优选择。另外，Valgrind 扫描也是一种常用的内存泄露分析工具，虽然 Valgrind 非常强大，但是 Valgrind 会报出很多干扰项，且使用较为麻烦。本文主要是介绍另一种分析 Native method 内存泄漏的方法，供大家参考。

jemalloc 是通过 malloc(3) 实现的一种分配器，代替 glibc 中的 malloc 实现，开发人员通过 jemalloc 的 Profiling 功能分析内存分配过程，可帮助解决一些 Native method 内存泄漏问题。

## 1 jemalloc 使用方法

jemalloc 使用方法的详细介绍，请参考本文附录章节。

## 2 使用 jemalloc 工具解决实际业务中遇到 Native method 内存泄漏问题

毕昇 JDK 某个版本内部迭代开发期间，在特性功能开发测试完毕后，进行 7\*24 小时长稳测试时发现开启 - XX:+UseG1GC 选项会导致内存迅速增加，怀疑 JVM 层面存在内存泄露问题。

Java 例子参考（例子仅作为帮助问题理解使用）：

```
import java.util.LinkedHashMap;

public class SystemGCTest {
    static int Xmx = 10;
    private static final int MB = 1024 * 1024;
    private static byte[] dummy;
    private static Integer[] funny;
    private static LinkedHashMap<Integer, Integer[]> map = new LinkedHashMap<>();

    public static void main(String[] args) {
        int loop = Integer.valueOf(args[0]);
        if (loop < 0) {
            loop = loop * -1;
            while (true) {
                doGc(loop);
                map.clear();
                System.gc();
            }
        } else {
            doGc(loop);
            map.clear();
            System.gc();
        }
    }

    private static void doGc(int numberOfTimes) {
        final int objectSize = 128;
        final int maxObjectInYoung = (Xmx * MB) / objectSize;
        for (int i = 0; i < numberOfTimes; i++) {
            for (int j = 0; j < maxObjectInYoung + 1; j++) {
                dummy = new byte[objectSize];
                funny = new Integer[objectSize / 16];
                if (j % 10 == 0) {
                    map.put(Integer.valueOf(j), funny);
                }
            }
        }
    }
}
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbyNGcKeibeGgJ5nkR4HckZfntiaxib6jfSa15HhhI2CyUtQEvwzibnracjTibKcTrTwOaxCjSN16S2iaSQ/640?wx_fmt=png)

上图是开启 - XX:+UseG1GC 选项，Java 进程内存增长曲线图。横坐标是内存使用的统计次数，每 10 分钟统计一次；纵坐标是 Java 进程占用物理内存的大小。从上图可以看出：物理内存持续增涨的速度很快，存在内存泄露问题。

我们在设置了 jemalloc 的环境下，重新运行该测试用例：

```
java -Xms10M -Xmx10M -XX:+UseG1GC SystemGCTest 10000
```

注意：10000 与 jemalloc 无关，是 SystemGCTest 测试用例的参数，java 是疑似存在内存泄漏的 Java 二进制文件。

程序启动后，会在当前目录下逐渐生成一些 heap 文件，格式如：jeprof.26205.0.i0.heap。jeprof 工具的环境变量设置正确后（可参考本文附录），开发可以直接执行 jeprof 命令查看运行结果，了解 jeprof 的使用方式。jeprof 可基于 jemalloc 生成的内存 profile 堆文件，进行堆文件解析、分析并生成用户容易理解的文件，工具使用方便。

下面我们通过上述内存泄露问题，简单介绍 jeprof 工具的典型使用方法。

jeprof 工具可以生成内存申请代码的调用路径图。上述 Java 例子运行一段时间后会产生一些 heap 文件，jeprof 可帮助开发者获取有助于分析的可视化文件。

方法 1，通过使用 jeprof 工具将这些 heap 文件转成 svg 文件，命令如下：

```
jeprof --show_bytes --svg /home/xxxx/jdk1.8.0_292/bin/java jeprof*.heap > app-profiling.svg
```

这里需要注意的是：/home/xxxx/jdk1.8.0\_292/bin/java 必须是绝对路径。

注意：执行生成 svg 文件的命令时，部分环境会遇到类似如下错误：

```
Dropping nodes with <= 2140452 B; edges with <= 428090 abs(MB)
 dot: command not found
```

该问题的解决方法，需要在环境中安装 graphviz 和 gv：

```
sudo apt install graphviz gv
```

安装成功后，再次执行方法 1 中命令，可以得到可视化 svg 文件。

测试用例执行三十分钟后，我们对最后十分钟的内存增长进行分析，结果发现：95.9% 的内存增长来自 G1DefaultParGCAllocator 的构造函数调用，这里的最后 10 分钟是和用例设置相关，如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbyNGcKeibeGgJ5nkR4HckZfKBQ1KCHYB57J7810DgZQ8wDutGqnLvtLRybCeBhxUeg1OP4vuspAiag/640?wx_fmt=png)

上图比较清晰显示了内存申请相关函数的调用关系以及内存申请比例和数量，约95.9% 的堆内存是通过 G1DefaultParGCAllocator 完成申请，可以预测在 G1DefaultParGCAllocator 的构造函数中申请的内存没有被及时回收掉而导致内存泄漏的可能性非常大。这个时候可以通过代码协助分析了。

jeprof 工具不仅可以查看详细信息或者生成调用路径图（如上图所示），还可以用来比较两个 dump 文件（显示增量部分），既然作为工具使用介绍，我们继续介绍另一种补充性分析方法：将连续两次的 heap 文件做差异对比，输出的 PDF 可视化文件可以进一步确定是哪里内存持续申请没有被释放而导致内存增长。

方法如下：

```
jeprof --base=jeprof.34070.0.i0.heap  --pdf /home/xxxx/jdk1.8.0_292/bin/java jeprof.34070.1.i1.heap > diff.pdf
```

内存增加差异图：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbyNGcKeibeGgJ5nkR4HckZf3PNALhoBibg7AgjQscPVNPxLAicdK2Qkjl5Ty1WiaJ1zcTGrGBKibIacXg/640?wx_fmt=png)

通过上图可以非常清晰看到：G1DefaultParGCAllocator 的构造函数持续申请内存，导致内存增长迅速。后续的工作就是针对 G1DefaultParGCAllocator 构造函数中内存申请情况，排查释放逻辑，寻找问题原因并解决，这块的工作不属于 jemalloc 范畴，本内容不再赘述。

代码修复后 Java 进程物理内存使用情况如下（运行 30 小时 +）：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbyNGcKeibeGgJ5nkR4HckZf4JQnoQF93QCyloDjOLibSRAPzqopmfU702wsy38JJPBnlgkt8N3iaDug/640?wx_fmt=png)

内存使用符合预期，问题解决。

通过 jemalloc 工具和上面介绍的方法，帮助开发快速解决了此特性引起 Native method 内存泄漏问题，方法使用简单。在实际业务中有遇到类似问题的同学，不妨亲自尝试一下。

## 附录 A jemalloc 的编译

jemalloc 普通版并不包含 profiling 机制，所以需要下载源代码重新编译，在 configure 的时候添加了 --enable-prof 选项，这样才能打开 profiling 机制。

**A.1 下载最新版本 jemalloc 源码**

```
git clone https://github.com/jemalloc/jemalloc.git
```

**A.2 jemalloc 源码构建**

1. 修改 autogen.sh 文件，使能 prof，如下：

```
diff --git a/autogen.sh b/autogen.sh
index 75f32da6..6ab4053c 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -9,8 +9,8 @@ for i in autoconf; do
     fi
 done

-echo "./configure --enable-autogen $@"
-./configure --enable-autogen $@
+echo "./configure --enable-prof $@"
+./configure --enable-prof $@
 if [ $? -ne 0 ]; then
     echo "Error $? in ./configure"
     exit 1
```

执行：

```
$ ./autogen.sh
$ make -j 6
```

以下命令可选：

```
$ make install
```

2. 源码构建成功后（一般不会出错），会在当前目录的 bin 和 lib 目录下生成重要的文件：

```
$ ls -l
total 376
-rw-rw-r-- 1 xxxx xxxx   1954 Jun 19 06:16 jemalloc-config
-rw-rw-r-- 1 xxxx xxxx   1598 Jun 19 06:12 jemalloc-config.in
-rw-rw-r-- 1 xxxx xxxx    145 Jun 19 06:16 jemalloc.sh
-rw-rw-r-- 1 xxxx xxxx    151 Jun 19 06:12 jemalloc.sh.in
-rw-rw-r-- 1 xxxx xxxx 182460 Jun 19 06:16 jeprof
-rw-rw-r-- 1 xxxx xxxx 182665 Jun 19 06:12 jeprof.in
$ cd ../lib/
$ ls -l
total 89376
-rw-rw-r-- 1 xxxx xxxx 42058434 Jun 19 06:19 libjemalloc.a
-rw-rw-r-- 1 xxxx xxxx 42062016 Jun 19 06:19 libjemalloc_pic.a
lrwxrwxrwx 1 xxxx xxxx       16 Jun 19 06:19 libjemalloc.so -> libjemalloc.so.2
-rwxrwxr-x 1 xxxx xxxx  7390832 Jun 19 06:19 libjemalloc.so.2
$ pwd
/home/xxxx/jemalloc/jemalloc/lib
```

3. 设置环境变量和执行权限

bin 目录下的 jeprof 文件，没有执行权限，需要设置一下：

```
bin$ chmod +x ./*
```

退到 bin 的上一层目录设置环境变量，可参考如下方法：

```
xxxx@hostname:jemalloc$ echo $JEMALLOC_DIR
 xxxx@hostname:jemalloc$ export JEMALLOC_DIR=`pwd`
 xxxx@hostname:jemalloc$ echo $JEMALLOC_DIR
 /home/xxxx/jemalloc/jemalloc
 xxxx@hostname:jemalloc$ export LD_PRELOAD=$JEMALLOC_DIR/lib/libjemalloc.so
 xxxx@hostname:jemalloc$ export MALLOC_CONF=prof:true,lg_prof_interval:30,lg_prof_sample:17
 xxxx@hostname:jemalloc$ which jeprof
 xxxx@hostname:jemalloc$ export PATH=$PATH:$JEMALLOC_DIR/bin
 xxxx@hostname:jemalloc$ which jeprof
 /home/xxxx/jemalloc/jemalloc/bin/jeprof
 xxxx@hostname:jemalloc$ jeprof --version
 jeprof (part of jemalloc 5.2.1-737-g2381efab5754d13da5104b101b1e695afb442590)
 based on pprof (part of gperftools 2.0)

 Copyright 1998-2007 Google Inc.

 This is BSD licensed software; see the source for copying conditions
 and license information.
 There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
 PARTICULAR PURPOSE.
```

到这一步，jeprof 可以在该环境中启动使用了。

## 后记

如果遇到相关技术问题（包括不限于毕昇 JDK），可以进入毕昇 JDK 社区查找相关资源（点击**阅读原文**进入官网），包括二进制下载、代码仓库、使用教学、安装、学习资料等。毕昇 JDK 社区每双周周二举行技术例会，同时有一个技术交流群讨论 GCC、LLVM、JDK 和 V8 等相关编译技术，感兴趣的同学可以添加如下微信小助手，回复 Compiler 入群。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbyNGcKeibeGgJ5nkR4HckZf9XKia1ETBgcfoVVsIdOeDILdmjBCzldOMBVWuoib8k3e2TvZ0cgFdATw/640?wx_fmt=png)

## 参考

1. https://chenhm.com/post/2018-12-05-debuging-java-memory-leak
2. https://github.com/jemalloc/jemalloc
3. https://blog.csdn.net/qq\_36287943/article/details/105491301
4. https://www.cnblogs.com/minglee/p/10124174.html
5. https://www.yuanguohuo.com/2019/01/02/jemalloc-heap-profiling

[阅读原文](http://bishengjdk.openeuler.org)
