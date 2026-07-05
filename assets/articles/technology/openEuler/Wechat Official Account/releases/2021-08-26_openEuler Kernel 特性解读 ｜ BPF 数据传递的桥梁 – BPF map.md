# [openEuler Kernel 特性解读 ｜ BPF 数据传递的桥梁 – BPF map](https://mp.weixin.qq.com/s/jPIrKigiNgwj6j9gMGFfeg)

[OpenAtom openEuler](javascript:void%280%29;)*2021-08-26 19:15:49*

#### 什么是 MAP

map 是驻留在内核空间中的高效键值仓库（key/value store）。map 中的数据可以被 BPF 程序访问，如果想在多个 BPF 程序之间保存状态，可以将状态信息放到 map。map 还可以从用户空间通过文件描述符访问，可以在任意 BPF 程序以及用户空间应用之间共享。Map 就是它们之间的一个桥梁。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaVXKRz8qu4kp4NuuaMhJFhoJZ0WdYZFLhzdxK4l5wb0KuXnVgfSlSH03ic6DBo2pyJgLTUWUteQ2A/640?wx_fmt=png)

#### MAP 创建

只能在用户态创建，根据是否用户显式创建，可分为用户态程序创建和加载器创建两种方式。Map 创建后具有全局唯一的 id。BPF\_MAP\_CREATE 系统调用返回的是一个 BPF Map 的文件描述符。

###### 用户态程序创建

用户态程序主动调用 bpf(BPF\_MAP\_CREATE, …)系统调用，如下 kernel sample 示例：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaVXKRz8qu4kp4NuuaMhJFh5UKClmaCGV9hItSocKmCqdicGv4tSTG6olDJPUOib8sj0TQwqN0HNv3g/640?wx_fmt=png)

##### 加载器创建

Bpf 程序里面定义 map，如下：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaVXKRz8qu4kp4NuuaMhJFhFeC8Qv8uiaZLoiacETWwEHPXsibumAOjQ3y7mHvuoP2vUzYvF4kU6CXUA/640?wx_fmt=png)

编译器会创建名字为 maps 的 section，加载器会检查 maps section 下的 map 定义，以 bpftool 为例有如下调用路径帮忙创建 map：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaVXKRz8qu4kp4NuuaMhJFhzxEqLTN2LJia9qDv27EhUs1rVxrF1kYicMDOFPl0DtRT9VzJwQ9ajVCw/640?wx_fmt=png)

#### 访问 map

##### 用户态访问

用户态访问 map，有统一的系统调用，如下：

- int bpf\_map\_update\_elem(int fd, const void \*key, const void \*value, \_\_u64 flags); - sys\_bpf(BPF\_MAP\_UPDATE\_ELEM, …); // 更新，添加 map entry
- int bpf\_map\_lookup\_elem(int fd, const void \*key, void \*value); - sys\_bpf(BPF\_MAP\_LOOKUP\_ELEM, …); // 查找 map entry
- int bpf\_map\_delete\_elem(int fd, const void \*key); - sys\_bpf(BPF\_MAP\_DELETE\_ELEM, …); // 删除 map entry
- int bpf\_map\_get\_next\_key(int fd, const void \*key, void \*next\_key) - sys\_bpf(BPF\_MAP\_GET\_NEXT\_KEY, …); // 遍历 map entry
- int bpf\_map\_freeze(int fd) - sys\_bpf(BPF\_MAP\_FREEZE, …); // 设置 frozen 属性

##### BPF 程序访问

访问 bpf 程序，需要借助 bpf helper 函数，功能和上面对应：

- void \*bpf\_map\_lookup\_elem(struct bpf\_map \*map, const void \*key) // 查找 map entry
- long bpf\_map\_update\_elem(struct bpf\_map \*map, const void \*key, const void \*value, u64 flags) // 更新或添加 map entry
- long bpf\_map\_delete\_elem(struct bpf\_map \*map, const void \*key) // 删除 map entry

#### BPF MAP 生命周期

##### 持久化

BPF map 和程序作为内核资源只能通过文件描述符访问，其背后是内核中的匿名 inode，这种文件描述符受限于进程的生命周期，给多个 bpf 程序之间共享 map 带来了诸多不便。例如 tc 或 xdp 环境上，还需要有个常驻的用户态程序；在 data path 多个 hook 点上共享 map（如包统计， 配置等）。

为了解决这个问题，内核实现了一个最小内核空间 BPF 文件系统（https://lore.kernel.org/patchwork/cover/613343/），BPF map 和 BPF 程序 都可以 pin 到这个文件系统内，这个过程称为 object pinning。

相应的，添加了两个新 BPF 系统调用，分别用于钉住（`BPF_OBJ_PIN`）一个对象和获取（`BPF_OBJ_GET`）一个被钉住的对象（pinned objects）。

- int bpf\_obj\_pin(int fd, const char \*pathname)
- sys\_bpf(BPF\_OBJ\_PIN, …);
- int bpf\_obj\_get(const char \*pathname)
- fd = sys\_bpf(BPF\_OBJ\_GET, …);

##### 生命周期

BPF map 的生命周期通过 refcnt 管理，如下是各种操作对应的 refcnt 的变化。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaVXKRz8qu4kp4NuuaMhJFh8s3cAicticFC3XppaezvoGNVLBUbSZfVYyYXxGfz9wFsuw4fzKL6z1fQ/640?wx_fmt=png)

##### BPF MAP 类型

截止到 Linux Kernel 5.13 版本， 已有的 map 类型如下所示：

```
enum bpf_map_type {
BPF_MAP_TYPE_UNSPEC,
BPF_MAP_TYPE_HASH,
BPF_MAP_TYPE_ARRAY,
BPF_MAP_TYPE_PROG_ARRAY,
BPF_MAP_TYPE_PERF_EVENT_ARRAY,
BPF_MAP_TYPE_PERCPU_HASH,
BPF_MAP_TYPE_PERCPU_ARRAY,
BPF_MAP_TYPE_STACK_TRACE,
BPF_MAP_TYPE_CGROUP_ARRAY,
BPF_MAP_TYPE_LRU_HASH,
BPF_MAP_TYPE_LRU_PERCPU_HASH,
BPF_MAP_TYPE_LPM_TRIE,
BPF_MAP_TYPE_ARRAY_OF_MAPS,
BPF_MAP_TYPE_HASH_OF_MAPS,
BPF_MAP_TYPE_DEVMAP,
BPF_MAP_TYPE_SOCKMAP,
BPF_MAP_TYPE_CPUMAP,
BPF_MAP_TYPE_XSKMAP,
BPF_MAP_TYPE_SOCKHASH,
BPF_MAP_TYPE_CGROUP_STORAGE,
BPF_MAP_TYPE_REUSEPORT_SOCKARRAY,
BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE,
BPF_MAP_TYPE_QUEUE,
BPF_MAP_TYPE_STACK,
BPF_MAP_TYPE_SK_STORAGE,
BPF_MAP_TYPE_DEVMAP_HASH,
BPF_MAP_TYPE_STRUCT_OPS,
BPF_MAP_TYPE_RINGBUF,
BPF_MAP_TYPE_INODE_STORAGE,
BPF_MAP_TYPE_TASK_STORAGE,
};
```

对应 type 的含义及操作是在 include/linux/bpf\_types.h 文件中定义的

BPF\_MAP\_TYPE(BPF\_MAP\_TYPE\_ARRAY, array\_map\_ops) BPF\_MAP\_TYPE(BPF\_MAP\_TYPE\_PERCPU\_ARRAY, percpu\_array\_map\_ops) …

使用可以参考 samples/bpf/下的示例程序。

#### 常见 BPF map 类型

ARRAY Maps：

所有数组 key 为 4 字节，并且不支持删除值

- BPF\_MAP\_TYPE\_ARRAY：简单数组。Key 是数组索引，不能删除元素
- BPF\_MAP\_TYPE\_PERCPU\_ARRAY：同上，precpu
- BPF\_MAP\_TYPE\_PROG\_ARRAY：bpf\_tail\_call()用作跳转表的 BPF 程序数组， samples/bpf/sockex3\_kern.c
- BPF\_MAP\_TYPE\_PERF\_EVENT\_ARRAY：内核在 bpf\_perf\_event\_output() 中使用的数组映射，用于将跟踪输出与特定键相关联。用户空间程序将 fds 与每个键关联，并且可以 poll() 这些 fds 以接收数据已被跟踪的通知
- BPF\_MAP\_TYPE\_ARRAY\_OF\_MAPS：Map in map，外层 map 的 vaule 是内层 map 的 fd，相关用例可以参见内核源代码目录下 samples/bpf/test\_map\_in\_map\_kern.c

Hash Maps：

- key 的长度没有限制，但显然应该大于 0。
- 给定 key 查找 value 时，内部通过哈希实现，而非数组索引。
- key/value 是可删除的；作为对比，Array 类型的 map 中，key/value 是不可删除的（但用空值覆盖掉 value ，可实现删除效果）
- BPF\_MAP\_TYPE\_HASH: 最简单的哈希 map
- BPF\_MAP\_TYPE\_PERCPU\_HASH: percpu 的 hashmap
- BPF\_MAP\_TYPE\_LRU\_HASH：普通 hash map 的问题是有大小限制，超过最大数量后无法再插入了。LRU map 可以避 免这个问题，如果 map 满了，再插入时它会自动将最久未被使用（least recently used）的 entry 从 map 中移除
- BPF\_MAP\_TYPE\_LRU\_PERCPU\_HASH：percpu 的，同上
- BPF\_MAP\_TYPE\_HASH\_OF\_MAPS：map-in-map，外层 map 的 value 是内层 map 的 fd

其它类型：

- BPF\_MAP\_TYPE\_STACK\_TRACE：内核程序可以通过 bpf\_get\_stackid() 帮助程序存储堆栈
- BPF\_MAP\_TYPE\_LPM\_TRIE：最长前缀匹配，例如，用于存储/检索 IP 路由
- BPF\_MAP\_TYPE\_SOCKMAP：sockmaps 主要用于套接字重定向
- BPF\_MAP\_TYPE\_DEVMAP：与 sockmap 做类似的工作，使用 XDP 的 netdevices 和 bpf\_redirect()

##### 添加新的 BPF map 类型

- enum bpf\_map\_type {} - include/uapi/linux/bpf.h // 在 enum bpf\_map\_type 添加类型
- BPF\_MAP\_TYPE(BPF\_MAP\_TYPE\_XXX, yyy\_ops) - include/linux/bpf\_types.h //注册 ops - BPF\_MAP\_TYPE 宏，会添加这个 type 到全局 bpf\_map\_types 数组中
- 合适的位置实现 struct bpf\_map\_ops yyy\_ops
- 允许的 helper 函数 - 在 check\_map\_func\_compatibility 函数中添加兼容的 helper 函数

#### openEuler kernel SIG

##### openEuler kernel 仓库

openEuler kernel 源代码仓库：https://gitee.com/openeuler/kernel

欢迎大家多多 star、fork，多多参与社区开发，多多贡献补丁。

关于贡献补丁请参考：[如何参与 openEuler 内核开发](https://mp.weixin.qq.com/s?__biz=MzI2NDE4OTE2Mg%3D%3D&mid=2247487429&idx=1&sn=8d22d09679425d81c819260e84224f5b&scene=21#wechat_redirect)

#### openEuler kernel SIG 微信技术交流群

请扫描下方二维码添加小助手微信，或者直接添加小助手微信（微信号：openeuler-kernel），备注“交流群”或“技术交流”，加入 openEuler kernel SIG 技术交流群。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaVXKRz8qu4kp4NuuaMhJFheTJZyib2G2BJOric6aRLkn2hmWtMc8GiaqviajGTx9Gb56icLa8xlTSMJ1g/640?wx_fmt=png)

#### 引用

\[1] https://cloud.tencent.com/developer/article/1685332

\[2] https://arthurchiao.art/blog/cilium-bpf-xdp-reference-guide-zh/#13-maps

\[3] https://face-bookmicrosites.github.io/bpf/blog/2018/08/31/object-lifetime.html

\[4] https://www.programmersought.com/article/43327115854/

\[5] http://arthurchiao.art/blog/bpf-advanced-notes-2-zh/
