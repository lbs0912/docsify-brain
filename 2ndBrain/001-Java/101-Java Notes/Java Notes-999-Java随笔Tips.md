

# Java Notes-999-Java随笔Tips

[TOC]


## 更新
* 2020/08/05，撰写
* 2020/08/05，添加 *匿名内部类*
* 2020/08/05，添加 *Lambda 表达式*
* 2020/08/22，添加 *Google Guava*
* 2020/08/22，添加 *URL和URI*
* 2020/09/08，添加 *分页请求中整数取整*
* 2020/09/23，添加 *方法引用`::`*
* 2020/09/25，添加 *Bigdecimal类型判断是否等于0*
* 2020/11/11，添加 *覆盖equals时总要覆盖hasCode*
* 2020/11/11，添加 *String-.hasCode()*
* 2021/02/16，添加 *Guava介绍*
* 2021/03/11，添加 *String.split()*
* 2021/03/18，添加 *枚举类使用equal和==*
* 2021/04/21，添加 *遇到多个构造器参数时要考虑使用Builder构建器*
* 2021/04/21，添加 *IDEA Debug时以JSON串格式查看Java对象信息*
* 2021/12/05，添加 *Stream求数组最大最小值*






## switch使用时null判断
* ref 1-[Switch竟然会报空指针异常 | 掘金](https://juejin.cn/post/7082435085537902623)
  
在《阿里巴巴Java开发手册》中，有如下规则

> 【强制】当 switch 括号内的变量类型为 String 并且此变量为外部参数时，必须先进行 null 判断。




```java
public class Test {
    public static void main(String[] args) {
        String param = null;
        switch (param) {
            case "null":
                System.out.println("匹配null字符串");
                break;
            default:
                System.out.println("进入default");
        }
    }
}
```

执行上述代码，将抛出空指针。

```s
Exception in thread main,java.lang.NullPointerException ...
```

在 `case xxx` 条件判断时，是根据变量的 `hahCode` 去匹配的，若传入的为 null，则在取 `hahCode`时会产生 NPE。




## Hutool

* [hutool doc](https://hutool.cn/docs/#/)




|    模块	    |           介绍                |
|---------------|-------------------------------|
| hutool-aop	| JDK动态代理封装，提供非IOC下的切面支持  | 
| hutool-bloomFilter  | 	布隆过滤，提供一些Hash算法的布隆过滤  | 
| hutool-cache  | 	简单缓存实现  | 
| hutool-core	| 核心，包括Bean操作、日期、各种Util等  | 
| hutool-cron	| 定时任务模块，提供类Crontab表达式的定时任务 | 
| hutool-crypto	|  加密解密模块，提供对称、非对称和摘要算法封装 | 
| hutool-db	| JDBC封装后的数据操作，基于ActiveRecord思想  | 
| hutool-dfa | 	基于DFA模型的多关键字查找  | 
| hutool-extra  | 	扩展模块，对第三方封装（模板引擎、邮件、Servlet、二维码、Emoji、FTP、分词等）  | 
| hutool-http	| 基于HttpUrlConnection的Http客户端封装  | 
| hutool-log	| 自动识别日志实现的日志门面  | 
| hutool-script	| 脚本执行封装，例如Javascript  | 
| hutool-setting | 	功能更强大的Setting配置文件和Properties封装  | 
| hutool-system	| 系统参数调用封装（JVM信息等）  | 
| hutool-json	| JSON实现 | 
| hutool-captcha | 	图片验证码实现 | 
| hutool-poi	| 针对POI中Excel和Word的封装 | 
| hutool-socket	|  基于Java的NIO和AIO的Socket封装 | 
| hutool-jwt	| JSON Web Token (JWT)封装实现 | 



## 对String进行排序



```java
String s = "edcba"  ->  "abcde"
```

将String转为数组，借助 `Arrays.sort()` 进行排序。





```
String test= "edcba";
char[] ar = test.toCharArray();
Arrays.sort(ar);
String sorted = String.valueOf(ar);
```



or


```java
String original = "edcba";
char[] chars = original.toCharArray();
Arrays.sort(chars);
String sorted = new String(chars);
```

or

```java
String str = "aeoiu";
String[]arr = str.split("");
Arrays.sort(arr);
str = String.join("", arr);
```






## 集合的交差并补

* [Java求两个list的交集、并集、和差集](https://blog.csdn.net/huyishero/article/details/74108019)

```java
  List list1 =new ArrayList();
  list1.add("1111");
  list1.add("2222");
  list1.add("3333");
  
  List list2 =new ArrayList();
  list2.add("3333");
  list2.add("4444");
  list2.add("5555");
```


```java
//并集
list1.addAll(list2);  //若list1发生变化 则addAll返回true

//交集
list1.retainAll(list2);

//差集
list1.removeAll(list2);

//无重复并集
list2.removeAll(list1);
list1.addAll(list2);
```


## List<String> -> String []
* [在Java中将List <String>转换为String数组](https://qastack.cn/programming/2552420/converting-liststring-to-string-in-java)
* [java doc](https://docs.oracle.com/javase/6/docs/api/java/util/List.html#toArray(T%5B%5D))

```java
String[] strarray = strlist.toArray(new String[strlist.size()]);
```


## List<Integer> -> int []

```java
//List<Integer> list = new ArrayList<>();


int[] arr = list.stream().mapToInt(i->i).toArray();
```




## List的stream方法遍历和for循环遍历，哪个效率高

* [List的stream方法遍历和for循环遍历，哪个效率高](https://www.zhihu.com/question/405935760/answer/2252696945)



使用for循环，串行Stream流，并行Stream流来对5亿个数字求和。看消耗的时间。


```java
public class Demo06 {
private static long times = 50000000000L;
private long start;
    
    @Before
    public void init() {
        start = System.currentTimeMillis();
    }
    
    @After
    public void destory() {
        long end = System.currentTimeMillis();
        System.out.println("消耗时间: " + (end - start));

    }
   
    // 测试效率,parallelStream 120
    @Test
    public void parallelStream() {
        System.out.println("serialStream");
        LongStream.rangeClosed(0, times)
                    .parallel()
                    .reduce(0, Long::sum);
    }
    
    // 测试效率,普通Stream 342
    @Test
    public void serialStream() {
        System.out.println("serialStream");
        LongStream.rangeClosed(0, times)
            .reduce(0, Long::sum);
    }
   
    // 测试效率,正常for循环 421
    @Test
    public void forAdd() {
        System.out.println("forAdd");
        long result = 0L;
        for (long i = 1L; i < times; i++) {
             result += i;
        }
    }
}
```


可以看到 parallelStream 的效率是最高的。


## for each和普通for循环效率对比

* [Java中for each与正常for循环效率对比 | CSDN](https://blog.csdn.net/scuzoutao/article/details/77431522)
* [Java基础——foreach与正常for循环效率对比](https://blog.csdn.net/qq_19703019/article/details/79697789?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-1.highlightwordscore&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-1.highlightwordscore)

先给出结论
1. 对于数组来说，for和foreach循环效率差不多，for会相对更高点。
2. 但是对于链表来说，for循环效率明显比foreach低很多。



```java
public class ForTest {

    public static void testArrayList(ArrayList<Integer> arrayList) {
        System.out.println("测试ArrayList for");
        long starTime = System.currentTimeMillis();
        for(int i =0;i<arrayList.size();i++) {
            int x = arrayList.get(i);
        }
        long endTime  = System.currentTimeMillis();
        System.out.println("时间是："+(endTime - starTime));

        System.out.println("测试ArrayList foreach");
        long starTime1 = System.currentTimeMillis();
        for(int i: arrayList) {
            int y = i;
        }
        long endTime1  = System.currentTimeMillis();
        System.out.println("时间是："+(endTime1 - starTime1));
    }

    public static void testLinkedList(LinkedList<Integer> linkedList) {
        System.out.println("测试linkedList for");
        long starTime = System.currentTimeMillis();
        for(int i =0;i<linkedList.size();i++) {
            int x = linkedList.get(i);
        }
        long endTime  = System.currentTimeMillis();
        System.out.println("时间是："+(endTime - starTime));

        System.out.println("测试linkedList foreach");
        long starTime1 = System.currentTimeMillis();
        for(int i: linkedList) {
            int y = i;
        }
        long endTime1  = System.currentTimeMillis();
        System.out.println("时间是："+(endTime1 - starTime1));
    }
    public static void main(String[] args) {
        ArrayList<Integer> arrayList = new ArrayList<>();
        LinkedList<Integer> linkedList = new LinkedList<>();

        for(int i =0;i<100000;i++) {
            arrayList.add(i);
            linkedList.add(i);
        }

        testArrayList(arrayList);
        testLinkedList(linkedList);

    }

}
```

测试数据如下

```java
测试ArrayList for
时间是：6
测试ArrayList foreach
时间是：5
测试linkedList for
时间是：4515
测试linkedList foreach
时间是：2
```



需要循环数组结构的数据时，建议使用普通for循环，因为for循环采用下标访问，对于数组结构的数据来说，采用下标访问比较好。

需要循环链表结构的数据时，一定不要使用普通for循环，这种做法很糟糕，数据量大的时候有可能会导致系统崩溃。**LinkedList是通过链表实现的，for循环时要获取第i个元素必须从头开始遍历，而iterator遍历就是从头开始遍历，遍历完只需要一次，所以for循环需要的时间远远超过for循环。**



## Stream求数组最大最小值

```java
int[] A = {6,7,8,2,1,3,4,5};
int maxVal = Arrays.stream(A).max().getAsInt();
int minVal = Arrays.stream(A).min().getAsInt();
```


## IDEA Debug时以JSON串格式查看Java对象信息

* [Idea Debug 时 JAVA对象转Json字符串 的操作](https://blog.csdn.net/joyce0323/article/details/109780422)


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/leetcode/idea-debug-json-print-1.png)




参考如上链接和图片
1. Debug启动服务，并设置断点
2. 在断点处单击选择 "Evaluate Expressions..."
3. 在弹出的对话框上，执行 `JSONUtil.toJsonStr(user)`，在执行的结果上选择 "View Text"。
4. 复制文本结果，并将该JSON串格式化即可。


* hutool - JSONUtil.toJsonStr

```java
JSONUtil.toJsonStr(user)
//https://hutool.cn/docs/#/
```
```xml
<dependency>
    <groupId>cn.hutool</groupId>
    <artifactId>hutool-all</artifactId>
    <version>5.7.16</version>
</dependency>
```







## arr.clone
* [Java中的数组互相赋值，形参传递，地址传递](https://blog.csdn.net/xialong_927/article/details/81071100)

Java 中的数组本质上是对象。但是这个对象不是通过某个类实例化来的，而是 JVM 创建的。


```java    
int[] arr1 = {1,2,3};
int[] arr2 = arr1;
int[] arrCopy = arr1.clone();
```

如上所示，直接使用等号赋值，`arr2 = arr1`，改变 arr1，同时也会改变 arr2，因为等号赋值下，两者指向的是同一个对象。

使用 `arr1.clone()` 进行数组拷贝，是深拷贝，是创建一个新的对象。








## ArrayList和LinkedList哪个更占空间
* [当面试官问我ArrayList和LinkedList哪个更占空间时，我这么答让他眼前一亮 | 知乎](https://zhuanlan.zhihu.com/p/166686856)


### 结论
1. 一般情况下，LinkedList 的占用空间更大，因为每个节点要维护指向前后地址的两个节点
2. 但也不是绝对，如果刚好数据量超过 ArrayList 默认的临时值时，ArrayList 占用的空间也是不小的，因为扩容的原因会浪费将近原来数组一半的容量
3. 不过，因为 ArrayList 的数组变量是用 transient 关键字修饰的，如果集合本身需要做序列化操作的话，ArrayList 这部分多余的空间不会被序列化


### ArrayList

ArrayList 是 List 接口的一个实现类，底层是基于数组实现的存储结构。因此，比较适用于数组的查询，不太适用于数组的插入和删除。



```java
/**
 * Default initial capacity.
 */
private static final int DEFAULT_CAPACITY = 10
```

新建一个 `ArrayList` 实例时，会默认帮我们初始化数组的大小为 10。当插入数据时，若容量不够，会触发扩容，新增一个为原来容量 1.5倍 的新数组。


```java
//插入 5
| 1 | 2 | 3 | 4 |   

//扩容，新数组容量为1.5*4 = 6
| 1 | 2 | 3 | 4 | 5 | 0 |
```


除此之外，ArrayList 支持在指定 index 处插入元素。如上所示，把元素 9 插入到 元素 3 后面的位置，也就是现在 4 所在的地方。


插入数据的时候，ArrayList 的操作是先把 3 后面的数组全部复制一遍，然后将这部分数据往后移动一位，其实就是逐个赋值给后移一位的索引位置，然后 3 后面就可以空出一个位置，把 9 放入就完成了插入数据的操作。


因此，在对 ArrayList 进行数据的增删时，效率很低。








### LinkedList

**LinkedList 是基于双向链表实现的，不需要指定初始容量，链表中任何一个存储单元都可以通过向前或者向后的指针获取到前面或者后面的存储单元。** 在 LinkedList 的源码中，其存储单元用一个 Node 类表示

```java
private static class Node<E> {
    E item;
    Node<E> next;       
    Node<E> prev;

    Node(Node<E> prev, E element, Node<E> next) {
        this.item = element;
        this.next = next;
        this.prev = prev;
    }
}
```

Node中包含了三个成员，分别是存储数据的item，指向前一个存储单元的点 prev 和指向后一个存储单元的节点 next ，通过这两个节点就可以关联前后的节点，组装成为链表的结构。



LinkedList 比较适用于数据增删操作频繁的场景，不适用于数据的查询。**LinkedList是基于双向链表存储的，当查询对应 index 位置的数据时，会先计算链表总长度一半的值，判读 index 是在这个值的左边还是右边，然后决定从头结点还是从尾结点开始遍历。**


```java
Node<E> node(int index) {
        // assert isElementIndex(index);

        if (index < (size >> 1)) {
            Node<E> x = first;
            for (int i = 0; i < index; i++)
                x = x.next;
            return x;
        } else {
            Node<E> x = last;
            for (int i = size - 1; i > index; i--)
                x = x.prev;
            return x;
        }
    }

    //...
}
```



表面上看，LinkedList 的 Node 存储结构似乎更占空间，但别忘了前面介绍 ArrayList 扩容的时候，它会默认把数组的容量扩大到原来的 1.5 倍的，如果你只添加一个元素的话，那么会有将近原来一半大小的数组空间被浪费了，如果原先数组很大的话，那么这部分空间的浪费也是不少的。所以，如果数据量很大又在实时添加数据的情况下，ArrayList占用的空间不一定会比LinkedList空间小。


### ArrayList的transient



```java
transient Object[] elementData;
```

查看 ArrayList 的源码，其 elementData 被 `transient` 修饰了，这意味着不希望 `elementData` 数组被序列化。为什么要这么做呢？


这是因为序列化 ArrayList 的时候，ArrayList 里面的 elementData，也就是数组未必是满的，比方说 elementData 有 10 的大小，但是我只用了其中的 3 个，那么是否有必要序列化整个 elementData 呢？ 显然没有这个必要，因此 ArrayList 中重写了 `writeObject` 方法



```java
private void writeObject(java.io.ObjectOutputStream s)
    throws java.io.IOException{
    // Write out element count, and any hidden stuff
    int expectedModCount = modCount;
    s.defaultWriteObject();

    // Write out size as capacity for behavioural compatibility with clone()
    s.writeInt(size);

    // Write out all elements in the proper order.
    for (int i=0; i<size; i++) {
        s.writeObject(elementData[i]);
    }

    if (modCount != expectedModCount) {
        throw new ConcurrentModificationException();
    }
}
```

每次序列化的时候调用这个方法，先调用 `defaultWriteObject()` 方法序列化 ArrayList 中的非 transient 元素，elementData 这个数组对象不去序列化它，而是遍历 elementData，只序列化数组里面有数据的元素，这样一来，就可以加快序列化的速度，还能够减少空间的开销。





## transient关键字
* [Java中的transient关键字 | 掘金](https://juejin.cn/post/6844903872725516296)
* [你真的搞懂 transient 关键字了吗 ](https://zhuanlan.zhihu.com/p/58422235)
* [Java transient关键字使用小记](https://www.cnblogs.com/lanxuezaipiao/p/3369962.html)




### 结论

1. 一旦变量被 `transient` 修饰，变量将不再是对象持久化的一部分。
2. `transient` 关键字只能修饰变量，而不能修饰方法和类。
3. 被 `transient` 关键字修饰的变量不再能被序列化，一个静态变量不管是否被 `transient` 修饰，均不能被序列化。


### Demo


```java
@Data
@Builder
class User{
    private String name;
    private static int count;
    private transient String password;
}
```

```java
public static void main(String[] args) {
    User user = User.builder().name("lbs0912").password("123456").build();
    System.out.println(JsonUtil.write2JsonStr(user));
}
```

如上代码所示，`transient` 修饰 `password` 属性后，在序列化打印 user 对象信息时，`password` 无法被序列化，代码输出为 `{"name":"lbs0912"}`。




### 静态变量能被序列化吗


```java
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;


public class TransientStaticTest {

    public static void main(String[] args) throws Exception {

        User2 user = new User2();
        User2.username = "Java技术栈1";
        user.setId("javastack");

        System.out.println("\n序列化之前");
        System.out.println("username: " + user.getUsername());
        System.out.println("id: " + user.getId());

        ObjectOutputStream os = new ObjectOutputStream(new FileOutputStream("d:/user.txt"));
        os.writeObject(user);
        os.flush();
        os.close();

        // 在反序列化出来之前，改变静态变量的值
        User2.username = "Java技术栈2";

        ObjectInputStream is = new ObjectInputStream(new FileInputStream("d:/user.txt"));
        user = (User2) is.readObject();
        is.close();

        System.out.println("\n序列化之后");
        System.out.println("username: " + user.getUsername());
        System.out.println("id: " + user.getId());

    }
}


class User2 implements Serializable {

    private static final long serialVersionUID = 1L;

    public static String username;
    private transient String id;

    public String getUsername() {
        return username;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

}
```



输出结果如下

```s
序列化之前
username: Java技术栈1
id: javastack

序列化之后
username: Java技术栈2
id: null
```

可以看到，把 `username` 改为了 `public static`，并在反序列化出来之前改变了静态变量的值，结果可以看出序列化之后的值并非序列化进去时的值。

由以上结果分析可知，**静态变量不能被序列化，读取出来的是 username 在 JVM 内存中存储的值。**


### transient 真不能被序列化吗



```java
import java.io.Externalizable;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInput;
import java.io.ObjectInputStream;
import java.io.ObjectOutput;
import java.io.ObjectOutputStream;


public class ExternalizableTest {

    public static void main(String[] args) throws Exception {

        User3 user = new User3();
        user.setUsername("Java技术栈");
        user.setId("javastack");
        ObjectOutput objectOutput = new ObjectOutputStream(new FileOutputStream(new File("javastack")));
        objectOutput.writeObject(user);

        ObjectInput objectInput = new ObjectInputStream(new FileInputStream(new File("javastack")));
        user = (User3) objectInput.readObject();

        System.out.println(user.getUsername());
        System.out.println(user.getId());

        objectOutput.close();
        objectInput.close();
    }

}


class User3 implements Externalizable {

    private static final long serialVersionUID = 1L;

    public User3() {

    }

    private String username;
    private transient String id;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @Override
    public void writeExternal(ObjectOutput objectOutput) throws IOException {
        objectOutput.writeObject(id);
    }

    @Override
    public void readExternal(ObjectInput objectInput) throws IOException, ClassNotFoundException {
        id = (String) objectInput.readObject();
    }

}
```



输出结果

```s
null
javastack
```

上述代码的 id 被 `transient` 修改了，为什么还能序列化出来？那是因为 User3 实现了接口 `Externalizable`，而不是 `Serializable`。

在 Java 中有 2 种实现序列化的方式，`Serializable` 和 `Externalizable`。这两种序列化方式的区别是
1. 实现了 Serializable 接口是自动序列化的
2. 实现 Externalizable 则需要手动序列化，通过 `writeExternal` 和 `readExternal` 方法手动进行。这也是为什么上面的 username 为 null 的原因了。

















## int (2^32）-1

Java 中 int表示的最大整数位 `(2^32）-1`，若用 `10^x` 衡量，x最大是9。

即  **`10^9` < `(2^32）-1` < `10^10`**。

```java
int val = (int) (Math.pow(2,32) -1);  //2147483647   10位数字
long val2 = (long) Math.pow(10,9);    //1000000000   val2 < val
long val3 = (long) Math.pow(10,10);   //10000000000   val3 < val
```



## Comparison method violates its general contract报错解决


### 参考资料
* [ref-1-Comparison method violates its general contract!](https://www.cnblogs.com/firstdream/p/7204067.html)
* [why does my compare method throw exception — Comparison method violates its general contract!](https://stackoverflow.com/questions/6626437/why-does-my-compare-method-throw-exception-comparison-method-violates-its-gen)
* [ref-2-Java中排序报：Comparison method violates its general contract异常的解决](https://www.yisu.com/zixun/216478.html)
* [ref-3-JAVA 排序异常：java.lang.IllegalArgumentException:Comparison method violates its general contract!](https://www.dtmao.cc/news_show_97743.shtml)

### 问题描述

```java
public class FixedPromotionMaterialInfoComparator implements Comparator<PromotionMaterialInfo> {
    @Override
    public int compare(PromotionMaterialInfo o1, PromotionMaterialInfo o2) {
        try{
            if(StringUtils.isNotBlank(o1.getSortNum()) && StringUtils.isNotBlank(o2.getSortNum())){
                int sortNum1 = PromotionMaterialUtils.getSortNum(o1.getSortNum(), EasyUtils.toString(o1.getForceType()));
                int sortNum2 = PromotionMaterialUtils.getSortNum(o2.getSortNum(),EasyUtils.toString(o2.getForceType()));
                if(sortNum1 == sortNum2){ //页码相等 按照有效开始时间升序排序
                    Map<String, Object> extMap1 = JsonUtil.json2Map(EasyUtils.toString(o1.getExt()));
                    Map<String, Object> extMap2 = JsonUtil.json2Map(EasyUtils.toString(o2.getExt()));
                    Long startTimeVal1 = EasyUtils.parseLong(Optional.ofNullable(extMap1).orElseGet(HashMap::new).get("validStartTime"));
                    Long startTimeVal2 = EasyUtils.parseLong(Optional.ofNullable(extMap2).orElseGet(HashMap::new).get("validStartTime"));
                    return (int) (startTimeVal1 - startTimeVal2);
                }
                return sortNum1 - sortNum2; //页码不等 按照页码升序排序
            }
        }catch (Exception e){
            log.error("FixedPromotionMaterialInfoComparator exception,o1:{},o2:{}",JsonUtil.write2JsonStr(o1),JsonUtil.write2JsonStr(o2));
        }
        return 0;
    }
}
```

在素材CMS@JD开发期间，如上代码所示，线上运行后偶现如下报错日志。可以看到在调用 `TimSort.sort` 时， `java.lang.IllegalArgumentException: Comparison method violates its general contract` ，比较方法违背了其约定的规则。




```s
java.lang.IllegalArgumentException: Comparison method violates its general contract!  
at java.util.TimSort.mergeHi(TimSort.java:868)  
at java.util.TimSort.mergeAt(TimSort.java:485)  
at java.util.TimSort.mergeCollapse(TimSort.java:408)  
at java.util.TimSort.sort(TimSort.java:214)  
at java.util.TimSort.sort(TimSort.java:173)  
at java.util.Arrays.sort(Arrays.java:659)  
at java.util.Collections.sort(Collections.java:217) 
```



### 问题分析

> 在 JDK6 及更老版本的中，上述代码运行是不会产生异常的。从 JDK7 开始，`Collections.sort()` 在排序算法上的更新固然能够带来排序性能上的提升，但这一次排序算法的升级对比较器 `Comparator` 增加了一些规则，并没有完全向前兼容。

在 JDK7 版本以上，`Comparator` 要满足自反性，传递性，对称性，不然 `Arrays.sort`，`Collections.sort` 会报 `IllegalArgumentException` 异常。

1. 自反性：x，y 的比较结果和 y，x 的比较结果相反，即 `sgn(compare(x,y)) == -sgn(compare(y,x))`。
2. 传递性：x > y，y > z，则 x > z，即 `((compare(x, y)>0) && (compare(y, z)>0)) implies compare(x, z)>0`。
3. 对称性：x=y，则 x，z 比较结果和 y，z 比较结果相同。即 `compare(x,y)==0 implies that sgn(compare(x,z))==sgn(compare(y,z)) for all z`。



因此，对于上述代码，`compare(PromotionMaterialInfo o1, PromotionMaterialInfo o2)`，若 `o1.startTimeVal1 = o2.startTimeVal1`，则会出现
`compare(o1,o2) == compare(o2,o1)` 的情况，这违反了自反性质。从而导致代码抛出异常。


x=null; y=yFile; z=zFile

compare(x,y)==0; compare(x,z)==0;

但compare(y,z)不一定==0，不能保证sgn(compare(x, z))==sgn(compare(y, z))。

### 问题解决


1. 方法1：强制 JVM 使用老旧的 MergeSort，而非新的 TimSort。
(1) 可以在代码层面上进行声明

```java
System.setProperty("java.util.Arrays.useLegacyMergeSort", "true");
```

(2) 也可以在 JVM 的启动参数中声明

```s
-Djava.util.Arrays.useLegacyMergeSort=true
```


2. 方法2：修改代码，使得比较器 `Comparator` 满足新算法自反性、传递性、对称性的要求


```java
public class FixedPromotionMaterialInfoComparator implements Comparator<PromotionMaterialInfo> {
    @Override
    public int compare(PromotionMaterialInfo o1, PromotionMaterialInfo o2) {
        try{
            if(StringUtils.isNotBlank(o1.getSortNum()) && StringUtils.isNotBlank(o2.getSortNum())){
                
                ... 

                //return (int) (startTimeVal1 - startTimeVal2);
                return startTimeVal1.compareTo(startTimeVal2);  //修改为此语句
            }
            
            ...
        }catch (Exception e){
            log.error("FixedPromotionMaterialInfoComparator exception,o1:{},o2:{}",JsonUtil.write2JsonStr(o1),JsonUtil.write2JsonStr(o2));
        }
        return 0;
    }
}
```


其中 `compareTo()` 源码如下。



```java
    /**
     * Compares two {@code Long} objects numerically.
     *
     * @param   anotherLong   the {@code Long} to be compared.
     * @return  the value {@code 0} if this {@code Long} is
     *          equal to the argument {@code Long}; a value less than
     *          {@code 0} if this {@code Long} is numerically less
     *          than the argument {@code Long}; and a value greater
     *          than {@code 0} if this {@code Long} is numerically
     *           greater than the argument {@code Long} (signed
     *           comparison).
     * @since   1.2
     */
    public int compareTo(Long anotherLong) {
        return compare(this.value, anotherLong.value);
    }
    
    /**
     * Compares two {@code long} values numerically.
     * The value returned is identical to what would be returned by:
     * <pre>
     *    Long.valueOf(x).compareTo(Long.valueOf(y))
     * </pre>
     *
     * @param  x the first {@code long} to compare
     * @param  y the second {@code long} to compare
     * @return the value {@code 0} if {@code x == y};
     *         a value less than {@code 0} if {@code x < y}; and
     *         a value greater than {@code 0} if {@code x > y}
     * @since 1.7
     */
    public static int compare(long x, long y) {
        return (x < y) ? -1 : ((x == y) ? 0 : 1);
    }
```






-------------------------------------



## int[]和List<Integer>互转

* [ref-1](https://segmentfault.com/a/1190000038380668)
* [ref-2](https://blog.csdn.net/qq493820798/article/details/100894596)
* [ref-3](https://blog.csdn.net/ASDQWE09876/article/details/79271992)


```java
int[] intArr = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, };
```

* `int[] <-> List<Integer>`

```java
//int[] -> List<Integer> 
//方法1：java8及以上版本
List<Integer> integerList = Arrays.stream(intArr).boxed().collect(Collectors.toList());
//方法2：需要导入apache commons-lang3  jar 
List<Integer> integerList = Arrays.asList(ArrayUtils.toObject(intArr));

// List<Integer> -> int[]
//方法1：java8及以上版本
intArr = integerList.stream().mapToInt(Integer::intValue).toArray();
```

* `int[] <-> Integer[]`

```java
// int[] -> Integer[]
Integer[] integerArr = Arrays.stream(intArr).boxed().toArray(Integer[]::new);
// Integer[] -> int[]
intArr  = Arrays.stream(integerArr).mapToInt(Integer::valueOf).toArray();
Integer数组转List<Integer>集合 以及 List<Integer> 集合转Integer数组
```

* `Integer[] <-> List<Integer>`

```java
// Integer[] -> List<Integer>
integerList = Arrays.asList(integerArr);   //转换后的List 不支持增删 只能查改
integerList = new ArrayList<>(Arrays.asList(strArray)); // 转换后的List 支持增伤该查
// List<Integer> -> Integer[]
integerArr = integerList.toArray(new Integer[integerList.size()]);
```


### Java中转List的3种方式

#### Arrays.asList(arr)


```java
String[] strArray = {"a","b","c"};
List<String> list = Arrays.asList(strArray);
System.out.println(list);

Integer[] arr = {0,1,2,3};
List<Integer> list1 = Arrays.asList(arr);
System.out.println(list1);
```



使用 `Arrays.asList(arr)` 方式，将数组转换 List 后，不能对 List 增删，只能查改，否则会抛出异常。



```java
String[] strArray = {"a","b","c"};
List<String> list = Arrays.asList(strArray);
System.out.println(list);

//对转换后的list插入一条数据  会抛出异常 UnsupportedOperationException
list.add("1");

list.set(1,"d");  //可以改 但是不可以增删  
```

上述代码中，对 List 进行增操作，会抛出 `UnsupportedOperationException` 的异常。

```s
Exception in thread "main" java.lang.UnsupportedOperationException
	at java.util.AbstractList.add(AbstractList.java:148)
	at java.util.AbstractList.add(AbstractList.java:108)
	at com.lbs0912.java.demo.Solution.main(Solution.java:40)
```

* 异常原因分析

`Arrays.asList(strArray)` 返回值是 `java.util.Arrays` 类中一个私有静态内部类 `java.util.Arrays.ArrayList`，它并非 `java.util.ArrayList` 类。`java.util.Arrays.ArrayList` 类具有 `set()`，`get()`，`contains()` 等方法，但是不具有添加 `add()` 或删除 `remove()` 方法，所以调用 `add()` 方法会报错。


* 使用场景

`Arrays.asList(strArray)` 方式仅能用在将数组转换为 List 后，不需要增删其中的值，仅作为数据源读取使用。


此处需要注意的是，使用 `Arrays.asList()` 可以将 `Integer[]` 转化为 `List<Integer>`，但若涉及到装箱，则不可以，即不能将 `int[]` 转化为 `List<Integer>`



```java
int[] arr = {0,1,2,3};
List<Integer> list1 = Arrays.asList(arr);  //error 编译不通过
System.out.println(list1);
```

```s
java: 不兼容的类型: 推论变量T具有不兼容的限制范围
    等式约束条件: java.lang.Integer
    下限: int[]
```



#### new ArrayList<String>(Arrays.asList(strArray))

**在上述方法1的基础上，通过 ArrayList 的构造器，将 `Arrays.asList(strArray)` 的返回值由 `java.util.Arrays.ArrayList` 转为 `java.util.ArrayList`。**


```java
String[] strArray = new String[2];
List<String> list = new ArrayList<>(Arrays.asList(strArray));
list.add("1");
System.out.println(list); //[null, null, 1]
```

* 使用场景

需要在将数组转换为 List 后，对 List 进行增删改查操作，在 List 的数据量不大的情况下，可以使用。


#### 集合工具类Collections.addAll()【最高效】


通过 `Collections.addAll(arrayList, strArray)` 方式转换，根据数组的长度创建一个长度相同的 List，然后通过 `Collections.addAll()` 方法，将数组中的元素转为二进制，然后添加到 List 中，这是最高效的方法。



```java
String[] strArray = new String[2];
ArrayList< String> arrayList = new ArrayList<>(strArray.length);
Collections.addAll(arrayList, strArray);
arrayList.add("1");
System.out.println(arrayList);
```

* 使用场景

需要在将数组转换为 List 后，对 List 进行增删改查操作，在 List 的数据量巨大的情况下，优先使用，可以提高操作速度。




-------------------------------------







## String.format("%03d",intVal)

* [％02d％01d语法](https://www.codenong.com/3377688/)

使用 `String.format` 可以对字符串进行格式化，如 `String.format("%03d",str)`。`%03d` 语法在 `java.util.Formatter` 中给出。

通用语法如下。

```s
%[argument_index$][flags][width][.precision]conversion
```
`%03d` 执行十进制整数转换 `d`，格式为零填充(0标志)，宽度为3。因此，其值表示为 7 的 int 自变量将被格式化为 "007" 作为 String。





## 元祖

* [Java里的元祖](https://www.jianshu.com/p/41777d4a5096)



元组中的对象可是不同的类型，元素也可以具有任意长度。

```java
public class Tuple2<A, B> {
  public final A a1;
  public final B a2;
  public Tuple2(A a, B b) { a1 = a; a2 = b; }
}
```

可以利用继承来实现更长的元祖，如下代码所示。



```java
public class Tuple3<A, B, C> extends Tuple2<A, B> {
  public final C a3;
  public Tuple3(A a, B b, C c) {
    super(a, b);
    a3 = c;
  }
}

public class Tuple4<A, B, C, D>  extends Tuple3<A, B, C> {
  public final D a4;
  public Tuple4(A a, B b, C c, D d) {
    super(a, b, c);
    a4 = d;
  }
}
```

## protected default使用

* [Java 中 public default protected private区别 | CSDN](https://blog.csdn.net/xingchenhy/article/details/81223168)


| 修饰符 | 类内部 | 同一包 | 子类 | 任何地方 |
|--------|-------|---------|------|----------|
| private  | Yes |  |   |  |  | 
| default | Yes | Yesy |  | | 
| protected | Yes  | Yes | Yes | |
| public | Yes | Yes | Yes | Yes |


用隐私程度来表示各种修饰符的权限，即 `private` > `default` > `protected` >` public`。








## char转为int

* [Java中char 转化为int 的两种方法](https://blog.csdn.net/sxb0841901116/article/details/20623123)
* [Java 实例 char到int的转换](https://geek-docs.com/java/java-examples/char-to-int.html)


### 隐式转换->ASCII值


```java
char c1 = 'A';
char c2 = 'a';
char c3 = '9';
//隐式转换 转为对应的ASCII值
int val1 = c1;  //65
int val2 = c2;  //97
int val3 = c3;  //57
```

**需要强调的是，直接进行隐士转换，对于字符 '9'，转换后是对应的 ASCII 值，而不是数字 9。**




例如使用 `Integer.valueOf('9')`，得到的是 Integer 类型的 `57`，而不是 `9`。


`Integer.valueOf(int val)` 只负责将 `int` 转换为 `Integer`，传入的 `'9'` 会进行默认的隐式转换，转化为 `56`，再传给 `Integer.valueOf()`。



```java
    public static Integer valueOf(int i) {
        if (i >= IntegerCache.low && i <= IntegerCache.high)
            return IntegerCache.cache[i + (-IntegerCache.low)];
        return new Integer(i);
    }
```



### Character.getNumericValue -> 数值

* [Character.getNumericValue(..) in Java returns same number for upper and lower case characters | StackOv erflow](https://stackoverflow.com/questions/31888001/character-getnumericvalue-in-java-returns-same-number-for-upper-and-lower-ca)

```java
char c1 = 'A';
char c2 = 'a';
char c3 = '9';
    
int val1 = Character.getNumericValue(c1);  //10
int val2 = Character.getNumericValue(c2);  //10
int val3 = Character.getNumericValue(c2);  //9
```

需要注意的是，该方法对于字母 `A-Z`, `a-z` 以及全宽变体的数值，返回的结果都是在 [10.35] 范围内。

因此，对于大写字母 `A` 和小写字母 `a`，该方法的返回结果是一样的。






### Integer.parseInt() -> 数值



```java
char c1 = 'A';
char c2 = '9';

int val1 = Integer.parseInt(String.valueOf(c1));  //NumberFormatException
int val2 = Integer.parseInt(String.valueOf(c2));  //9
```

可以看到，使用 `Integer.parseInt()` 直接对于非数字的字符进行转换，会抛出 `NumberFormatException` 异常。为了保证代码健壮性，可以使用 `Character.isDigit()` 进行条件判断。

```java 
if(Character.isDigit(c1)){
    System.out.println(Integer.parseInt(String.valueOf(c1)));
}
```


### char - '0' -> 数值

```java
char c2 = '9';
if(Character.isDigit(c1)){
    int val  = c2 - '0';  // 9
}
```
              




## Set转换为List


将 Set 转换为 List，可以采用如下两种方式。


```java
Set<String> set = new HashSet<>();
List<String> list;

//方式1 直接new ArrayList转换
list = new ArrayList<>(set);


//方式2 采用stream
//如果值进行数据类型转换，不对数据进行操作（如filter等），IDEA中会提示使用方式1
list = set.stream().collect(Collectors.toList());
		
```


## TreeMap
* [使用TreeMap | Blog](https://www.liaoxuefeng.com/wiki/1252599548343744/1265117109276544)
* [Java TreeMap类](http://www.51gjie.com/java/674.html)

HashMap 是一种以空间换时间的映射表，它的实现原理决定了内部的 Key 是无序的，即遍历 HashMap 的 Key 时，其顺序是不可预测的（但每个Key都会遍历一次且仅遍历一次）。

还有一种 Map，它在内部会对 Key 进行排序，这种 Map 就是 `SortedMap`。**注意到SortedMap是接口，它的实现类是TreeMap。**


```s
       ┌───┐
       │ Map │
       └───┘
            ▲
    ┌────┴─────┐
    │          │
┌───────┐ ┌─────────┐
│ HashMap │ │SortedMap│
└───────┘ └─────────┘
               ▲
               │
          ┌─────────┐
          │ TreeMap │
          └─────────┘
```

`SortedMap` 保证遍历时以 Key 的顺序来进行排序。例如，放入的 Key 是 "apple"、"pear"、"orange"，遍历的顺序一定是 "apple"、"orange"、"pear"，因为String默认按字母排序。

```java
public class Main {
    public static void main(String[] args) {
        Map<String, Integer> map = new TreeMap<>();
        map.put("orange", 1);
        map.put("apple", 2);
        map.put("pear", 3);
        for (String key : map.keySet()) {
            System.out.println(key);
        }
        // apple, orange, pear
    }
}
```


使用 TreeMap 时，放入的 Key 必须实现 Comparable 接口。String、Integer 这些类已经实现了 Comparable 接口，因此可以直接作为 Key 使用。作为 Value 的对象则没有任何要求。

如果作为 Key 的 class 没有实现 Comparable 接口，那么，必须在创建 TreeMap 时同时指定一个自定义排序算法。


```java
public class Main {
    public static void main(String[] args) {
        Map<Person, Integer> map = new TreeMap<>(new Comparator<Person>() {
            public int compare(Person p1, Person p2) {
                return p1.name.compareTo(p2.name);
            }
        });
        map.put(new Person("Tom"), 1);
        map.put(new Person("Bob"), 2);
        map.put(new Person("Lily"), 3);
        for (Person key : map.keySet()) {
            System.out.println(key);
        }
        // {Person: Bob}, {Person: Lily}, {Person: Tom}
        System.out.println(map.get(new Person("Bob"))); // 2
    }
}

class Person {
    public String name;
    Person(String name) {
        this.name = name;
    }
    public String toString() {
        return "{Person: " + name + "}";
    }
}
```

注意到 Comparator 接口要求实现一个比较方法，它负责比较传入的两个元素 a 和 b，如果 `a<b`，则返回负数，通常是 -1，如果 `a==b`，则返回0，如果 `a>b`，则返回正数，通常是1。TreeMap 内部根据比较结果对 Key 进行排序。



### 小结

* `SortedMap` 在遍历时严格按照 Key 的顺序遍历，最常用的实现类是 TreeMap。
* 作为 SortedMap 的 Key 必须实现 Comparable 接口，或者传入 Comparator。
* 要严格按照 `compare()` 规范实现比较逻辑，否则，TreeMap 将不能正常工作。



## Collectors.toMap
* [Java8 中 List 转 Map(Collectors.toMap) 使用技巧](https://zhangzw.com/posts/20191205.html)
* [一次Collectors.toMap的问题 | Blog](https://www.jianshu.com/p/aeb21dea87e0)

### for循环完成List->Map

我们经常会用到 List 转 Map 操作，在过去我们可能使用的是 for 循环遍历的方式，如下所示。


```java
// 简单对象 
@Accessors(chain = true) // 链式方法 
@lombok.Data
class User {
    private String id;
    private String name;
}
```

```java
List<User> userList = Lists.newArrayList(
        new User().setId("A").setName("张三"),
        new User().setId("B").setName("李四"),
        new User().setId("C").setName("王五")
);
```

希望转成 Map 的格式为

```s
A-> 张三 
B-> 李四 
C-> 王五 
```

过去的做法（循环）

```java
Map<String, String> map = new HashMap<>();
for (User user : userList) {
    map.put(user.getId(), user.getName());
}
```


### 使用 Java8 特性

Java8 中新增了 Stream 特性，使得我们在处理集合操作时更方便了。

以上述例子为例，我们可以一句话搞定

```java
userList.stream().collect(Collectors.toMap(User::getId, User::getName));
```

当然，如果希望得到 Map 的 value 为对象本身时，可以这样写

```java
userList.stream().collect(Collectors.toMap(User::getId, t -> t));

//或
userList.stream().collect(Collectors.toMap(User::getId, Function.identity()));
```


### Collectors.toMap 方法

`Collectors.toMap` 有三个重载方法

```java
// 1
toMap(Function<? super T, ? extends K> keyMapper, Function<? super T, ? extends U> valueMapper);

// 2
toMap(Function<? super T, ? extends K> keyMapper, Function<? super T, ? extends U> valueMapper,
        BinaryOperator<U> mergeFunction);

// 3
toMap(Function<? super T, ? extends K> keyMapper, Function<? super T, ? extends U> valueMapper,
        BinaryOperator<U> mergeFunction, Supplier<M> mapSupplier);
```

参数含义分别是
* `keyMapper`：`Key` 的映射函数
* `valueMapper`：`Value` 的映射函数
* `mergeFunction`：当 `Key` 冲突时，调用的合并方法
* `mapSupplier`：Map 构造器，在需要返回特定的 Map 时使用


还是用上面的例子，如果 List 中 userId 有相同的，使用上面的写法会抛异常

```java
List<User> userList = Lists.newArrayList(
        new User().setId("A").setName("张三"),
        new User().setId("A").setName("李四"), // Key 相同 
        new User().setId("C").setName("王五")
);
userList.stream().collect(Collectors.toMap(User::getId, User::getName));

// 异常：
java.lang.IllegalStateException: Duplicate key 张三 
    at java.util.stream.Collectors.lambda$throwingMerger$114(Collectors.java:133)
    at java.util.HashMap.merge(HashMap.java:1245)
    at java.util.stream.Collectors.lambda$toMap$172(Collectors.java:1320)
    at java.util.stream.ReduceOps$3ReducingSink.accept(ReduceOps.java:169)
    at java.util.ArrayList$ArrayListSpliterator.forEachRemaining(ArrayList.java:1374)
    at java.util.stream.AbstractPipeline.copyInto(AbstractPipeline.java:481)
    at java.util.stream.AbstractPipeline.wrapAndCopyInto(AbstractPipeline.java:471)
    at java.util.stream.ReduceOps$ReduceOp.evaluateSequential(ReduceOps.java:708)
    at java.util.stream.AbstractPipeline.evaluate(AbstractPipeline.java:234)
    at java.util.stream.ReferencePipeline.collect(ReferencePipeline.java:499)
    at Test.toMap(Test.java:17)
    ...
```

这时就需要调用第二个重载方法，传入合并函数，如


```java
userList.stream().collect(Collectors.toMap(User::getId, User::getName, (n1, n2) -> n1 + n2));

// 输出结果：
A-> 张三李四 
C-> 王五
```


第四个参数（`mapSupplier`）用于自定义返回 Map 类型，比如我们希望返回的 Map 是根据 Key 排序的，可以使用如下写法

> `TreeMap`是一个有序的 `key-value` 集合，它是通过红黑树实现的，会根据其键（`key`）进行自然排序。

```java
List<User> userList = Lists.newArrayList(
        new User().setId("B").setName("张三"),
        new User().setId("A").setName("李四"),
        new User().setId("C").setName("王五")
);
userList.stream().collect(
    Collectors.toMap(User::getId, User::getName, (n1, n2) -> n1, TreeMap::new)
);

// 输出结果：
A-> 李四 
B-> 张三 
C-> 王五 
```


### Collectors.toMap 方法中Map中的key不能重复

在使用 `Collectors.toMap` 时候，Map中的 key 不能重复。如下示例，当有重复的 key，会抛出 `IllegalStateException` 状态异常。


```java
List<User> userList = Lists.newArrayList(
        new User().setId("A").setName("张三"),
        new User().setId("A").setName("李四"), // Key 相同 
        new User().setId("C").setName("王五")
);
userList.stream().collect(Collectors.toMap(User::getId, User::getName));

// 异常：
java.lang.IllegalStateException: Duplicate key 张三 
    at java.util.stream.Collectors.lambda$throwingMerger$114(Collectors.java:133)
    at java.util.HashMap.merge(HashMap.java:1245)
    at java.util.stream.Collectors.lambda$toMap$172(Collectors.java:1320)
    at java.util.stream.ReduceOps$3ReducingSink.accept(ReduceOps.java:169)
    at java.util.ArrayList$ArrayListSpliterator.forEachRemaining(ArrayList.java:1374)
    at java.util.stream.AbstractPipeline.copyInto(AbstractPipeline.java:481)
    at java.util.stream.AbstractPipeline.wrapAndCopyInto(AbstractPipeline.java:471)
    at java.util.stream.ReduceOps$ReduceOp.evaluateSequential(ReduceOps.java:708)
    at java.util.stream.AbstractPipeline.evaluate(AbstractPipeline.java:234)
    at java.util.stream.ReferencePipeline.collect(ReferencePipeline.java:499)
    at Test.toMap(Test.java:17)
    ...
```

查看其源码，可以发现


```java
public static <T, K, U> Collector<T, ?, Map<K,U>> toMap(Function<? super T, ? extends K> keyMapper,
                                Function<? super T, ? extends U> valueMapper) {
    return toMap(keyMapper, valueMapper, throwingMerger(), HashMap::new);
}
```

> If the mapped keys contains duplicates (according to Object#equals(Object)), an IllegalStateException is thrown when the collection operation is performed. If the mapped keys may have duplicates, use toMap(Function, Function, BinaryOperator) instead.


因此，若 Map 中有重复的 key，建议使用 `toMap(Function, Function, BinaryOperator)` 方法进行替换。


### Collectors.toMap 方法中Map中的value不能为null


在使用 `Collectors.toMap` 时候，Map中的 value 不能为null，否则会抛出 `NullPointerException` 异常，如下示例。


```java
User user1 = new User("A","张三");
User user2 = new User("D","李四");
User user3 = new User("C",null);  //value 为null

List<User> list = new ArrayList<>();
list.add(user1);
list.add(user2);
list.add(user3);

Map<String, String> map = list.stream().collect(Collectors.toMap(User::getId, User::getName, (n1, n2) -> n1, TreeMap::new));
System.out.println(map.keySet());
System.out.println(map.values());
```


```s
Exception in thread "main" java.lang.NullPointerException
	at java.util.Objects.requireNonNull(Objects.java:203)
	at java.util.Map.merge(Map.java:1172)
	at java.util.stream.Collectors.lambda$toMap$58(Collectors.java:1320)
	at java.util.stream.ReduceOps$3ReducingSink.accept(ReduceOps.java:169)
	at java.util.ArrayList$ArrayListSpliterator.forEachRemaining(ArrayList.java:1382)
	at java.util.stream.AbstractPipeline.copyInto(AbstractPipeline.java:481)
	at java.util.stream.AbstractPipeline.wrapAndCopyInto(AbstractPipeline.java:471)
	at java.util.stream.ReduceOps$ReduceOp.evaluateSequential(ReduceOps.java:708)
	at java.util.stream.AbstractPipeline.evaluate(AbstractPipeline.java:234)
	at java.util.stream.ReferencePipeline.collect(ReferencePipeline.java:499)
	at com.lbs0912.java.demo.Solution.main(Solution.java:30)
```

查看源码可以发现，`Collectors.toMap` 底层是基于 `Map.merge` 方法来实现的，而 `merge` 中 `value` 是不能为 `null` 的。如果为 `null`，就会抛出空指针异常。


> Collectors.toMap() internally uses Map.merge() to add mappings to the map. Map.merge() is spec'd not to allow null values, regardless of whether the underlying Map supports null values. This could probably use some clarification in the Collectors.toMap() specifications.




其解决方案为

1. 方案1：使用for循环或forEach

```java
Map<String, String> map1 = null;
list.forEach(user -> {
    map1.put(user.getId(),user.getName());
});
```

2. 使用 stream 的 `collect` 的重载方法

```java
Map<String, String> map1 = list.stream().collect(HashMap::new,(m,v)-> m.put(v.getId(),v.getName()),HashMap::putAll);   
```

## Function.identity()
* [Function.identity() | CSDN](https://blog.csdn.net/liyantianmin/article/details/89643443)
* [Java 8 lambdas, Function.identity() or t->t | StackOverflow](https://stackoverflow.com/questions/28032827/java-8-lambdas-function-identity-or-t-t)
* [Function.identity()的使用详解](https://evanwang.blog.csdn.net/article/details/103942253?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-1.no_search_link&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-1.no_search_link)







`Function` 是一个接口，那么 `Function.identity()` 是什么意思呢？

Java 8允许在接口中加入具体方法。接口中的具体方法有两种，default 方法和 static 方法，`identity()` 就是 `Function` 接口的一个静态方法。

**`Function.identity()` 返回一个输出跟输入一样的 `Lambda` 表达式对象，等价于形如 `t -> t` 形式的 Lambda 表达式。**

```java
static  Function identity() {
    return t -> t;
}
```


大多数情况下，`Function.identity()` 和 `t -> t` 是一样的，并且`Function.identity()` 代码更加简洁。


但有的时候，需要使用 `t -> t`，如下场景所示。

```java
List list = new ArrayList<>();
list.add(1);
list.add(2);

int[] arrayOK = list.stream().mapToInt(i -> i).toArray();

```

若使用 `Function.identity()` 则会报错。


```java
int[] arrayProblem = list.stream().mapToInt(Function.identity()).toArray();
```

这是因为 `mapToInt` 要求的参数是 `ToIntFunction` 类型，但是 `ToIntFunction` 类型和 `Function` 没有关系。



## url参数中出现+、空格、=、%、&、#等字符的解决办法

* [ref-url参数中出现+、空格、=、%、&、#等字符的解决办法](https://www.cnblogs.com/peterlu/p/3572283.html)



URL中的参数值中，若出现有 `+`，空格，`/`，`?`，`%`，`#`，`&`，`=` 等特殊符号，在服务端解析时可能无法解析到正确的参数值。

解决办法是，前端将这些字符进行转义，对照表如下。


| 符号 |   说明    |    转义字符 |
|-----|-----------|------------|
| + |   URL 中+号表示空格 | %2B  |  
|空格 | URL中的空格可以用+号或者编码   |  %20 |
| /  |  分隔目录和子目录   | %2F |    
| ?  |  分隔实际的URL和参数   |   %3F |    
| %  |  指定特殊字符   |  %25 |    
| #  |  表示书签    |  %23 |    
| &  |   URL 中指定的参数间的分隔符  |  %26 |   
| =  |  URL 中指定参数的值    |  %3D |





## Maps.newHashMap 和 new HashMap

* [ref-Maps.newHashMap 和 new HashMap | CSDN](https://blog.csdn.net/Wooooozh/article/details/82970225)


`Maps.newHashMap()` 和 `new HashMap()` 在底层是线上没有任何区别。



* `Map<String,Object> result = new HashMap<String,Object>();`

这种是 Java 原生 API 写法，需要手动指定泛型。

* `Map<String, Object> result = Maps.newHashMap()`;

这种是 Google 的 `guava.jar` 提供的写法，目的是为了简化代码，不需要手动写泛型。

```xml
<dependency>
	<groupId>com.google.guava</groupId>
	<artifactId>guava</artifactId>
	<version>${guava.version}</version>
</dependency>
```




## stream去重-distinct和filter
* [ref-stream去重-distinct和filter | 掘金](https://juejin.cn/post/6844903842132262926#heading-6)
* [ref-filter使用 | CSDN](https://blog.csdn.net/dnc8371/article/details/106701601)
* [ref-filter stream | Blog](https://www.liaoxuefeng.com/wiki/1252599548343744/1322402956967969)


Java 8 stream中，对元素进行去重，可以使用 `filter`，也可以使用 `disntinct`。


### distinct

`distinct()` 返回的是由该流中不同元素组成的流。`distinct()` 使用 `hashCode()` 和 `eqauls()` 方法来获取不同的元素。因此，需要去重的类必须实现 `hashCode()` 和 `equals()` 方法。换句话讲，我们可以通过重写定制的 `hashCode()` 和 `equals()` 方法来达到某些特殊需求的去重。


```java

  // String类已经覆写了 equals() 和 hashCode() 方法
  List<String> stringList = new ArrayList<String>() {{
    add("A");
    add("A");
    add("B");
    add("B");
    add("C");
  }};
  
  //去重
  stringList = stringList.stream().distinct().collect(Collectors.toList());
```





### filter

所谓 `filter()` 操作，就是对一个 `Stream` 的所有元素一一进行测试，不满足条件的就被 "滤掉" 了，剩下的满足条件的元素就构成了一个新的 Stream。

```java
 IntStream.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
                .filter(n -> n % 2 != 0)
                .forEach(System.out::println);
```

`filter()` 方法接收的对象是 `Predicate` 接口对象，它定义了一个 `test()` 方法，负责判断元素是否符合条件。

```java
@FunctionalInterface
public interface Predicate<T> {
    // 判断元素t是否符合条件:
    boolean test(T t);
}
```

`filter()` 除了常用于数值外，也可应用于任何 Java 对象。如下示例。

```java

public class Dish {
 
     private String name;
     private Boolean vegitarian; //是否素菜
     private Integer calaries;
     private Type type;
 
     public Dish(String name, Boolean vegitarian, Integer calaries, Type type) {
          super();
          this.name = name;
          this.vegitarian = vegitarian;
          this.calaries = calaries;
          this.type = type;
     }
 
     public Boolean getVegitarian() {
         return vegitarian;
     }
 
     public void setVegitarian(Boolean vegitarian) {
         this.vegitarian = vegitarian;
     }
 
     public Type getType() {
         return type;
     }
 
     public void setType(Type type) {
         this.type = type;
     }
 
     public enum Type { MEAT, FISH, OTHER };
}
```

如上菜肴 `Dish` 类，过滤出素菜类结果，可以采用下面的方法。


```java
List<Dish> menu = ....
List<Dish> vegitarianDishes = menu.stream()
                                    .filter(d -> d.getVegitarian())
									.collect(Collectors.toList());
								
//使用Lambda进一步简化
List<Dish> vegitarianDishes = menu.stream()
                                    .filter(Dish::getVegitarian)
                                    .collect(Collectors.toList());
```





## BeanUtils.copyProperties

### 参考资料
* [关于BeanUtils.copyProperties的用法和优缺点 | 华为云](https://www.huaweicloud.com/articles/2e5373ae8d09aca0135dd01199cd3566.html)
* [ref-Spring的BeanUtils采坑| CSDN](https://blog.csdn.net/lzp492782442/article/details/102957813?utm_medium=distribute.pc_relevant.none-task-blog-baidujs_title-0&spm=1001.2101.3001.4242)
* [BeanUtils引入不同的包的结果（坑） | CSDN](https://blog.csdn.net/bronzehammer/article/details/100917082)
* [ref-BeanUtils性能测试-1](https://cloud.tencent.com/developer/article/1445629)
* [ref-BeanUtils性能测试-2](https://dbwos.com/blog/note/useful-beanutils/)


### Java对象——PO,VO,DAO,BO,POJO

* [ref-java的几种对象-PO,VO,DAO,BO,POJO | CSDN](https://blog.csdn.net/bzhxuexi/article/details/8227808)

|  对象 |  释意   |   使用 |  备注 |
|------|--------|-------|--------|
| PO（persistant object） |  持久对象 | 可以看成是与数据库中的表相映射的Java对象，最简单的PO就是对应数据库中某个表中的一条记录。 | PO中应该不包含任何对数据库的操作 | 
| VO（view object）| 表现层对象 | 主要对应界面显示的数据对象。 | 对于一个WEB页面，或者SWT、SWING的一个界面，用一个VO对象对应整个界面的值。 | 
| BO（business object） |  业务对象 | 封装业务逻辑的 Java 对象 | 通过调用DAO方法，结合PO，VO进行业务操作。 | 
| POJO（plain ordinary java object） |  简单无规则Java对象 | POJO和其他对象不是一个层面上的对象划分，VO和PO应该都属于POJO |  POJO是最多变的对象，是一个中间对象。一个POJO持久化以后就是PO，直接用它传递、传递过程中就是DTO，直接用来对应表示层就是VO | 
| DAO（data access object) |  数据访问对象| 此对象用于访问数据库。| 通常和PO结合使用，DAO中包含了各种数据库的操作方法。通过它的方法，结合PO对数据库进行相关的操作。 | 
| DTO （data transfer object） | 数据传输对象 | 主要用于远程调用等需要大量传输对象的地方。| 比如我们一张表有100个字段，那么对应的PO就有100个属性。但是界面上只要显示10个字段，客户端用WEB service 来获取数据，没有必要把整个PO对象传递到客户端。这时就可以用只有这 10 个属性的 DTO 来传递结果到客户端，这样也不会暴露服务端表结构。到达客户端以后，如果用这个对象来对应界面显示，那此时它的身份就转为VO |



### Overview


在开发中，常使用 `BeanUtils.copyProperties()` 进行PO，VO，DTO等对象的复制和转换。

BeanUtils 提供对 Java 反射和自省 API 的包装。其主要目的是利用反射机制对 Java Bean 的属性进行处理，在这里只介绍它的 `copyProperties()` 方法。



需要注意的是


1. 使用 Spring 的 `BeanUtils # CopyProperties` 方法去拷贝对象属性时，需要对应的属性有 `getter` 和 `setter` 方法（内部实现时，使用反射拿到 `set` 和 `get` 方法，再去获取/设置属性值）；
2. 如果存在属性完全相同得内部类，但不是同一个内部类（即分别属于各自得内部类），则 Spring 会认为属性不同，不会Copy；
3. 泛型只在编译期起作用，不能依靠泛型来做运行期的限制；
4. Spring 和 Apache 的 `copy` 属性得方法源和目的参数得位置正好相反，所以导包和调用得时候需要注意。



### Method

```java
// Apache 将源对象中的值拷贝到目标对象 
// 注意，目标对象在前
public static void copyProperties(Object dest, Object orig) throws IllegalAccessException, InvocationTargetException {
    BeanUtilsBean.getInstance().copyProperties(dest, orig);
}
```

如果你有两个具有很多相同属性的 Java Bean，一个很常见的情况就是 Struts 里的 PO 对象（持久对象）和对应的 ActionForm。例如 Teacher 和 TeacherForm。我们一般会在 Action 里从 ActionForm 构造一个 PO 对象，传统的方式是使用类似下面的语句对属性逐个赋值。

```java
//得到TeacherForm   
TeacherForm teacherForm=(TeacherForm)form; 
//构造Teacher对象   
Teacher teacher=new Teacher(); 
//赋值   
teacher.setName(teacherForm.getName()); 
teacher.setAge(teacherForm.getAge()); 
teacher.setGender(teacherForm.getGender()); 
teacher.setMajor(teacherForm.getMajor()); 
teacher.setDepartment(teacherForm.getDepartment()); 
//持久化Teacher对象到数据库   
HibernateDAO.save(teacher);
```

而使用 BeanUtils 后，代码就大大改观了，如下所示

```java
//得到TeacherForm   
TeacherForm teacherForm=(TeacherForm)form;   
  
//构造Teacher对象   
Teacher teacher = new Teacher();   
  
//赋值   
BeanUtils.copyProperties(teacher,teacherForm);   
  
//持久化Teacher对象到数据库   
HibernateDAO.save(teacher);  
```



如果 Teacher 和 TeacherForm 间存在名称不相同的属性，则 BeanUtils 不对这些属性进行处理，需要程序员手动处理。例如 Teacher 包含 modifyDate（该属性记录最后修改日期，不需要用户在界面中输入）属性，而 TeacherForm 无此属性，那么在上面代码的 copyProperties() 后还要加上一句


```java
teacher.setModifyDate(new Date()); 
```

除 BeanUtils 外，还有一个名为 PropertyUtils 的工具类，它也提供 `copyProperties()` 方法，作用与 BeanUtils 的同名方法十分相似，主要的区别在于后者提供类型转换功能，即发现两个 Java Bean的同名属性为不同类型时，在支持的数据类型范围内进行转换，而前者不支持这个功能，但是速度会更快一些。BeanUtils 支持的转换类型如下


* java.lang.BigDecimal 
* java.lang.BigInteger 
* boolean and java.lang.Boolean 
* byte and java.lang.Byte 
* char and java.lang.Character 
* java.lang.Class 
* double and java.lang.Double 
* float and java.lang.Float 
* int and java.lang.Integer   
* long and java.lang.Long  
* short and java.lang.Short  
* java.lang.String 
* java.sql.Date   
* java.sql.Time 
* java.sql.Timestamp 



这里要注意一点，`java.util.Date` 是不被支持的，而它的子类 `java.sql.Date` 是被支持的。因此如果对象包含时间类型的属性，且希望被转换的时候，一定要使用 `java.sql.Date` 类型。否则在转换时会提示 `argument mistype` 异常。

### 优缺点 

```java
// Apache 将源对象中的值拷贝到目标对象 
// 注意，目标对象在前
public static void copyProperties(Object dest, Object orig) throws IllegalAccessException, InvocationTargetException {
    BeanUtilsBean.getInstance().copyProperties(dest, orig);
}

BeanUtils.copyProperties(destObject, origObjecr)  
```
上述方法的优点是可以简化代码。

缺点是使用 BeanUtils 的成本惊人地昂贵！BeanUtils 所花费的时间要超过取数据、将其复制到对应的 destObject 对象（通过手动调用 get 和 set 方法），以及通过串行化将其返回到远程的客户机的时间总和。所以要小心使用这种威力！



### 采坑

在使用时，需要注意如下几点

1. 使用 Spring 的 `BeanUtils # CopyProperties` 方法去拷贝对象属性时，需要对应的属性有 `getter` 和 `setter` 方法（内部实现时，使用反射拿到 `set` 和 `get` 方法，再去获取/设置属性值）；
2. 如果存在属性完全相同得内部类，但不是同一个内部类（即分别属于各自得内部类），则 Spring 会认为属性不同，不会Copy；
3. 泛型只在编译期起作用，不能依靠泛型来做运行期的限制；
4. Spring 和 Apache 的 `copy` 属性得方法源和目的参数得位置正好相反，所以导包和调用得时候需要注意。




#### 内部类的拷贝

如果存在属性完全相同得内部类，但不是同一个内部类（即分别属于各自得内部类），则 Spring 会认为属性不同，不会Copy。


下面给出例子进行验证。

```java
@Data
public class TestEntity{
    private Integer age;
    private String name;
    private Inner inner;
    
    @Data
    public static class Inner{
        private Integer a;
        public Inner(Integer a){
            this.a = a;
        }
    }
    
}
```

```java
@Data
public class TestVO{
    private Integer age;
    private String name;
    private Inner inner;
    

    @Data
    public static class Inner{
        private Integer a;
        public Inner(Integer a){
            this.a = a;
        }
    }

}
```

```java
public class Main{
    public static void main(String args[]){
        TestEntity entity = new TestEntity();
        entity.setAge(1);
        entity.setName("hehe");
        entity.setInner(new TestEntity.Inner(1));

        TestVO vo = new TestVO();
        BeanUtils.copyProperties(entity,vo);
        System.out.println(vo.toString());
        
    }   
}
```




执行代码，程序输入如下。可以看到，对象的 `inner` 是空的。

```s
TestVO(age=1, name=lbs, inner=null)
```

查看编译后的 `.class` 文件。可以看到，`TestEntity.java` 和 `TestVO.java` 里面的 `Inner` 在编译之后的 `class` 名字不一样（代表加载到虚拟机之后的地址不同），因此无法拷贝成功。

```s
// 编译后的 .class 文件
TestEntity$Inner.class
TestEntity.class

TestVO$Inner.class
TestVO.class
```


那么问题来了哈，我们怎样用才能让其拷贝成功呢？将代码修改如下。

```java
@Data
public class TestVO{
    private Integer age;
    private String name;
    private TestEntity.Inner inner;
}
```

仅仅是把 `Inner` 变为了 `TestEntity.Inner`，删掉了没引用得内部类 `Inner`，再次执行测试代码，然后运行结果如下

```java
TestVO(age=1, name=lbs, inner=TestEntity.Inner(a=1))
```

可以看到， `TestEntity` 对象里面的 `inner` 被成功拷贝过来。此时编译后的 `class` 文件也由4个变为了3个。



```s
// 编译后的 .class 文件
TestEntity$Inner.class
TestEntity.class
TestVO.class
```



#### Spring 和 Apache 的 copyProperties

Apache中，`org.apache.commons.beanutils.BeanUtils # copyProperties` 源码如下。


```java
// Apache 将源对象中的值拷贝到目标对象 
// 注意，目标对象在前
public static void copyProperties(Object dest, Object orig) throws IllegalAccessException, InvocationTargetException {
    BeanUtilsBean.getInstance().copyProperties(dest, orig);
}
```

默认情况下，使用 `org.apache.commons.beanutils.BeanUtils` 对复杂对象的复制是引用，这是一种**浅拷贝**。

由于 Apache 下的 BeanUtils 对象拷贝性能太差，不建议使用，而且在阿里巴巴 Java 开发规约插件上也明确指出

> Ali-Check | 避免用Apache Beanutils进行属性的copy。

`commons-beantutils` 对于对象拷贝加了很多的检验，包括类型的转换，甚至还会检验对象所属的类的可访问性,可谓相当复杂，这也造就了它的差劲的性能，具体实现代码如下。

```java
    public void copyProperties(final Object dest, final Object orig)
        throws IllegalAccessException, InvocationTargetException {

        // Validate existence of the specified beans
        if (dest == null) {
            throw new IllegalArgumentException
                    ("No destination bean specified");
        }
        if (orig == null) {
            throw new IllegalArgumentException("No origin bean specified");
        }
        if (log.isDebugEnabled()) {
            log.debug("BeanUtils.copyProperties(" + dest + ", " +
                      orig + ")");
        }

        // Copy the properties, converting as necessary
        if (orig instanceof DynaBean) {
            final DynaProperty[] origDescriptors =
                ((DynaBean) orig).getDynaClass().getDynaProperties();
            for (DynaProperty origDescriptor : origDescriptors) {
                final String name = origDescriptor.getName();
                // Need to check isReadable() for WrapDynaBean
                // (see Jira issue# BEANUTILS-61)
                if (getPropertyUtils().isReadable(orig, name) &&
                    getPropertyUtils().isWriteable(dest, name)) {
                    final Object value = ((DynaBean) orig).get(name);
                    copyProperty(dest, name, value);
                }
            }
        } else if (orig instanceof Map) {
            @SuppressWarnings("unchecked")
            final
            // Map properties are always of type <String, Object>
            Map<String, Object> propMap = (Map<String, Object>) orig;
            for (final Map.Entry<String, Object> entry : propMap.entrySet()) {
                final String name = entry.getKey();
                if (getPropertyUtils().isWriteable(dest, name)) {
                    copyProperty(dest, name, entry.getValue());
                }
            }
        } else /* if (orig is a standard JavaBean) */ {
            final PropertyDescriptor[] origDescriptors =
                getPropertyUtils().getPropertyDescriptors(orig);
            for (PropertyDescriptor origDescriptor : origDescriptors) {
                final String name = origDescriptor.getName();
                if ("class".equals(name)) {
                    continue; // No point in trying to set an object's class
                }
                if (getPropertyUtils().isReadable(orig, name) &&
                    getPropertyUtils().isWriteable(dest, name)) {
                    try {
                        final Object value =
                            getPropertyUtils().getSimpleProperty(orig, name);
                        copyProperty(dest, name, value);
                    } catch (final NoSuchMethodException e) {
                        // Should not happen
                    }
                }
            }
        }

    }
```


而 Spring 的 `copyProperties` 的使用如下。


```java
package org.springframework.beans;
// Spring 将源对象中的值拷贝到目标对象 
// 注意，目标对象在后。
public static void copyProperties(Object source, Object target) throws BeansException {
    copyProperties(source, target, null, (String[]) null);
}
```

**对比 Spring 和 Apache 的 `copyProperties` 方法，可以发现两者参数顺序不一样，在使用时一定要注意这个区别。**


```java
package org.apache.commons.beanutils.BeanUtils;
// Apache 将源对象中的值拷贝到目标对象 
// 注意，目标对象在前
public static void copyProperties(Object dest, Object orig) throws IllegalAccessException, InvocationTargetException {
    BeanUtilsBean.getInstance().copyProperties(dest, orig);
}
```


| 类别 |       所在的包  |            函数参数          | 性能 | 
|-----|----------------|-----------------------------|-----| 
| Apache | org.apache.commons.beanutils.BeanUtils  | copyProperties(Object dest, Object orig) | 较差 | 
| Spring | org.springframework.beans | copyProperties(Object source, Object target)| 较好 | 


Spring 下的 `BeanUtils # copyProperties` 方法实现比较简单，就是对两个对象中相同名字的属性进行简单的 `get/set`，仅检查属性的可访问性，因此具有较好的性能，优于 Apache 的 `copyProperties`。具体实现如下。


```java
    //Spring  中  copyProperties
    private static void copyProperties(Object source, Object target, @Nullable Class<?> editable,
			@Nullable String... ignoreProperties) throws BeansException {

		Assert.notNull(source, "Source must not be null");
		Assert.notNull(target, "Target must not be null");

		Class<?> actualEditable = target.getClass();
		if (editable != null) {
			if (!editable.isInstance(target)) {
				throw new IllegalArgumentException("Target class [" + target.getClass().getName() +
						"] not assignable to Editable class [" + editable.getName() + "]");
			}
			actualEditable = editable;
		}
		PropertyDescriptor[] targetPds = getPropertyDescriptors(actualEditable);
		List<String> ignoreList = (ignoreProperties != null ? Arrays.asList(ignoreProperties) : null);

		for (PropertyDescriptor targetPd : targetPds) {
			Method writeMethod = targetPd.getWriteMethod();
			if (writeMethod != null && (ignoreList == null || !ignoreList.contains(targetPd.getName()))) {
				PropertyDescriptor sourcePd = getPropertyDescriptor(source.getClass(), targetPd.getName());
				if (sourcePd != null) {
					Method readMethod = sourcePd.getReadMethod();
					if (readMethod != null &&
							ClassUtils.isAssignable(writeMethod.getParameterTypes()[0], readMethod.getReturnType())) {
						try {
							if (!Modifier.isPublic(readMethod.getDeclaringClass().getModifiers())) {
								readMethod.setAccessible(true);
							}
							Object value = readMethod.invoke(source);
							if (!Modifier.isPublic(writeMethod.getDeclaringClass().getModifiers())) {
								writeMethod.setAccessible(true);
							}
							writeMethod.invoke(target, value);
						}
						catch (Throwable ex) {
							throw new FatalBeanException(
									"Could not copy property '" + targetPd.getName() + "' from source to target", ex);
						}
					}
				}
			}
		}
	}
```

可以看到，成员变量赋值是基于目标对象的成员列表，但必须保证同名的两个成员变量类型相同。







#### 包装类型

在进行属性拷贝时，低版本的 Apache CommonsBeanUtils 为了解决 Date 为空的问题，会导致为目标对象的原始类型的包装类属性赋予初始值。如 Integer 属性默认赋值为 0，尽管你的来源对象该字段的值为 null。

这个在我们的包装类属性为 null 值时有特殊含义的场景，非常容易踩坑！例如搜索条件对象，一般 null 值表示该字段不做限制，而 0 表示该字段的值必须为0。

#### 改用其他工具时
如上一章节 「Spring 和 Apache 的 copyProperties」所讲，知道了 Apache CommonsBeanUtils 的性能较差后，要改用 Spring 的 BeanUtils 时，需要注意两者的参数顺序问题。记得将 `targetObject` 和 `sourceObject` 两个参数顺序对调。



### BeanUtils性能测试

* [ref-BeanUtils性能测试-1](https://cloud.tencent.com/developer/article/1445629)
* [ref-BeanUtils性能测试-2](https://dbwos.com/blog/note/useful-beanutils/)


参见上述参考链接1的测试结果，`Cglib` 的 `BeanCopier` 的拷贝速度是最快的，即使是百万次的拷贝也只需要 10 毫秒！ 相比而言，最差的是 Apache Commons 包的 `BeanUtils.copyProperties` 方法，100 次拷贝测试与表现最好的 Cglib 相差 400 倍之多。百万次拷贝更是出现了 2600 倍的性能差异！

| 实现 | 100 | 1000 | 10000 | 100000 | 1000000 | 
|------|------|------|------|------|------|
| StaticCglibBeanCopier | 0.053561 | 0.680016 | 1.196787 | 2.924973 | 10.769302 |
| CglibBeanCopier | 4.099259 | 12.252336 | 33.50937 | 48.940261 |104.005539 |
| SpringBeanUtils | 3.80229 | 9.268228 | 26.635362 | 118.699586 | 162.996875 |
| CommonPropertyUtils | 6.7971116 | 20.59255 | 49.380707 | 219.271803 | 1857.382452 |
| CommonBeanUtils | 23.566713 | 106.971358 | 473.95897 | 2619.76277 | 26199.132175 | 



--------------




--------------




## Java对象——PO,VO,DAO,BO,POJO

* [ref-java的几种对象-PO,VO,DAO,BO,POJO | CSDN](https://blog.csdn.net/bzhxuexi/article/details/8227808)

| 对象 | 释意 | 使用 | 备注 |
|------|--------|-------|--------|
| PO（persistant object） |  持久对象 | 可以看成是与数据库中的表相映射的Java对象，最简单的PO就是对应数据库中某个表中的一条记录。 | PO中应该不包含任何对数据库的操作 | 
| VO（view object）| 表现层对象 | 主要对应界面显示的数据对象。 | 对于一个WEB页面，或者SWT、SWING的一个界面，用一个VO对象对应整个界面的值。 | 
| BO（business object） |  业务对象 | 封装业务逻辑的 Java 对象 | 通过调用DAO方法，结合PO，VO进行业务操作。 | 
| POJO（plain ordinary java object） |  简单无规则Java对象 | POJO和其他对象不是一个层面上的对象划分，VO和PO应该都属于POJO |  POJO是最多变的对象，是一个中间对象。一个POJO持久化以后就是PO，直接用它传递、传递过程中就是DTO，直接用来对应表示层就是VO | 
| DAO（data access object) |  数据访问对象| 此对象用于访问数据库。| 通常和PO结合使用，DAO中包含了各种数据库的操作方法。通过它的方法，结合PO对数据库进行相关的操作。 | 
| DTO （data transfer object） | 数据传输对象 | 主要用于远程调用等需要大量传输对象的地方。| 比如我们一张表有100个字段，那么对应的PO就有100个属性。但是界面上只要显示10个字段，客户端用WEB service 来获取数据，没有必要把整个PO对象传递到客户端。这时就可以用只有这 10 个属性的 DTO 来传递结果到客户端，这样也不会暴露服务端表结构。到达客户端以后，如果用这个对象来对应界面显示，那此时它的身份就转为VO |



## 移除对象中值为null的属性


```java
    public static void main(String[] args) {
        Map<String, Object> map = new HashMap<>();
        map.put("age",1992);
        map.put("name","lbs");
        map.put("sex",null);
        System.out.println(map.values()); //[null, lbs, 1992]
        Map<String, Object> targetMap = new HashMap<>();
        safePutAll(targetMap,map);
        System.out.println(map.values()); //[lbs, 1992] 源map也会被改变
        System.out.println(targetMap.values()); //[lbs, 1992]
    }

    /**
     * 移除sourceMap中值为null的属性 并赋值到targetMap
     * @param targetMap 目标map
     * @param sourceMap 源map
     */
    public static void safePutAll(Map<String, Object> targetMap, Map<String, Object> sourceMap) {
        sourceMap.values().removeAll(Collections.singleton(null));
        targetMap.putAll(sourceMap);
    }
```



## Java 数值不使用包含E的科学计数法
* ref-https://blog.csdn.net/mbh12333/article/details/89573822


```java
//方式A：
double num=8.2347983984297E7;
String str=new BigDecimal(num+"").toString();

//方式B：
Double num=8.2347983984297E7;
String str=new BigDecimal(num.toString()).toString();
```


注意使用 `new BigDecimal()` 排除科学计数法格式，如下为一个价格格式化的实用工具。


```java
/**
	 * 应产品经理赵树杰要求，规范前端价格显示要求，修改价格显示格式，并做四舍五入计算
	 * @param object 例如：<p>110.01-->110.01;<p>100.10-->100.1;<p>100.00-->100;<p>100-->100
	 */
	public static String formatPrice(Object object) {
		String price = EasyUtils.toString(object);
		if(StringUtils.isEmpty(price)) {
			return "";
		}
		
		try {
			BigDecimal bigDecimalPrice = new BigDecimal(price);
			price = bigDecimalPrice.setScale(2, BigDecimal.ROUND_HALF_UP).toString();
			while(price.contains(".") && price.endsWith("0")) {
				price = price.substring(0, price.length() - 1);
			}
			if(price.endsWith(".")) {
				return price.substring(0, price.length() - 1);
			}
		} catch (Exception e) {
			log.error("格式化价格异常，异常object：" + object, e);
		}
		return price;
	}
```

--------------






## List<Integer>转化为int[]


* [Java中List-Integer-int的相互转换](https://www.cnblogs.com/a-du/p/10682869.html)

将 `List<Integer>` 转换为 `int[]` 的方法如下。

```java
list.stream().mapToInt(Integer::valueOf).toArray();
```

## str.split("\\.") 转义

* [java中split(regex)使用中要注意的问题:正则表达式](https://www.cnblogs.com/wuyida/p/6300973.html)

```java

String res = "a.b.c";
String[] arr = res.split(".");
System.out.println(arr.length); //0 转换失败
```


`split(String regex)` 接收一个正则表达式作为入参。若传入 `.`，因为 `.` 在正则表达式中有特殊意义，因此，需要进行转义，否则会匹配失败。


```java

String res = "a.b.c";
String[] arr = res.split("\\.");
System.out.println(arr.length); // 3
```




## ImmutableMap


* [Java ImmutableMap使用 | CSDN](https://blog.csdn.net/wantsToBeASinger/article/details/84997362)


Java 中的 `Immutable` 是一个不可变的对象，位于 `com.google.common.collect.ImmutableMap` 包中。其用法如下

1. 创建 ImmutableMap

```java
Map<String,Object> immutableMap = new ImmutableMap.Builder<String,Object>().build();

//因为ImmutableMap在创建后不可变，所以创建时候不赋值的使用场景很少。主要使用下面的场景2，创建时候放值
```

2. 在创建时放值，下面2种方式均可

```java
//方式1
Map<String,Object> immutableMap = new ImmutableMap.Builder<String,Object>()
    .put("k1","v1")
    .put("k2","v2")
    .build();

//方式2
Map<String,Object> immutableMap = ImmutableMap.<String,Object>builder()
    .put("k1","v1")
    .put("k2","v2")
    .build();
```


3. ImmutableMap 创建后不可变

```java
immutableMap.put("k1","v3");//会抛出java.lang.UnsupportedOperationException
```

4. ImmutableMap 中 `key` 和 `value` 均不能为 `null`，放入 `null` 值会抛出 NPE


综上，ImmutableMap 的使用场景
* 适合确定性的配置, 比如根据不同的 `key` 值得到不同的请求 `url`
* 不适合 `key`, `value` 为未知参数的场景
 



```java

private static finalMap<String, String> unitMap;

static{
    unitMap = new HashMap<>();
    unitMap.put("1", "个");
    unitMap.put("2", "盒");
}
```



-----------------------------




## List和Set互转
* [Java Array、List、Set互相转化](https://blog.csdn.net/u014532901/article/details/78820124)

因为 List 和 Set 都实现了 Collection 接口，实现了 `addAll(Collection<? extends E> c);` 方法，因此可以采用 `addAll()` 方法将 List 和Set 互相转换。

另外，List 和 Set 也提供了 `Collection<? extends E> c` 作为参数的构造函数，因此通常采用构造函数的形式完成互相转化。

```java
//List转Set
Set<String> set = new HashSet<>(list);
System.out.println("set: " + set);
//Set转List
List<String> list_1 = new ArrayList<>(set);
System.out.println("list_1: " + list_1);
```

和 `toArray()` 一样，被转换的 `List(Set)` 的修改不会对被转化后的 `Set（List）` 造成影响。





## <![CDATA[]]>
* [mybatis 中的<![CDATA[ ]]>标签用法](https://www.jianshu.com/p/49f885672adc)
* [mybatis中特殊字符转义-CDATA](https://blog.csdn.net/qq_37192800/article/details/80645499)
* [mybatis中﹤![CDATA[ ]]> 的使用](https://segmentfault.com/q/1010000006251069)

XML 文件会在解析 XML 时，会将 5 种特殊字符进行转义，分别是
* `&`
* `<`
* `>`
* `"`
* `'`

若不希望语法被转义，就需要进行特别处理。有 2 种解决方法
1. 方法1：使用 `<![CDATA[ ]]>` 标签来包含字符
2. 方法2：使用 XML 转义序列来表示这些字符。

| 特殊字符  |   转义序列  |
|----------|-----------|
|    `<`     |    `&lt;` | 
|     `>`    |   `&gt;`    | 
|     `&`    |    `&amp;`  | 
|     `"`    |    `&quot;` | 
|    `'`     |    `&apos;` | 



例如，如下SQL查询

```s
<select id="userInfo" parameterType="java.util.HashMap" resultMap="user">   
     SELECT id,newTitle, newsDay FROM newsTable WHERE 1=1  
     AND  newsday <![CDATA[>=]]> #{startTime}
     AND newsday <![CDATA[<= ]]>#{endTime}  
  ]]>  
 </select>  
```


```xml
<isNotEmpty prepend="and" property="lasttime">
(<![CDATA[a.modified >= #lasttime#]]>or<![CDATA[i.modified >= #lasttime#]]>)
</isNotEmpty>
```

在 CDATA 内部的所有内容都会被解析器忽略，保持原貌。所以在 Mybatis 配置文件中，要尽量缩小 `<![CDATA[ ]]>` 的作用范围，来避免 `<if test=""> </if> <where> </where>` 等 SQL 标签无法解析的问题。

上述 SQL 也可以写成如下

```sql
<select id="userInfo" parameterType="java.util.HashMap" resultMap="user">   
     SELECT id,newTitle, newsDay FROM newsTable WHERE 1=1  
     AND  newsday &gt; #{startTime}
     AND  newsday &gt; #{endTime}  
 </select> 
```

推荐使用 `<![CDATA[ ]]>`，清晰，简洁。





## 遇到多个构造器参数时要考虑使用Builder构建器
* ref-《Effective Java》书籍-第2点 - `遇到多个构造器参数时要考虑使用构建器`
* [优雅地创建复杂对象 —— Builder 模式](https://blog.csdn.net/justloveyou_/article/details/78298420)
* [详解Lombok中的@Builder用法](https://www.jianshu.com/p/d08e255312f9)

> `Builder` 使用创建者模式又叫建造者模式。简单来说，就是一步步创建一个对象，它对用户屏蔽了里面构建的细节，但却可以精细地控制对象的构造过程。

### Builder使用
使用 `Builder` 模式创建复杂对象时，不直接生成想要的对象，而是让客户端利用所有必要的参数构造一个 `Builder`对象，然后在此基础上，调用类似于`Setter` 的方法来设置每个可选参数，最后通过调用无参的 `build()` 方法来生成不可变对象。一般情况下，**所属 `Builder` 是它所构建类的静态成员类，即开发者只需要定义一个静态公共的内部类**。


```java
public class User {
    private Integer id;
    private String name;
    private String address;

    private User() {
    }

    private User(User origin) {
        this.id = origin.id;
        this.name = origin.name;
        this.address = origin.address;
    }

    public static class Builder { //静态内部类
        private User target;

        public Builder() {
            this.target = new User();
        }

        public Builder id(Integer id) {
            target.id = id;
            return this;
        }

        public Builder name(String name) {
            target.name = name;
            return this;
        }

        public Builder address(String address) {
            target.address = address;
            return this;
        }

        public User build() {
            return new User(target);
        }
    }

```

创建对象时方法如下。


```java
UserExample userExample = UserExample.builder()
                .id(1)
                .name("aaa")
                .address("bbb")
                .build();

System.out.println(userExample);
```


### Lombok中的@Builder

`@Builder` 注解为你的类生成构建器API。

`@Builder` 内部帮我们做了什么？
* 创建一个名为 `ThisClassBuilder` 的内部静态类，并具有和实体类形同的属性（称为构建器）。
* 在构建器中：对于目标类中的所有的属性和未初始化的 `final` 字段，都会在构建器中创建对应属性。=
* 在构建器中：创建一个无参的 `default` 构造函数。
* 在构建器中：对于实体类中的每个参数，都会对应创建类似于 `setter` 的方法，只不过方法名与该参数名相同。 并且返回值是构建器本身（便于链式调用），如上例所示。
* 在构建器中：一个 `build()` 方法，调用此方法，就会根据设置的值进行创建实体对象。
* 在构建器中：同时也会生成一个 `toString()` 方法。
* 在实体类中：会创建一个 `builder()` 方法，它的目的是用来创建构建器。

下面给出一个示例。

```java
@Builder
public class User {
    private final Integer code = 200;
    private String username;
    private String password;
}
```

上述代码编译后如下。

```java
// 编译后：
public class User {
    private String username;
    private String password;
    User(String username, String password) {
        this.username = username; this.password = password;
    }
    public static User.UserBuilder builder() {
        return new User.UserBuilder();
    }

    public static class UserBuilder {
        private String username;
        private String password;
        UserBuilder() {}

        public User.UserBuilder username(String username) {
            this.username = username;
            return this;
        }
        public User.UserBuilder password(String password) {
            this.password = password;
            return this;
        }
        public User build() {
            return new User(this.username, this.password);
        }
        public String toString() {
            return "User.UserBuilder(username=" + this.username + ", password=" + this.password + ")";
        }
    }
}
```

在创建对象时，可采用如下方法

```java
User.builder()
    .username("lbs")
    .password("0912")
    .build();
```



## TypeReference
* [Java 为什么使用TypeReference](https://www.cnblogs.com/kaituorensheng/p/9804097.html)


对于如下代码，泛型参数 `T hi` 作为入参，使用反射获取其属性值。 

```java
    /**
     * 根据站点和推荐位 获取通用唯一识别码
     * 1）京东到家小程序站点推荐位 -> openId
     * 2) 手Q/微信小程序站点 & 特定推荐位 -> openId
     * 3）other -> uuId
     * @param hi hi
     * @param userInfo 用户信息
     * @param p 推荐位
     * @param <T> 泛型
     * @return String
     */
    private <T> String getUuidOrOpenIdByMcChannel(T hi,UserInfo userInfo,String p){
        String uuId = "";
        if(JDDJ_MICRO_PROGRAM_BI_TYPES.contains(p)){ //京东到家小程序站点推荐位
            uuId = userInfo.getOpen_id();
        } else if(COMPATIBLE_OPEN_ID_BI_TYPES.contains(p)){ //兼容openId的推荐位
            try{
                Field field = hi.getClass().getDeclaredField("ci");
                field.setAccessible(true);
                String ci = EasyUtils.toString(field.get(hi));
                //手Q/微信小程序站点
                boolean mpChannel = McChannelEnum.WE_CHAT.getValue() == EasyUtils.parseInt(ci) || McChannelEnum.Mobile_QQ.getValue() == EasyUtils.parseInt(ci);
                uuId = mpChannel ? userInfo.getOpen_id():userInfo.getUuid();
            } catch (Exception e){
                log.error("getUuidOrOpenIdByMcChannel exception",e);
            }
        }
        if(StringUtil.isBlank(uuId)){ //openId为空 兜底uuId
            uuId = userInfo.getUuid();
        }
        return uuId;
    }
```



```java
// case 1
BiHi hi = new BiHi();


// case 2
BiSkuHi hi = new BiSkuHi();
```

```java
public class BiHi {

    private List<Did> dids;
    private Filter filter;
    private String ci;//channel id 渠道id（app:0 pc:1 微信:2 手Q:3 m页:4）
    private String pi;//页面id


    public BiHi() {}
    // ...
}
```


对于上述使用反射解析 `hi` 参数，仅仅适用于 `hi` 为一个类且类属性有 `ci` 值的情况，如上 case 1 和 case 2所示。



但是如果 `hi` 是个 Map（如下 case 3 所示），则上述反射解析会失败。报错 `ERROR - service.impl.BiSortServiceImpl - getUuidOrOpenIdByMcChannel exception`。




```java
// case 3 generate hi map
Map<String,Object> hiMap = buildHi();
```


这个时候，可以使用 `TypeReference` 指定反序列化的类型，代码如下。


```java
import org.codehaus.jackson.type.TypeReference;

    /**
     * 根据站点和推荐位 获取通用唯一识别码
     * 1）京东到家小程序站点推荐位 -> openId
     * 2) 手Q/微信小程序站点 & 特定推荐位 -> openId
     * 3）other -> uuId
     * @param hi hi
     * @param userInfo 用户信息
     * @param p 推荐位
     * @param <T> 泛型
     * @return String
     */
    private <T> String getUuidOrOpenIdByMcChannel(T hi,UserInfo userInfo,String p){
        String uuId = "";
        if(JDDJ_MICRO_PROGRAM_BI_TYPES.contains(p)){ //京东到家小程序站点推荐位
            uuId = userInfo.getOpen_id();
        } else if(COMPATIBLE_OPEN_ID_BI_TYPES.contains(p)){ //兼容openId的推荐位
            try{
                Map<String,Object> hiMap = JsonUtils.fromJson(JsonUtil.write2JsonStr(hi), new TypeReference<Map<String, Object>>() {});
                if(MapUtils.isNotEmpty(hiMap) && hiMap.containsKey("ci")){
                    int ci = EasyUtils.parseInt(hiMap.get("ci"));
                    //手Q/微信小程序站点
                    boolean mpChannel = McChannelEnum.WE_CHAT.getValue() == ci || McChannelEnum.Mobile_QQ.getValue() == ci;
                    uuId = mpChannel ? userInfo.getOpen_id():userInfo.getUuid();
                }
            } catch (Exception e){
                log.error("getUuidOrOpenIdByMcChannel exception",e);
            }
        }
        if(StringUtil.isBlank(uuId)){ //openId为空 兜底uuId
            uuId = userInfo.getUuid();
        }
        return uuId;
    }
```





## Java枚举类比静态常量占用更多的内存

Ref
* [Java枚举类比静态常量占用更多的内存 | CSDN](https://blog.csdn.net/xiao_nian/article/details/80002101)
* [Java 枚举会比静态常量更消耗内存吗？](https://www.zhihu.com/question/48707169)


Java中，枚举类比静态常量占用更多的内存，具体原因分析参见上述参考链接。

> Android开发文档中指出，使用枚举会比使用静态变量多消耗两倍的内存。


对于我们定义的枚举，编译器会将其转换成一个类，这个类继承自 `java.lang.Enum` 类，除此之外，编译器还会帮我们生成多个枚举类的实例，赋值给我们定义的枚举类型常量，并且还声明了一个枚举对象的数组，保存了所有的枚举对象。因此，枚举类会比静态常亮占用更多的内存。

但是使用枚举类的代码可维护性较好，可以针对具体实际情况，采用枚举类或者静态常量。



## IDEA-Dependency Analysis
* [IDEA-Dependency Analysis 使用](https://blog.csdn.net/daerzei/article/details/82344569)


找到对应的依赖，鼠标单击 `Exclude`，可以排除冲突的依赖。

```xml
	  <dependency>
		  <groupId>org.springframework.data</groupId>
		  <artifactId>spring-data-elasticsearch</artifactId>
		  <version>2.0.2.RELEASE</version>
		  <exclusions>
			  <exclusion>
				  <artifactId>guava</artifactId>
				  <groupId>com.google.guava</groupId>
			  </exclusion>
			  <exclusion>
			  <groupId>org.springframework</groupId>
				  <artifactId>spring-beans</artifactId>
			  </exclusion>
		  </exclusions>
	  </dependency>
```




## 枚举类使用equal和==
* [java 枚举类比较是用==还是equals](https://blog.csdn.net/qq_27093465/article/details/70237349)


一般只对简单数据类型和字符 `char` 使用 `==` 进行相等判断，对于枚举类应该使用 `equals()` 进行判断相等。

但是使用 `==` 可以得到相同的结果。这是因为 `Enum` 内部实现的 `equals()` 方法中也是通过 `==` 实现的。


```java
//Enum.class

    /**
     * Returns true if the specified object is equal to this
     * enum constant.
     *
     * @param other the object to be compared for equality with this object.
     * @return  true if the specified object is equal to this
     *          enum constant.
     */
    public final boolean equals(Object other) {
        return this==other;
    }
```



## String.split()

* [String.split() 方法介绍](https://www.runoob.com/java/java-string-split.html)

1. 对于字符串，可以调用其 `split()` 方法，按照传入的正则表达式，对字符串进行分割，返回值类型为一个字符串型数组 `String[]`。方法参数如下。

```java
public String[] split(String regex) {
    return split(regex, 0);
}

public String[] split(String regex, int limit);
```

2. 对于入参中的 `limit`，表示正则匹配应用的个数，对于目标字符串，会应用 `limit - 1` 次正则匹配，下面给出示例进行说明。对于字符串 `"boo:and:foo"`, 正则表达式为 `:`，当 `limit` 传不同的值，，返回结果如下。
* limit=2，返回 `{ "boo", "and:foo" }`
* limit=5，返回 `{ "boo", "and", "foo" }`
* limit=-2，返回 `{ "boo", "and", "foo" }`



3. 当 `limit > 0` 时，会应用 `limit - 1` 次正则匹配。若 `limit <= 0`，则会对字符串全部应用应用正则匹配（不限制次数）。因此，上述示例中，`limit = -2` 和 `limit = 5` 的返回结果相同。


4. 若正则匹配无相符的，则返回整个原字符串。

```java
    String str = "abccd";
    String[] arr = str.split("o");
    System.out.println(JsonUtil.write2JsonStr(arr)); // "abccd"
```


5. 此处给出一个常用例子，将一句英文语句分割成具体的单次，即按照空格进行分割。

```java
    String str = "SADA Systems uses cookies to improve your website experience";
    String[] arr = str.split(" ");
    System.out.println(JsonUtil.write2JsonStr(arr));  
    // ["SADA","Systems","uses","cookies","to","improve","your","website","experience"]
```

可以直接使用空格作为正则表达式，即 `str.split(" ")`（只能匹配单次之间一个空格符的情况），也可以使用 `str.split("\\s+")`（可以匹配单次之间多个空格符的情况）。


> 转义字符 `\s` 表示匹配空白符，包括换行。
>
> 转义字符 `\S` 表示非空白符，不包括换行。
> 
> 对于该转义字符，前面需要加 `\\`。`+` 表示匹配1次或多次。 -- [正则表达式 | 菜鸟教程](https://www.runoob.com/regexp/regexp-syntax.html)


转义字符 `\S` 表示非空白符，不包括换行。如果使用该匹配，返回如下。


```java
    String str = "SADA Systems uses cookies to improve your website experience";
    String[] arr = str.split(" ");
    System.out.println(JsonUtil.write2JsonStr(arr));  
    // [""," "," "," "," "," "," "," "," "]
```


## 字符串翻转

Java 中字符串 `String` 是不可变的，因此对字符串反转，需要借助  `StringBuilder`，代码如下。

```java
String str2 = new StringBuilder(str1).reverse().toString();
```

## String.join()

* [ref-Java String join方法](https://geek-docs.com/java/java-string/java-string-join.html)


`String.join()` 方法源码如下。


```java
    /**
     * Returns a new String composed of copies of the
     * {@code CharSequence elements} joined together with a copy of
     * the specified {@code delimiter}.
     *
     * <blockquote>For example,
     * <pre>{@code
     *     String message = String.join("-", "Java", "is", "cool");
     *     // message returned is: "Java-is-cool"
     * }</pre></blockquote>
     *
     * Note that if an element is null, then {@code "null"} is added.
     *
     * @param  delimiter the delimiter that separates each element
     * @param  elements the elements to join together.
     *
     * @return a new {@code String} that is composed of the {@code elements}
     *         separated by the {@code delimiter}
     *
     * @throws NullPointerException If {@code delimiter} or {@code elements}
     *         is {@code null}
     *
     * @see java.util.StringJoiner
     * @since 1.8
     */
    public static String join(CharSequence delimiter, CharSequence... elements) {
        Objects.requireNonNull(delimiter);
        Objects.requireNonNull(elements);
        // Number of elements not likely worth Arrays.stream overhead.
        StringJoiner joiner = new StringJoiner(delimiter);
        for (CharSequence cs: elements) {
            joiner.add(cs);
        }
        return joiner.toString();
    }
```

`String.join()` 方法的使用示例如下。


```java
String message = String.join("-", "This", "is", "a", "String");
// message returned is: "This-is-a-String"


//Converting an array of String to the list
List list<String> = Arrays.asList("Steve", "Rick", "Peter", "Abbey");
String names = String.join(" | ", list);
System.out.println(names);  //Steve | Rick | Peter | Abbey


//将数组连接为字符串
String[] arr = {"a","bc","d"};
String str = String.join("", arr);  //"abcd"
```


## Enum在Switch中的使用

* [Java枚举类在switch中的总结-Constant expression required和An enum switch case label must be the unqualif..](https://www.codeleading.com/article/37352591956/)
* [enum和switch case结合使用](https://blog.csdn.net/qq_26287435/article/details/80309786?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.control&dist_request_id=df82358e-4a61-4e48-9098-94d88f2e8cea&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.control)



开发中遇到，在 Switch 语句中使用枚举类的情况，代码如下。


```java
import lombok.Getter;

@Getter
public enum FindChannelForceTypeEnum {
    /**
     * 发现频道 穿插类型
     */
    STRONG_INSERT_TYPE("1", "强穿插类型"),
    MIXED_INSERT_TYPE("2", "混合穿插类型"),
    FORCE_INSERT_TYPE("3", "强制穿插类型"),
    DT_SINGLE_INSERT_TYPE("4", "定投-单坑穿插类型"),
    DT_CIRCLE_INSERT_TYPE("5", "定投-循环穿插类型"),
    UNKNOWN_INSERT_TYPE("-1", "未知类型");

    /**
     * 穿插类型值
     */
    private final String code;
    /**
     * 描述
     */
    private final String desc;

    FindChannelForceTypeEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }
}
```


### Constant expression required


针对如下代码，会编译提示 `Constant expression required`。可以看到，`case` 的值，需要为常量，需要在编译时候就明确值，而 `getCode()` 导致了只有运行时才真正知道值的多少。


```java
for(PromotionMaterialInfo info: infoList){
    switch (EasyUtils.toString(info.getForceType())){
	    case FindChannelForceTypeEnum.DT_SINGLE_INSERT_TYPE.getCode():
			singleFixedList.add(info);
			break;
		case FindChannelForceTypeEnum.DT_CIRCLE_INSERT_TYPE.getCode():
			circleFixedList.add(info);
			break;
		default:
			otherFixedList.add(info);
	}
	// ...
}
```



针对此错误，可以对代码进行如下修改，在枚举类 `FindChannelForceTypeEnum` 中提供一个 `getEnumByCode()` 方法，来将值转换为枚举值。



```java

import lombok.Getter;

@Getter
public enum FindChannelForceTypeEnum {
    /**
     * 发现频道 穿插类型
     */
    STRONG_INSERT_TYPE("1", "强穿插类型"),
    MIXED_INSERT_TYPE("2", "混合穿插类型"),
    FORCE_INSERT_TYPE("3", "强制穿插类型"),
    DT_SINGLE_INSERT_TYPE("4", "定投-单坑穿插类型"),
    DT_CIRCLE_INSERT_TYPE("5", "定投-循环穿插类型"),
    UNKNOWN_INSERT_TYPE("-1", "未知类型");

    /**
     * 穿插类型值
     */
    private final String code;
    /**
     * 描述
     */
    private final String desc;

    FindChannelForceTypeEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }


    public static FindChannelForceTypeEnum getEnumByCode(String code) {
        if(null == code){
            return FindChannelForceTypeEnum.UNKNOWN_INSERT_TYPE;
        }
        for (FindChannelForceTypeEnum typeEnum : FindChannelForceTypeEnum.values()){
            if(typeEnum.getCode().equals(code)){
                return typeEnum;
            }
        }
        return FindChannelForceTypeEnum.UNKNOWN_INSERT_TYPE;
    }

}
```

此时，对应代码修改为

```java
for(PromotionMaterialInfo info: infoList){
	switch (FindChannelForceTypeEnum.getEnumByCode(EasyUtils.toString(info.getForceType()))){
		case FindChannelForceTypeEnum.DT_SINGLE_INSERT_TYPE:
			singleFixedList.add(info);
			break;
	    case FindChannelForceTypeEnum.DT_CIRCLE_INSERT_TYPE:
			circleFixedList.add(info);
		    break;
		default:
			otherFixedList.add(info);
	}
}
```

上述代码依旧会报错，`An enum switch case label must be the unqualified name of an enumeration constant`。


### An enum switch case label must be the unqualified name of an enumeration constant


针对 `An enum switch case label must be the unqualified name of an enumeration constant` 编译错误提示，可以看到，枚举类型在 `switch ... case ...` 中使用时，不要限定枚举常量值的类型，例如对 `FindChannelForceTypeEnum.DT_SINGLE_INSERT_TYPE`，直接使用 `DT_SINGLE_INSERT_TYPE` 即可，最终代码如下。




```java
for(PromotionMaterialInfo info: infoList){
	switch (FindChannelForceTypeEnum.getEnumByCode(EasyUtils.toString(info.getForceType()))){
		case DT_SINGLE_INSERT_TYPE:
			singleFixedList.add(info);
			break;
	    case DT_CIRCLE_INSERT_TYPE:
			circleFixedList.add(info);
		    break;
		default:
			otherFixedList.add(info);
	}
}
```




## guava
* [guava | github](https://github.com/google/guava)
* [Guava - 拯救垃圾代码，写出优雅高效，效率提升N倍 | Blog](http://www.itwanger.com/java/2021/01/29/guava.html)
* [Guava文档 | 极客学院](https://wiki.jikexueyuan.com/project/google-guava-official-tutorial/)

### Maven配置

```xml
<dependency>
    <groupId>com.google.guava</groupId>
    <artifactId>guava</artifactId>
    <version>30.1-jre</version>
</dependency>
```



### Optional

```java
Optional<Integer> possible = Optional.of(5);
possible.isPresent(); // returns true
possible.get(); // returns 5
```

JDK8 中也提供了 `Optional`类。Guava 中的 `Optional` 借鉴了 JDK8中的设计，但也有不同之处。
* Guava 中的 `Optional` 是 `abstract` 的，意味着可以有子类对象；而大哥 JDK8 的是 `final` 的，意味着没有子类对象。
* Guava 的 `Optional` 实现了 `Serializable` 接口，可以序列化；而大哥 JDK8 则没有。



### 集合

首先说一下，为什么需要不可变集合。
* 保证线程安全。在并发程序中，使用不可变集合既保证线程的安全性，也大大地增强了并发时的效率（跟并发锁方式相比）。
* 如果一个对象不需要支持修改操作，不可变的集合将会节省空间和时间的开销。
* 可以当作一个常量来对待，并且集合中的对象在以后也不会被改变。


与 JDK 中提供的不可变集合相比，Guava 提供的 `Immutable` 才是真正的不可变，为什么这么说呢？来看下面这个示例。

下面的代码利用 JDK 的 `Collections.unmodifiableList(list)` 得到一个不可修改的集合 `unmodifiableList`。

```java
List list = new ArrayList();
list.add("雷军");
list.add("乔布斯");

List unmodifiableList = Collections.unmodifiableList(list);
unmodifiableList.add("马云");
```

运行代码将会出现以下异常

```
Exception in thread "main" java.lang.UnsupportedOperationException
	at java.base/java.util.Collections$UnmodifiableCollection.add(Collections.java:1060)
	at com.itwanger.guava.NullTest.main(NullTest.java:29)
```

很好，执行 `unmodifiableList.add()` 的时候抛出了 `UnsupportedOperationException` 异常，说明 `Collections.unmodifiableList()` 返回了一个不可变集合。但真的是这样吗？


你可以把 `unmodifiableList.add()` 换成 `list.add()`。

```java
List list = new ArrayList();
list.add("雷军");
list.add("乔布斯");

List unmodifiableList = Collections.unmodifiableList(list);
list.add("马云");
```

再次执行的话，程序并没有报错，并且你会发现 `unmodifiableList` 中真的多了一个元素。说明什么呢？

**`Collections.unmodifiableList(…)` 实现的不是真正的不可变集合，当原始集合被修改后，不可变集合里面的元素也是跟着发生变化。**

Guava 提供的 `Immutable` 可以避免这个问题，来看下面的代码。

```java
List<String> stringArrayList = Lists.newArrayList("雷军","乔布斯");
ImmutableList<String> immutableList = ImmutableList.copyOf(stringArrayList);
immutableList.add("马云");
```

尝试 `immutableList.add()` 的时候会抛出 `UnsupportedOperationException`。在源码中已经把 `add()` 方法废弃了。

```java
  /**
   * Guaranteed to throw an exception and leave the collection unmodified.
   *
   * @throws UnsupportedOperationException always
   * @deprecated Unsupported operation.
   */
  @CanIgnoreReturnValue
  @Deprecated
  @Override
  public final boolean add(E e) {
    throw new UnsupportedOperationException();
  }
```

尝试 `stringArrayList.add()` 修改原集合的时候 `immutableList` 并不会因此而发生改变。


### 字符串处理

字符串表示字符的不可变序列，创建后就不能更改。在我们日常的工作中，字符串的使用非常频繁，熟练的对其操作可以极大的提升我们的工作效率。

Guava 提供了连接器 —— `Joiner`，可以用分隔符把字符串序列连接起来。下面的代码将会返回“雷军; 乔布斯”，你可以使用 `useForNull(String)` 方法用某个字符串来替换 null，而不像 `skipNulls()` 方法那样直接忽略 null。

```java
Joiner joiner = Joiner.on("; ").skipNulls();
String str = joiner.join("雷军", null, "乔布斯");
System.out.println(str);  //雷军; 乔布斯


Joiner joiner = Joiner.on("; ").useForNull("lbs0912");
String str = joiner.join("雷军", null, "乔布斯");
System.out.println(str);    //雷军; lbs0912; 乔布斯
```

Guava 还提供了拆分器 —— `Splitter`，可以按照指定的分隔符把字符串序列进行拆分。

```
Splitter.on(',')
        .trimResults()
        .omitEmptyStrings()
        .split("雷军,乔布斯,,   沉默王二");
```



## 导出数据至Excel-文件名中文乱码

在Java项目中，导出数据至Excel时，出现了文件名中中文乱码或中文不展示的情况，解决办法如下，指定 UTF8 编码。



```java
fileName = URLEncoder.encode(fileName,"utf-8"); //中文支持
```

完整代码如下。


```java

```



## String-.hasCode()
* [为什么Java String哈希乘数为31 | 掘金](https://juejin.im/post/6844903683361079309)


计算字符串的哈希值，返回值为 `int`。

```java
    /**
     * Returns a hash code for this string. The hash code for a
     * {@code String} object is computed as
     * <blockquote><pre>
     * s[0]*31^(n-1) + s[1]*31^(n-2) + ... + s[n-1]
     * </pre></blockquote>
     * using {@code int} arithmetic, where {@code s[i]} is the
     * <i>i</i>th character of the string, {@code n} is the length of
     * the string, and {@code ^} indicates exponentiation.
     * (The hash value of the empty string is zero.)
     *
     * @return  a hash code value for this object.
     */
    public int hashCode() {
        int h = hash;
        if (h == 0 && value.length > 0) {
            char val[] = value;

            for (int i = 0; i < value.length; i++) {
                h = 31 * h + val[i];
            }
            hash = h;
        }
        return h;
    }
```

根据上述源码，可以推导出计算哈希值的计算公式

```s
s[0]*31^(n-1) + s[1]*31^(n-2) + ... + s[n-1]
```

对于为什么使用 `31` 作为哈希乘数，可以参考 [为什么Java String哈希乘数为31 | 掘金](https://juejin.im/post/6844903683361079309)
* 31是奇素数，哈希分布较为均匀。偶数的冲突率基本都很高，只有少数例外。
* 较小的乘数，冲突率也比较高，如1至20。
* `31` 可以被JVM优化——哈希计算速度快，可用移位和减法来代替乘法。现代的VM可以自动完成这种优化，如 `31 * i = (i << 5) - i`。`31` 的计算速度和哈希分布基本一致，整体表现好，因此被选中。


## 覆盖equals时总要覆盖hasCode
* [Java提高篇——equals()与hashCode()方法详解](https://www.cnblogs.com/qian123/p/5703507.html)
  

参考 《Effective Java》 书籍第11条：`覆盖equals时总要覆盖hasCode`



`.hasCode()` 方法具有如下性质
1. 在一个 Java 应用的执行期间，如果一个对象提供给 `equals` 做比较的信息没有被修改的话，该对象多次调用 `hashCode()` 方法，该方法必须始终如一返回同一个 `integer`。
2. 如果两个对象根据 `equals(Object)` 方法是相等的，那么调用二者各自的 `hashCode()` 方法必须产生同一个 `integer` 结果。
3. 并不要求根据 `equals(java.lang.Object)` 方法不相等的两个对象，调用二者各自的 `hashCode()` 方法必须产生不同的 `integer` 结果。然而，程序员应该意识到对于不同的对象产生不同的 `integer` 结果，有可能会提高 `hash table` 的性能。


**在每个覆盖了 `equals` 方法的类中，都必须覆盖 `hasCode` 方法。** 覆写规则为
1. 如果 `equals()` 返回 true，则 `hashCode()` 返回值必须相等；
2. 如果 `equals()` 返回 false，则 `hashCode()` 返回值尽量不要相等。

实现 `hashCode()` 方法可以通过 `Objects.hashCode()` 辅助方法实现。

## 判断实体对象是否为空

* [Java 判断实体类属性是否为空工具类](https://www.liangzl.com/get-article-detail-129309.html)
* [Java 判断实体对象及所有属性是否为空](https://blog.csdn.net/jiahao1186/article/details/83662333)




利用反射获取对象的方法体集合，再遍历属性值，若有一个属性值不为空，则认为实体对象不为空。代码如下。


1. 判断对象是否为空


```java
//核心代码
package com.lbs0912.java.demo;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

public class EntityEmptyJudge {

    public static void main(String[] args) {
        User user1 = new User("Jack", "male", 17);
        User user2 = new User();

        boolean u1Flag = isNotEmptyBean(user1);
        boolean u2Flag = isNotEmptyBean(user2);

        System.out.println("user1 是否非空：" + u1Flag);
        System.out.println("user2 是否非空：" + u2Flag);

    }

    /**
     * 判断对象是否为空
     * @param obj obj
     * @return Boolean
     */
    public static Boolean isNotEmptyBean(Object obj) {
        Boolean flag = false;
        try {
            if (null != obj) {
                //得到类对象
                Class<?> c = (Class<?>) obj.getClass();
                //得到属性集合
                Field[] fs = c.getDeclaredFields();
                //得到方法体集合
                Method[] methods = c.getDeclaredMethods();
                //遍历属性
                for (Field f : fs) {
                    //设置属性是可以访问的(私有的也可以)
                    f.setAccessible(true);
                    String fieldGetName = parGetName(f.getName());
                    //判断属性是否存在get方法
                    if (!checkGetMet(methods, fieldGetName)) {
                        continue;
                    }
                    //得到此属性的值
                    Object val = f.get(obj);
                    //只要有1个属性不为空,那么就不是所有的属性值都为空
                    if (isNotEmpty(val)) {
                        flag = true;
                        break;
                    }
                }
            }
        } catch (Exception e) {
            log.error("判断对象是否为空出错：" + e.getMessage());
        }

        return flag;
    }

    /**
     * 拼接某属性的 get方法
     *
     * @param fieldName fieldName
     * @return String
     */
    public static String parGetName(String fieldName) {
        if (null == fieldName || "".equals(fieldName)) {
            return null;
        }
        int startIndex = 0;
        if (fieldName.charAt(0) == '_'){
            startIndex = 1;
        }
        return "get"
                + fieldName.substring(startIndex, startIndex + 1).toUpperCase()
                + fieldName.substring(startIndex + 1);
    }

    /**
     * 判断是否存在某属性的 get方法
     *
     * @param methods methods
     * @param fieldGetMet fieldGetMet
     * @return boolean
     */
    public static Boolean checkGetMet(Method[] methods, String fieldGetMet) {
        for (Method met : methods) {
            if (fieldGetMet.equals(met.getName())) {
                return true;
            }
        }
        return false;
    }

    public static Boolean isNotEmpty(Object object){
        Boolean res = false;
        if(null != object && StringUtils.isNotBlank(object.toString()) ){
            res = true;
        }
        return res;
    }
}
```

2. 字符串实用工具类

```java
//使用工具类
public class StringUtils {
    public static boolean isBlank(String str) {
        int strLen;
        if (str == null || (strLen = str.length()) == 0) {
            return true;
        }
        for (int i = 0; i < strLen; i++) {
            if ((Character.isWhitespace(str.charAt(i)) == false)) {
                return false;
            }
        }
        return true;
    }

    public static boolean isNotBlank(String str) {
        return !StringUtils.isBlank(str);
    }
}
```


3. 测试实体类

```java
//测试实体类
@Data
public class User {

    private String name;

    private String gender;

    

    /**
     * 如果属性类型为基本数据类型，则会有默认值
     * 影响正确判断，请特别注意
     */
    private int height;

    private Integer age;

    public User() {
    }

    public User(String name, String gender, int age) {
        this.name = name;
        this.gender = gender;
        this.age = age;
    }
}
```



需要注意的是，若实体对象中有基本数据类型，由于基本数据类型会有默认值，会影响判断。如上代码所示，对于 `User user2 = new User()` 对象，若实体类没有基本数据类型的属性，则判断对象为空。若添加了 `private int height;` 属性，则会认为该对象是非空的。








## 类型转换

将上游下发的指定实体类转换为通用 `Map`。

```java
JsonUtil.json2Map(JsonUtil.write2JsonStr(jPassCouponInfoList));
```


## 遇到多个构造器参数时考虑使用构建器Builder






如果类的构造器或者静态工厂中具有多个参数，设计这种类时， `Builder` 模式就是一种不错的选择，特别是当大多数参数都是可选或者类型相同的时候。与使用重叠构造器模式相比，使用 `Builder` 模式的客户端代码将更易于阅读和编写，构建器也比 JavaBeans 更加安全。


> 参考《Effective Java》书籍第2条 - *遇到多个构造器参数时考虑使用构建器*。


此处以素材JSF@JD代码为例，进行说明。


```java
package com.jd.material.jsf.vo;

import com.jd.directpush.domain.param.UserInfo;
import com.jd.material.jsf.data.advert.AdvertParam;
import com.jd.material.jsf.data.common.SysParam;
import com.jd.material.jsf.domain.AdvertGroupInfo;
import com.jd.material.jsf.domain.AdvertStageInfo;
import com.jd.stock.gqm.dq.export.vo.GisShopInfo;
import lombok.Data;

import java.math.BigInteger;
import java.util.List;

@Data
public class AdvertInfoRequestVO extends MatInfoRequestVO {
    private AdvertGroupInfo advertGroupInfo;
    private AdvertStageInfo stageInfo;
    private AdvertStageInfo nextStageInfo;
    private UserInfo userInfo;
    private AdvertParam advertParam;
    private SysParam sysParam;
    private boolean getBeanNum;

    public AdvertInfoRequestVO(){}

    public AdvertInfoRequestVO(Builder builder){
        this.advertGroupInfo = builder.advertGroupInfo;
        this.stageInfo = builder.stageInfo;
        this.nextStageInfo = builder.nextStageInfo;
        this.userInfo = builder.userInfo;
        this.advertParam = builder.advertParam;
        this.sysParam = builder.sysParam;
        this.getBeanNum = builder.getBeanNum;
        this.gisShopInfos = builder.gisShopInfos;
    }

    public static final class Builder{
        private AdvertGroupInfo advertGroupInfo;
        private AdvertStageInfo stageInfo;
        private AdvertStageInfo nextStageInfo;
        private UserInfo userInfo;
        private AdvertParam advertParam;
        private SysParam sysParam;
        private boolean getBeanNum;
        private List<GisShopInfo> gisShopInfos;

        public static Builder getInstance(){
            return new Builder();
        }

        public Builder advertGroupInfo(AdvertGroupInfo advertGroupInfo){
            this.advertGroupInfo = advertGroupInfo;
            return this;
        }

        public Builder stageInfo(AdvertStageInfo stageInfo){
            this.stageInfo = stageInfo;
            return this;
        }

        public Builder nextStageInfo(AdvertStageInfo nextStageInfo){
            this.nextStageInfo = nextStageInfo;
            return this;
        }

        public Builder userInfo(UserInfo userInfo){
            this.userInfo = userInfo;
            return this;
        }

        public Builder advertParam(AdvertParam advertParam){
            this.advertParam = advertParam;
            return this;
        }

        public Builder sysParam(SysParam sysParam){
            this.sysParam = sysParam;
            return this;
        }

        public Builder getBeanNum(boolean getBeanNum){
            this.getBeanNum = getBeanNum;
            return this;
        }

        public Builder gisShopInfos(List<GisShopInfo> gisShopInfos){
            this.gisShopInfos = gisShopInfos;
            return this;
        }

        public AdvertInfoRequestVO build(){
            return new AdvertInfoRequestVO(this);
        }
    }
}

```



```java
//使用示例
AdvertInfoRequestVO advertInfoRequestVO = AdvertInfoRequestVO.Builder.getInstance()
                                                    .advertGroupInfo(groupInfo)
                                                    .stageInfo(stageInfo)
                                                    .nextStageInfo(nextStageInfo)
                                                    .userInfo(userInfo)
                                                    .advertParam(advertParam)
                                                    .sysParam(sysParam)
                                                    .getBeanNum(false)
                                                    .build();
```






## Bigdecimal类型判断是否等于0

* [ Bigdecimal类型判断是否等于0（用equals方法的坑）](https://blog.csdn.net/wy373679691/article/details/79638630?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param)
* [为什么阿里巴巴禁止使用BigDecimal的equals方法做等值比较](https://www.hollischuang.com/archives/5559)


```
boolean test = BigDecimal.ZERO.equals(new BigDecimal("0"));
System.out.println(test);  // true

boolean test1 = BigDecimal.ZERO.equals(new BigDecimal("0.0"));
System.out.println(test1);   //false


boolean test2 = BigDecimal.ZERO.compareTo(new BigDecimal("0")) == 0;
System.out.println(test2);   // true


boolean test3 = BigDecimal.ZERO.compareTo(new BigDecimal("0.0")) == 0;
System.out.println(test3);   // true
``` 


**`Bigdecimal` 的 `equals` 方法不仅仅比较值的大小是否相等，还比较保留位数是否相等。**


如上代码所示，在判断是否等于0时候，使用 `equals` 方法判断容易采坑。建议使用 `compareTo` 方法进行判断。




## 分页请求中整数取整

在投放-知识库@JD开发中，对于分页请求，计算需要展示的页码时，需要对整数除法的取整问题，使用 `1.0 * xxx` 先进行浮点数的除法，最后使用 `Math.ceil()` 向上取整。


```java
Long totalCount = docCenterDao.countDocInfo(map);
long pageCount = (long) Math.ceil(1.0 * totalCount / pageSize);
```

## 日志打印时格式化输出


使用 `String.format()` 进行格式化输出。


```java
log.error(String.format("到家商品%s价格%s未在配置范围", skuId ,jdPrice));
```


## catch中使用return


```
try{
    int val = 10/0;
}catch (Exception e){
    System.out.println(e);
}
finally {
    System.out.println("finally");   //可执行
} 
System.out.println("end");  //可执行
```


上述代码中，`finally` 部分和最后的打印输出都可以执行。但是如果在 `catch` 中使用了 `return`，则只能执行 `finally` 部分，最后的 `end` 不会打印输出。


```
try{
    int val = 10/0;
}catch (Exception e){
    System.out.println(e);
    return;
}
finally {
    System.out.println("finally");   //可执行
} 
System.out.println("end");  //不可执行  程序执行finally部分之后结束
```



## Map取值时String和int区别

```json
{
    "5678":{
        "name":"lbs",
        "age":12
    },
    "1234":{
        "name":"majie",
        "age":12
    },
    
}
```

对于上述对象，在获取值时候，注意 `key` 为String。

```java
map.get(5678)  // 获取到的值为 null

map.get("5678") // 正确获取
```


## URL和URI


### URI无法对 `{}` 中内容解析

对于链接中的 `{}` 部分，使用 `URI` 无法正常解析，会抛出异常，可以使用 `URL` 进行解析。测试代码如下。

```java
        import java.net.URI;
        import java.net.URL;

        String urlTestStr = "https://ms.jr.jd.com/gw/generic/pc_wd/redirect/m/experienceExposure?reqData={%22activitySource%22:%22cf818%22}\n";
        try{
            URI uri = new URI(urlTestStr);
            System.out.println("uri: " + uri);
        } catch (URISyntaxException e){
            System.out.println("URISyntaxException: " + e);
        }
        try{
            URL url = new URL(urlTestStr);
            System.out.println("url: " + url);
        }catch (MalformedURLException e){
            System.out.println("MalformedURLException: " + e);
        }
```

执行代码，会抛出异常，报错显示在字符串的第76索引出解析异常，即 `{XXX}` 处。


```json
URISyntaxException: java.net.URISyntaxException: Illegal character in query at index 76: https://ms.jr.jd.com/gw/generic/pc_wd/redirect/m/experienceExposure?reqData={%22activitySource%22:%22cf818%22}

url: https://ms.jr.jd.com/gw/generic/pc_wd/redirect/m/experienceExposure?reqData={%22activitySource%22:%22cf818%22}
```






## Lists.newArrayList | guava

* [Lists.newArrayList vs new ArrayList | StackOverflow](https://stackoverflow.com/questions/9980915/lists-newarraylist-vs-new-arraylist)



```java
List<String> list = new ArrayList<String>(); 

// guava
import com.google.common.collect.Lists;
List<String> list = Lists.newArrayList();
```

`Lists` 是 `com.google.common.collect` 中的一个工具类, `Lists.newArrayList()` 其实和 `new ArrayList()` 几乎一模一样，唯一区别是 `Lists.newArrayList()` 可以自动推导出尖括号里的数据类型。


Google Guava 是 Java 通用库的开源集合，是解决那些项目中遇到的许多常见问题的解决方案，其中包括集合，数学，函数习语，输入&输出和字符串等领域。

```xml
<dependency>
    <groupId>com.google.guava</groupId>
    <artifactId>guava</artifactId>
    <version>19.0</version>
</dependency>
```

在 `Google Guava` 中有如下创建集合的方法。



```java
List<List<Long>> pageSkus = Lists.newArrayList();

Set<String> skuIds = Sets.newHashSet(1,2);
```



## Map的复制
在素材中心JSF@JD 工程中，有如下代码，在获取 `productInfoMap` 时，复制了一份新的 Map，来保证线程安全，代码实现如下。


```java
public class ProductInfoEvent {
    private String skuIds;

    private Map<String, Map<String, Object>> productInfoMap;
    
    /**
     * 复制一份新的map，保证线程安全
     *
     */
    public Map<String, Map<String, Object>> getProductInfoMap() {
        return JsonUtil.jsonStr2Object(JsonUtil.write2JsonStr(productInfoMap), new TypeReference<HashMap<String, Map<String, Object>>>() {
        });
    }
}
```

`JsonUtil.jsonStr2Object()` 方法的源码如下。


```java
public class JsonUtil {
    /**
	 * 将JSON格式字符串转换成对象
	 * @param jsonString
	 * @param typeReference
	 * @return
	 */
	public static <T> T jsonStr2Object(String jsonString, TypeReference<T> typeReference) {
		if (StringUtils.isBlank(jsonString)) {
			return null;
		}
		try {
			return (T) OBJECT_MAPPER.readValue(jsonString, typeReference);
		} catch (IOException e) {
			log.error("parse json string error:" + jsonString, e);
		}
		return null;
	}
	// ...
}
```



## 查看CPU核心数

```java
//查看CPU核心数
System.out.println(Runtime.getRuntime().availableProcessors()); 
```


## 对空对象取属性导致对象不再为空


```java
class Man {
    private String age;
    private String name;
        
    public String getAge() {
        return age;
    }

    public void setAge(String age) {
        this.age = age;
    }
}
```


考虑一个场景，类 `Man` 的代码如上。在实际情况中，若获取到的对象 `man` 为 `null`，这个时候对 `null` 对象调用 `getAge()` 方法（会抛出空指针异常），**这个时候，对象 `man` 不再是 `null`了。**


在日常开发中，要严格警惕此种情况。


```java
    private void test6(){
        Man man = null; //考虑实际情况中 获取到的对象为null
        System.out.println((null != man)); //  always 'false'
        try{
            String age = man.getAge();
            System.out.println((null != man)); // always 'true'  !!!
        }
        catch (NullPointerException e) {
            System.out.println("NullPointerException" + e);
            e.printStackTrace();
        }
    }
```



## 方法引用`::`
* [Java中::符号-方法引用 | 掘金](https://juejin.im/post/6873479007703138317)



```java
// demo
  List<Long> skuIds = new ArrayList<>();
        Set<String> skuIdSet = skuIds.stream().map(Objects::toString).collect(Collectors.toSet());
```


### Demo-方法引用





```java
new Random().ints(10)
        .map(i->Math.abs(i))
        .forEach(i -> System.out.println(i));
```

对于上述代码，随机生成10个整数，然后取出它们的绝对值并打印。代码并没任何问题，但是可以进一步简化。



`map` 方法接受的是一个函数式接口 `IntUnaryOperator`，那么上面代码中的 `i->Math.abs(i)` 实际上是


```java
new IntUnaryOperator() {
    @Override
    public int applyAsInt(int operand) {
        return Math.abs(operand);
    }
}
```

从上面来看，`IntUnaryOperator` 就是代理了 `Math.abs(int i)`，**参数列表、返回值都相同，而且没有掺杂其它额外的逻辑。这一点非常重要，不掺杂其它逻辑，才能使用方法引用进行代替。**

通过方法引用来简化 `Lambda` 表达式。上面的代码就可以简化为


```java
new Random().ints(10)
        .map(Math::abs)
        .forEach(System.out::println);
```



### 方法引用的使用条件


Java 方法引用是 Java 8 随着 `Lambda` 表达式引入的新特性。可以直接引用已有 Java 类或对象的方法或构造器。方法引用通常与 `Lambda` 表达式结合使用以简化代码。其使用条件是 
1. **`Lambda` 表达式的主体仅包含一个表达式，且 `Lambda` 表达式只调用了一个已经存在的方法**
2. **被引用的方法的参数列表和返回值与 `Lambda` 表达式的输入输出一致**


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-base-method-ref-1.jpg)



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-base-method-ref-2.jpg)



### 方法引用的格式


方法引用的格式为 `<ClassName | instance>::<MethodName>`。也就是被引用的方法所属的类名和方法名用双冒号 `::` 隔开，构造器方法是个例外，引用会用到 `new` 关键字，总结如下





|  引用方式   |        说明    |
|-------------|----------------|
| 静态方法引用 |  `ClassName :: staticMethodName` | 
| 构造器引用   | `ClassName :: new`   |
| 任意实例方法引用 |    `ClassName :: instanceMethodName` | 
| 类特定实例方法引用 |    `instance:: instanceMethodName`  | 



## Lambda 表达式

### 参考资料
* [Java 8 Lambda 表达式 | 菜鸟教程](https://www.runoob.com/java/java8-lambda-expressions.html)
* [Java 从lambda 表达式引用的本地变量必须是最终变量或实际上的最终变量 | CSDN](https://blog.csdn.net/xiaolulululululu/article/details/86650703)
* [Java8 lambda表达式使用局部变量final问题 | CSDN](https://blog.csdn.net/qq_38345296/article/details/103871684)
* [5万字:Stream和Lambda表达式最佳实践-附PDF下载 | 掘金](https://juejin.im/post/6854573219895050254)


### Overview

Lambda 表达式，也可称为闭包，它是推动 Java 8 发布的最重要新特性。**Lambda 允许把函数作为一个方法的参数（函数作为参数传递进方法中）。**

使用 Lambda 表达式可以使代码变的更加简洁紧凑，其语法如下


```java
(parameters) -> expression
//或
(parameters) ->{ statements;}
```
Lambda 表达式具有如下重要特征
* 可选类型声明：不需要声明参数类型，编译器可以统一识别参数值。
* 可选的参数圆括号：一个参数无需定义圆括号，但多个参数需要定义圆括号。
* 可选的大括号：如果主体包含了一个语句，就不需要使用大括号。
* 可选的返回关键字：如果主体只有一个表达式返回值则编译器会自动返回值，大括号需要指定明表达式返回了一个数值。




### Lambda简化代码

```java
//素材jsf
private Map<String,Map<String, Object>> batchRankSalesInformation(List<Integer> rankIds) {
        Map<String,Map<String, Object>> rankIdToUvInfoMap = Maps.newHashMap();
        if (CollectionUtils.isEmpty(rankIds)) {
            return rankIdToUvInfoMap;
        }
        // 上游单次查询最多支持10个id
        List<List<Integer>> lists = Lists.partition(rankIds, 10);
        // 并发处理
        List<CompletableFuture<Map<Integer, RankDetailInformationRpc>>> futures = lists.stream()
                .map(list -> CompletableFuture.supplyAsync(new RankDetailRpcSupplier(list), rankVisitorThreadPool))
                .collect(Collectors.toList());

        // 合并结果
        for (CompletableFuture<Map<Integer, RankDetailInformationRpc>> task : futures) {
            try {
                Map<Integer, RankDetailInformationRpc> tempMap = task.get(500, TimeUnit.MILLISECONDS);
                if (tempMap == null) {
                    continue;
                }
                for(Map.Entry<Integer, RankDetailInformationRpc> entry : tempMap.entrySet()){
                    Map<String, Object> extension = new HashMap<>();
                    String rankId = entry.getKey().toString();
                    RankDetailInformationRpc rankDetailInformationRpc = entry.getValue();
                    if(null != rankDetailInformationRpc) {
						 // ...
                    }
                    rankIdToUvInfoMap.put(rankId,extension);
                }
            } catch (Exception e) {
                task.cancel(true);
                log.error("batchRankDetailInformation future get Exception", e);
            }
        }
        return rankIdToUvInfoMap;
    }
```



### 变量作用域


1. **在 Lambda 表达式当中不允许声明一个与局部变量同名的参数或者局部变量。**

```java
String first = "";  

//编译会出错  提示 Variable 'first' is already defined in the scope
Comparator<String> comparator = (first, second) -> Integer.compare(first.length(), second.length());  
```

2. **Lambda 表达式只能引用标记了 `final` 的外层局部变量或者隐性的具有 `final` 语义的局部变量（即局部变量可以不用声明为 `final`，但是必须不可被后面的代码修改），这就是说不能在 Lambda 内部修改定义在域外的局部变量，否则会编译错误。**


> `Lambda` 表达式内部引用的局部变量是隐式的 `final`，所以无论 `Lambda` 表达式引用的局部变量无论是否声明 `final`，均具有 `final` 特性！表达式内仅允许对变量引用（引用内部修改除外，比如list增删），禁止修改！

```java
//demo 1- 引用标记了 final 的外层局部变量
public class Java8Tester {
 
   final static String salutation = "Hello! ";
   
   public static void main(String args[]){
      //Lambda 实现函数式接口
      GreetingService greetService1 = message -> 
         System.out.println(salutation + message);
      
      greetService1.sayMessage("Runoob");
   }
    
   interface GreetingService {
      void sayMessage(String message);
   }
}

//执行代码 输出如下
//Hello! Runoob
```


```java
//demo 2- 直接在Lambda表达式中访问外层局部变量
public class Java8Tester {   
   public static void main(String args[]){
      final int num = 1;
        Converter<Integer, String> s = (param) ->
            System.out.println(String.valueOf(param + num));
        s.convert(2);  // 输出结果为 3
   }
    
   public interface Converter<T1, T2> {
     void convert(int i);
   }
}
```


```java
// demo 3 - lambda 表达式的局部变量可以不用声明为 final
// 但是必须不可被后面的代码修改（即隐性的具有 final 的语义）
int num = 1;  
Converter<Integer, String> s = (param) -> System.out.println(String.valueOf(param + num));
s.convert(2);

num = 5;  
//报错信息：Local variable num defined in an enclosing scope must be final or effectively final
```

#### Lambda中为什么有局部变量隐性final的限制
* [Java8 lambda表达式使用局部变量final问题 | CSDN](https://blog.csdn.net/qq_38345296/article/details/103871684)


根据上一章节中第2点说明，可以知道 Lambda 表达式中，局部变量必须有 `final` 限制或隐性 `final` 限制，这是为什么呢？

* 第一，实例变量和局部变量背后的实现有一个关键不同。实例变量都存储在堆中，堆是线程共享的。而局部变量则保存在栈上。如果 `Lambda` 可以直接访问局部变量，而且 `Lambda` 是在一个线程中使用的，则使用 `Lambda` 的线程，可能会在分配该变量的线程将这个变量收回之后，去访问该变量。因此，Java 为避免这个问题，在访问自由局部变量时，实际上是在访问它的副本，而不是访问原始变量。为了保证局部变量和 `Lambda` 中复制品 的数据一致性，就必须要这个限制。
* 第二，这一限制不鼓励你使用改变外部变量的典型命令式编程模式(这种模式会阻碍 Java 8 很容易做到的并行处理)。




### map和forEach区别

* [Java stream中map和forEach区别](https://www.jianshu.com/p/92e6bf8c2bf8)


两者区别主要包括
1. 区别1：`forEach` 方法无返回值，`map` 方法有返回值
2. 区别2：`map` 方法是中间操作 (`intermediate operations`)，是在终点操作开始的时候才真正执行 `map` 操作的。



对于区别2，结合下述 Demo 加深理解。如下代码所示，将 `List` 中的数据转换为大写字母，并插入到 `Set` 中。


```java
List<String> list = new ArrayList<String>(Arrays.asList("a","b","c","d"));
Set<String> set = new HashSet<>();

list.stream().map(item->{
    System.out.println("item is " + item);
    set.add(item.toUpperCase());     //中间操作 并未执行 最终Set为空
    return item;
});
System.out.println("map--set is" + set.toString());

list.stream().forEach(item->{
    System.out.println("item is " + item);
    set.add(item.toUpperCase());
});
System.out.println("forEach--set is" + set.toString());
```

执行上述代码，输出如下。可以发现，使用 `map()` 操作，并没有把数据插入到 `Set` 中。这是因为 `map` 方法是中间操作 (`intermediate operations`)，是在终点操作开始的时候才真正执行 `map` 操作的。上述代码中没有执行终点操作，因此 `map` 中的操作并没有执行。


```
map--set is[]

item is a
item is b
item is c
item is d
forEach--set is[A, B, C, D]
```



若要执行 `map` 中的数据插入，需要添加终点操作，如下代码所示。

```java
List<String> list3 = list.stream().map(item->{
    System.out.println("item is " + item);
    set.add(item.toUpperCase());
    return item;
}).collect(Collectors.toList());
System.out.println("map2--set is" + set.toString());
```

此时代码输出如下，可以发现数据已经被插入到 `Set` 中了。

```
item is a
item is b
item is c
item is d
map2--set is[A, B, C, D]
```



#### 中间操作

**中间操作（`intermediate operations`)会返回一个新的流，并且操作是延迟执行的(lazy)，它不会修改原始的数据源，而且是由在终点操作开始的时候才真正开始执行。**



#### map操作

```java
<R> Stream<R> map(Function<? super T, ? extends R> mapper)
```

`map` 方法接收一个功能型接口，功能型接口接收一个参数，返回一个值。`map` 方法的用途是将旧数据转换后变为新数据，是一种 `1:1` 的映射，每个输入元素按照规则转换成另一个元素。该方法是 `Intermediate` 操作。

```java
Stream<String> stream = Stream.of("a", "b", "c", "d");
stream.map(String::toUpperCase).forEach(System.out::println);
```

以上代码通过 `map` 方法，把字母变成大写，然后输出。


#### forEach操作

```java
void forEach(Consumer<? super T> action)
```

`forEach` 接收一个 `Consumer` 接口，它只接收不参数，**没有返回值**，使用示例如下。

```java
Stream<String> stream = Stream.of("I", "love", "you");
stream.forEach(System.out::println);
```


### Usage Demo


此处给出几个常用的示例，加深理解。



#### List转换为Set

考虑如下场景，将 `List<Long>` 入参转换为 `Set<String>`，历史实现代码如下（素材中心JSF）。


```java
/**
* 将List<Long> 转换为 Set<String>
* @param skuIdList  List<Long>
* @return Set<String>
*/
private Set<String> list2StringSet (List<Long> skuIdList){
    Set<String> skuIds = new HashSet<String>();
    for (Long id : skuIdList) {
        skuIds.add(id.toString());
    }
    return skuIds;
}
```


下面使用 `Stream` 操作对代码进行精简。


```java
//精简1
Set<String> skuIds = skuIdList.stream()
    .limit(30)
    .map(item → item.toString)
    .collect(Collectors.toSet());
```


`limit(30)` 表示限制数组长度为30个，还可以使用 `Object::toString` 进一步精简代码。

```java
//精简2
Set<String> skuIds = skuIdList.stream()
    .limit(30)
    .map(Object::toString)
    .collect(Collectors.toSet());
```







## 函数式接口
* [Java 8 函数式接口 | 菜鸟教程](https://www.runoob.com/java/java8-functional-interfaces.html)
* [Lambda表达式和匿名内部类 | Blog](https://www.cnblogs.com/CarpenterLee/p/5978721.html)

函数式接口 (`Functional Interface`) 就是一个有且仅有 1 个抽象方法，但是可以有多个非抽象方法的接口。

函数式接口可以被隐式转换为 `lambda` 表达式。


如下代码所示，定义了一个函数式接口

```java
@FunctionalInterface
interface GreetingService 
{
    void sayMessage(String message);
}
```

那么就可以使用 Lambda 表达式来表示该接口的一个实现 (注 - JAVA 8 之前一般是用匿名类实现的)


```java
//java 8 - 使用 Lambda表达式实现函数式接口
GreetingService greetService1 = message -> System.out.println("Hello " + message);
```


下面再看一个例子。如需要新建一个线程，在Java 8 之前借助匿名类实现的代码如下

```java
// JDK7 匿名内部类写法
new Thread(new Runnable(){// 接口名
	@Override
	public void run(){// 方法名
		System.out.println("Thread run()");
	}
}).start();
```

上述代码给 `Tread` 类传递了一个匿名的 `Runnable` 对象，重载 `Runnable` 接口的 `run()` 方法来实现相应逻辑。这是 JDK 7 以及之前的常见写法。匿名内部类省去了为类起名字的烦恼，但还是不够简化，在 Java 8 中可以简化为如下形式

```java
// JDK8 Lambda表达式写法
new Thread(
	() -> System.out.println("Thread run()")// 省略接口名和方法名
).start();
```

上述代码跟匿名内部类的作用是一样的，但比匿名内部类更进一步。这里连接口名和函数名都一同省掉了，写起来更加神清气爽。如果函数体有多行，可以用大括号括起来，就像这样


```
// JDK8 Lambda表达式代码块写法
new Thread(
        () -> {
            System.out.print("Hello");
            System.out.println(" Hoolee");
        }
).start();
```


##  匿名内部类


**匿名内部类必须实现某接口或继承某父类。** 其语法如下

1. 继承某父类时

```java
new SuperType(construction parameters){
    {
        inner class methods and data
    }
}
```

**由于构造器的名字必须和类名相同，而匿名内部类没有类名，所以，匿名内部类不能有构造器。取而代之的是，将构造器参数传递给超类（`superclass`）构造器。尤其是在内部类实现接口的时候，不能有任何构造参数。不仅如此，还要像下面这样提供一组括号。**

2. 实现某接口时



```java
new InterfaceType()
    methods and data
}
```




使用匿名内部类，需要注意以下两点
* 匿名内部类不能有构造器（构造方法）
* 匿名内部类不可以是抽象类。（Java 在创建匿名内部类的时候，会立即创建内部类的对象，而抽象类不能创建实例）


## Stream
* [Stream和Lambda表达式最佳实践-附PDF下载 | 掘金](https://juejin.im/post/6854573219895050254#heading-33)
* [PDF-Stream和Lambda表达式最佳实践](https://github.com/ddean2009/www.flydean.com/blob/master/java/stream/java-stream-lambda-all-in-one.pdf)

## 优雅地向List中添加数据
* [如何更优雅地往List中添加数据](https://www.toutiao.com/i6856215916036751879/)
* [Java创建List, Map集合对象的同时进行赋值操作](https://www.cnblogs.com/tuyang1129/p/11960950.html)




如何优雅地向 List 中添加数据，有如下方法

### 基础版

```java
List<String> list = new ArrayList<>();
list.add("小明");
list.add("小红");
```

### 进阶版1-匿名内部类

```java
// 方法1
List<String> list = new ArrayList<String>() {{
    add("小明");
    add("小红");
}};
```


上述代码中，创建了一个匿名内部类对象，且这个类继承自 `ArrayList`，在这个匿名内部类中添加了一个非静态代码块，并在代码块中调用了三次 `add` 方法，为这个 List 对象赋值。

> 若想创建一个匿名内部类，只需在构造方法后面加上一对大括号即可（该类需要实现某接口或继承某父类）。同时，非静态代码块会在构造方法执行前被执行，所以我们将赋值语句放在了代码块中，于是就有了上面这段代码。


上面的代码等价于下面的代码。


```java
public class Test {
    public static void main(String[] args) {
        List<String> list = new MyList();
    }

}
// 创建一个类继承自ArrayList
class MyList extends ArrayList{
    // 在类的非静态代码块中编写赋值语句
    {
        add("小明");
        add("小红");
    }
}
```


### 进阶版2-调用 `Arrays.asList` 方法【推荐使用】


```java
// 方法2
List<String> list = new ArrayList<String>(Arrays.asList("小明","小红"));
```

### 使用第三方包 `jcommander`

```java
import com.beust.jcommander.internal.Lists;

List<String> list = Lists.newArrayList("小明", "小红");
```


查看 `com.beust.jcommander.internal.Lists.newArrayList` 的源码，可以发现其底层实现方法，用进阶版-2的方法。


```
    public static <K> List<K> newArrayList(K... c) {
        return new ArrayList(Arrays.asList(c));
    }
```


附，`jcommander` 的 Maven 依赖如下。



```
<!-- https://mvnrepository.com/artifact/com.beust/jcommander -->
<dependency>
    <groupId>com.beust</groupId>
    <artifactId>jcommander</artifactId>
    <version>1.78</version>
</dependency>
```



## 对象的解析和序列化 

在日常开发中，遇到对象的解析和序列化问题，在此进行记录和分析。

### 问题描述

1. 在工程A（投放SOA）中，请求了外部接口，并将拿到的 `StoreHotSku` 类型的实体类对象数据放入扩展字段中，将该扩展字段传递给另外一个工程B（素材中心JSF）。


```java
StoreHotSkuQueryRequest storeHotSkuQueryRequest = new StoreHotSkuQueryRequest();
List<Long> shopIdList = resultList.stream().map( shopInfo -> shopInfo.getId()).collect(Collectors.toList());
storeHotSkuQueryRequest.setStoreIds(shopIdList);
//外部接口请求
StoreResult<StoreHotSkuData> storeHotSkuDataResponse = jwStoreService.batchQueryStoreHotSkus(storeHotSkuQueryRequest);
// ...
StoreHotSkuData storeHotSkuData = storeHotSkuDataResponse.getModel();
Map<Long, List<StoreHotSku>> storeHotSkuMaps = storeHotSkuData.getStoreHotSkuMap();
```


```java
List<SortedItem> items = resultList.stream()
    .map(shopInfo -> {
        SortedItem item = new SortedItem();
        Map<String, Object> ext = new HashMap<>();
        // ...
        ext.put("skuList", storeHotSkuMaps.get(shopInfo.getId()));
        //...
        item.setExtMap(ext);
        return item;
    }).collect(Collectors.toList());
```

2. 在另外一个工程B（素材中心JSF）中，拿到工程A（投放SOA）的返回结果，进行解析和序列化，代码如下。`deliveryResult` 对象中包含上述代码中的 `StoreHotSku` 实体对象，`StoreHotSku` 实体对象是外部接口中定义的对象，定义在 Maven 依赖包中。

```java
try {
    DeliveryResult deliveryResult = targetedDeliveryService1Sec.enhancedFilterAndSort(userInfo, type2IdList, paramMap);
    // ...
    // deliveryResult 对象中包含上述代码中的StoreHotSku实体对象
```


3. 这个时候，在工程B（素材中心JSF）中，对返回的结果进行解析和序列化时，会报错，报错信息如下，显示 `StoreHotSku` 找不到，在反序列化时候出现错误。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/jd-base/jd-bean-util-parse-1.png)

### 问题分析

错误原因也很明显，在工程B（素材中心JSF）中，并没有 `StoreHotSku` 对应的定义（其定义是在工程A中的Maven依赖包中），因此在工程B中无法对 `StoreHotSku` 进行解析和序列化，只可以在具有 Maven 依赖的工程A中对`StoreHotSku` 进行解析和序列化。

### 问题分析

解决办法是在工程A中，**将实体类转换为普通的 Map 对象。通用方法为通过反射实现（不需要知道实体类的属性和方法）。** 此处采用最简单的方法实现，进行对象的取值和赋值。代码如下。

```java
List<SortedItem> items = resultList.stream()
    .map(shopInfo -> {
        SortedItem item = new SortedItem();
        Map<String, Object> ext = new HashMap<>();
        // ...
        // 之前的方案
        // ext.put("skuList", storeHotSkuMaps.get(shopInfo.getId()));  
        
        // 新方案  将实体类转换为普通的 Map 对象
        if(isSkuMapsNotNull){
            List<StoreHotSku> storeHotSkuList = storeHotSkuMaps.get(shopInfo.getId());
            if(null != storeHotSkuList){
                List<Map<String,Object>> hotSkuList = storeHotSkuList.stream().map(skuInfo -> {
                    Map<String,Object> tmp = new HashMap<>();
                    tmp.put("skuName",skuInfo.getSkuName());
                    tmp.put("imgUrl",skuInfo.getImgUrl());
                    tmp.put("jdPrice",skuInfo.getJdPrice());
                    tmp.put("skuId",skuInfo.getSkuId());
                    return tmp;
                }).collect(Collectors.toList());
                ext.put("storeSkuList",hotSkuList);
            }
        }
        //...
        item.setExtMap(ext);
        return item;
    }).collect(Collectors.toList());
```






## CollectionUtils

Spring 中提供了 `CollectionUtils` 工具类，可以进行集合为空的判断。

```java
package org.springframework.util;

public abstract class CollectionUtils {
    /**
	 * Return {@code true} if the supplied Collection is {@code null} or empty.
	 * Otherwise, return {@code false}.
	 * @param collection the Collection to check
	 * @return whether the given Collection is empty
	 */
	public static boolean isEmpty(Collection<?> collection) {
		return (collection == null || collection.isEmpty());
	}
}

```


## MapUtils


`MapUtils.isEmpty()` 除了判断对象是否 `null` 外 还进行了 `isEmpty` 判断。在代码参数校验时，比直接使用 `null == map` 更好。

```java
package org.apache.commons.collections;

public class MapUtils {
    /**
     * Null-safe check if the specified map is empty.
     * <p>
     * Null returns true.
     * 
     * @param map  the map to check, may be null
     * @return true if empty or null
     * @since Commons Collections 3.2
     */
    public static boolean isEmpty(Map map) {
        return (map == null || map.isEmpty());
    }
}
```

对应的 Maven 依赖如下

```xml
        <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-collections4</artifactId>
            <version>4.2</version>
        </dependency>
```


## Map取值时key类型的影响

如下示例代码，对于 `key=15(Integer)` 和 `key="15"(String)` 两种情况，`key` 类型的不同，会影响获取到的值，即集合中取值时，对 `key` 是类型敏感的。


```java
Map<Integer,String> map = new HashMap<>();
map.put(15,"123");

System.out.println("key = \"15\"(String), value = " +  map.get("15"));  //null
System.out.println("key = 15(Integer), value = " +  map.get(15));  //"123"
System.out.println("map.containsKey(\"15\"): " +  map.containsKey(15));  //false
System.out.println("map.containsKey(15):"  +  map.containsKey(15));  //true
```
