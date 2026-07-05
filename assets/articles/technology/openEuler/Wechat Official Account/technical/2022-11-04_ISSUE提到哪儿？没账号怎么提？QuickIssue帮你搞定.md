# [ISSUE提到哪儿？没账号怎么提？QuickIssue帮你搞定](https://mp.weixin.qq.com/s/STK0-baRUAZD4Uu5mPXEAg)

[OpenAtom openEuler](javascript:void%280%29;)*2022-11-04 19:00:00*

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYYw9uTd2b9GnRomxPGfxOiaE6acDBmUs8EMF2lhGNXujrKiadjE0rws64OqTAJNsCkRqeSUJvL4KyQ/640?wx_fmt=png)

本文作者：曹志（georgecao）

关于作者：曹志（georgecao）openEuler 技术委员会委员\\Infrastructure、Gatekeeper、sig-reproducible-bulids 三个SIG组的Maintainer。

**前言**

一个活跃的开源社区，每天都有大量的issue和PR在交错提交、处理、关闭。建立issue时如何准确地提交到对应的仓库？查询issue时如何精准查找到需要的内容？成了开发者所关注的重点。

为此，QuickIssue——一个更快捷的issue分类提交工具上线了！

**背景**

openEuler社区成立以来，issue管理平台也经历了几轮迭代。从代码托管平台Gitee到Bugziila服务，openEuler不断地完善社区的issue管理平台。

![](https://mmbiz.qpic.cn/mmbiz_svg/9UjCmequjU99Yic13ibk9d5XRDeC2x37j0xetKhxs2uZ2wGeauucsO5vejjicYwQwVrhnyonYEzOkksv2y7Ea5B8PgZIeRlvecK/640?wx_fmt=svg)

**Gitee平台issue管理**

自openEuler社区成立以来，为开发者提供的问题跟踪服务是由代码托管平台Gitee提供的issue管理服务；

该服务的优点是：

1\. 可以很好的将记录问题的issue信息与问题解决的PR关联在一起;

2\. 系统提供了相应的issue提交、修改、查询等操作;

3\. 有一些简单的统计功能可以统计并导出整个社区所有的issue；

然而，该服务也有一些不足：

1\. issue提交的入口比较'散'，issue都'散'落在各个代码仓库中，而很多社区使用者或开发者并不清楚需要将自己发现的问题提交到哪个仓库，从而阻碍了issue正常提交；

2\. Gitee平台要求issue提交人必须使用gitee账号登录才能提交，而部分社区使用者没有gitee平台账号信息，从而影响issue提交；

3\. Gitee平台数据量大，从而导致在问题筛选、过滤等方面响应速度不够快捷，处理逻辑也和社区开发者预期有出入，给使用者带来不便；

![](https://mmbiz.qpic.cn/mmbiz_svg/9UjCmequjU99Yic13ibk9d5XRDeC2x37j0xetKhxs2uZ2wGeauucsO5vejjicYwQwVrhnyonYEzOkksv2y7Ea5B8PgZIeRlvecK/640?wx_fmt=svg)

**Bugziila服务**

由于Gitee平台在问题筛选、过滤等方面响应速度不够快捷，社区开发者呼吁社区提供一个openEuler自己的问题跟踪服务。社区基础设施在2021年年初提供了Bugzilla管理系统。该系统是一款用perl语言开发的开源服务。然而，该系统上线后因为难以对接Gitee平台已有的issue，界面风格陈旧，用户注册管理繁琐，所以注册使用者寥寥无几。

（因Bugziila与QuickIssue功能重叠，社区计划于22年年底下线Bugzilla服务）

**QuickIssue：一个更快捷的issue分类提交工具**

openEuler基础设施团队在深入分析社区需求后，决定提供一个能够满足社区发展的问题跟踪系统，以解决上述问题，QuickIssue应运而生。

![](https://mmbiz.qpic.cn/mmbiz_svg/9UjCmequjU99Yic13ibk9d5XRDeC2x37j0xetKhxs2uZ2wGeauucsO5vejjicYwQwVrhnyonYEzOkksv2y7Ea5B8PgZIeRlvecK/640?wx_fmt=svg)

**简介**

QuickIssue是一个更快捷的issue分类提交工具，在提交issue上有一些独特的优势：

1\. QuickIssue在openEuler官网提供统一的issue提交入口，开发者在提交issue时更便于查找对应仓库；

2\. QuickIssue提供了两种提交issue的方式，无论开发者是否有Gitee账号，都可以提交issue；

3\. QuickIssue可以指导用户或开发者将issue提交到某个仓库中，也有默认的仓库可供开发者提交issue；

4\. QuickIssue只为openEuler服务，保证查询、搜索、筛选等操作足够顺滑；

5\. 可以和社区已有的SIG管理、贡献统计等服务互通信息。

![](https://mmbiz.qpic.cn/mmbiz_svg/9UjCmequjU99Yic13ibk9d5XRDeC2x37j0xetKhxs2uZ2wGeauucsO5vejjicYwQwVrhnyonYEzOkksv2y7Ea5B8PgZIeRlvecK/640?wx_fmt=svg)

**功能亮点**

QuickIssue提供三个主要功能： 新建issue，查询issue，查询PR，可以为开发者提供更便捷的issue提交服务。

**新建issue**：

1\. 统一了issue提交入口，openEuler社区的所有issue都可以通过这个入口提交；

2.解决了issue提交人没有代码托管平台账号的问题，可以直接使用邮件和验证码完成issue提交；

3\. 优化了issue提交人查找issue归属仓库的途径，可以按图索骥找仓库，也可以直接提交默认仓库;

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYYw9uTd2b9GnRomxPGfxOia90zl0pQ5DcDwAkoSsRhCujURfKbC5CHibF9CbUH1hyKmUwGCsdDE4gQ/640?wx_fmt=png)

QuickIssue提供两种issue提交方式。

1\. 通过gitee账号提交，QuickIssue会指引提交人根据不同的领域选择合适的SIG组，进而选择合适的仓库来提交；提交issue后对该问题的所有讨论交流都可以直接评论；

2\. 通过邮件方式提交，QuickIssue会根据验证码确认邮箱有效性，通过验证后将通知机器人代替提交一条issue，且如果issue提交后在issue评论区有任何评论，QuickIssue都会贴心的将每一条评论都通过邮件通知到提交人。

**查询issue：**

QuickIssue服务会展示openEuler社区所有的issue信息。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYYw9uTd2b9GnRomxPGfxOiaLwicxXS7YyOSPcWuMar8rqUiaqFqYcxDyS2BVhrnfqERwE7WhibTIYfAA/640?wx_fmt=png)

针对不同的使用场景，QuickIssue提供了较为便捷的筛选功能，开发者可以按照自己需求定向查找。如果需要查找通过邮件提交的issue，可以在提交人一栏输入邮箱前半段筛选。

**查询PR：**

QuickIssue会展示openEuler社区所有的PR信息。开发者通过PR状态、提交人、标签等信息可以筛选出满足场景的PR。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYYw9uTd2b9GnRomxPGfxOiaeV0ibIID8Vn1CoCibHlFVruEBNJ4mOw3iathgcsQ43PK76I9gP5G5mWFA/640?wx_fmt=png)

QuickIssue中只包含openEuler社区的全量PR，比代码托管平台自身所管理的PR信息量少很多，且系统采用了缓存数据，查询操作响应速度有保障。

![](https://mmbiz.qpic.cn/mmbiz_svg/9UjCmequjU99Yic13ibk9d5XRDeC2x37j0xetKhxs2uZ2wGeauucsO5vejjicYwQwVrhnyonYEzOkksv2y7Ea5B8PgZIeRlvecK/640?wx_fmt=svg)

**Quickissue服务地址**

1\. 可以直接通过域名访问：

https://quickissue.openeuler.org/zh/

2\. 可通过openEuler官网-&gt;【社区】 -&gt; 【QuickIssue】跳转

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYYw9uTd2b9GnRomxPGfxOiazjxExOe9QqQQnD9Tx8SvTQwqGGyU31vyxGM8gIhnyrSibciavIcGqL2g/640?wx_fmt=png)

3\. 可通过官网主页的QuickIssue悬窗直接进入

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYYw9uTd2b9GnRomxPGfxOia8tTiazIiciaUjxeFEiaicKVlUJv7mic2G3IzibNTnjsbRhYu4PwyJzvZeCSzQ/640?wx_fmt=png)

（openEuler官网地址：

https://www.openeuler.org/zh/  ）

![](https://mmbiz.qpic.cn/mmbiz_svg/9UjCmequjU99Yic13ibk9d5XRDeC2x37j0xetKhxs2uZ2wGeauucsO5vejjicYwQwVrhnyonYEzOkksv2y7Ea5B8PgZIeRlvecK/640?wx_fmt=svg)

**联系方式**

社区在飞速发展，服务也在快速迭代，不论是在使用过程中遇到任何问题还是对QuickIssue有新的需求和想法，欢迎反馈给Infrastructure SIG组：infra@openeuler.org ，让QuickIssue能更好服务社区。
