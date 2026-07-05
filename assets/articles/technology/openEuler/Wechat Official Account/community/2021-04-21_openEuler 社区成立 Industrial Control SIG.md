# [openEuler 社区成立 Industrial Control SIG](https://mp.weixin.qq.com/s/DhN7u8H8fNEwEfbDO8Eskw)

[OpenAtom openEuler](javascript:void%280%29;)*2021-04-21 21:05:00*

经openEuler 社区技术委员会讨论决定，openEuler 社区正式成立 Industrial Control SIG。操作系统是工业控制系统的核心组件，工业控制系统广泛应用于能源、交通、水利、化工等关系到国计民生的重点领域，这些领域对于操作系统有着更高的实时性要求，普通的 Linux 操作系统无法满足需求，国内面向工控领域的实时操作系统方面缺乏研究。Industrial Control SIG 将专注于将拓展 openEuler 在工控领域的使用场景，包括现场总线、工控协议、工控软件、系统裁剪、实时虚拟化、嵌入式虚拟化和其他工控特性。提供基于 Xenomai 的硬实时和基于Preempt\_rt 的软实时两套完整的解决方案。

## SIG 组现有的技术储备

1. 具备多年Linux内核实时性改造的经验，发布的相关产品得到工控领域实际应用。
2. 完成基于ARM平台的鲲鹏Kyrin 920芯片和X86平台的I5芯片openEuler 20.03 LTS SP1系统对应的内核增加Xenomai、Preempt\_rt实时性。
3. 完成基于X86平台和飞腾2000/4平台的CentOS系统实体机环境增加Xenomai 、Preempt\_rt实时性。
4. 完成基于RTOS与RTOS通信、RTOS与GPOS通信、RTOS与硬件通信的功能验证。
5. 完成基于X86平台的RTOS系统的CAN、串口、网卡外设功能验证。
6. 完成基于GPOS环境集成CANOpen、EtherCat、ModbusRTU工控协议，并自测通过。
7. 正在进行RTOS环境移植CANOpen、EtherCat、ModbusRTU工控协议。

## SIG组的工作

01. 制定Xenomai硬实时方案相关软件包的版本生命周期。
02. 制定Preempt\_rt软实时方案相关软件包的版本生命周期。
03. 对openEuler进行裁剪，集成常见工业控制软件。
04. 对常见开源工业控制现场总线，如Modbus、CANopen、EtherCAT等进行迁移、适配和优化。
05. 复用Embedded SIG组成果，为嵌入式系统提供实时方案。
06. 坚持创新并持续贡献上游社区。
07. 及时响应用户反馈，解决相关问题。
08. 根据实际情况增加其他工控特性。
09. 移植实时相关或适用于工业控制领域的虚拟化方案。
10. 移植RTOS系统，以适配虚拟化方案

## Roadmap

1. 2021年5月底完成Xenomai方案向OpenEuler社区的迁移。
2. 2021年7月底完成CANOpen、EtherCat、ModbusRTU工控协议向OpenEuler社区的迁移。
3. 2021年10月完成Preempt\_rt方案向OpenEuler社区的迁移。
4. 2021年11月底完成Xenomai内核对CANOpen、EtherCat、ModbusRTU工控协议的移植适配。
5. 2021年12月底完成Xenomai方案的第一个OpenEuler版本。
6. 2022年2月底完成Preempt\_rt方案的第一个OpenEuler版本。
7. 2022年4月完成对飞腾嵌入式2000芯片的适配。
8. 2022年6月完成Xenomai实时性优化。
9. 2022年6月后续，进行实时相关或适用于工业控制领域的虚拟化方案研究。

## Maintainer

姓名公司Gitee ID职责郭皓麒麟软件guohaocs2c对外接口人，维护 Xenomai 和 Preempt\_rt 内核吴春光麒麟软件wuchunguang维护工控软件包马玉昆麒麟软件kylin-mayukun维护 Xenomai 方案方案核外软件包张茜麒麟软件zxiiiii维护工控协议丁丽丽麒麟软件blueskycs2c维护 Preempt\_rt 方案核外软件包张继文麒麟软件zhang-jiwen制作版本，系统裁剪

## 特邀成员

姓名Gitee id职责刘步权sunshower行业和技术

## 例会时间

每双周周三下午 15:00-17:00

## 交流群

添加微信：guohao\_c，回复“加群”，进入 industrial control SIG 交流群。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYElnr6RywIhhQavibP5joSnDGHkN0dbbs40mBia4qDSFhDJrha9W72U6Atxvm4zx2x9hBZ4L5qSW0w/640?wx_fmt=jpeg)
