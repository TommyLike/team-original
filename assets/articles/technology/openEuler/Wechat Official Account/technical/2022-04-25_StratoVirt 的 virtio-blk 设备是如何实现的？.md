# [StratoVirt 的 virtio-blk 设备是如何实现的？](https://mp.weixin.qq.com/s/clGUwUA5KXqV65DB8hyAvw)

*李佳杰*[OpenAtom openEuler](javascript:void%280%29;)*2022-04-25 19:18:34*

StratoVirt 是开源在 openEuler 社区的面向云数据中心的企业级虚拟化平台，具备轻量低噪、软硬协同、Rust 语言级安全等关键技术竞争优势。

virtio-blk 是虚拟化 KVM 平台下虚拟磁盘的一种实现方式，本质上为一种半模拟技术。virtio-blk 设备中采用 io\_event\_fd 进行前端到后端通知，采用中断注入方式实现后端到前端的通知，并通过 IO 环(vring) 进行数据的共享。

## 基本原理

IO 总体流程可以分为以下几个步骤，如下图所示：

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZhdibS3PNFRpv42fX6hxALs2sqKibMJgtljv1fickbhZBNwib7eXBdmmFwnqtA3BSf7w4qRBeib2ibe1bA/640?wx_fmt=jpeg)

1. Guest 内部下发 IO 请求，通过 Eventfd 唤醒 StratoVirt 的 IO 线程
2. IO 主线程从共享环中取出 IO 请求，下发异步 IO 系统调用
3. Host 执行具体 IO 操作
4. IO 处理完成后唤醒 IO 线程
5. IO 线程 IO 结果生成响应放入共享环，向 Guest 注入中断
6. Guest 内部处理 IO 中断

## 具体实现

virtio-blk 的具体代码实现位于 StratoVirt 项目的 /virtio/src/block.rs 文件中，相关细节可参考代码理解。代码架构如下：

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
    │   ├── user
    │   │   ├── client.rs
    │   │   ├── message.rs
    │   │   ├── mod.rs
    │   │   └── sock.rs
    │   └── mod.rs
    └── virtio_mmio.rs
    └── virtio_pci.rs
```

StratoVirt 的 virtio crate 中的 lib.rs 中定义了为所有 virtio 设备定义的 VirtioDevice Trait。virtio-blk 设备实现了该 Trait。

当前 StratoVirt 中 virtio-blk 设备支持一个队列：request\_queue。该队列负责 block 设备的初始化以及 IO 命令传输。StratoVirt 为该队列配置了对应的 event\_fd 和 handler 函数。

定义 BlockIoHandler 作为 virtio-blk 设备事件处理的主体。

```
/// Control block of Block IO.
struct BlockIoHandler {
    /// The virtqueue.
    queue: Arc<Mutex<Queue>>,
    /// Eventfd of the virtqueue for IO event.
    queue_evt: EventFd,
    /// The address space to which the block device belongs.
    mem_space: Arc<AddressSpace>,
    /// The image file opened by the block device.
    disk_image: Option<Arc<File>>,
    /// The number of sectors of the disk image.
    disk_sectors: u64,
    /// Serial number of the block device.
    serial_num: Option<String>,
    /// if use direct access io.
    direct: bool,
    /// Aio context.
    aio: Option<Box<Aio<AioCompleteCb>>>,
    /// Bit mask of features negotiated by the backend and the frontend.
    driver_features: u64,
    /// The receiving half of Rust's channel to receive the image file.
    receiver: Receiver<SenderConfig>,
    /// Eventfd for config space update.
    update_evt: RawFd,
    /// Eventfd for device deactivate.
    deactivate_evt: RawFd,
    /// Callback to trigger an interrupt.
    interrupt_cb: Arc<VirtioInterrupt>,
    /// thread name of io handler
    iothread: Option<String>,
    /// Using the leak bucket to implement IO limits
    leak_bucket: Option<LeakBucket>,
}
```

其中包含了上述的一个 virtio 队列即 `queue` 变量，以及对应的触发事件描述符 (EventFd) `queue_evt`。队列使用了 Mutex 锁，保证在同一时刻只有一个使用者会对该队列进行操作，确保了多线程环境下的数据安全。

当该队列的事件描述符被触发只有，对应的处理函数 `process_queue` 会被调用。接下来结合代码讲解一下具体处理逻辑。

当该 handler 函数被触发时，首先从 virtio 队列中取出对应的元素，随后按照特定格式将取出的队列元素组合为 block 设备的 IO 请求。随后循环遍历执行 IO 请求，根据执行结果决定是否需要向 Guest 注入中断通知。

```
fn process_queue(&mut self) -> Result<bool> {
    /* 略 */
    // 从队列中取出元素
    while let Ok(elem) = queue.vring.pop_avail(&self.mem_space, self.driver_features) {
        /* 略 */
        // 将队列元素组合为IO请求
        match Request::new(&self.mem_space, &elem) {
            Ok(req) => {
                match req.out_header.request_type {
                    VIRTIO_BLK_T_IN | VIRTIO_BLK_T_OUT => {
                        last_aio_req_index = req_index;
                    }
                    _ => {}
                }
                req_queue.push(req);
                req_index += 1;
                done = true;
            }
            Err(ref e) => {
                //  If it fails, also need to free descriptor table entry.
                queue
                    .vring
                    .add_used(&self.mem_space, elem.index, 0)
                    .chain_err(|| "Failed to add used ring")?;
                need_interrupt = true;

                error!(
                    "failed to create block request, {}",
                    error_chain::ChainedError::display_chain(e)
                );
            }
        };
    }

    if let Some(disk_img) = self.disk_image.as_mut() {
        req_index = 0;
        // 循环遍历所有IO请求
        for req in merge_req_queue.iter() {
            if let Some(ref mut aio) = self.aio {
                let rw_len = match req.out_header.request_type {
                    VIRTIO_BLK_T_IN => u32::try_from(req.data_len)
                        .chain_err(|| "Convert block request len to u32 with overflow.")?,
                    _ => 0u32,
                };

                let aiocompletecb = AioCompleteCb::new(
                    self.queue.clone(),
                    self.mem_space.clone(),
                    req.desc_index,
                    rw_len,
                    req.in_header,
                    Some(self.interrupt_cb.clone()),
                    self.driver_features,
                );
                // 执行IO请求
                match req.execute(
                    aio,
                    disk_img,
                    self.disk_sectors,
                    &self.serial_num,
                    self.direct,
                    last_aio_req_index == req_index,
                    aiocompletecb,
                ) {
                    Ok(v) => {
                        if v == 1 {
                            /* 略 */
                            // 更新virtio队列
                            self.queue.lock().unwrap().vring.add_used(
                                &self.mem_space,
                                req.desc_index,
                                1,
                            ).chain_err(|| "Failed to add the request for block with device id to used ring")?;
                            // 如果执行成功，判断是否需要对Guest注入中断
                            if self
                                .queue
                                .lock()
                                .unwrap()
                                .vring
                                .should_notify(&self.mem_space, self.driver_features)
                            {
                                need_interrupt = true;
                            }
                        }
                    }
                    Err(ref e) => {
                        /* 略 */
                    }
                }
                req_index += 1;
            }
        }
    } else if !merge_req_queue.is_empty() {
        /* 略 */
    }

    if need_interrupt {
        // 如果需要对Guest注入中断，则调用对应总线的中断注入函数，通知Guest
        (self.interrupt_cb)(
            &VirtioInterruptType::Vring,
            Some(&self.queue.lock().unwrap()),
        )
        .chain_err(|| ErrorKind::InterruptTrigger("block", VirtioInterruptType::Vring))?;
    }

    Ok(done)
}
```

virtio-blk 设备的 IO 请求通过调用 Host 上的系统调用来完成处理。IO 请求结构体代码如下：

```
#[derive(Clone)]
struct Request {
    desc_index: u16,
    out_header: RequestOutHeader,
    iovec: Vec<Iovec>,
    data_len: u64,
    in_header: GuestAddress,
}
```

如果 virtio-blk 设备的命令行配置中指定 direct 为 on，则会调用异步 IO 系统调用：`io_submit` 和 `io_getevents` 进行 IO 请求的下发以及 IO 请求处理结果的获取；如果 virtio-blk 设备的命令行配置中指定 direct 为 off，则会调用同步 IO 系统调用：`pread` 和 `pwrite`。

## 性能优化

StratoVirt 还对 virtio-blk 设备进行了对应的优化处理。优化处理主要有两点。

第一点优化是对地址空间连续的 IO 请求进行了合并操作，减少了对 Host 上 IO 系统调用的调用次数，从而获得了一定程度的性能提升。具体代码处理逻辑如下：

```
fn merge_req_queue(&self, mut req_queue: Vec<Request>) -> Vec<Request> {
    if req_queue.len() == 1 {
        return req_queue;
    }

    req_queue.sort_by(|a, b| a.out_header.sector.cmp(&b.out_header.sector));
    let mut merge_req_queue = Vec::<Request>::new();
    let mut continue_merge: bool = false;

    for req in &req_queue {
        if continue_merge {
            if let Some(last_req) = merge_req_queue.last_mut() {
                if last_req.out_header.sector + last_req.get_req_sector_num()
                    != req.out_header.sector
                {
                    continue_merge = false;
                    merge_req_queue.push(req.clone());
                } else {
                    for iov in req.iovec.iter() {
                        let iovec = Iovec {
                            iov_base: iov.iov_base,
                            iov_len: iov.iov_len,
                        };
                        last_req.data_len += iovec.iov_len;
                        last_req.iovec.push(iovec);
                    }
                }
            }
        } else {
            merge_req_queue.push(req.clone());
        }
    }

    merge_req_queue
}
```

第二点优化操作是对于异步 IO 系统调用的处理优化。下发 io\_submit 系统调用之后，Host 会通过 io\_getevents 系统调用通知 StratoVirt 上一次 IO 请求处理的结果。

如果采用 Epoll 的事件唤醒机制就会导致 IO 请求处理结果获取的速度变慢。因此 StratoVirt 的处理方式是在 IO 线程内每次先预先轮询一段时间，查看上一次 IO 请求处理是否完成，如果完成了则直接进行下一步；如果没有轮询成功则继续进行 Epoll 等待。具体代码如下：

```
pub fn iothread_run(&mut self) -> Result<bool> {
    if let Some(manager) = &self.manager {
        if manager.lock().unwrap().loop_should_exit() {
            manager.lock().unwrap().loop_cleanup()?;
            return Ok(false);
        }
    }
    let timeout = self.timers_min_timeout();

    if timeout == -1 {
        for _i in 0..AIO_PRFETCH_CYCLE_TIME {
            for (_fd, notifer) in self.events.read().unwrap().iter() {
                if notifer.io_poll {
                    if let EventStatus::Alive = notifer.status {
                        let handle = notifer.handlers[1].lock().unwrap();
                        match handle(self.ready_events[1].event_set(), notifer.raw_fd) {
                            None => {}
                            Some(_) => {
                                break;
                            }
                        }
                    }
                }
            }
        }
    }

    self.epoll_wait_manager(timeout)
}
```

通过以上的优化措施之后，virtio-blk 设备性能就可以达到理论上限。经过测试，StratoVirt 的 virtio-blk 设备的磁盘 IO 性能与 Qemu 的 virtio-blk 设备的磁盘 IO 性能基本持平。

## 关注我们

StratoVirt 已经在 openEuler 社区开源。后续将开展一系列主题分享，如果您对 StratoVirt 的使用、实现感兴趣，欢迎围观和加入。

> ?
> 
> 项目地址https://gitee.com/openeuler/stratovirt
> 
> ?

> ?
> 
> 订阅邮件列表 https://mailweb.openeuler.org/postorius/lists/virt.openeuler.org/
> 
> ?

## 进入交流群

如果您对虚拟化技术感兴趣，欢迎加入 Virt SIG 技术交流群，讨论 StratoVirt、KVM、QEMU 和 Libvirt 等虚拟化相关技术。您可以添加如下微信小助手，回复 StratoVirt 入群。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMZhdibS3PNFRpv42fX6hxALsVViclcJXkNoPvuiaXOsZjQhvIApicoDovwWgdEp2UbsibydqLvc96Jq5UA/640?wx_fmt=jpeg)
