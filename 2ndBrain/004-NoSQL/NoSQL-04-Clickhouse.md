
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
* **向量引擎**
* 实时的数据更新（数据可以持续不断地高效的写入到表中，并且写入的过程中不会存在任何加锁的行为）
* 索引（按照主键对数据进行排序，这将帮助 ClickHouse 在几十毫秒以内完成对数据特定值或范围的查找）
* 支持近似计算（允许牺牲数据精度的情况下对查询进行加速）
* Adaptive Join Algorithm（ClickHouse 支持自定义 JOIN 多个表，它更倾向于散列连接算法，如果有多个大表，则使用合并-连接算法）
* 支持数据复制和数据完整性
* 角色的访问控制
  

在 CK 官网介绍的基础上，对 CK 的特性做如下补充说明
* **索引非 B 树结构，不需要满足最左原则；只要过滤条件在索引列中包含即可；即使在使用的数据不在索引中，由于各种并行处理机制，ClickHouse 全表扫描的速度也很快。**
* 写入速度非常快，50-200M/s，对于大量的数据更新非常适用。
* **通过 CK 可以使用极其低的成本来完成以往 RDBMS（比如 MySQL）做不到的准实时级别的数据分析。**（参见 [CK快速上手 | 掘金](https://juejin.cn/post/7019636893033693191?share_token=729791e9-ebd0-45c0-927b-b39bc2a85246)）
* 快速分析一些离线数据，做数据计算、聚合、筛选。
* **通过数据压缩，CK 中亿级别以下的数据，最低只要 4 核心 16GB 的虚拟机就能轻松搞定。而亿级别到百亿级别的数据，只要你能搞定 32～64G 内存，计算出来的时间也只几乎只和你设备的核心数数量、CPU缓存大小是多少有关而已。**


### ClickHouse的限制
* 没有完整的事务支持
* 缺少高频率，低延迟的修改或删除已存在数据的能力。仅能用于批量删除或修改数据，但这符合 GDPR
* **稀疏索引**使得 ClickHouse 不适合通过其键检索单行的点查询


在 CK 官网介绍的基础上，对 CK 的特性做如下补充说明
* **不支持高并发，官方建议 QPS 为 100，可以通过修改配置文件增加连接数，但是在服务器足够好的情况下。**
* SQL 满足日常使用 80% 以上的语法，JOIN 写法比较特殊；最新版已支持类似 SQL 的 JOIN，但性能不好。
* 尽量做 1000 条以上批量的写入，避免逐行 `insert` 或小批量的 `insert`，`update`，`delete` 操作，因为 ClickHouse 底层会不断的做异步的数据合并，会影响查询性能。
* **ClickHouse 的分布式表性能性价比不如物理表高。**
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



## CK的索引

* ref 1-[深入浅出Clickhouse: 索引结构设计](https://saintbacchus.github.io/2021/08/15/%E6%B7%B1%E5%85%A5%E6%B5%85%E5%87%BAClickhouse-%E7%B4%A2%E5%BC%95%E7%BB%93%E6%9E%84%E8%AE%BE%E8%AE%A1/)
* ref 2-[MergeTree | Cookbook](https://clickhouse.com/docs/zh/engines/table-engines/mergetree-family/mergetree/)



> 索引非 B 树结构，不需要满足最左原则，只要过滤条件在索引列中包含即可。即使在使用的数据不在索引中，由于各种并行处理机制，ClickHouse 全表扫描的速度也很快




**CK 中采用了 `MergeTree` 引擎（合并树引擎），存储的数据按主键排序。**
1. CK 的「主键索引」是一个「稀疏索引」
2. 对非排序字段的查询，CK 设计了一种叫做「跳数索引」的二级索引方式

### MergeTree

Clickhouse 中最强大的表引擎当属 `MergeTree` 引擎（合并树引擎）。

`MergeTree` 系列的引擎被设计用于插入极大量的数据到一张表当中。数据可以以「数据片段（Data Part）」的形式一个接着一个的快速写入，数据片段在后台按照一定的规则进行合并。相比在插入时不断修改（重写）已存储的数据，这种策略会高效很多。


`MergeTree` 有如下特点
1. **存储的数据按主键排序**
   * 这使得您能够创建一个小型的稀疏索引来加快数据检索
2. 如果指定了「分区键」的话，可以使用分区
   * 在相同数据集和相同结果集的情况下，CK 中某些带分区的操作会比普通操作更快。查询中指定了分区键时 CK 会自动截取分区数据，这也有效增加了查询性能
3. 支持数据副本
4. 支持数据采样

### 稀疏索引


Clickhouse 的「主键索引」是一个「稀疏索引」。它并不存储每一个行的数据，而是存储每个子矩阵的第一个行数据，因此 8192 行数据才会有一个索引值，索引非常小，对应的代价就是查找时，需要用折半查找的方式来查询具体的编号，复杂度为 `log(n)`。


### 跳跃索引

Clickhouse 对于非排序字段的查询，设计了一种叫做「跳数索引」的二级索引方式，名为「跳数」，意思是并非记录每个编号内的索引，而是选择一批编号进行计算，比如按照 2 个编号算一个跳数索引。



跳数索引有 3 种
1. min_max
   * 存储的是两个数据块中的最大最小值
2. set
3. bloomfilter



跳数索引主要的目的为判断查询的数值是否存在，如果不存在则跳过。由于跳数索引是随机的，因此的查询复杂度为 `O(n)`。

> 其实不应该叫做二级索引，因为 Clickhouse 没有回表的动作，跳数索引选中数据块之后，就直接通过暴力扫描的方式开始计算了。


### 索引的存储位置

* InnoDb 存储引擎中，将数据文件和索引放在一起。
* 而 CK 是数据文件和索引文件分开存储，Clickhouse 的数据存放在 `bin` 文件中，这是真正的存储的地方。


## CK的适用场景


**Clickhouse 索引的特点为「排序索引」+「稀疏索引」+「列式存储」，因此相应的Clickhouse 最合适的场景就是「基于排序字段的范围过滤后的聚合查询」。**

1. 因为排序索引（CK 中采用了 `MergeTree` 引擎（合并树引擎），存储的数据按主键排序），所有基于排序字段的查询会明显优于 MR 类型计算，否则 Hive/Spark 这类动态资源的更优。
2. 由于稀疏索引，点查询的效率可能没有 KV 型数据库高，因此适合相对大范围的过滤条件。
3. 因为列式存储，数据压缩率高，对应做聚合查询效率也会更高。




## CK为什么不支持高并发


CK 不支持高并发，官方建议 QPS 为 100，可以通过修改配置文件增加连接数（修改 `config.xml` 的 `max_concurrent_queries`配置），但是在服务器足够好的情况下。

CK 采用了「多核心并行处理机制」，即使一个查询，也会使用服务器一半的 CPU 去执行，所以 CK 不能支持高并发的使用场景。默认单查询使用 CPU 核数为服务器核数的一半，在安装 CK 时会自动识别服务器的核数，也可以通过配置文件修改该参数。

> 对于一个单查询，若请求达到 CK 集群上一台机器，则默认使用单机器 CPU 核数的一半。若请求打到 CK 集群上所有机器，则使用集群整个 CPU 核数的一半。




## CK为什么快
* ref 1-[ClickHouse 为什么快 | CSDN](https://blog.csdn.net/chenkeqin_2012/article/details/120676881)
* ref 2-[Clickhouse 为什么这么快 | CSDN](https://blog.csdn.net/sileiH/article/details/113702750)


1. 列式存储，适合做 OLAP
2. 数据压缩
3. 向量化执行引擎
   * CK 利用 CPU的 SIMD 指令实现了向量化执行
   * SIMD 的全称是 Single Instruction Multiple Data，即用单条指令操作多条数据。SIMD 是通过数据并行以提高性能的一种实现方式，它的原理是在 CPU 寄存器层面实现数据的并行操作
4. 数据分片与分布式查询
   * CK 集群由 1 到多个分片组成，而每个分片则对应了 CK 的 1 个服务节点。分片的数量上限取决于节点数量（1 个分片只能对应 1 个服务节点）
   * CK 提供了本地表（Local Table）与分布式表（Distributed Table）的概念
   * 一张本地表等同于一份数据的分片
   * 分布式表本身不存储任何数据，它是本地表的访问代理，其作用类似分库中间件。借助分布式表，能够代理访问多个数据分片，从而实现分布式查询
5. 核心并行处理
   * CK 采用了「多核心并行处理机制」，即使一个查询，也会使用服务器一半的 CPU 去执行
6. 硬件方面
   * CK 会在内存中进行 Group By，并使用 HashTable 装载数据
7. 算法方面
   * 对于常量，CK 使用了 Volnisky 算法；
   * 对于非常量，CK 使用 CPU 的向量化执行 SIMD 来优化
   * 对于正则，CK 使用 re2 和 hyperscan 算法
8. 持续测试和持续改进
   * CK 由于拥有 Yandex（俄罗斯的一家公司，世界第五大搜索引擎） 的天然优势，经常会使用真实数据来进行测试，尝试使用于各个场景
   * 也因此获得了快速的版本更新换代，基本维持在一个月一更新
  


## CK和ES的对比
* ref 1-[ClickHouse 与 ES 的优劣对比](https://www.cnblogs.com/xionggeclub/p/15100707.html)


### CK相比ES的优点

> 在京东营销选品项目中，秒杀池商品进行小时级更新，需要保证在 1 小时内写完数据。根据 CK 每秒写入数据可 超过 60W，则一小时写入的数据超过 `600W * 60 * 60`，大约是 216 亿。


1. ClickHouse 写入吞吐量大，单服务器日志写入量在 50MB 到 200MB/s，每秒写入超过 60w 记录数，**是 ES 的 5 倍以上**。
2. 查询速度快，官方宣称数据在 pagecache 中，单服务器查询速率大约在 2-30GB/s；没在 pagecache 的情况下，查询速度取决于磁盘的读取速率和数据的压缩率。
3. CK 比 ES 服务器成本更低
   * 一方面 CK 的数据压缩比，比 ES 高，相同数据占用的磁盘空间只有 ES 的 `1/3` 到 `1/30`，节省了磁盘空间的同时，也能有效的减少磁盘 IO。
   * 另一方面 CK 比 ES 占用更少的内存，消耗更少的 CPU 资源。
4. 相比 ES，CK 运维成本更低
   * ES 中不同的 Group 负载不均衡，有的 Group 负载高，会导致写 Rejected 等问题，需要人工迁移索引。
   * 在 CK 中通过集群和 Shard 策略，采用轮询写的方法，可以让数据比较均衡的分布到所有节点。
5. 相比 ES，CK 稳定性也更高
   * ES 中一个大查询可能导致 OOM 的问题。CK 通过预设的查询限制，会查询失败，不影响整体的稳定性。
   * ES 需要进行冷热数据分离，CK 按天分区（`partition`），一般不需要考虑冷热分离，特殊场景用户确实需要冷热分离的，数据量也会小很多，CK 自带的冷热分离机制就可以很好的解决。
6. ClickHouse 采用 SQL 语法，比 ES 的 DSL 更加简单，学习成本更低。


### CK相比ES的缺点

> ES 的底层是 Lucenc，主要是要解决搜索和全文检索的问题。ES 的核心技术是「倒排索引」和「布隆过滤器」。ES 通过分布式技术，利用「分片」与「副本」机制，直接解决了集群下搜索性能与高可用的问题。 -- [ES 不香吗，为啥还要 ClickHouse](https://www.dounaite.com/article/625c5f3c7cc4ff68e651751e.html)


1. **由于 CK 是列式数据库，无法像 ES 一样提供全文检索功能。**
2. CK 无法动态添加字段，需要提前定义好表 schema。
3. CK 日志无法长期保存，历史数据需定期清理下线，如果有保存历史数据需求，需要通过迁移数据，采用 ClickHouse_copier 或者复制数据的方式实现。
4. ClickHouse 查询速度快，能充分利用集群资源，但是无法支持高并发查询，默认配置 QPS 为 100。
5. Clickhouse 并不适合许多小数据高频插入，批量写入日志会有一定延迟。


### 性能数据对比

* ES 和 CK 磁盘空间对比
  
![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/ck-es-vs-1.png)

* ES 和 CK 查询效率对比

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/ck-es-vs-2.png)




## 一体化营销选品

### 项目架构设计

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/jd-yth-module-1.png)



### CK技术选型

此处以京东店铺赛马和一体化营销选品项目为例，阐述为什么赛马选择 ES + Hbase 的方案，营销选品选择 CK 方案。营销选品项目的功能划分如上图所示。



从业务角度考虑，有如下选型参考

1. 实时查询和非实时查询
   * 营销选品项目要进行实时查询，而 CK 性能较高，适合实时查询
   * 店铺赛马进行的是离线非实时查询（计算频率 24H），而 Hbase 适合存储大量的离线数据
2. 是否涉及到全文检索
   * 营销选品项目不涉及全文检索，可以使用 CK
   * 店铺赛马项目涉及到了全文检索，而 CK 是列式数据库，无法像 ES 一样提供全文检索功能。ES 适合用于全文检索
3. 营销选品项目涉及的筛选字段变更较大，利用「自定义规则和规则解析」，可以生成动态 SQL 查询。CK 对 SQL 语法支持较好，比 ES 的 DSL 更加简单，学习成本更低。
4. 营销选品项目涉及「小时级更新」和「数据分区」，这方面 CK 比较擅长。详情见下面「技术角度」的第 4 点和第 5 点

从技术角度考虑，有如下选型参考

1. CK 适合实时查询，Clickhouse 索引的特点为「排序索引（CK 中采用了 MergeTree 引擎（合并树引擎），存储的数据按主键排序）」+「稀疏索引」+「列式存储」，因此相应的 Clickhouse 最合适的场景就是 **「基于排序字段的范围过滤后的聚合查询」**。
2. ES + Hbase 用来处理离线数据
3. CK 不适合做全文搜索，而 ES 适合全文搜索
4. CK 使用了 MergeTree 引擎（合并树引擎）被设计用于插入极大量的数据到一张表当中。数据可以以「数据片段（Data Part）」的形式一个接着一个的快速写入，数据片段在后台按照一定的规则进行合并。相比在插入时不断修改（重写）已存储的数据，这种策略会高效很多。营销选品项目中，底表更新频率快，如小时级更新吗，要做到在一小时内写入千万级的数据。基于 CK 的「数据片段（Data Part）」特点，适合小时级的数据更新。
5. CK 中 MergeTree 引擎，如果指定了「分区键」的话，可以使用分区。在相同数据集和相同结果集的情况下，CK 中某些带分区的操作会比普通操作更快。查询中指定了分区键时 CK 会自动截取分区数据，这也有效增加了查询性能。营销选品项目涉及「数据分区」，这方面 CK 比较擅长。




### 计算模块

计算模块主要处理 3 部分工作
1. 打分计算并排序
   * 单一指标：直接取表中字段，进行过滤盒筛选
   * 综合指标：取出表中字段，根据配置的权重值算出得分，最后对得分进行归一化（抹平不同指标值大小的差异，归一化到 [0,1] 区间）
2. 干预
   * 人工干预置顶
   * 白名单和黑名单
3. 打散
   * 打散模块中的打散用于保证商品的多样性。比如用户搜索「手表」，可能匹配的前 10 个都是卡西欧手表，这个时候可以对结果进行打散，按照店铺维度（如卡西欧、小米、天王表）或者按照功能维度（如机械表、电子表）。
   * 采用平衡打散思想，在一个滑动窗口内，若连续出现3个同类品牌或者不连续出现5个同类品牌，将其剔除


针对大量数据（10W条）的计算，采用如下优化手段
1. 类名精简，字段压缩
   * 数据通过 RPC 调用获取，要想尽办法，减少传输的数据大小
   * 比如对类名精简，对字段名称压缩，传统开发中，对字段命令尽可能做到“见名知意”，此处采用简单的 `a`、`b`、`c` 进行命名
2. 多线程并行流计算
   * 多线程并行计算，采用并行流（`parallelStream`）进行计算，`parallelStream` 是使用线程池 `ForkJoin` 来调度的，其思想大体同 MapReduce。
   * 并行流计算中，比如针对 10W 条数据，起 10 个线程，每个线程计算和排序 1W 条数据。
   * 最后再进行汇总，采用类似归并排序的思想，可以将时间复杂度做到 `O(NlogN)`


### 动态SQL

动态 SQL 方案中，在 CMS 端配置筛选规则，然后进行规则解析，动态拼接成 SQL 查询语句。



