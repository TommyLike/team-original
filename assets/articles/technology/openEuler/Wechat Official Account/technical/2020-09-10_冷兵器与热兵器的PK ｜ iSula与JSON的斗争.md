# [冷兵器与热兵器的PK ｜ iSula与JSON的斗争](https://mp.weixin.qq.com/s/rILQemQGJAPvbvPjiBDBKg)

原创*haozi007*[OpenAtom openEuler](javascript:void%280%29;)*2020-09-10 12:39:21*

对于各种习惯高级语言的伙伴们来说，JSON的解析和生成是如呼吸般简单自然的事情。但是对于C语言，JSON的解析和生成就麻烦了。根本原因是由于C语言不支持反射，没办法对JSON做动态解析和生成。但是，容器引擎中涉及大量的JSON解析和生成。

那么，我们为了更好的和JSON进行和谐相处，做了哪些努力呢？

大体上，iSula经历了几个阶段，为了更好的感受这几个阶段的差距：我觉得通过武器的不同时代来感受一下。

**# 冷兵器时代**

C语言还是有一些JSON解析的库的，例如yaj1，cjson等等；这些库提供了把JSON字符串解析为tree结构的元素集合，然后通过遍历书可以快速的找到JSON的key/value的对应关系和值。

而且也能自己构建对应的元素结合tree，然后生成JSON字符串。那么，**如何通过这些库来做JSON和C结构体直接的相互转换呢？**

**用法**

以yaj1为例，实现一个isula\_version结构体的marsha和unmarshal.

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRC1p9oyG8KibEIuTBNnn5crMWWfEZNQzKJaBibpZOHl7VJPIK9M33GWibaA/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCePkE97ORegQHXqLbTry8OF6ibQUxyBZtSWBQanTDqhL7ekyxUrvWWYw/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRC7XsZ8QbARanUEcrd86BvZufYsmiaJXVicukpvF6l4z9bAYEEK1v7wKjA/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCVBRc5xzicLh2md5icQ8W4WY0qrOEIibJrtXHSz5RptqibTFHpZsUGvRMpw/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCOgfKmKdbJQRV5cr2fGvG5Xd1dZBvpV0BdpKj36MCIzDhPtGxTNQTug/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRClcmt3n33fZgEQj39FYcIPV9CP6PFSbibPxFvWNsSgpwEv0liaBicpK7hw/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCr7rwWJribMGCm5NcfoJp9QOnGWOrVK7OS3Jrxib2y8vEw3V7oyk7ibrzQ/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCZbCc726oaDHlicYrektpJTibM6aPshrrM4FicjakiaRztCE0oBzxNdOhxw/640?wx_fmt=png)

执行效果如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRChuLtFOjMmSkVvQQn5H0KDbPlXMDEHBDRZ6Y3Bv2mksWwIUEYqBEgDw/640?wx_fmt=png)

这种方式虽然没法和支持动态解析的语言一样高效简单，但是也算完成了任务。如果动态解析是热兵器，这个勉强能算是长矛了。

**缺陷**

从示例来看，完成一个结构体和JSON的映射大概需要160行左右的代码。而上面只是一个简单的结构体，而且有的项目有很多这种结构体需要做映射。这种原始的方式在大型项目中很难保证参与人员代码质量可控；而且效率低下。

主要的缺陷总结如下：

**? 映射工作量较大；**

**? 对每种结构体需要单独适配代码，无法实现自动化；**

**? 效率低下；**

**? 代码质量不可控；**

**# 伪热兵器时代**

由于C不支持反射，没法做到动态解析。但是可以通过其他途径简化解析流程、提高效率、实现自动化以及实现代码可控。为了避免重复造论子，17年的时候发现了libocisper项目，提供了一个解决C语言JSON映射的思路：

? 通过json schema描述JSON字符串的结构信息；

? 通过python解析json schema信息；

? 根据json schema信息自动生成C结构体和JSON的映射代码；

这种方式，可以解决上面的上一章节的几个缺陷：

? 工作量大大减少，这需要写好json schema文件即可；

? 自动化解析代码工作；

? 效率很高；

? 代码质量可控，取决于生产框架的质量；

**注：libocispes早期只能用于解析oci spec的json，在我们发现之后，多个开发人员参与社区，提供了大量的功能升级，才有了今天的强大能力。**

**iSula集成libocispec结构**

iSula当前把JSON映射相关的代码，统一放到lcr项目中进行管理，通过一个动态库和头文件提供相应功能。

生成代码的开源python框架结构如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCziawTdsJLHw3Z6LSicZqcqiaYy8YrvPiaSbBv87mAibbE9icSqxphczeMWoA/640?wx_fmt=png)

json schema文件存放结构（由于iSula涉及的所有JSON结构都在该目录下，所以存在大量的schema文件）如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCnyoSAxMERQUK24XboYnhSicKZ9mHlKchElb1dHKWk4Vx6mRsAL9r65g/640?wx_fmt=png)

然后在cmake的时候，会触发python框架，根据schema目录下面所有的schema来生成对应的映射代码。会看到如下提示信息。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCtiagwzY06xQ0LzLCAiczGibyMotYPCXckOt5iccliapzStGafWTBMsSxnGw/640?wx_fmt=png)

**用法**

那么，现在我们如果需要对一个新的结构体和JSON进行映射，需要做的事情就是在json schema目录下面新增一个对应的schema文件即可。这里以上一章节的isula\_version为例。

新增schema文件isula\_version.json：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCVa0onnR82hFCvztXvuxnwoOA5H6LLXdRXv3Iuia19OyemR0eVGnMwQw/640?wx_fmt=png)

重新cmake，可以看到新生成了两个文件：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCQ3bB3KficfdCvsGIqLzTZ36fBial31CuQrujvppsNLeDVEpDic8oCQeQg/640?wx_fmt=png)

生成的代码对外的接口如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCTDAXtYytDcuvJqcxm671ZGmfyH2lQIY5tzRFautda6O0avXTBG2ibFA/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCsyrMGAtYr4QaPNglswTEWAn2p41DZ81tz88IJjv5QCV4I4U2HKRYZA/640?wx_fmt=png)

测试用例：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCs3uEVDBX6sibrL31pbMDxibLy8PT2ibynsB2ibZVnJl3ZclpUsh8azrQnw/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCrB8E1V6rpiaeaF4XFJNy44eMcePM5To5zru1LeNz5WdlADTDUMN8vNw/640?wx_fmt=png)

执行结果如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCUyBcxGtYvoFUkZd59mmRtG7HtCcVrDKyRNDiaqALX8Pw3RVLnQbosTw/640?wx_fmt=png)

**缺陷**

通过libocispec可以实现接近于高级语言的marshal和 unmarshal 了，只需要简单编写schema文件即可，极大的提高了效率，并且依托开源社区可以提高代码质量。但是，还是存在一些缺陷。

例如golang中，marshal之后的结构体可以通过map\[string]interface-保存，可以完整的记录JSON字 符串中的信息。而我们当前的实现，只能根据schema来解析JSON字符串，因此，存在信息丢失的情况。有些场景，规范只规定了主体的JSON结构，并且支持拓展配置，例如CNI规范。 

**# 近乎热兵器时代**

为了解决信息丢失的问题，我们通过在结构体中记录原始的元素集合tree的方案，unmarshal的时候不 会丢失原始信息，marshal的时候解析记录的元素信息，从而实现原始数据完整的传递。

具体解决方案见官方PR：https://github.com/containers/libocispec/pull/56

**用法**

使用方式和上面的基本一致，差异主要包括以下几部分：

1\. 生成的代码有部分差异（\_residual）；

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCfvojuvgw9XeVefWia15GB0m5U3pQ8tIWMDfo10P4F3NooT1IeDYaWJQ/640?wx_fmt=png)

2\. 解析是需要指定 struct parser\_context 参数为 OPT\_PARSE\_FULLKEY ；

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRC0m1JWl36hDEnHlMKCZQDNVFtFib5nI0cvic0icAbhHGRM0CaCN7rxrDBw/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCmLFErBIzbVSVlbZMp2QdBHJic99ia8X3f4QnEzibJqNWAOBKTT8jGV8Zw/640?wx_fmt=png)

3\. 效果如下

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCEbp5GPWVRka2pgHT4LmZ8VdeZL65xKUVyGUeyknIgIxcAa3wtQEYpg/640?wx_fmt=png)

可以看到拓展的信息，完整的传递下去了。通过这种方式完美的解决了CNI的拓展配置的支持，从而解 决了iSulad动态支持多种插件的技术瓶颈。

**缺陷**

上面的方案已经基本和支持反射的语言实现的功能相近了，但是，还是存在部分缺陷的。例如，动态修改JSON结构的数据会比较麻烦，需要对底层的解析库比较了解，而且比较麻烦。 

**总结**

虽然当前的框架还有一些缺陷，但是，我们的目标并不是实现一个完美的JSON和C结构体的映射框架， 而是解决容器引擎使用JSON的问题。而上面的方案，已经完全满足iSula当前的需求。

因此，目前没有进一步优化的需求。如果后续使用场景或者其他用户有需求，可以到**libocispec的社区**进行进一步的优化。

**参考资料**

? *https://github.com/containers/libocispec*

? *http://json-schema.org/*

? *https://github.com/lloyd/yajl/tree/master/example*

? *libocispec 社区：https://github.com/containers/libocispec*

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCglQP81nqFVK5x9ianhfof7ic0jQj0AzWJDnIEZnogR7p1ANV5GjIIR2w/640?wx_fmt=jpeg)

☆每周二、周四晚8点，更多iSula容器详细解读

我们在B站openEuler直播间等你~

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbVKUoCNtmZY845KPaNdYRCFS5YdEvia1ShPtz4vRHibiamg8U5GP4RB7IrHYlUQzRTaI4q47KVSodVQ/640?wx_fmt=jpeg)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibOspOSKHic8Nh8icmf9xozgIK5j5ibJibMLzCLhbSoicDQOrVDQpZKX2nkBA/640?wx_fmt=png)

*观众老爷们来点一波关注*

*支持一下吧~！*

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYCjA16Qbj8RtLq6ZdzGlsR9Llaa49Bia9A8SlgicOgPZoDYZB2pxuLtp7FkmXvaIoZHRBUkAB6hA7w/640?wx_fmt=png)
