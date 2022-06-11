
# MySQL-04-MySQL锁

[TOC]

## 更新
* 2022/05/09，撰写


## 参考资料
* [《MySQL是怎样运行的》从根儿上理解 MySQL](https://juejin.cn/book/6844733769996304392)，「锁」章节、「语句加锁分析」章节、「如何查看事务加锁情况」章节
* [MySQL中的锁 | Blog](https://www.cnblogs.com/chenqionghe/p/4845693.html)



## 什么是锁

锁是计算机在执行多线程或线程时用于并发访问同一共享资源时的同步机制。MySQL 中的锁是在服务器层或者存储引擎层实现的，保证了数据访问的一致性与有效性。

## 锁的分类

* ref 1-[史上最全MySQL各种锁详解 | 掘金](https://juejin.cn/post/6931752749545553933)


从不同的角度，可对锁做出不同的分类。

* 锁按模式可分为
    1. 乐观锁（业务实现）
    2. 悲观锁（`select ... for update`）
* 锁按粒度可分为
    1. 全局锁（全库逻辑备份，`flush tables with read lock`）
    2. 表级锁（MyISAM，BDB和InnoDB引擎）
    3. 页级锁（BDB引擎）
    4. 行级锁（InnoDB引擎）
* 锁按属性可分为
    1. 共享锁（S锁，`select ... lock in share mode`）
    2. 排它锁（X锁，`select ... for update`）
* 锁按属性可分为
    1. 意向共享锁（IS锁）
    2. 意向排它锁（IX锁）
* 锁按算法可分为
    1. 记录锁（Record Lock）：单个行记录上的锁
    2. 间隙锁（Gap Lock）：锁定一个范围，但不包含记录本身
    3. 临键锁（Next-Key Lock，即 Gap Lock + Record Lock）：是记录锁与间隙锁的组合。它的封锁范围既包含索引记录，又包含索引区间，是一个左开右闭区间。临键锁的主要目的是为了避免幻读（Phantom Read）
  



### 表级锁、页级锁和行级锁


锁按粒度可分为
1. 全局锁（全库逻辑备份，`flush tables with read lock`）
2. 表级锁（MyISAM，BDB和InnoDB引擎）
3. 页级锁（BDB引擎）
4. 行级锁（InnoDB引擎）



MySQL 中不同的存储引擎，支持的锁情况也不同。
* MyISAM 和 Memory 存储引擎支持表级锁（`table-level locking`），不支持行级锁
* BDB 存储引擎支持表级锁和页级锁（`page-level locking`）
* InnoDB 存储引擎支持表级锁和行级锁（`row-level locking`）


| 锁类型 |  性能  |  死锁  |  粒度 | 并发性能 |  支持的引擎 |
|-------|-------|--------|------|---------|-----------|
| 表级锁 | 开销小，加锁快 | 不会出现 | 大 | 发生锁冲突概率最高，并发性能最低 | InnoDB，MyISAM，Memory，BDB |
| 行级锁 | 开销大，加锁慢 | 会出现 | 小 | 发生锁冲突概率最低，并发性能最高 | InnoDB |
| 页级锁 | 开销和加锁时间介于表锁和行锁之间 | 会出现 | 粒度介于表锁和行锁之间 | 并发性能一般 | BDB |



### 全局锁

全局锁就是对整个数据库实例加锁。MySQL 提供了一个加全局读锁的方法，命令为

```sql
-- 简记为 FTWRL
flush tables with read lock 
```

当你需要让整个库处于只读状态的时候，可以使用这个命令，之后其他线程的以下语句会被阻塞
1. 数据更新语句（数据的增删改）
2. 数据定义语句（包括建表、修改表结构等）
3. 更新类事务的提交语句



全局锁的典型使用场景是，做全库逻辑备份。 

  
使用全局锁，需明确如下风险
* 如果在主库备份，在备份期间会造成主库不能更新，业务停摆
* 如果在从库备份，备份期间不能执行主库同步的 binlog，导致主从延迟

  
官方自带的逻辑备份工具是 `mysqldump`。使用 `mysqldump`工具时，指定参数 `–single-transaction` 时，导数据之前就会启动一个事务，来确保拿到一致性视图。而由于 MVCC 的支持（可以进行一致性读），这个过程中数据是可以正常更新数据库的。

你一定在疑惑，有了 `mysqldump` 这个功能，为什么还需要 `FTWRL` 呢？

一致性读是好，但前提是引擎要支持这个隔离级别。比如，对于 MyISAM 这种不支持事务的引擎，如果备份过程中有更新，总是只能取到最新的数据，那么就破坏了备份的一致性。这时，我们就需要使用 `FTWRL` 命令了。

 
综上，`-single-transaction` 方法只适用于所有的表的存储引擎都支持事务的场景。如果有的表使用了不支持事务的引擎，那么备份就只能通过 `FTWRL` 方法。这往往是 DBA 要求业务开发人员使用 InnoDB 替代 MyISAM 的原因之一。


## 使用锁解决并发事务带来的问题

并发事务会造成脏写（也称为更新丢失），脏读，不可重复读和幻读的问题。本章节，将对「如何解决并发事务带来的问题」进行分析。

并发事务访问相同记录的情况，大致可以划分为 3 种
1. 读-读
2. 写-写
3. 读-写和写-读

下面将对这 3 种场景进行具体分析。

### 读-读
读操作不会对记录产生影响，所以允许并发事务相继读取相同的记录。


### 写-写

并发事务相继对相同的记录做出写操作，会产生「脏读」问题。

该问题较为严重，SQL 中任何一种隔离级别都不允许这种问题的发生。在多个未提交事务相继对一条记录做改动时，通过对该记录「加锁」，将一个「锁结构」和该记录关联，让多个事务的写操作串行执行，从而避免「脏读」问题。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-lock-structure-1.png)


「锁结构」里有很多信息，为了简化理解，此处仅介绍两个比较重要的属性
* `trx` 信息：代表这个锁结构是哪个事务生成的
* `is_waiting` 信息：代表当前事务是否在等待



### 读-写或写-读

对同一条记录，一个事务进行读取操作，另一个进行改动操作。此时并发事务会造成脏读，不可重复读和幻读的问题。

SQL 标准中定义了不同的隔离级别来规避上述问题，如下表所示。


|  隔离级别  | 脏读  |  不可重复读  |  幻读  |
|-----------|-------|------------|-------|
| READ UNCOMMITTED（未提交读）| 可能 | 可能 | 可能 |
| READ COMMITTED（已提交读）| No | 可能 | 可能  |
| REPEATABLE READ（可重复读）| No | No | 可能  |
| SERIALIZABLE（可串行化）| No | No |  No  |


#### 解决问题的两种方式

如何解决「脏读，不可重复读和幻读」问题呢？有两种可选的解决方案
* **方案1：读操作利用多版本并发控制（MVCC），写操作进行加锁。此时的读，称为「一致性读」或「一致性无锁读」。**
* **方案2：读、写操作都采用加锁的方式。此时的读，称为「锁定读」。**


很明显，采用 MVCC 方式的话，读-写操作彼此并不冲突，性能更高。采用加锁方式的话，读-写操作彼此需要排队执行，影响性能。关于 MVVC 的介绍，参见 「*Notes-03-MySQL事务*」。

一般情况下，我们当然愿意采用 MVCC 来解决读-写操作并发执行的问题，但是业务在某些特殊情况下，要求必须采用加锁的方式执行，如金融转账业务等。


下面将对并发事务中的「读-写或写-读」中的读操作和写操作分别进行介绍
* 读操作
    - 一致性读
    - 锁定读
* 写操作
  


#### 读-写中的读操作

##### 一致性读
事务利用 MVCC 进行的读取操作，称之为「一致性读（`Consistent Reads`）」，或者「一致性无锁读」，有的地方也称之为「快照读」。

所有普通的 SELECT 语句（plain SELECT）在 `READ COMMITTED`、`REPEATABLE READ` 隔离级别下都是一致性读。

```sql
SELECT * FROM t;
SELECT * FROM t1 INNER JOIN t2 ON t1.col1 = t2.col2
```

一致性读并不会对表中的任何记录做加锁操作，其他事务可以自由的对表中的记录做改动。



##### 锁定读

在读-写和写-读操作中，若读和写操作都采用加锁的方式处理，则此时的读称为「锁定读（`Locking Reads`）」。

###### 共享锁和独占锁

锁定读中，既要允许读-读情况不受影响，又要使写-写、读-写或写-读情况中的操作相互阻塞。

为此，MySQL 将锁细分出了
* 共享锁（`Shared Locks`）：简称 `S锁`，在事务要读取一条记录时，需要先获取该记录的`S锁`。
* 独占锁（`Exclusive Locks`）：也称排他锁，简称 `X锁`，在事务要改动一条记录时，需要先获取该记录的 `X锁`。

`S锁` 和 `X锁` 的兼容性如下表所示。


| 兼容性 |    X   |    S   |
|-------|--------|--------|
|   X	|  不兼容 |	 不兼容 |
|   S	|  不兼容 |   兼容  |


###### 锁定读的语句

*  对读取的记录加 `S锁` 

```sql
SELECT ... LOCK IN SHARE MODE;
```

* 对读取的记录加 `X锁`


```sql
SELECT ... FOR UPDATE;
```


#### 读-写中的写操作

「写操作」主要涉及到 DELETE、UPDATE、INSERT 这 3 种。

本章节内容，详情见参考资料中的 *[《MySQL是怎样运行的》从根儿上理解 MySQL](https://juejin.cn/book/6844733769996304392)*，此处仅做大纲记录。


对于 `Insert` 操作
* **一般情况下，新插入一条记录的操作并不加锁，InnoDB 引擎提供了「隐式锁」，来保护这条新插入的记录在本事务提交前不被别的事务访问**
* 当然，在一些特殊情况下，`INSERT` 操作也是会获取锁的，详情见本文「*INSERT语句加锁分析*」章节




## InnoDB存储引擎中的锁

### InnoDB中的表级锁
#### 表级别的S锁和X锁

在对某个表执行 SELECT、INSERT、DELETE、UPDATE 语句时，InnoDB 存储引擎是不会为这个表添加表级别的 `S锁` 或者 `X锁` 的。


在系统变量 `autocommit=0`，`innodb_table_locks = 1` 时，手动获取 InnoDB 存储引擎提供的表级别的 `S锁` 或者 `X锁` 方法如下

```sql
-- InnoDB存储引擎会对表t加表级别的S锁
LOCK TABLES t READ；

-- InnoDB存储引擎会对表t加表级别的X锁
LOCK TABLES t WRITE;
```

请尽量避免在使用 InnoDB 存储引擎的表上使 用 LOCK TABLES 这样的手动锁表语句，它们并不会提供什么额外的保护，只是会降低并发能力而已。


#### 元数据锁

MySQL 中，在 server 层使用提供了「元数据锁（Metadata Locks，简称 MDL）」，用于下述场景
* 一个事务 `T1` 对表执行诸如 ALTER TABLE、DROP TABLE 这类的 DDL 语句
* 另一个事务 `T2` 对表执行SELECT、INSERT、DELETE、UPDATE 语句
* 事务 `T1` 和事务 `T2` 若并发执行，会发生阻塞，这个阻塞就是通过元数据锁实现的



**MDL 不需要显式使用，在访问一个表的时候会被自动加上。MDL 的作用是保证读写的正确性。 MDL 是在 server 层面实现的。**

> 在 MySQL 5.5 版本中引入了 MDL，当对一个表做增删改查操作的时候，加 MDL 读锁；当要对表做结构变更操作的时候，加 MDL 写锁。


MDL 读锁之间不互斥，因此你可以有多个线程同时对一张表增删改查。MDL 读写锁之间、MDL写锁之间是互斥的，用来保证变更表结构操作的安全性。因此，如果有两个线程要同时给一个表加字段，其中一个要等另一个执行完才能开始执行。

事务中的 MDL 锁，在语句执行开始时申请，但是语句结束后并不会马上释放，而会等到整个事务提交后再释放。

  
**给一个表加字段，或者修改字段，或者加索引，需要扫描全表的数据。在对大表操作的时候，你肯定会特别小心，以免对线上服务造成影响。** 而实际上，即使是小表，操作不慎也会出问题。在修改表的时候会持有 MDL 写锁，如果这个表上的查询语句频繁，而且客户端有重试机制，也就是说超时后会再起一个新 session 再请求的话，这个库的线程很快就会爆满。


此处，就「**如何安全地给表加字段**」问题进行分析。

1. 解决长事务问题
事务不提交，就会一直占着 MDL 锁。在 MySQL 的 `information_schema` 库的 `innodb_trx` 表中，你可以查到当前执行中的事务。如果你要做 DDL 变更的表刚好有长事务在执行，要考虑先暂停 DDL，或者 kill 掉这个长事务。

2. 在alter table 语句里设定等待时间
如果在这个指定的等待时间里面能够拿到 MDL 写锁最好，拿不到也不要阻塞后面的业务语句，先放弃。之后开发人员或者 DBA 再通过重试命令重复这个过程。

3. MariaDB 和 AliSQL 已经支持了 `DDL NOWAIT/WAIT n` 语法

```sql
ALTER TABLE tbl_name NOWAIT add column ...
ALTER TABLE tbl_name WAIT N add column ... 
```




#### 表级别的IS锁和IX锁

InnoDB 存储引擎提供了「意向锁（`Intention Locks`）」
1. 意向共享锁（Intention Shared Lock）：简称 `IS锁`，当事务准备在某条记录上加 `S锁` 时，需要先在表级别加一个 `IS锁`。
2. 意向独占锁（Intention Exclusive Lock）：简称 `IX锁`，当事务准备在某条记录上加 `X锁` 时，需要先在表级别加一个 `IX锁`。


`IS锁` 和 `IX锁` 的使命只是为了后续在加表级别的 `S锁` 和 `X锁` 时判断表中是否有已经被加锁的记录，以避免用遍历的方式来查看表中有没有上锁的记录。


`IS锁`、`IX锁` 和 `S锁`、`X锁` 的兼容关系如下表所示。


| 兼容性 |    X   |    IX  |   S   |    IS   |
|-------|--------|--------|-------|---------|
|   X	|  不兼容 |	 不兼容 | 不兼容 |	 不兼容 |
|   IX	|  不兼容 |   兼容  | 不兼容 |   兼容  |
|   S	|  不兼容 |  不兼容 |   兼容 |   兼容  |
|   IS	|  不兼容 |   兼容  |   兼容 |   兼容  |


#### 表级别的AUTO-INC锁和轻量级锁

MySQL 中可以为表的某个列添加 `AUTO_INCREMENT` 属性，之后在插入记录时，可以不指定该列的值，系统会自动为它赋上递增的值。

```sql
CREATE TABLE t (
    id INT NOT NULL AUTO_INCREMENT,
    c VARCHAR(100),
    PRIMARY KEY (id)
) Engine=InnoDB CHARSET=utf8;
```

实现这种自动给 `AUTO_INCREMENT` 修饰的列递增赋值，有两种实现方案
* 方案1：采用 `AUTO-INC` 锁，在执行插入语句时就在表级别加一个 `AUTO-INC` 锁；然后为每条待插入记录 `的AUTO_INCREMENT` 修饰的列分配递增的值；在该语句执行结束后，再把 `AUTO-INC` 锁释放掉。这样一个事务在持有 `AUTO-INC` 锁的过程中，其他事务的插入语句都要被阻塞，从而保证一个语句中分配的递增值是连续的。
* 方案2：采用一个轻量级的锁，在为插入语句生成 `AUTO_INCREMENT` 修饰的列的值时获取一下这个轻量级锁，然后生成本次插入语句需要用到的递增值之后，就把该轻量级锁释放掉，并不需要等到整个插入语句执行完才释放锁。


InnoDB 存储引擎提供了一个叫做 `innodb_autoinc_lock_mode` 的系统变量，来控制使用哪种方式为 `AUTO_INCREMENT` 修饰的列进行赋值
1. `innodb_autoinc_lock_mode = 0` 时，采用 `AUTO-INC` 锁
2. `innodb_autoinc_lock_mode = 2` 时，采用轻量级锁
3. `innodb_autoinc_lock_mode = 1` 时，两种方式均采用，在插入记录数量确定时采用轻量级锁，不确定时使用 `AUTO-INC` 锁

> 采用轻量级锁的方式对 `AUTO_INCREMENT` 修饰的列进行赋值，这种方式可以避免锁定表，可以提升插入性能。


### InnoDB中的行级锁


锁按算法可分为
1. 记录锁（Record Lock）：单个行记录上的锁
2. 间隙锁（Gap Lock）：锁定一个范围，但不包含记录本身
3. 临键锁（Next-Key Lock，即 Gap Lock + Record Lock）


![mysql-line-lock-all-kinds-1](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-line-lock-all-kinds-1.png)

#### 记录锁
* 记录锁（Record Lock），官方的类型名称为 `LOCK_REC_NOT_GAP`，是单个记录上的锁。
* 记录锁有S锁和X锁之分。

#### 间隙锁
* 间隙锁（Gap Lock）仅仅是为了防止插入幻影记录而提出的。对一条记录加了 GAP 锁（不论是共享 GAP 锁还是独占 GAP 锁），并不会限制其他事务对这条记录加记录锁或者继续加 GAP 锁。

#### 临键锁
* 临键锁（Next-Key Lock），官方的类型名称为 `LOCK_ORDINARY`，即 Gap Lock + Record Lock）
* 临键锁的本质就是一个记录锁和一个间隙锁的合体（Gap Lock + Record Lock），它既能保护该条记录，又能阻止别的事务将新记录插入被保护记录前边的间隙。
  

#### 插入意向锁
* 一个事务在执行 INSERT 操作时，如果即将插入的间隙已经被其他事务加了 GAP 锁，那么本次 INSERT 操作会阻塞，并且当前事务会在该间隙上加一个插入意向锁（Insert Intention Locks）
* 向某条记录添加插入意向锁后，不会阻止别的事务继续获取该记录上任何类型的锁。


#### 隐式锁

一个事务在执行 INSERT 操作时，如果即将插入的间隙已经被其他事务加了 GAP 锁，那么本次 INSERT 操作会阻塞，并且当前事务会在该间隙上加一个插入意向锁。否则，一般情况下 INSERT 操作是不加锁的。

那如果一个事务首先插入了一条记录（**此时并没有与该记录关联的锁结构**），然后另一个事务

* 立即修改这条记录，这会造成「脏写」问题
* 立即读这条记录（具体包括下面两种场景），这会造成「脏读」问题
    - 立即使用 `SELECT ... LOCK IN SHARE MODE` 语句读取这条记录，也就是在要获取这条记录的 `S锁`
    - 立即使用 `SELECT ... FOR UPDATE` 语句读取这条记录，也就是要获取这条记录的 `X锁`

如何避免上述问题呢？这个时候可以用到「事务ID」来解决该问题
1. 情景一：对于聚簇索引记录来说，有一个 `trx_id` 隐藏列，该隐藏列记录着最后改动该记录的事务ID
   * 在当前事务中新插入一条聚簇索引记录后，该记录的 `trx_id` 隐藏列代表的就是当前事务的事务ID
   * 如果其他事务此时想对该记录添加S锁或者X锁时，首先会看一下该记录的 `trx_id` 隐藏列代表的事务是否是当前的活跃事务
   * 如果是的话，那么就帮助当前事务创建一个X锁（也就是为当前事务创建一个锁结构，`is_waiting` 属性是 `false`），然后自己进入等待状态（也就是为自己也创建一个锁结构，`is_waiting` 属性是 `true`）
2. 情景2：对于二级索引记录来说，本身并没有 `trx_id` 隐藏列，但是在二级索引页面的 `Page Header` 部分有一个 `PAGE_MAX_TRX_ID` 属性，该属性代表对该页面做改动的最大的事务ID
   * 如果 `PAGE_MAX_TRX_ID` 属性值小于当前最小的活跃事务ID，那么说明对该页面做修改的事务都已经提交了
   * 否则，就需要在页面中定位到对应的二级索引记录，然后「回表」找到它对应的聚簇索引记录，然后再重复情景一的做法。

通过上边的描述我们知道，一个事务对新插入的记录可以不显式的加锁（生成一个锁结构），并通过事务 ID 来避免「脏写」和「脏读」问题，这个过程相当于给记录加了一个「隐式锁」。其余的事务在对这条记录加S锁或者X锁时，由于隐式锁的存在，会先帮助当前事务生成一个锁结构，然后自己再生成一个锁结构后进入等待状态。



### InnoDB锁的内存结构


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-innodb-lock-structure-1.png)


## 语句加锁分析
* ref 1-[Innodb到底是怎么加锁的(完整版) | 我们都是小青蛙](https://mp.weixin.qq.com/s/MfVmJPvwSfFlSxaOdYkvfg)


“一条语句该加什么锁” 受到很多条件的制约，包括
1. 事务的隔离级别
2. 语句执行时使用的索引（比如聚簇索引、唯一二级索引、普通二级索引）
3. 查询条件（比方说=、=<、>=等等）
4. 具体执行的语句类型


### 普通SELECT语句加锁分析

1. READ UNCOMMITTED 隔离级别下，不加锁，直接读取记录的最新版本，可能发生脏读、不可重复读和幻读问题。
2. READ COMMITTED 隔离级别下，不加锁，在每次执行普通的 SELECT 语句时都会生成一个ReadView，这样解决了脏读问题，但没有解决不可重复读和幻读问题。
3. REPEATABLE READ 隔离级别下，不加锁，只在第一次执行普通的 SELECT 语句时生成一个ReadView，这样把脏读、不可重复读和幻读问题都解决了。
4. SERIALIZABLE隔离级别下，需要分为两种情况讨论
   * `autocommit=0` 时，也就是禁用自动提交时，普通的 SELECT 语句会被转为`SELECT ... LOCK IN SHARE MODE`，也就是在读取记录前需要先获得记录的 `S锁`
   * `autocommit=1` 时，也就是启用自动提交时，普通的 SELECT 语句并不加锁，只是利用 MVCC 来生成一个 ReadView 去读取记录


### 锁定读
本章节中，将下边四种语句放到一起讨论
1. `SELECT ... LOCK IN SHARE MODE`
2. `SELECT ... FOR UPDATE`
3. `UPDATE ...`
4. `DELETE ...`

`UPDATE` 和 `DELETE` 语句，在执行过程需要首先定位到被改动的记录并给记录加锁，故可以被认为是一种锁定读。

本章节内容，详情见 [《MySQL是怎样运行的》从根儿上理解 MySQL](https://juejin.cn/book/6844733769996304392) -「语句加锁分析」章节，此处仅做大纲记录。


#### 使用主键进行范围查询时加锁分期


先创建一个 `hero` 表并插入数据，用于后续演示。

```sql
CREATE TABLE hero (
    number INT,
    name VARCHAR(100),
    country varchar(100),
    PRIMARY KEY (number),
    KEY idx_name (name)
) Engine=InnoDB CHARSET=utf8;

INSERT INTO hero VALUES
    (1, 'l刘备', '蜀'),
    (3, 'z诸葛亮', '蜀'),
    (8, 'c曹操', '魏'),
    (15, 'x荀彧', '魏'),
    (20, 's孙权', '吴');
```


下面使用主键进行范围查询（以 `LOCK IN SHARE MODE` 为例进行说明，`FOR UPDATE` 模式下，加的是同种的 `X锁`），语句如下。

```sql
SELECT * FROM hero WHERE number >= 8 LOCK IN SHARE MODE;
```

该语句的加锁情况，和事务隔离级别相关

* 在隔离级别不大于 READ COMMITTED（指的就是 READ UNCOMMITTED，READ COMMITTED）时，会为当前记录添加S型记录锁，如下图所示

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-lock-select-analysis-1.png)




* 在隔离级别不小于 REPEATABLE READ（指的就是 REPEATABLE READ，SERIALIZABLE）时，这两个级别需要依赖间隙锁（Gap Lock）或临键锁（Next-key Lock）来解决幻读问题。上述语句中，会为 `number = 8` 的记录加一个S型正经记录锁。为 `number > 8` 的记录（包括 Supremum 伪记录）都加一个临键索（`Next-key Lock`）。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-lock-select-analysis-2.png)




### INSERT语句加锁分析

* ref 1- [《MySQL是怎样运行的》从根儿上理解 MySQL](https://juejin.cn/book/6844733769996304392)，「两条一样的INSERT语句竟然引发了死锁」章节


`INSERT` 语句在正常执行时是不会生成锁结构的，它是靠聚簇索引记录自带的 `trx_id` 隐藏列来作为隐式锁来保护记录的。

但是在一些特殊场景下，`INSERT` 语句还是会生成锁结构的。下面将分三种情况进行介绍。
1. 待插入记录的下一条记录上已经被其他事务加了GAP锁时
2. 遇到重复键时
3. 外键检查时

#### 1.待插入记录的下一条记录上已经被其他事务加了GAP锁时

每插入一条新记录，都需要看一下待插入记录的下一条记录上是否已经被加了 GAP 锁，如果已加 GAP 锁，那 INSERT 语句应该被阻塞，并生成一个插入意向锁。



#### 2.遇到重复键时

如果在插入新记录时，发现页面中已有的记录的主键或者唯一二级索引列，与待插入记录的主键或者唯一二级索引列值相同时
* **如果是主键值重复，那么**
  - **当隔离级别不大于 RC（`READ COMMITTED`）时，插入新记录的事务会给已存在的主键值重复的聚簇索引记录添加S型记录锁**
  - **当隔离级别不小于 RR（`REPEATABLE READ`）时，插入新记录的事务会给已存在的主键值重复的聚簇索引记录添加S型临键锁（`Next-key Lock`）**
* **如果是唯一二级索引列重复，那不论是哪个隔离级别，插入新记录的事务都会给已存在的二级索引列值重复的二级索引记录添加S型临键锁（`Next-key Lock`）**

#### 3.外键检查时

当我们向子表中插入记录时，分两种情况讨论
* 当子表中的外键值可以在父表中找到时，那么无论当前事务是什么隔离级别，插入新记录的事务会给父表中对应的记录添加一个S型记录锁
* 当子表中的外键值在父表中找不到时
  - 如果当前隔离级别不大于 RC 时，不对父表记录加锁
  - 当隔离级别不小于 RR 时，对父表中该外键值所在位置的下一条记录添加 GAP 锁




### 半一致性读的加锁分析
* ref 1-[MySQL半一致性读 | 掘金](https://juejin.cn/post/6844904022499917838)



#### MySQL支持3种类型的读语句

MySQL 支持 3 种类型的读语句
1. 普通读（也称一致性读，`Consistent Read`）：一致性读指的是在末尾不加 `FOR UPDATE` 或者 `LOCK IN SHARE MODE` 的普通 SELECT 语句。普通读的执行方式是生成 ReadView 直接利用 MVCC 机制来进行读取，并不会对记录进行加锁
2. 锁定读（`Locking Read`）
3. 半一致性读（`Semi-Consistent Read`）




半一致性读（`Semi-Consistent Read`）是夹在普通读（一致性读）和锁定读之间的一种读取方式。
* **它只在 `READ COMMITTED` 隔离级别下（或者在开启了 `innodb_locks_unsafe_for_binlog` 系统变量的情况下），使用 `UPDATE` 语句时才会使用。**
* 具体的含义就是当 UPDATE 语句读取已经被其他事务加了锁的记录时，InnoDB 会将该记录的最新提交的版本读出来，然后判断该版本是否与 UPDATE 语句中的 WHERE 条件相匹配
  * 如果不匹配则不对该记录加锁，从而跳到下一条记录
  * 如果匹配则再次读取该记录并对其进行加锁。
  * 这样子处理只是为了让 UPDATE 语句尽量少被别的语句阻塞。

**另外，需要注意的是，半一致性读只适用于对聚簇索引记录加锁的情况，并不适用于对二级索引记录加锁的情况。**


#### 半一致性读示例

先创建一个 `hero` 表并插入数据，用于后续演示。

```sql
CREATE TABLE hero (
    number INT,
    name VARCHAR(100),
    country varchar(100),
    PRIMARY KEY (number),
    KEY idx_name (name)
) Engine=InnoDB CHARSET=utf8;

INSERT INTO hero VALUES
    (1, 'l刘备', '蜀'),
    (3, 'z诸葛亮', '蜀'),
    (8, 'c曹操', '魏'),
    (15, 'x荀彧', '魏'),
    (20, 's孙权', '吴');
```

考虑如下场景
1. 事务 T1 在 `READ COMMITTED` 隔离级别下，执行如下语句。该语句会在 `number = 8` 的聚簇索引记录上加上 `X` 型记录锁。

```sql
SELECT * FROM hero WHERE number = 8 FOR UPDATE;
```
2. 此时，事务 T2 也在 `READ COMMITTED` 隔离级别下，执行如下语句。

```sql
UPDATE hero SET name = 'cao曹操' 
WHERE number >= 8 AND number < 20 AND country != '魏';
```
3. 事务 T2 中的 `UPDATE` 语句在执行时，需要依次获取 number 值为8/15/20的聚簇索引记录的X型记录锁（`number = 20` 的记录的锁会稍后释放掉） 
4. 此时，T1 已经获取到了 `number = 8` 的聚簇索引的X型记录锁，若没有半一致性读，按道理分析，事务 T2 会因为获取不到 `number = 8` 的聚簇索引的X型记录锁，而被阻塞
5. 但是由于半一致性读，存储引擎会先获取 `number = 8` 的聚簇索引记录最新提交的版本并返回给 server 层
   * 该版本的 `county='魏'`，很显然不满足 WHERE 的筛选条件
   * 所以 server 层巨鼎放弃获取 `number = 8` 的聚簇索引记录上的X型记录锁，转而让存储引擎读取下一条记录
6. 这样，就通过半一致性读，避免了 UPDATE 语句被阻塞的问题

## 查看事务加锁情况

查看事务加锁情况，主要包括 2 种方法
1. 使用 `information_schema` 数据库中的 `innodb_locks` 和 `innodb_lock_wait`。在 MySQL 8.0 中，这两个表已经被移除，可使用 `performance_schema` 数据库中的 `data_locks` 和 `data_locks_waits`。
2. 使用 `show engine innodb status`（MySQL中推荐使用该方式）



### autocommit


MySQL 默认自动提交事务，可通过 `autocommit` 属性进行设置


```s
# mysql 默认支持自动提交事务
mysql> SHOW VARIABLES LIKE 'autocommit';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| autocommit    | ON    |
+---------------+-------+


# 手动关闭自动提交事务
mysql> SET autocommit = OFF;
```

### 使用information_schema数据库的表查看加锁信息

使用 `information_schema` 数据库中的 `innodb_locks` 和 `innodb_lock_wait`，可以查看加锁信息。

1. `INNOD_TRX` 表，存储了 InnoDB 存储引擎在**当前正在执行**的事务信息。注意，存储的是当前正在执行的事务信息，不包括已经完成或中止的事务信息。


```sql
mysql> select * from information_schema.innodb_trx \G;
*************************** 1. row ***************************
                    trx_id: 1315
                 trx_state: RUNNING
               trx_started: 2022-05-11 19:36:21
     trx_requested_lock_id: NULL
          trx_wait_started: NULL
                trx_weight: 1
       trx_mysql_thread_id: 22
                 trx_query: NULL
       trx_operation_state: NULL
         trx_tables_in_use: 0
         trx_tables_locked: 1
          trx_lock_structs: 1
     trx_lock_memory_bytes: 1128
           trx_rows_locked: 1
         trx_rows_modified: 0
   trx_concurrency_tickets: 0
       trx_isolation_level: REPEATABLE READ
         trx_unique_checks: 1
    trx_foreign_key_checks: 1
trx_last_foreign_key_error: NULL
 trx_adaptive_hash_latched: 0
 trx_adaptive_hash_timeout: 0
          trx_is_read_only: 0
trx_autocommit_non_locking: 0
       trx_schedule_weight: NULL
```

一个`INNOD_TRX` 表的存储信息如上所示
* `trx_id` 表示事务ID
* `trx_isolation_level` 表示事务隔离级别
* `trx_rows_locked` 表示当前加了多少个行级锁
* `trx_tables_locked` 表示当前加了多少个表级锁



2. `innodb_locks` 表主要记录了下面两个方面的锁信息
    * 如果一个事务想要获取某个锁但未获取到，则记录该锁信息
    * 如果一个事务获取到了锁，但是这个锁阻塞了别的事务，则记录该锁信息

3. `innodb_lock_wait` 表记录了某个事务是因为获取不到哪个事务持有的锁而阻塞的。


`information_schema` 数据库中的 `innodb_locks` 和 `innodb_lock_wait` 这两个表，在在 MySQL 8.0 中，这两个表已经被移除，可使用 `performance_schema` 数据库中的 `data_locks` 和`data_locks_waits` 代替。


> 'INFORMATION_SCHEMA.INNODB_LOCKS' AND 'INFORMATION_SCHEMA.INNODB_LOCKS_WAITS' is deprecated a is deprecated as of MySQL 5.7.14 and is removed in MySQL 8.0.  -- [The INFORMATION_SCHEMA INNODB_LOCKS Table | MySQL Cookbook](https://dev.mysql.com/doc/refman/5.7/en/information-schema-innodb-locks-table.html)



### 使用performance_schema数据库的表查看加锁信息

* ref 1-[mysql 8.0 查看锁信息 | blog](http://t.zoukankan.com/gered-p-12769367.html)


`performance_schema` 数据库中的表 `data_locks` 和表`data_locks_waits`，作用同 `information_schema` 数据库中的表 `innodb_locks` 和表 `innodb_lock_wait`。


### 使用show engine innodb status

MySQL 中推荐使用 `show engine innodb status` 方式去查看当前系统中各个事务的加锁情况。

```sql
mysql> show engine innodb status \G;

-- 省略别的信息 仅展示事务相关信息
------------
TRANSACTIONS
------------
Trx id counter 1319
Purge done for trx's n:o < 1312 undo n:o < 0 state: running but idle
History list length 0
LIST OF TRANSACTIONS FOR EACH SESSION:
---TRANSACTION 421772213132424, not started
0 lock struct(s), heap size 1128, 0 row lock(s)
---TRANSACTION 421772213131632, not started
0 lock struct(s), heap size 1128, 0 row lock(s)
---TRANSACTION 421772213130840, not started
0 lock struct(s), heap size 1128, 0 row lock(s)
---TRANSACTION 1318, ACTIVE 182 sec
1 lock struct(s), heap size 1128, 1 row lock(s)
MySQL thread id 22, OS thread handle 123145450823680, query id 544 localhost root
---TRANSACTION 1316, ACTIVE 290 sec
2 lock struct(s), heap size 1128, 4 row lock(s)
MySQL thread id 20, OS thread handle 123145448693760, query id 533 localhost root
--------
```

## 死锁

* 不同事务由于互相持有对方需要的锁而导致事务都无法继续执行的情况，称为「死锁」。
* **死锁发生时，InnoDB 会选择一个较小的事务进行回滚。**
* 可以通过 `show engine innodb status` 查看死锁日志来分析死锁的过程。


### 如何避免死锁

通常来说，死锁都是应用设计的问题，通过调整业务流程、数据库对象设计、事务大小、SQL语句，绝大部分都可以避免。下面是一些常用的避免死锁的方法。
* 如果不同的程序会并发存取多个表，应尽量约定以相同的顺序为访问表，这样可以大大降低产生死锁的机会。如果两个 session 访问两个表的顺序不同，发生死锁的机会就非常高！但如果以相同的顺序来访问，死锁就可能避免。
* 在程序以批量方式处理数据的时候，如果事先对数据排序，保证每个线程按固定的顺序来处理记录，也可以大大降低死锁的可能。
* 在事务中，如果要更新记录，应该直接申请足够级别的锁，即排他锁，而不应该先申请共享锁，更新时再申请排他锁。
* 在 REPEATEABLE READ 隔离级别下，如果两个线程同时对相同条件记录用 `SELECT...FOR UPDATE` 加排他锁，在没有符合该记录情况下，两个线程都会加锁成功。程序发现记录尚不存在，就试图插入一条新记录，如果两个线程都这么做，就会出现死锁。这种情况下，将隔离级别改成 `READ COMMITTED`，就可以避免问题。


### SELECT死锁示例

| 发生时间编号 |     事务T1     |       事务T2   |
|------------|----------------|---------------|
|    1       |     BEGIN      |               |
|    2       |                |    BEGIN      |
|    3       | SELECT * FROM hero WHERE num=1 FOR UPDATE |    |
|    4       |   | SELECT * FROM hero WHERE num=3 FOR UPDATE  |
| 5 | SELECT * FROM hero WHERE num=3 FOR UPDATE（此操作阻塞）| |
| 6 | | SELECT * FROM hero WHERE num=1 FOR UPDATE（死锁发生，记录日志，服务器回滚一个事务）| 


如上表所示
1. 时间序号3中，事务 T1 持有 `num=1` 的聚簇索引的 `X锁`
2. 时间序号4中，事务 T2 持有 `num=3` 的聚簇索引的 `X锁`
3. 时间序号5中，事务 T1 也想对 `num=3` 的聚簇索引添加 `X锁`，但该锁已被事务 T2 持有，故 T1 发生阻塞，等待 T2 释放锁
4. 时间序号6中，事务 T2 也想对 `num=1` 的聚簇索引添加 `X锁`，但该锁已被事务 T1 持有，故 T2 发生阻塞，等待 T1 释放锁

此时，T1 和 T2 都在等待对方释放锁，导致 T1 和 T2 都不能继续执行，这个时候就发生了死锁。

InnoDB 有一个死锁检测机制，当它检测到死锁发生时，会选择一个较小的事务进行回滚（所谓较小的事务，是指在事务执行过程中插入、更新和删除的记录条数较少的事务），并向客户端发送一条消息。

```s
ERROR 1213 (40001): Deadlock found when trying to get lock; trying to restarting transaction
```

可以通过 `show engine innodb status` 查看死锁日志来分析死锁的过程。


上述死锁问题，是两个事务对 `num` 值为1、3的两条聚簇索引记录的加锁顺序不同而导致发生了死锁。可以考虑在业务代码中改变事务对记录的加锁顺序来避免死锁，将事务 T2 改为先获取 `num=1`的锁，再获取 `num=3` 的锁，就可以避免死锁，如下表所示。


| 发生时间编号 |     事务T1     |       事务T2   |
|------------|----------------|---------------|
|    1       |     BEGIN      |               |
|    2       |                |    BEGIN      |
|    3       | SELECT * FROM hero WHERE num=1 FOR UPDATE |    |
| 4 | | SELECT * FROM hero WHERE num=1 FOR UPDATE （此操作阻塞）|
| 5 | SELECT * FROM hero WHERE num=3 FOR UPDATE | |
| 6 | | SELECT * FROM hero WHERE num=3 FOR UPDATE（此操作阻塞）| 




### INSERT死锁示例

* ref 1- [《MySQL是怎样运行的》从根儿上理解 MySQL](https://juejin.cn/book/6844733769996304392)，「两条一样的INSERT语句竟然引发了死锁」章节



先创建一个 `hero` 表并插入数据，用于后续演示。

```sql
CREATE TABLE hero (
    number INT,
    name VARCHAR(100),
    country varchar(100),
    PRIMARY KEY (number),
    KEY idx_name (name)
) Engine=InnoDB CHARSET=utf8;

INSERT INTO hero VALUES
    (1, 'l刘备', '蜀'),
    (3, 'z诸葛亮', '蜀'),
    (8, 'c曹操', '魏'),
    (15, 'x荀彧', '魏'),
    (20, 's孙权', '吴');
```


考虑如下并发事务场景。

| 发生时间编号 |     事务T1     |       事务T2   |
|------------|----------------|---------------|
|    1       |     BEGIN      |               |
|    2       |                |    BEGIN      |
| 3 | INSERT INTO hero(name,country) VALUES('g关羽','蜀') |   |
| 4 |  | INSERT INTO hero(name,country) VALUES('g关羽','蜀')  | 
| 5 | INSERT INTO hero(name,country) VALUES('g关羽','蜀') |   |


1. 时间序号3中，事务 T1 先插入 `name=g关羽` 的记录，可以插入成功，此时对应的唯一二级索引记录被隐式锁保护。
2. 时间序号4中，事务 T2 也插入 `name=g关羽` 的记录，由于 T1 已经插入 `name=g关羽` 的记录，所以 T2 在插入二级索引记录时，会遇到重复的唯一二级索引列值，此时 T2 想获取一个S型临键锁（`Next-key Lock`）（RC隔离级别）。但是 T1 并未提交，T1 插入的 `name=g关羽` 的记录上的隐式锁相当于一个X型记录锁，所以 T2 在获取S型临键锁时会遇到锁冲突，T2 进入阻塞状态，并且将T1 的隐式锁转换为显式锁（就是帮助 T1 生成一个记录锁的锁结构）。
3. 此时，T1 持有的 `name=g关羽` 记录的隐式锁已经被转换为显式锁（X型记录锁），T2 正在等待获取一个 S型临键锁（`Next-key Lock`）
4. 时间序号5中，事务 T1 插入一条 `name=d邓艾` 的记录。在插入一条记录时，会在页面中先定位到这条记录的位置，`name=d邓艾` 二级索引记录所在位置的下一条记录是 `name=g关羽`（按照汉语拼音排序）。所以，在插入 `name=d邓艾` 的记录时，就需要看一下 `name=g关羽` 的二级索引记录上有没有被别的事务加 GAP 锁。
5. 此时，T2 已经在 `name=g关羽` 的二级索引记录上生成了一个S型临键锁（临键锁的本质是一个记录锁和一个间隙锁的合体），虽然 T2 正在阻塞（尚未获取锁），但是 T1 仍然不能插入 `name=d邓艾` 的二级索引记录。

> **只要别的事务生成了一个显式的 GAP 锁的锁结构，不论那个事务已经获取（`granted`）到了该锁，还是正在等待获取（`waiting`），当前事务的 INSERT 操作都应该被阻塞。**

至此，变产生了死锁
* T1 在等待 T2 释放 `name=g关羽` 的二级索引记录上的 GAP 锁
* T2 在等待 T1 释放 `name=g关羽` 的二级索引记录上的 X 型记录锁
* 两个事务相互等待对方释放锁，产生了死锁


那么，如何解决这个死锁问题呢？有两个方案
* 方案1：一个事务中只插入一条记录。
* 方案2：先插入 `name=d邓艾` 的记录，再插入 `name=g关羽` 的记录

## 锁表


### 什么是锁表

> 事务并发执行中，使用了锁，并造成了等待和阻塞，我们称之为发生了「锁表」。

举个例子，一个会话对表执行的 insert、update 或 delete 操作还未提交，另一个会话也对同一个表进行相同的操作，则此时会产生锁表，产生阻塞。




### select锁表分析
* ref 1-[select ... for update会锁表还是锁行 | 腾讯云](https://cloud.tencent.com/developer/article/1896441)
* ref 2-[Mysql「Select For Update」锁机制分析 | 掘金](https://juejin.cn/post/7002103448427003940)

在使用 `select ...for update` 语句查询时，是会锁表还是锁行
1. 如果查询条件用了索引/主键，则会锁行
2. 如果是普通字段，没有索引/主键，则会锁表




### update锁表分析
* ref 1-[update 没有索引则会锁全表 | 华为云](https://bbs.huaweicloud.com/blogs/300169)


此处给出一个 update 命令执行造成的锁表示例。在表 `studentTable` 中，有字段 `kid`，并为该字段添加了普通索引。此时，执行如下语句

```sql
update table set name='lbs' where kid=12;
```

1. 若满足 `kid=12` 条件的记录有多个，会加 Next-key 锁，锁定一个范围，最终造成锁表。
2. 若满足 `kid=12` 条件的记录只有一个，会加记录锁，只会锁一行，不会造成锁表。
3. 如果 `kid` 没有索引，则更新过程中会回表，会加 Next-key 锁，锁定一个范围，造成锁表


由此可得出结论
1. **用索引字段做为条件进行修改时，是否表锁的取决于这个索引字段能否确定记录唯一。当索引值对应记录不唯一，会进行锁表，相反则不会锁表，只会使用行锁。**
2. **用无索引字段做为条件进行修改时，过程中会进行回表，整个更新过程会造成锁表。**


下面结合参考资料 `ref-1` 对上面的结论进行解释说明。
* InnoDB 存储引擎的默认事务隔离级别是「可重复读」，但是在这个隔离级别（SQL标准隔离级别定义下）下会出现幻读的问题
* **但是 MySQL中，在使用InnoDB存储引擎时，是可以避免幻读发生的。这是因为 InnoDB 存储引擎自己实现了行锁，通过 next-key 锁（记录锁和间隙锁的组合）来锁住记录本身和记录之间的“间隙”，防止其他事务在这个记录之间插入新的记录，从而避免了幻读现象。**
* 在执行 update 语句时，会对记录加X型独占锁，如果其他事务对持有独占锁的记录进行修改时，是会被阻塞的。另外，这个锁并不是执行完 update 语句就会释放的，而是会等事务结束时才会释放。
* **在 InnoDB 事务中，对记录加锁带基本单位是 next-key 锁，但是会因为一些条件会退化成间隙锁或者记录锁。加锁的位置准确的说，锁是加在索引上的而非行上。比如，在 update 语句的 where 条件使用了唯一索引，那么 next-key 锁会退化成记录锁，也就是只会给一行记录加锁。**


### 如何查看和解决锁表

* ref 1-[MySQL锁表原因和如何解决 | InfoQ](https://xie.infoq.cn/article/469900fb8757d181892384335)


1. 执行 `show open tables where in_use > 0;` 查看表是否在使用

```sql
mysql>  show open tables where in_use > 0 ;
+----------+-------+--------+-------------+
| Database | Table | In_use | Name_locked |
+----------+-------+--------+-------------+
| test     | t     |      1 |           0 |
+----------+-------+--------+-------------+
```

2. 使用 `show  processlist;` 查看数据库当前的进程

> `show processlist` 是显示用户正在运行的线程，需要注意的是，除了 root 用户能看到所有正在运行的线程外，其他用户都只能看到自己正在运行的线程，看不到其它用户正在运行的线程。


3. 查看当前的事务

```sql
SELECT * FROM information_schema.INNODB_TRX; 
```

4. 查看当前的锁和锁等待关系

```sql
-- MySQL 8.0版本前
SELECT * FROM information_schema.INNODB_LOCKs;
SELECT * FROM information_schema.INNODB_LOCK_WAITS;

-- MySQL 8.0版本后
SELECT * FROM performance_schema.data_locks;
SELECT * FROM performance_schema.data_locks_waits;

-- 该步骤，也可使用 show engine innodb status 查看
SHOW ENGINE INNODB STATUS;
```


5. 获取要结束的事务的线程ID

```sql
mysql > SELECT p.id,p.time,i.trx_id,i.trx_state,p.info 
> FROM INFORMATION_SCHEMA.PROCESSLIST p, INFORMATION_SCHEMA.INNODB_TRX i 
> WHERE p.id = i.trx_mysql_thread_id    
> AND i.trx_state = 'LOCK WAIT';

+----+------+--------+-----------+-------------------------+
| id | time | trx_id | trx_state | info                    |
+----+------+--------+-----------+-------------------------+
| 41 |   27 | 23312  | LOCK WAIT | delete from t where c=1 |
+----+------+--------+-----------+-------------------------+
1 row in set (0.01 sec)
```


6. 使用 `kill` 命令结束相应的事务

```sql
kill -9 [线程ID] #该示例中为41
```


## FAQ

### 删除表数据并避免锁表

如果要删除一个表里面的前 10000 行数据，有以下 3 种方法
1. 直接执行 `delete from T limit 10000;`
2. 在一个连接中循环执行 20 次 `delete from T limit 500;`
3. 在 20 个连接中同时执行 `delete from T limit 500;`

上述三种方案，哪个最好呢？
1. 方案1中，事务执行相对较长，即「大事务」，占用锁的时间较长，会导致其他客户端等待资源时间较长。
2. 方案2中，串行化执行，将相对长的事务分成多次相对短的事务，则每次事务占用锁的时间相对较短，其他客户端在等待相应资源的时间也较短。这样的操作，同时也意味着将资源分片使用（每次执行使用不同片段的资源），可以提高并发性。
3. 方案3中，人为自己制造锁竞争，加剧并发量。 


### 锁是加在索引上的


先创建一个 `hero` 表并插入数据，用于后续演示。

```sql
CREATE TABLE hero (
    number INT,
    name VARCHAR(100),
    country varchar(100),
    PRIMARY KEY (number),
    KEY idx_name (name)
) Engine=InnoDB CHARSET=utf8;

INSERT INTO hero VALUES
    (1, 'l刘备', '蜀'),
    (3, 'z诸葛亮', '蜀'),
    (8, 'c曹操', '魏'),
    (15, 'x荀彧', '魏'),
    (20, 's孙权', '吴');
```


对于 `hero` 表，执行下面两条语句，最终查询到的结果是一样的，但是两条语句执行过程中加的锁也是一样的吗？

答案是加锁情况是不一样的，锁是加到「索引」上的。两条语句执行过程中使用到的索引不一样，故加锁情况也不一样。

```sql
-- 只会在主键索引记录上加锁
SELECT * FROM hero WHERE number = 8 LOCK IN SHARE MODE;

-- 对主键索引和二级索引都会加锁，加锁情况如下图所示
SELECT * FROM hero WHERE name = 'c曹操' LOCK IN SHARE MODE;
```



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-lock-on-index-1.png)