
# Java Notes-23-《Java并发编程之美》阅读笔记


[TOC]


## 更新
* 2020/09/06，撰写



## 参考资料料

* 《Java并发编程之美》


## 并发编程基础

### 创建线程的3种方式

Java 中有 3 种线程创建方式
1. 实现 `Runnable` 接口的 `run` 方法 (线程任务无返回值)
2. 继承 `Thread` 类并重写 `run` 方法 (线程任务无返回值)，Java不支持多重继承，若继承了 `Thread` 类，则不能再继承其他类。而 `Runnable` 则没有这个限制。
3. 使用 `FutureTask` 方式 (线程任务有返回值)


使用 `FutureTask` 方式 (线程任务有返回值) 的示例代码如下。


```java
import java.util.concurrent.Callable;

public class CallerTask implements Callable<String> {

    /**
     * Computes a result, or throws an exception if unable to do so.
     *
     * @return computed result
     * @throws Exception if unable to compute a result
     */
    @Override
    public String call() throws Exception {
        return "CallerTask return value";
    }
}
```


```java
public class FirstJavaTest {

    public static void main(String[] args) throws Exception {

        //创建异步任务
        FutureTask<String> futureTask = new FutureTask<>(new CallerTask());

        //启动线程
        new Thread(futureTask).start();

        try{
            //等待任务执行完毕 并返回结果
            String res = futureTask.get();
            System.out.println(res);  //CallerTask return value
        } catch (ExecutionException e){
            e.printStackTrace();
        }
    }
}
```


### 线程通知和等待

#### wait

当一个线程调用一个共享变量的 `wait()` 方法，该调用线程会被阻塞挂起，直到发生下面的情况之一才返回
1. 其他线程调用了该共享对象的 `notify()` 或者 `notifyAll()` 方法
2. 其他线程调用了该线程的 `interrupt()` 方法，该线程抛出 `InterruptedException` 异常返回**并终止**

另外需要注意的是，如果调用 `wait()` 方法的线程没有事先获取该对象的监视器锁，则调用该方法时调用线程会抛出 `IllegalMonitorStateException` 异常。

那么一个线程如何才能获取一个共享变量的监视器锁呢？

1. 执行 `synchronized` 同步代码块时，使用该共享变量作为参数


```java
synchronized (共享变量) {
    // doSomething
}
```
    
2. 调用该共享变量的方法，并且该方法使用了 `syhchronized` 修饰


```java
synchronized void add(int a, int b){
    // doSomething
}
```


#### notify

一个线程调用共享变量的 `notify` 方法后，会唤醒一个在该共享变量上调用 `wait` 系列方法后被挂起的线程。一个共享变量上可能会有多个线程在等待，具体唤醒哪个等到的线程是随机的。

此外，**被唤醒的线程不能马上从 `wait()` 方法返回并继续执行，它必须在获取了共享对象的监视器锁后，才可以返回。**

也就是唤醒它的线程释放了共享变量上的监视器锁后，被唤醒的线程也不一定会获取到共享对象的监视器锁，这是因为该线程还需要和其他线程一起竞争该锁，只有该线程竞争到了共享变量的监视器锁后才可以继续执行。


类似 `wait()` 系列方法，只有当前线程获取到了共享变量的监视器锁后，才可以调用共享变量的 `notify()` 方法，否则会抛出 `Illega!MonitorStateException` 异常。


### join - 等待线程执行中止

`join()` 方法是 `Thread` 类直接提供的，而 `wait()` 和 `notify()` 是 `Object` 的方法。

`join()` 方法是无参且返回值为 `void` 的方法。


`join` 方法，一种特殊的 `wait`，当前运行线程调用另一个线程的 `join` 方法，当前线程进入阻塞状态直到调用 `join` 方法的线程结束，再继续执行。

**<font color="red">`t.join()` 方法只会使调用 `t.join()` 的当前线程进入等待池，并等待 `t` 线程执行完毕后才会被唤醒。并不影响同一时刻处在运行状态的其他线程。</font>**


### sleep - 让线程睡眠

`Thead` 类的 `sleep()` 静态方法，会让调用线程暂时让出指定时间的执行权，也就是在这期间不参与 CPU 调度，但是该线程所拥有的监视器资源，比如锁还是持有不让出的。指定的睡眠时间到了后该函数会正常返回，线程就处于就绪状态，然后参与 CPU 的调度，获取到 CPU 资源后就可以继
续运行了。

如果在睡眠期间其他线程调用了该线程的 `interrupt()` 方法中断了该线程，则该
线程会在调用 `sleep` 方法的地方抛出 `InterruptedException` 异常而返回。


### yield - 让出CPU执行权

当一个线程调用 `yield` 方法时， 当前线程会让出 CPU 使用权，然后处于就绪状态，线程调度器会从线程就绪队列里面获取一个线程优先级最高的线程，当然也有可能会调度到刚刚让出 CPU 的那个线程来获取 CPU 执行权。


### yield对比sleep

`sleep` 与 `yield` 方法的区别在于，当线程调用 `sleep` 方法时调用线程会被阻塞挂
起指定的时间，在这期间线程调度器不会去调度该线程。而调用 `yield` 方法时，线程只是
让出自己剩余的时间片，并没有被阻塞挂起，而是处于就绪状态，线程调度器下一次调度
时就有可能调度到当前线程执行。


