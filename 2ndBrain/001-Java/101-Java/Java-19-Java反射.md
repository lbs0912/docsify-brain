
# Java-19-Java反射

[TOC]


## 更新
* 2020/08/29，撰写
* 2021/01/09，内容整理


## 参考资料
* [Java基础与提高干货系列——Java反射机制](http://tengj.top/2016/04/28/javareflect/)
* [学会反射后，我被录取了 | 掘金](https://juejin.im/post/6864324335654404104)



## 前言


Java 反射机制是指在运行状态中，对于任意一个类，都能够知道这个类的所有属性和方法；对于任意一个对象，都能够调用它的任意一个方法和属性。这种能动态获取信息以及动态调用对象方法的功能，称为 Java 语言的反射机制。

反射机制可以用来
* 在运行时分析类的能力，获取类的属性和方法
* 在运行时查看对象，例如，编写一个 `toString` 方法供所有类使用
* 利用Method对象调用方法


Java反射的主要组成部分有 4 个
1. `Class`
2. `Field`
3. `Constructor`
4. `Method`

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-reflective-1.png)


## Class类和类类型

想要了解反射，首先理解一下 `Class` 类，它是反射实现的基础。



在 Java 中，每一个类都会有专属于自己的 `Class` 对象，当我们编写完 `.java` 文件后，使用 `javac` 编译后，就会产生一个字节码文件 `.class`，在字节码文件中包含类的所有信息，如属性、构造方法、方法等。


当字节码文件被装载进虚拟机执行时，会在内存中生成 `Class` 对象，它包含了该类内部的所有信息，在程序运行时可以获取这些信息。

类是 `java.lang.Class` 类的实例对象，而 `Class` 是所有类的类（There is a class named Class）。对于普通的对象，我们一般都会这样创建和表示

```java
Code code1 = new Code();
```

上面说了，所有的类都是 `Class` 的对象，那么如何表示呢，可不可以通过如下方式呢

```java
Class c = new Class();
```

但是我们查看 `Class` 的源码时，是这样写的

```java
    /*
     * Private constructor. Only the Java Virtual Machine creates Class objects.
     * This constructor is not used and prevents the default constructor being
     * generated.
     */
    private Class(ClassLoader loader) {
        // Initialize final field for classLoader.  The initialization value of non-null
        // prevents future JIT optimizations from assuming this final field is null.
        classLoader = loader;
    }
```

可以看到，**构造器是私有的，只有 JVM 可以创建 `Class` 的对象，因此不可以像普通类一样 `new` 一个 `Class` 对象。虽然我们不能 `new` 一个 `Class` 对象，但是却可以通过已有的类得到一个 `Class` 对象。** 获取 `Class` 对象的方法有 3 种

1. `类名.class`：这种获取方式只有在编译前已经声明了该类的类型才能获取到 `Class` 对象

```java
Class clazz = SmallPineapple.class;
```

2. `实例.getClass()`：通过实例化对象获取该实例的 `Class` 对象

```java
SmallPineapple sp = new SmallPineapple();
Class clazz = sp.getClass();
```


3. `Class.forName(className)`：通过**类的全限定名**获取该类的 `Class` 对象

```java
Class clazz = Class.forName("com.bean.smallpineapple");
```

每个类的 `Class` 对象只有一个，使用上面 3 种方法获取的 `Class` 对象是相同的，而且有个学名，叫做 `Class` 的 **类类型（`class type`）**。

> 顾名思义，类类型就是类的类型，也就是描述一个类是什么，都有哪些东西，所以我们可以通过类类型知道一个类的属性和方法，并且可以调用一个类的属性和方法，这就是反射的基础






至此，我们知道了怎么获取 `Class`，那么我们可以通过这个 `Class` 干什么呢？
* 获取成员方法 `Method`
* 获取成员变量 `Field`
* 获取构造函数 `Constructor`


下面进行具体介绍。



## 反射的基本使用

下面创建一个具体实体类，用来展示反射的基本使用。

```java
public class SmallPineapple {
    public String name;
    public int age;
    private double weight; // 体重只有自己知道
    
    public SmallPineapple() {}
    
    public SmallPineapple(String name, int age) {
        this.name = name;
        this.age = age;
    }
    public void setName(String name) {
        this.name = name;
    }
    
    public void getInfo() {
        System.out.print("["+ name + " 的年龄是：" + age + "]");
    }
}
```



### 获取构造函数

类的构造函数也是一个对象，它是 `java.lang.reflect.Constructor` 的一个对象，所以我们可以通过 `java.lang.reflect.Constructor` 里面封装的方法来获取这些信息。

单独获取某个构造函数，通过 `Class` 类的以下方法实现

```java
//  获得该类所有的构造器，不包括其父类的构造器
public Constructor<T> getDeclaredConstructor(Class<?>... parameterTypes) 
// 获得该类所以public构造器，包括父类
public Constructor<T> getConstructor(Class<?>... parameterTypes) 
```

下面展示一个示例。



```java
    try {
        Class c1 = Class.forName("com.lbs0912.java.demo.entity.SmallPineapple");
        Constructor constructor = c1.getConstructor(String.class,int.class);
        // 设置是否允许访问，因为该构造器是private的，所以要手动设置允许访问
        // 如果构造器是public的就不需要这行了
        constructor.setAccessible(true);
        Object o1 = constructor.newInstance("lbs0912",28);
    } catch (Exception e) {
        e.printStackTrace();
    }
```


### 构造类的实例化对象

通过反射构造一个类的实例方式有2种
1. 调用 `Class` 对象的 `newInstance()` 方法：此种方法中只能调用类的默认无参构造函数创建对象实例。

```
Class clazz = Class.forName("com.bean.SmallPineapple");
SmallPineapple smallPineapple = (SmallPineapple) clazz.newInstance();
smallPineapple.getInfo();
// [null 的年龄是：0]
```


2. 先调用 `Class` 对象的 `getConstructor()` 方法获得构造器 `Constructor` 对象，再调用构造器对象 `Constructor` 的 `newInstance()` 方法。

```java
//默认无参构造函数
//调用 clazz.getConstructor()时若不传参数类型，则还是使用默认的无参构造函数创建对象实例
Class clazz = Class.forName("com.bean.SmallPineapple");
Constructor constructor = clazz.getConstructor();
SmallPineapple smallPineapple2 = (SmallPineapple) constructor.newInstance("小菠萝", 21);
smallPineapple2.getInfo();
// [null 的年龄是：0]
```


```java
//指定构造函数
//clazz.getConstructor(Object... paramTypes) 可以指定构造函数的参数类型
Class clazz = Class.forName("com.bean.SmallPineapple");
Constructor constructor = clazz.getConstructor(String.class, int.class);
SmallPineapple smallPineapple2 = (SmallPineapple) constructor.newInstance("小菠萝", 21);
smallPineapple2.getInfo();
// [小菠萝 的年龄是：21]
```


### 获取成员方法-Method


有如下 4 种方式获取成员方法。

```java
// 1. 得到该类的单个方法，不包括父类的
public Method getDeclaredMethod(String name, Class<?>... parameterTypes) 

// 2. 得到该类的public方法，包括父类的
public Method getMethod(String name, Class<?>... parameterTypes) 

// 3. 获取类的所有方法（不包括父类的），结果以数组形式返回
public Method[] getDeclaredMethods();

// 4. 获取类的所有方法，结果以数组形式返回
public Method[] getMethods();
```


获取成员方法的一个完整示例如下。


```java
class Solution {
    public static void main(String[] args) throws ClassNotFoundException, IllegalAccessException, InstantiationException, NoSuchMethodException, InvocationTargetException {
        try {
            // 生成Class
            Class c1 = Class.forName("com.lbs0912.java.demo.entity.SmallPineapple");
            // newInstance可以初始化一个实例
            Object o1 = c1.newInstance();
            // 获取方法
            Method method = c1.getMethod("getInfo", String.class, int.class);
            // 通过invoke调用该方法，参数第一个为实例对象，后面为具体参数值
            method.invoke(o1, "lbs0912", 28);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

执行结果如下

```s
[lbs0912 的年龄是：28]
```

有时候我们想获取类中所有成员方法的信息，可以执行如下代码。


```java
Class c1 = Class.forName("com.lbs0912.java.demo.entity.SmallPineapple");

Method[] methods = c1.getDeclaredMethods();
for(Method method1:methods){
    String  methodName= method1.getName();
    System.out.println(methodName);
}
```

### 通过反射调用方法-invoke

通过反射获取到某个 `Method` 类对象后，可以通过执行 `invoke()` 方法调用类的方法。

```java
invoke(Oject obj, Object... args)
```

该方法中，参数 1 指定调用该方法的对象，参数 2 是方法的参数列表值。**如果调用的方法是静态方法，参数 1 只需要传入 `null`，因为静态方法不与某个对象有关，只与某个类有关。**


下面代码中，通过反射实例化一个对象，然后获取 `Method` 方法对象，调用 `invoke()` 指定 `SmallPineapple` 的 `getInfo()` 方法。

```java
Class clazz = Class.forName("com.bean.SmallPineapple");
Constructor constructor = clazz.getConstructor(String.class, int.class);
constructor.setAccessible(true);
SmallPineapple sp = (SmallPineapple) constructor.newInstance("小菠萝", 21);
Method method = clazz.getMethod("getInfo");
if (method != null) {
    method.invoke(sp, null);
}
// [小菠萝的年龄是：21]
```

### 获取成员变量-Field


类的成员变量也是一个对象，它是 `java.lang.reflect.Field` 的一个对象，所以我们可以通过 `java.lang.reflect.Field` 里面封装的方法来获取这些信息。

单独获取某个成员变量，通过 `Class` 类的以下方法实现

```java
// 获得该类自身声明的所有变量，不包括其父类的变量
public Field getDeclaredField(String name) 

// 获得该类自所有的public成员变量，包括其父类变量
public Field getField(String name) 
```

下面如何展示获取对象的 `weight` 私有成员变量。


```java
//import java.lang.reflect.Field;
try {
    Class c1 = Class.forName("com.lbs0912.java.demo.entity.SmallPineapple");
    Field field = c1.getDeclaredField("weight");
    Object o = c1.newInstance();
    // 设置是否允许访问，因为该变量是private的，所以要手动设置允许访问
    // 如果weight是public的就不需要这行了
    field.setAccessible(true);
    Object weight = field.get(o);
    System.out.println(weight);
} catch (Exception e) {
    e.printStackTrace();
}
```

执行结果

```s
0.0
```


同样，也可以获取所有成员变量的信息，代码如下。


```java
Field[] fields = c1.getDeclaredFields();
for(Field field1:fields){
    System.out.println(field.getName() + "---" + field1.getType());
}
```


执行结果


```s
name---class java.lang.String
age---int
weight---double
```



## 反射的应用场景

反射常见的应用场景包括

* Spring 实例化对象：当程序启动时，Spring 会读取配置文件 `applicationContext.xml` 并解析出里面所有的标签实例化到 IOC 容器中。
* 反射 + 工厂模式：通过反射消除工厂中的多个分支，如果需要生产新的类，无需关注工厂类，工厂类可以应对各种新增的类，反射可以使得程序更加健壮。
* JDBC 连接数据库：使用 JDBC 连接数据库时，指定连接数据库的驱动类时用到反射加载驱动类

### Spring的IOC容器

在 Spring 中，经常会编写一个上下文配置文件 `applicationContext.xml`，里面就是关于 `bean` 的配置，程序启动时会读取该 `.xml`文件，解析出所有的 `<bean>` 标签，并实例化对象放入 IOC 容器中。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="smallpineapple" class="com.bean.SmallPineapple">
        <constructor-arg type="java.lang.String" value="小菠萝"/>
        <constructor-arg type="int" value="21"/>
    </bean>
</beans>
```

在定义好上面的文件后，通过 `ClassPathXmlApplicationContext` 加载该配置文件，程序启动时，Spring 会将该配置文件中的所有 `bean` 都实例化，放入 IOC 容器中。IOC 容器本质上就是一个工厂，通过该工厂传入 `<bean>` 标签的 `id` 属性获取到对应的实例。

```java
public class Main {
    public static void main(String[] args) {
        ApplicationContext ac =
                new ClassPathXmlApplicationContext("applicationContext.xml");
        SmallPineapple smallPineapple = (SmallPineapple) ac.getBean("smallpineapple");
        smallPineapple.getInfo(); // [小菠萝的年龄是：21]
    }
}
```

Spring 实例化对象的过程，经过简化之后，可以理解为通过反射技术来实例化对象，其步骤如下
1. 获取 `Class` 对象的构造器
2. 通过构造器调用 `newInstance()` 实例化对象

当然 Spring 在实例化对象时，做了非常多额外的操作，才能够让现在的开发足够的便捷且稳定。


## 反射的优缺点

### 优点
* 增加程序的灵活性：面对需求变更时，可以灵活地实例化不同对象。

### 缺点
* 破坏类的封装性：可通过 `setAccessible(true)` 强制访问 `private` 修饰的信息。
* 性能损耗：反射相比直接实例化对象、调用方法、访问变量，中间需要非常多的检查步骤和解析步骤，JVM 无法对它们优化。



#### 破坏类的封装性

反射中，调用 `setAccessable(true)` 可以无视访问修饰符的限制，在外界强制访问 `private` 修饰的信息。


下面结合具体代码进行说明。


```java
public class SmallPineapple {
    public String name;
    public int age;
    private double weight; // 体重只有自己知道
    
    public SmallPineapple(String name, int age, double weight) {
        this.name = name;
        this.age = age;
        this.weight = weight;
    }
}
```

`SmallPineapple` 对象的 `weight` 属性是私有的。在反射中，调用 `setAccessable(true)`，则在外界也可以访问到该属性。


```java
SmallPineapple sp = new SmallPineapple("小菠萝", 21, "54.5");
Clazz clazz = Class.forName(sp.getClass());
Field weight = clazz.getDeclaredField("weight");
weight.setAccessable(true);
System.out.println("窥觑到小菠萝的体重是：" + weight.get(sp));
// 窥觑到小菠萝的体重是：54.5 kg

```







#### 性能损耗（反射效率低的原因）

* [为什么总说Java的反射效率低 | 掘金](https://juejin.cn/post/7075691875402792990)


反射效率低的原因，主要如下

1. `Method#invoke` 方法会对参数做封装和解封操作
2. 需要检查方法可见性
3. 需要校验参数
4. 反射方法难以内联
5. JIT 无法优化
6. 请求 JVM 去查找其方法区中的方法定义，需要使用 JNI、开销相对比较大