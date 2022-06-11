
# 多线程-05-ThreadLocalRandom

[TOC]


## 更新
* 2020/08/29，撰写
* 2022/04/29，笔记整理


## 参考资料
* [多线程下的ThreadLocalRandom用法 | 掘金](https://juejin.im/post/6863713733252743182)
* [Random和ThreadLocalRandom区别 | 掘金](https://juejin.im/post/6844904096785235982)


## Java中使用随机数

Java中和随机数相关的包，主要包括3个
1. `java.lang.Math.random`
2. `java.util.Random`
3. `java.util.concurrent.ThreadLocalRandom`


## java.lang.Math.random

`Math.random()` 方法可以返回区间 `[0.0,1.0)` 内的 `double` 型随机数，区间左闭右开。

```java
double val = Math.random();
```
需要注意的是，`Math.random()` 方法返回是 `double` 类型，注意取值的范围 `[0.0,1.0)`（能够取到零值，注意除零异常）。如果想获取整数类型的随机数，不建议将 `val` 放大 10 的若干倍然后取整。

更好的解决方案是直接使用 `Random` 对象的 `nextInt` 或者 `nextLong` 方法。 


## java.util.Random

`Random()` 有 2 种构造方法
1. `Random()`: 创建一个新的随机数生成器，默认当前系统时间的毫秒数作为种子数
2. `Random(long seed)`: 使用指定的种子创建一个新的随机数生成器



```java
    /**
     * @param seed the initial seed
     */
    public Random(long seed) {
        if (getClass() == Random.class)
            this.seed = new AtomicLong(initialScramble(seed));
        else {
            // subclass might have overriden setSeed
            this.seed = new AtomicLong();
            setSeed(seed);
        }
    }
```





`Random` 类最常用的方法是 `nextInt()`，表示返回一个随机 `int` 值。该方法可以接受参数，如 `nextInt(100)`，表示返回一个区间为 `[0,100)` 的随机数，区间左闭右开。

```java
    //随机返回一个int型整数
    int nextInt()          
    
    //随机返回一个值在[0,num)的int类型的整数,包括0不包括num
    int nextInt(int num) 
```

`nextInt(bound)` 方法的源码如下。


```java
    public int nextInt(int bound) {
        if (bound <= 0)
            throw new IllegalArgumentException(BadBound);

        int r = next(31);
        int m = bound - 1;
        if ((bound & m) == 0)  // i.e., bound is a power of 2
            r = (int)((bound * (long)r) >> 31);
        else {
            for (int u = r;
                 u - (r = u % bound) + m < 0;
                 u = next(31))
                ;
        }
        return r;
    }
```



### [min,max]之间的随机数

`[min,max]` 之间的随机数，可以使用下面代码生成。

```java
Random rand = new Random();
int num = rand.nextInt(MAX - MIN + 1) + MIN;
```

### seed 

对于种子（`seed`）相同的 `Random` 对象，生成的随机数序列是一样的。


```java
    private void test7(){
        for(int j=0;j<5;j++){
            System.out.println("====第"+ j +"次====");
            Random random = new Random(100);
            for(int i=0;i<4;i++){
                System.out.println("index_"+ i +"：" + random.nextInt(100));
            }
        }
    }
```

执行上述代码，程序输入如下。可以看到对于种子相同的`Random` 对象，生成的随机数序列是一样的，是一种伪随机数。

> 伪随机即有规则的随机。


```s
====第1次====
index_0：15
index_1：50
index_2：74
index_3：88
====第2次====
index_0：15
index_1：50
index_2：74
index_3：88
====第3次====
index_0：15
index_1：50
index_2：74
index_3：88
====第4次====
index_0：15
index_1：50
index_2：74
index_3：88
```


##  java.util.concurrent.ThreadLocalRandom


### ThreadLocalRandom为每个线程维护一个种子seed

在多线程下，使用 `java.util.Random` 获取随机数，它是线程安全的。但深挖 Random 的实现过程，会发现多个线程会竞争同一 `seed`，这会造成性能下降。

这是因为，`Random` 生成新的随机数需要 2 步
1. 根据老的 `seed` 生成新的 `seed`
2. 由新的 `seed` 计算出新的随机数

第 2 步的算法是固定的，**如果每个线程并发地获取同样的 `seed`，那么得到的随机数也是一样的。为了避免这种情况，`Random` 使用 `CAS` 操作保证每次只有一个线程可以获取并更新 `seed`，失败的线程则需要自旋重试。**


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-random-seed-1.png)

因此，在多线程下用 `Random` 不太合适，为了解决这个问题，出现了 `ThreadLocalRandom`，在多线程下，它为每个线程维护一个 `seed` 变量，这样就不用竞争了。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-random-seed-2.png)

### JMH性能对比测试-ThreadLocalRandom-Random



下面使用 JMH 测试并发情况下，`ThreadLocalRandom` 和 `Random` 的性能差异。
 
首先，导入如下依赖（JDK9之后自带JMH，不需导入依赖）
 
 
```xml
        <!--JMH-->
        <dependency>
            <groupId>org.openjdk.jmh</groupId>
            <artifactId>jmh-core</artifactId>
            <version>1.23</version>
        </dependency>
        <dependency>
            <groupId>org.openjdk.jmh</groupId>
            <artifactId>jmh-generator-annprocess</artifactId>
            <version>1.23</version>
        </dependency>
```


编写测试代码如下


```java
@BenchmarkMode(Mode.Throughput) // 测试类型：吞吐量
@Warmup(iterations = 3, time = 1)
@Threads(100)
@OutputTimeUnit(TimeUnit.MILLISECONDS)
public class SpbAppApplication {
    public static void main(String[] args) throws RunnerException {
//        SpringApplication.run(SpbAppApplication.class, args);

        // 启动基准测试
        Options opt = new OptionsBuilder()
                .include(SpbAppApplication.class.getSimpleName()) // 要导入的测试类
                .warmupIterations(5) // 预热 5 轮
                .measurementIterations(10) // 度量10轮
                .forks(1)
                .build();
        new Runner(opt).run(); // 执行测试
    }



    /**
     * Random 性能测试
     */
    @Benchmark
    public void randomTest() {
        Random random = new Random();
        for (int i = 0; i < 10; i++) {
            // 生成 0-9 的随机数
            random.nextInt(10);
        }
    }
    /**
     * ThreadLocalRandom 性能测试
     */
    @Benchmark
    public void threadLocalRandomTest() {
        ThreadLocalRandom threadLocalRandom = ThreadLocalRandom.current();
        for (int i = 0; i < 10; i++) {
            threadLocalRandom.nextInt(10);
        }
    }

}
```

设定 `forks(1)`，设定 `@Threads()` 分别为 16 和 100，即在一个进程中，分别测试16个线程情况下和100个线程情况下的吞吐量对比数据。


测试结果如下，其中 `Cnt` 表示运行了多少次，`Score` 表示执行的成绩，`Units` 表示每秒的吞吐量。


```java
# Threads: 16 threads, will synchronize iterations
Benchmark                                 Mode  Cnt      Score      Error   Units
SpbAppApplication.randomTest             thrpt   10   4996.466 ± 3629.543  ops/ms
SpbAppApplication.threadLocalRandomTest  thrpt   10  37720.715 ± 6566.971  ops/ms


# Threads: 100 threads, will synchronize iterations
Benchmark                                 Mode  Cnt      Score       Error   Units
SpbAppApplication.randomTest             thrpt   10   3259.461 ±  1819.021  ops/ms
SpbAppApplication.threadLocalRandomTest  thrpt   10  29948.252 ± 10276.214  ops/ms
```



**从 JMH 测试的结果可以看出，在16个线程并发下，`ThreadLocalRandom` 在并发情况下的吞吐量约是 `Random` 的 5 倍。在 100个线程并发下，差距扩大到了将近10倍。**

因此在高并发下，尽量使用 `ThreadLocalRandom`。




### 多线程下使用


在每个线程下调用 `ThreadLocalRandom.current()` 获取对象实例，再调用 `nextInt()` 方法获取随机数。



```java
import java.util.concurrent.ThreadLocalRandom;

public class ThreadLocalRandomDemo {

    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            new Player().start();
        }
    }

    private static class Player extends Thread {
        @Override
        public void run() {
            System.out.println(getName() + ": " +
            ThreadLocalRandom threadLocalRandom = ThreadLocalRandom.current();
            threadLocalRandom.nextInt(100));
        }
    }
}

```


需要注意的是，多线程下不能把 `ThreadLocalRandom.current()` 设置为 `final`，即下述代码。否则多线程下，产生的随机数是相同的。详情可以参考 [多线程下的ThreadLocalRandom用法 | 掘金](https://juejin.im/post/6863713733252743182)。


```java
import java.util.concurrent.ThreadLocalRandom;

public class ThreadLocalRandomDemo {

    private static final ThreadLocalRandom RANDOM =
            ThreadLocalRandom.current();

    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            new Player().start();
        }
    }

    private static class Player extends Thread {
        @Override
        public void run() {
            System.out.println(getName() + ": " + RANDOM.nextInt(100));
        }
    }
}
```

上述程序的输出如下。


```java
Thread-0: 4
Thread-1: 4
Thread-2: 4
Thread-3: 4
Thread-4: 4
Thread-5: 4
Thread-6: 4
Thread-7: 4
Thread-8: 4
Thread-9: 4
```