
# MySQL-06-读写分离和分库分表

[TOC]

## 更新
* 2022/06/09，撰写


## 参考资料
* [MySQL 主从复制读写分离 | Segmentfault](https://segmentfault.com/a/1190000023775512)
* [MySQL 读写分离详解及同步延迟问题](https://codeantenna.com/a/lkuet4ljTY)
* [MySQL 分库分表方案 | 掘金](https://juejin.cn/post/6844903648670007310)
* [分库分表方案 | 腾讯云](https://cloud.tencent.com/developer/article/1623139)
* [大众点评订单系统分库分表实践 | 美团技术](https://tech.meituan.com/2016/11/18/dianping-order-db-sharding.html)



## 前言
* ref 1-[分库分表 | Hollis](https://www.hollischuang.com/archives/6701)
  
参考上述参考链接 *ref-1*，“分库分表” 根本不是一件事，而是三件事
1. 什么时候分库
2. 什么时候分表
3. 什么时候即分库又分表





### binlog

详情见笔记「MySQL-08-日志」。


## 库的最大连接数

以 MySQL 为例，当访问连接数过多或数据库设置的最大连接数太小时，会出现 `too many connections` 的错误。

MySQL 默认的最大连接数为 100，可以修改该值。MySQL 服务允许的最大连接数是 16384（2^14）。


**<font color='red'>注意，连接数是针对库的，不是针对表的。只分表不分库，无法解决最大连接数问题。也就是说，只分表不分库，无法真正解决问题。当并发量上来了，还是会存在连接数过多的问题。分表只是用来解决一条 SQL 查询在全表扫描时扫描的数据量太大的问题。</font>**




### too many connections
* ref 1-[MySQL连接数太多应该怎么解决 | 51CTO](https://www.51cto.com/article/603854.html)



以 MySQL 为例，当访问连接数过多或数据库设置的最大连接数太小时，会出现 `too many connections` 的错误。

MySQL 数据库的默认最大连接数是 100，可以修改该值。MySQL 服务允许的最大连接数是 16384。

**<font color='red'>对于多人开发的单体项目来说，虽然我们同时在用的连接不会超过 10 个，理论上100 绰绰有余，但是除了我们正在使用的连接以外，还有很大一部分 Sleep 的连接，这个才是真正的罪魁祸首。`too many connections` 问题的根源不是连接数过多，而是 Sleep 状态的连接太多，没有释放，占用了连接数。</font>**


#### show processlist

```sql
mysql> show processlist;

+----+-----------------+-----------+------+---------+--------+------------------------+------------------+

| Id | User            | Host      | db   | Command | Time   | State                  | Info             |

+----+-----------------+-----------+------+---------+--------+------------------------+------------------+
|  5 | event_scheduler | localhost | NULL | Daemon  | 577958 | Waiting on empty queue | NULL             |
|  9 | root            | localhost | NULL | Query   |    177 | init                   | show processlist |
| 10 | root            | localhost | NULL | Sleep   |   5667 | init                   | show processlist |
| 11 | root            | localhost | NULL | Sleep   |     57 | init                   | show processlist |
| 12 | root            | localhost | NULL | Sleep   |    670 | init                   | show processlist |
| 13 | root            | localhost | NULL | Sleep   |    120 | init                   | show processlist |
| 14 | root            | localhost | NULL | Sleep   |    122 | init                   | show processlist |
| 15 | root            | localhost | NULL | Sleep   |   1312 | init                   | show processlist |
| 16 | root            | localhost | NULL | Sleep   |    123 | init                   | show processlist |
| 17 | root            | localhost | NULL | Sleep   |   2312 | init                   | show processlist |
| 18 | root            | localhost | NULL | Sleep   |   1212 | init                   | show processlist |
| 19 | root            | localhost | NULL | Query   |  12321 | init                   | show processlist |
+----+-----------------+-----------+------+---------+--------+------------------------+------------------+

12 rows in set (0.01 sec)
```



可以发现， Sleep 的连接占了绝大多数。

MySQL 数据库有一个属性 `wait_timeout` 就是 `sleep` 连接最大存活时间，默认是 28800s，换算成小时就是 8 小时，我的天呐！这也太长了！严重影响性能。相当于今天上班以来所有建立过而未关闭的连接都不会被清理。


#### 杀掉 Sleep 连接



我们将 `wait_timeout` 修改成一个合适的值，比如 250s。当然也可以在配置文件中修改，添加 `wait_timeout = 250`。

```s
set global wait_timeout=250; 
```

这样，就能从根本上解决 `Too Many Connections` 的问题了。


### 查看当前 MySQL 最大连接数

```sql
mysql> show variables like '%max_connections%';
+-----------------+-------+
| Variable_name   | Value |
+-----------------+-------+
| max_connections | 151   |
+-----------------+-------+
1 row in set (0.01 sec)
```

### 修改最大连接数

1. 在 `/etc/my.cnf` 文件中 `[mysqld]` 部分增加 `max_connections=1000`，重启 MySQL 服务，即可修改最大连接数。




## MySQL的连接池
* ref 1-[数据库连接池到底应该设多大 | 掘金](https://juejin.cn/post/7030599868615753758)



**首先，需要明确的是，线程最大个数和内存有关，和 CPU 核数无关。CPU 核数是和线程的运行效率有关。线程过多会涉及上下文的切换，一旦线程的数量超过了 CPU 核心的数量，再增加线程数系统就只会更慢，而不是更快。**

### 连接池的计算公式

下面的公式是由 PostgreSQL 提供的，不过我们认为可以广泛地应用于大多数数据库产品。你应该模拟预期的访问量，并从这一公式开始测试你的应用，寻找最合适的连接数值。**<font color='red'>连接数 = ((核心数 * 2) + 有效磁盘数)</font>**

```s
连接数 = ((核心数 * 2) + 有效磁盘数)
```

核心数不应包含超线程（hyper thread），即使打开了 hyperthreading 也是。如果活跃数据全部被缓存了，那么有效磁盘数是0，随着缓存命中率的下降，有效磁盘数逐渐趋近于实际的磁盘数。这一公式作用于 SSD 时的效果如何尚未有分析。

按这个公式，你的 4 核 i7 数据库服务器的连接池大小应该为 `((4 * 2) + 1) = 9`。取个整就算是是 10 吧。是不是觉得太小了？跑个性能测试试一下，我们保证它能轻松搞定 3000 用户以 6000TPS 的速率并发执行简单查询的场景。如果连接池大小超过 10，你会看到响应时长开始增加，TPS 开始下降。

### 公理：你需要一个小连接池和一个充满了等待连接的线程的队列

需要明确的是，你需要的并不是一个较大的连接池，而是一个小连接池和一个充满了等待连接的线程的队列。


如果你有 10000 个并发用户，设置一个 10000 的连接池基本等于失了智。1000 仍然很恐怖。即是 100 也太多了。你需要一个 10 来个连接的小连接池，然后让剩下的业务线程都在队列里等待。连接池中的连接数量应该等于你的数据库能够有效同时进行的查询任务数（通常不会高于 `2*CPU核心数`）。

我们经常见到一些小规模的 web 应用，应付着大约十来个的并发用户，却使用着一个 100 连接数的连接池。这会对你的数据库造成极其不必要的负担。




### 连接池的大小最终与系统特性相关

连接池的大小最终与系统特性相关。

比如一个混合了长事务和短事务的系统，通常是任何连接池都难以进行调优的。最好的办法是创建两个连接池，一个服务于长事务，一个服务于短事务。

再例如一个系统执行一个任务队列，只允许一定数量的任务同时执行，此时并发任务数应该去适应连接池连接数，而不是反过来。


## 基于主从复制的读写分离




### 主从复制的原理
1. 当 Master 节点进行 insert、update、delete 操作时，会按顺序写入到 binlog 中。
2. Salve 从库连接 Master 主库，Master 有多少个 Slave 就会创建多少个 binlog dump 线程。
3. 当 Master 节点的 binlog 发生变化时，binlog dump 线程会通知所有的 Salve 节点，并将相应的 binlog 内容推送给 Slave 节点。
4. I/O 线程（I/O thread）接收到 binlog 内容后，将内容写入到本地的 relay-log（中继日志）。
5. SQL 线程（SQL thread）读取 I/O 线程写入的 relay-log，并且根据 relay-log 的内容对从数据库做对应的操作。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-master-slave-copy-1.png)

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/sql-master-slave-io-thread-1.png)



> 长链接

主库和从库在同步数据的过程中断怎么办呢，数据不就会丢失了嘛。因此主库与从库之间维持了一个长链接，主库内部有一个线程，专门服务于从库的这个长链接的。

> binlog格式
* binlog 日志有三种格式，分别是 statement，row 和 mixed。
* 如果是 statement 格式，binlog 记录的是 SQL 的原文，如果主库和从库选的索引不一致，可能会导致主库不一致。
* row 格式的 binlog 日志，记录的不是 SQL 原文，而是两个 `event:Table_map` 和 `Delete_rows`。`Table_map event` 说明要操作的表，`Delete_rows event` 用于定义要删除的行为，记录删除的具体行数。row 格式的 binlog 记录的就是要删除的主键 ID 信息，因此不会出现主从不一致的问题。
*  row 格式会很占空间，因此设计 MySQL 的大叔想了一个折中的方案，`mixed` 格式的 binlog。所谓的 `mixed` 格式其实就是 row 和 statement 格式混合使用，当 MySQL 判断可能数据不一致时，就用 row 格式，否则使用就用 statement 格式。




### 读写分离

> 读写分离适用于读多写少的场景，对写多读少的场景，并不适用。

在主从复制的基础上，可进行读写分离，即主库进行写操作，从库进行读操作。



读写分离的实现方式有很多，包括
1. 基于 AOP 的方式
   * 对方法名进行判断，方法名中有 get、select、query 开头的则连接从库，其他的则连接主库。
2. MyCat
   * 阿里的开源产品
   * 支持读写分离，支持多种分库分表算法
   * 性能损耗 20% ~ 50%
   * 目前社区现状很不好，基本慢慢被抛弃
3. Apache ShardingSphere-JDBC
   * 轻量级 Java 架构，开源的分布式数据库中间件解决方案，由 JDBC、Proxy 两部分组成
   * 支持读写分离，支持多种分库分表算法
   * 性能损耗约 20%
   * 目前发展趋势较好


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-master-slave-copy-2.png)


### 存在的问题

基于主从复制实现的读写分离方案，主要存下如下几个问题
1. 主库数据丢失（可采用半同步机制解决）
2. 主从延迟（可采用并行复制解决）


#### 主库数据丢失

若主库宕机，写操作还没来得及写入 binlog 日志，会造成写入数据丢失。

对于「主库数据丢失」问题，可采用「半同步机制」解决。



MySQL 提供了一种「半同步复制」机制，也叫 `semi-sync` 复制，其过程如下
1. 主库写入 binlog 日志之后，就会将强制此时立即将数据同步到从库
2. 从库将日志写入自己本地的 relay log 之后，接着会返回一个 ack 给主库
3. 主库接收到至少一个从库的 ack 之后才会认为写操作完成了



#### 主从延迟

「主从延迟」指的是由于从机是通过 binlog 日志从 Master 同步数据的，由于某些原因造成了从机无法实时（或及时）读取到写入主库的数据（会有几十甚至几百毫秒的延迟）。

主从延迟产生的原因如下
* 硬件原因
* 主库并发，从库单线程重放
* 网络原因
* 执行大的事务



对于「主从延迟」问题，解决办法如下
1. 采用多主库方案，降低主库的并发量
2. 采用并行复制，缩短数据同步耗时
   * 从库开启多个线程，并行读取 relay log 中不同库的日志，然后并行重放不同库的日志，这是库级别的并行。
3. 写入主库并立刻查询时，规定直接从主库读取；超过一定时间后，从从库读取
   * Apache ShardingSphere-JDBC 框架规定了「同一线程且同一数据库连接内，如有写操作，以后的读操作均从主库读取，用于保证数据一致性」
4. 使用自增表
   * Mysql Proxy 中规定，在 Master 上做 insert 时，更新一张自增表。查询时，查询 Master 和 Slave 上的这张自增表的值是否一样。如果一样认为已经完成主从同步，可从从库读取，否则读取主库。




## 数据库瓶颈

不管是 IO 瓶颈，还是 CPU 瓶颈，最终都会导致数据库的活跃连接数增加，进而逼近甚至达到数据库可承载活跃连接数的阈值。在业务 Service 来看就是，可用数据库连接少甚至无连接可用。接下来就可以想象了吧（并发量、吞吐量、崩溃）。

1. IO瓶颈
   * 第 1 种：磁盘读 IO 瓶颈，热点数据太多，数据库缓存放不下，每次查询时会产生大量的 IO，降低查询速度 -> **分库和垂直分表**。
   * 第 2 种：网络 IO 瓶颈，请求的数据太多，网络带宽不够 -> **分库**。
2. CPU 瓶颈
   * 第 1 种：SQL 问题，如 SQL 中包含 join，group by，order by，非索引字段条件查询等，增加 CPU 运算的操作 -> SQL优化，建立合适的索引，在业务 Service 层进行业务计算。
   * 第 2 种：单表数据量太大，查询时扫描的行太多，SQL 效率低，CPU 率先出现瓶颈 -> **水平分表**。


## 分库分表


读写分离方案中，只解决了读的扩展性，对于写操作，仍是单机（一个主库）操作。当写操作越来越多时，就要考虑分库分表（`Sharding`）了，对写操作进行拆分。



分库分表（`Sharding`）可分为两种方式
1. 垂直拆分
2. 水平拆分

> 分库分表的顺序应该是先垂直拆分，后水平拆分。因为垂直拆分更简单，更符合我们处理现实世界问题的方式。数据库是“有状态的”，相对于 Web 和应用服务来讲，是比较难实现“横向扩展”的。



### 垂直拆分


#### 优缺点

特点 
1. 垂直拆分是基于表或字段划分，拆分出的表的结构是不同的。

优点
1. 拆分后业务清晰，方便针对业务进行优化（专库专用按业务拆分）
2. 数据维护简单，按业务不同将业务放到不同机器上

#### 垂直分表


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-sharing-5.png)

* **垂直分表，即大表拆小表，基于列字段对表拆分**
* 若表中的字段较多，可将不常用的、数据较大的、长度较长的（如 text 类型字段）的字段拆分到「扩展表」中
* 垂直分表可以避免查询时数据量太大造成的「跨页」问题


#### 垂直分库


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-sharing-4.png)

* 在一个系统中，按照不同的业务，将数据拆分到不同的数据库，并部署到多个服务器上（不要部署到一个服务器）
* 以电商系统为例，可以拆分出用户库，订单库，商品库，并部署到多个服务器上
* 垂直分库中，将拆分的库部署到多个服务器上，在一定程度上能够突破 IO、连接数及单机硬件资源的瓶颈；并且也便于服务的治理和降级。

### 水平拆分

业务量比较大的时候，即使做了垂直拆分，依然会存在以下问题
1. 如果单表的数据量大，读写压力依然很大
2. 受某种业务限制，一个业务影响到整个系统的性能，如电商系统中订单库的读写往往大于其他库

这个时候，可以考虑水平拆分进一步提升性能。


#### 优缺点

特点
1. 基于数据划分，表结构相同，数据不同

优点
1. 单库（表）的数据保持在一定的量（或减少），提高了系统的稳定性和负载能力
2. 切分表的结构相同，程序改造较少


缺点
1. 数据扩容有难度，维护量大
* 如早期按照 `userid % 2` 分两个库，后期想按照 `userid % 10` 分 10 个库，就会造成较大的改动，原有数据也要迁移
2. 拆分规则很难抽象出来
3. 分布式事务的一致性问题



#### 水平分表

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-sharing-3.png)

* 将数据量较大的单张表，按照某种规则（`RANGE` 或 `HASH`取模等），拆分到多张表中
* **水平分表中，拆分的多张表还是在同一个库中，所以库级别的数据库操作还是有 IO 瓶颈，不建议采用**

> **注意，连接数是针对库的，不是针对表的。只分表不分库，无法解决最大连接数问题。**
> 
> **<font color='red'>分表仅仅是解决了单一表数据过大的问题，但由于表的数据还是在同一台机器上，其实对于提升 MySQL 并发能力没有什么意义，所以水平拆分最好分库。</font>**


#### 水平分库

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-sharing-2.png)

* 将单张表的数据切分到多个服务器上去，每个服务器具有相应的库与表，只是表中数据集合不同
* **水平分库分表能够有效的缓解单机和单库的性能瓶颈和压力，突破IO、连接数、硬件资源等的瓶颈**

> 单纯使用水平分表意义不大，一般伴随着水平分库一起使用。

#### 拆分维度

1. RANGE
   * 如 1~1W 为一个表，1W~2W 为一个表
2. HASH 取模
   * 如对用户 ID 进行 HASH 取模，映射到不同的表中
3. 地理区域
   * 如按照华南，华北，东北等地理区域拆分
4. 时间
   * 按时间维度拆分，比如今年，去年，前年




### 存在的问题

分库分表后，存在如下问题
1. 事务支持
   * 分库分表后，需要执行分布式事务
2. 多库结果集合并（`group by`，`order by`）
3. 跨库 JOIN
   * 可通过表中添加冗余字段或使用中间件进行组装 JOIN
4. 自增 ID 问题
   * 可使用全局唯一 ID 生成的方案，如雪花 ID



### 开源产品

1. sharding-sphere
2. TDDL（Taobao Distribute Data Layer）
3. MyCat

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-sharding-1.png)



## 不停机扩容怎么实现

* [MySQL六十六问，两万字+五十图详解](https://mp.weixin.qq.com/s/zSTyZ-8CFalwAYSB0PN6wA)

> 第 1 阶段：在线双写，查询走老库

* 建立好新的库表结构，数据写入旧库的同时，也写入拆分的新库
* 数据迁移，使用数据迁移程序，将旧库中的历史数据迁移到新库
* 使用定时任务，新旧库的数据对比，把差异补齐

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/mysql-double-write-1.png)


> 第 2 阶段：在线双写，查询走新库
* 完成了历史数据的同步和校验
* 把对数据的读切换到新库

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/mysql-double-write-2.png)


> 第 3 阶段：旧库下线
* 旧库不再写入新的数据
* 经过一段时间，确定旧库没有请求之后，就可以下线老库


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/mysql-double-write-3.png)


## MySQL并行复制（MTS）
* [MySQL并行复制的深入浅出 | 阿里云](https://developer.aliyun.com/article/621197)
* [速度提升5~10倍，基于WRITESET的MySQL并行复制](https://mp.weixin.qq.com/s/oj-DzpR-hZRMMziq2_0rYg?spm=a2c6h.12873639.article-detail.4.c491552beO5B0c)

### 为什么有并行复制
在主从复制时，从库会有两类线程
1. IO 线程，用于接收主库传递过来的 binlog 日志，并将其写入到 relay log 中
2. SQL 线程，读取 relay-log，并根据 relay-log 的内容对从数据库做对应的操作

为了提升复制效率，有必要引入并行复制
1. 主从复制，瓶颈并不在从库的 IO 线程，所以没必要引入多 IO 线程
2. 主从复制中，将单 SQL 线程改为多 SQL 线程，可以大大提升复制效率


### 如何实现并行复制

是否能够并行，关键在于多事务之间是否有锁冲突，这是关键。下面的并行复制原理就是在看如何让避免锁冲突。

不同的 MySQL 版本中，并行复制的实现方案也不同
1. MySQL 5.6 基于 schema 的并行复制
2. MySQL 5.7 基于 group commit 的并行复制
3. MySQL 8.0 基于 write-set 的并行复制



MySQL 从 5.6 版本开始支持并行复制机制，官方称为 MTS（Multi-Thread Slave），经过几个版本的迭代，目前 MTS 支持以下几种机制。

| 版本	| MTS 机制	| 实现原理 |
|-------|-----------|---------|
| 5.6	|  Database	| 基于库级的并行复制 | 
| 5.7	| COMMIT_ORDER	| 基于组提交的并行复制 | 
| 5.7.22	| WRITESET/WRITESET_SESSION	| 基于 WRITESET 的并行复制 | 



### MySQL 5.6 基于 schema 的并行复制

> slave-parallel-type = DATABASE（不同库的事务，没有锁冲突）


并行复制的目的就是要让 slave 尽可能的多 SQL 线程跑起来，当然基于库级别的多线程也是一种方式，不同库的事务，没有锁冲突。

MySQL 5.6 基于 schema 的并行复制的示意图如下。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/mysql-master-slave-paralle-copy-1.png)




优点
1. 实现相对来说简单，对用户来说使用起来也简单

缺点
1. 由于是基于库的，那么并行的粒度非常粗
2. 现在很多公司的架构是一库一实例，针对这样的架构，5.6 的并行复制无能为力


### MySQL 5.7 基于 group commit 的并行复制

> slave-parallel-type = LOGICAL_CLOCK : Commit-Parent-Based 模式（同一组的事务 [ last-commit 相同 ]，没有锁冲突。同一组，肯定没有冲突，否则没办法成为同一组)
> 
> slave-parallel-type = LOGICAL_CLOCK : Lock-Based 模式（即便不是同一组的事务，只要事务之间没有锁冲突 [ prepare 阶段]，就可以并发。不在同一组，只要 N 个事务 prepare 阶段可以重叠，说明没有锁冲突）

MySQL 5.7 在组提交的时候，还为每一组的事务打上了标记。

### MySQL 8.0 基于 write-set 的并行复制

MySQL 8.0 中，提出了基于 write-set 的并行复制。详情参考 [速度提升5~10倍，基于WRITESET的MySQL并行复制](https://mp.weixin.qq.com/s/oj-DzpR-hZRMMziq2_0rYg?spm=a2c6h.12873639.article-detail.4.c491552beO5B0c)，下面仅做大纲记录。




Master 端在记录 binlog 的 `last_committed` 方式有如下两种
1. 基于 `commit-order` 的方式中，`last_committed` 表示同一组的事务拥有同一个 `parent_commit`。
2. 基于 `write-set` 的方式中，`last_committed` 的含义是保证冲突事务（相同记录）不能拥有同样的 `last_committed` 值

当事务每次提交时，会计算修改的每个行记录的 `WriteSet` 值，然后查找哈希表中是否已经存在有同样的 `WriteSet`
1. 若无，`WriteSet` 插入到哈希表，写入二进制日志的 `last_committed` 值保持不变，意味着上一个事务跟当前事务的 `last_committed` 相等，那么在 slave 就可以并行执行
2. 若有，更新哈希表对应的 `WriteSet` 的 value 为 sequence number，并且写入到二进制日志的 `last_committed` 值也要更新为sequnce_number。意味着，相同记录（冲突事务）回放，`last_committed` 值必然不同，必须等待之前的一条记录回放完成后才能执行。