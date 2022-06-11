
# Java-15-Java中的集合

[TOC]

## 更新
* 2020/06/14，撰写


## 参考资料




## 集合总览

Java 集合就像一个容器，可以存储任何类型的数据，也可以结合泛型来存储具体的类型对象。**在程序运行时，Java 集合可以动态的进行扩展，随着元素的增加而扩大。在 Java 中，集合类通常存在于 `java.util` 包中，Java 集合使用统一的 `Iterator` 遍历。**

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






## Queue
* ref 1-[接口 Deque<E>](http://itmyhome.com/java-api/java/util/Deque.html)

此处重点介绍下 `Deque`，它是一个双端队列，常用的方法如下。




| 操作 |  头部-抛异常 | 头部-不抛异常 | 尾部-抛异常  | 尾部-不抛异常 |
|---------|----------------|---------|----------|------|-------|------|
| 插入|  addFirst(e) | offerFirst(e) |  addLast(e) | offerLast(e) |
| 删除|  removeFirst() | pollFirst() |  removeLast() | pollLast() |
| 检查|  getFirst() | peekFirst() |  getLast() | peekLast() |






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

HashMap 在 `put` 的元素数量大于临界值 `threshold` 时，即 `Capacity * LoadFactor`（默认 `16 * 0.75`） 之后会进行扩容。每次扩容后，`capacity` 变为原来的两倍。


```s
threshold = loadFactor * capacity
```


关于 HashMap 的扩容和容量，给出下面两个常见的问题

> 1.如果 `new HashMap<>(19)`，`bucket` 数组多大？
* HashMap 的 `bucket` 数组大小一定是 2 的幂（内部通过移位运算进行扩容），如果 `new` 的时候指定了容量且不是 2 的幂，实际容量会是最接近(大于)指定容量的 2 的幂。
* 如果 `new HashMap<>(19)`，比 19 大且最接近的 2 的幂是 32，因此实际的 `bucket` 数组容量是 32。



> 2.HashMap 什么时候开辟 bucket 数组占用内存
* HashMap 在 `new` 后并不会立即分配 `bucket` 数组，而是第一次 `put` 时初始化。类似 `ArrayList` 在第一次 `add` 时分配空间。



###  集合初始化时指定集合大小

阿里巴巴《Java开发手册》中指出，在集合初始化时，要指定集合大小。


> 【推荐】 集合初始化时，指定集合初始值大小
>
> 说明：HashMap 使用 HashMap（int initialCapacity） 初始化


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
* 当 HashMap 元素个数小于 8 时，采用链表存储
* 当 HashMap 元素个数大于 8 时，链表的查找效率较低，会使用红黑树进行存储。





## HashTable
* `HashMap` 是线程不安全的，`HashTable` 是线程安全的。`HashTable` 早期使用较多，目前不建议在开发中使用。
* `HashTable` 是线程安全的，在 `put` 和 `get` 操作都是加了 `synchronized` 锁，所以效率较差。
* `HashMap` 允许空的 `key` 和 `value` 值，`HashTable` 不允许空的 `key` 和 `value` 值。
* `HashTable` 的初始长度是 11，之后每次扩充容量变为之前的 `2n+1`。`HashMap` 的默认初始容量是 16，之后每次扩容变为之前的两倍。



## ConcurrentHashMap

* ref 1-[ConcurrentHashMap | 线程安全容器](https://juejin.cn/post/7056572041511567367)


`HashMap` 不是一个线程安全的容器，并发场景下推荐使用 `ConcurrentHashMap` 或 `Collections.synchronizedMap(new HashMap())`。


### 线程安全的实现

`ConcurrentHashMap` 是一个线程安全的容器，在 JDK 不同的版本中，实现线程安全的方案是不一样的。
1. JDK 7 中，通过分段锁实现线程安全的，分段锁使用的是 `ReentrantLock`
2. JDK 8 中，通过 CAS 或 `synchronized` 锁头节点实现线程安全，锁的粒度小于分段锁，发生冲突和锁竞争的频率降低了，并发操作的性能得到了提高。



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

