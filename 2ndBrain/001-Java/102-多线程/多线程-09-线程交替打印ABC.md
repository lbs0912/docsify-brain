# 多线程-09-线程交替打印ABC

[TOC]




## 更新
* 2022/06/20，撰写



## 前言

本文以「多线程交替打印 ABC」为例，对多线程知识进行必要的总结。




## AQS

* [AQS解析与实战](https://mp.weixin.qq.com/s?__biz=Mzg3NzU5NTIwNg==&mid=2247487939&idx=1&sn=560f9ec0fdbc081949383bbee2407b0e&chksm=cf21ceeaf85647fc24537661ca063f9537b5cb5090da1c4ecf1f4d8326a5359391143bd16e1a&token=1496082535&lang=zh_CN#rd)


AQS 全称是 `AbstractQueuedSynchronizer`，即抽象同步队列。AQS为 Java 中几乎所有的锁和同步器提供一个基础框架，派生出如 ReentrantLock、Semaphore、CountDownLatch 等 AQS 全家桶。

AQS 原理面试题的核心回答要点
1. state 状态的维护
2. CLH 队列
3. ConditionObject 通知
4. 模板方法设计模式
5. 独占与共享模式
6. 自定义同步器
7. AQS 全家桶的一些延伸，如 ReentrantLock 等




### AQS简介
* ref 1-[谈谈你对AQS的理解](https://juejin.cn/post/7081932085186953229)



AQS（AbstractQueuedSynchronizer）是抽象同步队列（多线程同步器），它是 J.U.C 包中多个组件的底层实现，如 Lock、CountDownLatch、Semaphore 等都用到了 AQS。

从本质上来说，AQS 提供了两种锁机制，分别是排它锁和共享锁。

排它锁，就是存在多线程竞争同一共享资源时，同一时刻只允许一个线程访问该共享资源，也就是多个线程中只能有一个线程获得锁资源，比如 Lock 中的 ReentrantLock 重入锁的实现，就是用到了 AQS 中的排它锁功能。

共享锁也称为读锁，就是在同一时刻允许多个线程同时获得锁资源，比如 CountDownLatch 和 Semaphore 都是用到了 AQS 中的共享锁功能。



### state状态维护


AQS 对象内部有一个核心的变量叫做 state，是 int 类型的，代表了加锁的状态。初始状态下，这个 state 的值是 0，这个 AQS 内部还有一个关键变量，用来记录当前加锁的是哪个线程，初始化状态下，这个变量是 null。


state 源码设计几个回答要点
1. `state` 用 `volatile` 修饰，保证多线程中的可见性
2. `getState()` 和 `setState()` 方法采用 final 修饰，限制 AQS 的子类重写这两个方法
3. `compareAndSetState()` 方法采用乐观锁思想的 CAS 算法，也是采用 `final` 修饰的，不允许子类重写


### CLH队列

CLH（Craig, Landin, and Hagersten locks) 同步队列是一个 FIFO 双向队列，其内部通过节点 head 和 tail 记录队首和队尾元素，队列元素的类型为 Node。

AQS 依赖它来完成同步状态 state 的管理，当前线程如果获取同步状态失败时，AQS 则会将当前线程已经等待状态等信息构造成一个节点（Node）并将其加入到 CLH 同步队列，同时会阻塞当前线程，当同步状态释放时，会把首节点唤醒（公平锁），使其再次尝试获取同步状态。

### Node节点

CLH同步队列中，一个节点表示一个线程，它保存着线程的引用（thread）、状态（waitStatus）、前驱节点（prev）、后继节点（next），condition 队列的后续节点（nextWaiter）。

### ConditionObject

我们都知道，synchronized 控制同步的时候，可以配合 Object 的 wait()、notify()，notifyAll() 系列方法可以实现等待/通知模式。而Lock 呢？它提供了条件 Condition 接口，配合 await()、signal()、signalAll() 等方法也可以实现等待/通知机制。ConditionObject 实现了 Condition 接口，给 AQS 提供条件变量的支持 。


### AQS的模板方法设计模式

模板方法指的是，在一个方法中定义一个算法的骨架，而将一些步骤延迟到子类中。模板方法使得子类可以在不改变算法结构的情况下，重新定义算法中的某些步骤。


具体到 AQS 中，AQS 提供 tryAcquire、tryAcquireShared 等模板方法，给子类实现自定义的同步器。



### 自定义同步器

基于以上分析，我们都知道 state，CLH 队列，ConditionObject 队列等这些关键点，你要实现自定义锁的话，首先需要确定你要实现的是独占锁还是共享锁，定义原子变量 state 的含义，再定义一个内部类去继承 AQS，重写对应的模板方法。



## 基于AQS实现的锁



AQS（`AbstractQueuedSynchronizer`）是 Java 并发包 JUC 中非常重要的一个类，大部分锁都是基于 AQS 实现的，主要实现的类如下
1. `ReentrantLock`
   * 可重入锁，独占锁，实现了公平锁和非公平锁。
   * **通常搭配 `Condition` 一起使用。**
2. `ReentrantReadWriteLock`
   * 读写锁，可共享也可独占锁，读是共享锁，写是独占锁，也实现了公平锁和非公平锁。
3. `Semaphore`
   * 信号锁，共享锁，也实现了公平锁和非公平锁，主要同于控制流量。
4. `CountDownLatch`
   * 闭锁，共享锁，也实现了公平锁和非公平锁。（Latch 译为门闩）。



### ReentrantLock + Condition

`ReentrantLock` 是可重入锁，独占锁，实现了公平锁和非公平锁。

**`ReentrantLock` 通常搭配 `Condition` 一起使用。**

`Condition` 可以通俗的理解为条件队列。当一个线程在调用了 `await` 方法以后，直到线程等待的某个条件为真的时候才会被唤醒。这种方式为线程提供了更加简单的等待/通知模式。

**`Condition` 必须要配合锁一起使用，因为对共享状态变量的访问发生在多线程环境下。一个 `Condition` 的实例必须与一个 `Lock` 绑定，因此 `Condition` 一般都是作为 Lock 的内部实现。**

1. `await()` ：造成当前线程在接到信号或被中断之前一直处于等待状态。
2. `await(long time, TimeUnit unit)` ：造成当前线程在接到信号、被中断或到达指定等待时间之前一直处于等待状态。
3. `awaitNanos(long nanosTimeout)` ：造成当前线程在接到信号、被中断或到达指定等待时间之前一直处于等待状态。返回值表示剩余时间，如果在nanosTimesout 之前唤醒，那么返回值 = `nanosTimeout` - 消耗时间，如果返回值 <= 0 ,则可以认定它已经超时了。
4. `awaitUninterruptibly()` ：造成当前线程在接到信号之前一直处于等待状态。【注意：该方法对中断不敏感】。
5. `awaitUntil(Date deadline)` ：造成当前线程在接到信号、被中断或到达指定最后期限之前一直处于等待状态。如果没有到指定时间就被通知，则返回true，否则表示到了指定时间，返回返回 false。
6. `signal()` ：唤醒一个等待线程。该线程从等待方法返回前必须获得与Condition 相关的锁。
7. `signalAll()` ：唤醒所有等待线程。能够从等待方法返回的线程必须获得与 Condition 相关的锁。


### CountDownLatch

`CountDownLatch` 这个类使一个线程等待其他线程各自执行完毕后再执行。

`CountDownLatch` 是通过一个计数器来实现的，计数器的初始值是线程的数量。每当一个线程执行完毕后，计数器的值就 `-1`，当计数器的值为 0 时，表示所有线程都执行完毕，然后在闭锁上等待的线程就可以恢复工作了。


```java
//调用await()方法的线程会被挂起，它会等待直到count值为0才继续执行
public void await() throws InterruptedException;

//和await()类似，只不过等待一定的时间后count值还没变为0的话就会继续执行
public boolean await(long timeout, TimeUnit unit) throws InterruptedException;  

//将count值减1
public void countDown();  
```


### CyclicBarrier
* ref 1-[CyclicBarrier使用及应用场景例子](https://www.jianshu.com/p/4ef4bbf01811)



`CyclicBarrier` 字面意思回环栅栏，通过它可以实现让一组线程等待至某个状态之后再全部同时执行。
1. 叫做回环，是因为当所有等待线程都被释放以后，`CyclicBarrier` 可以被重用。
2. 叫做栅栏，大概是描述所有线程被栅栏挡住了，当都达到时，一起跳过栅栏执行，也算形象。我们可以把这个状态叫做 `barrier`。


* 构造函数

```java
public CyclicBarrier(int parties)

public CyclicBarrier(int parties, Runnable barrierAction)
// -构造方法
//parties 是参与线程的个数
//第二个构造方法有一个 Runnable 参数，这个参数的意思是最后一个到达线程要做的任务
```

* 常用方法

```java
public int await() throws InterruptedException,BrokenBarrierException

public int await(long timeout, TimeUnit unit) throws InterruptedException, BrokenBarrierException, TimeoutException

//- 函数
//线程调用 await() 表示自己已经到达栅栏
//BrokenBarrierException 表示栅栏已经被破坏，破坏的原因可能是其中一个线程 await() 时被中断或者超时
//调用await方法的线程告诉CyclicBarrier自己已经到达同步点，然后当前线程被阻塞。直到parties个参与线程调用了await方法
```

`CyclicBarrier` 与 `CountDownLatch` 区别
1. `CountDownLatch` 是一次性的，`CyclicBarrier` 是可循环利用的
2. `CountDownLatch` 参与的线程的职责是不一样的，有的在倒计时，有的在等待倒计时结束。`CyclicBarrier` 参与的线程职责是一样的。



`CyclicBarrier` 的底层原理如下
* `CyclicBarrier` 类是 `concurrent` 并发包下的一工具类。
* 线程间同步阻塞是使用的是 `ReentrantLock`，可重入锁。
* 线程间通信使用的是 `Condition`，`Condition` 将 `Object` 监视器方法（`wait`、`notify` 和 `notifyAll`）分解成截然不同的对象，以便通过将这些对象与任意 Lock 实现组合使用。



### 信号量 Semaphore

* ref 1-[Semaphore 信号量的源码深度解析与应用 | 掘金](https://juejin.cn/post/7103504476375351326)


信号量（Semaphore）是基于 AQS 实现的信号锁，是一个共享锁，实现了「公平锁」和「非公平锁」（默认创建新号量使用非公平锁），可以用来控制同时访问特定资源的线程数，通过协调各个线程以保证合理的使用资源。





#### 基本使用

Semaphore 可以控制同时访问共享资源的线程个数
1. 通过 `acquire` 方法获取一个信号量，信号量减一，如果没有就等待（阻塞）
2. 通过 `release` 方法释放一个信号量，信号量加一。

`Semaphore` 通过控制信号量的总数量，以及每个线程所需获取的信号量数量，进而控制多个线程对共享资源访问的并发度，以保证合理的使用共享资源。

相比 `synchronized` 和独占锁一次只能允许一个线程访问共享资源，功能更加强大，有点类似于共享锁。



####  Semaphore并没有和线程绑定
Semaphore 的信号量资源很像锁资源，但和锁是有不同的，那就是锁资源是和获得锁的线程绑定的，而这里的信号量资源并没有和线程绑定，也就是说你可以让一些线程不停的 “释放信号量”，而另一些线程只是不停的 “获取信号量”，这在 AQS 内部实际上就是对 `state` 状态的值的改变而已，与线程无关。


#### API



* 初始化构造函数（默认非公平锁）

```java
// 构建指定数量锁的非公平信号锁
public Semaphore(int permits) {
    sync = new NonfairSync(permits);
}

// 构建指定数量锁的公平/非公平信号锁
public Semaphore(int permits, boolean fair) {
    sync = fair ? new FairSync(permits) : new NonfairSync(permits);
}
```

* 常用方法

```java
// 从信号锁获取获取一个锁，在获取到锁之前一直处理阻塞状态，除非线程被中断
acquire();

// 从信号锁获取获取指定数量锁，在获取到锁之前一直处理阻塞状态，除非线程被中断
acquire(int permits);

// 从信号锁获取一个锁，在获取到锁之前线程一直处于阻塞状态（忽略中断）
acquireUninterruptibly();

// 尝试从信号锁获取锁，返回获取成功或者失败，不会阻塞线程
tryAcquire();

// 尝试从信好锁获取锁，指定获取时间，在指定时间内没有获取到则超时返回，不会阻塞线程
tryAcquire(long timeount, TimeUnit unit);

// 释放锁
release();

// 获取等待队列中是否还有等待线程
hadQueuedThreads();

// 获取等待队列里阻塞线程的数量
getQueuedLength();

// 清空锁，返回清空锁的数量
drainPermits();

// 返回可用的锁的数量
availabelPermits();
```





## 原子操作 AtomicInteger

JDK 1.5 之后的 java.util.concurrent.atomic 包里，多了一批原子处理类，`AtomicBoolean`、`AtomicInteger`、`AtomicLong`、`AtomicReference`，主要用于在高并发环境下的高效程序处理,


以 `AtomicInteger` 为例，它是一个提供原子操作的 `Integer` 的类。在Java语言中，`++i` 和 `i++` 操作并不是线程安全的，在使用的时候，不可避免的会用到 `synchronized` 关键字。而 AtomicInteger 则通过一种线程安全的加减操作接口。


`AtomicInteger` 提供的一些方法如下。


```java

//增加1 并返回更新后的值
public final int incrementAndGet()

//减去1 并返回更新后的值
public final int decrementAndGet()


//获取当前的值
public final int get() 

//获取当前的值，并设置新的值
public final int getAndSet(int newValue)

//获取当前的值，并自增
public final int getAndIncrement()

//获取当前的值，并自减
public final int getAndDecrement() 

//获取当前的值，并加上预期的值
public final int getAndAdd(int delta) 
```



### AtomicInteger是如何保证线程安全的

* ref 1-[AtomicInteger如何保证线程安全](https://blog.csdn.net/qq_37514242/article/details/105161869)


```java
public class AtomicInteger extends Number implements java.io.Serializable {
    private static final long serialVersionUID = 6214790243416807050L;

    /*
     * This class intended to be implemented using VarHandles, but there
     * are unresolved cyclic startup dependencies.
     */
    private static final jdk.internal.misc.Unsafe U = jdk.internal.misc.Unsafe.getUnsafe();
    private static final long VALUE = U.objectFieldOffset(AtomicInteger.class, "value");

    private volatile int value;

    /**
     * Creates a new AtomicInteger with the given initial value.
     *
     * @param initialValue the initial value
     */
    public AtomicInteger(int initialValue) {
        value = initialValue;
    }

    /**
     * Creates a new AtomicInteger with initial value {@code 0}.
     */
    public AtomicInteger() {
    }
	
	public final int getAndIncrement() {
        return U.getAndAddInt(this, VALUE, 1);
    }
    
	...
	
}
```

AtomicInteger 类的部分代码如上，重点关注两个字段
1. `private volatile int value;` 中，`value` 被 `volatile` 字段修饰
2. `private static final jdk.internal.misc.Unsafe U = jdk.internal.misc.Unsafe.getUnsafe();` 中，`U` 是一个 `Unfase` 类型的对象



AtomicInteger 保证线程安全，主要通过如下两种手段
1. **用 volatile 关键字修饰 value 字段**
   * AtomicInteger 用 value 字段来存储数据值，volatile 关键字保证了 value 字段对各个线程的可见性。各线程读取 value 字段时，会先从主内存把数据同步到工作内存，这样保证可见性。
2. **Unsafe 实现操作原子性（通过 CAS，CAS 操作保证了多线程环境下对数据修改的安全性），用户在使用时无需额外的同步操作**
   * 如 AtomicInteger 提供了自增方法 `getAndIncrement`，其内部实现是由 Unsafe 类的 `compareAndSetInt` 方法来保证的。
   * `compareAndSetInt` 方法是一个 CAS 操作，用 native 关键字修饰。CAS 的原理是，先比较内存中的值与 expected 是否一致，一致的前提下才赋予新的值 x，此时返回 true，否则返回 false。


```java
    // jdk.internal.misc.Unsafe
   
    /**
     * Atomically updates Java variable to {@code x} if it is currently
     * holding {@code expected}.
     *
     * <p>This operation has memory semantics of a {@code volatile} read
     * and write.  Corresponds to C11 atomic_compare_exchange_strong.
     *
     * @return {@code true} if successful
     */
    @HotSpotIntrinsicCandidate
    public final native boolean compareAndSetInt(Object o, long offset,
                                                 int expected,
                                                 int x);

```





## 三个线程按序打印ABC一次



* [LeetCode-1114. 按序打印](https://leetcode.cn/problems/print-in-order/)



### Synhronized锁

使用 `Synchronized` 加锁，同时使用两个布尔变量记录是否完成了打印 A 和 B。



```java
class Foo {
    private Object lock = new Object();
    private boolean firstFinished = false;
    private boolean secondFinished = false;

    public Foo() {
       
    }
    public void first(Runnable printFirst) throws InterruptedException {
        synchronized(lock){
            printFirst.run();
            firstFinished = true;
            lock.notifyAll(); 
        }
       
    }
    public void second(Runnable printSecond) throws InterruptedException {
        synchronized(lock){
            while (!firstFinished) {
                lock.wait();
            }
            printSecond.run();
            secondFinished = true;
            lock.notifyAll();
        }

    }

    public void third(Runnable printThird) throws InterruptedException {
        synchronized (lock) {
           while (!secondFinished) {
                lock.wait();
            }
            printThird.run();
        } 
    }
}
```

### ReentrantLock + Condition


```java
class Foo {

    int num;
    Lock lock;
    //精确的通知和唤醒线程
    Condition condition1, condition2, condition3;

    public Foo() {
        num = 1;
        lock = new ReentrantLock();
        condition1 = lock.newCondition();
        condition2 = lock.newCondition();
        condition3 = lock.newCondition();
    }

    public void first(Runnable printFirst) throws InterruptedException {
        lock.lock();
        try {
            while (num != 1) {//不是1的时候，阻塞
                condition1.await();
            }
            printFirst.run();
            num = 2;
            condition2.signal();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }
    }

    public void second(Runnable printSecond) throws InterruptedException {
        lock.lock();
        try {
            while (num != 2) {//不是2的时候，阻塞
                condition2.await();
            }
            printSecond.run();
            num = 3;
            condition3.signal();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }
    }

    public void third(Runnable printThird) throws InterruptedException {
        lock.lock();
        try {
            while (num != 3) {//不是3的时候，阻塞
                condition3.await();
            }
            printThird.run();
            num = 1;
            condition1.signal();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }
    }
}
```


### AtomicInteger


```java
class Foo {
    private AtomicInteger firstJobDone = new AtomicInteger(0);
    private AtomicInteger secondJobDone = new AtomicInteger(0);
   

    public Foo() {
       
    }
    public void first(Runnable printFirst) throws InterruptedException {
        printFirst.run();
        firstJobDone.incrementAndGet();
       
    }
    public void second(Runnable printSecond) throws InterruptedException {
        while(firstJobDone.get() !=  1){
            //wait
        }
        printSecond.run();
        secondJobDone.incrementAndGet();
    }

    public void third(Runnable printThird) throws InterruptedException {
        while(secondJobDone.get() !=  1){
            //wait
        }
        printThird.run();
    }
}
```



### 信号量 Semaphore


Semaphore 可以控制同时访问共享资源的线程个数
1. 通过 `acquire` 方法获取一个信号量，信号量减一，如果没有就等待（阻塞）
2. 通过 `release` 方法释放一个信号量，信号量加一。

`Semaphore` 通过控制信号量的总数量，以及每个线程所需获取的信号量数量，进而控制多个线程对共享资源访问的并发度，以保证合理的使用共享资源。


```java
class Foo {
    private Semaphore s12 = new Semaphore(0);
    private Semaphore s23 = new Semaphore(0);
     
    
    public Foo() {
       
    }
    public void first(Runnable printFirst) throws InterruptedException {
        printFirst.run();
        s12.release(); //释放信号量 计数加1
       
    }
    public void second(Runnable printSecond) throws InterruptedException {
        s12.acquire();// 0的时候拿不到 没有会阻塞  当为1的时候，说明线程2可以拿到s12了
        printSecond.run();
        s23.release();//释放后s23的值会变成1
    }

    public void third(Runnable printThird) throws InterruptedException {
        s23.acquire();//0的时候拿不到 没有会阻塞 ，1的时候可以拿到
        printThird.run();
    }
}
```


### CountDownLatch

```java
class Foo {
    CountDownLatch latch12 = new CountDownLatch(1); //初始值设为1  
    CountDownLatch latch23 = new CountDownLatch(1);

    public Foo() {

    }

    public void first(Runnable printFirst) throws InterruptedException {
        printFirst.run();
        latch12.countDown();//唤醒线程2
    }

    public void second(Runnable printSecond) throws InterruptedException {
        latch12.await();//latch12的值为0会执行下面的语句，否则会在此次阻塞
        printSecond.run();
        latch23.countDown();//准备唤醒线程3
    }

    public void third(Runnable printThird) throws InterruptedException {
        latch23.await();//latch23的值为0会执行下面的语句，否则会在此次阻塞
        printThird.run();
    }
}
```




## 交替打印 FooBar

* [LeetCode-1115. 交替打印 FooBar](https://leetcode.cn/problems/print-foobar-alternately/)

### 信号量 Semaphore


使用信号量 `Semaphore`，每个信号量的 `acquire()` 方法都会阻塞，直到获取一个可用的许可证。

如果线程要访问一个资源就必须先获得信号量。如果信号量内部计数器大于 0，信号量减 1，然后允许共享这个资源；否则，如果信号量的计数器等于 0，信号量将会把线程置入休眠直至计数器大于0。当信号量使用完时，必须释放。



```java
class FooBar {
    private int n;
    private Semaphore fooSema = new Semaphore(1);
    private Semaphore barSema = new Semaphore(0);

    public FooBar(int n) {
        this.n = n;
    }

    public void foo(Runnable printFoo) throws InterruptedException {
        
        for (int i = 0; i < n; i++) {
            fooSema.acquire();  //值为1的时候，能拿到，执行下面的操作
            printFoo.run();
            barSema.release(); //释放许可给barSema这个信号量 barSema 的值 + 1
        }
    }

    public void bar(Runnable printBar) throws InterruptedException {
        
        for (int i = 0; i < n; i++) {
            barSema.acquire();//值为1的时候，能拿到，执行下面的操作
            printBar.run();
            fooSema.release();//释放许可给fooSema这个信号量 fooSema 的值+1
        }
    }
}
```




### Synchronized

```java
class FooBar {  
    private int n;
    private Object obj = new Object();
    private volatile boolean fooExec = true;

    public FooBar(int n) {
        this.n = n;
    }

    public void foo(Runnable printFoo) throws InterruptedException {

        for (int i = 0; i < n; i++) {
            synchronized (obj) {
                if (!fooExec) {//fooExec为false时，该线程等待，为true的时候执行下面的操作
                    obj.wait();
                }
                printFoo.run();
                fooExec = false;
                obj.notifyAll();//唤醒其他线程
            }

        }
    }

    public void bar(Runnable printBar) throws InterruptedException {

        for (int i = 0; i < n; i++) {
            synchronized (obj) {
                if (fooExec) {
                    obj.wait();
                }
                printBar.run();
                fooExec = true;
                obj.notifyAll();
            }

        }
    }
}
```


### ReentrantLock


注意，该方案由于独占锁的独占性，会在 `n>5` 时候提示超时。


```java
class FooBar {
    private int n;
    private ReentrantLock lock = new ReentrantLock(true);
    volatile boolean fooExec = true;

    public FooBar(int n) {
        this.n = n;
    }

    public void foo(Runnable printFoo) throws InterruptedException {
        for (int i = 0; i < n; ) {
            lock.lock();
            try {
                if (fooExec) {
                    printFoo.run();
                    fooExec = false;
                    i++;
                }
            } finally {
                lock.unlock();
            }

        }
    }

    public void bar(Runnable printBar) throws InterruptedException {
        for (int i = 0; i < n; ) {
            lock.lock();
            try {
                if (!fooExec) {
                    printBar.run();
                    fooExec = true;
                    i++;
                }
            } finally {
                lock.unlock();
            }
        }
    }
}
```



### Thread.yield()



```java
class FooBar {
    private int n;
    volatile boolean fooExec = true;//foo可以执行

    public FooBar(int n) {
        this.n = n;
    }

    public void foo(Runnable printFoo) throws InterruptedException {
        for (int i = 0; i < n; ) {
            if (fooExec) {
                printFoo.run();
                fooExec = false;
                i++;
            } else {
                Thread.yield();
            }
        }
    }

    public void bar(Runnable printBar) throws InterruptedException {
        for (int i = 0; i < n; ) {
            if (!fooExec) {
                printBar.run();
                fooExec = true;
                i++;
            } else {
                Thread.yield();
            }
        }
    }
}

```

### CyclicBarrier





```java
import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;

class Main {

    //input
    public static void main(String[] args) {
        FooBar fooBar = new FooBar(10);//打印10次foo bar
        Runnable printFoo = () -> {
            System.out.printf("%s\n", "foo");
        };
        Runnable printBar = () -> {
            System.out.printf("%s\n", "bar");
        };
        Thread fooThread = new Thread(() -> {
            try {
                fooBar.foo(printFoo);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        });
        Thread barThread = new Thread(() -> {
            try {
                fooBar.bar(printBar);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        });
        fooThread.start();
        barThread.start();

    }

    static class FooBar {
        private int n;

        private CyclicBarrier cb = new CyclicBarrier(2); //表示两个线程
        volatile boolean fooExec = true;

        public FooBar(int n) {
            this.n = n;
        }

        public void foo(Runnable printFoo) throws InterruptedException {

            for (int i = 0; i < n; i++) {
                while (!fooExec) {
                    //false的时候，bar线程在执行，foo线程在这此处空转
                }
                printFoo.run();//打印foo
                fooExec = false;//设置变量
                try {
                    cb.await();//线程foo到达同步点
                } catch (BrokenBarrierException e) {
                    e.printStackTrace();
                }
            }
        }

        public void bar(Runnable printBar) throws InterruptedException {

            for (int i = 0; i < n; i++) {
                try {
                    cb.await();
                } catch (BrokenBarrierException e) {
                    e.printStackTrace();
                }
                printBar.run();
                fooExec = true;

            }
        }
    }
}
```


## 三个线程按序打印线程名和ABC八次



### synchronized


先使用 `synchronized` 打印一次线程名和 ABC，代码实现如下。

```java
public class Main {

    private static Object lock = new Object();
    private static boolean hasFinishedA = false;
    private static boolean hasFinishedB = false;

    public static void main(String[] args) {
        // thread 1
        Thread thread1 = new Thread(new Runnable() {
            @Override
            public void run(){
                try{
                    printA();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },"thread 1");

        // thread 2
        Thread thread2 = new Thread(new Runnable() {
            @Override
            public void run(){
                try{
                    printB();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },"thread 2");

        // thread 3
        Thread thread3 = new Thread(new Runnable() {
            @Override
            public void run(){
                try{
                    printC();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },"thread 3");

        try{
            thread1.start();
            thread2.start();
            thread3.start();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public static void printA() throws InterruptedException{
        synchronized(lock){
            System.out.println(Thread.currentThread().getName() + " A");
            hasFinishedA = true;
            lock.notifyAll();
        }
    }

    public static void printB() throws InterruptedException{
        synchronized(lock){
            while(!hasFinishedA){
                lock.wait();
            }
            System.out.println(Thread.currentThread().getName() + " B");
            hasFinishedB = true;
            lock.notifyAll();
        }
    }

    public static void printC() throws InterruptedException{
        synchronized(lock){
            while(!hasFinishedB){
                lock.wait();
            }
            System.out.println(Thread.currentThread().getName() + " C");
            lock.notifyAll();
        }
    }
}
```


执行上述代码，程序输出如下。


```s
thread 1 A
thread 2 B
thread 3 C
```


继续，实现循环 8 次打印。注意，加锁应该加在 for 循环内部，而不是加到 for 循环外面。



```java
public class Main {

    private static Object lock = new Object();
    private static boolean hasFinishedA = false;
    private static boolean hasFinishedB = false;

    private static boolean hasFinishedC = true;

    public static void main(String[] args) {
        // thread 1
        Thread thread1 = new Thread(new Runnable() {
            @Override
            public void run(){
                try{
                    printA();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },"thread 1");

        // thread 2
        Thread thread2 = new Thread(new Runnable() {
            @Override
            public void run(){
                try{
                    printB();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },"thread 2");

        // thread 3
        Thread thread3 = new Thread(new Runnable() {
            @Override
            public void run(){
                try{
                    printC();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },"thread 3");

        try{
            thread1.start();
            thread2.start();
            thread3.start();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public static void printA() throws InterruptedException{
        for(int i=0;i<8;i++){
            synchronized(lock){
                while(!hasFinishedC){
                    lock.wait();
                }
                System.out.println(Thread.currentThread().getName() + " A");
                hasFinishedA = true;
                hasFinishedB = false;
                hasFinishedC = false;
                lock.notifyAll();
            }
        }

    }

    public static void printB() throws InterruptedException{
        for(int i=0;i<8;i++){
            synchronized(lock){
                while(!hasFinishedA){
                    lock.wait();
                }
                System.out.println(Thread.currentThread().getName() + " B");
                hasFinishedA = false;
                hasFinishedB = true;
                hasFinishedC = false;
                lock.notifyAll();
            }
        }

    }

    public static void printC() throws InterruptedException{
        for(int i=0;i<8;i++){
            synchronized(lock){
                while(!hasFinishedB){
                    lock.wait();
                }
                System.out.println(Thread.currentThread().getName() + " C");
                hasFinishedA = false;
                hasFinishedB = false;
                hasFinishedC = true;
                lock.notifyAll();
            }
        }

    }
}
```


执行上述代码，程序输出如下。


```s
thread 1 A
thread 2 B
thread 3 C
thread 1 A
thread 2 B
thread 3 C
thread 1 A
thread 2 B
thread 3 C
thread 1 A
thread 2 B
thread 3 C
thread 1 A
thread 2 B
thread 3 C
thread 1 A
thread 2 B
thread 3 C
thread 1 A
thread 2 B
thread 3 C
thread 1 A
thread 2 B
thread 3 C

```


### 信号量 Semaphore

```java
import java.util.concurrent.Semaphore;

public class Main {

    private static Semaphore s1 = new Semaphore(1);
    private static Semaphore s2 = new Semaphore(0);
    private static Semaphore s3 = new Semaphore(0);

    public static void main(String[] args) {
        // thread 1
        Thread thread1 = new Thread(new Runnable() {
            @Override
            public void run(){
                try{
                    printA();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },"thread 1");

        // thread 2
        Thread thread2 = new Thread(new Runnable() {
            @Override
            public void run(){
                try{
                    printB();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },"thread 2");

        // thread 3
        Thread thread3 = new Thread(new Runnable() {
            @Override
            public void run(){
                try{
                    printC();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },"thread 3");

        try{
            thread1.start();
            thread2.start();
            thread3.start();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public static void printA() throws InterruptedException{
        for(int i=0;i<8;i++){
            s1.acquire(); //值为1的时候拿到  否则阻塞等待
            System.out.println(Thread.currentThread().getName() + " A");
            s2.release(); //释放s2  信号量 + 1
        }
    }

    public static void printB() throws InterruptedException{
        for(int i=0;i<8;i++){
            s2.acquire(); //值为1的时候拿到  否则阻塞等待
            System.out.println(Thread.currentThread().getName() + " B");
            s3.release(); //释放s3  信号量 + 1
        }
    }

    public static void printC() throws InterruptedException{
        for(int i=0;i<8;i++){
            s3.acquire(); //值为1的时候拿到  否则阻塞等待
            System.out.println(Thread.currentThread().getName() + " C");
            s1.release(); //释放s1  信号量 + 1
        }

    }
}
```

### AtomicInteger


```java
import java.util.concurrent.Semaphore;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Main {
    private static AtomicInteger firstJobDone = new AtomicInteger(1);
    private static AtomicInteger secondJobDone = new AtomicInteger(0);
    private static AtomicInteger thirdJobDone = new AtomicInteger(0);

    public Main(){

    }
    public static void main(String[] args) {
        // thread 1
        Thread thread1 = new Thread(new Runnable() {
            @Override
            public void run(){
                try{
                    printA();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },"thread 1");

        // thread 2
        Thread thread2 = new Thread(new Runnable() {
            @Override
            public void run(){
                try{
                    printB();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },"thread 2");

        // thread 3
        Thread thread3 = new Thread(new Runnable() {
            @Override
            public void run(){
                try{
                    printC();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },"thread 3");

        try{
            thread1.start();
            thread2.start();
            thread3.start();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public static void printA() throws InterruptedException{

        for(int i=0;i<8;i++){
            while(firstJobDone.get() != 1){
            }
            System.out.println(Thread.currentThread().getName() + " A");
            secondJobDone.incrementAndGet();
            firstJobDone.decrementAndGet();
        }
    }

    public static void printB() throws InterruptedException{
        for(int i=0;i<8;i++) {
            while(secondJobDone.get() != 1){
            }
            System.out.println(Thread.currentThread().getName() + " B");
            thirdJobDone.incrementAndGet();
            secondJobDone.decrementAndGet();
        }
    }

    public static void printC() throws InterruptedException{
        for(int i=0;i<8;i++) {
            while(thirdJobDone.get() != 1){
            }
            System.out.println(Thread.currentThread().getName() + " C");
            firstJobDone.incrementAndGet();
            thirdJobDone.decrementAndGet();
        }

    }
}
```


## 实现一个生产者和消费者

* [Java多种方式解决生产者消费者问题 | CSDN](https://blog.csdn.net/ldx19980108/article/details/81707751)



实现一个生产者和消费者的核心问题是，保证同一资源被多个线程并发访问时的完整性。常用的同步方法是采用信号或加锁机制，保证资源在任意时刻至多被一个线程访问。


Java 中实现的几种方式
1. wait()/notify() 方法
2. await()/signal() 方法
3. BlockingQueue 阻塞队列方法
4. 信号量
5. 管道


### wait()/notify()方法
1. 当缓冲区已满时，生产者线程停止执行，放弃锁，使自己处于等状态，让其他线程执行；
2. 当缓冲区已空时，消费者线程停止执行，放弃锁，使自己处于等状态，让其他线程执行。
3. 当生产者向缓冲区放入一个产品时，向其他等待的线程发出可执行的通知，同时放弃锁，使自己处于等待状态；
4. 当消费者从缓冲区取出一个产品时，向其他等待的线程发出可执行的通知，同时放弃锁，使自己处于等待状态。


此处以仓库存储商品，生产者进行生产，消费者进行消费为例，进行说明。


* 仓库存储和仓库容量


```java
import java.util.LinkedList;

public class Storage {

    // 仓库容量
    private final int MAX_SIZE = 10;
    // 仓库存储的载体
    private LinkedList<Object> list = new LinkedList<>();

    public void produce() {
        synchronized (list) {
            while (list.size() + 1 > MAX_SIZE) {
                System.out.println("【生产者" + Thread.currentThread().getName()
		                + "】仓库已满");
                try {
                    list.wait(); //等待
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            list.add(new Object());
            System.out.println("【生产者" + Thread.currentThread().getName()
                    + "】生产一个产品，现库存" + list.size());
            list.notifyAll(); //通知
        }
    }

    public void consume() {
        synchronized (list) {
            while (list.size() == 0) {
                System.out.println("【消费者" + Thread.currentThread().getName() 
						+ "】仓库为空");
                try {
                    list.wait(); //等待
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            list.remove();
            System.out.println("【消费者" + Thread.currentThread().getName()
                    + "】消费一个产品，现库存" + list.size());
            list.notifyAll(); //通知
        }
    }
}
```

* 生产者


```java
public class Producer implements Runnable{
    private Storage storage;

    public Producer(){}

    public Producer(Storage storage){
        this.storage = storage;
    }

    @Override
    public void run(){
        while(true){
            try{
                Thread.sleep(1000);
                storage.produce();
            }catch (InterruptedException e){
                e.printStackTrace();
            }
        }
    }
}
```


* 消费者

```java
public class Consumer implements Runnable{
    private Storage storage;

    public Consumer(){}

    public Consumer(Storage storage){
        this.storage = storage;
    }

    @Override
    public void run(){
        while(true){
            try{
                Thread.sleep(3000);
                storage.consume();
            }catch (InterruptedException e){
                e.printStackTrace();
            }
        }
    }
}
```

* 主函数


```java
public class Main {

    public static void main(String[] args) {
        Storage storage = new Storage();
        Thread p1 = new Thread(new Producer(storage));
        Thread p2 = new Thread(new Producer(storage));
        Thread p3 = new Thread(new Producer(storage));

        Thread c1 = new Thread(new Consumer(storage));
        Thread c2 = new Thread(new Consumer(storage));
        Thread c3 = new Thread(new Consumer(storage));

        p1.start();
        p2.start();
        p3.start();
        c1.start();
        c2.start();
        c3.start();
    }
}
```


* 程序运行结果

```s
生产者p1】生产一个产品，现库存1
【生产者p2】生产一个产品，现库存2
【生产者p3】生产一个产品，现库存3
【生产者p1】生产一个产品，现库存4
【生产者p2】生产一个产品，现库存5
【生产者p3】生产一个产品，现库存6
【生产者p1】生产一个产品，现库存7
【生产者p2】生产一个产品，现库存8
【消费者c1】消费一个产品，现库存7
【生产者p3】生产一个产品，现库存8
【消费者c2】消费一个产品，现库存7
【消费者c3】消费一个产品，现库存6
【生产者p1】生产一个产品，现库存7
【生产者p2】生产一个产品，现库存8
【生产者p3】生产一个产品，现库存9
【生产者p1】生产一个产品，现库存10
【生产者p2】仓库已满
【生产者p3】仓库已满
【生产者p1】仓库已满
【消费者c1】消费一个产品，现库存9
【生产者p1】生产一个产品，现库存10
【生产者p3】仓库已满

...
```