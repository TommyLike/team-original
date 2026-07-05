# [「转」开源之夏2025 ｜ 欢迎报名 openEuler Compiler SIG 项目，收获丰厚奖金！](https://mp.weixin.qq.com/s/DbCR3qSO0zgfl-NwMMy9vA)

*Compiler SIG*[OpenAtom openEuler](javascript:void%280%29;)*2025-05-19 17:33:26中国香港*

**开源之夏**

Open Source Promotion Plan

开源之夏是中国科学院软件研究所发起的“开源软件供应链点亮计划”系列暑期活动，旨在鼓励在校学生积极参与开源软件的开发维护，促进优秀开源软件社区的蓬勃发展。活动联合各大开源社区，针对重要开源软件的开发与维护提供项目，并向全球高校学生开放报名。

OpenAtom openEuler（简称 openEuler） Compiler SIG 致力于打造编译根技术，为用户提供高性能、高可靠的编译器工具链。本期开源之夏活动，openEuler Compiler SIG共发布了10个项目课题，欢迎同学们积极报名申请！成功结项将获得丰厚的**结项奖金**、**结项证书**、**年度优秀学生提名机会**以及未来的就业和深造机遇。

开源之夏官网：https://summer-ospp.ac.cn/

**# 项目介绍 #**

**01**

**项目名称：**

llvm与gcc兼容性增强——模板调构造函数使用auto

**项目导师：**

张仁杰（1334531924@qq.com）

**项目简述：**（向上滑动浏览）

llvm和gcc是当下主流的C、C++编译器。应用使用不同编译器编译构建，可能遇到编译或者运行的兼容性问题。为降低客户在从gcc迁移至llvm过程中的人力投入，提升客户体验，需要在llvm编译器中对兼容性进行增强，支持对应场景，例如如下在调用析构函数时使用auto的场景：

template

void f (T* p)

{

p-&gt;~auto(); // p-&gt;~T();

}

int d;

struct A { ~A() { ++d; } };

int main()

{

f(new int(42));

f(new A);

if (d != 1)

throw;

return 0;

}

该场景gcc可以编译通过，llvm编译会提示如下报错：

test.cpp:4:7: error: expected a class name after '~' to name a destructor

4 | p-&gt;~auto(); // p-&gt;~T();

| ^

1 error generated.

将auto改为对应类型名称后LLVM可以编译通过。出于兼容性考虑，希望可以兼容对应用法。

**项目详情：**

https://summer-ospp.ac.cn/org/prodetail/25b970286?lang=zh&list=pro

**02**

**项目名称：**

llvm与gcc兼容性增强 —— 符号类型处理差异

**项目导师：**

杨阳（yangyang305@huawei.com）

**项目简述：**（向上滑动浏览）

llvm和gcc是当下主流的C、C++编译器。应用使用不同编译器编译构建，可能遇到编译或者运行的兼容性问题。为降低客户在从gcc迁移至llvm过程中的人力投入，提升客户体验，需要在llvm编译器中对兼容性进行增强，支持对应场景的处理。不同编译器生成obj文件时，生成的函数/变量符号的类型可能存在差异，最终引发兼容性问题。

**项目详情：**

https://summer-ospp.ac.cn/org/prodetail/25b970265?lang=zh&list=pro

**03**

**项目名称：**

基于classic-flang支持C Strings in Character Constants

**项目导师：**

张瑞楠（zhangruinan@huawei.com）

**项目简述：**（向上滑动浏览）

Fortran语言由于其接近数学公式自然描述的语言特征，时至今日仍然是用于HPC场景的主流编程语言。但由于Fortran语言规范相对较宽容，代码中较易出现标准外行为，不同编译器可能对此存在编译或者运行的兼容性问题。针对HPC实际应用场景中出现的C Strings in Character Constants场景，classic-flang、gfortran、ifort三款主流Fortran编译器的行为都存在不同；经分析，ifort的行为相对更具合理性，因此本选题目标为完成classic-flang对C Strings in Character Constants场景的支持，支持程度与ifort对齐。

**项目详情：**

https://summer-ospp.ac.cn/org/prodetail/25b970258?lang=zh&list=pro

**04**

**项目名称：**

面向循环中SVE访存指令的基址+偏移模式的冗余指令消除

**项目导师：**

胡可科（hukeke2@huawei.com）

**项目简述：**（向上滑动浏览）

sve memory operations包括gather/scatter场景，会使用base+index的方式进行访存，用户编写代码时可能会出于开发习惯和代码整洁的原因而选择更新index来对不同的内存进行访问，但是在SVE场景中性能可能并不如修改base地址。编译器可以帮助用户进行这方面的优化，在保证用户开发便捷的前提下完成性能增强。

**项目详情：**

https://summer-ospp.ac.cn/org/prodetail/25b970256?lang=zh&list=pro

**05**

**项目名称：**

探索LLVM AArch64架构后端的代码生成优化机会

**项目导师：**

陈正（chenzheng1030@hotmail.com）

**项目简述：**（向上滑动浏览）

编译器优化在助力设备整机性能上的重要越来越高。当一些常见的编译优化，比如向量化、内联、反馈优化、链接优化等遇到优化瓶颈的时候，编译器后端在紧密结合底层硬件和操作系统的条件下，仍然能够进一步优化程序性能。在编译器后端优化当中，指令级别的优化，比如指令选择，指令窥孔优化等是基础的优化手段。目前寻找指令级别的优化方法往往依赖专业人员对AArch64指令的了解程度，然后在分析大的应用程序性能时，发现指令级别优化机会。这种手段依赖专家先验知识，而且依赖具体的应用场景暴露优化机会，很难系统、全面的覆盖所有的指令窥孔类的优化机会。该项目建议用新的方法，脚本化的方式，基于很小的代码片段去寻找潜在的AArch64后端的指令级别优化机会。

实现思路：

1：使用llvm-extract工具将llvm的LIT case拆分成各个小函数，LIT case目录为llvm-project/llvm/test/Transforms llvm-project/llvm/test/CodeGen/AArch64(后续可能增删LIT case范围)

2：使用llvm c backend https://github.com/JuliaHubOSS/llvm-cbe 将步骤一拆分出来的每个单个函数的LIT文件编译成对应的C函数

3：使用最新的gcc(14.2)/clang(https://gitee.com/openeuler/llvm-project/tree/dev\_19.1.7/) 编译步骤2的C函数(-march=armv8.6-a+sve -O3)，找出最优的指令序列（指令数目最少），若clang没有产生最优的序列，那就是一个优化机会

**项目详情：**

https://summer-ospp.ac.cn/org/prodetail/25b970264?lang=zh&list=pro

**06**

**项目名称：**

Triton-CPU tile操作生成AArch64 SVE/SME

**项目导师：**

黄凯垚（huangkaiyaohz@163.com）

**项目简述：**（向上滑动浏览）

在现代高性能计算（HPC）和机器学习（ML）应用中，矩阵运算（如加、减、乘、转置等）是核心操作。目前在Triton-CPU中，已经基于ARM NEON和X86 AVX512实现了固定长度向量的矩阵操作。而SVE/SME指令集支持可变长度向量，能够大幅提升数据并行吞吐，如果能够基于SVE/SME实现矩阵操作，可以优化运算逻辑并显著提升计算性能。因此本选题目标是基于SVE/SME指令集，在Triton-CPU中实现高效的tile加、减、乘、转置操作。

**项目详情：**

https://summer-ospp.ac.cn/org/prodetail/25b970403?lang=zh&list=pro

**07**

**项目名称：**

调研LLVM FLANG对OpenACC 3.3支持情况

**项目导师：**

朱盛涛（627824024@qq.com）

**项目简述：**（向上滑动浏览）

OpenACC是一种基于指令的并行编程模型。与OpenMP类似，开发者可以通过在代码中添加简单的指令便可以借助编译器实现在异构计算平台（如CPU+GPU）上加速应用程序。LLVM FLANG是基于LLVM开发的Fortran前端编译器，经过数年开发已基于完善，对于OpenACC导语也有一定的支持。本选题希望对LLVM FLANG支持OpenACC的现状有一个全面的了解，便于后续项目的开发及应用。

**项目详情：**

https://summer-ospp.ac.cn/org/prodetail/25b970267?lang=zh&list=pro

**08**

**项目名称：**

网络数控面统一编程IDE插件

**项目导师：**

陈民栋（chenmindong1@huawei.com）

**项目简述：**（向上滑动浏览）

网络编程中，数据面与控制面通常采用不同的语言开发，如数据面常用P4等DSL高效地表达转发逻辑，而控制面通常用python、c等通用语言表达复杂的控制逻辑。研究表明38.8%的网络编程bug由控制器的错误配置导致，部分就可以归咎于数据面、控制面开发语言不一致。本课题希望基于VSCode，提供数据面、控制面统一的IDE插件，降低错误配置的可能性，提高开发者网络编程效率。

**项目详情：**

https://summer-ospp.ac.cn/org/prodetail/25b970285?lang=zh&list=pro

**09**

**项目名称：**

面向代码任务的DeepSeek大语言模型的本地部署和性能优化

**项目导师：**

Tianyi Liu（tianyi.liu3@h-partners.com）

**项目简述：**（向上滑动浏览）

在将代码从gcc/g++迁移到基于LLVM/Clang的毕昇编译器时，往往会遇到由于编译器兼容性问题所引发的代码兼容性的编译错误，这些错误的定位与修复需要投入大量时间。目前，智能迁移助手（BiSheng AI）利用大语言模型（LLM）来辅助分析和修复这些编译错误，但该工具目前依赖于云端的大模型进行推理。为了提高用户代码的安全性和隐私保护，采用本地部署的大语言模型成为更理想的选择。然而，本地机器的硬件性能通常较为有限，尤其是在仅有CPU的情况下，如何实现高效且快速的推理成为一大挑战。并且不同用户的本地硬件不同，本地部署需要根据硬件条件进行调整。

本项目的目标是实现智能迁移助手的基座LLM（大语言模型）在多核CPU环境下的本地部署的通用化，并在推理速度、模型精度与模型参数大小之间找到最佳平衡。具体来说，项目将集中于建立一个通用的大模型接入层，使切换不同平台的大模型代价最小，减少切换时底层代码修改。另外，学生需要评估并选择适合在学生自己本地CPU上运行的最大DeepSeek模型，并利用量化、裁剪、代码模型优化等技术手段，提升推理速度和效率，从而最大化本地模型的性能。

通过该项目，学生将面临在硬件资源有限的情况下，如何优化复杂AI模型在多核CPU上的执行，平衡模型性能与资源消耗。学生不仅会深入了解模型优化的技术方法，还会实践在不同硬件环境中部署大规模语言模型的挑战。

**项目详情：**

https://summer-ospp.ac.cn/org/prodetail/25b970248?lang=zh&list=pro

**10**

**项目名称：**

PGO反馈优化可用性增强

**项目导师：**

姜海波（polaris\_jiang@163.com）

**项目简述：**（向上滑动浏览）

PGO反馈优化在各领域已经在广泛使用。该优化技术对于CPU前端瓶颈使用的应用场景优化效果非常显著。

但是PGO优化依赖运行时Profile信息采集和二次编译，使用方法较为复杂，且面对不同的应用场景，也呈现了不同的Profile采样需求。

希望可以基于当前PGO使用方法，进行如下两部分功能增强：

增加一个计数器置零功能，如通过signal信号支持profile count重置为0，使用方式尽可能方便通用。

增加clang -fprofile-use支持profraw自动合并功能或者新增如-fprofile-use-dir选项支持该功能，省掉llvm-profdata merge的步骤。

**项目详情：**

https://summer-ospp.ac.cn/org/prodetail/25b970252?lang=zh&list=pro

**# 关键时间表 #**

5月9日-6月9日

学生与导师沟通并提交项目申请

6月25日

中选结果公示

7月1日-9月30日

项目开发阶段

11月9日

结项项目公示

**# 申请指南 #**

?  根据项目要求，参考学生指南中的【项目申请模板】准备相关材料。

?  通过系统提交项目申请材料。

?  本届活动起，一名学生最多可以提交一个项目的申请书，且最终一个项目最多由一名学生承担。

学生指南：https://blog.summer-ospp.ac.cn/help/student%20guide

![](https://mmbiz.qpic.cn/sz_mmbiz_gif/icntuIQtpSJUylMx73Z83JDCh5DdpsYibYct8lJ7BbgdYySBylcLmywAgmW3ibFhXGoQqrJoRoziayicibWv6hycDasQ/640?wx_fmt=gif&from=appmsg)

感兴趣的同学可添加小助手微信，备注“开源之夏”邀请您加入**开源之夏 | openEuler 交流群**。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/icntuIQtpSJUylMx73Z83JDCh5DdpsYibYsYLGc2DLicvxvoibPicFialBLAs1ky7FdCnQqVbmozMP2h3K24AaGa6zog/640?wx_fmt=jpeg&from=appmsg)

点击 **阅读原文** 跳转开源之夏官网

[阅读原文](https://summer-ospp.ac.cn/)
