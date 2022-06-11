

# Spark Notes-01-Spark基础入门


[TOC]

## 更新
* 2020/09/28，撰写




## Scala 语法

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





## 窗口函数

### 参考资料
* [Spark 窗口函数 I](https://xie.infoq.cn/article/c393dbf033e95b7d020cf1590)
* [Spark SQL中的窗口函数](http://yangcongchufang.com/Introducing-Window-Functions-in-Spark-SQL.html)
* [Spark-窗口函数实现原理及各种写法](https://www.jianshu.com/p/409312265fa4)
* [Spark Window 入门介绍 - 图解](https://lotabout.me/2019/Spark-Window-Function-Introduction/)

### 简介

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





### 分区条件+窗口函数

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



### 窗口函数分类

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
