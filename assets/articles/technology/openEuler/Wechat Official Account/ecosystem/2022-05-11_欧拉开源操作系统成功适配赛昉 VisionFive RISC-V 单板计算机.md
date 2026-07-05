# [欧拉开源操作系统成功适配赛昉 VisionFive RISC-V 单板计算机](https://mp.weixin.qq.com/s/61BjTs-zOgrFMKCa0aQeMA)

*RISC-V SIG*[OpenAtom openEuler](javascript:void%280%29;)*2022-05-11 17:59:00*

近日，欧拉开源操作系统在赛昉科技的昉·星光 RISC-V 单板计算机 VisionFive 上成功运行。

openEuler 与 VisionFive 的适配工作由 RISC-V SIG 开发者袁穗聪（Samuel Yuan）负责并完成。目前，openEuler 在 VisionFive 上的基础软件适配成功，整体运行过程较为流畅，外设工作正常。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYv2QnhjzIicvPBteXicPXhNwIQ6PS6ulIHicb2Vic0ShGavhp5pjgEa6hGIyhSlHRZV6M0jq7IZjQOgw/640?wx_fmt=jpeg)

VisionFive 由 RISC-V 软硬件生态领导者赛昉科技推出，是全球首批基于 Linux 的高性价比的 RISC-V 单板计算机。VisionFive 为开源软件在 RISC-V 的移植提供了开源硬件保障，驱动 RISC-V 更多顶层创新应用的实现。更多关于 VisionFive 的介绍，请关注 RVspace 开源社区rvspace.org。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYv2QnhjzIicvPBteXicPXhNwW3UL6p6beXVBwteY6abML5FsP3ibViaxJvHwVoU8HJImxlKZBLYC4Xfw/640?wx_fmt=jpeg)

据袁穗聪介绍，openEuler 在 VisionFive 上运行时，xfce 图形界面的启动速度不错，文件系统、终端模拟器和输入法等相关 GUI 应用也运行流畅，不过，openEuler 在 VisionFive 上的图形软件运行水平有待提高。

openEuler 在 RISC-V 开源硬件上的运行还有很大的进步空间：

- 目前 GUI 只是初步适配了 xfce4，还有许多 GUI 应用需要适配。
- VisionFive 没有 GPU，图形界面依靠 LLVMpipe 渲染， CPU 负荷较大。开发板性能需要优化，以提高渲染的速度。
- RISC-V SIG 还需增强对 SELinux 的支持。

为了帮助感兴趣的伙伴们在 VisionFive 硬件平台上具备熟练部署欧拉开源操作系统软件的能力，袁穗聪整理了《Play with openEuler on VisionFive》系列课程与大家分享：

https://gitee.com/samuel\_yuan/riscv-openeuler-visionfive

课程目前已经完成了关于欧拉开源操作系统在 VisionFive 安装的操作手册，后续预计还将补充 GUI 应用的验证、测试与优化的操作手册。

随着欧拉开源操作系统与 VisionFive 的成功适配，RISC-V Lab 的基础设施将继续扩大和完善，部署更多数量的 VisionFive 开发板。

针对使用场景在 GUI 应用落地方面的规划，RISC-V SIG 会进行 FireFox 浏览器， Chromium 浏览器，LibreOffice 等重要 GUI 应用在 VisionFive 等开发板的适配工作。

RISC-V SIG 未来[规划](https://mp.weixin.qq.com/s?__biz=MzI2NDE4OTE2Mg%3D%3D&mid=2247492567&idx=1&sn=a6488def9f84d8e2b821b4c2d79acc1f&scene=21#wechat_redirect)

### 关于赛昉科技

赛昉科技（StarFive）于 2018 年成立，是一家具有自主知识产权的本土高科技企业，提供全球领先的基于 RISC-V 的 CPU IP、SoC、开发板等系列产品，是中国 RISC-V 软硬件生态的领导者。未来赛昉科技将会从内核层、系统服务层、框架层和应用层等各方面与国内外生态合作伙伴开展全面的合作，通过引领 RISC-V 技术的发展，驱动产业创新，进而使得 RISC-V 进入更多高端应用领域，为全球开发者及客户创造更多的价值。

### 加群

如果您对 RISC-V 感兴趣，欢迎加入 RISC-V SIG 交流群，讨论更多关于 RISC-V 的更多内容，为推动 openEuler & RISC-V 生态贡献力量！

**中科院软件所吴伟微信**

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMa7ayvh1SIfRNI9ZbX7k4HbsySDpbp7roS51g7W1ws0Nor2dEXhTKYaJea3aLPibOSrh3Vib2XF5Jvw/640?wx_fmt=jpeg)

**「添加请备注 oerv」**

### 关于作者

杨延玲，中科院软件所 PLCT 实验室实习生，欧拉开源社区 RISC-V SIG 成员，目前在温州大学读研一，负责协助 RISC-V SIG 的日常运营。
