# [「转」开源之夏 ｜ 【结项报告】毕昇Fortran编译器内联动态库函数str\_copy](https://mp.weixin.qq.com/s/-dMxMbxFruSlgmjUZHuTsw)

*王哲葳*[OpenAtom openEuler](javascript:void%280%29;)*2022-09-20 22:30:00*

![](https://mmbiz.qpic.cn/mmbiz_jpg/icntuIQtpSJXF0dIvpQiaoRiajvyOLM2rkQTDP1Xmy0icjaJ9wkXHE7ppXMroec2PaagXlSF3BkdOVPqvDBtA6QWJw/640?wx_fmt=jpeg)

**项目简介**

项目名称

毕昇Fortran编译器内联动态库函数str\_copy

项目描述

毕昇Fortran编译器是一款基于classic flang的高性能Fortran编译器，支持Fortran编程语言的编译和运行，提供强大的数值计算和数据处理能力，在科学计算领域应用前景广阔。f90\_str\_copy\_klen是一个实现字符串拷贝功能的动态库函数，本项目是对该动态库函数进行内联，预期提高编译器字符串拷贝的性能。

项目导师

peixin-qiao

项目开发者

王哲葳，华东师范大学硕士在读

项目链接

https://summer-ospp.ac.cn/#/org/prodetail/22b970386

**开发详情**

方案描述

Flang编译器主要由flang1和flang2两个组件组成，其中flang1用于解析Fortran代码并生成中间表示，然后通过flang2生成LLVM IR并输出。本项目的主要任务就是在flang2中对解析出的“f90\_str\_copy\_klen”函数进行内联优化。这个项目的方案分为如下几步：

**01**

flang2会获得通过Fortran生成的IR指令列表，遍历该列表，寻找到函数调用指令“I\_CALL”。

**02**

通过“I\_CALL”指令的位置查询所调用的是否为需要被内联的函数，如本项目需要实现的“f90\_str\_copy\_klen”函数的内联。在确认需要内联的函数后开始生成相应的指令，“f90\_str\_copy\_klen”函数的内联指令生成过程如下：

1. 将复制后得到的字符串称为目标字符串，待复制的字符串称为输入字符串。首先需要从原先的指令中获得输入字符串并开辟一系列内存空间用于记录目标字符串、输入字符串的起始地址、字符串索引及字符串长度。
2. 对每一个输入字符串，从头开始遍历。分别判断当前目标字符串、输入字符串的索引是否小于其长度，如果均符合则将输入字符串中对应索引的字符复制到目标字符串的相应地址中。如果输入字符串索引大于等于其长度则处理下一个输入字符串。如果目标字符串索引大于等于其长度则停止字符串的复制。
3. 按照2所述流程依次遍历函数中的输入字符串，直至所有字符串都完成复制。
4. 目标字符串索引是否仍小于其长度，若是，则将目标字符串中剩余未被赋值的字符用空格进行补充。
5. 将实现上述功能的指令替换掉对应的“I\_CALL”指令。

**03**

继续flang2中的流程以生成对应的LLVM IR 文件。

项目产出

? 

实现了项目方案中所需的功能。

? 

分别用一个字符串、三个字符串作为输入字符串，完成了共十种输入字符串各种长度情况下”f90\_str\_copy\_klen”函数内联的的功能性测试，在这些输入字符串中也包含了一些ASCII码小于32（ASCII码为32表示空格）的特殊字符。十种情况如下：

- a=b
  
  1. len(a) &lt; len(b)
  2. len(a) = len(b)
  3. len(a) &gt; len(b)
- a = b // c // d
  
  1. len(a) &lt; len(b)
  2. len(a) = len(b)
  3. len(b) &lt; len(a) &lt; len(b) + len(c)
  4. len(a) = len(b) + len(c)
  5. len(b) + len(c) &lt; len(a) &lt; len(b) + len(c) + len(d)
  6. len(a) = len(b) + len(c) + len(d)
  7. len(a) &gt; len(b) + len(c) + len(d)

? 

将“f90\_str\_copy\_klen”在函数中调用一亿次，对内联前后所花费的时间做对比。实验结果显示没有内联时运行花费的时间约为10秒，内联后运行花费的时间约为0.7秒。

- 测试代码如下：  
  主函数：main.f90
  
  ```
  program main
    integer :: i
    character(20) :: a, b, c, d
    a = "aaaaaaaaaaaaaaa"
    b = "aaaaaaaaaaaaaaa"
    c = "aaaaaaaaaaaaaaa"
    do i = 1, 100000000
      call test(a, b, c, d, 20)
    enddo
  end
  ```
  
  字符串拼接拷贝函数：test.f90
  
  ```
  subroutine test(a, b, c, d, n)
    integer :: n
    character(n) :: a, b, c, d
    d = a // b // c
  end subroutine
  ```
- 测试方法如下：  
  未优化前：
  
  ```
  $ flang main.f90 -c
  $ flang test.f90 -O3 -c
  $ flang main.o test.o -o a.out
  $ time ./a.out 
  ```
  
  > real 0m10.190s  
  > user 0m10.180s  
  > sys 0m0.004s
  
  优化之后（编译选项-Mx,218,0x1使能该优化功能）：
  
  ```
  $ flang main.f90 -c
  $ flang test.f90 -O3 –c –Mx,218,0x1
  $ flang main.o test.o -o a.out
  $ time ./a.out
  ```
  
  > real 0m0.706s  
  > user 0m0.702s  
  > sys 0m0.004s

![](https://mmbiz.qpic.cn/mmbiz_gif/icntuIQtpSJXF0dIvpQiaoRiajvyOLM2rkQEa1dsxcTBQ6iaNSWMJiahHWGBNtbYYvytw2lZrkn7EibFMIfYa0QYMKYg/640?wx_fmt=gif)

除开源之夏外，Compiler SIG还发布了十多个开源实习任务（戳 [开源实习1](http://mp.weixin.qq.com/s?__biz=MzkyNTMwMjI2Mw%3D%3D&mid=2247488537&idx=1&sn=bc7a433b6e2eab335517155ed4631cba&chksm=c1c9f881f6be7197101a5111f590f68e661883065b917a783a03bba5ed29577f09ffbe9f35c6&scene=21#wechat_redirect)、[开源实习2](http://mp.weixin.qq.com/s?__biz=MzkyNTMwMjI2Mw%3D%3D&mid=2247485998&idx=1&sn=bbad9f75f69574b9e4f0244fb400b707&chksm=c1c9e6b6f6be6fa0b4936862a42cefa16674cef6bcba5c23117513b710fdd0aaeaf1e22379ef&scene=21#wechat_redirect) 了解详情），欢迎各位高校生报名参与~

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJXF0dIvpQiaoRiajvyOLM2rkQfASgUnbibGm21mxk8oygD8ThIPGAw0DL5sKQiaX3A2S39SFEYBt63n8w/640?wx_fmt=png)
