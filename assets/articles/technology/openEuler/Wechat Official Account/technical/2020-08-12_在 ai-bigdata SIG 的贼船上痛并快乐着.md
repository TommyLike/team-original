# [在 ai-bigdata SIG 的贼船上痛并快乐着](https://mp.weixin.qq.com/s/puz0tzedZqgtMZBqcsBTLw)

原创*hubble*[OpenAtom openEuler](javascript:void%280%29;)*2020-08-12 22:30:04*

记得在本科毕业的时候，人工智能和大数据才刚刚火起来。

我在大学的时候选修过人工智能，但半年的课程，又是选修，你懂的~~最后只接触了一些分类、预测算法的皮毛，也没有项目实践。

所以毕业的时候觉得人工智能、大数据这俩东西很神秘，猜不透。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7gG5buqruYAjkoNcE7Rlcrx8jsZT2MK24JagWsEUj5VxcibB1n7KUy5lsltChLSBkicndKCmYrvTw/640?wx_fmt=png)

工作后我依然保持浓厚的兴趣，经常自己看一些相关书籍关注一些技术前沿，但毕竟每天要完成工作，并且没有人带领，也没有人交流，两年下来感觉还是很虚，我决定必须改变这种现状。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7gG5buqruYAjkoNcE7RlcxtKWhwqrnho9xiaJKhyQMZl5Qe4ibg8XLFDo3A1WnGticjAx2d4z2a77g/640?wx_fmt=png)

非常偶然的机会我发现 openEuler 上有个 ai/bigdata 的特别兴趣组(SIG)，说起来真的很巧合，当时不知道从哪看到 openEuler 的网站。

浏览时看到了邮件列表，点击后填入邮箱然后回复了确认，就没有在意了。

后来整理邮件时发现了很多大数据和人工智能方面的讨论，比如 Spark、TensorFlow 的安装，hadoop 单机部署和集群部署方式，大数据和人工智能的发展趋势分享，hadoop 在 aarch64(那时候还不知道是啥)上的支持情况，Flink 在 openEuler 上的支持情况(当时以为所有的 OS 都一样)等。

这些我有时间自己阅读下，觉得收获还挺多，尤其是一些安装、使用问题正好是我在部署时也遇到了的。除了这些，也有例会链接，我偶尔上去听一下，看看这些领域专家们都在干什么。

自己虽然有兴趣，一直关注相关资讯，但毕竟纸上得来终觉浅，所以感觉例会上的内容应该都非常高大上。

但是通过观察，我发现例会上大家的水平也是层次不齐，有项目经验丰富，走在 ai、大数据领域技术前沿的架构师，也有 ai、大数据组件上游社区的老专家，也有对客户提供服务的厂商，经常分享客户对 ai，大数据软件的诉求。

当然最多的是一些 ai、大数据开发者、爱好者，最最重要的是，我发现大家并不都是在这个领域很擅长，也有一部分像我一样的小白用户，而且很多项目我感觉我也可以参与，慢慢的我在邮件列表里和例会上也活跃起来，也利用业余时间参与一些项目，在这里逐渐找到了一批志同道合的朋友，一起进步，互相鼓励。

当遇到问题时在邮件列表里也能得到快速响应，自我感觉没有那么虚了，当然我也牺牲了很多休息时间，有时候为了完成社区任务，搞到半夜一两点，还是很痛苦的，第二天也有点吃不消，不过能够得到技术积累，并得到大家的认可，自我感觉还可以。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMa7gG5buqruYAjkoNcE7RlchsMAVauJpibnNmnGmjhXXzz561PCSiaxanqu0H8iczL3EEbfTj4ibO8qibA/640?wx_fmt=jpeg)

我总结现在社区主要的工作差不多有这几种：

#### **完成 openEuler 上 ai/bigData 软件栈的支持**

openEuler 是一个完全基于上游社区构建的一个操作系统，因此所有的运行环境都需要从零支持，kernel/glibc/gcc 是这样，jvm/python 是这样，因此spark/tensorflow 也是这样，需要将 ai/bigdata 的常用软件引入到 openEuler 上，而且还需要让这些软件的功能完整，性能更好，更易用，因此有很多选型、编译、打包、测试、开发的工作量(好几百个，大家理解为啥搞到2点了吧，我在公司也没搞这么晚，这就是爱好吧。害~

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMa7gG5buqruYAjkoNcE7Rlc86Oq85ULIK54j32JQ1SrTBbEp1rKCWHbKnWjicT5U86Cibja1VAm4e9g/640?wx_fmt=jpeg)

说到这个，我解释下，刚开始我也挺纳闷，直接把 tar 包解压缩了或者使用 pip install 不就行了吗，我虽然用的少，但是我看网上 SUSE/CentOS 上都是这样啊。我是参与了一段时间后，并且和社区的大佬们交流才逐渐明白这个道理，并且搞明白了为什么有这么多成熟的操作系统，CentOS/SUSE/Ubuntu，还要再搞一个，我只能说自己太年轻，江湖水深啊~~

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMa7gG5buqruYAjkoNcE7RlcOW454ePdnczIHibem8hu3zibMziaIjdlCicVSG3Y1Z4BBGjZ0n8XT8ov8A/640?wx_fmt=jpeg)

#### **在 openEuler 上搭建一个统一平台**

构建一个 ai/bigdata 的统一平台，屏蔽底层硬件和软件差异，让小白用户可以快速上手，让使用者专注于自身业务。

以前看大数据，人工智能只知道 spark、tensorflow、人脸识别、机器视觉、深度学习、机器学习，根本搞不清楚关系，经过一段时间，终于搞明白了这些关系。

大数据是一个领域，包含数据摄取、数据存储、数据处理、工作流调度，可视化等，每一个过程还包括很多不同组件，每个组件各有特点。

比如数据存储里有 mysql、postgresql 等关系型数据库，有 mongodb、ravendb 等文档型数据库，hdfs、alluxio 等分布式文件系统，还有键值数据库、图数据库、列数据库、时序数据库，数据处理里有 hadoop、spark、flink、beam 等，数据摄取有 chukwa、kafka、flume 等。人工智能领域也有 scikit-learn、tensorflow、pytorch 等各种框架。

那么对于使用者如何在众多的组件中选择，选择后如何安装，安装后如何使用这些都是非常头痛的问题。如果选了一个用了一段时间后，发现不合适需要换，又有很多重复工作量。

#### **尽量帮助爱好者解决使用过程中的相关问题**

这个没啥说的，大家都是爱好者，互相帮助是应该的，用自己的力量为其他人提供方便，可能就是一种自我价值体现，帮助的过程中自己的能力提升了，威望也提升了，还结交了很多朋友，以后自己遇到问题也会得到帮助。

哈哈哈，另外大家一起搞项目，不帮也不行啊。

说实在的，搞了快半年，几乎没怎么睡过早觉，也没有过周末和假期(嗯，也得感谢疫情)，收获也是实实在在的。

通过帮助其他人并参与社区项目，现在 openEuler 里 ai/bigdata 领域的软件栈总算从无到有总算建立起来了，想想自己参与了国内最大开源操作系统ai/bigdata 软件栈构建就很激动，以后万一我有了孩子是不是可以吹嘘一番呢，美滋滋。

自己在 ai/bigdata 领域的技术积累肯定是有很大提高，结交了一些志同道合(水平相当)的朋友，也在圈子里慢慢有了一些小名气。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMa7gG5buqruYAjkoNcE7RlcfHf0QeIdBdS30bXb11of4xibfszwfez62uxibPn2HS8V4OiaibqsN59fxQ/640?wx_fmt=jpeg)

加入 openEuler 上的 ai-bigdata SIG 已经有一段时间了，虽然牺牲了很多睡觉时间和刷手机的时间，还要熬夜，但自我感觉期间收获了很多，起码和之前天天自己漫无目隔三差五的看资料好多了，回头也打算把自己的一些经历记录下来

就以博客不定期连载的方式吧，这就是第一篇~

不过，作为程序员……，最讨厌也是最不擅长的事就是写文档 ORZ（仅代表个人意见），文笔不好多多包容。就凑合看看吧~

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7gG5buqruYAjkoNcE7Rlcan2SsOYqGFfT53nSUU5AtBfbibibW1OBmT2b1qU4pENW0AgBNN7WHpXw/640?wx_fmt=png)

最后，ai-bigdata SIG 对所有开发者 open，欢迎大家加入到 ai-bigdata SIG 中来一起贡献，一起提高。

邮件列表

*https://mailweb.openeuler.org/hyperkitty/list/sig-ai-bigdata@openeuler.org/*

微信群

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMYRQzXKpDffmGDftpicqh3VenXWIc7Gib1X81Rl9DKH5onDbjbqEh9kCD5I06wjvII36XL9RWp1RRHw/640?wx_fmt=jpeg)

如果二维码失效，欢迎添加 “softcorepro”

回复“aibigdata”，即可入群

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7gG5buqruYAjkoNcE7RlcWyt0wicZz3ZScSG9uhE9eZoFibbPIsAoV10zDtpZiaUMpoXcLgIoPc1nQ/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYRQzXKpDffmGDftpicqh3VerYvFAVw3laA66UO0ky9GeNualmCFS9YAg4GicxpMkbUx5G0ISffqdrg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYRQzXKpDffmGDftpicqh3VeDAg9GvysGTghWQicrbgOFjRmgxvia4vFTFpMrfCNCkQqbH1AMYK4P4ag/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibOspOSKHic8Nh8icmf9xozgIK5j5ibJibMLzCLhbSoicDQOrVDQpZKX2nkBA/640?wx_fmt=png)

***观众老爷们不考虑点一波关注***

***支持一下这个快要秃顶的主编吗？***

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbR3YNaNBytF0uqAicKL7fRD0JJj1HibCo2Sic0qxQ1LkZPlLqibMPxWUBBGeOOicicX3yY8e2icz81TU7Fg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYCjA16Qbj8RtLq6ZdzGlsR9Llaa49Bia9A8SlgicOgPZoDYZB2pxuLtp7FkmXvaIoZHRBUkAB6hA7w/640?wx_fmt=png)
