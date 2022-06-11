# Java-16-深拷贝和浅拷贝

[TOC]

## 更新
* 2020/05/12，撰写
* 2022/05/30，排版整理


## 参考资料
* 《Effective Java》，「第13条 谨慎地重写 clone 方法」
* [Java深入理解浅拷贝和深拷贝 | 掘金](https://juejin.im/post/5eb883a86fb9a043780fe445)
* [细说Java的深拷贝和浅拷贝 | Segmentfault](https://segmentfault.com/a/1190000010648514)

## 前言

Java 中存在基础类型和引用类型。Java 的赋值都是传值的
1. 对于基础类型，会拷贝具体的内容。
2. 对于引用类型，存储的这个值只是指向实际对象的地址，拷贝也只会拷贝引用地址。


在此基础上，「对象的拷贝」可分为两种情况

* 浅拷贝
  1. 对基本数据类型进行值传递
  2. 对引用数据类型进行引用地址的拷贝
* 深拷贝
  1. 对基本数据类型进行值传递
  2. 对引用数据类型，创建一个新的对象，并复制其内容





## 拷贝相关API

### Object#clone


Java 中所有的对象都是继承自 `java.lang.Object`。`Object` 对象中提供了一个 `protected` 类型的 `clone` 方法。

```java
protected native Object clone() 
    throws CloneNotSupportedException;
```


`Object#clone()` 方法是 `native` 的，所以不需要我们来实现。需要注意的是，`clone` 方法是 `protected` 的，这意味着 `clone` 方法只能在 `java.lang` 包或者其子类可见。

**如果我们想要在一个程序中调用某个对象的 `clone` 方法则是不可以的。因为 `clone` 方法是定义在 `Object` 中的，该对象并没有对外可见的 `clone` 方法。**

### Cloneable接口

在上文中提到，`Object#clone()` 方法是 `protected` 的，我们不能直接在程序中对一个对象调用 `clone` 方法。

**JDK 推荐「实现 `Cloneable` 接口并重写 `clone` 方法（可使用 `public` 修饰符）来实现属性的拷贝」。** 




```java
package java.lang;

/**
 * 此处给出 Cloneable 的部分注释
 * A class implements the Cloneable interface to
 * indicate to the java.lang.Object#clone() method that it
 * is legal for that method to make a
 * field-for-field copy of instances of that class.
 * 
 * Invoking Object's clone method on an instance that does not implement the
 * Cloneable interface results in the exception
 * CloneNotSupportedException being thrown.
 * 
 * By convention, classes that implement this interface should override
 * Object.clone (which is protected) with a public method.
 */
public interface Cloneable {

}
```

阅读 `Cloneable` 源码，有如下结论

1. 对于实现 `Cloneable` 接口的对象，是可以调用 `Object#clone()` 方法来进行属性的拷贝。
2. 若一个对象没有实现 `Cloneable` 接口，直接调用 `Object#clone()` 方法，会抛出 `CloneNotSupportedException` 异常。
3. `Cloneable` 是一个空接口，并不包含 `clone` 方法。但是按照惯例（`by convention`），实现 `Cloneable` 接口时，应该以 `public` 修饰符重写 `Object#clone()` 方法（该方法在 `Object` 中是被 `protected` 修饰的）。



> 参照《Effective Java》中「第13条 谨慎地重写 clone 方法」
> 
> `Cloneable` 接口的目的是作为一个 `mixin` 接口，约定如果一个类实现了 `Cloneable` 接口，那么 `Object` 的 `clone` 方法将返回该对象的逐个属性（`field-by-field`）拷贝（浅拷贝）；否则会抛出 `CloneNotSupportedException` 异常。


上面第1、2点，可用下面的伪代码描述。

```java
protected Object clone throws CloneNotSupportedException {
    if(!(this instanceof Cloneable)){
        throw new CloneNotSupportedException("Class" + getClass().getName() + "doesn't implement Cloneable"); 
    }

    return internalClone();
}
/**
 * Native Helper method for cloning.
 */
private native Object internalClone();
```






## 浅拷贝


参考 `Cloneable` 接口的源码注释部分，如果一个类实现了 `Cloneable` 接口，那么 `Object` 的 `clone` 方法将返回该对象的逐个属性（`field-by-field`）拷贝，**这里的拷贝是浅拷贝。**
1. 对基本数据类型进行值传递
2. 对引用数据类型进行引用地址的拷贝



下面结合一个示例加以说明。


* 定义两个对象，`Address` 和 `CustomerUser`


```java
@Data
class Address implements Cloneable{
    private String name;

    @Override
    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}

@Data
class CustomerUser implements Cloneable{
    private String firstName;
    private String lastName;
    private Address address;
    private String[] cars;

    @Override
    public Object clone() throws CloneNotSupportedException{
        return super.clone();
    }
}
```


* 在测试方法 `testShallowCopy` 中，使用 `customerUser.clone()` 进行对象拷贝。注意，此处为浅拷贝。

```java

public class CloneTest {
    public static void main(String[] args) throws CloneNotSupportedException {
        testShallowCopy();
    }

    public static void testShallowCopy() throws CloneNotSupportedException {
        Address address= new Address();
        address.setName("北京天安门");
        CustomerUser customerUser = new CustomerUser();
        customerUser.setAddress(address);
        customerUser.setLastName("李");
        customerUser.setFirstName("雷");
        String[] cars = new String[]{"别克","路虎"};
        customerUser.setCars(cars);

        //浅拷贝
        CustomerUser customerUserCopy =(CustomerUser) customerUser.clone();

        customerUserCopy.setFirstName("梅梅");
        customerUserCopy.setLastName("韩");
        customerUserCopy.getAddress().setName("北京颐和园");
        customerUserCopy.getCars()[0]="奥迪";

        System.out.println("customerUser: " + JSONUtil.toJsonStr(customerUser));
        System.out.println("customerUserCopy: " + JSONUtil.toJsonStr(customerUserCopy));
    }
}
```


* 程序运行结果如下。


```s
customerUser: {"lastName":"李","address":{"name":"北京颐和园"},"firstName":"雷","cars":["奥迪","路虎"]}
customerUserCopy: {"lastName":"韩","address":{"name":"北京颐和园"},"firstName":"梅梅","cars":["奥迪","路虎"]}
```

* 可以看到，修改拷贝之后的 `customerUserCopy` 的引用类型的属性值（`Address` 和 `String[]` 类型的属性值），会影响到原对象 `customerUser`。




## 深拷贝

实现深拷贝有两种方式，「序列化对象方式」和「二次调用 `clone` 方式」

1. 序列化（`serialization`）方式
   * 先对对象进行序列化，再进行反序列化，得到一个新的深拷贝的对象
2. 二次调用 `clone` 方式
   * 先调用对象的 `clone()` 方法
   * 对对象的引用类型的属性值，继续调用 `clone()` 方法进行拷贝





下面，在「浅拷贝」章节示例的基础上，使用「二次调用 `clone` 方式」实现深拷贝。


* 修改 `CustomerUser` 的 `clone()` 方法，对 `CustomerUser` 对象的引用类型的属性值，即 `Address` 属性值和数组（`String[]`）属性值 `cars`，二次调用 `clone` 方法。

```java
@Data
class CustomerUser implements Cloneable{
    private String firstName;
    private String lastName;
    private Address address;
    private String[] cars;

    @Override
    public Object clone() throws CloneNotSupportedException{
        CustomerUser customerUserDeepCopy = (CustomerUser) super.clone();
        //二次调用clone方法
        customerUserDeepCopy.address = (Address) address.clone();
        customerUserDeepCopy.cars = cars.clone();
        return customerUserDeepCopy;
    }
}
```


* 再次运行程序，输出结果如下。


```s
customerUser: {"lastName":"李","address":{"name":"北京天安门"},"firstName":"雷","cars":["别克","路虎"]}
customerUserCopy: {"lastName":"韩","address":{"name":"北京颐和园"},"firstName":"梅梅","cars":["奥迪","路虎"]}
```

* 可以看到 `address` 和 `cars` 是不同的，表示我们的深拷贝是成功的。





## 创建对象
* ref 1-[Java中的clone和new的效率对比](https://www.shouxicto.com/article/2776.html)


在介绍 `clone` 方法的基础上，引出对「创建对象的4种方法」，「clone和new的效率对比」等问题的介绍。


### 创建对象的4种方法

创建对象的 4 种方法如下
1. 使用 `new` 关键字
2. 反射机制
3. 实现 `Cloneable` 接口，使用 `clone` 方法创建对象
4. 序列化和反序列化



以上 4 种方式，都可以创建一个 Java 对象，实现机制上有如下区别
* 方式 1 和方式 2 中，都明确地显式地调用了对象的构造函数。
* **方式 3 中，是对已经的对象，在内存上拷贝了一个影印，并不会调用对象的构造函数。**
* 方式 4 中，对对象进行序列化，转化为了一个文件流，再通过反序列化生成一个对象，也不会调用构造函数。


### clone和new的效率对比

* 使用 `clone` 创建对象，该操作并不会调用类的构造函数，是在内存中进行的数据块的拷贝，复制已有的对象。
* 使用 `new` 方式创建对象，调用了类的构造函数。


使用 `clone` 创建对象，直接在内存中进行数据块的拷贝。这是否意味着 `clone` 方法的效率更高呢？

答案并不是，JVM 的开发者意识到通过 `new` 方式来生成对象的方式，使用的更加普遍，所以对于利用 `new` 操作生成对象进行了优化。


下面编写一个测试用例，用 `clone` 和 `new` 两种方式来创建 `10000 * 1000` 个对象，测试对应的耗时。


```java
public class Bean implements Cloneable {
    private String name;

    public Bean(String name) {
        this.name = name;
    }

    @Override
    protected Bean clone() throws CloneNotSupportedException {
        return (Bean) super.clone();
    }
}

public class TestClass {
    private static final int COUNT = 10000 * 1000;

    public static void main(String[] args) throws CloneNotSupportedException {
        long s1 = System.currentTimeMillis();
        for (int i = 0; i < COUNT; i++) {
            Bean bean = new Bean("ylWang");
        }

        long s2 = System.currentTimeMillis();
        Bean bean = new Bean("ylWang");
        for (int i = 0; i < COUNT; i++) {
            Bean b = bean.clone();
        }

        long s3 = System.currentTimeMillis();

        System.out.println("new  = " + (s2 - s1));
        System.out.println("clone = " + (s3 - s2));
    }
}
```

程序输出如下。

```s
new  = 7
clone = 83
```

可以看到，创建 `10000 * 1000` 个对象，使用 `new` 方法的耗时，只有 `clone` 方式的 1/10，即 `new` 方式创建对象的效率更高。


但是，若构造函数中有一些耗时操作，则 `new` 方式创建对象的效率会受到构造函数性能的影响。如下代码，在构造函数中添加字符串截取的耗时操作。

```java
public class Bean implements Cloneable {
    private String name;
    private String firstSign;//获取名字首字母

    public Bean(String name) {
        this.name = name;
        if (name.length() != 0) {
            firstSign = name.substring(0, 1);
            firstSign += "abc";
        }
    }

    @Override
    protected Bean clone() throws CloneNotSupportedException {
        return (Bean) super.clone();
    }
}
```


此时，再执行测试用例，创建 `10000 * 1000` 个对象，程序输出如下，使用 `new` 方法的耗时，就远大于 `clone` 方式了。

```s
new  = 297
clone = 60
```



最后，**对「`clone` 和 `new` 的效率对比」给出结论**
* JVM 对使用 `new` 方法创建对象的方式进行了优化，默认情况下，`new` 的效率更高。
* `new` 方式创建对象时，会调用类的构造函数。若构造函数中有耗时操作，则会影响 `new` 方法创建对象的效率。
* `clone` 方式创建对象，并不会调用类的构造函数。



基于上述结论，在上文「深拷贝」章节中，可对深拷贝功能的实现进行优化，不要调用 `clone` 方法来创建对象，改为直接调用构造函数来实现。



```java
@Data
class Address implements Cloneable{
    private String name;

    Address(Address address){
        this.name=address.name;
    }
}

@Data
class CustomerUser implements Cloneable{
    
    private String firstName;
    private String lastName;
    private Address address;
    private String[] cars;


    CustUserDeep(CustUserDeep custUserDeep){
        this.firstName = custUserDeep.firstName;
        this.lastName = custUserDeep.lastName;
        this.cars = custUserDeep.getCars().clone();
        this.address = new Address(custUserDeep.getAddress());
    }
}
```