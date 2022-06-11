
# JVM-02-JVM类加载机制、双亲委派和SPI机制

[TOC]



## 更新
* 2022/05/25，撰写


## 参考资料
* 《深入理解Java虚拟机》周志明 - 第7章 虚拟机类加载机制
* [JVM类加载机制 | 陈树义Blog](https://www.cnblogs.com/chanshuyi/p/jvm_serial_07_jvm_class_loader_mechanism.html)
* [Java类加载器classloader的原理及应用 | 掘金](https://juejin.cn/post/6931972267609948167)
* [你确定你真的理解"双亲委派"了吗 | Blog](https://www.cnblogs.com/hollischuang/p/14260801.html)
* [Java常用机制 - SPI机制详解 | Java全栈知识体系](https://pdai.tech/md/java/advanced/java-advanced-spi.html)





## 前言

* 一个编译后的 `class` 文件，想要在 JVM 中运行，就需要先加载到 JVM 中。这就涉及到类的「生命周期」和「加载过程」。
* Java 中将类的加载工具抽象为「类加载器（`classloader`）」。
* 「双亲委派」机制是 Java 中通过加载工具（`classloader`）加载类文件的一种具体方式。
* JVM 中类加载器默认使用双亲委派原则，但双亲委派模型并不是一个强制性约束。如 Java 的 「SPI 机制」、Tomcat、日志门面等场景中，均打破了双亲委派模型。




## 类的生命周期和加载过程

类的生命周期可以划分为 7 个阶段
1. 加载
2. 验证
3. 准备
4. 解析
5. 初始化
6. 使用
7. 卸载

其中，第 1~5 阶段，即加载、验证、准备、解析、初始化，统称为「类加载」，如下图所示。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-classloader-class-life-phase-1.png)



### 1.加载

加载阶段是类加载过程的第一个阶段。在这个阶段，JVM 的主要目的是将字节码从各个位置（网络、磁盘等）转化为二进制字节流加载到内存中，接着会为这个类在 JVM 的方法区创建一个对应的 `Class` 对象，这个 `Class` 对象就是这个类各种数据的访问入口。


**该过程可以总结为「JVM 加载 `Class` 字节码文件到内存中，并在方法区创建对应的 `Class` 对象」。**

### 2.验证

当 JVM 加载完 `Class` 字节码文件，并在方法区创建对应的 `Class` 对象之后，JVM 便会启动对该字节码流的校验，只有符合 JVM 字节码规范的文件才能被 JVM 正确执行。

这个校验过程，大致可以分为下面几个类型
1. JVM 规范校验
   * JVM 会对字节流进行文件格式校验，判断其是否符合 JVM 规范，是否能被当前版本的虚拟机处理。
   * 例如，校验文件是否是以 `0x cafe babe` 开头，主次版本号是否在当前虚拟机处理范围之内等。
2. 代码逻辑校验
   * JVM 会对代码组成的数据流和控制流进行校验，确保 JVM 运行该字节码文件后不会出现致命错误。
   * 例如，一个方法要求传入 `int` 类型的参数，但是使用它的时候却传入了一个  `String` 类型的参数。


### 3.准备

**准备阶段中，JVM 将为类变量分配内存并初始化。** 

准备阶段，有两个关键点需要注意
1. 内存分配的对象
2. 初始化的类型



> 内存分配的对象

Java 中的变量有「类变量」和「类成员变量」两种类型。「类变量」指的是被 `static` 修饰的变量，而其他所有类型的变量都属于「类成员变量」。**在准备阶段，JVM 只会为「类变量」分配内存，而不会为「类成员变量」分配内存。「类成员变量」的内存分配需要等到初始化阶段才开始。**


```java
public static int factor = 3;
public String website = "www.google.com";
```

如上代码，在准备阶段，只会为 `factor` 变量分配内存，而不会为 `website` 变量分配内存。


> 初始化的类型

**在准备阶段，JVM 会为「类变量」分配内存并为其初始化。这里的「初始化」指的是为变量赋予 Java 语言中该数据类型的零值，而不是用户代码里初始化的值。**


```java
public static int sector = 3;
```

如上代码，在准备阶段后，`sector` 的值将是 0，而不是 3。


**如果一个变量是常量（被 `static final` 修饰）的话，那么在准备阶段，变量便会被赋予用户希望的值。** `final` 关键字用在变量上，表示该变量不可变，一旦赋值就无法改变。所以，在准备阶段中，对类变量初始化赋值时，会直接赋予用户希望的值。

```java
public static final int number = 3;
```

如上代码，在准备阶段后，`number` 的值将是 3，而不是 0。


### 4.解析
解析过程中，JVM 针对「类或接口」、「字段」、「类方法」、「接口方法」、「方法类型」、「方法句柄」、「调用点限定符」这 7 类引用进行解析。解析过程的主要任务是将其在常量池中的符号引用，替换成其在内存中的直接引用。

### 5.初始化

到了初始化阶段，用户定义的 Java 程序代码才真正开始执行。在这个阶段，JVM 会根据语句执行顺序对类对象进行初始化。

一般来说，当 JVM 遇到下面 5 种情况的时候会触发初始化
1. 遇到 `new`、`getstatic`、`putstatic`、`invokestatic` 这 4 条字节码指令时，如果类没有进行过初始化，则需要先触发其初始化。
    * 生成这 4 条指令的最常见的 Java 代码场景是使用 `new` 关键字实例化对象的时候、读取或设置一个类的静态字段（被 `final` 修饰、已在编译器把结果放入常量池的静态字段除外）的时候，以及调用一个类的静态方法的时候。
2. 使用 `java.lang.reflect` 包的方法对类进行反射调用的时候，如果类没有进行过初始化，则需要先触发其初始化。
3. 当初始化一个类的时候，如果发现其父类还没有进行过初始化，则需要先触发其父类的初始化。
4. 当虚拟机启动时，用户需要指定一个要执行的主类（包含 `main()` 方法的那个类），虚拟机会先初始化这个主类。
5. 当使用 JDK 1.7 动态语言支持时，如果一个 `java.lang.invoke.MethodHandle` 实例最后的解析结果是 `REF_getstatic`、`REF_putstatic`、`REF_invokeStatic` 的方法句柄，并且这个方法句柄所对应的类没有进行初始化时，则需要先出触发其初始化。



### 6.使用


当 JVM 完成初始化阶段之后，JVM 便开始从入口方法开始执行用户的程序代码。

### 7.卸载

当用户程序代码执行完毕后，JVM 便开始销毁创建的 `Class` 对象，最后负责运行的 JVM 也退出内存。


## 对类加载的理解


下面，将通过几个案例，对类加载的 5 个阶段加深理解。


### 类初始化方法和对象初始化方法


```java
public class Book {
    public static void main(String[] args) {
        System.out.println("Hello Liu Baoshuai");
    }

    Book() {
        System.out.println("书的构造方法");
        System.out.println("price=" + price +",amount=" + amount);
    }

    {
        System.out.println("书的普通代码块");
    }

    int price = 110;

    static{
        System.out.println("书的静态代码块");
    }

    static int amount = 112;
}
```

运行上述代码，输出信息如下。

```s
书的静态代码块
Hello Liu Baoshuai
```


下面对输出结果进行分析。

根据「类的生命周期和加载过程 / 5.初始化」章节中提到的「当虚拟机启动时，用户需要指定一个要执行的主类（包含 `main()` 方法的那个类），虚拟机会先初始化这个主类」可知，我们将会进行类的初始化。

**Java 源代码中有构造方法这个概念。但编译为字节码后，是没有构造方法这个概念的，只有「类初始化方法」和「对象初始化方法」。**
1. 「类初始化方法」
   * 编译器会按照代码出现的顺序，收集类变量的赋值语句、静态代码块，最终组成类初始化方法。
   * **类初始化方法一般在类初始化的时候执行。**


上面的例子中，其类初始化方法如下。

```java
    static {
        System.out.println("书的静态代码块");
    }

    static int amount = 112;
```

2. 「对象初始化方法」
   * 编译器会按照代码出现的顺序，收集成员变量的赋值语句、普通代码块，**最后**收集构造函数的代码，最终组成对象初始化方法。**注意，构造函数的代码一定是被放在最后的。**
   * **对象初始化方法一般在实例化类对象的时候执行。**

上面的例子中，其对象初始化方法如下。

```java
    {
        System.out.println("书的普通代码块");
    }

    int price = 110;

    //注意，构造函数的代码一定是被放在最后的
    Book() {
        System.out.println("书的构造方法");
        System.out.println("price=" + price +",amount=" + amount);
    }
```

结合「类初始化方法」和「对象初始化方法」的分析，再回过头看上述例子，就不难得出结论了。
1. 当虚拟机启动时，用户需要指定一个要执行的主类（包含 main() 方法的那个类），虚拟机会先初始化这个主类。所以开始执行「初始化」过程。
2. `main` 方法中，并没有实例化对象，所以只执行「类初始化方法」，如下所示。因此，会输出 `书的静态代码块`。

```java
    static {
        System.out.println("书的静态代码块");
    }

    static int amount = 112;
```
3. 初始化过程执行完毕后，继续执行 `main()` 方法。因此，会输出 `Hello Liu Baoshuai`。


> 案例引申

下面，对上述测试案例进一步引申，修改 `main()` 方法，代码如下所示。

```java
public class Book {
    public static void main(String[] args) {
        System.out.println("Hello Liu Baoshuai" + new Book().price);
    }

    Book() {
        System.out.println("书的构造方法");
        System.out.println("price=" + price +",amount=" + amount);
    }

    {
        System.out.println("书的普通代码块");
    }

    int price = 110;

    static{
        System.out.println("书的静态代码块");
    }

    static int amount = 112;
}
```

运行上述代码，输出信息如下。

```s
书的静态代码块
书的普通代码块
书的构造方法
price=110,amount=112
Hello Liu Baoshuai110
```


下面对输出结果进行分析。

1. 当虚拟机启动时，用户需要指定一个要执行的主类（包含 main() 方法的那个类），虚拟机会先初始化这个主类。所以开始执行「初始化」过程。
2. 「初始化」过程中，先执行「类初始化方法」，如下所示。因此，会输出 `书的静态代码块`。

```java
    static {
        System.out.println("书的静态代码块");
    }

    static int amount = 112;
```
3. 「类初始化方法」执行完毕后，继续执行 `main()` 方法。遇到了 `new Book()` 语句，所以触发执行「对象初始化方法」，如下所示。

```java
    // part 1
    {
        System.out.println("书的普通代码块");
    }
    // part 2
    int price = 110;

    // part 3
    Book() {
        System.out.println("书的构造方法");
        System.out.println("price=" + price +",amount=" + amount);
    }
```

4. 需要注意的是，`part 1` 和 `part 2` 的先后顺序，是根据它们在代码中出现的顺序决定的。`part 3` 部分是构造函数部分，这部分永远是出现最后的，和它在代码中的顺序无关。在代码中，`part 3` 部分虽然出现在 `part 1` 和 `part 2` 的前面，但在「对象初始化方法」中，它永远是出现在最后的。
5. 此外，由于 `part 2` 出现在 `part 3` 前面，所以输出 `price` 的值是 110，而不是 0。



### 继承关系下类的加载情况


```java
class Grandpa
{
    static
    {
        System.out.println("爷爷在静态代码块");
    }
}   

class Father extends Grandpa
{
    static
    {
        System.out.println("爸爸在静态代码块");
    }

    public static int factor = 25;

    public Father()
    {
        System.out.println("我是爸爸~");
    }
}

class Son extends Father
{
    static 
    {
        System.out.println("儿子在静态代码块");
    }

    public Son()
    {
        System.out.println("我是儿子~");
    }
}
public class InitializationDemo
{
    public static void main(String[] args)
    {
        System.out.println("爸爸的岁数:" + Son.factor);	//入口
    }
}
```

运行上述代码，输出信息如下。

```s
爷爷在静态代码块
爸爸在静态代码块
爸爸的岁数:25
```



下面对输出结果进行分析。

1. 当虚拟机启动时，用户需要指定一个要执行的主类（包含 main() 方法的那个类），虚拟机会先初始化这个主类。所以开始执行「初始化」过程。
2. `main` 方法中，并没有实例化对象，所以只执行「类初始化方法」，不会执行「对象初始化方法」。
3. 根据「类的生命周期和加载过程 / 5.初始化」章节中提到的「当初始化一个类的时候，如果发现其父类还没有进行过初始化，则需要先触发其父类的初始化」可知，进行 `Son` 初始化时，会先进行父类 `Father` 的初始化。同理，进行 `Father` 初始化时，会先进行父类 `Grandpa` 的初始化。所以，程序会输出如下信息。

```s
爷爷在静态代码块
爸爸在静态代码块
```

4. 继续，执行 `main()` 方法中的 `System.out.println` 语句，程序会输出 `爸爸的岁数:25`。


**也许会有人问为什么没有输出「儿子在静态代码块」这个字符串？这是因为对于静态字段，只有直接定义这个字段的类才会被初始化，才会执行该类的「类初始化方法」。因此，通过其子类来引用父类中定义的静态字段，只会触发父类的初始化，而不会触发子类的初始化。**




### 继承关系下实例化对象


```java
class Grandpa
{
    static
    {
        System.out.println("爷爷在静态代码块");
    }

    public Grandpa() {
        System.out.println("我是爷爷~");
    }
}

class Father extends Grandpa
{
    static
    {
        System.out.println("爸爸在静态代码块");
    }

    public Father()
    {
        System.out.println("我是爸爸~");
    }
}

class Son extends Father
{
    static 
    {
        System.out.println("儿子在静态代码块");
    }

    public Son()
    {
        System.out.println("我是儿子~");
    }
}

public class InitializationDemo
{
    public static void main(String[] args)
    {
        new Son(); 	//入口
    }
}
```

运行上述代码，输出信息如下。

```s
爷爷在静态代码块
爸爸在静态代码块
儿子在静态代码块
我是爷爷~
我是爸爸~
我是儿子~
```


下面对输出结果进行分析。

1. 当虚拟机启动时，用户需要指定一个要执行的主类（包含 main() 方法的那个类），虚拟机会先初始化这个主类。所以开始执行「初始化」过程。
2. 根据「类的生命周期和加载过程 / 5.初始化」章节中提到的「当初始化一个类的时候，如果发现其父类还没有进行过初始化，则需要先触发其父类的初始化」可知，进行 `Son` 初始化时，会先进行父类 `Father` 的初始化。同理，进行 `Father` 初始化时，会先进行父类 `Grandpa` 的初始化。所以，程序会输出如下信息。

```s
爷爷在静态代码块
爸爸在静态代码块
儿子在静态代码块
```


3. `main()` 方法的 `new Son()` 语句将触发实例化对象，调用 `Son` 的构造函数，调用子类的构造函数时会先调用父类的构造函数。所以，程序会输出如下信息。

```s
我是爷爷~
我是爸爸~
我是儿子~
```


### 类初始化方法中执行对象初始化方法


```java
public class Book {
    public static void main(String[] args)
    {
        staticFunction();
    }

    static Book book = new Book(); //注意该语句

    static
    {
        System.out.println("书的静态代码块");
    }

    {
        System.out.println("书的普通代码块");
    }

    Book()
    {
        System.out.println("书的构造方法");
        System.out.println("price=" + price +",amount=" + amount);
    }

    public static void staticFunction(){
        System.out.println("书的静态方法");
    }

    int price = 110;
    static int amount = 112;
}
```


运行上述代码，输出信息如下。

```s
书的普通代码块
书的构造方法
price=110,amount=0
书的静态代码块
书的静态方法
```


下面对输出结果进行分析。


1. 准备阶段中，会为类变量分配内存和进行初始化。此时，`book` 实例变量被初始化为 `null`，`amount` 变量被初始化为 0。
2. 进入初始化阶段后，因为 `Book` 类的 `main()` 方法是程序的入口，所以 JVM 会初始化 `Book` 类，执行「类初始化方法」，如下所示。


```java
    static Book book = new Book(); //注意该语句

    static
    {
        System.out.println("书的静态代码块");
    }

    static int amount = 112;
```

3. 如上代码所示，会先执行 `static Book book = new Book()`。这条语句又触发了类的实例化，所以会执行「对象初始化方法」，如下所示。

```java
    // part 1
    {
        System.out.println("书的普通代码块");
    }
    // part 2
    int price = 110;

    // part 3
    Book()
    {
        System.out.println("书的构造方法");
        System.out.println("price=" + price +",amount=" + amount);
    }
```

4. 需要注意的是，`part 1` 和 `part 2` 的先后顺序，是根据它们在代码中出现的顺序决定的。`part 3` 部分是构造函数部分，这部分永远是出现最后的，和它在代码中的顺序无关。在代码中，`part 3` 部分虽然出现在 `part 2` 的前面，但在「对象初始化方法」中，它永远是出现在最后的。
5. 此外，由于 `part 2` 出现在 `part 3` 前面，所以输出 `price` 的值是 110，而不是 0。
6. 至此，程序输出如下。

```s
书的普通代码块
书的构造方法
price=110,amount=0
```
7. 继续，执行完 `static Book book = new Book()` 语句后，回到步骤 2 中，执行「类初始化方法」。此时，程序会输出 `书的静态代码块`。
8. 继续，执行 `main()` 方法的 `staticFunction();` 语句。此时，程序会输出 `书的静态方法`。





## 类加载机制和类加载器
### 什么是类加载机制

当编译器将 Java 源码编译为字节码之后，虚拟机便可以将字节码读取进内存，从而进行解析、运行等整个过程。我们将这个过程称为 Java 虚拟机的「类加载机制」。



「类加载机制」中，通过类加载器（`classloader`）来完成类加载的过程。
### 类加载器

#### 什么是类加载器

通过一个类全限定名称来获取其二进制文件（`.class`）流的工具，被称为类加载器（`classloader`）。


#### Java支持的4种classloader

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/jvm-classloader-parent-1.png)


如上图所示，Java 支持 4 种 `classloader`
1. 启动类加载器（`Bootstrap ClassLoader`）
   * 用于加载 Java 的核心类
   * 它不是一个 Java 类，是由底层的 C++ 实现。因此，启动类加载器不属于 Java 类库，无法被 Java 程序直接引用。`Bootstrap ClassLoader` 的 `parent` 属性为 `null`
2. 标准扩展类加载器（`Extention ClassLoader`)
   * 由 `sun.misc.Launcher$ExtClassLoader` 实现
   * 负责加载 `JAVA_HOME` 下 `libext` 目录下的或者被 `java.ext.dirs` 系统变量所指定的路径中的所有类库
3. 应用类加载器（`Application ClassLoader`)
   * 由 `sun.misc.Launcher$AppClassLoader` 实现
   * 负责在 JVM 启动时加载用户类路径上的指定类库
4. 用户自定义类加载器（`User ClassLoader`) 
   * 当上述 3 种类加载器不能满足开发需求时，用户可以自定义加载器
   * **自定义类加载器时，需要继承 `java.lang.ClassLoader` 类。如果不想打破双亲委派模型，那么只需要重写 `findClass` 方法即可；如果想打破双亲委派模型，则需要重写 `loadClass` 方法**




前 3 种 `classloader` 均继承了抽象类 `ClassLoader`，其源码如下，该抽象类拥有一个 `parent` 属性，用于指定其父类的加载器。


```java
public abstract class ClassLoader {

    private static native void registerNatives();
    static {
        registerNatives();
    }

    // The parent class loader for delegation
    // Note: VM hardcoded the offset of this field, thus all new fields
    // must be added *after* it.
    private final ClassLoader parent;

    protected Class<?> findClass(String name) throws ClassNotFoundException {
        throw new ClassNotFoundException(name);
    }
    
    // ...

    protected synchronized Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
        // First, check if the class has already been loaded
        Class c = findLoadedClass(name);
        if (c == null) {
            try {
                if (parent != null) {
                    c = parent.loadClass(name, false);
                } else {
                    c = findBootstrapClass0(name);
                }
            } catch (ClassNotFoundException e) {
                // If still not found, then invoke findClass in order
                // to find the class.
                c = findClass(name);
            }
        }
        if (resolve) {
            resolveClass(c);
        }
        return c;
    }
}
```


可以通过下面这种方式，打印加载路径及相关 jar。

```java
System.out.println("boot:" + System.getProperty("sun.boot.class.path"));
System.out.println("ext:" + System.getProperty("java.ext.dirs"));
System.out.println("app:" + System.getProperty("java.class.path"));
```






#### 自定义类加载器

此处给出一个自定义类加载器示例。



```java
package com.lbs0912.java.demo;

import java.io.IOException;
import java.io.InputStream;

public class ConsumerClassLoaderDemo extends ClassLoader {

    public static void main(String[] args) throws Exception {

        ClassLoader myClassLoader = new ConsumerClassLoader();
        Object obj = myClassLoader.loadClass("com.lbs0912.java.demo.ConsumerClassLoaderDemo").newInstance();
        ClassLoader classLoader = obj.getClass().getClassLoader();
        // BootStrapClassLoader在Java中不存在的，因此会是null
        while (null != classLoader) {
            System.out.println(classLoader);
            classLoader = classLoader.getParent();
        }
    }
}

class ConsumerClassLoader extends ClassLoader {
    @Override
    public Class<?> loadClass(String name) throws ClassNotFoundException {
        try {
            String classFile = name.substring(name.lastIndexOf(".") + 1) + ".class";
            InputStream in = getClass().getResourceAsStream(classFile);
            if (null == in) {
                return super.loadClass(name);
            }
            byte[] bytes = new byte[in.available()];
            in.read(bytes);
            return defineClass(name, bytes, 0, bytes.length);
        } catch (IOException e) {
            throw new ClassNotFoundException(name);
        }
    }
}
```


控制台输入如下


```s
com.lbs0912.java.demo.ConsumerClassLoader@266474c2
sun.misc.Launcher$AppClassLoader@18b4aac2
sun.misc.Launcher$ExtClassLoader@63947c6b
```


#### Java 9 中类加载器的变化

* ref 1-[Java 9 中类加载器的变化 | Segmentfault](https://segmentfault.com/a/1190000020847626)


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-9-classloader-1.png)



### 类加载机制的特点


「类加载机制」中，通过「类加载器（`classloader`）」来完成类加载的过程。Java 中的类加载机制，有如下 3 个特点
1. **双亲委派** 
   * JVM 中，类加载器默认使用双亲委派原则
2. **负责依赖**
   * 如果一个加载器在加载某个类的时候，发现这个类依赖于另外几个类或接口，也会去尝试加载这些依赖项。
3. **缓存加载**
   * 为了提升加载效率，消除重复加载，一旦某个类被一个类加载器加载，那么它会缓存这个加载结果，不会重复加载。



下面对「双亲委派」进行说明。




## 双亲委派

### 什么是双亲委派

> JVM 中，类加载器默认使用双亲委派原则。

**双亲委派机制是一种任务委派模式，是 Java 中通过加载工具（`classloader`）加载类文件的一种具体方式。** 具体表现为
1. 如果一个类加载器收到了类加载请求，它并不会自己先加载，而是把这个请求委托给父类的加载器去执行。
2. 如果父类加载器还存在其父类加载器，则进一步向上委托，依次递归，请求最终将到达顶层的引导类加载器 `BootstrapClassLoader`。
3. 如果父类加载器可以完成类加载任务，就成功返回；倘若父类加载器无法完成加载任务，子加载器才会尝试自己去加载。
4. 父类加载器一层一层往下分配任务，如果子类加载器能加载，则加载此类；如果将加载任务分配至系统类加载器（`AppClassLoader`）也无法加载此类，则抛出异常。





### 父委派模型被翻译成了双亲委派机制

> The Java platform uses a delegation model for loading classes. The basic idea is that every class loader has a “parent” class loader. When loading a class, a class loader first “delegates” the search for the class to its parent class loader before attempting to find the class itself. —— Oracel Document
> 
> Java 平台通过委派模型去加载类。每个类加载器都有一个父加载器。当需要加载类时，会优先委派当前所在的类的加载器的父加载器去加载这个类。如果父加载器无法加载到这个类时，再尝试在当前所在的类的加载器中加载这个类。



参考上述 Oracle 官网文档描述，Java 的类加载机制，更准确的说，应该叫做 “父委派模型”。但由于翻译问题，被称为了 “双亲委派机制”。参考 [Java类加载机制-双亲委派机制还是应该叫做“父委派模型” | CSDN](https://blog.csdn.net/u010841296/article/details/89731566?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-3.control&dist_request_id=6077030a-e458-4e66-badf-71ee51d25037&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-3.control) 了解更多。




### 双亲

`classloader` 类存在一个 `parent` 属性，可以配置双亲属性。默认情况下，JDK 中设置如下。

```java

ExtClassLoader.parent=null;

AppClassLoader.parent=ExtClassLoader

//自定义
XxxClassLoader.parent=AppClassLoader
```

需要注意的是，启动类加载器（`BootstrapClassLoader`）不是一个 Java 类，它是由底层的 C++ 实现，因此启动类加载器不属于 Java 类库，无法被 Java 程序直接引用，所以 `ExtClassLoader.parent=null;`。









### 委派


双亲设置之后，便可以委派了。委派过程也就是类文件加载过程。

`ClassLoader` 里面有 3 个重要的方法，即
1. `loadClass()`
2. `findClass()`
3. `defineClass()`


实现双亲委派的代码都集中在 `java.lang.ClassLoader` 的 `loadClass()` 方法中。



```java
public abstract class ClassLoader {
    // 委派的父类加载器
    private final ClassLoader parent;

    public Class<?> loadClass(String name) throws ClassNotFoundException {
        return loadClass(name, false);
    }


    protected Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
        // 保证该类只加载一次
        synchronized (getClassLoadingLock(name)) {
            // 首先，检查该类是否被加载
            Class<?> c = findLoadedClass(name);
            if (c == null) {
                try {
                    if (parent != null) {
                    	//父类加载器不为空，则用该父类加载器
                        c = parent.loadClass(name, false);
                    } else {
                    	//若父类加载器为空，则使用启动类加载器作为父类加载器
                        c = findBootstrapClassOrNull(name);
                    }
                } catch (ClassNotFoundException e) {
                    //若父类加载器抛出ClassNotFoundException ，
                    //则说明父类加载器无法完成加载请求
                }

                if (c == null) {
                    //父类加载器无法完成加载请求时
                    //调用自身的findClass()方法进行类加载
                    c = findClass(name);
                }
            }
            if (resolve) {
                resolveClass(c);
            }
            return c;
        }
    }

    protected Class<?> findClass(String name) throws ClassNotFoundException {
        throw new ClassNotFoundException(name);
    }
}
```


上述代码的主要步骤如下
1. 先检查类是否已经被加载过
2. 若没有加载，则调用父加载器的 `loadClass()` 方法进行加载
3. 若父加载器为空，则默认使用启动类加载器作为父加载器
4. 如果父类加载失败，抛出 `ClassNotFoundException` 异常后，再调用自己的 `findClass()` 方法进行加载


此处给出一个加载时序图，加深理解。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-classloader-time-info-1.jpeg)


### loadClass、findClass、defineClass 方法的区别

`ClassLoader` 中和类加载有关的方法有很多，前面提到了 `loadClass()`，除此之外，还有 `findClass()` 和 `defineClass()` 等。这3个方法的区别如下
* `loadClass()`：默认的双亲委派机制在此方法中实现
* `findClass()`：根据名称或位置加载 `.class` 字节码
* `definclass()`：把 `.class` 字节码转化为 `Class` 对象 



### 双亲委派的优点

#### 避免类的重复加载

通过委派的方式，可以避免类的重复加载。当父加载器已经加载过某一个类时，子加载器就不会再重新加载这个类。

#### 保证安全性

通过双亲委派的方式，可以保证安全性 。因为 `BootstrapClassLoader` 在加载的时候，只会加载 `JAVA_HOME` 中的 jar 包里面的类，如 `java.lang.String`，那么这个类是不会被随意替换的，除非有人跑到你的机器上，破坏你的 JDK。




### 双亲委派的缺点



在双亲委派中，子类加载器可以使用父类加载器已经加载过的类，但是父类加载器无法使用子类加载器加载过的类（类似继承的关系）。

Java 提供了很多服务提供者接口（SPI，`Service Provider Interface`），它可以允许第三方为这些接口提供实现，比如数据库中的 SPI 服务 - JDBC。这些 SPI 的接口由 Java 核心类提供，实现者确是第三方。如果继续沿用双亲委派，就会存在问题，提供者由 Bootstrap ClassLoader 加载，而实现者是由第三方自定义类加载器加载。这个时候，顶层类加载就无法使用子类加载器加载过的类。


要解决上述问题，就需要打破双亲委派原则。






## 打破双亲委派模型
* ref 1-[破坏双亲委派模型 | 掘金](https://juejin.cn/post/6844903633574690824)

双亲委派模型并不是一个强制性约束，而是 Java 设计者推荐给开发者的类加载器的实现方式。在一定条件下，为了完成某些操作，可以 “打破” 模型。


打破双亲委派模型的方法主要包括
1. 重写 `loadClass()` 方法
2. 利用线程上下文加载器

### 重写 loadClass 方法

在双亲委派的过程，都是在 `loadClass()` 方法中实现的，因此要想要破坏这种机制，可以自定义一个类加载器，继承 `ClassLoader` 并重写 `loadClass()` 方法即可，使其不进行双亲委派。



### 利用线程上下文加载器

利用线程上下文加载器（`Thread Context ClassLoader`）也可以打破双亲委派。


Java 应用上下文加载器默认是使用 `AppClassLoader`。若想要在父类加载器使用到子类加载器加载的类，可以使用 `Thread.currentThread().getContextClassLoader()`。


比如我们想要加载资源可以使用以下方式。


```java
// 使用线程上下文类加载器加载资源
public static void main(String[] args) throws Exception{
    String name = "java/sql/Array.class";
    Enumeration<URL> urls = Thread.currentThread().getContextClassLoader().getResources(name);
    while (urls.hasMoreElements()) {
        URL url = urls.nextElement();
        System.out.println(url.toString());
    }
}
```

```s
//程序输出
jar:file:/Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home/jre/lib/rt.jar!/java/sql/Array.class
jar:file:/Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home/jre/lib/rt.jar!/java/sql/Array.class

```









## 类加载器的应用

* ref 1-[Java类加载器classloader的原理及应用 | 掘金](https://juejin.cn/post/6931972267609948167)




### 依赖冲突


在 Maven 工程中，经常会出现依赖冲突，抛出 `NoSuchMethodException` 异常。如下图所示，业务依赖了消息中间件和微服务中间件，每个模块依赖的 `fastjson` 版本各不相同。根据引用路径最短原则，工程中实际最终引入的 `fastjson` 版本为 `fastjson-1.0`。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-classloader-usage-mvn-conflict-1.png)


因此，在调用 `classA` 的 `method2()` 时候，就会抛出 `NoSuchMethodException` 异常。




此处介绍一下阿里的潘多拉（`pandora`） 是如何解决依赖冲突的。潘多拉中，通过自定义类加载器，为每个中间件自定义一个加载器，这些加载器之间的关系是平行的，彼此没有依赖关系。这样每个中间件的`classloader` 就可以加载各自版本的 `fastjson`。

**一个类的全限定名以及加载该类的加载器，两者共同形成了这个类在 JVM 中的惟一标识，这也是阿里潘多拉实现依赖隔离的基础。**



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-classloader-usage-mvn-conflict-2.png)


可能到这里，你又会有新的疑惑，根据双亲委托模型，`App Classloader` 分别继承了 `Custom Classloader`，那么业务包中的 `fastjson` 的 `class` 在加载的时候，会先委托到 `Custom ClassLoader`，这样不就会导致自身依赖的 `fastjson` 版本被忽略吗？确实如此，所以潘多拉又是如何做的呢？





![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-classloader-usage-mvn-conflict-3.png)


如上图所示
1. 首先每个中间件对应的 `ModuleClassLoader` 在加载对应的 `class` 文件的同时，根据中间件配置的 `export.index` 信息，将要需要透出的 `class`(主要是提供 API 接口的相关类)索引到`exportedClassHashMap`中
2. 然后应用程序的类加载器会持有这个 `exportedClassHashMap`
3. 因此应用程序代码在 `loadClass` 的时候，会优先判断 `exportedClassHashMap` 是否存在当前类。如果存在，则直接返回；如果不存在，则再使用传统的双亲委托机制来进行类加载。
4. 这样中间件 `MoudleClassloader` 不仅实现了中间件的加载，也实现了中间件关键服务类的透出。


上述过程对应代码如下。


```java
    protected Class<?> loadClass(String name, boolean resolve)
            throws ClassNotFoundException
    {
        //导出类中是否存在 若存在则直接返回
        if(classCache != null && classCache.containsKey(name)){
            return classCache.get(name);
        }
        //双亲委托加载机制
        synchronized (getClassLoadingLock(name)) {
            // First, check if the class has already been loaded
            Class<?> c = findLoadedClass(name);
            if (c == null) {
                try {
                    if (parent != null) {
                        c = parent.loadClass(name, false);
                    } else {
                        c = findBootstrapClassOrNull(name);
                    }
                } catch (ClassNotFoundException e) {
                    // ClassNotFoundException thrown if class not found
                    // from the non-null parent class loader
                }

                if (c == null) {
                    // If still not found, then invoke findClass in order
                    // to find the class.
                    c = findClass(name);
                }
            }
            if (resolve) {
                resolveClass(c);
            }
            return c;
        }
    }
```


### Tomcat 中打破双亲委派

我们知道，Tomcat 是一个 web 容器，那么一个 web 容器可能需要部署多个应用程序。

不同的应用程序可能会依赖同一个第三方类库的不同版本，但是不同版本的类库中某一个类的全路径名可能是一样的。如多个应用都要依赖 `hollis.jar`，但是 A 应用需要依赖 1.0.0 版本，但是 B 应用需要依赖 1.0.1 版本。这两个版本中都有一个类是 `com.hollis.Test.class`。

**如果采用默认的双亲委派类加载机制，那么是无法加载多个相同的类。**

**所以，Tomcat 破坏双亲委派原则，提供隔离的机制，为每个 web 容器单独提供一个 `WebAppClassLoader` 加载器。** 工作流程如下
1. 为每一个应用提供一个 `WebAppClassLoader` 加载器，负责加载应用自身目录下的 `class` 文件，从而实现隔离。
2. 只有当加载不到时，才向上委派到通用的加载器 `CommonClassLoader` 进行加载。




### 热加载


通过将一个模块和该模块的类加载器的替换，可以实现热加载。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-classloader-usage-hotfix-1.png)



结合下图，介绍下 Spring 官方推荐的热加载方案 —— Spring boot devtools。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-classloader-usage-hotfix-2.png)


**`RestartClassLoader` 为自定义的类加载器，其核心是 `loadClass` 的加载方式。Spring boot devtools 中修改了双亲委托机制，默认优先从自己加载，如果自己没有加载到，则从 parent 进行加载。** 这样保证了业务代码可以优先被 `RestartClassLoader` 加载，进而通过重新加载 `RestartClassLoader` 完成应用代码部分的重新加载。



上述过程对应代码如下。


```java
    protected Class<?> loadClass(String name, boolean resolve)
            throws ClassNotFoundException
    {
        String path = name.replace('.','/').concat(".class");
        ClassLoaderFile file = this.updatedFiles.getFile(path);
        if(file != null && file.getKind() == Kind.DELETED){
            throw new ClassNotFoundException(name);
        }
        //双亲委托加载机制
        synchronized (getClassLoadingLock(name)) {
            // First, check if the class has already been loaded
            Class<?> loadedClass = findLoadedClass(name);
            if (c == null) {
                try {
                    //优先从自己加载（编译生成的target/classes目录）
                    loadedClass = findClass(name);
                } catch (ClassNotFoundException e) {
                    //如果没有加载到 则从父类加载
                    loadedClass = Class.forName(name,false,getParent());
                }
            }
            if (resolve) {
                resolveClass(loadedClass);
            }
            return loadedClass;
        }
    }
```


### 热部署


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-classloader-usage-hotfix-3.png)



热部署原理大体同热加载，如上图所示，将每个业务方通过一个 `classloader` 来加载。基于「类的隔离机制」，可以保障各个业务方的代码不会相互影响，同时也可以做到各个业务方进行独立的发布。


### 加密保护

出于技术保护或安全的目的，存在对 jar 包进行加密保护的诉求。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-classloader-usage-auth-1.png)



对 jar 包进行加密，本质上还是对字节码文件的操作。加密前后，不能影响 `class` 文件的正常加载过程，因此，加密保护步骤可划分为
1. 在打包的时候对 `class` 进行正向的加密操作
2. 在加载 `class` 文件之前通过自定义 `classloader` 先进行反向的解密操作
3. 最后，按照标准的 `class` 文件标准进行加载




只有在实现了解密方法的 `classloader` 的加载下，加密的 jar 包才可以被正常加载。上述过程对应代码如下。


```java
    protected Class<?> loadClass(String name, boolean resolve)
            throws ClassNotFoundException
    {
        Class<?> clasz = findLoadedClass(name);
        if(clasz != null){
            return clasz;
        }
        
        //提前对class文件进行解密
        try{
            //读取经过加密的类文件
            byte classData[] = util.readFile(name + ".class");
            if(classData != null){
                byte decryptedClassData[] = cipher.doFinal(classData); //解密
                //再把它转换成一个类
                clasz = defineClass(name,decryptedClassData,0,decryptedClassData.length);
            }
        }catch (FileNotFoundException e){
            e.printStackTrace();
        }
        
        
        //必须的步骤2： 如果上面没有成功
        //尝试用默认的classloader装入它
        if(resolve && clasz != null){
            clasz = findSystemClass(name);
        }
        if (resolve) {
            resolveClass(clasz);
        }
        return clasz;
    }
```




## SPI 机制 

* ref 1-[Java常用机制 - SPI机制详解 | Java全栈知识体系](https://pdai.tech/md/java/advanced/java-advanced-spi.html)
* ref 2-[高级开发必须理解的Java中SPI机制](https://www.jianshu.com/p/46b42f7f593c)
* ref 3-[SPI 机制是「可插拔」的奥义所在，SpringBoot Starter 也利用了这个特性](https://mp.weixin.qq.com/s/CGAzsC4wyrR68MOhZd0aLg)



### 什么是 SPI


服务提供接口（`SPI`，`Service Provider Interface`） 是 JDK 内置的一种「服务提供发现机制」，是 Java 提供的一套用来被第三方实现或者扩展的 API，它可以用来启用框架扩展和替换组件（可通过 SPI 机制实现模块化）。SPI 的整体机制图如下。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-spi-structure-1.png)


**Java 的 SPI 机制可以为某个接口寻找服务实现。SPI 机制主要思想是将装配的控制权移到程序之外，在「模块化设计」中这个机制尤其重要，其核心思想就是「解耦」。Java SPI 实际上是 “基于接口的编程 ＋ 策略模式 ＋ 配置文件” 组合实现的动态加载机制。**




### 使用示例

Java 中使用 SPI 的步骤如下图所示，主要包括 3 步
1. 目录创建
   * Java 中，在 ClassPath 下创建 `META-INF/services` 目录
2. 文件创建
   * 创建服务提供接口（`SPI`）
   * 创建实现者，实现上述 SPI 接口
   * 创建配置文件
3. 开始使用 
   * 通过 `Service.load()` 获得服务提供接口（`SPI`）的所有实现类
  
![java-spi-usage-1](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-spi-usage-1.png)


下面给出一个具体的例子，展示 SPI 的使用。项目结构如下图所示。

![java-spi-usage-2](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-spi-usage-2.png)


* 创建 `ICustomSvc`接口，作为服务提供接口（`SPI`）

```java
public interface ICustomSvc {
    String getName();
}
```

* 创建接口的实现者 `CustomSvcOne`、`CustomSvcTwo`。实际应用中，接口实现者为第三方厂商提供。开发者可通过 `jar` 包导入或 `maven` 依赖方式集成到自己的工程。


```java
public class CustomSvcOne {
    @Obverride
    public String getName(){
        return "CustomSvcOne";
    }
}

public class CustomSvcTwo {
    @Obverride
    public String getName(){
        return "CustomSvcTwo";
    }
}
```

* 通过 `Service.load()` 获得服务提供接口（`SPI`）的所有实现类。

```java
public class CustomTest {
    public static void main(String[] args){
        ServiceLoader<ICustomSvc> svcs = Service.load(ICustomSvc.class);
        svcs.forEach(s -> System.out.println(s.getName()));
    }
```

* 程序输出如下。


```s
cbuc.life.spi.service.impl.CustomSvcOne
cbuc.life.spi.service.impl.CustomSvcTwo
```


### SPI 机制的实现原理

从「SPI 的使用示例」中可知，使用 SPI 时，要通过 `Service.load()` 获得服务提供接口（`SPI`）的所有实现类，得到的是一个 `ServiceLoader<S>` 类型的数据结构。

不妨看一下 JDK 中 `ServiceLoader<S>` 方法的具体实现。

```java
//ServiceLoader实现了Iterable接口，可以遍历所有的服务实现者
public final class ServiceLoader<S>
    implements Iterable<S>
{

    //查找配置文件的目录
    private static final String PREFIX = "META-INF/services/";

    //表示要被加载的服务的类或接口
    private final Class<S> service;

    //这个ClassLoader用来定位，加载，实例化服务提供者
    private final ClassLoader loader;

    // 访问控制上下文
    private final AccessControlContext acc;

    // 缓存已经被实例化的服务提供者，按照实例化的顺序存储
    private LinkedHashMap<String,S> providers = new LinkedHashMap<>();

    // 迭代器
    private LazyIterator lookupIterator;


    //重新加载，就相当于重新创建ServiceLoader了，用于新的服务提供者安装到正在运行的Java虚拟机中的情况。
    public void reload() {
        //清空缓存中所有已实例化的服务提供者
        providers.clear();
        //新建一个迭代器，该迭代器会从头查找和实例化服务提供者
        lookupIterator = new LazyIterator(service, loader);
    }

    //私有构造器
    //使用指定的类加载器和服务创建服务加载器
    //如果没有指定类加载器，使用系统类加载器，就是应用类加载器。
    private ServiceLoader(Class<S> svc, ClassLoader cl) {
        service = Objects.requireNonNull(svc, "Service interface cannot be null");
        loader = (cl == null) ? ClassLoader.getSystemClassLoader() : cl;
        acc = (System.getSecurityManager() != null) ? AccessController.getContext() : null;
        reload();
    }

    //解析失败处理的方法
    private static void fail(Class<?> service, String msg, Throwable cause)
        throws ServiceConfigurationError
    {
        throw new ServiceConfigurationError(service.getName() + ": " + msg,
                                            cause);
    }

    private static void fail(Class<?> service, String msg)
        throws ServiceConfigurationError
    {
        throw new ServiceConfigurationError(service.getName() + ": " + msg);
    }

    private static void fail(Class<?> service, URL u, int line, String msg)
        throws ServiceConfigurationError
    {
        fail(service, u + ":" + line + ": " + msg);
    }

    //解析服务提供者配置文件中的一行
    //首先去掉注释校验，然后保存
    //返回下一行行号
    //重复的配置项和已经被实例化的配置项不会被保存
    private int parseLine(Class<?> service, URL u, BufferedReader r, int lc,
                          List<String> names)
        throws IOException, ServiceConfigurationError
    {
        //读取一行
        String ln = r.readLine();
        if (ln == null) {
            return -1;
        }
        //#号代表注释行
        int ci = ln.indexOf('#');
        if (ci >= 0) ln = ln.substring(0, ci);
        ln = ln.trim();
        int n = ln.length();
        if (n != 0) {
            if ((ln.indexOf(' ') >= 0) || (ln.indexOf('\t') >= 0))
                fail(service, u, lc, "Illegal configuration-file syntax");
            int cp = ln.codePointAt(0);
            if (!Character.isJavaIdentifierStart(cp))
                fail(service, u, lc, "Illegal provider-class name: " + ln);
            for (int i = Character.charCount(cp); i < n; i += Character.charCount(cp)) {
                cp = ln.codePointAt(i);
                if (!Character.isJavaIdentifierPart(cp) && (cp != '.'))
                    fail(service, u, lc, "Illegal provider-class name: " + ln);
            }
            if (!providers.containsKey(ln) && !names.contains(ln))
                names.add(ln);
        }
        return lc + 1;
    }

    //解析配置文件，解析指定的url配置文件
    //使用parseLine方法进行解析，未被实例化的服务提供者会被保存到缓存中去
    private Iterator<String> parse(Class<?> service, URL u)
        throws ServiceConfigurationError
    {
        InputStream in = null;
        BufferedReader r = null;
        ArrayList<String> names = new ArrayList<>();
        try {
            in = u.openStream();
            r = new BufferedReader(new InputStreamReader(in, "utf-8"));
            int lc = 1;
            while ((lc = parseLine(service, u, r, lc, names)) >= 0);
        }
        return names.iterator();
    }

    //服务提供者查找的迭代器
    private class LazyIterator
        implements Iterator<S>
    {

        Class<S> service;//服务提供者接口
        ClassLoader loader;//类加载器
        Enumeration<URL> configs = null;//保存实现类的url
        Iterator<String> pending = null;//保存实现类的全名
        String nextName = null;//迭代器中下一个实现类的全名

        private LazyIterator(Class<S> service, ClassLoader loader) {
            this.service = service;
            this.loader = loader;
        }

        private boolean hasNextService() {
            if (nextName != null) {
                return true;
            }
            if (configs == null) {
                try {
                    String fullName = PREFIX + service.getName();
                    if (loader == null)
                        configs = ClassLoader.getSystemResources(fullName);
                    else
                        configs = loader.getResources(fullName);
                }
            }
            while ((pending == null) || !pending.hasNext()) {
                if (!configs.hasMoreElements()) {
                    return false;
                }
                pending = parse(service, configs.nextElement());
            }
            nextName = pending.next();
            return true;
        }

        private S nextService() {
            if (!hasNextService())
                throw new NoSuchElementException();
            String cn = nextName;
            nextName = null;
            Class<?> c = null;
            try {
                c = Class.forName(cn, false, loader);
            }
            if (!service.isAssignableFrom(c)) {
                fail(service, "Provider " + cn  + " not a subtype");
            }
            try {
                S p = service.cast(c.newInstance());
                providers.put(cn, p);
                return p;
            }
        }

        public boolean hasNext() {
            if (acc == null) {
                return hasNextService();
            } else {
                PrivilegedAction<Boolean> action = new PrivilegedAction<Boolean>() {
                    public Boolean run() { return hasNextService(); }
                };
                return AccessController.doPrivileged(action, acc);
            }
        }

        public S next() {
            if (acc == null) {
                return nextService();
            } else {
                PrivilegedAction<S> action = new PrivilegedAction<S>() {
                    public S run() { return nextService(); }
                };
                return AccessController.doPrivileged(action, acc);
            }
        }

        public void remove() {
            throw new UnsupportedOperationException();
        }

    }

    //获取迭代器
    //返回遍历服务提供者的迭代器
    //以懒加载的方式加载可用的服务提供者
    //懒加载的实现是：解析配置文件和实例化服务提供者的工作由迭代器本身完成
    public Iterator<S> iterator() {
        return new Iterator<S>() {
            //按照实例化顺序返回已经缓存的服务提供者实例
            Iterator<Map.Entry<String,S>> knownProviders
                = providers.entrySet().iterator();

            public boolean hasNext() {
                if (knownProviders.hasNext())
                    return true;
                return lookupIterator.hasNext();
            }

            public S next() {
                if (knownProviders.hasNext())
                    return knownProviders.next().getValue();
                return lookupIterator.next();
            }

            public void remove() {
                throw new UnsupportedOperationException();
            }

        };
    }

    //为指定的服务使用指定的类加载器来创建一个ServiceLoader
    public static <S> ServiceLoader<S> load(Class<S> service,
                                            ClassLoader loader)
    {
        return new ServiceLoader<>(service, loader);
    }

    //使用线程上下文的类加载器来创建ServiceLoader
    public static <S> ServiceLoader<S> load(Class<S> service) {
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        return ServiceLoader.load(service, cl);
    }

    //使用扩展类加载器为指定的服务创建ServiceLoader
    //只能找到并加载已经安装到当前Java虚拟机中的服务提供者，应用程序类路径中的服务提供者将被忽略
    public static <S> ServiceLoader<S> loadInstalled(Class<S> service) {
        ClassLoader cl = ClassLoader.getSystemClassLoader();
        ClassLoader prev = null;
        while (cl != null) {
            prev = cl;
            cl = cl.getParent();
        }
        return ServiceLoader.load(service, prev);
    }

    public String toString() {
        return "java.util.ServiceLoader[" + service.getName() + "]";
    }

}
```


* `ServiceLoader` 实现了 `Iterable` 接口，所以它有迭代器的属性。`ServiceLoader` 实现了迭代器的 `hasNext` 和 `next` 方法。`ServiceLoader` 持有了 `private LazyIterator lookupIterator;`，这是一个懒加载类型的迭代器 迭代器（懒加载迭代器）。
* `hasNextService()` 方法中获取 `fullName` 时，使用到了前缀 `PREFIX`，这个值是 `"META-INF/services/"`。所以，在创建配置文件时，其路径是 ClassPath 下的 `META-INF/services/`。
* SPI 机制中，通过反射方法 `Class.forName()` 加载类对象，并用 `newInstance` 方法将类实例化，并把实例化后的类缓存到 `providers` 对象中（其类型为 `LinkedHashMap<String,S>`），最后返回实例对象。
* `ServiceLoader` 不是实例化以后，就去读取配置文件中的具体实现并进行实例化，而是等到使用迭代器去遍历的时候，才会加载对应的配置文件去解析，调用 `hasNext` 方法的时候会去加载配置文件进行解析，调用 `next` 方法的时候进行实例化并缓存。
* 所有的配置文件只会加载一次，服务提供者也只会被实例化一次，重新加载配置文件可使用 `reload` 方法。


### SPI 机制的应用

SPI 机制应用较为广泛，包括
* 数据库驱动 JDBC DriveManager
* 日志库门面 Common-Logging
* 插件体系
* Spring 中使用 SPI


以「 JDBC DriveManager」为例，简要介绍下 SPI 机制的应用。
1. Java 定义服务提供接口（SPI），提供一个标准，如 `java.sql.Driver`。
2. 具体厂商或框架来实现这个 SPI 接口，比如 `me.cxis.sql.MyDriver`。
3. 具体厂商或框架创建配置文件，在 `META-INF/services` 目录下定义一个名字为接口全限定名的文件，如 `java.sql.Driver` 文件。文件内容是具体的实现名字，如 `me.cxis.sql.MyDriver`。
4. 开发者引用具体厂商的 `jar` 包进行业务逻辑开发。

```java
//获取ServiceLoader
ServiceLoader<Driver> loadedDrivers = ServiceLoader.load(Driver.class);
//获取迭代器
Iterator<Driver> driversIterator = loadedDrivers.iterator();

//遍历
while(driversIterator.hasNext()) {
    driversIterator.next();
    //可以做具体的业务逻辑
}
```


### SPI 机制的缺点

1. 不能按需加载
   * 需要遍历所有的实现，并实例化，然后在循环中才能找到我们需要的实现。
   * 如果不想用某些实现类，或者某些类实例化很耗时，就会造成浪费。 
2. 获取某个实现类的方式不够灵活
   * 只能通过 `Iterator` 形式获取
   * 不能根据某个参数来获取对应的实现类
3. 多线程下不安全
   * 多个并发多线程使用 `ServiceLoader` 类的实例，是不安全的


### API 和 SPI
* ref 1-[小议 SPI 和 API | Blog](https://www.cnblogs.com/happyframework/archive/2013/09/17/3325560.html)



在服务/客户（S/C）系统中
* API 中，接口的实现在服务端
* SPI 中，接口的实现在客户端

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-spi-api-verse-1.png)




### Spring SPI

SPI 机制不仅在 JDK 中实现，Spring 及 Dubbo 框架也都有对应的 SPI 机制。

在 Spring Boot 中好多配置和实现都有默认的实现，我们如果想要修改某些配置，我们只需要在配置文件中写上对应的配置，项目应用的便是我们定义的配置内容。这正是通过 SPI 机制实现的。
* 我们将想要注入 IoC 容器的类的全类限定名写到 `META-INF/spring.factories` 文件中
* Spring Boot 程序启动时，使用 `SpringFactoriesLoader` 进行加载，扫描每个 jar 包 `class-path` 目录下的 `META-INF/spring.factories` 配置文件，然后解析 `properties` 文件，找到指定名称的配置




**Java SPI 与 Spring SPI 的区别**
1. JDK 使用的加载工具类是 `ServiceLoader`，而 Spring 使用的是 `SpringFactoriesLoader`。
2. JDK 目录命名方式是 `META-INF/services/提供方接口全类名`，而 Spring 使用的是 `META-INF/spring-factories`。

