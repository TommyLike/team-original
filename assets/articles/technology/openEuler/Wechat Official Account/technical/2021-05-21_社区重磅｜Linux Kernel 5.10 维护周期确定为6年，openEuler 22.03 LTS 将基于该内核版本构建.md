# [社区重磅｜Linux Kernel 5.10 维护周期确定为6年，openEuler 22.03 LTS 将基于该内核版本构建](https://mp.weixin.qq.com/s/ab7xvMxAcKWWBSnga54YGA)

原创*周荔人*[OpenAtom openEuler](javascript:void%280%29;)*2021-05-21 16:00:00*

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMacTicusNYbDXZMo3MVvtNibL1qIJXO7ZDPKwf9Tm4Fj9vjibdEDj9xUtw2iaIfp1XepG5kgvQUfTAPtA/640?wx_fmt=png)

Linux Kernel 5.10 维护周期已经延长至2026年

经过 Linux Kernel 社区成员的共同努力，Linux Kernel 5.10 维护周期最终确定从2年延长至6年。华为是第一个在 Linux Kernel 社区公开承诺，可以投入资源，协助 Greg 进行 Linux Kernel 测试和补丁回合的公司。openEuler 22.03 LTS 将基于 Linux Kernel 5.10 构建。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMarQxHZIEfUSib4U1WUhQds9M1aJ7zqIPQsn2PQlLflqRPWia5wGfl3VkyyaNboufTHnroKH7Wnw6Qw/640?wx_fmt=jpeg)

### Linux Kernel 5.10 维护周期 2 年？6 年？

1 月 26 日，Linux Kernel 主要维护者 Greg 表示：“目前由于人员和资金投入问题，Linux Kernel 5.10 的测试和维护可能只会维持 2 年，虽然不排除维护到 6 年的可能，但需要其他公司与组织愿意伸出援手。”

各个厂商对于该邮件的反馈各不相同：华为、Google、Linaro 等厂商公开表达了对 Linux Kernel 5.10 以及长维护周期支持的强烈需求。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMacTicusNYbDXZMo3MVvtNibLoqibsWXauYtztnoz9NF66xMVpxzLUEHHEsKFUPhpY9JSaWzvMKnfiazQ/640?wx_fmt=jpeg)

Linux Kernel 子系统 Maintainer

openEuler Kernel SIG Maintainer

华为 OS 内核实验室技术专家 郭寒军

给 Greg 回复邮件中可以看到， Greg 在向 Linux Kernel 社区寻求支持

根据 Greg 最近在[华为系统软件创新峰会](http://mp.weixin.qq.com/s?__biz=MzI2NDE4OTE2Mg%3D%3D&mid=2247487645&idx=2&sn=6fbb4f24f4d3332a87c60ecead29358d&chksm=eab13518ddc6bc0ee1449b33ea828f98d98508cb26e9feaefd442c4d3f98632b41c284939e8b&scene=21#wechat_redirect)上的分享，在 Linux Kernel 5.6-5.11 版本中，每天有 8900 行新代码、2500 行代码被删除、2100 行代码被修改、每 2.5 个月出一个 Linux Kernel 稳定版……，测试和回合补丁的压力可见一斑。

华为在 Linux Kernel 社区的 Maintainer 在看到该邮件后，迅速在公司内部展开讨论。

华为在 Linux Kernel 5.10、Linux Kernel 5.11、Linux Kernel 5.12 的补丁贡献排名分别是 Top1、Top5、Top5，在 Linux Kernel 5.6-5.11 的公司代码总贡献量中，华为排名 Top3，代码量占比 5.8%。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMarQxHZIEfUSib4U1WUhQds9X4w4C2b5pAcZJD7jhRgDdU6icIJDZ1oAKsmaia07QV6eFic8CNQRnFF2g/640?wx_fmt=jpeg)

基于这样的内核贡献能力，华为确认可以投入资源，协助 Greg 完成相应的测试和补丁回合工作，希望可以通过这种方式把 Linux Kernel 5.10 的维护周期延长至 6 年，**并第一个在 Linux Kernel 社区邮件中公开表态**。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZsDTyEea8puqefqaEFfPDwVia1buNBOXvzYk8iaPKW4QJKW9qgsq1VNCQkwM9DmTDxVZ6MYZQfIlRQ/640?wx_fmt=png)

华为协助维护的不仅是 Linux Kernel 5.10 版本，还要协助完成现有的三个 Linux Kernel LTS 版本（4.14、4.19、5.4）的测试和补丁回合工作。

华为将先从内核测试工作开始，使用 HULK Robot 挖掘内核 bug，并对补丁进行测试。从 x86 和 Arm 架构的入手，后续延伸到其他架构。

截止目前，华为已经测试了 Linux Kernel 4.14、Linux Kernel 4.19、Linux Kernel 5.4、Linux Kernel 5.10 在 x86 和 Arm 架构上总计 6000 多个用例，后续会增加到约 1 万用例。

Greg 和 Linux Kernel 社区中的多名资深专家在邮件列表以及 Twitter 上给予华为很大的肯定。体现了华为作为 Linux Kernel 社区贡献者的技术实力和责任担当。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZsDTyEea8puqefqaEFfPDwECiaicUakdqxSo8w1Ih0XLbKY7DjiaCtWBcY6D7B4p6TGFMiacnsTUwvbQ/640?wx_fmt=png)

Greg 在社区邮件列表的回复

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZsDTyEea8puqefqaEFfPDwZNBYBl6gicVRTaiaxrj0jicVfYDZsNrMLXrBNS5UNfo49ADuQMIAf65bw/640?wx_fmt=jpeg)

Greg 在 Twitter 的回复

**经过 Linux Kernel 社区成员如华为、Google、Linaro 等共同努力，以及 Linux Kernel 社区的内部讨论，最终确认，Linux Kernel 5.10 的维护周期从2年延长至 6 年。**

### openEuler 22.03 LTS 内核将基于 Linux Kernel 5.10 构建

根据 openEuler 社区的版本生命周期，openEuler 22.03 LTS 版本将于明年发布，届时将会使用 Linux Kernel 5.10 作为该版本的内核，为 openEuler 社区和 Linux Kernel 社区提供稳定的内核，贡献力量。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZsDTyEea8puqefqaEFfPDwejUNDWesicJshGFk1n3V4IricZbOVuI90aRmXK93RZVUZcqP8bxZCqRA/640?wx_fmt=png)

openEuler 版本生命周期

[![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMarQxHZIEfUSib4U1WUhQds9fiaw4vRBkOOvJzWTeJUUUyFvRywdrt7VVyndB7gRILeX5au88DMlriaA/640?wx_fmt=jpeg)](http://mp.weixin.qq.com/s?__biz=MzI2NDE4OTE2Mg%3D%3D&mid=2247488310&idx=1&sn=5046628b2119bb2ced51c7f8abe39b0d&chksm=eab136b3ddc6bfa52e6d8ef4cf7e9b09d0ed48aa52c6d1e280bf6a4c834707a581bc33f069ee&scene=21#wechat_redirect)
