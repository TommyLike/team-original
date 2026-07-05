# [「转」毕昇JDK 8 Dynamic CDS 特性介绍](https://mp.weixin.qq.com/s/teE3_JrvhFmCYRWJDERivA)

*马守兵、张一鹏*[OpenAtom openEuler](javascript:void%280%29;)*2022-12-02 20:00:00*

## 1 背景

JDK 5 中引入的 Class-Data Sharing (CDS) 技术允许将一组类预处理为共享存档文件，然后可以在运行时进行内存映射以减少启动时间。当多个 JVM 共享同一个归档文件时，它还可以减少内存占用。

在 OpenJDK 社区，CDS 技术发展有两个演进方向：

1. 扩大archive的类的范围：CDS **-&gt;** AppCDS **-&gt;** Dynamic CDS。
2. 扩大archive的数据种类：metadata（CDS、AppCDS、Dynamic AppCDS) **-&gt;** 基本类对象 **-&gt;** strings **-&gt;** module **-&gt;** Support for pre-generated java.lang.invoke classes in CDS archive。

Dynamic CDS特性（JEP 350: Dynamic CDS Archives\[1]）主要功能：

- 继续增加类共享的范围，提升共享类技术的收益
- 简化使用 AppCDS 时 dump classlist 的操作，直接在程序退出时 dump 内存中的类到 JSA 文件。

毕昇JDK 8 中实现的 Dynamic CDS 特性相比之前的 AppCDS ，增加了 Custom ClassLoader 的支持，扩展了共享类的支持范围；且该JDK版本带有基本类的 base JSA 文件，可以消除 dump classlist 的步骤，提高该特性的易用性。经测试，在使用此特性的情况下 SpringBoot 启动时间具有显著提升。

> 注：JEP 350 中 Dynamic CDS 增加支持的类（lambda、匿名类），毕昇JDK 8 暂时没有实现。

## 2 特性介绍

- Java 应用程序使用base JSA运行，在程序执行结束时对类进行动态归档生成top JSA，top JSA将包含base JSA以外所有可以共享的类(包含Custom ClassLoader加载的类)，共享类范围的扩大提供了更短的启动时间，而且Dynamic CDS对于额外共享的类采用重定位（relocate）到一个更加紧凑的内存空间以减少空间的浪费。
  
  > **base JSA：**使用CDS/AppCDS生成的类共享文件，当不指定其路径时，默认为：$JAVA\_HOME/jre/lib/&lt;platform&gt;/server/classes.jsa。  
  > **top JSA：**使用Dynamic CDS生成的类共享文件。
  
  ![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJUGicPX6fGezulFyNfiblhwQ8sCk3EsHkcp0jqWzvROOUbs1v5Glib2dgUYXOdribIibARbEMHI71T0FUg/640?wx_fmt=png)
  
  > 注：类数据区分为读写、只读，分别放置在RW、RO区。
- 此特性可以使用default JSA（JDK包中自带的基本类的JSA文件）作为base JSA，因此可以简化CDS特性使用步骤，生成top JSA后，运行程序时则同时将base JSA、top JSA映射到内存中以加速启动和节省内存。
  
  ![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJUGicPX6fGezulFyNfiblhwQ8yWnnPu7ic6G8EdqzBq5VYqcUUicgE8tVZ8mWThnfKLHIe4XSjC4ALtKw/640?wx_fmt=png)
- 此特性为保证Customer ClassLoader加载类的正确性，与AppClassLoader、ExtClassLoader在FindLoadedClass时直接由classLoader来查找共享类不同，其在DefineClass中的基本校验完毕后查询共享类。

## 3 使用说明

### 3.1 相关参数说明

分类选项含义运行时选项-Xshare:on该参数继承 CDS，使用共享文件-XX:+UnlockExperimentalVMOptions开启实验特性-XX:SharedArchiveFile用于用户首次启动时指定 base JSA 文件，其是生成 top JSA 的基础-XX:ArchiveClassesAtExit用户指定进程退出时生成 top JSA 文件路径。文件名支持按照进程号 %p 输出，可避免多JVM进程复写一份 top JSA，导致 top JSA 不可用日志开关-XX:InfoDynamicCDS打开级别为 info 的日志，可以通过 -XX:DynamicCDSLog=PATH 设置输出路径，默认为标准输出流-XX:DebugDynamicCDS打开级别为 debug 的日志，其余同上-XX:TraceDynamicCDS打开级别为 trace 的日志，其余同上

### 3.2 使用步骤

分为两个步骤：

1. 将可共享类的元数据（MetaData）dump 进文件；
2. 使用该文件执行 Java 程序。

下面以 HelloWorld 程序为例简单说明 Dynamic CDS 的用法。

预置条件：Java 程序 HelloWorld.class。

下面是每个步骤的命令行，相关参数说明请参见 JVM 参数说明。

**步骤一：生成 top JSA（依赖 base JSA ），实验特性开关需要使能**

```
java -XX:+UnlockExperimentalVMOptions -Xshare:on -XX:ArchiveClassesAtExit=top.jsa -XX:+InfoDynamicCDS HelloWorld
```

- 如果因为某些参数改变，导致 JDK 包中带的 default JSA 无法使用，请重新用 CDS/AppCDS 生成 base JSA。
- 非正常结束的进程，比如 kill -9 杀死进程，则无法生成 JSA，则需要通过 `jcmd <pid> GC.dynamic_cds_dump` 命令在进程结束之前生成。
- 可省略 -XX:SharedArchiveFile 参数，此时默认使用 `-XX:SharedArchiveFile=$JAVA_HOME/jre/lib/<platform>/server/classes.jsa` 文件。
- 因为生成 JSA 过程中会修改运行时数据，无法保证运行时正确，因此 dump top JSA 结束后直接退出进程。

**步骤二：使用 top JSA 运行 Java 程序**

```
java -XX:+UnlockExperimentalVMOptions -Xshare:on -XX:ArchiveClassesAtExit=top.jsa -XX:+InfoDynamicCDS HelloWorld
```

top JSA 中记录了 base JSA 的路径，可以在参数中只指明 top JSA 。如果 base JSA 路径在 top JSA 生成之后发生了改变，需要同时指明 base、top JSA 的路径：

```
java -Xshare:on -XX:SharedArchiveFile=base.jsa:top.jsa -XX:+InfoDynamicCDS HelloWorld
```

### 3.3 使用限制

1. **生成、使用JSA两阶段参数和环境PAGE\_SIZE必须一致**
   
   - restore阶段使用参数 -XX:ObjectAlignmentInBytes=32、16 时，运行时会报错，信息如下：
     
     ```
     Error occurred during initialization of VM
     Unable to use shared archive.
     An error has occurred while processing the shared archive file.
     The shared archive file's ObjectAlignmentInBytes of 8 does not equal the current ObjectAlignmentInBytes of 32.
     ```
     
     **错误原因：**因为生成 base JSA 时，ObjectAlignmentInBytes 默认为8，读取时不支持指定其他对齐参数。
     
     **解决方法：**重新使用 CDS/AppCDS 生成 base JSA 使用，生成时参数加入使用时对应的 -XX:ObjectAlignmentInBytes 的值即可。
   - 当dump时的系统环境变量pagesize小于使用时的pagesize，运行时会报错，信息如下：
     
     ```
     An error has occurred while processing the shared archive file.
     Unable to map ReadOnly shared space at required address.
     Error occurred during initialization of VM
     Unable to use shared archive.
     ```
     
     **错误原因：**page\_size 影响 JSA 文件中的数据对齐，系统无法为JSA文件恢复分配内存。
     
     **解决方法：**重新使用 CDS/AppCDS 在当前环境生成 JSA 使用即可。
2. **不支持关闭压缩指针**
   
   使用 CDS（restore）阶段使用参数 -XX:-UseCompressedOops 或 -XX:-UseCompressedClassPointers 时，运行时会报错，信息如下：
   
   ```
   Error occurred during initialization of VM
   Unable to use shared archive.: UseCompressedOops and UseCompressedClassPointers must be on for UseSharedSpaces.
   Class data sharing is inconsistent with other specified options.
   ```
   
   **错误原因：**目前 CDS 只支持压缩指针场景。
   
   **解决方法：**使用时应当开启压缩指针开关，后续会支持压缩指针关闭场景。
3. **最大堆地址值需小于32G（当使用默认参数 -XX:ObjectAlignmentInBytes=8）**
   
   使用 CDS（restore）阶段使用参数  和 （值 ）的组合，运行时会报错，信息如下：
   
   ```
   An error has occurred while processing the shared archive file.
   Unable to reserve shared space at required address 0x0000000800000000
   Error occurred during initialization of VM
   Unable to use shared archive.
   ```
   
   **错误原因：**JSA 文件的映射地址的堆区间，不能被参数所指定的JVM 其他组件占用。
   
   **解决方法：**将此组合值 改为小于 32 可正常运行。
4. **Dynamic CDS 不支持的共享类**
   
   - Java version1.5 以及之前的类不支持共享。
   - JVM anonymous class 不支持共享。
   - 如果基类不支持共享，则该类也不支持共享。
5. **Dynamic CDS 不支持 JFR**
   
   JFR组件启动过程会通过 asm 动态创建匿名类（anonymous class），与 Dynamic CDS 冲突。

## 4 性能测试

SpringBoot场景测试结果：

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJWPr8B1dCcRUO5OzAEqEsJQ6LznNaFBlu5zYzEiaKExpEz306IKaoZpyAsSLVJdfFM3jCpibepGunMw/640?wx_fmt=png)

**测试说明：**

经测试，使能 Dynamic CDS 特性相比于默认参数 java -jar spring-petclinic-2.5.0-SNAPSHOT.jar 启动效率会提升14.3％。

## 5 特性演进

后续毕昇JDK8 CDS特性将支持压缩指针关闭场景。

## 参考

1. https://openjdk.java.net/jeps/350

![](https://mmbiz.qpic.cn/mmbiz_gif/icntuIQtpSJUGicPX6fGezulFyNfiblhwQ8zf2rDCylDUMuia25JgSNZ8dPqzKpqXe9OickNlAp34oDY8ZXzVJIrgdA/640?wx_fmt=gif)

Compiler SIG 专注于编译器领域技术交流探讨和分享，包括 GCC/LLVM/OpenJDK 以及其他的程序优化技术，聚集编译技术领域的学者、专家、学术等同行，共同推进编译相关技术的发展。

扫码添加 SIG 小助手微信，邀请你进 Compiler SIG 微信交流群。

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJUGicPX6fGezulFyNfiblhwQ884dpIULWh0OQxuDy4tvfDNEIQPzZK0ckTtsqM2owWMpXV36k7vEAQA/640?wx_fmt=png)

点击 阅读原文 开始使用毕昇JDK

[阅读原文](https://www.hikunpeng.com/developer/devkit/compiler/jdk)
