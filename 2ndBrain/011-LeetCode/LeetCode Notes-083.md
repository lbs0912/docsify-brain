
# LeetCode Notes-083


[TOC]



## 更新
* 2022/03/06，撰写
* 2022/06/10，完成



## Overview
* [LeetCode-1114. 按序打印](https://leetcode.cn/problems/print-in-order/)
* [LeetCode-1115. 交替打印 FooBar](https://leetcode.cn/problems/print-foobar-alternately/)
* [LeetCode-146. LRU 缓存](https://leetcode.cn/problems/lru-cache/)
* [LeetCode-剑指 Offer II 031. 最近最少使用缓存](https://leetcode.cn/problems/OrIXps/)
* [LeetCode-面试题 16.25. LRU 缓存](https://leetcode.cn/problems/lru-cache-lcci/)


## 1114. 按序打印
### Description

* [LeetCode-1114. 按序打印](https://leetcode.cn/problems/print-in-order/)

### Approach 1-AtomicInteger


#### Analysis


参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Foo {
    private AtomicInteger firstJobDone = new AtomicInteger(0);
    private AtomicInteger secondJobDone = new AtomicInteger(0);

    public Foo() {
        
    }

    public void first(Runnable printFirst) throws InterruptedException {
        // printFirst.run() outputs "first". Do not change or remove this line.
        printFirst.run();
        firstJobDone.incrementAndGet();
    }

    public void second(Runnable printSecond) throws InterruptedException {
        while (firstJobDone.get() != 1) {
            // waiting for the first job to be done.
        }
        // printSecond.run() outputs "second". Do not change or remove this line.
        printSecond.run();
        secondJobDone.incrementAndGet();
    }

    public void third(Runnable printThird) throws InterruptedException {
        while (secondJobDone.get() != 1) {
            // waiting for the second job to be done.
        }
        // printThird.run() outputs "third". Do not change or remove this line.
        printThird.run();
    }
}
```


### Approach 2-锁


#### Analysis


参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Foo {
    
    private boolean firstFinished;
    private boolean secondFinished;
    private Object lock = new Object();


    public Foo() {
        
    }

    public void first(Runnable printFirst) throws InterruptedException {        
        synchronized (lock) {
            // printFirst.run() outputs "first". Do not change or remove this line.
            printFirst.run();
            firstFinished = true;
            lock.notifyAll(); 
        }
    }

    public void second(Runnable printSecond) throws InterruptedException {
        synchronized (lock) {
            while (!firstFinished) {
                lock.wait();
            }
        
            // printSecond.run() outputs "second". Do not change or remove this line.
            printSecond.run();
            secondFinished = true;
            lock.notifyAll();
        }
    }

    public void third(Runnable printThird) throws InterruptedException {
        synchronized (lock) {
           while (!secondFinished) {
                lock.wait();
            }
            // printThird.run() outputs "third". Do not change or remove this line.
            printThird.run();
        } 
    }
}
```




## 1115. 交替打印 FooBar
### Description

* [LeetCode-1115. 交替打印 FooBar](https://leetcode.cn/problems/print-foobar-alternately/)

### Approach 1-Semaphore


使用信号量 `Semaphore`，每个信号量的 `acquire()` 方法都会阻塞，直到获取一个可用的许可证。

如果线程要访问一个资源就必须先获得信号量。如果信号量内部计数器大于 0，信号量减 1，然后允许共享这个资源；否则，如果信号量的计数器等于 0，信号量将会把线程置入休眠直至计数器大于0。当信号量使用完时，必须释放。



#### Analysis


参考 `leetcode-cn` 官方题解。

#### Solution

```java
class FooBar {
    private int n;
    private Semaphore fooSema = new Semaphore(1);
    private Semaphore barSema = new Semaphore(0);

    public FooBar(int n) {
        this.n = n;
    }

    public void foo(Runnable printFoo) throws InterruptedException {
        for (int i = 0; i < n; i++) {
            fooSema.acquire();//值为1的时候，能拿到，执行下面的操作
            printFoo.run();
            barSema.release();//释放许可给barSema这个信号量 barSema 的值+1
        }
    }

    public void bar(Runnable printBar) throws InterruptedException {
        for (int i = 0; i < n; i++) {
            barSema.acquire();//值为1的时候，能拿到，执行下面的操作
            printBar.run();
            fooSema.release();//释放许可给fooSema这个信号量 fooSema 的值+1
        }
    }
}
```


### Approach 2-Thread.yield()


#### Analysis


参考 `leetcode-cn` 官方题解。

#### Solution


```java
class FooBar {
    private int n;
    volatile boolean fooExec = true;//foo可以执行

    public FooBar(int n) {
        this.n = n;
    }

    public void foo(Runnable printFoo) throws InterruptedException {
        for (int i = 0; i < n; ) {
            if (fooExec) {
                printFoo.run();
                fooExec = false;
                i++;
            } else {
                Thread.yield();
            }
        }
    }

    public void bar(Runnable printBar) throws InterruptedException {
        for (int i = 0; i < n; ) {
            if (!fooExec) {
                printBar.run();
                fooExec = true;
                i++;
            } else {
                Thread.yield();
            }
        }
    }
}

```



### Approach 3-ReentrantLock


#### Analysis


参考 `leetcode-cn` 官方题解。

注意，该方案由于独占锁的独占性，会在 n>5 时候提示超时。

#### Solution

```java
class FooBar {
    private int n;
    private ReentrantLock lock = new ReentrantLock(true);
    volatile boolean fooExec = true;

    public FooBar(int n) {
        this.n = n;
    }

    public void foo(Runnable printFoo) throws InterruptedException {
        for (int i = 0; i < n; ) {
            lock.lock();
            try {
                if (fooExec) {
                    printFoo.run();
                    fooExec = false;
                    i++;
                }
            } finally {
                lock.unlock();
            }

        }
    }

    public void bar(Runnable printBar) throws InterruptedException {
        for (int i = 0; i < n; ) {
            lock.lock();
            try {
                if (!fooExec) {
                    printBar.run();
                    fooExec = true;
                    i++;
                }
            } finally {
                lock.unlock();
            }
        }
    }
}
```

### Approach 4-synchronized


#### Analysis


参考 `leetcode-cn` 官方题解。

#### Solution


```java
class FooBar {
    private int n;
    private Object obj = new Object();
    private volatile boolean fooExec = true;

    public FooBar(int n) {
        this.n = n;
    }

    public void foo(Runnable printFoo) throws InterruptedException {

        for (int i = 0; i < n; i++) {
            synchronized (obj) {
                if (!fooExec) {//fooExec为false时，该线程等待，为true的时候执行下面的操作
                    obj.wait();
                }
                printFoo.run();
                fooExec = false;
                obj.notifyAll();//唤醒其他线程
            }

        }
    }

    public void bar(Runnable printBar) throws InterruptedException {

        for (int i = 0; i < n; i++) {
            synchronized (obj) {
                if (fooExec) {
                    obj.wait();
                }
                printBar.run();
                fooExec = true;
                obj.notifyAll();
            }

        }
    }
}
```



## 146. LRU 缓存
### Description

* [LeetCode-146. LRU 缓存](https://leetcode.cn/problems/lru-cache/)

### Approach 1-借助Java的LinkedHashMap


#### Analysis


参考 `leetcode-cn` 官方题解。

借助 Java 的 `LinkedHashMap` 数据结构，可实现 LRU 算法。`LinkedHashMap` 类的 `accessOrder` 参数指定了排序方式，默认为 false，采用插入的顺序。若设为 true，则基于访问的顺序。**`accessOrder = true` 时，`LinkedHashMap` 会将最近一次访问的元素，移动到链表的尾部。** 同时，如果重写了该类的 `removeEldestEntry` 方法，当 `LinkedHashMap` 容量不够时，会将链表头部的元素删除。

#### Solution


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




### Approach 2-哈希表+双向链表


#### Analysis


参考 `leetcode-cn` 官方题解。


可以通过哈希表辅以双向链表实现 LRU 算法。
1. 双向链表按照被使用的顺序存储了这些键值对，靠近头部的键值对是最近使用的，而靠近尾部的键值对是最久未使用的。若有新元素插入，将其插入到链表头部。淘汰元素时，删除链表尾部的节点。
2. 哈希表即为普通的哈希映射（HashMap），通过缓存数据的键映射到其在双向链表中的位置。
3. 在双向链表的实现中，使用一个伪头部（dummy head）和伪尾部（dummy tail）标记界限，这样在添加节点和删除节点的时候就不需要检查相邻的节点是否存在



#### Solution



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

    //HashMap
    private Map<Integer, DLinkedNode> cache = new HashMap<Integer, DLinkedNode>();
    //双向链表
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

/**
 * Your LRUCache object will be instantiated and called as such:
 * LRUCache obj = new LRUCache(capacity);
 * int param_1 = obj.get(key);
 * obj.put(key,value);
 */
```


## 剑指 Offer II 031. 最近最少使用缓存
### Description

* [LeetCode-剑指 Offer II 031. 最近最少使用缓存](https://leetcode.cn/problems/OrIXps/)

### Approach 1

此题同 [LeetCode-146. LRU 缓存](https://leetcode.cn/problems/lru-cache/)，此处不再赘述。



## 面试题 16.25. LRU 缓存

### Description

* [LeetCode-面试题 16.25. LRU 缓存](https://leetcode.cn/problems/lru-cache-lcci/)

### Approach 1

此题同 [LeetCode-146. LRU 缓存](https://leetcode.cn/problems/lru-cache/)，此处不再赘述。
