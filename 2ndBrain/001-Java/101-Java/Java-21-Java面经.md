# Java-21-Java面经


[TOC]


## 更新
* 2022/06/09，撰写


## 参考资料
* [To Be Top Javaer | gitbook](http://hollischuang.gitee.io/tobetopjavaer/#/)
* [JavaGuide | gitbook](https://snailclimb.gitee.io/javaguide/#/)

## Java为什么不支持多重继承


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-multi-extends-faq-1.png)


C++ 因为支持多继承，引入了「菱形继承」问题，如下所示。



```s
     | A |
   /      \ 
| B |    | C |
   \      /
     | D |
```

D 继承了 B 和 C，同时 B 和 C 又继承了 A。如果 D 要调用 A 的方法并且 D 没有实现该方法，那到底是调用 B 的实现，还是 C 的实现呢？

C++ 为了解决菱形继承问题，引入了「虚继承」。


C++ 为了要支持多重继承，而引入了「菱形继承」问题，又为了解决该问题，引入了「虚继承」。Java 的创始人在设计 Java 时，参考了 C++ 的设计，认为支持多重继承，过于复杂，而且实际使用多重继承的场景并不多，所以 Java 不支持多重继承。


## 重载（overload）和重写（override）

重载发生在一个类中，同名的方法如果有不同的参数列表（参数类型不同、参数个数不同或者二者都不同）则视为重载（overload）。

重写发生在子类与父类之间，重写要求子类被重写方法与父类被重写方法有相同的返回类型，比父类被重写方法更好访问，不能比父类被重写方法声明更多的异常（里氏代换原则）。


在一个类中，同名的方法如果有不同的参数列表（参数类型不同、参数个数不同甚至是参数顺序不同）则视为重载。同时，重载对返回类型没有要求，可以相同也可以不同，**但不能通过返回类型是否相同来判断重载。**

## 构造器是否可被重写

`Constructor` 不能被 `override`（重写），但是可以 `overload`（重载），所以你可以看到⼀个类中有多个构造函数的情况。


## protected和default
* ref 1-[Java 中 public、default、protected、private 区别](https://blog.csdn.net/xingchenhy/article/details/81223168)



| 修饰符 | 类内部 | 同一包 | 子类 | 任何地方 |
|-------|-------|-------|-----|---------|
| private | Yes | | | | 
| default | Yes | Yes | | | 
| protected | Yes | Yes | Yes | |
| public | Yes | Yes | Yes | Yes |  




## final关键字

`final` 表示不可变的意思，可用于修饰类、属性和方法。
1. 被 final 修饰的类不可以被继承。
2. **被 final 修饰的方法不可以被重写，但是可以被继承，也就是说，子类可以调用父类的 final 方法，但是不允许重写该方法**。
3. 被 final 修饰的变量不可变，被 final 修饰的变量必须被显式第指定初始值。需要注意的是，这里的不可变指的是变量的引用不可变，不是引用指向的内容的不可变。
4. final 不能修饰抽象类，因为抽象类是用来被继承的，而被 final 修饰的类是不能被继承的。
5. final 也不能修饰接口，因为接口是用来被实现的。



## final、finally、finalize的区别

1. `final` 表示不可变的意思，可用于修饰类、属性和方法。
2. finally 作为异常处理的一部分，它只能在 `try/catch` 语句中，并且附带一个语句块表示这段语句最终一定被执行（无论是否抛出异常）。
3. finalize 是在 `java.lang.Object` 里定义的方法，也就是说每一个对象都有这么个方法，这个方法在 `gc` 启动，该对象被回收的时候被调用。

**一个对象的 `finalize` 方法只会被调用一次，`finalize` 被调用不一定会立即回收该对象，所以有可能调用 `finalize` 后，该对象又不需要被回收了，然后到了真正要被回收的时候，因为前面调用过一次，所以不会再次调用`finalize` 了，进而产生问题，因此不推荐使用 `finalize` 方法。**


```java
class Student {
    //Java Object finalize() 方法用于实例被垃圾回收器回收的时触发的操作 JVM不保证此方法总被调用
    @Override
    protected void finalize() throws Throwable {
        System.out.println("Student 被回收了");
    }
}
```




## new Object()的过程

```java
Object obj = new Object();
```

使用 `new` 关键字创建一个对象时，如上代码所示，其过程包括
1. 分块一块内存 M
2. 在内存 M 上初始化该对象
3. 将内存 M 的地址赋值给引用变量 obj



## 创建对象的4种方法

* ref 1-[深入理解Java中四种创建对象的方式 | 掘金](https://juejin.im/post/5a3b7c1f5188253865095b7b)
* ref 2-[Java创建对象的4种方式 | CSDN](https://blog.csdn.net/u010889616/article/details/78946580)




创建对象的 4 种方法如下
1. 使用 `new` 关键字
2. 反射机制
   * 使用 `Class` 类的 `newInstance` 方法可以调用无参的构造器来创建对象。
   * 如果是有参构造器，则需要使用 `Class` 的 `forName` 方法和 `Constructor` 来进行对象的创建。
3. 实现 `Cloneable` 接口，使用 `clone` 方法创建对象
4. 序列化和反序列化



以上 4 种方式，都可以创建一个 Java 对象，实现机制上有如下区别
* 方式 1 和方式 2 中，都明确地显式地调用了对象的构造函数。
* **方式 3 中，是对已经的对象，在内存上拷贝了一个影印，并不会调用对象的构造函数。**
* 方式 4 中，对对象进行序列化，转化为了一个文件流，再通过反序列化生成一个对象，也不会调用构造函数。




| 方式      | 是否调用了构造函数
|----------|--------------------
| 使用 new 关键字 | 是 | 
| （反射）使用 Class 类的 newInstance 方法 | 是，调用无参构造函数 |
| （反射）使用 Constructor 类的 newInstance 方法 | 是，调用有参构造函数  |
| 使用 clone 方法   | 否  |
| 使用反序列化    | 否  | 




### 调用 `new` 语句创建对象


```java
// 使用关键字 new 创建对象，初始化对象数据　
MyObject mo = new MyObject();　
```

### 调用对象的 `clone()` 方法

```java
MyObject anotherObject = new MyObject();
MyObject object = anotherObject.clone();
```

使用 `clone()` 方法克隆一个对象的步骤
1. 被克隆的类要实现 `Cloneable` 接口
2. 被克隆的类要重写 `clone()` 方法

原型模式主要用于对象的复制，实现一个接口（实现 `Cloneable` 接口），重写一个方法（重写 `Object` 类中的 `clone` 方法），即完成了原型模式。

原型模式中的拷贝分为“浅拷贝”和“深拷贝”
* 浅拷贝: 对值类型的成员变量进行值的复制，对引用类型的成员变量只复制引用，不复制引用的对象
* 深拷贝: 对值类型的成员变量进行值的复制，对引用类型的成员变量也进行引用对象的复制

> `Object` 类的 `clone` 方法只会拷贝对象中的基本数据类型的值，对于数组、容器对象、引用对象等都不会拷贝，这就是浅拷贝。
> 
> 如果要实现深拷贝，必须将原型模式中的数组、容器对象、引用对象等另行拷贝。


### 运用反射手段创建对象
使用反射手段创建对象，又可细分为两种场景
1. 使用 `Class` 类的 `newInstance` 方法可以调用无参的构造器来创建对象。
2. 如果是有参构造器，则需要使用 `Class` 的 `forName` 方法和 `Constructor` 来进行对象的创建。



```java
Employee emp2 = (Employee) Class.forName("org.programming.mitra.exercises.Employee").newInstance();
//或者
Employee emp2 = Employee.class.newInstance();
```


```java
Class stuClass = Class.forName("Student");
Constructor constructor = stuClass.getConstructor(String.class);
Student stu2 = (Student) constructor.newInstance("李四");
```

### 运用反序列化手段

一个对象实现了 `Serializable` 接口，就可以把对象写入到文件中，并通过读取文件来创建对象。

```java
String path = Test.class.getClassLoader().getResource("").getPath();
String objectFilePath = path + "out.txt";

ObjectOutputStream objectOutputStream = new ObjectOutputStream(new FileOutputStream(objectFilePath));
objectOutputStream.writeObject(stu2);

ObjectInput objectInput = new ObjectInputStream(new FileInputStream(objectFilePath));
Student stu4 = (Student) objectInput.readObject();
```



## String str1 = new String("abc")和String str2 = "abc"的区别

两个语句都会去字符串常量池中检查是否已经存在 "abc"，如果有则直接使用，如果没有则会在常量池中创建 "abc" 对象。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/java-string-create-vs-1.png)

但是不同的是，`String str1 = new String("abc")` 还会通过 `new String()` 在堆里创建一个 "abc" 字符串对象实例。所以后者可以理解为被前者包含。


> `String s = new String("abc")` 创建了几个对象？

很明显，一个或两个。如果字符串常量池已经有 "abc"，则是一个；否则，两个。

当字符创常量池没有 "abc"，此时会创建如下两个对象
1. 一个是字符串字面量 "abc" 所对应的、字符串常量池中的实例
2. 另一个是通过 `new String()` 创建并初始化的，内容与 "abc" 相同的实例，在堆中。


## String怎么转成Integer

String 转成 Integer，主要有两个方法

1. `Integer.parseInt(String s)`
2. `Integer.valueOf(String s)`


不管哪一种，最终还是会调用 Integer 类内中的 `parseInt(String s, int radix)` 方法。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/java-object-method-1.png)



## Java的异常处理体系

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/java-exception-all-kinds-1.png)


> OOM： OutOfMemoryError，内存溢出错误
> **SOF：StackOverflowError，堆栈溢出错误**


**Throwable 是 Java 语言中所有错误或异常的基类。Throwable 又分为 Error 和 Exception，其中 Error 是系统内部错误，比如虚拟机异常，是程序无法处理的。Exception 是程序问题导致的异常，又分为两种**
1. CheckedException 受检异常：编译器会强制检查并要求处理的异常。
2. RuntimeException 运行时异常：程序运行中出现异常，比如我们熟悉的空指针、数组下标越界等等。


## 基本数据类型和引用数据类型
1. 基本数据类型：数据直接存储在栈上
2. 引用数据类型区别：数据存储在堆上，栈上只存储引用地址
3. Java 中的基本数据类型只有 8 个：byte、short、int、long、float、double、char、boolean
4. 除了基本类型（primitive type），剩下的都是引用类型（reference type）


## 两个对象的hashCode()相同，则equals()也一定为true吗

不对。`hashCode()` 和 `equals()` 之间的关系如下
1. 当有 `a.equals(b) == true` 时，则 `a.hashCode() == b.hashCode()` 必然成立，
2. 反过来，当 `a.hashCode() == b.hashCode()` 时，`a.equals(b)` 不一定为 `true`。

也就是说，`hasCode` 因为存在哈希碰撞，所以 `hasCode` 相等的两个对象，`equals` 不一定相等。但是，`equals` 相等的两个对象，其 `hashCode` 一定是相等的。


## CPU飙高系统反应慢如何解决
* ref 1-[CPU飙高系统反应慢怎么排查](https://juejin.cn/post/7085555235879387172)

CPU 是整个电脑的核心计算资源，对于一个应用进程来说，CPU 的最小执行单元是线程。


导致 CPU 飙高的原因有几个方面
1. CPU 上下文切换过多，对于 CPU 来说，同一时刻下每个 CPU 核心只能运行一个线程，如果有多个线程要执行，CPU 只能通过上下文切换的方式来执行不同的线程。上下文切换需要做两个事情
   * 保存运行线程的执行状态
   * 让处于等待中的线程执行

这两个过程需要 CPU 执行内核相关指令实现状态保存，如果较多的上下文切换，会占据大量 CPU 资源，从而使得 CPU 无法去执行用户进程中的指令，导致响应速度下降。

在 Java 中，文件 IO、网络 IO、锁等待、线程阻塞等操作都会造成线程阻塞从而触发上下文切换。

2. CPU 资源过度消耗，也就是在程序中创建了大量的线程，或者有线程一直占用 CPU 资源无法被释放，比如死循环。

CPU 利用率过高之后，导致应用中的线程无法获得 CPU 的调度，从而影响程序的执行效率。


既然是这两个问题导致的 CPU 利用率较高，于是我们可以通过`top` 命令，找到 CPU 利用率较高的进程，这里有两种情况。
1. CPU 利用率过高的线程一直是同一个，说明程序中存在线程长期占用 CPU 没有释放的情况，这种情况直接通过 `jstack` 获得线程的 Dump 日志，定位到线程日志后就可以找到问题的代码。
2. CPU 利用率过高的线程 id 不断变化，说明线程创建过多，需要挑选几个线程 id，通过 `jstack` 去线程 dump 日志中排查。



最后有可能定位的结果是程序正常，只是在 CPU 飙高的那一刻，用户访问量较大，导致系统资源不够。



## 对AQS的理解

* ref 1-[谈谈你对AQS的理解](https://juejin.cn/post/7081932085186953229)



AQS（AbstractQueuedSynchronizer）是抽象同步队列（多线程同步器），它是 J.U.C 包中多个组件的底层实现，如 Lock、CountDownLatch、Semaphore 等都用到了 AQS。

从本质上来说，AQS 提供了两种锁机制，分别是排它锁和共享锁。

排它锁，就是存在多线程竞争同一共享资源时，同一时刻只允许一个线程访问该共享资源，也就是多个线程中只能有一个线程获得锁资源，比如 Lock 中的 ReentrantLock 重入锁的实现，就是用到了 AQS 中的排它锁功能。

共享锁也称为读锁，就是在同一时刻允许多个线程同时获得锁资源，比如 CountDownLatch 和 Semaphore 都是用到了 AQS 中的共享锁功能。




## 银行转账

* 题目描述

在招商银行的APP上可以进行不同用户之间的转账操作，假设现在有10万条用户转账数据，请简述如何检查是否存在转账行为回路，如A向B转账，并且B向A转账。


* 题目解答

对于是否存在回路的判断，可以将转账行为建模为转账图，例如A向B转账，则可以建模为点A与B之间有一个有向边连接，形成一个有向图。

有向图可以使用「拓扑排序」判断是否存在环，具体如下。
1. 计算图中所有点的入度，把入度为 0 的点加入栈
2. 如果栈非空
   * 取出栈顶顶点 a，从图中删除该顶点
   * 从图中删除所有以 a 为起始点的边，如果删除的边的另一个顶点入度为 0，则把它入栈
3. 如果图中还存在顶点，则表示图中存在环


### 什么是拓扑排序

在图论中，拓扑排序（Topological Sorting）是一个有向无环图（DAG， Directed Acyclic Graph）的所有顶点的线性序列。且该序列必须满足下面两个条件
1. 每个顶点出现且只出现一次。
2. 若存在一条从顶点 A 到顶点 B 的路径，那么在序列中顶点 A 出现在顶点 B 的前面。

有向无环图（DAG）才有拓扑排序，非 DAG 图没有拓扑排序一说。

### 拓扑排序的应用

**拓扑排序通常用来 “排序” 具有依赖关系的任务。**

比如，如果用一个 DAG 图来表示一个工程，其中每个顶点表示工程中的一个任务，用有向边表示在做任务 B 之前必须先完成任务 A。故在这个工程中，任意两个任务要么具有确定的先后关系，要么是没有关系，绝对不存在互相矛盾的关系（即环路）。



## 1.0/0.0

`1.0/0.0` 得到的结果是什么？会抛出异常吗，还是会出现编译错误？



数字在 Java 中可以分为两种，一种是整型，一种是浮点型。

**当浮点数除以 0 的时候，结果为 `Infinity` 或者 `NaN`。**

```java
System.out.println(1.0 / 0.0); // Infinity
System.out.println(0.0 / 0.0); // NaN
```

Infinity 的中文意思是无穷大，NaN 的中文意思是这不是一个数字（Not a Number）。

```java
    /**
     * A constant holding a Not-a-Number (NaN) value of type
     * {@code double}. It is equivalent to the value returned by
     * {@code Double.longBitsToDouble(0x7ff8000000000000L)}.
     */
    public static final double NaN = 0.0d / 0.0;
```


当整数除以 0 的时候（10 / 0），会抛出异常

```s
Exception in thread "main" java.lang.ArithmeticException: / by zero
    at com.itwanger.eleven.ArithmeticOperator.main(ArithmeticOperator.java:32)
```

通常，我们在进行整数的除法运算时，需要先判断除数是否为 0，以免程序抛出异常。



## Double.MIN_VALUE

* [Why is Double.MIN_VALUE in not negative | Stack Overflow](https://stackoverflow.com/questions/3884793/why-is-double-min-value-in-not-negative)
* [为什么Double.MIN_VALUE不是负数](https://www.codenong.com/3884793/)
* [Java基本数据类型-Double.MIN_VALUE](https://www.cnblogs.com/Alanf/p/9279453.html)



下面代码打印输出结果是什么？

```java
public class Test {
    public static void main(String[] args) {
        System.out.println(Math.min(Double.MIN_VALUE, 0.0d));
    }
}
```

`Double.MIN_VALUE` 和 `Double.MAX_VALUE` 一样，都是正数，`Double.MIN_VALUE` 的值是 `2^(-1074)`，直接打印 `Double.MIN_VALUE` 的话，输出结果为 `4.9E-324`。

因此这道题的正确答案是输出 `0.0`。


```java
    /**
     * A constant holding the smallest positive nonzero value of type
     * {@code double}, 2<sup>-1074</sup>. It is equal to the
     * hexadecimal floating-point literal
     * {@code 0x0.0000000000001P-1022} and also equal to
     * {@code Double.longBitsToDouble(0x1L)}.
     */
    public static final double MIN_VALUE = 0x0.0000000000001P-1022; // 4.9e-324
    
    /**
     * A constant holding the negative infinity of type
     * {@code double}. It is equal to the value returned by
     * {@code Double.longBitsToDouble(0xfff0000000000000L)}.
     */
    public static final double NEGATIVE_INFINITY = -1.0 / 0.0;
```

**`Double.MIN_VALUE` 表示的是 64 位双精度值能表示的最小正数。**

如果需要用到 Double 的负无穷，可以用 `Double.NEGATIVE_INFINITY`。

`Double.MAX_VALUE` 表示最大的double值，在这种情况下，可以认为 `-Double.MAX_VALUE` 是最小的实际数。



## System.exit(0)和finally


下面程序输出是什么？


在 `try` 块或者 `catch` 语句中执行 `return` 语句或者 `System.exit()` 会发生什么，`finally` 语句还会执行吗？

需要指出的是，不要刻板的认为 `finally` 语句是无论如何都会执行的。事实上，在 `try` 块或者 `catch` 语句中执行 `return` 语句时，`finally` 语句会执行；但若执行了 `System.exit()` 时，`finally` 语句不会执行。


```java
public class Test1 {
    public static void main(String[] args) {
        returnTryExec();
        returnCatchExec();
        exitTryExec();
        exitCatchExec();
    }

    public static int returnTryExec() {
        try {
            return 0;
        } catch (Exception e) {
        } finally {
            System.out.println("finally returnTryExec");
            return -1;
        }
    }

    public static int returnCatchExec() {
        try { } catch (Exception e) {
            return 0;
        } finally {
            System.out.println("finally returnCatchExec");
            return -1;
        }
    }

    public static void exitTryExec() {
        try {
            System.exit(0);
        } catch (Exception e) {
        } finally {
            System.out.println("finally exitTryExec");
        }
    }

    public static void exitCatchExec() {
      //exitTryExec方法中调用了System.exit(0);
      //所以exitCatchExec这个函数不会被执行
        try { 

        } catch (Exception e) {
            System.exit(0);
        } finally {
            System.out.println("finally exitCatchExec");
        }
    }
}
```

程序执行结果如下所示

```
finally returnTryExec
finally returnCatchExec
```

* [ref-system.exit和finally说明](https://www.jianshu.com/p/c3b2635bd4bc)

**`System.exit(status)` 调用了关闭 JVM 的方法，因此后面的 `finlaly` 不会继续执行了。** 其中，`status` 非 0 表示异常退出，0 表示正常退出。



```java
    /**
     * Terminates the currently running Java Virtual Machine. The
     * argument serves as a status code; by convention, a nonzero status
     * code indicates abnormal termination.
     * <p>
     * This method calls the <code>exit</code> method in class
     * <code>Runtime</code>. This method never returns normally.
     * <p>
     * The call <code>System.exit(n)</code> is effectively equivalent to
     * the call:
     * <blockquote><pre>
     * Runtime.getRuntime().exit(n)
     * </pre></blockquote>
     *
     * @param      status   exit status.
     * @throws     SecurityException
     *                     if a security manager exists and its <code>checkExit</code> method doesn't allow exit with the specified status.
     * @see        java.lang.Runtime#exit(int)
     */
    public static void exit(int status) {
        Runtime.getRuntime().exit(status);
    }
```

## 静态方法不能被重写


* 题目

```s
私有方法和静态方法是否可以被重写？
```

**答案是私有方法和静态方法，都不能被重写。**


下面先看一个方法重写的示例。

```java
class LaoWang{
    public void write() {
        System.out.println("老王写了一本《基督山伯爵》");
    }
}
class XiaoWang extends LaoWang {
    @Override
    public void write() {
        System.out.println("小王写了一本《茶花女》");
    }
}
public class OverridingTest {
    public static void main(String[] args) {
        LaoWang wang = new XiaoWang();
        wang.write();
    }
}
```


在 `main` 方法中，我们声明了一个类型为 `LaoWang` 的变量 `wang`。在编译期间，编译器会检查 `LaoWang` 类是否包含了 `write()` 方法，发现 `LaoWang` 类有，于是编译通过。**在运行期间，`new` 了一个 `XiaoWang` 对象，并将其赋值给 `wang`，此时 Java 虚拟机知道 `wang` 引用的是 `XiaoWang` 对象，所以调用的是子类 `XiaoWang` 中的 `write()` 方法而不是父类 `LaoWang` 中的 `write()` 方法**，因此输出结果为 *小王写了一本《茶花女》*。


私有方法对子类是不可见的，它仅在当前声明的类中可见，`private` 关键字满足了封装的最高级别要求。另外，**<font color="red">Java 中的私有方法是通过编译期的静态绑定的方式绑定的，不依赖于特定引用变量所持有的对象类型。</font>**

**<font color="red">方法重写适用于动态绑定，因此私有方法无法被重写。</font>**

看下面的例子。

```java
class LaoWang{
    public LaoWang() {
        write();
        read();
    }
    public void write() {
        System.out.println("老王写了一本《基督山伯爵》");
    }

    private void read() {
        System.out.println("老王在读《哈姆雷特》");
    }
}
class XiaoWang extends LaoWang {
    @Override
    public void write() {
        System.out.println("小王写了一本《茶花女》");
    }

    private void read() {
        System.out.println("小王在读《威尼斯商人》");
    }
}
public class PrivateOrrideTest {
    public static void main(String[] args) {
        LaoWang wang = new XiaoWang();
    }
}
```

程序输出结果如下所示

```
小王写了一本《茶花女》
老王在读《哈姆雷特》
```

在父类的构造方法中，分别调用了 `write()` 和 `read()` 方法，`write()` 方法是 `public` 的，可以被重写，因此执行了子类的 `write()` 方法，`read()` 方法是私有的，无法被重写，因此执行的仍然是父类的 read() 方法。


**<font color="red">和私有方法类似，静态方法在编译期也是通过静态绑定的方式绑定的，不依赖于特定引用变量所持有的对象类型。方法重写适用于动态绑定，因此静态方法无法被重写。</font>**


```java
public class StaticOrrideTest {
    public static void main(String[] args) {
        Laozi zi = new Xiaozi();
        zi.write();
    }
}
class Laozi{
    public static void write() {
        System.out.println("老子写了一本《基督山伯爵》");
    }
}
class Xiaozi extends Laozi {
    public static void write() {
        System.out.println("小子写了一本《茶花女》");
    }
}
```

程序输出结果如下所示

```
老子写了一本《基督山伯爵》
```

引用变量 `zi` 的类型为 `Laozi`，所以 `zi.write()` 执行的是父类中的 `write()` 方法。





### Object类常用的12个方法
* [Object类常用的12个 | 掘金](https://juejin.cn/post/6844903983295774734)



`Object` 常用的方法如下（12个）
1. getClass
2. hasCode
3. equals
4. clone
5. toString
6. notify
7. notifyAll
8. wait(long timeout)
9. wait(long timeout, int nanos) 
10. wait
11. finalize



#### getClass方法

```java
public final native Class<?> getClass();
```

`final` 方法、获取对象的运行时 `class` 对象，`class` 对象就是描述对象所属类的对象。这个方法通常是和 Java 反射机制搭配使用的。



#### clone方法

```java
protected native Object clone() throws CloneNotSupportedException;
```

该方法是保护方法，实现对象的浅复制，只有实现了 `Cloneable` 接口才可以调用该方法，否则抛出 `CloneNotSupportedException` 异常。默认的 `clone` 方法是浅拷贝。

所谓浅拷贝，指的是对象内属性引用的对象只会拷贝引用地址，而不会将引用的对象重新分配内存。深拷贝则是会连引用的对象也重新创建。


#### finalize方法

```java
protected void finalize() throws Throwable {}
```


finalize 是在 `java.lang.Object` 里定义的方法，也就是说每一个对象都有这么个方法，这个方法在 `gc` 启动，该对象被回收的时候被调用。

**一个对象的 `finalize` 方法只会被调用一次，`finalize` 被调用不一定会立即回收该对象，所以有可能调用 `finalize` 后，该对象又不需要被回收了，然后到了真正要被回收的时候，因为前面调用过一次，所以不会再次调用`finalize` 了，进而产生问题，因此不推荐使用 `finalize` 方法。**


```java
class Student {
    // Java Object finalize() 方法用于实例被垃圾回收器回收的时触发的操作
    // JVM不保证此方法总被调用
    @Override
    protected void finalize() throws Throwable {
        System.out.println("Student 被回收了");
    }
}
```


## 打印昨天零点零分的日期


```s

SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
Calendar calendar  = Calendar.getInstance();
calendar.set(Calendar.SECOND,0);
calendar.set(Calendar.MINUTE,0);
calendar.set(Calendar.HOUR,0);
calendar.add(Calendar.DATE,-1);
String str = simpleDateFormat.format(calendar.getTime());
System.out.println(str);
```



## Future实现阻塞等待获取结果的原理

`Future.get()` 用于异步结果的获取。它是阻塞的，背后原理是什么呢？

`FutureTask` 实现了 `RunnableFuture` 接口，`RunnableFuture` 继承了`Runnable` 和 `Future` 这两个接口。


`Future` 表示一个任务的生命周期，并提供了相应的方法来判断是否已经完成或取消，以及获取任务的结果和取消任务等。

`FutureTask` 就是 `Runnable` 和 `Future` 的结合体，我们可以把 `Runnable` 看作生产者，`Future` 看作消费者。而 `FutureTask` 是被这两者共享的，生产者运行 `run` 方法计算结果，消费者通过 `get` 方法获取结果。
