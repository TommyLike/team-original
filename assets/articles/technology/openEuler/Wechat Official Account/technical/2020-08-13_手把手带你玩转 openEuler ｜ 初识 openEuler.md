# [手把手带你玩转 openEuler ｜ 初识 openEuler](https://mp.weixin.qq.com/s/jxmNv3ASo-OKFsMy0zG5kw)

原创*zyp-rock*[OpenAtom openEuler](javascript:void%280%29;)*2020-08-13 23:30:00*

为了让更多人更深入认识 openEuler 并积极参与进来，社区将出一些列课程和大家近距离接触，邀请 openEuler 开源的重要参与者、SIG 组 maintainer 等资深专家来进行持续分享。本课程分为三部分，主要是让大家了解 openEuler 是什么、怎么玩、如何参与。

- 第 1 部分：认识 openEuler。了解 openEuler 是一个怎样的平台，包含哪些内容。
- 第 2 部分：openEuler 社区运作。通过本讲您可以了解到 openEuler 社区的治理及运作方式。
- 第 3 部分：openEuler 版本介绍。通过该部分您可以了解到 openEuler 的软件构建和未来的一些规划。

## 1. 认识 openEuler

### 1.1 社区网站：openEuler.org\[1]

通过社区网站大家可以了解到更多关于 openEuler 的相关内容，并通过文档查看 openEuler 的使用方法。

openEuler 是一个开源、免费的 Linux 发行版平台，通过开放的社区形式与全球的开发者共同构建一个开放、多元和架构包容的软件生态体系。同时，openEuler 也是一个创新的平台，鼓励任何人在该平台上提出新想法、开拓新思路、实践新方案。

### 1.2 下载体验 openEuler

上面了解了 openEuler 是一个开源免费的平台，对于工程师来说，下载使用才是第一步，那么我们怎么去下载 openEuler 呢？

openEuler 社区提供了openEuler 下载地址\[2]。

可以通过 openEuler 社区导航上的【下载】按钮，下载 **openEuler 20.03 LTS** 的 ISO 安装包。openEuler 20.03 LTS 版本是面向开放场景的标准发行版，生命周期四年。

在 openEuler 使用过程中遇到问题或想提出意见，在社区导航下的【下载】里和文档里可以提出意见反馈，供相关技术人员及时解决问题。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J3hdjOj9sKGYx3T7AyTEcqTrs8qU6iaQFf0ZIiakyb9vH7H30mnFLwDPSg/640?wx_fmt=png)

### 1.3 参与 openEuler 社区

可以通过 openEuler 导航下的【社区】来参与 openEuler 社区，里面有很多社区相关的子菜单大家可以在官方社区里进行深入的了解。这里重点关注三个子菜单：【社区】里的【开发者】可以指导开发者一步一步参于 openEuler 社区、【SIG（项目组）】可以找到自己感兴趣的项目组、【邮件列表】可以收听参与相关的一些讨论。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J3Ar4QAZLibnZdTFVia1WFeK29FTJ8Q2QYD8YNmveMJOIXKjYbdn3UbvuA/640?wx_fmt=png)

- 开发者：参与社区贡献需要签署”贡献者许可协议（CLA）“，要了解社区行为守则。
- SIG（项目组）：SIGs 是社区根据领域划分的各个领域的兴趣小组，每一个小组会根据情况维护社区一个或者多个项目。访问此处\[3]了解如何申请一个新 SIG。
- 邮件列表：邮件列表是社区交流的很重要的一种方式。
  
  - 你可以订阅邮件列表：建议您在订阅前把邮箱的‘答复邮件上的邮件头使用英语’的相关设置打开：1）打开邮箱的选项界面。2）点击【高级】——并找到【国际选项】——勾选‘答复或转发邮件上的邮件头和转发通知使用英语’。
  - 发送邮件到邮件列表：要将邮件发送到指定的邮件列表，请向上表中列出的邮件地址发送您的电子邮件。这样所有在这个邮件列表中的社区成员都能收到您的电子邮件。
  - 查看以前的邮件列表：要查看邮件列表中以前发布的电子邮件，请访问以下存档地址（Community\[4]、Dev\[5]、Announce\[6]、Council\[7]、Infra\[8]、Marketing\[9]、User-committee\[10]、Build-team\[11]、TC\[12]、Kernel\[13]、A-Tune\[14]、iSulad\[15]、QA\[16]、Sig-ai-bigdata\[17]、Crystal-ci\[18]、Virt\[19]）

通过社区我们可以做些什么：

在我们要做一些事情之前，先说一下 openEuler 本身是在什么地方的？openEuler 本身是放在 gitee.com 上的，并且是开源的，如果大家想要加入使用 openEuler 需要有一个 gitee 账号。

下面就是我们要在社区里做些事情了。

**1）提需求/bug：** 在使用/开发过程中遇到的一些问题，发现哪些地方使用不方便，大家都可以可以通过 issue 或者邮件列别提出问题。

最简单基本的参与社区的方式：当然是先点一点社区里的内容了，看看有哪些需要优化改进的地方，提出一些有价值有意义的建议。这也是最简单的方式了。

在社区中提交问题都是通过 issue 机制来进行的，在提交问题的过程中需要提交人指定提交的对象是谁，也就是你要提交问题给谁。

让我们看下 issue 的界面长什么样子？

举个栗子：如果你想提交一个社区治理的一个问题，那么你可以在 Community 代码仓库的 issue 中提交问题

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J3OPMqSibLjAO0z9x1aqFKKaw2sfeV7fItgZ7ibBlHCgDricTfXJnh1Kkuw/640?wx_fmt=png)

方框里的 issue 就是我们用来提交 bug/问题的入口，进入到 issue 里我们可以点击【新建 Issue】，进去之后就可以提交 issue 了。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J3kulsczrshMEhXSD2zbaSslwic75Zwssa9pdE9AAbURhXHfeUFT7NSGg/640?wx_fmt=png)

当然你可以设置提交的 issue 是什么级别的。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J3oO3URQIysNHso3GiaA3ljXAB5a5ZQaQFiaibVoKMcZ4lxeic1xkm7SosDA/640?wx_fmt=png)

我们在提交问题时怎么来接行 issue 的划分呢？

总的来说分为以下几类：

- 在社区中使用基础设施的过程中，感觉不爽，比如页面布局不够霸气，文字太小等等，可以提交问题到https://gitee.com/openeuler/infrastructure\[20]
- 如果遇到社区治理方面的问题，比如委员选举机制等问题可以提交到 https://gitee.com/openeuler/community\[21]
- 具体的软件问题，提交到 https://gitee.com/openeuler/kernel\[22]
- 其他问题，也就是你知道该提交什么地方的问题，可以提交到 https://gitee.com/openeuler/community-issue\[23]

如果你想要更详细的了解 issue 提交的流程，下面的链接可以帮助到你：https://gitee.com/openeuler/community/blob/master/zh/contributors/issue-submit.md\[24]

**2）修 bug 解决问题：** 这个就需要高层次的社区人员，以一个开发者的身份参与到社区中，在社区里可以自己主动认定一些 bug，来解决相关的问题。

在社区里，通常我们希望提出问题并同时解决问题，如果有一个问题，当然最好的情况是同时提供问题解决的 patch 补丁。我们以社区的轻量化容器引擎 iSulad 为例，https://gitee.com/openeuler/iSulad\[25]，假定我们需要为 iSulad 提交一个 patch 补丁，基本流程如下：

第一步：首先要先建立一个自己的分支

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J3k4TGmAh41lYElYGN8XsYiaBUUSkxanuA2hd36OkhL3CliaNB9T07vsicw/640?wx_fmt=png)

分支是通过 Fork 创建的，如果大家不了解 Fork，还是先去学习以下 git 吧，对于开发者来说，git 的开发模式是最常用的，也是最基本的，使用 git 是必须的。

第二步：修改代码并生成 Pull Request

点击 fork 完毕后，目录已经从 openEuler 切换成了自己的账户了，你自己的分支就创建好了。接下来就可以在自己的分支上进行代码的修改了。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J3chqUuxsNPsxybrQAiaNo8yxKnTTtBOHgicsxdlPnUQ3K38XerU2L9kSQ/640?wx_fmt=png)

修改完代码后，点击 Pull Request，就会生成一个 patch 提交代码到原始社区里了，到这里就完成了 patch 的提交了，接下来的时间就是等待 maintainer 审核你的代码了。

**3）贡献软件包：** 可以在 openEuler 代码仓库中的 openeuler 或者 src-openeuler 贡献自己的软件包，当然里面有很多软件包供开发者使用。这样日积月累，openEuler 就能够提供更多更丰富的软件包功能，越多人参与进来，openEuler 就能够成为万能的软件生态系统。

**4）开发新软件：** 大家根据自己爱好和想法，可以开发一些新的软件，贡献到 openeler 下面，经过一定时间的孵化可以进驻到 src-openeuler 里，供大家使用。

有两种方式可以将自己的作品发布到 openEuler 社区：

- 在其他社区开发，集成到 openEuler 中：假如我们常使用的 github、gitlab、gitee，在上面有一些我们的项目，我们可以通过将软件放到 src-openEuler 的 repo 仓就可以了。这样就可以把我们在其他管理平台里的软件集成到 openEuler 里。
- 在 openEuler 社区中开发，在 openEuler 中集成：我们可以直接在 openEuler 的代码仓库https://gitee.com/openeuler中创建项目，相当于将代码托管到openEuler社区。就像社区里的iSula和A-Tune就是这样的模式。

### 1.4 《社区参与之旅》

如果大家想更加详细的了解社区，可以通过两篇比较好的博客去进一步了解。可以介绍如何参与社区的博客地址如下：我的社区参与之旅\[26]openEuler 社区参与之旅\[27]

### 1.5 openEuler 代码仓库

openEuler 的愿景是：通过社区合作，打造创新平台，构建支持多处理器架构、统一和开放的操作系统 openEuler，推动软硬件生态繁荣发展。

openEuler 代码是放在 gitee 上的，大家可以尽情的去下载使用。

**openEuler 主要包括两个代码仓库：**

**src-openEuler 软件包仓库地址：**https://gitee.com/src-openeuler\[28]

src-openEuler 主要用于存放制作发布件所需的软件包。为 openEuler 的 release 发行版提供生成 rpm 包等构建信息等的地方。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J33eLice06YpqTHcbXFptedg49bhBySSf3JdMIlLYicQETbVJQkxfFqwTA/640?wx_fmt=png)

**openEuler 代码仓库地址：**https://gitee.com/openeuler\[29]

openEuler 主要用于存放源码类项目。openeuler 这个仓是存储所有“原生态”的软件，也就是为原创性的软件提供一个展示的舞台，或者是一个孵化器平台。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J3y9I0QQvdo3pG6ucARGxZKImdUA0RUBGLoNaXfrx5708Muv5taR14yA/640?wx_fmt=png)

## 2. openEuler 社区运作

### 2.1 社区治理：开放、透明

**openEuler 社区码云地址：** https://gitee.com/openeuler/community\[30]

代码仓 Community 保存了关于 openEuler 社区的所有信息，包括社区治理、社区活动、开发者贡献指南、沟通交流指南等内容。这里包括：openEuler 社区介绍、社区治理组织架构、社区活动、开发者贡献指南。

**社区治理组织结构**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J3LE8ZIfBPMt3Qo9BU0QZOcMThPWvQAxUE3IlMicTPxW7Ts7drgDAhZSg/640?wx_fmt=png)

我们主要介绍 秘书处、安全委员会、技术委员会、SIG。通过对各自的介绍，大家很明白的知道这些架构组织的作用了。

**秘书处：** 负责社区的筹备、运营规划等支撑社区规范化运作成熟。

现阶段，openEuler 社区秘书处的主要职责如下：

- 制定社区运营规划
- 制定费用预算，请获得社区创始人批准
- 执行社区创始人筹备社区的工作
- openEuler 社区其他未明确分配到责任人的工作

**安全委员会：** 负责接收和响应 openEuler 安全问题报告、提供社区安全指导。

现阶段，openEuler 社区安全委员会的工作职责如下：

- 协助漏洞修复：确保及时修复已知漏洞。通过为软件包 Maintainer 们提供补丁帮助，帮助用户系统在成为攻击受害者之前进行漏洞修复，包括提供相关漏洞检测和修复工具。
- 响应安全问题：响应上报的安全问题，跟踪安全问题的处理进展，并遵循安全问题披露策略对安全问题在社区内进行披露和公告。
- 安全编码规则：普及安全编码知识是安全团队的目标。安全团队会努力创建文档或开发工具来帮助开发团队避免软件开发过程中的常见陷阱。安全团队还会尝试回答在开发和使用过程中遇到的任何问题。
- 参与代码审核：安全团队希望能够通过代码审核帮助团队提前发现代码中的漏洞。

**技术委员会：** 负责社区技术决策和技术资源的协调。

技术委员会的主要职责如下：

- 负责回答理事会提出的技术问题，支撑理事会对战略蓝图的技术发展方向做出判断；
- 以远程协作的方式运行，每半年召开一次面对面沟通的正式会议，正式会议间定期召开例行线上公开会议；
- 对社区技术路线、接口定义、架构设计、构建发布等进行指导，并逐步构建社区规则；
- 协调跨项目合作，对社区跨项目技术问题进行指导，并逐步构建社区规则；
- 制定、指导项目孵化、开发、退出流程，支撑社区技术生态健康发展；
- 制定、指导软件包接纳、退出 openEuler 的流程，支撑 openEuler 开源版本的可信和可靠；
- 接受用户委员会的反馈（需求和问题），牵引社区资源将其落地至项目；
- 建立社区认证标准和平台，为社区认证（OS 商业发行版认证、硬件兼容性认证等）提供技术支撑；

**SIG：** 社区兴趣小组，每个小组维护一个或多个项目（对应多个 gitee 仓）

### 2.2 参与社区治理和运作

在您遇到任何问题、想参与各委员会/各 SIG 的运作、找到感兴趣的 SIG 都可以通过一下方式进行了解和提问。

**如果您对社区治理有任何问题或建议，可以**发邮件到 maillist：community@openeuler.org

提 issue：https://gitee.com/openeuler/community

**如果您想参与各委员会、各 SIG 的运作，可以通过邮件列表交流及获取信息**邮件列表：https://openeuler.org/zh/community/mails.html

SIGs：https://openeuler.org/zh/sig.html

**如果您没找到感兴趣或者合适的 SIG，可以申请创建 1 个新 SIG**https://gitee.com/openeuler/community/tree/master/zh/technical-committee/governance

**如果您对社区版本发布有任何建议或者需求、想法，可以**发邮件到 maillist：dev@openeuler.org

标题行首带上\[release management] 提 issue：https://gitee.com/openeuler/release-management

## 3. openEuler 版本介绍

### 3.1 Linux Kernel 等上游社区

openEuler 跟其他大家比较熟悉的操作系统是一样的，主要是从上游社区来取相关的软件进行一些增强开发、集成和质量保障，然后构建出来的一个社区免费版本。基于上游社区开源软件构建的免费、开源的 Linux 社区发行版，与国内主流 OS 厂商共建共享，形成合力繁荣国内 Linux 操作系统生态

下图是 openEuler 与 Linux 发行版的对比，大家可以了解一下。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J37PWBN9uMzr1JvXHL5DJtiatRYLoGnIWXGE4If7icm3fLhg38hEy9ZgNg/640?wx_fmt=png)

- openEuler 与 SUSE、Debian、 RedHat 一样基于上游社区开源软件 构建
- openEuler 社区发行 LTS 免费版本， 使能 OSV 发展商业发行版，如麒麟软件、普华、中科软、万里开源等
- openEuler 当前基于内核 4.19 版本

### 3.2 openEuler 基于上游开源软件构建，回馈上游开源社区

openEuler 大部分软件来自于上游开源社区，基于上游开源社区我们也做了大量的贡献来回馈上游开源社区。（比如：在 Linux Kernel 社区里，华为的贡献排到了 Top5；在 GCC 社区里华为有 Maintainer 在社区里进行贡献，等等。）推送到上游社区比较困难的代码，经过 openEuler maintainer 的评审，如果确实有价值，也可以将代码先合入到openEuler社区里。但还是鼓励尽可能推送到上游社区，坚持upstream first的原则。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J3aaBiaQlexZMHTdD7ngJVZb3YMerR8fApcCPpXJCVS3iaMKFdXNRmwWyg/640?wx_fmt=png)

### 3.3 openEuler 版本路标规划

openEuler 社区版本命名，发布时间与生命周期管理\[31]

**LTS 版本**：2 年发布 1 个，维护 4 年，OSV 厂商可以基于 LTS 版本构建商用发行版；下一个 LTS 版本 22.03

**创新版本**：6 个月发布 1 个，维护 6 个月

- 社区版本按按照交付年份和月份进行版本号命名。例如，openEuler 20.09 于 2020 年 09 月发布
- 社区版本分为长期支持版本和创新版本。
- 长期支持版本：发布间隔周期定为 2 年，提供 4 年社区支持。社区首个 LTS 版本 openEuler 20.03 已于 20 年 3 月正式发布。
- 社区创新版本：LTS 版本之间每隔 6 个月 openEuler 会发布一个社区创新版本，提供 6 个月社区支持。
- 欢迎社区开发者和用户提出宝贵建议，以上规则将根据反馈意见以及社区实施情况不断完善。

### 3.4 openEuler 20.03LTS 版本基本信息

20.03LTS 版本基本信息表\[32]

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J3XOF8ic2d36sL6ibQK8u9amJ3ibFLXOgQTgjZb6NEfoyLhLPYvKic9S9qtA/640?wx_fmt=png)

LTS 版本架构环境支持 ARM 和 X86 版本。如果对 ARM 感兴趣的人员可以通过 openEuler 的【首页】—【鹏城实验室】可以去申请 ARM 的虚拟机资源进行体验。详细的版本信息可查看下表。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J3SN6814rw2piaV8nk56Xz6A9Ssl3cQHGJkgWU3y0W0RtA137rNN3KKOA/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J38aZZiaiaH62Hc3Y7icVqTOdJq7SWk3H0Dy7mZ3IuraeLUJl1kHkIkHKrg/640?wx_fmt=png)

### 3.5 openEuler 软件全堆栈的技术优化，充分释放多样化计算平台算力

openEuler 关键特性文档说明\[33]

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J3tV70DqmOibXNn6qjpIWpGIpw3VEaykuJZL5qpzPMz3EJeYR1Lq0D9XQ/640?wx_fmt=png)

1. 多核调度技术
   
   关键路径 Fs pagecache 免锁重构，极致发挥算力，Nginx HTTP 性能提升 15%
2. 集成 KAE 插件
   
   软硬协同，助力鲲鹏加速库实现 10%-100%性能提升
3. iSula 轻量级容器
   
   具备轻、快、易、灵特点启动时间缩短 35%，内存资源消耗降低 68%，通过 Smart-loading 智能镜像下载技术，显著提升镜像下载速度
4. openEuler Community build of OpenJDK
   
   通过 GC 优化，冗余 DMB 指令消除等技术提升性能 20%
5. A-Tune 场景自优化
   
   典型场景智能自优化，推理出业务特征，配置最佳的系统参数合，使业务处于最优运行状态，提升系统调优效率 30%

## 4. To Do More

通过社区合作，打造创新平台，构建支持多处理器架构、统一和开放的操作系统 openEuler，推动软硬件生态繁荣发展。后面会有更多有意义有挑战性的一些特性在后续的开发维护中会陆陆续续的发布出来，大家尽请关注。

社区地址：https://gitee.com/openeuler\[34]

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J38vufnRP7OP0oOXKXR2XancCBOgyMv9LR3s7pgQmrLGDxk945dpeWGA/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbqRbk1LexicwdrOmDhaA1J3xxcrrkcYo5DkYGuC5Oo96vJjSCkAXYV1Khxr2DPiboT7F4IbGV7uvCg/640?wx_fmt=png)

### 参考资料

\[1]

openEuler.org: *https://openeuler.org/*

\[2]

https://openeuler.org/zh/download.html: *https://openeuler.org/zh/download.html*

\[3]

此处: *https://gitee.com/openeuler/community/blob/master/zh/technical-committee/governance/README.md*

\[4]

**Community**: *https://mailweb.openeuler.org/hyperkitty/list/community@openeuler.org*

\[5]

**Dev**: *https://mailweb.openeuler.org/hyperkitty/list/dev@openeuler.org*

\[6]

**Announce**: *https://mailweb.openeuler.org/hyperkitty/list/announce@openeuler.org*

\[7]

**Council**: *https://mailweb.openeuler.org/hyperkitty/list/council@openeuler.org*

\[8]

**Infra**: *https://mailweb.openeuler.org/hyperkitty/list/infra@openeuler.org*

\[9]

**Marketing**: *https://mailweb.openeuler.org/hyperkitty/list/marketing@openeuler.org*

\[10]

**User-committee**: *https://mailweb.openeuler.org/hyperkitty/list/user-committee@openeuler.org*

\[11]

**Build-team**: *https://mailweb.openeuler.org/hyperkitty/list/buildteam@openeuler.org*

\[12]

**TC**: *https://mailweb.openeuler.org/hyperkitty/list/tc@openeuler.org*

\[13]

**Kernel**: *https://mailweb.openeuler.org/hyperkitty/list/kernel@openeuler.org*

\[14]

**A-Tune**: *https://mailweb.openeuler.org/hyperkitty/list/a-tune@openeuler.org*

\[15]

**iSulad**: *https://mailweb.openeuler.org/hyperkitty/list/isulad@openeuler.org*

\[16]

**QA**: *https://mailweb.openeuler.org/hyperkitty/list/qa@openeuler.org*

\[17]

**Sig-ai-bigdata**: *https://mailweb.openeuler.org/hyperkitty/list/sig-ai-bigdata@openeuler.org*

\[18]

**Crystal-ci**: *https://mailweb.openeuler.org/hyperkitty/list/crystal-ci@openeuler.org*

\[19]

**Virt**: *https://mailweb.openeuler.org/hyperkitty/list/virt@openeuler.org*

\[20]

https://gitee.com/openeuler/infrastructure: *https://gitee.com/openeuler/infrastructure*

\[21]

https://gitee.com/openeuler/community: *https://gitee.com/openeuler/community*

\[22]

https://gitee.com/openeuler/kernel: *https://gitee.com/openeuler/kernel*

\[23]

https://gitee.com/openeuler/community-issue: *https://gitee.com/openeuler/community-issue*

\[24]

https://gitee.com/openeuler/community/blob/master/zh/contributors/issue-submit.md: *https://gitee.com/openeuler/community/blob/master/zh/contributors/issue-submit.md*

\[25]

https://gitee.com/openeuler/iSulad: *https://gitee.com/openeuler/iSulad*

\[26]

我的社区参与之旅: *https://openeuler.org/zh/blog/2020/06/10/2020-06-10-my-traval-of-openeuler.html*

\[27]

openEuler 社区参与之旅: *https://openeuler.org/zh/blog/2020/05/13/2020-5-13-openEuler-Travel.html*

\[28]

https://gitee.com/src-openeuler: *https://gitee.com/src-openeuler*

\[29]

https://gitee.com/openeuler: *https://gitee.com/openeuler*

\[30]

https://gitee.com/openeuler/community: *https://gitee.com/openeuler/community*

\[31]

openEuler 社区版本命名，发布时间与生命周期管理: *https://gitee.com/openeuler/release-management/blob/master/lifecycle.md*

\[32]

20.03LTS 版本基本信息表: *https://openeuler.org/zh/docs/20.03\_LTS/docs/Releasenotes/release\_notes.html*

\[33]

openEuler 关键特性文档说明: *https://openeuler.org/zh/docs/20.03\_LTS/docs/Releasenotes/%E5%85%B3%E9%94%AE%E7%89%B9%E6%80%A7.html*

\[34]

https://gitee.com/openeuler: *https://gitee.com/openeuler*

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYrPvaHfrVobhVnuEZU9h6ibOspOSKHic8Nh8icmf9xozgIK5j5ibJibMLzCLhbSoicDQOrVDQpZKX2nkBA/640?wx_fmt=png)

***观众老爷们不考虑点一波关注***

***支持一下这个快要秃顶的主编吗？***

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbR3YNaNBytF0uqAicKL7fRD0JJj1HibCo2Sic0qxQ1LkZPlLqibMPxWUBBGeOOicicX3yY8e2icz81TU7Fg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYCjA16Qbj8RtLq6ZdzGlsR9Llaa49Bia9A8SlgicOgPZoDYZB2pxuLtp7FkmXvaIoZHRBUkAB6hA7w/640?wx_fmt=png)
