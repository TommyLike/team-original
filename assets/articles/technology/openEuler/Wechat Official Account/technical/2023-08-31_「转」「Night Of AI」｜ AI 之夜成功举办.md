# [「转」「Night Of AI」｜ AI 之夜成功举办](https://mp.weixin.qq.com/s/WJbL2Hnr0LIMstQ61zOy9A)

*傲空间*[OpenAtom openEuler](javascript:void%280%29;)*2023-08-31 18:30:00*

![](https://mmbiz.qpic.cn/mmbiz_gif/A0h5yD51CMaQGJbzoBjvFomBd1Spk0mfbw84WNicicr8n33taBg0wL3b9lbHHEmLoEHcsx7DmfnPo5HYcSU901Pg/640?wx_fmt=gif&tp=wxpic&wxfrom=5&wx_lazy=1)

近日，AO.space 傲空间与 AGI 早早聊、KCC@新加坡社区?起联合举办本次线上 AI 大会「Night Of AI」。本次活动邀请了openEuler TC委员，傲空间团队项目发起人之一王建民与大家分享了如何利用人工智能实现操作系统性能调优。

**01**

**讲师介绍**

![](https://mmbiz.qpic.cn/mmbiz_png/OwZHdn3YJwekw7HDcDxDYHAG0cg7PJz3r2SgnSmKxhWdFwKJejKIicMzORFfOuSeiaE1tRTJHmXMelt30oSmaicCg/640?wx_fmt=png)

王建民

- AO.space 傲空间 - 项目发起人之一
- 一位经验丰富的中科院软件所高级工程师，拥有十多年操作系统经验。在 openEuler 社区的技术委员会担任职务，并发起了面向学生的Summer-OSPP 开源项目。

**02**

**精彩内容**

**A-Tune：基于 AI 的操作系统性能调优引擎的实践分享**

操作系统性能调优一直是软件开发中的一项具有挑战性的任务。由于操作系统的复杂性，找到最佳配置参数可以是一项艰巨且耗时的过程。然而，如今人工智能正投入其中，革新性地改变着性能调优的方式。

**挑战与目标**

性能调优面临的挑战众多。操作系统（OS）具有大量的参数，它们之间具有复杂的相关性，这些可调参数控制操作系统的各个方面。

![](https://mmbiz.qpic.cn/mmbiz_png/OwZHdn3YJwekw7HDcDxDYHAG0cg7PJz3kx4001Ix9w5q64Is0sZSN3JpIud6kSia3UgmVbxbicKyEUOx7KIbdicGw/640?wx_fmt=png)

传统上，手动调优涉及大量的工作和丰富的经验，使其成为一项资源密集型的工作。然而，A-Tune利用人工智能技术来克服这些挑战。它采用智能目标导向探索、全栈覆盖和全自动化等技术，同时优化多个层次。

![](https://mmbiz.qpic.cn/mmbiz_png/OwZHdn3YJwekw7HDcDxDYHAG0cg7PJz3wPj8icYzQPGUnNFVByFcOAFTeSRBapKaLUbwt3RnJibdhDjkN6ZISiaBQ/640?wx_fmt=png)

**A-Tune-相关工作：**

调优是一个永恒的话题。

![](https://mmbiz.qpic.cn/mmbiz_png/OwZHdn3YJwekw7HDcDxDYHAG0cg7PJz3lA9adgELY5SoOBo7YiaX1DuzF3TQ7vmfVzmibUzbH4EO1IuJib64Bxg4g/640?wx_fmt=png)

凭借其创新的架构，A-Tune结合了智能决策、系统特征化和系统交互，实现了高效的数据分析、特征工程、训练、推断、监控等功能。

![](https://mmbiz.qpic.cn/mmbiz_png/OwZHdn3YJwekw7HDcDxDYHAG0cg7PJz3iau0EMBtlLkVfibKLSxUJh84XP6kickO0fvrLsqP4lDCPIGxTwvp8R7yQ/640?wx_fmt=png)

**A-Tune：AI使系统实现最佳性能**

![](https://mmbiz.qpic.cn/mmbiz_png/OwZHdn3YJwekw7HDcDxDYHAG0cg7PJz3jhb6ibcvuDofBfIvkiamswcJkowDaO5mGicyN2e0jIVTGKE1TInLPOeZA/640?wx_fmt=png)

**A-Tune的架构**

A-Tune旨在分析应用程序的资源使用情况（例如，计算，存储和网络）工作负载，支持行业主流应用的参数调优，提升调优效率。

![](https://mmbiz.qpic.cn/mmbiz_png/OwZHdn3YJwekw7HDcDxDYHAG0cg7PJz3ibEsTpEOzxDNqiaf3FbctDiccItxJz366zkR4UHYpQkVic7sdxbXMqh4YA/640?wx_fmt=png)

- 智能决策：在线静态调优和离线动态调优
- 系统表征：数据平台、特征工程、训练和推理
- 系统交互：系统全栈监控和配置服务

**A-Tune：在线静态调参**

场景：普通用户和应用程序需要始终在线。

解决方案：检测当前应用程序工作负载，根据分类模型，并输出经验参数。

![](https://mmbiz.qpic.cn/mmbiz_png/OwZHdn3YJwekw7HDcDxDYHAG0cg7PJz33NbEW1CDj5JrINd5Ma7RQLEByfw8yI0AbjRxMaialeDia1EGcZW7uL5Q/640?wx_fmt=png)

**A-Tune：离线动态调参**

场景：高级用户具有高性能要求。

调参器为目标设备设置参数，获取反馈性能指标，以及不断迭代以获得最佳参数。

![](https://mmbiz.qpic.cn/mmbiz_png/OwZHdn3YJwekw7HDcDxDYHAG0cg7PJz3ibicVURUw3YNnTnicQCgN1gbgCTMRcIq2WJWwTVGPUKotfxic87qTCjuSg/640?wx_fmt=png)

**A-Tune实施框架：**

![](https://mmbiz.qpic.cn/mmbiz_png/OwZHdn3YJwekw7HDcDxDYHAG0cg7PJz3906sb2W4XSSSz49icArJyiapnbUjf56fva0MptQ7Yrq1GPkSlJjZwWug/640?wx_fmt=png)

**调优结果：**

在微服务和大数据场景中，性能比默认系统提高了 30%配置，和配置的 5%由专业工程师优化。调参效率是手动调参的五倍。

![](https://mmbiz.qpic.cn/mmbiz_png/OwZHdn3YJwekw7HDcDxDYHAG0cg7PJz3nYtQ7Cu3gicViaXnfXAzbmVeWQGvt3wa8LRzMFibymmotSXdt2HwB9RPw/640?wx_fmt=png)

不仅如此，麒麟软件用 A-Tune 优化了 etcd ，性能提升10%+。

![](https://mmbiz.qpic.cn/mmbiz_png/OwZHdn3YJwekw7HDcDxDYHAG0cg7PJz3vYbGZTJX1ibgITJ2xeYhPzn4iabe0HVriaictTjQY1Gw3G4CpmNnPA9o7A/640?wx_fmt=png)

MySQL 8.0.25 在 openEuler 上的6种不同场景中进行优化后，在具有 4 个内核和 16 GB 内存的 VM 上运行，以及32 个内核和 64 GB 内存。在 oltp\_insert 方案中，吞吐量也提高了五倍。

![](https://mmbiz.qpic.cn/mmbiz_png/OwZHdn3YJwekw7HDcDxDYHAG0cg7PJz3xicIaclBG44AtbvGx4TVVVq5c2WkXKb4ccXcLKBQp2Hdb60nUH3gOHg/640?wx_fmt=png)

本次演讲，王建民分享了他在 A-Tune 项目的实践经验。A-Tune 是一个基于 AI 技术的操作系统性能调优引擎，通过感知和推理应用场景特征，给出最佳的参数配置组合来提高操作系统的运行效率。 

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZEq3W4gpjPRz743lMp7cLJUoUCgO1ku5Xwqblj5VibNp9nXzRsK6ibNichMMrUPdRUEPqlgSrnM05RQ/640?wx_fmt=jpeg&wxfrom=13&tp=wxpic)

[阅读原文](https://ao.space/blog/communityovercode-asia-2023-succeed)
