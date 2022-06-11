# Java Notes-28-JDK 8

[TOC]

## 更新
* 2020/11/19，撰写


## 参考资料
* 《Java 8实战》书籍



## Stream


* [延迟执行与不可变，系统讲解JavaStream数据处理 | 掘金](https://juejin.cn/post/6983835171145383967)
* [归约、分组与分区，深入讲解JavaStream终结操作 | 掘金](https://juejin.cn/post/6986805369540444191/)





## Optional
* [史上最佳 Java Optional 指南 |  王二博客](http://www.itwanger.com/life/2020/03/10/java-Optional.html)
* [Optional 菜鸟教程](https://www.runoob.com/java/java8-optional-class.html)
* [关于optional的orElse和orElseGet、orElseThrow](https://www.jianshu.com/p/1a711fa3adab)



### API Doc

|    方法      |       描述    | 
|--------------|---------------|
| static <T> Optional<T> empty() | 返回空的 Optional 实例 | 
| boolean equals(Object obj)  |  判断其他对象是否等于 Optional | 
| Optional<T> filter(Predicate<? super <T> predicate) | 如果值存在，并且这个值匹配给定的 predicate，返回一个Optional用以描述这个值，否则返回一个空的Optional | |  <U> Optional<U> flatMap(Function<? super T,Optional<U>> mapper) | 如果值存在，返回基于Optional包含的映射方法的值，否则返回一个空的Optional | 
|  T get()  | 如果在这个Optional中包含这个值，返回值，否则抛出异常 NoSuchElementException | 
|  int hashCode() | 返回存在值的哈希码，如果值不存在，返回 0 | 
| void ifPresent(Consumer<? super T> consumer) | 如果值存在则使用该值调用 consumer , 否则不做任何事情 | 
| boolean isPresent() | 如果值存在则方法会返回true，否则返回 false | 
| <U>Optional<U> map(Function<? super T,? extends U> mapper) | 如果有值，则对其执行调用映射函数得到返回值。如果返回值不为 null，则创建包含映射返回值的Optional作为map方法返回值，否则返回空Optional | 
| static <T> Optional<T> of(T value) | 回一个指定非null值的Optional | 
| static <T> Optional<T> ofNullable(T value) |  如果为非空，返回 Optional 描述的指定值，否则返回空的 Optional | 
| T orElse(T other) | 如果存在该值，返回值， 否则返回 other | 
| T orElseGet(Supplier<? extends T> other) | 如果存在该值，返回值， 否则触发 other，并返回 other 调用的结果 | 
| <X extends Throwable> T orElseThrow(Supplier<? extends X> exceptionSupplier) | 如果存在该值，返回包含的值，否则抛出由 Supplier 继承的异常 | 
| String toString()  | 返回一个Optional的非空字符串 | 



### 创建Optional对象

1. 可以使用静态方法 `empty()` 创建一个空的 `Optional` 对象

```java
Optional<String> empty = Optional.empty();
System.out.println(empty); // 输出：Optional.empty
```

2. 可以使用静态方法 `of()` 创建一个非空的 `Optional` 对象

```java
Optional<String> opt = Optional.of("沉默王二");
System.out.println(opt); // 输出：Optional[沉默王二]
```

当然了，传递给 `of()` 方法的参数必须是非空的，也就是说不能为 `null`，否则仍然会抛出 `NullPointerException`。

```java
String name = null;
Optional<String> optNull = Optional.of(name);  //NPE Exception
```
 
3. 可以使用静态方法 `ofNullable()` 创建一个即可空又可非空的 `Optional` 对象

```java
String name = null;
Optional<String> optOrNull = Optional.ofNullable(name);
System.out.println(optOrNull); // 输出：Optional.empty
```

`ofNullable()` 方法内部有一个三元表达式，如果为参数为 `null`，则返回私有常量 `EMPTY`；否则使用 `new` 关键字创建了一个新的 `Optional` 对象 —— 不会再抛出 NPE 异常了。`ofNullable()` 内部实现如下。

```java
public static <T> Optional<T> ofNullable(T value) {
    return value == null ? empty() : of(value);
}
```

### 判断值是否存在

可以通过方法 `isPresent()` 判断一个 `Optional` 对象是否存在，如果存在，该方法返回 true，否则返回 false —— 取代了 `obj != null` 的判断。


```java
Optional<String> opt = Optional.of("沉默王二");
System.out.println(opt.isPresent()); // 输出：true

Optional<String> optOrNull = Optional.ofNullable(null);
System.out.println(opt.isPresent()); // 输出：false
```

### 非空表达式

`Optional` 类的 `ifPresent()`，允许我们使用函数式编程的方式执行一些代码，因此，我把它称为非空表达式。

如果没有该方法的话，我们通常需要先通过 `isPresent()` 方法对 `Optional` 对象进行判空后再执行相应的代码。


```java
Optional<String> optOrNull = Optional.ofNullable(null);
if (optOrNull.isPresent()) {
    System.out.println(optOrNull.get().length());
}
```

有了 `ifPresent()` 之后，情况就完全不同了，可以直接将 Lambda 表达式传递给该方法，代码更加简洁，更加直观。

```java
Optional<String> opt = Optional.of("沉默王二");
opt.ifPresent(str -> System.out.println(str.length()));
```

Java 9 后还可以通过方法 `ifPresentOrElse(action, emptyAction)` 执行两种结果，非空时执行 `action`，空时执行 `emptyAction`。


```java
Optional<String> opt = Optional.of("沉默王二");
opt.ifPresentOrElse(str -> System.out.println(str.length()), () -> System.out.println("为空"));
```


### 设置（获取）默认值

有时候，我们在创建（获取） `Optional` 对象的时候，需要一个默认值，`orElse()` 和 `orElseGet()` 方法就派上用场了。

`orElse()` 方法用于返回包裹在 `Optional` 对象中的值，如果该值不为 `null`，则返回；否则返回默认值。该方法的参数类型和值得类型一致。


```java
String nullName = null;
String name = Optional.ofNullable(nullName).orElse("沉默王二");
System.out.println(name); // 输出：沉默王二
```

`orElseGet()` 方法与 `orElse()` 方法类似，但参数类型不同。如果 `Optional` 对象中的值为 `null`，则执行参数中的函数。

```java
String nullName = null;
String name = Optional.ofNullable(nullName).orElseGet(()->"沉默王二");
System.out.println(name); // 输出：沉默王二
```

从输出结果以及代码的形式上来看，这两个方法极其相似，这不免引起我们的怀疑，Java 类库的设计者有必要这样做吗？

假设现在有这样一个获取默认值的方法，很传统的方式。

```java
public static String getDefaultValue() {
    System.out.println("getDefaultValue");
    return "沉默王二";
}
```

然后，通过 `orElse()` 方法和 `orElseGet()` 方法分别调用 `getDefaultValue()` 方法返回默认值。


```java
public static void main(String[] args) {
    String name = null;
    System.out.println("orElse");
    String name2 = Optional.ofNullable(name).orElse(getDefaultValue());

    System.out.println("orElseGet");
    String name3 = Optional.ofNullable(name).orElseGet(OrElseOptionalDemo::getDefaultValue);
}
```

> `类名 :: 方法名` 是 Java 8 引入的语法，方法名后面是没有 `()` 的，表明该方法并不一定会被调用。


输出结果如下所示

```
orElse
getDefaultValue

orElseGet
getDefaultValue
```

输出结果是相同的，这是在 `Optional` 对象的值为 `null` 的情况下。假如 `Optional` 对象的值不为 `null` 呢？


```java
public static void main(String[] args) {
    String name = "沉默王三";
    System.out.println("orElse");
    String name2 = Optional.ofNullable(name).orElse(getDefaultValue());

    System.out.println("orElseGet");
    String name3 = Optional.ofNullable(name).orElseGet(OrElseOptionalDemo::getDefaultValue);
}
```

输出结果如下所示

```
orElse
getDefaultValue

orElseGet
```



**可以看到，在对象非 `null` 情况下，`orElse()` 依旧会调用 `getDefaultValue()` 函数，计算出若对象为 `null` 下的兜底值。而 `orElseGet()` 在对象非 `null` 时，则不会触发 `getDefaultValue()` 的执行。因此 `orElseGet()` 的性能更佳。**





此处给出一个素材中心@JD工程中，`orElseGet()` 使用的一个示例。

```java
private queryAdvertInfo(SysParam sysParam,Map<String,Object> map){
    //初始化入参
    sysParam = Optional.ofNullable(sysParam).orElseGet(()->new SysParam()); 
    // add by lbs 使用Lambda表达式进一步优化代码
    sysParam = Optional.ofNullable(sysParam).orElseGet(SysParam::new);

    // ...
    
    Map<String, Object> paraMap = Optional.ofNullable(advertParam.getExtension()).orElseGet(HashMap::new);
}
```

如上所示，使用 `orElseGet` 进行参数校验。




### 获取值

直观从语义上来看，`get()` 方法才是最正宗的获取 Optional 对象值的方法，但很遗憾，该方法是有缺陷的，因为假如 Optional 对象的值为 null，该方法会抛出 NoSuchElementException 异常。这完全与我们使用 Optional 类的初衷相悖。


```java
public class GetOptionalDemo {
    public static void main(String[] args) {
        String name = null;
        Optional<String> optOrNull = Optional.ofNullable(name);
        System.out.println(optOrNull.get());
    }
}
```
这段程序在运行时会抛出异常

```
Exception in thread "main" java.util.NoSuchElementException: No value present
	at java.base/java.util.Optional.get(Optional.java:141)
	at com.cmower.dzone.optional.GetOptionalDemo.main(GetOptionalDemo.java:9)
```

尽管抛出的异常是 NoSuchElementException 而不是 NPE，但在我们看来，显然是在“五十步笑百步”。**建议 `orElseGet()` 方法获取 Optional 对象的值。**

### 过滤值

可以使用 `filter()` 方法进行过滤处理。


```java
public class FilterOptionalDemo {
    public static void main(String[] args) {
        String password = "12345";
        Optional<String> opt = Optional.ofNullable(password);
        System.out.println(opt.filter(pwd -> pwd.length() > 6).isPresent());
    }
}
```

`filter()` 方法的参数类型为 `Predicate`（Java 8 新增的一个函数式接口），也就是说可以将一个 `Lambda` 表达式传递给该方法作为条件，如果表达式的结果为 false，则返回一个 EMPTY 的 Optional 对象，否则返回过滤后的 Optional 对象。

在上例中，由于 password 的长度为 5 ，所以程序输出的结果为 false。

假设密码的长度要求在 6 到 10 位之间，那么还可以再追加一个条件。

```
Predicate<String> len6 = pwd -> pwd.length() > 6;
Predicate<String> len10 = pwd -> pwd.length() < 10;

password = "1234567";
opt = Optional.ofNullable(password);
boolean result = opt.filter(len6.and(len10)).isPresent();
System.out.println(result);
```



### 转换值

在上述校验密码长度的基础上，对密码强度也进行校验，比如说密码不能是 `"password"`，这样的密码太弱了。

**此时，可以使用 `map()` 方法，该方法可以按照一定的规则将原有 Optional 对象转换为一个新的 Optional 对象，原有的 Optional 对象不会更改。**


```java
public class OptionalMapDemo {
    public static void main(String[] args) {
        String name = "沉默王二";
        Optional<String> nameOptional = Optional.of(name);
        Optional<Integer> intOpt = nameOptional
                .map(String::length);
        
        System.out.println(intOpt.orElse(0));
    }
}
```

在上面这个例子中，`map()` 方法的参数 `String::length`，意味着要 将原有的字符串类型的 Optional 按照字符串长度重新生成一个新的 Optional 对象，类型为 Integer。


更进一步，下面代码中，`map()` 将密码转化为小写，`filter()` 判断长度以及是否是 `password`。

```java
public class OptionalMapFilterDemo {
    public static void main(String[] args) {
        String password = "password";
        Optional<String>  opt = Optional.ofNullable(password);

        Predicate<String> len6 = pwd -> pwd.length() > 6;
        Predicate<String> len10 = pwd -> pwd.length() < 10;
        Predicate<String> eq = pwd -> pwd.equals("password");

        boolean result = opt.map(String::toLowerCase).filter(len6.and(len10 ).and(eq)).isPresent();
        System.out.println(result);
    }
}
```



