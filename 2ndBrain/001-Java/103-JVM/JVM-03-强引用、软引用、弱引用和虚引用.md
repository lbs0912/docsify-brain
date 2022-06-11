
# JVM-03-强引用、软引用、弱引用和虚引用

[TOC]



## 更新
* 2022/01/21，撰写
* 2022/03/16，内容整理



## 参考资料
* [理解Java的强引用、软引用、弱引用和虚引用 | 掘金](https://juejin.im/post/5b82c02df265da436152f5ad)
* [强软弱虚引用，只有体会过了，才能记住](https://www.cnblogs.com/CodeBear/p/12447554.html)
* [理解Java的强引用、软引用、弱引用和虚引用](https://juejin.cn/post/6844903665241686029)



## 前言


Java 执行 `GC` 判断对象是否存活有两种方式其中一种是**引用计数**。


> 引用计数：Java 堆中每1个对象都有1个引用计数属性，引用每新增1次计数加1，引用每释放1次计数减1。

在 JDK 1.2 以前的版本中，若一个对象不被任何变量引用，那么程序就无法再使用这个对象。也就是说，只有对象处于(`reachable`)可达状态，程序才能使用它。

从 JDK 1.2 版本开始，对象的引用被划分为 4 种级别，从而使程序能更加灵活地控制对象的生命周期。这 4 种级别由高到低依次为
1. 强引用
2. 软引用
3. 弱引用
4. 虚引用，也称为幻影引用


| 引用类型 | 被垃圾回收时间  | 用途  | 生存时间 |
|----------|-----------------|-------|------------|
| 强引用   |  从来不会  |   对象的一般状态  |   JVM停止运行时终止  | 
| 软引用   |    当内存不足时  | 对象缓存  |   内存不足时终止  |
| 弱引用   |   正常垃圾回收时  |   对象缓存  |  垃圾回收后终止  | 
| 虚引用  |   正常垃圾回收时  | 跟踪对象的垃圾回收  | 垃圾回收后终止 |

> 4种引用级别的强度，由高到低依次为：强引用 > 软引用 > 弱引用 > 虚引用。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-reference-kinds-1.png)



Java 设计 4 种引用方式的好处是
* 可以让程序员通过代码的方式来决定某个对象的生命周期
* 有利于垃圾回收






## 强引用(StrongReference)

**强引用是使用最普遍的引用。如果一个对象具有强引用，那垃圾回收器绝不会回收它。**

```java
Object strongReference = new Object();
```

**当内存空间不足时，Java 虚拟机宁愿抛出 OutOfMemoryError 错误，使程序异常终止，也不会靠随意回收具有强引用的对象来解决内存不足的问题。**

如果强引用对象不使用时，需要弱化从而使 GC 能够回收，如下

```java
strongReference = null;
```

显式地设置 `strongReference` 对象为 `null`，或让其超出对象的生命周期范围，则 GC 认为该对象不存在引用，这时就可以回收这个对象。具体什么时候回收，要取决于 GC 算法。


### 强引用回收示例

如下示例，当强引用和对象之间的关联被中断了，并且手动调用 `gc()`，对象就可以被回收了。


```java
class Student {
    //Java Object finalize() 方法用于实例被垃圾回收器回收的时触发的操作 JVM不保证此方法总被调用
    @Override
    protected void finalize() throws Throwable {
        System.out.println("Student 被回收了");
    }
}

public  class Solution {

    public static void main(String[] args) {
        //强引用
        Student student = new Student();
        //中断强引用
        student = null;
        //手动调用GC
        System.gc();
    }
}
```

执行上述代码，输入如下

```s
Student 被回收了
```




## 软引用(SoftReference)

如果一个对象只具有软引用，则内存空间充足时，垃圾回收器就不会回收它；如果内存空间不足了，就会回收这些对象的内存。只要垃圾回收器没有回收它，该对象就可以被程序使用。




```java
import java.lang.ref.SoftReference;

// 强引用
String strongReference = new String("abc");

// 软引用
String str = new String("abc");
SoftReference<String> softReference = new SoftReference<String>(str);
SoftReference softReference = new SoftReference(str); //此种写法也可
```

软引用可以和一个引用队列（`ReferenceQueue`）联合使用。如果软引用所引用对象被垃圾回收，JAVA 虚拟机就会把这个软引用加入到与之关联的引用队列中。

```java
ReferenceQueue referenceQueue = new ReferenceQueue();
String str = new String("abc");
SoftReference softReference = new SoftReference(str, referenceQueue);

str = null;
// Notify GC
System.gc();

System.out.println(softReference.get()); // abc

Reference<? extends String> reference = referenceQueue.poll();
System.out.println(reference); //null
```

> 需要注意的是，软引用对象是在 JVM 内存不够的时候才会被回收，我们调用 `System.gc()` 方法只是起通知作用，JVM 什么时候扫描回收对象是 JVM 自己的状态决定的。就算扫描到软引用对象也不一定会回收它，只有内存不够的时候才会回收。

**当内存不足时，JVM 首先将软引用中的对象引用置为 null，然后通知垃圾回收器进行回收。**

```java
if(JVM内存不足) {
    // 将软引用中的对象引用置为null
    str = null;
    // 通知垃圾回收器进行回收
    System.gc();
}
```

也就是说，垃圾收集线程会在虚拟机抛出 `OutOfMemoryError` 之前回收软引用对象，而且虚拟机会尽可能优先回收长时间闲置不用的软引用对象。对那些刚构建的或刚使用过的 **“较新的”软对象会被虚拟机尽可能保留**，这就是引入引用队列 `ReferenceQueue` 的原因。



### 软引用回收示例


如下代码所示，创建一个软引用对象，里面包裹了 `byte[]`，`byte[]` 占用了 10M，然后再创建一个 10M 的 `byte[]` 对象。

```java
SoftReference<byte[]> softReference = new SoftReference<byte[]>(new byte[1024*1024*10]);

System.out.println(softReference.get());
System.gc();
System.out.println(softReference.get());

byte[] bytes = new byte[1024 * 1024 * 10];
System.out.println(softReference.get());
```

运行上述程序，并附带参数  `-Xmx20M`，即设置最大堆内存为 20M，程序执行结果如下。

```s
[B@11d7fff
[B@11d7fff
null
```

可以很清楚的看到，手动完成 GC 后，软引用对象包裹的 `byte[]` 还活的好好的，但是当我们再创建了一个 10M 的 `byte[]` 后，最大堆内存不够了，所以把软引用对象包裹的 `byte[]` 给干掉了。如果不干掉，就会抛出OOM。



### 软引用用处


> 软引用可用来实现内存敏感的高速缓存。


软引用比较适合用作缓存，当内存足够时可以正常的拿到缓存，当内存不够时，就会先干掉缓存，不至于马上抛出 OOM。


例如，浏览器的后退按钮。按后退时，显示的网页内容是重新进行请求还是从缓存中取出呢？这就要看具体的实现策略了
* 如果一个网页在浏览结束时就进行内容的回收，则按后退查看前面浏览过的页面时，需要重新构建
* 如果将浏览过的网页存储到内存中会造成内存的大量浪费，甚至会造成内存溢出

这时候就可以使用软引用，很好的解决了实际的问题。

```java
    // 获取浏览器对象进行浏览
    Browser browser = new Browser();
    // 从后台程序加载浏览页面
    BrowserPage page = browser.getPage();
    // 将浏览完毕的页面置为软引用
    SoftReference softReference = new SoftReference(page);

    // 回退或者再次浏览此页面时
    if(softReference.get() != null) {
        // 内存充足，还没有被回收器回收，直接获取缓存
        page = softReference.get();
    } else {
        // 内存不足，软引用的对象已经回收
        page = browser.getPage();
        // 重新构建软引用
        softReference = new SoftReference(page);
    }
```


## 弱引用(WeakReference)

弱引用与软引用的区别在于，只具有弱引用的对象拥有更短暂的生命周期。**在垃圾回收器线程扫描它所管辖的内存区域的过程中，一旦发现了只具有弱引用的对象，不管当前内存空间足够与否，都会回收它的内存。** 不过，由于垃圾回收器是一个优先级很低的线程，因此不一定会很快发现那些只具有弱引用的对象。




### 弱引用的创建

```java
//创建一个弱引用
WeakReference<Student> studentWeakReference = new WeakReference<Student>(new Student());

//调用get方法 从弱引用对象获得被包裹的对象
Student student = studentWeakReference.get();
```


> 如果一个对象是偶尔（很少）的使用，并且希望在使用时随时就能获取到，但又不想影响此对象的垃圾收集，那么你应该用 `Weak Reference` 来记住此对象。

同样的，弱引用可以和一个引用队列（`ReferenceQueue`）联合使用，如果弱引用所引用的对象被垃圾回收，Java 虚拟机就会把这个弱引用加入到与之关联的引用队列中。

下面的代码会让一个弱引用再次变为一个强引用。

```java
    String str = new String("abc");
    WeakReference<String> weakReference = new WeakReference<>(str);
    // 弱引用转强引用
    // 调用Reference类的get方法 从弱引用对象获得被包裹的对象
    String strongReference = weakReference.get();
```

### 弱引用特点

不管内存是否足够，只要发生 GC，弱引用的对象都会被回收。


### 弱引用回收示例

```java
WeakReference<byte[]> weakReference = new WeakReference<byte[]>(new byte[1]);

System.out.println(weakReference.get());
System.gc();
System.out.println(weakReference.get());
```

程序运行如下

```s
[B@11d7fff
null
```

可以很清楚的看到，明明内存还很充足，但是触发了 GC，资源还是被回收了。弱引用在很多地方都有用到，比如 `ThreadLocal`、`WeakHashMap`。

## 虚引用(PhantomReference)

虚引用又被称为幻影引用（`PhantomReference`）。

虚引用顾名思义，就是形同虚设。**与其他几种引用都不同，虚引用并不会决定对象的生命周期。如果一个对象仅持有虚引用，那么它就和没有任何引用一样，在任何时候都可能被垃圾回收器回收。**


### 虚引用的创建


```java
//引用队列
ReferenceQueue queue = new ReferenceQueue();

PhantomReference<byte[]> reference = new PhantomReference<byte[]>(new byte[1], queue);

System.out.println(reference.get());
```

执行上述程序

```s
null
```

可以看到，程序打印出了 `null`。查看下虚引用的 `get()` 源码。

```java
public T get() {
    return null;
}
```

可以看到，虚引用的 `get()` 方法直接返回 `null`。**这就是虚引用特点之一了，即无法通过虚引用来获取对一个对象的真实引用。**


### 虚引用的特点

1. 虚引用的 `get()` 方法直接返回 `null`，因此无法通过虚引用来获取对一个对象的真实引用。
2. 与其他几种引用都不同，虚引用并不会决定对象的生命周期。如果一个对象仅持有虚引用，那么它就和没有任何引用一样，在任何时候都可能被垃圾回收器回收。
3. 虚引用与软引用和弱引用的一个区别在于，虚引用必须和引用队列（`ReferenceQueue`）联合使用。当垃圾回收器准备回收一个对象时，如果发现它还有虚引用，就会在回收对象的内存之前，把这个虚引用加入到与之关联的引用队列中。

### 虚引用的用处

1. 虚引用主要用来跟踪对象被垃圾回收器回收的活动。
2. 在 NIO 中，就运用了虚引用管理堆外内存。

### 虚引用的使用示例


```java
String str = new String("abc");
ReferenceQueue queue = new ReferenceQueue();
// 创建虚引用，要求必须与一个引用队列关联
PhantomReference pr = new PhantomReference(str, queue);
```

可以通过判断引用队列中是否已经加入了虚引用，来了解被引用的对象是否将要进行垃圾回收。如果程序发现某个虚引用已经被加入到引用队列，那么就可以在所引用的对象的内存被回收之前采取必要的行动。

下面看一个示例。


```java
class Student {
    //Java Object finalize() 方法用于实例被垃圾回收器回收的时触发的操作
    @Override
    protected void finalize() throws Throwable {
        System.out.println("Student 被回收了");
    }
}
```

```java
    // ...

    ReferenceQueue queue = new ReferenceQueue();
    List<byte[]> bytes = new ArrayList<>();
    PhantomReference<Student> reference = new PhantomReference<Student>(new Student(),queue);

    //第一个线程往集合里面塞数据，随着数据越来越多，肯定会发生GC
    new Thread(() -> {
        for (int i = 0; i < 100;i++ ) {
            bytes.add(new byte[1024 * 1024]);
        }
    }).start();

    //第二个线程死循环，从queue里面拿数据，如果拿出来的数据不是null，就打印出来
    new Thread(() -> {
        while (true) {
            Reference poll = queue.poll();
            if (poll != null) {
                System.out.println("虚引用被回收了：" + poll);
            }
        }
    }).start();

    Scanner scanner = new Scanner(System.in);
    scanner.hasNext();

    // ...
```

执行上述程序

```s
Student 被回收了
虚引用被回收了：java.lang.ref.PhantomReference@1ade6f1
```

从运行结果可以看到，当发生 GC，虚引用就会被回收，并且会把回收的通知放到 `ReferenceQueue` 中。




