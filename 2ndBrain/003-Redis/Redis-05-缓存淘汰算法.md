

# Redis-05-缓存淘汰算法




[TOC]

## 更新
* 2022/05/14，撰写
* 2022/05/22，添加 *Window TinyLfu*


## 参考资料
* [图解 LRU LFU ARC FIFO 缓存淘汰算法 | 掘金](https://juejin.cn/post/6923510255154528263)
* [缓存淘汰算法的代码实现 | Blog](https://www.sakuratears.top/blog/%E7%BC%93%E5%AD%98%E6%B7%98%E6%B1%B0%E7%AE%97%E6%B3%95%EF%BC%88LFU%E3%80%81LRU%E3%80%81FIFO%E3%80%81ARC%E3%80%81MRU%EF%BC%89.html)
* [Redis深度历险 | 掘金小册](https://juejin.cn/book/6844733724618129422)




## 缓存淘汰算法的分类

在缓存系统中，常用的缓存淘汰算法包括
* FIFO
* LFU
* LRU
  * LRU-K
  * 2Q
* ARC





### FIFO
* First In First Out，即「先进先出」。
* FIFO（`First In First Out`）按照 “先进先出” 的原理淘汰数据。这正好符合队列的特性，所以，数据结构上使用队列 `Queue` 来实现。
* FIFO算法中，将新访问的数据插入队列尾部，当队列满时，淘汰队列头部的数据。
* 优点：实现简单
* 缺点：无法根据数据的使用频次、时间等维度进行优化，会导致缓存命中率降低。



### LFU
* Least Frequently Used，即「最近最不常用」。
* 优点：高频使用的数据，可以较长的保存不被淘汰。
* 缺点
  1. 需要给每个记录项维护频率信息，每次访问都需要更新，这是个巨大的开销
  2. 无法缓存某一时间点的热点数据。对突发性的稀疏流量无力，因为前期经常访问的记录已经占用了缓存。


> Caffeine 中使用了 `Window TinyLfu` 算法，是对 LFU 算法的一种改进。


### LRU
* Least Recently Used，即「最近最少使用」。
* LRU 算法使用页面置换算法，会首先淘汰最长时间未被使用的数据。
* 优点：热点数据，可以较长的保存不被淘汰
* 缺点：当某一时间节点产生了大量仅访问了**一次**的数据，热点数据会被淘汰



### LRU的改进算法

LRU算法中，当某一时间节点，产生了大量仅访问了**一次**的数据，会造成热点数据的淘汰。为此，可以对 LRU 算法进行改进，对「最近访问页面的次数」进行策略优化，由此产生了下面两种算法
1. LRU-K
2. 2Q


#### LRU-K算法
* LRU-K 中的 `K`，指的是指最近访问页面的次数。
* 上文介绍的 LRU 算法，其实就是 LRU-1，该算法中，仅访问 1 次就能淘汰其余缓存，这会造成 “缓存污染”。解决思路就是提高这个阈值判断，将 1 次提升到 K 次，这就是 LRU-K 算法。
* LRU-K 算法中需要维护两个队列：历史队列和缓存队列。
  * 历史队列保存着每次访问的页面，当页面访问次数达到了 k 次，该页面出栈，并保存至缓存队列；
  * 若尚未达到 k 次则继续保存，直至历史队列也满了，那就根据一定的缓存策略（FIFO、LRU、LFU）进行淘汰；
  * 缓存队列则是保存已经访问 k 次的页面，当该队列满了之后，则淘汰最后一个页面，**也就是第 K 次访问距离现在最久的那个页面。**
* LRU-K 算法的核心思想就是将访问一次就能淘汰其余缓存的 “1” 提升为 “K”。
* 优点：避免了仅访问 1 次就能淘汰其余缓存的 “缓存污染” 问题，提高了缓存命中率。
* 缺点：多维护了一个历史队列，消耗内存较高。
  
#### 2Q
* Two Queues，简称为 2Q
* 2Q 算法其实是 LRU-K 的一个具体版本，LRU-2。并且 2Q 算法中的历史队列，采用 FIFO 的方法进行缓存的
* 2Q 算法的优缺点同 LRU-K 算法



### ARC
* Adaptive Replacement Cache，即「自适应缓存替换」算法，是一种自适应性 Cache 算法, 它结合了 LRU 与 LFU。
* ARC 算法中，使用了 4 个链表：
  * LRU 和 LRU Ghost
  * LFU 和 LFU Ghost
  * Ghost 链表为对应淘汰的数据记录链表，不记录数据，只记录 ID 等信息
  * 当数据 A 要缓存时，先加入 LRU 链表；若 A 再次被访问，则同时被加入到 LFU 链表中。所以 LFU 链表的缓存的是 LRU 链表中多次被访问的数据。
  * 当 LRU 链表淘汰了 A，则将 A 存入到 LRU Ghost 链表。如果数据 A 在之后再次被访问，则增加 LRU 链表的大小，同时缩减 LFU 链表的大小。
  * LFU 链表同理。
* 优点：可以根据被淘汰数据的访问情况，自适应地动态地增加 LRU 或 LFU 链表的大小。
* 缺点：占用内存较多




## 缓存淘汰算法的数据结构实现

* ref 1-[缓存淘汰算法 FIFO、LRU、LFU、ARC | Blog](https://www.sakuratears.top/blog/%E7%BC%93%E5%AD%98%E6%B7%98%E6%B1%B0%E7%AE%97%E6%B3%95%EF%BC%88LFU%E3%80%81LRU%E3%80%81FIFO%E3%80%81ARC%E3%80%81MRU%EF%BC%89.html)


对于 FIFO、LRU、LFU、ARC缓存淘汰算法的数据结构实现，详情见上述参考资料 *ref-1*，此处仅做大纲记录。



### LRU算法的实现

* [LeetCode-146. LRU 缓存](https://leetcode.cn/problems/lru-cache/)


#### 借助Java的LinkedHashMap

借助 Java 的 `LinkedHashMap` 数据结构，可实现 LRU 算法。`LinkedHashMap` 类的 `accessOrder` 参数指定了排序方式，默认为 false，采用插入的顺序。若设为 true，则基于访问的顺序。**`accessOrder = true` 时，`LinkedHashMap` 会将最近一次访问的元素，移动到链表的尾部。** 同时，如果重写了该类的 `removeEldestEntry` 方法，当 `LinkedHashMap` 容量不够时，会将链表头部的元素删除。



```java
class LRUCache extends LinkedHashMap<Integer, Integer>{
    private int capacity;
    
    public LRUCache(int capacity) {
        //设定accessOrder为true 基于访问的顺序
        //链表尾部元素是最近一次访问的元素
        super(capacity, 0.75F, true); 
        this.capacity = capacity;
    }

    public int get(int key) {
        return super.getOrDefault(key, -1);
    }

    public void put(int key, int value) {
        super.put(key, value);
    }

    @Override
    protected boolean removeEldestEntry(Map.Entry<Integer, Integer> eldest) {
        return size() > capacity; 
    }
}
```


#### 哈希表+双向链表

可以通过哈希表辅以双向链表实现 LRU 算法。
1. 双向链表按照被使用的顺序存储了这些键值对，靠近头部的键值对是最近使用的，而靠近尾部的键值对是最久未使用的。若有新元素插入，将其插入到链表头部。淘汰元素时，删除链表尾部的节点。
2. 哈希表即为普通的哈希映射（HashMap），通过缓存数据的键映射到其在双向链表中的位置。
3. 在双向链表的实现中，使用一个伪头部（dummy head）和伪尾部（dummy tail）标记界限，这样在添加节点和删除节点的时候就不需要检查相邻的节点是否存在


在实际的 `get()` 和 `put()` 操作时，
1. `get()` 操作时，从哈希表中取出节点，然后再将该节点调整到双向链表的头部
2. `put()` 操作时
   * 若该 key 已经存在，则执行 `get()` 操作（会把节点调整到双向链表的头部），并更新 value 值
   * 若该 key 不存在，则插入一个新的节点，判断下 `size` 和 `capacity` 的关系，若未满，则将其插入到双向链表的头部；否则，还需要将双向链表尾部节点删除


```java
public class LRUCache {
    //带前后指针的节点
    class DLinkedNode {
        int key;
        int value;
        DLinkedNode prev;
        DLinkedNode next;
        public DLinkedNode() {}
        public DLinkedNode(int key, int value) {
            this.key = key; 
            this.value = value;
        }
    }

    //HashMap 用于取元素
    private Map<Integer, DLinkedNode> cache = new HashMap<Integer, DLinkedNode>();
    //双向链表 维护使用频率
    private DLinkedNode head, tail;
    
    private int size;
    private int capacity;
   

    public LRUCache(int capacity) {
        this.size = 0;
        this.capacity = capacity;
        // 使用伪头部和伪尾部节点
        head = new DLinkedNode();
        tail = new DLinkedNode();
        head.next = tail;
        tail.prev = head;
    }

    public int get(int key) {
        DLinkedNode node = cache.get(key);
        if (node == null) {
            return -1;
        }
        // 如果 key 存在，先通过哈希表定位，再移到头部
        moveToHead(node);
        return node.value;
    }

    public void put(int key, int value) {
        DLinkedNode node = cache.get(key);
        if (node == null) {
            // 如果 key 不存在，创建一个新的节点
            DLinkedNode newNode = new DLinkedNode(key, value);
            // 添加进哈希表
            cache.put(key, newNode);
            // 添加至双向链表的头部
            addToHead(newNode);
            ++size;
            if (size > capacity) {
                // 如果超出容量，删除双向链表的尾部节点
                DLinkedNode tail = removeTail();
                // 删除哈希表中对应的项
                cache.remove(tail.key);
                --size;
            }
        }
        else {
            // 如果 key 存在，先通过哈希表定位，再修改 value，并移到头部
            node.value = value;
            moveToHead(node);
        }
    }

    private void addToHead(DLinkedNode node) {
        node.prev = head;
        node.next = head.next;
        head.next.prev = node;
        head.next = node;
    }

    private void removeNode(DLinkedNode node) {
        node.prev.next = node.next;
        node.next.prev = node.prev;
    }

    private void moveToHead(DLinkedNode node) {
        removeNode(node);
        addToHead(node);
    }

    private DLinkedNode removeTail() {
        DLinkedNode res = tail.prev;
        removeNode(res);
        return res;
    }
}
```


## Redis的缓存淘汰

* Redis 采用「惰性删除」+「定期删除」的组合策略，对过期数据进行清理。
* 当内存占用超过 `maxmemory` 限制时，Redis 通过「内存淘汰机制」来保证内存不会耗尽。

> 也可以将「内存淘汰机制」理解为一种「主动清理」策略。即 Redis 采用三种策略进行缓存淘汰
> 1. 惰性删除
> 2. 定期删除
> 3. 主动清理


### 过期数据的清理

* ref 1-[Redis 的过期数据会被立马删除么 | 码哥字节](https://mp.weixin.qq.com/s?__biz=MzkzMDI1NjcyOQ==&mid=2247499253&idx=1&sn=816395c3429177bf94448f1750090a89&chksm=c27fbfc3f50836d53ea80d574d8db93cc3d9be0ff9de1d6339024a2b2f476e05eb2110438917&token=563623526&lang=zh_CN&scene=21#wechat_redirect)
* ref 2-[Redis深度历险 | 掘金小册](https://juejin.cn/book/6844733724618129422)，「过期策略」章节



Redis 中，当有 key 过期时，数据会被立马删除吗？答案是不会的。

**Redis 并不会立马删除过期的数据。Redis 采用「惰性删除」+「定期删除」的组合策略，对过期数据进行清理。**


#### 惰性删除

* 当有客户端的请求查询该 key 时，服务端会检查下 key 是否过期，如果过期，则删除该 key。
* 惰性删除相关源码见 `src/db.c` 中的 `expireIfNeeded` 函数。

```cpp
int expireIfNeeded(redisDb *db, robj *key, int force_delete_expired) {
   // key 没有过期，return 0
    if (!keyIsExpired(db,key)) return 0;
    if (server.masterhost != NULL) {
        if (server.current_client == server.master) return 0;
        if (!force_delete_expired) return 1;
    }

    if (checkClientPauseTimeoutAndReturnIfPaused()) return 1;

    /* Delete the key */
    deleteExpiredKeyAndPropagate(db,key);
    return 1;
}
```


#### 定期删除

> Redis 过期键值删除使用的是贪心策略，它每秒会进行 10 次过期扫描（即每100ms扫描一次），此配置可在 `redis.conf` 进行配置，默认值是 `hz 10`，Redis 会随机抽取 20 个值，删除这 20 个键中过期的键，如果过期 key 的比例超过 25% ，重复执行此流程。


* 如果仅采用「惰性删除」策略清理过期数据，会产生内存浪费的问题。比如，某 key 过期后一直无客户端的访问请求，则该 key 的数据会一直占用内用。
* 为解决上述问题，Redis 在采用「惰性删除」策略的同时，也采用了「定期删除」策略。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-expire-data-del-time-1.png)



如上图所示，「定期删除」策略的步骤如下
* Redis 会将设置了过期时间的 key 放入到一个独立的字典中，在「定期删除」策略中，会定时遍历这个字典，删除过期的数据
* Redis 默认会每秒进行十次「过期扫描」，即每 100ms 执行一次。过期扫描不会遍历过期字典中所有的 key，而是采用了一种简单的「贪心策略」
   1. 从过期字典中随机 20 个 key（并不会检查所有的库，所有的键，会随机选取）；
   2. 删除这 20 个 key 中已经过期的 key；
   3. 如果过期的 key 比率超过 25%，那就重复步骤 1；
* 同时，为了保证过期扫描不会出现循环过度，导致线程卡死现象，算法还增加了扫描时间的上限，默认不会超过 25ms。




**我们要尽量避免大量数据同时失效。** 这是因为
1. 如果在大型系统中有大量缓存在同一时间同时过期，那么会导致 Redis 循环多次持续扫描删除过期字典，直到过期字典中过期键值被删除的比较稀疏为止，而在整个执行过程会导致 Redis 的读写出现明显的卡顿，卡顿的另一种原因是内存管理器需要频繁回收内存页，因此也会消耗一定的 CPU。
2. 为了避免这种卡顿现象的产生，我们需要预防大量的缓存在同一时刻一起过期，就简单的解决方案就是在过期时间的基础上添加一个指定范围的随机数。





#### 从库的过期策略
* 从库不会进行过期扫描，从库对过期的处理是被动的。
* 主库在 key 到期时，会在 AOF 文件里增加一条 DEL 指令，同步到所有的从库，从库通过执行这条 DEL 指令来删除过期的 key。
* 因为指令同步是异步进行的，所以主库过期的 key 的 DEL 指令没有及时同步到从库的话，会出现主从数据的不一致的问题，主库没有的数据在从库里还存在。





### 内存淘汰机制

* ref 1-[Redis 内存满了怎么办？这样置才正确 | 码哥字节](https://mp.weixin.qq.com/s?__biz=MzkzMDI1NjcyOQ==&mid=2247500061&idx=1&sn=b99e32b4cf522bedf8e6adc206fee565&scene=21#wechat_redirect)
* ref 2-[Redis深度历险 | 掘金小册](https://juejin.cn/book/6844733724618129422)，「优胜劣汰 - LRU」章节
* ref 3-[Redis 为何使用近似 LRU 算法淘汰数据，而不是真实 LRU  | 码哥字节](https://mp.weixin.qq.com/s/vBSXc00K-aV50XXBNRjB1A)


**当 Redis 内存超出物理内存限制时，内存的数据会开始和磁盘产生频繁的交换 (swap)。交换会让 Redis 的性能急剧下降，对于访问量比较频繁的 Redis 来说，这样龟速的存取效率基本上等于不可用。**

在生产环境中我们是不允许 Redis 出现交换行为的，为了限制最大使用内存，Redis 提供了配置参数 `maxmemory` 来限制内存超出期望大小。


当实际内存超出 `maxmemory` 时，就会执行一次内存淘汰策略，具体何种内存淘汰策略，可在`maxmemory-policy` 中进行配置。Redis 提供了如下几种策略
1. `noeviction`：不会继续服务写请求 (DEL 请求可以继续服务)，读请求可以继续进行。这样可以保证不会丢失数据，但是会让线上的业务不能持续进行。这是默认的淘汰策略。
2. `volatile-lru`：尝试淘汰设置了过期时间的 key，最少使用的 key 优先被淘汰。**没有设置过期时间的 key 不会被淘汰，这样可以保证需要持久化的数据不会突然丢失。**
3. `volatile-ttl`：跟上面一样，除了淘汰的策略不是 LRU，而是 key 的剩余寿命 ttl 的值，ttl 越小越优先被淘汰。
4. `volatile-random`：跟上面一样，不过淘汰的 key 是过期 key 集合中随机的 key。
5. `allkeys-lru`：区别于 `volatile-lru`，**这个策略要淘汰的 key 对象是全体的 key 集合，而不只是过期的 key 集合。这意味着没有设置过期时间的 key 也会被淘汰。**
6. `allkeys-random`：跟上面一样，不过淘汰的策略是随机的 key。

`volatile-xxx` 策略只会针对带过期时间的 key 进行淘汰，`allkeys-xxx` 策略会对所有的 key 进行淘汰。
* 如果你只是拿 Redis 做缓存，那应该使用 `allkeys-xxx`，客户端写缓存时不必携带过期时间。
* 如果你还想同时使用 Redis 的持久化功能，那就使用 `volatile-xxx` 策略，这样可以保留没有设置过期时间的 key，它们是永久的 key 不会被 LRU 算法淘汰。



#### 近似LRU算法

在 `volatile-lru` 策略中，Redis 并没有采用经典的 LRU 算法，而是采用了一种近似 LRU 算法。


> 为什么不采用经典 LRU 算法
* 实现 LRU 算法除了需要 key/value 字典外，还需要附加一个链表，链表元素的排列顺序，就是元素最近被访问的时间顺序。
* LRU 算法中额外链表的引入，会增加内存的消耗。
* 同时，由于要保证「链表元素的排列顺序，就是元素最近被访问的时间顺序」，当有大量的节点被访问时，就会带来频繁的链表节点移动操作，这也会消耗大量的性能。



> 什么是近似 LRU 算法

* 近似 LRU 算法中，是在现有数据结构的基础上，使用**随机采样**法来淘汰元素，避免额外的内存开销。
* 近似 LRU 算法中，Redis 给每个 key 增加了一个额外的小字段（长度为 24 个 bit），存储了元素最后一次次被访问的时间戳。Redis 会对少量的 key 进行采样，并淘汰采样的数据中最久没被访问过的 key。这也就意味着 Redis 无法淘汰数据库最久访问的数据。
* Redis LRU 算法有一个重要的点在于，它可以更改样本数量（修改 `maxmemory-samples` 属性值）来调整算法的精度，使其近似接近真实的 LRU 算法，同时又避免了内存的消耗，因为每次只需要采样少量样本，而不是全部数据。

```s
# 设置采样数量
maxmemory-samples 50
```


> 近似 LRU 算法的效果怎么样

* 近似 LRU 算法，能达到和 LRU 算法非常近似的效果，两者对比如下图所示。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-expire-data-del-time-2.png)

* 上图中，绿色部分是新加入的 key，深灰色部分是老旧的 key，浅灰色部分是通过 LRU 算法淘汰掉的 key。从图中可以看出，采样数量越大，近似 LRU 算法的效果越接近严格 LRU 算法。
* Redis 3.0 在算法中增加了「淘汰池」，进一步提升了近似 LRU 算法的效果。




