# Java-22-Java新版本特性


[TOC]

## 更新
* 2020/07/02，撰写



## 前言

| 版本 | 发布时间 |
|------|--------|
| Java SE 9  | 2017.9 | 
| Java SE 10 (18.3) | 2018.3 |
| Java SE 11 (18.9 LTS) | 2018.9 |
| Java SE 12 (19.3) | 2019.3 | 
| Java SE 13 (19.9) | 2019.9 |

## Java 8
1. Lambda 表达式和函数式接口
2. 方法引用
   * 使用一对冒号来 `::` 引用方法，如 `System.out::println`
3. 接口默认方法和静态方法
4. Optional
5. Stream
6. 日期时间 API
   * 新增了日期时间 API 用来加强对日期时间的处理，其中包括了 LocalDate，LocalTime，LocalDateTime，ZonedDateTime 等等
7. Base64 支持
8. JVM 的新特性：JVM 内存永久区被废弃，被 MetaSpace 替换




### Stream


* [延迟执行与不可变，系统讲解 Java Stream 数据处理 | 掘金](https://juejin.cn/post/6983835171145383967)
* [归约、分组与分区，深入讲解 Java Stream 终结操作 | 掘金](https://juejin.cn/post/6986805369540444191/)





### Optional
* [史上最佳 Java Optional 指南 |  王二博客](http://www.itwanger.com/life/2020/03/10/java-Optional.html)
* [Optional 菜鸟教程](https://www.runoob.com/java/java8-optional-class.html)
* [关于optional的orElse和orElseGet、orElseThrow](https://www.jianshu.com/p/1a711fa3adab)



#### 创建Optional对象

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

#### 判断值是否存在

可以通过方法 `isPresent()` 判断一个 `Optional` 对象是否存在，如果存在，该方法返回 true，否则返回 false —— 取代了 `obj != null` 的判断。


```java
Optional<String> opt = Optional.of("沉默王二");
System.out.println(opt.isPresent()); // 输出：true

Optional<String> optOrNull = Optional.ofNullable(null);
System.out.println(opt.isPresent()); // 输出：false
```

#### 非空表达式

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


#### 设置（获取）默认值

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

```s
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

```s
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




#### 获取值

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

```s
Exception in thread "main" java.util.NoSuchElementException: No value present
	at java.base/java.util.Optional.get(Optional.java:141)
	at com.cmower.dzone.optional.GetOptionalDemo.main(GetOptionalDemo.java:9)
```

尽管抛出的异常是 NoSuchElementException 而不是 NPE，但在我们看来，显然是在“五十步笑百步”。**建议 `orElseGet()` 方法获取 Optional 对象的值。**

#### 过滤值

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

```s
Predicate<String> len6 = pwd -> pwd.length() > 6;
Predicate<String> len10 = pwd -> pwd.length() < 10;

password = "1234567";
opt = Optional.ofNullable(password);
boolean result = opt.filter(len6.and(len10)).isPresent();
System.out.println(result);
```



#### 转换值

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







## Java 9

1. Jigsaw 模块系统
2. JShell REPL
3. 接口中使用私有方法
4. 集合不可变实例工厂方法
5. 改进 try-with-resources
6. 多版本兼容 jar 包
7. JVM：默认使用 G1 垃圾回收器

### Jigsaw 模块系统

在 Java 9 以前，打包和依赖都是基于 JAR 包进行的。JRE 中包含了 rt.jar，将近 63M，也就是说要运行一个简单的 Hello World，也需要依赖这么大的 jar 包。在 Java 9 中提出的模块化系统，对这点进行了改善。

关于模块化系统，具体可参考 [Java 9的模块化 | 知乎](https://zhuanlan.zhihu.com/p/24800180)。

### JShell REPL

Java 9 提供了交互式解释器。有了 JShell 以后，Java 终于可以像 Python，Node 一样在 Shell 中运行一些代码并直接得出结果了。


### 接口中使用私有方法

Java 9 中可以在接口中定义私有方法。

```java
public interface TestInterface {
    String test();

    // 接口默认方法
    default String defaultTest() {
        pmethod();
        return "default";
    }

    private String pmethod() {
        System.out.println("private method in interface");
        return "private";
    }
}
```

### 集合不可变实例工厂方法

在以前，我们想要创建一个不可变的集合，需要先创建一个可变集合，然后使用 `unmodifiableSet` 创建不可变集合。代码如下。


```java
Set<String> set = new HashSet<>();
set.add("A");
set.add("B");
set.add("C");

set = Collections.unmodifiableSet(set);
System.out.println(set);
```

Java 9 中提供了新的 API 用来创建不可变集合。

```java
List<String> list = List.of("A", "B", "C");
Set<String> set = Set.of("A", "B", "C");
Map<String, String> map = Map.of("KA", "VA", "KB", "VB");
```

### 改进 try-with-resources

Java 9 之前需要这样使用 try-with-resources。

```java
InputStream inputStream = new StringBufferInputStream("a");
try (InputStream in = inputStream) {
    in.read();
} catch (IOException e) {
    e.printStackTrace();
}
```



Java 9 中不需要在 try 中额外定义一个变量。在 Java 9 中可以直接使用 inputStream 变量，不需要再额外定义新的变量了。

```java
InputStream inputStream = new StringBufferInputStream("a");
try (inputStream) {
    inputStream.read();
} catch (IOException e) {
    e.printStackTrace();
}
```

### 多版本兼容 jar 包

Java 9 中支持在同一个 JAR 中维护不同版本的 Java 类和资源。


### JVM：默认使用 G1 垃圾回收器

Java 9 中，默认使用 G1 垃圾回收器。


G1 成为 JDK9 以后版本的默认 GC 策略，同时，`ParNew` + `SerialOld` 这种组合不被支持。

> 注意，G1 回收器是 JDK 1.7 引入的，只是在 Java 9 中被设置为了默认的垃圾回收器。也就是说，在 Java 9 之前的版本，如 Java 8 中，也可以使用 G1 回收器。



## Java 10

1. 新增局部类型推断 `var`。`var` 关键字目前只能用于局部变量以及 for 循环变量声明中。

```java
var a = "aa";
System.out.println(a);
```

2. 删除工具 javah
   * 从 JDK 中移除了 `javah` 工具，使用 `javac -h` 代替。
   * `javah` 命令主要用于在 JNI 开发的时，把 Java 代码声明的 JNI 方法转化成 C\C++ 头文件，以便进行 JNI 的 C\C++ 端程序的开发
3. 统一的垃圾回收接口，改进了 GC 和其他内务管理



## Java 11

1. Lambda 表达式中使用 var

```java
(var x, var y) -> x.process(y)
```

2. 字符串 API 增强。Java 11 新增了一系列字符串处理方法。

```java
// 判断字符串是否为空白
" ".isBlank(); 
" Javastack ".stripTrailing();  // " Javastack"
" Javastack ".stripLeading();   // "Javastack "
```

3. 标准化 HttpClient API
4. Java 命令直接编译并运行 `.java` 文件，省去先 `javac` 编译生成 `.class` 再运行的步骤


## Java 12
1. switch 表达式。Java 12 以后，switch 不仅可以作为语句，也可以作为表达式。

```java
private String switchTest(int i) {
    return switch (i) {
        case 1 -> "1";
        default -> "0";
    };
}
```

2. switch 表达式中，您可以定义多个 case 标签并使用箭头返回值，它使 switch 表达式真正更易于访问。

```java
// Java 12
public String newMultiSwitch(int day) {
    return switch (day) {
        case 1, 2, 3, 4, 5 -> "workday";
        case 6, 7 -> "weekend";
        default -> "invalid";
    };
} 
```
对于低于 12 的 Java，相同的示例要复杂得多。

```java
public String oldMultiSwitch(int day) {
    switch (day) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            return "workday";
        case 6:
        case 7:
            return "weekend";
        default:
            return "invalid";
    }
} 
```

## Java 13


文本块是多行字符串文字，它避免使用转义序列，并以可预测的方式自动设置字符串格式。它还使开发人员可以控制字符串的格式。从 Java 13 开始，文本块可用作预览功能。它们以三个双引号（`"""`）开头。让我们看看我们如何轻松地创建和格式化 JSON 消息。


```java
public String getNewPrettyPrintJson() {
    return """
        {
            "firstName": "Piotr",
            "lastName": "Mińkowski"
        }
    """;
} 
```


创建 Java 13 之前的相同 JSON 字符串要复杂得多。


```java
public String getOldPrettyPrintJson() {
    return "{\n" +
        "     \"firstName\": \"Piotr\",\n" +
        "     \"lastName\": \"Mińkowski\"\n" +
    "}";
} 
```

## Java 14

使用 `Records`，您可以定义不可变的纯数据类（仅限 `getter`）。它会自动创建 `toString`，`equals` 和 `hashCode` 方法。实际上，您只需要定义如下所示的字段即可。

```java
public record Person(String name, int age) {} 
```


## Java 15


### 密封类

使用密封类功能，您可以限制超类的使用。使用 `new` 关键字，`sealed` 您可以定义哪些其他类或接口可以扩展或实现当前类。


```java
public abstract sealed class Pet permits Cat, Dog {} 
```


允许的子类必须定义一个修饰符。如果您不想允许任何其他扩展名，则需要使用 `final` 关键字。


```java
public final class Cat extends Pet {} 
```


另一方面，您可以打开扩展类。在这种情况下，应使用 `non-sealed` 修饰符。


```java
public non-sealed class Dog extends Pet {} 
```


当然，下面的可见声明是不允许的。

```java
public final class Tiger extends Pet {} 
```
