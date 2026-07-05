# [如何参与 openEuler 内核开发](https://mp.weixin.qq.com/s/p2uq60agoihT6blP7NVBHQ)

[OpenAtom openEuler](javascript:void%280%29;)*2021-03-30 18:00:00*

openEuler kernel 开发跟 linux mainline 一样，采用社区协作的方式，我们发送补丁、咨询问题都是通过邮件进行交流的，因此我们进行内核开发的标准流程和主线内核的开发流程是一样的。

1. 首先你需要配置好你的 git，而且要能正常使用 git 发送补丁；
2. 下载 openEuler kernel 源代码；
3. 提交、验证你的补丁；
4. 补丁验证完成后，发往 openEuler kernel 邮件列表，等待社区讨论及回复；
5. 参与讨论，与 Maintainer 和其他开发者充分沟通。如果大家有意见，可以按照建议修改你的补丁后重复步骤 3；
6. 你的补丁经过充分的讨论和验证后，得到了 Committer 和 Maintainer 的认可，通过了门禁和测试用例的各项考验，最终合入内核仓库。

当前版本 v1.3 @ 2021-03-15

版本更新日期作者更新日志v0.92021/03/01汪雄峰完成 v0.9 版本v1.02021/03/01成坚完成了内容，并将格式修改为 MARKDOWNv1.12021/03/03汪雄峰完善了 issue 提交帮助v1.22021/03/04成坚完善了沟通交流渠道一节的内容，添加技术讨论群添加渠道v1.32021/03/15成坚根据检视同学的进行，进行了认真的修改

感谢 张文博\[1]，张明\[2] 两位同学对文档的检视。针对大家的意见进行了修改，感谢。其中

- 张文博\[3]同学，检视的非常仔细，发现了很多问题。
- 张明\[4]同学，除了检视发现了不少问题，还按照文档描述的流程，进行了验证操作。

## 1 环境准备与配置

* * *

我们需要一台安装了 `linux` 系统的机器，由于你要编译内核，最好是服务器，当前 PC 也是可以的。

openEuler kernel 代码使用 git 管理，开发过程涉及较多的 git 操作，你的开发环境上需要安装 git，对于 git 配置和使用不熟悉的同学，可以前往 Git 教程-廖雪峰\[5] 学习，或者自行查阅资料。

### 1.1 下载 openEuler kernel 代码

* * *

openEuler kernel 开源在 gitee 上面。

```
git clone git@gitee.com:openeuler/kernel.git
```

**强烈建议使用 ssh 协议**，由于 kernel 仓库较大，使用 https 协议下载，可能会下载失败，特别是当你辛辛苦苦下载一半然后失败的时候，那种感觉....

使用 git 下载 kernel 代码前，请确认你的 ssh key 已正确配置，参见 Gitee 官方文档 生成/添加 SSH 公钥\[6] 和 SSH 公钥设置\[7]。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7st7Rxh2RM2msS0m1myJP04cwWTQMuhte4qgmJrS8JN2icicEWUP8CNKUy8gA0USC8f8Tick6Lnn8w/640?wx_fmt=png)

默认会把仓库下载到和仓库同名的目录下。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7st7Rxh2RM2msS0m1myJP9tDqLNA6A5HHcTdTWZxqRJibhblmZ9F9Om0O4nfia2oHjrtvEdYD0Gaw/640?wx_fmt=png)

openEuler kernel 代码开源在 Gitee 上，但是 github 也提供了镜像仓库。地址如下：

```
https://github.com/openeuler-mirror/kernel.git
```

注意：**由于是镜像仓库，因此是定期（每天）更新的。因此代码和 Gitee 仓库可能存在一天的延迟**。

### 1.2 git 配置

* * *

配置 git 需要配置用户名和邮箱

```
git config --global user.name "Zhang San"
git config --global user.email "zhangsan@163.com"
```

这些信息都将作为以后你提交补丁的“身份戳”。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7st7Rxh2RM2msS0m1myJPlhkyLQNeicwK0Z0ic2AMagJoBn5OVfTg7XILMU7HEybGkFpravYsCEUA/640?wx_fmt=png)

待你提交补丁合入后，你的大名将显示在 git 的 log 中。

另外 git 默认配置的编辑器为 `EMACS`，如果你更习惯用 `VIM`，可以通过如下命令设置 GIT 默认编辑器。

```
git config --global core.editor vim
```

配置完成后的信息，都存储在本地 `~/.gitconfig`，你也可以直接查看和修改该文件。你可以可以通过 `git config --list` 查看你的 GIT 配置。

### 1.3 配置 git 邮箱服务器

* * *

我们向 openEuler kernel 提交补丁以及和社区的小伙伴们探讨问题，都是通过邮件进行交流的。

推荐大家使用 git send-email 来发送补丁，直接使用 yum(或者 apt) 安装即可

```
sudo yum install git-email
```

> 注意: send-email 并不是 git 的必备组件，你可以使用 "git send-email" 确认一下。如果正确显示了 send-email 的 help 信息，那么 send-email 已经安装在你的系统了。否则如果显示结果类似于下面：
> 
> ```
> # git send-email

git: 'send-email' is not a git command. See 'git --help'.
> ```
> 
> 你需要安装 send-email 命令。你的版本可能有一个 send-email 的安装包。一般来说这个包的名字都是 "git-email"，当前不同发行版可能会有差异。

使用 `git send-email` 命令发送补丁是通过你邮箱的 SMTP 服务进行的，因此我们必须正确的配置 SMTP 服务。以 163 邮箱为例，配置信息如下所示：

```
# cat ~/.gitconfig
[user]
 name = Zhang San
 email = zhangsan@163.com

[core]
 editor = vim

[sendemail]
 from = "Zhang San <zhangsan@163.com>"
 smtpserver = smtp.163.com
 smtpuser = zhangsan@163.com
 smtpserverport = 25
 suppresscc = all
 confirm = always
 smtppass = xxxxxxxxxxx
```

附常用邮箱的 `POP/SMTP` 服务。

邮箱服务商POP3 服务SMTP 服务163 免费邮pop.163.comsmtp.163.com126 免费邮pop.126.comsmtp.126.comyeah.net 免费邮pop.yeah.netsmtp.yeah.net

> 注意，目前国内的大多数邮箱为了安全，都是默认关闭了 POP3/SMTP 等服务的，我们需要自己手动打开。可以参见网易提供的帮助文档或者查阅其他网络资源，比如这篇 网易 163，126 邮箱如何开启 POP3/SMTP/IMAP 服务\[8]
> 
> 另：服务器地址也可以在设置页面找到
> 
> 另外 163 邮箱过程中，还是用了授权码作为 SMTP 服务的验证密码，因此如果开启了授权码，那么 smtppass 字段填写的就是你的授权码而不是登陆密码。

可以先简单发一封邮件测试下

```
git send-email -to zhangsan@163.com ./xxxx.patch
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7st7Rxh2RM2msS0m1myJPZvEIBvqh9VEqN5AibRqWibpIeKRFIDY8Hvc7FXwyx0KqkgKlGJj6plVQ/640?wx_fmt=png)

## 2 补丁制作与提交

* * *

### 2.1 修改内核代码解决 bug 并提交

* * *

这个过程我们不详细描述了，大家把问题解决掉之后，提交到本地，然后验证，待测试验证完成之后，就可以把自己提交的修改制作成补丁，然后发送到 openEuler kernel 邮件列表进行讨论。

### 2.2 补丁描述

* * *

#### 2.2.1 补丁基本格式

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7st7Rxh2RM2msS0m1myJPolQ3V1mlqK1PHGasU1B1CQYuHfMKd7mjjCsmetdHjickbL8f6iatWFuw/640?wx_fmt=png)

`commit` 信息如下图所示，包括下面 4 部分内容：

格式描述标题简要概括下这个提交完成了什么功能或修复了什么问题commit 头补丁头是 openEuler kernel 追溯补丁来源和功能的手段，关于补丁头的详细内容，请参考 2.2.2 节或者 openEuler kernel 补丁合入规范\[9]。commit 内容具体描述这个 commit 为什么有必要做，怎么修改的，有没有其他要注意的等等，通常 commit 要尽可能的清晰  
对于 bugfix 特别是一些疑难的问题，通常要求清晰的描述：问题的现象、复现方法、原因分析以及采用了什么方式修复该问题。  
对于一些性能优化补丁，通常需要清晰的描述下：当前的版本存在的问题，优化的思路和技巧，以及关键场景补丁合入前后的性能数据对比。  
对于一些 feature，则要详细的描述下特性所解决的问题，实现的思路和使用的场景。引用 or 修复非必须，但是在一些场景下有助于大家对补丁有一个深层次的理解。  
如果你的补丁参考了某个补丁或者文档的思路，请在引用字段指出参考的链接，类似于参考文献。  
如果是个修复补丁，则需要指明你修复的问题是哪个补丁引入的。签名包含了 Signed-off-by/Reviewed-by/Suggested-by/Reported-by/Tested-by 等等信息，是大家对此补丁的签名。

关于 **签名**

签名描述Signed-off-by表明签名者参与了补丁的开发、或者由签名者适配该补丁到当前 kernel 版本。需要注意，最后一个 Signed-off-by 必须是提交补丁的开发人员。Reviewed-by所有人都可以对 openEuler kernel 邮件列表中的补丁进行 review，回复此签名表示签名者认可该补丁的修改。Reported-by表明签名者发现了这个 BUG。openEuler 社区赞扬那些发现 BUG 并报告 BUG 的人，为了表示感谢，并希望更多的人帮助 openEuler kernel 挖掘问题，为内核稳定性作出贡献，建议开发者在解决了他人发现的 BUG 之后，在补丁中添加该签名。Suggested-by表明该补丁的修改思路是这个签名者提出的。openEuler 社区鼓励并赞扬对其他人的问题提供想法的行为。Tested-by表明签名者测试了这个补丁的功能或者性能数据，并保证数据的确定性，并对此数据负责。Co-developed-by表明这个补丁是由多个开发者共同完成的。该签名者的身份是等同于作者的，一般来说 PATCH 邮件在提交之后，会使用邮件的 From 字段所标记的开发者作为 Author，但是如果你希望表明其他人也参与了开发，请使用此签名。

关于**签名**的详细信息，可以参考内核文档 Documentation/process/submitting-patches.rst\[10] 或者主线内核手册\[11]。

关于 **引用和修复**

- References 字段，通常填写当前补丁参考的内容或者相关联的补丁信息。其他人可以通过 References 信息了解你补丁的思路或者问题信息，都可以在这里指出。
- 如果你的补丁是一个修复补丁，那么我们一般建议在提交补丁的时候，找到引入问题的那个 commit，然后填写 Fixes 字段。

#### 2.2.2 openEuler kernel 补丁格式要求

* * *

openEuler kernel 的补丁格式延用了 Linux kernel 社区的格式，但是 openEuler kernel 为了对补丁和问题的来源和定位信息进行跟踪，因此在补丁的 `commit message` 之前要求大家添加一些补丁头。

字段描述XXX inclusion表明这个补丁是哪个组织或者机构提交的或有谁维护，如果是主线补丁请填 mainline，如果是 LTS 补丁，请填写 stable，自研补丁填写对应机构的的缩写category表明这个补丁的类别，一般如下字段可选 : bugfix/performance/feature/docbugzilla填写补丁对应的 issue 链接或者 bugzilla 链接。用于跟踪此问题的详细信息和定位日志，通过关联网站查阅此信息，可以清楚的了解该补丁修改的问题，或者该特性所完成的工作，以及需求来源等信息。  
所有你关于此补丁想知道的可能都在这里，一般 bugziila 或者 issue 任选其一即可。CVE如果当前补丁是 CVE 修复补丁，则必须填写，否则请填 NA

非主线特性，请使用此格式提交

```
openEuler inclusion
category: bugfix
bugzilla: https://bugzilla.openeuler.org/show_bug.cgi?id=6
CVE: NA
```

主线补丁，请使用此格式提交。

```
mainline inclusion
from mainline-v5.2-rc1
commit 898490c010b5d2e499e03b7e815fc214209ac583
category: bugfix
bugzilla: https://gitee.com/openeuler/kernel/issues/I390TB
CVE: NA
```

关于补丁头的更详细信息，请参照 openEuler kernel 补丁合入规范\[12]，信息如有出入，以合入规范为准。

#### 2.2.3 示例

* * *

下面就是一个比较清晰的 bugfix 补丁的格式：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7st7Rxh2RM2msS0m1myJPAxdjnlA2zjcRVIKCXzzf1X8OKpvicmZPZgoxCTjemTG8Hlk4fAibet6g/640?wx_fmt=png)

这个补丁的描述中较为详细的说明了这个补丁触发的场景、现象和复现步骤，也提出了解决的思路。

### 2.3 补丁制作

* * *

#### 2.3.1 生成 patch

* * *

使用 format-patch 生成 PATCH

参数描述-s/--signoff添加自己的 Signed-off-by 戳，自己提交的补丁，不管是不是自己自研的，都是要带上自己的签名的，使用 -s 自动在 patch 最后添加自己的签名--subject-prefix "PATCH openEuler-1.0-LTS"为补丁标题添加前缀，默认的前缀为 `[PATCH]`，可以使用此参数修改补丁补丁标题的前缀，我们的补丁必须显式告诉 Committer/Maintainer 们，补丁是为哪个版本或者分支提供的-N将前 N 个提交生成 PATCH 文件，比如 -65 将生成 65 个 PATCH，我们可以指定开始生成的位置，指定 tag/commit id 等都可以-o XXXX将 PATCH 生成到 XXXX 目录下

使用 git format-patch 生成补丁文件

- 生成单个 patch

我们针对某个 commit 生成一个 PATCH 文件出来

```
git format-patch -s -1 9ced0cc25946
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7st7Rxh2RM2msS0m1myJPoZjBPibNTw1FMxRzpybVc93VyMibmokLQJMRNekE3DvX0DV9r6Uic4JiaQ/640?wx_fmt=png)

- 生成一组补丁集(patchset)

kernel 要求补丁满足最小化原则，每个补丁都完成一个单独的功能，因此对于某些比较大的改动，就需要提交多次 commit，这时候我们通常将这些提交生成一个补丁集，使用的命令如下图所示。

```
git format-patch -s -10 --cover-letter --subject-prefix "PATCH v3 openEuler-1.0-LTS" -10 -o  mpam/20210301/v3
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7st7Rxh2RM2msS0m1myJPwhBTtziab3Owibz2BQaU9omskT5xvlOic8uY6OsMUAuWJLZic2qicyHpOBg/640?wx_fmt=png)

上面的命令，将当前 HEAD 位置开始，往前的 10 个补丁生成 PATCH 文件，并输出到当前目录 mpam/20210301/v3 路径下，补丁的标题前缀 "PATCH v3 openEuler-1.0-LTS"，表示这个补丁是为 openEuler-20.03-LTS 提供的，并且已经是第 3 个版本。

一般一组补丁集(patchset)我们会使用 `--cover-letter` 生成补丁集封面。在 patch 目录下名为 0000-cover-letter.patch 的文件就是生成的 patchset 封面，我们可以在这个封面中填写我们补丁集的描述信息。

1. 修改第 1 个框中(`*** SUBJECT HERE ***`)的内容为对该补丁集的简要描述；
2. 在第 2 个框中(`*** BLURB HERE ***`)具体描述该补丁集。

> 注意 将 `***` 一起替换掉，要不然你的标题叫 `*** fix XXXXXX ***` 也是蛮奇怪的。这个封面补丁只是作者呈现补丁集用的，方便大家对整个补丁集有一个直观上的认识。在 apply 之后这个补丁并不会出现在 git log 中。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7st7Rxh2RM2msS0m1myJPUvbMHpS8SVzYJKRXduh2h23T9EImQ8keoUbibXiadR0SywgrgVUYDAtg/640?wx_fmt=png)

> 注意我们可以指定 commit id 为 patchset 的结束位置 如果没有指定要生成的 PATCH 结束位置的 COMMIT 号，则默认使用 HEAD。

- changelog 信息

一般软件发布的时候，changelog 用来说明与上一个版本的差异，对于内核 PATCH 来，我们的版本在经历了几次修改之后，也建议用 changelog 描述下相比较之前版本的修改点。这有助于 Committer 对补丁的修改和逻辑有一个大致的了解。

对于 patchset ，一般我们把 changelog 写到封面补丁中，在 patchset 的详细描述信息之后填写 changelog 信息。由于这个补丁不会出现在 git log 中，自然也不用担心 changelog 出现在版本的 git log 中。我们以 mainline patchwork 中的 patchset 举例，参见\[13]

对于单个 patch，如果在 commit message 之后填写 changelog 信息，apply 之后就会体现在 git log 中，这自然不是我们想要的。这种情况下，git 为我们提供了一种更简单的方式。在最后一个 Signed-off-by 之后，git 打印了几个短杠 "---"，在这几个短杠之后，修改文件列表之前，我们可以在这里畅所欲言，而不会体现在 git log 中。这里也是我们可以填写 changelog 的地方。同样以 mainline patchwork 中的 patch 为例，参见\[14]

#### 2.3.3 checkpatch 检查

* * *

内核提供了 \`scripts/checkpatch.pl\`\[15] 脚本用来对代码进行静态扫描，主要用来识别一些不规范的编码。

- 使用 `script/checkpatch.pl XXXX.patch` 对生成的单个 patch 进行检查。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7st7Rxh2RM2msS0m1myJPew1yrFrgBsBOXqsicsicOunDhtsplwtejrmKlX67GuHxPXSBfdaRv9Mg/640?wx_fmt=png)

> 注意 检查出的部分内容是由于我们追加的补丁头等信息报错的，这部分内容不用修改 比如上面检查出的如下错误:
> 
> ```
> ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit fatal: bad o ("778836857adfba3f8")'
#8:
commit 1a999d25ef536a14f6a7c25778836857adfba3f8

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit fatal: bad o ("7a702e7819e62f04e")'
#13:
commit 8310b77b48c5558c140e7a57a702e7819e62f04e upstream.
> ```
> 
> 这些问题都是由于内核编码规范中要求内核 commit 按照固定的格式描述，但是我们的补丁头明显不符合这些格式。这类问题我们忽略就好了。

- 也可以加上 `-f` 选项，直接对文件进行检查。这样在编码过程中，就可以直接边检查边改了，在 `checkpatch` 的错误信息清掉之后，再生成 patch。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7st7Rxh2RM2msS0m1myJPnS9X52pEbiaxoOvq9vHd5WoRohBUyQt7uBuzdAtGNz9NkFwKfPWJ4Xw/640?wx_fmt=png)

除了一些补丁头等引入的问题不需要修改，其他问题按照要求提示修改即可。

关于内核编码规范，可以参考 \`Documentation/process/coding-style.rst\`\[16]，或者中文版 Linux 内核代码风格\[17].

#### 2.3.4 发送补丁到 openEuler kernel 社区

* * *

使用 git send-email 发送邮件到 openEuler kernel 的邮件列表 kernel@openeuler.org。发送补丁到邮件列表之前可以先发送自己的邮箱，方便自检下补丁的格式是否满足要求。发送到邮件列表的邮件会被订阅该邮件列表的所有人收到，包括维护该模块的 Maintainer。待经过充分的讨论，社区对补丁的修改没有异议之后，补丁会在后续合入 openEuler kernel。

```
git send-email –cc zhangsan@163.com --to kernel@openeuler.org 0001-arm64-fix-compile-error-when-CONFIG_ACPI-is-not-enab.patch --suppress-cc=all
```

建议大家推送补丁的邮件显式地抄送一下相关 Maintainer 及 Committer。

> 注意：建议发送之前先订阅 openEuler kernel 邮件列表，订阅流程请参阅本文 3.4 节的内容。由于邮件列表设置了安全规则，对于未订阅用户发送的补丁，可能会被邮件服务器拦截。
> 
> 所有人都可以对邮件列表的补丁进行讨论和 review，也建议大家多提意见，多讨论。

## 3 附录

* * *

### 3.1 openEuler kernel 分支介绍

* * *

- 开发主干 (OLK: openEuler Long-term support Kernel)

openEuler 每隔几年会选取一个上游社区的 LTS 内核版本，继续开发和维护。该版本作为 openEuler kernel 的开发主干，支持新特性、新硬件、回合社区高版本特性。作为 openEuler kernel 维护分支的上游。（开发主干请不要直接用于生产环境）

分支名说明停止维护时间kernel-4.19(OLK-4.19)openEuler kernel 4.19 的开发主干2024.03OLK-5.10openEuler kernel 5.10 的开发主干2026.03

- 维护分支

openEuler 版本发布之后，对应的内核由开发状态转为维护状态。合入较少的特性，并考虑合入补丁的兼容性和稳定性。

分支发布时间停止维护时间状态说明openEuler-1.0-LTS2020-03-122024-03维护中20.03 LTS SP1/SP2 的维护分支openEuler-20.092020-09-302021-03维护中20.09 创新版本的维护分支openEuler-21.032021-03-30(TBD)TBD开发中21.03 创新版本的维护分支

Notes: 各版本和分支的生命周期以 openEuler 官方发布的为准，上面表格仅供参考。

- openEuler 社区各版本发布时间和生命周期\[18]

### 3.2 issue

* * *

https://gitee.com/openeuler/kernel/issues

我们可以向 openEuler kernel 提一个 issue，如下图所示。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7st7Rxh2RM2msS0m1myJPmSTwgboZv8xXRg1IU3qOGDJzfOd3RDaqibQaQJ4M56iafdeX6RrmVWMg/640?wx_fmt=png)

issue 的类型请按要求填写，对于 BUG 一般选择 "缺陷"，标题格式为 "\[分支名 架构] 具体问题描述 xxx"。

**温馨提示**issue 请在 **openEuler/kernel\[19]** 仓库创建**不要**在 **src-openEuler/kernel\[20]** 仓库创建 src-openEuler/kernel 是 openEuler 用于构建 kernel 镜像和 RPM 包的构建仓库，并不是 kernel 源代码仓库。

### 3.3 bugzilla

* * *

Bugzilla 是一个开源的缺陷跟踪系统(Bug-Tracking System)，openEuler kernel 使用 Bugzilla 跟踪整个 kernel 的开发过程，包括 bug 的发现、分析、解决过程，feature 的需求、开发过程等。

openEuler bugzilla 目前已经上线了，大家可以使用这个平台提交各类问题。地址: https://bugzilla.openeuler.org

### 3.4 邮件列表

* * *

为了更好的参与 openEuler kernel 社区，我们可以通过下面的网址订阅 openEuler kernel 邮件列表，点击 Kernel-discuss 或者 Kernel，填入名字和邮箱即可订阅。

订阅邮件列表后，我们也可以收到其他参与者发到 openEuler kernel 社区的补丁，与其他人一起讨论补丁内容，协作开发。

邮件列表地址归档地址描述openEuler kernelkernel@openeuler.orgArchive\[21]kernel 的主邮件列表，主要是 kernel patch 的提交和讨论。其他关于 kernel 的所有信息都可以发送到此邮件列表openEuler kernel-discusskernel-discuss@openeuler.orgNA主要用于讨论内核相关问题，鉴于 kernel 主邮件列表邮件可能较多，喜欢清静，只想静静的讨论技术的可以订阅此邮件列表。

查找 openEuler 更多邮件列表，请前往\[22]

### 参考资料

\[1]

张文博: *https://github.com/ethercflow*

\[2]

张明: *https://github.com/zhangming-cloud*

\[3]

张文博: *https://github.com/ethercflow*

\[4]

张明: *https://github.com/zhangming-cloud*

\[5]

Git 教程-廖雪峰: *https://www.liaoxuefeng.com/wiki/896043488029600*

\[6]

生成/添加 SSH 公钥: *https://gitee.com/help/articles/4181*

\[7]

SSH 公钥设置: *https://gitee.com/help/articles/4191*

\[8]

网易 163，126 邮箱如何开启 POP3/SMTP/IMAP 服务: *https://jingyan.baidu.com/article/3f16e003e327772591c1039f.html*

\[9]

openEuler kernel 补丁合入规范: *https://openeuler.gitee.io/kernel-portal/post/2021/03/0001-openeuler\_patch\_format\_specification*

\[10]

Documentation/process/submitting-patches.rst: *https://gitee.com/openeuler/kernel/blob/kernel-4.19/Documentation/process/submitting-patches.rst*

\[11]

主线内核手册: *https://www.kernel.org/doc/html/latest/process/submitting-patches.html*

\[12]

openEuler kernel 补丁合入规范: *https://openeuler.gitee.io/kernel-portal/post/2021/03/0001-openeuler\_patch\_format\_specification*

\[13]

参见: *https://lore.kernel.org/patchwork/cover/1340764*

\[14]

参见: *https://lore.kernel.org/patchwork/patch/1328176/*

\[15]

`scripts/checkpatch.pl`: *https://gitee.com/openeuler/kernel/blob/kernel-4.19/scripts/checkpatch.pl*

\[16]

`Documentation/process/coding-style.rst`: *https://gitee.com/openeuler/kernel/blob/kernel-4.19/Documentation/process/coding-style.rst*

\[17]

Linux 内核代码风格: *https://gitee.com/openeuler/kernel/blob/kernel-4.19/Documentation/translations/zh\_CN/coding-style.rst*

\[18]

openEuler 社区各版本发布时间和生命周期: *https://gitee.com/openeuler/release-management/blob/master/lifecycle.md*

\[19]

openEuler/kernel: *https://gitee.com/openeuler/kernel*

\[20]

src-openEuler/kernel: *https://gitee.com/src-openeuler/kernel*

\[21]

Archive: *https://mailweb.openeuler.org/hyperkitty/list/kernel@openeuler.org*

\[22]

请前往: *https://openeuler.org/zh/community/mailing-list*

\[23]

Contributions to openEuler kernel project: *https://gitee.com/openeuler/kernel/blob/kernel-4.19/README*

\[24]

openEuler kernel SIG: *https://gitee.com/openeuler/community/tree/master/sig/Kernel*
