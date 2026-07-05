# [如何使用openEuler WSL sideload](https://mp.weixin.qq.com/s/CrNTBddLohZ-D-e_TG44TQ)

[OpenAtom openEuler](javascript:void%280%29;)*2023-07-14 18:00:00*

自openEuler 22.03 LTS SP2版本开始，repo仓库里默认发布WSL sideload压缩包，不方便访问Windows Store的用户可以使用这种方法安装体验openEuler WSL。

**如何使用**

1\. 在仓库中下载对应版本的WSL sideload发布件，例如 22.03 LTS SP2的sideload.zip包；

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyGPvO2osZVI4iaDYyxQibpJr7XbkYqhIQCtoI4WQGgLEMY2L1licurZfGWzH7CObM3r9e3WDzZ5H4g/640?wx_fmt=png)

2\. 下载后，解压该zip，可以看到其中有一个cer证书文件和一个appxbundle文件；

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyGPvO2osZVI4iaDYyxQibpJyZGTSGlLkydib3GFlYJDWrkBE2gVPVeiblXnLL8cJtkUFeZEGSBNQHUA/640?wx_fmt=png)

3\. 首先双击cer，将证书安装到受信任的；

① 双击xxx.cer

② 选择本地计算机（local machine），点击下一页

③ 选择受信任人（trusted people），点击下一页 

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyGPvO2osZVI4iaDYyxQibpJfz2UAZb3tsJiaB50rCvtib9NqBcfvVNb5sn0yb9UDGAGtrORDxPpO7bQ/640?wx_fmt=png)

④ 点击完成

4\. 双击appbundle安装sideload，如果已经按照过曾经发布过的22.03的WSL，则会提示更新，点击安装；

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyGPvO2osZVI4iaDYyxQibpJA0PMLv8iaMXlPjibgj8iaRKPsZiaibftHfiawZwKtcmeHeJUgDwnAwMIuIiag/640?wx_fmt=png)

5\. 安装成功后，会自动弹出WSL初始化界面，创建账号。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyGPvO2osZVI4iaDYyxQibpJjvCibqrMQib66iaoibwkbS8QhBh3iaZhDBTicLo6S3icyAu112sFB6HxG6tOw/640?wx_fmt=png)

**联系方式**

欢迎感兴趣的朋友使用，有任何建议欢迎一起交流。

邮件列表：infra@openeuler.org

社区论坛：https://forum.openeuler.org/

WSL开发体验（视频）：

回放链接：

https://www.bilibili.com/video/BV1VP411z7Uw/#reply171502311520
