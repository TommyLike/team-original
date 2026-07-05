# [【安全公告】Linux Kernel 本地权限提升漏洞（CV](https://mp.weixin.qq.com/s/qCwPRljyFoiBpdVB3pMScg)

[OpenAtom openEuler](javascript:void%280%29;)*2026-05-03 21:00:00广东*

![](https://mmbiz.qpic.cn/mmbiz_gif/jqTxnpIZ2mB2DfYCS4Rfib7aEzrKoYo4a47pmwYKrTftvGXyFfspek4hoUibdJtrBB96517RL4k2AXD1gSav958g/640?wx_fmt=gif&from=appmsg)

**漏洞概述**

近日，Linux 内核披露本地提权漏洞 CVE-2026-31431（Copy Fail），该漏洞源于内核加密子系统中的一处逻辑缺陷，攻击者可以利用 AF\_ALG 加密接口与 splice() 系统调用的组合，向任意可读文件的页缓存写入受控的4字节数据，从而篡改 setuid 程序，无需竞争条件即可直接获得 root 权限，目前该漏洞PoC和技术细节已公开。

**openEuler应急响应**

# 鉴于该漏洞影响范围较大，OpenAtom openEuler（简称 “openEuler” 或 “开源欧拉”）社区迅速开展应急响应，2026年4月30日完成对社区全部在维的版本的评估分析，**并于2026年5月3日完成了4.19、5.10和6.6全系列内核版本的修复，建议客户尽快做好自查并及时应用对应的修复补丁。**

**漏洞分析**

# 该漏洞的根源涉及 AF\_ALG 加密接口、splice 系统调用以及具有 setuid-root 二进制文件，这三者结合导致攻击者能将恶意数据写入内核页缓存，进而篡改二进制文件，从而执行二进制文件可以触发本地提权风险。

**受影响版本及修复补丁**

**系统版本**

**内核版本**

**是否受影响**

**修复补丁链接**

openEuler-20.03-LTS-SP4

&lt;=4.19.90-2604.3.0.0369

是

https://atomgit.com/openeuler/kernel/pull/22146

openEuler-22.03-LTS-SP4

&lt;=5.10.0-311.0.0.214

是

https://atomgit.com/openeuler/kernel/pull/22139

openEuler-24.03-LTS

&lt;=6.6.0-145.0.6.133

是

https://atomgit.com/openeuler/kernel/pull/22148

openEuler-24.03-LTS-SP1

&lt;=6.6.0-145.0.6.145

是

https://atomgit.com/openeuler/kernel/pull/22148

openEuler-24.03-LTS-SP2

&lt;=6.6.0-145.0.3.144

是

已停止维护，https://atomgit.com/openeuler/kernel/pull/22148

openEuler-24.03-LTS-SP3

&lt;=6.6.0-145.0.6.137

是

https://atomgit.com/openeuler/kernel/pull/22148

**修复的内核版本**

# **各版本修复内核RPM包，可在安全公告中获取：**

**系统版本**

**修复内核版本**

**公告链接**

openEuler-20.03-LTS-SP4

4.19.90-2605.3.0.0370

https://www.openeuler.org/zh/security/security-bulletins/detail/?id=openEuler-SA-2026-2174

openEuler-22.03-LTS-SP4

5.10.0-312.0.0.215

https://www.openeuler.org/zh/security/security-bulletins/detail/?id=openEuler-SA-2026-2175

openEuler-24.03-LTS

6.6.0-145.0.7.134

https://www.openeuler.org/zh/security/security-bulletins/detail/?id=openEuler-SA-2026-2176

openEuler-24.03-LTS-SP1

6.6.0-145.0.7.146

https://www.openeuler.org/zh/security/security-bulletins/detail/?id=openEuler-SA-2026-2172

openEuler-24.03-LTS-SP2

\-

已停止维护，可升级openEuler-24.03-LTS-SP3对应的修复版本：https://www.openeuler.org/zh/security/security-bulletins/detail/?id=openEuler-SA-2026-2173

openEuler-24.03-LTS-SP3

6.6.0-145.0.7.138

https://www.openeuler.org/zh/security/security-bulletins/detail/?id=openEuler-SA-2026-2173

**排查方法**

1. **内核版本自查：uname -a，确定内核是否在受影响范围：**

<!--THE END-->

![](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOtpibhOYEK0rjFfgN59CYtqg1Mn6QrpqAeCzqVWe43FmNXFfuZZpNcW847QIop8ibAm3ogly27eFS2peVNWRK5n7whpg6Uejwoz0/640?wx_fmt=png&from=appmsg)

2. **检查内核配置是否启用：**

grep CONFIG\_CRYPTO\_USER\_API\_AEAD /boot/config-$(uname -r)

![](https://mmbiz.qpic.cn/mmbiz_png/rxr9tddEHOtQTMZvhukHtsN4icVcZONqSaicwicBosibjt31yWLhhfJjV498Wb4uRjxbNvNgnPLL2icvfBXwRWcdpc6ib76FB5YSXUgibdRdPUFVZA/640?wx_fmt=png&from=appmsg)

CONFIG\_CRYPTO\_USER\_API\_AEAD=y：openEuler在维的版本模块已静态编译入内核，会自动加载，lsmod不可查，会受影响。

CONFIG\_CRYPTO\_USER\_API\_AEAD=m：可通过lsmod检查模块是否加载

lsmod | grep algif，若存在则受影响。

**漏洞修复验证**

**1、升级openEuler社区已发布的修复内核版本，需使用root权限操作：**

官方源在线升级：sudo dnf update kernel -y

或手动离线升级：

rpm -ivh kernel-6.6.0-145.0.7.138.oe2403sp3.aarch64.rpm

*注：*

以24.03-LTS-SP3版本update为例 最新内核包获取地址：

https://repo.openeuler.org/openEuler-24.03-LTS-SP3/update/aarch64/Packages/

![](https://mmbiz.qpic.cn/sz_mmbiz_png/rxr9tddEHOvicUrZvM6Dd01ROAWNpmqYj9A7MrUHv9wCibDV4EVupB0R2ib3rbWZQ29EHNyozIXgiaNVVSka4IcY1SHSBPV0v9XzibyFpQShyG8I/640?wx_fmt=png&from=appmsg)

**2、更新完内核后重启系统并确认内核版本是否正确**

sudo uname -a

![](https://mmbiz.qpic.cn/mmbiz_png/rxr9tddEHOu4SibhWIBYLYicHicOadCCjaUoCIptLILjztR9H6zVcwXr30KesGEXCLGovrKRkx6KBo8KsvXjgMzTp9l21PV7qZJjzicvKPTALnc/640?wx_fmt=png&from=appmsg)

**3、验证漏洞已修复**

![](https://mmbiz.qpic.cn/mmbiz_png/rxr9tddEHOtx1fhGG2UTDmnqZLC1N2jTCVqHvaSqRoDC0JlBnQjiavvKYdfCdzKqIcmQKN3LstHYPp4AAOQQ95DtAicMvicVZo1wdYW2Zsuf5w/640?wx_fmt=png&from=appmsg)

**规避措施**

在无法更新修复补丁的情况下可尝试采取以下规避措施：

**1. algif\_aead模块禁用**

\`algif\_aead.ko\` 为 crypto 框架层提供的 socket 用户态接口，受 \`CONFIG\_CRYPTO\_USER\_API\_AEAD\` 控制（\`=m\` 时编译成模块，\`=y\` 是编译进内核），openEuler默认发布的内核是编译进内核的，因此禁用该模块的规避措施不可用，基于openEuler内核将此模块编译为ko的情况下可禁止此模块加载进行规避。

**2. Seccomp 禁止相关 syscall**

seccomp 是进程级别的控制机制，通过 seccomp 禁止进程使用带有 \`AF\_ALG\` 标志位的 socket。适用容器场景，通过更改容器管理器（如 docker）配置，给新创建的容器增加 seccomp 规则，阻止新容器使用 \`AF\_ALG\` socket。

**本文参考链接**

\[1].https://copy.fail/

\[2].https://github.com/theori-io/copy-fail-CVE-2026-31431

\[3]引入问题补丁

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=72548b093ee38a6d4f2a19e6ef1948ae05c181f7

\[4]修复问题补丁

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a664bf3d603dc3bdcf9ae47cc21e0daec706d7a

-END-

供稿 | openEuler安全委员会

编辑 | 丘云

校审 | 郑振宇、刘彦飞

**关注我们，了解更多**

**▼**

![图片](https://mmbiz.qpic.cn/mmbiz_png/jqTxnpIZ2mCbBSyvm2AJRXb5x9C3DgH2d1CvxNf56DXribfOKnOqvMU1jP4fVRpO45sDy84Knibcp1OuASLm5MMg/640?wx_fmt=png&from=appmsg&wxfrom=5&wx_lazy=1#imgIndex=1)

▼点击阅读原文快速进入【安全中心】

[阅读原文](https://www.openeuler.openatom.cn/zh/security/security-bulletins/)
