# [「转」毕昇 JDK ｜ PriorityBlockingQueue比较器异常导致的NPE问题分析](https://mp.weixin.qq.com/s/e5wpJKb80Dbfrj-Xwzn4Cg)

*谢照昆、王嘉伟*[OpenAtom openEuler](javascript:void%280%29;)*2022-05-06 18:04:54*

> 编者按：笔者在使用PriorityBlockingQueue实现按照优先级处理任务时遇到一类NPE问题，经过分析发现根本原因是在任务出队列时调用比较器异常，进而导致后续任务出队列抛出NullPointerException。本文通过完整的案例复现来演示在什么情况会触发该问题，同时给出了处理建议。希望读者在编程时加以借鉴，避免再次遇到此类问题。

## **背景知识**

PriorityBlockingQueue是一个无界的基于数组的优先级阻塞队列，使用一个全局ReentrantLock来控制某一时刻只有一个线程可以进行元素出队和入队操作，并且每次出队都返回优先级别最高的或者最低的元素。PriorityBlockingQueue通过以下两种方式实现元素优先级排序：

1. 入队元素实现Comparable接口来比较元素优先级；
2. PriorityBlockingQueue构造函数指定Comparator来比较元素优先级；

关于PriorityBlockingQueue中队列操作的部分，基本和PriorityQueue逻辑一致，只不过在操作时加锁了。在本文中我们主要关注PriorityBlockingQueue出队的take方法，该方法通过调用dequeue方法将元素出队列。当没有元素可以出队的时候，线程就会阻塞等待。

```
public E take() throws InterruptedException {
    final ReentrantLock lock = this.lock;
    lock.lockInterruptibly();
    E result;
    try {
        // 尝试获取最小元素，即小顶堆第一个元素，然后重新排序，如果不存在表示队列暂无元素，进行阻塞等待。
        while ( (result = dequeue()) == null)
            notEmpty.await();
    } finally {
        lock.unlock();
    }
    return result;
}
```

## **现象**

在某个业务服务中使用PriorityBlockingQueue实现按照优先级处理任务，某一天环境中的服务突然间不处理任务了，查看后台日志，发现一直抛出NullPointerException。将进程堆dump出来，使用MAT发现某个PriorityBlockingQueue中的size值比实际元素个数多1个（入队时已经对任务进行非空校验）。

异常堆栈如下：

```
java.lang.NullPointerException
 at java.util.concurrent.PriorityBlockingQueue.siftDownComparable(PriorityBlockingQueue.java:404)
 at java.util.concurrent.PriorityBlockingQueue.dequeue(PriorityBlockingQueue.java:333)
 at java.util.concurrent.PriorityBlockingQueue.take(PriorityBlockingQueue.java:548)
        ...
```

MAT结果：

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVkLicjibZ173ArRvhY2yt5Taz0NprS9eNzq364FdhYcbZ2LuKodr31zfIuP8KEggR3zOjvIx0omjQA/640?wx_fmt=png)

## **原因分析**

在此我们分析下PriorityBlockingQueue是如何出队列的，PriorityBlockingQueue最终通过调用dequeue方法出队列，dequeue方法处理逻辑如下：

1. 将根节点（array\[0]）赋值给result；
2. array\[n] 赋值给 arrary\[0]；
3. 将 array\[n] 设置为 null；
4. 调用siftDownComparable或siftDownUsingComparator对队列元素重新排序；
5. size大小减1；
6. 返回result；

如果在第4步中出现异常，就会出现队列中的元素个数比实际的元素个数多1个的现象。此时size未发生改变，arry\[n]已经被置为null，再进行siftDown操作时就会抛出NullPointerException。继续分析第4步中在什么情况下会出现异常，通过代码走读我们可以发现只有在调用Comparable#compareTo或者Comparator#compare方法进行元素比较的时候才可能出现异常。这块代码的处理逻辑和业务相关，如果业务代码处理不当抛出异常，就会导致上述现象。

```
    /**
     * Mechanics for poll().  Call only while holding lock.
     */
    private E dequeue() {
        int n = size - 1;
        if (n < 0)
            return null;
        else {
            Object[] array = queue;
            E result = (E) array[0];     //step1
            E x = (E) array[n];     //step2
            array[n] = null;        //step3
            Comparator<? super E> cmp = comparator;
            if (cmp == null)        //step4 如果指定了comparator，就按照指定的comparator来比较。否则就按照默认的
                siftDownComparable(0, x, array, n);
            else
                siftDownUsingComparator(0, x, array, n, cmp);
            size = n;       //step5
            return result;      //step6
        }
    }

private static <T> void siftDownComparable(int k, T x, Object[] array, int n) {
    if (n > 0) {
        Comparable<? super T> key = (Comparable<? super T>)x;
        int half = n >>> 1;
        while (k < half) {
            int child = (k << 1) + 1; 
            Object c = array[child];
            int right = child + 1;
            if (right < n && ((Comparable<? super T>) c).compareTo((T) array[right]) > 0) 
                c = array[child = right];
            if (key.compareTo((T) c) <= 0) 
                break;
            array[k] = c;
            k = child;
        }
        array[k] = key;
    }
}
private static <T> void siftDownUsingComparator(int k, T x, Object[] array, int n,
 Comparator<? super T> cmp) {
    if (n > 0) {
        int half = n >>> 1;
        while (k < half) {
            int child = (k << 1) + 1;
            Object c = array[child];
            int right = child + 1;
            if (right < n && cmp.compare((T) c, (T) array[right]) > 0)
                c = array[child = right];
            if (cmp.compare(x, (T) c) <= 0)
                break;
            array[k] = c;
            k = child;
        }
        array[k] = x;
    }
}
```

## **复现代码**

```
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.PriorityBlockingQueue;

public class PriorityBlockingQueueTest {
    static class Entity implements Comparable<Entity> {
        private int id;
        private String name;
        private boolean flag;

        public void setFlag(boolean flag) {
            this.flag = flag;
        }

        public Entity(int id, String name) {
            this.id = id;
            this.name = name;
        }

        @Override
        public int compareTo(Entity entity) {
            if(flag) {
                throw new RuntimeException("Test Exception");
            }
            if (entity == null || this.id > entity.id) {
                return 1;
            }
            return this.id == entity.id ? 0 : -1;
        }
    }

    public static void main(String[] args) {
        int num = 5;
        PriorityBlockingQueue<Entity> priorityBlockingQueue = new PriorityBlockingQueue<>();
        List<Entity> entities = new ArrayList<>();
        for (int i = 0; i < num; i++) {
            Entity entity = new Entity(i, "entity" + i);
            entities.add(entity);
            priorityBlockingQueue.offer(entity);
        }

        entities.get(num - 1).setFlag(true);
        int size = entities.size();
        for (int i = 0; i < size; i++) {
            try {
                priorityBlockingQueue.take();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
```

执行结果如下：

```
java.lang.RuntimeException: Test Exception
 at PriorityBlockingQueueTest$Entity.compareTo(PriorityBlockingQueueTest.java:31)
 at PriorityBlockingQueueTest$Entity.compareTo(PriorityBlockingQueueTest.java:8)
 at java.util.concurrent.PriorityBlockingQueue.siftDownComparable(PriorityBlockingQueue.java:404)
 at java.util.concurrent.PriorityBlockingQueue.dequeue(PriorityBlockingQueue.java:333)
 at java.util.concurrent.PriorityBlockingQueue.take(PriorityBlockingQueue.java:548)
 at PriorityBlockingQueueTest.main(PriorityBlockingQueueTest.java:71)
java.lang.NullPointerException
 at java.util.concurrent.PriorityBlockingQueue.siftDownComparable(PriorityBlockingQueue.java:404)
 at java.util.concurrent.PriorityBlockingQueue.dequeue(PriorityBlockingQueue.java:333)
 at java.util.concurrent.PriorityBlockingQueue.take(PriorityBlockingQueue.java:548)
 at PriorityBlockingQueueTest.main(PriorityBlockingQueueTest.java:71)
```

## **规避方案**

可以通过以下两种方法规避：

- 在take方法出现NPE时，清除队列元素，将未处理的元素重新进入队列；
- 在 Comparable#compareTo 或 Comparator#compare 方法中做好异常处理，对异常情况进行默认操作；

建议使用后者。

## **案例引申**

使用PriorityBlockingQueue作为缓存队列来创建线程池时，使用submit提交任务会出现 java.lang.ClassCastException: java.util.concurrent.FutureTask cannot be cast to 异常，而使用execute没有问题。

观察submit源码可以发现在submit内部代码会将Runable封装成RunnableFuture对象，然后调用execute提交任务。

```
public Future<?> submit(Runnable task) {
    if (task == null) throw new NullPointerException();
    RunnableFuture<Void> ftask = newTaskFor(task, null);
    execute(ftask);
    return ftask;
}

```

以Comparable为例，任务入队列时，最终会调用siftUpComparable方法。该方法第一步将RunnableFuture强转为Comparable类型，而RunnableFuture类未实现Comparable接口，进而抛出ClassCastException异常。

```
public boolean offer(E e) {
 if (e == null)
  throw new NullPointerException();
 final ReentrantLock lock = this.lock;
 lock.lock();
 int n, cap;
 Object[] array;
 while ((n = size) >= (cap = (array = queue).length))
  tryGrow(array, cap);
 try {
  Comparator<? super E> cmp = comparator;
  if (cmp == null)
   siftUpComparable(n, e, array);
  else
   siftUpUsingComparator(n, e, array, cmp);
  size = n + 1;
  notEmpty.signal();
 } finally {
  lock.unlock();
 }
 return true;
}

private static <T> void siftUpComparable(int k, T x, Object[] array) {
 Comparable<? super T> key = (Comparable<? super T>) x;
 while (k > 0) {
  int parent = (k - 1) >>> 1;
  Object e = array[parent];
  if (key.compareTo((T) e) >= 0)
   break;
  array[k] = e;
  k = parent;
 }
 array[k] = key;
}
```

这也是常见的比较器调用异常案例，本文不再赘述，可自行参考其他文章。

## **总结**

在使用PriorityBlockingQueue时，注意在比较器中做好异常处理，避免出现类似问题。

## **后记**

如果遇到相关技术问题（包括不限于毕昇 JDK），可以通过 Compiler SIG 求助。Compiler SIG 每双周周二举行技术例会，同时有一个技术交流群讨论 GCC、LLVM 和 JDK 等相关编译技术，感兴趣的同学可以添加如下微信小助手入群。

![](https://mmbiz.qpic.cn/mmbiz_jpg/icntuIQtpSJURabyabXmK64ich3UzDtIyn2picNDbEMLvAMkuCFsnz8oVXYibnZXWVRJy8SwHIsh4YW629PMgeicymg/640?wx_fmt=jpeg)
