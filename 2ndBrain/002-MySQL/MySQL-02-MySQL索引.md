# MySQL-02-MySQL索引

[TOC]

## 更新
* 2022/04/23，撰写
* 2022/04/25，笔记整理
* 2022/05/14，添加*索引下推*
* 2022/05/15，添加*索引合并*
  
## 参考资料
* 书籍 [01-《MySQL技术大全》开发优化与运维实战](https://cread.jd.com/read/startRead.action?bookId=30691430&readType=3) 第14章-MySQL索引，第21章-MySQL索引优化
* [深入理解 MySQL 索引 | InfoQ](https://www.infoq.cn/article/ojkwyykjoyc2ygb0sj2c)
* [MySQL 的覆盖索引与回表 | 知乎](https://zhuanlan.zhihu.com/p/107125866)
* [MySQL索引原理及慢查询优化 | 美团技术](https://tech.meituan.com/2014/06/30/mysql-index.html)


## 什么是索引

> 索引是存储引擎快速找到记录的一种数据结构，例如 `MyISAM` 引擎和 `Innodb` 引擎都使用 `B+ Tree` 作为索引结构，但二者在底层实现还是有些不同的。 ——《高性能MySQL》
> * Innodb 索引和数据存储在同一个文件
> * MyISAM 索引文件和数据文件是分离的


索引是一种能够改善表操作速度的数据结构。 索引可以通过一个或多个列来创建，它可以提高随机查询的速度，并在检索记录时实现高效排序。

**索引一经创建不能修改，如果要修改索引，只能删除重建。**





### 索引的优点
* 大大减少了服务器需要扫描的数据量（避免全表扫描）
* 帮助服务器避免排序带来的性能开销（**索引有2个作用：排序和查找。索引不仅可以用于筛选还可用于排序**）
* 将随机IO变成顺序IO

### 索引的缺点

* 虽然索引大大提高了查询速度，同时却会降低更新表的速度，如对表进行 `INSERT`、`UPDATE` 和 `DELETE`，因为更新表时，MySQL 不仅要保存数据，还要保存一下索引文件。
* 建立索引会占用磁盘空间的索引文件。一般情况这个问题不太严重，但如果你在一个大表上创建了多种组合索引，索引文件的会膨胀很快。
* 索引只是提高效率的一个因素，如果你的 MySQL 有大数据量的表，就需要花时间研究建立最优秀的索引或优化查询语句。



## 索引基础


### 一条查询语句是如何执行的
* ref 1-[一条SQL查询语句是如何执行的](https://learn.lianglianglee.com/%E4%B8%93%E6%A0%8F/MySQL%E5%AE%9E%E6%88%9845%E8%AE%B2/01%20%20%E5%9F%BA%E7%A1%80%E6%9E%B6%E6%9E%84%EF%BC%9A%E4%B8%80%E6%9D%A1SQL%E6%9F%A5%E8%AF%A2%E8%AF%AD%E5%8F%A5%E6%98%AF%E5%A6%82%E4%BD%95%E6%89%A7%E8%A1%8C%E7%9A%84%EF%BC%9F.md)
* ref 2-[深入理解 MySQL 索引 | InfoQ](https://www.infoq.cn/article/ojkwyykjoyc2ygb0sj2c)


首先来看一下在 MySQL 数据库中，一条查询语句是如何执行的，索引出现在哪个环节，起到了什么作用。


![mysql-sql-process-1](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-sql-process-1.png)


1. 应用程序通过连接器跟服务端建立连接
2. 查询缓存，若有缓存则直接返回查询结果
3. 若无缓存，则进行查询优化处理并生成执行计划
（1）分析器进行词法分析和语法分析
（2）优化器进行优化，如决定使用哪个索引或者在多个表相关联的时候决定表的连接顺序等，并生成执行计划
（3）执行器去执行计划，操作存储引擎并返回结果
4. 将查询结果返回客户端


从上图可以看到，索引出现在优化器优化SQL的步骤中。



#### 1.应用程序通过连接器跟服务端建立连接

当执行 SQL 语句时，应用程序会连接到相应的数据库服务器，然后服务器对 SQL 进行处理。

#### 2.查询缓存

接着数据库服务器会先去查询是否有该 SQL 语句的缓存，`key` 是查询的语句，`value` 是查询的结果。如果你的查询能够直接命中，就会直接从缓存中拿出 `value` 来返回客户端。

需要注意的是，此时查询语句不会被解析，不会生成执行计划，不会被执行。


#### 3.查询优化处理并生成执行计划

如果没有命中缓存，则开始第3步
* 解析 SQL：生成解析树，验证关键字如 `select`，`where`，`left join` 等是否正确。
* 预处理：进一步检查解析树是否合法，如检查数据表和列是否存在，验证用户权限等。
* 优化SQL：决定使用哪个索引或者在多个表相关联的时候决定表的连接顺序。
* 生成执行计划：接上步，将 SQL 语句转成执行计划。


#### 4.将查询结果返回客户端

最后，数据库服务器将查询结果返回给客户端。如果查询可以缓存，MySQL 也会将结果放到查询缓存中。




### 索引SQL语法

* 创建数据表时创建索引（当没有为索引指定名称时会使用字段的名称来命名索引）

```sql
CREATE TABLE table_name
column_name1 data_type1
[PRIMIARY | UNIQUE | FULLTEXT | SPATIAL] [INDEX | KEY]
[index_name] (column_name [length])
[ASC | DESC]
```

* 为已有数据表添加索引

```sql
-- ALTER TABLE 语法
ALTER TABLE table_name
ADD
[PRIMIARY | UNIQUE | FULLTEXT | SPATIAL] [INDEX | KEY]
[index_name] (column_name [length])
[ASC | DESC]

-- CREATE INDEX 语法
CREATE 
[UNIQUE | FULLTEXT | SPATIAL] [INDEX | KEY]
INDEX index_name
ON table_bame
(column_name [length])
[ASC | DESC]
```

* 删除索引

```sql
-- ALTER TABLE 语法
ALTER TABLE table_name
DROP INDEX index_name

-- DROP INDEX 语法
DROP INDEX index_name
ON table_name
```


* 查看索引（使用 `\G` 来格式化输出信息）

```sql
mysql> SHOW INDEX FROM table_name; \G
```


### MySQL 8.x中实现的索引新特性

> 关于本章节内容，详情参考书籍 [01-《MySQL技术大全》开发优化与运维实战](https://cread.jd.com/read/startRead.action?bookId=30691430&readType=3) 第14章-MySQL索引


MySQL 8.x版本中关于索引实现了3大特性，即
1. 隐藏索引
2. 降序索引
3. 函数索引


#### 隐藏索引

MySQL 8.x开始支持隐藏索引，隐藏索引不会被优化器使用，但是仍然需要维护。隐藏索引通常会软删除和灰度发布的场景中使用。


#### 降序索引

从MySQL 4版本开始就已经支持降序索引的语法了，但是直到MySQL 8.x版本才开始真正支持降序索引。另外，在MySQL 8.x版本中，不再对GROUP BY语句进行隐式排序。

#### 函数索引
从MySQL 8.0.13版本开始支持在索引中使用函数或者表达式的值，也就是在索引中可以包含函数或者表达式。


### 使用索引提示

MySQL 中的查询优化器能够根据索引提示使用或忽略相应的索引，这有助于更好地优化数据库中的索引。常见的索引提示主要包括
1. `USE INDEX`
2. `IGNORE INDEX`
3. `FORCE INDEX`


```sql
SELECT * FROM table_name 
[USE | IGNORE | FORCE]  INDEX (index1) 
WHERE ...
```


### 使用生成列为JSON建立索引

MySQL 不支持在 JSON 列上直接建立索引。此时可以通过创建生成列，并在生成列上创建索引来提取 JSON 列的数据。







## 索引的分类


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/mysql-index-all-kinds-1.png)
### 从存储结构上划分

* `BTree` 索引（`B+tree`，`B-tree`)
* 哈希索引
* `FULLINDEX` 全文索引
* `RTree`


索引是存储引擎快速找到记录的一种数据结构，例如 `MyISAM` 引擎和 `Innodb` 引擎都使用 `B+ Tree` 作为索引结构，但二者在底层实现还是有些不同的。
* **Innodb 索引和数据存储在同一个文件**
* **MyISAM 索引文件和数据文件是分离的**



### 从应用层次上来划分


> 外键索引
> InnoDB 是 MySQL 目前唯一支持外键索引的内置引擎。
>
> 外键成本：外键每次修改数据时都要求在另一张表多执行一次查找，当然外键在相关数据删除和更新上比在应用中维护更高效。



从应用层次角度对索引进行分类

1. 普通索引（`INDEX`）：最基本的索引
2. 唯一索引（`UNIQUE INDEX`）：索引列的值必须唯一，但允许有空值
3. 主键索引 (`PRIMARY KEY`)：是一种特殊的唯一索引，不允许有空值
4. 单列索引
5. 组合索引（联合索引）：联合索引最多只能包含16列
6. 全文索引 (`FULLTEXT INDEX`)
7. 空间索引（`SPATIAL INDEX`）


> **<font color='red'>主键不允许有空值，唯一索引允许有空值。</font>**


下面对上述索引进行必要的说明。
* 创建唯一索引（`UNIQUE INDEX`）的列值必须唯一，但是允许值为空。如果创建的唯一索引中包含多个字段，也就是复合索引，则索引中包含的多个字段的值的组合必须唯一。
* 主键索引是特殊类型的唯一索引，与唯一索引不同的是，主键索引不仅具有唯一性，而且不能为空，而唯一索引中的列的数据可能为空。
* 创建全文索引时，对列的数据类型有一定的限制，只能为定义为 `CHAR`，`VARCHAR` 和 `TEXT` 数据类型的列创建全文索引。全文索引不支持对列的局部进行索引。
* MySQL 支持在 `GEOMETRY` 数据类型的字段上创建空间索引。





### 从表记录的排列顺序和索引的排列顺序是否一致来划分


1. 聚簇索引（聚集索引，一级索引）：表记录的排列顺序和索引的排列顺序一致
2. 非聚簇索引（非聚集索引，二级索引，普通索引）：表记录的排列顺序和索引的排列顺序不一致


**聚集索引在叶子节点存储的是表中的数据，非聚集索引在叶子节点存储的是主键和索引列。**

| 比较项  |        聚集索引    |       非聚集索引   |
|--------|-------------------|------------------|
|  别名   |  聚簇索引，一级索引  | 非聚集索引，二级索引，普通索引 |
| 表记录的排列顺序和索引的排列顺序是否一致 | 一致 | 不一致 |
|叶子节点的存储内容|    表中的数据 |    主键和索引列     |







#### 聚簇索引

聚簇索引也被称为一级索引或聚集索引。

* 优点

聚集索引表记录的排列顺序和索引的排列顺序一致，只要找到第一个索引值记录，其余的连续性的记录在物理表中也会连续存放，一起就可以查询到，所以查询效率较高。

* 缺点

新增比较慢，因为为了保证表中记录的物理顺序和索引顺序一致，在记录插入的时候，会对数据页重新排序。


对于InnoDB存储引擎来说
* 如果表设置了主键，则主键就是聚簇索引
* 如果表没有主键，则会默认第一个 `NOT NULL`，且唯一（`UNIQUE`）的列作为聚簇索引
* 以上都没有，则会默认创建一个隐藏的 `row_id` 作为聚簇索引
* 由此可见，`InnoDB` 必须要有至少一个聚簇索引


聚集索引在叶子节点存储的是行记录。

#### 非聚簇索引

非聚簇索引，也叫做非聚集索引或二级索引或普通索引。除聚簇索引外的索引，即非聚簇索引。

非聚集索引在叶子节点存储的内容是
* `InnoDB` 存储引擎中，非聚集索引在叶子节点存储的是聚集索引的值
* `MyISAM` 存储引擎中，非聚集索引在叶子节点存储的是记录指针


**索引的逻辑顺序与磁盘上行的物理存储顺序不同，非聚集索引在叶子节点存储的是主键和索引列。**

**当我们使用非聚集索引查询数据时，需要拿到叶子上的主键再去表中查到想要查找的数据，需要扫描两次索引 B+树，这个过程被称为「回表」。**



### 主键和索引的区别

1. 主键一定会创建一个唯一索引，但是有唯一索引的列不一定是主键；
2. **主键不允许为空值，唯一索引列允许空值；**
3. 一个表只能有一个主键，但是可以有多个唯一索引；
4. 主键可以被其他表引用为外键，唯一索引列不可以；
5. 主键是一种约束，而唯一索引是一种索引，是表的冗余数据结构，两者有本质区别。



## 索引设计原则

索引设计，需要遵循如下原则

1. 适合索引的列是出现在 `where` 子句中的列或者 `join` 连接子句中指定的列。
2. 基数较小的类，区分度较小，索引效果较差，没有必要在此列建立索引，如性别列。
3. 使用短索引，如果对长字符串列进行索引，应该指定一个前缀长度，这样能够节省大量索引空间。
4. 不要过度索引。索引需要额外的磁盘空间，并降低写操作的性能。在修改表内容的时候，索引会进行更新甚至重构，索引列越多，这个时间就会越长。所以只保持需要的索引有利于查询即可。
5. 参考 [MySQL学习之索引 | CSDN](https://blog.csdn.net/mysteryhaohao/article/details/51719871)，给出何时使用聚簇索引或非聚簇索引，见下表


| 使用动作描述	| 使用聚簇索引	| 使用非聚簇索引 |
|---------------|---------------|----------------|
| 列经常被分组排序	|   ✅      | 	 ✅         |    
| 返回某范围内的数据 |   ✅     | 	 ❎          |    
| 一个或极少不同的值 |   ❎     | 	 ❎          |    
| 小数目不同的值    |   ✅     | 	 ❎          |    
| 大数目不同的值   |   ❎       | 	 ✅     |    
| 频繁更新的列   |    ❎       | 	 ✅        |    
| 外键列     |        ✅       | 	  ✅        |    
| 主键列        |      ✅        | 	 ✅         |    
| 频繁修改索引列  |   ❎       | 	 ✅           |  



下面对上述设计原则，进行必要的补充说明。





### 最左匹配原则
* ref 1-[联合索引和最左匹配 | CSDN](https://blog.csdn.net/u014453898/article/details/113748259)
* ref 2-[最左匹配 | 官方文档翻译](https://juejin.cn/post/6844903966690508814)

联合索引遵循最左匹配原则，当创建 `(a,b,c,d)` 联合索引时，相当于创建了 

1. `(a)` 单列索引
2. `(a,b)` 联合索引
3. `(a,b,c)` 联合索引
4. `(a,b,c,d)` 联合索引


#### 范围查询导致索引停止匹配

**当遇到范围查询（`>`、`<`、`between`、`like`）就会停止匹配，`IN` 查询可视为等值查询，不属于范围查询。** 例如筛选条件为 `a = 1 and b = 2 and c > 3 and d = 4` 时，a，b，c 这三个字段可以使用索引，字段 d 无法使用索引，因为遇到了范围查询。

```sql
-- c > 3 为范围查询，导致 d 无法使用索引
select * from db_name
where 
a = 1 and b = 2 and c > 3 and d = 4
```

#### 优化器对查询条件顺序的调整


在本文「一条查询语句是如何执行的」章节中提到了 **MySQL 的优化器**。例如筛选条件为 `b = 2 and a = 1` 时，优化器会自动调整 a 和 b 的顺序，等效执行 `a = 1 and b = 2`，字段 a 和 b 都可以使用索引。但是若筛选条件为 `b = 2`，则违背了最左匹配原则，无法使用索引。


```sql
-- 优化器优化后，字段a和b都可以使用索引
select * from db_name
where 
b = 2 and a = 1  -- 优化器优化为 a=1 and b=2

-- 违背了最左匹配原则 无法使用索引
select * from db_name
where 
b = 2
```


#### 最左匹配相关的索引设计问答场景

最后，给出几个和最左匹配相关的索引设计问答场景，加深理解。


* 问答1：针对 `select *  from table where a = 1 and b = 2 and c = 3` 如何设计索引？
  

创建联合索引 `(a,b,c)` 或 `(c,b,a)` 或 `(b,a,c)` 都可以，因为 MySQL 的优化器会自动调整 `a=1 and b=2 and c=3` 的顺序，来满足最左匹配原则。在创建联合索引时，需要将区分度高的字段靠前。


* 问答2：针对 `select * from table where a>1 and b=2` 如何设计索引？
  
创建联合索引 `(b,a)`。MySQL优化器会将上述语句调整为 `b=2 and a>1`，从而使字段 a 和 b 都可以使用索引。若创建索引 `(a,b)`，由于 `a>1` 为范围查询，故此时只有字段 a 可以使用索引。


* 问答3：针对 `select * from table where a>1 and b=2 and c>3` 如何设计索引？
  
创建联合索引 `(b,a)` 或 `(b,c)` 均可。

* 问答4：针对 `select * from table where a=1 order by b` 如何设计索引？
  
创建联合索引 `(a,b)`，当 `a=1` 的时候，b 相对有序，可以避免再次排序。**索引不仅可以用于筛选还可用于排序。**

* 问答5：针对 `select * from table where a in (1,2,3) and b>1` 如何设计索引？

`IN` 在这里可以视为等值引用，不会中止索引匹配，所以可创建联合索引 `(a，b)`。


### 回表查询

* ref 1-[MySQL 的覆盖索引与回表 | 知乎](https://zhuanlan.zhihu.com/p/107125866)



![mysql-back-to-table-1](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-back-to-table-1.png)



对于非聚集索引，索引的逻辑顺序与磁盘上行的物理存储顺序不同，非聚集索引在叶子节点存储的是主键和索引列。当我们使用非聚集索引查询数据时，需要拿到叶子上的主键再去表中查到想要查找的数据，需要扫描两次索引 B+树，这个过程被称为「回表」。


如下数据表 `user`，聚簇索引是主键 `id` 字段，非聚簇索引是 `age` 字段。


```sql
-- InnoDB引擎
create table user(
    id int(10) auto_increment,
    name varchar(30),
    age tinyint(4),
    primary key (id),
    index idx_age (age)
)engine=innodb charset=utf8mb4;

-- 数据表中插入如下数据
+----+--------+------+
| id | name  | age |
+----+--------+------+
| 1 | 张三  |  30 |
| 2 | 李四  |  20 |
| 3 | 王五  |  40 |
| 4 | 刘八  |  10 |
+----+--------+------+
```

执行查询 `select * from user where age=30` 时
* 第1步，先通过普通索引 `age=30` 定位到主键值 `id=1`
* 第2步，再通过聚集索引 `id=1` 定位到行记录数据

可以看到，上述一次查询中，扫描了两次索引 B+树，这个过程被称为「回表」。

### 索引覆盖

> 当一个索引包含（或者说是覆盖）需要查询的所有字段的值时，我们称之为「覆盖索引」。

当索引可以覆盖到查询所需的全部数据，只需要在一棵索引树上就能获取 SQL 所需的所有列数据，此时无需进行回表查询，查询速度较快。


#### 如何实现覆盖索引

常见的方法是将被查询的字段，建立到联合索引里中。

此处继续使用「回表查询」章节中的数据表 `user` 为例进行说明。

* 执行查询 `select id,age from user where age = 10`

因为 `age` 是普通索引，其叶子节点存储的是主键（`id`）和索引列（`age`），通过一次扫描 B+ 树即可查询到相应的结果，这样就实现了覆盖索引，查询速度较快。其 `expalin` 信息如下，`Extra=Using index` 表示使用覆盖索引扫描，不需要回表。

```sql
mysql> explain select id,age from user where age = 10; 
+----+-------------+-------+------------+------+---------------+---------+---------+-------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key     | key_len | ref   | rows | filtered | Extra       |
+----+-------------+-------+------------+------+---------------+---------+---------+-------+------+----------+-------------+
|  1 | SIMPLE      | user  | NULL       | ref  | idx_age       | idx_age | 2       | const |    1 |   100.00 | Using index |
+----+-------------+-------+------------+------+---------------+---------+---------+-------+------+----------+-------------+
1 row in set, 1 warning (0.00 sec)

```

* 执行查询 `select id,age,name from user where age = 10`

因为 `age` 是普通索引，其叶子节点存储的是主键（`id`）和索引列（`age`），并没有存储 `name` 的信息，所以通过一次扫描 B+ 树无法获得查询结果，还需再根据主键 `id=4` 去查询 `name` 信息。该过程发生了回表，无法实现索引覆盖。

```sql
mysql> explain select id,age,name from user where age = 10;
+----+-------------+-------+------------+------+---------------+---------+---------+-------+------+----------+-------+
| id | select_type | table | partitions | type | possible_keys | key     | key_len | ref   | rows | filtered | Extra |
+----+-------------+-------+------------+------+---------------+---------+---------+-------+------+----------+-------+
|  1 | SIMPLE      | user  | NULL       | ref  | idx_age       | idx_age | 2       | const |    1 |   100.00 | NULL  |
+----+-------------+-------+------------+------+---------------+---------+---------+-------+------+----------+-------+
```

* 为了实现索引覆盖，需要建组合索引 `idx_age_name(age,name)`


```sql
alter table user drop index idx_age;
alter table user add index idx_age_name (age,name);
```

* 再次查询 `select id,age,name from user where age = 10`


联合索引的 B+ 索引树的叶子节点，存储的是主键（`id`）和索引列（`age` 和 `name`），包含了所有的查询结果信息，不需进行回表，实现了索引覆盖。

```sql
mysql> explain select id,age,name from user where age = 10;
+----+-------------+-------+------------+------+---------------+--------------+---------+-------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key          | key_len | ref   | rows | filtered | Extra       |
+----+-------------+-------+------------+------+---------------+--------------+---------+-------+------+----------+-------------+
|  1 | SIMPLE      | user  | NULL       | ref  | idx_age_name  | idx_age_name | 2       | const |    1 |   100.00 | Using index |
+----+-------------+-------+------------+------+---------------+--------------+---------+-------+------+----------+-------------+
1 row in set, 1 warning (0.00 sec)
```



#### 哪些场景适合使用索引覆盖来优化SQL

1. 全表 `count` 查询优化：如 `select count(age) from user;`，此时可以考虑为 `age` 字段添加索引。
2. 列查询回表优化：如 `select id,age,name from user where age=10`，此时可以创建联合索引 `(age,name)`。


### 使用短索引

尽量使用短索引，如果对长字符串列进行索引，应该指定一个前缀长度，这样会加速索引查询速度，还会减少索引文件的大小，节省大量索引空间。同时也可以提高 `INSERT` 的更新速度。


```sql
ALTER TABLE mytable 
ADD INDEX name_city_age (usernname(10),city,age);
```

如上所示，`usernname` 长度为 16，在创建索引是为其指定前缀长度 10。这是因为一般情况下名字的长度不会超过 10，这样会加速索引查询速度，还会减少索引文件的大小。


> 创建索引时，若字段是 `BLOB` 和 `TEXT` 类型，必须指定 `length`。



### 尽量选择区分度高的列作为索引

区分度的公式是 `count(distinct col)/count(*)`，表示字段不重复的比例。

比例越大我们扫描的记录数越少，唯一键的区分度是 1，而一些状态、性别字段可能在大数据面前区分度就是 0。一般需要 `join` 的字段都要求区分度 0.1 以上，即平均 1 条扫描 10 条记录。


### 创建联合索引时将区分度高的字段靠前

创建联合索引时，将区分度高的字段靠前，可以提高检索效率。

例如，对 ID，性别，状态三个字段创建联合索引，性别和状态区分度较低，ID区分度较高，所以创建联合索引时，需要将 ID 靠前。


```sql
ALTER TABLE table_name
ADD INDEX
id_sex_status_index (id,sex,status)   -- good
sex_id_status_index (sex,id,status)   -- bad
```



### ORDER BY和GROUP BY字段使用索引


**索引有2个作用：排序和查找。索引不仅可以用于筛选还可用于排序。**

`ORDER BY` 和 `GROUP BY` 对应的字段，也可以通过添加索引的方式提升排序速度。在联合索引使用场景中，`ORDER BY` 和 `GROUP BY` 对应的字段同样遵循最左匹配原则。


例如，创建联合索引 `(name,age,pos,phone)`，下述查询语句的索引使用情况如下。


```sql
-- age和pos字段可以正常使用索引
select * from user where name = 'zhangsan' and age = 20 
order by age,pos;

-- 违反最左匹配原则 pos字段无法使用索引
select name,age from user where name = 'zhangsan' 
order by pos;
```

在使用 `GROUP BY` 分组前，MySQL会默认对分组字段进行排序。在 MySQL 8.x 版本中，不再对 GROUP BY 语句进行隐式排序。


```sql
-- 违反最左匹配原则 pos和age字段无法使用索引
select name,age from user where name = 'zhangsan' 
group by pos,age;

-- 含非索引字段
select * from user where name = 'zhangsan' and age = 20 
group by created_time,age;
```



## 索引失效场景

* ref 1-[一张图搞懂MySQL的索引失效 | Segmentfault](https://segmentfault.com/a/1190000021464570)

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/database-index-no-use-case-1.png)




索引失效的场景包括
1. 以通配符开始的 `LIKE` 语句
2. 数据类型转换，如对字符串筛选时不加单引号会导致索引失效
3. 联合索引违反最左匹配原则
4. OR 语句连接索引失效
5. 在索引列上进行任何操作都将导致索引失效，如计算索引列，使用函数，自动或手动的类型转换
6. 范围查询（`>`、`<`、`between`、`like`）导致索引匹配停止，右侧的列无法使用索引。`IN` 查询可视为等值查询，不属于范围查询
7. 使用不等于 `<>` 或 `!=` 或 `NOT IN` 操作符匹配查询条件。`IN` 查询可视为等值查询，不属于不等于操作
8. 匹配 `NOT NULL` 值 （注意，使用 `IS NULL` 可以使用索引）
9.  **索引耗时评估**





下面对索引失效的场景，进行必要的补充说明。



### 以通配符开始的LIKE语句

LIKE 中以通配符开头 `%`，会导致索引失效。

```sql
-- 索引失效
explain select * from user where name like "%zhangsan";
```

但是以 LIKE 中以通配符结尾 `%`，索引依然有效。

```sql
-- 索引生效
explain select * from user where name like "zhangsan%";
```



### 匹配IS NOT NULL值 

在 MySQL 中使用 `IS NULL` 判断某个字段是否为 `NULL` 时，会使用该字段的索引。但是如果使用 `IS NOT NULL` 来验证某个字段不为 `NULL` 时，会进行全表扫描操作，索引失效。



### 索引耗时评估


> **不是命中索引了就会走索引查询。**


**在某些场景下，如果MySQL评估使用索引比使用全表扫描查询数据性能更低，则不会使用索引来查询数据，而会进行全表扫描。**


这个评估的过程，就是「基于成本的优化」，详情参考本文「Notes-05-MySQL连接和基于成本的优化」章节。








## 索引底层原理

本章节将对索引的底层原理进行介绍，首先介绍下磁盘I/O与预读，然后对B树和B+树的数据结构进行介绍。

### 磁盘I/O与预读

#### 一次磁盘IO的耗时

磁盘读取数据，靠的是机械运动，每次读取数据花费的时间可以分成3个部分
1. 寻道时间
2. 旋转延迟
3. 传输时间

寻道时间指的是磁臂移动到指定磁盘所需要的时间，主流的磁盘一般在 5ms 以下。

旋转延迟指的是我们经常说的磁盘转速，比如一个磁盘 7200 转，表示的就是每分钟磁盘能转 7200 次，转换成秒也就是 120 次每秒，旋转延迟就是 1/120/2 = 4.17ms。

传输时间指的是从磁盘读取出数据或将数据写入磁盘的时间，一般都在零点几毫秒，相对于前两个，可以忽略不计。


那么访问一次磁盘的时间，即一次磁盘I/O的时间约等于 5+4.17 = 9.17ms。

9ms 左右，听起来还是不错的哈，但要知道一台 500-MIPS 的机器每秒可以执行 5 亿条指令，因为指令依靠的是电的性质。换句话说，执行一次I/O的时间可以执行 40 万条指令，数据库动辄百万级甚至千万级的数据，每次 9ms 的时间，显然是一个灾难。下图是计算机硬件延迟时间的对比图。


![disk-io-time-1.png](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/disk-io-time-1.png)



#### 局部预读性原理

考虑到磁盘I/O是非常高昂代价的操作，计算机系统做了一些优化。当一次I/O时，不仅会把当前磁盘地址的数据读取到内存中，而且会把相邻的数据也读取到内存缓冲区中，因为「局部预读性原理」告诉我们，当计算机访问一个地址的数据的时候，与其相邻的数据也会很快访问到。**每一次I/O读取的数据我们称之为「一页（Page）」**。

具体一页的数据有多大，这个跟操作系统有关，一般为4K或8K，也就是我们读取一页数据的时候，实际上才发生了一次I/O，这个理论对于索引的数据结构设计很有帮助。


**除此之外，我们还需要知道数据库对数据的读取并不是以行为单位进行的，无论是读取一行还是多行，都会将该行或者多行所在的页全部加载进来，然后再读取对应的数据记录；也就是说，读取所耗费的时间与行数无关，只与页数有关。**

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/database-bufferpool-1.png)

#### 缓冲池和内存

一个数据库必须保证其中存储的所有数据都是可以随时读写的，同时因为 MySQL 中所有的数据其实都是以文件的形式存储在磁盘上的，而从磁盘上随机访问对应的数据非常耗时，所以**数据库程序和操作系统提供了缓冲池和内存以提高数据的访问速度。**

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/database-bufferpool-2.png)


**索引或行记录是否在缓存池中极大的影响了访问索引或者数据的成本。**

### MySQL的基本存储结构是页

* ref 1-[MySQL的神器-索引 | 掘金](https://juejin.cn/post/6844903645125820424)

MySQL 的基本存储结构是「页」，行记录是存储在页中的。


![mysql-page-structure-1](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-page-structure-1.png)


![mysql-insert-data-step-1](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-insert-data-step-1.png)

### 哈希索引

哈希索引就是采用一定的哈希算法，只需一次哈希算法即可立刻定位到相应的位置，速度非常快，`value = get(key)`，时间复杂度是 `O(1)`。本质上就是把键值换算成新的哈希值，根据这个哈希值来定位。



哈希索引的局限性
1. 哈希索引没办法利用索引完成排序
2. 不支持最左匹配原则
3. 不能进行多字段查询
4. 在有大量重复键值的情况下，哈希索引的效率也是极低的（出现哈希碰撞问题）
5. 不支持范围查询

### B树

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-b-tree-node-1.png)

B 树的结构图如上，B树具有如下特点
* 所有叶子节点在同一层，即所有叶子节点的高度一致
* **关键字（或数据）分布在整棵树的所有节点**
* 任何一个关键字出现且只出现在一个节点中
* **搜索有可能在非叶子节点结束**




### B+树

MySQL 中的 InnoDB 引擎使用 `B+ Tree` 结构来存储索引，可以尽量减少数据查询时的磁盘 IO 次数。


B+ Tree 结构如下图，可以将结点划分为 3 类
1. 根节点（`root`）
2. 枝，即非叶子节点（`branch`）
3. 叶子节点（`leaf`）

**B+ Tree 中根节点和非叶子节点不存储数据，只存储指针地址。数据全部存储在叶子节点中，同时叶子节点之间用双向链表链接。** 从下图可以看到，每个叶子节点由 3 部分组成
1. 前驱指针 `p_prev`
2. 数据 `data`
3. 后继指针 `p_next`


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-b%2Btree-node-1.png)


需要注意的是
* **相比于 B 树，B+树的叶子节点之间用双向链表链接。**
* 叶子节点的数据 `data` 是有序的，默认是升序 ASC，此时分布在 B+ Tree 右边的键值总是大于左边的。
* **同时从根节点到每个叶子节点的距离是相等的，也就是访问任何一个叶子节点需要的 IO 是一样的，查询的性能更加的稳定。**
* **B+树中根节点和非叶子节点不存储数据，只存储指针地址（索引）。**

> B+树中根节点和非叶子节点不存储数据，只存储指针地址（索引），这样做有什么好处呢？
> 1. **中间节点不保存数据，那么就可以保存更多的索引，减少数据库磁盘 IO 的次数。**
> 2. 中间节点不保存数据，所以每一次的查找都会命中到叶子节点，而叶子节点是处在同一层的，因此访问任何一个叶子节点需要的 IO 是一样的，查询的性能更加的稳定。
> 3. **所有的叶子节点按顺序链接成了链表，因此可以方便的话进行范围查询。**




### B+树高频面试题

* [MySQL六十六问，两万字+五十图详解](https://mp.weixin.qq.com/s/zSTyZ-8CFalwAYSB0PN6wA)

#### 为什么不用普通二叉树

普通二叉树存在退化的情况，如果它退化成链表，相当于全表扫描。平衡二叉树相比于二叉查找树来说，查找效率更稳定，总体的查找速度也更快。


#### 为什么不用平衡二叉树呢

读取数据的时候，是从磁盘读到内存。如果树这种数据结构作为索引，那每查找一次数据就需要从磁盘中读取一个节点，也就是一个磁盘块，但是平衡二叉树可是每个节点只存储一个键值和数据的。如果是 B+ 树，可以存储更多的节点数据，树的高度也会降低，因此读取磁盘的次数就降下来啦，查询效率就快。


#### 为什么不用红黑树

**B+树是多路树，红黑树是二叉树。**

红黑树也是一种平衡二叉树，原因大体同「为什么不用平衡二叉树呢」。

使用红黑树的话，一个节点只有两个子节点，树的高度会比较高，增加了 IO 查询成本。


#### 为什么不用B树

B+ 树相比较 B 树，有这些优势
1. B+ 树是 B Tree 的变种，B Tree 能解决的问题，它都能解决。
2. B 树的关键字（或数据）分布在整棵树的所有节点，任何一个关键字出现且只出现在一个节点中。搜索有可能在非叶子节点结束。
3. 相比于 B 树，B+ 树的叶子节点之间用双向链表链接，便于范围查询。
4. B+ 树叶子节点的数据 `data` 是有序的，默认是升序 ASC，此时分布在 B+ Tree 右边的键值总是大于左边的。
5. B+ 树从根节点到每个叶子节点的距离是相等的，也就是访问任何一个叶子节点需要的 IO 是一样的，查询的性能更加的稳定。
6. B+ 树中根节点和非叶子节点不存储数据，只存储指针地址（索引），因此，要对表进行全表扫描，只需要遍历叶子节点就可以了，不需要遍历整棵 B+ Tree。
7. B+ Tree 的磁盘读写能力相对于 B Tree 来说更强，IO 次数更少。
8. B+ 根节点和枝节点不保存数据区，所以一个节点可以保存更多的关键字，一次磁盘加载的关键字更多，IO 次数更少。
9. B+ Tree 永远是在叶子节点拿到数据，所以 IO 次数是稳定的。


#### Hash索引和B+树索引的区别

1. B+ 树可以进行范围查询，Hash 索引不能。
2. B+ 树支持联合索引的最左侧原则，Hash 索引不支持。
3. B+ 树支持 order by 排序，Hash 索引不支持。
4. Hash 索引在等值查询上比 B+ 树效率更高。
5. B+ 树使用 like 进行模糊查询的时候，like 后面（比如 % 开头）的话可以起到优化的作用，Hash 索引根本无法进行模糊查询。




### B+树的高度
* ref 1-[MySQL索引原理及慢查询优化 | 美团技术](https://tech.meituan.com/2014/06/30/mysql-index.html)
* ref 2-[mysql如何设计索引更高效 | Segmentfault](https://segmentfault.com/a/1190000038921156)



> **树的高度直接影响了查询的性能，一般树的高度维持在 3~4 层。**

**磁盘 IO 次数取决于 B+ 树的高度 `h`。**

假设当前数据表的数据为 `N`，每个磁盘块的数据项的数量是 `m`，则有 B+ 树的高度为


$$
h = log_(m+1)N
$$


当数据量 `N` 一定的情况下，`m` 越大，`h` 越小。




### 树的高度和存储数据大小的计算

InnoDB 存储引擎最小储存单元是页，一页大小就是 16k。

B+ 树叶子存的是数据，内部节点存的是键值 + 指针。索引组织表通过非叶子节点的二分查找法以及指针确定数据在哪个页中，进而再去数据页中找到需要的数据。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/mysql-b%2B-tree-height-page-1.png)


**假设 B+ 树的高度为 2 的话，即有一个根结点和若干个叶子结点。这棵 B+ 树的存放总记录数为 = 根结点指针数 * 单个叶子节点记录行数。**

如果一行记录的数据大小为 1k，那么单个叶子节点可以存的记录数 = `16k/1k = 16`。

非叶子节点内存放多少指针呢？我们假设主键 ID 为 bigint 类型，长度为 8 字节（如果是 int 类型，一个 int 就是 32 位，4 字节)，而指针大小在 InnoDB 源码中设置为 6 字节，所以就是 8 + 6 = 14 字节，`16KB/14B = 16 * 1024B/14B = 1170`。

因此，一棵高度为 2 的 B+ 树，能存放 `1170 * 16 = 18720` 条这样的数据记录。

同理一棵高度为 3 的 B+ 树，能存放 `1170 * 1170 * 16 = 21902400`，也就是说，可以存放两千万左右的记录。B+ 树高度一般为 1-3 层，已经满足千万级别的数据存储。



### 相对B树使用B+树做索引的优势

* **B+ 树中所有关键字（数据）都在叶子节点出现，根节点和非叶子节点不存储数据。而 B 树中关键字（或数据）分布在整棵树的所有节点。因此对 B+ 树，只需要去遍历叶子节点就可以实现整棵树的遍历。**
* 树的查询效率更加稳定。B+ 树所有数据都存在于叶子节点，所有关键字查询的路径长度相同，每次数据的查询效率相当。而 B 树可能在非叶子节点就停止查找了，所以查询效率不够稳定。
* B+ 树的磁盘读写代价更低。B+ 树的内部没有指向关键字具体信息的指针，所以其内部节点相对 B 树更小。
* **B+ 树相邻的叶子节点之间是通过链表指针连起来的，B 树却不是。**
* 查找过程中，B 树在找到具体的数值以后就结束，而 B+ 树则需要通过索引找到叶子结点中的数据才结束。
* **B 树中任何一个关键字出现且只出现在一个节点中，而 B+ 树可以出现多次。**


### MyISAM和InnoDB的索引有什么区别

`MyISAM` 引擎和 `Innodb` 引擎都使用 `B+ Tree` 作为索引结构，但二者在底层实现还是有些不同的
1. Innodb 索引和数据存储在同一个文件
* 主键索引中，索引树的叶子节点保存的是对应行的数据
* 二级索引中，索引树的叶子节点保存的主键和索引列
  
2. MyISAM 索引文件和数据文件是分离的，索引文件仅保存记录所在页的指针（物理位置），通过这些指针来读取页，进而读取被索引的行。
* 主键索引中，索引树的叶子节点保存的是对应行的物理位置。通过该值，存储引擎能顺利地进行回表查询，得到一行完整记录
* MyISAM的二级索引，和主键索引相比，在结构上没有任何区别，只是主键索引要求 key 是唯一的，而二级索引的 key 可以重复





## 索引下推

* ref 1-[MySQL性能优化之索引下推 | Blog](https://www.cnblogs.com/three-fighter/p/15246577.html)



### 什么是索引下推

MySQL 5.6 版本中，引入了索引下推（Index Condition Pushdown，简称 ICP），它能减少回表查询次数，提高查询效率。



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-icp-1.png)

在 MySQL 5.6 之前，使用非主键索引进行查询的时候，存储引擎通过索引查询数据，然后将结果返回给MySQL Server 层，在 Server 层判断是否符合条件。

在 MySQL 5.6 版本引入「索引下推」后，在使用包含索引的列进行条件判断时，存储引擎会直接根据索引条件过滤掉不符合要求的记录，将原本应交由「Server层」处理的工作，直接在「存储引擎层」完成了。然后再回表，最后将结果返回给 Server 层。


综上，索引下推的好处是
1. 存储引擎层可以在回表查询之前，对数据进行过滤，减少回表次数
2. 可以减少 MySQL Server 层从存储引擎接收到的数据


### 索引下推实战

此处给出一个使用索引下推的实例，加深理解。


1. 创建一个 `user` 表，包含 `id`、`name`、`age` 字段，并创建联合索引 `name_age_idx(name,age)`。并插入必要的测试数据。

```sql
create table `user` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `age` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name_age_idx` (`name`,`age`)
) ENGINE=InnoDB CHARSET=utf8;


insert into user values
(1,"刘大宝",30),
(2,"刘小宝",20),
(3,"周大宝",40),
(4,"周小宝",10);
```

2. 执行如下查询语句。对 `name` 的筛选使用到了范围匹配，根据「最左匹配原则」，将只会使用到 `name` 字段的索引。

```sql
select * from user where name like "大%" and age = 30
```

3. 在 MySQL 5.6 版本前，根据 `name like "大%"` 筛选条件，存储引擎将匹配到两条记录，然后进行两次回表，最后将 `(1,"刘大宝",30)` 和 `(3,"周大宝",40)` 这两条记录返回给 Server 层。Server 层再根据 `age = 30` 的查询条件进行过滤，最终只返回 `(1,"刘大宝",30)` 这一条记录。
4. 在 MySQL 5.6 版本之后，存储引擎在使用索引列筛选后，将得到 `("刘大宝",30)` 和 `("周大宝",40)` 这两条记录。根据索引下推，存储引擎可以执行 `age = 30`的筛选，最终只得到一条记录，此时只需要一次回表。



### 索引下推配置

可以使用如下命令关闭索引下推。


```s
set optimizer_switch='index_condition_pushdown=off';
```


## 索引合并
* ref-1-[MySQL优化之索引合并 | 简书](https://www.jianshu.com/p/34bd66629355)
* ref-2-[Index Merge Optimization | MySQL Cookbook](https://dev.mysql.com/doc/refman/8.0/en/index-merge-optimization.html)
* ref 3-[MySQL索引合并算法 | Blog](https://gentlezuo.github.io/2019/09/11/MySQL%EF%BC%9A%E7%B4%A2%E5%BC%95%E5%90%88%E5%B9%B6/)
* ref 4-[MySQL 优化之 index merge | Blog](https://www.cnblogs.com/digdeep/p/4975977.html)


### 什么是索引合并

MySQL 5.0 之前，一个表一次只能使用一个索引，无法同时使用多个索引分别进行条件扫描。但是从 5.1 版本开始，引入了索引合并（`Index Merge`）技术，对同一个表可以使用多个索引分别进行条件扫描，然后将结果进行合并处理，最后再进行回表查询。

> 与其说是「MySQL 5.0 之前，一个表一次只能使用一个索引」，倒不如说是「大多数情况下，使用两个/多个索引，分析两个/多个索引B+树，比只使用一个索引和全表扫描，会更耗时」。所以，绝大多数情况下，数据库都是只用一个索引。

>  Ref. [Index Merge Optimization | MySQL Cookbook](https://dev.mysql.com/doc/refman/8.0/en/index-merge-optimization.html)
> 
> The Index Merge access method retrieves rows with **multiple range scans** and merges their results into one. This access method merges index scans from a single table only, **not scans across multiple tables**. The merge can produce unions, intersections, or unions-of-intersections of its underlying scans.
> 
> Index Merge is not applicable to full-text indexes.



* 索引合并技术，可以把几个索引的**范围扫描**合并成一个索引。
* 索引合并的时候，会对索引进行并集（`unions`），交集（`intersections`）或者交集的并集（`unions-of-intersections`，即先交集再并集），并合并为一个索引。
* **索引合并技术只适用于单表查询，不适用于多表查询。**
* 索引合并并不适用于全文索引。

### 索引合并的优缺点

优点
1. 可以让一条 SQL 语句使用多个索引，减少不必要的回表，提高查询效率。

缺点
1. 索引合并技术只适用于单表查询，不适用于多表查询。
2. 索引合并并不适用于全文索引。
3. 如果在 WHERE 语句中，存在多层嵌套的 AND/OR，MySQL 可能不会选择最优的方案，可以尝试通过拆分 WHERE 子句的条件来进行转换

```s
(x AND y) OR z => (x OR z) AND (y OR z)
(x OR y) AND z => (x AND z) OR (y AND z)
```




### 如何查看索引合并的使用

使用 EXPLAIN 对 SQL 语句进行查看，如果使用了索引合并
1. `type` 列会限制 `index_merge`
2. `key` 列会显示出所有使用的索引
3. `Extra` 列会显示具体的索引合并算法
    * `Using union` 表示对多个索引求并集
    * `Using intersect` 表示对多个索引求交集
    * `Using sort_union`表示对查询到的记录先按 `rowid` 排序再并集



### 索引合并算法

索引合并算法包括
1. Index Merge Intersection Access Algorithm（交集）
2. Index Merge Union Access Algorithm （并集）
3. Index Merge Sort-Union Access Algorithm（排序并集）


#### Index Merge Intersection Access Algorithm

Index Merge Intersection Access Algorithm（索引合并交集访问算法））会对多个索引条件扫描得到的结果进行交集运算。WHERE 子句中多个查询条件需要 AND 连接，并且满足下面的条件
1. 二级索引是等值查询；如果是组合索引，组合索引的每一位都必须覆盖到，不能只是部分
2. InnoDB 表上的主键范围查询条件

```sql
-- 主键可以使范围查询，二级索引只能是等值查询
SELECT * FROM innodb_table
  WHERE primary_key < 10 AND key_col1 = 20;

-- 没有主键的情况
SELECT * FROM tbl_name
  WHERE key1_part1 = 1 AND key1_part2 = 2 AND key2 = 2;
```

#### Index Merge Union Access Algorithm 

Index Merge Union Access Algorithm （索引合并并集访问算法）会对多个索引条件扫描得到的结果进行并集运算。WHERE 子句中多个查询条件需要 OR 连接，并且满足下面的条件
1. 二级索引是等值查询；如果是组合索引，组合索引的每一位都必须覆盖到，不能只是部分
2. InnoBD 表上的主键范围查询
3. 符合 index merge intersect 的条件


```sql
-- 无主键，or 连接
SELECT * FROM t1
  WHERE key1 = 1 OR key2 = 2 OR key3 = 3;

-- 既有and 也有or
SELECT * FROM innodb_table
  WHERE (key1 = 1 AND key2 = 2)
     OR (key3 = 'foo' AND key4 = 'bar') AND key5 = 5;
```


#### Index Merge Sort-Union Access Algorithm

Index Merge Sort-Union Access Algorithm（索引合并排序并集访问算法）适用于 WHERE 子句中的条件是通过 OR 结合的不同索引的范围条件，但是不能使用 Index Merge Union 算法的情景。

```sql
SELECT * FROM tbl_name
  WHERE key_col1 < 10 OR key_col2 < 20;

SELECT * FROM tbl_name
  WHERE (key_col1 > 10 OR key_col2 = 20) AND nonkey_col = 30;
```

Sort-Union Access Algorithm 和 Union Access Algorithm 算法的区别是
1. Sort-Union Access Algorithm 必须在返回行数据前，先获取行ID（`rowId`）并对行 ID 进行排序。
2. **Sort-Union Access Algorithm 放宽了使用条件，二级索引不必等值查询，联合索引也不必匹配所有的索引项。**


### 索引合并实战

1. 先创建一个 `t2` 表，创建主键索引和联合索引，并插入足量的测试数据。
  
```sql
create table t2(
	id int primary key, 
    a int not null, 
    b int not null,
    c int not null, 
    d int not null,
    f int not null,
    index idx_abc(a,b,c), 
    index idx_d(d),
    index idx_f(f)
);

DELIMITER $$  -- 使用$$作为结束符
CREATE PROCEDURE t2_copy()
BEGIN
SET @i=1;
WHILE @i<=10000 DO
INSERT INTO t2 VALUES(@i,@i,@i,@i,@i,@i);
SET @i=@i+1;
END WHILE;
END $$
DELIMITER ; -- 使用;作为结束符

call t2_copy; 
```

2. Using intersect
  
```sql
mysql> explain select * from t2 where id>1000 and f=1000;
+----+-------------+-------+------------+-------------+---------------+---------------+---------+------+------+----------+---------------------------------------------+
| id | select_type | table | partitions | type        | possible_keys | key           | key_len | ref  | rows | filtered | Extra                                       |
+----+-------------+-------+------------+-------------+---------------+---------------+---------+------+------+----------+---------------------------------------------+
|  1 | SIMPLE      | t2    | NULL       | index_merge | PRIMARY,idx_f | idx_f,PRIMARY | 8,4     | NULL |    1 |   100.00 | Using intersect(idx_f,PRIMARY); Using where |
+----+-------------+-------+------------+-------------+---------------+---------------+---------+------+------+----------+---------------------------------------------+
```

3. Using union

```sql
mysql> explain select * from t2 where f=1000 or d=1000;

+----+-------------+-------+------------+-------------+---------------+-------------+---------+------+------+----------+---------------------------------------+
| id | select_type | table | partitions | type        | possible_keys | key         | key_len | ref  | rows | filtered | Extra                                 |
+----+-------------+-------+------------+-------------+---------------+-------------+---------+------+------+----------+---------------------------------------+
|  1 | SIMPLE      | t2    | NULL       | index_merge | idx_d,idx_f   | idx_f,idx_d | 4,4     | NULL |    2 |   100.00 | Using union(idx_f,idx_d); Using where |
+----+-------------+-------+------------+-------------+---------------+-------------+---------+------+------+----------+---------------------------------------+
```


4. Using sort_union


```sql
mysql> explain select * from t2 where id >1000 or a=2;
+----+-------------+-------+------------+-------------+-----------------+-----------------+---------+------+------+----------+------------------------------------------------+
| id | select_type | table | partitions | type        | possible_keys   | key             | key_len | ref  | rows | filtered | Extra                                          |
+----+-------------+-------+------------+-------------+-----------------+-----------------+---------+------+------+----------+------------------------------------------------+
|  1 | SIMPLE      | t2    | NULL       | index_merge | PRIMARY,idx_abc | idx_abc,PRIMARY | 4,4     | NULL | 4974 |   100.00 | Using sort_union(idx_abc,PRIMARY); Using where |
+----+-------------+-------+------------+-------------+-----------------+-----------------+---------+------+------+----------+------------------------------------------------+
```


5. 因为组合索引没有完全覆盖而导致未使用 Intersect

```sql
mysql> explain select * from t2 where id>1000 and a=1000;
+----+-------------+-------+------------+------+-----------------+---------+---------+-------+------+----------+-----------------------+
| id | select_type | table | partitions | type | possible_keys   | key     | key_len | ref   | rows | filtered | Extra                 |
+----+-------------+-------+------------+------+-----------------+---------+---------+-------+------+----------+-----------------------+
|  1 | SIMPLE      | t2    | NULL       | ref  | PRIMARY,idx_abc | idx_abc | 4       | const |    1 |    49.99 | Using index condition |
+----+-------------+-------+------------+------+-----------------+---------+---------+-------+------+----------+-----------------------+
1 row in set, 1 warning (0.00 sec)
```



6. 因二级索引不是等值查询而导致未使用 Intersect


```sql
mysql> explain select * from t2 where id>1000 and d<1000;
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------------+
| id | select_type | table | partitions | type  | possible_keys | key     | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | t2    | NULL       | range | PRIMARY,idx_d | PRIMARY | 4       | NULL | 4973 |    10.04 | Using where |
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------------+
```


### 对索引合并的进一步优化

索引合并可以使用多个索引同时进行扫描，然后对结果进行合并。但是如果出现了索引合并（`Index Merge`），那么一般也意味着我们的索引建立得不太合理，因为可以通过建立联合索引进一步优化。 

```sql
SELECT * FROM t1 WHERE key1=1 AND key2=2 AND key3=3;
```
如上查询语句，我们可以建立联合索引 `key1_2_3_idx(key1,key2,key3)` 进一步优化查询，这样只需要扫描一个索引B+树即可，而不是使用索引合并技术对三个索引B+树进行扫描再交集合并。

关于索引合并和多列联合索引的对比，可参考 [Multi Column indexes vs Index Merge](https://www.percona.com/blog/2009/09/19/multi-column-indexes-vs-index-merge/) 做扩展阅读。

### 索引合并配置

使用 `select @@optimizer_switch` 查看 `optimizer_swith` 变量信息，可以发现和索引合并相关的配置信息
1. index_merge
2. index_merge_intersection
3. index_merge_union
4. index_merge_sort_union

默认情况下，上面四个变量的值都是 `on`，即索引合并是是启用的。可以要单独启或关闭（设置 `off`）某个算法。

```sql
mysql> select @@optimizer_switch \G;

*************************** 1. row ***************************
@@optimizer_switch: index_merge=on,index_merge_union=on,index_merge_sort_union=on,index_merge_intersection=on,engine_condition_pushdown=on,index_condition_pushdown=on,mrr=on,mrr_cost_based=on,block_nested_loop=on,batched_key_access=off,materialization=on,semijoin=on,loosescan=on,firstmatch=on,duplicateweedout=on,subquery_materialization_cost_based=on,use_index_extensions=on,condition_fanout_filter=on,derived_merge=on,use_invisible_indexes=off,skip_scan=on,hash_join=on,subquery_to_derived=off,prefer_ordering_index=on,hypergraph_optimizer=off,derived_condition_pushdown=on
1 row in set (0.00 sec)
```




## 再谈索引

### 全文索引
* [MySQL模糊查询再也用不着 like+% 了](https://mp.weixin.qq.com/s/ElmWWxsUsAOduGVBMR7luQ)


早期的 MySQL 版本中，InNoDB 不支持全文检索。从 MySQL 5.6 版本开始，InnoDB 支持全文检索。

全文检索通常使用倒排索引（`inverted index`）来实现，倒排索引同 `B+ Tree` 一样，也是一种索引结构。它在辅助表中存储了单词与单词自身在一个或多个文档中所在位置之间的映射，这通常利用关联数组实现，拥有两种表现形式
* `inverted file index`：{单词，单词所在文档的 id}
* `full inverted index`：{单词，（单词所在文档的 id，在具体文档中的位置）}
  

* 创建全文索引


```sql
-- 在已有的表上创建全文索引
CREATE FULLTEXT INDEX full_index_name ON table_name(col_name);

-- 创建表时创建全文索引
CREATE TABLE table_name ( 
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  ... 
  FULLTEXT full_index_name (col_name) 
) ENGINE=InnoDB;
```



* 使用全文索引
MySQL 数据库支持全文检索的查询，全文索引只能在 InnoDB 或 MyISAM 的表上使用，并且只能用于创建 `char`、`varchar`、`text` 类型的列。全文索引查询语法如下。

```sql
MATCH(col1,col2,...) AGAINST(expr[search_modifier])
search_modifier:
{
    IN NATURAL LANGUAGE MODE
    | IN NATURAL LANGUAGE MODE WITH QUERY EXPANSION
    | IN BOOLEAN MODE
    | WITH QUERY EXPANSION
}
```

## FAQ

### MongoDB的索引为什么选择B树而MySQL的索引是B+树

因为 MongoDB 不是传统的关系型数据库，而是以 JSON 格式作为存储的 NoSQL 非关系型数据库，目的就是高性能、高可用、易扩展。摆脱了关系模型，所以范围查询和遍历查询的需求就没那么强烈了。

**B+ 树的叶子节点上有指针进行相连，因此在做数据遍历的时候，只需要对叶子节点进行遍历即可，这个特性使得 B+ 树非常适合做范围查询。**



### 多个单列索引和一个联合索引

> 如果对 `a`，`b` 和 `c` 三个字段都创建对应的单列索引，执行查询条件为 `WHERE a=1 AND b=2 AND c=3` 时，三个字段对应的索引都会被用到吗？

多个单列索引在多条件查询时，MySQL 优化器会选择最优索引策略，可能只用一个索引，也可能将多个索引都用上。


> 多条件查询时是创建多个单列索引还是创建一个联合索引好？它们之间的区别是什么？哪个效率更高？


多个单列索引底层会建立多个 B+ 索引树，比较占用空间，也会浪费搜索效率。所以多条件联合查询时最好建联合索引。
