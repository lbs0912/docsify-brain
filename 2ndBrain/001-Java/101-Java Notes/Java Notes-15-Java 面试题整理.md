
# Java Notes-15-Java 面试题整理

[TOC]


## 更新
* 2020/07/28，撰写



## 学习资料
* [To Be Top Javaer | gitbook](http://hollischuang.gitee.io/tobetopjavaer/#/)
* [JavaGuide | gitbook](https://snailclimb.gitee.io/javaguide/#/)


## Java中创建对象的几种方式
* [ref 1-java创建对象的五种方式 | 掘金](https://juejin.im/post/5d44530a6fb9a06aed7103bd#heading-10)
* [ref 2-Java创建对象的4种方式 | CSDN](https://blog.csdn.net/u010889616/article/details/78946580)
* [ref 3-Java创建对象的几种方式](https://blog.csdn.net/houwanle/article/details/82721816?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.channel_param&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.channel_param)


Java中创建对象的方式，可以总结为以下几种
1. 使用 `new` 关键字
2. 使用 `Class` 类的 `newInstance` 方法（反射调用）
3. 使用 `Constructor` 类的 `newInstance` 方法（反射调用）
4. 使用 `Clone` 方法
5. 使用序列化


方式      | 是否调用了构造函数
----------|--------------------
使用new关键字 | 是
使用Class类的newInstance方法 | 是
使用Constructor类的newInstance方法 | 是
使用clone方法   | 否  
使用反序列化    | 否



### 使用new关键字

通过 `new` 关键字直接在堆内存上创建对象，调用对象的有参或无参的构造函数创建对象。


```java
Student stu1 = new Student("lbs");
```

### 使用Class类的newInstance方法（反射调用）

可以使用 `Class` 类的 `newInstance` 方法创建对象（反射调用），`newInstance` 方法调用无参的构造函数创建对象。


此方法使用了 Java 的反射特性。

```java
Employee emp2 = (Employee) Class.forName("org.programming.mitra.exercises.Employee").newInstance();
//或者
Employee emp2 = Employee.class.newInstance();
```



### 使用Constructor类的newInstance方法（反射调用）


和 `Class` 类的 `newInstance` 方法很像，`java.lang.reflect.Constructor` 类里也有一个 `newInstance` 方法可以创建对象。我们可以通过这个 `newInstance` 方法调用构造函数床架对象。

此方法使用了 Java 的反射特性。

```java
Constructor<Employee> constructor = Employee.class.getConstructor();
Employee emp3 = constructor.newInstance();
```


上述两种 `newInstance` 方法都使用了反射特性，事实上 `Class` 的 `newInstance` 方法内部调用了 `Constructor` 的 `newInstance` 方法。









### 使用Clone方法



使用 `Clone` 方法创建对象。

调用一个对象的 `clone` 方法时，JVM 就会创建一个新的对象，将前面的对象的内容全部拷贝进去，用 `clone` 方法创建对象并不会调用任何构造函数。

要使用 `clone` 方法，我们必须先实现 `Cloneable` 接口并实现其定义的 `clone` 方法。


```java
try {
    Student stu3 = (Student) stu1.clone();
    System.out.println(stu3);
}
catch (CloneNotSupportedException e) {
    e.printStackTrace();
}
```




### 使用序列化


当我们序列化和反序列化一个对象，JVM 会创建一个单独的对象。在反序列化时，JVM 创建对象并不会调用任何构造函数。

为了反序列化一个对象，我们需要让我们的类实现 `Serializable` 接口。


```java
ObjectInputStream in = new ObjectInputStream(new FileInputStream("data.obj"));

Employee emp5 = (Employee) in.readObject();
```


### 使用Unsafe
* [ref 1-java创建对象的五种方式 | 掘金](https://juejin.im/post/5d44530a6fb9a06aed7103bd#heading-10)