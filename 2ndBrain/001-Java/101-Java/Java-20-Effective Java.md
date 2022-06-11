
# Java-20-Effective Java


[TOC]

## 更新
* 2022/05/29，撰写


## 参考资料
* 《Effective Java》3rd
* 阿里《Java开发手册》华山版


## 前言
本文以《Effective Java》和阿里《Java开发手册》为基础（但不局限于二者），记录 Java 开发过程中的一些代码规范、常见误区、高效编码技巧。


## hashCode和equals的
* ref 1-阿里《Java开发手册》，「集合处理」章节
* ref 2-《Effective Java》，第3章节，「第11条 覆盖equals时总要覆盖hashcode」
* ref 3-[为什么重写equals必须重写hashCode | Segmentfault](https://segmentfault.com/a/1190000024478811)

> [强制] 关于 hashCode 和 equals 的处理，遵循如下规则
> 1）**只要覆写 equals，就必须覆写 hashCode。**
> 2）因为 Set 存储的是不重复的对象，依据 hashCode 和 equals 进行判断，所以 Set 存储的对象必须覆写这两个方法。
> 3）如果自定义对象作为 Map 的键，那么必须覆写 hashCode 和 equals。
> 说明：String 已经覆写 hashCode 和 equals 方法，所以我们可以愉快地使用 String 对象作为 key 来使用。



### equals保证可靠性，hashCode保证性能


> **`equals` 保证可靠性，`hashCode` 保证性能。**

`equals` 和 `hashCode` 都可用来判断两个对象是否相等，但是二者有区别
* `equals` 可以保证比较对象是否是绝对相等，即「`equals` 保证可靠性」
* `hashCode` 用来在最快的时间内判断两个对象是否相等，可能有「误判」，即「`hashCode` 保证性能」
* 两个对象 `equals` 为 true 时，要求 `hashCode` 也必须相等
* 两个对象 `hashCode` 为 true 时，`equals` 可以不等（如发生哈希碰撞时）


`hashCode` 的「误判」指的是
1. 同一个对象的 `hashCode` 一定相等。
2. 不同对象的 `hashCode` 也可能相等，这是因为 `hashCode` 是根据地址 `hash` 出来的一个 `int 32` 位的整型数字，相等是在所难免。


此处以向 HashMap 中插入数据（调用 `put` 方法，`put` 方法会调用内部的 `putVal` 方法）为例，对「`equals` 保证可靠性，`hashCode` 保证性能」这句话加以说明，`putVal` 方法中，判断两个 Key 是否相同的代码如下所示。


```java
// putVal 方法
if (p.hash == hash && 
    ((k = p.key) == key || (key != null && key.equals(k))))
...
```

在判断两个 Key 是否相同时，
1. 先比较 `hash`（通过 `hashCode` 的高 16 位和低 16 位进行异或运算得出）。这可以在最快的时间内判断两个对象是否相等，保证性能。
2. 但是不同对象的 `hashCode` 也可能相等。所以对满足 `p.hash == hash` 的条件，需要进一步判断。
3. 继续，比较两个对象的地址是否相同，`==` 判断是否绝对相等，`equals` 判断是否客观相等。



### 自定义对象作为Set元素时

* ref 1-[自定义对象作为Map的键或Set元素，需要重写equals和hashCode方法 | CSDN](https://blog.csdn.net/renfufei/article/details/14163329)


```java
class Dog {
    String color;

    public Dog(String s) {
        color = s;
    }
}

public class SetAndHashCode {
    public static void main(String[] args) {
        HashSet<Dog> dogSet = new HashSet<Dog>();
        dogSet.add(new Dog("white"));
        dogSet.add(new Dog("white"));

        System.out.println("We have " + dogSet.size() + " white dogs!");

        if (dogSet.contains(new Dog("white"))) {
            System.out.println("We have a white dog!");
        } else {
            System.out.println("No white dog!");
        }
    }
}
```

运行程序，输出结果如下。

```s
We have 2 white dogs!
No white dog!
```

根据阿里《Java开发手册》可知，「因为 Set 存储的是不重复的对象，依据 hashCode 和 equals 进行判断，所以 Set 存储的对象必须覆写这两个方法」。将 `Dog` 代码修改为如下。


```java
class Dog {
    String color;

    public Dog(String s) {
        color = s;
    }

    //重写equals方法, 最佳实践就是如下这种判断顺序:
    public boolean equals(Object obj) {
        if (!(obj instanceof Dog))
            return false;
        if (obj == this)
            return true;
        return this.color == ((Dog) obj).color;
    }

    public int hashCode() {
        return color.length();//简单原则
    }
}
```

此时，再运行程序，输出结果如下。

```s
We have 1 white dogs!
We have a white dog!
```

### 自定义对象作为Map的键和内存溢出


如下代码，自定义 `KeylessEntry` 对象，作为 Map 的键。

```java
class KeylessEntry {
    static class Key {
        Integer id;
        Key(Integer id) {
            this.id = id;
        }
        @Override
        public int hashCode() {
            return id.hashCode();
        }
    }
    public static void main(String[] args) {
        Map m = new HashMap();
        while (true){
            for (int i = 0; i < 10000; i++){
                if (!m.containsKey(new Key(i))){
                    m.put(new Key(i), "Number:" + i);
                }
            }
            System.out.println("m.size()=" + m.size());
        }
    }
}
```


上述代码中，使用 `containsKey(keyElement)` 判断 Map 是否已经包含 `keyElement` 键值。`containsKey` 的关键代码如下所示，使用了 `hashCode` 和 `equals` 方法进行判断。

```java
if (first.hash == hash && 
    ((k = first.key) == key || (key != null && key.equals(k))))
...
```


执行上述代码，因没有重写 `equals` 方法，导致 `m.containsKey(new Key(i))` 判断总是 false，导致程序不断向 Map 中插入新的 `key-value`，造成死循环，最终将导致内存溢出。 





## 抽象类和接口的区别
* [Java 中接口和抽象类的 7 大区别](https://www.shouxicto.com/article/2990.html)


### 接口
* 接口是对行为的抽象
* 创建接口使用关键字 `interface`，实现接口使用关键字 `implements`
* 接口中定义的普通方法，不能有具体的代码实现，方法默认是 `public  abstract`，并且不能定义为其他控制符
* 在 JDK 8 之后，允许创建 `static` 和 `default` 方法，这两种方法可以有默认的方法实现
* 接口不能直接实例化
* 接口中属性的访问控制符只能是 `public`，默认是 `public static final`

### 抽象类
* 抽象类是对对象公共行为的抽象
* 创建抽象类使用关键字 `abstract`，子类继承抽象类时使用关键字 `extends`
* 抽象类中定义的普通方法，可以有具体的代码实现
* 抽象类中定义的抽象方法，不能有具体的代码实现。抽象方法需要使用 `abstract` 标记
* 抽象类不能直接实例化
* 抽象类中属性控制符无限制，可以定义 `private` 类型的属性
* 抽象类中的方法控制符无限制，其中抽象方法不能使用 `private` 修饰


### 二者区别
1. 定义关键字不同：接口使用关键字 `interface` 来定义。抽象类使用关键字 `abstract` 来定义。
2. 继承或实现的关键字不同：接口使用 `implements` 关键字定义其具体实现。 抽象类使用 `extends` 关键字实现继承。
3. 子类扩展的数量不同：一个类可以同时实现多个接口，但是只能继承一个抽象类。
4. 属性访问控制符不同：接口中属性的访问控制符只能是 `public`。抽象类中的属性访问控制符无限制，可为任意控制符。
5. 方法控制符不同：接口中方法的默认控制符是 `public`，并且不能定义为其他控制符。抽象类中的方法控制符无限制，其中抽象方法不能使用 `private` 修饰。
6. 方法实现不同：接口中普通方法不能有具体的方法实现，在 JDK 8 之后 `static` 和 `default` 方法可以有默认的方法实现。抽象类中普通方法可以有方法实现，抽象方法不能有方法实现。
7. 静态代码块使用不同：接口中不能使用静态代码块，抽象类中可以使用静态代码，如下所示。

```java
//接口中不能使用静态代码块，如下代码会报错
public interface InterfaceDemo {
    static {
        System.out.println("interface static error");
    }
}

//抽象类中能使用静态代码块
public abstract class AbstractClassDemo {
    static {
        System.out.println("abstract class static ok");
    }
}
```




## StringBuilder和StringBuffer

### 线程安全性

* `StringBuffer` 是线程安全的。
* `StringBuilder` 不是线程安全的，但在单线程中性能优于 `StringBuffer`。

## 内容清空

* [Java 清空 StringBuilder / StringBuffer 变量的几种方法对比](https://www.cpming.top/p/clear-or-empty-a-stringbuilder)



`StringBuilder` 和 `StringBuffer` 内容清空，可分为 3 种方法
1. 重新赋值一个新的实例（涉及对象的创建，内存的分配）
2. 使用 `delete` 方法。`delete` 方法在内部分配具有指定长度的新缓冲区，然后将 `StringBuilder/StringBuffer` 缓冲区的修改内容复制到新缓冲区。如果迭代次数过多，这又是一项昂贵的操作。
3. `setLength(0)`。该操作不涉及任何新分配和垃圾回收，只是将内部缓冲区长度变量重置为 0，原始缓冲区保留在内存中，因此不需要新的内存分配，效率最高。


使用 `setLength(0)` 的效率最高。


```java
StringBuffer sb = new StringBuffer("test");
//方法1
sb = new StringBuffer();
//方法2
sb.delete(0, sb.length());
//方法3
sb.setLength(0);
```
