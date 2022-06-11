
# Java-17-this关键字

[TOC]

## 更新
* 2020/05/24，撰写


## 参考资料

* [我去，你竟然还不会用 this 关键字 | 掘金](https://juejin.im/post/5ec9e8cce51d45785a7ca8a9)
* [Java this 关键字详解（3种用法）](http://c.biancheng.net/view/953.html)


## 消除字段歧义

在构造函数中，经常使用 `this` 关键字消除字段歧义，如下代码所示。

```java
public class Writer {
    private int age;
    private String name;
    
    public Writer(int age, String name) {
        this.age = age;
        this.name = name;
    }
}
```

`Writer` 类有两个成员变量，分别是 `age` 和 `name`，在使用有参构造函数的时候，如果参数名和成员变量的名字相同，就需要使用 `this` 关键字消除歧义：`this.age` 是指成员变量，`age` 是指构造方法的参数。


## 引用类的其他构造方法

当一个类的构造方法有多个，并且它们之间有交集的话，就可以使用 `this` 关键字来调用不同的构造方法，从而减少代码量。

比如说，在无参构造方法中调用有参构造方法

```java
public class Writer {
    private int age;
    private String name;
    
    public Writer(int age, String name) {
        this.age = age;
        this.name = name;
    }
    public Writer() {
        this(18, "lbs0912");
    }
}
```

也可以在有参构造方法中调用无参构造方法

```java
public class Writer {
    private int age;
    private String name;
    
    public Writer(int age, String name) {
        this();
        this.age = age;
        this.name = name;
    }
    public Writer() {
        
    }
}
```

**需要注意的是，`this()` 必须是构造方法中的第一条语句，否则就会报错。**


```java
// ...
    public Writer(int age, String name) {
        this.age = age;
        this();    //error
        this.name = name;
    }
// ...
```

编译上述代码，会看到如下报错信息

```s
Error:(66, 13) java: 对this的调用必须是构造器中的第一个语句
```


## 调用类的另一个方法或实例变量


`this` 关键字最大的作用就是让类中一个方法，访问该类里的另一个方法或实例变量。如下示例，在 `Dog` 类的 `run()` 方法中，调用该类的 `jump()` 方法。


```java
/**
 * 第一种定义Dog类方法
 **/
public class Dog {
    // 定义一个jump()方法
    public void jump() {
        System.out.println("正在执行jump方法");
    }

    // 定义一个run()方法，run()方法需要借助jump()方法
    public void run() {
        Dog d = new Dog();
        d.jump();
        System.out.println("正在执行 run 方法");
    }
    
    public static void main(String[] args) {
        // 创建Dog对象
        Dog dog = new Dog();
        // 调用Dog对象的run()方法
        dog.run();
    }
}
```


因为 `jump()` 方法不是静态 `static` 方法，因此在上述代码中，我们又创建了一个新的对象，来调用 `jump()`。

下面我们来思考这个问题，在调用 `run()` 方法时，是否一定要重新创建一个 `Dog` 对象呢？


```java
public void run() {
    Dog d = new Dog();  //显示创建了一个新的 Dog 对象
    d.jump();
    System.out.println("正在执行 run 方法");
}
```

其实，此处没有必要显示去创建一个新的 `Dog` 对象。因为当程序调用 `run()` 方法时，一定会提供一个 `Dog` 对象，这样就可以直接使用这个已经存在的 `Dog` 对象，而无须重新创建新的 `Dog` 对象了。因此需要在 `run()` 方法中获得调用该方法的对象，通过 `this` 关键字就可以满足这个要求。

**`this` 可以代表任何对象，当 `this` 出现在某个方法体中时，它所代表的对象是不确定的，但它的类型是确定的，它所代表的只能是当前类的实例。只有当这个方法被调用时，它所代表的对象才被确定下来。谁在调用这个方法，`this` 就代表谁。**


因此，上述代码可以优化为


```java
/**
 * 第二种定义Dog类方法
 **/
 
// 定义一个run()方法，run()方法需要借助jump()方法
public void run() {
    // 使用this引用调用run()方法的对象
    this.jump();
    System.out.println("正在执行run方法");
}
```


在现实世界里，对象的一个方法依赖于另一个方法的情形很常见，**这种依赖都是同一个对象两个方法之间的依赖。因此，Java 允许对象的一个成员直接调用另一个成员，可以省略 `this` 前缀。** 也就是说，将上面的 `run()` 方法改为如下形式也完全正确。

```java
public void run() {
    jump();
    System.out.println("正在执行run方法");
}
```

**省略 `this` 前缀只是一种假象，虽然程序员省略了调用 `jump()` 方法之前的 `this`，但实际上这个 `this` 依然是存在的。**




## 作为参数传递

在下例中，有一个无参的构造方法，里面调用了 `print()` 方法，参数只有一个 `this` 关键字。

```java
class ThisTest {
    public ThisTest() {
        print(this);
    }
    private void print(ThisTest thisTest){
        System.out.println("print " + thisTest);
    }
    public static void main(String[] args){
        ThisTest test = new ThisTest();
        System.out.println("main " + test);
    }
}
```


来打印看一下结果

```s
print com.cmower.baeldung.this1.ThisTest@573fd745
main com.cmower.baeldung.this1.ThisTest@573fd745
```

从结果中可以看得出来，`this` 就是我们在 `main()` 方法中使用 `new` 关键字创建的 `ThisTest` 对象。


## 链式调用

学过 JavaScript 或者 jQuery 的读者可能对链式调用比较熟悉，类似于 `a.b().c().d()`，仿佛能无穷无尽调用下去。

在 Java 中，对应的专有名词叫 `Builder` 模式，来看一个示例。


```java
public class Writer {
    private int age;
    private String name;
    private String bookName;
    public Writer(WriterBuilder builder) {
        this.age = builder.age;
        this.name = builder.name;
        this.bookName = builder.bookName;
    }

    public static class  WriterBuilder {
        private int age;
        private String name;
        private String bookName;

        public WriterBuilder(int age, String name) {
            this.age = age;
            this.name = name;
        }
        public WriterBuilder writeBook(String bookName) {
            this.bookName = bookName;
            return this;
        }
        public Writer build() {
            return new Writer(this);
        }
    }
}
```


`Writer` 类有 3 个成员变量，分别是 `age`、`name` 和 `bookName`，还有它们仨对应的一个构造方法，参数是一个内部静态类 `WriterBuilder`。

内部类 `WriterBuilder` 也有三个成员变量，和 `Writer` 类一致。不同的是，`WriterBuilder` 类的构造方法里面只有 `age` 和 `name` 赋值了，另外一个成员变量 `bookName` 通过单独的方法 `writeBook()` 来赋值。注意，该方法的返回类型是 `WriterBuilder`，最后使用 `return` 返回了 `this` 关键字。

最后的 `build()` 方法用来创建一个 `Writer` 对象，参数为 `this` 关键字，也就是当前的 `WriterBuilder` 对象。

这时候，创建 `Writer` 对象就可以通过链式调用的方式。

```java
Writer writer = new Writer.WriterBuilder(18,"沉默王二")
                .writeBook("《Web全栈开发进阶之路》")
                .build();
```


## 在内部类中访问外部类对象

说实话，自从 Java 8 的函数式编程出现后，就很少用到 `this` 在内部类中访问外部类对象了。来看一个示例。

```java
public class ThisInnerTest {
    private String name;
    class InnerClass {
        public InnerClass() {
            ThisInnerTest thisInnerTest = ThisInnerTest.this;
            String outerName = thisInnerTest.name;
        }
    }
}
```

在内部类 `InnerClass` 的构造方法中，通过 `外部类.this` 可以获取到外部类对象，然后就可以使用外部类的成员变量了，比如说 `name`。

## 关于 super

本质上，`this` 关键字和 `super` 关键字有蛮多相似之处的。此处，在文末位置简单介绍下 `super` 关键字。


简而言之，`super` 关键字就是用来访问父类的。

* 先看父类代码

```java
public class SuperBase {
    String message = "父类";
    
    public SuperBase(String message) {
        this.message = message;
    }
    public SuperBase() {
    
    }
    public void printMessage() {
        System.out.println(message);
    }
}
```

* 再看子类代码


```java
public class SuperSub extends SuperBase {
    String message = "子类";
    public SuperSub(String message) {
        super(message);
    }
    public SuperSub() {
        super.printMessage();
        printMessage();
    }
    public void getParentMessage() {
        System.out.println(super.message);
    }
    public void printMessage() {
        System.out.println(message);
    }
}
```


下面介绍下 `super` 关键字的作用

1. `super` 关键字可用于访问父类的构造方法

子类可以通过 `super(message)` 来调用父类的构造方法。现在来新建一个 `SuperSub` 对象，看看输出结果是什么

```java
SuperSub superSub = new SuperSub("子类的message");
```

`new` 关键字在调用构造方法创建子类对象的时候，会通过 `super` 关键字初始化父类的 `message`，所以此此时父类的 `message` 会输出 `"子类的message"`。

2. `super` 关键字可以访问父类的变量

在 `getParentMessage()` 方法中，可以通过 `super.message` 访问父类的同名成员变量 `message`。

3. 当方法发生重写时，`super` 关键字可以访问父类的同名方法

上述例子，子类的无参的构造方法 `SuperSub()` 中使用 `super.printMessage()` 调用了父类的同名方法。

