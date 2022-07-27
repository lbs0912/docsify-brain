# 多线程-04-ThreadLocal

[TOC]



## 更新
* 2022/01/21，撰写
* 2022/04/28，添加 *InheritableThreadLocal*

## 参考资料
* [ThreadLocal详解 | Java全栈知识体系](https://www.pdai.tech/md/java/thread/java-thread-x-threadlocal.html)
* [并发容器之ThreadLocal详解 | CSDN](https://blog.csdn.net/ThinkWon/article/details/102508381)
* [Java进阶之ThreadLocal | 掘金](https://juejin.cn/post/6937565518354186271)
* [ThreadLocal内存泄漏分析与解决方案](https://blog.csdn.net/ThinkWon/article/details/102508721)
* 冰河技术-深入理解高并发编程 - 「ThreadLocal学会了这些，你也能和面试官扯皮了」章节



## 什么是ThreadLocal

`ThreadLocal` 是一个线程内部的数据存储类，可以在指定线程中存储数据（线程本地变量），且只有在该指定线程中才可以获取存储数据。

线程本地变量存储在 `ThreadLocalMap` 中， `ThreadLocalMap` 是 `ThreadLocal` 的一个内部类，`ThreadLocalMap` 内部维护了一个 `Entry` 类型的 `table` 数组。

**线程 `Thread` 通过调用 `ThreadLocal` 提供的 `get` 和 `set` 方法来从读/写存储在 `ThreadLocalMap` 中的变量的值。**

### threadLocals和inheritableThreadLocals

* `Thread` 类

```java
public class Thread implements Runnable {

    /* ThreadLocal values pertaining to this thread. This map is maintained
     * by the ThreadLocal class. */
    ThreadLocal.ThreadLocalMap threadLocals = null;

    /*
     * InheritableThreadLocal values pertaining to this thread. This map is
     * maintained by the InheritableThreadLocal class.
     */
     //inheritableThreadLocals的使用 见本文末 「inheritableThreadLocal」 章节
    ThreadLocal.ThreadLocalMap inheritableThreadLocals = null;
}
```


从 `Thread` 类的源码可以看出，在 `ThreadLocal` 类中存在成员变量`threadLocals` 和 `inheritableThreadLocals`，这两个成员变量都是`ThreadLocalMap` 类型的变量，而且二者的初始值都为 `null`。只有当前线程第一次调用 `ThreadLocal` 的 `set()` 方法或者 `get()` 方法时才会实例化变量。


此处需要注意的是，每个线程的本地变量不是存放在 `ThreadLocal` 实例里面的，而是存放在调用线程的 `ThreadLocalMap` 类型的 `threadLocals/inheritableThreadLocals` 变量中。也就是说，**调用 `ThreadLocal` 的 `set()` 方法存储的本地变量，是存放在具体线程的内存空间中的，而 `ThreadLocal` 类只是提供了 `set()` 和 `get()` 方法来存储和读取本地变量的值。**


> 当调用 `ThreadLocal` 类的 `set()` 方法时，把要存储的值放入调用线程的 `ThreadLocalMap` 类型的 `threadLocals` 变量中中存储起来。
> 
> 当调用 `ThreadLocal` 类的 `get()` 方法时，从当前线程的 `ThreadLocalMap` 类型的 `threadLocals` 变量中将存储的值取出来。

### ThreadLocalMap


*  `ThreadLocal` 部分源码如下

```java
public class ThreadLocal<T> {
    public T get() {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null) {
            ThreadLocalMap.Entry e = map.getEntry(this);
            if (e != null) {
                @SuppressWarnings("unchecked")
                T result = (T)e.value;
                return result;
            }
        }
        return setInitialValue();
    }

    // ...

    static class ThreadLocalMap {

        /**
         * The entries in this hash map extend WeakReference, using
         * its main ref field as the key (which is always a
         * ThreadLocal object).  Note that null keys (i.e. entry.get()
         * == null) mean that the key is no longer referenced, so the
         * entry can be expunged from table.  Such entries are referred to
         * as "stale entries" in the code that follows.
         */
        static class Entry extends WeakReference<ThreadLocal<?>> {
            /** The value associated with this ThreadLocal. */
            Object value;

            private Entry[] table;
            
            Entry(ThreadLocal<?> k, Object v) {
                super(k);
                value = v;
            }
        }

        // ...
   }

}
```


![java-threadlocal-design-6](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/java-threadlocal-design-6.png)


结合上述源码和结构图，可知
1. **`ThreadLocalMap` 是 `ThreadLocal` 的内部类，内部维护了一个 `Entry` 类型的 `table` 数组。**
2. **`Entry` 对象由 `Key` 和 `Value` 两个成员变量，`key` 是对 `ThreadLocal` 对象的弱引用（`WeakReference`），`Value` 是针对这个`threadLocal` 存入的 `Object` 类型对象。**
3. **`Key` 弱引用 `threadLocal`，每次 GC，如果 `threadLocal` 对象只剩下被这个 `ThreadLocalMap` 的 `key` 弱引用， 那么对象将被回收掉，`Key` 为 `null` 值（此时易造对应 `value` 的内存泄露）。**



### Demo

下面给出一个示例代码，加深理解。

```java
        // 创建 Boolean 类型的 ThreadLocal 对象
        ThreadLocal<Boolean> mBooleanThread = new ThreadLocal<Boolean>();
        mBooleanThread.set(true);  // 主线程中设置为 true
        System.out.println(Thread.currentThread().getName() + "-" + mBooleanThread.get());      // 主线程中获取为 true

        new Thread("Thread #1") {
            @Override
            public void run() {
                mBooleanThread.set(false);                // 子线程1中设置为 false
                // 子线程1中获取为 false
                System.out.println(Thread.currentThread().getName() + "-" + mBooleanThread.get());
            }
        }.start();

        new Thread("Thread #2") {
            @Override
            public void run() {                       // 子线程2中不去设置
                 // 子线程2中获取为 null
                System.out.println(Thread.currentThread().getName() + "-" + mBooleanThread.get());
            }
        }.start();
```

执行上述代码，输出如下。可以看到，在不同的线程中操作 `ThreadLocal` 是互不影响的。


```s
main-true
Thread #1-false
Thread #2-null
```




## ThreadLocal的用处

1. 线程隔离：提供线程内的局部变量，不同的线程之间不会相互干扰，这种变量在线程的生命周期内起作用。
2. 传递数据：减少同一个线程内多个函数或组件之间一些公共变量传递的复杂度。



## ThreadLocal原理解析

### 内部设计

1. 早期方案

早期的方案设计中，每个 `ThreadLocal` 都创建一个 `ThreadLocalMap`，用 `Thread` 作为 Map 的 key，要存储的局部变量作为 Map 的 value。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/java-threadlocal-design-1.png)


2. Java 8 方案


在Java8方案中，每个 `Thread` 维护一个 `ThreadLocalMap`，用 `ThreadLocal` 实例本身 作为 Map 的 key，要存储的局部变量作为 Map 的 value。
* 每个 `Thread` 线程内部都有一个 Map（`ThreadLocalMap`）
* Map 里面存储 `ThreadLocal` 对象（ key）和线程的变量副本（value）
* `Thread` 内部的 Map 是由 `ThreadLocal` 维护的，由 `ThreadLocal` 负责向 Map 获取和设置线程的变量值。
* 对于不同的线程，每次获取副本值时，别的线程并不能获取到当前线程的副本值，形成了线程的隔离，互不干扰。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/java-threadlocal-design-2.png)


### ThreadLocal核心方法

|              方法声明       |            描述          |
|----------------------------|-------------------------|
| protected T initialValue() | 返回当前线程局部变量的初始值 |
| public void set(T value)   | 设置当前线程绑定的局部变量   |
|   public T get()           | 获取当前线程绑定的局部变量   |
| public void remove()       | 移除当前线程绑定的局部变量   |



`remove()` 对应的源码如下。需要注意的是，如果调用线程一直不终止，则本地变量会一直存放在调用线程的 `threadLocals` 成员变量中，所以，如果不需要使用本地变量时，可以通过调用 `ThreadLocal` 的 `remove()` 方法，将本地变量从当前线程的`threadLocals` 成员变量中删除，以免出现「内存溢出」的问题。


```java
    public void remove() {
        //根据当前线程获取threadLocals成员变量
         ThreadLocalMap m = getMap(Thread.currentThread());
         if (m != null)
            ////threadLocals成员变量不为空，则移除value值
             m.remove(this);
     }
```

## ThreadLocal源码分析

`ThreadLocalMap` 是 `ThreadLocal` 的静态内部类，`ThreadLocalMap` 并没有实现 Map 接口。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/java-threadlocal-design-3.png)


```java
public class ThreadLocal<T> {

    // ...

    // 初始容量，必须是2的幂
    private static final int INITIAL_CAPACITY = 16;

    // 用于存放数据的table，长度必须是2的幂
    private Entry[] table;

    // 数组里面元素的个数，用于判断table的当前使用量是否超过阈值
    private int size = 0;

    // 进行扩容的阈值，当使用量大于它是就要进行扩容
    private int threshold; // Default to 0



    static class ThreadLocalMap {

        /**
         * The entries in this hash map extend WeakReference, using
         * its main ref field as the key (which is always a
         * ThreadLocal object).  Note that null keys (i.e. entry.get()
         * == null) mean that the key is no longer referenced, so the
         * entry can be expunged from table.  Such entries are referred to
         * as "stale entries" in the code that follows.
         */
        // 继承自WeakReference，将ThreadLocal对象的生命周期与线程的生命周期解绑
        // 如果key为null（entry.get() == null）则表示key不再被引用了，此时entry也可以从table中清除掉
        static class Entry extends WeakReference<ThreadLocal<?>> {
            /** The value associated with this ThreadLocal. */
            Object value;
            // 只能使用ThreadLocal作为key，来存储K-V结构的数据
            Entry(ThreadLocal<?> k, Object v) {
                super(k);
                value = v;
            }
        }

        // ...
   }

}
```


## ThreadLocal内存泄漏

如上 `ThreadLocal` 源码可知，`ThreadLocalMap` 中的 key 使用了弱引用，将将 `ThreadLocal` 对象的生命周期与线程的生命周期解绑。


`ThreadLocalMap` 的 `Entry`，只能使用 `ThreadLocal` 作为 key，来存储K-V 结构的数据。


下面，讨论下为什么 `ThreadLocalMap` 中的 key 要使用弱引用，使用强引用可以吗，以及为什么会造成内存泄露。


### 如果key是强引用

`ThreadLocalMap` 中的 key 使用了强引用，会导致 `key`（即 `threadLocal`） 和 `value` 出现内存泄漏。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/java-threadlocal-design-4.png)


* 假设在业务代码中使用完 `ThreadLocal`，`threadLocalRef` 被回收了
* 由于 `threadLocalMap` 的 `Entry` 强引用了 `threadLocal`，造成 `threadLocal` 无法被回收
* 在没有手动删除这个 `Entry` 以及 `CurrentThread` 依然运行的前提下，始终有引用链 `threadRef` -> `currentThread` -> `threadLocalMap` -> `entry`，`Entry` 就不会被回收，导致 `Entry` 内存泄漏（`threadLocal` 和 `value` 同时出现内存泄漏）


### key是弱引用时

`ThreadLocalMap` 中的 key 使用了弱引用，会导致 value 出现内存泄漏。



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/java-threadlocal-design-5.png)


* 假设在业务代码中使用完 `ThreadLocal`，`threadLocalRef` 被回收了
* 由于 `ThreadLocalMap` 只持有 `ThreadLocal` 的弱引用，没有任何强引用指向 `threadlocal` 实例，所以 `threadlocal` 就可以顺利被 GC 回收，此时 Entry 中的 `key = null`
* 在没有手动删除这个 Entry 以及 `CurrentThread` 依然运行的前提下，也存在有强引用链 `threadRef` -> `currentThread` -> `threadLocalMap` -> `entry` -> `value`，`value` 不会被回收，而这块 `value` 永远不会被访问到了，导致 `value` 内存泄漏



### 导致内存泄漏的原因
1. 没有手动删除相应的 `Entry` 对象
2. 当前线程依然在运行

### 如何解决内存泄露
1. 使用完 `ThreadLocal`，调用其 `remove` 方法删除对应的 `Entry`
2. 使用完 `ThreadLocal`，当前 `Thread` 也随之运行结束（不好控制，线程池中的核心线程不会销毁）


### 内存泄露Demo

* ref 1-[ThreadLocal内存泄漏案例分析实战](https://juejin.cn/post/6982121384533032991)


```java
/**
 * 测试threadLocal内存泄漏
 * 01:固定6个线程，每个线程持有一个变量
 * 按理来说会有 6 * 5 = 30M内存无法回收，其余的在set方法中覆盖了。
 */
public class ThreadLocalOutOfMemoryTest {
    static class LocalVariable {
        //总共有5M
        private byte[] locla = new byte[1024 * 1024 * 5];
    }

    // (1)创建了一个核心线程数和最大线程数为 6 的线程池，这个保证了线程池里面随时都有 6 个线程在运行
    final static ThreadPoolExecutor poolExecutor = new ThreadPoolExecutor(6, 6, 1, TimeUnit.MINUTES,
            new LinkedBlockingQueue<>());
    // (2)创建了一个 ThreadLocal 的变量，泛型参数为 LocalVariable，LocalVariable 内部是一个 Long 数组
    static ThreadLocal<LocalVariable> localVariable = new ThreadLocal<LocalVariable>();

    public static void main(String[] args) throws InterruptedException {
        // (3)向线程池里面放入 50 个任务
        for (int i = 0; i < 50; ++i) {
            poolExecutor.execute(new Runnable() {
                @Override
                public void run() {
                    // (4) 往threadLocal变量设置值
                    LocalVariable localVariable = new LocalVariable();
                    // 会覆盖
                    ThreadLocalOutOfMemoryTest.localVariable.set(localVariable);
                    // (5) 手动清理ThreadLocal
                    System.out.println("thread name end：" + Thread.currentThread().getName() + ", value:"+ ThreadLocalOutOfMemoryTest.localVariable.get());
//                    ThreadLocalOutOfMemoryTest.localVariable.remove();

                }
            });

            Thread.sleep(1000);
        }

        // (6)是否让key失效，都不影响。只要持有的线程存在，都无法回收。
        //ThreadLocalOutOfMemoryTest.localVariable = null;
        System.out.println("pool execute over");
    }
}
```


## ThreadLocal变量不具有传递性

使用 `ThreadLocal` 存储本地变量不具有传递性，也就是说，同一个 `ThreadLocal` 在父线程中设置值后，在子线程中是无法获取到这个值的，这个现象说明 `ThreadLocal` 中存储的本地变量不具有传递性。


### 不具有传递性示例

```java
public class ThreadLocalTest { 
    private static ThreadLocal<String> threadLocal = new ThreadLocal<String>(); 
    
    public static void main(String[] args){ 
        //在主线程中设置值 
        threadLocal.set("ThreadLocalTest"); 
        
        //在子线程中获取值 
        Thread thread = new Thread(new Runnable() { 
            @Override 
            public void run() { 
                System.out.println("子线程获取值：" + threadLocal.get()); 
            } 
        }); 
        //启动子线程 
        thread.start(); 
        //在主线程中获取值 
        System.out.println("主线程获取值：" + threadLocal.get()); 
    }
}
```

执行代码，输出信息如下。

```s
主线程获取值：ThreadLocalTest
Test 子线程获取值：null
```

可以看出，在主线程中向 `ThreadLocal` 设置值后，在子线程中是无法获取到这个值
的。那有没有办法在子线程中获取到主线程设置的值呢？

此时，我们可以使用 `InheritableThreadLocal` 来解决这个问题。


### InheritableThreadLocal


```java
public class InheritableThreadLocal<T> extends ThreadLocal<T> {
    protected T childValue(T parentValue) {
        return parentValue;
    }
    ThreadLocalMap getMap(Thread t) {
       return t.inheritableThreadLocals;
    }

    void createMap(Thread t, T firstValue) {
        t.inheritableThreadLocals = new ThreadLocalMap(this, firstValue);
    }
}
```


`InheritableThreadLocal` 类继承自 `ThreadLocal` 类，它能够让子线程访问到在父线程中设置的本地变量的值，例如，我们将 `ThreadLocalTest` 类中的`threadLocal` 静态变量改写成 `InheritableThreadLocal` 类的实例，如下所示。



```java
public class ThreadLocalTest { 

    private static ThreadLocal<String> threadLocal = new InheritableThreadLocal<String>(); 
    
    public static void main(String[] args){ 
        // 此处同上 省略
    }
}
```

执行代码，输出信息如下。

```s
主线程获取值：ThreadLocalTest
Test 子线程获取值：ThreadLocalTest
```

可以看到，使用 `InheritableThreadLocal` 类存储本地变量时，子线程能够获取到父线程中设置的本地变量。



## FAQ 

### 线程池下使用ThreadLocal

* ref 1-[线程池下ThreadLocal引发的故障 | 掘金](https://juejin.cn/post/7095627880482209822)


使用线程池时，一个线程处理完一个请求后，并不会被销毁，多个用户请求可能会共用一个线程。所以，如果在 ThreadLocal 中存放了和用户相关的数据（如用户的订单数据等），虽然 `ThreadLocal` 是线程私有的，但线程会被多个用户使用，为避免数据被“张冠李戴”，在获取 `ThreadLocal` 数据后，要调用 `remove` 方法清除 `ThreadLocal` 数据。

```java
/**
 * @apiNote 本地缓存用户信息
 **/
public class ThreadLocalUtil {
​
    // 使用ThreadLocal存储用户信息
    private static final ThreadLocal<User> threadLocal = new ThreadLocal<>();
​
    /**
     * 获取用户信息
     */
    public static User getUser() {
        // 如果ThreadLocal中没有用户信息，就从request请求解析出来放进去
        if (threadLocal.get() == null) {
            threadLocal.set(UserUtil.parseUserFromRequest());
        }
        return threadLocal.get();
    }
​
    /**
     * 删除用户信息
     */
    public static void removeUser() {
        threadLocal.remove();
    }

    /**
    * 获取订单列表
    */
    public List<Order> getOrderList() {
       // 1. 从ThreadLocal缓存中获取用户信息
       User user = ThreadLocalUtil.getUser();
       // 2. 根据用户信息，调用用户服务获取订单列表
       try {
           return orderService.getOrderList(user);
       } catch (Exception e) {
           throw new RuntimeException(e.getMessage());
       } finally {
           // 3. 使用完ThreadLocal后，删除用户信息
           ThreadLocalUtil.removeUser();
       }
       return null;
    }

}
```