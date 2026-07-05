# [openEuler ROS SIG 工作进展及规划路线：持续繁荣 ROS 机器人产学研生态](https://mp.weixin.qq.com/s/sybDf6A_RB7-VXRJ_lLKcw)

[OpenAtom openEuler](javascript:void%280%29;)*2022-10-13 20:30:00*

ROS，即 Robot Operating System，是机器人领域主流的开源平台，提供类似于操作系统的服务，包括硬件抽象描述、底层驱动程序管理、共用功能的执行、程序间消息传递、程序发行包管理等功能。ROS 还提供一些工具和库用于获取、建立、编写和执行多机融合的程序，为机器人产学研究提供了便利的开发环境。

## 项目简介

2020 年 6 月，由中国科学院软件所智能软件中心的机器人团队为核心创立的 openEuler ROS SIG 正式成立。ROS SIG 旨在完善 openEuler 操作系统对机器人分布式通信的底层支持，并且将 ROS 生态逐步扩展到 openEuler 上。同时，ROS SIG 致力于保证 ROS 机器人和最新版本的 ROS 软件包，以及基于 ROS 开发的第三方软件包相关软件可以顺利适配并兼容 openEuler 操作系统，从而使得社区贡献者和用户可以直接从 openEuler 中直接获取最新的 ROS 包进行安装和使用。当前，ROS SIG 组的基础目标如下：

- 在 openEuler 社区中添加并完善对 ROS 和 ROS2 的支持
- 跟随 openEuler 迭代版本，持续完成 ROS 和 ROS2 中各个组件向 openEuler 的适配，并提供相关使用文档
- 积极提供后续技术维护，及时响应用户反馈

## 项目进展

目前，ROS SIG 各方面取得了阶段性的进展，完成了适配 ROS 包的安装、功能测试、仿真和真机运行等。

### 软件层面

- ROS-SIG 跟随 openEuler 的 20.03、21.03、22.03 版本，分别适配移植了 ROS-kinetic、ROS-melodic、ROS-noetic、ROS2-foxy 四个版本的基础功能包，以及部分桌面扩展包、第三方工具包等等。其中，在 openEuler 的 21.03 版本上成功编译运行 ROS melodic 桌面版，22.03 版本上成功编译运行 ROS melodic 桌面版和 ROS2 foxy 基础版。

<!--THE END-->

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaJbashpQsJuOZgZSMEjtb3k1RwOUrml0kLD0HeTicFZkrGzODFiakNF6ApfibaUy07erJCOcvdh4XgA/640?wx_fmt=png)

- 在仿真模拟软件方面，SIG 组率先进行了二维仿真软件 stage 的移植适配和更新迭代。stage 作为一款轻量化的可视化模拟软件，在嵌入式桌面版本调试开发十分高效。而后 SIG 组又移植适配了 gazebo 三维模拟软件，可以更真实的模拟复杂的机器人空间环境，为桌面版的 ROS 软件生态，添加更有力的支持。

### 硬件层面

- ROS-SIG 成功将 ROS 真机运行在了 ARM 和 x86 两种架构上的 openEuler 操作系统上，在树莓派、RK3399、TX2 等开发板上安装测试通过。

<!--THE END-->

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaJbashpQsJuOZgZSMEjtb3Pbnyjx1ibJ0hqlehKiaX89UdLLKhmibKRIalGua00Y3jc7Q6fh4iazmibTQ/640?wx_fmt=png)

- 在机器人上安装 openEuler 和 ROS 成功运行 SLAM 和导航等功能包，在机械臂上安装 openEuler 和 ROS 成功运行识别抓取等软件包。

已适配的 ROS 软件包列表：https://gitee.com/openeuler/community/tree/master/sig/sig-ROS

## 产学联动

ROS SIG 致力于机器人方向的产学联动，为中国机器人产业长远发展提供源源不断的原动力。

### 开源之夏

2022 年，在由中国科学院软件研究所与 openEuler 社区共同主办的开源软件供应链点亮计划系列暑期活动——开源之夏（OSPP）中，ROS SIG 从当前 ROS 生态中比较受欢迎的常用软件中，挑选了三个基于 ROS 开发的第三方软件相关的项目任务。

ROS SIG 基于"ROS 与人工智能"的大主题，精心将三个任务分属为区别较大的三个模块，分别是应用广泛的 ROS2 和激光导航的算法、扩展探索性质 ROS2 和深度学习的目标检测的算法以及在 AI 领域的关键模块 VIO 算法，为学生们提供具有深度探索性和学习性开源机器人项目编程实践。SIG 组成员持续跟进开源之夏项目进展，并且为学生提供线上直播答疑，邮件答疑等辅导工作。

### 科普展示

在中科院软件所 2022 年公众科学日中，ROS SIG 为智能软件研究中心的智能机器人展示项目提供了技术支持。

SIG 组成员利用互动实验、多媒体演示和真人讲解，向公众展示和介绍了多种机器人和常见传感器（激光雷达、景深摄像头、超声雷达等），以及机器学习如何帮助机器人认知人脸和手势，机器人 SLAM 建图和导航技术和智能机器人对日常生活的贡献。

同时，ROS SIG 和 RISC-V SIG 联动， 利用 RISC-V 开发板介绍智能机器人的大脑。全方位展示了 openEuler 操作系统和 ROS 对智能机器人的贡献。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaJbashpQsJuOZgZSMEjtb3L54qblst4wTr6ibia30j687hVn98hyoEYkPsWOpAYnnWFQxK9f2tfOgA/640?wx_fmt=png)

### 公开博客视频

ROS SIG 目前累计发表多篇总结性文档、博客和多个公开展示视频。相关文章与视频发表在 CSDN 和 B 站等平台，被多次转载和点赞。

#### SIG 组演示视频推荐：

- openEuler 上运行 cartrographer\[1]
- openEuler 上运行 gmapping\[2]
- openEuler 上运行 rostopic demo\[3]
- openEuler 上利用 stage\_ros 模拟器运行 move\_base\[4]
- openEuler 21.03 安装 ros\_comm 运行 server\_demo 示例\[5]
- openeuler 21.03 安装 ros\_comm\[6]
- 激光 SLAM 建图 demo\[7]
- ROS 点对点导航 demo\[8]
- openEuler stage\_ros 仿真，move\_base 导航，rviz 可视化\[9]
- openEuler 21.03 安装 ros2 的 rpm 包,玩转小乌龟\[10]

#### SIG 组博客文章：

- Raspberrypi4+openEuler 源码安装 catkin\[11]
- Raspberrypi4+openEuler 将 catkin 打包成 rpm\[12]
- openeuler 20.09 和 openeuler 21.03 安装指南\[13])
- 在 openeuler 操作系统下, 验证 ros\_comm 已完成的 rpm 包的步骤\[14]
- openeuler 下载已经打包好的 rpm 包,并验证功能\[15]
- openeuler 打包 ros-comm\[16]

## ROS SIG 未来规划

ROS SIG 经过两年多的发展，目前已趋于稳定，接下来面对的问题是如何让 SIG 组的工作不局限于兼容，平稳发展以及确定后续的发展方向。

对于未来的计划，ROS SIG 表示，将会

1. 梳理更新 22.03 版本对应的 ROS-noetic 和 ROS2-foxy，创建对应的软件包列表，预计在 2022 年底，随 22.03-sp 发布 ROS 和 ROS2 基础版本。用户可以在 ARM 架构主机上安装和使用 ROS。
2. 预计在 2023 年，更新发布 ROS 和 ROS2 桌面版本，扩展 ROS 调试工具、仿真模拟软件的适配范围。用户可以在 openEuler 上更高效直观的使用 ROS，开发 ROS。
3. 预计在 2023 年，不局限于兼容的工作，扩大基于 ROS 的第三方软件适配，包含 AI、SLAM、VIO 等算法领域，进一步繁荣 openEuler 的社区生态。

同时 ROS SIG 将进一步支持中科院博物馆导航包等实际环境应用，支持轻量化安装，积极进行 ROS 在产学方向的探索，推动 ROS SIG 的可持续发展。

# 关于作者

杨延玲，中科院软件所 PLCT 实验室实习生，欧拉开源社区 RISC-V SIG 成员，目前在温州大学读研一，负责协助 RISC-V 和 ROS 的日常运营。

### Reference

\[1]

openEuler 上运行 cartrographer: https://www.bilibili.com/video/BV1Rf4y1B73u

\[2]

openEuler 上运行 gmapping: https://www.bilibili.com/video/BV1ZZ4y157uN

\[3]

openEuler 上运行 rostopic demo: https://www.bilibili.com/video/BV1QK4y1f7Lw

\[4]

openEuler 上利用 stage\_ros 模拟器运行 move\_base: https://www.bilibili.com/video/BV1Dh41117B6

\[5]

openEuler 21.03 安装 ros\_comm 运行 server\_demo 示例: https://www.bilibili.com/video/BV1Wq4y1U7u6

\[6]

openeuler 21.03 安装 ros\_comm: https://www.bilibili.com/video/BV1oq4y1Q7XT

\[7]

激光 SLAM 建图 demo: https://www.bilibili.com/video/BV1TN411f7xh

\[8]

ROS 点对点导航 demo: https://www.bilibili.com/video/BV1QK4y1P7t2

\[9]

openEuler stage\_ros 仿真，move\_base 导航，rviz 可视化: https://www.bilibili.com/video/BV1TX4y1K7DZ

\[10]

openEuler 21.03 安装 ros2 的 rpm 包,玩转小乌龟: https://www.bilibili.com/video/BV1FS4y1g74P

\[11]

Raspberrypi4+openEuler 源码安装 catkin: https://gitee.com/link?target=https%3A%2F%2Fblog.csdn.net%2Fqq\_29772939%2Farticle%2Fdetails%2F119787952

\[12]

Raspberrypi4+openEuler 将 catkin 打包成 rpm: https://gitee.com/link?target=https%3A%2F%2Fblog.csdn.net%2Fqq\_29772939%2Farticle%2Fdetails%2F119851642

\[13]

openeuler 20.09 和 openeuler 21.03 安装指南: https://gitee.com/link?target=https%3A%2F%2Fwww.bilibili.com%2Fvideo%2FBV1Rf4y1B73u

\[14]

在 openeuler 操作系统下, 验证 ros\_comm 已完成的 rpm 包的步骤: https://gitee.com/link?target=https%3A%2F%2Fblog.csdn.net%2Fdavid\_han008%2Farticle%2Fdetails%2F108188165

\[15]

openeuler 下载已经打包好的 rpm 包,并验证功能: https://gitee.com/link?target=https%3A%2F%2Fblog.csdn.net%2Fdavid\_han008%2Farticle%2Fdetails%2F107591536

\[16]

openeuler 打包 ros-comm: https://gitee.com/link?target=https%3A%2F%2Fblog.csdn.net%2Fdavid\_han008%2Farticle%2Fdetails%2F106966653
