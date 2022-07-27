
# NoSQL-07-Spark、Hive、HBase


[TOC]


## 更新
* 2022/05/31，撰写



## Scala



### na.fill

* [在Spark DataFrame 中的 na.fill | Scala](http://cn.voidcc.com/question/p-xcmnssdd-bmb.html)
* [Spark Scala 中对Null/Nan的处理](https://www.cnblogs.com/houji/p/9968281.html)



针对不同类型的列，填充不同的默认值。

```s
val typeMap = df.dtypes.map(column => 
    column._2 match { 
     case "IntegerType" => (column._1 -> 0) 
     case "StringType" => (column._1 -> "") 
     case "DoubleType" => (column._1 -> 0.0) 
    }).toMap 

dataDF.withColumn("dt", functions.lit(dt1))
    .na.fill(typeMap)    # .na.fill(0) 
    .write.mode(SaveMode.Overwrite)
    .insertInto(RACE_SHOP_RANK_IND_TABLE_NAME)
```





### groupBy()-agg()


* [SparkSQL--内置函数--groupBy()-agg() | 使用示例](http://www.manongjc.com/detail/19-iueeuuqexnuczft.html)


```s
[root@centos00 ~]$ cd /opt/cdh5.14.2/hadoop-2.6.0-cdh5.14.2/
[root@centos00 hadoop-2.6.0-cdh5.14.2]$ sbin/hadoop-daemon.sh start namenode
[root@centos00 hadoop-2.6.0-cdh5.14.2]$ sbin/hadoop-daemon.sh start datanode
        
[root@centos00 ~]$ cd /opt/cdh5.14.2/hive-1.1.0-cdh5.14.2/
[root@centos00 hive-1.1.0-cdh5.14.2]$ bin/hive --service metastore &
        
[root@centos00 hadoop-2.6.0-cdh5.14.2]$ cd ../spark-2.2.1-cdh5.14.2/
[root@centos00 spark-2.2.1-cdh5.14.2]$ sbin/start-master.sh
[root@centos00 spark-2.2.1-cdh5.14.2]$ sbin/start-slaves.sh
[root@centos00 spark-2.2.1-cdh5.14.2]$ bin/spark-shell --master local[2]


scala> val df = Seq(
     | ("01", "Jack", "28","SALES", "1000"),
     | ("02", "Tom", "19","MANAGEMENT", "2500"),
     | ("03", "Mike", "25","MARKET", "2000"),
     | ("04", "Tina", "30","LOGISTICS", "3000"),
     | ("05", "Alex", "18","MARKET", "3500"),
     | ("06", "Bob",  "22","CLERK", "1500"),
     | ("07", "Dvaid","25","CLERK", "2500"),
     | ("08", "Ben",  "35","MARKET", "500"),
     | ("09", "Franklin", "32","SALES", "1000")).toDF("user_id", "name", "age", "department", "expense")
df: org.apache.spark.sql.DataFrame = [user_id: string, name: string ... 3 more fields]

scala> df.show
+-------+--------+---+----------+-------+
|user_id|    name|age|department|expense|
+-------+--------+---+----------+-------+
|     01|    Jack| 28|     SALES|   1000|
|     02|     Tom| 19|MANAGEMENT|   2500|
|     03|    Mike| 25|    MARKET|   2000|
|     04|    Tina| 30| LOGISTICS|   3000|
|     05|    Alex| 18|    MARKET|   3500|
|     06|     Bob| 22|     CLERK|   1500|
|     07|   Dvaid| 25|     CLERK|   2500|
|     08|     Ben| 35|    MARKET|    500|
|     09|Franklin| 32|     SALES|   1000|
+-------+--------+---+----------+-------+

scala> df.groupBy("department").agg(max("age"), sum("expense")).show
+----------+--------+------------+
|department|max(age)|sum(expense)|
+----------+--------+------------+
|     CLERK|      25|      4000.0|
|     SALES|      32|      2000.0|
|    MARKET|      35|      6000.0|
| LOGISTICS|      30|      3000.0|
|MANAGEMENT|      19|      2500.0|
+----------+--------+------------+
```






## Spark
### 窗口函数

#### 参考资料
* [Spark 窗口函数 I](https://xie.infoq.cn/article/c393dbf033e95b7d020cf1590)
* [Spark SQL中的窗口函数](http://yangcongchufang.com/Introducing-Window-Functions-in-Spark-SQL.html)
* [Spark-窗口函数实现原理及各种写法](https://www.jianshu.com/p/409312265fa4)
* [Spark Window 入门介绍 - 图解](https://lotabout.me/2019/Spark-Window-Function-Introduction/)

#### 简介

> 窗口函数的核心出发点，在处理当前这条数据时，还需要考虑上下文，比如随机取N条数据等。





在 Spark 中支持两种方式使用窗口函数
1. Spark SQL
2. Spark DataFrame SQL


窗口函数是一种特殊的聚合函数。当应用它们时，原表的行不会改变（普通的聚合函数聚合后，行数一般都会小于原表），新值将作为新列添加到其中。


```s
import pyspark.sql.functions as F
from pyspark.sql import Window

product_revenue_data = [
  ("Thin", "Cell Phone", 6000),
  ("Normal", "Cell Phone", 1500),
  ("Mini", "Tablet", 5500),
  ("Ultra thin", "Cell Phone", 5000),
  ("Very thin", "Cell Phone", 6000),
  ("Big", "Tablet", 2500),
  ("Bendable", "Cell Phone", 3000),
  ("Foldable", "Cell Phone", 3000),
  ("Pro", "Tablet", 4500),
  ("Pro2", "Tablet", 6500)
]

product_revenue = spark.createDataFrame(product_revenue_data, 
    schema=["product", "category", "revenue"])
product_revenue.show()
```

```s
+----------+----------+-------+
|   product|  category|revenue|
+----------+----------+-------+
|      Thin|Cell Phone|   6000|
|    Normal|Cell Phone|   1500|
|      Mini|    Tablet|   5500|
|Ultra thin|Cell Phone|   5000|
| Very thin|Cell Phone|   6000|
|       Big|    Tablet|   2500|
|  Bendable|Cell Phone|   3000|
|  Foldable|Cell Phone|   3000|
|       Pro|    Tablet|   4500|
|      Pro2|    Tablet|   6500|
+----------+----------+-------+
```

然后，通过 select 方法内部定义了一个典型的窗口函数

```s
product_revenue.select(
    'product', 
    'category',
    'revenue', 
    F.sum("revenue").over(Window.partitionBy('category').orderBy('revenue')).alias("cn")
).show()
```

```s
+----------+----------+-------+-----+
|   product|  category|revenue|   cn|
+----------+----------+-------+-----+
|       Big|    Tablet|   2500| 2500|
|       Pro|    Tablet|   4500| 7000|
|      Mini|    Tablet|   5500|12500|
|      Pro2|    Tablet|   6500|19000|
|    Normal|Cell Phone|   1500| 1500|
|  Bendable|Cell Phone|   3000| 7500|
|  Foldable|Cell Phone|   3000| 7500|
|Ultra thin|Cell Phone|   5000|12500|
|      Thin|Cell Phone|   6000|24500|
| Very thin|Cell Phone|   6000|24500|
+----------+----------+-------+-----+
```


在结果中，cn 是使用窗口函数生成的新列。可以发现，虽然是聚合统计，但返回新表的行数和原表的行数是相等的。





#### 分区条件+窗口函数

不过与聚合一样，**一个完整的窗口分析语句也由两个部分组成：分区条件和窗口函数**。如下语句中，` F.sum("revenue")` 为窗口函数，`Window.partitionBy('category')` 为分区条件。


```s
 F.sum("revenue").over(Window.partitionBy('category').orderBy('revenue')).alias("cn")
```

开发者要使用窗口函数的话，需要使用下面的方式去标记，代表想“开窗”
1. SQL 语句中，在想执行开窗的函数的后面加一个 `OVER` 子句，比如 `avg(revenue) OVER (...)`
2. 同理，DataFrame API 中，在想执行开窗的语句后也是加一个 `over` 方法，比如 `rank().over(...)`

当一个函数被标记成想 "开窗" 后，下一步就是定义一下针对这个窗口要做啥里面放点啥，这里暂且称为 "窗口定义"。所谓 "窗口定义" 就是要将输入的各行数据生成前文所提到的 "数据框"。一个 "窗口定义" 要包含三个部分去声明
1. 分区字段的定义
2. 排序字段的定义
3. 框选范围定义


在SQL中，`PARTITION BY` 和 `ORDER BY` 关键字是分别用于分区字段定义的表达式和排序字段定义的表达式。SQL语法如下所示

```s
OVER (PARTITION BY ... ORDER BY ...) 
```


在 DataFrame API中，提供了工具函数去做 "窗口定义"。在下面的 Python 示例中，示范了分区表达式和排序表达式的用法

```s
from pyspark.sql.window import Window
windowSpec = \
  Window \
    .partitionBy(...) \
    .orderBy(...)
```



#### 窗口函数分类

Spark SQL 支持 3 种类型的窗口函数
1. 排名函数(ranking function)
2. 分析函数 (analytic functions)
3. 聚合函数(aggregate functions)

其中聚合函数（如 max, min, avg 等) 常用在 reduce 操作中，不再介绍，其它函数如下。

* Ranking functions


| SQL	| Dataframe API |
|-------|---------------|
| rank	 |  rank |
| dense_rank	| denseRank | 
| percent_rank | 	percentRank |
| ntile	 | ntile |
| row_number |	rowNumber |


* Analytic functions

| SQL	| Dataframe API |
|-------|---------------|
| cume_dist	 | cumeDist |
| first_value	| firstValue |
| last_value	| lastValue |
| lag |	lead |


这些函数在使用时，只需要将函数应用在窗口定义上，例如 `avg(df.score).over(windowSpec)`。



## HBbse




### RowKey在查询中的作用

* [一篇文章带你快速搞懂HBase RowKey设计](https://mp.weixin.qq.com/s?__biz=MzU5OTM5NjQ2NA==&mid=2247483771&idx=1&sn=ead4fbbee2981451723640fae67e6cb4&chksm=feb4d864c9c3517298b9faa84f09eafd6b08bfb4addfc389873dfe0105b73befa09578ba5187&token=302026731&lang=zh_CN&scene=21#wechat_redirect)



HBase 中 RowKey 可以唯一标识一行记录，在 HBase 中检索数据有以下三种方式
1. 通过 get 方式，指定 RowKey 获取唯一一条记录
2. 通过 scan 方式，设置 startRow 和 stopRow 参数进行范围匹配
3. 全表扫描，即直接扫描整张表中所有行记录


大量请求访问 HBase 集群的一个或少数几个节点，造成少数 RegionServer 的读写请求过多、负载过大，而其他 RegionServer 负载却很小，这样就造成「热点现象」。大量访问会使热点 Region 所在的主机负载过大，引起性能下降，甚至导致 Region 不可用。所以我们在向 HBase 中插入数据的时候，应尽量均衡地把记录分散到不同的 Region 里去，平衡每个 Region 的压力。


### RowKey在Region中的作用

在 HBase 中，Region 相当于一个数据的分片，每个 Region 都有StartRowKey 和 StopRowKey，这是表示 Region 存储的 RowKey 的范围。

HBase 表的数据时按照 RowKey 来分散到不同的 Region，要想将数据记录均衡的分散到不同的 Region 中去，因此需要 RowKey 满足这种散列的特点。此外，在数据读写过程中也是与 RowKey 密切相关，RowKey在读写过程中的作用如下。
1. 读写数据时通过 RowKey 找到对应的 Region；
2. MemStore 中的数据是按照 RowKey 的字典序排序；
3. HFile 中的数据是按照 RowKey 的字典序排序。


#### RowKey 设计原则

1. **长度原则**，RowKey 是一个二进制码流，可以是任意字符串，最大长度为 64kb，实际应用中一般为 10-100byte，以 `byte[]` 形式保存，一般设计成定长。建议越短越好，不要超过 16 个字节，原因如下
   * 数据的持久化文件 HFile 中时按照 Key-Value 存储的，如果 RowKey 过长，例如超过 100byte，那么 1000W 行的记录，仅 RowKey 就需占用近 1GB 的空间。这样会极大影响 HFile 的存储效率。
   * MemStore 会缓存部分数据到内存中，若 RowKey 字段过长，内存的有效利用率就会降低，就不能缓存更多的数据，从而降低检索效率。
   * 目前操作系统都是 64 位系统，内存 8 字节对齐，控制在 16 字节，8 字节的整数倍利用了操作系统的最佳特性。
2. 唯一原则
   *  必须在设计上保证 RowKey 的唯一性。
   *  由于在 HBase 中数据存储是 Key-Value 形式，若向 HBase 中同一张表插入相同 RowKey 的数据，则原先存在的数据会被新的数据覆盖。
3. 排序原则
   * **HBase 的 RowKey 是按照 ASCII 有序排序的，因此我们在设计 RowKey 的时候要充分利用这点。**
4. 散列原则
   * **设计的 RowKey 应均匀的分布在各个 HBase 节点上。**



#### 避免数据热点的方法

在对 HBase 的读写过程中，如何避免热点现象呢？主要有以下几种方法

1. Reversing

如果经初步设计出的 RowKey 在数据分布上不均匀，但 RowKey 尾部的数据却呈现出了良好的随机性，此时，可以考虑将 RowKey 的信息翻转，或者直接将尾部的 bytes 提前到 RowKey 的开头。Reversing 可以有效的使 RowKey 随机分布，但是牺牲了 RowKey 的有序性。

Reversing 的缺点是利于 Get 操作，但不利于 Scan 操作，因为数据在原RowKey 上的自然顺序已经被打乱。

2. Salting

Salting（加盐）的原理是在原 RowKey 的前面添加固定长度的随机数，也就是给 RowKey 分配一个随机前缀，使它和之间的 RowKey 的开头不同。随机数能保障数据在所有 Regions 间的负载均衡。

缺点是因为添加的是随机数，基于原 RowKey 查询时无法知道随机数是什么，那样在查询的时候就需要去各个可能的 Regions 中查找，Salting 对于读取是利空的。并且加盐这种方式增加了读写时的吞吐量。

3. Hashing

基于 RowKey 的完整或部分数据进行 Hash，而后将 Hashing 后的值完整替换或部分替换原 RowKey 的前缀部分。这里说的 hash 包含 MD5、sha1、sha256 或 sha512 等算法。

该方案的缺点与 Reversing 类似，Hashing 也不利于 Scan，因为打乱了原 RowKey 的自然顺序。




### HBase读写性能优化


* [HBase读写性能优化 | 掘金](https://juejin.cn/post/6844903873795063822)



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/hbase-opt-1.png)



### HBase读的过程

* [HBase读写流程之读流程](https://www.modb.pro/db/78346)


@TODO 此部分笔记待整理


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/hbase-read-1.png)

相较 HBase 的写流程，HBase 的读流程更加复杂。需要对数据进行删选过滤。先来整体看下读数据流程吧。可分为 4 个阶段
1. Client 与 Server 交互阶段
2. Server 端构建 Scan 框架体系阶段
3. 过滤 HFile 阶段
4. 通过 HFile 读取 KeyValue 阶段


第 3 阶段「过滤 HFile 阶段」的详细步骤如下图所示。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/hbase-read-2.png)






### HBase写的过程

* [HBase读写流程之写流程](https://www.modb.pro/db/74396)

@TODO 此部分笔记待整理

HBase 适合于写多读少的应用场景，HBase 服务端不提供 update，delete 接口，对数据的更新，删除操作在服务端也会被认为是写入操作，只不过更新操作会写入一个最新版本的数据，删除操作会写入一条标记为 deleted 的 KV 数据。HBase数据写入流程随着版本迭代优化，但是总体流程变化不大。

HBase 写入流程整体可以分为 3 个阶段，流程如下图所示。

1. 客户端处理阶段
2. Region 写入阶段
   * 第 1 步，追加写入 HLog
   * 第 2步，随机写入 MemStore
3. MemStore Flush 阶段

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/hbase-write-step-1.png)




### HBase更适合写多读少的场景

* [HBase 适合读多写少还是写多读少 | 知乎](https://www.zhihu.com/question/457507714/answer/1868808289)


HBase 更适合「写多读少」的场景。在写入这一块，每个 table 在合理预分区的情况，可以将负载均匀分配到不同的 region server，而且可以 LSM 结构可以有效避免随机 IO ，即使开启 wal 也是顺序写入，效率、吞吐量还是不错的。

但这种结构也有一个问题，就是写放大，也就是常说的 compation，这个问题要分析负载分布来调参，有的公司甚至还做了一些扩展以减小写放大的影响。

而读取默认 HBase 是没有二级索引的，唯一的索引就是 rowkey，所以很多公司针对 rowkey 设计做文章，还有公司会扩展其他高效率查询的引擎作为二级索引，例如 ES，再或者通过 phoneix。如果没有二级索引的支持，HBase 本身对复杂一点的检索效率是很有问题的。

所以，只说 HBase，写多读少更准确一些。


