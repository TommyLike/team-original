# [openEuler 社区签名体系建立](https://mp.weixin.qq.com/s/C8cGzwwyF9Yww8TuhxVgog)

[OpenAtom openEuler](javascript:void%280%29;)*2024-07-13 10:00:00广东*

近年来，网络安全形势日益严峻，各种攻击手段层出不穷。软件的构建、发布、安装、运行等环节都面临着安全威胁。对以开源软件为主的 openEuler 操作系统来说，软件组件的完整性保护至关重要。通过在社区建立以 PKI （Public Key Infrastructure，公钥基础设施）为基础的软件发布签名体系，结合从系统启动到运行的端到端完整性保护技术，可以有效防护各个环节的攻击，从而提升系统安全性。

安全启动（Secure Boot）是利用公私钥对启动部件进行签名和验证。在启动过程中，前一个部件验证后一个部件的数字签名，如果能验证通过，则运行后一个部件；如果验证不通过，则停止启动。通过安全启动可以保证系统启动过程中各个部件的完整性，防止没有经过认证的部件被加载运行，从而防止对系统及用户数据产生安全威胁。

openEuler 在支持安全启动的基础上，还通过支持内核模块签名、IMA 文件完整性保护等机制，将基于数字签名的保护链路进一步延伸至内核模块和应用程序文件（广义安全启动），整个验证过程可包含如下四个部分：

- 启动阶段：BIOS-&gt;shim-&gt;grub-&gt;内核（EFI 加载前进行签名校验）；
- 运行阶段（模块加载）：内核-&gt;内核模块（模块插入时进行签名校验）；
- 运行阶段（文件访问）：内核-&gt;文件（应用程序执行或普通文件访问时进行签名校验）；
- 运行阶段（软件包安装）：包管理组件-&gt;RPM 软件包（软件包安装时进行签名校验）。

为支持“开箱即用”的安全启动能力，核心是在 openEuler 社区建立以 PKI 为基础的软件构建签名体系。在软件构建阶段，自动为目标文件添加数字签名，并在关键组件中预置公钥证书，从而在用户安装 openEuler 镜像后，可以直接开启相关的签名校验机制，提升系统安全性。

**整体方案介绍**

自 openEuler 24.03 LTS 版本开始，openEuler 采用统一的签名平台进行签名证书和密钥的管理以及签名生成，并对接 EulerMaker 构建平台，实现交付件的自动签名：

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBndxTrG92HmyzlW8HrmGkh3pAT2XWPhCIu6FA57jChRwhVxZKOhV5GJfJ0Iq3QaMHHjXaB5aJh9w/640?wx_fmt=png&from=appmsg)

1. openEuler 签名平台生成并管理签名公私钥和证书，同时通过 Signatrust 提供签名服务；
2. EulerMaker 构建系统在执行软件包构建阶段，通过spec脚本调用 Signatrust 签名接口为目标文件执行添加数字签名；
3. 具备签名验证功能的组件（如 shim、kernel 等），在构建阶段预置相应的验签证书；
4. 用户安装 openEuler 镜像后，开启安全启动、内核模块校验、IMA、RPM 校验等按机制，在系统启动和运行阶段使能相应的签名验证功能，保障系统组件的真实性和完整性。

**证书及签名介绍**

openEuler 24.03 LTS 证书包含 x509 和 openPGP 两种体系，其中 x509 体系采用三级证书的形式进行管理（根证书、中间证书、签名证书）： 

![](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mBndxTrG92HmyzlW8HrmGkhicsopWl2vL0TFGZ8wnE2afiaHZfzyho9ziagiatqicUlrGVuT2sAxPuePLw/640?wx_fmt=png&from=appmsg)

各证书作用分别如下：

证书类型说明openEuler CA证书x509一级证书openEuler社区根证书，用于签发及校验二级证书安全启动ICA证书x509二级证书安全启动二级证书，用于签发及校验安全启动签名证书内核ICA证书x509二级证书预置在openEuler内核中的根证书，用于签发及校验内核签名证书IMA摘要列表EE证书x509三级证书对RPM包中提供的IMA摘要列表文件进行签名和校验内核模块EE证书x509三级证书对kernel中的内核模块文件进行签名和校验openEuler RPM证书openPGP证书对openEuler发布的RPM软件包进行签名和校验

注意：

- EFI文件（shim/grub/kernel 等）的签名信息包含二、三级证书，可以使用 openEuler CA证书进行签名验证；
- IMA 摘要列表和内核模块的签名信息包含三级证书，可以使用内核 ICA 证书进行签名验证。

openEuler 24.03 LTS 版本已默认集成如下签名：

文件类型文件格式签名格式EFI文件EFI Imageauthenticode内核模块文件Kernel ModuleCMSIMA摘要列表文件BinaryCMSRPM软件包文件RPM PackageopenPGP

用户可开启对应的安全机制，如安全启动、内核模块校验、IMA 等，开启后可使能签名校验功能。

**三方安全启动签名**

openEuler 社区与 CFCA（中国金融认证中心）进行合作，在 openEuler 24.03 LTS 版本中提供基于 CFCA 签名的 shim 组件，在预置 CFCA 安全启动证书的服务器可实现安全启动。

**加入我们**

sig-security\_facility 主要讨论在 openEuler 社区版本中已有或未来规划的安全技术：

- 在openEuler 社区版本中使能主流的 Linux 安全特性，提供系统安全工具、库、基础设施等，提升系统的安全性。
- 改善现有安全技术的应用体验，帮助安全创造实际的价值。

如果您对相关技术感兴趣，欢迎您的参与和加入。您可以添加小助手微信，加入安全技术交流群。

![](https://mmbiz.qpic.cn/mmbiz_jpg/jqTxnpIZ2mAk7XGjrHQX48E1tGVyJGQcgaTxicyGy9UAaYQYrL3ADZeFvrsbKPgXGSSwxkrfJsQdiccRkoQyFGDw/640?wx_fmt=other&from=appmsg&wxfrom=5&wx_lazy=1&wx_co=1)

**参考资料**

\[1] signatrust签名服务开源项目：https://gitee.com/openeuler/signatrust

\[2] openEuler 社区证书中心：https://www.openeuler.org/zh/security/certificate-center/

\[3] openEuler 签名资料：https://gitee.com/openeuler/docs/tree/master/docs/zh/docs/CertSignature
