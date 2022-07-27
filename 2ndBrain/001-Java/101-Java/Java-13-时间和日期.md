
# Java-13-时间和日期

[TOC]

## 更新
* 2020/09/20，撰写
* 2022/07/03，排版整理




## SimpleDateFormat-Y和y区别

* [SimpleDateFormat大写Y和小写y的区别 | CSDN](https://blog.csdn.net/chengluchuang2753/article/details/85603338)
* [日期格式化SimpleDateFormat的坑 | CSDN](https://blog.csdn.net/jn19970215/article/details/105446271)


> 日期格式化字符串 `[YYYY-MM-dd HH:mm:ss]` 使用时，应注意使用小写 `y` 表示当天所在的年，大写 `Y` 代表 `week in which year`。


日期格式化时，`yyyy` 表示当天所在的年，而大写的 `YYYY` 代表是 `week in which year`（JDK 7 之后引入的概念），表示当天所在的周属于的年份。

一周从周日开始，周六结束，只要本周跨年，返回的 `YYYY` 就是下一年。如下示例。


```java
Calendar calendar = Calendar.getInstance();
// 2014-12-31
calendar.set(2014, Calendar.DECEMBER, 31);
Date strDate1 = calendar.getTime();
// 2015-01-01
calendar.set(2015, Calendar.JANUARY, 1);
Date strDate2 = calendar.getTime();
// 大写YYYY
DateFormat formatUpperCase = new SimpleDateFormat("YYYY/MM/dd");
System.out.println("2014-12-31 to YYYY/MM/dd: " + formatUpperCase.format(strDate1)); //2014-12-31 to YYYY/MM/dd: 2015/12/31
System.out.println("2015-01-01 to YYYY/MM/dd: " + formatUpperCase.format(strDate2)); //2015-01-01 to YYYY/MM/dd: 2015/01/01

// 小写YYYY
DateFormat formatLowerCase = new SimpleDateFormat("yyyy/MM/dd");
System.out.println("2014-12-31 to yyyy/MM/dd: " + formatLowerCase.format(strDate1)); //2014-12-31 to yyyy/MM/dd: 2014/12/31
System.out.println("2015-01-01 to yyyy/MM/dd: " + formatLowerCase.format(strDate2)); //2015-01-01 to yyyy/MM/dd: 2015/01/01
```



另外需要注意
* 月份对应大写的 `M`
* 分钟对应小写的 `m`
* 24制的小时对应大写的 `H`
* 12制的小时对应小写的 `h`






## 时间戳的3种获取方式

* [new Date().getTime()和System.currentTimeMillis()获取时间戳 | CSDN](https://www.jianshu.com/p/5efbdc579f3d)



Java 中获取时间戳的方式主要有以下 3 种
1. `System.currentTimeMillis()` （性能最佳）
2. `new Date().getTime()` （性能一般）
3. `Calendar.getInstance().getTimeInMillis()` （性能最差）


上述 3 种方式中，`System.currentTimeMillis()` 的性能最佳，下面进行具体的分析。



### new Date().getTime()


打开 `java.util.Date` 的源码可以发现，`new Date()` 其实就是调用了 `System.currentTimeMillis()`。不难看出，如果只是仅仅获取时间戳，即使是匿名的 `new Date()` 对象，也会有些许的性能消耗， 

```java
public Date() {
    this(System.currentTimeMillis());
}
```


从提升性能的角度来看，只是仅仅获取时间戳，不考虑时区的影响，直接调用 `System.currentTimeMillis()` 会更好一些。

### Calendar.getInstance().getTimeInMillis()

使用 `Calendar.getInstance().getTimeInMillis()` 获取时间戳，这种方式的性能是最差的。因为 `Canlendar` 是区分时区的，而 `System.currentTimeMillis()` 方法中是不区分时区的。


### System.currentTimeMillis()

若要获取的时间戳不涉及时区，使用该方式的性能是最佳的。




## 10位和13位时间戳

* [java时间戳 10位和13位分别是怎么来的 | CSDN ](https://blog.csdn.net/qq_28483283/article/details/80583197)
* [13位时间戳（单位为毫秒）转换为10位字符串（单位为秒） | CSDN](https://blog.csdn.net/lin_dianwei/article/details/54616014)



Java 中的 `Date` 默认精度是毫秒，默认情况下生成的时间戳是 13 位的，而像 C++ 或者 PHP 生成的时间戳默认是 10 位的，默认精度是秒。即
1. 13 位的时间戳的精度为毫秒
2. 10 位的时间戳的精度为秒


将 13 位的时间戳，转换为 10 位时间戳，直接使用 `1000` 整除即可，代码如下。


```java
long timeStampSec = System.currentTimeMillis()/1000; //获取精度为秒的时间戳
String timestamp = String.format("%010d", timeStampSec);
```

此外，对于将时间戳转换为字符串的情况，需要使用 `String.format("%010d", timeStampSec)` 进行格式化转换，对于时间戳长度不满10位的情况，要进行补 0 处理，如上代码所示。



## 时间戳-日期转换


* 时间戳转换为日期


```java
long time1 = 1602259199000L;
String result1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date((long) time1));
System.out.println("13位数的时间戳（秒）--->Date:" + result1);
```

* 日期转换为时间戳


```java
DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
Date date = df.parse("2020-09-18 00:00:00");
Calendar cal = Calendar.getInstance();
cal.setTime(date);
long timestamp = cal.getTimeInMillis();
System.out.println("timestamp(13位):" + timestamp);
```


## SimpleDateFormat的线程安全问题

* ref 1-[SimpleDateFormat 线程不安全的 5 种解决方案 | Segmentfault](https://segmentfault.com/a/1190000040010020)



### 为什么线程不安全

`SimpleDateFormat` 为什么是线程不安全的？查看 `SimpleDateFormat` 的 `format` 方法实现，如下所示。

```java
private StringBuffer format(Date date, StringBuffer toAppendTo,
                                FieldDelegate delegate) {
    // 注意此行代码
    calendar.setTime(date);

    boolean useDateFormatSymbols = useDateFormatSymbols();

    for (int i = 0; i < compiledPattern.length; ) {
        int tag = compiledPattern[i] >>> 8;
        int count = compiledPattern[i++] & 0xff;
        if (count == 255) {
            count = compiledPattern[i++] << 16;
            count |= compiledPattern[i++];
        }

        switch (tag) {
            case TAG_QUOTE_ASCII_CHAR:
                toAppendTo.append((char)count);
                break;

            case TAG_QUOTE_CHARS:
                toAppendTo.append(compiledPattern, i, count);
                i += count;
                break;

            default:
                subFormat(tag, count, delegate, toAppendTo, useDateFormatSymbols);
                break;
        }
    }
    return toAppendTo;
}
```


从上述源码可以看出，在执行 `SimpleDateFormat.format` 方法时，会使用 `calendar.setTime` 方法将输入的时间进行转换，那么我们想象一下这样的场景
1. 线程 1 执行了 `calendar.setTime(date)` 方法，将用户输入的时间转换成了后面格式化时所需要的时间；
2. 线程 1 暂停执行，线程 2 得到 CPU 时间片开始执行；
3. 线程 2 执行了 `calendar.setTime(date)` 方法，对时间进行了修改
4. 线程 2 暂停执行，线程 1 得出 CPU 时间片继续执行，因为线程 1 和线程 2 使用的是同一对象，而时间已经被线程 2 修改了，所以此时当线程 1 继续执行的时候就会出现线程安全的问题了。


### 线程不安全示例

此处结合一个具体示例进行分析。


首先我们先创建 10 个线程来格式化时间，时间格式化每次传递的待格式化时间都是不同的，所以程序如果正确执行将会打印 10 个不同的值，接下来我们来看具体的代码实现。

```java
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class SimpleDateFormatExample {
    // 创建 SimpleDateFormat 对象
    private static SimpleDateFormat simpleDateFormat = new SimpleDateFormat("mm:ss");

    public static void main(String[] args) {
        // 创建线程池
        ExecutorService threadPool = Executors.newFixedThreadPool(10);
        // 执行 10 次时间格式化
        for (int i = 0; i < 10; i++) {
            int finalI = i;
            // 线程池执行任务
            threadPool.execute(new Runnable() {
                @Override
                public void run() {
                    // 创建时间对象
                    Date date = new Date(finalI * 1000);
                    // 执行时间格式化并打印结果
                    System.out.println(simpleDateFormat.format(date));
                }
            });
        }
    }
}
```

我们预期的正确结果如下。

```s
# 预期的正确结果
00:01
00:05
00:00
00:02
00:06
00:03
00:04
00:07
00:08
00:09
```

但是，实际的程序输出如下。


```s
# 实际的输出
00:02
00:06
00:02
00:06
00:06
00:06
00:07
00:07
00:08
00:09
```

从上述结果可以看出，当在多线程中使用 `SimpleDateFormat` 进行时间格式化是线程不安全的。



### 如何解决线程不安全问题

`SimpleDateFormat` 线程不安全的解决方案总共包含以下 5 种
1. 将 `SimpleDateFormat` 定义为局部变量；
2. 使用 `synchronized` 加锁执行；
3. 使用 `Lock` 加锁执行（和解决方案 2 类似）；
4. 使用 `ThreadLocal`；
5. 使用 JDK 8 中提供的 `DateTimeFormat`。


#### 将 `SimpleDateFormat` 变为局部变量

```java
public class SimpleDateFormatExample {
    public static void main(String[] args) {
        // 创建线程池
        ExecutorService threadPool = Executors.newFixedThreadPool(10);
        // 执行 10 次时间格式化
        for (int i = 0; i < 10; i++) {
            int finalI = i;
            // 线程池执行任务
            threadPool.execute(new Runnable() {
                @Override
                public void run() {
                    // 创建 SimpleDateFormat 对象
                    SimpleDateFormat simpleDateFormat = new SimpleDateFormat("mm:ss");
                    // 创建时间对象
                    Date date = new Date(finalI * 1000);
                    // 执行时间格式化并打印结果
                    System.out.println(simpleDateFormat.format(date));
                }
            });
        }
        // 任务执行完之后关闭线程池
        threadPool.shutdown();
    }
}
```



#### 使用 `synchronized` 加锁执行


```java

public class SimpleDateFormatExample2 {
    // 创建 SimpleDateFormat 对象
    private static SimpleDateFormat simpleDateFormat = new SimpleDateFormat("mm:ss");

    public static void main(String[] args) {
        // 创建线程池
        ExecutorService threadPool = Executors.newFixedThreadPool(10);
        // 执行 10 次时间格式化
        for (int i = 0; i < 10; i++) {
            int finalI = i;
            // 线程池执行任务
            threadPool.execute(new Runnable() {
                @Override
                public void run() {
                    // 创建时间对象
                    Date date = new Date(finalI * 1000);
                    // 定义格式化的结果
                    String result = null;
                    synchronized (simpleDateFormat) {
                        // 时间格式化
                        result = simpleDateFormat.format(date);
                    }
                    // 打印结果
                    System.out.println(result);
                }
            });
        }
        // 任务执行完之后关闭线程池
        threadPool.shutdown();
    }
}
```


#### 使用 `Lock` 加锁执行


```java

/**
 * Lock 解决线程不安全问题
 */
public class SimpleDateFormatExample3 {
    // 创建 SimpleDateFormat 对象
    private static SimpleDateFormat simpleDateFormat = new SimpleDateFormat("mm:ss");

    public static void main(String[] args) {
        // 创建线程池
        ExecutorService threadPool = Executors.newFixedThreadPool(10);
        // 创建 Lock 锁
        Lock lock = new ReentrantLock();
        // 执行 10 次时间格式化
        for (int i = 0; i < 10; i++) {
            int finalI = i;
            // 线程池执行任务
            threadPool.execute(new Runnable() {
                @Override
                public void run() {
                    // 创建时间对象
                    Date date = new Date(finalI * 1000);
                    // 定义格式化的结果
                    String result = null;
                    // 加锁
                    lock.lock();
                    try {
                        // 时间格式化
                        result = simpleDateFormat.format(date);
                    } finally {
                        // 释放锁
                        lock.unlock();
                    }
                    // 打印结果
                    System.out.println(result);
                }
            });
        }
        // 任务执行完之后关闭线程池
        threadPool.shutdown();
    }
}
```



#### 使用 `ThreadLocal`


```java

public class SimpleDateFormatExample4 {
    // 创建 ThreadLocal 对象，并设置默认值（new SimpleDateFormat）
    private static ThreadLocal<SimpleDateFormat> threadLocal =
            ThreadLocal.withInitial(() -> new SimpleDateFormat("mm:ss"));

    public static void main(String[] args) {
        // 创建线程池
        ExecutorService threadPool = Executors.newFixedThreadPool(10);
        // 执行 10 次时间格式化
        for (int i = 0; i < 10; i++) {
            int finalI = i;
            // 线程池执行任务
            threadPool.execute(new Runnable() {
                @Override
                public void run() {
                    // 创建时间对象
                    Date date = new Date(finalI * 1000);
                    // 格式化时间
                    String result = threadLocal.get().format(date);
                    // 打印结果
                    System.out.println(result);
                }
            });
        }
        // 任务执行完之后关闭线程池
        threadPool.shutdown();
    }
}
```

#### 使用 JDK 8 中提供的 `DateTimeFormat`


JDK 8 之后我们就有了新的选择，如果使用的是 JDK 8+ 版本，就可以直接使用 JDK 8 中新增的、安全的时间格式化工具类 `DateTimeFormatter` 来格式化时间了，接下来我们来具体实现一下。

使用 `DateTimeFormatter` 必须要配合 JDK 8 中新增的时间对象 `LocalDateTime` 来使用，因此在操作之前，我们可以先将 Date 对象转换成 `LocalDateTime`，然后再通过 `DateTimeFormatter` 来格式化时间，具体实现代码如下。

```java
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * DateTimeFormatter 解决线程不安全问题
 */
public class SimpleDateFormatExample5 {
    // 创建 DateTimeFormatter 对象
    private static DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("mm:ss");

    public static void main(String[] args) {
        // 创建线程池
        ExecutorService threadPool = Executors.newFixedThreadPool(10);
        // 执行 10 次时间格式化
        for (int i = 0; i < 10; i++) {
            int finalI = i;
            // 线程池执行任务
            threadPool.execute(new Runnable() {
                @Override
                public void run() {
                    // 创建时间对象
                    Date date = new Date(finalI * 1000);
                    // 将 Date 转换成 JDK 8 中的时间类型 LocalDateTime
                    LocalDateTime localDateTime =
                            LocalDateTime.ofInstant(date.toInstant(), ZoneId.systemDefault());
                    // 时间格式化
                    String result = dateTimeFormatter.format(localDateTime);
                    // 打印结果
                    System.out.println(result);
                }
            });
        }
        // 任务执行完之后关闭线程池
        threadPool.shutdown();
    }
}
```