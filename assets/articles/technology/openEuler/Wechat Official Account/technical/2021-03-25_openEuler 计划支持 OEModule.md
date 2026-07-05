# [openEuler 计划支持 OEModule](https://mp.weixin.qq.com/s/zNoJkB23aSZ-ISY8Z86SJQ)

[OpenAtom openEuler](javascript:void%280%29;)*2021-03-25 18:17:52*

根据 openEuler 技术委员会讨论决定，在 openEuler 20.03 LTS SP2 版本中，首次推出 OEModule 的特性。

OEModule 是 openEuler 20.03 LTS SP2 版本中的一个新特性，它是 openEuler 新出的一种应用程序集合。在增加 OEModule 特性后，操作系统软件包被分为了 Base 、Application 和 OEModule 三部分。

如果把 openEuler 比做成 iOS，那么 OEModule 就类似于 iOS 中的 App Store。只不过 OEModule 中的应用程序下载时可以手动选择版本。

系统在使用 OEModule 特性后，系统功能和应用程序之间的的分工会更加明显，这无疑对于操作系统来说是极好的，Base 和 Application 负责提供底层及偏上层的操作系统的核心功能，以 RPM 的格式提供，而应用程序这可以通过 OEModule 动态选择，每个应用程序在 OEModule 中被称为 module。

我们常见的 MySQL、Nginx、PHP 在 OEModule 中被称为一个 module 。每个 module 又可以包含多个 stream，也是多个版本，可以根据实际的使用情况选择适合的版本安装。

OEModule 是操作系统的一个新的试验场，对于操作系统的开发者，可以通过 OEModule 获取最新的特性。对于后续稳定版本操作系统的开发起着风向标的作用。

目前 openEuler 的 OEModule 的 roadmap:

```
├── 2021.02：为满足越来越多 OSV&ISV 对于 openEuler 支持多版本软件的诉求，调研 openEuler 引入多版本软件包后依赖关系的冲突及可能解决的方案；
    └── 2021.03：基于 openEuler 当前的 OBS 构建系统及 gitee 代码仓管理的方式，做 OEModule 的方案设计，并且与同样致力于此的社区其他 sig 组交流想法，分配一同开发的子任务；
        └── 2021.04~2021.05.10：OEModule 特性开发及联调阶段；
            └──2021.06.30(21.03 SP2): 落地 openEuler 21.06 版本，对外公布

```

如果你对这个特性感兴趣，欢迎联系夏森林。

联系方式：

- Giteeid:small\_leek
- 邮箱：xiasenlin1@huawei.com

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYX6OJ6sKnPIKiadTdMKJE1REz9KGvVTdCcNoZaQ2iby2vekIuiczcgLlaicKUZ6XJW4MpHibQAat5JwzA/640?wx_fmt=png)
