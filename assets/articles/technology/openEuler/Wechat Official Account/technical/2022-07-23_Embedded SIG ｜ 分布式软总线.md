# [Embedded SIG ｜ 分布式软总线](https://mp.weixin.qq.com/s/EQqczm8LeB2tMj2xPJ5zlQ)

*Embedded SIG*[OpenAtom openEuler](javascript:void%280%29;)*2022-07-23 15:30:00*

**Embedded SIG**

**分布式软总线**

**-** 特性介绍 **-**

**背景**

openEuler秉承着打造“数字化基础设施操作系统”的愿景，为促进与OpenHarmony生态的合作与互通，实现端边领域的互通和协同，首次在嵌入式领域引入分布式软总线技术。

分布式软总线是OpenHarmony社区开源的分布式设备通信基座，为设备之间的互通互联提供统一的分布式协同能力，实现设备无感发现和高效传输。

OpenHarmony主要面向强交互等需求的智能终端、物联网终端和工业终端。openEuler主要面向有高可靠、高性能等需求的服务器、边缘计算、云和嵌入式设备，二者各有侧重。通过以分布式软总线为代表的技术进行生态互通，以期实现“1+1&gt;2”的效果，支撑社区用户开拓更广阔的行业空间。

**架构**

软总线的主要架构如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbhDX0ic1uibBfBXRecL2HMNiaVia6hgQOjkFSY2skgDicZEWxaTuVofic7zIJibAV0M4m5WtywSWcFkiaWxQ/640?wx_fmt=png)

软总线主体功能分为发现、组网、连接和传输四个基本模块，实现：

**· 即插即用：**快速便捷发现周边设备。

**· 自由流转：**各设备间自组网，任意建立业务连接，实现自由通信。

**· 高效传输：**通过WIFI、蓝牙设备下软硬件协同最大化发挥硬件传输性能。

软总线南向支持标准以太网通信，同时后续可持续拓展WIFI、蓝牙等多种通信方式。并为北向的分布式应用提供统一的API接口，屏蔽底层通信机制。

软总线依赖于设备认证、IPC、日志和系统参数（SN号）等周边模块，嵌入式系统中将这些依赖模块进行了样板性质的替换，以实现软总线基本功能。实际的周边模块功能实现，还需要用户根据实际业务场景进行丰富和替换，以拓展软总线能力。

**-** 应用指南 **-**

**部署示意**

软总线支持局域网内多设备部署，设备间通过以太网通信。单设备上分为server和client，二者通过IPC模块进行交互。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbhDX0ic1uibBfBXRecL2HMNiaBwVjW9vmpJrerzKCG6UZGcGennWktoHTprSo73E50W15zxjB0s4AaA/640?wx_fmt=png)

**注意：**

当前IPC模块和SN号等系统参数，嵌入式版本提供的仅为参考模板，还无法支持多节点和多client部署。用户可根据实际业务场景进行IPC模块和SN号系统参数进行功能丰富，以拓展软总线部署能力。

**服务端启动**

服务端主程序为softbus\_server\_main，执行该主程序既可拉起软总线服务端。

````
```bashopeneuler ~ # softbus_server_main >log.file &```
````

当服务端被拉起时，会主动通过名为ethX的网络设备进行coap广播，若探测到对端设备存在则会启动自组网。

**客户端API**

头文件在sdk和initrd中均存放在/usr/include/dsoftbus/下，其中：

1\. discovery\\\_service.h：发现模块头文件，支持应用主动探测和发布的API如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbhDX0ic1uibBfBXRecL2HMNiae7BpWIHJIRhuKQcJtyNEBwXiaRLTW896kmVPuWRnDFmaxFoTxWVuOUw/640?wx_fmt=png)

当服务端被拉起时，会主动通过名为ethX的网络设备进行coap广播，若探测到对端设备存在则会启动自组网。

2\. softbus\\\_bus\\\_center.h：组网模块头文件，支持获取组网内设备信息API如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbhDX0ic1uibBfBXRecL2HMNialmAgBibfpB6RAkCLJhtyKJjHLBOUVWSaoSx70TWt6EyMfib8ps6potyA/640?wx_fmt=png)

3\. session.h：连接/传输模块头文件，支持创建session和数据传输API如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMbhDX0ic1uibBfBXRecL2HMNiaByNnfibzmy59Q6M8tWzDMLgzdb3hRic8qicVufX9s6xOEibxw6Rk9otJicg/640?wx_fmt=png)

各API参数详见头文件描述。

**应用示例**

**1.编写客户端程序**

编写客户端程序依托于Embedded版本发布的SDK，按如下步骤进行SDK环境使用准备。

1.1 安装SDK

执行SDK自解压安装脚本

````
```bashsh openeuler-glibc-x86_64-openeuler-image-aarch64-qemu-aarch64-toolchain-22.03.sh ```
````

根据提示输入工具链的安装路径，默认路径是/opt/openeuler//；若不设置，则按默认路径安装；也可以配置相对路径或绝对路径。

举例如下：

````
```bashsh ./openeuler-glibc-x86_64-openeuler-image-armv7a-qemu-arm-toolchain-22.03.sh``openEuler embedded(openEuler Embedded Reference Distro) SDK installer version 22.03================================================================Enter target directory for SDK (default: /opt/openeuler/22.03): sdkYou are about to install the SDK to "/usr1/openeuler/sdk". Proceed [Y/n]? yExtracting SDK...............................................doneSetting it up...SDK has been successfully set up and is ready to be used.Each time you wish to use the SDK in a new shell session, you need to source the environment setup script e.g.. /usr1/openeuler/sdk/environment-setup-armv7a-openeuler-linux-gnueabi ```
````

1.2 设置SDK环境变量

前一步执行结束最后已打印source命令，运行即可。

````
```bash. /usr1/openeuler/myfiles/sdk/environment-setup-armv7a-openeuler-linux-gnueabi```
````

1.3 查看是否安装成功

运行如下命令，查看是否安装成功、环境设置成功。

````
```basharm-openeuler-linux-gnueabi-gcc -v```
````

接下来编写客户端程序。

      创建一个main.c文件，源码如下：

````
```c    #include "dsoftbus/softbus_bus_center.h"    #include <stdio.h>    #include <stdlib.h>    int main(void){        int32_t infoNum = 10;        NodeBasicInfo **testInfo = malloc(sizeof(NodeBasicInfo *) * infoNum);        int ret = GetAllNodeDeviceInfo("testClient", testInfo, &infoNum);        if (ret != 0) {            printf("Get node device info fail.\n");            return 0;        }        printf("Get node num: %d\n", infoNum);        for (int i = 0; i < infoNum; i++) {            printf("\t networkId: %s, deviceName: %s, deviceTypeId: %d\n",            testInfo[i]->networkId,            testInfo[i]->deviceName,            testInfo[i]->deviceTypeId);        }        for (int i = 0; i < infoNum; i++) {            FreeNodeInfo(testInfo[i]);        }        free(testInfo);        testInfo = NULL;        return 0;    }```
````

创建一个\`CMakeLists.txt\`文件，源码如下：

````
```bashproject(dsoftbus_hello C)add_executable(dsoftbus_hello main.c)target_link_libraries(dsoftbus_hello dsoftbus_bus_center_service_sdk.z)```
````

编译客户端

````
 ```bashmkdir buildcd buildcmake ..make```
````

编译完成后会得到\`dsoftbus\_hello\`。

**2. 构建QEMU组网环境**

在host中创建网桥br0

````
 ```bashbrctl addbr br0```
````

启动qemu1

````
```bashqemu-system-aarch64 -M virt-4.0 -m 1G -cpu cortex-a57 -nographic -kernel zImage -initrd <openeuler-image-qemu-xxx.cpio.gz> -device virtio-net-device,netdev=tap0,mac=52:54:00:12:34:56 -netdev bridge,id=tap0```
````

**注意**

首次运行如果出现如下错误提示：

````
```bashfailed to parse default acl file `/usr/local/libexec/../etc/qemu/bridge.conf'qemu-system-aarch64: bridge helper failed ```
````

则需要向指示的文件添加“allow br0”

````
```bashecho "allow br0" > /usr/local/libexec/../etc/qemu/bridge.conf```
````

启动qemu2

````
```bashqemu-system-aarch64 -M virt-4.0 -m 1G -cpu cortex-a57 -nographic -kernel zImage -initrd openeuler-image-qemu-aarch64-20220331025547.rootfs.cpio.gz  -device virtio-net-device,netdev=tap1,mac=52:54:00:12:34:78 -netdev bridge,id=tap1```
````

**注意**

qemu1与qemu2的mac地址需要配置为不同的值。

配置IP

````
配置host的网桥地址```bashifconfig br0 192.168.10.1 up```配置qemu1的网络地址```bashifconfig eth0 192.168.10.2```配置qemu2的网络地址```bashifconfig eth0 192.168.10.3```
````

分别在host、qemu1、qemu2使用ping进行测试，确保qemu1可以ping通qemu2。

**3. 启动分布式软总线**

````
在qemu1和qemu2中启动分布式软总线的服务端```bashsoftbus_server_main >log.file &```将编译好的客户端分发到qemu1和qemu2的根目录中```bashscp dsoftbus_hello root@192.168.10.2:/scp dsoftbus_hello root@192.168.10.3:/```
````

分别在qemu1和qemu2的根目录下运行\`dsoftbus\_hello\`，将得到如下输出：

````
qemu1```bash[LNN]NodeStateCbCount is 10[LNN]BusCenterClientInit init OK![DISC]Init success[TRAN]init tcp direct channel success.[TRAN]init succ[COMM]softbus server register service success![COMM]softbus sdk frame init success.Get node num: 1networkId: 714373d691265f9a736442c01459ba39236642c743a71750bb63eb73cde24f5f, deviceName: UNKNOWN, deviceTypeId: 0```qemu2```bash[LNN]NodeStateCbCount is 10[LNN]BusCenterClientInit init OK![DISC]Init success[TRAN]init tcp direct channel success.[TRAN]init succ[COMM]softbus server register service success![COMM]softbus sdk frame init success.Get node num: 1networkId: eaf591f64bab3c20304ed3d3ff4fe1d878a0fd60bf8c85c96e8a8430d81e4076,deviceName: UNKNOWN, deviceTypeId: 0```
````

qemu1和qemu2分别输出了发现的对方设备的基础信息。

**编译指导**

编译依托于Embedded版本发布的容器镜像，请参考容器构建指导进行容器环境准备。

容器构建指导链接：

&lt;https://docs.openeuler.org/zh/docs/22.03\_LTS/docs/Embedded/容器构建指导.html&gt;

**1. 下载脚本所在仓库**（例如下载到\`src/yocto-meta-openeuler\`目录下）

````
```bashgit clone https://gitee.com/openeuler/yocto-meta-openeuler.git -b openEuler-22.03-LTS -v src/yocto-meta-openeuler```
````

**2. 执行下载脚本**

````
 下载最新软总线代码:```bashsh src/yocto-meta-openeuler/scripts/download_code.sh dsoftbus```
````

代码默认下载到与\`yocto-meta-openeuler\`同级别的路径，如需修改软总线或者其依赖的模块代码可到对应路径下查找\`dsoftbus/\_standard\`和\`yocto-embedded-tools\`仓库进行对应修改。

**3. 编译编译脚本**

````
编译最新软总线代码:```bashsh src/yocto-meta-openeuler/scripts/compile.sh dsoftbus```
````

编译工作目录名为dsoftbus/\_build，编译生成件目录名为dsoftbus/\_output，二者均默认与yocto-meta-openeuler在同级别路径。

**-** 限制约束 **-**

1\. 仅支持局域网下的coap发现。WIFI/BLE等功能在后续版本中持续支持。

2\. 目前提供的IPC、SN号等软总线的依赖模块均为样例，仅支持双设备节点部署，client-server一对一部署的能力。期待后续与社区伙伴，根据实际场景共同对这些依赖模块进行实例化。

**-** 关注我们 **-**

Embedded 已经在 openEuler 社区开源。将开展一系列主题分享，如果您对 Embedded 的构建，应用感兴趣，欢迎围观和加入。

项目地址：

&lt;https://gitee.com/openeuler/yocto-meta-openeuler&gt;

欢迎大家多多 star、fork，多多参与社区开发，多多贡献。

**-** 进入交流群 **-**

如果您对嵌入式应用感兴趣，欢迎加入 openEuler Embedded&Yocto SIG 技术交流群，讨论 Embedded 和 Yocto 等相关技术。请扫描下方二维码加入群聊。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMbhDX0ic1uibBfBXRecL2HMNiaNm8qFazsoOMSic3SM6ibTdYgHrevf2Y0HNlTcdxN7ib8M9JkrsW5sr0eg/640?wx_fmt=jpeg)

欢迎扫码入群
