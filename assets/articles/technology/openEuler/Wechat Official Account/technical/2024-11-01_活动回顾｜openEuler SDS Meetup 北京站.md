# [活动回顾｜openEuler SDS Meetup 北京站](https://mp.weixin.qq.com/s/esM-nT_a_JVgiQQrd59PNg)

[OpenAtom openEuler](javascript:void%280%29;)*2024-11-01 19:00:00中国香港*

随着物联网、边缘计算、区块链等技术的蓬勃兴起，数据存储与管理的效率成为了数据中心竞争力的核心要素。SDS作为数据存储架构的先锋，正日益成为加速数据访问速度、增强存储灵活性的重要手段。10月26日，OpenAtom openEuler（简称"openEuler"）SDS Meetup北京站圆满落幕。本次交流活动由openEuler社区和联通数科联合主办，邀请多位业内专家，围绕SDS技术的最新进展，深度剖析了在实际应用场景中的成功案例，共同探索了SDS技术在提升数据存储效能、降低运维成本方面的广泛应用与后续发展。

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mBfQyoicJCgg7CqJM5MwskC6cHaL5qGm5xmNgM4AR8fASZP1iat0myxhoqNV21crhOF5eicNg92LhXAA/640?wx_fmt=jpeg&from=appmsg)

精彩回顾

“

**Ceph SPDK NVMe-oF Gateway Evaluation on openEuler**

Linaro高级工程师、openEuler SDS SIG committer刘新良分享了其在openEuler平台上验证和使能Ceph NVMe-oF方案的实践，Ceph NVMe-oF方案旨在Ceph存储基础上为不支持RBD客户端的平台提供块存储，本质上是使用更通用的NVMe-oF协议取代现有的iSCSI协议。他介绍了介绍 Ceph SPDK NVMe-oF Gateway 在 openEuler 上的验证和评估。

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mBfQyoicJCgg7CqJM5MwskC6o9YfxMbeVON5Uoib3xicrs7icWwYN5yQkoh4nHeYJaf5L564bF4kdrOLw/640?wx_fmt=jpeg&from=appmsg)

“

**Crimson: 下一代 Ceph-OSD**

英特尔亚太研发有限公司工程师、Ceph SeaStore Lead程盈心介绍了Ceph下一代OSD Crimson的架构设计和开发进展。Crimson从架构设计上更适合多核扩展，具有线程间无共享、无锁、NUMA感知的内存分配等特点，提供了相比classical OSD更灵活的冷热数据分层配置。已经发布社区预览版本，社区开发团队正在完善验证用例、开展性能优化，推动在生产环境中部署使用。

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mBfQyoicJCgg7CqJM5MwskC6VeXsu5f2tBx5VQSnYRsicZl2bC3ibUG3ocZ6ciazaQ9fCn7gZBa0bhboQ/640?wx_fmt=jpeg)

“

**基于 Log-Structured 的分布式存储架构设计**

大道运行产品研发经理 周磊，介绍了大道云行全闪存分布式存储产品的架构设计，充分考虑NVMe SSD性能好但成本高、寿命低的特点，通过用EC纠删码替代副本机制大幅提升了磁盘得盘率，选用Log-Structured日志结构化存储，减少EC小IO写放大、提升随机写IO性能和延长磁盘寿命，实现使用EC4+2方案的2.X产品的随机写吞吐和时延与使用三副本策略的1.X产品相近。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBfQyoicJCgg7CqJM5MwskC6aVc9bD7aD0U7ruYxUCgCsLk3n9qr8QspW6iaLL7lQiaYobVx3u9Mibpyw/640?wx_fmt=png&from=appmsg)

“

**openEuler 社区高性能存储项目 fastblock 开发进展**

联通数科高级工程师、fastblock owner吴兴义介绍了openEuler社区孵化的高性能块存储项目 fastblock 的开发进展。fastblock是为了解决性能和时延问题而生的，架构设计充分使用现有的SPDK框架：用户态NVMe驱动、无锁队列，以充分发挥NVMe SSD的高吞吐低时延的性能。已完成多网卡功能、集群部署、打包工具、命令行工具等特性的开发，计划年内发布稳定版本。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBfQyoicJCgg7CqJM5MwskC6IjKTMCe8DOU66tMicdvVlaMsBJ24Fym9MBCZYTjibJibI4bvs9vDa2aTw/640?wx_fmt=png&from=appmsg)

“

**SPDK 使能 UADK 加速压缩和加解密**

华为高级工程师、openEuler SDS SIG Maintainer刘秦飞介绍了在SPDK上使能鲲鹏硬件加速器加速数据压缩和加解密的实践。存储效率和数据安全是数据中心两个非常重要的考虑因素，但数据压缩和加解密是计算密集型操作，会消耗大量的 CPU资源。在kunpeng平台上，利用kunpeng硬件加速器加速SPDK中的压缩和加解密操作，可以实现吞吐和时延的优化。

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBfQyoicJCgg7CqJM5MwskC6Mdy89Z0HRDyKH7dJiag3Kz5RAdMO3mKqgUdtrJgQQ2W6tnIefOlA5nw/640?wx_fmt=png&from=appmsg)

彩蛋

本次 Meetup 的分享材料已上传至 openEuler Gitee仓库。欢迎前往下方链接获取，期待您的下次参与！

链接：https://gitee.com/openeuler/presentations/tree/master/meetup

本次 Meetup 直播回放已上传至 openEuler 视频号。如果您错过了本次线下活动，可前往视频号（OpenAtom-openEuler）查看活动回顾，期待您的下次参与！

我们欢迎与 openEuler 一起组织开发者活动，共同探讨前沿技术和开源发展趋势，分享创新成果和实践经验，与 openEuler 社区共同成长！点击文末阅读原文即可申请。

[阅读原文](https://www.openeuler.org/zh/interaction/event-list/collect/)
