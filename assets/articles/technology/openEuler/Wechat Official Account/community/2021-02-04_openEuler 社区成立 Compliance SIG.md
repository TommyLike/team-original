# [openEuler 社区成立 Compliance SIG](https://mp.weixin.qq.com/s/psG0LaZkbgu0_JgWKRx8PQ)

*周荔人*[OpenAtom openEuler](javascript:void%280%29;)*2021-02-04 18:00:00*

经 openEuler 社区技术委员会讨论决定，openEuler 社区正式成立 Compliance SIG。Compliance SIG 将专注解决 openEuler 社区中开源软件的合规问题。openEuler 社区中的开发者更加擅长于软件开发，而合规的本质是一个法律问题，社区开发者在开发的软件的过程中不合理的使用其他开源软件，可能会存在法律风险。

 

为什么开源软件存在“免费”的属性，但还是会有法律风险问题？根据版权法，以任何方式使用软件均须从软件作者处获取许可证，许可证描述了授予用户的权利，以及用户必须履行的义务的。尽管开源软件本身是“免费”的，但他实际上与任何其他软件并无不同，开源软件在开源之初,作者就选择了相应的开源许可证。使用开源软件同样受到许可证的约束。

 

根据新思科技网络安全研究中心制作的《2020年开源安全和风险分析报告》对许可证冲突的分析，发现 33% 的代码库中包含未经许可的软件，67% 的代码库存在许可证冲突的问题，所以合规问题是每一个开源开发者必须关注的问题。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbgnbHeRSt5frvI8Yonaupn83aRmSgKCrcIsOvbLkohDnuZCnQf5u6Dn2vBlJnX9jT5AsU9MWdEcA/640?wx_fmt=png)

 

openEuler 社区作为最具活力的开源社区，开源软件仓库已经达到了 7000+个，如此大量的开源软件如何保证在法律上是合规的？再加上如今开源软件更换许可证的事情时有发生，牵一发而动全身，每一个许可证的更改所带来的影响，对于一款开源软件来说都是一个复杂的工程问题。这是 Compliance SIG 要去探索并尝试解决的问题之一。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbgnbHeRSt5frvI8YonaupnnFpLbLJ3XZyy4zicliclYRAla3TybNiakNvWVfNUEA8hibWa53fpod7LCg/640?wx_fmt=png)

 

每一个 RPM 包发布都会有一个spec文件，这其中包含 RPM 包引用的上游开源软件，但是对于这些引入的上游开源软件，开发者并没有能力去及时进行维护。根据新思科技网络安全研究中心发布的《2020年开源安全和风险分析报告》，目前82% 的代码库包含已经过期四年以上的组件，88%的代码库中包含过去两年中没有任何开发活动的组件。

这导致的问题是，当软件漏洞涉及到上游软件时，上游软件已经停止更新，会直接导致该软件漏洞无法修复，这也是 Compliance SIG 要去探索并尝试解决的第二个问题。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbgnbHeRSt5frvI8YonaupnwheOiaPTqibXNoiaibXibJhSy4hD53jl441z5d4jh6ID9GqowAdqGib822pg/640?wx_fmt=png)

在 ComplianceSIG 未成立之前，openEuler 社区中引入一款开源软件是先交由 TC 进行决策，随着引入的开源软件不断增加，TC 决策的压力日益增大，且专业性不容易得到保证，openEuler 社区需要 Compliance SIG 来专门处理这些事情，专业的人做专业的事。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbgnbHeRSt5frvI8Yonaupn02e99LCK9CXlzXLr9icr5XpP1oDia70ym0vQibxjNYzrj4s8SAeicRAZvQ/640?wx_fmt=jpeg)

本次 Compliance SIG 的成立得到了麒麟信安、润和软件和华为的支持。来自这三家公司的开发者担任 Compliance SIG 的 Maintainer。该 SIG 会通过提升整个社区合规的工程能力作为其使命，将合规打造成openEuler的品牌。

 

就像胡 Core 在《openEuler 社区2021年1月运作报告》中所说

 

***“我们希望 Compliance SIG 能够为国内的软件合规做出样板，同时能够积累出一系列软件工具，为行业提供公共的能力服务”***

 

欢迎大家加入Compliance SIG。

#### **Compliance SIG 主要想解决的问题**

1\. 解决文件级license的问题。例如：PHP

2\. 解决新引入组件的license的判断问题。

3\. 解决上游组件license变更的问题。例如：mangoDB、ES

4\. 解决RPM包的spec文件license和原生社区的license不一致的问题。例如：greenlet组件

#### **Compliance SIG 的目标**

1\. 建立openEuler的合规体系

2\. 发布openEuler的规则、规范

3\. 制定openEuler的合规流程

4\. 设计openEuler的合规架构（BA\\IA）

5\. 开发openEuler的合规工具

6.  提供openEuler的合规服务（解决方案）

#### **例会时间**

双周周二例会时间：上午10:00~12:00

 

 

成为 openEuler 社区的一员

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMa7lLCBqDyB4o1cXb6YL68TT81xiblAiadcZXpgrtkIcib0rQhXyfzI8QgSjUCmogFV5yIGNl1nVUP5g/640?wx_fmt=png)
