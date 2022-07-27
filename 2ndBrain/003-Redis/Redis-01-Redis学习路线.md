# Redis-01-Redis学习路线

[TOC]

## 更新
* 2020/01/30，撰写
* 2021/12/12，整理排版
* 2022/05/15，添加*Redis Module*


## 学习路线
1. 学习 [【尚硅谷】Redis 6 视频教程 | Bilibili](https://www.bilibili.com/video/BV1Rv41177Af?p=1)，配套 [大纲笔记](https://zhangc233.github.io/2021/05/02/Redis/)
2. 学习《Redis设计与实现》，掌握底层数据原理
3. 学习《Redis深度历险》，对应 [Redis深度历险 | 掘金小册](https://juejin.cn/book/6844733724618129422)

### 参考资料
* [【尚硅谷】Redis 6 视频教程 | Bilibili](https://www.bilibili.com/video/BV1Rv41177Af?p=1)，配套 [大纲笔记](https://zhangc233.github.io/2021/05/02/Redis/)
* [Redis命令参考 | 简明版](http://doc.redisfans.com/) 和 [Redis命令参考 | 官网](https://redis.io/commands/)
* [Redis官网](https://redis.io/)
* [Redis中文官网](http://www.redis.cn/)
* [Redis菜鸟教程](https://www.runoob.com/redis/redis-tutorial.html)
* [Redis源码](https://github.com/antirez/redis) —— 使用C语言开发，源码只有3万多行，降低了用户通过修改Redis源码来提升性能的门槛，源码解读参见 [redis源码注释 | 《Redis设计与实现》](http://redisbook.com/)
* [try.redis.io](https://try.redis.io/)



### 学习书籍
* 《Redis实战》，豆瓣读书 8.1
* [《Redis设计与实现》](http://redisbook.com/)，豆瓣读书 8.6（该书籍在在线阅读参见 [《Redis设计与实现》第2版 | 在线阅读](http://static.kancloud.cn/kancloud/redisbook/63822)）
* 《Redis深度历险》，豆瓣读书 8.4，对应 [Redis深度历险 | 掘金小册](https://juejin.cn/book/6844733724618129422)
* 《Redis开发与运维》，豆瓣读书 8.9
* 码哥字节-Redis高手心法




## 面试题汇总
* [2W字！详解20道Redis经典面试题珍藏版](https://juejin.cn/post/7002011542145204261) !!!
  

### Redis的key和value可以存储的最大值
* 虽然 Key 的大小上限为 512M，但是一般建议 key 的大小不要超过 1KB，这样既可以节约存储空间，又有利于 Redis 进行检索。
* value 的最大值也是 512M。对于 String 类型的 value 值上限为 512M，而集合、链表、哈希等 key 类型，单个元素的 value 上限也为 512M。


> **Memcache 的单个 value 最大 1MB，Redis 的单个 value 最大 512 MB。**




### 1亿个key，10W个key是固定前缀开头，如何将它们找出来

> 本题考察的是 `keys` 和 `scan` 命令的区别。
> 1. `keys` 命令的时间复杂度是 `O(n)`，并且会阻塞线程，并且不支持分页查询。
> 2. `scan` 命令执行时不会阻塞线程，是基于游标实现的，可以支持分页。


我们可以使用 `keys` 命令和 `scan` 命令，但是会发现使用 `scan` 更好。


> 方法1：使用 keys 命令
1. 直接使用 `keys` 命令查询，但是如果是在生产环境下使用会出现一个问题，keys 命令是遍历查询的，查询的时间复杂度为 `O(n)`，数据量越大查询时间越长。而且 Redis 是单线程，keys 指令会导致线程阻塞一段时间，会导致线上 Redis 停顿一段时间，直到 keys 执行完毕才能恢复。这在生产
环境是不允许的。
2. 除此之外，需要注意的是，这个命令没有分页功能，会一次性查询出所有符合条件的 key 值，会发现查询结果非常大，输出的信息非常多。
3. 所以不推荐使用这个命令。


> 方法2：使用 scan 命令，用法详情参考 [scan | Redis 命令参考](http://doc.redisfans.com/key/scan.html)
1. `scan` 命令可以实现和 keys 一样的匹配功能，但是 `scan` 命令在执行的过程不会阻塞线程。
2. 但是需要注意的是，查找的数据可能存在重复，需要客户端操作去重。
3. 因为 `scan` 是通过游标方式查询的，所以不会导致 Redis 出现假死的问题。Redis 查询过程中会把游标返回给客户端，单次返回空值且游标不为 0，则说明遍历还没结束，客户端继续遍历查询。scan 在检索的过程中，被删除的元素是不会被查询出来的，但是如果在迭代过程中有元素被修改，scan 不能保证查询出对应元素。
4. 相对来说，scan 指令查找花费的时间会比 keys 指令长。



### 如果有大量key设置同一时间过期，会导致什么问题

会导致两方面的问题
1. 对 Redis 自身而言，会导致 Redis 出现卡顿。
2. 对整个系统而言，会导致「缓存雪崩」，影响 DB 和整个系统的性能。



下面对第 1 点中提到的「Redis 出现卡顿」进行说明。




Redis 过期键值删除使用的是贪心策略，它每秒会进行 10 次过期扫描（即每100ms扫描一次），此配置可在 `redis.conf` 进行配置，默认值是 `hz 10`，Redis 会随机抽取 20 个值，删除这 20 个键中过期的键，如果过期 key 的比例超过 25% ，重复执行此流程，如下图所示。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-expire-data-del-time-1.png)


如果在大型系统中有大量缓存在同一时间同时过期，那么会导致 Redis 循环多次持续扫描删除过期字典，直到过期字典中过期键值被删除的比较稀疏为止，而在整个执行过程会导致 Redis 的读写出现明显的卡顿，卡顿的另一种原因是内存管理器需要频繁回收内存页，因此也会消耗一定的 CPU。

为了避免这种卡顿现象的产生，我们需要预防大量的缓存在同一时刻一起过期，就简单的解决方案就是在过期时间的基础上添加一个指定范围的随机数。



### 什么情况下可能会导致 Redis 阻塞

Redis 产生阻塞的原因主要有内部和外部两个原因导致。

内部原因
1. 如果 Redis 主机的 CPU 负载过高，也会导致系统崩溃；
2. 数据持久化占用资源过多；
3. 对 Redis 的 API 或指令使用不合理，导致 Redis 出现问题。

外部原因
1. 外部原因主要是服务器的原因，例如服务器的 CPU 线程在切换过程中竞争过大，内存出现问题、网络问题等


### 如何提高缓存命中率

1. 提前加载数据到缓存中
2. 增加缓存的存储空间，提高缓存的数据（减少缓存被淘汰的可能性）
3. 调整缓存的存储数据类型
4. 提升缓存的更新频率



### Redis 报内存不足怎么办
1. 修改配置文件 `redis.conf` 的 `maxmemory` 参数，增加 Redis 可用内存；
2. 设置缓存淘汰策略，提高内存的使用效率
3. 使用 Redis 集群模式，提高存储量



### 热点数据和冷数据

1. 热点数据就是访问次数较多的数据。
2. 冷数据就是访问很少或者从不访问的数据。
3. 需要注意的是，只有热点数据，缓存才有价值。
4. 对于冷数据，大部分数据可能还没有再次访问到就已经被挤出内存，不仅占用内存，而且价值不大。
5. **数据更新前至少读取两次，缓存才有意义。这个是最基本的策略，如果缓存还没有起作用就失效了，那就没有太大价值了。**




### Memecache和Redis区别

1. 存储方式
   * Memecache 把数据全部存在内存之中，断电后会挂掉，数据不能超过内存大小。
   * Redis 有部份存在硬盘上，redis可以持久化其数据。
2. 数据支持类型 
   * Memcached 所有的值均是简单的字符串
   * Redis 作为其替代者，支持更为丰富的数据类型，提供 list，set，zset，hash 等数据结构的存储 
3. 使用底层模型不同
   * 它们之间底层实现方式，以及与客户端之间通信的应用协议不一样。 
   * Redis 直接自己构建了 VM 机制，因为一般的系统调用系统函数的话，会浪费一定的时间去移动和请求。
4. value 值大小不同
   * Redis 可以达到 512 MB。
   * Memcache 只有 1mb。
5. Redis 的速度比 Memcached 快很多
6. Redis 支持数据的备份，即 master-slave 模式的数据备份。



### Redis单线程为什么这么快
1. **基于内存的操作**
   * Redis 的所有数据都存在内存中，因此所有的运算都是内存级别的，性能较高。
2. **采用合适的数据结构**
   * Redis 的数据结构都是专门设计的，对这些数据结构的操作，大部分时间复杂度都是 `O(1)`，因此性能较高。
3. **多路复用和非阻塞I/O**
   * Redis 使用 I/O 多路复用技术，来监听多个 `socket` 链接客户端。这样就可以使用一个线程连接来处理多个请求，减少线程切换带来的开销，同时也避免了 I/O 阻塞操作。
4. **主线程为单线程，避免了下文切换**
   * 单线程模型下，避免了不必要的上下文切换和多线程竞争（比如锁）。




![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/redis-why-fast-1.png)

> 上图参考 [2W字！详解20道Redis经典面试题珍藏版](https://juejin.cn/post/7002011542145204261) 



### Redis为什么是单线程的

从 CPU 上看
* Redis 是基于内存的，因此减少了 CPU 将数据从磁盘复制到内存的时间
* Reedis 是单线程的，因此减少了多线程切换和恢复上下文的时间
* Redis 是单线程的，因此多核 CPU 和单核 CPU 对于 Redis 来说没有太大影响，单个线程的执行使用一个 CPU 即可

**综上所述，CPU 并不是 Redis 的性能瓶颈，内存大小和网络 IO 才是 Redis 的性能瓶颈。**

所以在 Redis 6 中，使用多路 IO 复用技术 来优化 Redis。

### Redis操作为什么是原子的

Redis 单线程执行命令操作。

## Redis初识

### 什么是Redis
* Redis = Remote Dictionary Server，远程字典服务器
* Redis 是一个 高性能的 `key-value` 存储系统，通常被称为数据结构服务器，因为值（value）可以是字符串（String），哈希（Hash）, 列表（List）, 集合（Sets）和有序集合（Sorted Sets）等类型。
* Redis 与其他 `key - value` 缓存产品有以下 3 个特点
    1. Redis支持数据的持久化，可以将内存中的数据保存在磁盘中，重启的时候可以再次加载进行使用
    2. Redis不仅仅支持简单的 key-value 类型的数据，同时还提供 list，set，zset，hash 等数据结构的存储
    3. Redis支持数据的备份，即 master-slave 模式的数据备份
* Redis 性能极高，读取速度是11W次/s，写入的速度是8.1W次/s。**Redis数据库中的所有数据都存储在内存中，内存读写速度远快于磁盘。**
* Redis功能丰富，除了用于数据库开发，还可以用于缓存，队列系统等。
* **Redis的所有操作都是原子性的**，意思就是要么成功执行要么失败完全不执行。单个操作是原子性的。多个操作也支持事务，即原子性，通过 `MULTI`和 `EXEC` 指令包起来。



### 多数据库

Redis 是一个字典结构的存储服务器，**一个 Redis 实例**提供了多个用来存储的字典，可以把其中的每个字典都理解成一个独立的数据库。
* **每个数据库对外都是一个从0开始的递增数字命名（0~15），Redis默认支持16个数据库**
* Redis不支持自定义数据库名称，每个数据库都以编号命名，默认使用0号数据库，可以使用 `select x` 进行数据库的选择

```s
lbsmacbook-pro:~ lbs$ redis-cli
127.0.0.1:6379> select 1   # 默认使用0号
OK
127.0.0.1:6379[1]> select 0
OK
127.0.0.1:6379> select 15
OK
127.0.0.1:6379[15]>
```

* 需要注意的是，**一个 Redis 实例的多个数据库之间并不是完全隔离的**，比如 `FLUSHALL` 命令可以清空一个 Redis 实例中所有数据库中的数据。综上所述，这些数据库更像是一种命名空间，而不适宜存储不同应用程序的数据。比如，可以使用 0 号数据库存储应用 A 的生产环境数据，使用1号数据库存储应用 A 的测试环境数据，而不应该使用1号数据库存储应用 B 的数据。
* **不同的应用，应该使用不同的Redis实例存储数据。** 由于 Redis 非常轻量，一个空的 Redis 实例占用的内存只有 1MB，所以不用担心多个 Redis 实例会额外占用很多内存。





## Redis环境配置和启动

### 安装 Redis

* Mac上，建议使用Homebrew安装Redis

```s
brew install redis    //会默认安装当前最新的稳定版本

/// 此处安装路径为 usr/local/Cellar/redis/5.0.7
//==> Caveats
// To have launchd start redis now and restart at login:
//  brew services start redis
//Or, if you don't want/need a background service you can just run:
//  redis-server /usr/local/etc/redis.conf
//==> Summary
//🍺  /usr/local/Cellar/redis/5.0.7: 13 files, 3.1MB
```

* 如果需要后台运行Redis服务，使用命令 `brew services start redis`
* 如果不需要后台运行Redis服务，使用命令 `redis-server /usr/local/etc/redis.conf`




* 查看 Redis 版本

```s
lbsmacbook-pro:~ lbs$ redis-server --version

Redis server v=6.0.6 sha=00000000:0 malloc=libc bits=64 build=5b8f79637e2b0790
```

### 启动/停止Redis
执行 `brew services start redis` 命令，第一次启动 Redis 后，在 `/usr/local/bin` 目录下，会生成如下文件夹

| 文件名 | 说明   | 
|-------|----------| 
| redis-server | redis 服务器  | 
| redis-cli | redis 命令行客户端 | 
| redis-benchmark | redis 性能测试工具 | 
| redis-check-aof | AOF 文件修复工具 | 
| redis-check-dump | RDB 文件检查工具 | 
| redis-sentinel | Sentinel 服务器  | 



* 启动Redis


> Redis 默认端口号是6379。


```s
# 前台启动
redis-server   # 默认端口号 6379 

redis-server --port 6380  # 指定端口号
```

```s
lbsmacbook-pro:~ lbs$ redis-server 
69230:C 14 Dec 2021 23:49:50.046 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
69230:C 14 Dec 2021 23:49:50.046 # Redis version=6.0.6, bits=64, commit=00000000, modified=0, pid=69230, just started
69230:C 14 Dec 2021 23:49:50.046 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
69230:M 14 Dec 2021 23:49:50.047 * Increased maximum number of open files to 10032 (it was originally set to 2560).
                _._                                                  
           _.-``__ ''-._                                             
      _.-``    `.  `_.  ''-._           Redis 6.0.6 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._                                   
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 69230
  `-._    `-._  `-./  _.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |           http://redis.io        
  `-._    `-._`-.__.-'_.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |                                  
  `-._    `-._`-.__.-'_.-'    _.-'                                   
      `-._    `-.__.-'    _.-'                                       
          `-._        _.-'                                           
              `-.__.-'                                               

69230:M 14 Dec 2021 23:49:50.048 # Server initialized
69230:M 14 Dec 2021 23:49:50.048 * Ready to accept connections
```


* 停止Redis

考虑到 Redis 有可能正在将内存中数据同步到硬盘中，强行终止Redis进程可能会导致数据丢失。因此，正确停止Redis的方式应该是向Redis发送 `SHUTDOWN` 命令，方法为

```s
redis-cli SHUTDOWN
```

当 Redis 收到 `SHUTDOWN`  命令后，会先断开所有客户端连接，然后根据配置执行数据持久化，最后完成退出。

Redis 可以妥善处理 `SIGTERM` 信号，所以使用 `kill` Redis 进程的 PID，也可以正常结束 Redis，效果和发送 `SHUTDOWN` 命令一样。



### redis-cli

Redis 命令用于在 Redis 服务上执行操作。要在 Redis 服务上执行命令需要一个 Redis 客户端。

`redis-cli` 是Redis自带的基于命令行的Redis客户端，下面介绍如果通过 `redis-cli` 向 Redis 发送命令。


通过 `redis-cli` 向 Redis 发送命令有2种方式
* 方式1：将命令作为 `redis-cli` 的参数执行。例如 `redis-cli SHUTDOWN`
* 方式2：执行 `redis-cli`（不附带任何参数），进入交互模式后，可以自由输入命令


```s
# 方式1：将命令作为 redis-cli 的参数执行

redis-cli SHUTDOWN

# redis默认服务器地址127.0.0.1，默认端口号6379 
# 也可以使用-h指定服务器地址，-p指定端口号
redis-cli -h 127.0.0.1 -p 6379  

# 使用PING命令测试客户端和Redis的连接是否正常
redis-cli PING  //返回PONG 表示连接正常
```


```s
# 方式2: 执行 redis-cli（不附带任何参数），进入交互模式后，可以自由输入命令
lbsMacBook-Pro:~ lbs$ redis-cli
127.0.0.1:6379> PING
PONG
127.0.0.1:6379> 
```




## Redis采用单线程+多路IO复用技术
* ref 1-[Redis高性能之IO多路复用 | InfoQQ](https://xie.infoq.cn/article/b3816e9fe3ac77684b4f29348)
* ref 2-[Redis性能瓶颈分析和IO多路复用 | Segmentfault]()




**Redis 6 中引入了多路IO复用技术。Redis 通过单线程执行命令和多路IO复用技术，实现了高性能。**

> IO多线程其实指客户端交互部分的网络 IO 交互处理模块的多线程，而非执行命令的多线程。Redis 6 执行命令依然是单线程。




### Redis单线程为什么这么快
1. **基于内存的操作**：Redis 的所有数据都存在内存中，因此所有的运算都是内存级别的，性能较高。
2. **采用合适的数据结构**：Redis 的数据结构都是专门设计的，对这些数据结构的操作，大部分时间复杂度都是 `O(1)`，因此性能较高。
3. **多路复用和非阻塞I/O**：Redis 使用 I/O 多路复用技术，来监听多个 `socket` 链接客户端。这样就可以使用一个线程连接来处理多个请求，减少线程切换带来的开销，同时也避免了 I/O 阻塞操作。
4. **主线程为单线程，避免了下文切换**：单线程模型下，避免了不必要的上下文切换和多线程竞争（比如锁）。




![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/redis-why-fast-1.png)

> 上图参考 [2W字！详解20道Redis经典面试题珍藏版](https://juejin.cn/post/7002011542145204261) 
  

### Redis的性能瓶颈在哪里（Redis为什么是单线程）

从 CPU 上看
* Redis 是基于内存的，因此减少了 CPU 将数据从磁盘复制到内存的时间
* Reedis 是单线程的，因此减少了多线程切换和恢复上下文的时间
* Redis 是单线程的，因此多核 CPU 和单核 CPU 对于 Redis 来说没有太大影响，单个线程的执行使用一个 CPU 即可

**综上所述，CPU 并不是 Redis 的性能瓶颈，内存大小和网络 IO 才是 Redis 的性能瓶颈。**

所以在 Redis 6 中，使用多路 IO 复用技术 来优化 Redis。




### IO多路复用

**「IO多路复用」模型中，一个服务端进程可以同时处理多个套接字描述符。**
* 多路：即多个客户端连接，一个连接对应着一个套接字描述符（`fd`）。
* 复用：使用单进程就能够同时处理多个客户端的连接

> 如果通过增加进程和线程的数量来并发处理多个套接字，免不了上下文切换的开销，而 IO 多路复用只需要一个进程就能够处理多个套接字，避免了上下文切换的开销。

IO多路复用技术的发展，可以分 `select` -> `poll` -> `epoll` 三个阶段来描述。


| 对比项  |  select  | 	poll  | epoll  |
|--------|----------|--------|--------|
| 操作方式 |    遍历  |  遍历	|  回调  |
| 数据结构 | bitmap	  |  数组  | 红黑树  |
| 最大连接数 |	1024(x86)，2048(x64) | 无上限 | 无上限 |
| 最大支持文件描述符数 | 有最大值限制 | 65535 |	65535 |
| fd拷贝 | 每次调用都需要把fd从用户态拷贝到内核态 | 每次调用都需要把fd从用户态拷贝到内核态 | 	只有首次调用的时候拷贝 |
| 工作效率 | 每次都要遍历所有文件描述符，时间复杂度O(n) | 每次都要遍历所有文件描述符，时间复杂度O(n) | 每次只用遍历需要遍历的文件描述符，时间复杂度O(1) |




### Redis的事件驱动和文件事件

* ref 1-《Redis设计与实现》第12章 事件


Redis 服务器是一个事件驱动程序，服务器需要处理以下两类事件
1. 文件事件（file event）：**Redis 服务器通过套接字与客户端（或者其他 Redis 服务器）进行连接，而文件事件就是服务器对套接字操作的抽象。** 服务器与客户端（或者其他服务器）的通信会产生相应的文件事件，而服务器则通过监听并处理这些事件来完成一系列网络通信操作。
2. 时间事件（time event）：Redis 服务器中的一些操作（比如 serverCron 函数）需要在给定的时间点执行，而时间事件就是服务器对这类定时操作的抽象。


Redis 基于 Reactor 模式开发了自己的网络事件处理器，这个处理器被称为「文件事件处理器」（file event handler）。

文件事件处理器使用 IO 多路复用（multiplexing）程序来同时监听多个套接字，并根据套接字目前执行的任务来为套接字关联不同的事件处理器。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-io-multiplexing-1.png)


虽然文件事件处理器以单线程的方式运行，但通过使用 IO 多路复用程序来监听多个套接字，文件事件处理器既实现了高性能的网络通信模型，又可以很好的与 Redis 服务器中其他同样以单线程方式运行的模块进行对接，这保持了 Redis 内部单线程设计的简单性。





## 数据结构与对象
* **ref 1-《Redis设计与实现》，第1部分-数据机构与对象**


### 简单动态字符串（SDS）

* Redis 的简单动态字符串（SDS）是一个可以被修改的字符串。
* Redis 将获取字符串长度的复杂度从 `O(N)` 降低到了 `O(1)`，这确保了获取字符串长度的工作不会成为 Redis 的性能瓶颈。
* SDS 是二进制安全的。



通过未使用空间，SDS 实现了空间预分配和惰性空间释放两种优化策略。

1. 空间预分配
   * 对 SDS 修改之后，若长度（即 `len` 属性）小于 1MB，则程序分配和 `len` 属性同样大小的未使用空间
   * 对 SDS 修改之后，若长度（即 `len` 属性）大于等于 1MB，则程序分配 1MB 的存储空间
   * 通过空间预分配，Redis 可以减少连续字符串增长操作所需的内存重分配次数
2. 惰性空间释放
   * 当要缩短 SDS 保存的字符串时，并不是立即使用内存重分配来回收缩短后多出来的字节，而是使用 `free` 属性将这些字节的数量记录下来，并等待将来使用




| 比较项 | C 字符串  | SDS   |
|-------|----------|-------|
| 是否记录字符串长度 | 否 | 是 |
| 获取字符串长度的复杂度 | O(N) | O(1) |
| 内存安全 | API是不安全的，可能会造成缓冲区溢出 | API 是安全的，不会造成缓冲区溢出（SDS使用了未使用空间，并使用了空间预分配和惰性空间释放两种优化策） |
| 内存分配 | 修改字符串长度必然会需要执行内存重分配 | 修改字符串长度N次最多会需要执行N次内存重分配 |
| 二进制安全 | 只能保存文本数据 | 可以保存文本或二进制数据 | 
| C 函数支持 | 可以使用所有 `<string.h>` 库中的函数 | 可以使用一部分 `<string.h>` 库中的函数 | 



### 压缩列表（ziplist）

压缩列表是 Redis 为了节约内存而开发的，是由一系列特殊编码的**连续内存块**组成的顺序型数据结构。一个压缩列表可以包含任意多个节点（`entry`），每个节点可以保存一个字节数组或者一个整数值。


**压缩列表（`zip list`）是列表键和哈希键的底层实现之一。**
1. 当一个列表键（`list`）只包含少量列表项，并且每个列表项要么是小整数值，要么是长度比较短的字符串，那么 Redis 就会使用压缩列表来做列表键的底层实现。
2. 当一个哈希建只包含少量键值对，并且每个键值对的键和值要么是小整数值，要么是长度比较短的字符串，那么 Redis 就会使用压缩列表来做哈希键的底层实现。


```s
127.0.0.1:6379> hmset profile "name" "jack"
OK
127.0.0.1:6379> type profile
hash
127.0.0.1:6379> object encoding profile
"ziplist"
```


### 跳跃表（skiplist）

* ref 1-[跳跃表 SkipList 设计与实现](https://www.toutiao.com/article/6910597347328426503)


跳跃表（`skiplist`）是一种有序数据结构，它通过在每个节点中维持多个指向其他节点的指针，从而达到快速访问节点的目的。

> 跳跃表中，使用术语「跨度」表示两个节点之间的距离，两个节点之间的跨度越大，它们相聚的就越远。



跳跃表支持平均 `O(logN)`、最坏 `O(N)` 复杂度的节点查找，还可以通过顺序性操作来批量处理节点。

在大部分情况下，跳跃表的效率可以和平衡树媲美，并且因为跳跃表的实现比平衡树要来的更为简单，所以有不少程序都使用跳跃表来代替平衡树。

Redis 使用跳跃表作为有序集合对象的底层实现之一。



### 字典（dict）

* ref 1-[《Redis设计与实现》第2版 | 在线阅读](http://static.kancloud.cn/kancloud/redisbook/63822)）
* ref 2-[美团针对Redis Rehash机制的探索和实践 | 美团技术](https://tech.meituan.com/2018/07/27/redis-rehash-practice-optimization.html)




#### `ht[0]` 和 `ht[1]`

Redis 中的字典由 `dict.h/dict` 结构表示如下。


```java
typedef struct dict {

    // 类型特定函数
    dictType *type;

    // 私有数据
    void *privdata;

    // 哈希表
    dictht ht[2];

    // rehash 索引
    // 当 rehash 不在进行时，值为 -1
    int rehashidx; /* rehashing not in progress if rehashidx == -1 */

} dict;
```


`ht` 属性是一个包含两个项的数组，数组中的每个项都是一个 `dictht` 哈希表， 一般情况下，字典只使用 `ht[0]` 哈希表，`ht[1]` 哈希表只会在对 `ht[0]`哈希表进行 `rehash` 时使用。

除了 `ht[1]` 之外，另一个和 `rehash` 有关的属性就是 `rehashidx`：它记录了 `rehash` 目前的进度，如果目前没有在进行 `rehash`，那么它的值为 -1 。



#### 解决键冲突

当有两个或以上数量的键被分配到了哈希表数组的同一个索引上面时，我们称这些键发生了冲突（`collision`）。

Redis 的哈希表使用「链地址法（`separate chaining`）」来解决键冲突
1. 每个哈希表节点都有一个 `next` 指针，多个哈希表节点可以用 `next` 指针构成一个「单向链表」
2. 被分配到同一个索引上的多个节点，可以用这个单向链表连接起来。这就解决了键冲突的问题。



#### rehash

随着操作的不断执行，哈希表保存的键值对会逐渐地增多或者减少，为了让哈希表的负载因子（`load factor`）维持在一个合理的范围之内，当哈希表保存的键值对数量太多或者太少时，程序需要对哈希表的大小进行相应的扩展或者收缩。

扩展和收缩哈希表的工作可以通过执行 `rehash`（重新散列）操作来完成，Redis 对字典的哈希表执行 rehash 的步骤如下
1. 为字典的 `ht[1]` 哈希表分配空间，这个哈希表的空间大小取决于要执行的操作，以及 `ht[0]` 当前包含的键值对数量（也即是 `ht[0].used` 属性的值）
   * 如果执行的是扩展操作，那么 `ht[1]` 的大小为第一个大于等于 `ht[0].used * 2` 的 `2^n`
   * 如果执行的是收缩操作，那么 `ht[1]` 的大小为第一个大于等于 `ht[0].used` 的 `2^n`。
2. 将保存在 `ht[0]` 中的所有键值对 `rehash` 到 `ht[1]` 上面。`rehash` 指的是重新计算键的哈希值和索引值，然后将键值对放置到 `ht[1]` 哈希表的指定位置上。
3. 当 `ht[0]` 包含的所有键值对都迁移到了 `ht[1]` 之后（`ht[0]` 变为空表），释放 `ht[0]`，将 `ht[1]` 设置为 `ht[0]`，并在 `ht[1]` 新创建一个空白哈希表，为下一次 rehash 做准备。



#### 哈希表的扩展与收缩

当以下条件中的任意一个被满足时，程序会自动开始对哈希表执行扩展操作
1. 服务器目前没有在执行 `BGSAVE` 命令或者 `BGREWRITEAOF` 命令，并且哈希表的负载因子大于等于 1；
2. 服务器目前正在执行 `BGSAVE` 命令或者 `BGREWRITEAOF` 命令，并且哈希表的负载因子大于等于 5；

其中，哈希表的负载因子可以通过下面的公式计算。

```s
# 负载因子 = 哈希表已保存节点数量 / 哈希表大小
load_factor = ht[0].used / ht[0].size
```

#### 渐进式rehash

扩展或收缩哈希表需要将 `ht[0]` 里面的所有键值对 `rehash` 到 `ht[1]` 里面，但是，这个 rehash 动作并不是一次性、集中式地完成的，而是分多次、渐进式地完成的。

这是因为，如果 `ht[0]` 中保存的多个、上百万、上千万的键值对时，要一次性将这些键值对全部 rehash 到 `ht[1]` 的话，庞大的计算量可能会导致服务器在一段时间内停止服务。

因此，为了避免 rehash 对服务器性能造成影响，服务器不是一次性将 `ht[0]` 里面的所有键值对全部 rehash 到 `ht[1]`，而是分多次、渐进式地将 `ht[0]` 里面的键值对慢慢地 rehash 到 `ht[1]`。

以下是哈希表渐进式 rehash 的详细步骤。
1. 为 `ht[1]` 分配空间，让字典同时持有 `ht[0]` 和 `ht[1]` 两个哈希表。
2. 在字典中维持一个索引计数器变量 `rehashidx`，并将它的值设置为 0，表示 rehash 工作正式开始。
3. 在 rehash 进行期间，每次对字典执行添加、删除、查找或者更新操作时，程序除了执行指定的操作以外，还会顺带将 `ht[0]` 哈希表在 `rehashidx` 索引上的所有键值对 rehash 到 `ht[1]`，当 rehash 工作完成之后，程序将 rehashidx 属性的值增 1。
4. 随着字典操作的不断执行，最终在某个时间点上，`ht[0]` 的所有键值对都会被 rehash 至 `ht[1]`，这时程序将 rehashidx 属性的值设为 -1 ，表示 rehash 操作已完成。



渐进式 rehash 的好处在于它采取分而治之的方式，将 rehash 键值对所需的计算工作均摊到对字典的每个添加、删除、查找和更新操作上，从而避免了集中式 rehash 而带来的庞大计算量。


#### 渐进式rehash执行期间的哈希表操作

因为在进行渐进式 rehash 的过程中，字典会同时使用 `ht[0]` 和 `ht[1]` 两个哈希表， 所以在渐进式 rehash 进行期间，字典的删除（delete）、查找（find）、更新（update）等操作会在两个哈希表上进行。

比如说，要在字典里面查找一个键的话，程序会先在 `ht[0]` 里面进行查找，如果没找到的话，就会继续到 `ht[1]` 里面进行查找，诸如此类。

另外，在渐进式 rehash 执行期间，新添加到字典的键值对一律会被保存到 `ht[1]`里面，而 `ht[0]` 则不再进行任何添加操作。这一措施保证了 `ht[0]` 包含的键值对数量会只减不增， 并随着 rehash 操作的执行而最终变成空表。




### 对象


Redis 并没有直接使用动态字符串（SDS），双端列表，字典，压缩列表和整数集合这些数据结构来实现键值对数据库，而是基于这些数据结构创建了一个对象系统。这个系统包括字符串对象，列表对象，哈希对象，集合对象和有序集合对象这 5 种类型的对象。每种类型的对象都至少使用了两种不同的编码。


#### redisObject结构

Redis 中的每个对象都由一个 `redisObject` 结构表示，如下所示。

> 使用 TYPE 可以查看一个对象的类型。
> 使用 OBJECT ENCODING可以查看一个对象的编码。

```cpp
typedef struct redisObject {
    //类型
    unsigned type:4;   //使用 TYPE 命令查看
    
    //编码
    unsigned encoding:4;  //使用 OBJECT ENCODING 命令查看
    
    //指向底层实现数据结构的指针
    void *ptr;
    
    //引用计数
    int refcount;  // 使用 OBJECT REFCOUNT 命令查看

    //记录了对象最后一次被命令程序访问的时间，用于计算对象的空转时长
    unsigned lru:22  // 使用 OBJECT IDLETIME 命令查看
	
    // ...
}robj
```


#### 使用Redis对象的好处
1. 通过上述5种不同类型的对象，Redis可以在执行命令之前，根据对象的类型来判断一个对象是否可以执行给定的命令。
2. 可以针对不同的使用场景，为对象设置多种不同的数据结构实现，从而优化对象在不同场景下的使用效率。
3. Redis对象基于引用计数计数实现了
    - 内存回收机制
    - 对象共享机制（仅针对包含整数值的字符串对象）
4. Redis的对象带有访问时间记录信息，该信息可以用于计算数据库键的空转时长，在服务器启用了 `maxmemory` 功能的情况下，空转时长交大的那些键可能会优先被服务器删除。



此处针对上述第2点，以列表对象（`list`）为例进行说明
* 在列表对象包含的元素比较少时，Redis 使用压缩列表（`zip list`）作为列表对象的底层实现。因为压缩列表比双端列表更节约内存，并且在元素数量较少时，在内存中以**连续块方式**保存的压缩列表，比起双端链表可以更快被载入到缓存中
* 随着列表对象包含的元素越来越多，使用压缩列表来保存元素的优势逐渐消失时，对象就会将底层实现从压缩列表转向功能更强、也更适合保存大量元素的**双端链表**上



此处针对上述第3点的「对象共享机制」，进行如下说明。
* **Redis 只对包含整数值的字符串对象进行共享。**
* Redis 会在初始化服务时，创建 10000 个字符串对象，这些对象包含了从 0 到 9999 的所有整数值。当服务器需要用到值为 0 到 9999 的字符串对象时，服务器就会使用这些共享对象，而不是新创建对象。


> Redis 性能优化
> 
> 生产环境中，能用整数就用整数，充分利用对象共享池。 —— [使用 Redis 的一些最佳实践 | 开源博客](https://my.oschina.net/u/4499317/blog/5171817)



#### 不同类型对象的编码

* 字符串对象（`string`）的编码可以是 `int`，`raw` 或者 `embstr`。
* 列表对象（`list`）的编码可以是 `ziplist` 或者 `linkedlist`。
* 哈希对象（`hash`）的编码可以是压缩列表（`ziplist`）或者哈希表（`hashtable`）。
* 集合对象（`set`）的编码可以是整数集合（`intset`）或者哈希表（`hashtable`）。
* 有序集合对象（`zset`）的编码可以是压缩列表（`ziplist`）或者跳跃表（`skip list`）。




### zset的数据结构

有序集合对象 `zset` 的编码可以是压缩列表（`ziplist`）或跳跃表（`skuplist`）。

当有序集合对象可以同时满足以下两个条件时，对象使用压缩列表（`ziplist`）编码
1. 有序集合对象保存的元素数量小于 128 个
2. 有序集合对象保存的所有元素成员的长度都小于 64 字节

不能满足以上两个条件的有序集合对象，将使用跳跃表（`skiplist`）编码。


除此之外，`zset` 结构中的 `dict` 字典为有序集合创建了一个从成员到分值的映射，字典中的每个键值都保存了一个集合元素：字典的键保存了元素的成员，而字典的值则保存了元素的分值。通过这个字典，程序可以用 `O(1)` 复杂度查找给定成员的分值，`ZSCORE` 命令就是根据这一特性实现的。




## 5种常用数据类型

Redis 支持 5 种常用数据类型
* string（字符串）
* hash（哈希或散列）
* list（列表）
* set（集合）
* zset（sorted set，有序集合）





### String
* String 的数据结构为简单动态字符串（Simple Dynamic String，缩写 `SDS`），是可以修改的字符串。而 Java 中的字符串是不可变的。
* String 类型是二进制安全的，意味着 Redis 的 String 可以包含任何数据，比如 jpg 图片或者序列化的对象。
* String 可以存储 3 种类型的值：字符串，整数，浮点数
* 字符串对象的编码可以是 `int`，`raw` 或者 `embstr`
* String 采用预分配冗余空间的方式来减少内存的频繁分配。如下图所示，当前字符串实际分配的空间 `capacity` 一般要高于实际字符串长度 `len`。当字符串长度小于 1M 时，扩容都是加倍现有的空间。如果超过 1M，扩容时一次只会多扩 1M 的空间。字符串最大长度为 512M。


![redis-string-capacity-1](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-string-capacity-1.png)



### List
* 在列表元素较少时，Redis会使用压缩列表（`ziplist`）存储列表。压缩列表将所有的元素紧挨着一起存储，分配的是一块连续的内存。

![redis-list-structure-2](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-list-structure-2.png)


* 当数据量比较多时，Redis会使用**双向链表**（`linkedlist`）存储列表，即将多个 `ziplist` 使用双向指针串起来使用。因此，对两端的操作性能很高，通过索引下标的操作中间的节点性能会较差

![redis-list-structure-1](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-list-structure-1.png)


因此，针对双向链表的特点，列表类型特别适合如下场景
* 如社交网站的新鲜事，我们只关心最新内容，即使新鲜事达到几千万条，获取列表尾部的 100 条最新数据也是很快的
* 如日志记录场景，双向链表保证了插入新日志的速度不会受到已有日志数量的影响
* 借助列表类型，Redis 还可以作为队列使用



### Hash
* Redis的 hash 是一个 string 类型的 `field` 和 `value` 的映射表，类似 Java 里面的 `Map<String,Object>`。

* 哈希对象（`hash`）的编码可以是压缩列表（`ziplist`）或者哈希表（`hashtable`）。当 `field-value` 长度较短且个数较少时，使用 `ziplist`，否则使用 `hashtable`。

### Set
* Redis 的 Set 是 String 类型的无序集合。它的底层其实是一个 value 为 null 的 hash 表。所以对Set的添加，删除和查找操作的复杂度都是 `O(1)`。



### Zset

有序集合(`sorted list`)类型，是在集合类型的基础上，为每个元素关联一个分数（`score`，可以理解为索引值），使得元素有序。

Redis中，采用哈希表和跳跃表（`Skip list`）实现有序集合类型。所以即使读取位于中间部分的数据，速度也是很快的，时间复杂度是 `O(logN)`。


## Redis 6中新数据类型
Redis 6中提供了以下几种新的数据类型
1. Bitmaps
2. HyperLogLog
3. Geospatial


### Bitmap
* Bitmap 本身不是一种数据类型，实际上它就是一个字符串，但是它可以对字符串的位进行操作。可以把 Bitmaps 想象成一个以位为单位的数组，数组的每个单元只能存储 0 和 1， 数组的下标在 Bitmap 中叫做偏移量。
* 常用的位操作命令如下

```s
SETBIT key offset value
GETBIT key offset
```

* Bitmap 实际上就是一个字符串，一个字符串最大存储 `512M`，则一个 Bitmap 包括 `521（MB）* 1024(KB) * 1024(byte) * 8(bit)` = `2^32`，约 `42.28亿`，即一个 Bitmap 最大可存储 42.28亿个 `0`、`1` 信息。



### HyperLogLog
* Redis HyperLogLog 是用来做基数统计的算法。HyperLogLog 的优点是在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定的，并且是很小的。
* 在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 `2^64` 个不同元素的基数。
* 但是，因为 HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以 HyperLogLog 不能像集合那样，返回输入的各个元素。**因此，在业务场景找那个，一般使用 Bitmap 标识哪些用户活跃，用 HyperLogLog 统计活跃用户总数，二者搭配使用。**


> 什么是基数？
> 
> 比如数据集 `{1, 3, 5, 7, 5, 7, 8}`，那么这个数据集的基数集为 `{1, 3, 5 ,7, 8}`，基数 (不重复元素) 为 5。 





HyperLogLog 可用来
* 统计注册 IP 数
* 统计每日访问 IP 数
* 统计页面实时 UV 数、
* 统计在线用户数
* 统计用户每天搜索不同词条的个数


### Geospatial
* Redis 3.2 中增加了对 GEO 类型的支持。GEO，即 `Geographic`，地理信息的缩写。Geospatial 存储位置的经纬度信息。
* Redis 基于该类型，提供了经纬度设置，查询，范围查询，距离查询，经纬度 Hash 等常见操作。

```s
GEOADD
GEOPOS
GEODIST  # 计算两个位置的直线距离
GEORADIUS 
```




## Redis 基本操作命令
* ref 1-[Redis命令参考 | 简明版](http://doc.redisfans.com/) 
* ref 2-[Redis命令参考 | 官网](https://redis.io/commands/)


关于「基本操作命令」，详情参考上述链接。此处仅做必要的补充说明。




### Connection（连接）
* `SELECT index`：切换到指定的数据库，数据库索引号 index 用数字值指定，以 0 作为起始索引值。Redis 默认使用 0 号数据库。



### Server（服务器）
* `FLUSHDB`：清空当前数据库中的所有 key
* `FLUSHALL`：清空整个 Redis 服务器的数据，会删除所有数据库的所有 key。


### KEY（键）
*  `UNLINK key [key ...]`：删除指定的 key，相比于 `DEL key` 会产生阻塞，该命令是非阻塞的，仅将 key 从 `keyspace` 元数据中删除，真正的删除会在后续异步操作，即在另一个线程中回收内存
* `TTL key`：以秒为单位，返回给定 key 的剩余生存时间(TTL, time to live)。当 key 不存在时，返回 -2。当 key 存在但没有设置剩余生存时间时，返回 -1。
* `DBSIZE`：返回当前数据库的 key 的数量
* `KEYS pattern`：获得符合规则的键名列表，`pattern` 支持 `glob` 风格通配符格式，具体如下


| 符号    |     含义  |
|--------|-----------|
| ?       | 匹配一个字符  |
| *       | 匹配任意个（包括0个）字符 |
| []      |匹配括号间的任一字符，可以使用 `-` 表示一个范围，如 `[1-9]` |
| \x      | 用于转义字符   |


* `OBJECT`：该命令有多个子命令，具体如下

```sql
# 返回给定 key 引用所储存的值的次数
OBJECT REFCOUNT <key>   

# 返回给定 key 锁储存的值所使用的内部表示，即编码方式
OBJECT ENCODING <key> (representation)

# 返回给定 key 自储存以来的空转时间(idle， 没有被读取也没有被写入)，以秒为单位
OBJECT IDLETIME <key> 
```


### String（字符串）

* `INCR key`：将 key 中储存的数字值增一。如果 key 不存在，那么 key 的值会先被初始化为 0，然后再执行 INCR 操作。如果值包含错误的类型，或字符串类型的值不能表示为数字，那么返回一个错误。
  
```s
# test1 不存在
127.0.0.1:6379> exists test1
(integer) 0
127.0.0.1:6379> incr test1
(integer) 1
127.0.0.1:6379> get test1
"1"

# user为字符串类型的值
127.0.0.1:6379> set user lbs0912
OK
127.0.0.1:6379> incr user
(error) ERR value is not an integer or out of range
```

* `GETRANGE key start end`：返回 key 中字符串值的子字符串，字符串的截取范围为 `[star,end]`（闭区间）。负数偏移量表示从字符串最后开始计数，-1 表示最后一个字符，-2 表示倒数第二个，以此类推。
* `SETRANGE key offset value`：用 value 参数覆写给定 key 所储存的字符串值，从偏移量 offset 开始。不存在的 key 当作空白字符串处理。

```s
127.0.0.1:6379> set name lucymary
OK
127.0.0.1:6379> getrange name 0 3
"lucy"
127.0.0.1:6379> setrange name 3 abc
(integer) 8
127.0.0.1:6379> get name
"lucabcry"
```

* `GETSET key value`：将给定 key 的值设为 value ，并返回 key 的旧值(old value)。当 key 没有旧值时，也即是 key 不存在时，返回 nil。当 key 存在但不是字符串类型时，返回一个错误。

```s
127.0.0.1:6379> getset name lbs0912
"lucabcry"  # 返回旧值
127.0.0.1:6379> get name
"lbs0912"
```


### List（列表）
* `LRANGE key start stop`：返回列表 key 中指定区间内的元素，区间以偏移量 start 和 stop 指定。可以使用负数下标，以 -1 表示列表的最后一个元素，-2 表示列表的倒数第二个元素，以此类推。

### Set（集合）
* `SPOP key`：移除并返回集合中的一个随机元素。
* `SRANDMEMBER key [count]`：相比 `SPOP`，仅返回集合中的随机元素，但不移除集合中的元素。
* `SUNION key [key ...]`：返回一个集合的全部成员，该集合是所有给定集合的并集。
* `SINTER key [key ...]`：返回一个集合的全部成员，该集合是所有给定集合的交集。
* `SDIFF key [key ...]`：返回一个集合的全部成员，该集合是所有给定集合之间的差集。



### Hash（哈希表）
* `HEXISTS key field`：查看哈希表 key 中，给定域 （`field`） 是否存在。
* `HKEYS key`：返回哈希表 key 中的所有域（`field`）。
* `HVALS key`：返回哈希表 key 中所有域的值（`value`）。









## Redis事务

Redis 事务是一个单独的隔离操作：事务中的所有命令都会序列化、按顺序地执行。**事务在执行的过程中，不会被其他客户端发送来的命令请求所打断。Redis 事务的主要作用就是串联多个命令防止别的命令插队。**



### Redis事务三特性
1. 单独的隔离操作 ：事务中的所有命令都会序列化、按顺序地执行。事务在执行的过程中，不会被其他客户端发送来的命令请求所打断。
2. 没有隔离级别的概念 ：队列中的命令没有提交之前都不会实际被执行，因为事务提交前任何指令都不会被实际执行。
3. 不保证原子性 ：**事务中如果有一条命令执行失败，其后的命令仍然会被执行，没有回滚。注意，这点是和关系型数据库的事务回滚机制不同的。**


Redis 事务涉及的指令包括
* multi
* exec
* discard
* watch/unwatch

### 事务的执行



在 Redis 中，从输入 `multi` 命令开始，输入的命令都会依次进入命令队列中，但不会执行，直到输入 `exec` 后，Redis 会将之前的命令队列中的命令依次执行。而组队的过程中可以通过 `discard` 来放弃组队。事物的执行过程如下图所示。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-transaction-0.png)

> **事务中的命令是在 `EXEC` 之后才执行的，因此，一个事务中，只有当所有命令都依次执行完成后，才能得到每个结果的返回值。**


### 事务的错误处理

组队中某个命令出现了错误，执行时整个的所有队列都会被取消，如下图所示。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-transaction-1.png)


```s
127.0.0.1:6379> multi
OK
127.0.0.1:6379> set m1 v1
QUEUED
127.0.0.1:6379> set m2
(error) ERR wrong number of arguments for 'set' command
127.0.0.1:6379> set m3 v3
QUEUED
127.0.0.1:6379> exec
(error) EXECABORT Transaction discarded because of previous errors.
```



如果执行阶段某个命令报出了错误，则只有报错的命令不会被执行，而其他的命令都会执行，不会回滚，如下图所示。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-transaction-2.png)

```s
127.0.0.1:6379> multi
OK
127.0.0.1:6379> set k1 v1
QUEUED
127.0.0.1:6379> incr k1
QUEUED
127.0.0.1:6379> set k2 v2
QUEUED
127.0.0.1:6379> exec
1) OK
2) (error) ERR value is not an integer or out of range   # 仅该操作执行失败 其余2条操作执行成功 且不会滚
3) OK
```

### watch/unwatch
* 一个事务中，只有当所有命令都依次执行完成后才能得到每个结果的返回值。可是有些情况下，需要先获得一条命令的返回值，根据返回值再执行下一条命令。针对该情况，可以使用 `WATCH` 命令。
* 在执行 `multi` 之前，可以先执行 `watch key1 [key2]`，来监视一个或多个 `key`。
* 如果在事务执行（`exec`）之前这个 (或这些) `key` 被其他命令所改动，那么事务将被打断。
* `unwatch` 会取消对 key 的监视。如果在执行 `watch` 命令之后，`exec` 命令或 `discard` 命令先被执行了的话，会取消对键的监控，此时就不需要再执行 `unwatch` 了。


此处给出一个 `watch` 的示例。

```s
redis> SET key 1
OK
redis> WATCH key
OK
redis> SET key 2
OK
redis> MULTI
OK
redis> SET key 3
QUEED
redis> EXEC
nil
redis> GET key
"2"
```

上例中，执行 `WATCH` 命令后，事务修改了 `key` 值，所以最后事务代码并没有执行，`EXEC` 命令返回结果为 `nil`。


### 事务应用实战

#### 秒杀库存场景
* ref 1-[【尚硅谷】Redis 6 视频教程 | Bilibili](https://www.bilibili.com/video/BV1Rv41177Af?p=1)，配套 [大纲笔记](https://zhangc233.github.io/2021/05/02/Redis/)

关于「秒杀库存场景」，详情参考上述链接。此处仅做必要的补充说明，下面给出秒杀库存场景高并发下存在的问题和解决办法
1. 连接超时  ->  使用连接池解决
2. 超卖问题  -> 使用乐观锁，Jedis中使用 `watch` 监听，`jedis.watch(kcKey);`
3. 乐观锁造成的库存遗留问题  -> 使用 LUA 脚本，相当于悲观锁



## Redis 6 的新功能

* ref 1-[【尚硅谷】Redis 6 视频教程 | Bilibili](https://www.bilibili.com/video/BV1Rv41177Af?p=1)，配套 [大纲笔记](https://zhangc233.github.io/2021/05/02/Redis/)

关于「Redis 6的新功能」，详情参考上述链接。此处仅做必要的补充说明。

此处记录几个 Redis 6 的新功能
1. ACL（`Access Control List`）：访问控制列表。
2. 工具支持 Cluster：老版 Redis 想要搭建集群需要单独安装 ruby 环境，Redis 5 将 `redis-trib.rb` 的功能集成到了 `redis-cli`。另外官方 `redis-benchmark` 工具开始支持 `cluster` 模式了，通过多线程的方式对多个分片进行压测。
3. IO多线程：多线程IO默认是不开启的，需要在配置文件中配置，如下所示。

```s
ip-thread-do-reads yes
io-threads 4
```

> **IO多线程其实指客户端交互部分的网络 IO 交互处理模块的多线程，而非执行命令的多线程。Redis 6 执行命令依然是单线程。**




## 持久化

Redis 提供了 2 种方式的持久化
* RDB（Redis DataBase）：Redis 默认的持久化方案，默认开启。RDB 方案中，会将内存中的数据以快照形式，定时保存到 `dump.rdb` 的文件中。
* AOF（Append Only File）：将对 Redis 服务器执行的所有写命令，保存到 `appendonly.aof` 文件中。该方案默认是关闭的。


> 优先级：AOF > RDB

当 RDB 和 AOF 持久化方案同时打开时，Redis 会优先使用 AOF 文件来还原数据集，因为 AOF 文件保存的数据集通常比 RDB 文件所保存的数据集更完整。


### 两种方案的优缺点
* ref 1-[RDB和AOF方案优劣对比 | CSDN](https://blog.csdn.net/jayxujia123/article/details/112760653)



> RDB 的优点
1. 使用一个 `dump.rdb` 文件就可以记录数据库的状态，方便持久化，比较适用于「数据库的备份和灾难恢复（`disaster recovery`）」，比较适合做「冷备份」。
2. 对同一个数据库状态，RDB 文件体积比 AOF 文件小，可以节省磁盘空间。同时，在恢复大数据集时，RDB 的恢复速度也 AOF 的恢复速度要快
3. Redis 生产一个子进程来完成 RDB 文件的写操作，主进程不会进行任何 IO 操作，保证了 Redis 的高性能。 

> RDB 的缺点
1. 数据安全性较低：RDB 是间隔一段时间进行持久化，如果两次持久化之间 Redis 发生故障，会产生数据丢失。所以 RDB 方式更适合使用在对数据完整性和一致性要求不高的场景。
2. 在使用 `BGSAVE` 命令时，Redis 调用 `fork()` 函数创建了一个和父进程完全相同的子进程，内存中的数据被克隆了一份，造成了大致 2 倍的膨胀。因此，在数据庞大时还是比较消耗内存空间的。


> AOF 的优点
1. 相比 RDB 方案，数据安全性更高：可以通过配置同步频率 `appendfsync` 来保证较高的数据安全性。AOF 默认策略为每秒钟 `fsync` 一次，也可以配置为每次进行一次同步（`always`）。默认情况下，每秒同步一次，即使发生故障停机，也最多只会丢失一秒钟的数据。
2. AOF 以 `append only` 的模式写入，所以没有任何磁盘寻址的开销，写入性能非常高。


> AOF 的缺点
1. **对同一个数据库状态，AOF 文件体积比 RDB 文件大，且恢复速度较慢，不适合做「冷备份」。**



### 选择哪种持久化方案
1. Redis 官方建议同时选用 RDB 方案和 AOF 方案。
    - 用 AOF 来保证数据不丢失，作为恢复数据的第一选择；
    - 用 RDB 来做不同程度的冷备份，在 AOF 文件丢失或损坏不可用的时候，使用 RDB 进行快速的数据恢复；
2. 如果可以接受数据部分丢失，对数据完整性和一致性要求不高，可以只使用 RDB 方案
3. 使用 RDB 方案进行「数据库备份和灾难恢复」：定时生成 RDB 快照，非常便于进行数据库备份，并且 RDB 恢复数据集的速度也要比 AOF 恢复的速度要快。


### RDB
* RDB 是 Redis 默认的持久化方案，默认开启。
* RDB 文件的生成
    - `SAVE` 命令：会阻塞 Redis 服务器进程，此时客户端发送的所有命令请求都会被拒绝
    - `BGSAVE` 命令：在子进程中生成 RDB 文件，不会造成阻塞，服务器仍然可以继续处理客户端的请求
* 在 RDB 文件载入时，也会阻塞 Redis 服务器
* 可通过设置服务器配置文件的 `save` 选项，让服务器每隔一段时间自动执行一次 `BGSAVE` 命令

```s
save 900 1
save 300 10
save 60  10000
```






### AOF

#### 3个步骤

AOF 持久化功能的实现可以分为如下 3 个步骤
1. 命令追加（`append`）
2. 文件写入
3. 文件同步（`sync`）


可通过设置 `appendfsync` 属性，控制 AOF 频率，AOF 默认是每秒同步一次。

```s
# appendfsync always
appendfsync everysec   //默认
# appendfsync no       //不主动进行同步操作，即交由操作系统处理（每30秒同步一次）
```

#### AOF重写

为了解决 AOF 文件体积膨胀的问题，Redis 提供了 AOF 文件重写（`rewrite`）功能。通过该功能，Redis 服务器可以创建一个新的 AOF 文件来代替现有的 AOF 文件。新的 AOF 文件不会包含任何浪费空间的冗余命令，体积会小很多。


AOF 文件重写并不需要对现有的 AOF 文件进行任何读取、分析或写入操作，这个功能是通过读取服务器当前的数据库状态来实现的。


AOF 重写是在子进程中执行的，其目的是
1. 子进程进行 AOF 重写期间，服务器进程（父进程）可以继续处理命令请求
2. 子进程带有服务器进程的数据副本，使用子进程而不是子线程，可以在避免使用锁的情况下，保证数据的安全性


#### AOF重写缓冲区

由于在 AOF 重写期间，服务器进程还需要继续处理命令请求，而新的命令肯能会对现有的数据库状态进行修改，从而使得服务器当前的数据库状态和重写后 AOF 文件锁保存的数据库状态不一致。

为了解决数据不一致的问题，Redis 服务器设置了一个 「AOF 重写缓冲区」。这个缓冲区在服务器创建子线程之后开始使用，当 Redis 服务器执行完一个写命令之后，它会同时将这个命令发送给 AOF 缓冲区和 AOF 重写缓冲区。

当子进程完成 AOF 重写工作之后，它会向父进程发送一个信号。父进程在接收到该信号之后，会调用一个信号处理函数，并执行如下工作
1. 将 AOF 重写缓冲区的所有内容，写入到新的 AOF 文件中，此时新的 AOF 文件锁保存的数据库状态，就和当前服务器的状态一致了。
2. 对新的 AOF 文件重命名，原子地（`atomic`）覆盖现有的 AOF 文件，完成新旧两个 AOF 文件的替换。该步骤，使用了「写时复制」的技术。
   

> **在整个 AOF 后台重写过程中，只有信号处理函数执行时会对服务进程（父进程）造成阻塞，在其他时候，AOF 后台重写都不会阻塞父进程，这将 AOF 重写对服务性能造成的影响降到了最低。**



#### redis-check-aof–fix

在持久化过程中，若 AOF 文件损坏，可通过如下命令进行文件修复。

```s
/usr/local/bin/ redis-check-aof–fix appendonly.aof
```


## 分布式锁

* ref 1-[【尚硅谷】Redis 6 视频教程 | Bilibili](https://www.bilibili.com/video/BV1Rv41177Af?p=1)，配套 [大纲笔记](https://zhangc233.github.io/2021/05/02/Redis/)
* ref 2-[从青铜到钻石的五种演进方案 | 悟空聊架构](https://mp.weixin.qq.com/s?__biz=MzAwMjI0ODk0NA==&mid=2451954663&idx=1&sn=4bd071b6aaede114263f88c790b61371&chksm=8d1c2278ba6bab6eca2ef44f21b2178cc719fffe124289b68128c0dad72429fe5f286854157a&scene=178&cur_album_id=1835581086177755145#rd)
* ref 1-[分布式锁的三种实现方式](https://www.cnblogs.com/barrywxx/p/11644803.html)


分布式锁的 3 种实现方式
1. 基于数据库实现分布式锁
2. 基于缓存（Redis等）实现分布式锁
3. 基于Zookeeper实现分布式锁


|    分布式锁   |   缺点     |
|--------------|-----------|
| 基于数据库实现分布式锁 |1. 锁没有过期时间；2. DB 操作性能较差并且有锁表的风险；3. 非阻塞操作失败后，需要轮询，占用 CPU 资源；4. 长时间轮询可能会占用较多连接资源 |
| 基于 Redis 实现分布式锁 | 1. 锁删除失败，过期时间不好控制；2. 非阻塞，操作失败后，需要轮询，占用 CPU 资源 |
| 基于 ZK 实现分布式锁 | 性能不如 Redis 实现，主要原因是写操作（获取锁释放锁）都需要在 Leader 上执行，然后同步到 Follower |


* 从理解的难易程度角度（从低到高）：数据库 > 缓存 > Zookeeper
* 从实现的复杂性角度（从低到高）：Zookeeper >= 缓存 > 数据库
* 从性能角度（从高到低）：缓存 > Zookeeper >= 数据库
* 从可靠性角度（从高到低）：Zookeeper > 缓存 > 数据库


### 分布式锁的4个特性

为了确保分布式锁可用，我们至少要确保分布式锁的实现同时满足下面 4 个条件
1. 互斥性：在任意时刻，只有一个客户端能持有锁
2. 不会发生死锁：即使有一个客户端在持有锁的期间崩溃而没有主动解锁，也能保证后续其他客户端能加锁
3. 独占性：解铃还须系铃人，加锁和解锁必须是同一个客户端，一把锁只能有一把钥匙，客户端自己的锁不能被别人给解开，当然也不能去开别人的锁。比如可用通过 uuid 来防止锁的误操作。
4. 原子性：加锁和加锁必须具有原子性，比如可以通过 LUA 脚本来保证原子性。



### 基于数据库实现分布式锁

1. 悲观锁

利用 `select ... where name = 'lock' for update` 排他锁。需要注意的是，`name` 字段必须走索引，否则会锁表。



2. 乐观锁

基于 CAS 思想，是不具有互斥性，不会产生锁等待而消耗资源，操作过程中认为不存在并发冲突。可利用版本号实现乐观锁，在更新操作时候，校验下版本号。


### 基于Zookeeper实现分布式锁

* ref 1-[分布式锁 - ZK的实现](https://juejin.cn/post/7084023049942466574#heading-12)


> ZK 实现分布式锁，本质上是客户端调用 `create` 方法创建类似定义锁方式的「临时顺序节点」，ZK 可以保证临时顺序节点的序号递增。


ZooKeeper 是一个为分布式应用提供一致性服务的开源组件，它内部是一个分层的文件系统目录树结构，规定同一个目录下只能有一个唯一文件名。基于 ZooKeeper 实现分布式锁的步骤如下
1. 创建一个目录 mylock
2. 线程 A 想获取锁就在 mylock 目录下创建「临时顺序节点」
3. 获取 mylock 目录下所有的子节点，然后获取比自己小的兄弟节点，如果不存在，则说明当前线程顺序号最小，获得锁
4. 线程 B 获取所有节点，判断自己不是最小节点，设置监听比自己次小的节点
5. 线程 A 处理完，删除自己的节点；线程 B 监听到变更事件，判断自己是不是最小的节点，如果是则获得锁

推荐一个 Apache 的开源库 Curator，它是一个 ZooKeeper 客户端，Curator 提供的 InterProcessMutex 是分布式锁的实现，acquire 方法用于获取锁，release 方法用于释放锁。


#### ZK的4种节点

Zookeeper 的节点 Znode 有四种类型
1. 持久节点：默认的节点类型。创建节点的客户端与 zookeeper 断开连接后，该节点依旧存在。
2. 持久节点顺序节点：所谓顺序节点，就是在创建节点时，Zookeeper 根据创建的时间顺序给该节点名称进行编号，持久节点顺序节点就是有顺序的持久节点。
3. 临时节点：和持久节点相反，当创建节点的客户端与zookeeper断开连接后，临时节点会被删除。
4. 临时顺序节点：有顺序的临时节点。

**Zookeeper 分布式锁实现应用了临时顺序节点。**





#### ZK分布式锁图解

下面对 ZK 分布式锁的过程进行图解。


1. 当第一个客户端请求过来时，Zookeeper 客户端会创建一个持久节点 `/locks`。如果 Client1 想获得锁，需要在 locks 节点下创建一个临时顺序节点 `lock1`，如图。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/zk-lock-1.png)


2. 接着，客户端 Client1 会查找 locks 下面的所有临时顺序子节点，判断自己的节点 lock1 是不是排序最小的那一个，如果是，则成功获得锁。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/zk-lock-2.png)

3. 这时候如果又来一个客户端 Client2 前来尝试获得锁，它会在 locks 下再创建一个临时节点 lock2

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/zk-lock-3.png)


4. 客户端 client2 一样也会查找 locks 下面的所有临时顺序子节点，判断自己的节点 lock2 是不是最小的，此时，发现 lock1 才是最小的，于是获取锁失败。获取锁失败，它是不会甘心的，client2 向它排序靠前的节点 lock1 注册 Watcher 事件，用来监听 lock1 是否存在，也就是说 client2 抢锁失败进入等待状态。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/zk-lock-4.png)


5. 此时，如果再来一个客户端 Client3 来尝试获取锁，它会在 locks 下再创建一个临时节点 lock3。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/zk-lock-5.png)


6. 同样的，client3 一样也会查找 locks 下面的所有临时顺序子节点，判断自己的节点 lock3 是不是最小的，发现自己不是最小的，就获取锁失败。它也是不会甘心的，它会向在它前面的节点 lock2 注册 Watcher 事件，以监听 lock2 节点是否存在。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/zk-lock-6.png)


下面再来看一下释放锁的过程。

1. Zookeeper 的客户端业务完成或者发生故障，都会删除临时节点，释放锁。如果是任务完成，Client1 会显式调用删除 lock1 的指令。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/zk-lock-7.png)

2. 如果是客户端故障了，根据临时节点得特性，lock1是会自动删除的。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/zk-lock-8.png)


3. lock1 节点被删除后，Client2 可开心了，因为它一直监听着 lock1。lock1 节点删除，Client2 立刻收到通知，也会查找 locks 下面的所有临时顺序子节点，发现 lock2 是最小，就获得锁。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/zk-lock-9.png)


同理，Client2 获得锁之后，Client3 也对它虎视眈眈，啊哈哈~

Zookeeper 设计定位就是分布式协调，简单易用。如果获取不到锁，只需添加一个监听器即可，很适合做分布式锁。

Zookeeper 作为分布式锁也缺点，如果有很多的客户端频繁的申请加锁、释放锁，对于Zookeeper 集群的压力会比较大。


### Redis实现分布式锁

#### 实现方案

基于 Redis 实现分布式锁，一个严谨的流程如下
1. 加锁：`SET lock_key uniqueId EX expire_time NX`
2. 操作共享资源
3. 释放锁：使用 LUA 脚本保证原子性。释放锁时，先 GET 判断锁是否归属自己，再 DEL 释放锁，保证 “解铃还须系铃人”


下面，对上述步骤进行必要的说明。
* Redis 是单线程的，上述步骤 1 中使用 `SET ... EX ... NX` 一条命完成设置，可以保证原子性
* 使用 UUID 防止误删：可以使用 UUID 作为步骤 1 中的 `uniqueId`，Java 中可通过 `java.util.UUID.randomUUID().toString()` 随机生成一个 UUID。
* Redis 处理每一个请求是「单线程」执行的，在执行一个 Lua 脚本时，其它请求必须等待，直到这个 Lua 脚本处理完成。所以，步骤 3 中的 `GET` + `DEL` 操作可以保证原子性。

##### UUID防止误删

为了防止锁被误，使用 UUID 作为 key 的value。

每次释放锁的时候，先 GET 取到值，然后和本地的 UUID 进行比较，只有相等时候才进行锁的释放 DEL 操作。


##### LUA 脚本保证原子性

使用 UUID 后，在锁的释放时，由于不具备原子性，所以还是会发生锁被误删的可能。

锁的释放分为 3 个步骤
1. GET key，先获取锁的值
2. 将获取到的值和本地 UUID 比较，若相等，则执行第三步操作
3. DEL key，删除锁


考虑一个场景，节点 A 加锁之后，执行完业务逻辑，进行锁的释放。第 1 步操作先获取锁的值，第 2 步操作比较锁的值和 UUID 是否相等。假设前两步都执行成功，再要执行但还没执行第 3 步操作时，这个锁自动过期导致锁被释放。

此时节点 B 恰好抢占到了这把锁。

再回到 A，节点 A 继续执行释放锁的操作，即 DEL 操作。

那么很显然，会发生节点 A 误释放了节点 B 加的锁。



所以，需要使用 LUA 脚本 保证锁释放的 3 个操作的原子性。












#### 存在的问题
上述方案存在 2 个问题
1. 锁过期时间不好评估
2. 在 Redis 集群中发生「主从切换」时，存在安全问题

下面对这两个问题进行分析。
##### 锁过期时间不好评估

上述方案存在一个问题 —— 锁过期时间不好评估。
* 若锁过期时间 `expire_time` 设置过短，操作共享资源还没结束，因为过期时间太短导致锁被提前释放
* 若锁过期时间 `expire_time` 设置过长，保证 「冗余」过期时间，虽然可以避免锁被提前释放的问题，但降低了系统的性能


针对「锁过期时间不好评估」，解决思路是**引入守护线程，自动对锁进行续期**。
1. 加锁时，先设置一个过期时间
2. 开启一个守护线程，定时去检测这个锁的失效时间
3. 如果操作共享资源还没完成，那么自动对锁进行「续期」，重新设置过期时间


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/distributed-lock-redis-1.png)



对于 Java 技术栈，可以直接使用 Redisson 工具来解决该问题。Redisson 是一个Java 语言实现的 Redis SDK客户端，在使用分布式锁是，它采用了「自动续期」的方案来避免锁过期，这个守护线程，被称为「看门狗」线程。


##### Redis集群发生「主从切换」

Redis 集群一般采用 「主从集群 + 哨兵」的部署模式。这样做的好处是，当主库发生异常宕机时，哨兵可以实现「故障自动切换」，把从库提升为主库，保证高可用性。

上述分布式锁的方案，在 Redis 集群发生「主从切换」时，存在安全问题
1. 客户端 A 在主库上执行 SET 命令，加锁成功
2. 此时，主库异常宕机， SET 命令还未同步到从库上（主从复制是异步的）
3. 从库被哨兵提升为新的主库。这个锁在新的主库上，丢失了



针对该问题，Redis 的作者提出了一种解决方案，即 Redlock（红锁）。



### Redisson
* ref 1-[深度剖析：Redis分布式锁到底安全吗](https://cloud.tencent.com/developer/article/1839627?from=article.detail.1608807) !!!「PDF本地已存」
* ref 2-[分布式锁中的王者方案-Redisson | 悟空聊架构](https://mp.weixin.qq.com/s?__biz=MzAwMjI0ODk0NA==&mid=2451955246&idx=1&sn=5db231b88fb9e735e907873d420f26a5&chksm=8d1c27b1ba6baea7d3ef65860276140ae30a4e2bbe45179931c3f476f1fcb30d8365905dd413&scene=178&cur_album_id=1835581086177755145#rd)
* ref 3-[Redis分布式锁和Redlock算法 | 官网](http://www.redis.cn/topics/distlock.html)




#### 什么是Redisson

> Redisson 是一个在 Redis 的基础上实现的 Java 驻内存数据网格（In-Memory Data Grid）。



Redisson 是一个Java 语言实现的 Redis SDK客户端，在使用分布式锁时，它采用了「自动续期」的方案来避免锁过期，这个守护线程，被称为「看门狗」线程。

除此之外，Redisson 还提供了如下功能
* 可重入锁
* 乐观锁
* 悲观锁
* 公平锁
* 读写锁
* Redlock（红锁）：可以解决 Redis 集群发生「主从切换」时存在的安全问题



#### 看门狗和锁超时

在使用分布式锁时，Redisson 采用了「自动续期」的方案来避免锁过期，这个守护线程，被称为「看门狗」线程。默认情况下，看门狗的检查锁的超时时间是30秒，也可以通过修改 `Config.lockWatchdogTimeout` 来另行指定。

另外，在使用 Redisson 加锁是，可通过 `leaseTime` 参数来指定加锁的时间，超过这个时间后锁将自动释放。


```java
// 加锁以后10秒钟自动解锁
// 无需调用unlock方法手动解锁
lock.lock(10, TimeUnit.SECONDS);

// 尝试加锁，最多等待100秒，上锁以后10秒自动解锁
boolean res = lock.tryLock(100, 10, TimeUnit.SECONDS);
if (res) {
   try {
     ...
   } finally {
       lock.unlock();
   }
}
```


#### Redlock

详情参考「Redisson」章节的阅读链接 *ref-1* 和 *ref-3*，此处仅做大纲记录。



Redlock 算法 **基于 N 个完全独立** 的 Redis 节点，客户端依次执行下面各个步骤，来完成获取锁的操作。Redlock 的流程如下
1. 客户端先获取「当前时间戳 T1」
2. 客户端依次向这 5 个 Redis 实例发起加锁请求（用前面讲到的 SET 命令），且每个请求会设置超时时间（毫秒级，要远小于锁的有效时间），如果某一个实例加锁失败（包括网络超时、锁被其它人持有等各种异常情况），就立即向下一个 Redis 实例申请加锁
3. 如果客户端从 `>=3` 个（大多数）以上 Redis 实例加锁成功，则再次获取「当前时间戳T2」，计算获取锁消耗了多长时间（`T3 = T2 - T1`），如果 `T3 = T2 - T1` < 锁的过期时间，此时，认为客户端加锁成功，否则认为加锁失败
4. 加锁成功，去操作共享资源（例如修改 MySQL 某一行，或发起一个 API 请求）
5. 加锁失败，向「全部节点」发起释放锁请求（前面讲到的 Lua 脚本释放锁）



对于 Redlock 的流程，进行以下补充说明
* 客户端在多个 Redis 实例上申请加锁
* Redlock算法中必须保证大多数节点加锁成功，对于 N 个节点，加锁成功的节点需大于「N/2+1」
* 大多数节点加锁的总耗时，要小于锁设置的过期时间
* 释放锁，要向全部节点发起释放锁请求



## maxmemory和缓存系统

为了提高服务器负载能力，常常需要将一些访问频率较高但是 CPU 或 IO 资源消耗较大的操作的结果缓存起来，并希望让这些缓存过一段时间后自动过期。

实际开发中很难为缓存键设定合理的过期时间，为此可以限制 Redis 可以使用的最大内存，并让 Redis 按照一定的规则淘汰不需要的缓存键。这种方式在只将 Redis 用作缓存系统时非常实用。

Redis 配置文件的 `maxmemory` 属性限定了 Redis 可以使用的最大内存。当超出这个限制时，Redis会依据 `maxmemory-policy` 参数指定的策略来删除不要的键值直到Redis占用的内存大小小于指定内存。

`maxmemory-policy` 支持 `LRU`(`Least Recently Used`) 算法规则，即“最近最少使用原则”，其认为最近最少使用的键在未来一段时间内也不会被用到，当内存不足时这些键是可以被删除的。


## 集群

### 主数据库和从数据库

Redis 集群中，将数据库划分为主数据库和从数据库
* 主数据库（`master`）：可以进行读写操作，当写操作导致数据变化时会自动将数据同步给从数据库
* 从数据库 （`slave`）：一般是只读的（也可以配置为可写入），并接受主数据库同步过来的数据


Redis中，只需要在从数据库配置文件中加入如下配置，即可完成复制操作，主数据库不需要任何配置。

```s
salveof 主数据库地址   主数据库端口
```


### 哨兵

Redis 2.8 中提供了哨兵工具来实现自动化的系统监控和故障恢复功能。哨兵的作用就是监控 Redis 系统的运行状况，它的功能包括 2 个
1. 监控主数据库和从数据库是否正常工作
2. 主数据库出现故障时自动将从数据库转换为主数据库


**哨兵是一个独立的进程**，使用哨兵的一个典型架构如下图所示。虚线表示主从复制关系，实线表示哨兵的监控路径。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/redis-basic-guard-1.png)


在一个一主多从的Redis系统中，可以使用多个哨兵进行监控任务以保证系统是足够稳健的，如下图所示。此时不仅哨兵会同时监控主从数据库，哨兵之间也会互相监控。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/redis-basic-guard-2.png)



### 分片集群
* ref 1-[Redis集群的最大槽数是16384个 | 简书](https://www.jianshu.com/p/de268f62f99b)
* ref 2-[高可拓展之 Redis 分片技术（Redis Cluster）详解](https://www.pdai.tech/md/db/nosql-redis/db-redis-x-cluster.html)



Redis 在 3.0 版本后推出了 RedisCluster 用于搭建数据分片集群。RedisCluster 使用「哈希槽（Hash Slot）」的方式进行数据分片，处理数据和实例之间的映射关系。
1. Redis 集群共有 16384（2^14）个哈希槽
2. Redis 集群会根据键值对的 `key`，按照 CRC16 算法计算出一个 16 bit 的哈希值，然后对 16384 取模得到一个值，这个值可以映射到一个相应编号的哈希槽。





## Redis Module
* ref 1-[Redis Module介绍 | Blog](https://www.modb.pro/db/52884)
* ref 2-[Modules | Redis Cookbook](https://redis.io/docs/modules/)
  

在 Redis 4.0 版本中，增加了 Module 功能，该功能可以允许用户自定义扩展模块，在 Redis 内部实现新的数据类型和功能，使用统一的调用方式和传输协议格式扩展 Redis 的能力。

Redis Module 是一种动态库，可以用与 Redis 内核相似的运行速度和特性来扩展 Redis 内核的功能。一些常用的 Module 如下（详情参考 [Modules List | Redis Cookbook](https://redis.io/docs/modules/)）
* RediSearch：一个功能齐全的搜索引擎
* RedisJSON：对JSON类型的原生支持
* RedisTimeSeries：时序数据库支持
* RedisGraph：图数据库支持
* RedisBloom：概率性数据的原生支持
* RedisGears：可编程的数据处理
* RedisAI：机器学习的实时模型管理和部署
  


### RediSearch
* ref 1-[Elasticsearch vs RediSearch](https://www.modb.pro/db/323301)
* ref 2-[RediSearch | Redis Module](https://redis.io/docs/stack/search/)
* ref 3-[比 ES 更快，RediSearch + RedisJSON | 掘金](https://juejin.cn/post/7073276818425380872#heading-4)


RediSearch 是基于 Redis 构建的分布式全文搜索和聚合引擎，能以极快的速度在 Redis 数据集上执行复杂的搜索查询。

RediSearch 的特性如下
* 二级索引
* 多个字段的文档的全文索引
* 文档排名
* 字段权重
* 支持用于查询扩展和评分的自定义函数
* 在子查询之间使用 AND、OR、NOT 运算符进行复杂的布尔查询
* 可选的查询子句
* 前缀匹配全文查询
* 可排序属性




#### 性能数据
* 在同等服务器配置下索引了 560 万个文档 (5.3GB)，RediSearch 构建索引的时间为 221 秒，而 Elasticsearch 为 349 秒。RediSearch 比 ES 快了 58%。
* 数据建立索引后，使用 32 个客户端对两个单词进行检索，RediSearch 的吞吐量达到 `12.5K ops/sec`，ES 的吞吐量为 `3.1K ops/sec`，RediSearch 比ES 要快 4 倍。同时，RediSearch 的延迟为 8ms，而 ES 为 10ms，RediSearch 延迟稍微低些。



|    对比  | Redisearch  |  Elasticsearch |
|---------|-------------|-----------------|
| 搜索引擎 |   专用引擎   | 基于 Lucene 引擎 |
| 编程语言 |  C 语言     |   Java  |
| 存储方案 |    内存    |   磁盘 |
|    协议 | Redis 序列化协议   |   HTTP  |
| 集群   |   企业版支持  |  支持 |
| 性能  | 简单查询高于 ES |  复杂查询时高于 RediSearch |



### RedisJSON
* ref 1-[RedisJSON | Cookbook](https://redis.io/docs/stack/json/)
* ref 2-[小谈Redis JSON | 掘金](https://juejin.cn/post/7052271318598680613)




> RedisJSON is a Redis module that provides JSON support in Redis. RedisJSON lets your store, update, and retrieve JSON values in Redis just as you would with any other Redis data type. RedisJSON also works seamlessly with RediSearch to let you index and query your JSON documents.


RedisJSON 是一个 Redis 模块，在 Redis 中提供 JSON 支持。RedisJSON 允许您在 Redis 中存储、更新和检索 JSON 值，就像使用任何其他 Redis 数据类型一样。RedisJSON 还与 RediSearch 无缝配合，让您可以索引和查询 JSON 文档。

下面给出一个 RedisJSON 的使用示例。


1. `JSON.SET tag $` 设置一个名为 `tag` 的 JSON 数据对象，其中 `$`表示根路径（详情参考[JSONPath - XPath for JSON](https://goessner.net/articles/JsonPath/)）。

```s
2022-01-10 20:22:44 JSON.SET tag $ '{"1":{"tag":"GOAL_SELECT_TAG","execTs":1640676319},"2":{"tag":"GOAL_SELECT_TAG","execTs":1640676319}}'
OK
```

2. 获取键为 `1` 的内容

```s
2022-01-11 21:37:36 JSON.GET tag $.1
[{"tag":"GOAL_SELECT_TAG","execTs":1640676319}]
```

3. 获取键为 `2` 的 `tag` 内容

```s
2022-01-11 21:38:45  JSON.GET tag $.2.tag
["GOAL_SELECT_TAG"]
```

4. 遍历获取 `tag` 值，以数组格式返回

```s
2022-01-10 20:23:01 JSON.GET tag $..tag
["GOAL_SELECT_TAG","GOAL_SELECT_TAG"]
```


#### 性能数据
* ref 1-[RedisJson 横空出世，性能碾压 ES 和 Mongo | 掘金](https://juejin.cn/post/7042476201574662175)



根据官网的性能测试报告，RedisJson + RedisSearch 可谓碾压其他 NoSQL
* 对于隔离写入（isolated writes），RedisJSON 比 MongoDB 快 5.4 倍，比 ES 快 200 倍以上
* 对于隔离读取（isolated reads），RedisJSON 比 MongoDB 快 12.7 倍，比 ES 快 500 倍以上


**在混合工作负载场景中，实时更新不会影响 RedisJSON 的搜索和读取性能，而 ES 会受到影响。**
* RedisJSON 支持的操作数/秒比 MongoDB 高约 50 倍，比 ES 高 7 倍/秒。
* RedisJSON 的延迟比 MongoDB 低约 90 倍，比 ES 低 23.7 倍。



此外，RedisJSON 的读取、写入和负载搜索延迟，在更高的百分位数中远比 ES 和 MongoDB 稳定。当增加写入比率时，RedisJSON 还能处理越来越高的整体吞吐量。而当写入比率增加时，ES 会降低它可以处理的整体吞吐量。




## 数据结构在业务场景中的使用

Redis 提供了多种数据结构，可用于不同的业务场景，如下表所示。

|            数据结构          |         业务场景        |
|-----------------------------|------------------------|
| 通过list实现按自然时间排序的数据 |       最新N个数据        |
|        zset 有序集合         |       排行榜，topN       |
|         expire过期          |  时效性的数据，如手机验证码  |
|   原子性，自增方法incr，decr  |        计数器，秒杀        |
|         set集合            |     去除大量数据中的重复数据  |
|       利用list             |         构建队列           |
|        pub/sub模式         |         发布/订阅系统       |



下面介绍一些实战场景。


### 存储和计算一亿用户的活跃度
* ref 1-[Redis如何存储和计算一亿用户的活跃度](https://www.cnblogs.com/bryan31/p/13331213.html)
* ref 2-[HyperLogLog使用与应用场景](https://www.cnblogs.com/loveLands/articles/10987055.html)


> 如何用 Redis 存储统计 1 亿用户一年的登陆情况，并快速检索任意时间窗口内的活跃用户数量？

针对该问题，思考过程如下
1. 使用 Hash 存储
2. 使用 BitMap 存储
3. 使用 HyperLogLog 存储


> 计算单位换算
> 1. `8 bit = 1 byte`
> 2. `1024 byte = 1 KB`
> 3. `1024 KB = 1 MB`
> 4. `1024 MB = 1 GB`


> 使用 Hash 存储
* 使用 Hash 存储，经过测试，一对 `key-value` 占用大约 48 byte。
* 使用一对 `key-value` 记录一个用户一天的登录情况，则一天中一亿用户占用 `48 * 100000000 / 1024 / 1024 / 1024` = `4.47GB`。
* 该方案占用内存太大了，不可行。


> 使用 BitMap 存储
* Bitmap 实际上就是一个字符串，一个字符串最大存储 `512M`，则一个 Bitmap 包括 `521（MB）* 1024(KB) * 1024(byte) * 8(bit)` = `2^32`，约 `42.28亿`，即一个 Bitmap 最大可存储 42.28亿个 `0`、`1` 信息。
* 使用 BitMap 存储时，每位代表一个用户，则一天一亿用户需要占用 `100000000 / 8 / 1024 / 1024` = `11.92M`，该存储方案是实际可行的。
* 使用 `bitcount` 命令，可以统计一天的活跃用户。
* 若要统计一段时间区间内的活跃用户（如 7 日内的日活），可使用 `bitop` 命令。

```s
# or
bitop or result 01-01 01-02 ... 01-07

# 获取统计结果
bitcount result
```

> 使用 HyperLogLog 存储
* HyperLogLog 是一个概率数据结构，用来估算数据的基数，能通过牺牲准确率来减少内存空间的消耗。
* 每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 `2^64` 个不同元素的基数。
* HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以 HyperLogLog 不能像集合那样，返回输入的各个元素。**因此，在业务场景找那个，一般使用 Bitmap 标识哪些用户活跃，用 HyperLogLog 统计活跃用户总数，二者搭配使用。**


### Redis消息队列

* ref 1-[Redis 消息队列的三种方案（List、Streams、Pub/Sub）](https://mp.weixin.qq.com/s/_q0bI62iFrG8h-gZ-bCvNQ)
  




#### 消息队列

消息队列是指利用「高效可靠」的「消息传递机制」进行与平台无关的「数据交流」，并基于数据通信来进行分布式系统的集成。

通过提供「消息传递」和「消息排队」模型，它可以在「分布式环境」下提供应用解耦、弹性伸缩、冗余存储、流量削峰、异步通信、数据同步等等功能，其作为「分布式系统架构」中的一个重要组件，有着举足轻重的地位。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/mq-list-redis-1.png)

一个典型的 MQ 系统组成如上图所示
1. 三个角色：生产者、消费者、消息处理中心（Broker）
2. 异步处理模式
   * 生产者将消息发送到一条虚拟的通道（消息队列）上，而无须等待响应。
   * 消费者则「订阅」或是「监听」该通道，取出消息。
   * 生产者和消费者，两者互不干扰，甚至都不需要同时在线，也就是我们说的「松耦合」
3. 可靠性
   * 消息要可以保证不丢失、不重复消费、有时可能还需要顺序性的保证




#### Redis实现消息队列的 3 种方案

使用 Redis 实现消息队列，有如下 3 种方式
1. 使用 List 实现
2. 使用发布/订阅（pub/sub）
3. 使用 Stream

> 发布/订阅（pub/sub）下实现的消息队列，可以实现 1:1，也可以实现1:N消息队列。但缺点是，消息无法持久化，在消费下线的情况下，生产的消息会丢失。


#### 1.使用List实现

Redis 列表是简单的字符串列表（使用了双向链表实现），按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）。

所以常用来做异步队列使用。将需要延后处理的任务结构体序列化成字符串塞进 Redis 的列表，另一个线程从这个列表中轮询数据进行处理。

Redis 提供了好几对 List 指令，先大概看下这些命令，混个眼熟。

| 命令	 |   用法	|    描述   |
|--------|--------|-----------|
| LPUSH	 | LPUSH key value [value ...]	| 将一个或多个值 value 插入到列表 key 的表头，如果有多个 value 值，那么各个 value 值按从左到右的顺序依次插入到表头 |
| RPUSH	 | RPUSH key value [value ...]	| 将一个或多个值 value 插入到列表 key 的表尾（最右边）|
| LPOP	| LPOP key	| 移除并返回列表 key 的头元素 |
| BLPOP	| BLPOP key [key ...] timeout	| 移出并获取列表的第一个元素，如果列表没有元素会阻塞列表，直到等待超时或发现可弹出元素为止 |
| RPOP	| RPOP key	| 移除并返回列表 key 的尾元素 |
| BRPOP	| BRPOP key [key ...] timeout	| 移出并获取列表的最后一个元素，如果列表没有元素会阻塞列表，直到等待超时或发现可弹出元素为止 |
| BRPOPLPUSH	| BRPOPLPUSH source destination timeout | 从列表中弹出一个值，将弹出的元素插入到另外一个列表中并返回它；如果列表没有元素，会阻塞列表，直到等待超时或发现可弹出元素为止 |
| RPOPLPUSH	| RPOPLPUSH source destinationb	| 命令 RPOPLPUSH 在一个原子时间内，执行以下两个动作：将列表 source 中的最后一个元素（尾元素）弹出，并返回给客户端。将 source 弹出的元素插入到列表 destination，作为 destination 列表的的头元素 |
| LLEN	| LLEN key	| 返回列表 key 的长度。如果 key 不存在，则 key 被解释为一个空列表，返回 0。如果 key 不是列表类型，返回一个错误 |
| LRANGE | LRANGE key start stop | 返回列表 key 中指定区间内的元素，区间以偏移量 start 和 stop 指定 |


##### 简单队列实现

挑几个弹入、弹出的命令，就可以组合出很多姿势
1. LPUSH、RPOP 实现左进右出
2. RPUSH、LPOP 实现右进左出


##### 即时消费问题

通过 `LPUSH`，`RPOP` 这样的方式，会存在一个性能风险点，就是消费者如果想要及时的处理数据，就要在程序中写个类似 `while(true)` 这样的逻辑，不停的去调用 `RPOP` 或 `LPOP` 命令，这就会给消费者程序带来些不必要的性能损失。

所以，Redis 还提供了 `BLPOP`、`BRPOP` 这种阻塞式读取的命令（带 B - `Bloking` 的都是阻塞式），客户端在没有读到队列数据时，自动阻塞，直到有新的数据写入队列，再开始读取新数据。这种方式就节省了不必要的 CPU 开销。

1. LPUSH、BRPOP 实现左进右阻塞出
2. RPUSH、BLPOP 实现右进左阻塞出


以 `BRPOP key [key ...] timeout` 命令为例，可以指定超时时间 `timeout`，该命令将移出并获取列表的最后一个元素，如果列表没有元素会阻塞列表，直到等待超时或发现可弹出元素为止。

**如果将超时时间设置为 0 时，即可无限等待，直到弹出消息。**



##### 可靠队列模式和 ACK 机制

因为 Redis 单线程的特点，所以在消费数据时，同一个消息会不会同时被多个 consumer 消费掉，但是需要我们考虑消费不成功的情况。

以上方式中，List 队列中的消息一经发送出去，便从队列里删除。如果由于网络原因消费者没有收到消息，或者消费者在处理这条消息的过程中崩溃了，就再也无法还原出这条消息。究其原因，就是缺少消息确认机制（Ack）。

为了保证消息的可靠性，消息队列都会有完善的消息确认机制（Acknowledge），即消费者向队列报告消息已收到或已处理的机制。

Redis 的 List 提供了两个命令，`RPOPLPUSH`、`BRPOPLPUSH`，这两条命令可以在从一个 List 中获取消息的同时，把这条消息复制到另一个 List 里（可以当做备份），而且这个过程是原子的。

这样我们就可以在业务流程安全结束后，再删除队列元素，实现消息确认机制。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/mq-list-redis-2.png)



#### 2.使用发布/订阅实现实现1:1的消息队列


我们都知道消息模型有两种
1. 点对点：Point-to-Point（P2P）
2. 发布订阅：Publish/Subscribe（Pub/Sub）

List 实现方式其实就是点对点的模式，下边我们再看下 Redis 的发布订阅模式（消息多播），这才是 “根正苗红” 的 Redis MQ。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/mq-list-redis-3.png)


“发布/订阅” 模式同样可以实现进程间的消息传递，其原理如下
1. “发布/订阅” 模式包含两种角色，分别是发布者和订阅者。订阅者可以订阅一个或者多个频道（channel），而发布者可以向指定的频道（channel）发送消息，所有订阅此频道的订阅者都会收到此消息。
2. Redis 通过 `PUBLISH`、`SUBSCRIBE` 等命令实现了订阅与发布模式，这个功能提供两种信息机制，分别是订阅/发布到「频道」和订阅/发布到「模式」。

这个「频道」和「模式」有什么区别呢？
1. 「频道」可以先理解为是个 Redis 的 key 值
2. 「模式」可以理解为是一个类似正则匹配的 Key，只是个可以匹配给定模式的频道。这样就不需要显式的去订阅多个名称了，可以通过模式订阅这种方式，一次性关注多个频道。


##### 订阅/发布到「频道」实现1:N的消息队列

使用 `PUBLISH`、`SUBSCRIBE` 命令订阅一个指定的频道 `key`。


在订阅/发布模式中，消费者收到的消息，将包括下面 3 个参数
1. 消息的种类
2. 始发频道的名称
3. 实际的消息

##### 订阅/发布到「模式」

使用 `PSUBSCRIBE` 命令订阅一个模式，可以匹配多个频道。



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/mq-list-redis-4.png)


如上图所示，我们往 `java.framework` 这个频道发送了一条消息，不止订阅了该频道的 Consumer1 和 Consumer2 可以接收到消息，订阅了模式 `java.*` 的 Consumer3 和 Consumer4 也可以接收到消息。



###### Pub/Sub常用命令


| 命令	| 用法	| 描述  |
|------|-------|------|
| PSUBSCRIBE | PSUBSCRIBE pattern [pattern ...]	|  订阅一个或多个符合给定模式的频道 | 
|PUBSUB	| PUBSUB subcommand [argument [argument ...]] | 查看订阅与发布系统状态 | 
| PUBLISH | PUBLISH channel message	| 将信息发送到指定的频道 |
| PUNSUBSCRIBE | PUNSUBSCRIBE [pattern [pattern ...]] | 退订所有给定模式的频道 |
| SUBSCRIBE	| SUBSCRIBE channel [channel ...] |	订阅给定的一个或多个频道的信息 |
| UNSUBSCRIBE | UNSUBSCRIBE [channel [channel ...]] |	退订给定的频道 |


#### 3. Stream 实现消息队列

Redis 发布订阅 (pub/sub) 有个缺点就是消息无法持久化，如果出现网络断开、Redis 宕机等，消息就会被丢弃。而且也没有 Ack 机制来保证数据的可靠性，假设一个消费者都没有，那消息就直接被丢弃了。


**Redis 5.0 版本新增了一个更强大的数据结构 —— `Stream`。它提供了消息的持久化和主备复制功能，可以让任何客户端访问任何时刻的数据，并且能记住每一个客户端的访问位置，还能保证消息不丢失。**

它就像是个仅追加内容的消息链表，把所有加入的消息都串起来，每个消息都有一个唯一的 ID 和对应的内容。而且消息是持久化的。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/mq-list-redis-5.png)

每个 Stream 都有唯一的名称，它就是 Redis 的 key，在我们首次使用 `xadd` 指令追加消息时自动创建。

Streams 是 Redis 专门为消息队列设计的数据类型，所以提供了丰富的消息队列操作命令。


##### Stream常用命令

| 描述	| 用法  |
|-------|------|
| 添加消息到末尾，保证有序，可以自动生成唯一ID | XADD key ID field value [field value ...] |
| 对流进行修剪，限制长度 | XTRIM key MAXLEN [~] count |
| 删除消息	| XDEL key ID [ID ...] |
| 获取流包含的元素数量，即消息长度	| XLEN key |
| 获取消息列表，会自动过滤已经删除的消息 | XRANGE key start end [COUNT count] |
| 以阻塞或非阻塞方式获取消息列表 | XREAD [COUNT count] [BLOCK milliseconds] STREAMS key [key ...] id [id ...] |
| 创建消费者组	| XGROUP [CREATE key groupname id-or-] [DESTROY key groupname] [DELCONSUMER key groupname consumername] |
| 读取消费者组中的消息 | XREADGROUP GROUP group consumer [COUNT count] [BLOCK milliseconds] [NOACK] STREAMS key [key ...] ID [ID ...] |
| 将消息标记为“已处理” | XACK key group ID [ID ...] |
| 为消费者组设置新的最后递送消息ID	| XGROUP SETID [CREATE key groupname id-or-] [DESTROY key groupname] |
| 删除消费者 | XGROUP DELCONSUMER [CREATE key groupname id-or-] [DESTROY key groupname] |
| 删除消费者组	| XGROUP DESTROY [CREATE key groupname id-or-] [DESTROY key groupname] [DEL |
| 显示待处理消息的相关信息	| XPENDING key group [start end count] [consumer] |
|查看流和消费者组的相关信息	| XINFO [CONSUMERS key groupname] [GROUPS key] [STREAM key] [HELP] |
| 打印流信息	| XINFO STREAM [CONSUMERS key groupname] [GROUPS key] [STREAM key] [HELP] |



##### CRUD

```s
# * 号表示服务器自动生成 ID，后面顺序跟着一堆 key/value
127.0.0.1:6379> xadd mystream * f1 v1 f2 v2 f3 v3
"1609404470049-0"  ## 生成的消息 ID，有两部分组成，毫秒时间戳-该毫秒内产生的第1条消息

# 消息ID 必须要比上个 ID 大
127.0.0.1:6379> xadd mystream 123 f4 v4  
(error) ERR The ID specified in XADD is equal or smaller than the target stream top item

# 自定义ID
127.0.0.1:6379> xadd mystream 1609404470049-1 f4 v4
"1609404470049-1"

# -表示最小值 , + 表示最大值,也可以指定最大消息ID，或最小消息ID，配合 -、+ 使用
127.0.0.1:6379> xrange mystream - +
1) 1) "1609404470049-0"
   2) 1) "f1"
      2) "v1"
      3) "f2"
      4) "v2"
      5) "f3"
      6) "v3"
2) 1) "1609404470049-1"
   2) 1) "f4"
      2) "v4"

127.0.0.1:6379> xdel mystream 1609404470049-1
(integer) 1
127.0.0.1:6379> xlen mystream
(integer) 1
# 删除整个 stream
127.0.0.1:6379> del mystream
(integer) 1
```

##### 使用 xadd 来发布消息

```s
xadd mystream * name jiangwang age 26
```
1. `mystream` 是 Redis key；
2. `*` 是消息 ID，使用 `*` 表示由 Redis 自己生成消息 ID（也可以指定，但是要保证 ID 唯一）。默认生成的消息 ID 格式为「时间戳_同时间戳内消息 index」。
3. 后面的消息主体是多组 `field-value` 对，比如 `name` 是 `filed`，`jiangwang` 是 `value`。

##### 使用 xread 来独立消费

`xread` 以阻塞或非阻塞方式获取消息列表，指定 `BLOCK` 选项即表示阻塞，超时时间 0 毫秒（意味着永不超时）。


```s
# 从ID是0-0的开始读前2条
127.0.0.1:6379> xread count 2 streams mystream 0
1) 1) "mystream"
   2) 1) 1) "1609405178536-0"
         2) 1) "f5"
            2) "v5"
      2) 1) "1609405198676-0"
         2) 1) "f1"
            2) "v1"
            3) "f2"
            4) "v2"

# 阻塞的从尾部读取流，开启新的客户端xadd后发现这里就读到了,block 0 表示永久阻塞
127.0.0.1:6379> xread block 0 streams mystream $
1) 1) "mystream"
   2) 1) 1) "1609408791503-0"
         2) 1) "f6"
            2) "v6"
(42.37s)
```



#### Redis实现延时队列

**使用有序集合（zset）实现，拿时间戳作为 score，消息内容作为 key。**

**调用 zadd 来生产消息，消费者用 `zrangebyscore` 指令获取 N 秒之前的数据轮询进行处理。**


1. `zadd` 生产消息
   
```s
# 将一个或多个 member 元素及其 score 值加入到有序集 key 当中

ZADD key score member [[score member] [score member] ...]
```


2. `zrangebyscore` 获取 N 秒之前的数据

```s
# 返回有序集 key 中，所有 score 值介于 min 和 max 之间(包括等于 min 或 max )的成员。有序集成员按 score 值递增(从小到大)次序排列。

ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count]
```

3. 使用 `zrem` 消费消息


```s
# 移除有序集 key 中的一个或多个成员，不存在的成员将被忽略
ZREM key member [member ...]
```



