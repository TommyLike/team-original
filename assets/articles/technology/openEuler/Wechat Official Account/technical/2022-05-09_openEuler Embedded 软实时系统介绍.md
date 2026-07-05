# [openEuler Embedded 软实时系统介绍](https://mp.weixin.qq.com/s/F3xXpmQQMeHiyqRJvhAyzA)

*Embedded SIG*[OpenAtom openEuler](javascript:void%280%29;)*2022-05-09 20:05:00*

本文主要介绍 openEuler Embedded 软实时系统的特性说明，构建方式和性能测试。

## 软实时特性介绍

**「实时性简介」**

实时的诉求通常是事件的响应时间不能超过规定的期限，一个事件的最大响应时间应该是确定的、可以预测的。

**「Preempt\_RT 补丁简介」**

Preempt\_RT 补丁（以下简称 RT 补丁）可直接打在内核源码上，并通过内核配置选项 CONFIG\_PREEMPT\_RT=y 使能软实时功能。RT 补丁实现的核心在于最小化内核中不可抢占部分的代码，从而使高优先级任务就绪时能及时抢占低优先级任务，减少切换时延。除此之外，补丁通过多种降低时延的措施，对锁、驱动等模块也进行了优化。

openEuler Embedded 版本中可使用的 RT 补丁请参考：

1. QEMU：

> ?
> 
> 1. patch-5.10.0-60.10.0-rt62.patch
> 2. patch-5.10.0-60.10.0-rt62\_openeuler\_defconfig.patch
> 
> ?

2. raspberrypi：

> ?
> 
> 1. 0000-raspberrypi-kernel.patch（树莓派补丁）
> 2. 0001-add-preemptRT-patch.patch
> 3. 0002-modifty-bcm2711\_defconfig-for-rt-rpi-kernel.patch
> 
> ?

**「补丁获取地址」**

https://gitee.com/src-openeuler/kernel/blob/openEuler-22.03-LTS

**「补丁关键功能举例」**

1. 增加中断程序的可抢占性（中断线程化、软中断线程化）
2. 增加临界区的可抢占性（如自旋锁）
3. 增加关中断代码的可抢占性
4. 解决优先级反转问题（优先级继承）

## 软实时镜像构建指导

具体下载源码和编译流程建议参考容器环境下的快速构建指导：https://openeuler.gitee.io/yocto-meta-openeuler/yocto/quickbuild/container-build.html

**「QEMU RT 镜像构建方式」**

- 步骤：

下载源码 --&gt; 修改 bb 文件打入 RT 补丁 --&gt; 手动打开 CONFIG\_PREEMPT\_RT --&gt; 编译构建

- 更改 aarch64 镜像内核 bb 文件，使其构建时自动打入 RT 补丁，示例：

```
cd /usr1/openeuler/src/yocto-meta-openeuler/meta-openeuler/recipes-kernel/linux/

sed -i '/0001-arm64-add-zImage/a\    file://src-kernel-5.10/patch-5.10.0-60.10.0-rt62.patch \\' linux-openeuler.bb

sed -i '/patch-5.10.0-60.10.0-rt62.patch/a\    file://src-kernel-5.10/patch-5.10.0-60.10.0-rt62_openeuler_defconfig.patch \\' linux-openeuler.bb
```

git diff 输出示例：

```
diff --git a/meta-openeuler/recipes-kernel/linux/linux-openeuler.bb b/meta-openeuler/recipes-kernel/linux/linux-openeuler.bb
index 77d8717..5a4b2b8 100644
--- a/meta-openeuler/recipes-kernel/linux/linux-openeuler.bb
+++ b/meta-openeuler/recipes-kernel/linux/linux-openeuler.bb
@@ -11,6 +11,8 @@ SRC_URI = "file://kernel-5.10 \
 # add patches only for aarch64
 SRC_URI_append_aarch64 += " \
     file://yocto-embedded-tools/patches/${ARCH}/0001-arm64-add-zImage-support-for-arm64.patch \
+    file://src-kernel-5.10/patch-5.10.0-60.10.0-rt62.patch \
+    file://src-kernel-5.10/patch-5.10.0-60.10.0-rt62_openeuler_defconfig.patch \
 "

 # add patches for OPENEULER_PLATFROM such as aarch64-pro
```

- 打开 aarch64 镜像 defconfig 中的 CONFIG\_PREEMPT\_RT，示例：

```
cd /usr1/openeuler/src/yocto-embedded-tools/config/arm64/

sed -i 's/CONFIG_PREEMPT=y/CONFIG_PREEMPT_RT=y/g' defconfig-kernel
```

git diff 输出示例：

```
diff --git a/config/arm64/defconfig-kernel b/config/arm64/defconfig-kernel
index dece4f7..c4ef7ab 100644
--- a/config/arm64/defconfig-kernel
+++ b/config/arm64/defconfig-kernel
@@ -80,7 +80,7 @@ CONFIG_HIGH_RES_TIMERS=y

 # CONFIG_PREEMPT_NONE is not set
 # CONFIG_PREEMPT_VOLUNTARY is not set
-CONFIG_PREEMPT=y
+CONFIG_PREEMPT_RT=y
 CONFIG_PREEMPT_COUNT=y
 CONFIG_PREEMPTION=y
```

- 编译时选择 aarch64-std 架构，示例：

```
cd /usr1/openeuler/src/yocto-meta-openeuler/scripts

source compile.sh aarch64-std /usr1/build /usr1/openeuler/gcc/openeuler_gcc_arm64le

bitbake openeuler-image
```

- 构建镜像生成目录：
  
  `/usr1/build/output/`
- 二进制介绍：
  
  1. `Image-5.10.0`：QEMU RT 内核镜像
  2. `openeuler-image-qemu-aarch64-<时间戳>.rootfs.cpio.gz`：QEMU 文件系统
  3. `openeuler-glibc-x86-64-openeuler-image-aarch64-qemu-aarch64-toolchain-22.03.sh`：SDK 工具链
  4. `zImage`：QEMU RT 内核的压缩镜像

**「树莓派 RT 镜像构建方式」**

- 步骤：

下载源码 --&gt; 修改 bb 文件打入 RT 补丁（补丁已自动打开 CONFIG\_PREEMPT\_RT） --&gt; 编译构建

- 更改 raspberrypi 镜像内核 bb 文件，使其构建时自动打入 RT 补丁并打开 CONFIG\_PREEMPT\_RT，示例：

```
cd /usr1/openeuler/src/yocto-meta-openeuler/bsp/meta-openeuler-bsp/raspberrypi/recipes-kernel/linux/

sed -i '/0000-raspberrypi-kernel.patch/a\    file://src-kernel-5.10/0001-add-preemptRT-patch.patch \\' linux-openeuler.bbappend

sed -i '/0001-add-preemptRT-patch.patch/a\    file://src-kernel-5.10/0002-modifty-bcm2711_defconfig-for-rt-rpi-kernel.patch \\' linux-openeuler.bbappend
```

git diff 输出示例：

```
diff --git a/bsp/meta-openeuler-bsp/raspberrypi/recipes-kernel/linux/linux-openeuler.bbappend b/bsp/meta-openeuler-bsp/raspberrypi/recipes-kernel/linux/linux-openeuler.bbappend
index ad6ebab..cf52b3d 100644
--- a/bsp/meta-openeuler-bsp/raspberrypi/recipes-kernel/linux/linux-openeuler.bbappend
+++ b/bsp/meta-openeuler-bsp/raspberrypi/recipes-kernel/linux/linux-openeuler.bbappend
@@ -1,5 +1,7 @@
 SRC_URI += "\
     file://src-kernel-5.10/0000-raspberrypi-kernel.patch \
+    file://src-kernel-5.10/0001-add-preemptRT-patch.patch \
+    file://src-kernel-5.10/0002-modifty-bcm2711_defconfig-for-rt-rpi-kernel.patch \
 "
 OPENEULER_KERNEL_CONFIG = "${S}/arch/${ARCH}/configs/bcm2711_defconfig"
 do_configure_prepend() {
```

- 编译时选择 raspberrypi4-64 架构，示例:

```
cd /usr1/openeuler/src/yocto-meta-openeuler/scripts

source compile.sh raspberrypi4-64 /usr1/build /usr1/openeuler/gcc/openeuler_gcc_arm64le

bitbake openeuler-image
```

- 构建镜像生成目录：
  
  `/usr1/build/output/`
- 二进制介绍：
  
  1. `Image`：树莓派 RT 内核镜像
  2. `openeuler-image-raspberrypi4-64-<时间戳>.rootfs.rpi-sdimg`：树莓派 RT 支持 SD 卡镜像
  3. `openeuler-glibc-x86-64-openeuler-image-cortexa72-raspberrypi4-64-toolchain-22.03.sh`：SDK 工具链

树莓派 4B 的具体使用方法后期会详细介绍。

> ?
> 
> **「说明」**
> 
> - 如果开发人员使用的内核配置不是 RT 补丁中修改的 defconfig（QEMU：`arch/arm64/configs/openeuler\_defconfig`，树莓派：`arch/arm64/configs/bcm2711\_defconfig`），则需要在自己的 defconfig 中开启内核配置选项 CONFIG\_PREEMPT\_RT，例如上面 QEMU 构建方式中的 yocto-embedded-tools/config/arm64/defconfig-kernel
> - openEuler Embedded 软实时特性当前仅支持 arm64 架构
> 
> ?

## 验证环境的软实时是否使能

- 查看系统是否有 PREEMPT\_RT 字样：

输入示例：

```
uname -a
```

输出示例：

```
Linux openeuler 5.10.0-rt62-v8 #1 SMP PREEMPT_RT Fri Mar 25 03:58:22 UTC 2022 aarch64 GNU/Linux
```

## 软实时性能测试

**「软实时相关测试」**

参考 RT-Tests 指导

https://wiki.linuxfoundation.org/realtime/documentation/howto/tools/rt-tests

进行软实时相关测试，用例包括但不限于：

1. cyclictest 时延性能测试
2. pi\_stress 优先级继承测试
3. hackbench 负载构造工具

下面以 cyclictest 时延性能测试为例进行说明。

**「cyclictest 时延性能测试」**

1. 准备开发环境

安装 SDK，准备编译环境，示例：

```
sh openeuler-glibc-x86_64-openeuler-image-aarch64-qemu-aarch64-toolchain-22.03.sh

. /path/to/sdk/environment-setup-aarch64-openeuler-linux
```

2. 编译用例

```
git clone https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git

cd rt-tests

git checkout stable/v1.0

make all
```

3. 执行用例

编译完成后生成二进制 `cyclictest`，传入单板环境后可查看执行 cyclictest 时可配置的参数：

```
./cyclictest --help
```

cyclictest 有多种参数配置方法，用例具体的入参设计可参考 test-design

https://wiki.linuxfoundation.org/realtime/documentation/howto/tools/cyclictest/test-design

输入示例：

```
./cyclictest -p 90 -m -i 100 -n -h 100 -l 10000000
```

输出示例：

```
# /dev/cpu_dma_latency set to 0us
policy: fifo: loadavg: 2.32 1.99 1.58 1/95 311

T: 0 (  311) P:90 I:100 C:10000000 Min:      7 Act:    9 Avg:    8 Max:      16
```

即用例循环 1000 万次后，平均时延为 8us，最坏时延为 16us（该数据仅为示例，具体以环境实测为准）。

> ?
> 
> **「说明：」**
> 
> 如果树莓派 4B 的空载情况下，平均时延较差（如超过 20us），可查看使用的树莓派固件是否将 CPU 频率配置为了节能模式，并根据需要将 CPU 频率配置为最高运行频率。如无 cpufreq 相关接口，则不涉及。
> 
> ?

输入示例：

```
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

输出示例：

```
powersave
```

如上结果表示 CPU 频率为节能模式。

配置 CPU 最高运行频率，输入示例：

```
echo performance > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

## 关注我们

Embedded 已经在 openEuler 社区开源。后续将开展一系列主题分享，如果您对 Embedded 的构建，应用感兴趣，欢迎围观和加入。

项目地址

https://gitee.com/openeuler/yocto-meta-openeuler

欢迎大家多多 star、fork，多多参与社区开发，多多贡献。

## 进入交流群

如果您对嵌入式应用感兴趣，欢迎加入 openEuler Embedded&Yocto SIG 技术交流群，讨论 Embedded 和 Yocto 等相关技术。请扫描下方二维码加入群聊。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMb3lrSx2sKk8ADazyQMX7JnuNib1cPDs59UYQn58N1thc0jnMm6m3MibhHKP1qjlsSUib39QOgc4DW4w/640?wx_fmt=jpeg)
