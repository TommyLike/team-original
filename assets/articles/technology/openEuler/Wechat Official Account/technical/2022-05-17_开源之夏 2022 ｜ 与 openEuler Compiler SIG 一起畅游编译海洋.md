# [开源之夏 2022 ｜ 与 openEuler Compiler SIG 一起畅游编译海洋](https://mp.weixin.qq.com/s/BquSf31mI-75YoiQOqWDlQ)

*Compiler SIG*[OpenAtom openEuler](javascript:void%280%29;)*2022-05-17 22:04:21*

**活动介绍**

开源之夏是由“开源软件供应链点亮计划”发起并长期支持的一项暑期开源活动，旨在鼓励在校学生积极参与开源软件的开发维护，促进优秀开源软件社区的蓬勃发展，培养和发掘更多优秀的开发者。

学生可在本活动中自主选择感兴趣的项目任务进行申请，并在中选后获得该开源项目资深维护者（社区导师）亲自指导的机会，完成项目并贡献给社区后，参与学生还将获得开源之夏活动奖金和结项证书。

**项目介绍**

本期开源之夏活动，openEuler Compiler SIG发布了4个课题，内容涉及编译器语言前端、动态编译性能优化、lib库和兼容性等。随着硬件和软件的协同设计变得更加重要，编译技术正处在LLVM之父Chris Lattner所说“编译器的黄金时代”，尤其在国内，以编译技术为代表的基础软件技术的发展越来越受重视，国之重器。欢迎各位同学积极参与申请报名，与华为资深编译专家畅游编译海洋，共享编译知识盛宴。

**1**

**源码中矩阵乘识别**

**项目导师**

Eric\_Ch96（chendewen3@huawei.com）

**项目描述**

基于C、C++语言和开源的LLVM框架，在Clang前端的抽象语法树(Abstract Syntax Tree，AST)识别出典型的矩阵乘操作，并将矩阵信息以Metadata的形式添加在LLVM IR上。

**产出要求**

- 自定义包含矩阵乘信息的metadata，矩阵信息如矩阵大小、是否转置等重要信息。
- 以个人仓库形式提交代码，实现基于Clang AST，识别出典型的矩阵乘操作，并将识别信息添加至LLVM IR，并添加端到端测试用例。

**技术要求**

- 熟练掌握C、C++语言
- 对编译器前端有一定了解，熟悉前端的流程，尤其是AST
- 熟悉开源Clang、LLVM的整体框架，对源码有一定的理解
- 熟练使用Linux

**2**

**在BGMProvider中使用Java实现**

**国密相关算法以及国密证书解析**

**项目导师**

xiezhaokun（xiezhaokun@huawei.com）

**项目描述**

BGMProvider是为毕昇JDK生态提供国密TLS协议Java实现，它包括 jca、jsse、tomcat-adaptor等模块。目前BGMProvider jca模块实现的国密相关算法依赖于bouncycastle。为了将来更好地扩展，需要将BGMProvider和bouncycastle解耦，并且在BGMProvider上实现国密相关算法。

**产出要求**

- 实现SM2/SM3/SM4/HmacSM3/
  
  SM3WithSM2国密算法以及相关功能测试用例。
- BGMProvider与bouncycastle解耦，去除与bouncycastle相关类的依赖。

**技术要求**

- 熟练掌握Java语言
- 熟悉JDK Service Provider机制，熟悉TLS协议

**3**

**毕昇编译器应用迁移**

**兼容性问题的解决**

**项目导师**

eastb233（xiezhiheng@huawei.com）

**项目描述**

为了构建毕昇编译器生态，毕昇编译器已融入openEuler yum源，并持续迁移各个领域的应用，在迁移过程中需要解决和其他编译器的兼容性问题。

**产出要求**

- 按问题描述实现功能，并输出相关测试用例。
- 支持高扩展性，如：以尽量少的代码修改量实现添加更多的屏蔽/替换选项。

**技术要求**

- 掌握编译器的使用，如GCC、LLVM的使用
- 熟悉编译器源码的架构和调试方法
- 掌握编程语言C、C++

**4**

**毕昇Fortran编译器**

**内联动态库函数str\_copy**

**项目导师**

peixin-qiao（qiaopeixin@huawei.com）

**项目描述**

毕昇Fortran编译器是一款基于classic flang的高性能Fortran编译器，支持Fortran编程语言的编译和运行，提供强大的数值计算和数据处理能力，在科学计算领域应用前景广阔。str\_copy是一个实现字符串拷贝功能的动态库函数，本项目是对该动态库函数进行内联，预期提高编译器字符串拷贝的性能。

**产出要求**

- 以patch的方法提交代码，实现str\_copy内联。
- 场景有性能提升。

**技术要求**

- 掌握C语言
- 了解汇编的同学优先

**申请资格**

- 本活动面向年满 18 周岁在校学生。
- 暑期即将毕业的学生，只要在申请时学生证处在有效期内，就可以提交申请。
- 海外学生可提供录取通知书、学生卡、在读证明等文件用于证明学生身份。

**活动日程**

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJV0wcxTjQgTeTme3mp8lEia1WIFgF3Libxh5thpfyX71UkSCkF87SCldpDaKa5cPWrB2dbfZkq34Oaw/640?wx_fmt=png)

**Compiler SIG介绍**

Compiler SIG 专注于编译器领域技术交流探讨和分享，包括 GCC/LLVM/OpenJDK 以及其他的程序优化技术，聚集编译技术领域的学者、专家、学术等同行，共同推进编译相关技术的发展。

Compiler SIG 每双周周二上午10:00进行线上例会，也会定期举办线下沙龙，以议题驱动方式进行编译器领域学习交流分享。我们希望加入 SIG 群组的每一位开发者都能在编译器领域有所成长和收获。

扫码添加 SIG 小助手微信，邀请你进 Compiler SIG 微信交流群。

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJV0wcxTjQgTeTme3mp8lEia13O2PwJm1JnYdMNsE8We89ickxaPVUrTbLVq1RuUFUZZB03EgBKsvsHQ/640?wx_fmt=png)
