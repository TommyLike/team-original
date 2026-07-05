# [【安全预警】Linux Kernel 本地权限提升漏洞（Di](https://mp.weixin.qq.com/s/47YIcMtAOYk_GDB95N6luQ)

[OpenAtom openEuler](javascript:void%280%29;)*2026-05-08 23:03:07广东*

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a47pmwYKrTftvGXyFfspek4hoUibdJtrBB96517RL4k2AXD1gSav958g/640?wx_fmt=gif&from=appmsg)

**漏洞概述**

近期Linux 又爆 Dirty Frag严重漏洞，该漏洞链由韩国安全研究员 Hyunwoo Kim 发现，该漏洞实际包含2个漏洞，涉及xfrm-ESP（CVE-2026-43284）和RxRPC（CVE-2026-43500）模块，两者都是通过 splice() 系统调用将文件 page cache 页直接挂到 skb，利用解密路径不复制页面内容而是原地写入的逻辑来篡改page cache内容，实现提权。

**openEuler受影响情况**

xfrm-ESP引入问题补丁cac2661c53f3，经排查openEuler全版本涉及（内核4.19/5.10/6.6），esp4和esp6默认编译为ko。

RxRPC引入问题补丁d0d5c0cd1e71，经排查openEuler 20.03 LTS系列版本（内核4.19）不受影响，openEuler 22.03 LTS系列版本（内核5.10）和openEuler 24.03 LTS系列版本（内核6.6）受影响，在受影响的版本中rxrpc默认未编译，因此openEuler 22.03 LTS系列版本和openEuler 24.03 LTS系列版本默认不能攻击成功，但社区源码仍涉及，客户自主编译加载rxrpc后仍受影响。

**CVE-2026-43284排查方法**

1.如果 CONFIG\_INET\_ESP =y || CONFIG\_INET6\_ESP =y则涉及；

2.如果 CONFIG\_INET\_ESP =m || CONFIG\_INET6\_ESP =m则排查esp4.ko和esp6.ko是否被裁剪，均被裁剪则不涉及。

\# =y 为内置，规避措施1黑名单无效；=m 为模块，规避措施1黑名单有效

**CVE-2026-43500排查方法**

1.如果 CONFIG\_AF\_RXRPC=y && CONFIG\_RXKAD=y则涉及；

2.如果 CONFIG\_AF\_RXRPC=m && CONFIG\_RXKAD=y的形式打开的情况下，则可排查rxrpc.ko是否被裁剪，被裁剪则不涉及。

**修复补丁**

目前社区正在抓紧修复中，暂未发布漏洞补丁及修复版本，修复进展请及时关注社区对应漏洞的issue和安全公告：

**CVE-2026-43284：**

https://gitcode.com/src-openeuler/kernel/issues/14835

CVE-2026-43500：

https://gitcode.com/src-openeuler/kernel/issues/14909

**openEuler安全公告网站：**

https://www.openeuler.org/zh/security/security-bulletins/

**规避措施**

请评估业务是否受影响后，及时实施缓解措施：

1.禁用相关内核模块，无需重启。

sudo sh -c "printf 'install esp4 /bin/false\\ninstall esp6 /bin/false\\ninstall rxrpc /bin/false\\n' &gt; /etc/modprobe.d/dirtyfrag.conf"

sudo rmmod esp4 esp6 rxrpc 2&gt;/dev/null ||true

2.针对xfrm-ESP禁止普通用户使用unshare系统调用创建user namespace

sudo sh -c "echo 0 &gt; /proc/sys/user/max\_user\_namespaces

**本文参考链接**

https://github.com/V4bel/dirtyfrag

-END-

供稿 | openEuler安全委员会

编辑 | 丘云

校审 | 郑振宇、刘彦飞

![](https://mmbiz.qpic.cn/mmbiz_png/rxr9tddEHOuF1rJtYcZsFMFIZSfA0j9zrJerqTSia93rKrHQoYbuQqSFuKnibicX7ichibyAZKOQicibnOgjq6qrtshClQWnA9xkTiaOVtEepTJZuiaY/640?wx_fmt=png&from=appmsg)

**推荐阅读**      Recommend

[![](https://mmbiz.qpic.cn/mmbiz_jpg/rxr9tddEHOvTmxJB7T8afeoJicPY4tPyRPlGia37yKSr7uvdaicXfsiclFusqm45C3tGxyxwogW6rSsPWfA9K4gCgfspIImG1ucxia1mXvR25XNw/640?wx_fmt=jpeg)](https://mp.weixin.qq.com/s?__biz=MzkyMjYzNjU0Ng%3D%3D&mid=2247519763&idx=1&sn=763e96c448b3fc1e14f2940d85b7940b&scene=21#wechat_redirect)

【安全公告】Linux Kernel 本地权限提升漏洞（CVE-2026-31431）openEuler在维版本均已修复，请尽快升级

&lt;

**关注我们，了解更多**

**▼**

![图片](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2d1CvxNf56DXribfOKnOqvMU1jP4fVRpO45sDy84Knibcp1OuASLm5MMg/640?wx_fmt=png&from=appmsg&wxfrom=5&wx_lazy=1#imgIndex=1)

▼点击阅读原文快速进入【安全中心】

[阅读原文](https://www.openeuler.org/zh/security/security-bulletins/)
