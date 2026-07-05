# [「转」OERV 双周报：RISC-V生态加速发展及多项技术进展公布](https://mp.weixin.qq.com/s/dbE0QO500FukSSabA-IIEQ)

*OERV*[OpenAtom openEuler](javascript:void%280%29;)*2024-07-16 17:55:12中国香港*

欢迎阅读 OERV 双周报专栏，今天是专栏第二期。本专栏定期介绍 OERV 团队的工作进展、社区事务以及相关活动资讯，希望与大家一起学习进步。欢迎感兴趣的伙伴们在公众号后台留言讨论！

**新闻快讯**

1. OERV 团队将参加7月26日在北京举办的 OpenAtom openEuler（简称"openEuler"） SIG Gathering 2024，目前已经在多样性算力论坛申报五个议题，囊括 Kernel、工具链、核心库、虚拟化和嵌入式多方面的讨论
2. openEuler RISC-V 24.09 发版验证工作正式启动，本次发版包含主版本和 LLVM 平行宇宙版本。其中 LLVM 版本在本次发版中会扩充到全量范围支持，对齐主版本质量控制策略，同时针对特定场景进行针对性优化以展示竞争力
3. 在与多家厂商协调意见后，RVCK 项目于七月份初步启动，RVCK 是 针对 RISC-V 的 Linux 6.6 LTS 版本同源内核维护项目，目前已经有多家 RISC-V 硬件厂商共同参与，项目细节将在八月份的 RISC-V 中国峰会上由 OERV 阐述

**核心进展**

1. openEuler 原生的 A-Ops 智能操作工具集组件 gala-gopher 初步完成移植，目前已跑通单元测试 @laokz
2. 完成对 EulerMaker RISC-V 架构 Everything 和 Epol 仓库依赖关系检测 CI 系统 @wangliu-iscas
3. 完成对 TH1520 第三方版本 SDK 升级，并且支持对 Chromium 的 GPU 硬件编解码能力 @misaka00251
4. 初步完成 OERV 官网域名服务（oerv.ac.cn）搭建，已经完成 etherpad和问卷后台建设 @misaka00251
5. Hadoop 相关软件包完成本地部署并且验证图形化功能，并且已经完成社区内部标准化打包方案 @dingli
6. 在 QEMU 下完成 rpmsglite 对 Uniproton RISC-V 的移植验证 @tiberium

**更新修复**

1. trace-cmd: 升级到3.2 版本解决内核trace工具陈旧报错问题 #24.03LTS @shafeipaozi
2. Mugen: 完成对 Mugen 20多个测试用例修复 #master @OERV-QA @jiewu
3. jboss-dmr: 移除构建中的无用参数并修复了意外跳过测试的问题 #master @dingl
4. chromium: 修复配置文件不正确导致的构建错误问题 #master @sunyuechi

**联系我们**

对 OERV 工作感兴趣的伙伴们可以添加下方的微信并且加入到 openEuler RISC-V 社区开发群，获取更多即时信息

**中国科学院软件研究所 王经纬**

![](https://mmbiz.qpic.cn/sz_mmbiz_png/tkVlnC85sFEDN5mleLnfdN4Upia6vq9yd2tS7tXEQWeqY4An4eF3YwicmdTYXc72DP0W9J6D9SibLQbDiaphIJyL4g/640?wx_fmt=png)

添加时请备注 OERV

**相关链接：**

- Gitee 协作主页:
  
  - https://gitee.com/openeuler/RISC-V
- 构建仓库协作地址:
  
  - https://build.tarsier-infra.com
- 第三方 repo 源:
  
  - https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V
- OERV 工作中心：
  
  - https://github.com/openeuler-riscv
- 邮件列表:
  
  - riscv@openeuler.org
- Discord 邀请链接:
  
  - https://discord.gg/f9znRFjh
