
# Java-20-Effective Java


[TOC]

## 更新
* 2022/05/29，撰写


## 参考资料
* 《Effective Java》3rd
* 阿里《Java开发手册》华山版


## 前言
本文以《Effective Java》和阿里《Java开发手册》为基础（但不局限于二者），记录 Java 开发过程中的一些代码规范、常见误区、高效编码技巧。







## transient
* [Java中的transient关键字 | 掘金](https://juejin.cn/post/6844903872725516296)
* [你真的搞懂 transient 关键字了吗 ](https://zhuanlan.zhihu.com/p/58422235)
* [Java transient关键字使用小记](https://www.cnblogs.com/lanxuezaipiao/p/3369962.html)




### 结论

> transient 表示短暂的，转瞬即逝的。

1. 一旦变量被 `transient` 修饰，变量将不再是对象持久化的一部分。
2. `transient` 关键字只能修饰变量，而不能修饰方法和类。
3. 被 `transient` 关键字修饰的变量不再能被序列化
4. 一个静态变量不管是否被 `transient` 修饰，均不能被序列化。





### 静态变量不能被序列化


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

**序列化保存的是对象的状态，静态变量属于类的状态，因此，序列化并不保存静态变量。**


### 被 `transient` 关键字修饰的变量不再能被序列化


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



### transient 真不能被序列化吗和Externalizable



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

**在 Java 中有 2 种实现序列化的方式，`Serializable` 和 `Externalizable`。这两种序列化方式的区别是**
1. 实现了 Serializable 接口是自动序列化的
2. 实现 Externalizable 则需要手动序列化，通过 `writeExternal` 和 `readExternal` 方法手动进行。这也是为什么上面的 username 为 null 的原因了。


### Externalizable和Serializable

* ref 1-[Serializable 和 Externalizable 有何不同](https://hollischuang.github.io/toBeTopJavaer/#/basics/java-basic/diff-serializable-vs-externalizable?id=serializable-%e5%92%8c-externalizable-%e6%9c%89%e4%bd%95%e4%b8%8d%e5%90%8c)


Java 中的类通过实现 `java.io.Serializable` 接口以启⽤其序列化功能。未实现此接口的类将⽆法使其任何状态序列化或反序列化。

可序列化类的所有⼦类型本⾝都是可序列化的。

序列化接口没有⽅法或字段，仅⽤于标识可序列化的语义。

当试图对⼀个对象进⾏序列化的时候，如果遇到不⽀持 `Serializable` 接口的对象，在此情况下，将抛 `NotSerializableException`。

如果要序列化的类有⽗类，要想同时将在⽗类中定义过的变量持久化下来，那么⽗类也应该继承 `java.io.Serializable` 接口。

`Externalizable` 继承了 `Serializable`，该接口中定义了两个抽象⽅法，`writeExternal()` 与 `readExternal()`。当使⽤ `Externalizable` 接口来进⾏序列化与反序列化的时候，需要开发⼈员重写 `writeExternal()` 与 `readExternal()` ⽅法。

如果没有在这两个⽅法中定义序列化实现细节，那么序列化之后，对象内容为空。

实现 `Externalizable` 接口的类必须要提供⼀个 `public` 的⽆参的构造器。

所以，实现 `Externalizable`，并实现 `writeExternal()` 和`readExternal()` ⽅法可以指定序列化哪些属性。



## StringBuilder和List的删除元素

* 对一个 List，是调用其 `remove()` 方法进行删除
 
```java
List<Integer> list = new ArrayList<>();
list.remove()
```

* 对一个 StringBuilder，是调用 `deleteCharAt()` 方法进行删除。

```java
StringBuffer sb = new StringBuffer();
sb.deleteCharAt(sb.length() - 1);
```
* 对一个 StringBuilder，调用 `setLength(0)` 方法进行清空。
 

## protected和default
* ref 1-[Java 中 public、default、protected、private 区别](https://blog.csdn.net/xingchenhy/article/details/81223168)



| 修饰符 | 类内部 | 同一包 | 子类 | 任何地方 |
|-------|-------|-------|-----|---------|
| private | Yes | | | | 
| default | Yes | Yes | | | 
| protected | Yes | Yes | Yes | |
| public | Yes | Yes | Yes | Yes |  

## hashCode和equals
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
* **两个对象 `hashCode` 为 true 时，`equals` 可以不等（如发生哈希碰撞时）**


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
* **接口不能直接实例化**
* 接口中属性的访问控制符只能是 `public`，默认是 `public static final`

### 抽象类
* 抽象类是对对象公共行为的抽象
* 创建抽象类使用关键字 `abstract`，子类继承抽象类时使用关键字 `extends`
* **抽象类中定义的普通方法，可以有具体的代码实现**
* **抽象类中定义的抽象方法，不能有具体的代码实现。抽象方法需要使用 `abstract` 标记**
* **抽象类不能直接实例化**
* **抽象类中属性控制符无限制，可以定义 `private` 类型的属性**
* **抽象类中的方法控制符无限制，其中抽象方法不能使用 `private` 修饰**


### 二者区别
1. 定义关键字不同：接口使用关键字 `interface` 来定义。抽象类使用关键字 `abstract` 来定义。
2. 继承或实现的关键字不同：接口使用 `implements` 关键字定义其具体实现。 抽象类使用 `extends` 关键字实现继承。
3. 子类扩展的数量不同：一个类可以同时实现多个接口，但是只能继承一个抽象类。
4. 属性访问控制符不同：接口中属性的访问控制符只能是 `public`。抽象类中的属性访问控制符无限制，可为任意控制符。
5. 方法控制符不同：接口中方法的默认控制符是 `public`，并且不能定义为其他控制符。抽象类中的方法控制符无限制，其中抽象方法不能使用 `private` 修饰。
6. 方法实现不同：接口中普通方法不能有具体的方法实现，在 JDK 8 之后 `static` 和 `default` 方法可以有默认的方法实现。抽象类中普通方法可以有方法实现，抽象方法不能有方法实现。
7. **静态代码块使用不同：接口中不能使用静态代码块，抽象类中可以使用静态代码，如下所示。**

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


| StringBuffer | StringBuilder |
|--------------|---------------|
|   线程安全    |  非线程安全     |
| synchronized |  非synchronized |
| 单线程中，比 StringBuilder 慢 | 单线程中，比 StringBuffer 快|


### 内容清空

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



## Scanner
* ref 1-[Java Scanner 类](https://www.cainiaojc.com/java/java-scanner.html)
* ref 2-[华为机试 | 牛客网](https://www.nowcoder.com/exam/oj/ta?page=3&tpId=37&type=37)

在面试系统（牛客网等），会使用 `Scanner` 接受输入参数。在此，对 `Scanner` 的使用进行记录。




* Scanner 示例


```java


import java.util.Scanner;

// 注意类名必须为 Main, 不要有任何 package xxx 信息
public class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        // 注意 hasNext 和 hasNextLine 的区别
        // 注意 while 处理多个 case
        while (in.hasNextInt()) { 
            //int读取
            int a = in.nextInt();
            int b = in.nextInt();
            System.out.println(a + b);

            //String读取
            String str = in.nextLine();
            String[] s = str.split(" ");
            int length = s[s.length - 1].length();
            System.out.println(length);
        }
    }
}

```

* 读取两个输入的字符串

```java
// 读取两个输入的字符串
Scanner in = new Scanner(System.in);
String input1 = in.nextLine();
String input2 = in.nextLine();
```


* 读取数组

```java
//输入 [1,2,3]
String str = input.nextLine();
String[] arr = str.substring(1,str.length()-1).split(",");
int len = arr.length;
int[] intVal = new int[len];
for(int i=0;i<len;i++){
    intVal[i] = Integer.parseInt(arr[i]);
}
```


### 常用方法


|      方法	   |      描述    |
|-------------|--------------|
| nextInt() | 从用户读取 int 值 |
| nextFloat() |	从用户读取 float 值 |
| nextBoolean() |	从用户读取 boolean 值 |
| nextLine() |	从用户读取一行文本 |
| next() |	从用户那里读取一个单词 |
| nextByte() |	从用户读取 byte 值 |
| nextDouble() |	从用户读取 double 值 |
| nextShort() |	从用户读取 short 值 |
| nextLong() |	从用户读取 long 值 |
| close() |	关闭连接 |



```java
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        while (sc.hasNext()) {
            int length = sc.nextInt(); 
            
            ...
        }
        sc.close(); //关闭连接
    }
```

### `next()` 与 `nextLine()` 的区别
1. `next()` 不会获取字符前/后的空格/Tab键，遇到空格/Tab键/回车截止获取。
2. `nextLine()` 会获取字符前后的空格/Tab键，遇到回车键截止。


```java
//demo1
//输入 "java   "（后带3个空格），则
//str1 = "java"，str1.length() = 4
//str2 = "java   "，str1.length() = 7
String str1 = input.next();
String str2 = input.nextLine();
```



```java
//demo2
//输入 "a b c d"，则
//str1 = "a"，str1.length() = 1
//str2 = "b"，str1.length() = 1
String str1 = input.next();
String str2 = input.next();
```


## 数组排序

* 对 `int[] arr` 数组排序

```java
Arrays.sort(arr)
```

* 对 `List<Integer> list` 数组排序
  1. `Collections.sort(list);`
  2. `list.sort((o1, o2) -> 0);`



```java
//方法1 Collections.sort()
Collections.sort(list);

//方法2 调用sort() 方法，并实现 Comparator

list.sort(new Comparator<Integer>(){
    @Override
    public int compare(Integer o1,Integer o2){
        return o1-o2;
    }
});

//o1-o2 表示升序排列
//o2-o1 表示降序排列
// return 0 表示不交换位置 不排序


//可以简写
list.sort((o1, o2) -> o1-02);
```






## char转为int

* [Java中char 转化为int 的两种方法](https://blog.csdn.net/sxb0841901116/article/details/20623123)
* [Java 实例 char到int的转换](https://geek-docs.com/java/java-examples/char-to-int.html)


### 隐式转换->ASCII值

> **'A' 的 ASCII 值是 56，'a' 的 ASCII 值是 97。**

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

需要注意的是，该方法对于字母 `A-Z`, `a-z` 以及全宽变体的数值，返回的结果都是在 [10,35] 范围内。

**因此，对于大写字母 `A` 和小写字母 `a`，该方法的返回结果是一样的。**


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


### char-'0' -> 数值

```java
char c2 = '9';
if(Character.isDigit(c1)){
    int val  = c2 - '0';  // 9
}
```

对于 `'a' ~ 'z'`，可接减去 97（或 'a'），再加上 10，得到对应的数值。      

```java
char c2 = 'b';
int val  = c2 - 97 + 10;  // 11



char c3 = 'b';
int val2  = c2 - 'a' + 10;  // 11
```


### 16进制转10进制

* [进制转换 | 牛客网](https://www.nowcoder.com/practice/8f3df50d2b9043208c5eed283d1d4da6?tpId=37&tqId=21228&rp=1&ru=/exam/oj/ta&qru=/exam/oj/ta&sourceUrl=%2Fexam%2Foj%2Fta%3Fpage%3D1%26tpId%3D37%26type%3D37&difficulty=undefined&judgeStatus=undefined&tags=&title=)


1. 使用 `Character.getNumericValue()` 实现


```java
import java.util.Scanner;

public class Main{
    public static void main(String[] args){
        Scanner in  = new Scanner(System.in);
        String str = in.nextLine();
        str = str.substring(2).toLowerCase();
        int sum = 0;
        for(int i=0;i<str.length();i++){
            int val  = Character.getNumericValue(str.charAt(i));
            sum = 16*sum + val;

        }
        System.out.println(sum);
    }
}
```


2. 隐式转换

```java

import java.util.Scanner;

public class Main{
    public static void main(String[] args){
        Scanner in  = new Scanner(System.in);
        String str = in.nextLine();
        str = str.substring(2).toLowerCase();
        int sum = 0;
        for(int i=0;i<str.length();i++){
            char c = str.charAt(i);
            int val = 0;
            if(c >= 97){
                val = c - 97  + 10;
            } else {
                val = c - '0';
            }

            //下面这种写法也可以
            //if(c >= 'a'){
            //    val = c - 'a'  + 10;
            

            sum = 16*sum + val;

        }
        System.out.println(sum);
    }
}
```


## List和Array互转

* `List<String>` 转为 `String[]`


```java
List<String> list = new ArrayList<>():
String[] arr = list.toArray(new String[list.size()]);
```



* `List<Integer>` 转为 `int[]`


```java
List<Integer> list = new ArrayList<>():
int[] arr = list.stream().mapToInt(Integer::valueOf).toArray();
```

* `String[]` 转为 `List<String>`

```java
String[] arrays = new String[]{"aa","bb","cc"};
List<String> list = Arrays.asList(arrays);
```