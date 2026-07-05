# [GearOS：基于 openEuler 的实时增强操作系统](https://mp.weixin.qq.com/s/BizOFaAzeAe05GbiWE9HYQ)

[OpenAtom openEuler](javascript:void%280%29;)*2021-11-05 23:27:45*

GearOS 是由欧拉开源社区 Industrial-Control SIG 孵化的一款面向工业控制领域的实时增强操作系统，专注于操作系统实时性、可靠性，基于欧拉开源操作系统，使用 Yocto 构建，可应用于汽车控制、机器人控制、PLC 控制、机床控制等领域。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZrVFdTChzFnTLCnMjLSRWvb88jj3o96xKFeicicNvQCucaQvVnbpLKMicHOJtUsOorft5P4oJj6SUDg/640?wx_fmt=png)

GearOS 在 openEuler Summit 2021 的嵌入式分论坛中有名为“Linux 实时性实践与探索”的技术分享，欢迎大家报名参加。

欧拉开源社区 Industrial-Control SIG 组主要致力于将欧拉开源操作系统打造成适用于工业控制领域的实时、可靠、安全的操作系统。

本次发布的 GearOS 版本基于 ARM64 架构，主要包含两个内核和两个文件系统镜像。

两个内核：分别为支持 Preempt\_RT 实时特性的内核和支持 Xenomai 实时特性的内核，均基于 openEuler 4.19 内核改造而来，大小为 8MB。

两个文件系统镜像：分别为紧凑型文件系统镜像和标准文件系统镜像。其中紧凑型文件系统镜像使用 BusyBox 制作，大小为 5.4MB；标准文件系统镜像未使用 BusyBox。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbyNGcKeibeGgJ5nkR4HckZfIy08JJaCdgNJ93yc0icHKk35nACxf5HQQLRfRGPpvF1H9oAGlnwlvZw/640?wx_fmt=png)

GearOS系统架构图

##### GearOS 技术特性

- 系统主要特性
  
  - 支持飞腾 2000/4、鲲鹏 920、TI AM335X、Qemu-ARM64、X86 等平台
  - 内核最低可做到 3.3MB，本次发布 8MB
  - 内核支持串口、网络、块设备、USB、PCIe 等驱动
  - 文件系统最低可做到 5.4MB
  - 启动时间小于 5s
  - 支持 Preempt\_RT 和 Xenomai 实时方案
  - 紧凑型文件系统镜像包含登录验证、Udev、SSH、Xenomai 库、rt-tests 工具集
  - 标准型文件系统镜像增加 Python、Perl、OpenSSL、Sqlite、RPM 包管理等
- 工业相关附加特性（已支持暂未集成）
  
  - 支持 LibModbus 协议
  - 支持 EtherCAT 协议
  - 支持 OPC UA 协议
  - 支持 TSN
  - 支持 HSR/PRP
  - 支持 NETCONF/YANG
- 实时相关特性

在 FT-2000/4、鲲鹏 920 硬件设备，使用 openEuler 4.19 内核，使用 cyclictest 测试工具对比测试结果。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbyNGcKeibeGgJ5nkR4HckZfibezyUaUDyFbzVXlUpibsot0tSrvvZCQU5gp9DwbeVjPK55cYWqtYmcg/640?wx_fmt=png)

- 未来计划
  
  - 支持树莓派 4、NXP i.MX 7、瑞芯微 RK3399 等平台
  - 支持 5G、Bluetooth 、NFC、ZigBEE 设备及相关协议
  - 支持 CoAP、MQTT 等 IOT 相关协议
  - OTA
  - 可靠性、安全性增强
  - 虚拟化特性
  - 实时性优化
  - CoDeSys 运行时
  - IDE
  - 其他嵌入式或工控需求

项目地址：https://gitee.com/openeuler/xenomai

##### 主要贡献者

姓名公司Gitee ID邮箱郭皓麒麟软件guohaocs2cguohao@kylinos.cn马玉昆麒麟软件kylin-mayukunmayukun@kylinos.cn吴春光麒麟软件wuchunguangwuchunguang@kylinos.cn丁丽丽麒麟软件blueskycs2cdinglili@kylinos.cn张继文麒麟软件zhang-jiwenzhangjiwen@kylinos.cn张茜麒麟软件zxiiiiizhangxi@kylinos.cn黎亮华为liliang\_eulerliliang889@huawei.com张攀华为SuperHugePanzhangpan26@huawei.com
