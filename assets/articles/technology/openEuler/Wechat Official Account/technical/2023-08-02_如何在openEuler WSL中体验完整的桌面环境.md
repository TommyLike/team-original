# [如何在openEuler WSL中体验完整的桌面环境](https://mp.weixin.qq.com/s/Fg4Ca-o86dMDP5KIf906Gg)

[OpenAtom openEuler](javascript:void%280%29;)*2023-08-02 18:01:00*

**openEuler WSL**

WSL是微软发布的让用户能够在windows上使用Linux环境的技术，openEuler已发布多个版本的WSL镜像。近期openEuler又补充了WSL的桌面支持，提升了桌面应用开发者的开发体验。**本文将为大家介绍在使用openEuler WSL的过程中，如何安装和链接桌面环境。**

**EUR**

EUR(openEuler User Repo)是openEuler社区针对开发者推出的个人软件包托管平台，目的在于为开发者提供一个易用的软件包分发平台。

在使用openEuler WSL的过程中，由于有部分软件包暂时没有被openEuler社区正式引入，开发者很难体验完整的桌面环境。这时候EUR就是最好的帮手，借助EUR，开发者可实现在Windows中完全使用openEuler 桌面环境进行开发的小目标。

**EUR:**https://eur.openeuler.openatom.cn/

**使用步骤**

当前WSL社区主流的桌面解决方案是kail linux独家的软件包kex，而kex的Seamless Mode其实是借助了xrdp来实现的。

通过在EUR创建xrdp软件包，可实现在Windows中完全使用openEuler 桌面环境进行开发。具体步骤如下：

**1. 安装openEuler WSL：**

目前openEuler已经将 openEuler 20.03-LTS，22.03-LTS，22.03，23.03等版本相继上架到了微软应用商店，欢迎大家下载试用。不方便访问Windows Store的用户可以[使用openEuler WSL sideload安装体验openEuler WSL](http://mp.weixin.qq.com/s?__biz=MzI2NDE4OTE2Mg%3D%3D&mid=2247505243&idx=2&sn=e73b4f071773a829788a30ea11392ea3&chksm=eab2f0deddc579c8d33f7b8c68709f9d8484e88a93e41ee274a61565c024a606c0988a1082c7&scene=21#wechat_redirect)。

**2. 安装桌面环境：**

本文采用xrdp的方式来实现WSL中的桌面环境，由于xrdp包还不存在于openEuler官方仓库，openEuler开发者已经在EUR中引入了最新的0.9.22.1版本。

链接：

https://eur.openeuler.openatom.cn/coprs/mywaaagh\_admin/xrdp/

①首先获取23.03版本EUR仓库配置；

```
$ sudo curl -o /etc/yum.repos.d/xrdp.repo -L https://eur.openeuler.openatom.cn/coprs/mywaaagh_admin/xrdp/repo/openeuler-23.03/mywaaagh_admin-xrdp-openeuler-23.03.repo

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for lcr:
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                Dload  Upload   Total   Spent    Left  Speed
100   379  100   379    0     0   1237      0 --:--:-- --:--:-- --:--:--  1238
```

②安装xrdp和gnome相关的软件包；

```
$ sudo dnf in xrdp gnome-terminal gdm neofetch
...
Total                                                                                   1.2 MB/s | 358 MB     05:05
Copr repo for xrdp owned by mywaaagh_admin                                              7.0 kB/s | 1.0 kB     00:00
Importing GPG key 0xA893D75B:
Userid     : "mywaaagh_admin_xrdp (None) <mywaaagh_admin#xrdp@copr.osinfra.cn>"
Fingerprint: 945E 21A6 D982 49A7 A61A E62A 026A 219C A893 D75B
From       : https://eur.openeuler.openatom.cn/results/mywaaagh_admin/xrdp/pubkey.gpg
Is this ok [y/N]: y
...

Complete!
```

③启动xrdp和gdm服务；

```
sudo systemctl start xrdp
sudo systemctl restart gdm
```

④通过windows的mstsc.exe命令即可访问刚刚启动的xrdp服务，WSL的IP可以通过ip a命令获取。

```
$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
    valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:15:5d:1a:3f:30 brd ff:ff:ff:ff:ff:ff
    inet 172.29.191.92/20 brd 172.29.191.255 scope global eth0
    valid_lft forever preferred_lft forever
    inet6 fe80::215:5dff:fe1a:3f30/64 scope link
    valid_lft forever preferred_lft forever
(base) [lcr@lcrpc cascadia-code-nerd-fonts-mono]$
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbwNRZVJIURIu278iaMy7CwtZ8TbDPd6BIMFuohrHFgYGplpEnp3Gnyrr62xcXfVBiaaKiavdv7MKxOQ/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbwNRZVJIURIu278iaMy7CwtQkTL3pH3Gu4R1iaEgV1aYkTjej2AictMVyQf2gUib2Xic73eb9dUKUK2Kw/640?wx_fmt=png)

在远程桌面连接后，选择Xvnc，在填入WSL首次启动是创建的用户名和密码，即可进入openEuler的gnome桌面。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbwNRZVJIURIu278iaMy7CwtKYL2uuUSqJDQgj6QnkSib2kWnErLZ4ygGibloQVbDquFJXLunqPJCibQg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbwNRZVJIURIu278iaMy7CwtxWRmle8h3hABeTmpXhvwibHzKicQuua9ib8wjqXticiaibbuQArceyqich43Q/640?wx_fmt=png)

欢迎感兴趣的朋友使用，有任何建议欢迎一起交流。

邮件列表：infra@openeuler.org

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbwNRZVJIURIu278iaMy7CwtqWfhTzZuRJFfVRexQ66lI8jnDc7Dvs4BI0zbkB0DVMRiamSfDc0q2Ag/640?wx_fmt=png)

欢迎加入基础设施交流群

[阅读原文](https://www.openeuler.org/zh/blog/waaagh/openEuler-DE-in-WSL.html)
