# MySQL-01-MySQL学习路线

[TOC]

## 更新
* 2022/04/23，撰写




## 学习路线
1. 以书籍「《MySQL技术大全》开发优化与运维实战」作为知识体系查阅手册
2. 以书籍「《MySQL是怎样运行的》从根儿上理解 MySQL」 作为进阶指导手册


### 学习书籍

1. 入门版
（1）[01-《MySQL技术大全》开发优化与运维实战](https://cread.jd.com/read/startRead.action?bookId=30691430&readType=3) 
（2）01-《MySQL必知必会》
2. 进阶版
（1）[02-《MySQL是怎样运行的》从根儿上理解 MySQL](https://juejin.cn/book/6844733769996304392)
（2）02-《高性能MySQL》


### 参考资料
* [MySQL官网](https://www.mysql.com/cn/)



## FAQ




### SHOW TABLES LIKE "%xx%"


```sql
SHOW TABLES LIKE "%babel_activity_product_info%";
```


### 工程开发中数据库异常时自动切换到从库


参考素材 JSF@JD 的代码，在数据查询时，若发生数据库异常，自动切换到另一个从库。


```java
@Override
public List<FeedConfig> queryFeedConfigs(List<Long> feedIds) {
    CallerInfo info = Ump.methodReg(UmpKeyConstants.METHOD.QUERY_FEED_CONFIGS);
    try {
        return queryForList("Feed.queryFeedConfigs",feedIds);
    } catch (DataAccessException e) {
        log.error("Feed.queryFeedConfigs error:" + e.getMessage());
        Ump.funcError(info);
        //数据库异常自动切换到另一个从库
        return backupDao.queryFeedConfigs(feedIds);
    } finally {
        Ump.methodRegEnd(info);
    }
}
```



### count(1)、count(*)与count(col)

* ref 1-[count(1)、count(*)与count(col)的执行区别](https://mp.weixin.qq.com/s/tVCr7QaxJCzVCTTGpshm5g)


三者区别如下
1. `count(col)` 只计数列名为 `col` 的这一列，并且会忽略列值为 `NULL` 的情况，即某个值为 `NULL` 时，不统计。`count(1)` 和 `count(*)` 则会统计值为 `NULL` 的情况。
2. `count(1)` 和 `count(*)` 并无较大区别。如果表中有多个列并且没有主键，则 `count(1)` 的执行效率高于 `count(*)`。
3. 如果表有主键且 `col` 为主键，则 `count(col)` 的效率是最高的。





### update更新多个字段

* ref 1-[MySQL 中 update 语句踩坑日记 | 掘金](https://juejin.im/post/5ec699d6e51d45786973b5f4)



**使用 `update` 更新多个字段时，相邻字段间应该以逗号分隔，而不是 `and`。**


下面结合具体例子进行分析。


* 创建一个用户表，同时插入测试数据

```sql
create table user(
    id int(12) COMMENT '用户主键id',
    name varchar(36) COMMENT '用户名',
    age int(12) comment '年龄'
);

insert into user values 
    (1,'one',11),
    (2,'two',12),
    (3,'three',13),
    (4,'four',15),
    (5,'five',15);
```

* 现在需要把所有的年龄改成 10，用户名改成 `user`（假设此操作有意义）

```sql
update user set age=10 and name='user';
```

* 执行后，查看数据表，会发现 `age` 全部被更新为 0 了，而 `name` 字段没有任何更改。


```sql
id  name    age
--------------
1	one  	0
2	two 	0
3	three	0
4	four	0
5	five	0
```



* `update` 语句中，使用 `and` 作为多个字段之间的分隔符，SQL 解析器会将其作为一个布尔条件处理。上述查询语句等价如下语句，`(10 and name='user')` 将作为一个返回值为 `boolean` 类型的判断语句。

```sql
update user set age=(10 and name='user');
```




* 正确情况下，使用 `update` 更新多个字段时，相邻字段间应该以逗号分隔，而不是 `and`。正确的操作语句如下。

```sql
update user set age=10, name='user';
```



### 分页limit过大导致大量排序

分页limit过大导致大量排序，如何优化？

```sql
select * from `user` order by age limit 100000,10
```
* 可以记录上一页最后的 id，下一页查询时，查询条件带上 id，如 `where id > 上一页最后 id limit 10`。
* 也可以在业务允许的情况下，限制页数，避免深翻页




## 环境配置

### 安装MySQL

1. 使用 HomeBrew 安装


```s
$ brew install mysql
```

安装结束后，会有如下提示

```s
We've installed your MySQL database without a root password. To secure it run:
    mysql_secure_installation

MySQL is configured to only allow connections from localhost by default

To connect run:
    mysql -uroot

To have launchd start mysql now and restart at login:
  brew services start mysql
Or, if you don't want/need a background service you can just run:
  mysql.server start

```

上述信息提示，
* 运行 `brew services start mysql`，可以在后台启动 mysql
* 运行 `mysql.server start`，可以在前台启动 mysql（关闭控制台，服务停止）
* 运行 `mysql_secure_installation`，可以进行密码设置




2. 使用 `mysql --version` 校验 mysql 版本号


```s
lbs@lbsmacbook-pro ~ % mysql --version
mysql  Ver 8.0.29 for macos12.2 on x86_64 (Homebrew)
```


### MySQL的启动和停止


1. 启动mysql


```s
brew services start mysql   //后台启动

sudo mysql.server start     //前台启动

//若遇到权限问题，可执行下述命令
sudo chmod -R a+rwx /usr/local/var/mysql
```

2. 停止mysql


```s
sudo mysql.server stop
```


3. 重启mysql

```s
sudo mysql.server restart
```


### Can't connect to local MySQL server through socket '/tmp/mysql.sock'
* [Can't connect to local MySQL server through socket '/tmp/mysql.sock' | StackOverflow](https://stackoverflow.com/questions/22436028/cant-connect-to-local-mysql-server-through-socket-tmp-mysql-sock-2)

执行MySQL连接时候遇到如下报错

```s
> mysql -uroot -p

Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)
```

解决办法为

```s
mysql.server start   //启动
mysql.server stop    //停止


//sudo /usr/local/mysql/support-files/mysql.server stop
//sudo /usr/local/mysql/support-files/mysql.server start

```



## 数据类型

1. 数值类型（整数类型，浮点数类型和定点数类型）
2. 日期和时间类型
3. 字符串类型（文本字符串类型和二进制字符串类型）



### 数值类型

数值类型的具体细分如下
1. 整数类型
(1) TINYINT
(2) SMALLINT
(3) MEDIUMINT
(4) INT（INTEGER）
(5) BIGINT
2. 浮点数类型
(1) 单精度FLOAT
(2) 双精度DOUBLE
3. 定点数（只有 `DECIMAL` 一种类型，也可以使用 `(M,D)` 进行表示）


对于浮点数，可以使用 `(M,D)` 的方式进行标识，表示当前数值包含整数位和小数位一共会显示 M 位数字，其中小数点后会显示 D 位数字。M 又被精度，D又被成为标度。

```sql
CREATE TABLE user_info (
    f FLOAT(5,2),
    d DOUBLE(5,2)
);
```

浮点数若不写精度和标度时，会按照计算机硬件和操作系统决定的数据精度进行显示。如果用户指定的精度超出了浮点数类型的数据精度，则MySQL会自动进行四舍五入操作，数据能够插入MySQL中，并能够正常显示。

对比而言，定点数不指定精度和标度时，会默认使用 `DECIMAL(10,0)`。


### 日期和时间类型

此类型可分为
1. YEAR类型（YYYY）
2. TIME类型（HH:MM:SS）
3. DATE类型（YYYY-MM-DD）
4. DATETIME类型（YYYY-MM-DD HH:MM:SS）
5. TIMESTAMP类型（YYYY-MM-DD HH:MM:SS）


### 字符串类型

字符串类型可分为文本字符串类型和二进制字符串类型。

文本字符串类型又可分为
1. CHAR
2. VARCHAR
3. TINYTEXT
4. TEXT
5. MEDIUMTEXT
6. LONGTEXT
7. ENUM
8. SET
9. JSON


二进制字符串类型主要存储一些二进制数据，比如可以存储图片，音频和视频得动二进制数据，具体类型包括
1. BIT
2. BINARY
3. VARBINARY
4. TINYBLOB
5. BLOB
6. MEDIUMBLOB
7. LONGBLOB


### CHAR和VARCHAR的区别

`CHAR` 类型的字段长度是固定的，为创建表时声明的字段长度，最小取值为0，最大取值为255。如果保存时，数据的实际长度比 `CHAR` 类型声明的长度小，则会在右侧填充空格以达到指定的长度。当 MySQL 检索 `CHAR` 类型的数据时，`CHAR` 类型的字段会去除尾部的空格。对于 `CHAR` 类型的数据来说，定义 `CHAR` 类型字段时，声明的字段长度即为 `CHAR` 类型字段所占的存储空间的字节数。


`VARCHAR` 类型修饰的字符串是一个可变长的字符串，长度的最小值为0，最大值为65535。检索 `VARCHAR` 类型的字段数据时，会保留数据尾部的空格。`VARCHAR` 类型的字段所占用的存储空间为字符串实际长度加1个字节。


















### 字符串过长

* ref 1-[com.mysql.jdbc.MysqlDataTruncation: Data truncation: Data too long for column 'aboutMeText' at row 1 | Stack Overflow](https://stackoverflow.com/questions/39631478/com-mysql-jdbc-mysqldatatruncation-data-truncation-data-too-long-for-column-a)
* ref 2-[Data truncation: Data too long for column 'logo' at row 1 | Stack Overflow](https://stackoverflow.com/questions/21522875/data-truncation-data-too-long-for-column-logo-at-row-1/21523073)
* ref 3-[MySQL中varchar最大长度是多少](https://developer.aliyun.com/article/8826)
* ref 4-[mysql 数据库中varchar的长度与字节，字符串的关系](https://segmentfault.com/q/1010000003040054)


在日常开发中，遇到如下报错。根据报错信息可以知道，插入的数据长度，超过了允许的最大单行长度。下面进行具体分析和总结。

```s
com.mysql.jdbc.MysqlDataTruncation: Data truncation: Data too long for column 'aboutMeText' at row 1
```



#### vachar允许的最大长度

**MySQL 要求一个行的定义长度不能超过 65535（包括多个字段）。**

在 UTF8 编码中，一个字符占 3 个字节。因此，在 UTF8 编码中，`varchar` 允许的最大字符长度为 `21842`，即对数字或中文，允许存储的最大长度都是 `21842`。

```s
21842 = (65535-1-2-4)/3
```

上述计算公式中
* 减 1 是因为实际行的存储从第2个字节开始
* 减 2 是因为 `varchar` 头部的2个字节用于表示长度
* 减 4 是因为字段 `id` 的 `int` 类型占用 4 个字节
* 除以 3 是因为一个 UTF8 编码中，一个字符占用 3 个字节





> 字符类型若为 gbk，每个字符最多占 2 个字节，最大长度不能超过 32766。
>
> 字符类型若为 utf8，每个字符最多占 3 个字节，最大长度不能超过 21845。




比如，如果在创建数据库字段时候设定 `varchar(21844)`，由于 21844 大于 21842，因此会有如下报错信息。


```s
Row size too large.
The maximum row size for the used table type, not counting BLOBs, is 65535.
This includes storage overhead, check the manual.
You have to change some columns to TEXT or BLOBs.
```



#### vacahr(n)

`varchar(n)` 表示字符串的最大长度为 `n`（不区分数字或中文）。根据上文分析，在 UTF8 编码中，`n` 不能大于 21482。


例如，创建如下数据表。

```sql
CREATE TABLE `test_char` (
    `s` VARCHAR(10) NULL DEFAULT NULL
)
```

执行插入语句，插入 10 个中文或者 10 个数字，均可以成功。

```sql
mysql > insert into test_char(s) values ('0123456789');
Query OK, 1 row affected (0.00 sec)

mysql > insert into test_char(s) values ('一二三四五六七八九十');
Query OK, 1 row affected (0.00 sec)
```


但是如果插入大于 10 个的数字或中文，就会提示插入失败。


```sql
mysql > insert into test_char(s) values ('0123456789X');
ERROR 1406 (22001): Data too long for column 's' at row 1

mysql > insert into test_char(s) values ('一二三四五六七八九十2');
ERROR 1406 (22001): Data too long for column 's' at row 1
```




### tinyint、smallint、int、bigint的取值范围


|        type     |     min    |       max   | 存储空间 |
|-----------------|------------|-------------|----------|
| tinyint         |  -128(-2^7) | +127 (2^7 -1) | 1字节 |
| tinyint unsigned|     0 | +255 (2^8 -1)       | 1字节 |
| smallint        |  -(-2^15)   | +(2^15 -1)    | 2字节 |
|      int        |  -(-2^31)   | +(2^31 -1)    | 4字节 |
|      bigint     |  -(-2^63)   | +(2^63 -1)    | 8字节 |


### int(1)和int(9)的区别

* ref 1-[资深开发竟然不清楚int(1)和int(10)的区别](https://juejin.cn/post/6992574502282477605)


首先，需要明确的是，`int(1)` 和 `int(9)` 所能表示的数据范围是一样的，都可以表示 `[-(-2^31),+(2^31 -1) ]` 。



**`int(x)` 需要和 `zerofill` 搭配使用，才可以看到效果，`x` 表示数字展示的位数。如 `int(4)` 表示当数值小于1000时，会以 `000X` 的格式展示。**




```sql
CREATE TABLE `user` (
  `id` int(4) unsigned zerofill NOT NULL AUTO_INCREMENT,
   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;
```


如上所示，对于上述数据库的表 `user`，字段 `id` 类型为 `int(4) unsigned`，并使用 `zerofill` 修饰。


下面插入 4 条数，并查询其结果。


```sql
mysql> INSERT INTO `user` (`id`) VALUES (1),(10),(100),(1000);
```

查询结果如下。

```sql
mysql> select * from user;
+------+
| id   |
+------+
| 0001 |
| 0010 |
| 0100 |
| 1000 |
+------+
4 rows in set (0.00 sec)
```

可以发现， `int(4)` + `zerofill` 实现了不足 4 位补 0 的现象，单单 `int(4)` 是没有用的。而且对于 0001 这种，底层存储的还是 1，只是在展示时候会补 0。



> `zerofill` 一般用于格式化输出数字的时候，如学生的编号 0001 0002 ... 9999 这种。
> 
> 在 MySQL 中创建数据表时，对于整数类型字段，指定数据字段为 `ZEROFILL` 时，MySQL 会自动为当前列添加 `UNSIGNED` 属性，如 `id1 int(10) unsigned zerofill`。






## 基本操作

### DQL、DML、DDL、DCL

详情参考 [SQL中有关DQL、DML、DDL、DCL的概念与区别](https://cloud.tencent.com/developer/article/1735276)。



* DQL

数据查询语言（DQL: Data Query Language）。数据检索语句，用于从表中获取数据。通常最常用的为 SELECT 查询。

* DML

数据操纵语言（DML：Data Manipulation Language）。主要用来对数据库的数据进行一些操作，常用的就是 INSERT、UPDATE、DELETE。


* DDL

数据库定义语言（DDL: Data Definition Language）。主要针对数据库创建和修改的一些操作，如CREATE、ALTER、DROP等。DDL主要是用在定义或改变表的结构，数据类型，表之间的链接和约束等初始化工作上


* DCL

数据库控制语言：DCL（Data Control Language）。是用来设置或更改数据库用户或角色权限的语句，包括（grant,deny,revoke等）语句。这个比较少用到。

* DPL

事务处理语言（DPL）。事务处理语句能确保被DML语句影响的表的所有行及时得以更新。TPL语句包括BEGIN TRANSACTION、COMMIT和ROLLBACK。




### SQL查询顺序

SELECT 子句遵循下述顺序。

```s
SELECT > FROM > WHERE > GROUP BY > HAVING > ORDER BY > LIMIT
```

* 在同时使用 `ORDER BY` 和 `WHERE` 子句时，应该让 `ORDER BY` 位于 `WHERE` 之后，否则将会产生错误。
* **`GROUP BY` 子句必须出现在 `WHERE` 子句之后，`ORDER BY` 子句之前。**
* `WHERE` 子句操作符如下表所示



### 不等于

**`<>` 和 `!=` 都可以表示不等于，但是只有 `<>` 是标准的 SQL 语法，可以移植。所以开发中，尽量使用 `<>` 表示不等于。**




### NULL判断

**进行 `null` 的等于判断时，必须使用 `is null` 或 `is not null`，其它操作符与 `null` 操作都是 `false`。**

例如，`select * from bl_ip_dt where amount <> 800` 这条语句查不出 `amount` 等于 `null` 的记录，`select * from bl_ip_dt where amount <> 800 or amount is null` 才是可以的。



### AND优先级高于OR


```sql
SELECT  prod_name, pord_price 
FROM products
WHERE vend_id = 1002 OR vend_id = 1003 AND prod_price >= 10;
```


**SQL（像多数语言一样）在处理 OR 操作符前，优先处理 AND 操作符。即 AND 在计算次序中优先级更高。**


对于上述查询，查询到的是供应商1003制造的价格大于等于10美元的产品，或者供应商1002制造的任何商品。

若要改变计算的优先级，可以使用圆括号明确优先级关系，如下所示。


```sql
SELECT  prod_name, pord_price 
FROM products
WHERE (vend_id = 1002 OR vend_id = 1003) AND prod_price >= 10;
```

更进一步的，上述查询可以使用 `IN` 操作符替换

```sql
SELECT  prod_name, pord_price 
FROM products
WHERE vend_id IN (1002,1003) AND prod_price >= 10;
```

* **`IN` 操作符一般比 `OR` 操作符执行更快。**
* `IN` 的最大优点是可以包含其他 `SELECT` 语句，使得能够更动态地建立 `WHERE` 子句。




### UNION和UNION ALL

UNION 语句可以对使用多个 SELECT语句查询出的结果数据进行合并，合并查询结果数据是，要求每个 SELECT 语句查询出的数据的列数和数据类型必须相等，并且相互对应。


UNION 语句的语法格式如下。

```sql
SELECT col1 [,col2, ... ,coln] FROM table1
UNION [ALL]
SELECT col1 [,col2, ... ,coln] FROM table1
```

其中，`ALL` 关键字可以省略
* 当省略 ALL 关键字时，即使用 `UNION` 时，会删除重复的记录，返回的每行数据都是唯一的。
* 当使用 ALL 关键字是，即使用 `UNION ALL` 时，结果数据中会包含重复的数据记录。


### LIMIT

* [ref-分页查询 | 廖雪峰的网站](https://www.liaoxuefeng.com/wiki/1177760294764384/1217864791925600)


使用 `LIMIT <M> OFFSET <N>` 可以对结果集进行分页，每次查询返回结果集的一部分。分页查询需要先确定每页的数量和当前页数，然后确定 `LIMIT` 和 `OFFSET` 的值。

* `LIMIT <M>` 中参数 `M` 表示 `pageSize`
* `OFFSET <N>` 中参数 `N` 的计算公式为 `pageSize * (pageIndex - 1)`
* `OFFSET` 是可选的，如果只写 `LIMIT 15`，那么相当于 `LIMIT 15 OFFSET 0`
* `OFFSET` 超过了查询的最大数量并不会报错，而是得到一个空的结果集
* 使用 `LIMIT <M> OFFSET <N>` 分页时，随着 N 越来越大，查询效率也会越来越低
* 例如 `LIMIT 15 OFFSET 30` 表示查询第3页，即每页数据量为15个，偏移前30个数据，返回第3页的数据。

### `LIMIT M OFFSET N` 和 `LIMIT N, M`

二者关系如下。

```sql
LIMIT M OFFSET N   = LIMIT N, M
-- 注意前后 M 和 N 的位置关系
```
* `LIMIT 15 OFFSET 30` 等价于 `LIMIT 30, 15`。
* `LIMIT 2,1` 表示跳过 2 条数据并取出 1 条数据，即读取第 3 条数据。
* `LIMIT 2 OFFSET 1` 表示从第 1 条（不包括）数据开始，取出 2 条数据，`LIMIT` 后面跟的是 2 条数据，`OFFSET` 后面是从第 1 条开始读取，即读取第 2，3 条数据。



### 指定自增值 AUTO_INCREMENT


```sql
CREATE TABLE `hui_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户表id',
  `username` varchar(50) NOT NULL COMMENT '用户名'
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_name_unique` (`username`) 
  USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
```

在创建数据表时候， `AUTO_INCREMENT=22` 表示自增值是从 22 开始自增的。




### 视图

MySQL 5 添加了对视图的支持。视图是虚拟的表。与包含数据的表不一样，视图只包含使用时动态检索数据的查询。


通常，视图是可以更新的。更新一个视图将更新其基表（视图本身没有数据）。如果你对视图增加或删除行，实际上是对其基表增加或删除行。



但是，并非所有视图都是可更新的。基本上可以说，如果 MySQL 不能正确地确定被更新的基数据，则不允许更新（包括插入和删除）。这实际上意味着，如果视图定义中有以下操作，则不能进行视图的更新
* 分组（使用 GROUP BY 和 HAVING）
* 联结
* 子查询
* 并 UNION
* 聚集函数（Min()、Count()、Sum()等）
* DISTINCT
* 导出（计算）列

> 一般情况下，应该将视图用于检索（`SELECT` 语句），而不用于更新（`INSERT`、`UPDATE` 和 `DELETE`）。




使用视图时，注意如下限制
* `ORDER BY` 可以用在视图中，但如果从该视图检索数据 `SELECT` 中也含有 `ORDER BY`，那么该视图中的 `ORDER BY` 将被覆盖。
* 视图不能索引，也不能有关联的触发器或默认值。



### 临时表
MySQL 临时表在我们需要保存一些临时数据时是非常有用的。临时表只在当前连接可见，当关闭连接时，MySQL 会自动删除表并释放所有空间。

临时表在 MySQL 3.23 版本中添加，如果你的 MySQL 版本低于 3.23 版本就无法使用 MySQL 的临时表。

```s
CREATE TEMPORARY TABLE table_name(...);
```

默认情况下，当你断开与数据库的连接后，临时表就会自动被销毁。当然你也可以在当前 MySQL 会话使用 `DROP TABLE` 命令来手动删除临时表。



在 MySQL中，使用 `create temporary table` 语句创建临时表后，使用 `show tables` 语句是无法查看到临时表的，此时可以通过 `describe/desc` 或 `show create table` 语句来查看临时表的表结构，来确定临时数据表是否创建成功。





### 反引号

* ref 1-[在mysql语句中为什么要加反引号 | blog](https://www.cnblogs.com/yangzailu/p/6694000.html)

SQL 语句中，为了区分保留字与普通字符，引入了反引号。所以为了安全起见，可以在表名和字段名上都加上反引号。

```sql
create table `test` (
    `desc` varchar(255)
);
```



## 存储引擎



MySQL中常用的存储引擎有
1. InnoDB
2. MyISAM 
3. Memory
   * 功能等同于 MyISAM，但由于数据存储在内存（不是磁盘）中，速度很快，特别适合于临时表
4. Archive
5. CSV


**需要注意的是，引擎可以混用，但是外键不能跨引擎。** 即，使用一个引擎的表，不能引用具有使用不同引擎的表的外键。

### InnoDB引擎
* 支持事务
* 锁级别为行锁，比 MyISAM 存储引擎支持更高的并发
* 能够通过二进制日志恢复数据
* 支持外键操作
* 在索引存储上，索引和数据存储在同一个文件中，默认按照 B+Tree 组织索引的结构。同时，主键索引的叶子节点存储完整的数据记录，非主键索引的叶子节点存储主键和索引列
* 在 MySQL 5.6 版本之后，默认使用 InnoDB 存储引擎
* 在 MySQL 5.6 版本之后，InnoDB 存储引擎支持全文索引

### MyISAM引擎
* 不支持事务
* 锁级别为表锁，在要求高并发的场景下不太适用
* 如果数据文件损坏，难以恢复数据
* 不支持外键
* 在索引存储上，索引文件和数据文件分离
* 支持全文索引


## Expalin

* ref 1-[explain的使用](https://mp.weixin.qq.com/s?__biz=MzU2MDY0NDA1MQ==&mid=2247492577&idx=1&sn=840ff9114765958706a0c62efe5f83a9&scene=21#wechat_redirect)

