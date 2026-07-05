# [Windows上秒开openEuler桌面！DevStation 25.09 AI桌面开发环境正式上架微软商店](https://mp.weixin.qq.com/s/XpDvZD2zVc15v1EYTmq0Mg)

[OpenAtom openEuler](javascript:void%280%29;)*2025-11-20 18:00:00广东*

还在为开发环境配置烦恼吗？好消息来了！OpenAtom openEuler（简称“openEuler”或“开源欧拉”） DevStation 25.09正式登陆 Microsoft Store，基于 WSL 2 技术，让你在 Windows 11 上轻松运行完整的 openEuler 桌面环境！

这是目前最简单的 openEuler 体验方式——无需复杂的双系统安装，不用笨重的虚拟机，只需几个简单步骤，就能在 Windows 中获得原汁原味的 openEuler 开发环境。

01

什么是DevStation？

openEuler DevStation 是 openEuler 社区专为开发者打造的 Agentic OS，它不仅仅是一个 Linux 发行版，更是一套 开箱即用的开发工具集合。 DevStation 内置了多项开发利器：

- PolyMind：通用 AI 入口，可以自然语言调用 DevStation 提供的 AI Agent，实现自然语言管理操作系统（当前需要单独安装）

<!--THE END-->

- DevStore：默认软件商店，提供 MCP 服务、oeDeploy 插件的快速安装

<!--THE END-->

- Roo Code：VSCodium 中的 AI 代理插件，智能编程助手

<!--THE END-->

- oeDevPlugin：可视化界面管理 Gitee 仓库、issue、PR

<!--THE END-->

- oeGitExt：命令行方式参与社区贡献

<!--THE END-->

- oeDeploy：轻量易用的软件部署工具

02

两种安装方式，轻松上手

方法一：微软商店一键安装（最简单）

1. 打开 Microsoft Store
2. 搜索 "openEuler DevStation 25.09"
3. 点击 "获取" 按钮安装
4. 从开始菜单启动，按引导设置账号
5. 安装完成后，想要体验完整的桌面环境？只需在命令行中输入：

<!--THE END-->

```
sudo systemctl start graphical.target
```

输入密码后等待几秒钟，即可进入 DevStation 的图形化桌面环境，享受流畅的 Linux 桌面体验！

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mANMLDBXoOtS2UVY4uGSU57wkaMcdIbtup6icTgia5CLibyGQeeCAnE2SsNVby09PUCsXlzeBQhSo7uQ/640?wx_fmt=gif&from=appmsg)

方法二：ZIP 包手动安装

如果无法访问 Microsoft Store，也可通过官方镜像安装：

- 获取 WSL zip 压缩包：从官网下载安装包：https://dl-cdn.openeuler.openatom.cn/openEuler-25.09/WSL/
- 解压至目标文件夹：进入解压后的 xxx\_Test 目录
- 注册安全证书：
  
  - 双击 ".cer" 文件，点击 "安装证书"
  - 选择本地计算机 → 将所有的证书都放入下列存储 → 浏览选择 "受信任人"

<!--THE END-->

- 安装 WSL：
  
  - 双击 ".appxbundle" 文件
  - 点击 "安装"（已安装则显示 "重新安装"，直接点击“启动”）

<!--THE END-->

- 创建账户：按提示设置用户名和密码

启动图形桌面，输入：

```
sudo systemctl start graphical.target
```

体验完整功能。

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mANMLDBXoOtS2UVY4uGSU57licTqSO79o2RYabgQ73rD4WibiayA1ib1GnwsJ5L8D5ic5udPyKMex6QxMg/640?wx_fmt=gif&from=appmsg)

03

下期预告：解锁 DevStation 完全体

成功安装只是第一步！下期我们将深入介绍如何在 DevStation 上使用 DevStore 快速获取智能体和完成 MCP 安装配置,并且如何使用 PolyMind 调用，让你真正发挥这个智能开发环境的全部潜力。

通过 DevStore 和 PolyMind，你可以：

- 一键安装各种开发工具和插件

<!--THE END-->

- 快速配置 MCP 服务

<!--THE END-->

- 体验 AI 辅助编程的强大功能

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mANMLDBXoOtS2UVY4uGSU57Zp4jePfGmqrZP5ibghqbFXHq6MynGk8bic0PRHKHBb4bOYsp2z1GoSOQ/640?wx_fmt=gif&from=appmsg)

敬请期待我们的下一篇教程，带你从安装走向精通！

04

加入社区，获取支持与反馈

独行快，众行远。为了给大家提供一个便捷的交流平台，及时解答使用中的疑问并收集反馈，我们特地开设了 openEuler DevStation 官方交流群。

进群你能获得：

- ?? 实时技术交流：与众多开发者和爱好者共同探讨；

<!--THE END-->

- ??? 安装使用帮助：遇到问题快速获得社区支持；

<!--THE END-->

- ?? 最新动态速递：第一时间获取版本更新和活动信息；

<!--THE END-->

- ?? 反馈产品建议：你的声音能直接帮助改进 DevStation。

扫码入群：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mANMLDBXoOtS2UVY4uGSU57aYjom850dtnllEic1gUN5gWEuSlVEicdxRIwZtwrkjI5BwwxXXoSAZicw/640?wx_fmt=png&from=appmsg)
