
# Java Notes-31-Java面试题整理

[TOC]


## 更新
* 2021/02/15，撰写


## 参考资料
* [10 道虐心的 Java 面试题](http://www.itwanger.com/java/2020/12/23/java-interview-10.html)



## new Object()的过程

```java
Object obj = new Object();
```

使用 `new` 关键字创建一个对象时，如上代码所示，其过程包括
1. 分块一块内存M
2. 在内存M上初始化该对象
3. 将内存M的地址赋值给引用变量obj


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
        try { } catch (Exception e) {
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

**`System.exit(status)` 调用了关闭 Jvm 的方法，因此后面的 `finlaly` 不会继续执行了。** 其中，`status` 非0表示异常退出，0表示正常退出。



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

给出下面题目的答案

```
私有方法和静态方法是否可以被重写？
```

答案是私有方法和静态方法，都不能被重写。


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

```
Exception in thread "main" java.lang.ArithmeticException: / by zero
    at com.itwanger.eleven.ArithmeticOperator.main(ArithmeticOperator.java:32)
```

通常，我们在进行整数的除法运算时，需要先判断除数是否为 0，以免程序抛出异常。




## Java 支持多重继承吗

使用 `extends` 关键字，Java不支持多重继承，因为会存在菱形问题。

但是，使用 `implements` 关键字，通过接口可以达到多重继承的目的。


来定义两个接口，`Fly` 会飞，`Run` 会跑。

```java
public interface Fly {
    void fly();
}
public interface Run {
    void run();
}
```

然后让一个类同时实现这两个接口。

```java
public class Pig implements Fly,Run{
    @Override
    public void fly() {
        System.out.println("会飞的猪");
    }

    @Override
    public void run() {
        System.out.println("会跑的猪");
    }
}
```



Java 只支持单一继承，是因为涉及到菱形问题。如果有两个类共同继承一个有特定方法的父类，那么该方法可能会被两个子类重写。然后，如果你决定同时继承这两个子类，那么在你调用该重写方法时，编译器不能识别你要调用哪个子类的方法。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-multi-extends-faq-1.png)


类 C 同时继承了类 A 和类 B，类 C 的对象在调用类 A 和类 B 中重写的方法时，就不知道该调用类 A 的方法，还是类 B 的方法。

