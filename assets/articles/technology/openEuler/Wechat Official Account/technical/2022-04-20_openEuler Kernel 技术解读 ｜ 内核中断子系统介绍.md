# [openEuler Kernel 技术解读 ｜ 内核中断子系统介绍](https://mp.weixin.qq.com/s/Jl9HNhv91iFFohP3bwqEiw)

*Kernel SIG*[OpenAtom openEuler](javascript:void%280%29;)*2022-04-20 08:55:09*

很多人在学习中断子系统的过程中，在对基本概念与整体不太了解的情况下，过早的陷入了各种架构的实现细节，如同盲人摸象。这里主要给大家明确中断的各个基本概念，希望从这个角度能让大家更好的理解中断子系统。

## 什么是中断

在计算机科学中，中断（英语：Interrupt）是指处理器接收到来自硬件或软件的信号，提示发生了某个事件，应该被注意，这种情况就称为中断。中断子系统中的中断指的是其中硬件的一方，后续中断均按此理解。

## 中断处理的参与对象和流程

中断处理中有着多个对象的参与，理解每个对象在其中是如何参与是很重要的。以下列举了中断处理的参与对象。

- 中断事件：指中断事件本身的抽象。
- 中断号：用于硬件和软件识别并区分中断事件，需要注意同一个中断事件在中断处理的不同阶段未必是同一个中断号。
- 中断源：有中断事件需要 cpu 处理的硬件。
- 中断控制器：非必须，用于解决系统拥有多中断源场景的硬件；从中断源接收中断事件并传递到 cpu；可以级联。
- cpu：收到中断，cpu 跳转到特定的地址——中断向量。由中断向量开始软件对中断的处理。

中断事件在硬件中的流程如下，上一行是中断事件的体现形式，下一行是所在的硬件：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbzonKUuZvD4LlibWibRySe0lJO90mWkXia0ibarq8ISZ6Zbv4icfIhZNwQVGZ5a8GpeIR0MSo5nzvAJFQ/640?wx_fmt=png)

再把软件处理结合起来，形成一个硬件软件切换的过程：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbzonKUuZvD4LlibWibRySe0lUQEaLhsSBIGxNEBtXff8fHiaYjuJYV5Fgke6lE0JXh3iaNIjnb0BogGg/640?wx_fmt=png)

相邻的中断事件体现形式的映射方式可以在所在的对象的连接的实现中找到。

## 中断子系统

现在把之前的流程具有的部分对比内核中断子系统，可以发现还多出了一个通用中断处理层。因为内核需要支持各种不同的架构与外设，需要解耦架构硬件相关部分（cpu 与中断控制器）与非架构相关（外设），使得开发外设驱动并不需要了解架构相关部分。另一方面，系统硬件拓扑结构的信息一般由设备树源码 DTS 体现。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbzonKUuZvD4LlibWibRySe0lPPOVRuF2onicwQ0mcAxbVH2FwuI3WagRcOoIo99TSlnbTGPF8iblJiasQ/640?wx_fmt=png)

## 硬件封装层

硬件封装层包括 cpu 和中断控制器两部分。区分开 cpu 和中断控制器相当重要，希望大家能更明确 cpu 和中断控制器的概念。软件在 cpu 方面主要需要按架构实现中断向量的处理，可以看 arch/**「/kernel/entry」**.S 的汇编实现。另外还需要为通用的开关中断方法提供架构实现：

通用中断开关方法具体架构中断开关实现local\_irq\_enablearch\_local\_irq\_enablelocal\_irq\_disablearch\_local\_irq\_disable

这个 local 指的是 local\_cpu，表示的是当前 cpu 是否响应中断：当前 cpu 关中断的情况下，中断控制器不管怎么玩都是徒劳的。事实上 cpu 对中断开关的实现还包含着很多条件，类似特权态、非屏蔽中断 NMI 之类的，可以在后文找下具体分析。软件对中断控制器的抽象是 struct irq\_chip，体现的是中断控制器所具体的行为。这里列举部分重要成员讲解：

起因struct irq\_chip 成员说明怎么控制中断控制器是否屏蔽某个中断事件？irq\_enable/ irq\_disable  
中断控制器如何配置中断事件的触发方式irq\_set\_type控制各个中断的电气触发条件，例如边沿触发或者是电平触发。中断控制器如何得知中断事件被 cpu 响应?irq\_ack中断控制器在实现中会根据中断事件被 cpu 开始响应或完成响应来决定该中断事件类型是否会再度通知 cpu 处理。中断控制器如何得知 cpu 完成处理中断事件？irq\_eoi中断控制器在实现中会根据中断事件被 cpu 开始响应或完成响应来决定该中断事件类型是否会再度通知 cpu 处理。在 smp 系统中，中断事件应该通知哪个 cpu？irq\_set\_affinityaffinity 表示了中断事件在中断控制器中配置的目标 cpu，根据具体实现可以是 1 个或多个。

此外，当多个中断事件同时发生，中断控制器会根据其优先级的实现来决定中断事件通知给 cpu 的顺序，某些实现是可配置的。另一方面，考虑到系统中可能存在多个中断控制器，使得单一中断控制器的中断号不足以区分中断事件，所以引入了软件中断号的概念。加上硬件中断号映射中断号的软件抽象 struct irq\_domain，再看中断控制器软件抽象到中断源软件抽象的流程：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbzonKUuZvD4LlibWibRySe0lRWYvyRrNAAmNtaWW0xJEsQXp30TrszqEqUlzS6F8CeNUAf5X1PVJIQ/640?wx_fmt=png)

##中断流控处理层 这一层主要是隐藏了中断控制器在具体中断事件处理函数调用前后的一些处理逻辑，包括：

- 何时对中断控制器发出 ack 回应？
- mask\_irq 和 unmask\_irq 的处理；
- 中断控制器是否需要 eoi 回应？
- 何时打开 cpu 的本地 irq 中断？以便允许 irq 的嵌套；

类似于在用洗衣机洗衣服的时候，我们不关心衣服可能要经历过的洗涤多久、脱水多久、漂洗多久诸如此类的步骤细节，只需要按衣服类型选择流程；内核引入中断流程的抽象类型 irq\_flow\_handler\_t 屏蔽了中断事件相关的 cpu、中断控制器和中断源的属性的不同带来的处理流程差异。这里举例部分内核实现：

- handle\_simple\_irq：用于简易流控处理。
- handle\_level\_irq：用于电平触发中断的流控处理。
- handle\_edge\_irq：用于边沿触发中断的流控处理。
- handle\_fasteoi\_irq：用于需要响应 eoi 的中断控制器
- handle\_percpu\_irq：用于只在单一 cpu 响应的中断。

## 驱动程序 API 与中断通用逻辑

对于中断事件本身，内核使用 struct irq\_desc 进行描述，它包含着所有的信息。而对于中断控制器与中断源的驱动来说，关注的信息都只是其中的一部分。中断事件从中断源到中断控制器的映射的描述一般事先会静态定义好并存放在设备树源码里，即中断源的设备树节点包含着相连的中断控制器和中断事件对应在中断控制器中断号的信息；而作为驱动程序需要对软件中断号 irq 和中断事件处理函数建立映射。那么要把设备树节点中的中断控制器和中断控制器中断号转换成软件中断号 irq，内核给驱动程序提供了接口：

- irq\_of\_parse\_and\_map：驱动由设备树节点获得 irq。

当中断控制器和中断控制器中断号转换成软件中断号 irq 映射不存在时，这个接口会申请 irq\_desc 并建立映射，根据连接着的中断控制器的驱动提供的硬件中断号映射中断号的软件抽象 irq\_domain 完成映射。在映射过程中会包括对 irq\_desc 的一些属性的设置，如：

- irq\_set\_handler：驱动选择 irq\_flow\_handler。
- irq\_set\_chip：驱动选择 irq 连接的中断控制器。
- irq\_alloc\_desc 系列：驱动直接申请 irq\_desc。

中断源驱动获取到 irq，还需要将 irq 与中断处理函数建立映射：

- request\_irq/request\_threaded\_irq：驱动将中断处理函数注册到 irq。
- enable\_irq & disable\_irq：驱动开关 irq。

接下来将对一些具体的架构实现做介绍。这里介绍两个处理器 armv8 和 x86，以及两个中断控制器 arm-gicv3 和 x86-APIC 的实现。希望帮助大家得出诸如“arm 内核有中断嵌套吗”“arm cpu eoi 是做什么”这类问题的答案。

## armv8

arm 核心拥有 2 个外部中断线，IRQ 和 FIQ；这两根中断线连接到中断控制器上，中断控制器通过拉高和拉低这两根中断线触发中断。一个中断应该触发 IRQ 还是 FIQ 中断线，由其 GROUP 属性和当前的特权级和安全域决定。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbzonKUuZvD4LlibWibRySe0lmsd6q7PMuBiacX2NxZOvOCbib6wXoQHdW79rhCmFPjibuCHSoSLRLyhew/640?wx_fmt=png)

GROUP 的定义：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbzonKUuZvD4LlibWibRySe0ldEIr5vpR8pcIblL81Whq1pNdcyjAFCmNvib7sRaorRpzszNowh41S4w/640?wx_fmt=png)

arm 核，软件可以写 SCR、HCR 和 PSTATE.DAIF 寄存器以决定响应中断的特权级和屏蔽中断；arm 不支持 NMI。arm 核由于中断控制器的实现，同时只会有一个需要被响应的中断，因此不限制 IRQ/FIQ 响应顺序的实现。arm 核上处于触发状态的中断线需要结合 SCR、HCR 和 PSTATE.DAIF 寄存器判断是否触发中断，不论当前是否处于中断。在中断触发时，arm 核心根据 VBAR 系列寄存器的基地址，会按具体情况选择偏移跳转到对应的地址。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbzonKUuZvD4LlibWibRySe0lCHctqnXmicbogpWklxHJlxrRmxQr5mh2Iq6licFMrd4RkhcsJd1vCTFA/640?wx_fmt=png)

## x86

Intel x86 架构提供 INTR 和 NMI 两个中断引脚，他们通常与 Local APIC 相连， 用于接收 Local APIC 传递的中断信号。一个中断应该触发 INTR 还是 NMI 中断线由 Local APIC 实现。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbzonKUuZvD4LlibWibRySe0lWVwIa0cS7KVovhgCUwNd16jQU8EELFTVdCMicXDGuicxbFss1ib1okX1w/640?wx_fmt=png)

x86，中断都在 ring0 响应。x86 上软件使用 CLI 指令将本 CPU 的 EFLAGS 寄存器的 IF 位清 0，阻止接收中断；STI 指令将 IF 位置为 1，允许接收中断。这两条指令都只对当前 CPU 起作用，而不影响平台上的其他 CPU。x86 中断线的实现原生支持 NMI。x86 核上同时只会有一个需要被响应的中断，它由 Local APIC 从 IRR 中选择；当 Local APIC 不使能时，优先响应 NMI 中断线。不论当前是否处于中断，x86 核上若 INTR 处于触发且未屏蔽中断即会触发中断；NMI 处于触发则直接触发中断。中断触发时，x86 核根据寄存器 IDTR 记录的基址和中断控制器的寄存器 ISR 提供的中断向量号找到 IDT 表中对应的 Interrupt Gate 表项，跳转到相应的地址。

## arm-gicv3

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbzonKUuZvD4LlibWibRySe0lPCsFKEE5st1CBfyF8DZUsXs4OqpX9O4PtI65ADnazkATRAZbS9qbaA/640?wx_fmt=png)

从逻辑视图上看，gicv3 的核外部分统称 IRI，由 Distributor、ITS、Redistributor 这 3 种组件组成；gicv3 核内部分是 CPU interface-，PE 可以理解为 cpu；IRI 与 CPU interface- 通过 GIC Stream Protocol interface- 交互。

不同的中断在 gic 上对应着不同的 INTID；gic 把中断类型分为 LPI、PPI、SPI、SGI，约束 INTID 取值对应的中断类型。SGI 指由 CPU 直接写对应的寄存器触发中断；PPI 指中断为特定一个 CPU 私有/专用，同一中断号的 PPI 在不同 CPU 可以指不同的中断源；SPI 对应 PPI，是所有 CPU 全局共享的，同一中断号的 SPI 在不同 CPU 均指相同的中断源；LPI 的区分是中断路由上的不同，主要是在 IRI 中由 ITS 路由的中断，其余 3 种中断均不经过 ITS；某些实现下还有直接在 Redistributor 触发的 LPI 中断。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbzonKUuZvD4LlibWibRySe0lR983GMHgwLk2WJkYt1hxQcFZkgx8pTHjnzR6ILStetLIJNJUUtH1ibg/640?wx_fmt=png)

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbzonKUuZvD4LlibWibRySe0lHgRiaED4MUwDRfh5WQtRUibzgngflbe3QLCYiaZ9bcFuI4v7jyOLf55Uw/640?wx_fmt=png)

一个外部中断从在外设上产生，依次经过 IRI、CPU interface- 并最终通过中断线到达 PE；PE 产生的中断需要先经过 CPU interface- 到 IRI，再到目标的 CPU interface- 和 PE。逻辑上，IRI 可以对应多个 PE，因此对于需要被一个特定目标 PE 响应的中断，gicv3 通过引入 affinity routing 机制解决这种路由问题。同一时间，CPU interface- 上只能存在一个待处理的中断，对于多个中断被发送到 CPU interface- 上，gic 引入优先级的机制来决定如何选择保留的中断；这个优先级的机制还被运用在 IRI 上，优先级更高的中断会被优先发送到 CPU interface-。另外，CPU interface- 还负责将这个待处理的中断按照 GROUP 属性和当前的特权级和安全域决定触发 IRQ 还是 FIQ 中断线；并且当 PE 当前处于中断时，CPU interface- 还需要通过中断优先级分组的机制判断待处理的中断是否需要被通知给 PE，即抢占。

## x86-APIC

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbzonKUuZvD4LlibWibRySe0lWVwIa0cS7KVovhgCUwNd16jQU8EELFTVdCMicXDGuicxbFss1ib1okX1w/640?wx_fmt=png)

从逻辑视图上看，APIC 的核外部分是 I/O APIC，核内部分是 Local APIC。I/O APIC 根据内部 PRT table 中的 RTE 发送中断消息给 Local APIC。I/O APIC 中 PRT table 由 24 个 RTE 项组成，每一项对应一个 IRQ 引脚。I/O APIC 可以有多个，当多个 I/O APIC 存在时，使用 GSI 代表每个 I/O APIC 管脚的编号：例如 I/O APIC1 有 24 个 IRQ，I/O APIC2 也有 24 个 IRQ，则 I/O APIC2 的 GSI 是从 24 开始，GSI = 24 + IRQ（I/O APIC2）。I/O APIC 的 24 个管脚没有优先级之分。一个外部中断经过 I/O APIC 再到 Local APIC，最后由 Local APIC 控制中断线在 CPU 上触发中断；CPU 内部的中断源由 Local APIC 管理，不需要经过 I/O APIC；IPI 也由 Local APIC 管理，同样不需要经过 I/O APIC。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbzonKUuZvD4LlibWibRySe0lKwickTy5WlRtibaR2mJk9ic5VopQMLgYSXv4gO55oJAD9aXzhv6nSJTog/640?wx_fmt=png)

Local APIC 支持 0-255 的中断向量号，它们可以同时存在于寄存器 IRR 上，引入中断优先级进行选择：优先级 = 中断向量号 / 16 因为 32 以下的中断向量号是保留的，所以可用中断优先级范围为 2-15，数字越大优先级越高；当优先级高于寄存器 PPR 的情况下会操作 INTR 中断线，若当前已经处于中断则可能出现抢占。中断向量号的低 4 位会在当 PPR 改变的情况下，ISR 从 IRR 上选择中断向量号的比较中使用，同样也是数字越大优先级越高。

## 参考资料

\[1]arm generic interrupt controller architecture specification

\[2] ARM Architecture Reference Manual ARMv8 

\[3]multiprocessor specification

\[4]intel? 64 and ia-32 architectures software developer's manual volume 3a: system programming guide, part 1

## openEuler Kernel SIG

- openEuler kernel 源代码仓库：https://gitee.com/openeuler/kernel 欢迎大家多多 star、fork，多多参与社区开发，多多贡献补丁。关于贡献补丁请参考：如何参与 openEuler 内核开发
- openEuler kernel 微信技术交流群 请扫描下方二维码添加小助手微信，或者直接添加小助手微信（微信号：openeuler-kernel），备注“交流群”或“技术交流”，加入 openEuler kernel SIG 技术交流群。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbzonKUuZvD4LlibWibRySe0l8bdCfTkQ5fVWMQJlDoicEZm4GqeS22eficp2PBMawIiatmdoicYo4vXNRA/640?wx_fmt=png)
