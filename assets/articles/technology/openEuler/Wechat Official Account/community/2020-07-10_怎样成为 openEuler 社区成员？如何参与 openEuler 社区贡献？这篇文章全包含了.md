# [怎样成为 openEuler 社区成员？如何参与 openEuler 社区贡献？这篇文章全包含了](https://mp.weixin.qq.com/s/I0fEoAZLlgPYjqYCkVVFsQ)

*熊伟*[OpenAtom openEuler](javascript:void%280%29;)*2020-07-10 19:24:48*

 openEuler 社区已经建立起来了，也有不少合作伙伴, OSV, ISV 等参与进来。整个社区的治理结构也初步建立了起来。但毕竟是一个年轻的社区，因此有一些流程方面还有待优化，很多文档还有待于完善。

鉴于有很多工程师希望参与到社区里的工程师对整个社区的运作流程，开发流程还比较陌生，我总结了一个文档来帮助一个工程师更容易的参与到社区中。

openEuler 社区在这个半年的运作里，不少合作伙伴、OSV、ISV 都陆续参与了起来。整个社区治理结构也初步建立起来了。但是 openEuler 仍然是一个年轻的社区，在一些流程方面还有很多优化空间。

很多工程师希望参与到 openEuler 社区的整个运作流程，但是对于社区的整个运作流程还比较陌生。所以本篇文章跟大家讲一讲，如何参与到 openEuler 社区的建设之中。

**openEuler 社区**

***https://openeuler.org*** 

openEuler 社区首页是一个导航页，提供了各种网页入口。在这些入口当中，对于工程师最重要应该是下载链接：

***https://openeuler.org/zh/releases.html***

对于想要参与到 openEuler 社区建设的工程师来说，社区贡献网页才是你们需要关注的。

**openEuler 社区贡献**

***https://openeuler.org/zh/developer.html***

 

## **法律合规是第一步，也是最重要的一步**

“开源” 这两个字在很大程度上代表了自由，奔放，随心所欲。符合工程师天生追求“自由飞翔”的特质。

但开源并不是法外之地，法律合规是一个社区健康发展最重要的前提，没有之一。任何一个工程师，如果想要参与到 openEuler 项目中，第一步就是要签署 CLA 协议。协议的签署网址是：

**CLA 协议签署网址**

***https://openeuler.org/en/cla.html***

协议内容并不复杂，作为一个工程师，通常我都对这类法律文书都是免疫。

我们连需要给自己赔钱的保险合同都不会多花上一分钟时间看上一眼，对于这种需要自己奉献的条款又怎会关注呢？还有更关键的是，如果码农看懂了法律文书，那还是码农么？

这很大程度是我们工程师的现状，但是我还是建议大家认真阅读一下协议，了解一下权益范围并没有坏处。

 

**openEuler 社区是开源的**

openEuler 社区原则上只接受开源协议的软件，哪些开源协议是社区认可的开源协议呢？大家可以参考下面的网址。

对于社区本身，我们默认使用 mulan V2 协议，这是一个非常友好的开源协议，也欢迎大家更多的使用这个协议来开发开源软件。

# **木兰宽松许可证**

***https://opensource.org/licenses/MulanPSL-2.0***

**我能做点什么**

在签署完 CLA 协议和了解 openEuler 社区所认可的开源协议以后，下面要进行的就是完成社区的注册。

由于 openEuler 本身是开放到 gitee.com 上，因此需要大家拥有 gitee 账号，如果没有，请去注册一个。

你完成上面这部的时候，恭喜你，你已经是 openEuler 社区的一员了。

所以，我能够做点什么？参与社区有很多种形式，如果总结起来，大体有下面的四类：

**提交一些需求或 bug**：简单来说就是发现哪里用的不爽，直接提 issue。或者在用 openEuler 的过程中发现了一些问题，把这个问题反馈给社区。

为社区修正 bug：这是更高一个层面的参与社区了，在这个层面，工程师实质上是以一个开发者角色进入到了 openEuler 社区中。我们提倡大家提出问题，我们也希望大家能够解决问题。

**贡献软件包**：发现 openEuler 缺失了一个软件包，帮 openEuler 把这个软件包补上。实际上贡献软件包的过程就是帮助 openEuler 丰富功能的过程。只有大家的不断的贡献软件包，openEuler 才能够成为一个“无所不有”的软件生态系统。

**开发新软件**：有一些新想法，想独立开发一个全新的软件，并将这个软件贡献到 openEuler 社区，成为 openEuler 发行版本中的一份子。

下面我们就来看看这 4 种参与方式如何进行吧。

## **提交一些需求或 bug**

## 最基本参与社区的方式当然是要先用一用社区的物件，看看还有哪些需要改进的地方。提出一些有价值的建议和意见了。这几乎是最简单参与社区的方式了。

在社区中，我们提交问题都是通过“issue”机制来进行。但是在提交之前，提交人得先明确这个 issue 要提交给谁。在社区里，我们是一个个“repo”来对功能进行分组的。比如我们著名的Linux操作系统的“内核”（kernel）就有一个独立的“repo”(通常我们称之为“仓”)。

如果你发现了一个内核的问题，或者需求，那么就需要找到内核相关的 repo 地址。

**openEuler Kernel 地址**

***https://gitee.com/openeuler/kernel***

它的界面这个样子。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbDzxR8ezkVayYsjmnswzKicZw1tvFKS6QKYXIRuY9KkGUgxibV1lIJibf3hx7vqDvLgslJYFTlfWVvA/640?wx_fmt=png)

其中红圈里大家可以看到 issues 这个字样，这就是我们所有问题&bug&需求的入口了。点进去以后可以看到：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbDzxR8ezkVayYsjmnswzKicXY2tk83JVYvslV1Q164xqkGBeKr7pN7SRtMobZJRRKu0dbpmqKiaJfg/640?wx_fmt=png)

红圈位置的按钮就是我们建立一个新的 issue 的入口。

进入以后，就可以提交 issue 了，有分类栏来说明这个 issue 属于什么类别。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbDzxR8ezkVayYsjmnswzKicTvZxotcImqBrtWxOg5T0jz07ev10gP8U8dbiakAuAOtOlR6FEP4eS9A/640?wx_fmt=png)

在这里，可能会有一些同学们会问：为什么没有一个 bugzilla ？这是一个拷问灵魂的问题，是呀，为啥没有建立一个工程师们更为熟悉的 bugzilla 呢？我没有办法给出一个合理的解释，不过目前看越来越多的项目都逐步通过 issue，PR 等机制来管理项目，如果再独立构建一个 bugzilla 系统，那么和 PR，Merge 合入等的工作就需要进行交联，复杂度会增加，因此目前我们还是选择通过 issue 来管理 bug 和需求。

总体来说，提交 issue 分如下几类：

具体软件的问题直接提交到相关的软件 repo 中，比如上面所提到的 kernel 的 repo 中。

社区中的一些基础设施用的不爽，比如网页看起来不顺眼等，提交到基础设施组。

如果是一些社区治理方面问题，例如技术选型，软件的增加，删除，GNOME 和 KDE 哪个更图形界面原教旨主义一些等问题可以提到 community 组。

**基础设施组**

***https://gitee.com/openeuler/infrastructure***

**community 组**

***https://gitee.com/openeuler/community***

**不知道提到什么地方**

***https://gitee.com/openeuler/community-issue***

更为详细的 issue 提交流程可以参见如下的专业讲解

***https://gitee.com/openeuler/community/blob/master/zh/contributors/issue-submit.md***

## **修复 bug**

在社区里，通常我们希望提出问题并同时解决问题，如果有一个问题，当然最好的情况是同时提供问题解决的 patch 补丁。我们以社区的轻量化容器引擎 iSulad 为例，假定我们需要为 iSulad 提交一个 patch 补丁，基本流程如下：

### **第一步：建立自己的分支**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbDzxR8ezkVayYsjmnswzKicFxh4zXNxNnnrSgnibF4JBSw0iarkcDd0EE3YcT5Fcah7LBfwQXZIhggQ/640?wx_fmt=png)

在红圈处先要 fork 一个“分支”到自己的账号下。如果大家不清楚 fork 的含义，建议学习一下 git 的使用方法。在这里要提一句，无论如何，现代工程师要理解git的开发模式，不了解 git 在当代几乎会寸步难行。

### **第二步，修改代码并生成 Pull Request(简称PR)**

当 fork 完毕以后，大家可以在下图的红圈1中发现，目录已经从 openEuler 切换成了自己的账户。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbDzxR8ezkVayYsjmnswzKicicLMlrrcbWTaJN5dJtbTk7XKa5Itaian7yzficnCt4swVVo9nHjlXe6pg/640?wx_fmt=png)

接下来，就可以在自己的“分支”上进行代码的修改了。

修改完以后，点击红圈2中的+PR，这可能是提交代码中最关键的一个步骤，这里会正式生成一个 patch 并送到 iSulad 社区。

比如我修改了一个函数，增加了一行代码。那么 PR 看起来就是这样的：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbDzxR8ezkVayYsjmnswzKiccF43kXa45dn2vXdHzttACrUbicSAvjCQns9t4e4suxnBHcYwUVrsbYA/640?wx_fmt=png)

你需要为这个 PR 起一个名字，同时填写一个说明。分别是红圈1和2，最后确定 patch 没有问题以后，点击红圈3中的“创建”按钮提交。

你会在 iSulad 上看到你所提交的PR，红圈一表明你提交的 PR 已经进入了 iSulad 的社区，红圈2中的数字228是这个 PR 的编号。同时这个 PR 的 URL 是：

***https://gitee.com/openeuler/iSulad/pulls/228***

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbDzxR8ezkVayYsjmnswzKicU0Ah0MnD5k7Aqpha1C7j4Nm9oju3Cx1GibVsMnO9RoFfB5jcVGNIobQ/640?wx_fmt=png)

至此，作为一个 patch 提交者的工作就做完了，你剩下所要做的事情就是耐心的等待 iSulad 开发组的 maintainer 来审核你的 patch，比如我相信今天晚上他会非常诧异，谁提交了这么一个 stupid 的 patch，而且公然用 useless demo 这样的 PR 题目来挑战他脆弱而敏感的 maintainer 神经。

因此，你的 PR 可能有三种命运：

1. 被 iSulad 社区接受。
2. 被 iSulad 社区残忍的拒绝。
3. 提出修改意见，修改后再提交 PR。goto 1

不仅仅是可以提交代码的 PR，任何修改，甚至是为 readme 修正了一个拼写错误，所遵循的流程都一摸一样。

更细致，更专业的介绍请参考：

***https://gitee.com/openeuler/community/blob/master/zh/contributors/Gitee-workflow.md***

这里有一步步的教程引导大家来提交。

另外，PR 的提交也在很大程度上体现了提交者的专业能力和亲和力。Be nice 很重要，下面的链接可以帮助大家理解如何更优雅的提交一个 PR。

***https://gitee.com/openeuler/community/blob/master/zh/contributors/pull-request.md***

好了，恭喜您，至此，您的第一次真正意义上的社区开发之旅就画上了一个完美的句号。

让我们进入下一个挑战环节，为 openEuler 增加一个新的软件包。

## **参与方式三：贡献软件包**

在能够为 openEuler 贡献一个软件包之前，需要我们的开发者理解两个基本的概念：

1. 什么是 Linux 的软件包。或者说 Linux 操作系统是怎么组织的。
2. 如何制作一个软件包。

### **OS是怎么组织的**

显然这是一个非常巨大的话题，可能需要写一本书来讲 OS 是怎么组织，怎么构建出来的。在这里我只能简要的给大家介绍一下。

实际上，一个 OS 系统的组成既复杂，也简单。

何所谓简单呢，其实 OS 本质上就是一堆安装包的大杂烩，就类似我们不论使用 Windows 也好，使用 Android 也罢，或者使用 Linux，我们都经历过“安装”这个概念，就是从网上，或者是从“仓库”中下载一个安装包，然后安装到系统上，所以大家可以看到安装的“进度条”。实际上，一个 OS 的安装过程和在 Andorid 上安装微信的道理一模一样。只不过所谓的安装 OS 是需要一次性的要把几千个软件包按照一定的顺序安装到机器中。

那么 OS 所谓的组织很复杂呢，大家可以想象一下，几千个软件，他们之间会有很多的交联关系，通常我们叫做“依赖关系”，就好比，如果你想用微信小程序，那么前提是必须先得有微信，那么安装微信小程序的前提就是必须要先安装微信。因此，即使我们考虑一个 OS 的安装过程，其实也是非常复杂的，必须要精确的计算哪些软件需要先安装，哪些需要后安装。随着系统的膨胀，那么这些软件包之间就形成了复杂的网状关系。即使我们这些行业内的人都为此头痛不已。

讲了这么多，和我们的 openEuler 社区开发有啥关系呢？其实，上面的讲解是要让大家理解，任何 OS 的基本零件就是软件包，就类似组成人体的基本零件是细胞一样。这一个个软件包就是构成 OS 的一个个基本零件。

在 Linux 的世界，有两种基本的安装包格式：

#### **RPM**

这个格式是 redhat、SUSE、WindRiver、openEuler 等所选用，目前在企业市场，基本是以这些厂家为主，因此 RPM 格式在商用企业市场用的比较多。

#### **Deb**

这个格式是 Debian, Ubuntu, Android 使用的，目前在 desktop，终端则用的比较广泛。

这两种格式本身没有什么优劣之分，只是不用厂商的选择而已。当然，对于客户，开发者来说，世界被割裂成为两个互不兼容的部分总归是一种不必要的残忍。对于这个问题社区也有不同的尝试，但目前为止还没有出现某个大一统的软件包格式能够终结这个分裂的世界。

不过幸好我们有容器，很大程度上，容器的出现缓解了这个问题。那未来能不能找到一条优雅的技术道路将这些不兼容，将这些复杂的软件包的依赖带来的诸多痛苦一并解决掉呢？我把这个问题留给本文的爱好者吧，也许在你们中间就会出现这样的“历史终结者”。

所以，一个软件从源代码到能进入到我们的 OS 安装光盘中，要经历三个步骤。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbDzxR8ezkVayYsjmnswzKicXZMAiaZxk9djjI4DZvC5WrurS020AaN2JSQu8MSwsEaQFvArkzruz8g/640?wx_fmt=png)

#### 第一步：源代码开发阶段，也就是写程序的阶段。这个阶段可以在任何地方，可以在 github，gitlab, gitee 等代码托管平台上，也可以是自己的笔记本电脑上。

#### 第二步：将代码编译，生成二进制可执行程序。并且制作 RPM 软件包，其中“制作 RPM”的过程实际上也是一种“编程”，只不过使用的是一种定义好的脚本语言，“程序”是一种叫做 spec 的文件。讲真，spec 的编写是非常不符合老派程序员思维的，那种分段式的，跳跃式的，宏式的写法绝对挑战老派程序员的神经。所以，我们有很多很好的程序员，但是却很少有程序员能将一个程序真正制作成一个 rpm 包（或者 deb 包）。希望大家能挑战一下自己，成为一个 RPMer。真的，不难，但是够你手忙脚乱一阵的。

我们有一个 RPM 的编写规范，可以供大家参考。

***https://gitee.com/openeuler/community/blob/master/zh/contributors/packaging.md***

#### 第三步：将这些 RPM 包放在 ISO 中，做成安装光盘。这一步一般的工程师不用感知，后台有自动化的系统来完整整个工作，而且相关的工具我们也会开源到 openEuler 中。也就是说，后续任何人都可以简单的为自己构建一个 My Linux。

那就让我们看看如果你有一个项目在 github 上，我们如何将它最终转变成为安装光盘上的一个软件包吧。

### 首先，你得有一个组织

人生活在社会中，无时无刻不属于某个组织，并受到一些人的领导，比如白天，你需要属于某一个公司组织，晚上，你需要属于一个家庭组织。

社区也一样，在你想要把一个软件做成软件包放到 openEuler 系统中之前，你需要明确两件事情：

1. 你自己属于哪个组织？
2. 你要加入的这个软件包属于哪个组织？

在 openEuler 社区中，它的基本“组织”单元是 SIG 组，也就是 special interest group，我至今没有弄明白为什么“兴趣”要加上“特殊”这个极易产生歧义和联想的前缀。不过 anyway，如果你想有归属感，你有两种选择：

1. 寻找到和你具有同样“特殊爱好”的小组，然后申请加入。
2. 你的爱好太“特殊”以至于目前还没有志同道合的人，自己申请建一个。

openEuler 所有的 SIG 组都在下面的网址中，大家可以参考。

***https://gitee.com/openeuler/community/tree/master/sig***

如果你有意愿，同时也展示了对某些“特殊爱好”有着深厚的积累或者惊人的天赋，那么欢迎你参照完成一个新的 SIG 组的申请。我不得不说，这个流程不光看起来有一些复杂，也不友好，实际操作起来也是这样的。但我相信这难不倒码农，我们不就是为了制造这些复杂和不友好而生的吗！

***https://gitee.com/openeuler/community/blob/master/zh/technical-committee/governance/README.md***

最后一步，当创建完 SIG 的 PR 申请以后，需要到技术委员会 (TC) 的例行会议上进行评审，在下面的网址中可以找到 TC 委员会的基本信息，还有联系方式，大家可以订阅 TC 的邮件列表来获取一些动态，特别是例会的信息。

***https://gitee.com/openeuler/community/tree/master/zh/technical-committee***

既然说到了 TC（技术委员会），我们就简要讲一下 openEuler 的组织结构吧。

## **组织结构**

openEuler 是一个完全开放的组织架构，而且非常简单，这里可以看到基本的情况。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbDzxR8ezkVayYsjmnswzKicSMsHRkBQKvibTiawRTx5pTppBu4J3NoZknRP57UAWLuZVoRFbaQEdNMQ/640?wx_fmt=png)

***https://gitee.com/openeuler/community***

我想这副图已经说的很清楚了。

### 开始干活，先要弄明白干什么

当然，即使你完全不属于任何一个 SIG 组，理论上也能提交一个软件包到 openEuler 中，只是被接受的概率相对较低而已。其主要原因是很难来评估相关提交的质量，SIG 组很大的意义就在于一些专业方面的人能够为每次提交做出质量的保证。

软件包本身必须是要属于某一个 SIG 的。以我自己常用的一个软件包为例，我每次写完程序以后，都总会执行一下 cloc 这个命令，看一下今天又新增了多少行代码，以期获得一下码农与生俱来的成就感，并中和一下写 PPT 带来的空虚和乏力感。

显然 cloc 是一个开发类的工具，帮助码农统计代码行，幸运的是，拥有同样“特殊爱好”的人并不在少数，他们建立了一个 dev-utils 的 SIG 组。

***https://gitee.com/openeuler/community/tree/master/sig/dev-utils***

我们可以将 cloc 这个软件归属于这个 SIG 组。

### **如何把大象放到冰箱里**

一般来说，增加一个软件包到 openEuler 中，需要如下的几个大步骤

1. 让系统为你的 cloc 软件包建立一个“仓”，也就是 git 仓。
2. 上传制作 cloc 软件包所需要的“零件”
3. 将这个软件系统加入到 openEuler 的自动化编译系统中，由系统自动化构建出软件。

#### 建仓

建仓其实就是提交一个PR，一般来说需要修改三个文件。

1. ***https://gitee.com/openeuler/community/blob/master/sig/dev-utils/README.md***
2. ***https://gitee.com/openeuler/community/blob/master/sig/sigs.yaml***
3. ***https://gitee.com/openeuler/community/blob/master/repository/src-openeuler.yaml***

修改第一个文件 README.md 将你要加入的 cloc 软件的名字和地址放上去。

修改 sigs.yaml 文件，将 cloc 软件增加到 dev-utils 这个 SIG 分组下面。

修改 src-openeuler.yaml 将 cloc 增加到 src-openeuler 里。

你要做的就是照猫画虎的把这三个文件修改了，然后提交 PR 就可以了。剩下的就是等待“命运的裁决”。

当申请的结果被批准以后，你所需要的“仓”就会被系统自动建立起来，对于cloc 来说，它的代码仓的位置在 https://gitee.com/src-openeuler/cloc，这是 PR 被批准以后由系统自动为我建立的。

剩下的时间，你就可以开始真正上传制作 cloc 软件的原材料了。

#### **上传软件包**

一般来说，一个软件只需要上传两个“原材料”就足够制作一个软件包了。如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbDzxR8ezkVayYsjmnswzKicGVkOB6LIv8I4G4QSc6oCeOejmib3om3oCvUUPtksBPUibl65HicXSVickQ/640?wx_fmt=png)

第一个材料：首先要上传这个软件包的 spec 文件，也就是告诉构建系统如何编译，制作 cloc 这个软件包。

第二个材料：cloc 的源代码压缩包。

其它零件：如果 spec 中需要有 patch，那么也需要把相关的 patch 文件上传到仓中。

上传完毕一个软件包所需要的原材料，下一步就是要把这些原材料加入到构建系统中，使之能够被真正编译，生成一个实际的软件包。

#### 加入构建系统

openEuler 现在使用 OBS 作为构建工具系统，大家可以参考下面的这个链接把自己的软件加入到 OBS 中

***https://gitee.com/openeuler/community/blob/master/zh/contributors/create-obs-package.md***

加入到构建系统中，就意味着你的软件可以被系统自动编译，自动生成 RPM 包，继而在后续的 openEuler 发行版本中出现。

#### **TIPS**

在整个过程中有几点需要开发者要注意：

1. 能够本地构建：提交的软件包首先要在自己的笔记本，或者服务器上能够编译通过。也就是如果你的软件包在本地无法构建成功，那么上传到 openEuler 社区也不会构建成功。因此。我们建议最好能下载最新的 openEuler 版本，安装以后通过 rpmbuild 等命令来进行构建验证。
2. 保证软件包可用：软件除了能够被编译和生成软件包，还要能正确运行，因此，在本地环境要保证制作出来的软件包能够：

a) 正确的安装

b) 正确的卸载

c) 正确的升级

d) 软件的功能是正常的。

1. 保证多体系架构支持：openEuler 目前支持 x86\_64 和 ARM64 两种指令集，因此在构建过程中需要能够保证软件包在这两种环境下都能被正确编译和运行。虽然然 ARM64 环境可能并不那么容易获取，但幸运的是，一般性软件在这两个系统上没有那么大的差异。
2. 保证正确的依赖关系：一个软件通常都需要依赖其它的一些软件才能运行，比如所有软件都需要依赖 glibc 这个库来执行，一些复杂的软件可能会依赖很多软件包来提供功能。这些软件包可能已经在 openEuler 社区中有了，也可能没有。如果没有，那么就需要同时在 openEuler 社区中将这这些软件包补齐才行。比如 cloc 这样一个小软件，却需要依赖如下的几个 perl 的软件包：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbDzxR8ezkVayYsjmnswzKiczCvlFLvlteXzwickpEk85xtQnOX1hnkvrOP0Tfz3qeAhq7hgciaSE1yg/640?wx_fmt=png)

也就是说在提交 cloc 软件包的同时，也需要同时提交这几个软件包，这样才能保证 cloc 能够被系统正确的编译和构建出来。

1. 保证 spec 文件的规范性：要保证 spec 文件是“规范”的，避免将外部的 spec 直接引入到 openEuler 中，因为如前所述，因为选择包的范围，依赖关系，版本等都不相同，同时保证所有软件包 spec 是一致的，请依照前面的 RPM 制作规范中的内容来书写 spec 文件。

因此，制作一个软件包，有的时候远比想象中的要复杂一些。但好在这并不是一个难度很大的事情，只需要提交一个软件包，走一遍流程，后续就会轻车熟路了。

## 参与方式四：开发新软件

上面讲的过程都是怎么给“别人”的软件提意见，怎么把“别人”做的软件添加到 openEuler 社区。但是每一个真正做软件的人内心都希望能拥有属于自己的作品，那么如何建立自己的作品，如何将自己的作品融入到 openEuler 社区呢？

将自己的作品融入到 openEuler 社区有如下两种方法：

### 方法一：在其它社区开发，集成到 openEuler 中

假定你已经在 github，gitlab 或者 gitee上 拥有了自己的项目，那么只需要按照参与方式三那样，将软件加入到 src-openeuler 这个 repo 仓就可以了。

### 方法二：在 openEuler 社区中开发，在 openEuler 中集成

另外一种方法是，直接在 openeuler 社区中建立项目，类似将项目“托管”到 openEuler 社区。比如现在社区中的 iSula 和 A-Tune 这样的项目就是这样的模式。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbDzxR8ezkVayYsjmnswzKiczEOQqtXS7iaXJYvO1aewqEQiazNvH5aO6FaxKQwpLY8wrXVVqoq1B0jQ/640?wx_fmt=png)

至此，我相信所有人都能明白了为什么 openEuler 会建立两个仓：

***https://gitee.com/openeuler***

***https://gitee.com/src-openeuler***

openeuler 这个仓是存储所有“原生态”的软件，也就是为原创性的软件提供一个展示的舞台，或者是一个孵化器平台。

而 src-openeuler 则是为 openEuler 的 release 发行版提供生成 RPM 包等构建信息等的地方。

因此，当一个很有梦想，很有情怀的工程师突然有一天有了一个很棒的 idea，那么他可以依照下面的过程来深度参与到 openEuler 中。

在 TC 委员会的例会 meeting 中申请一个开源项目，比如项目名称叫 做“broken\_dream”。

如果 TC 委员会认为这是一个很好的 idea，并且认为值得为破碎的梦想提供一个机会，那么我们会在openEuler 社区中建立一个 repo，网址就 是https://gitee.com/openeuler/broken\_dream

这个项目在 openEuler 社区中持续开发和孵化，直到有一天，大家认 为broken\_dream 已经足以成熟到为所有人提供破碎的梦想服务了，那么就可以 在src-openeuler 中建立一个仓，为 broken\_dream 提供相关的 spec 文件，制作成为一个 RPM。

最终 broken\_dream.rpm 会随着 openEuler 的发布版本走遍全世界，为世界人民提供 broken\_dream 功能。

我始终认为，一个工程师，在他的职业生涯中，至少要有一个，哪怕只有一个项目和他自己的名字是息息相关的。只有这样，才能在孙子，孙女骑在我们背上，问我们这辈子做的最棒的事情是什么的时候，我们可以让他们爬下来，然后直起身，看着他们天真无邪，对未来充满憧憬的大眼睛，认真的问他们：你知道 broken\_dream 的作者是谁吗？

最后，我要感谢 openEuler 社区中每一个贡献者，特别是文档的撰写者们，文档对于码农们来说永远是痛苦的源泉，但正是各位文档的撰写者的辛勤工作，才使得本文能够有一个机会为大家呈现一个完整的 openEuler 参与之旅。

## openEuler 社区欢迎大家。

***欢迎开源爱好者在 openEuler 成立 SIG*** 

***或加入现有 SIG*** 

***共同构建支持多处理器架构***

***统一和开放的操作系统***

***推动软硬件应用生态繁荣发展***

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYRojwmT4cgiba99YWljc4IUzKKic3yagiakZ1cFDfibTChLhs1NTica2KLtBs8dib8WZRtXxvibzW4m0WTg/640?wx_fmt=png)

***记得分享点赞再看哦***

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbR3YNaNBytF0uqAicKL7fRD0JJj1HibCo2Sic0qxQ1LkZPlLqibMPxWUBBGeOOicicX3yY8e2icz81TU7Fg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaRxOeek40gFtDaCe6MiaZtib6LzaoW0UAbwDfDZnRqfVaUKvExibDZodj3nAof4SZ2xZjDnpGoJEH7g/640?wx_fmt=png)
