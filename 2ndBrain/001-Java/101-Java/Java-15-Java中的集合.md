
# Java-15-Java中的集合

[TOC]

## 更新
* 2020/06/14，撰写


## 参考资料




## 集合总览

Java 集合就像一个容器，可以存储任何类型的数据，也可以结合泛型来存储具体的类型对象。**在程序运行时，Java 集合可以动态的进行扩展，随着元素的增加而扩大。在 Java 中，集合类通常存在于 `java.util` 包中，Java 集合使用统一的 `Iterator` 遍历。**


### Collection和Map

Java 集合主要由 2 大体系构成，分别是 `Collection` 体系和 `Map` 体系，其中 `Collection` 和 `Map` 分别是 2 大体系中的顶层接口。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/leetcode/java-collection-map-1.png)


1. `Collection` 主要有 3 个子接口，分别为 `List`、`Set`、`Queue`
   * `List`、`Queue` 中的元素有序可重复，而 `Set` 中的元素无序不可重复
   * `List` 中主要有 `ArrayList`、`LinkedList` 两个实现类
   * `Set` 中则是有 `HashSet` 实现类
   * `Queue` 是在 JDK1.5 后才出现的新集合，主要以数组和链表两种形式存在
2. `Map` 同属于 `java.util` 包中，是集合的一部分，但与 `Collection` 是相互独立的，没有任何关系
   * `Map` 中都是以 `key-value` 的形式存在，其中 `key` 必须唯一
   * 主要有 `HashMap`、`HashTable`、`TreeMap` 三个实现类





**由于Java的集合设计非常久远，中间经历过大规模改进，需要注意的是，有一小部分集合类是遗留类，不应该继续使用**
1. `Hashtable`：一种线程安全的 Map 实现
2. `Vector`：一种线程安全的 List 实现
3. `Stack`：基于 `Vector` 实现的 LIFO 的栈


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-deque-stack-uml-1.png)


> **官方不推荐使用 `Stack`，可用 `Deque` 实现 `Stack`。**


**还有一小部分接口是遗留接口，也不应该继续使用**
1. `Enumeration<E>`：已被 `Iterator<E>` 取代




### Collection和Collections

`java.util.Collection` 是一个集合接口，是一个接口。它提供了对集合对象进行基本操作的通用接口方法。`Collection` 接口在 Java 类库中有很多具体的实现，`Collection` 接口的意义是为各种具体的集合提供了最大化的统一操作方式。

```java
Collection (interface)
1. Set
2. List
    * ArrayList
    * LikedList
    * Vector
```

`java.util.Collections` 是一个包装类，是一个类。它包含有各种有关集合操作的静态多态方法。此类不能实例化，就像一个工具类，服务于 Java 的 Collection 框架。

如 Collections 提供如下方法
1. 排序方法 `Collections.sort(list)`
2. 翻转方法 `Collections.reverse(list)`


## List

`List` 集合是有序的，开发者可对其中每个元素的插入位置进行精确地控制，可以通过索引来访问元素，遍历元素。`List` 集合又分为 `ArrayList` 和 `LinkedList` 这两个类。

`ArrayList` 底层通过数组实现，随着元素的增加而**动态扩容**。而 `LinkedList` 底层通过链表来实现，随着元素的增加不断向链表的后端增加节点。


> `ArrayList` 把添加和删除的操作封装起来，让我们操作 `List` 类似于操作数组，却不用关心内部元素如何移动。

|       比较项      |	ArrayList	|  LinkedList   |
|-------------------|---------------|---------------|
| 获取指定元素	| 速度很快	 |  需要从头开始查找元素  |
| 添加元素到末尾  | 速度很快	|    速度很快      |
| 在指定位置添加/删除	|  需要移动元素	 | 不需要移动元素 | 
| 内存占用	|     少      |	 较大  |






## Queue和Deque

* ref 1-[接口 Deque<E>](http://itmyhome.com/java-api/java/util/Deque.html) !!!





> **官方不推荐使用 `Stack`，可用 `Deque` 实现 `Stack`。**



在日常开发中，使用双端队列 `Deque` 去实现栈 `Stack` 和 队列 `Queue` 即可。下面着重介绍双端队列 `Deque`。


### Deque的父接口和实现类
1. `Deque` 接口继承了 `Queue` 接口。
2. `Deque` 接口的实现类包括 `ArrayDeque`，`LinkedBlockingDeque` 和 `LinkedList`。**编程题目中，使用 `LinkedList` 实现队列和栈即可。**


```java
public interface Deque<E> extends Queue<E> {

}
```


### API


`Deque` 的常用 API 如下。



| 操作 |  头部-抛异常 | 头部-不抛异常 | 尾部-抛异常  | 尾部-不抛异常 |
|---------|----------------|---------|----------|------|-------|------|
| 插入|  addFirst(e) | offerFirst(e) |  addLast(e) | offerLast(e) |
| 删除|  removeFirst() | pollFirst() |  removeLast() | pollLast() |
| 检查|  getFirst() | peekFirst() |  getLast() | peekLast() |


此外，由于 `Deque` 接口继承了 `Queue` 接口，从 `Queue` 接口继承的方法完全等效于 `Deque` 方法。

| Queue 方法	|  等效 Deque 方法  |
|--------------|-------------------|
| add(e) |	addLast(e) |
| offer(e) | offerLast(e) | 
| remove()	| removeFirst() | 
| poll() |	pollFirst() |
| element()	 | getFirst() |
| peek()	| peekFirst() |



此外，官方不推荐使用 `Stack`，可用 `Deque` 实现 `Stack`，所以堆栈方法完全等效于 `Deque` 方法，如下表所示。


|     堆栈方法	 | 等效 Deque 方法   |
|--------------|-------------------|
| push(e)	 | addFirst(e) |
| pop()	 | removeFirst() |
| peek()	| peekFirst() |




* `LinkedList.poll()`：检索并删除此列表的头部（第一个元素）
* `LinkedList.pollFirst()`：检索并删除此列表的第一个元素，如果此列表为空，则返回 null
* `LinkedList.pollLast()`：检索并删除此列表的最后一个元素，如果此列表为空，则返回 null



统一初始化实现。

```java
// Deque
Deque<Character> deque = new LinkedList<>();
// queue
Deque<Character> queue = new LinkedList<>();
//stack
Deque<Character> stack = new LinkedList<>();
```

**为了方便记忆，编程题中统一使用 Deque 自带的 API，并使用 `Deque<Character> xxx = new LinkedList<>();` 进行初始化。** 如下编程题 [LeetCode-20. 有效的括号](https://leetcode.cn/problems/valid-parentheses/submissions/) 所示。






```java

public class Solution {
    public boolean isValid(String s) {
        int n = s.length();
        if (n % 2 == 1) {
            return false;
        }
        Map<Character,Character> pairs = new HashMap<>();
        pairs.put(')','(');
        pairs.put(']','[');
        pairs.put('}','{');

        Deque<Character> stack = new LinkedList<>();

        for(int i=0;i<n;i++){
            char ch = s.charAt(i);
            //如果是反括号
            if(pairs.containsKey(ch)){
                if(stack.isEmpty() || !stack.peek().equals(pairs.get(ch))){
                    return false;
                }
                //弹出栈顶元素
                stack.poll();
                //  stack.pollFirst();  pollFirst也可以

            } else {
                //如果是正括号 入栈
                stack.addFirst(ch);
                // stack.push(ch);  使用push方法也可以
            }
        }
        return stack.isEmpty();
    } 
}
```


## HashMap
* [HashMap的使用和数据结构 | cxuan](https://www.cnblogs.com/cxuanBlog/p/13181746.html)
* [阿里巴巴Java开发规约HashMap条目 | 知乎](https://zhuanlan.zhihu.com/p/30360734)


### 相关成员变量

`HashMap` 类中有以下主要成员变量

|      成员变量         |           说明       |
|---------------------|----------------------|
| `transient int size;`  |  记录了 Map 中 KV 对的个数  |
| `loadFactor` | 装载因子，默认值为 0.75f（`static final float DEFAULT_LOAD_FACTOR = 0.75f;` |
| `int threshold;` |  临界值，当实际 KV 个数超过 `threshold` 时，HashMap 会将容量扩容，`threshold ＝ 容量 capacity * 装载因子loadFactor` |
| `capacity` | 容量，若不指定，默认容量是 16 (`static final int DEFAULT_INITIAL_CAPACITY = 1 << 4;` | 




### Entry和Bucket

> JDK 8 中 HashMap 的底层数据结构是「数组 + 链表 + 红黑树」，数组在 HashMap 中又被称为桶（`bucket`）。

 
HashMap 在初始化时，会创建一个长度为 `capacity` 的 `Entry` 数组，这个数组里可以存储元素的位置被称为「桶（`bucket`）」。

每个桶（`bucket`）都有其指定索引，系统可以根据其索引快速访问该 `bucket` 里存储的元素。 


无论何时，HashMap 的每个桶（`bucket`）只存储一个元素（也就是一个 `Entry`），由于 `Entry` 对象可以包含一个引用变量（`Entry` 构造器的的最后一个参数）用于指向下一个 `Entry`。




### 扩容

HashMap 在 `put` 的元素数量大于临界值 `threshold` 时，即 `Capacity * LoadFactor`（默认 `16 * 0.75`） ，并且新建的 `Entry` 刚好落在一个非空的桶上，此时就会触发扩容。

**每次扩容后，`capacity` 变为原来的两倍。**


```s
threshold = loadFactor * capacity
```


关于 HashMap 的扩容和容量，给出下面两个常见的问题

> 1.如果 `new HashMap<>(19)`，`bucket` 数组多大？
* HashMap 的 `bucket` 数组大小一定是 2 的幂（内部通过移位运算进行扩容），如果 `new` 的时候指定了容量且不是 2 的幂，实际容量会是最接近(大于)指定容量的 2 的幂。
* 如果 `new HashMap<>(19)`，比 19 大且最接近的 2 的幂是 32，因此实际的 `bucket` 数组容量是 32。



> 2.HashMap 什么时候开辟 bucket 数组占用内存
* **HashMap 在 `new` 后并不会立即分配 `bucket` 数组，而是第一次 `put` 时初始化。类似 `ArrayList` 在第一次 `add` 时分配空间。**



###  集合初始化时指定集合大小

阿里巴巴《Java开发手册》中指出，在集合初始化时，要指定集合大小。


> 【推荐】 集合初始化时，指定集合初始值大小
>
> 说明：HashMap 使用 HashMap（int initialCapacity） 初始化


首先，需要明确一点，初始化构造方法传入的 `initialCapacity`，并不表示初始化的 HashMap 的容量就是 `initialCapacity`。`initialCapacity` 会被 `tableSizeFor()` 方法动态调整为 2 的 N 次幂。

比如初始化时候，传入初始大小 13，经过 `tableSizeFor()` 调整后，最接近的 2 的 N 次幂，是 16。所以最终的 HashMap 的容量大小是 16。




此处，对初始化时是否指定集合大小对性能的影响进行测试。测试代码如下，创建了 3 个 HashMap，分别使用默认的容量（16），元素个数的一半（5千万），元素个数（一亿）作为初始容量进行初始化。然后分别向其中 `put` 一亿个 KV。


```java
public static void main(String[] args) {
    int aHundredMillion = 10000000;
    Map<Integer, Integer> map = new HashMap<>();

    long s1 = System.currentTimeMillis();
    for(int i=0;i<aHundredMillion;i++){
        map.put(i,i);
    }
    long s2 = System.currentTimeMillis();
    System.out.println("未初始化容量，耗时 ： " + (s2 - s1));

    Map<Integer, Integer> map1 = new HashMap<>(aHundredMillion/2);
    long s5 = System.currentTimeMillis();
    for (int i = 0; i < aHundredMillion; i++) {
        map1.put(i, i);
    }
    long s6 = System.currentTimeMillis();
    System.out.println("初始化容量5000000，耗时 ： " + (s6 - s5));


    Map<Integer, Integer> map2 = new HashMap<>(aHundredMillion);

    long s3 = System.currentTimeMillis();
    for (int i = 0; i < aHundredMillion; i++) {
        map2.put(i, i);
    }
    long s4 = System.currentTimeMillis();
    System.out.println("初始化容量为10000000，耗时 ： " + (s4 - s3));
}
```

测试结果如下

```s
未初始化容量，耗时 ： 14419
初始化容量5000000，耗时 ： 11916
初始化容量为10000000，耗时 ： 7984
```

从结果中可以知道，在已知 `HashMap` 中将要存放的 KV 个数的时候，设置一个合理的初始化容量可以有效的提高性能。

如果没有设置初始容量大小，随着元素的不断增加，HashMap 会发生多次扩容，而 HashMap 中的扩容机制决定了每次扩容都需要重建 hash 表，是非常影响性能的。





### 数据结构
* ref 1-[红黑树深入剖析及Java实现 | 美团技术](https://tech.meituan.com/2016/12/02/redblack-tree.html)
* ref 2-[HashMap的底层数据结构 | 知乎](https://zhuanlan.zhihu.com/p/366679038)


HashMap 底层的数据结构实现如下
1. JDK 7 中的 HashMap 采用「数组 + 链表」的结构来存储数据。
2. JDK 8 中的 HashMap 采用 「数组 + 链表 + 红黑树」的结构来存储数据。

HashMap 中使用了链表结构，链表的查找效率较低，所以，JDK 8 中引入了红黑树来对 HashMap 的查找操作进行优化。红黑树是一个平衡搜索二叉树，二叉树的查询效率很高。
* 当 HashMap 的链表长度小于 8 时，采用链表存储。
* 当 HashMap 的链表长度大于 8 时，会判断一下当前数组的长度是否小于 64，若小于 64，则会选择先进行数组扩容；大于 64 时，会将链表转换为红黑树。
* 转为红黑树后，如果红黑树节点个数小于 6，则再转为链表。



#### 为什么链表大于 8（且数组长度大于64）时会转红黑树

红黑树的平均查找长度是 `log(n)`，如果长度为 8，平均查找长度为 `log(8) = 3`。链表的平均查找长度为 `n/2`，当长度为 8 时，平均查找长度为 `8/2 = 4`，这才有转换成树的必要。

链表长度如果是小于等于 6，`6/2 = 3`，而 `log(6) = 2.6`，虽然速度也很快的，但是转化为树结构和生成树的时间并不会太短。


#### 为什么不用二叉树

红黑树是一种平衡的二叉树，其插入、删除、查找的最坏时间复杂度都为 `O(logn)`，避免了二叉树最坏情况下的 O(n) 时间复杂度。

#### 为什么不用平衡二叉树

平衡二叉树是比红黑树更严格的平衡树，为了保持保持平衡，需要旋转的次数更多，也就是说平衡二叉树保持平衡的效率更低，所以平衡二叉树插入和删除的效率比红黑树要低。

### 线程不安全


HashMap 不是线程安全的，多线程下扩容死循环。可以使用如下线程安全的容器
1. HashTable
2. Collections.synchronizedMap
3. ConcurrentHashMap

HashTable 是在每个方法加上 `synchronized` 关键字，粒度比较大。

`Collections.synchronizedMap` 是使用 `Collections` 集合工具的内部类，通过传入 Map 封装出一个 `SynchronizedMap` 对象，内部定义了一个对象锁，方法内通过对象锁实现。

**`ConcurrentHashMap` 在 JDK 1.7 中使用分段锁，在 JDK 1.8 中使用`CAS + synchronized`。**
## HashTable
* `HashMap` 是线程不安全的，`HashTable` 是线程安全的。`HashTable` 早期使用较多，目前不建议在开发中使用。
* `HashTable` 是线程安全的，在 `put` 和 `get` 操作都是加了 `synchronized` 锁，所以效率较差。
* `HashMap` 允许空的 `key` 和 `value` 值，`HashTable` 不允许空的 `key` 和 `value` 值。
* `HashTable` 的初始长度是 11，之后每次扩充容量变为之前的 `2n+1`。`HashMap` 的默认初始容量是 16，之后每次扩容变为之前的两倍。



## ConcurrentHashMap

* ref 1-[ConcurrentHashMap | 线程安全容器](https://juejin.cn/post/7056572041511567367)


`HashMap` 不是一个线程安全的容器，并发场景下推荐使用 `ConcurrentHashMap` 或 `Collections.synchronizedMap(new HashMap())`。


### 线程安全的实现

* ref 1-[为什么ConcurrentHashMap是线程安全的](https://blog.51cto.com/u_15492510/4965866)


> **`ConcurrentHashMap` 在 JDK 1.7 中使用分段锁，在 JDK 1.8 中使用`CAS + synchronized`。**

`ConcurrentHashMap` 是一个线程安全的容器，在 JDK 不同的版本中，实现线程安全的方案是不一样的。
1. JDK 7 中，通过分段锁实现线程安全的，分段锁使用的是 `ReentrantLock`。
2. JDK 8 中，通过 CAS 或 `synchronized` 锁头节点实现线程安全，锁的粒度小于分段锁，发生冲突和锁竞争的频率降低了，并发操作的性能得到了提高。


#### JDK 1.7 的底层数据结构

ConcurrentHashMap 在不同的 JDK 版本中实现是不同的，在 JDK 1.7 中，它使用的是数组加链表的形式实现的，而数组又分为
1. 大数组 Segment 
2. 小数组 HashEntry

大数组 Segment 可以理解为 MySQL 中的数据库，而每个数据库（Segment）中又有很多张表 HashEntry，每个 HashEntry 中又有多条数据，这些数据是用链表连接的，如下图所示。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/concurrent-hashmap-jdk1.7-1.png)

#### JDK 1.7 的线程安全


接下来，我们通过添加元素 put 方法，来看 JDK 1.7 中 ConcurrentHashMap 是如何保证线程安全的，具体实现源码如下。


```java
final V put(K key, int hash, V value, boolean onlyIfAbsent) {
    // 在往该 Segment 写入前，先确保获取到锁
    HashEntry<K,V> node = tryLock() ? null : scanAndLockForPut(key, hash, value); 
    V oldValue;
    try {
        // Segment 内部数组
        HashEntry<K,V>[] tab = table;
        int index = (tab.length - 1) & hash;
        HashEntry<K,V> first = entryAt(tab, index);
        for (HashEntry<K,V> e = first;;) {
            if (e != null) {
                K k;
                // 更新已有值...
            }
            else {
                // 放置 HashEntry 到特定位置，如果超过阈值则进行 rehash
                // 忽略其他代码...
            }
        }
    } finally {
        // 释放锁
        unlock();
    }
    return oldValue;
}
```


从上述源码我们可以看出，Segment 本身是基于 `ReentrantLock` 实现的加锁和释放锁的操作，这样就能保证多个线程同时访问 ConcurrentHashMap 时，同一时间只有一个线程能操作相应的节点，这样就保证了 ConcurrentHashMap 的线程安全了。

也就是说 ConcurrentHashMap 的线程安全是建立在 Segment 加锁的基础上的，所以我们把它称之为「分段锁」或「片段锁」，如下图所示。



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/concurrent-hashmap-jdk1.7-2.png)

#### JDK 1.8 的底层数据结构


JDK 1.7 中，ConcurrentHashMap 虽然是线程安全的，但因为它的底层实现是数组 + 链表的形式，所以在数据比较多的情况下访问是很慢的，因为要遍历整个链表，而 JDK 1.8 则使用了「数组 + 链表/红黑树」的方式优化了 ConcurrentHashMap 的实现，具体实现结构如下。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/concurrent-hashmap-jdk1.8-1.png)


链表升级为红黑树的规则是，当链表长度大于 8，并且数组的长度大于 64 时，链表就会升级为红黑树的结构。

> ConcurrentHashMap 在 JDK 1.8 虽然保留了 Segment 的定义，但这仅仅是为了保证序列化时的兼容性，不再有任何结构上的用处了。





#### 二叉查找树

二叉查找树（`Binary Search Tree`）是指一棵空树或者具有下列性质的二叉树
1. 若任意节点的左子树不空，则左子树上所有节点的值均小于它的根节点的值
2. 若任意节点的右子树不空，则右子树上所有节点的值均大于它的根节点的值
3. 任意节点的左、右子树也分别为二叉查找树


#### 红黑树

红黑树是每个节点都带有颜色属性的二叉查找树，颜色为红色或黑色。在二叉查找树强制一般要求以外，对于任何有效的红黑树我们增加了如下的额外要求
1. 节点是红色或黑色
2. 根是黑色
3. 所有叶子都是黑色（叶子是 NIL 节点）
4. 每个红色节点必须有两个黑色的子节点；或者说从每个叶子到根的所有路径上不能有两个连续的红色节点；或者说不存在两个相邻的红色节点，相邻指两个节点是父子关系；或者说红色节点的父节点和子节点均是黑色的
5. 从任一节点到其每个叶子的所有简单路径都包含相同数目的黑色节点

这些约束确保了红黑树的关键特性：从根到叶子的最长的可能路径不多于最短的可能路径的两倍长。

该特性可以保证这个树大致上是平衡的。如插入、删除和查找某个值的操作的最坏情况时间，都要求与树的高度成比例，这个在高度上的理论上限允许红黑树在最坏情况下都是高效的，而不同于普通的二叉查找树。


> **红黑树是二叉树，B+树是多路树。**

#### JDK 1.8 的线程安全

在 JDK 1.8 中 ConcurrentHashMap 使用的是 「`CAS` + `volatile`」 或 「`synchronized`」 的方式来保证线程安全的，它的核心实现源码如下。


```java
final V putVal(K key, V value, boolean onlyIfAbsent) { if (key == null || value == null) throw new NullPointerException();
    int hash = spread(key.hashCode());
    int binCount = 0;
    for (Node<K,V>[] tab = table;;) {
        Node<K,V> f; int n, i, fh; K fk; V fv;
        if (tab == null || (n = tab.length) == 0)
            tab = initTable();
        else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) { // 节点为空
            // 利用 CAS 去进行无锁线程安全操作，如果 bin 是空的
            if (casTabAt(tab, i, null, new Node<K,V>(hash, key, value)))
                break; 
        }
        else if ((fh = f.hash) == MOVED)
            tab = helpTransfer(tab, f);
        else if (onlyIfAbsent
                 && fh == hash
                 && ((fk = f.key) == key || (fk != null && key.equals(fk)))
                 && (fv = f.val) != null)
            return fv;
        else {
            V oldVal = null;
            synchronized (f) {
                   // 细粒度的同步修改操作... 
                }
            }
            // 如果超过阈值，升级为红黑树
            if (binCount != 0) {
                if (binCount >= TREEIFY_THRESHOLD)
                    treeifyBin(tab, i);
                if (oldVal != null)
                    return oldVal;
                break;
            }
        }
    }
    addCount(1L, binCount);
    return null;
}
```

从上述源码可以看出，在 JDK 1.8 中，添加元素时首先会判断容器是否为空，如果为空则使用 volatile 加 CAS 来初始化。如果容器不为空则根据存储的元素计算该位置是否为空，如果为空则利用 CAS 设置该节点；如果不为空则使用 synchronize 加锁，遍历桶中的数据，替换或新增节点到桶中，最后再判断是否需要转为红黑树，这样就能保证并发访问时的线程安全了。


**我们把上述流程简化一下，我们可以简单的认为在 JDK 1.8 中，ConcurrentHashMap 是在头节点加锁来保证线程安全的，锁的粒度相比 Segment 来说更小了，发生冲突和加锁的频率降低了，并发操作的性能就提高了。**

而且 JDK 1.8 使用的是红黑树，优化了之前的固定链表，那么当数据量比较大的时候，查询性能也得到了很大的提升，从之前的 `O(n)` 优化到了 `O(logn)` 的时间复杂度，具体加锁示意图如下。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/concurrent-hashmap-jdk1.8-2.png)



### key和value都不允许null
* ref 1-[为什么HashMap的key允许空值，而HashTable却不允许 | 华为云](https://www.huaweicloud.com/articles/8d3ef8118b0492dc7dc0355f57c1d1cf.html)
* ref 2-[ConcurrentMap不允许value为null | Segmentfault](https://segmentfault.com/a/1190000021105716)



在「投放@JD」开发中遇到如下问题
1. 代码重构优化，将集合类型从 `HashMap` 修改为了 `ConcurrentHashMap`
2. 在向 `ConcurrentHashMap` 类型的集合中插入元素时，未进行非空判断，导致线上抛出空指针异常。


```java
// 从上游请求得到 skuDcInfoMap，将其属性值放入结果集 assembleInfo中
// assembleInfo 类型是 ConcurrentHashMap<String, Object>

assembleInfo.put(ProductInfoMapKeys.WARE_STOCK_NUM, skuDcInfoMap.get("bb"));

//未对 bb属性值进行null判断，线上可能会抛出空指针异常
```



上述产生异常的原因是
* `HasMap` 是一个线程不安全的容易，允许 `key` 和 `value` 为 `null`。`HashMap` 部分源码如下。可以看到，`HashMap` 在 `put` 的时候会调用 `hash()` 方法来计算 `key` 的 `hashcode` 值，当 `key == null` 时返回的值为 0。

```java
//HashMap 部分源码
public V put(K key, V value) {
    return putVal(hash(key), key, value, false, true);
}
    
static final int hash(Object key) {
    int h;
    return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
}
```

* `ConcurrentHashMap` 是一个线程安全的容易，不允许 `key` 和 `value` 为 `null`。`ConcurrentHashMap` 部分源码如下，可见在 `putVal()` 中，若 `key` 或 `value` 为 `null`，会直接抛出 NPE。

```java
public V put(K key, V value) {
    return putVal(key, value, false);
}

final V putVal(K key, V value, boolean onlyIfAbsent) {
    if (key == null || value == null) throw new NullPointerException();
        
    int hash = spread(key.hashCode());
    // ...
}
```

查看完源码后，下面分析为什么 `ConcurrentHashMap` 不支持 `null` 键和 `null` 值。
* `ConcurrentHashMap` 是一个线程安全容器，若支持 `null` 键和 `null` 值，就会存在一个问题，当通过 `get(k)` 获取对应的 `value` 时，如果获取到的是 `null` 时，你无法判断它是 `put(k,v)` 的时候 `value` 为 `null`，还是这个 `key` 从来没有做过映射，即造成「二义性」。
* `HashMap` 是非并发的，可以通过 `containsKey(key)` 来做这个判断。而支持并发的 `ConcurrentHashMap` 在调用 `map.containsKey(key)` 和 `map.get(key)` 时，`map` 可能已经不同了。


> **总结而言，`null` 会带来二义性，但非并发的 `HashMap` 可通过 `containsKey()` 和 `get()` 进一步判断来消除二义性。**



## List

### ArrayList与LinkedList区别

| ArrayList	|  LinkedList | 
|-----------|------------|
|   数组	 | 双向链表 | 
| 增删的时候在扩容的时候慢，通过索引查询快，通过对象查索引慢 | 增删快，通过索引查询慢，通过对象查索引慢 | 
| 当数组无法容纳下此次添加的元素时进行扩容	| 无 | 
| 扩容之后容量为原来的 1.5 倍	| 无 |

### ArrayList
* ArrayList 是基于数组实现的，是一个动态数组，其容量能自动增长。
* ArrayList 不是线程安全的，只能用在单线程环境下。


#### 扩容

```java
//无参构造函数
public ArrayList();

//指定初始大小的构造函数
public ArrayList(int initialCapacity) 
```

在创建 `ArrayList` 时，若指定大小，则会创建一个容量为 `initialCapacity` 的对象。

调用无参构造函数时，会创建一个初始容量为 0 的数组，当真正对数组进行添加时，才真正分配容量。

ArrayList 的扩容，是在容量不够时候才进行扩容（这点和 HashMap 不同，ArrayList 并没有负载因子的概念）
1. 若初始化创建时没有指定大小，则会创建一个初始容量为 0 的对象
2. 在第一次真正插入元素时候，才去分配空间，第一次扩容会默认分配 10 个对象空间
3. ArrayList 并没有负载因子的概念，只有当空间不够时候才进行扩容，这点和 HashMap 不同
4. 后续插入元素时，若发现元素不够，进行非首次扩容。非首次扩容，会按照当前容量的 1.5 倍扩容（HashMap 有负载因子的概念，可以提前扩容，每次扩容后，`capacity` 变为原来的两倍）


#### 线程不安全和如何并发修改改造

* [如何改造 ArrayList，保证线程安全](https://blog.51cto.com/knifeedge/5011564)





ArrayList 不是线程安全的，只能用在单线程环境下。

那么，如何进行改造，保证线程安全呢？



| 方法  |  示例   |   原理  |
|------|--------|----------|
| Vector  | `List list = new ArrayList();` 替换为 `List arrayList = new Vector<>();` | 使用了 `synchronized` 关键字 |
| `Collections.synchronizedList(list)` | `List<String> list = Collections.synchronizedList(new ArrayList<String>());`  | `Object mutex = new Object()`，对此对象使用`synchronized` |
| JUC 中的 `CopyOnWriteArrayList` | `CopyOnWriteArrayList<String> list = new CopyOnWriteArrayList<String>();` | 适用于读多写少的并发场景 |



1. 思路1：加锁，使用 `synchronized` 对 `add()` 方法加锁。如下代码也是 `Vector` 的实现，`Vector` 是一个线程安全的容器。


```java
public synchronized void addElement(E obj) {
    modCount++;
    ensureCapacityHelper(elementCount + 1);
    elementData[elementCount++] = obj;
}
```

1. 思路2：使用 `Collections.synchronizedList` 修饰

```java
List list = Collections.synchronizedList(new ArrayList());
```

3. 思路2：Java提供的读写分离的、线程安全的容器 `CopyOnWriteArrayList` 


## 线程安全容器

1. HashTable 和 Vector （不推荐使用）
2. ConcurrentHashMap 和 ConcurrentHashSet
3. List 类型的 CopyOnWriteArrayList
4. ConcurrentLinkedQueue
5. ArrayBlockingQueue 阻塞队列
6. Collections 类中提供的静态工厂方法创建的类，如 `Collections.synchronizedList`



## HashMap、ArrayList、HashTable的扩容表现
1. Hashtable 初始容量是 11，扩容方式为 2N+1
2. HashMap 初始容量是 16，扩容方式为 2N
3. ArrayList 初始容量是 0（第一次扩容为 10），后续非第一次扩容为 1.5N　　


## TreeMap

TreeMap 是底层利用红黑树实现的 Map 结构，底层实现是一棵平衡的排序二叉树，由于红黑树的插入、删除、遍历时间复杂度都为 O(logN)，所以性能上低于哈希表。但是哈希表无法提供键值对的有序输出，红黑树可以按照键的值的大小有序输出。


## Set

Set 其实是通过 Map 实现的，所以我们可以在 HashSet 等源码中看到一个 Map 类型的成员变量。

```java
public class HashSet<E> extends AbstractSet<E> 
    implements Set<E>, Cloneable, java.io.Serializable 
{
    private transient HashMap<E,Object> map;
}
```

这个 Map 的具体实现在不同类型的 Set 中也不尽相同，比如
1. 在 HashSet 中，这个 Map 的类型是 HashMap
2. 在 TreeSet 中，这个 Map 的类型是 TreeMap（底层基于红黑树实现）
3. 在 LinkedHashSet 中，这个 Map 的类型是 LinkedHashMap


### HashSet、LinkedHashSet、TreeSet的区别

| 比较项 | HashSet | LinkedHashSet | TreeSet |
|-------|---------|---------------|---------|
| 有序性 | 不维护对象的插入顺序 | 维护对象的插入顺序 | 基于红黑树实现，根据提供的 Comparator 对元素进行排序 |
| 比较方式 | 使用 equals() 和 hashCode() 方法比较对象 | 使用 equals() 和 hashCode() 方法比较对象 | 使用 compare() 和 compareTo() 方法比较对象 |
| 是否允许存储空值 | 允许存储一个 null 值 | 允许存储一个 null 值 | 不允许存储 null |

## FAQ

### HashMap初始化容量大小

* [准备用 HashMap 存 1W 条数据，构造时传 10000 还会触发扩容吗](https://juejin.cn/post/6844903983748743175)




在 HashMap 中，提供了一个指定初始容量的构造方法 `HashMap(int initialCapacity)`。如果不指定，则默认容量是 16。

初始化方法中，默认的装载因子 `DEFAULT_LOAD_FACTOR` 是 0.75f。

查看如下源码，可以发现，初始化构造方法传入的 `initialCapacity`，并不表示初始化的 HashMap 的容量就是 `initialCapacity`。`initialCapacity` 会被 `tableSizeFor()` 方法动态调整为 2 的 N 次幂。

比如初始化时候，传入初始大小 13，经过 `tableSizeFor()` 调整后，最接近的 2 的 N 次幂，是 16。所以最终的 HashMap 的容量大小是 16。



```java
public class HashMap<K,V> extends AbstractMap<K,V>
    implements Map<K,V>, Cloneable, Serializable {

   public HashMap(int initialCapacity) {
        this(initialCapacity, DEFAULT_LOAD_FACTOR);
    }
    
    public HashMap(int initialCapacity, float loadFactor) {
        if (initialCapacity < 0)
            throw new IllegalArgumentException("Illegal initial capacity: " +
                                               initialCapacity);
        if (initialCapacity > MAXIMUM_CAPACITY)
            initialCapacity = MAXIMUM_CAPACITY;
        if (loadFactor <= 0 || Float.isNaN(loadFactor))
            throw new IllegalArgumentException("Illegal load factor: " +
                                               loadFactor);
        this.loadFactor = loadFactor;
        this.threshold = tableSizeFor(initialCapacity);
    }

    static final int tableSizeFor(int cap) {
        int n = cap - 1;
        n |= n >>> 1;
        n |= n >>> 2;
        n |= n >>> 4;
        n |= n >>> 8;
        n |= n >>> 16;
        return (n < 0) ? 1 : (n >= MAXIMUM_CAPACITY) ? MAXIMUM_CAPACITY : n + 1;
    }

    ... 
}
```



当实际 KV 个数超过 threshold 时，HashMap 会将容量扩容，扩容为现在容量的两倍。

```s
threshold ＝ 容量 capacity * 装载因子loadFactor
```

回到本题场景中，若初始化指定容量为 1W，实际上经过 `tableSizeFor()` 方法处理之后，就会变成 2 的 14 次幂，即  16384。考虑到负载因子 0.75f，实际在不触发扩容的前提下，可存储的数据容量是 12288（16384 * 0.75f）。

所以，此时若插入 1W 条数据，并不会触发 HashMap 的扩容。


### HashMap到底是插入链表头部还是尾部

* [HashMap到底是插入链表头部还是尾部 | CSDN](https://blog.csdn.net/qq_33256688/article/details/79938886)
  
HashMap 中插入新元素，在 JDK 1.8 之前是插入头部的，在 JDK 1.8 中是插入尾部的。
1. JDK 1.8 之前，会使用新插入的元素和当前 Entry，生产一个新的 Entry，然后用新的 Entry 取代旧的 Entry


### HashMap默认的加载因子为何选择0.75F
* [HashMap默认加载因子为什么选择0.75](https://www.cnblogs.com/aspirant/p/11470928.html)


**从「提高空间利用率」和「减少查询成本」两个角度考虑，依据「泊松分布」，取一个折中值，取 0.75 时，即可以保证空间利用率，又可以减少不必要的哈希碰撞。**
1. 加载因子过低，例如 0.5，虽然可以减少查询时间成本，但是空间利用率很低，同时提高了 `rehash` 操作的次数。
2. 加载因子过高，例如为 1，虽然减少了空间开销，提高了空间利用率，但同时也增加了查询时间成本。
3. 选择 0.75 作为默认的加载因子，完全是时间和空间成本上寻求的一种折衷选择。

> 泊松分布和 0.75

在理想情况下，使用随机哈希码，节点出现的频率在 hash 桶中遵循「泊松分布」。当采用 0.75 作为加载因子时，每个碰撞位置的链表长度超过 ８ 个是几乎不可能的。



### HashMap的初始容量和扩容为什么都是2^N 

* [HashMap初始容量为什么是2的n次幂及扩容为什么是2倍的形式 | CSDN](https://blog.csdn.net/Apeopl/article/details/88935422)



HashMap 中添加元素时，会调用 `putVal` 方法，源码如下。重点观察 `(p = tab[i = (n - 1) & hash])` 这一行的逻辑处理。


```java
 final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                   boolean evict) {
        Node<K,V>[] tab; Node<K,V> p; int n, i;
        if ((tab = table) == null || (n = tab.length) == 0)
            n = (tab = resize()).length;
        if ((p = tab[i = (n - 1) & hash]) == null)
            tab[i] = newNode(hash, key, value, null);
        else {
            Node<K,V> e; K k;
            if (p.hash == hash &&
                ((k = p.key) == key || (key != null && key.equals(k))))
                e = p;
            else if (p instanceof TreeNode)
                e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
            else {
                for (int binCount = 0; ; ++binCount) {
                    if ((e = p.next) == null) {
                        p.next = newNode(hash, key, value, null);
                        if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
                            treeifyBin(tab, hash);
                        break;
                    }
                    if (e.hash == hash &&
                        ((k = e.key) == key || (key != null && key.equals(k))))
                        break;
                    p = e;
                }
            }
            if (e != null) { // existing mapping for key
                V oldValue = e.value;
                if (!onlyIfAbsent || oldValue == null)
                    e.value = value;
                afterNodeAccess(e);
                return oldValue;
            }
        }
        ++modCount;
        if (++size > threshold)
            resize();
        afterNodeInsertion(evict);
        return null;
    }
```

向集合中添加元素时，会使用 `(n - 1) & hash` 的计算方法来得出该元素在集合中的位置。符号 `&` 是按位与的计算，这是位运算，计算机能直接运算，特别高效，按位与 `&` 的计算方法是，只有当对应位置的数据都为 `1` 时，运算结果也为 `1`。当 HashMap 的容量是 2 的 n 次幂时，`(n-1)` 的 `2` 进制也就是 `1111111***111` 这样形式的，这样与添加元素的 `hash` 值进行位运算时，**能够充分的散列**，使得添加的元素均匀分布在 HashMap 的每个位置上，减少 hash 碰撞。


所以综上，使用 2 的 n 次幂作为容量，其好处是
1. 计算方便
2. hash 分布更均匀