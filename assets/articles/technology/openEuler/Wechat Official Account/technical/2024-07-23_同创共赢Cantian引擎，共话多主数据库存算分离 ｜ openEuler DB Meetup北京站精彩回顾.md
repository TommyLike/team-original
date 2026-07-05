# [同创共赢Cantian引擎，共话多主数据库存算分离 ｜ openEuler DB Meetup北京站精彩回顾](https://mp.weixin.qq.com/s/IuWl6UZ4E4dmSMCJIPOOVQ)

[OpenAtom openEuler](javascript:void%280%29;)*2024-07-23 18:08:44北京*

 2024年7月19日下午，openEuler DB Meetup在北京圆满举办。本次活动由OpenAtom openEuler（简称"openEuler"）社区联合华为数据存储主办，北京中关村创业大街科技服务有限公司倾力协办，**汇聚了20余位数据库领域的行业专家及资深开发者，在此活动中，与会者深入交流，共同探讨多主数据库技术的创新进展及其在行业中的应用前景**。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/P4YNxf7deicWWfSPyspOI2l04qXMZnwuTPKNvicyDicFQ1WFxOuShP5tbicLIFONgNK0jVtsMHfrHJtMKHRLwO7RRA/640?wx_fmt=jpeg&from=appmsg&wxfrom=13)

参会人员合影

      在本次交流活动中，我们有幸邀请到一众行业领导与专家作为嘉宾，分别是华为数据存储分布式数据库领域总经理邵志杰、华为数据存储OSDT经理钟昭，openEuler技术委员会委员、DB SIG Maintainer陈棋德，openEuler DB SIG Maintainer习楚天，泽拓科技创始人赵伟、技术专家石松，云和恩墨数据库领域专家潘春秋，北京海量数据科技公司数据库专家李海珺，北京科蓝软件数据库专家师月山、曹平国，优炫软件技术专家王国军、王军，博云视觉的天诺，Cantain存储引擎架构师曹宇和王伟以及其他开发爱好者。

**开场致辞** 

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/P4YNxf7deicWrf4513BS2o9EGGCHaYKfKY5micuSfLsHbm4l0E8fnfk9kEiaPicXeKZTuEjyZZDgcT1cCR0ncaEWIQ/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

华为邵志杰

      活动伊始，华为数据存储分布式数据库领域总经理邵志杰进行了致辞，他表示**致力于把Cantian存储引擎打造成一款真正利他型的开源软件，并做到真利他**，始终以用户利益为出发点，做到不内卷，立足于中国，同时向全球开发者敞开怀抱，助力合作伙伴走向世界，并依托顶尖的存储产品，为社区伙伴提供全球顶级的舞台。

**精彩议程** 

     

     本次活动分别由**来自云和恩墨、泽拓科技、海量数据和华为的5位数据库领域专家带来了精彩的议题分享**。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/P4YNxf7deicWWfSPyspOI2l04qXMZnwuTxC65osUp4QG1XrBuK6iaPGooVtib6RkKZSsUaqHTEra9o9jiauRicEJ8Yw/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

      云和恩墨潘春秋

        **云和恩墨的技术专家潘春秋**凭借其深厚的专业知识和丰富的行业经验，对当前国内数据库的发展现状，技术趋势以及数据库在各行业中的应用场景进行了全面深入的解读，不仅揭示了国内数据库面临的诸多挑战，还分享了多个主流数据库细分场景的创新解决方案。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/P4YNxf7deicWWfSPyspOI2l04qXMZnwuTGiaLTyuLo2CYRnn7cJAafiaHlEibotmAdj51tTLlZO5afIugoLXmlykpw/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

  泽拓科技赵伟

     **泽拓科技创始人赵伟**为我们带来了MySQL/MariaDB和Klustron使用Cantian引擎架构、技术和优势的详细解读。构建Klustron for Cantian架构，存储与计算分离，可按需部署任意数量的计算节点，建立基于Cantian存储系统的高可用机制，既能完整保留Klustron的强大功能和生态兼容能力，又能充分发挥贡献存储硬件性能。最后赵伟又详细解读了泽拓昆仑Klustron高性能分布式查询处理技术体系。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/P4YNxf7deicWWfSPyspOI2l04qXMZnwuT43TjReibHJALPYJYy6OxkMUIbx5RBAfpyFo5prCKuA2oqzS3klgKshQ/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

  海量数据李海珺

     **海量数据技术专家李海珺**对基于资源池化的创新架构做了分享，海量数据库Vastbase G100是基于开源openGauss内核开发的企业级关系型数据库，Vastbase 资源池化架构提供主备机共享一份存储的能力，实现基于磁阵设备的资源池化HA部署形态，解决传统HA部署下存储容量较单机翻倍的问题，同时备机支持实时一致性读。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/P4YNxf7deicWWfSPyspOI2l04qXMZnwuTpDskHOhE4E9H5EjCSOLQYSBaYWTWdMvI5vJwhiaEZL3ziaiamKD3RQAiaA/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

  Cantian架构师王伟

      **Cantian架构师王伟**从在Cantian之前客户遇到的业务关键挑战说起为什么要做多主架构，及通过全局分布式缓存技术、分布式MVCC技术、多主集群高可用技术等打造一个可插拔的数据库多主高可用存储引擎。Cantian存储引擎当前已以插件无侵入修改的方式完美融入MySQL生态，未来会持续围绕存算分离架构，构建多模开放的开源技术生态。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/P4YNxf7deicWWfSPyspOI2l04qXMZnwuTJwMWJJ2BD9wsVY8vWB2PnkHK3E200YItzK6CoQkfwL9a1Nw4OnJTog/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

  DB SIG Maintainer 习楚天

       Cantian 24.06社区版本已于2024.7.11号正式发布，**openEuler DB SIG Maintainer习楚天为我们带来Cantian 24.06版本关键特性解读**。24.06版本具备高可靠同城容灾，可做到RPO=0、RTO&lt;60s，再结合企业级存储Active-Passive双活作为存储底座，可有效提高可靠性；同时Cantian 24.06支持多租户功能，使用户之间的资源隔离，具备资源池化编排的能力。

**热烈互动** 

      在本次Meetup上，数据库领域的大咖们汇聚一堂，不仅对数据库行业形势做了分析及讨论，更对多主数据库技术的创新应用进行了案例分享，围绕实际应用场景探讨多主数据库技术在提升数据处理能力、提高社区化开发效率，及下一步Cantian存储引擎社区版本应重点规划的关键需求等方面开展探讨，为加速多主数据库技术的创新发展提供了宝贵的思路。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/P4YNxf7deicWWfSPyspOI2l04qXMZnwuTo0pLZjORgA9jy6299KwZDGn8AqucyZCHTZdVAviavfwJQ43LDC4KsGA/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/P4YNxf7deicWWfSPyspOI2l04qXMZnwuTT8PD7Q9VRYlII9FYnlCndRBFOpG8UgePHqxu2NG73lI9KicAAdkYJ0w/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/P4YNxf7deicWWfSPyspOI2l04qXMZnwuTsbIBhiatR58TIOzgRyvyjbc2onznGJeVydKTv1P6QvvEr7ayI0zIAnw/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/P4YNxf7deicWWfSPyspOI2l04qXMZnwuT1Rd8oicghr55H9tCibvq0SmUtl7fJmOhmvnhAE1nE5EK1Aq8ibTWA8A5Q/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/P4YNxf7deicWrf4513BS2o9EGGCHaYKfKJpvpuv44lLCDU7GEOx1vuLP42sAr5seuShY1t8enoOwZT6EWticLutQ/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

**活动赞助**       

     本次活动礼品和茶歇由openEuler社区&华为数据存储赞助，活动场地由北京中关村创业大街科技服务有限公司提供。
