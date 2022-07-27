# MySQL-05-MySQL连接和基于成本的优化

[TOC]



## 更新
* 2022/05/09，撰写

## 参考资料
* [《MySQL是怎样运行的》从根儿上理解 MySQL](https://juejin.cn/book/6844733769996304392)，「连接的原理」章节和「基于成本的优化」章节
* [join语句如何优化](https://mp.weixin.qq.com/s/GuYAK6PY26XtSExd8DGwmg)







## JOIN 基本语法

JOIN 可分为内连接和外连接
1. 内连接（`inner/cross join`）
2. 外连接（`left join`，`right join`，`full join`）


### 内连接的语法
* ref 1-[MySQL中inner join 和 cross join 的区别](https://www.zhihu.com/question/34559578)

在 MySQL 中 `cross join` 与 `inner join` 的作用是一样的。并且可以直接省略掉 `cross` 或者 `inner` 关键字，即下面3种写法是等价的。

```sql
SELECT * FROM t1 JOIN t2;
SELECT * FROM t1 INNER JOIN t2;
SELECT * FROM t1 CROSS JOIN t2;
```

上边的这些写法等价于，直接把需要连接的表名放到 FROM 语句之后，用逗号 `,` 分隔开。

```sql
SELECT * FROM t1,t2;
```


### 借助UNION实现FULL JOIN

需要说明的是，MySQL中并没有 `full join` 的语法，需要借助 `union` 关键字来实现。

```sql
select user.name,depart.department 
from user left join depart 
on user.name = depart.name

union

select user.name, depart.department 
from user right join depart 
on user.name = depart.name;
```



### 连接中WHERE子句中的过滤条件和ON子句中的过滤条件

在 Join 中的过滤条件分为 2 种
1. WHERE 子句中的过滤条件：不管是内连接还是外连接，凡是不符合 WHERE 子句中过滤条件的记录都不会加入到最后的结果集中。
2. ON 子句中的过滤条件
   * 对于外连接的驱动表的记录来说，如果无法在被驱动表中找到匹配 ON 子句中的过滤条件的记录，那么该记录仍然会被加入到结果集中，对应的被驱动表记录的各个字段使用 NULL 值填充
   * 对于内连接，ON 子句和 WHERE 子句是等价的，不符合过滤条件的记录，不会加入到最后的结果集中


> **内连接和外连接的根本区别就是，在驱动表中的记录不符合 ON 子句中的连接条件时，内连接不会把该记录加入到最后的结果集中，而外连接会。**




### where和having的区别
参考 [Mysql中having语句与where语句的用法与区别](https://juejin.cn/post/7074467600243097636)


* where 用在 group by 之前，having 用在 group by 之后
* where 用于条件筛选，having 用于分组后筛选
* where 条件后面不能跟聚合函数；having 一般配合 group by 或者聚合函数（min、max、avg、count、sum）使用
* having 子句在查询过程中慢于聚合语句（sum,min,max,avg,count)，而 where 子句在查询过程中则快于聚合语句（sum,min,max,avg,count)，如下示例


```sql
-- where子句  先查询出id大于10的记录才能进行聚合语句 
select sum(num) as rmb from order where id>10  
 

-- having子句   
-- having条件表达示为聚合语句 having子句查询过程慢于聚合语句
-- 对分组数据再次判断时要用having
select reportsto as manager, count(*) as reports from employees  group by reportsto having count(*) > 4  
```



## JOIN的原理

1. （简单）嵌套循环连接（Simple Nested-Loop Join）
2. 使用索引加快连接速度（Index Nested-Loop Join）
3. 基于块的嵌套循环连接（Block Nested-Loop Join）


关于「基于块的嵌套循环连接」，此处进行必要的补充说明，在基于块的嵌套循环连接中
* 首先，使用连接缓冲区（Join Buffer），即执行连接查询前申请的一块固定大小的内存，先把若干条驱动表结果集中的记录装在这个 Join Buffer 中
* 然后开始扫描被驱动表，每一条被驱动表的记录一次性和 Join Buffer 中的多条驱动表记录做匹配。因为匹配的过程都是在内存中完成的，所以这样可以显著减少被驱动表的 I/O 代价。







## 基于成本的优化


在某些场景下，如果 MySQL 评估使用索引比使用全表扫描查询数据性能更低，则不会使用索引来查询数据，而会进行全表扫描。因此，不是命中索引了就会走索引查询。这个评估的过程，就是「基于成本的优化」。


### 什么是成本

在 MySQL 中，一条查询语句的执行成本是由 2 个方面组成的
1. I/O 成本：将记录从磁盘加载到内存，这个过程消耗的时间就是 I/O 成本。
2. CPU 成本：读取以及检测记录是否满足对应的搜索条件、对结果集进行排序等这些操作损耗的时间称之为 CPU 成本。


### 基于成本的优化步骤

在一条单表查询语句真正执行之前，MySQL 的「查询优化器」会找出执行该语句所有可能使用的方案，对比之后找出成本最低的方案，这个成本最低的方案就是所谓的「执行计划」。之后才会调用存储引擎提供的接口真正的执行查询，这个过程总结一下就是这样
1. 根据搜索条件，找出所有可能使用的索引
2. 计算全表扫描的代价
3. 计算使用不同索引执行查询的代价
4. 对比各种执行方案的代价，找出成本最低的那一个


## 连接查询的成本


### 如何计算成本

MySQL 中连接查询采用的是嵌套循环连接算法，驱动表会被访问一次，被驱动表可能会被访问多次，所以对于两表连接查询来说，它的查询成本由下边 2 个部分构成
1. 单次查询驱动表的成本
2. 多次查询被驱动表的成本（具体查询多少次取决于对驱动表查询的结果集中有多少条记录）

综上，两表连接的成本为

```s
两表连接查询的总成本 = 单次访问驱动表的成本 + 驱动表扇出数 x 单次访问被驱动表的成本
```



### 扇出

我们把对驱动表进行查询后得到的记录条数称之为驱动表的「扇出（`fanout`）」。很显然，驱动表的扇出值越小，对被驱动表的查询次数也就越少，连接查询的总成本也就越低。


### 条件过滤

* ref 1-[MySQL性能优化-条件过滤 | 数据库之家](https://mytecdb.com/blogDetail.php?id=98)


#### 什么是条件过滤


在 Join 查询时，通过「条件过滤（`Condition Filtering`）」，使用 WHERE 条件对驱动表进行限制，从而减少驱动表的扇出，降低连接查询的成本。

在进行条件过滤时，有如下限制
1. 条件只能是常量
2. 条件过滤中的 WHERE 条件不在索引条件中



#### 条件过滤在EXPLAIN中的表现




在 expalin 的输出中，`rows` 字段表示所选择的索引访问方式预估的扫描记录数，`filtered` 字段反映了条件过滤。

`filtered` 值是一个百分比，表示通过查询条件获取的最终记录行数占通过 `type` 字段指明的搜索方式搜索出来的记录行数的百分比。
1. 最大值是 100，表示没有进行任何过滤
2. 该值越小，说明条件过滤效果越好


举个例子，如果一个 SQL 的执行计划，rows 为 200，filtered 为 10（即 10%），那么最终预估的扫描记录数为 `200*10%` = 20。





#### 条件过滤案例

有两张表做 JOIN 查询，`employee` 为雇员表，`department` 为部门表，查询SQL如下

```sql
SELECT *
FROM employee JOIN department 
ON employee.dept_no = department.dept_no
WHERE employee.first_name = 'John'
AND employee.hire_date BETWEEN '2018-01-01' AND '2018-06-01';
```

两张表的数据信息如下

* `employee` 表记录总数：1024
* `department` 表记录总数：12
* 两张表在 `dept_no` 字段上都有索引
* `employee` 表在 `first_name` 上有索引
* 满足 `employee.first_name = 'John'` 的记录数：8
* 满足 `employee.hire_date BETWEEN '2018-01-01' AND '2018-06-01'` 的记录数：150
* 满足 `employee.first_name = 'John' AND employee.hire_date BETWEEN '2018-01-01' AND '2018-06-01'` 记录数：1



1. 如果没有使用条件过滤，EXPLAIN 执行计划如下

```s
+----+------------+--------+------------------+---------+---------+------+----------+
| id | table      | type   | possible_keys    | key     | ref     | rows | filtered |
+----+------------+--------+------------------+---------+---------+------+----------+
| 1  | employee   | ref    | name,h_date,dept | name    | const   | 8    | 100.00   |
| 1  | department | eq_ref | PRIMARY          | PRIMARY | dept_no | 1    | 100.00   |
+----+------------+--------+------------------+---------+---------+------+----------+
```

可知，驱动表 `employee` 的扇出是 8，在连接查询时，会查询 8 次被驱动表。


2. 使用了条件过滤，EXPLAIN 执行计划如下


```s
+----+------------+--------+------------------+---------+---------+------+----------+
| id | table      | type   | possible_keys    | key     | ref     | rows | filtered |
+----+------------+--------+------------------+---------+---------+------+----------+
| 1  | employee   | ref    | name,h_date,dept | name    | const   | 8    | 16.31    |
| 1  | department | eq_ref | PRIMARY          | PRIMARY | dept_no | 1    | 100.00   |
+----+------------+--------+------------------+---------+---------+------+----------+
```

很明显，表 `employee` 上的 `filtered` 由 100 变为了 16.31，则驱动表的扇出为 `8 × 16.31% = 1.3`，即在连接查询时，会查询 1 次被驱动表。




#### 条件过滤开关

MySQL 提供了参数来控制是否打开条件过滤。条件过滤（`Condition Filtering`）默认情况下是打开的。

```s
SET optimizer_switch = 'condition_fanout_filter=on';  #off表关闭
```

#### 条件过滤和性能


**条件过滤并不总是能提高性能，优化器可能会高估条件过滤的影响，个别场景下使用条件过滤反而会导致性能下降。**


在排查性能问题时，可参考以下思路
* JOIN 连接的字段是否有索引，如果没有索引，则应当先加上索引，以便优化器能够掌握字段值的分布情况，更准确的预估行数。
* 表的 JOIN 顺序是否合适，通过改变表的 JOIN 顺序，让更小的表作为驱动表。
* 可以考虑使用 `STRAIGHT_JOIN`，强制优化器使用指定的表 JOIN 顺序。
* 如果不使用条件过滤，性能会更好，那么可以关闭会话级条件过滤功能。

```s
SET optimizer_switch = 'condition_fanout_filter=off';
```



## 连接性能优化
1. 在嵌套循环连接中，由于被驱动表可能被访问多次，因此可以为被驱动表建立合适的索引以加快查询速度。
2. 使用小表做驱动表。
3. 如果被驱动表很大，多次访问被驱动表可能导致多次磁盘 I/O，此时可以使用基于块的嵌套循环连接算法来减少磁盘 I/O。若机器硬件允许，可适当增加连接缓冲区（Join Buffer）的大小。
4. 不要用 `*` 作为查询列表，只返回需要的列。
5. 必要情况下，可以考虑使用 `STRAIGHT_JOIN`，强制优化器使用指定的表 JOIN 顺序。
   


### STRAIGHT_JOIN
* ref 1-[【性能提升神器】STRAIGHT_JOIN | 博客园](https://www.cnblogs.com/heyonggang/p/9462242.html)

> `STRAIGHT_JOIN` is similar to JOIN, except that the left table is always read before the right table. This can be used for those (few) cases for which the join optimizer puts the tables in the wrong order.


`STRAIGHT_JOIN` 功能同 JOIN  类似，但能让强制让左边的表作为驱动表，来驱动右边的表。


#### INNER JOIN时驱动表的确定

在表的 `INNER JOIN` 查询时
* 若指定了连接条件，MySQL优化器会将满足查询条件的记录行数较少的表作为驱动表
* 若未指定查询条件，则 MySQL 会扫描两个表的行数，行数较少的为驱动表
* 可以使用 `STRAIGHT_JOIN` 绕过 MySQL 优化器，强制指定左边的表作为驱动表



#### 注意事项
* `STRAIGHT_JOIN` 只适用于 `INNER JOIN` 情况，并不适用 `LEFT JOIN` 和 `RIGHT JOIN`，因为 `LEFT JOIN` 和 `RIGHT JOIN` 已经代表指定了表的执行顺序。
* 尽可能让优化器去判断，因为大部分情况下 MySQL 优化器是比人要聪明的。使用`STRAIGHT_JOIN` 一定要慎重，人为指定的执行顺序，并不一定会比 MySQL 优化器确定执行顺序更好。
