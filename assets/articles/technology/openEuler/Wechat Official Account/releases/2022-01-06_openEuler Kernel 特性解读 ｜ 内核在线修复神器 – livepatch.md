# [openEuler Kernel 特性解读 ｜ 内核在线修复神器 – livepatch](https://mp.weixin.qq.com/s/xWV8eSIQAoP91AkZneJyAw)

*Kernel SIG*[OpenAtom openEuler](javascript:void%280%29;)*2022-01-06 18:43:28*

## 什么是 livepatch

Livepatch 即内核热补丁，通常在系统不可重启的情况下，用于修复内核以及内核模块的函数 bug。简单地说，livepatch 将待修复函数的开头几条指令替换为特定的跳转指令，让其跳转至修复函数中，这样该函数每次被调用，都会自动执行替换后的函数，达到修复函数的效果。

openEuler 上的 livepatch 与 linux 主线上的实现略有不同，主要是 openEuler 上采用的方法是直接修改指令，而 linux 主线上采用的方法是基于 ftrace 实现跳转。Linux 社区主线采用的 ftrace 方案，新函数运行前必须先跳转至`ftrace_caller`中，并且通过`klp_ftrace_handler`将 ip 值修改为新函数的地址，最后才能执行新函数的指令。整个流程相对来说比较冗长，每次运行都需要跳转至`ftrace_caller`中查找`klp_ftrace_handler`，效率较低。而 openEuler 上的方案，在运行时直接跳转至新函数，无需经过中转，效率较高。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMamc0OX9aVbJ1uwIHsBtd1PSRnBicRj1ianFsKYnbS8fTpx7aSpOY85GqXVQtNOm2zuf5957AATltiaQ/640?wx_fmt=png)

## livepatch 全局框架

Livepatch 主要涉及到内核的 livepatch 模块、用户态 kpatch 工具以及制作生成的热补丁 ko 三个大块，各个部分的关系如下图所示。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMamc0OX9aVbJ1uwIHsBtd1PmlicGIicwtBZWLWZibGwTMSXbf3J0Wc5SKdpjvo3fib2Mmx9RbsknCD0hw/640?wx_fmt=png)

在编译内核后，需要提供热补丁 patch，编译时的`.config`，编译后的 vmlinux 以及内核源码目录给 kpatch 工具，由 kpatch 工具中的`kpatch-build`脚本生成对应的热补丁 ko。热补丁 ko 中会包含数据以及新函数的指令，当热补丁 ko 插入内核后，会经过 module 处理，再到 livepatch 进行初始化。当命令行输入激活指令后，livepatch 会将老函数的前几条指令进行替换，跳转至热补丁 ko 中的新函数上，从而实现老函数的修复动作。此后，每次调用老函数，都会经过前几条跳转指令跳转至新函数上执行。

## livepatch 内部框架

热补丁内部主要暴露的直接接口有`klp_register_patch`和`klp_unregister_patch`，分别用于注册和卸载热补丁。在热补丁 ko 的 init 函数和 exit 函数中会对应地进行调用。热补丁内部还有两个非直接暴露，但是可以通过命令调用的接口`__klp_enable_patch`和`__klp_disable_patch`，分别用于激活以及去使能热补丁。

如下图所示，热补丁注册过程中会执行的操作大致包含以下几个部分：符号重定向、jump\_label 初始化以及 hook 函数执行。热补丁激活以及去使能过程中会执行栈检查以及指令替换的操作。当热补丁卸载时，需要执行 hook 函数以及资源回收。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMamc0OX9aVbJ1uwIHsBtd1Pp0FyibffBtEmEbrmE7yjzEzEhQcuqu9IdCicoNB5mD49oRaBZ23UENtw/640?wx_fmt=png)

## 热补丁函数管理

Livepatch 允许对单个函数打多个 patch，也允许单个 patch 中对多个函数进行修改。基于此，需要对大量的热补丁函数进行规范化管理。

如下图所示，在内核有一个全局链表管理所有的已经激活的 livepatch 函数，横向管理的数据结构是`klp_func_node`，表示不同的热补丁函数，此链表上的所有函数可以乱序地去使能（比如先 disable C 函数再 disable A 函数）。纵向管理的数据结构是`klp_func`，表示同一个函数的多个热补丁版本，此链表上的多个版本，只允许去使能最后一个（去使能后从链表摘除），并且生效的永远是链表上的最后一个（比如 A 函数激活了四个补丁，分别是 A1、A2、A3、A4，此时生效的是 A4，当去使能时，只能去使能 A4，并且去使能后 A4 从链表摘除，并且 A3 生效）。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMamc0OX9aVbJ1uwIHsBtd1P1bEgh5tRIMhgxic9icGbJUwS9OpJg5jiauWx40Xe74bJlxW2v6A19Kcgw/640?wx_fmt=png)

## livepatch 实现流程

如下图所示，初始目标是将内核函数 func A 通过一个 patch 的修改变为 func A’。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMamc0OX9aVbJ1uwIHsBtd1PxsPyPWwQu116N5zuUDxaKOxfeLicxoibVDKMRXELwqv9nzPMq3optLOA/640?wx_fmt=png)

首先需要将 vmlinux、.config 文件以及对应的 patch 提供给 kpatch 工具，用以生成 livepatch.ko 文件。如下图所示，livepatch.ko 文件中包含三大部分，第一部分是`.klp.rela.xxx`段，用于存储需要重定向的符号；第二个部分是数据段，主要用于存储`klp_patch`、`klp_object`、`klp_func`等数据；第三个部分是代码段，除了热补丁调用相关的代码之外，最主要的就是 func A’函数，也就是打上热补丁后的新函数。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMamc0OX9aVbJ1uwIHsBtd1PA3B2kP7Rl6FwdjiabibREpOekubQSJvGic5rbD114JtPnVSyWgIyFicbXQ/640?wx_fmt=png)

接下来需要将生成的 livepatch.ko 插入内核中，如下图所示，livepatch.ko 插入内核之后，会通过`module_init`模块，将 livepatch.ko 中包含的内核中的`EXPORT_SYMBOL`重定向。然后通过 ko 中的 init 函数，调用 livepatch 模块中的`klp_register_patch`接口。在此过程中，livepatch 将`klp_patch`数据结构挂在全局的`klp_patches`链表上管理起来，并且执行符号重定向（对象是`.klp.rela.xxx`段中的符号，这些符号都不是`EXPORT_SYMBOL`）、函数长度校验（若函数长度小于需要修改的指令条数，则不允许打热补丁）、jump\_label 初始化（此处涉及到地址跳转，需要刷新以保证正确性）、load\_hook 函数执行。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMamc0OX9aVbJ1uwIHsBtd1PpkfOhTbmjdoIEPbg4VZ5RtMpoeWm1ZZST9MibiajJSicLG3J4GHibpcNLw/640?wx_fmt=png)

最后通过命令`echo 1 > /sys/kernel/livepatch/xxxx/enable`进行激活，自动调用 livepatch 中的`__klp_enable_patch`接口。在此过程中，livepatch 模块会陷入`stop_machine中`，将所有的 cpu 暂停工作，切换至 migration 线程上执行。其中只有 CPU 会执行热补丁激活的动作，其余 CPU 执行`cpu_relax`操作。在热补丁 CPU 上，会执行以下几个动作：一是进行 kprobe 检查，若是待修改的函数上有 kprobe 点则不允许使用热补丁修改，理由是同时存在指令修改，可能会互相覆盖，产生预料外的结果；二是进行栈检查，检查所有线程，保证待修改的函数都不在线程栈上；三是执行指令修改，将待修改函数的前几条指令修改为跳转指令，使其跳转至 livepatch.ko 中的新函数上。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMamc0OX9aVbJ1uwIHsBtd1PyMHr4R5ehk8mlq4hN9kjDI7K22GXGt6TUnSazicwkJpykww9ibjBj4eg/640?wx_fmt=png)

## livepatch 使用

内核热补丁功能需要使能以下这些 config：

```
CONFIG_HAVE_LIVEPATCH_WO_FTRACE=y
CONFIG_LIVEPATCH=y
CONFIG_LIVEPATCH_WO_FTRACE=y
CONFIG_LIVEPATCH_STOP_MACHINE_CONSISTENCY=y
CONFIG_LIVEPATCH_RESTRICT_KPROBE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_DEBUG_INFO=y
```

制作热补丁 ko 有两种方式，第一种方式是通过编写模块代码的方式，可以参考内核源码的`samples/livepatch/livepatch-sample.c`文件。如下所示，编写的过程需要构造关键的数据结构，包括`klp_func`、`klp_object`、`klp_patch`。

```
static struct klp_func funcs[] = {
 {
  .old_name = "cmdline_proc_show",
  .new_func = livepatch_cmdline_proc_show,
 }, { }
};

static struct klp_object objs[] = {
 {
  /* name being NULL means vmlinux */
  .funcs = funcs,
  .hooks_load = hooks_load,
  .hooks_unload = hooks_unload,
 }, { }
};

static struct klp_patch patch = {
 .mod = THIS_MODULE,
 .objs = objs,
};
```

然后就是热补丁函数，以及通过 init 函数调用`klp_register_patch`接口。

```
static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
{
 seq_printf(m, "%s\n", "this has been live patched");
 return 0;
}
```

```
static int livepatch_init(void)
{
 return klp_register_patch(&patch);
}

static void livepatch_exit(void)
{
 WARN_ON(klp_unregister_patch(&patch));
}
```

第二种方式是通过 kpatch 工具来制作（可以参考https://gitee.com/src-openeuler/kpatch），大致的流程如下：①安装kpatch工具：`yum install kpatch kpatch-runtime`；②准备好一个修改函数内容的patch；③`export NO_PROFILING_CALLS=1`；④设置对应的ARCH和CROSS\_COMPILE（如果是在本机使用则无需设置）；⑤在kpatch-build目录下执行：`./kpatch-build -s <src dir> -v <src dir>/vmlinux <patch dir>/xxxx.patch --skip-gcc-check -c <src dir>/.config`。

得到热补丁 ko 之后，使用比较简单，大致内容如下：

? 插入内核：`insmod xxx.ko`? 激活热补丁：`echo 1 > /sys/kernel/livepatch/xxx/enabled`? 去使能热补丁：`echo 0 > /sys/kernel/livepatch/xxx/enabled`? 卸载 ko：`rmmod xxx`? 查询当前热补丁状态：`cat /proc/livepatch/state`

## livepatch 实例

① 准备好 patch。可用`git format-patch`来生成：`git format-patch -1`。注意：生成 patch 后记得回退该补丁；

```
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6204,6 +6204,7 @@ void cgroup_exit(struct task_struct *tsk)
  struct css_set *cset;
  int i;

+ printk("livepatch: out of cgroup\n");
  spin_lock_irq(&css_set_lock);

  WARN_ON_ONCE(list_empty(&tsk->cg_list));
```

② 使用 kpatch 工具制作生成 livepatch，-s 表示源码路径，-c 表示.config，-v 表示 vmlinux；

```
./kpatch-build -s /home/yeweihua/projects/hulk/hulk-5.10/ -c build/.config -v build/vmlinux --skip-gcc-check /home/yeweihua/projects/hulk/hulk-5.10/0001-test.patch
```

③ 将生成的热补丁插入内核；

```
insmod livepatch-0001-test.ko
```

④ 将热补丁激活；

```
echo 1 > /sys/kernel/livepatch/livepatch_0001_test/enabled
```

⑤ 验证热补丁是否生效（`cgroup_exit`函数只要进程退出便会执行）；

```
/modules # ls
[  382.479847] livepatch: out of cgroup
livepatch-0001-test.ko
```

⑥ 去使能热补丁；

```
echo 0 > /sys/kernel/livepatch/livepatch_0001_test/enabled
```

⑦ 查询当前系统的热补丁状况；

```
/modules # cat /proc/livepatch/state
Index    Patch                              State
----------------------------------------------------
1        livepatch_0001_test                disabled
----------------------------------------------------
```

⑧ 卸载热补丁

```
rmmod livepatch-0001-test.ko
```
