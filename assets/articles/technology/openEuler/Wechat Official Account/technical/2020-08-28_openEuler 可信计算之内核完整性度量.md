# [openEuler 可信计算之内核完整性度量](https://mp.weixin.qq.com/s/jyPaZjVAg4SpE8qggBB3TQ)

原创*天行*[OpenAtom openEuler](javascript:void%280%29;)*2020-08-28 23:00:34*

本文将带你走进 openEuler 可信计算技术中的内核完整性度量（IMA）。读完文章后，你将对可信计算技术建立初步认识，了解原生社区与 openEuler 中的内核完整性度量技术，并且掌握 openEuler 中内核完整性度量的部署过程。

## 1. 可信计算的前世今生

### 1.1 什么是可信计算

我们先看几个定义，通过这几个定义来建立对可信计算的初步认识。

**什么是可信？**

国际上的不同组织对可信做了不同的定义。

1）可信计算组织（TCG）的定义：

一个实体是可信的，它的行为总是以一个预期的方式达到预期的目标。

2）国际标准化组织与国际电子技术委员会定义（1999）：

参与计算的组件、操作或过程在任意的条件下是可预测的，并能够抵御病毒和一定程度的物理干扰。

3）IEEE Computer Society Technical Committee on Dependable Computing 定义：

所谓可信，是指计算机系统所提供的服务是可被论证其是可信赖的，可信赖主要是指系统的可靠性和可用性。

4）我国学者认为：

可信计算系统是能够提供系统的可靠性、可用性、信息和行为安全性的计算机系统。可信包括：正确性、可靠性、安全行、可用性、效率等。系统的安全性和可靠性是现阶段可信最主要的两个方面，因此也可简称为 “ 可信 = 可靠 + 安全 ”。

简单的说，可信就是指系统按照设计和策略运行，按要求运行，不做其他事情。

**什么是可信计算**

广义上来说，可信计算指系统行为总是符合预期，并且有硬件和软件提供保障。也就是计算机将始终以预期的方式运行，并且这些行为将由计算机硬件和软件强制执行。

狭义上来说，TCG 这样定义可信计算：基于可信平台模块（TPM），保护系统行为和完整性。TCG 创建了 TPM 的加密功能，该功能可强制执行特定行为并保护系统免受未经授权的更改和攻击，如恶意软件和 root kits。

### 1.2 可信计算基本原理

早期可信计算的研究主要以 TCG（国际可信计算工作组）组织为主，国内开展可信计算研究的思路基本也是跟着 TCG 的步伐。可信计算最核心的就是 TPM 硬件芯片，其 TPM 1.2 规范是比较经典的，大多数厂家的芯片都以 TPM 1.2 为标准。该规范已经升级到 TPM 2.0，也称为“Trusted Platform Module Library Specification”，而且遵循该规范的新芯片也已经面世。

所谓的 **TPM 就是可信平台模块**，它有以下三个特点：

- TPM 是可信计算平台的信任根（TCB），是可信计算的核心模块。
- 通过将密钥和加解密引擎集成到 TPM 芯片中，为实现系统安全功能提供了安全的可信基点。
- PCR 存储方式是扩展递加存储，具有单向性，即根据 PCR 中的值反推消息和之前的任何信息是不可能的。

在现有的 TPM 芯片基础上，我们可以逐级构造信任链。下图就很好的展示出来了信任链的整个流程：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu2SoTEW86rG6pgSWZL9S2e3iaS4HztS3FEGFks06rwnTeUmvibnZHNmaQA/640?wx_fmt=png)

最底层就是从系统的可信任根（TPM）向上去扩展，有 CRTM，BIOS，再向上有 Bootloader，是导入内核的软件，再到 OS 层，最上面就是应用层。

**信任链与可信计算的实现**过程必须的三个步骤：

1. **建立信任链：** 从信任根开始到硬件平台、操作系统，再到应用， 一级信任一级，把信任扩展到整个计算机系统。
2. **标识身份：** 模块内置 EK 身份证书，通过权威认证平台签发，证明芯片和系统的身份。
3. **保护密钥：** 模块内置 SRK 存储根密钥，不能被外部访问，从而建立起一棵密钥保护树。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu21CjgOCtKxXKPfMibTDMuv4RGNWDuxluBPHYxwDt1Y1hnNWqic1rTZtWA/640?wx_fmt=png)

### 1.3 可信计算技术族

下面我们了解一下当前整个可信计算到底有多少相关技术。从下面这张图我们可以分成三部分来看：

- 左边的是开源社区和学术界引入进来的可信计算技术，大家可能比较熟悉的有 SELinux、AppArmor；
- 中间的是由 TCG 组织引入进来的技术，包括 IMA、DIM、安全启动、RoT 等技术。
- 右边的是由工业界引入进来的技术，这里的工业界主要是指 Intel、IBM 等，包括 SGX、Trustzone 等技术。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu2f5MZ6UdxhmMSM91pXNDRd28ITDMoOZ3gFEkdMHQrNHojXCtkw5taHw/640?wx_fmt=png)

## 2. 走进内核完整性度量

### 2.1 内核完整性度量（IMA）

**IMA (Integrity Measurement Architecture)**

IBM 研究院于 2004 年提出了完整性度量架构（IMA），目的是基于 TPM 芯片进行系统完整性度量。IMA 技术主要包括以下三大块内容：

- IMA-measurement（IMA 度量）：通过在内核中增加 IMA 模块，当应用程序/动态库/内核模块被加载时，度量文件和关键数据并扩展到 PCR10。
- IMA-appraisal（IMA 评估）：对 IMA 基础功能的扩展，将被评估文件内容的度量基准值存储在安全扩展属性 security.ima 中，在打开文件时将度量值与扩展属性中的基准值进行对比，如果不匹配，则拒绝加载该文件。
- IMA-audit：提供审计功能的日志模块。

> 疑问：现在是把度量基准值存储在扩展属性 security.ima 当中，如果 security.ima 被篡改了，它和文件内容一起篡改的话，不就实现了对文件本身的篡改并且不被系统发现，为了解决这个问题，我们引入了 EVM 模块来防止这种事情的发生。

**EVM (Extended Verification Module)**

EVM 是扩展验证模块，它的作用就是将系统当中某个文件的安全扩展属性，包括 security.ima 、security.selinux 等合起来计算一个哈希值，然后使用 TPM 中存的密钥对其进行对称签名，签名之后的值存在 security.evm 中，这个签名后的值是不能被篡改的，如果被篡改，再次访问的时候就会验签失败。

总而言之，EVM 的作用就是通过对安全扩展属性计算 HMAC 值并将其存储在 security.evm 中，提供对安装扩展属性的离线保护。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu2V9Ck0uXvZCRYg1SolSQCrKm4iaGjbtGPZXgXNCc4t75NDkAibujGjeew/640?wx_fmt=png)

### 2.2 IMA 摘要列表扩展：openEuler 的思考

根据以上所说的内容，我们能够知道，原生 IMA 会在系统初次部署的时候进入一个 fix 模式，在该模式下对系统中的所有文件去计算一个参考值，然后进入到 enforce 模式中，用初次部署时计算出来的基准值和系统当前的文件摘要值进行对比，如果两者不符合，就拒绝对文件的访问。

但这种方式存在一个问题，它的信任链并不完整，因为在启动系统之后，要通过人为对系统重新设定基准值，在设定基准值之前，这个文件是有可能被篡改的，为避免这个问题，我们会在构建一个系统软件包的时候就确定里面所有受保护文件的参考值。

那么在 openEuler 社区中是如何改良系统内核社区原生的 IMA 机制的呢？有以下三个方式：

**Feature 1：构建时发布的参考值**

为解决原生内核 IMA 初次部署操作复杂且信任链不完整的问题，openEuler 内核将参考值的生成统一放到构建阶段。

“摘要列表”（digest lists）是一种特殊格式的二进制数据文件，它与 rpm 包一一对应，在构建过程中自动生成并打包到 rpm 包中（在 `/etc/ima/digest_lists` 目录下），记录了 rpm 包中受保护文件（即可执行文件和动态库文件）的哈希值列表。

构建环境下，摘要列表文件会被私钥签名，以保护其完整性。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu28Ky6HNYmRPzXoFlpaWUzkcNAPicB7Cb0ezG9MkUNib3fIypJGYQ5nX4Q/640?wx_fmt=png)

**Feature 2：启动阶段验签导入所有参考值，并支持开箱即用**

在 initramfs 阶段就完成所有摘要列表的导入，确保 systemd 起的每个进程都经过 IMA 校验 。

摘要列表在导入时需由内核中的公钥进行签名校验。

如果 ISO 中的内核启动参数默认配置打开了 IMA 开关，那么完成安装时所有摘要列表已被导入，无需重启。

enforce 模式下，访问文件时发生了什么？

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu26ze2g1qHlGcFGtwEUB1HjKVHUVqTtCx1ZQaBCalgwyWSBb69erHXgg/640?wx_fmt=png)

**Feature 3：随时随地更新参考值**

进入运行阶段后，您可以随时在内核空间中更新 IMA 度量和评估所需的参考值，而无需像原生 IMA 那样重启后进入 fix 模式。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu2EQgQsTpNCzTJ3YfnlSiabVOv204B9Gx743KCPdAluDIHlNk3cf6Samw/640?wx_fmt=png)

**方法一（手动更新）**：使用 echo 命令将摘要列表文件的绝对路径写到 securityfs 提供的接口中。

- 导入列表：`echo [/path/to/digest_list] > /sys/kernel/security/ima/digest_list_data`
- 删除列表：`echo [/path/to/digest_list] > /sys/kernel/security/ima/digest_list_data_del`

这种方法的优点在于灵活自由，只要摘要列表事先经过签名（签名存放在 security.ima 属性中），就能完成内核中参考值的更新。

**方法二（自动更新）**：安装、卸载、升级 rpm 包的过程中摘要列表的自动更新

更新操作由插件自动完成（原理与手动操作类似），优点是不需要手动操作，简单便捷。

**总结：原生内核 IMA 特性 vs openEuler 内核 IMA 特性**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu2Ta32FwqHut1PDt9KHiaL9FEFpZcYNHmzPZwl2K235rPJicYvqI26jkrg/640?wx_fmt=png)

> 注：以上性能数据均为实验室环境下测试所得，实际环境下可能存在一定偏差。

## 3. 在 openEuler 上部署 IMA

### 3.1 配置环境前的准备工作

**Step 1：从官方镜像源下载安装 openEuler-20.09 ISO**

**openEuler 官方镜像站：** https://mirrors.huaweicloud.com/openeuler/

镜像还在准备过程中，预计在 9 月底的正式版本中与大家见面！

对于安装环境而言，虚拟机和物理机都可行，且 TPM 芯片不是必需的，具体步骤请参考第三期直播“安装 openEuler”：https://www.bilibili.com/video/BV1vK4y1s7QG。

**Step 2：配置 IMA 前的环境准备**

1. 使用 openEuler 官方镜像源配置 yum 仓库。
2. 确认工具包 digest-list-tools 和 ima-evm-utils 是否已安装：
   
   ```
   $ rpm -qa | grep digest-list-tools$ rpm -qa | grep ima-evm-utils
   ```
   
   如果没有安装，使用 yum 安装：
   
   ```
   $ yum install -y digest-list-tools ima-evm-utils
   ```
3. 检查系统的 initramfs 公钥是否正确：
   
   ```
   $ evmctl ima_verify /etc/keys/x509_evm.der
   ```
4. 编辑 `/etc/dracut.conf` 文件，加入一行：
   
   ```
   install_items+=" /etc/keys/x509_ima.der /etc/keys/x509_evm.der"
   ```

### 3.2 配置环境进入 IMA enforce 模式

**Step 3：为受保护文件标记 security.ima 和 security.evm 扩展属性**

```
$ upload_digest_lists -p add-ima-xattr -d /etc/ima/digest_lists.tlv$ upload_digest_lists -p add-evm-xattr -d /etc/ima/digest_lists.tlv
```

**Step 4：为摘要列表文件标记 security.ima 和 security.evm 扩展属性**

```
$ upload_digest_lists -p repair-meta-digest-lists$ find /etc/ima/digest_lists -type f -exec evmctl verify -o -a sha256 \{} \; # 检查摘要列表扩展属性是否已正确标记
```

**Step 5：重新生成 initramfs**

```
$ dracut -f -e xattr
```

**Step 6：设置启动参数并重启**

在 `grub.cfg` 文件中添加启动参数：

```
ima_appraise=enforce-evm evm=ignore ima_appraise_digest_list=digest ima_digest_list_pcr=+11 ima_template=ima-sig ima_policy="tcb_exec|secure_boot_exec|secure_boot_immutable" initramtmpfs integrity=1
```

重启系统：

```
$ reboot
```

### 3.3 实际环境演示：x86\_64

**场景一：攻防场景**

修改文件内容，查看文件是否能够继续执行？如果修改文件扩展属性呢？

执行一条未知的命令，是否可以成功？

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu2wRwJxOe8T3Oc12JtPC7VeTP8FJ9v3FsuKTecDIlQQlOu4TL9B3NaFQ/640?wx_fmt=png)

摘要列表会保护文件的哪些内容？答：uid、gid、权限、security.selinux、security.ima、security.evm、security.capability

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu2UBetvEQaZYJIGdVb4q9DfseNeYEibe1dcAn4d2jZ8fia5EfIKVk4JnuQ/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu2dHRq9cluNz8stp24zpWkl5fCuh2SGCiaxibibUl0DRSrgh5w62VnbfpmQ/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu2wtRJQPDrdpSZHav44FK9CZKGhdRRIS8WarYk337ctweibDQtrHKbZ7g/640?wx_fmt=png)

**场景二：升级场景**

安装、卸载软件包过程中 digests\_count 数量的变化。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu2Pefqg1Ndmj6urSGrwVxXWRvicvQZyUHYaHKN4IJplGia4d90ib5BiclO3g/640?wx_fmt=png)

尝试通过 securityfs 接口手动更新内核哈希表，更新后命令是否能够正确执行？

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu2ibia8cRl02ribZqnMV3hODQ4mcs5XgpIyabXtWjt3Bc2LGPlziaVDeWjicA/640?wx_fmt=png)

## 4. one more thing...

### 4.1 展望未来

了解了 IMA 在 openEuler 的现状，对于未来我们还有哪些可以期待呢？这里有一些我们对 IMA 新特性的规划：

**Topic A：如何将度量范围从可执行文件延伸到非可执行文件？**

- 从主体（可执行文件/动态库文件）的可信，扩展到被它读取的客体（配置文件/数据文件）的可信。
- 引入新的 IMA 策略关键字 check\_evm 和 don\_check\_evm。
- 根据业务场景，为需要保护客体完整性的主体设置特殊的 SELinux 标签，被此类主体访问的客体都会触发 IMA 度量。
- 需要在运行环境下手动调整的配置文件，不会触发 IMA 度量，而是通过信任链的其它环节保护。

**Topic B：如何导入第三方应用的摘要列表？**

在内核中加入新公钥，重新编译内核，从而支持导入第三方软件摘要列表。使第三方应用在系统中运行的步骤：

1. 使用 digest-list-tools 和 ima-evm-utils 为第三方应用 rpm 包或 tar 包生成摘要列表。
2. 在可信的构建环境中用第三方公钥对应的私钥对摘要列表签名。
3. 安装部署过程对摘要列表验签。

当然，如果您对于 IMA 有更多的建议和诉求，我们也非常欢迎您在 openEuler 社区中和我们交流，甚至参与到贡献中来。

### 4.2 如何贡献

**openEuler 内核邮件列表：kernel@openeuler.org**

如果您想要参与到内核中 IMA 特性的开发，欢迎发送补丁到 openEuler 内核邮件列表，具体操作可以参考第 9 期直播“如何参与 openEuler 内核开发”：https://www.bilibili.com/video/BV11i4y1u7r9。

**openEuler 自维护源码仓**

- https://gitee.com/openeuler/kernel
- https://gitee.com/openeuler/digest-list-tools
- https://gitee.com/openeuler/attest-tools

提 issue 或者 PR，甚至申请加入 security facility SIG 成为 maintainer，你说了算！

**openEuler 第三方软件仓**

- https://gitee.com/src-openeuler/tss2
- https://gitee.com/src-openeuler/ima-evm-utils "https://gitee.com/src-openeuler/ima-evm-utils

心动不如行动，加入 openEuler 大家庭，现在就加入 openEuler 的大家庭吧！

### 4.3 更多学习资料

openEuler 官方博客\[1]

项目仓库\[2]

**开源社区资源**

内核完整性度量（IMA）官方 wiki\[3]

可信软件栈（TSS）\[4]

IBM Software TPM\[5]

**学术资源**

推荐阅读 CMU 学者的综述论文 “Bootstrapping Trust in Commodity Computers”，发表在信息安全顶会 IEEE S&P 2010，对可信计算理解比较到位。

中文书籍方面，推荐冯登国教授的“可信计算理论与实践”，这本书对可信计算的历史、现状和技术有比较全面和深入的探讨。

## 5. 欢迎关注

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu2L1qasNQhJcCMOApO9vxaibqhoIHl6FOD0qy7vlv8pebh6FMcq0IBtFA/640?wx_fmt=png)

openEuler 已全面开源， 欢迎关注、使用 openEuler 并参与社区贡献。

**新浪微博：** openEuler 社区

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbf34A7jWxc2FxGvsLribJu2Hbbicr6YLklb60YqPFMRvJEhU56Ckw9vbUs2DLof2BnHNeqdnWpgCOQ/640?wx_fmt=png)

### 参考资料

\[1]

openEuler 官方博客: *https://openeuler.org/zh/blog.html*

\[2]

项目仓库: *https://gitee.com/digest-list-tools*

\[3]

内核完整性度量（IMA）官方 wiki: *http://sourceforge.net/p/linux-ima/wiki/Home*

\[4]

可信软件栈（TSS）: *https://github.com/tpm2-software/tpm2-tss*

\[5]

IBM Software TPM: *http://ibmswtpm.sourceforge.net/*
