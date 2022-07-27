

# Java-14-泛型


[TOC]



## 更新
* 2021/06/21，撰写
* 2022/07/02，排版整理

## 参考资料

* [泛型中<?>和<T>有什么区别 | Segmentfault](https://segmentfault.com/a/1190000023020690)
* [聊一聊-JAVA 泛型中的通配符 T，E，K，V，？ | 掘金](https://juejin.cn/post/6844903917835419661)
* [Java泛型的重要目的：别让猫别站在狗队里 | Blog](http://www.itwanger.com/java/2019/11/08/java-fanxing.html)
* [Java泛型：泛型类、泛型接口和泛型方法 | Segmentfault](https://segmentfault.com/a/1190000002646193)
* [Java 泛型中 ? 和 T 区别 | Blog](https://blog.mimvp.com/article/16134.html)
* [Java 泛型 <? super T> 中 super 怎么 理解？与 extends 有何不同 | 知乎](https://www.zhihu.com/question/20400700/answer/117464182)


## 前言

Java 泛型（generics）是 JDK 5 中引入的一个新特性，泛型提供了编译时类型安全检测机制，该机制允许开发者在编译时检测到非法的类型。

**泛型的本质是参数化类型**，也就是说所操作的数据类型被指定为一个参数。

泛型包括
1. 泛型类
2. 泛型方法
3. 泛型接口


## 通配符 T E K V ？

我们在定义泛型类，泛型方法，泛型接口的时候经常会碰见很多不同的通配符，比如 `T`，`E`，`K`，`V`，`?` 等等。本质上这些个都是通配符，没啥区别，只不过是编码时的一种约定俗成的东西。
* `？`，表示不确定的 Java 类型
* `T` (type) 表示具体的一个 Java 类型
* `K` `V` (key value) 分别代表 Java 键值中的 Key 和Value
* `E` (element) 代表 Element



## 泛型的使用

泛型的使用主要表现在3个方面
1. 泛型类
2. 泛型接口
3. 泛型方法


### 泛型类 


```java
//lmy material-jsf
@Data
public class AssembleKeyInfo<T> {
    // long id set
    private Set<Long> longIds = Sets.newHashSet();
    // string id set
    private Set<String> strIds = Sets.newHashSet();
    // int id set
    private Set<Integer> intIds = Sets.newHashSet();

    private T keyData;
}
```

```java
@Data
public class Container<K, V> {
    private K key;
    private V value;

    public Container(K k, V v) {
        key = k;
        value = v;
    }
}
```


### 泛型接口

```java
//接口定义
public interface Generator<T> {
    public T next();
}
```

```java
//实现接口
public class FruitGenerator implements Generator<String> {

    private String[] fruits = new String[]{"Apple", "Banana", "Pear"};

    @Override
    public String next() {
        Random rand = new Random();
        return fruits[rand.nextInt(3)];
    }
}
```

```java
//调用
public class Main {

    public static void main(String[] args) {
        FruitGenerator generator = new FruitGenerator();
        System.out.println(generator.next());
        System.out.println(generator.next());
        System.out.println(generator.next());
        System.out.println(generator.next());
    }
}
```

### 泛型方法

```java
public class Main {

    public static <T> void out(T t) {
        System.out.println(t);
    }

    public static void main(String[] args) {
        out("findingsea");
        out(123);
        out(11.11);
        out(true);
    }
}
```

## 类型擦除

* [Java泛型的重要目的：别让猫别站在狗队里 | Blog](http://www.itwanger.com/java/2019/11/08/java-fanxing.html)


### 真泛型和伪泛型
* 真泛型：泛型中的类型是真实存在的。
* 伪泛型：仅于编译时类型检查，在运行时擦除类型信息。


### Java的伪泛型


泛型是 Java 1.5 版本才引进的概念，在这之前是没有泛型的概念的。但显然，泛型代码能够很好地和之前版本的代码很好地兼容。这是因为，**Java中的泛型是伪泛型，泛型信息只存在于代码编译阶段，在进入 JVM 之前，与泛型相关的信息会被擦除掉**，专业术语叫做类型擦除。

```java
List<String> l1 = new ArrayList<String>();
List<Integer> l2 = new ArrayList<Integer>();
		
System.out.println(l1.getClass() == l2.getClass()); //true 
```

上述代码执行结果为 true，`List<String>` 和 `List<Integer>` 在 jvm 中的 Class 都是 `List.class`，即泛型信息被擦除了。


### 类型擦除的影响

结合一个示例，来理解类型擦除的影响。

```java
public class Cmower {
    class Dog {
    }

    class Cat {
    }

    public static void main(String[] args) {
        Cmower cmower = new Cmower();
        Map<String, Cat> map = new HashMap<>();
        Map<String, Dog> map1 = new HashMap<>();
		
        // The method put(String, Cmower.Cat) in the type Map<String,Cmower.Cat> is not applicable for the arguments (String, Cmower.Dog)
        //map.put("dog",cmower.new Dog());
		
        System.out.println(map.getClass());
        // 输出：class java.util.HashMap
        System.out.println(map1.getClass());
        // 输出：class java.util.HashMap
    }
}
```

map 的键位上是 Cat，所以不允许 put 一只 Dog；否则编译器会提示 `The method put(String, Cmower.Cat) in the type Map<String,Cmower.Cat> is not applicable for the arguments (String, Cmower.Dog)`。

但是问题就来了，map 的 Class 类型为 HashMap，map1 的 Class 类型也为 HashMap —— 也就是说，Java 代码在运行的时候并不知道 map 的键位上放的是 Cat，map1 的键位上放的是 Dog。

那么，试着想一些可怕的事情：既然运行时泛型的信息被擦除了，而反射机制是在运行时确定类型信息的，那么利用反射机制，是不是就能够在键位为 Cat 的 Map 上放一只 Dog 呢？

我们不妨来试一下。

```java
public class Cmower {
    class Dog {     
    }

    class Cat {
    }

    public static void main(String[] args) {
        Cmower cmower = new Cmower();
        Map<String, Cat> map = new HashMap<>();
		
        try {
            Method method = map.getClass().getDeclaredMethod("put",Object.class, Object.class);
                
            method.invoke(map,"dog", cmower.new Dog());
            
            System.out.println(map);
            // {dog=com.cmower.java_demo.sixteen.Cmower$Dog@55f96302}
	    } catch (NoSuchMethodException | SecurityException | IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }  
}
```

可以看到，我们竟然在键位为 Cat 的 Map 上放了一只 Dog！

> Java 的设计者在 JDK 1.5 时才引入了泛型，但为了照顾以前设计上的缺陷，同时兼容非泛型的代码，不得不做出了一个折中的策略：编译时对泛型要求严格，运行时却把泛型擦除了——要兼容以前的版本，还要升级扩展新的功能，真的很不容易！




## `<?>` 和 `<T>`
* [聊一聊-JAVA 泛型中的通配符 T，E，K，V，？ | 掘金](https://juejin.cn/post/6844903917835419661)


`"T"` 是**定义**类或方法时声明的，`"?"` 是**调用**时传入的，二者是不同的概念。
* `Class<T>` 在实例化的时候，`T` 要替换成具体类
* `Class<?>` 是个通配泛型，`?` 可以代表任何类型
* `<? extends E>` 是上界通配符，接收 E 类型或者 E 的子类型
* `<? super E>` 是下界通配符，接收 E 类型或者 E 的父类型


```java
ArrayList<T> al = new ArrayList<T>(); //指定集合元素只能是T类型

ArrayList<?> al = new ArrayList<?>(); //集合元素可以是任意类型

ArrayList<? extends E> al = new ArrayList<? extends E>();
```


* 上界通配符(Upper Bounds Wildcards):  `< ? extends E>`
* 下界通配符(Lower Bounds Wildcards):  `< ? super E>`




## 注意事项

### 泛型不支持基本数据类型

Java 中有基本数据类型和包装数据类型。

泛型不支持基本数据类型，也就是说，只能使用包装类型作为泛型的类型参数。比如 `List<Integer>` 是可以使用的，但是不能使用 `List<int>`。

### 泛型会影响重载


因为泛型在虚拟机编译过程中会进行类型擦除，所以，`List<Integer>` 和 `List<String>` 在类型擦除后都会变成 `List`。


### `List<Integer>` 不是 `List<Object>` 的子类

因为 Integer 是 Object 的子类，所以很多人误认为 `List<Integer>` 不是`List<Object>` 的子类，这是错误的。

我们可以说，`List<Integer>` 是 `Collection<Integer>` 的子类，但绝对不是 `List<Object>` 的子类。

因为经过类型擦除后，`List<Integer>` 和 `List<Object>` 都会变成 `List`。




