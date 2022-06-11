
# Java Notes-22-线程通信


[TOC]


## 更新
* 2020/08/29，撰写



## 参考资料

* [Java多线程（五）——线程等待与唤醒 | Blog](https://www.cnblogs.com/xiaoxi/p/6637740.html)
* [Java 线程通信之 wait/notify 机制 | 掘金](https://juejin.im/post/6844904161834713101)
* [JAVA多线程中join()方法的详细分析 | CSDN](https://blog.csdn.net/u013425438/article/details/80205693?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param)
* [JAVA并发-join](https://www.cnblogs.com/hongdada/p/11739311.html)
* [一个Thread.join()面试题的思考](https://juejin.im/post/6844903977113354254)



## 线程通信之wait/notify机制

### Overiew

Java 线程通信是将多个独立的线程个体进行关联处理，使得线程与线程之间能进行相互通信。比如线程 A 修改了对象的值，然后通知给线程 B，使线程 B 能够知道线程 A 修改的值，这就是线程通信。

在 `wait/notify` 机制中，一个线程调用 `Object` 的 `wait()` 方法，使其线程被阻塞；另一线程调用 `Object` 的 `notify()/notifyAll()` 方法，`wait()` 阻塞的线程继续执行。

|    方法     |                说明                     |
|-------------|-----------------------------------------|
| `wait()`    | 当前线程被阻塞，线程进入 `WAITING` 状态   | 
| `wait(long timeout)` | 设置线程阻塞时长，线程会进入 `TIMED_WAITING` 状态。如果设置时间内（毫秒）没有通知，则超时返回 |
| `wait(long timeout, int nanos)` | 纳秒级别的线程阻塞时长设置 |
| `notify()`   | 只唤醒一个等待该对象的线程，该线程开始执行 |
| `notifyAll()` | 唤醒等待对象的所有线程 |


实现 `wait/notify` 机制的条件
1. 调用 `wait` 线程和 `notify` 线程必须拥有相同对象锁。
2. **`wait()` 方法和 `notify()/notifyAll()` 方法必须在 `synchronized` 方法或代码块中。**

由于 `wait/notify` 方法是定义在 `java.lang.Object` 中，所以在任何 Java 对象上都可以使用。



### Demo-wait()和notify()

下面通过示例演示 `wait()` 和 `notify()` 配合使用的情形。



```java
package com.demo.Thread;

public class ThreadA extends Thread{
    
    public ThreadA(String name){
        super(name);
    }
    
    public void run(){
        synchronized(this){
            System.out.println(Thread.currentThread().getName()+" call notify()");
             // 唤醒当前的wait线程
            notify();
        }
    }
}
```

```java
package com.demo.Thread;
public class WaitTest {
    
    public static void main(String[] args){
        
        ThreadA t1 = new ThreadA("t1");
        
        synchronized(t1){
            try{
                 // 启动“线程t1”
                System.out.println(Thread.currentThread().getName()+" start t1");
                t1.start();
                
                // 主线程等待t1通过notify()唤醒。
                System.out.println(Thread.currentThread().getName()+" wait()");
                t1.wait();

                System.out.println(Thread.currentThread().getName()+" continue");

            }catch(InterruptedException e){
                e.printStackTrace();
            }
        }
    }
}
```

程序运行结果如下

```
main start t1
main wait()
t1 call notify()
main continue
```



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-wait-notify-1.png)

下面结合上图分析一下代码中的线程处理。
1. 图中“主线程”代表“主线程main”，“线程t1”代表 `WaitTest` 中启动的“线程t1”，而“锁” 代表“ `t1` 这个对象的同步锁”。
2. 主线程通过 `new ThreadA("t1")` 新建线程t1。**通过 `synchronized(t1)` 获取 `t1` 对象的同步锁。** 然后调用 `t1.start()` 启动线程t1。
3. **主线程执行 `t1.wait()` 释放 `t1` 对象的锁并且进入等待(阻塞)状态。** 等待 `t1` 对象上的线程通过 `notify()` 或 `notifyAll()` 将其唤醒。
4. **线程 `t1` 运行之后，通过 `synchronized(this)` 获取当前对象的锁；** 接着调用 `notify()` 唤醒当前对象上的等待线程，也就是唤醒主线程。
5. 线程 `t1` 运行完毕之后，释放当前对象的锁。紧接着，主线程获取 `t1` 对象的锁，然后接着运行。



对于上面的代码，部分读者可能会疑问，`t1.wait()` 应该是让线程 `t1` 等待，但是为什么却是让主线程 `main` 等待了呢？


在解答该问题前，我们先看看 JDK 文档中关于 `wait` 的一段介绍

>  Causes the current thread to wait until another thread invokes the notify() method or the notifyAll() method for this object. 
In other words, this method behaves exactly as if it simply performs the call wait(0).
The current thread must own this object's monitor. The thread releases ownership of this monitor and waits until another thread notifies threads 
waiting on this object's monitor to wake up either through a call to the notify method or the notifyAll method. The thread then waits until it 
can re-obtain ownership of the monitor and resumes execution.


中文大意如下

> 引起 “当前线程” 等待，直到另外一个线程调用 `notify()` 或 `notifyAll()` 唤醒该线程。换句话说，这个方法和 `wait(0)` 的效果一样！(补充，对于 `wait(long millis)` 方法，当 `millis` 为 0 时，表示无限等待，直到被 `notify()` 或 `notifyAll()` 唤醒)。
>
> “当前线程” 在调用 `wait()` 时，必须拥有该对象的同步锁。该线程调用 `wait()` 之后，会释放该锁；然后一直等待直到 “其它线程” 调用对象的同步锁的 `notify()` 或 `notifyAll()` 方法。然后，该线程继续等待直到它重新获取 “该对象的同步锁”，然后就可以接着运行。


**<font color="red">注意，JDK的解释中，`wait()` 的作用是让 “当前线程” 等待，而 “当前线程” 是指正在 CPU 上运行的线程！</font>**

**这也意味着，虽然 `t1.wait()` 是通过 “线程t1” 调用的 `wait()` 方法，但是调用 `t1.wait()` 的地方是在 “主线程main” 中。而主线程必须是 “当前线程”，也就是运行状态，才可以执行 `t1.wait()`。所以，此时的 “当前线程” 是 “主线程main”！因此，`t1.wait()` 是让 “主线程” 等待，而不是 “线程t1”！**



### Demo-wait(timeout)和notify()

下面通过示例演示 `wait(long timeout)` 和 `notify()` 配合使用的情形。


```java
package com.demo;

public class ThreadB extends Thread{
    
     public ThreadB(String name){
        super(name);
     }
     
     public void run(){
         System.out.println(Thread.currentThread().getName()+" run ");
         // 死循环，不断运行。
         while(true);
     }
}
```

```java
package com.demo;

public class WaitTimeoutTest {

    public static void main(String[] args){
        ThreadB t1 = new ThreadB("t1");
        
        synchronized(t1){
            try{
                // 启动“线程t1”
                System.out.println(Thread.currentThread().getName() + " start t1");
                t1.start();
                
                // 主线程等待t1通过notify()唤醒 或 notifyAll()唤醒，或超过3000ms延时；然后才被唤醒。
                System.out.println(Thread.currentThread().getName() + " call wait ");
                t1.wait(3000);

                System.out.println(Thread.currentThread().getName() + " continue");
            }catch(InterruptedException e){
                e.printStackTrace();
            }
        }
    }
}
```


代码输出如下。

```
main start t1
main call wait 
t1 run                  // 大约3秒之后...输出“main continue”
main continue
```

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-wait-notify-2.png)




### Demo-wait()和notifyAll()


```java
package com.demo;

public class NotifyAllTest {
    
    private static Object obj = new Object();
    public static void main(String[] args){
        ThreadA t1 = new ThreadA("t1");
        ThreadA t2 = new ThreadA("t2");
        ThreadA t3 = new ThreadA("t3");
        
        t1.start();
        t2.start();
        t3.start();
        
        try{
            System.out.println(Thread.currentThread().getName()+" sleep(3000)");
            Thread.sleep(3000);
        }catch(InterruptedException e){
            e.printStackTrace();
        }
        
        synchronized(obj){
            System.out.println(Thread.currentThread().getName()+" notifyAll()");
            obj.notifyAll();
        }
    }
    
    static class ThreadA extends Thread{
        
        public ThreadA(String name){
            super(name);
        }
        
        public void run(){
            synchronized (obj) {
                try {
                    // 打印输出结果
                    System.out.println(Thread.currentThread().getName() + " wait");

                    // 阻塞当前的wait线程
                    obj.wait();

                    // 打印输出结果
                    System.out.println(Thread.currentThread().getName() + " continue");
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
```


程序运行结果如下。

```
t1 wait
main sleep(3000)
t3 wait
t2 wait
main notifyAll()
t2 continue
t3 continue
t1 continue
```

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-wait-notify-3.png)


结合上图分析代码中的线程处理。

1. 主线程中新建并且启动了3个线程 `t1`, `t2`和 `t3`。
2. 主线程通过 `sleep(3000)` 休眠 3 秒。在主线程休眠 3 秒的过程中，我们假设 `t1`, `t2` 和 `t3` 这 3 个线程都运行了。以 `t1` 为例，当它运行的时候，它会执行 `obj.wait()` 等待其它线程通过 `notify()` 或者 `notifyAll()` 来唤醒它；相同的道理，`t2` 和 `t3` 也会等待其它线程通过 `nofity()` 或 `notifyAll()` 来唤醒它们。
3. 主线程休眠 3 秒之后，接着运行。执行 `obj.notifyAll()` 唤醒 `obj` 上的等待线程，即唤醒 `t1`, `t2` 和 `t3` 这 3 个线程。
4. 紧接着，主线程的 `synchronized(obj)` 运行完毕之后，主线程释放 `obj` 锁。这样，`t1`, `t2` 和 `t3` 就可以获取 `obj` 锁而继续运行了！







## wait

**在执行 `wait()` 方法前，当前线程必须已获得对象锁。调用它时会阻塞<font color='red'>当前</font>线程，使得当前进入等待状态，在当前 `wait()` 处暂停线程。同时，`wait()` 方法执行后，<font color="red">会立即释放获得的对象锁。</font>**


下面通过案例来查看 `wait()` 释放锁。



```java
package top.ytao.demo.thread.waitnotify;

/**
 * Created by YangTao
 */
public class WaitTest {
    
    static Object object = new Object();
    
    public static void main(String[] args) {

        new Thread(() -> {
            synchronized (object){
                System.out.println("开始线程 A");
                try {
                    Thread.sleep(2000L);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("结束线程 A");
            }
        }, "线程 A").start();


        new Thread(() -> {
            try {
                Thread.sleep(500L);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            synchronized (object){
                System.out.println("开始线程 B");

                System.out.println("结束线程 B");
            }
        }, "线程 B").start();

    }

}
```

创建 A、B 两个线程。首先在 B 线程创建后 sleep ，保证 B 线程的打印后于 A 线程执行。在 A 线程中，获取到对象锁后，sleep 一段时间，且时间大于 B 线程的 sleep 时间。


执行结果为

```
开始线程 A
结束线程 A
开始线程 B
结束线程 B
```

根据运行结果，可以看到，线程 B 一定等线程 A 执行完 `synchronize` 代码块释放对象锁后，线程 B 再获取对象锁进入 `synchronize` 代码块中。在这过程中，`Thread.sleep()` 方法也不会释放锁。



当前在 A 线程 `synchronize` 代码块中执行 `wait()` 方法后，就会主动释放对象锁，A 线程代码如下


```java
new Thread(() -> {
    synchronized (object){
        System.out.println("开始线程 A");
        try {
            // 调用 object 对象的 wait 方法
            object.wait();
            Thread.sleep(2000L);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("结束线程 A");
    }
}, "线程 A").start();
```


执行结果如下，可以看到，A 线程一直处于阻塞状态，不会打印结束线程 A。

```
开始线程 A
开始线程 B
结束线程 B
```




`wait(long)` 方法是设置超时时间，当等待时间大于设置的超时时间后，会继续往 `wait(long)` 方法后的代码执行。



```java
new Thread(() -> {
    synchronized (object){
        System.out.println("开始线程 A");
        try {
            object.wait(1000);
            Thread.sleep(2000L);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("结束线程 A");
    }
}, "线程 A").start();
```


执行结果如下。

```
开始线程 A
开始线程 B
结束线程 B
结束线程 A
```



## notify


同样，在执行 `notify()` 方法前，当前线程也必须已获得线程锁。调用 `notify()` 方法后，会通知一个执行了 `wait()` 方法的阻塞等待线程，使该等待线程重新获取到对象锁，然后继续执行 `wait()` 后面的代码。

但是，与 `wait()` 方法不同，执行 `notify()` 后，不会立即释放对象锁，而需要执行完 `synchronize` 的代码块或方法才会释放锁，所以接收通知的线程也不会立即获得锁，也需要等待执行 `notify()` 方法的线程释放锁后再获取锁。


### Demo-notify()

下面是 `notify()` 方法的使用，实现一个完整的 `wait/notify` 的例子，同时验证发出通知后，执行 `notify()` 方法的线程是否立即释放锁，执行 `wait()` 方法的线程是否立即获取锁。



```java
package top.ytao.demo.thread.waitnotify;

/**
 * Created by YangTao
 */
public class WaitNotifyTest {

    static Object object = new Object();

    public static void main(String[] args) {
        System.out.println();

        new Thread(() -> {
            synchronized (object){
                System.out.println("开始线程 A");
                try {
                    object.wait();
                    System.out.println("A 线程重新获取到锁，继续进行");
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("结束线程 A");
            }
        }, "线程 A").start();


        new Thread(() -> {
            try {
                Thread.sleep(500L);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            synchronized (object){
                System.out.println("开始线程 B");
                object.notify();
                System.out.println("线程 B 通知完线程 A");
                try {
                    // 试验执行完 notify() 方法后，A 线程是否能立即获取到锁
                    Thread.sleep(2000L);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("结束线程 B");
            }
        }, "线程 B").start();

    }

}
```


上述代码中，A 线程执行 `wait()` 方法，B 线程执行 `notify()` 方法，执行结果为


```
开始线程 A
开始线程 B
线程 B 通知完线程 A
结束线程 B
A 线程重新获取到锁，继续进行
结束线程 A
```

可以看到，B 线程执行 `notify()` 方法后，即使 `sleep` 了，A 线程也没有获取到锁，可知，**`notify()` 方法并没有释放锁。**


`notify()` 是通知到等待中的线程，但是调用一次 `notify()` 方法，只能通知到一个执行 `wait()` 方法的等待线程。如果有多个等待状态的线程，则需多次调用 `notify()` 方法，通知到线程顺序则根据执行 `wait()` 方法的先后顺序进行通知。

下面创建有两个执行 wait() 方法的线程的代码。


```java
package top.ytao.demo.thread.waitnotify;

/**
 * Created by YangTao
 */
public class MultiWaitNotifyTest {

    static Object object = new Object();

    public static void main(String[] args) {
        System.out.println();

        new Thread(() -> {
            synchronized (object){
                System.out.println("开始线程 A");
                try {
                    object.wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("结束线程 A");
            }
        }, "线程 A").start();


        new Thread(() -> {
            try {
                Thread.sleep(500L);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            synchronized (object){
                System.out.println("开始线程 B");
                try {
                    object.wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("结束线程 B");
            }
        }, "线程 B").start();


        new Thread(() -> {
            try {
                Thread.sleep(3000L);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            synchronized (object){
                System.out.println("开始通知线程 C");
                object.notify();
                object.notify();
                System.out.println("结束通知线程 C");
            }
        }, "线程 C").start();

    }

}
```


先 A 线程执行 `wait()` 方法，然后 B 线程执行 `wait()` 方法，最后 C 线程调用两次 `notify()` 方法，执行结果如下



```
开始线程 A
开始线程 B
开始通知线程 C 
结束通知线程 C
结束线程 A
结束线程 B
```


### Demo-notifyAll()

通知多个等待状态的线程，通过多次调用 `notify()` 方法实现的方案，在实际应用过程中，实现过程不太友好，如果是想通知所有等待状态的线程，可使用 `notifyAll()` 方法，就能唤醒所有线程。

实现方式，只需将上面 C 线程的多次调用 `notify()` 方法部分改为调用一次 `notifyAll()` 方法即可。


```java
new Thread(() -> {
    try {
        Thread.sleep(3000L);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    synchronized (object){
        System.out.println("开始通知线程 C");
        object.notifyAll();
        System.out.println("结束通知线程 C");
    }
}, "线程 C").start();
```


执行结果如下


```
开始线程 A
开始线程 B
开始通知线程 C 
结束通知线程 C
结束线程 B
结束线程 A
```

根据不同 JVM 的实现，`notifyAll()` 的唤醒顺序会有所不同，当前测试环境中，以倒序顺序唤醒线程。


## 生产者消费者模式

生产消费者模式就是一个线程生产数据进行存储，另一线程进行数据提取消费。下面就以两个线程来模拟，生产者生成一个 UUID 存放到 List 对象中，消费者读取 List 对象中的数据，读取完成后进行清除。


```java
package top.ytao.demo.thread.waitnotify;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by YangTao
 */
public class WaitNotifyModelTest {

    // 存储生产者产生的数据
    static List<String> list = new ArrayList<>();

    public static void main(String[] args) {

        new Thread(() -> {
            while (true){
                synchronized (list){
                    // 判断 list 中是否有数据，如果有数据的话，就进入等待状态，等数据消费完
                    if (list.size() != 0){
                        try {
                            list.wait();
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }

                    // list 中没有数据时，产生数据添加到 list 中
                    list.add(UUID.randomUUID().toString());
                    list.notify();
                    System.out.println(Thread.currentThread().getName() + list);
                }
            }
        }, "生产者线程 A ").start();


        new Thread(() -> {
            while (true){
                synchronized (list){
                    // 如果 list 中没有数据，则进入等待状态，等收到有数据通知后再继续运行
                    if (list.size() == 0){
                        try {
                            list.wait();
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }

                    // 有数据时，读取数据
                    System.out.println(Thread.currentThread().getName() + list);
                    list.notify();
                    // 读取完毕，将当前这条 UUID 数据进行清除
                    list.clear();
                }
            }
        }, "消费者线程 B ").start();

    }
}
```


程序输出如下。


```
生产者线程 A [bca9d75b-c7a8-4dad-8abc-01d5d1c96672]
消费者线程 B [bca9d75b-c7a8-4dad-8abc-01d5d1c96672]
生产者线程 A [88fbdf87-40cf-44a2-b1eb-831f3c466c8f]
消费者线程 B [88fbdf87-40cf-44a2-b1eb-831f3c466c8f]
生产者线程 A [8d2bfbbf-3390-4d3c-8b65-90d8e7b5f494]
消费者线程 B [8d2bfbbf-3390-4d3c-8b65-90d8e7b5f494]
```


生产者线程运行时，如果已存在未消费的数据，则当前线程进入等待状态，收到通知后，表明数据已消费完，再继续向 list 中添加数据。

消费者线程运行时，如果不存在未消费的数据，则当前线程进入等待状态，收到通知后，表明 List 中已有新数据被添加，继续执行代码消费数据并清除。

不管是生产者还是消费者，基于对象锁，一次只能一个线程能获取到，如果生产者获取到锁就校验是否需要生成数据，如果消费者获取到锁就校验是否有数据可消费。




## join
* [JAVA多线程中join()方法的详细分析 | CSDN](https://blog.csdn.net/u013425438/article/details/80205693?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param)


`join` 方法，一种特殊的 `wait`，当前运行线程调用另一个线程的 `join` 方法，当前线程进入阻塞状态直到调用 `join` 方法的线程结束，再继续执行。

**<font color="red">`t.join()` 方法只会使调用 `t.join()` 的当前线程进入等待池，并等待 `t` 线程执行完毕后才会被唤醒。并不影响同一时刻处在运行状态的其他线程。</font>**



### Demo-并行程序变串行

```java
package CSDN;
public class TestJoin {
 
	public static void main(String[] args) throws InterruptedException {
		ThreadTest t1=new ThreadTest("A");
		ThreadTest t2=new ThreadTest("B");
		t1.start();
		t2.start();
	}
 
 
}
class ThreadTest extends Thread {
	private String name;
	public ThreadTest(String name){
		this.name=name;
	}
	public void run(){
		for(int i=1;i<=5;i++){
			System.out.println(name+"-"+i);
		}		
	}
}
```

程序运行结果如下。

```
A-1
B-1
B-2
B-3
A-2
B-4
A-3
B-5
A-4
A-5
```


可以看出A线程和B线程是交替执行的。而在其中加入 `t1.join()` 能够使得线程之间的并行执行变成串行执行。


```java

package CSDN;
public class TestJoin {
 
	public static void main(String[] args) throws InterruptedException {
		// TODO Auto-generated method stub
		ThreadTest t1=new ThreadTest("A");
		ThreadTest t2=new ThreadTest("B");
		t1.start();
		t1.join();
		t2.start();
	}
}
```


程序运行结果如下。

```
A-1
A-2
A-3
A-4
A-5
B-1
B-2
B-3
B-4
B-5
```


显然，使用 `t1.join()` 之后，B 线程需要等 A 线程执行完毕之后才能执行。需要注意的是，`t1.join()` 需要等 `t1.start()` 执行之后执行才有效果。

**此外，如果 `t1.join()` 放在 `t2.start()` 之后的话，仍然会是交替执行。** 这是为什么呢？ 下面结合 `join()` 源码进行分析。



### join()源码


```java
    /**
     * Waits for this thread to die.
     *
     * <p> An invocation of this method behaves in exactly the same
     * way as the invocation
     *
     * <blockquote>
     * {@linkplain #join(long) join}{@code (0)}
     * </blockquote>
     *
     * @throws  InterruptedException
     *          if any thread has interrupted the current thread. The
     *          <i>interrupted status</i> of the current thread is
     *          cleared when this exception is thrown.
     */
    public final void join() throws InterruptedException {
        join(0);
    }
    
    /**
     * Waits at most {@code millis} milliseconds for this thread to
     * die. A timeout of {@code 0} means to wait forever.
     *
     * <p> This implementation uses a loop of {@code this.wait} calls
     * conditioned on {@code this.isAlive}. As a thread terminates the
     * {@code this.notifyAll} method is invoked. It is recommended that
     * applications not use {@code wait}, {@code notify}, or
     * {@code notifyAll} on {@code Thread} instances.
     *
     * @param  millis
     *         the time to wait in milliseconds
     *
     * @throws  IllegalArgumentException
     *          if the value of {@code millis} is negative
     *
     * @throws  InterruptedException
     *          if any thread has interrupted the current thread. The
     *          <i>interrupted status</i> of the current thread is
     *          cleared when this exception is thrown.
     */
    public final synchronized void join(long millis)
    throws InterruptedException {
        long base = System.currentTimeMillis();
        long now = 0;

        if (millis < 0) {
            throw new IllegalArgumentException("timeout value is negative");
        }

        if (millis == 0) {
            while (isAlive()) {
                wait(0);
            }
        } else {
            while (isAlive()) {
                long delay = millis - now;
                if (delay <= 0) {
                    break;
                }
                wait(delay);
                now = System.currentTimeMillis() - base;
            }
        }
    }
```


可以看出，`join()` 方法的底层是利用 `wait()` 方法实现的。可以看出，`join` 方法是一个同步方法，当主线程调用 `t1.join()` 方法时，主线程先获得了 `t1` 对象的锁，随后进入方法，调用了 t1 对象的 `wait()` 方法，使主线程进入了 `t1` 对象的等待池。此时，A 线程则还在执行，并且随后的 `t2.start()` 还没被执行，因此，B 线程也还没开始。等到 A 线程执行完毕之后，主线程继续执行，走到了`t2.start()`，B线程才会开始执行。


> `join` 源码中，只会调用 `wait` 方法，并没有在结束时调用 `notify`，这是因为线程在 `die` 的时候会自动调用自身的 `notifyAll` 方法，来释放所有的资源和锁。



至此，上述疑问就可以解决了。把 `t1.join()` 放在 `t2.start()` 之后，当执行到 `t1.join()` 时，线程`t1` 和 `t2` 已经处于了允许状态，阻塞的仅仅是主线程。因此线程 `t1` 和 `t2` 仍然是交替运行的。



```java

package CSDN;
public class TestJoin {
 
	public static void main(String[] args) throws InterruptedException {
		// TODO Auto-generated method stub
		ThreadTest t1=new ThreadTest("A");
		ThreadTest t2=new ThreadTest("B");
		t1.start();
		t2.start();
		
		t1.join();
	}
}
```


更进一步的，结合下面代码，理解 `join()` 的位置和作用。


```java

package CSDN;
 
public class TestJoin {
 
	public static void main(String[] args) throws InterruptedException {
		// TODO Auto-generated method stub
		System.out.println(Thread.currentThread().getName()+" start");
		ThreadTest t1=new ThreadTest("A");
		ThreadTest t2=new ThreadTest("B");
		ThreadTest t3=new ThreadTest("C");
		System.out.println("t1start");
		t1.start();
		System.out.println("t1end");
		System.out.println("t2start");
		t2.start();
		System.out.println("t2end");
		t1.join();
		System.out.println("t3start");
		t3.start();
		System.out.println("t3end");
		System.out.println(Thread.currentThread().getName()+" end");
	}
 
}
```


程序运行结果如下。

```
main start
t1start
t1end
t2start
t2end
A-1
B-1
A-2
A-3
A-4
A-5
B-2
t3start
t3end
B-3
main end
B-4
B-5
C-1
C-2
C-3
C-4
C-5
```


可以看到，主线程在 `t1.join()` 方法处停止，并需要等待 A 线程执行完毕后才会执行 `t3.start()`，然而，并不影响 B 线程的执行。

因此，可以得出结论，
**<font color="red">`t.join()` 方法只会使调用 `t.join()` 的当前线程进入等待池，并等待 `t` 线程执行完毕后才会被唤醒。并不影响同一时刻处在运行状态的其他线程。</font>**



### Demo-替代join的案例

1. 首先看一个不使用 `join()` 的基本Demo。


```java
public class JoinThreadDemo {

	public static void main(String[] args) {
		JoinRunnable runnable1 = new JoinRunnable();
		Thread thread1 = new Thread(runnable1, "线程1");
		System.out.println("主线程开始执行！");
		thread1.start();
//		try {
//			thread1.join();
//		} catch (InterruptedException e) {
//			e.printStackTrace();
//		}

		System.out.println("主线程执行结束！");
	}

	static final class JoinRunnable implements Runnable {
		@Override
		public void run() {
			String name = Thread.currentThread().getName();
			System.out.println(name + "开始执行！");

			for (int i = 1; i <= 5; i++) {
				System.out.println(name + "执行了[" + i + "]次");
			}
		}
	}
}
```

程序输出如下。


```
主线程开始执行！
主线程执行结束！
线程1开始执行！
线程1执行了[1]次
线程1执行了[2]次
线程1执行了[3]次
线程1执行了[4]次
线程1执行了[5]次
```


2. 下面加入 `join()` 方法，使程序串行执行。


```java
	public static void main(String[] args) {
		JoinRunnable runnable1 = new JoinRunnable();
		Thread thread1 = new Thread(runnable1, "线程1");
		System.out.println("主线程开始执行！");
		thread1.start();
		try {
			thread1.join();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		System.out.println("主线程执行结束！");
	}
```



程序输出如下。

```
主线程开始执行！
线程1开始执行！
线程1执行了[1]次
线程1执行了[2]次
线程1执行了[3]次
线程1执行了[4]次
线程1执行了[5]次
主线程执行结束！
```


3. 下面使用 `synchronized` 和 `wait()` 替代 `join()`


```java
public class JoinThreadDemo {

	public static void main(String[] args) {
		JoinRunnable runnable1 = new JoinRunnable();
		Thread thread1 = new Thread(runnable1, "线程1");
		System.out.println("主线程开始执行！");
		thread1.start();
		try {
			synchronized (thread1) {
				while (thread1.isAlive()) {
					System.out.println("begin wait");
					//主线程持有thread1对象锁，阻塞，一直到thread1运行结束，jvm唤醒
					thread1.wait(0);
					System.out.println("thread wait");
				}
			}

		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		System.out.println("主线程执行结束！");

	}

	static final class JoinRunnable implements Runnable {

		@Override
		public void run() {
			String name = Thread.currentThread().getName();
			System.out.println(name + "开始执行！");

			for (int i = 1; i <= 5; i++) {
				System.out.println(name + "执行了[" + i + "]次");
			}
		}
	}
}
```



程序输出如下。

```
主线程开始执行！
线程1开始执行！
线程1执行了[1]次
线程1执行了[2]次
线程1执行了[3]次
线程1执行了[4]次
线程1执行了[5]次
主线程执行结束！
```


在 `thread1` 调用 `wait` 后，主线程阻塞，一直到子线程 `thread1` 运行结束退出以后，JVM 会自动唤醒阻塞在 `thread1` 对象上的线程。

那么有没有可能不使用 `thread1` 对象阻塞呢？参考如下代码实现。


4. 替代 `join()` 案例2（不阻塞）


```java
public class JoinThreadDemo {

	public static void main(String[] args) {
		Object lock = new Object();
		Thread thread1 = new Thread(() -> {
			String name = Thread.currentThread().getName();
			System.out.println(name + "开始执行！");

			for (int i = 1; i <= 5; i++) {
				System.out.println(name + "执行了[" + i + "]次");
			}
		}, "线程1");
		System.out.println("主线程开始执行！");
		thread1.start();

		//thread2自旋唤醒阻塞在lock对象上的主线程
		Thread thread2 = new Thread(new Thread() {
			@Override
			public void run() {
				while (!thread1.isAlive() && !Thread.currentThread().isInterrupted()) {
					synchronized (lock) {
						System.out.println("enter");
						lock.notifyAll();
						System.out.println("exit");
					}
				}
			}
		}, "线程2");
		thread2.start();

		try {
			synchronized (lock) {
				while (thread1.isAlive()) {
					System.out.println("bb");
					lock.wait();
					//停止thread2自旋
					thread2.interrupt();
					System.out.println("tt");
				}
			}
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		System.out.println("主线程执行结束！");
	}
}
```


这里添加了一个线程 `thread2` 用于专门自旋唤醒主线程，用于替换案例一中的，`thread1` 线程结束后，JVM 唤醒主线程操作。程序输出如下。


```
主线程开始执行！
bb
线程1开始执行！
线程1执行了[1]次
线程1执行了[2]次
线程1执行了[3]次
线程1执行了[4]次
线程1执行了[5]次
enter
exit
enter
exit
tt
主线程执行结束！
```