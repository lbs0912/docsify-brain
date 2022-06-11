
# NoSQL-04-Clickhouse


[TOC]



## 更新
* 2022/05/22，撰写




## 参考资料
* [Clickhouse Cookbook](https://clickhouse.com/docs/zh/)


## 什么是ClickHouse

ClickHouse 是一个用于联机分析（OLAP）的列式数据库管理系统（DBMS）。

### ClickHouse的特性
* 真正的列式数据库管理系统
* 数据压缩
* 数据的磁盘存储（相比内存存储，降低了成本）
* 多核心并行处理
* 多服务器分布式处理，支持分布式的查询处理。（在 ClickHouse 中，数据可以保存在不同的 `shard` 上，每一个 `shard` 都由一组用于容错的 `replica` 组成，查询可以并行地在所有 `shard` 上进行处理。并且这些处理对用户来说是透明的。）
* 支持SQL（ClickHouse 支持一种基于 SQL 的声明式查询语言，它在许多情况下与 ANSI SQL 标准相同）
* 向量引擎
* 实时的数据更新（数据可以持续不断地高效的写入到表中，并且写入的过程中不会存在任何加锁的行为）
* 索引（按照主键对数据进行排序，这将帮助 ClickHouse 在几十毫秒以内完成对数据特定值或范围的查找）
* 支持近似计算（允许牺牲数据精度的情况下对查询进行加速）
* Adaptive Join Algorithm（ClickHouse 支持自定义 JOIN 多个表，它更倾向于散列连接算法，如果有多个大表，则使用合并-连接算法）
* 支持数据复制和数据完整性
* 角色的访问控制
  

在 CK 官网介绍的基础上，对 CK 的特性做如下补充说明
* 索引非 B 树结构，不需要满足最左原则；只要过滤条件在索引列中包含即可；即使在使用的数据不在索引中，由于各种并行处理机制，ClickHouse 全表扫描的速度也很快。
* 写入速度非常快，50-200M/s，对于大量的数据更新非常适用。
* **通过 CK 可以使用极其低的成本来完成以往 RDBMS（比如 MySQL）做不到的准实时级别的数据分析。**（参见 [CK快速上手 | 掘金](https://juejin.cn/post/7019636893033693191?share_token=729791e9-ebd0-45c0-927b-b39bc2a85246)）
* 快速分析一些离线数据，做数据计算、聚合、筛选。
* **通过数据压缩，CK 中亿级别以下的数据，最低只要 4 核心 16GB 的虚拟机就能轻松搞定。而亿级别到百亿级别的数据，只要你能搞定 32～64G 内存，计算出来的时间也只几乎只和你设备的核心数数量、CPU缓存大小是多少有关而已。**


### ClickHouse的限制
* 没有完整的事务支持
* 缺少高频率，低延迟的修改或删除已存在数据的能力。仅能用于批量删除或修改数据，但这符合 GDPR
* 稀疏索引使得 ClickHouse 不适合通过其键检索单行的点查询


在 CK 官网介绍的基础上，对 CK 的特性做如下补充说明
* **不支持高并发，官方建议 QPS 为 100，可以通过修改配置文件增加连接数，但是在服务器足够好的情况下。**
* SQL 满足日常使用 80% 以上的语法，JOIN 写法比较特殊；最新版已支持类似 SQL 的 JOIN，但性能不好。
* 尽量做 1000 条以上批量的写入，避免逐行 `insert` 或小批量的 `insert`，`update`，`delete` 操作，因为 ClickHouse 底层会不断的做异步的数据合并，会影响查询性能。
* ClickHouse 的分布式表性能性价比不如物理表高。
* 使用 CK 时，CPU 一般在 50% 左右会出现查询波动，达到 70% 会出现大范围的查询超时，CPU 是最关键的指标，要非常关注。


### ClickHouse的性能

详情参见 [CK 的性能 | Clickhouse Cookbook](https://clickhouse.com/docs/zh/introduction/performance)。


* 处理大量短查询的吞吐量
在相同的情况下，ClickHouse 可以在单个服务器上每秒处理数百个查询（在最佳的情况下最多可以处理数千个）。但是由于这不适用于分析型场景。**因此我们建议每秒最多查询 100 次。**



## 安装部署

推荐使用 CentOS、RedHat 和所有其他基于 rpm 的 Linux 发行版的官方预编译 rpm 包。


* 安装

```s
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://packages.clickhouse.com/rpm/clickhouse.repo
sudo yum install -y clickhouse-server clickhouse-client
```

* 启动
  
```s
sudo /etc/init.d/clickhouse-server start

# 默认情况下，使用default用户并不携带密码连接到localhost:9000
clickhouse-client # or "clickhouse-client --password" if you set up a password.
```

* 在 `clickhouse-client` 中查询数据库列表

```s
VM-4-16-centos :) show databases;

SHOW DATABASES

Query id: cfc7b330-5260-4d14-bcea-2abb78dabe24

┌─name───────────────┐
│ INFORMATION_SCHEMA │
│ default            │
│ information_schema │
│ system             │
└────────────────────┘

4 rows in set. Elapsed: 0.001 sec.
```




## 基本概念
* ref 1-[CK的基本概念 | 阿里云](https://help.aliyun.com/document_detail/167447.html)


### 分片（Shard）

在超大规模海量数据处理场景下，单台服务器的存储、计算资源会成为瓶颈。为了进一步提高效率，ClickHouse 将海量数据分散存储到多台服务器上，每台服务器只存储和处理海量数据的一部分，在这种架构下，每台服务器被称为一个分片（Shard）。



### 本地表和分布式表


ClickHouse 的表从数据分布上，可以分为本地表和分布式表两种类型。


|   类型  |	     说明	     |
|--------|-------------------------|
| 本地表（Local Table） | 数据只会存储在当前写入的节点上，不会被分散到多台服务器上 | 
| 分布式表（Distributed Table） |本地表的集合，它将多个本地表抽象为一张统一的表，对外提供写入、查询功能。当写入分布式表时，数据会被自动分发到集合中的各个本地表中；当查询分布式表时，集合中的各个本地表都会被分别查询，并且把最终结果汇总后返回。 |


本地表和分布式表的区别如下
* 本地表的写入和查询，受限于单台服务器的存储、计算资源，不具备横向拓展能力。
* 分布式表的写入和查询，可以利用多台服务器的存储、计算资源，具有较好的横向拓展能力。
* 分布式表实际上是一种 `view`，映射到 ClickHouse 集群的本地表。
* 从分布式表中执行 `SELECT` 查询会使用集群所有分片的资源。您可以为多个集群指定`configs`，并创建多个分布式表，为不同的集群提供视图。



### 单机表和复制表

ClickHouse 的表从存储引擎上，可以分为单机表、复制表两种类型。

|   类型  |	     说明	     |
|--------|-------------------------|
| 单机表（Non-Replicated Table） | 数据只会存储在当前服务器上，不会被复制到其他服务器，即只有一个副本 |
| 复制表（Replicated Table） | 数据会被自动复制到多台服务器上，形成多个副本 |

单机表和复制表的区别如下
* 单机表在异常情况下无法保证服务高可用。
* 复制表在至少有一个正常副本的情况下，能够对外提供服务。



## 集群部署

ClickHouse 集群是一个同质集群，设置步骤如下
1. 在群集的所有机器上安装ClickHouse服务端
2. 在配置文件中设置集群配置
3. 在每个实例上创建本地表
4. 创建一个分布式表






## 操作表


### 创建表

下面给出创建本地表和分布式表的建表语句。


1. 创建本地表（本地物理表）`materia.selection_yth_shop_rank_horse_pool`

```s
CREATE TABLE materia.selection_yth_shop_rank_horse_pool on cluster shwx_cluster11
(
    `dt` Date COMMENT 'dt',
    `shop_id` String COMMENT '店铺id',
    `shop_name` String DEFAULT '' COMMENT '店铺名称'
)
ENGINE = ReplicatedMergeTree('/clickhouse/shwxck.cl11.jddb.com/tables/{layer}-{shard}/materia/selection_yth_shop_rank_horse_pool', '{replica}')
PARTITION BY dt
PRIMARY KEY shop_id
ORDER BY shop_id
SETTINGS index_granularity = 8192
```


2. 创建分布式表 `materia.selection_yth_shop_rank_horse_pool_all`（使用 `_all` 后缀）


```s
 CREATE TABLE materia.selection_yth_shop_rank_horse_pool_all
(
    `dt` Date COMMENT 'dt',
    `shop_id` String COMMENT '店铺id',
    `shop_name` String DEFAULT '' COMMENT '店铺名称'
)
ENGINE = Distributed('shwx_cluster11', 'materia', 'selection_yth_shop_rank_horse_pool', rand());
```


### 删除表

```s
# 删除分布式表
DROP table materia.smart_marketing_new_sku_indicator_all ON CLUSTER shwx_cluster7;

# 删除本地表
DROP table materia.smart_marketing_new_sku_indicator ON CLUSTER shwx_cluster7;
```


## ClickHouse Playground
* [ClickHouse Playground](https://play.clickhouse.com/play?user=play#U0hPVyBEQVRBQkFTRVM=)
* [ClickHouse Playground 使用说明 | CK Cookbook](https://clickhouse.com/docs/zh/getting-started/playground)

无需搭建服务或集群，ClickHouse Playground 允许人们通过执行查询语句立即体验 ClickHouse。