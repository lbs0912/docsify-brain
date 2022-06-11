

# CK Notes-01-CK学习笔记


[TOC]


## 更新
* 2022/01/20，撰写


## 学习资料



## FAQ


### CK Table xxx doesn't exist (version 21.2.3.15 (official build))


在 CK 开发过程中遇到如下报错。


```s
Exception in thread "main" ru.yandex.clickhouse.except.ClickHouseException: ClickHouse exception, code: 60, host: shwxck.cl11.jddb.com, port: 8123; Code: 60, e.displayText() = DB::Exception: There was an error on [172.18.164.17:9000]: Code: 60, e.displayText() = DB::Exception: Table materia.selection_yth_shop_rank_horse doesn't exist (version 21.2.3.15 (official build)) (version 21.2.3.15 (official build))
```
 

这是因为在建表时，未创建到集群上，只是创建到了一台机器上。CK建表语句如下，需要显示指定集群，即 `[ON CLUSTER cluster]`，参考 [Clickhouse建表语法](https://www.cnblogs.com/biehongli/p/14430153.html)

```s
CREATE TABLE [IF NOT EXISTS] [db.]table_name [ON CLUSTER cluster]
(
  name1 [type1] [DEFAULT|MATERIALIZED|ALIAS expr1],
  name2 [type2] [DEFAULT|MATERIALIZED|ALIAS expr2],
  ...
) ENGINE = engine
```

