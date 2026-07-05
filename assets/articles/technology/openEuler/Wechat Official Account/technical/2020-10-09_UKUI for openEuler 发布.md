# [UKUI for openEuler 发布](https://mp.weixin.qq.com/s/jYqjG3RXVIn0PvhZpVA1bQ)

*UKUI SIG*[OpenAtom openEuler](javascript:void%280%29;)*2020-10-09 19:10:00*

UKUI 是由麒麟团队开发的基于 Linux 发行版的轻量级桌面环境，默认搭载在优麒麟开源操作系统和银河麒麟/中标麒麟商业发行版中。UKUI 3.0 主要基于 GTK 和 QT 开发，更注重易用性和敏捷度，给用户带来亲切和高效的使用体验。目前，UKUI 已登陆 Debian、Ubuntu、Arch Linux 等多个国际 Linux 发行版。

openEuler 聚集了大批国内外开发者，通过社区的形式，迅速发展，是一个有生命力、潜力巨大的新生软件生态体系。麒麟软件成立了 UKUI SIG，并经过团队数月的努力，正式发布面向 openEuler 的 UKUI，成为 openEuler 用户的可选桌面环境之一。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZ6ysqwoibe8vVkLibuqoXAJ4UfCXpm6IAXbtF5gP0HvkezOX6gt1Qxtkg3KYVoxcpPpqlzDia21Qrbg/640?wx_fmt=png)

UKUI 3.0 的视觉效果经过了全面重新设计，用柔和的色彩，圆润温和的设计风格给用户以全新的感受。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZ6ysqwoibe8vVkLibuqoXAJ4kK61DsZPsP6v9W8Hdn7wwYiaJibELS9rVs54CFqcZXdiaScD1nK0PChtg/640?wx_fmt=png)

新引入的侧边栏模块，帮您收纳和管理应用发出的通知和消息。便捷的小插件和剪贴板工具轻松提高使用效率。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZ6ysqwoibe8vVkLibuqoXAJ4BEibY19iapJ1Y9yDD5GVn0UyUc7rgNpJ9WxRfnqicGOmf1T6gfEtZFKvw/640?wx_fmt=png)

开始菜单全新布局，全屏窗口随心切换，智能搜索一键可达。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZ6ysqwoibe8vVkLibuqoXAJ4hNUclE4ObdibTibxTutibImudSichl9rEU1kcq70qaQenGQQ41drMcuryw/640?wx_fmt=png)

控制面板重新设计，分类更加清晰明了。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZ6ysqwoibe8vVkLibuqoXAJ4SyZxWQlyu5s7qDPU7DlHD2NahBw5YfibGf1OM6jFSoK7tOmJZfib3F0w/640?wx_fmt=png)

文件管理器从底层开始进行了彻底的重构，着重增加了稳定性。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZ6ysqwoibe8vVkLibuqoXAJ424VQXmnRgCiae4HsvYzoBAbazTC5uELC2WoVpqBIRCpON1qgjAlKSMA/640?wx_fmt=png)

### 安装方法：

UKUI 支持 x86\_64 和 aarch64 两种架构。目前默认未开启 root 用户登录，因此在安装 UKUI 前请先创建一个管理员用户，推荐在安装 openEuler 时创建。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZ6ysqwoibe8vVkLibuqoXAJ4pLQicANOKFwbpczl9TmBQ3XMY7HjDYTibGFQqmicPAopUZm9wgs72TD4w/640?wx_fmt=png)

目前 UKUI 可以通过 yum install ukui 直接安装。

目前 UKUI 的依赖 libdbusmenu 在安装时需要安装 python2，和 python3-unversioned-command 包（该包提供了一个指向 python3 的软连接）冲突，必须先强行卸载 python3-unversioned-command

```
rpm -e --nodeps python3-unversioned-command
```

在安装完成后，可通过以下命令恢复该包的设置:

```
ln -s /usr/bin/python3 /usr/bin/python
```

然后安装字体库

```
yum groupinstall fonts
```

在确认正确安装后，输入

```
systemctl set-default graphical.target
```

重启之后即可启动图形界面。

目前 UKUI 版本还在不断的更新，最新的安装方法请查阅：https://gitee.com/openkylin/ukui-issues

您在使用或者安装中遇到的问题均可到上面的链接进行反馈。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibOspOSKHic8Nh8icmf9xozgIK5j5ibJibMLzCLhbSoicDQOrVDQpZKX2nkBA/640?wx_fmt=png)

***观众老爷们不考虑点一波关注吗？***

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbR3YNaNBytF0uqAicKL7fRD0JJj1HibCo2Sic0qxQ1LkZPlLqibMPxWUBBGeOOicicX3yY8e2icz81TU7Fg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYCjA16Qbj8RtLq6ZdzGlsR9Llaa49Bia9A8SlgicOgPZoDYZB2pxuLtp7FkmXvaIoZHRBUkAB6hA7w/640?wx_fmt=png)
