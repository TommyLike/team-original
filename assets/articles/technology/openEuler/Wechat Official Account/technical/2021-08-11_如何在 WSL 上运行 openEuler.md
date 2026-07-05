# [如何在 WSL 上运行 openEuler](https://mp.weixin.qq.com/s/Y53s8x8cnjlMGqn80At_zQ)

原创*王海涛*[OpenAtom openEuler](javascript:void%280%29;)*2021-08-11 18:21:53*

首先您需要 6 步配置 WSL 环境，然后您就能在 Microsoft Store 上安装任意 WSL 发行版了，包括 openEuler！

**目前 openEuler 20.03 LTS SP2 已经在 Microsoft Store 上架，欢迎大家使用。**

#### 配置 WSL 环境

这是官方文档，在 Windows 10 上安装 WSL | Microsoft Docs\[1]，您也可以按照以下步骤来做：

#### 启动控制台

使用管理员身份打开 PoweShell，您可以按下 Win+X，点击“**Windows PowerShell (管理员)**”。

请注意，请不要点击“Windows PowerShell”，一定要点击带有(管理员)后缀的，因为这样才能用管理员身份启动。

将下列命令复制粘贴到控制台，然后按回车运行：

#### 开启 WSL 服务

```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

#### 启动虚拟机特性

```
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

#### 重启电脑

请一定要重启，否则无法继续下面的操作。

您可以在浏览器中将该文档网页收藏，方便重启后继续往下操作。

#### 更新 WSL 内核

下载64 位的 Linux 内核升级包\[2]，双击安装下载好的安装包。

#### 将 WSL2 设为默认启动版本

打开控制台，运行以下命令。

```
wsl --set-default-version 2
```

#### 安装 openEuler

经过上述操作后，就可以前往 Microsoft Store，安装任意 Linux 发行版了，这里以 openEuler 为例。

1. 点击openEuler 在商城的链接\[3]，点击获取，允许网页跳转安装。
2. 或者打开 Microsoft Store，手动搜索 openEuler，如下所示：

默认情况下，您的任务栏应当有下列图标：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbw6hqVnsFLm70GybB5W4K86MguRIVUPJyMOoImr5Z62qXwGPW8ofAahRZhK44RSiaNvygViaeb4a1g/640?wx_fmt=png)

如果没有，可以按下 Win+Q，输入 store，搜索 Microsoft store

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbw6hqVnsFLm70GybB5W4K8HXdHnbM4S5eBDOfG4vDkLrAx3fvxY6lZJSZe8Gkef0PF7p2q9UgSHQ/640?wx_fmt=png)

无论哪种方法，您都会在 Microsoft Store 上看到 openEuler 的描述页，如下所示，点击获取，等待安装即可。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbw6hqVnsFLm70GybB5W4K88icNCTO0O8RmaTT9nRf8r1DKcG7DY4EyiaJZ6qu7wvgWdMjlxvMicDEIQ/640?wx_fmt=png)

#### 启动 openEuler

安装好后，有以下几种启动方法：

1. 开始菜单中点击图标启动。
2. 命令行启动。
3. VScode 中启动。

#### 开始菜单中点击图标启动

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbw6hqVnsFLm70GybB5W4K8lM3GNhF3VhaS601j9wqic75k7IWbTHt6pTQEncSQmUVEP5CFwds3PlA/640?wx_fmt=png)

如图所示，将左侧 openEuler 小图标拖到右侧变成较大的磁贴，点击磁贴或小图标都能运行。

#### 命令行启动

Windows 下有三种命令行，PoweShell，cmd，Windows terminal。

推荐使用 Windows terminal，其使用更符合 linux 习惯，而且界面更美观。

下面演示 Windows terminal 的安装，及打开方式。

1. 打开 Microsoft Store，搜索 Windows terminal，安装
2. 在开始菜单或 Win+Q 搜索 windows terminal 打开 Windows terminal
3. 或按下 Win+R，输入 windows terminal 或者其缩写 wt，按下回车即可启动

启动上述三种任意命令行后，即可在命令行中输入 WSL 命令，来启动 openEuler。

输入下列命令查看命令行帮助：

```
wsl -h
```

输入以下命令显示当前安装的 WSL 发行版：

```
wsl -l
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbw6hqVnsFLm70GybB5W4K8oIKhY3icX89KVyj6VpV8CBVIGrIHZXhOlk88ZAfRPrWc83awUWFibtHg/640?wx_fmt=png)

可以看到我这里安装了 openEuler、fedoraremix、Ubuntu，且 openEuler 是默认启动的发行版。

输入下列命令，可以启动默认的发行版。

```
wsl
```

如果您在安装 openEuler 前安装了其他 WSL 发行版，那么可以运行下列命令将 openEuler 设为默认启动的发行版。

```
wsl -s openEuler
```

此外，使用-d 命令，可以指定启动任意发行版。

```
wsl -d openEuler
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbw6hqVnsFLm70GybB5W4K8gT9zmxw3PTSiaHqTO7v8TetoT4icLjqb8zZpInQNDyyYvf7TeJM3ibhmg/640?wx_fmt=png)

如上图所示，我使用 Windows Terminal 启动了 WSL 的默认发行版，也就是 openEuler。

#### VScode 启动

如果涉及代码编写，推荐使用 VScode 打开 WSL。

VScode 可以使用 ssh 的方式，连接到 WSL。其需要在 WSL 中下载一个安装包，此安装包需要使用 tar 解包，因此连接的发行版需要安装 tar。

1\. 使用上面讲的方法，在命令行打开 openEuler，安装 tar。

```
dnf install tar -y
```

2\. 在 Windows 下安装 VScode，官网链接\[4]。

3\. 打开 vscode，安装 WSL 插件。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbw6hqVnsFLm70GybB5W4K8XllULwSunicfL2H1Hgmqbuey1ib3NvcMvtUX2KIcxhqtm9rFEVyJfDVQ/640?wx_fmt=png)

4\. 在远程资源管理器中，在下拉菜单中，选择 WSL targets

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbw6hqVnsFLm70GybB5W4K8jdaFSYZZVYczxcGWxicM1n9C1ibnpIQP8YuYwfTJqaFEzX9ica18MLsDw/640?wx_fmt=png)

5\. 在菜单中，选择 openEuler，即可打开新的窗口启动 openEuler

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbw6hqVnsFLm70GybB5W4K89gqvPX9cnl4DnwfCFsuENV0YGBxjkmcyVuQM7ecYUWwnmMNCdRJdDA/640?wx_fmt=png)

6\. 在 VScode 中，按下快捷键 Ctrl+~，即可打开控制台

#### 启动界面

首次运行需要进行安装，需要稍等一两分钟，如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbw6hqVnsFLm70GybB5W4K8TZS8FDOYsqd2yMkDt2wib71qyXj6XJme2GibUNmMUdhJriac9dma0lOkg/640?wx_fmt=png)

安装好后，界面如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbw6hqVnsFLm70GybB5W4K83LASJOXuQ9MPmmD34S1eZ3Mz4QY5vLeKniabqFLvM5KfB0ibTC6dCy2w/640?wx_fmt=png)

#### 注意事项

- WSL 与 VMware、VirtualBox 不兼容问题

参见官方文档\[5]，WSL 使用 Hyper-V 技术来提供虚拟化，而部分老版本的 VMware、VirtualBox 在 Hyper-V 技术开启后，无法正常运行。

这意味着您需要更新 VMware、VirtualBox 到新版本来解决这个问题。

- VScode 连接 openEuler 失败

如果您使用 VScode 连接 openEUler 报错，出现了下图所示的报错，那么您需要在 openEulelr 中安装 tar，才能让 VScode 连接成功。

请使用命令行启动 openEuler，然后运行下列命令来安装 tar 包。

```
dnf install tar -y
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbw6hqVnsFLm70GybB5W4K8PgribxmA4f1e5ia5vKhvbNs54OsRujxgtAvJ8fWic9E8dGrTPTGYz0PfA/640?wx_fmt=png)

#### 其他问题

如果您安装过程中，出现了其他问题，请参考以下微软文档：

1. 在 Windows 10 上安装 WSL | Microsoft Docs\[6]
2. 排查适用于 Linux 的 Windows 子系统问题 | Microsoft Docs\[7]

此外，微软官方还介绍了更多关于 WSL 的有用知识，请参考文档：

适用于 Linux 的 Windows 子系统文档 | Microsoft Docs\[8]

#### WSL 的缺陷

WSL 有部分无法支持的原生 Linux 功能，比如不支持 systemctl，正在支持 GUI 等。

详见有关适用于 Linux 2 的 Windows 子系统的常见问题 | Microsoft Docs\[9]

### 参考资料

\[1]

在 Windows 10 上安装 WSL | Microsoft Docs: *https://docs.microsoft.com/zh-cn/windows/wsl/install-win10*

\[2]

64 位的 Linux 内核升级包: *https://wslstorestorage.blob.core.windows.net/wslblob/wsl\_update\_x64.msi*

\[3]

openEuler 在商城的链接: *https://www.microsoft.com/store/apps/9NGF0Q0XP03D*

\[4]

官网链接: *https://code.visualstudio.com/*

\[5]

官方文档: *https://docs.microsoft.com/en-us/windows/wsl/wsl2-faq#will-i-be-able-to-run-wsl-2-and-other-3rd-party-virtualization-tools-such-as-vmware--or-virtualbox-*

\[6]

在 Windows 10 上安装 WSL | Microsoft Docs: *https://docs.microsoft.com/zh-cn/windows/wsl/install-win10#troubleshooting-installation*

\[7]

排查适用于 Linux 的 Windows 子系统问题 | Microsoft Docs: *https://docs.microsoft.com/zh-cn/windows/wsl/troubleshooting*

\[8]

适用于 Linux 的 Windows 子系统文档 | Microsoft Docs: *https://docs.microsoft.com/zh-cn/windows/wsl/*

\[9]

有关适用于 Linux 2 的 Windows 子系统的常见问题 | Microsoft Docs: *https://docs.microsoft.com/zh-cn/windows/wsl/wsl2-faq*
