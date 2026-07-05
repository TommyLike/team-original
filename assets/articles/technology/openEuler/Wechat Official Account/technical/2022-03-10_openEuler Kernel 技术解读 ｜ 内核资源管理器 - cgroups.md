# [openEuler Kernel 技术解读 ｜ 内核资源管理器 - cgroups](https://mp.weixin.qq.com/s/D-gzbB3oxvTV81INEyOPUQ)

*Kernel SIG*[OpenAtom openEuler](javascript:void%280%29;)*2022-03-10 19:23:49*

## 什么是 cgroups

cgroups 是 control groups 的缩写，是 Linux 内核提供的一种对进程进行分组管理；限制或记录进程所使用的资源的机制。

cgroups 的相关概念如下：

**「任务(task)」** : 系统中一个进程，在内核中相关信息都存储在 struct task\_struct 结构体中；

**「层级(hierarchy)」** ：cgroups 以树的形式进行组织，每一颗树称之为一个层级；

**「子系统(subsystems)」** ：资源控制器。

三者的关系如下图所示

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYHb7fKEibay75aSYsymbaNFOvicHLyZe8wdUfLvhq69wVZmr7PXYREp5CEYdQ5xxMAGBvk6ERtgoeQ/640?wx_fmt=png)

每一个任务都由一个或者多个进程构成。这些进程被划分在不同的目录中，这些目录以层级的形式进行组织。一个层级上面挂载一个或者多个子系统，这个层级用来管理这些进程所附属子系统的资源。

## cgroups 的分类

目前 cgroups 有 cgroupv1 和 cgroupv2 两种文件系统，目前内核中两种文件系统的功能都支持，用户可以根据自己的需求选择使用其中的一种或者选择兼容的模式。

cgroupv1 与 cgroupv2 的差异如下表所示：

cgroupv1cgroupv2进程可以存在于任一节点中进程只能存在与根节点和叶子节点中，中间节点用来对资源进行控制，实现了 cgroups 代表进程分组，子系统应用于资源控制各个子系统单独工作，很难实现协同合作（writeback 功能）所有子系统挂在统一层级，可以实现多系统协同工作memcg 资源限制手段简单，仅有 limit\_in\_bytes 的限制，实际业务无法很好平衡采用分级管理的调节手段，可以提高性能，解决临时内存峰值的情况，缓解不同业务之间的性能影响不支持 rootless支持 rootless不支持 PSI 功能支持 PSI 功能

cgroupv1 vs cgroupv2

cgroupv1 的管理方式举例如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYHb7fKEibay75aSYsymbaNFX5JZPytR4nLWzbO7qgDGm7t89WiaiaOIELegtpiauLOFibT0eReibkFY4icA/640?wx_fmt=png)

cgroupv1管理方式

cgroupv2 的管理方式举例如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYHb7fKEibay75aSYsymbaNFsDIvQe7kMNmtvLJqdicj5wC3YANw2pM5YqavVPiaibha2uP9WRk4HRlsw/640?wx_fmt=png)

cgroupv2管理方式

## cgroups 子系统介绍

子系统功能memory设置内存使用限制，统计内存使用情况HugeTLB限制透明大页的使用量cpu限制进程的 cpu 使用率cpuset为进程分配 cpu/mem 节点cpuacct统计 cpu 的使用情况blkio为块设备设定输入/输出限制devices允许或者拒绝进程访问设备net\_cls标记进程的网络数据包，并进行控制net\_prio动态配置进程每个网络接口的流量优先级freezer挂起或者回复进程

## cgourps 的主要数据结构

cgroups 主要的数据结构以及之间的关系如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYHb7fKEibay75aSYsymbaNFNiaN4W2aeEOnol5zf6o2iccCeQ2mjCiayjNPia8m9tD73YSJVv8hg1YgDA/640?wx_fmt=png)

cgroups主要数据结构

cgroups 是用来管理进程的一种机制，所以我们从进程入手，对 cgroups 的主要数据结构进行分析。在 Linux 中，管理进程的数据结构是`struct task_struct`,其中，与 cgroups 相关的数据结构如下所示：

```
struct task_struct {
    #ifdef CONFIG_CGROUPS
     /* Control Cgroup info protected by css_set_lock: */
     struct css_set __rcu  *cgroups;
     /* cg_list protected by css_set_lock and tsk->alloc_lock: */
     struct list_head   cg_list
}
```

1）cg\_list 是一个 list\_head 的结构，用于将指向同一个 css\_set 数据结构的所有进程组织成一个链表；

2）struct css\_set 结构体包含了与进程相关的所有 cgroups 的信息。

```
struct css_set {
 /*
  * Set of subsystem states, one for each subsystem. This array is
  * immutable after creation apart from the init_css_set during
  * subsystem registration (at boot time)
  */
     struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
    /* internal task count, protected by css_set_lock */
     int nr_tasks;
    /*
     * List running through all cgroup groups in the same gash
     * slot. Protected by css_set_lock
     */
     struct hlist_node hlist;
    /* List of cgrp_cset_links pointing at cgroups referenced from this
     * css_set. Protected by css_set_lock.
     */
     struct list_head cgrp_links;
}
```

1）nr\_tasks 是指向该 css\_set 的进程数；

2）css\_set 的数据结构通过 hash 表进行存储；hlist 是嵌入的 hlist\_node，用于把所有 css\_set 组织成一个 hash 表；

3）cgrp\_links 是指向一个 struct cgrp\_cset\_link 连成的链表，后面会进行讲解；

4）subsys 是一组指向 struct cgroup\_subsys\_state 指针的指针数组；CGROUP\_SUBSYS\_COUNT 是内核中支持子系统的最大值；每一个 cgroup\_subsys\_state 存储的是进程的某一个子系统的相关信息。

```
struct croup_subsys_state {
 /* PI: the cgroup that this css is attached to */
  struct cgroup *cgroup;
 /* PI: the cgroup subsystem that this css is attached to */
     struct cgroup_subsys *ss;
    /* reference count - access via css_[try]get() and css_put() */
     struct percpu_ref refcnt;
    /* siblings list anchored at the parent's ->children */
     struct list_head sibling;
     struct list_head children;
    /*
     * PI: the parent css.>-Placed here for cache proximity to following
     * fields of the containing structure.
     */
      struct cgroup_subsys_state *parent;
}
```

1. refcnt 是该 cgroup\_subsys\_state 引用的次数，只有当这个参数为 0 时，该数据结构才能被释放；
2. sibling children 和 parent 将同一层级的 cgroup 连接层一颗树；
3. cgroup 是指向 struct cgroup 的一个指针，也就是进程属于的 cgroup。对于用户来说，即 cgroups 中的目录。一个 struct cgroup 存储了一个目录的相关信息；
4. ss 是指向 struct cgroup\_subsys 的一个指针，里面主要是一些钩子函数的定义，涉及 cgroups 用户态地一系列操作，对应的具体实现在对应的子系统中。

```
strcut cgroup {
 /* self css with NULL ->ss, points back to this cgroup */
     struct cgroup_subsys_state self;
    /* Private pointers for each registered subsystem */
     struct cgroup_subsys_state *subsys[];
    /*
     * List of cgrp_cset_links pointing at css_sets with tasks in this
     * cgroup. Protected by css_set_lock.
     */
     struct list_head cset_links;
    struct cgroup_root *root;
}
```

1. self 指向的 cgroup\_subsys\_state 为当 struct cgroup\_subsys\_state 中 ss 为 NULL 是的结构体，存储的是当前 cgroup 本身的一些信息；
2. subsys 是一组指向 cgroup\_subsys\_state 的指针，存储的是当前目录锁绑定的子系统的信息；
3. cset\_links 指向一个由 struct cgrp\_cset\_links 连成的链表；
4. root 指向一个 struct cgroup\_root 的结构，存储了 root cgroup 中的信息。

```
struct cgroup_subsys {
    struct cgroup_subsys_state *(css_alloc)(struct cgroup_subsys_state *parent_css);
    int (*css_online)(struct cgroup_subsys_state *css);
    void (*css_offline)(struct cgroup_subsys_state *css);
    int (*can_attach)(struct cgroup_taskset *tset);
    int (*can_fork)(struct task_struct *task, struct css_set *cset);
}
```

struct cgroup\_subsys 定义了一组操作，让各个子系统根据各自的需求去实现，包括常见的申请销毁，上下线，任务迁移复制等。

```
struct cgroup_root {
 /* A list running through the active hierarchies */
     struct list_head root_list;
    /* Number of cgroups in the hierarchy, used only for /proc/cgroups */
     atomic_t nr_cgrps;
    /* The root cgroup. Root is destroyed on its release. */
     struct cgroup cgrp;
}
```

1. root\_list 是一个嵌入的 list\_head，用于将系统所有的层级连成链表；
2. nr\_cgrps 代表该层级有多少个 cgroup；
3. cgrp 指向该层级的 root cgroup；

**「struct cgroup 和 struct css\_set 之间是多对多的关系：」**

1 个 cgroup 中有多个进程，每一个进程可能对应不同的 scss\_set，所以 1 个 cgroup 可能对应多个 css\_set；

1 个 css\_set 对应的进程，不同的子系统对应不同的目录，所以 1 个 css\_set 对应多个 cgroup；

从 struct css\_set 访问 struct cgroup：struct css\_set-&gt;struct cgroup\_subsys\_state-&gt;struct cgroup；

反之用现有的结构体很难达到，所以要引入一个 struct cgrp\_cset\_link 的结构体将两者联系起来：

```
struct cgrp_cset_link {
    /* the cgroup and css_set this link associates */
     struct cgroup  *cgrp;
     struct css_set  *cset;
    /* list of cgrp_cset_link anchored at cgrp->cset_links */
     struct list_head cset_link;
    /* list of cgrp_cset_links anchored at css_set->cgrp_links */
     struct list_head cgrp_link;
}
```

struct cgroup 和 struct css\_set 对应获取的路径入下图所示，绿色箭头为 css\_set-&gt;cgroup，蓝色箭头为 cgroup-&gt;css\_set

!\[css\_set vs cgroup](./css\_set vs cgroup.png)

## cgroups 使用方法（以 cgroupv1 为例）

**「cgroups 文件系统挂载」**

`mount -t cgroup -o subsystems name /path`

subsystems: 表示需要挂载的 cgroups 子系统；

name：表示创建文件系统的名字；

/path：表示挂载点

**「cgroups 创建目录」**

`mkdir dir_name`

dir\_name: 子 cgroup 的目录名；

cgroups 文件系统的挂载路径为 root cgroup 的路径，在 root cgroup 下调用 mkdir 则可以创建子 cgroup 目录。

**「cgroups 迁移任务」**

`echo task_pid > /path/cgroup.procs`

task\_pid：需要迁移的进程号；

/path：需要迁移的 cgroups 的目录；

## memcg 简介

**「memcg 的作用」**

将系统中一些进程的内存资源通过某种限制进行隔离，从而导致不同的内存处理行为。

**「memcg 的特点」**

1. 可以统计匿名页，文件页，swap 等的使用量，并且对一个 cgroup 中这些类型的内存上限进行限制；
2. Pages 映射到的是对应每一个 memcg 的 LRU 链表；
3. 迁移任务时可以根据业务需求选择是否将迁移前任务的内存统计到新的 memcg 中；
4. 可以对一些行为，例如：触发 memcg 级别 oom，内存压力过大等统计发生的次数；
5. 实际业务中，root memcg 的 limit 是不做限制的。

memcg 的常见页面如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYHb7fKEibay75aSYsymbaNF46EnCVJfGmVib1HvaNgVZstlGOTA9B3Jk18gdkNnm4o6UZZVuBXDXXw/640?wx_fmt=png)

memcg界面

**「memcg 常见操作」**

挂载/卸载 memcg 子系统操作：

```
mount -t cgroup -o memory [name] [dir]
umount [dir]
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYHb7fKEibay75aSYsymbaNFXwnWicoN2YiaHrh86AInVyrKy9pJQLQk246K821hEwuOWeibWvnllG4WQ/640?wx_fmt=png)

memcg挂载卸载操作

通过 memcg 的内存限制对 memcg 中的进程进行隔离：

```
/* 对memcg进行内存上限的限制 */
echo xxx > /[memcg_dir]/memory.limit_in_bytes
cat /[memcg_dir]/memory_limit_in_bytes
/* 迁移一个进程到指定的memcg */
echo [pid] > /[memcg_dir]/cgroup.procs
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYHb7fKEibay75aSYsymbaNFh2nt0RQ1yGvowKpIr9U0fk2wlWjriblCfgY2ntNH7XksKqEOmq2ib3Aw/640?wx_fmt=png)

memcg进程隔离

获取当前 memcg 的内存使用量：

```
cat /[memcg_dir]/memory.usage_in_bytes
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYHb7fKEibay75aSYsymbaNF7zSBwdPRXibOtxe3oQ3pgjKdAlelgsicKuaW1b07MQbrtzSDQeTMYOSQ/640?wx_fmt=png)

usage\_in\_bytes

获取当前 memcg 的某些类别内存的使用量：

```
cat /[memcg_dir]/memory.stat
```

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYHb7fKEibay75aSYsymbaNFicRkz6EY3rdzjqpsRbcpGv6pzbWI0Y03GibWOiccMhKuYfy3tShPg137Q/640?wx_fmt=png)

memory.stat1

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYHb7fKEibay75aSYsymbaNFT6h4GAGCO3oKuLn986Wg0gzCicvTO6Y6uMfEtPX47mvIu4ZIVHL5zew/640?wx_fmt=png)

memory.stat2

## cgroups 的用途

1. **「资源限制」**：cgroups 可以对进程使用的资源总额进行限制，资源包括 memory，cpu， io；
2. **「优先级分配」**：cgroups 可以通过对 cpu 时间片的限制以及 block io 的带宽大小，间接对进程进行优先级分配；
3. **「资源统计」**：cgroups 可以对进程使用的资源进行统计，资源包括 memory，cpu 等；
4. **「进程控制」**：cgroups 中的 freezer 子系统可以对进程进行挂起/恢复等操作；

cgroups 广泛用于容器场景，同时为不同用户层面的资源管理，提供了一个统一化接口。实现了从单个进程的资源控制到操作系统层面的虚拟化。

## openEuler 有关 cgroups 的增强

1. 使能了 files cgroup，实现了对进程组打开文件数的控制，从而实现了进程隔离；
2. 在发生 OOM 时，优先 kill 调 offline 的 memcg 中的进程，保障 online 业务的进行；
3. 将 cgroupv2 实现的内存分类在 cgroupv1 中实现，从而减弱兄弟 cgroup 之间的性能影响，解决某些任务出现内存短时间高峰的问题；
4. 实现 memcg 级别的后台回收，使得可以及时回收 memcg 的 dirty 内存，解决某些任务短时间内产生大量 dirty 内存大师没有达到全局回收 dirty 标准，从而使任务出现问题；
5. 对 online 任务和 offline 任务进行分组，调度器根据分组，从而优先选择 online 任务，保障 online 业务优先进行；

## openEuler Kernel SIG

- openEuler kernel 源代码仓库：https://gitee.com/openeuler/kernel 欢迎大家多多 star、fork，多多参与社区开发，多多贡献补丁。关于贡献补丁请参考：如何参与 openEuler 内核开发
- openEuler kernel 微信技术交流群 请扫描下方二维码添加小助手微信，或者直接添加小助手微信（微信号：openeuler-kernel），备注“交流群”或“技术交流”，加入 openEuler kernel SIG 技术交流群。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMYHb7fKEibay75aSYsymbaNFWdcyylRcezYROBYuQzUMJVnKF3EDHBuiaUJQytAWrpib3uPYkNqlcuiaA/640?wx_fmt=png)
