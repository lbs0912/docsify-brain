
# Java Notes-04-Effective Java

[TOC]

## 更新
* 2020/05/12，撰写，记录编写高质量有效的Java代码的操作
* 2020/05/14，添加 *Java创建对象的4种方式*
* 2020/05/19，添加 *Integer的缓存值*
* 2020/05/22，添加 *Java编程规范*
* 2020/06/01，添加 *枚举+接口->避免if/else*



## 学习资料
* [我去，你竟然还在用 try–catch-finally | 掘金](https://juejin.im/post/5e87cb9be51d4546cf777342#heading-0)
* [深入理解 Java try-with-resource 语法糖 | 掘金](https://juejin.im/entry/57f73e81bf22ec00647dacd0)




## transient关键字

* [Java transient关键字使用示例](https://www.jianshu.com/p/2911e5946d5c)






## 如何正确定义接口的返回值(boolean/Boolean)类型及命名(success/isSuccess)

* [如何正确定义接口的返回值(boolean/Boolean)类型及命名(success/isSuccess) | toBeTopJavaer](https://hollischuang.github.io/toBeTopJavaer/#/basics/java-basic/success-isSuccess-and-boolean-Boolean)


下面引用《阿里-Java开发手册》中两条规定。



> （一） 命名风格
> 
> 8. 【强制】POJO 类中布尔类型变量都不要加is 前缀，否则部分框架解析会引起序列化错误。
> 
> 说明：在本文MySQL 规约中的建表约定第一条，表达是与否的值采用is_xxx 的命名方式，所以，需要在
> <resultMap>设置从is_xxx 到xxx 的映射关系。
> 
> 反例：定义为基本数据类型Boolean isDeleted 的属性，它的方法也是isDeleted()，RPC 框架在反向解
> 析的时候，“误以为”对应的属性名称是deleted，导致属性获取不到，进而抛出异常。


 

> （四）OOP规约
> 11. 关于基本数据类型与包装数据类型的使用标准如下：
>
> 1） 【强制】所有的POJO 类属性必须使用包装数据类型。
>
> 2） 【强制】RPC 方法的返回值和参数必须使用包装数据类型。
>
> 3） 【推荐】所有的局部变量使用基本数据类型。





## DO DTO BO AO VO POJO

* [实体类（VO，DO，DTO，PO）的划分 | CSDN](https://blog.csdn.net/u010722643/article/details/61201899)
* [PO BO VO DTO POJO DAO DO这些Java中的概念分别指一些什么？ | 知乎](https://www.zhihu.com/question/39651928)
* [阿里巴巴Java开发手册中的DO、DTO、BO、AO、VO、POJO定义 | Blog](https://www.cnblogs.com/EasonJim/p/7967999.html)


1. POJO = Plain Old Java Object，即简单的Java对象。**对应于POJO的Java类称作POJO类，也就是不实现或继承特定于框架的接口或类的Java类。**

## StringUtils
* [StringUtils 在 commons-lang3 和 commons-lang 中的区别](https://blog.csdn.net/zhuhai__yizhi/article/details/82688962)


### commons-lang3和commons-lang

Apache 提供的 `StringUtils` 工具类分为两个不同的版本
1. 一个位于 `org.apache.commons.lang` 包中 
2. 一个位于 `org.apache.commons.lang3` 包中

`lang3` 是 Apache Commons 团队发布的工具包，要求 jdk 版本在 1.5 以上，相对于 `lang` 来说完全支持 Java 5 的特性，废除了一些旧的 API。该版本无法兼容旧有版本，于是为了避免冲突改名为 `lang3`。



### isNotEmpty和isNotBlank


对于多个空格组成的字符串 `"   "`，`isNotEmpty`判断为非空，`isNotBlank` 判断为空。

```java
StringUtils.isNotEmpty(null)      = false
StringUtils.isNotEmpty("")        = false
StringUtils.isNotEmpty(" ")       = true
StringUtils.isNotEmpty("bob")     = true         //attention
StringUtils.isNotEmpty("  bob  ") = true


StringUtils.isNotBlank(null)      = false
StringUtils.isNotBlank("")        = false
StringUtils.isNotBlank(" ")       = false       //attention
StringUtils.isNotBlank("bob")     = true
StringUtils.isNotBlank("  bob  ") = true
```


* `isNotEmpty` 源码

```java
    public static boolean isNotEmpty(final CharSequence cs) {
        return !isEmpty(cs);
    }
    public static boolean isEmpty(final CharSequence cs) {
        return cs == null || cs.length() == 0;
    }
```




* `isNotBlank` 源码

```java
    public static boolean isNotBlank(final CharSequence cs) {
        return !isBlank(cs);
    }
    public static boolean isBlank(final CharSequence cs) {
        int strLen;
        if (cs == null || (strLen = cs.length()) == 0) {
            return true;
        }
        for (int i = 0; i < strLen; i++) {
            if (!Character.isWhitespace(cs.charAt(i))) {
                return false;
            }
        }
        return true;
    }
```


## 数组为空校验

在校验数组是否为空时，由于数组本身是个对象，因此可以先通过 `== null` 进行校验，后续再通过 `strsArr.length == 0` 校验数组长度。


```java
String[] strsArr;  
if(strsArr == null || strsArr.length == 0){
    // 数组不为空校验
}   
```


## 枚举+接口->避免if/else

* [ref-恕我直言，我怀疑你没怎么用过枚举](https://mp.weixin.qq.com/s?__biz=MzU4ODI1MjA3NQ==&mid=2247485369&idx=1&sn=0f1a5f3a7cf840a145fdc01719697821&scene=21#wechat_redirect)
* [ref-答应我，别再if/else走天下了可以吗](https://mp.weixin.qq.com/s?__biz=MzU4ODI1MjA3NQ==&mid=2247484807&idx=1&sn=27de517d6b992fb03a0a6ab637189125&chksm=fdded343caa95a550ab3b3da530c11762eaea1ab95dfc9e826643e1da21f16c28d3541287214&scene=21#wechat_redirect)
* [ref-Java设计模式-策略模式 | 掘金](https://juejin.im/post/59facc30518825297a0e164c)



## Java编程规范

### 参考资料

* [Google Java 编程规范](https://legacy.gitbook.com/book/jervyshi/google-java-styleguide-zh/details)
* [CF-Java编程规范 @JD](http://doc.jd.com/base/eos-doc/system-rule/JD%E7%BC%96%E7%A0%81%E8%A7%84%E8%8C%83/Java/)


### Google Java 编码规范

1. import不要使用通配符，不要出现 `import java.util.*;` 
2. 每次只声明一个变量，不要使用组合声明，比如 `int a, b;`
3. 需要时才声明，并尽快进行初始化。不要在一个代码块的开头把局部变量一次性都声明了(这是c语言的做法)，而是在第一次需要使用它时才声明。
4. 局部变量在声明时最好就进行初始化，或者声明后尽快进行初始化。


### Java规范@JD

1. 方法的参数个数建议不超过5个,方便代码阅读与理解
2. 方法体的行数不能多于70行，方便阅读和理解
3. 强转对象操作需要判断对象类型是否匹配


```java
//强转之前必须使用 istanceof 进行类型判断
if(a instanceof String){
	String str = (String)a;
}
```

4. 字符串不能用 `+` 连接, 需要用 `StringBuilder` 代替，提高性能
5. 所有的字段和方法必须要用 `javadoc` 注释
6. 类必须有 `@author`（创建者）、`@date`（创建日期）、类功能描述等注释信息

```java
/**  
* Demo class  
* @author keriezhang  
* @date 2016/10/31 
* 类功能描述 (alt + enter -> add to custom tags)  
*/ 
public class CodeNoteDemo {      }
```

7. 所有的枚举类型字段必须要有注释，说明每个数据项的用途
8. 线程池不允许使用 `Executors` 去创建，而是通过 `ThreadPoolExecutor` 的方式，这样的处理方式让写的同学更加明确线程池的运行规则，规避资源耗尽的风险。
9. 线程资源必须通过线程池提供，不允许在应用中自行显式创建线程
10. 使用 `CountDownLatch` 进行异步转同步操作，每个线程退出前必须调用 `countDown` 方法，线程执行代码注意 `catch` 异常，确保 `countDown` 方法可以执行，避免主线程无法执行至 `await` 方法，直到超时才返回结果。
11. `long` 或者 `Long` 初始赋值时，必须使用大写的 `L`，不能是小写的 `l`，小写容易跟数字 1 混淆，造成误解。

```
Negative example:
//It is hard to tell whether it is number 11 or Long 1.
Long warn = 1l;

Positive example:
Long notwarn = 1L;
```
12. 不允许任何魔法值（即未经定义的常量）直接出现在代码中。
13. **不能在 `finally` 块中使用 `return`，`finally` 块中的 `return` 返回后方法结束执行，不会再执行 `try` 块中的 `return` 语句。**
14. 在 `if/else/for/while/do` 语句中必须使用大括号，即使只有一行代码，避免使用下面的形式

```
if (condition) statements;
```
15. 除常用方法（如 `getXxx/isXxx`）等外，不要在条件判断中执行复杂的语句，将复杂逻辑判断的结果赋值给一个有意义的布尔变量，以提高可读性。
16. 异常类命名使用 `Exception` 结尾
17. 测试类命名以它要测试的类的名称开始，以 `Test` 结尾
18. 常量命名应该全部大写，单词间用下划线隔开，力求语义表达完整清楚，不要嫌名字长。

```java
public class ConstantNameDemo {

	/**
	* max stock count
	*/
	public static final Long MAX_STOCK_COUNT = 50000L;
}
```
17. 对于 Service 和 DAO 类，基于 SOA 的理念，暴露出来的服务一定是接口，内部的实现类用 `Impl` 的后缀与接口区别


```java
public interface DemoService{
	void f();
}

public class DemoServiceImpl implements DemoService {
	@Override
	public void f(){
		System.out.println("hello world");
	}
}
```

18. POJO 类中的任何布尔类型的变量，都不要加 `is`，否则部分框架解析会引起序列化错误


```java
public class DemoDO{
	Boolean success;
	Boolean delete;
}
```

19. 中括号是数组类型的一部分


```java
String[] a = new String[3];  //Good 

String []a = new String[3];  //Bad
```

20. Object 的 `equals` 方法容易抛空指针异常，应使用常量或确定有值的对象来调用 `equals`。


```java
public void f(String str){
	String inner = "hi";
	if (inner.equals(str)) {
		System.out.println("hello world");
	}
}
```
21. 获取当前毫秒数时，使用 `System.currentTimeMillis();`，而不是 `new Date().getTime();`。如果想获取更加精确的纳秒级时间值，用 `System.nanoTime`。在 JDK8 中，针对统计时间等场景，推荐使用 `Instant` 类。


```java
public class TimeMillisDemo {
	public static void main(String args[]) {
		// Positive example:
		long a = System.currentTimeMillis();
		// Negative example:
		long b = new Date().getTime();

		System.out.println(a);
		System.out.println(b);
	}
}
```

22. `Math.random(`) 这个方法返回是 `double` 类型，注意取值的范围 `[0,1)`（能够取到零值，注意除零异常）。如果想获取整数类型的随机数，不要将 `x` 放大 10 的若干倍然后取整。优雅的做法是，直接使用 `Random` 对象的 `nextInt` 或者 `nextLong` 方法。


```java
//Negative example:
Long randomLong =(long) (Math.random() * 10);

//Positive example:
Long randomLong = new Random().nextLong();
```

23. `ArrayList` 的 `subList` 结果不可强转成 `ArrayList`，否则会抛出 `ClassCastException` 异常。


```java
//Negative example
List list = new ArrayList();
list.add("22");
//warn
List test = (ArrayList) list.subList(0, 1);  

//Positive example
List list2 = new ArrayList(list.subList(0, 1));
```

24. **不要在 `foreach` 循环里进行元素的 `remove/add` 操作，`remove` 元素请使用 `Iterator` 方式。**


```java
//Negative example
List originList = new ArrayList();
originList.add("22");
for (String item : originList) { 
	//warn
	list.add("bb");
}

//Positive example:
Iterator it=b.iterator(); 
while(it.hasNext()){ 
	Integer temp = it.next(); 
	if (delCondition) {
		it.remove();
	}
}
```
25. 集合初始化时，指定集合初始值大小。如果暂时无法确定集合大小，那么指定默认值（16）即可。


```java
//Negative example
Map map = new HashMap();

//Positive example 
Map map = new HashMap(16);
```


26. 后台输送给页面的变量必须加感叹号，`${var}`——中间加感叹号 `!`。如果 `var=null` 或者不存在，那么 `${var}` 会直接显示在页面上。


```java
$!email
$!{email}
```


27. **POJO 类必须写 `toString` 方法。使用工具类 `source > generate toString` 时。如果继承了另一个 POJO 类，注意在前面加一下 `super.toString`。这样处理，在方法执行抛出异常时，可以直接调用 POJO 的 `toString()` 方法打印其属性值，便于排查问题。**


```java
public class ToStringDemo extends Super{
	private String secondName;

	@Override
	public String toString() {
		return super.toString() + "ToStringDemo{" + "secondName=" + secondName + ""};
	}
}

class Super {
	private String firstName;

	@Override
	public String toString() {
		return "Super{" + "firstName=" + firstName + ""};
	}
}
```

28. 所有的覆写方法，，必须添加 `@Override` 注解。
29. 尽量避免采用取反逻辑运算符，取反运算符不利于快速理解。
30. **浮点数之间的等值判断，基本数据类型不能用 `==` 来比较，包装数据类型不能用 `equals` 来判断。**









### 其他

1. 避免 `Double Brace Initialization` 初始化容器，此种写法在多次调用时会造成匿名类被多次加载，影响性能。


```java
Map<String, Integer> bodyMap = new HashMap<String, Integer>(){{
   put("source",25);
   put("page",1);
   put("pageSize",maxLen);
}};
```



## Double Brace Initialization——双括号初始化（匿名内部类）

**在开发中，避免使用 `Double Brace Initialization` 初始化容器，此种写法在多次调用时会造成匿名类被多次加载，影响性能。**
 
### 参考资料
* [ref1-Java中"Double Brace Initialization"的效率问题](https://blog.csdn.net/cq20110310/article/details/102852638)
* [ref2-双括号初始化（Double Brace Initialization）的原理分析 | CSDN](https://blog.csdn.net/wuxianjiezh/article/details/90267142)
* [ref3-永远不要使用双花括号初始化实例，否则就会OOM | 掘金](https://juejin.im/post/5ec77f69f265da76eb7ffc1b)



### 静态代码块和非静态代码块

* [ref-静态代码块和非静态代码块 | CSDN](https://blog.csdn.net/jackpk/article/details/53391701)

Java 中可以使用括号进行初始化，并且分为**静态代码块和非静态代码块**。

```java
public class Test {
    public static int num = 0;
    String s = ""; 
 
    {
        s = "abc";
        System.out.println("non static init");
    }
 
    static {
        num = 1;
        System.out.println("static init");
    }
 
 
    public void runTest(){
        System.out.println(num);
        System.out.println(s);
    }
}
```
运行 Test 类的 `runTest` 方法，输出如下

```
static init 
non static init 
1 
abc
```

**从输出结果可以看出，有static修饰的静态代码块在非静态代码块之前执行。**

另外，非静态代码块与静态代码块有个区别
1. **静态代码块，在虚拟机加载类的时候就会加载执行，而且只执行一次** 
2. **非静态代码块，在创建对象的时候（即 `new` 一个对象的时候）执行，每次创建对象都会执行一次**



为了验证以上区别，写测试程序如下

```java
Test test1 = new Test();
Test1.runTest();
Test test2 = new Test();
test2.runTest();
```

输出结果如下

```
static init 
non static init 
1 
abc 
non static init 
1 
abc
```
**可以看到，静态代码块只执行一次，非静态代码块每次创建都执行。**



除了以上的代码块方式进行初始化，还可以使用 `Double Brace Initialization` 方式进行初始化

```java
    Test test = new Test(){
        {
            num = 2;
            s = "aaa";
        }  
    };
    test.runTest();
```

**`Double Brace Initialization` 方式中调用的是非静态初始化方法** ，这样的输出结果是

```
static init 
non static init 
2 
aaa
```


### 语法

`Double Brace Initialization` 是 JAVA 的隐藏特性，其语法如下

```java
    //新建一个列表并赋初值A、B、C
    ArrayList<String> list = new ArrayList<String>() {{
        add("A");
        add("B");
        add("C");
    }};
```

这种方式，比起来先 `new` 出对象，再一条条 `add` 数据，显得更加简洁和优雅。

**这种方式被称为双括号初始化（`Double Brace Initialization` ）或者匿名内部类初始化方法。**


下面以 `ArrayList` 的例子进行解释。

> 外层 `"{}"` 创建了 ArrayList 的一个匿名子类，内层 `"{}"` 创建了一个对象构造块。




1. 首先，第 1 层花括号定义了一个继承于 `ArrayList` 的匿名内部类 (`Anonymous Inner Class`)


```java
//定义了一个继承于ArrayList的类，它没有名字
new ArrayList<String>(){
  //在这里对这个类进行具体定义
};
```


2. 第 2 层花括号实际上是这个匿名内部类实例初始化块 (`Instance Initializer Block`)（或称为**非静态初始化块**）

```java
new ArrayList<String>(){
  {
    //这里是实例初始化块，可以直接调用父类的非私有方法或访问非私有成员
  }
};
```

3. **我们通过 `new` 得到这个 `ArrayList` 的子类的实例，并向上转型为 `ArrayList` 的引用。**

```java
ArrayList<String> list = new ArrayList<String>() {{}};
```

* 我们得到的实际上是一个 `ArrayList` 的子类的引用，虽然这个子类相比 `ArrayList` 并没有任何功能上的改变。
* 可以认为这是个本身装有数据的子类（因为它的数据来自于自身的初始化），而不是取得引用后再赋值。



### 优缺点

1. 优点
* `Double Brace Initialization` 方法一定程度上使代码更简洁
2. 缺点
* 可能降低可读性
* 还可能会造成内存泄露，在序列化时可能也会出现一些问题
* 效率较低，在多次调用时会造成匿名类被多次加载，影响性能


### Double Brace Initialization 的开销

**`Double Brace Initialization` 是一个带有实例初始化块的匿名内部类。** 这就意味着每一个新的类的产生，都会执行一次实例块，这样的目的通常是为了创建一个简单的对象。

JAVA 虚拟机在使用类之前需要去读取其 `classes` 信息，然后执行字节码校验等流程。所以为了保存这些 `class` 文件，所需要的磁盘空间会增大。


例如，在使用匿名内部类时候，会出现如下问题


```java
2009/05/27  16:35             1,602 DemoApp2$1.class
2009/05/27  16:35             1,976 DemoApp2$10.class
2009/05/27  16:35             1,919 DemoApp2$11.class
2009/05/27  16:35             2,404 DemoApp2$12.class
2009/05/27  16:35             1,197 DemoApp2$13.class

/* snip */

2009/05/27  16:35             1,953 DemoApp2$30.class
2009/05/27  16:35             1,910 DemoApp2$31.class
2009/05/27  16:35             2,007 DemoApp2$32.class
2009/05/27  16:35               926 DemoApp2$33$1$1.class
2009/05/27  16:35             4,104 DemoApp2$33$1.class
2009/05/27  16:35             2,849 DemoApp2$33.class
2009/05/27  16:35               926 DemoApp2$34$1$1.class
2009/05/27  16:35             4,234 DemoApp2$34$1.class
2009/05/27  16:35             2,849 DemoApp2$34.class

/* snip */

2009/05/27  16:35               614 DemoApp2$40.class
2009/05/27  16:35             2,344 DemoApp2$5.class
2009/05/27  16:35             1,551 DemoApp2$6.class
2009/05/27  16:35             1,604 DemoApp2$7.class
2009/05/27  16:35             1,809 DemoApp2$8.class
2009/05/27  16:35             2,022 DemoApp2$9.class

```

上述是一个简单应用中所产生的类信息。在这个应用中，使用了大量的匿名内部类，这些类会被单独地编译成 `class` 文件。


下面给出一个更具体的实例进行说明。

```java
package com.wuxianjiezh.test;

import java.util.HashMap;
import java.util.Map;

public class MainTest {

    public static void main(String[] args) {
        Map<String, String> map = new HashMap<String, String>() {
            // 实例初始化块
            {
                put("name", "吴仙杰");
                put("englishName", "Jason Wu");
            }
        }; // 因为匿名类是表达式，故它必须是语句的一部分，所以在闭合的大括号后会有一个分号

        System.out.println(map);
    }
}
```

通过 `javac` 编译上面的代码后，会生成以下两个 `class` 文件
1. `MainTest.class`
2. `MainTest$1.class`

可以看到，有个匿名类的 `class` 文件生成了，所以毫无疑问，“双括号初始化” 的确是使用了匿名类。如果使用了大量的匿名内部类，这些类会被单独地编译成 `class` 文件，增大磁盘开销。


### 效率测试

做一个简单的试验，创建 1000 个带着 `"Hello"` 和 `"World!"` 元素的 `ArrayList`

* 方法1：`Double Brace Initialization`

```java
List<String> l = new ArrayList<String>() {{
  add("Hello");
  add("World!");
}};
```

* 方法2：初始化 `ArrayList` 并调用 `add` 方法

```java
List<String> l = new ArrayList<String>();
l.add("Hello");
l.add("World!");
```

* 测试代码如下

```java
class Test1 {
  public static void main(String[] s) {
    long st = System.currentTimeMillis();

    List<String> l0 = new ArrayList<String>() {{
      add("Hello");
      add("World!");
    }};

    List<String> l1 = new ArrayList<String>() {{
      add("Hello");
      add("World!");
    }};

    /* snip */

    List<String> l999 = new ArrayList<String>() {{
      add("Hello");
      add("World!");
    }};

    System.out.println(System.currentTimeMillis() - st);
  }
}
```

```java
class Test2 {
  public static void main(String[] s) {
    long st = System.currentTimeMillis();

    List<String> l0 = new ArrayList<String>();
    l0.add("Hello");
    l0.add("World!");

    List<String> l1 = new ArrayList<String>();
    l1.add("Hello");
    l1.add("World!");

    /* snip */

    List<String> l999 = new ArrayList<String>();
    l999.add("Hello");
    l999.add("World!");

    System.out.println(System.currentTimeMillis() - st);
  }
}
```

* 对比两种方式下的执行效率，结果如下

```
Test1 Times (ms)           Test2 Times (ms)
----------------           ----------------
           187                          0
           203                          0
           203                          0
           188                          0
           188                          0
           187                          0
           203                          0
           188                          0
           188                          0
           203                          0
```

**在 `Double Brace Initialization` 方法中，产生了 1000 个 `class` 文件。**

**对比测试结果，`Double Brace Initialization` 平均时间花费了 190ms 左右。同时，另外一种方法平均只用了 0ms。可见两者效率相差巨大。**



### 结论

**因此，在开发中，避免使用 `Double Brace Initialization` 初始化容器，此种写法在多次调用时会造成匿名类被多次加载，影响性能。**

## Integer的缓存

### 参考资料
* [ref1-Integer的-128~127值缓存问题的思考 | 掘金](https://juejin.im/post/5df071256fb9a0163b12b9e6)
* [ref2-int和Integer有什么区别，Integer的值缓存范围 | CSDN](https://blog.csdn.net/qq_41264674/article/details/80141639)



### 面试实战

```java
private static void demo4(){
    int a = 128, b = 128;
    System.out.println("run result NO.1->"+(a == b));
  
    Integer c = 128, d = 128;
    System.out.println("run result NO.2->"+(c == d));
   
    Integer e = 100, f = 100;
    System.out.println("run result NO.3->"+(e == f));
}
```

执行上述代码，运行结果如下

```
run result NO.1->true
run result NO.2->false
run result NO.3->true
```

从执行上可以看出，变量`c`、`d` 都是 128，而执行结果是 `false`。这里涉及的知识点包括
1. 自动拆装箱
2. Integer在 `[-128,127]` 区间的缓存值


### int和Integer
1. `Integer` 是 `int` 的包装类；`int` 是基本数据类型；
2. `Integer` 变量必须实例化后才能使用；`int` 变量不需要； 
3. **`Integer` 实际是对象的引用，指向此 `new` 的 `Integer` 对象；而 `int` 是直接存储数据值。** 
4. `Integer` 的默认值是 `null`；`int` 的默认值是 0。


### 数值相等判断

1. 由于 `Integer` 变量实际上是对一个 `Integer` 对象的引用，所以两个通过 `new` 生成的 `Integer` 变量，在使用 `==` 判断时，永远是不相等的（因为 `new` 生成的是两个对象，其内存地址不同）。


```java
Integer i = new Integer(100);
Integer j = new Integer(100);
System.out.print(i == j); //false
```

对于上述情况，若比较其数值是否相等，可以比较其 `intValue()` 是否相等，或者使用 `equals()` 进行比较。

```java
System.out.print(i.equals(j));   //true
System.out.print(i.intValue() == j.intValue());   //true
```

2. `Integer` 变量和 `int` 变量比较时，只要两个变量的值是向等的，则结果为 `true`。因为包装类 `Integer` 和基本数据类型 `int` 比较时，JAVA 会自动拆包装为 `int`，然后进行比较，实际上就变为两个 `int`变量的比较。


```java
Integer i = new Integer(100);
int j = 100；
System.out.print(i == j); //true
```

3. 非 `new` 生成的 `Integer` 变量和 `new Integer()` 生成的变量比较时，结果为 `false`。因为非 `new` 生成的 `Integer` 变量指向的是 JAVA 常量池中的对象，而 `new Integer()` 生成的变量指向堆中新建的对象，两者在内存中的地址不同。


```java
Integer i = new Integer(100);
Integer j = 100;
System.out.print(i == j); //false
```

4. 对于两个非 `new` 生成的 `Integer` 对象，进行比较时
    * 如果两个变量的值在区间 `-128`到 `127` 之间，则比较结果为 `true`
    * 如果两个变量的值不在此区间，则比较结果为 `false`


```java
Integer i = 100;
Integer j = 100;
System.out.print(i == j); //true
 
Integer i = 128;
Integer j = 128;
System.out.print(i == j); //false
```



JAVA 在编译 `Integer i = 100;` 时，会翻译成为 

```java
Integer i = Integer.valueOf(100)
```

而 `valueOf()` 的源码如下
* 对于 `-128` 到 `127` 之间的数，会进行缓存。`Integer i = 127` 时，会将 127 进行缓存，下次再写 `Integer j = 127` 时，就会直接从缓存中取，就不会 `new`了。
* 对于不属于  `[-128,127]`  区间的值，会直接通过 `new` 生成 `Integer` 对象。


```java
    /**
     * Returns an {@code Integer} instance representing the specified
     * {@code int} value.  If a new {@code Integer} instance is not
     * required, this method should generally be used in preference to
     * the constructor {@link #Integer(int)}, as this method is likely
     * to yield significantly better space and time performance by
     * caching frequently requested values.
     *
     * This method will always cache values in the range -128 to 127,
     * inclusive, and may cache other values outside of this range.
     *
     * @param  i an {@code int} value.
     * @return an {@code Integer} instance representing {@code i}.
     * @since  1.5
     */
    public static Integer valueOf(int i) {
        if (i >= IntegerCache.low && i <= IntegerCache.high)
            return IntegerCache.cache[i + (-IntegerCache.low)];
        return new Integer(i);
    }
    
    /**
     * Cache to support the object identity semantics of autoboxing for values between
     * -128 and 127 (inclusive) as required by JLS.
     *
     * The cache is initialized on first usage.  The size of the cache
     * may be controlled by the {@code -XX:AutoBoxCacheMax=<size>} option.
     * During VM initialization, java.lang.Integer.IntegerCache.high property
     * may be set and saved in the private system properties in the
     * sun.misc.VM class.
     */

    private static class IntegerCache {
        static final int low = -128;
        static final int high;
        static final Integer cache[];

        static {
            // high value may be configured by property
            int h = 127;
            String integerCacheHighPropValue =
                sun.misc.VM.getSavedProperty("java.lang.Integer.IntegerCache.high");
            if (integerCacheHighPropValue != null) {
                try {
                    int i = parseInt(integerCacheHighPropValue);
                    i = Math.max(i, 127);
                    // Maximum array size is Integer.MAX_VALUE
                    h = Math.min(i, Integer.MAX_VALUE - (-low) -1);
                } catch( NumberFormatException nfe) {
                    // If the property cannot be parsed into an int, ignore it.
                }
            }
            high = h;

            cache = new Integer[(high - low) + 1];
            int j = low;
            for(int k = 0; k < cache.length; k++)
                cache[k] = new Integer(j++);

            // range [-128, 127] must be interned (JLS7 5.1.7)
            assert IntegerCache.high >= 127;
        }

        private IntegerCache() {}
    }
```


> `IntegerCache` 有一个静态的 `Integer` 数组，在类加载时就将 -128 到 127 的 `Integer` 对象创建了，并保存在 cache 数组中，一旦程序调用 `valueOf` 方法，如果i的值是在 -128 到 127 之间就直接在 cache 缓存数组中去取 Integer 对象


### 为什么缓存范围是-128~127

更进一步的思考，`Integer` 缓存的范围为什么是 `-128~127`？

计算机二进制存储中，对于有符号数，最高位是符号位，1 表示负数，0表示正数。

```
正数：原码 = 反码 = 补码
负数：反码 = 原码的所有位（符号位除外）取反
补码=反码+1
```

对于 `Integer` 类型，占用一个字节，共 8 位，最高位是符号位，所以可以表示的
1. 最大正数二进制：`0111 1111 = 64+32+16+8+4+2+1=127`
2. 最小负数二进制：`1000 0000` → 反码 `1111 1111` → 补码  `-{(1+2+4+8+16+32+64)+1} = -(127+1) = -128`

### 延展

不仅 `Integer`，JAVA 中的另外 7 中基本类型都可以自动装箱和自动拆箱，其中也有用到缓存，如下表所示
1. Boolean： 全部缓存
2. Byte：全部缓存
3. Character：<= 127缓存
4. Short：-128 — 127缓存
5. Long：-128 ~ 127缓存
6. Float：没有缓存
7. Doulbe：没有缓存


| 基本类型  |  装箱类型 | 取值范围 | 是否缓存 | 缓存范围 |
|-----------|-----------|----------|----------|----------|
| byte     |    Byte   |  -128 ~ 127  |  是  | -128 ~ 127 |
| short    |   Short   | -2^15 ~ (2^15 - 1) | 是 | -128 ~ 127 |
| int    | Integer | -2^31 ~ (2^31 - 1) | 是 | -128 ~ 127 |
| long  |  Long  |   -2^63 ~ (2^63 - 1) | 是 | -128 ~ 127 |
| float    | Float      | --       |    否     |    --  | 
| double   | Double   | --   | 否  | --  |
| boolean  | Boolean  | true, false | 是 | true, false |
| char   | Character  | \u0000 ~ \uffff  |  是 | \u0000 ~ \u007f |



## 糟糕的Java程序设计

### 参考资料
* [惊呆了！Java程序员最常犯的错竟然是这10个 | 掘金](https://juejin.im/post/5e13d24cf265da5d45542608#heading-0)


### 把Array转成ArrayList

很多 Java 程序员喜欢把 `Array` 转成 `ArrayList`

```java
List<String> list = Arrays.asList(arr);
```

**但实际上，`Arrays.asList()` 返回的 `ArrayList` 并不是 `java.util.ArrayList`，而是 `Arrays` 的内部私有类 `java.util.Arrays.ArrayList`。**

两个类有着很大的不同。`Arrays.ArrayList` 虽然有 `set()`、`get()` 和 `contains()` 等方法，但却没有一个方法用来添加元素，因为它的大小是固定的。

如果想创建一个真正的 `ArrayList`，需要这样做

```java
List<String> list = new ArrayList<String>(Arrays.asList(arr));
```
`ArrayList` 的构造方法可以接收一个 `Collection` 类型的参数，而 `Arrays.ArrayList` 是其子类，所以可以这样转化。


### 通过Set检查数组中是否包含某个值

* [ref-如何检查Java数组中是否包含某个值 | blog](https://mp.weixin.qq.com/s/DBvgghP5cN6KlPnILaqjmQ)


```java
Set<String> set = new HashSet<String>(Arrays.asList(arr));
return set.contains(targetValue);
```

如上代码，通过 Set 检查数组中是否包含某个值。这种做法虽然可行，但却忽视了性能问题。

更优雅的实现方式如下

```java
Arrays.asList(arr).contains(targetValue);
```

或者使用普通的 for 循环或者 for-each。

### 通过for循环删除列表中的元素

新手特列喜欢使用for循环删除列表中的元素，如下

```java
List<String> list = new ArrayList<String>(Arrays.asList("沉","默","王","二"));
for (int i = 0; i < list.size();i++) {
    list.remove(i);
}
System.out.println(list);
```

上面代码的目的是把列表中的元素全部删除，但程序输出如下，显示还有2个元素未被删除。

```
[默, 二]
```

当 `List` 的元素被删除时，其 `size()` 会减小，元素的下标也会改变，所以想通过 for 循环删除元素是行不通的。


那 `for-each` 呢？

```java
for(String s : list) {
    if ("沉".equals(s)){
        list.remove(s);
    }
}
System.out.println(list);
```

竟然还抛出异常了

```java
Exception in thread "main" java.util.ConcurrentModificationException
	at java.util.ArrayList$Itr.checkForComodification(ArrayList.java:909)
	at java.util.ArrayList$Itr.next(ArrayList.java:859)
	at FirstJavaTest.main(FirstJavaTest.java:15)
```

抛出异常的原因，可以查看 [Java，你告诉我 fail-fast 是什么鬼？](http://www.itwanger.com/java/2019/11/22/java-fail-fast.html)。

> Tip: 不能在 `for each` 循环中进行元素的 `remove` 操作。



有经验的程序员应该已经知道答案了，使用 Iterator

```
Iterator<String> iter = list.iterator();
while (iter.hasNext()) {
	String s = iter.next();
	if (s.equals("沉")) {
		iter.remove();
	}
}
System.out.println(list);
```
程序输出的结果如下

```
[默, 王,二]
```


### 滥用 public 修饰符

有些新手喜欢使用 `public` 修饰符，因为不需要 `getter/setter` 方法就可以访问字段。

但实际上，这是一个非常糟糕的设计。更优雅的设计是使用尽可能低的访问级别，保证类的封装。


### 父类没有默认的无参构造方法

在 Java 中，如果父类没有定义构造方法，则编译器会默认插入一个无参的构造方法。但如果在父类中定义了构造方法，则编译器不会再插入无参构造方法。

```java
class Parent{
    private  String name;

    public Parent(String name){
        this.name = name;
    }
}
class  Child extends Parent{
    public Child(String name){
        super(name);
    }
    public Child(){

    }
}
```

如上代码，编译会报错。因为父类并没有定义无参的构造函数。在子类中的无参构造函数试图调用父类的无参构造函数时候会报错。

```
Error:(41, 19) java: 无法将类 Parent中的构造器 Parent应用到给定类型;
  需要: java.lang.String
  找到: 没有参数
  原因: 实际参数列表和形式参数列表长度不同
```


## Java创建对象的4种方式


Java 创建对象的 4 种方式如下
1. 调用 `new` 语句创建对象
2. 调用对象的 `clone()` 方法
3. 运用反射手段创建对象
4. 运用反序列化手段


### 参考资料
* [深入理解Java中四种创建对象的方式 | 掘金](https://juejin.im/post/5a3b7c1f5188253865095b7b)
* [Java创建对象的4种方式 | CSDN](https://blog.csdn.net/u010889616/article/details/78946580)



### 调用 `new` 语句创建对象


```java
// 使用关键字 new 创建对象，初始化对象数据　
MyObject mo = new MyObject();　
```

### 调用对象的 `clone()` 方法

```java
MyObject anotherObject = new MyObject();
MyObject object = anotherObject.clone();
```

使用 `clone()` 方法克隆一个对象的步骤
1. 被克隆的类要实现 `Cloneable` 接口
2. 被克隆的类要重写 `clone()` 方法

原型模式主要用于对象的复制，实现一个接口（实现 `Cloneable` 接口），重写一个方法（重写 `Object` 类中的 `clone` 方法），即完成了原型模式。

原型模式中的拷贝分为"浅拷贝"和"深拷贝"
* 浅拷贝: 对值类型的成员变量进行值的复制，对引用类型的成员变量只复制引用，不复制引用的对象
* 深拷贝: 对值类型的成员变量进行值的复制，对引用类型的成员变量也进行引用对象的复制

> `Object` 类的 `clone` 方法只会拷贝对象中的基本数据类型的值，对于数组、容器对象、引用对象等都不会拷贝，这就是浅拷贝。
> 
> 如果要实现深拷贝，必须将原型模式中的数组、容器对象、引用对象等另行拷贝。


### 运用反射手段创建对象

使用 `Class` 类的 `newInstance` 方法可以调用无参的构造器来创建对象。
如果是有参构造器，则需要使用 `Class` 的 `forName` 方法和 `Constructor` 来进行对象的创建。


```java
Class stuClass = Class.forName("Student");
Constructor constructor = stuClass.getConstructor(String.class);
Student stu2 = (Student) constructor.newInstance("李四");
```

### 运用反序列化手段

一个对象实现了 `Serializable` 接口，就可以把对象写入到文件中，并通过读取文件来创建对象。

```java
String path = Test.class.getClassLoader().getResource("").getPath();
String objectFilePath = path + "out.txt";

ObjectOutputStream objectOutputStream = new ObjectOutputStream(new FileOutputStream(objectFilePath));
objectOutputStream.writeObject(stu2);

ObjectInput objectInput = new ObjectInputStream(new FileInputStream(objectFilePath));
Student stu4 = (Student) objectInput.readObject();
```


##  try-with-resource

### 背景

众所周知，所有被打开的系统资源，比如流、文件或者 Socket 连接等，都需要被开发者手动关闭。否则随着程序的不断运行，资源泄露将会累积成重大的生产事故。

在 Java 中，处理资源关闭的代码通常写在 `finally` 块中。然而，如果你同时打开了多个资源，那么将会出现噩梦般的场景 —— 打开多个资源时，会出现 `finally` 多层嵌套。

```java
public class Demo {
    public static void main(String[] args) {
        BufferedInputStream bin = null;
        BufferedOutputStream bout = null;
        try {
            bin = new BufferedInputStream(new FileInputStream(new File("test.txt")));
            bout = new BufferedOutputStream(new FileOutputStream(new File("out.txt")));
            int b;
            while ((b = bin.read()) != -1) {
                bout.write(b);
            }
        }
        catch (IOException e) {
            e.printStackTrace();
        }
        finally {
            if (bin != null) {
                try {
                    bin.close();
                }
                catch (IOException e) {
                    e.printStackTrace();
                }
                finally {
                    if (bout != null) {
                        try {
                            bout.close();
                        }
                        catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }
    }
}
```

**Oh My God！！！关闭资源的代码竟然比业务代码还要多！！！**

这是因为，我们不仅需要关闭 `BufferedInputStream`，还需要保证如果关闭 `BufferedInputStream` 时出现了异常， `BufferedOutputStream` 也要能被正确地关闭。所以我们不得不借助 `finally` 中嵌套 `finally` 大法。可以想到，打开的资源越多，`finally` 中嵌套的将会越深！！！


### try-with-resource 语法糖

**我们可以利用 Java 1.7 中新增的 `try-with-resource` 语法糖来打开资源，而无需码农们自己书写资源来关闭代码。**

下面使用 `try-with-resource` 来改写刚才的例子

```java
public class TryWithResource {
    public static void main(String[] args) {
        try (BufferedInputStream bin = new BufferedInputStream(new FileInputStream(new File("test.txt")));
             BufferedOutputStream bout = new BufferedOutputStream(new FileOutputStream(new File("out.txt")))) {
            int b;
            while ((b = bin.read()) != -1) {
                bout.write(b);
            }
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

是不是很简单？是不是很刺激？好了，下面将会详细讲解其实现原理以及内部机制。


### try-catch-finally局限——异常堆栈信息只展示最后一个异常

如下一个打开本地文件并进行读取的示例代码，使用了 `try-catch-finally`处理。

`try–catch-finally` 处理资源打开场景的异常时，会在一个严重的隐患
* `try` 中的 `br.readLine()` 有可能会抛出 `IOException`，
* `finally` 中的 `br.close()` 也有可能会抛出 `IOException`
* 如果两处都抛出了 `IOException`，那程序的调试任务就变得复杂了起来。到底是哪一处出了错误，就需要花一番功夫去处理


```java
public class TrycatchfinallyDecoder {
    public static void main(String[] args) {
        BufferedReader br = null;
        try {
            String path = TrycatchfinallyDecoder.class.getResource("/牛逼.txt").getFile();
            String decodePath = URLDecoder.decode(path,"utf-8");
            br = new BufferedReader(new FileReader(decodePath));

            String str = null;
            while ((str =br.readLine()) != null) {
                System.out.println(str);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
```



为了模拟演示 `try-cathc-finally` 处理异常的局限性，先看一个例子。

首先自定义一个类 `MyfinallyReadLineThrow`，它有两个方法，分别是 `readLine()` 和 `close()`，方法体都是主动抛出异常。


```java
class MyfinallyReadLineThrow {
    public void close() throws Exception {
        throw new Exception("close");
    }

    public void readLine() throws Exception {
        throw new Exception("readLine");
    }
}
```

然后我们在 `main()` 方法中使用 `try-finally` 的方式调用 `MyfinallyReadLineThrow` 的 `readLine()` 和 `close()` 方法。


```java
public class TryfinallyCustomReadLineThrow {
    public static void main(String[] args) throws Exception {
        MyfinallyReadLineThrow myThrow = null;
        try {
            myThrow = new MyfinallyReadLineThrow();
            myThrow.readLine();
        } finally {
            myThrow.close();
        }
    }
}
```

运行上述代码后，错误堆栈如下所示

```
Exception in thread "main" java.lang.Exception: close
	at MyfinallyReadLineThrow.close(FirstJavaTest.java:32)
	at FirstJavaTest.main(FirstJavaTest.java:18)
```

**`readLine()` 方法的异常信息竟然被 `close()` 方法的堆栈信息吃了，这必然会让我们误以为要检查的目标是 `close()` 方法而不是 `readLine()`** —— 尽管它也是应该怀疑的对象。

但自从有了 `try-with-resources`，这些问题就迎刃而解了，**只要需要释放的资源（比如 `BufferedReader`）实现了 `AutoCloseable` 接口**。

有了解决方案之后，我们来对之前的 `finally` 代码块进行瘦身。

```java
try (BufferedReader br = new BufferedReader(new FileReader(decodePath));) {
    String str = null;
    while ((str =br.readLine()) != null) {
        System.out.println(str);
    }
} catch (IOException e) {
    e.printStackTrace();
}
```

上述代码中，`finally` 代码块消失了，取而代之的是把要释放的资源写在 `try` 后的 `()` 中。如果有多个资源（`BufferedReader` 和 `PrintWriter`）需要释放的话，可以直接在 `()` 中添加

```java
try (BufferedReader br = new BufferedReader(new FileReader(decodePath));
     PrintWriter writer = new PrintWriter(new File(writePath))) {
    String str = null;
    while ((str =br.readLine()) != null) {
        writer.print(str);
    }
} catch (IOException e) {
    e.printStackTrace();
}
```

### 实现AutoCloseable接口

**在 `try-with-resources` 中若要释放自定义的资源，只要让它实现 AutoCloseable 接口，并提供 close() 方法即可。**

```java
public class TrywithresourcesCustom {
    public static void main(String[] args) {
        try (MyResource resource = new MyResource();) {
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

class MyResource implements AutoCloseable {
    @Override
    public void close() throws Exception {
        System.out.println("关闭自定义资源");
    }
}
```

代码运行结果如下

```
关闭自定义资源
```

是不是很神奇？我们在 `try()` 中只是 `new` 了一个 `MyResource` 的对象，其他什么也没干，但偏偏 `close()` 方法中的输出语句执行了。

想要知道为什么吗？来看看反编译后的字节码吧（此处使用 `jad` 进行查看）。


### addSuppressed()

反编译后的字节码如下

```java
class MyResource implements AutoCloseable {
    MyResource() {
    }

    public void close() throws Exception {
        System.out.println("关闭自定义资源");
    }
}

public class TrywithresourcesCustom {
    public TrywithresourcesCustom() {
    }

    public static void main(String[] args) {
        try {
            MyResource resource = new MyResource();
            resource.close();
        } catch (Exception var2) {
            var2.printStackTrace();
        }

    }
}
```

**可以看到，编译器竟然主动为 `try-with-resources` 进行了变身，在 `try` 中调用了 `close()` 方法。**


接下来，我们在自定义类中再添加一个 `out()` 方法


```java
class MyResourceOut implements AutoCloseable {
    @Override
    public void close() throws Exception {
        System.out.println("关闭自定义资源");
    }

    public void out() throws Exception{
        System.out.println("沉默王二，一枚有趣的程序员");
    }
}
```

这次，我们在 `try` 中调用一下 `out()` 方法

```java
public class TrywithresourcesCustomOut {
    public static void main(String[] args) {
        try (MyResourceOut resource = new MyResourceOut();) {
            resource.out();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

再来看一下反编译的字节码

```java
public class TrywithresourcesCustomOut {
    public TrywithresourcesCustomOut() {
    }

    public static void main(String[] args) {
        try {
            MyResourceOut resource = new MyResourceOut();

            try {
                resource.out();
            } catch (Throwable var5) {
                try {
                    resource.close();
                } catch (Throwable var4) {
                    var5.addSuppressed(var4);
                }

                throw var5;
            }

            resource.close();
        } catch (Exception var6) {
            var6.printStackTrace();
        }

    }
}
```

这次，`catch` 块中主动调用了 `resource.close()`，并且有一段很关键的代码 `var5.addSuppressed(var4)`。

它有什么用处呢？**当一个异常被抛出的时候，可能有其他异常因为该异常而被抑制住，从而无法正常抛出。这时可以通过 `addSuppressed()` 方法把这些被抑制的方法记录下来。被抑制的异常会出现在抛出的异常的堆栈信息中，也可以通过 `getSuppressed()` 方法来获取这些异常。**

这样做的好处是不会丢失任何异常，方便开发人员进行调试。

有没有想到我们之前的那个例子——在 `try-finally` 中，`readLine()` 方法的异常信息竟然被 `close()` 方法的堆栈信息吃了。现在有了 `try-with-resources`，再来看看作用和 `readLine()` 方法一致的 `out()` 方法会不会被 `close()` 吃掉。

在 `close()` 和 `out()` 方法中直接抛出异常

```java
class MyResourceOutThrow implements AutoCloseable {
    @Override
    public void close() throws Exception {
        throw  new Exception("close()");
    }

    public void out() throws Exception{
        throw new Exception("out()");
    }
}
```

调用这 2 个方法

```java
public class TrywithresourcesCustomOutThrow {
    public static void main(String[] args) {
        try (MyResourceOutThrow resource = new MyResourceOutThrow();) {
            resource.out();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

程序输入结果如下

```java
java.lang.Exception: out()
	at com.cmower.dzone.trycatchfinally.MyResourceOutThrow.out(TrywithresourcesCustomOutThrow.java:20)
	at com.cmower.dzone.trycatchfinally.TrywithresourcesCustomOutThrow.main(TrywithresourcesCustomOutThrow.java:6)
	Suppressed: java.lang.Exception: close()
		at com.cmower.dzone.trycatchfinally.MyResourceOutThrow.close(TrywithresourcesCustomOutThrow.java:16)
		at com.cmower.dzone.trycatchfinally.TrywithresourcesCustomOutThrow.main(TrywithresourcesCustomOutThrow.java:5)
```

瞧，这次不会了，`out()` 的异常堆栈信息打印出来了，并且 `close()` 方法的堆栈信息上加了一个关键字 `Suppressed`。一目了然，便于开发排查异常。


### 结论

在处理必须关闭的资源时，建议考虑使用 `try-with-resources`，而不是 `try–catch-finally`。前者产生的代码更加简洁、清晰，产生的异常信息也更清晰明了。