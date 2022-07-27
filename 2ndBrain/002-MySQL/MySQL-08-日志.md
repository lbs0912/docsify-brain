# MySQL-08-日志


[TOC]

## 更新
* 2022/06/09，撰写


## 参考资料
* [《MySQL是怎样运行的》从根儿上理解 MySQL](https://juejin.cn/book/6844733769996304392)
* [详细分析 MySQL 事务日志](https://www.cnblogs.com/f-ck-need-u/p/9010872.html)
* [MySQL 的三大日志的区别](https://segmentfault.com/a/1190000023827696)






## 前言

MySQL 中的日志主要包括 3 种（其实还有错误日志，慢查询日志，一般查询日志）
1. binlog 
   * 二进制日志，在存储引擎的上层（Server 层）产生
   * 用途主要由 2 个，用于主从复制和用于恢复
2. redo log
   * 物理日志，存储由 InnoDB 存储引擎实现
   * redo log 用于实现事务四大特性中的持久性
3. undo log
   * 逻辑日志，存储由 InnoDB 存储引擎实现
   * 用于事务的回滚（`rollback`）和多版本并发控制（MVVC）
   * 事务四大特性中的原子性，底层是通过 undo log 实现的

`redo log` 和 `undo log` 都是 InnoDB 的事务日志，`redo log` 是重做日志，提供前滚操作；`undo log` 是回滚日志，提供回滚操作。`undo log` 不是 `redo log` 的逆向过程，其实它们都算是用来恢复的日志。
* `redo log` 通常是物理日志，记录的是数据页的物理修改，而不是某一行或某几行修改成怎样怎样，它用来恢复提交后的物理数据页（恢复数据页，且只能恢复到最后一次提交的位置）。
* `undo` 用来回滚行记录到某个版本。`undo log` 一般是逻辑日志，根据每行记录进行记录。


> 1. 逻辑日志：可以简单理解为记录的就是 sql 语句 
> 
> 2. 物理日志：mysql 数据最终是保存在数据页中的，物理日志记录的就是数据页变更。



### binlog和redo log的区别

1. binlog 是二进制日志，在存储引擎的上层（Server 层）产生，主要用于主从复制和恢复。
2. redo log 是物理日志，存储由 InnoDB 存储引擎实现。redo log 用于实现事务四大特性中的持久性。
3. bin log 会记录所有与数据库有关的日志记录，包括 InnoDB、MyISAM 等存储引擎的日志，而 redo log 只记 InnoDB 存储引擎的日志。
4. 记录的内容不同，bin log 记录的是关于一个事务的具体操作内容，即该日志是逻辑日志。而 redo log 记录的是关于每个页（Page）的更改的物理情况。
5. **写入的时间不同，bin log 仅在事务提交前进行提交，也就是只写磁盘一次。而在事务进行的过程中，却不断被写入 redo log 中。**
6. 写入的方式也不相同，redo log 是循环写入和擦除，bin log 是追加写入，不会覆盖已经写的文件。



| 比较项 |	redo log	|   binlog    |
|-------|--------------|-------------|
| 文件大小	| redo log 的大小是固定的 | 	binlog 可通过配置参数 max_binlog_size 设置每个 binlog 文件的大小 |
| 实现方式	| redo log 是 InnoDB 引擎层实现的，并不是所有引擎都有 |	binlog 是 Server 层实现的，所有引擎都可以使用 binlog 日志 |
| 记录方式	| redo log 采用循环写的方式记录，当写到结尾时，会回到开头循环写日志 | binlog 通过追加的方式记录，当文件大小大于给定值后，后续的日志会记录到新的文件上 |
| 适用场景	| redo log 适用于崩溃恢复(crash-safe) |	binlog 适用于主从复制和数据恢复 |


从上表对比可知，binlog 日志只用于归档，只依靠 binlog 是没有 `crash-safe` 能力的。但只有 redo log 也不行，因为 redo log 是 InnoDB 特有的，且日志上的记录落盘后会被覆盖掉。因此需要 binlog 和 redo log 二者同时记录，才能保证当数据库发生宕机重启时，数据不会丢失。




## MySQL的6种日志


MySQL 日志文件有很多，包括 
1. 错误日志（error log）
   * 错误日志文件对 MySQL 的启动、运行、关闭过程进行了记录，能帮助定位 MySQL 问题。
2. 慢查询日志（slow query log）
   * 慢查询日志是用来记录执行时间超过 `long_query_time` 这个变量定义的时长的查询语句。
   * 通过慢查询日志，可以查找出哪些查询语句的执行效率很低，以便进行优化。
3. 一般查询日志（general log）
   * 一般查询日志记录了所有对 MySQL 数据库请求的信息，无论请求是否正确执行。
4. 二进制日志（bin log）
   * 关于二进制日志，它记录了数据库所有执行的 DDL 和 DML 语句（除了数据查询语句 select、show 等），以事件形式记录并保存在二进制文件中。


还有两个 InnoDB 存储引擎特有的日志文件

5. 重做日志（redo log）
   * 重做日志至关重要，因为它们记录了对于 InnoDB 存储引擎的事务日志。
6. 回滚日志（undo log）
   * 回滚日志同样也是 InnoDB 引擎提供的日志，顾名思义，回滚日志的作用就是对数据进行回滚。
   * 当事务对数据库进行修改，InnoDB 引擎不仅会记录 redo log，还会生成对应的 undo log日志；如果事务执行失败或调用了rollback，导致事务需要回滚，就可以利用 undo log 中的信息将数据回滚到修改之前的样子。




## 慢查询日志
* [MySQL开启慢查询日志 | CSDN](https://blog.csdn.net/keketrtr/article/details/95636815)
* [慢查询日志的配置 | Segmentfault](https://segmentfault.com/a/1190000019690756)


MySQL 默认是没有开启慢查询日志的，可以通过命令行或者修改 `my.cnf` 来开启。开启后对性能有一定的影响，生产环境不建议开启。

### 慢查询日志参数

1. `show variables like 'slow_query_log%';` 查看慢查询日志相关配置
   * `slow_query_log` 值为 ON 或 OFF，表示是否打开，默认关闭慢查询日志 
   * `slow_query_log_file` 表示慢查询日志的存放位置


```sql
mysql> show variables like "slow_query_log%";
+---------------------+----------------------------------------------+
| Variable_name       | Value                                        |
+---------------------+----------------------------------------------+
| slow_query_log      | OFF                                          |
| slow_query_log_file | /usr/local/var/mysql/lbsMacBook-Pro-slow.log |
+---------------------+----------------------------------------------+
2 rows in set (0.07 sec)
```

2. `show variables like "long_query_time%";` 查看慢查询日志判定阈值，默认为 10s。即大于 10s 的 查询，才会认为是慢查询。

```sql
mysql> show variables like "long_query_time%";
+-----------------+-----------+
| Variable_name   | Value     |
+-----------------+-----------+
| long_query_time | 10.000000 |
+-----------------+-----------+
1 row in set (0.01 sec)
```


### 配置慢查询日志


1. 临时修改参数配置（mysql重启后该配置失效）


```s
# 打开慢查询日志
set global slow_query_log='ON';
# 慢查询日志的存放位置
set global slow_query_log_file='/var/lib/mysql/tmp_slow.log';
# 慢查询日志的时间判定阈值
set global long_query_time=1;

# 默认是FILE。如果也有TABLE，则同时输出到mysql库的slow_log表中
set global log_output='FILE,TABLE'; 
```

2. 永久修改：修改 `my.cnf` 配置文件，在 `[mysqld]` 下的下方加入如下配置。

```s
# 1 表示打开慢查询日志
slow_query_log=1
# 慢查询日志的存放位置
slow_query_log_file=/var/lib/mysql/slow-log.log
# 慢查询日志的时间判定阈值
long_query_time=3
```


## binlog


binlog（`binary log`）是二进制日志，可以记录数据库发生的变化，比如表的新建，表的修改，数据的插入和删除等。

binlog 的作用有 2 个
1. 用于主从复制
2. 用于恢复


使用 `show variables like 'log_bin';` 可以查看 binglog 日志是否打开。

```sql
mysql> show variables like 'log_bin';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| log_bin       | ON    |
+---------------+-------+

```


### binlog的3种格式

binlog 日志有三种格式，分别是
1. statement
2. row
3. mixed

如果是 statement 格式，binlog 记录的是 SQL 的原文，如果主库和从库选的索引不一致，可能会导致主库不一致。

row 格式的 binlog 日志，记录的不是 SQL 原文，而是两个 `event:Table_map` 和 `Delete_rows`。`Table_map event` 说明要操作的表，`Delete_rows event` 用于定义要删除的行为，记录删除的具体行数。row 格式的 binlog 记录的就是要删除的主键 ID 信息，因此不会出现主从不一致的问题。


row 格式会很占空间，因此设计 MySQL 的大叔想了一个折中的方案，`mixed` 格式的 binlog。所谓的 `mixed` 格式其实就是 row 和 statement 格式混合使用，当 MySQL 判断可能数据不一致时，就用 row 格式，否则使用就用 statement 格式。



## redo log



`redo log` 不是二进制日志。虽然二进制日志中也记录了 innodb 表的很多操作，也能实现重做的功能，但是它们之间有很大区别。
1. 二进制日志是在存储引擎的上层（Server层）产生的，不管是什么存储引擎，对数据库进行了修改都会产生二进制日志。而 `redo log` 是 innodb 层产生的，只记录该存储引擎中表的修改。**并且二进制日志先于 `redo log` 被记录。**
2. `redo log` 是 `InnoDB` 引擎特有的；`binlog` 是 MySQL 的 `Server` 层实现的，所有引擎都可以使用。
3. 二进制日志记录操作的方法是逻辑性的语句。即便它是基于行格式的记录方式，其本质也还是逻辑的 SQL 设置，如该行记录的每列的值是多少。而 redo log 是在物理格式上的日志，它记录的是数据库中每个页的修改。
4. redo log 是物理日志，记录的是 “在某个数据页上做了什么修改”。binlog 是逻辑日志，记录的是这个语句的原始逻辑，比如 “给 ID=2 这一行的 c 字段加 1”。
5. binlog 可以作为恢复数据使用，主从复制搭建。redo log 作为异常宕机或者介质故障后的数据恢复使用。



### 顺序IO
* ref 1-[《MySQL是怎样运行的》从根儿上理解 MySQL](https://juejin.cn/book/6844733769996304392)，「redo 日志」章节
* ref 2-[MySQL 为什么需要 redo log | CSDN](https://www.csdn.net/tags/NtzaYg2sODg4NjAtYmxvZwO0O0OO0O0O.html)


思考一个问题，如何将一个事务的修改，持久化下来？一个很简单的做法就是在事务提交完成之前，把该事务所修改的所有页面都刷新到磁盘，但是这个简单粗暴的做法有些问题
1. 刷新一个完整的数据页太浪费了
   * 有时候我们仅仅修改了某个页面中的一个字节，但是我们知道在 InnoDB 中是以页为单位来进行磁盘 IO 的，也就是说我们在该事务提交时不得不将一个完整的页面从内存中刷新到磁盘。我们又知道一个页面默认是 16KB 大小，只修改一个字节就要刷新 16KB 的数据到磁盘上显然是太浪费了。
2. 随机 IO 刷起来比较慢
   * 一个事务可能包含很多语句，即使是一条语句也可能修改许多页面，倒霉催的是该事务修改的这些页面可能并不相邻，这就意味着在将某个事务修改的 Buffer Pool 中的页面刷新到磁盘时，需要进行很多的**随机 IO**，随机 IO 比顺序 IO 要慢，尤其对于传统的机械硬盘来说。



咋办呢？再次回到我们的初心，我们只是想让已经提交了的事务对数据库中数据所做的修改永久生效，即使后来系统崩溃，在重启后也能把这种修改恢复出来。所以我们其实没有必要在每次事务提交时，就把该事务在内存中修改过的全部页面刷新到磁盘，只需要把修改了哪些东西记录一下就好，比方说某个事务将系统表空间中的第 100 号页面中偏移量为 1000 处的那个字节的值 1 改成 2，我们只需要记录一下

```s
将第0号表空间的100号页面的偏移量为1000处的值更新为2。
```

这样我们在事务提交时，把上述内容刷新到磁盘中，即使之后系统崩溃了，重启之后只要按照上述内容所记录的步骤重新更新一下数据页，那么该事务对数据库中所做的修改又可以被恢复出来，也就意味着满足持久性的要求。因为在系统崩溃重启时需要按照上述内容所记录的步骤重新更新数据页，所以上述内容也被称之为「重做日志」，英文名为 redo log，我们也可以土洋结合，称之为 redo 日志。

与在事务提交时将所有修改过的内存中的页面刷新到磁盘中相比，只将该事务执行过程中产生的 redo 日志刷新到磁盘的好处如下
1. redo 日志占用的空间非常小
   * 存储表空间ID、页号、偏移量以及需要更新的值所需的存储空间是很小的，关于 redo 日志的格式我们稍后会详细唠叨，现在只要知道一条 redo 日志占用的空间不是很大就好了。
2. **redo日志是顺序写入磁盘的**
   * 在执行事务的过程中，每执行一条语句，就可能产生若干条 redo 日志，这些日志是按照产生的顺序写入磁盘的，也就是使用顺序 IO。

> redo 日志，会把数据写盘的随机 IO 变成顺序 IO，确切来说是把用户的操作先用顺序 IO 写下来提高响应速度。

### redo日志格式

redo 日志本质上只是记录了一下事务对数据库做了哪些修改。 设计 InnoDB 的大叔们针对事务对数据库的不同修改场景定义了多种类型的 redo 日志，但是绝大部分类型的 redo 日志都有下边这种通用的结构。

```s
   | type | space ID | page number | data |
```
1. type：该条 redo 日志的类型。
   * 在 MySQL 5.7.21 这个版本中，设计 InnoDB 的大叔一共为 redo 日志设计了 53 种不同的类型
2. space ID：表空间 ID
3. page number：页号
4. data：该条 redo 日志的具体内容



### 基本概念

redo log 包括两部分
1. 内存中的日志缓冲（`redo log buffer`)，该部分日志是易失性的
2. 磁盘上的重做日志文件（`redo log file`)，该部分日志是持久的

在概念上，innodb 通过 `force log at commit` 机制实现事务的持久性，即在事务提交的时候，必须先将该事务的所有事务日志写入到磁盘上的 `redo log file` 和 `undo log file` 中进行持久化。



### redo log 是怎么输入磁盘的

* [MySQL六十六问，两万字+五十图详解](https://mp.weixin.qq.com/s/zSTyZ-8CFalwAYSB0PN6wA)


redo log 的写入不是直接落到磁盘，而是在内存中设置了一片称之为 redo log buffer 的连续内存空间，也就是 redo 日志缓冲区。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/mysql-redo-log-disk-1.png)


那 redo log 什么时候会刷入磁盘呢？

1. log buffer 空间不足时
   * log buffer 的大小是有限的，如果不停的往这个有限大小的 log buffer 里塞入日志，很快它就会被填满。
   * 如果当前写入 log buffer 的redo 日志量已经占满了 log buffer 总容量的大约一半左右，就需要把这些日志刷新到磁盘上。
2. 事务提交时
   * 在事务提交时，为了保证持久性，会把 log buffer 中的日志全部刷到磁盘。
   * 注意，这时候，除了本事务的，可能还会刷入其它事务的日志。

3. 后台线程输入
   * 有一个后台线程，大约每秒都会刷新一次 log buffer 中的 redo log 到磁盘。
4. 正常关闭服务器时
5. 触发checkpoint规则

下面对「checkpoint规则」进行具体介绍。
* 重做日志缓存、重做日志文件都是以块（block）的方式进行保存的，称之为重做日志块（redo log block），块的大小是固定的 512 字节。
* 我们的 redo log 它是固定大小的，可以看作是一个逻辑上的 log group，由一定数量的 log block 组成。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/mysql-redo-log-disk-2.png)

它的写入方式是从头到尾开始写，写到末尾又回到开头循环写。其中有两个标记位置。

write pos 是当前记录的位置，一边写一边后移，写到第 3 号文件末尾后就回到 0 号文件开头。checkpoint 是当前要擦除的位置，也是往后推移并且循环的，擦除记录前要把记录更新到磁盘。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/mysql-redo-log-disk-3.png)


当 write_pos 追上 checkpoint 时，表示 redo log 日志已经写满。这时候就不能接着往里写数据了，需要执行 checkpoint规则腾出可写空间。

所谓的 checkpoint 规则，就是 checkpoint 触发后，将 buffer 中日志页都刷到磁盘。




## undo log

`undo log` 的存储是由 InnoDB 存储引擎实现的。`undo log` 用于事务的回滚（`rollback`）和多版本并发控制（MVVC）。


`undo log` 和 `redo log` 记录物理日志不一样，它是逻辑日志。可以认为当 `delete` 一条记录时，`undo log` 中会记录一条对应的 `insert` 记录，反之亦然；当 `update` 一条记录时，它记录一条对应相反的 `update` 记录。

`undo log` 是采用段（`segment`）的方式来记录的，每个 `undo` 操作在记录的时候占用一个 `undo log segment`。

另外，`undo log` 也会产生 `redo log`，因为 `undo log` 也要实现持久性保护。


### 存储方式

InnoDB 存储引擎对 undo 的管理采用段的方式，`rollback segment` 称为回滚段，每个回滚段中有 1024 个 `undo log segment`。

在以前老版本，只支持 1 个 `rollback segment`，这样就只能记录 1024 个 `undo log segment`。后来 MySQL 5.5 可以支持 128 个 `rollback segment`，即支持 `128*1024` 个 undo 操作，还可以通过变量 `innodb_undo_logs`（5.6 版本以前该变量是  `innodb_rollback_segments`）自定义多少个 `rollback segment`，默认值为 128。


## group commit

为了提高性能，通常会将有关联性的多个数据修改操作放在一个事务中，这样可以避免对每个修改操作都执行完整的持久化操作。这种方式，可以看作是人为的「组提交（`group commit`）」。

除了将多个操作组合在一个事务中，记录 binlog 的操作也可以按组的思想进行优化：将多个事务涉及到的 binlog 一次性 flush，而不是每次 flush 一个 binlog。


事务在提交的时候不仅会记录事务日志，还会记录二进制日志，但是它们谁先记录呢？二进制日志是 MySQL 的上层（Server 层）日志，先于存储引擎的事务日志被写入。
1. 在 MySQL 5.6 以前，当事务提交（即发出 `commit` 指令）后，MySQL 接收到该信号进入 `commit prepare` 阶段；
2. 进入 `prepare` 阶段后，立即写内存中的二进制日志，写完内存中的二进制日志后就相当于确定了 `commit` 操作；
3. 然后开始写内存中的事务日志；
4. 最后将二进制日志和事务日志刷盘。它们如何刷盘，分别由变量 `sync_binlog` 和 `innodb_flush_log_at_trx_commit` 控制；


但因为要保证二进制日志和事务日志的一致性，在提交后的 `prepare` 阶段会启用一个 `prepare_commit_mutex` 锁来保证它们的顺序性和一致性。但这样会导致开启二进制日志后 `group commmit` 失效，特别是在主从复制结构中，几乎都会开启二进制日志。

在 MySQL 5.6 中进行了改进。提交事务时，在存储引擎层的上一层结构中会将事务按序放入一个队列，队列中的第一个事务称为 leader，其他事务称为 follower，leader 控制着 follower 的行为。虽然顺序还是一样先刷二进制，再刷事务日志，但是机制完全改变了：删除了原来的 `prepare_commit_mutex` 行为，也能保证即使开启了二进制日志，`group commit` 也是有效的。

MySQL 5.6 中分为 3 个步骤
1. flush 阶段
   * 向内存中写入每个事务的二进制日志
2. sync 阶段
   * 将内存中的二进制日志刷盘。若队列中有多个事务，那么仅一次 `fsync` 操作就完成了二进制日志的刷盘操作。这在 MySQL 5.6 中称为 BLGC（`binary log group commit`)
3. commit 阶段
   * leader 根据顺序调用存储引擎层事务的提交，由于 innodb 本就支持 group commit，所以解决了因为锁 `prepare_commit_mutex` 而导致的 group commit 失效问题

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/mysql-group-commit-1.png)



在 flush 阶段写入二进制日志到内存中，但是不是写完就进入 sync 阶段的，而是要等待一定的时间，多积累几个事务的 binlog 一起进入 sync 阶段，等待时间由变量 `binlog_max_flush_queue_tim` 决定，默认值为 0，表示不等待直接进入 sync，设置该变量为一个大于 0 的值的好处是 group 中的事务多了，性能会好一些，但是这样会导致事务的响应时间变慢，所以建议不要修改该变量的值，除非事务量非常多并且不断的在写入和更新。

进入到 sync 阶段，会将 binlog 从内存中刷入到磁盘，刷入的数量和单独的二进制日志刷盘一样，由变量 sync_binlog 控制。

当有一组事务在进行 `commit` 阶段时，其他新事务可以进行 `flush` 阶段，它们本就不会相互阻塞，所以 group commit 会不断生效。当然，`group commit` 的性能和队列中的事务数量有关，如果每次队列中只有 1 个事务，那么 `group commit` 和单独的 `commit` 没什么区别，当队列中事务越来越多时，即提交事务越多越快时，`group commit` 的效果越明显。
