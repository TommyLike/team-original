# [StratoVirt 基于 Rust 的 balloon 功能实践](https://mp.weixin.qq.com/s/BxF1hD5pNsuskLEHPj8Mtw)

原创*杨铭*[OpenAtom openEuler](javascript:void%280%29;)*2021-12-14 20:53:55*

StratoVirt 是计算产业中面向云数据中心的企业级虚拟化 VMM，实现了一套架构统一支持虚拟机、容器、Serverless 三种场景。StratoVirt 在轻量低噪、软硬协同、Rust 语言级安全等方面具备关键技术竞争优势。

### 背景介绍：

通常，在同一台服务器上存在着不同的用户，而多数用户对内存的使用情况是一种间断性的使用。也就是说用户对内存的使用率并不是很高。在服务器这种多用户的场景中，如果很多个用户对于内存的使用率都不高的话，那么会存在服务器实际占用的内存并不饱满这样一种情况。实际上各个用户使用内存的分布图可能如下图所示（黄色部分表示 used 部分，绿色部分表示 free 的部分）。

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaiblO29CkhXwuTZgQzrSjfGlG8KEYeT4SAjbklPShpbxpAoeLADEUSbhT8y9asgBsiausdQCrK5L7Q/640?wx_fmt=png)

### 解决方案：

为了解决上述服务器上内存使用率低的问题，可以将虚拟机中暂时不用的内存回收回来给其他虚拟机使用。而当被回收内存的虚拟机需要内存时，由 host 再将内存归还回去。有了这样的内存伸缩能力，服务器便可以有效提高内存的使用率。在 StratoVirt 中，我们使用 balloon 设备来对虚拟机中的空闲内存进行回收和释放。下面详细了解一下 StratoVirt 中的 balloon 设备。

### balloon 设备简介：

由于 StratoVirt 只是负责为虚拟机分配内存，只能感知到每个虚拟机总的内存大小。但是在每个虚拟机中如何使用内存，内存剩余多少。StratoVirt 是无法感知的，也就无法得知该从虚拟机中回收多少内存了。为此，需要在虚拟机中放置一个“气球（balloon）”设备。该设备通过 virtio 半虚拟化框架来实现前后端通信。当 Host 端需要回收虚拟机内部的空闲内存时，balloon 设备“充气”膨胀，占用虚拟机内部内存。而将占用的内存交给 Host 使用。如果虚拟机的空闲内存被回收后，虚拟机内部由于业务要求突然需要内存时。位于虚拟机内部的 balloon 设备可以选择“放气”缩小。释放出更多的内存空间给虚拟机使用。

### balloon 实现：

balloon 的具体代码实现位于 StratoVirt 项目的/virtio/src/balloon.rs 文件中，相关细节可阅读代码理解。代码架构如下：

```
virtio
├── Cargo.toml
└── src
    ├── balloon.rs
    ├── block.rs
    ├── console.rs
    ├── lib.rs
    ├── net.rs
    ├── queue.rs
    ├── rng.rs
    ├── vhost
    │   ├── kernel
    │   │   ├── mod.rs
    │   │   ├── net.rs
    │   │   └── vsock.rs
    │   └── mod.rs
    ├── virtio_mmio.rs
    └── virtio_pci.rs
```

由于 balloon 是一个 virtio 设备，所以在前后端通信时也使用了 virtio 框架提供的 virtio queue。当前 StratoVirt 支持两个队列：inflate virtio queue（ivq）和 deflate virtio queue（dvq）。这两个队列分别负责 balloon 设备的“充气”和“放气”。

气球的充放气时，前后端的信息是通过一个结构体来传递。

```
struct VirtioBalloonConfig {
    /// Number of pages host wants Guest to give up.
    pub num_pages: u32,
    /// Number of pages we've actually got in balloon.
    pub actual: u32,
}
```

因此后端向前端要内存的时候，只需要修改这个结构体中的 num\_pages 的数值，然后通知前端。前端读取配置结构体中的 num\_pages 成员。并与本身结构体中的 actual 对比，判断是进行 inflate 还是 deflate。

- inflate

如果是 inflate，那么虚拟机以 4k 页为单位去申请虚拟机内存，并将申请到的内存地址保存在队列中。然后通过 ivq 将保存了分配好的页面地址的数组分批发往后端处理（virtio queue 队列长度最大 256，也就是一次最多只能传输 1M 内存信息，对于大于 1M 的内存只能分批传输）。后端通过得到信息后，找到相应的 MemoryRegion，将对应的 page 标记为”WILLNEED“。然后通知前端，完成配置。

- deflate

如果是 deflate 则从保存申请到的内存地址队列中弹出一部分内存的地址。通过 dvq 分批次传输给后端处理。后端将 page 标记为“DONTNEED"。

下面结合代码进行说明：

定义 BalloonIoHandler 结构体作为处理 balloon 事件的主体。

```
struct BalloonIoHandler {
    /// The features of driver.
    driver_features: u64,
    /// Address space.
    mem_space: Arc<AddressSpace>,
    /// Inflate queue.
    inf_queue: Arc<Mutex<Queue>>,
    /// Inflate EventFd.
    inf_evt: EventFd,
    /// Deflate queue.
    def_queue: Arc<Mutex<Queue>>,
    /// Deflate EventFd.
    def_evt: EventFd,
    /* 省略 */
}
```

其中包含上述的两个 virtio 队列`inf_queue`和`def_queue`，以及对应的触发事件描述符（EventFd）`inf_evt`和`def_evt`。两个队列均使用了`Mutex`锁，保证了队列在同一时刻只有一个使用者对该队列进行操作。保证了多线程共享的数据安全。

```
fn process_balloon_queue(&mut self, req_type: bool) -> Result<()> {
    let queue = if req_type {
        &mut self.inf_queue
    } else {
        &mut self.def_queue
    }; //获得对应的队列
    let mut unlocked_queue = queue.lock().unwrap();
    while let Ok(elem) = unlocked_queue
        .vring
        .pop_avail(&self.mem_space, self.driver_features)
    {
        match Request::parse(&elem) {
            Ok(req) => {
                if !self.mem_info.has_huge_page() {
                    // 进行内存标记
                    req.mark_balloon_page(req_type, &self.mem_space, &self.mem_info);
                }
                /* 省略 */
            }
            Err(e) => {
                /* 省略错误处理 */
            }
        }
    }
    /* 省略 */
}
```

当相应的`EventFd`被触发后`process_balloon_queue`函数将会被调用。通过判断请求类型确定是“充气”还是”放气“，然后再从相应的队列中取数据进行内存标记。其中`while let`是 Rust 语言提供的一种循环模式匹配机制。借助该语法可以将队列中 pop 出来的所有数据遍历取出到`elem`中。

### 内存标记及优化：

标记内存在`mark_balloon_page`函数中进行实现，起初的实现思路为：将虚拟机传送过来的地址逐个进行标记。即，从队列中取出一个元素，转化为地址后立即进行标记。后来经过测试发现：balloon 设备在对页地址进行一页一页标记内存时花费时间巨大。而同时也发现通过虚拟机传回来的地址中有大段的连续内存段。于是通过改变标记方法：由原来的一页一页标记改为将这些连续的内存统一标记。大大节省了标记时间。下面代码为具体实现：

```
fn mark_balloon_page(
        &self,
        req_type: bool,
        address_space: &Arc<AddressSpace>,
        mem: &BlnMemInfo,
    ) {
        let advice = if req_type {
            libc::MADV_DONTNEED
        } else {
            libc::MADV_WILLNEED
        };
        /* 略 */
        for iov in self.iovec.iter() {
            let mut offset = 0;
            let mut hvaset = Vec::new();
            while let Some(pfn) = iov_to_buf::<u32>(address_space, iov, offset) {
                offset += std::mem::size_of::<u32>() as u64;
                let gpa: GuestAddress = GuestAddress((pfn as u64) << VIRTIO_BALLOON_PFN_SHIFT);
                let hva = match mem.get_host_address(gpa) {
                    Some(addr) => addr,
                    None => {
                        /* 略 */
                    }
                };
                //将hva地址保存在hvaset的vec中
                hvaset.push(hva);
            }
            //对hvaset进行从小到大排序。
            hvaset.sort_by_key(|&b| Reverse(b));
            /* 略 */
                //将hvaset中连续的内存段进行标记
                while let Some(hva) = hvaset.pop() {
                    if last_addr == 0 {
                        free_len += 1;
                        start_addr = hva;
                    } else if hva == last_addr + BALLOON_PAGE_SIZE {
                        free_len += 1;
                    } else {
                        memory_advise(
                            start_addr as *const libc::c_void as *mut _,
                            (free_len * BALLOON_PAGE_SIZE) as usize,
                            advice,
                        );
                        free_len = 1;
                        start_addr = hva;
                    }

                    if count_iov == iov.iov_len {
                        memory_advise(
                            start_addr as *const libc::c_void as *mut _,
                            (free_len * BALLOON_PAGE_SIZE) as usize,
                            advice,
                        );
                    }
                    count_iov += std::mem::size_of::<u32>() as u64;
                    last_addr = hva;
                }
            /* 略 */
        }
    }
}
```

首先将 virtio 队列中的地址全部取出，并保存在 vec 中，然后将该 vec 进行从小到大的排序。有利于快速找出连续的内存段并进行标记。由于 hvaset 中的地址是按照从小到大排列的，因此可以从头开始遍历 hvaset，遇到不连续的地址后将前面的连续段进行标记。这样就完成了由原来逐页标记到连续内存段统一标记的优化。

经过测试，StratoVirt 的 balloon 速度也有了极大的提高。

## 关注我们

StratoVirt 当前已经在 openEuler 社区开源。后续我们将开展一系列主题分享，如果您对 StratoVirt 的使用和实现感兴趣，欢迎您围观和加入。

项目地址：https://gitee.com/openeuler/stratovirt

项目 wiki：https://gitee.com/openeuler/stratovirt/wikis

您也可以订阅邮件列表：https://mailweb.openeuler.org/postorius/lists/virt.openeuler.org/

如有疑问，也欢迎提交 issue：https://gitee.com/openeuler/stratovirt/issues

## 入群

如果您对虚拟化技术感兴趣，可以进入 openEuler StratoVirt 主页查找相关资源（点击阅读原文进入项目主页，https://www.openeuler.org/zh/other/projects/stratovirt/），包括安装指导、虚拟机配置、代码仓库、学习资料等。也欢迎加入Virt SIG 技术交流群，讨论 StratoVirt、KVM、QEMU 和 Libvirt 等相关虚拟化技术。感兴趣的同学可以添加如下微信小助手，回复 StratoVirt 入群。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMaiblO29CkhXwuTZgQzrSjfGgucLqfVzYYToe0GmbHgl6sCsJXtgCogGQPibw4WQO9XTCARq3wPgEcQ/640?wx_fmt=jpeg)
