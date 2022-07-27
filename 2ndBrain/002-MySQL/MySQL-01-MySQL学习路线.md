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




## MySQL面试集锦

* [MySQL六十六问，两万字+五十图详解](https://mp.weixin.qq.com/s/zSTyZ-8CFalwAYSB0PN6wA)


### 数据库一定要自增主键吗

* ref 1-[数据库主键一定要自增吗 | 掘金](https://juejin.cn/post/7111616533042429959)


有没有建议主键不自增的场景
1. MySQL 分库分表下的 id。自增和递增不同，自增是每次+1，递增场景下每次不一定是加1。
2. 用户 id 不建议自增 id
3. 若不指定主键，InnoDB 存储引擎下，引擎内部会帮你生成一个名为 `ROW_ID` 列，它是个 6 字节的隐藏列，你平时也看不到它，但实际上，它也是自增的。有了这层兜底机制保证，数据表肯定会有主键和主键索引。

### 数据库的三大范式


> 第一范式：列不可再分。
> 
> 第二范式：行可以唯一区分，主键约束 。
> 
> 第三范式：表的非主属性不能依赖与其他表的非主属性、外键约束
> 
> 三大范式是一级一级依赖的，第二范式建立在第一范式上，第三范式建立第一第二范式上。




1. 第一范式：数据表中的每一列（每个字段）都不可以再拆分。例如用户表，用户地址还可以拆分成国家、省份、市，这样才是符合第一范式的。
2. 第二范式：在第一范式的基础上，非主键列完全依赖于主键，而不能是依赖于主键的一部分。例如订单表里，存储了商品信息（商品价格、商品类型），那就需要把商品 ID 和订单 ID 作为联合主键，才满足第二范式。
3. 第三范式：在满足第二范式的基础上，表中的非主键只依赖于主键，而不依赖于其他非主键。例如订单表，就不能存储用户信息（姓名、地址）。

三大范式的作用是为了控制数据库的冗余，是对空间的节省，实际上，一般互联网公司的设计都是反范式的，通过冗余一些数据，避免跨表跨库，利用空间换时间，提高性能。



### MySQL怎么存储emoji😊

utf8 编码是不行的，MySQL 中的 utf8 是阉割版的 utf8，它最多只用 3 个字节存储字符，所以存储不了表情。

需要使用 utf8mb4 编码。


```s
alter table blogs modify content text 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci not null;
```



### drop、delete与truncate的区别


三者都表示删除，但是三者有一些差别。


| 比较项 | delete	 | truncate	 | drop  |
|------|-----|------------|-------|
| 类型	| 属于DML |	属于DDL | 属于DDL |
| 回滚	| 可回滚	| 不可回滚	| 不可回滚 |
| 删除内容	| 表结构还在，删除表的全部或者一部分数据行	| 表结构还在，删除表中的所有数据	 | 从数据库中删除表，所有数据行，索引和权限也会被删除 |
| 删除速度	| 删除速度慢，需要逐行删除	| 删除速度快	| 删除速度最快 |

因此，在不再需要一张表的时候，用 drop；在想删除部分数据行时候，用delete；在保留表而删除所有数据的时候用 truncate。



### count(1)、count(*)与count(col)

* ref 1-[count(1)、count(*)与count(col)的执行区别](https://mp.weixin.qq.com/s/tVCr7QaxJCzVCTTGpshm5g)


三者区别如下
1. `count(col)` 只计数列名为 `col` 的这一列，并且会忽略列值为 `NULL` 的情况，即某个值为 `NULL` 时，不统计。`count(1)` 和 `count(*)` 则会统计值为 `NULL` 的情况。
2. `count(1)` 和 `count(*)` 并无较大区别。如果表中有多个列并且没有主键，则 `count(1)` 的执行效率高于 `count(*)`。
3. 如果表有主键且 `col` 为主键，则 `count(col)` 的效率是最高的。




### JDBC的4个步骤

* ref 1-[JDBC 连接数据库的基本步骤](https://blog.csdn.net/qq_38749759/article/details/88529115)

JDBC 是 JAVA 中连接 MySQL 数据库的驱动，我们可以使用编程语言来实现它，其实它的实现是固定的，分为下面几个步骤
1. 加载 JDBC 驱动程序
   * 在连接数据库之前，首先要加载想要连接的数据库的驱动到 JVM
   * 可以通过 `java.lang.Class` 类的静态方法 `forName(String className)` 实现。如下代码所示，成功加载后，会将 Driver 类的实例注册到DriverManager 类中。

```java
try{
   //加载MySql的驱动类
   Class.forName("com.mysql.jdbc.Driver") ;
} catch(ClassNotFoundException e){
   System.out.println("找不到驱动程序类 ，加载驱动失败！");
   e.printStackTrace() ;
}
```

2. 提供 JDBC 连接的 URL
   * 连接 URL 定义了连接数据库时的协议、子协议、数据源标识，书写形式为 `协议:子协议:数据源标识`
   * 协议：在 JDBC 中总是以 jdbc 开始
   * 子协议：是桥连接的驱动程序或是数据库管理系统名称
   * 数据源标识：标记找到数据库来源的地址与连接端口



3. 创建数据库的连接
   * 要连接数据库，需要向 `java.sql.DriverManager` 请求并获得 `Connection` 对象，该对象就代表一个数据库的连接。
   * 使用 `DriverManager` 的 `getConnectin(String url , String username,String password)` 方法传入指定的欲连接的数据库的路径、数据库的用户名和密码来获得。
4. 创建一个 Statement 对象。要执行 SQL 语句，必须获得 `java.sql.Statement` 实例，`Statement` 实例分为以下 3 种类型
* 执行静态 SQL 语句，通常通过 Statement 实例实现
* 执行动态 SQL 语句，通常通过 PreparedStatement 实例实现
* 执行数据库存储过程，通常通过 CallableStatement 实例实现

```java
Statement stmt = con.createStatement() ;

PreparedStatement pstmt = con.prepareStatement(sql) ;

CallableStatement cstmt = con.prepareCall("{CALL demoSp(?,?)}");
```


5. 执行 SQL 语句。Statement 接口提供了三种执行 SQL 语句的方法，`executeQuery`、`executeUpdate` 和 `execute`


```java
// 执行查询数据库的 SQL 语句，返回一个结果集（ResultSet）对象
ResultSet executeQuery(String sqlString)：

// 用于执行INSERT、UPDATE 或 DELETE 语句以及 SQL DDL 语句，如 CREATE TABLE和DROP TABLE 等
int executeUpdate(String sqlString)：


// 用于执行返回多个结果集、多个更新计数或二者组合的语句
execute(sqlString)
```


6. 处理结果，可分为两种情况
   * 执行更新返回的是本次操作影响到的记录数
   * 执行查询返回的结果是一个 ResultSet 对象
7. 关闭 JDBC 对象。操作完成以后要把所有使用的 JDBC 对象全都关闭，以释放JDBC 资源，关闭顺序和声明顺序相反。
   * 关闭记录集（`ResultSet`）
   * 关闭声明（`Statement`）
   * 关闭连接对象（`Connection`）




### SELECT COUNT(*) FROM table 在 InnoDB 比 MyISAM 慢

对于 `SELECT COUNT(*) FROM table` 语句，在没有 `WHERE` 条件的情况下，InnoDB 比 MyISAM 可能会慢很多，尤其在大表的情况下。因为 InnoDB 是去实时统计结果，会全表扫描；而 MyISAM 内部维持了一个计数器，预存了结果，所以直接返回即可。


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



> UTC 时间
* UTC（Coodinated Universal Time），协调世界时，又称世界统一时间、世界标准时间、国际协调时间。由于英文（CUT）和法文（TUC）的缩写不同，作为妥协，简称 UTC。、
* UTC 是现在全球通用的时间标准，全球各地都同意将各自的时间进行同步协调。UTC 时间是经过平均太阳时（以格林威治时间 GMT 为准）、地轴运动修正后的新时标以及以秒为单位的国际原子时所综合精算而成。



### date和datetime、timestamp的区别

* `date` 保存精度到天，格式为 `YYYY-MM-DD`。`datetime` 和 `timestamp` 精度保存到秒，格式为 `YYYY-MM-DD HH:MM:SS`。因此如果只需保存到天的字段（如生日），用 `date` 就可以了。

### datetime、timestamp的区别

* ref 1-[MySQL date、datetime和timestamp类型的区别](https://zhuanlan.zhihu.com/p/23663741)




两者相同点是
1. 两个数据类型存储时间的表现格式一致，均为 `YYYY-MM-DD HH:MM:SS`
2. 两个数据类型都包含「日期」和「时间」部分。
3. 两个数据类型都可以存储微秒的小数秒（秒后 6 位小数秒）


两者区别是
1. 「受时区影响不同」
   * `timestamp` 会跟随设置的时区变化而变化，值会从「当前时间」转换成 UTC 时间，或者反过来转换
   * `datetime` 保存的是绝对值，不会变化，值不会做任何转换，也不会检测时区
2. 占用存储空间不同
   * `timestamp` 储存占用 4 个字节，是以 utc 的格式储存， 它会自动检索当前时区并进行转换
   * `datetime` 储存占用 8 个字节，不会进行时区的检索
3. 可表示的时间范围不同
   * `timestamp` 可表示范围 `1970-01-01 00:00:00 ~ 2038-01-09 03:14:07`，`timestamp` 可表示的时间范围要小一些。
   * `datetime` 支持的范围更宽，`1000-01-01 00:00:00 ~ 9999-12-31 23:59:59`。
4. 索引速度不同
   * timestamp 更轻量，索引相对 datetime 更快
5. 默认值不同
   * DATETIME 的默认值为 null
   * TIMESTAMP 的字段默认不为空（not null），默认值为当前时间（CURRENT_TIMESTAMP）

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


### char和varchar的区别
* ref 1-[varchar和char的的区别是什么 | 腾讯云](https://cloud.tencent.com/developer/article/1793497)


`char` 和 `varchar` 的区别主要体现在三个方面
1. 是否固定长度的区别
2. 查询效率的区别
3. 存储方式的区别

| 类型 | 是否定长  | 存储长度 |  查询效率  |
|------|--------|----------|-----------|
| `char` | 是，空余处用空格填充 | `char(n)` 中 n 取值为 0~255 | 用空间换时间，查询效率高 |
| `varchar` | 否，长度不固定 | `varchar(n)` 中 n 取值为 0~65535 | 保证空间效率，查询效率低于 `char` |


> **对效率要求高用 `char`，对空间使用要求高用 `varchar`。**

下面进行具体介绍。


> 1. `char` 的长度是不可变的，而 `varchar`的长度是可变的
* `char` 类型的字段长度是固定的，为创建表时声明的字段长度，最小取值为 0，最大取值为 255。
* 如果保存时，数据的实际长度比 `char` 类型声明的长度小，则会在右侧填充空格以达到指定的长度。
* 当 MySQL 检索 `char` 类型的数据时，`char` 类型的字段会去除尾部的空格
* 对于 `char` 类型的数据来说，定义 `char` 类型字段时，声明的字段长度即为  `char` 类型字段所占的存储空间的字节数。
* `varchar` 类型修饰的字符串是一个可变长的字符串，长度的最小值为 0，最大值为 65535。
* 检索 `varchar` 类型的字段数据时，会保留数据尾部的空格。
* `varchar` 类型的字段所占用的存储空间为字符串实际长度加 1 个字节。


> 2. `char` 的存取速度还是要比 `varchar` 要快得多，因为其长度固定，方便程序的存储与查找。 
* `char` 是以空间换时间，追求效率，但也为此付出了空间的代价
* `varchar`是以空间效率为首位


> 3. 存储方式的区别
* `char` 中，对英文字符（ASCII）占用 1 个字节，对一个汉字占用 2 个字节。
* `varchar` 中，对每个英文字符占用 2 个字节，汉字也占用 2 个字节。



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



### blob和text的区别

1. blob 用于存储二进制数据，而 text 用于存储大字符串。
2. blob 没有字符集，text 有一个字符集，并且根据字符集的校对规则对值进行排序和比较。


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



### `<>`、`!=` 不等于

**`<>` 和 `!=` 都可以表示不等于，但是只有 `<>` 是标准的 SQL 语法，可以移植。所以开发中，尽量使用 `<>` 表示不等于。**


### `<=>` 等于

* ref 1-[MySQL运算符 `!=` 和 `＜＞` 以及 `=` 和 `＜=＞` 的区别](https://cloud.tencent.com/developer/article/1821235)



对于等于的判断，有 3 种
1. `IS`
   * 用于 `NULL` 的判断 
2. `=`
   * 用于非 `NULL` 的判断 
3. `<=>`
   * `<=>` 同时具有 `IS` 和 `=` 的功能
   * `<=>` 只用于 MySQL 数据库
   * `username <=> NULL` 等价 `username is NULL`
   * `NOT(username <=> NULL)` 等价 `username is NOT NULL`



此处给出一个示例，加深理解，可以在 [LeetCode-584. 寻找用户推荐人](https://leetcode.cn/problems/find-customer-referee/) 测试练习。



给定表 `customer`，里面保存了所有客户信息和他们的推荐人。


```sql
+------+------+-----------+
| id   | name | referee_id|
+------+------+-----------+
|    1 | Will |      NULL |
|    2 | Jane |      NULL |
|    3 | Alex |         2 |
|    4 | Bill |      NULL |
|    5 | Zack |         1 |
|    6 | Mark |         2 |
+------+------+-----------+
```

请书写一个查询语句，返回一个客户列表，列表中客户的推荐人的编号都不是 2。对于上述测试用例，返回的结果如下（注意，包含 `referee_id` 为 `NULL` 的行）。


```s
+------+
| name |
+------+
| Will |
| Jane |
| Bill |
| Zack |
+------+
```


**对于该测试场景，很容易写出如下语句。`referee_id <> 2` 不仅为排除该列值不等于 2 的记录，还会排除该列值为 `NULL` 的情况。所以，最终实现中，需要包含 `referee_id IS NULL`。**

```sql
SELECT 
   name 
FROM 
   customer 
WHERE 
   referee_id <> 2 OR referee_id IS NULL;
```


此外还有一种写法，就是结合 `NOT` 进行取反。

```sql
SELECT 
   name 
FROM 
   customer 
WHERE 
   NOT referee_id <=> 2;
```



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



**但是，并非所有视图都是可更新的。基本上可以说，如果 MySQL 不能正确地确定被更新的基数据，则不允许更新（包括插入和删除）。这实际上意味着，如果视图定义中有以下操作，则不能进行视图的更新**
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



### EXISTS

* [MySQL中EXISTS的用法 | Blog](https://www.cnblogs.com/qlqwjy/p/8598091.html)

EXISTS 用于检查子查询是否至少会返回一行数据，该子查询实际上并不返回任何数据，而是返回值 `true` 或 `false`。EXISTS 指定一个子查询，检测「行」的存在。


给定两个表，用于演示 `EXISTS` 的用法。

```s
# TableIn
| AID | ANAME | ASEX |
| 1   | 张金娟 |  女  |
| 2   | 张翠兰 |  女  |
| 3   | 李海滨 |  男  |
| 4   | 马艳艳 |  女  |
| 5   | 邓诗文 |  女  |

# TableEx
| BID | BNAME | BAddress |
| 1   | 马艳艳 |  太原  |
| 2   | 谭建军 |  长沙  |
| 3   | 李红军 |  长沙  |
| 4   | 丁秀娟 |  北京  |
| 5   | 邓诗文 |  深圳  |
```


1. 在子查询中使用 `NULL`，仍然返回结果集

```s
select * from TableIn where exists(select null)
# 等同于
select * from TableIn
```

对应的查询结果如下。

```s
# TableIn
| AID | ANAME | ASEX |
| 1   | 张金娟 |  女  |
| 2   | 张翠兰 |  女  |
| 3   | 李海滨 |  男  |
| 4   | 马艳艳 |  女  |
| 5   | 邓诗文 |  女  |
```


2. 比较使用 EXISTS 和 IN 的查询。注意两个查询返回相同的结果。

```s
select * from TableIn 
   where exists
      (select BID from TableEx where BNAME=TableIn.ANAME)

# 等同于
select * from TableIn 
   where ANAME in (select BNAME from TableEx)
```


对应的查询结果如下。

```s
# TableIn
| AID | ANAME | ASEX |
| 4   | 马艳艳 |  女  |
| 5   | 邓诗文 |  女  |
```



### ESITS和IN的区别
* [书写高质量SQL的30条建议](https://mp.weixin.qq.com/s?__biz=Mzg3NzU5NTIwNg==&mid=2247487972&idx=1&sn=cd035a7fcd7496658846ab9f914be2db&chksm=cf21cecdf85647dbc53e212bf1a2b95d0eb2bffe08dc0141e01f8a9b2088abffc385a2ef584e&token=1495321435&lang=zh_CN&scene=21#wechat_redirect)




假设表 A 表示某企业的员工表，表 B 表示部门表，查询所有部门的所有员工，很容易有以下SQL。

```sql
select * 
from A 
where
   deptId 
in ( select deptId from B);
```


这样写等价于

```s
先查询部门表B

select deptId from B

再由部门deptId，查询A的员工

select * from A where A.deptId = B.deptId
```

可以抽象成这样的一个循环。

```java
List<> resultSet;
 
for(int i=0;i<B.length;i++){
   for(int j=0;j<A.length;j++){
      if(A[i].id == B[j].id){
         resultSet.add(A[i]);
         break;
      }
   }
}
```

显然，除了使用 in，我们也可以用 exists 实现一样的查询功能，如下

```s
select * from  A where
exists (select 1 from  B where  A.deptId = B.deptId);
```
因为 exists 查询的理解就是，先执行主查询，获得数据后，再放到子查询中做条件验证，根据验证结果（true或者false），来决定主查询的数据结果是否得意保留。

那么，这样写就等价于

```s
select * from A，先从A表做循环

select * from B where A.deptId = B.deptId，再从B表做循环
```

可以抽象成这样的一个循环。

```java
List<> resultSet;
 
for(int i=0;i<A.length;i++){
   for(int j=0;j<B.length;j++){
      if(A[i].deptId == B[j].deptId){
         resultSet.add(A[i]);
         break;
      }
   }
}
```

数据库最费劲的就是跟程序链接释放。假设链接了两次，每次做上百万次的数据集查询，查完就走，这样就只做了两次；相反建立了上百万次链接，申请链接释放反复重复，这样系统就受不了了。即 MySQL 优化原则，就是小表驱动大表，小的数据集驱动大的数据集，从而让性能更优。

**因此，我们要选择最外层循环小的，也就是，如果B的数据量小于 A，适合使用 in，如果B的数据量大于 A，即适合选择 exist。**




### DENSE_RANK()

* [MySQL DENSE_RANK() 函数](https://www.begtut.com/mysql/mysql-dense_rank-function.html)

`DENSE_RANK()` 是一个窗口函数，它为分区或结果集中的每一行分配排名，而排名值没有间隙。

行的等级从行前的不同等级值的数量增加 1。

`DENSE_RANK()` 函数的语法如下。

```sql
DENSE_RANK() OVER (
    PARTITION BY <expression>[{,<expression>...}]
    ORDER BY <expression> [ASC|DESC], [{,<expression>...}]
)
```

在这个语法中
1. 首先，PARTITION BY 子句将 FROM 子句生成的结果集划分为分区。`DENSE_RANK()` 函数应用于每个分区。
2. 其次，`ORDER BY` 子句指定 `DENSE_RANK()` 函数操作的每个分区中的行顺序。


如果分区具有两个或更多具有相同排名值的行，则将为这些行中的每一行分配相同的排名。

**与 `RANK()` 函数不同，`DENSE_RANK()` 函数始终返回连续的排名值。**

假设我们有一个 `t` 包含一些样本数据的表，如下所示。

```s
CREATE TABLE rankDemo (
    val INT
);
 
INSERT INTO rankDemo(val)
VALUES(1),(2),(2),(3),(4),(4),(5);
```


```sql
# 查询
SELECT 
    *
FROM
    rankDemo; 

# 结果

+------+
| val  |
+------+
|    1 |
|    2 |
|    2 |
|    3 |
|    4 |
|    4 |
|    5 |
+------+
7 rows in set (0.02 sec)
```


下面，使用 `DENSE_RANK()` 函数为每行分配排名。

```sql
SELECT
    val,
    DENSE_RANK() OVER (
        ORDER BY val
    ) my_rank
FROM
    rankDemo;
```

查询结果如下。

```s
+------+---------+
| val  | my_rank |
+------+---------+
|    1 |       1 |
|    2 |       2 |
|    2 |       2 |
|    3 |       3 |
|    4 |       4 |
|    4 |       4 |
|    5 |       5 |
+------+---------+
7 rows in set (0.03 sec)
```

可以看到，第 2 行和第 3 行的排名都是 2，并且下一个排名是 3，不是 4。（这点和 RANK() 函数结果不同）



下面，使用 `RANK()` 函数为每行分配排名。


```sql
SELECT
    val,
    RANK() OVER (
        ORDER BY val
    ) my_rank
FROM
    rankDemo; 
```


查询结果如下。

```s
+------+---------+
| val  | my_rank |
+------+---------+
|    1 |       1 |
|    2 |       2 |
|    2 |       2 |
|    3 |       4 |
|    4 |       5 |
|    4 |       5 |
|    5 |       7 |
+------+---------+
7 rows in set (0.02 sec)
```

如您所见，第二行和第三行具有相同的关系，因此它们获得相同的等级 2。第四行具有等级 4，因为 `RANK()` 功能跳过等级 3。






## MySQL函数
* [MySQL 函数 | 易百教程](https://www.yiibai.com/mysql/functions.html)


> MySQL聚合函数

1. avg() 函数 - 计算一组值或表达式的平均值。
2. count()函数 - 计算表中的行数。
3. instr()函数 - 返回子字符串在字符串中第一次出现的位置。
4. sum()函数 - 计算一组值或表达式的总和。
5. min()函数 - 在一组值中找到最小值。
6. max()函数 - 在一组值中找到最大值。
7. group_concat()函数 - 将字符串从分组中连接成具有各种选项（如DISTINCT，ORDER BY和SEPARATOR）的字符串。
8. MySQL标准偏差函数 - 显示如何计算人口标准偏差和样本标准偏差。


> MySQL 字符串函数
1. concat()函数 - 将两个或多个字符串组合成一个字符串。
2. length()函数 & char_length()函数 - 以字节和字符获取字符串的长度。
3. left()函数 - 获取指定长度的字符串的左边部分。
4. replace()函数 - 搜索并替换字符串中的子字符串。
5. substring()函数 - 从具有特定长度的位置开始提取一个子字符串。
6. trim()函数 - 从字符串中删除不需要的字符。
7. find_in_set()函数 - 在逗号分隔的字符串列表中找到一个字符串
8. format()函数 - 格式化具有特定区域设置的数字，舍入到小数位数。

> MySQL 控制流函数
1. case()函数 - 如果满足 WHEN 分支中的条件，则返回 THEN 分支中的相应结果，否则返回 ELSE 分支中的结果。
2. if语句 - 根据给定的条件返回一个值。
3. ifnull()函数 - 如果第一个参数不为NULL，则返回第一个参数，否则返回第二个参数。
4. nullif()函数 - 如果第一个参数等于第二个参数，则返回 NULL，否则返回第一个参数。


> MySQL 日期和时间函数
1. curdate()函数 - 返回当前日期。
2. datediff()函数 - 计算两个 DATE 值之间的天数。
3. day()函数 - 获取指定日期月份的天(日)。
4. date_add()函数 - 将时间值添加到日期值。
5. date_sub()函数 - 从日期值中减去时间值。
6. date_format()函数 - 根据指定的日期格式格式化日期值。
7. dayname()函数 - 获取指定日期的工作日的名称。
8. dayofweek()函数 - 返回日期的工作日索引。
9. extract()函数 - 提取日期的一部分。
10. now()函数 - 返回当前日期和时间。
11. month()函数 - 返回一个表示指定日期的月份的整数。
12. str_to_date()函数 - 将字符串转换为基于指定格式的日期和时间值
13. sysdate()函数 - 返回当前日期。
14. timediff()函数 - 计算两个TIME或DATETIME值之间的差值
15. timestampdiff()函数 - 计算两个DATE或DATETIME值之间的差值
16. week()函数 -  返回一个日期的星期数值。
17. weekday()函数 - 返回一个日期表示为工作日/星期几的索引。
18. year()函数 - 返回日期值的年份部分。

> MySQL 比较函数
1. coalesce()函数 - 返回第一个非 NULL 参数，这非常适合用于将值替换为 NULL。
2. greatest()函数 & least()函数 – 使用 n 个参数，并分别返回 n 个参数的最大值和最小值。
3. isnull()函数 - 如果参数为 NULL，则返回 1，否则返回 0。
   
> 其他 MySQL 函数
1. last_insert_id()函数 - 获取最后插入的记录的最后生成的序列号
2. cast()函数 - 将任何类型的值转换为具有指定类型的值。




### CASE...WHEN...THEN

* ref 1-[MySQL CASE表达式简介](https://www.yiibai.com/mysql/case-function.html)


CASE 表达式是一个流控制结构，允许您在查询中构造条件。MySQL 为您提供了两种形式的 CASE 表达式。

* 第 1 种形式

```sql
CASE value
WHEN compare_value_1 THEN result_1
WHEN compare_value_2 THEN result_2
...
ELSE result END
```

* 第 2 种形式

```sql
CASE
WHEN condition_1 THEN result_1
WHEN condition_2 THEN result_2
...
ELSE result END
```

下面结合一个示例加深理解。

参考 [LeetCode-627. 变更性别](https://leetcode.cn/problems/swap-salary/)，Salary 表的结构如下。其中，`sex` 列只为 `'m'` 或 `'f'`。


```s
+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| id          | int      |
| name        | varchar  |
| sex         | ENUM     |
| salary      | int      |
+-------------+----------+
```

请你编写一个 SQL 查询来交换所有的 `'f'` 和 `'m'`，仅使用 单个 update 语句，且不产生中间临时表。


可使用 CASE 表达式实现。

```sql
UPDATE salary
SET  
    sex = (
        CASE sex
            WHEN 'm' THEN 'f'
            ELSE 'm'
        END
    )
;
```


### IF(expr,v1,v2)

* [LeetCode-1873. 计算特殊奖金](https://leetcode.cn/problems/calculate-special-bonus/)


表 Employees 的信息如下。

```s
+-------------+---------+
| 列名        | 类型     |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
| salary      | int     |
+-------------+---------+
```

写出一个 SQL 查询语句，计算每个雇员的奖金。如果一个雇员的 id 是奇数并且他的名字不是以 'M' 开头，那么他的奖金是他工资的 100%，否则奖金为 0。


**在实现时，可以使用 `IF(expr,v1,v2)` 表达式。**

* 使用 `NOT LIKE`
  
```sql
SELECT  
    employee_id,
    IF(employee_id%2 = 1 AND name NOT LIKE "M%",salary,0) AS bonus
FROM
    Employees
ORDER BY
    employee_id;
```

* 使用 `LEFT(str,length)`

> `LEFT(str,length);` 是一个字符串函数，它返回具有指定长度的字符串的左边部分。

```sql
SELECT  
    employee_id,
    IF(employee_id%2 = 1 AND LEFT(name,1) <> 'M',salary,0) AS bonus
FROM
    Employees
ORDER BY
    employee_id;
```


### CONCAT()

`CONCAT()` 可以将两个字符串连接在一起。

例如，将 MySQL 中名称 `name` 字段变为只有第一个字母大写的格式，可在 [LeetCode-1667. 修复表中的名字](https://leetcode.cn/problems/fix-names-in-a-table/) 自测。


```sql
SELECT user_id, CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2))) AS name
FROM Users
ORDER BY user_id
```

### GROUP_CONCAT
* ref 1-[MySQL group_concat() 函数](https://www.yiibai.com/mysql/group_concat.html)

参考 [1484. 按日期分组销售产品](https://leetcode.cn/problems/group-sold-products-by-the-date/)，掌握 `GROUP_CONCAT()` 的使用。


```sql

SELECT
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(DISTINCT product ORDER BY product ASC SEPARATOR ',') AS products
FROM 
    Activities
GROUP BY  sell_date
ORDER BY sell_date;
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
* 既支持表锁，也支持行锁
* 能够通过二进制日志恢复数据
* 支持外键操作
* 在索引存储上，索引和数据存储在同一个文件中，默认按照 B+Tree 组织索引的结构。同时，主键索引的叶子节点存储完整的数据记录，非主键索引的叶子节点存储主键和索引列
* 在 MySQL 5.6 版本之后，默认使用 InnoDB 存储引擎
* 在 MySQL 5.6 版本之后，InnoDB 存储引擎支持全文索引

### MyISAM引擎
* 不支持事务
* 锁级别为表锁，在要求高并发的场景下不太适用
* 不支持行锁
* 如果数据文件损坏，难以恢复数据
* 不支持外键
* 在索引存储上，索引文件和数据文件分离
* 支持全文索引


### InnoDB和MyISAM的区别

> 1. 存储结构
* 每个 MyISAM 在磁盘上存储成三个文件，索引和数据是分开到两个文件中。
* InnoDB 所有的表都保存在同一个数据文件中，索引和数据存储在同一个文件。
* InnoDB表的大小只受限于操作系统文件的大小，一般为 2GB。

> 2. 事务支持
* MyISAM不提供事务支持。
* InnoDB 提供事务支持事务，具有事务（commit）、回滚（rollback）和崩溃修复能力（crash recovery capabilities）的事务安全特性。

> 3. 最小锁粒度
* MyISAM 只支持表级锁，更新时会锁住整张表，导致其它查询和更新都会被阻塞。
* InnoDB 支持行级锁，也支持表级锁。


> 5. 主键必需
* MyISAM 允许没有任何索引和主键的表存在
* InnoDB 如果没有设定主键或者非空唯一索引，**就会自动生成一个 6 字节的主键(用户不可见)**，数据是主索引的一部分，附加索引保存的是主索引的值。

> 6. 表的具体行数
* MyISAM 保存了表的总行数，如果 `select count(*) from table;` 会直接取出出该值。
* InnoDB 没有保存表的总行数

> 7. 外键支持
* MyISAM 不支持外键。
* InnoDB 支持外键。

> 8. 非聚集索引在叶子节点存储的内容是
* InnoDB 存储引擎中，非聚集索引在叶子节点存储的是聚集索引的值
* MyISAM 存储引擎中，非聚集索引在叶子节点存储的是记录指针


### 如何选择存储引擎

* 如果对数据一致性要求比较高，需要事务支持，可以选择 InnoDB。
* 如果数据查询多更新少，对查询性能要求比较高，可以选择 MySIAM（支持表锁，不支持行锁）。
* 如果需要一个用于查询的临时表，可以选择 Memory（数据存储在内存中）。


| 功能	| MylSAM	 | MEMORY	| InnoDB | 
|-------|---------|----------|--------|
| 存储限制	|  256TB	 | RAM	|  64TB | 
| 支持事务	|  No	|  No	 | Yes | 
| 支持全文索引	|  Yes	| No	|  Yes | 
| 支持树索引	|  Yes	| Yes	| Yes| 
| 支持哈希索引	| No	| Yes | Yes | 
| 支持数据缓存	| No	| N/A	| Yes | 
| 支持外键	| No	| No | 	Yes |

MySQL 5.5 之前，默认存储引擎是 MyISAM，5.5 之后变成了 InnoDB。

> InnoDB 支持的哈希索引是自适应的，InnoDB 会根据表的使用情况自动为表生成哈希索引，不能人为干预是否在一张表中生成哈希索引。

> MySQL 5.6 开始 InnoD B支持全文索引


## Expalin

* ref 1-[explain的使用](https://mp.weixin.qq.com/s?__biz=MzU2MDY0NDA1MQ==&mid=2247492577&idx=1&sn=840ff9114765958706a0c62efe5f83a9&scene=21#wechat_redirect)
* ref 2-「《MySQL是怎样运行的》从根儿上理解 MySQL」




`explain` 是一个分析 SQL 执行的命令。在 MySQL 5.6 之前，只能对 `select` 语句进行分析，5.6 版本后，对 `update`、`insert` 等语句也可以进行分析。


下面先给出一个 MySQL 8 版本中的 `expalin` 的查询内容。

```s
mysql> select version();
+-----------+
| version() |
+-----------+
| 8.0.29    |
+-----------+
1 row in set (0.00 sec)



mysql> explain select * from user;
+----+-------------+-------+------------+-------+---------------+--------------+---------+------+------+----------+-------------+
| id | select_type | table | partitions | type  | possible_keys | key          | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-------+------------+-------+---------------+--------------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | user  | NULL       | index | NULL          | name_age_idx | 66      | NULL |    4 |   100.00 | Using index |
+----+-------------+-------+------------+-------+---------------+--------------+---------+------+------+----------+-------------+
1 row in set, 1 warning (0.00 sec)
```



可以看到，`explain` 的输出结果包括
1. id
2. select_type
3. table
4. partitions
5. type
6. possible_keys
7. key
8. key_len
9. ref
10. rows
11. filtered
12. Extra




|  列名	|        描述             |
|------|-------------------------|
| id	| 在一个大的查询语句中每个SELECT关键字都对应一个唯一的id | 
| select_type | SELECT 关键字对应的那个查询的类型 | 
| table | 	表名 | 
| partitions | 匹配的分区信息 | 
| type	|  针对单表的访问方法 | 
| possible_keys | 	可能用到的索引 | 
| key	|  实际上使用的索引 | 
| key_len | 实际使用到的索引长度 | 
| ref	|  当使用索引列等值查询时，与索引列进行等值匹配的对象信息 | 
| rows | 预估的需要读取的记录条数 | 
| filtered | 某个表经过「条件过滤」后剩余记录条数的百分比 | 
| Extra	 | 一些额外的信息 | 


下面对输出结果进行必要的介绍。


### 1. id
* id 列是一组数字，表示 sql 语句中 select 的执行顺序。有几个 select 就有几个 id，按照 select 出现的顺序呈现结果。
* id 值相同时，执行顺序由上而下。
* id 值不同时，序号会递增。值越大优先级越高，就越先执行。


### 2. select_type

`select_type` 表示 `select` 查询的类型，主要包括

1. `simple`：简单查询
   * 查询不包含子查询和 `union`，比如上面简介中演示的语句
2. `primary`
   * 跟上面相反，如果查询包含子查询和 `union`，就会被标记为 `primary`
3. `subquery`
   * 子查询，包含在 select 中的子查询（不在 from 子句中）
4. `derived`
   * 在 from 子句中子查询，MySQL 会将结果存放在一个「临时表」中，也称为派生表（`derived` 有派生的意思）

重点掌握前 4 中查询类型，下面还有几种查询类型，了解即可。

5. `union`
   * 表示此查询是 `union` 中的第二个或随后的查询
6. `union result`
   * 从 union 临时表检索结果的 select
7. `dependent union`
   * 此查询是 union 中的第二个或随后的查询，并且取决于外面的查询
8. `uncacheable union`
   * 此查询是 union 中的第二个或随后的查询，同时意味着 select 中的某些特性阻止结果被缓存于一个 `item_cache` 中\
9. `dependent subquery`
   * 子查询中的第一个 select，同时取决于外面的查询
10. `uncacheable subquery`
    * 子查询中的第一个 select，同时意味着 select 中的某些特性阻止结果被缓存于一个 `item_cache` 中



### 3. table

* 表示 explain 的一行访问的表是哪一个。
* 当 from 子句中有子查询时，table 列是 `<derivenN>` 格式，表示当前查询依赖 `id=N` 的查询，于是先执行 `id=N` 的查询
* 当有 union 时，`UNION RESULT` 的 table 列的值为 `<union1,2>`，1 和 2 表示参与 union 的 select 行 id




### 4. partitions

匹配的分区信息。

### 5. type

`type` 结果是表关联类型或访问类型。也是 `explain` 分析结果中很重要的一列，可用来判断查询是否高效。

**`type` 的结果有很多，性能从最优到最差为 `sytem` > `const` > `eq_ref` > `ref` > `fulltext` > `ref_or_null` > `index_merge` > `unique_subquery` > `index_subquery` > `range` > `index` > `ALL`。**


1. sytem
   * 当表中只有一条记录，并且该表使用的存储引擎的统计数据是精确的，比如 MyISAM、Memory，那么对该表的访问方法就是 system
   * system 是 const 类型的特例
2. const
   * 当我们根据主键或者唯一二级索引列与常数进行等值匹配时，对单表的访问方法就是 const
3. eq_ref
   * 在使用唯一性索引或主键查找时会出现该值，非常高效
   * 索引查找，并且最多只返回一条符合条件的记录
   * 在连接查询时，如果被驱动表是通过主键或者唯一二级索引列等值匹配的方式进行访问的（如果该主键或者唯一二级索引是联合索引的话，所有的索引列都必须进行等值比较），则对该被驱动表的访问方法就是 eq_ref
4. ref
   * 索引查找，索引要和某个值相比较，可能会找到多个符合条件的行
   * 不使用唯一索引，使用普通索引或者唯一性索引的部分前缀
5. fulltext
   * 全文索引
6. ref_or_null
   * 当对普通二级索引进行等值匹配查询，该索引列的值也可以是 NULL 值时，那么对该表的访问方法就可能是 ref_or_null
7. index_merge
   * 表示使用了索引合并
8. unique_subquery
9.  index_subquery
10. range
    * 范围扫描，使用一个索引来检索给定范围的行
    * 通常出现在 `in()`、`between`、`>` 、`<`、`>=` 等操作中
11. index
    * 全索引扫描，跟 ALL 差不多，不同的是 index 是扫描整棵索引树，比 ALL 要快些
12. ALL
    * 全表扫描，性能极差
    * 要尽力避免全表扫描



此处以 `single_table` 为例，对 `type=index` 的情况进行说明。


```s
CREATE TABLE single_table (
    id INT NOT NULL AUTO_INCREMENT,
    key1 VARCHAR(100),
    key2 INT,
    key3 VARCHAR(100),
    key_part1 VARCHAR(100),
    key_part2 VARCHAR(100),
    key_part3 VARCHAR(100),
    common_field VARCHAR(100),
    PRIMARY KEY (id),
    KEY idx_key1 (key1),
    UNIQUE KEY idx_key2 (key2),
    KEY idx_key3 (key3),
    KEY idx_key_part(key_part1, key_part2, key_part3)
) Engine=InnoDB CHARSET=utf8;
```

`single_table` 表结构如上，执行如下 SQL 语句。



```s
mysql> EXPLAIN SELECT key_part2 FROM s1 WHERE key_part3 = 'a';
+----+-------------+-------+------------+-------+---------------+--------------+---------+------+------+----------+--------------------------+
| id | select_type | table | partitions | type  | possible_keys | key          | key_len | ref  | rows | filtered | Extra                    |
+----+-------------+-------+------------+-------+---------------+--------------+---------+------+------+----------+--------------------------+
|  1 | SIMPLE      | s1    | NULL       | index | NULL          | idx_key_part | 909     | NULL | 9688 |    10.00 | Using where; Using index |
+----+-------------+-------+------------+-------+---------------+--------------+---------+------+------+----------+--------------------------+
1 row in set, 1 warning (0.00 sec)
```



上述查询中的搜索列表中只有 `key_part2` 一个列，而且搜索条件中也只有 `key_part3` 一个列，这两个列又恰好包含在 `idx_key_part` 这个索引中，可是搜索条件 `key_part3` 不能直接使用该索引进行 `ref` 或者`range` 方式的访问，只能扫描整个 `idx_key_part` 索引的记录，所以查询计划的 `type` 列的值就是 `index`。


### 6. possible_keys

* 表示 MySQL 执行查询可能会使用那些索引来查找。注意，只是可能使用的索引，不是最终真实使用的索引
* 如果为 `null`，可考虑在该列加个索引


### 7. key

* 表示 MySQL 执行查询实际使用那些索引来查找
* 如果为 null，则表示没有使用索引
* 如果想强制使用或者忽略索引，可以在查询语句加 `force index` 或者 `ignore index`

> 如果 `possible_keys` 有列，而 `key` 显示 `null`，则可能是 MySQL 进行了基于成本的优化，判断使用索引的效率并不如不使用该索引的效率。


### 8. key_len

* 表示在索引里使用的字节数
* 当 key 列的值为 null 时，则该列也是 null


### 9. ref

* 表示哪些字段或者常量，被用来和 key 列记录的索引配合查找值。
* 常见的有 const（常量）、func、null、colName（具体的字段名）


### 10. rows

* 表示 MySQL 估计要读取并检测的行数
* 注意这个不是结果集里的行数，只是个预测的数量


### 11. filtered


在 expalin 的输出中，`rows` 字段表示所选择的索引访问方式预估的扫描记录数，`filtered` 字段反映了条件过滤。

`filtered` 值是一个百分比，表示通过查询条件获取的最终记录行数占通过 `type` 字段指明的搜索方式搜索出来的记录行数的百分比。
1. 最大值是 100，表示没有进行任何过滤
2. 该值越小，说明条件过滤效果越好


举个例子，如果一个 SQL 的执行计划，rows 为 200，filtered 为 10（即 10%），那么最终预估的扫描记录数为 `200*10%` = 20。


关于 `filtered` 的示例，详情见笔记「MySQL-05-MySQL连接和基于成本的优化」中「条件过滤」章节。

### 12. Extra

一些额外信息，常见的包括
1. `Using index` 
   * 使用覆盖索引，表示查询索引就可查到所需数据，不用回表，说明性能不错
2. `Using where`
   * 在存储引擎检索行后再进行过滤，就是先读取整行数据，再按 where 条件进行取舍
3. `Using temporary`
   * MySQL 需要创建一张临时表来处理查询
   * 一般是因为查询语句中有排序、分组、和多表 join 的情况，一般是要进行优化的。
4. `Using filesort`
   * 对结果使用一个外部索引排序，而不是按索引次序从表里读取行
   * 一般若出现该值，都建议优化去掉，因为这样的查询 CPU 资源消耗大

5. 索引合并下，`Extra` 会展示 `Using union` 或 `Using intersect` 或 `Using sort_union`。详情见笔记「MySQL-05-MySQL连接和基于成本的优化」中「条件过滤」章节。

## 一条SQL语句的执行流程
* ref 1-[一条查询SQL语句是如何执行的 | 掘金](https://juejin.cn/post/7094638797077348389)
* ref 2-[一条SQL查询语句是如何执行的](https://learn.lianglianglee.com/%E4%B8%93%E6%A0%8F/MySQL%E5%AE%9E%E6%88%9845%E8%AE%B2/01%20%20%E5%9F%BA%E7%A1%80%E6%9E%B6%E6%9E%84%EF%BC%9A%E4%B8%80%E6%9D%A1SQL%E6%9F%A5%E8%AF%A2%E8%AF%AD%E5%8F%A5%E6%98%AF%E5%A6%82%E4%BD%95%E6%89%A7%E8%A1%8C%E7%9A%84%EF%BC%9F.md)
* ref 3-[一条更新SQL语句是如何执行的 | 掘金](https://juejin.cn/post/7103092370849153061)



### 查询语句的执行过程

首先来看一下在 MySQL 数据库中，一条查询语句是如何执行的，索引出现在哪个环节，起到了什么作用。


![mysql-sql-process-1](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-sql-process-1.png)


1. 应用程序通过连接器跟服务端建立连接
2. 查询缓存，若有缓存则直接返回查询结果
3. 若无缓存，则进行查询优化处理并生成执行计划
（1）分析器进行词法分析和语法分析
（2）优化器进行优化，如决定使用哪个索引或者在多个表相关联的时候决定表的连接顺序等，并生成执行计划
（3）执行器去执行计划，操作存储引擎并返回结果
4. 将查询结果返回客户端


下面进行必要的补充说明。


### MySQL 层级划分

如上图所示，我们可以将 MySQL 划分为三个层级
1. 连接层
2. 服务层（图中的 Server 层）
3. 存储引擎层


### 查询缓存

* ref 1-[聊聊MyBatis缓存机制 | 美团技术](https://tech.meituan.com/2018/01/19/mybatis-cache.html)


**MySQL 内部自带了一个缓存模块，默认关闭。MySQL 8.0 版本中，查询缓存功能已经被移除了。**

MySQL 8.0 版本前，使用 `show global variables like "query_cache%"` 可以查看缓存相关的参数信息，`query_cache_type` 默认只为 `OFF`，即默认缓存查询功能关闭。


对于缓存，我们一般交给 ORM 框架处理，比如 MyBatis 默认开启了一级缓存，或者独立的缓存服务器，比如 Redis。

关于「MyBatis的缓存」，详情见参考资料 *ref-1* 和笔记 [MySQL-08-Mybatis](./MySQL-08-MyBatis.md)。



### 一条更新语句的执行过程

更新语句的执行是 Server 层和引擎层配合完成，数据除了要写入表中，还要记录相应的日志，如下图所示。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/mysql-update-exe-step-1.png)

1. 执行器先找引擎获取 `ID=2` 这一行。ID 是主键，存储引擎检索数据，找到这一行。如果 `ID=2` 这一行所在的数据页本来就在内存中，就直接返回给执行器；否则，需要先从磁盘读入内存，然后再返回。

2. 执行器拿到引擎给的行数据，把这个值加上 1，比如原来是 N，现在就是 N+1，得到新的一行数据，再调用引擎接口写入这行新数据。
   
3. 引擎将这行新数据更新到内存中，同时将这个更新操作记录到 `redo log` 里面，此时 `redo log` 处于 `prepare` 状态。然后告知执行器执行完成了，随时可以提交事务。

4. 执行器生成这个操作的 binlog，并把 binlog 写入磁盘。

5. 执行器调用引擎的提交事务接口，引擎把刚刚写入的 redo log 改成提交（commit）状态，更新完成。

**从上图可以看出，MySQL 在执行更新语句的时候，在服务层进行语句的解析和执行，在引擎层进行数据的提取和存储；同时在服务层对 binlog 进行写入，在 InnoDB 内进行 redo log 的写入。**

**不仅如此，在对 redo log 写入时有两个阶段的提交，一是 binlog 写入之前 `prepare` 状态的写入，二是 binlog 写入之后 `commit` 状态的写入。**


### 那为什么要两阶段提交呢

为什么要两阶段提交呢？直接提交不行吗？

我们可以假设不采用两阶段提交的方式，而是采用「单阶段」进行提交，即要么先写入 redo log，后写入 binlog；要么先写入 binlog，后写入 redo  log。这两种方式的提交，都会导致原先数据库的状态和被恢复后的数据库的状态不一致。


> 先写入 redo log，后写入 binlog

在写完 redo log 之后，数据此时具有 crash-safe 能力，因此系统崩溃，数据会恢复成事务开始之前的状态。但是，若在 redo log 写完时候，binlog 写入之前，系统发生了宕机。此时 binlog 没有对上面的更新语句进行保存，导致当使用 binlog 进行数据库的备份或者恢复时，就少了上述的更新语句。从而使得 id=2 这一行的数据没有被更新。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/mysql-update-exe-step-2.png)


> 先写入binlog，后写入redo log

写完 binlog 之后，所有的语句都被保存，所以通过 binlog 复制或恢复出来的数据库中 id=2 这一行的数据会被更新为 a=1。但是如果在 redo log 写入之前，系统崩溃，那么 redo log 中记录的这个事务会无效，导致实际数据库中 id=2 这一行的数据并没有更新。



简单说，redo log 和 binlog 都可以用于表示事务的提交状态，而两阶段提交就是让这两个状态保持逻辑上的一致。

### 两段提交下的故障恢复

* ref 1-[redolog与binlog为什么需要两阶段提交](https://cloud.tencent.com/developer/article/1790507)
  

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/mysql-x-a-two-step-1.png)

如果在图中时刻 A 的地方，也就是写入 redo log 处于 prepare 阶段之后、写 binlog 之前，发生了崩溃（crash），由于此时 binlog 还没写，redo log 也还没提交，所以崩溃恢复的时候，这个事务会回滚。这时候，binlog 还没写，所以也不会传到备库。

如果 redo log 里面的事务是完整的，也就是已经有了 commit 标识，则直接提交；如果 redo log 里面的事务只有完整的 prepare，则判断对应的事务 binlog 是否存在并完整
1. 如果是，则提交事务（对应图中的时刻 B）
2. 否则，回滚事务。

这里，时刻 B 发生 crash 对应的就是上述情况 1的场景，崩溃恢复过程中事务会被提交。

> **两阶段提交的最后一个阶段的操作本身是不会失败的，除非是系统或硬件错误，所以也就不再需要回滚（不然就可以无限循环下去了）。**

## MySQL和字符集

* ref 1-[为什么不建议在MySQL中使用 UTF8](https://www.51cto.com/article/685551.html)



### 字符集

字符是各种文字和符号的统称，包括各个国家文字、标点符号、表情、数字等等。

「字符集」就是一系列字符的集合。字符集的种类较多，每个字符集可以表示的字符范围通常不同，就比如说有些字符集是无法表示汉字的。

计算机只能存储二进制的数据，那英文、汉字、表情等字符应该如何存储呢?

我们要将这些字符和二级制的数据一一对应起来，比如说字符 "a" 对应"01100001"，反之，"01100001" 对应 "a"。我们将字符对应二进制数据的过程称为「字符编码」，反之，二进制数据解析成字符的过程称为「字符解码」。


常见的字符集包括
1. ASCII
2. GB2312
3. GBK
4. Unicode 和 UTF-8


Unicode 字符集中包含了世界上几乎所有已知的字符。不过，Unicode 字符集并没有规定如何存储这些字符（也就是如何使用二级制数据表示这些字符）。

针对如何存储，诞生了 UTF-8（8-bit Unicode Transformation Format)，类似的还有 UTF-16、UTF-32。
* UTF-8 使用 1 到 4 个字节为每个字符编码
* UTF-16 使用 2 或 4 个字节为每个字符编码
* UTF-32 固定位 4 个字节为每个字符编码。

UTF-8 可以根据不同的符号自动选择编码的长短，像英文字符只需要 1 个字节就够了，这一点和 ASCII 字符集一样 。因此，对于英语字符，UTF-8 编码和 ASCII 码是相同的。


### MySQL的字符集

MySQL 支持很多种字符编码的方式，比如
1. UTF-8
2. GB2312
3. GBK
4. BIG5


但是需要注意的是，MySQL 字符编码集中有两套 UTF-8 编码实现
1. `utf8`
   * MySQL 中的 `utf8` 不是完整的 `UTF-8`。
   * 完整的 `UTF-8`使用 1 到 4 个字节为每个字符编码
   * **MySQL 中的 `utf8` 编码只支持 1 到 3 个字节。在 utf8 编码中，中文是占 3 个字节，其他数字、英文、符号占一个字节。但 emoji 符号占 4 个字节，一些较复杂的文字（比如“墅”）、繁体字也是 4 个字节。所以，MySQL 中不建议使用 uft8 作为编码**
2. `utf8mb4` 
   * `utf8mb4` 是 UTF-8 的完整实现，最多支持使用 4 个字节表示字符，因此，可以用来存储 emoji 符号、一些较复杂的文字和繁体字。
   * `utf8mb4` 中的 `mb4` 指的是 `most bytes 4`，即可支持使用最多 4 个字节表示字符。


### utf8处理4字节的错误

标准的 `utf-8` 编码可支持 1 个字节、2 个字节、3 个字节、4 个字节的字符，但是 MySQL 的 `utf8` 编码只支持最多 3 字节的数据，也就是说，MySQL 的 `utf8` 对标准的 `utf-8` 的支持是不完整的。

对于 emoji 表情字符、一些复杂的汉字（比如“墅”）、繁体字，是 4 个字节的字符。如果直接往采用 `utf8` 编码的数据库中插入表情数据，程序中将报 SQL 异常。

```java
java.sql.SQLException: Incorrect string value: ‘\xF0\x9F\x92\x94’ for column ‘name’ at row 1
at com.mysql.jdbc.SQLError.createSQLException(SQLError.java:1073)
at com.mysql.jdbc.MysqlIO.checkErrorPacket(MysqlIO.java:3593)
at com.mysql.jdbc.MysqlIO.checkErrorPacket(MysqlIO.java:3525)
at com.mysql.jdbc.MysqlIO.sendCommand(MysqlIO.java:1986)
at com.mysql.jdbc.MysqlIO.sqlQueryDirect(MysqlIO.java:2140)
at com.mysql.jdbc.ConnectionImpl.execSQL(ConnectionImpl.java:2620)
at com.mysql.jdbc.StatementImpl.executeUpdate(StatementImpl.java:1662)
at com.mysql.jdbc.StatementImpl.executeUpdate(StatementImpl.java:1581)
```

为了支持完整的 utf-8 编码，MySQL 推出了 `utf8mb4`，它是 MySQL 平台上 utf8 编码的超集，兼容 utf8，并且能存储 4 字节的表情字符。

采用 utf8mb4 编码的好处是，存储与获取数据的时候，不用再考虑表情字符的编码与解码问题。


### 使用utf8mb4替换utf8

* ref 1-[更改MySQL数据库的编码为utf8mb4](https://blog.csdn.net/woslx/article/details/49685111)


`utf8mb4` 的最低 MySQL 版本支持版本为 5.5.3+。在 5.5.3 后续版本中，建议使用 `uft8mb4` 编码代替 `utf8`。


**为了支持完整的 utf-8 编码，MySQL 推出了 `utf8mb4`，它是 MySQL 平台上 utf8 编码的超集，兼容 utf8，并且能存储 4 字节的表情字符。**


使用 utf8mb4 替换 utf 的步骤如下
1. 修改 MySQL 配置文件 `my.cnf`（Windows 为 `my.ini`）。`my.cnf` 一般在 `/etc/mysql/my.cnf` 位置。在配置文件中添加如下内容。


```s
[client] 
default-character-set = utf8mb4 
[mysql] 
default-character-set = utf8mb4 
[mysqld] 
character-set-client-handshake = FALSE 
character-set-server = utf8mb4 
collation-server = utf8mb4_unicode_ci 
init_connect='SET NAMES utf8mb4'
```

2. 重启数据库，检查变量

```s
SHOW VARIABLES WHERE Variable_name LIKE  'character_set_%'  OR Variable_name LIKE 'collation%';
```

| Variable_name	|  Value  | 
|-----------------|---------|
| character_set_client	| utf8mb4 | 
| character_set_connection | 	utf8mb4 | 
| character_set_database | 	utf8mb4 | 
| character_set_filesystem | 	binary | 
| character_set_results | 	utf8mb4 | 
| character_set_server	|  utf8mb4 | 
| character_set_system | 	utf8 | 
| collation_connection | 	utf8mb4_unicode_ci | 
| collation_database	| utf8mb4_unicode_ci | 
| collation_server | 	utf8mb4_unicode_ci | 


3. 将数据库和已经建好的表转换成 utf8mb4


```s
# 更改数据库编码
ALTER DATABASE caitu99 CHARACTER SET `utf8mb4` COLLATE `utf8mb4_general_ci`;

# 更改表编码
ALTER TABLE `TABLE_NAME` CONVERT TO CHARACTER SET `utf8mb4` COLLATE `utf8mb4_general_ci`; 
```
