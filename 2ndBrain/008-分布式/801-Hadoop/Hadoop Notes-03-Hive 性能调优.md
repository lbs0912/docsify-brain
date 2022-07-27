# Hadoop Notes-03-Hive 性能调优


[TOC]

## 更新
* 2020/04/19，撰写
* 2020/05/19，添加 *[Hive性能优化 | blog](https://www.cnblogs.com/smartloli/p/4356660.html)* 阅读笔记
* 2020/05/19，添加 *Hive SQL 编译过程* 


## 学习资料
* 《Hive实战》-Chap 9-Hive性能调优
* 《Hive性能调优实战》（电子书-豆瓣阅读）
* [那些年使用Hive踩过的坑 | blog](https://www.cnblogs.com/smartloli/p/4288493.html)
* [Hive性能优化 | blog](https://www.cnblogs.com/smartloli/p/4356660.html)




## Hive SQL编译过程

### 参考资料
* [Hive中Join的原理和机制](http://lxw1234.com/archives/2015/06/313.htm)
* [Hive SQL的编译过程 | 美团技术](https://tech.meituan.com/2014/02/12/hive-sql-to-mapreduce.html)
* [Hive 执行过程实例分析 | blog](https://www.cnblogs.com/qingyunzong/p/8847651.html)




### Join机制

**Hive 中的 `Join` 可分为 `Common Join`（Reduce 阶段完成 `join`）和 `Map Join`（Map 阶段完成 `join`）两种。**



<font color="red">**Hive中Join的关联键必须在ON ()中指定，不能在Where中指定，否则就会先做笛卡尔积，再过滤。**</font>  —— [一起学Hive之十一-Hive中Join的类型和用法](http://lxw1234.com/archives/2015/06/315.htm)

#### Hive Common Join

如果不指定 `MapJoin` 或者不符合 `MapJoin` 的条件，那么 Hive 解析器会将 `Join` 操作转换成 `Common Join`，即在 Reduce 阶段完成 `join`。

整个过程包含 Map、Shuffle、Reduce 阶段。

> Map-映射：负责将数据分为键值对
>
> shuffle-洗牌：将 map 输出的值进行排序和分区后再给 Reduce
> 
> Reduce-合并：将具有相同key的value进行处理后（shuffle）作为最终的结果


* Map 阶段

1. 读取源表的数据，Map 输出时候以 `join on` 条件中的列为 `key`，如果 `Join` 有多个关联键，则以这些关联键的组合作为 `key`
2. Map 输出的 `value` 为 `join` 之后所关心的(`select` 或者 `where` 中需要用到的)列；
3. **同时在 `value` 中还会包含表的 `Tag`信息，用于标明此 `value`对应哪个表**
4. 按照 `key` 进行排序


* Shuffle 阶段
1. 根据 `key` 的值进行 `hash`，并将 `key/value` 按照 `hash` 值推送至不同的 `reducer` 中，这样确保两个表中相同的 `key` 位于同一个 `reducer` 中


* Reduce阶段
1. 根据 `key` 的值完成 `join` 操作，**期间通过 `Tag` 来识别不同表中的数据。**


以下面的 HQL 为例，图解其过程


```
SELECT 
  a.id,a.dept,b.age 
FROM a join b 
  ON (a.id = b.id);
```

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hive-join-step-1.png)

结合上图分析 `Join` 机制
1. `join on` 条件中的列为 `id`，因此在 Map 阶段，`key` 为 `id` 字段的值，即 `1` 和 `2`
2. 在 `value` 中还会包含表的 `Tag`信息，用于标明此 `value`对应哪个表。本例中 `tag` 信息是 `a` 和 `b`，因此会看到如 `<a,行政>` 和 `<b,26>` 等信息。
3. Shuffle 阶段，会根据 `key` 的值进行 `hash`。







下面再看一个 HQL 实例。


```
SELECT 
    u.name, o.orderid 
FROM 
    order o 
JOIN 
    user u 
ON 
    o.uid = u.uid;
```

其过程如下图所示。需要注意的是，图中的 `value=<1,orange>` 中的 1 是表的 `tag`。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hive-join-step-2.png)







#### Hive Map Join

MapJoin 通常用于一个很小的表和一个大表进行 `join` 的场景。具体小表有多小，由参数 `hive.mapjoin.smalltable.filesize` 来决定，该参数表示小表的总大小，默认值为 `25000000` 字节，即 25M。


Hive 0.7 之前，需要使用 `hint` 提示 `/*+ mapjoin(table) */` 才会执行 MapJoin，否则执行 Common Join。但在 0.7 版本之后，默认自动会转换 Map Join，由参数 `hive.auto.convert.join` 来控制，默认为 true。



以下面的 HQL 为例，图解其过程


```
SELECT 
  a.id,a.dept,b.age 
FROM a join b 
  ON (a.id = b.id);
```

假设 a 表为一张大表，b 为小表，并且 `hive.auto.convert.join=true`，那么 Hive 在执行时候会自动转化为 MapJoin。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hive-map-join-step-1.png)


如上图所示
1. 首先是 Task A，它是一个 Local Task（在客户端本地执行的Task），负责扫描小表 b 的数据。将其转换成一个 HashTable 的数据结构，并写入本地的文件中，之后将该文件加载到 DistributeCache 中，该 HashTable 的数据结构可以抽象为


key | value
-----|--------
1 | 26
2 | 34


2. 下图的红框部分圈出了执行 `Local Task` 的信息

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hive-map-join-step-2.png)


3. 接下来是 Task B，该任务是一个没有 Reduce 的 MR，启动 MapTasks 扫描大表 a。在 Map 阶段，根据 a 的每一条记录去和 `DistributeCache` 中 b 表对应的 `HashTable` 关联，并直接输出结果。
4. **由于 MapJoin 没有 Reduce，所以由 Map 直接输出结果文件，有多少个 Map Task，就有多少个结果文件。**



### GROUP BY机制


```
select rank, isonline, count(*) 
from city 
group by rank, isonline;
```

1. **将 GroupBy 的字段组合为 map 的输出 key 值**
2. 利用 MapReduce 的排序，在 reduce 阶段保存 LastKey 区分不同的 key。
3. MapReduce 的过程如下（当然这里只是说明 Reduce 端的非 Hash 聚合过程）

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hive-group-by-step-1.png)



### distinct 机制

按照 age 分组，然后统计每个分组里面的不重复的 pageid 有多少个。


```
SELECT age, count(distinct pageid) 
FROM pv_users 
GROUP BY age;
```

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hive-distinct-step-1.png)

执行过程如上图所示，语句会按照 age 和 pageid 预先分组，进行 distinct 操作。然后会再按 照 age 进行分组，再进行一次 distinct 操作。

## Hive数据倾斜

### 参考资料
* [Hive的数据倾斜解决方案 | blog](http://www.timebusker.top/2018/01/09/Hive%E7%9A%84%E6%95%B0%E6%8D%AE%E5%80%BE%E6%96%9C%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88/)
* [hive数据倾斜原理与解决方案 | 简书](https://www.jianshu.com/p/859e39475832)
* [Hive数据倾斜与解决方案 | 知乎](https://zhuanlan.zhihu.com/p/105987407)





### 什么是数据倾斜

由于数据分布不均匀，造成数据大量的集中到一点，造成数据热点。

Hadoop框架的特性
1. 不怕数据大，怕数据倾斜
2. Jobs 数比较多的作业运行效率相对比较低，如子查询比较多
3. sum,count,max,min 等聚集函数，通常不会有数据倾斜问题


### 数据倾斜的主要表现

* 在执行任务的时候，任务进度长时间维持在 99% 左右。查看任务监控页面，发现只有少量（1个或几个）reduce 子任务未完成。因为其处理的数据量和其他 reduce 差异过大。
* 单一 reduce 的记录数与平均记录数差异过大，通常可能达到 3 倍甚至更多。最长时长远大于平均时长。


### 容易数据倾斜的场景
1. 小表关联超大表 join
2. 大表关联大表 join，但 key 比较集中到一个值上，如 null
3. `count(distinct)`，在数据量大的情况下，容易数据倾斜，因为 `count(distinct)` 是按 `group by` 字段分组，按 `distinct` 字段排序
4. `group by`，数据量大，维度太小
5. `key` 分布不均匀


| 关键词  |  情形 | 后果 |
|---------|-------|-------|
| Join    | 其中一个表较小，但是key集中  |  分发到某一个或几个Reduce上的数据远高于平均值| 
| join  |  大表与大表，但是分桶的判断字段 0 值或空值过多 | 这些空值都由一个reduce处理，非常慢 | 
| group by  |  group by 维度过小，某值的数量过多 | 处理某值的reduce灰常耗时 | 
| Count Distinct | 某特殊值过多  | 处理此特殊值的reduce耗时 | 



> 首先，阅读本文的 *Hive SQL编译过程* 章节，了解 `JOIN` 和 `GroupBy` 的编译过程。

**结合` JOIN` 和 `GroupBy` 的编译过程，此处给出导致数据倾斜的原因**
1. 对于 `join` 过程来说，如果出项较多的 `key` 值为空或异常的记录，或 `key` 值分布不均匀，就容易出现数据倾斜
2. 对于 `group by` 过程来说，如果某一个 key 值有特别的多的记录，其它 key 值的记录比较少，也容易出项数据倾斜


### 空值产生的数据倾斜

在日志中，常会有信息丢失的问题，比如日志中的 `user_id`，如果取其中的 `user_id` 和用户表中的 `user_id` 相关联，就会碰到数据倾斜的问题。

* 方法 1：`user_id` 为空的不参与 join 关联

```
select * 
from log a join user b 
on a.user_id is not null and a.user_id = b.user_id
union all;

select * from log c where c.user_id is null;
```

* 方法2：**赋予空值新的随机 key 值** 


```
select * 
from log a left outer join user b 
on
    case when a.user_id is null 
    then concat('hive',rand()) 
    else a.user_id end = b.user_id
```

**方法2 比方法1 效率更好**，不但 IO 少了，而且作业数也少了。
1. 方案1中，log 表读了两次，jobs 肯定是 2；而方案2是1。
2. **这个优化适合无效 id（比如 `-99`，`''`，`null`）产生的数据倾斜，把空值的 `key` 变 成一个字符串加上一个随机数，就能把造成数据倾斜的数据分到不同的 reduce 上，解决了数据倾斜的问题。** 
3. 上述优化方案中，使本身为 `null` 的所有记录不会拥挤在同一个 `reduceTask` 了，会由于有替代的随机字符串值，而分散到了多个 `reduceTask` 中了，由于 `null` 值关联不上，处理后并不影响最终结果。


### 不同数据类型关联产生数据倾斜

用户表中 `user_id` 字段为 int，log 表中 `user_id` 字段既有 `string` 也有 `int` 类型。 当按照两个表的 `user_id` 进行 join 操作的时候，**默认的 hash 操作会按照 int 类型的 id 进行分配，这样就会导致所有的 string 类型的 id 就被分到同一个 reducer 当中，造成了数据倾斜。**

解决方法为，统一数据类型，如下所示

```
select * from user a left outer join log b 
on b.user_id = cast(a.user_id as string)
```

### 大表与小表关联查询产生数据倾斜

使用 `map join` 解决小表关联大表造成的数据倾斜问题（这个方法使用的频率很高）。

**`map join` 概念：将其中做连接的小表（全量数据）分发到所有 `MapTask` 端进行 `Join`，从 而避免了 `reduceTask`，前提要求是内存足以装下该全量数据。**


```
# /* +mapjoin(内存中加载小表) */
select /* +mapjoin(a) */ a.id aid, a.name, b.age from a join b on a.id = b.id;
```

在 hive 0.11 版本以后会自动开启 `map join` 优化，由两个参数控制


```
// 设置 MapJoin 优化自动开启
set hive.auto.convert.join=true; 

// 设置小表不超过多大时开启 mapjoin 优化
set hive.mapjoin.smalltable.filesize=25000000 
```

**需要注意的是，新版的 hive 已经对小表 JOIN 大表，以及大表 JOIN 小表进行了优化。小表放在左边和右边，新版本中已经没有明显区别。**


### 大表与大表之间数据倾斜


大表与大表之间数据倾斜主要原因是，某一个 key 比较集中导致。

解决方法为进行业务逻辑的拆分，大表拆分为小表。把大表中集中的 key 取出作为小表，使用 `map join`。



### count distinct大量相同特殊值

count distinct 时，将值为空的情况单独处理，如果是计算 count distinct，可以不用处理，直接过滤，在最后结果中加1。

如果还有其他计算，需要进行group by，可以先将值为空的记录单独处理，再和其他计算结果进行 union。




#### join引起数据倾斜的解决方法

1. 如果是由于 key 值为空或为异常记录，且这些记录不能被过滤掉的情况下，可以考虑给 key 赋一个随机值，将这些值分散到不同的 reduce 进行处理。
2. 如果是一个大表和一个小表 join 的话，可以考虑使用 `MapJoin` 来避免数据倾斜，其的具体过程如下

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hive-map-join-step-3.png)




* 通过 `mapreduce local task`，扫描小表，生成为一个 `hashtable` 文件, 并上传到 `distributed cache`
* 在 map 阶段，每个 mapper, 从 `distributed cache` 中读取 `hashtable` 文件，扫描大表，并直接在 map 端 join
* 在 key 值都为有效值时，还可以通过设置每个 reduce 处理的数据量的大小来处理数据倾斜，即

```
//这两个一般不同时使用

set hive.exec.reducers.bytes.per.reducer = 1000000000或

set mapred.reduce.tasks=800
```

* 另外，还可以设置下面两个参数


```
set hive.optimize.skewjoin = true;

set hive.skewjoin.key = skew_key_threshold （default = 100000）
```

可以就按官方默认的 1 个 reduce 只处理1G 的算法，那么 `skew_key_threshold= 1G/平均行长` 或者默认直接设成 `250000000` (差不多算平均行长4个字节)




### groupby引起数据倾斜的解决方法

1. `set hive.map.aggr=true`，开启 map 之后使用 `combiner`，这样基本上是对各记录比较同质的数据效果比较好。相反，则没有什么意义。通用的做法是设置下面两个参数

```
// (默认)执行聚合的条数
set hive.groupby.mapaggr.checkinterval = 100000

// (默认)如果hash表的容量与输入行数之比超过这个数，那么map端的hash聚合将被关闭，默认是0.5，设置为1可以保证hash聚合永不被关闭
set hive.map.aggr.hash.min.reduction=0.5
```


2. 设置 `set hive.groupby.skewindata=true`，这个只针对单列有效。



### 集群任务调优避免数据倾斜

针对集群运行中可能存在数据倾斜的任务，进行集群任务参数优化配置。

1. 开启 map 端部分聚合功能

```
hive.map.aggr=true
```

将 key 相同的归到一起，减少数据量，这样就可以相对地减少进入 reduce 的数据量，在一定程度上可以提高性能。当然，如果数据的减少量微乎其微，那对性能的影响几乎没啥变化。

2. 任务负载均衡

```
hive.groupby.skewindata=true
```

如果发生了数据倾斜就可以通过它来进行负载均衡。当选项设定为 true，生成的查询计划会有两个 MR Job。
* 第一个 MR Job 中，Map 的输出结果集合会随机分布到 Reduce 中，每个 Reduce 做部分聚合操作，并输出结果，这样处理的结果是相同的 Key，有可能被分发到不同的 Reduce 中，从而达到负载均衡的目的；
* 第二个 MR Job 再根据预处理的数据结果按照 Key 分布到 Reduce 中（这个过程是按照 key 的 hash 值进行分区的，不同于 MR job1 的随机分配，这次可以保证相同的 Key 被分布到同一个 Reduce 中），最后完成最终的聚合操作。
* 所以它主要就是先通过第一个 MR job 将 key 随机分配到 reduce，使得会造成数据倾斜的 key 可能被分配到不同的 reduce上，从而达到负载均衡的目的。到第二个 MR job中，因为第一个 MR job 已经在 reduce 中对这些数据进行了部分聚合。

> 就像单词统计的例子，a 这个字母在不同的 reduce 中，已经算出它在每个 reduce 中的个数，但是最终的总的个数还没算出来，那么就将它传到第二个 MR job，这样就可以得到总的单词个数，所以这里直接进行最后的聚合就可以了。


3. 任务数据量控制

```
位/比特（bit）–> 字节(byte) –> 千字节(kb) –> 兆字节(mb) –> 吉字节(gb) –> 太字节(tb) –> 拍字节(pb)
```

```
hive.exec.reducers.bytes.per.reducer=1024*1024*1024 （单位是字节,1GM）
```

控制每个 reduce 任务计算的数据量。



4. 任务数量控制

```
hive.exec.reducers.max=999
```

设置最大可以开启的 reduce 个数，默认是 999 个。

在只配了 `hive.exec.reducers.bytes.per.reducer` 以及 `hive.exec.reducers.max` 的情况下，实际的 reduce 个数会根据实际的数据总量/每个 reduce 处理的数据量来决定。


5. 指定reduce任务数

```
mapred.reduce.tasks=-1
```

实际运行的 reduce 个数，默认是 -1，会自动根据集群参数计算任务数，但如果在此指定了，那么就不会通过实际的总数据量/ `hive.exec.reducers.bytes.per.reducer` 来决定 reduce 的个数。






## 存储格式
* [Hive-ORC文件存储格式 | Blog](https://www.cnblogs.com/cxzdy/p/5910760.html)
* [Hadoop全家桶-ORC文件格式 | 掘金](https://juejin.im/post/5d7717f3f265da03900557a6)
* [Hive - ORC 文件存储格式](https://www.cnblogs.com/ittangtang/p/7677912.html)

有些文件格式专门针对 Hive 使用进行了优化，这其中就包括 `ORC` 文件和 `Parquet` 文件。这两种格式都旨在减少查询期间从磁盘读取的数据量，从而提高查询的总体性能。

### ORC格式

`ORC` (`Optimized Row Columnar`) 格式是一种基于列的存储格式，这意味着，它并不是按单个数据行连续将全部数据存储在磁盘上，而是按每列连续存储数据。这样对于那些不包括某些列的查询，就可以避免不必要的磁盘访问，可以“跳过”那些在结果中不需要的大部分数据。


ORC File作用是降低 Hadoop 数据存储空间和加速 Hive 查询速度。 

> ORC File 演变史： TEXT File -> 列式存储 -> RCFile -> ORCFile。


#### ORC 数据存储方法

### Parquet格式
