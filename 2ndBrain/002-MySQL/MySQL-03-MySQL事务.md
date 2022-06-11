
# MySQL-03-MySQL事务

[TOC]

## 更新
* 2022/05/09，撰写


## 参考资料
* 书籍 [《MySQL是怎样运行的》从根儿上理解 MySQL](https://juejin.cn/book/6844733769996304392)



## 事务

* MySQL 中并不是所有存储引擎都支持事务的功能，目前只有 `InnoDB` 和 `NDB` 存储引擎支持事务，MyISAM 不支持事务。



### ACID
1. 原子性（Atomicity）
2. 一致性（Consistency）
3. 隔离性（Isolation）
4. 持久性（Durability）

### 事务的状态
* 活动的（active）
* 部分提交的（partially committed）：当事务中的最后一个操作执行完成，但由于操作都在内存中执行，**所造成的影响并没有刷新到磁盘时**，我们就说该事务处在部分提交的状态。
* 失败的（failed）
* 中止的（aborted）：当回滚操作执行完毕时，也就是数据库恢复到了执行事务之前的状态，我们就说该事务处在了中止的状态。
* 提交的（committed）：当一个处在部分提交的状态的事务将修改过的数据都同步到磁盘上之后，我们就可以说该事务处在了提交的状态。

### 事务相关语法

* 开启事务

```s
BEGIN [WORK]
# 或
START TRANSACTION [READ ONLY] | [READ WRITE] | [WITH CONSISTENT SNAPSHOT]
```

* 提交事务

```s
COMMIT [WORK]
```

* 中止事务

```s
ROLLBACK [WORK]
```

* 自动提交事务：MySQL 默认自动提交事务，可通过 `autocommit` 属性进行设置


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

* 关闭自动提交事务
  - 使用 `START TRANSACTION` 或者 `BEGIN` 语句显式开启事务，将关闭自动提交事务功能
  - `SET autocommit = OFF` 也可以关闭自动提交事务

* 事务的隐式提交
  - 详情参考 [《MySQL是怎样运行的》从根儿上理解 MySQL](https://juejin.cn/book/6844733769996304392)

* 保存点

```s
# 创建一个保存点
SAVEPOINT 保存点名称;

# 回滚到指定的保存点
ROLLBACK [WORK] TO [SAVEPOINT] 保存点名称;

# 删除保存点
RELEASE SAVEPOINT 保存点名称;
```


## 事务隔离级别

### 事务并发执行遇到的问题

* ref 1-[大白话讲解脏写、脏读、不可重复读和幻读 | 掘金](https://juejin.cn/post/6954535074637283358)


事务并发执行，会遇到一些问题，按照严重性从高到低排序为

1. 脏写（Dirty Write）：脏写也称为更新丢失（`Lost Update`）。
2. 脏读（Dirty Read）
3. 不可重复读（Non-Repeatable Read）：指在数据库访问中，一个事务范围内两个相同的查询却返回了不同数据。
4. 幻读（Phantom）：幻读强调的是一个事务按照某个相同条件多次读取记录时，后读取时读到了之前没有读到的记录。



### SQL标准中的4种隔离级别

SQL标准中，设立了 4 种隔离级别，隔离级别越低，越严重的问题就越可能发生。4 种隔离级别从低到高为


|  隔离级别  |   脏写（更新丢失）  | 脏读  |  不可重复读  |  幻读  |
|-----------|--------|-------|------------|-------|
| READ UNCOMMITTED（未提交读）| No | 可能 | 可能 | 可能 |
| READ COMMITTED（已提交读）| No | No | 可能 | 可能  |
| REPEATABLE READ（可重复读）| No | No | No | 可能  |
| SERIALIZABLE（可串行化）| No | No | No |  No  |


从上表可以看到
* 「脏读」问题最严重，所有隔离级别均保证不会发生脏读
* `SERIALIZABLE（可串行化）` 隔离级别最高，4种并发问题均不会发生，但是串行的执行，也拉低了系统性能

### MySQL中支持的四种隔离级别

* 不同的数据库厂商对 SQL 标准中规定的 4 种隔离级别支持不一样。
* Oracle 只支持 `READ COMMITTED` 和 `SERIALIZABLE` 隔离级别。
* MySQL 的默认隔离级别为 `REPEATABLE READ`。
* MySQL 虽然支持上述 4 种隔离级别，但与 SQL 标准中所规定的各级隔离级别允许发生的问题却有些出入。MySQL 在 `REPEATABLE READ` 隔离级别下，是可以禁止幻读问题的发生的。解决方案有两种
  * 使用MVCC方案
  * 使用加锁方案，用到了临键锁 (Next-key Lock）和间隙锁




> **与 SQL 标准不同的地方在于，`InnoDB` 存储引擎在 `REPEATABLE-READ`（可重读）事务隔离级别下使用的是 `Next-Key Lock` 锁算法，因此可以避免幻读的产生，这与其他数据库系统(如 SQL Server)是不同的。也就是说，`InnoDB` 存储引擎的默认支持的隔离级别是 `REPEATABLE-READ`（可重读） 已经可以完全保证事务的隔离性要求，即达到了 SQL 标准的 `SERIALIZABLE` (可串行化) 隔离级别。**


MySQL InnoDB 存储引擎的默认支持的隔离级别是 `REPEATABLE-READ`（可重读）。我们可以通过 `SELECT @@tx_isolation;` 命令来查看。需要注意的是，在 MySQL 8.X 中，`tx_isolation` 被命名为 `transaction_isolation`。


```sql
//非MySQL 8.x

mysql> SELECT @@tx_isolation;
+-----------------+
| @@tx_isolation  |
+-----------------+
| REPEATABLE-READ |
+-----------------+
```

```sql
//MySQL 8.x
mysql> select @@transaction_isolation;
+-------------------------+
| @@transaction_isolation |
+-------------------------+
| REPEATABLE-READ         |
+-------------------------+
1 row in set (0.00 sec)

mysql> show  variables like 'transaction_isolation';
+-----------------------+-----------------+
| Variable_name         | Value           |
+-----------------------+-----------------+
| transaction_isolation | REPEATABLE-READ |
+-----------------------+-----------------+
1 row in set (0.02 sec)
```


### 如何设置事务的隔离级别

可以通过下边的语句修改事务的隔离级别。

```sql
SET [GLOBAL|SESSION] TRANSACTION ISOLATION LEVEL level;
```

其中的 `level` 可选值有 4 个

```s
level: {
     REPEATABLE READ
   | READ COMMITTED
   | READ UNCOMMITTED
   | SERIALIZABLE
}
```

此处对 `[GLOBAL|SESSION]` 可选参数进行说明
* 使用 `GLOBAL` 关键字，事务级别的设置，影响全局范围
* 使用 `SESSION` 关键字，事务级别的设置，影响会话范围
* 两个关键字都不使用，事务级别的设置，只对执行语句后的下一个事务产生影响



## 多版本并发控指MVVC

关于「MVVC」章节内容，详情参考 [《MySQL是怎样运行的》从根儿上理解 MySQL](https://juejin.cn/book/6844733769996304392)，此处仅做大纲记录。


* MVCC（Multi-Version Concurrency Control），即「多版本并发控指」，指的是在使用 `READ COMMITTD` 和 `REPEATABLE READ` 这两种隔离级别的事务在执行普通的 `SELECT` 操作时，访问记录的版本链的过程。
* 通过 MVVC，可以使不同事务的读-写、写-读操作并发执行，从而提升系统性能。



### 版本链


对于使用 InnoDB 存储引擎的表来说，它的**聚簇索引**记录中都包含两个必要的隐藏列（`row_id` 并不是必要的，当创建的表中有主键或者非 NULL 的 UNIQUE 键时都不会包含 `row_id` 列）
1. `trx_id`：每次一个事务对某条聚簇索引记录进行改动时，都会把该事务的事务 id 赋值给 `trx_id` 隐藏列。
2. `roll_pointer`：每次对某条聚簇索引记录进行改动时，都会把旧的版本写入到 `undo` 日志中，然后这个隐藏列就相当于一个指针，可以通过它来找到该记录修改前的信息。


MySQL中，每次对记录进行改动，都会记录一条 `undo` 日志，每条 `undo` 日志也都有一个 `roll_pointer` 属性（`INSERT` 操作对应的 `undo` 日志没有该属性，因为该记录并没有更早的版本），可以将这些 `undo` 日志都连起来，串成一个链表，形成「版本链」，如下图琐事被。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-mvvc-version-link-1.png)



### ReadView


#### ReadView的作用
MySQL 中引入 `ReadView`的概念，来解决「当使用 `READ COMMITTED` 和 `REPEATABLE READ` 隔离级别的事务时，普通的 `SELECT` 查询时如何判断版本链中的哪个版本是当前事务可见的」问题。

#### 什么是ReadView

对于使用 `READ COMMITTED` 和 `REPEATABLE READ` 隔离级别的事务来说，都必须保证读到已经提交了的事务修改过的记录，也就是说假如另一个事务已经修改了记录但是尚未提交，是不能直接读取最新版本的记录的。因此，**核心问题就是需要判断一下版本链中的哪个版本是当前事务可见的。**

为此，引入了一个 `ReadView` 的概念，`ReadView` 中主要包含 4 个比较重要的内容
* `m_ids`：表示在生成 ReadView 时当前系统中活跃的读写事务的事务 id 列表。
* `min_trx_id`：表示在生成 ReadView 时当前系统中活跃的读写事务中最小的事务 id，也就是 `m_ids` 中的最小值。
* `max_trx_id`：表示生成 ReadView 时系统中应该分配给下一个事务的 id 值。

#### ReadView的使用

有了这个 ReadView，这样在访问某条记录时，只需要按照下边的步骤判断记录的某个版本是否可见
1. 如果被访问版本的 `trx_id` 属性值 等于（`=`）ReadView 中的 `creator_trx_id` 值，意味着当前事务在访问它自己修改过的记录，所以该版本可以被当前事务访问。
2. 如果 `trx_id` 小于（`<`）`min_trx_id` ，表明生成该版本的事务在当前事务生成 ReadView 前已经提交，所以该版本可以被当前事务访问。
3. 如果 `trx_id` 大于等于（`>=`）`min_trx_id` ，表明生成该版本的事务在当前事务生成 ReadView 后才开启，所以该版本不可以被当前事务访问。
4. 如果 `trx_id` 属性值在 `min_trx_id` 和 `max_trx_id` 之间，那就需要判断一下 `trx_id` 属性值是不是在 `m_ids` 列表中。
    * 如果在，说明创建 ReadView 时生成该版本的事务还是活跃的，该版本不可以被访问；
    * 如果不在，说明创建 ReadView 时生成该版本的事务已经被提交，该版本可以被访问。

#### ReadView的生成时机

在 MySQL 中，`READ COMMITTED` 和 `REPEATABLE READ` 隔离级别的的一个非常大的区别就是它们生成 `ReadView` 的时机不同
* `READ COMMITTED`：每次读取数据前都生成一个 ReadView
* `REPEATABLE READ`： 在第一次读取数据时生成一个 ReadView


