# [openEuler Kernel技术解读 ｜ kaslr内核安全特性](https://mp.weixin.qq.com/s/Wue2Z4dm_11p9-q8GYm3dw)

*Kernel SIG*[OpenAtom openEuler](javascript:void%280%29;)*2022-03-01 18:07:47*

kaslr全称为kernel address space layout randomization，是linux内核的一个非常重要的安全机制，该机制可以让kernel image映射的执行地址相对于链接地址有个偏移，使内核符号地址变得随机，提升内核的安全性和防攻击能力。

## kaslr实现原理

Linux内核支持arm、x86\_64、PowerPC等多种不同的架构，不同的架构下，kaslr的实现方式各不相同，但核心思想均在于增加随机偏移。在内核启动阶段，通过获取一个随机值，并对内核加载地址进行相应的随机偏移。该偏移值既可以通过dtb传递，也可以基于随机源生成，在完成内核数据随机映射之后，还需要对符号地址进行重定位，校正内核代码的符号寻址，以此确保内核代码的正常执行。以arm64 5.10内核为例，kaslr在实现时主要通过改变原先固定的内存布局来提升内核安全性，因此在代码实现过程中，kaslr与内存功能存在比较强的耦合关系，Linux内存的虚拟地址空间布局与内核编译配置有关，不同的配置会产生不同的地址空间模型，以4KB pages + 4 levels (48-bit)为例，其虚拟地址空间模型如下：(详细的内存布局信息可参考内核文档：Documentation/arm64/memory.rst)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyA5GZ9FIaTD0KiaW2Qa0pCagxd07LOLVqYBRhQtFSKeOpsNK1uiaRSibm502AXQWl9crwpdnrxiaAVA/640?wx_fmt=png)

如图所示，Arm64的虚拟地址空间整体可划分为两个部分：内核地址空间和用户地址空间，通常内核地址空间由内核代码分配使用，所有进程共享内核地址空间，而用户地址空间则为用户态进程独占。内核启动阶段，内核镜像的加载、解压和运行均在内核地址空间完成，kaslr也主要在这里对内核内存布局进行随机调整，arm64的内存布局随机主要分为三部分：内核镜像随机、线性映射区随机以及module随机，在随机过程中需要提供随机种子，随机种子生成如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyA5GZ9FIaTD0KiaW2Qa0pC4Dswc0Cx3U6YTnIRd5yia9WT7n65AicdX28ic0mEvOmvXxfiaIZ8jxJ76A/640?wx_fmt=png)

Arm64的随机种子通过dtb文件获取，因此会为dtb区域建立映射，从dtb文件解析kaslr-seed的属性配置，同时会获取dtb里面的command line配置，判断是否存在nokaslr配置参数，当不存在随机种子或者配置了nokaslr参数时，kaslr功能会被关闭，并修改相应的kaslr\_status状态变量为KASLR\_DISABLED\_CMDLINE或者KASLR\_DISABLED\_NO\_SEED。  由dtb文件获取到kaslr-seed配置后，会对种子进行处理，基于不同的处理方式，分别用于镜像、线性区和module区域的随机，如下图：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyA5GZ9FIaTD0KiaW2Qa0pCOlRw9MQ24XCXcgaMQhKtG1HPcZyJrEc0SzHVyGd88FpvpUxVMDRsFQ/640?wx_fmt=png)

offset为镜像随机偏移值，内核需要保证偏移地址2M对齐，同时通过（VA\_BITS\_MIN - 2）限制内核随机范围在vmalloc区域中间的一半，避免使用头部和尾部的1/4区域，以避免跟其他的内存分配特性冲突。memstart\_offset\_seed为线性区的随机种子，内核使用seed的高16位作为线性区域的随机值。  Arm64在内存初始化时，内核会将物理内存通过线性映射的方式完整映射到虚拟地址空间的线性映射区域，如下图：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyA5GZ9FIaTD0KiaW2Qa0pCN5C1g2XCaIbWicQEzEujkby1u3x7icibLKOsia8U7CzSmMmXJOLep35VHA/640?wx_fmt=png)

随机范围是线性区减去物理内存的大小，同时限制偏移粒度ARM64\_MEMSTART\_ALIGN（256MB），线性区的使用主要涉及virt\_to\_phys和phys\_to\_virt两个地址转换接口，其代码实现如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyA5GZ9FIaTD0KiaW2Qa0pCEzYlEJnGjn1TkrOECz76JyEGZdRfUL1NolNIER2qkADJYxF4NKoG2g/640?wx_fmt=png)

以virt\_to\_phys为例，通过virt\_to\_phys的接口实现，可以看出memstart\_addr为物理地址的起始值，PAGE\_OFFSET为虚拟地址中内核地址空间的起始位置，物理地址与虚拟地址之间存在以下转换关系：物理地址 = 虚拟地址 – PAGE\_OFFSET + memstart\_addr 因此内核可以通过调整memstart\_addr的值来进行线性区的映射关系的随机偏移。  Kernel系统启动初期，\_\_primary\_switched函数调用kaslr\_early\_init函数初始化随机偏移值，并保存在x23寄存器当中，实现如下图：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyA5GZ9FIaTD0KiaW2Qa0pCZfn1bOjwcftnkGtgoxJYnkKiaLKjOCqO0twATpwCziar9QX4STk5Dvng/640?wx_fmt=png)

后续进行kernel image虚拟地址映射，会将内核映射的虚拟地址加上kaslr随机偏移（x23寄存器）,如下图：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyA5GZ9FIaTD0KiaW2Qa0pC0zMh4WGV3Feic2UlK405Bv0pBVt4ibswz4JsDtOccyA6F9KH3jEep5gw/640?wx_fmt=png)

完成kernel image虚拟地址映射以后，需要调用\_\_relocate\_kernel进行重定位，函数实现如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyA5GZ9FIaTD0KiaW2Qa0pCCtaf85fAw0gEEibqQOBicKicdDJ3NX8CEzNNEvVh2YH4kw9Pib2GkyUVgw/640?wx_fmt=png)

\_\_relocate\_kernel主要对重定位段进行符号重定位，重定位段包含了内核执行过程中需要用到的变量符号，比如\_stext、\_etext，这些符号对应的地址在链接时确定的，使能kaslr之后，kernel image经过偏移映射，运行时的虚拟地址与编译确定的原始虚拟地址不同，如果不进行重定位操作，则内核无法正常执行。

## kaslr特性使能和调试

**使能条件**

1. kaslr功能通过CONFIG\_RANDOMIZE\_BASE进行控制。
2. cmdline中不能存在nokaslr参数，否则kaslr不被使能。

**随机种子**

通过dts指定随机种子，如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyA5GZ9FIaTD0KiaW2Qa0pCAP2aWeRWGOZv2h5gb0JIvDaF4pMZyQBKWgPbibRf7LlD6KqUuf4wKJw/640?wx_fmt=png)

**验证测试**

通过内核符号地址信息，可以观察内核符号加载状态，以此判断kaslr特性是否生效，命令如下：

```
echo 0 > /proc/sys/kernel/kptr_restrict
head /proc/kallsyms
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyA5GZ9FIaTD0KiaW2Qa0pCDHlchylib4NRhibQI9GvjbGxMiaDYXdfRAicztXr5LOeFgKjZiaQo3BazuQ/640?wx_fmt=png)

## kaslr开源社区参考资料

https://lwn.net/Articles/569635/

## openEuler Kernel SIG

- openEuler kernel 源代码仓库：https://gitee.com/openeuler/kernel 欢迎大家多多 star、fork，多多参与社区开发，多多贡献补丁。关于贡献补丁请参考：如何参与 openEuler 内核开发
- openEuler kernel 微信技术交流群 请扫描下方二维码添加小助手微信，或者直接添加小助手微信（微信号：openeuler-kernel），备注“交流群”或“技术交流”，加入 openEuler kernel SIG 技术交流群。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyA5GZ9FIaTD0KiaW2Qa0pCeNeqe4Llglib7J4E3pOfcTKw3vF4OrWMrtEWlgdbzqpzdVLq7zPrX1A/640?wx_fmt=png)
