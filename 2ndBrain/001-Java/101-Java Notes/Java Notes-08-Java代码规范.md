
# Java Notes-08-Java代码规范

[TOC]

## 更新
* 2020/06/14，撰写
* 2020/07/28，添加 *Boolean和boolean比较*
* 2020/09/13，添加 *实用工具集合-Hutool*
* 2020/09/22，添加 *实用工具集合-Guava*



## 学习资料
* [阿里《Java开发手册》中的 1 个bug](https://mp.weixin.qq.com/s?__biz=MzU1NTkwODE4Mw==&mid=2247486248&idx=1&sn=05a3d29f24000626cae0ad57857ee6b3&scene=21#wechat_redirect)
* [驳《阿里「Java开发手册」中的1个bug》](https://juejin.im/post/5ee07ce76fb9a047ff1abe01)



## 实用工具集合-Guava

* [guava | Maven](https://mvnrepository.com/artifact/com.google.guava/guava)


### Maven依赖

```xml
<!-- https://mvnrepository.com/artifact/com.google.guava/guava -->
<dependency>
    <groupId>com.google.guava</groupId>
    <artifactId>guava</artifactId>
    <version>29.0-jre</version>
</dependency>
```




### ImmutableMap

**`ImmutableMap` 中 `key` 和 `value` 均不能为 `null`，放入 `null`值会抛出 `NPE`。**



```java
        // method 1
        Map<String, Integer> map = ImmutableMap.of("a",1,"b",2,"c",3);

        // method 2
        Map<String, Integer> map2 = ImmutableMap.<String,Integer>builder()
                .put("a",1)
                .put("b",2)
                .put("c",3)
                .build();
```





### Lists.partition


`Lists.partition(List<T> list, int size)` 会把一个 `List` 按照指定的 `size` 进行分割，如下代码所示。


```java
for(int i=0;i<17;i++){
    shopIdList.add(new StringBuilder().append("item").append(i).toString());
}

List<List<String>> idsList = Lists.partition(shopIdList, 5);

//idList: [[item0, item1, item2, item3, item4], [item5, item6, item7, item8, item9], [item10, item11, item12, item13, item14], [item15, item16]]
```


## 实用工具集合-Hutool

* [hutool 官网](https://www.hutool.cn/)
* [hutool gitee](https://gitee.com/loolly/hutool)
* [Hutool 介绍 | 掘金](https://juejin.im/post/6869914176941359118)


> Hutool是一个小而全的Java工具类库，它帮助我们简化每一行代码，避免重复造轮子。

1. Install

```xml
<dependency>
    <groupId>cn.hutool</groupId>
    <artifactId>hutool-all</artifactId>
    <version>5.4.0</version>
</dependency>
```

2. 常用工具类
* Convert
* DateUtil
* JSONUtil
* StrUtil
* ClassPathResource
* ReflectUtil
* NumberUtil
* BeanUtil
* CollUtil
* MapUtil
* AnnotationUtil
* SecureUtil
* CaptchaUtil
* Validator
* DigestUtil
* HttpUtil






## putAll和addAll
* [Java putAll与addAll的区别 | CSDN](https://blog.csdn.net/u013066244/article/details/80151670)

* `putAll` 是将集合中所有元素拷贝一份到目标集合中，会开辟新的存储空间，改变原集合中的值，并不会影响到目标集合。

```java
Map<String, Object> testMap = new HashMap<>();
testMap.put("test", 1);

Map<String, Object> hashMap = new HashMap<>();
hashMap.putAll(testMap);
testMap.put("test", 2);

System.out.println(hashMap.toString());  //{test=1}
```


* `addAll` 是把集合中所有元素插入到目标集合中，存在引用地址，改变原集合中的值，会影响到目标集合。

```java
        Map<String, Object> testMap = new HashMap<>();
        testMap.put("test", 1);
        testMap.put("flag", false);


        List<Map<String, Object>> list = new ArrayList<>();
        List<Map<String, Object>> tmpList = new ArrayList<>();

        tmpList.add(testMap);
        list.addAll(tmpList);
        testMap.put("test", 3);
        testMap.put("flag", true);

        System.out.println(list.toString()); //[{flag=true, test=3}]
```


## type argument cannot be of primitive type

* [Create a List of primitive int? | StackOverflow](https://stackoverflow.com/questions/18021218/create-a-list-of-primitive-int)
* [Why don't Java Generics support primitive types? | StackOverflow](https://stackoverflow.com/questions/2721546/why-dont-java-generics-support-primitive-types)
* [Java Map did not accept "boolean" | StackOverflow](https://stackoverflow.com/questions/6690541/java-map-did-not-accept-boolean)



**在集合类中，只能使用引用类型，不能使用原始类型。**如下代码所示，若使用 `Map<String,boolean> map1`，则会报错，提示 `type argument cannot be of primitive type`。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/java-reference-value-1.png)


因此，在创建List时候，需要写为 `List<Integer>`，而不能写成 `List<int>`。



## Boolean-boolean
* [Java Map did not accept "boolean" | StackOverflow](https://stackoverflow.com/questions/6690541/java-map-did-not-accept-boolean)
* [Java中的自动装箱与拆箱 | Blog](https://droidyue.com/blog/2015/04/07/autoboxing-and-autounboxing-in-java/)
* [Java中Boolean和boolean的区别 | CSDN](https://blog.csdn.net/invLong/article/details/43986613)

从 Java 1.5 开始，引入了自动装箱和拆箱。在Java 1.5 之前，从集合中接收布尔类型的数据，必须使用 `Boolean`，Java 1.5之后，由于自动装箱和拆箱的引入，使用 `boolean` 也可以。


```java
// Java 1.5 之后
Map<String, Object> map1 = new HashMap<String, Object>(16);
map1.put("res",false);
boolean res = (boolean) map1.get("res");  //error 会报错 需要使用Boolean从集合中接收数据
Boolean res = (Boolean) map1.get("res");  //ok


// Java 1.5 之后
Map<String, Object> map1 = new HashMap<String, Object>(16);
map1.put("res",false);
boolean res = (boolean) map1.get("res");  //ok
Boolean res = (Boolean) map1.get("res");  //ok
```



###  没有自动装箱和拆箱时的赋值

此处以 `Integer` 和 `int` 类型的转换为例进行说明。在 Java 1.5 以前，需要手动地进行转换才行，而现在所有的转换都是由编译器来完成。


```java
//before autoboxing
Integer iObject = Integer.valueOf(3);
int iPrimitive = iObject.intValue()

//after java5
Integer iObject = 3; //autobxing - primitive to wrapper conversion
int iPrimitive = iObject; //unboxing - object to primitive conversion
```



###  for循环中自动装箱导致的多余对象创建

自动装箱有一个问题，那就是在一个循环中进行自动装箱操作的情况，如下面的例子就会创建多余的对象，影响程序的性能。

```java
Integer sum = 0;
 for(int i=1000; i<5000; i++){
   sum+=i;
}
```

上面的代码 `sum += i` 可以看成 `sum = sum + i`，但是 `+` 这个操作符不适用于 `Integer` 对象，首先 `sum` 进行自动拆箱操作，进行数值相加操作，最后发生自动装箱操作转换成 `Integer` 对象。其内部变化如下

```java
int result = sum.intValue() + i;
Integer sum = new Integer(result);
```

由于我们这里声明的 `sum` 为 `Integer` 类型，在上面的循环中会创建将近 4000 个无用的 `Integer` 对象，在这样庞大的循环中，会降低程序的性能并且加重了垃圾回收的工作量。因此在我们编程时，需要注意到这一点，正确地声明变量类型，避免因为自动装箱引起的性能问题。


## null==xx
* [java中判断对象为null时，null在前面还是后面](https://my.oschina.net/u/3908739/blog/3046124)

在判断对象是否为 `null` 时，`null` 放在前面或者放在后面并无本质区别，但是推荐将 `null` 放在前面，`null` 放在前面，若书写时候少写一个 `=`，即 `null = xx` 会报错，这样可以避免笔误。详情参考上述链接。



## 阿里巴巴《Java开发手册》

## 在日志输出时，字符串变量之间的拼接使用占位符的方式


* [ref-阿里《Java开发手册》中的 1 个bug](https://mp.weixin.qq.com/s?__biz=MzU1NTkwODE4Mw==&mid=2247486248&idx=1&sn=05a3d29f24000626cae0ad57857ee6b3&scene=21#wechat_redirect)
* [ref-驳《阿里「Java开发手册」中的1个bug》](https://juejin.im/post/5ee07ce76fb9a047ff1abe01)



阿里巴巴的《Java开发手册》泰山版中，在第二章第三小节的第4条规范中指出


> 【强制】在日志输出时，字符串变量之间的拼接使用占位符的方式。
>
> 说明：因为 String 字符串的拼接会使用 StringBuilder 的 append() 方式，有一定的性能损耗。使用占位符仅 是替换动作，可以有效提升性能。
>
> 正例：logger.debug("Processing trade with id: {} and symbol: {}", id, symbol);


除了性能方面，使用占位符而非字符串拼接，可以保证代码的优雅性，可以在代码中少些一些逻辑判断。
