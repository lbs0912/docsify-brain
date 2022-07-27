
# NoSQL-05-ES翻页优化和性能优化


[TOC]

## 更新
* 2020/08/08，撰写


## 参考资料
* [Elasticsearch深度分页解决方案 | CSDN](https://blog.csdn.net/weixin_36380516/article/details/120858001)
* [ES查询性能调优实践 - 亿级数据查询毫秒级返回](https://cloud.tencent.com/developer/article/1427848)





## 前言


在 Elasticsearch 使用的基础上，探讨「ES翻页优化」和「ES性能优化」。


## ES翻页


ES 翻页，有下面几种方案
1. `from` + `size` 翻页
2. `scroll` 翻页
3. `scroll scan` 翻页
4. `search after` 翻页






### from + size 翻页


```s
POST /my_index/my_type/_search
{
    "query": { "match_all": {}},
    "from": 100,
    "size":  10
}
```



使用 `from` + `size` 可进行翻页
* `from` 参数定义了需要跳过的 `hits` 数，默认 0
* `size` 参数定义了需要返回的 `hits` 数目的最大值


> ES 默认的单页查询最大限制（`max_result_window`）为10000。


该方案在翻页数目较多（即 `from` 较大）或者 `size` 特别大的情况，会出深翻页问题（`deep pagination`)。



该方案的优点
1. 实现较为简单
2. 可以指定任意合理的页码，实现跳页查询


该方案的缺点
1. 深翻页时，耗时较长




### `scroll` 翻页

* ref 1-[利用Scan和Scroll处理大结果集](https://www.bookstack.cn/read/Spring-Data-Elasticsearch/5-5.3-5.3.2.md)



`scroll` 翻页方案，主要用于「一次性查询大量的数据（甚至是全部数据）」，适合「非实时处理大量数据」的场景，该方案并不适合用来做「实时数据查询」。
1. 第一次查询时，会生成一个 `scrollId`，并将所有符合搜索条件的搜索结果缓存起来。注意，这里只是缓存的 `doc_id`，并不是真的缓存了所有的文档数据，取数据是在 `fetch` 阶段完成的。
2. 后续查询时，需要携带上一次查询返回的 `scrollId`。




`from` + `size` 翻页方案中，我们可以指定任意合理的页码，实现跳页查询；但在 `scroll` 方案中，无法实现跳页面查询，因为该方案中除了第一次查询，其余的查询都需要上一次查询返回的 `scrollId`。





该方案的优点
1. 性能较好，适合一次性查询大量的数据


该方案的缺点
1. 使用了 `scrollId`，会占用大量的资源（特别是排序的请求）
2. 生成的 `scrollId` 是基于历史数据的快照，若此时数据发生了变化，则不会反映在快照上，所以不适合用作「实时数据查询」



参照 [ES分页 | 腾讯云](https://cloud.tencent.com/developer/article/1676915)，对 srcoll 翻页做如下说明。

如下一个第 2 次请求，会携带一个 `scroll_id` 参数，和一个 `scroll` 参数，该参数表示 `scroll_id` 的一个有效时间。

```s
POST /_search/scroll
{
   "scroll" : "1m",
   "scroll_id" : "DXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAA5AWNGpKbFNMZnVS=="
}
```

scroll 参数相当于告诉了 ES 我们的 `search context` 要保持多久，后面每个 scroll 请求都会设置一个新的过期时间，以确保我们可以一直进行下一页操作。

我们继续讨论一个问题，scroll 这种方式为什么会比较高效?

ES 的检索分为查询（query）和获取（fetch）两个阶段，query 阶段比较高效，只是查询满足条件的文档 id 汇总起来。fetch 阶段则基于每个分片的结果在 coordinating 节点上进行全局排序，然后最终计算出结果。

scroll 查询的时候，在 query 阶段把符合条件的文档 id 保存在前面提到的 search context 里。后面每次 scroll 分批取回只是根据 scroll_id 定位到游标的位置，然后抓取 size 大小的结果集即可。



### `scroll scan` 翻页

`scroll scan` 方式在单纯 `scroll` 方式的基础上，进一步提升了性能，适合「非实时处理大量数据」的场景。

**单纯的使用 `scroll` 方式查询，可支持排序。若使用 `scroll` + `scan` 的方式，则不支持排序。** 


### `search after` 翻页


`Search after` 是 ES 5 引入的一种分页查询机制，其原理和 `scroll` 类似。
* 请求时，会返回一个包含 `sort` 排序值的数组
* 在下一次请求时，可以将包含 `sort` 排序值的数组用于请求入参，以便抓取下一页的数据


该方案的优点
1. 不需要维护 `scrollId`，不需要维护快照，因此可以避免消耗大量的资源




该方案的缺点
1. 至少需要指定一个唯一的不重复字段来排序
2. 不适用于大幅度跳页查询，或者全量导出




### 翻页方案对比


| 翻页方式	| 性能 |  优点	 | 缺点	   | 场景  |
|---------|-------|---------|--------|---------|
| `from` + `size` |	低	| 灵活性好，实现简单 | 深度分页问题	| 数据量比较小，能容忍深度分页问题 |
| `scroll` | 中 | 解决了深度分页问题	| 需要维护一个 `scrollId`（快照版本），无法反应数据的实时性；可排序，但无法跳页查询 | 查询海量数据 |
| `scroll scan` | 中 | 基于 `scroll` 方案，进一步提升了海量数据查询的性能	| 无法排序，其余缺点同 `scroll` | 查询海量数据 |
| `search after` | 高	| 性能最好，不存在深度分页问题，能够反映数据的实时变更 | 实现复杂，需要有一个全局唯一的字段。连续分页的实现会比较复杂，因为每一次查询都需要上次查询的结果 | 不适用于大幅度跳页查询，适用于海量数据的分页 | 





对上述几种翻页方案，查询不同数目的数据，耗时数据如下表。


| ES 翻页方式  | 1-10 | 49000-49010 | 99000-99010 |
|-------------|------|-------------|-------------|
| from + size | 8ms  |   30ms      |    117ms    |
| scroll      | 7ms  |   66ms      |    36ms     |
| search_after| 5ms  |   8ms       |    7ms      |






## ES中from...size...的实现过程
@todo 此处章节后续整理

* [ES 深分页问题解决方案 | 掘金](https://juejin.cn/post/7010660177791680520)

1. Client 发送一次搜索请求，node1 接收到请求，然后，`node1` 创建一个大小为 `from + size` 的优先级队列用来存结果，我们管 `node1` 叫 `coordinating node`；
2. coordinating node 将请求广播到涉及到的 `shards`，每个 `shard` 在内部执行搜索请求，然后，将结果存到内部的大小同样为 `from + size` 的优先级队列里，可以把优先级队列理解为一个包含 `top N` 结果的列表；
3. 每个 shard 把暂存在自身优先级队列里的数据返回给 coordinating node，coordinating node 拿到各个 shards 返回的结果后对结果进行一次合并，产生一个全局的优先级队列，存到自身的优先级队列里；
4. 在上面的例子中，coordinating node 拿到 `(from + size) * nodeNum` 条数据，然后合并并排序后选择前面的 `from + size` 条数据存到优先级队列，以便 `fetch` 阶段使用。

举个具体的例子，集群中有 10 个分片（shard），查询参数为 `form 200 size 100`，则会从每个分片取出 (200+100) = 300 条数据，共 10 个节点，则一共会取出 `300*10 = 3K` 条数据，然后再对 3K 条数据中排序，取出第 201~300 条数据。 

## 性能优化

* ref 1-[ES查询性能调优实践，亿级数据查询毫秒级返回](https://cloud.tencent.com/developer/article/1427848)
* ref 2-[超详细的Elasticsearch高性能优化实践](https://developer.51cto.com/article/596694.html)


对 ES 查询性能进行优化，有如下思路
1. 拆分索引
   * 尽量缩小搜索的数据集范围
   * 可按照数据源拆分，或按时间拆分
2. 字段拉平，减少嵌套层级
   * 比如若在 `extra_info` 字段中又嵌套了几个搜索字段，在性能优化时，可考虑将这几个搜索字段和 `extra_info` 字段拉平，减少嵌套层级
3. 减少模糊匹配
4. 使用过滤器上下文（`filter`）代替查询上下文（`query`）
   * `filter` 查询子句的性能优于 `query` 查询子句
   * `filter` 查询子句不需要计算相关性的分值，并且查询结果可以缓存
   * `query` 查询子句需要计算相关性的分值
5. 减少不必要的查询字段
   * 一个 ES 查询包括两个阶段，`query` 和 `fetch`。若查询字段较多，`fetch` 阶段会耗时很大 
6. **尽可能使用 `filesystem cache`**
7. 使用日期字段搜索范围
8. 减少 Refresh 的次数
9. 加大 Flush 设置
10. 减少副本的数量

下面进行必要的补充说明。



### 设计阶段调优
1. **根据业务增量需求，采取基于日期模板创建索引，通过 roll over API 滚动索引，如基于「模板 + 时间 + rollover api」 滚动创建索引；**
2. 使用别名进行索引管理；
3. 每天凌晨定时对索引做 `force_merge` 操作，以释放空间；
4. **采取冷热分离机制，热数据（如最近2天的数据）存储到 SSD，提高检索效率；冷数据定期进行 shrink 操作，以缩减存储；**
5. 仅针对需要分词的字段，合理的设置分词器；
6. Mapping 阶段充分结合各个字段的属性，是否需要检索、是否需要存储等；

### 写入调优
1. 写入前副本数设置为 0；
2. **写入前关闭 `refresh_interval` 设置为 -1，禁用刷新机制；**
3. 写入过程中：采取 bulk 批量写入；
4. 写入后恢复副本数和刷新间隔；
5. 尽量使用自动生成的 id；


### 查询
1. 禁用 wildcard；
2. 禁用批量 terms（成百上千的场景）
3. **充分利用倒排索引机制，能 keyword 类型尽量 keyword；** 
4. **数据量大时候，可以先基于时间敲定索引再检索；**
5. 设置合理的路由机制；


### filesystem cache
* ES 会将磁盘中的数据自动缓存到 `filesystem cache`，在内存中查找，提升了速度
* 若 `filesystem cache` 无法容纳索引数据文件，则会基于磁盘查找，此时查询速度会明显变慢
* 若数量两过大，基于「ES 查询的的 query 和 fetch 两个阶段」，可使用 ES + HBase 架构，保证 ES 的数据量小于 `filesystem cache`，保证查询速度



### 使用日期字段搜索范围

原先 ES 的日期 `date_created` 字段是用字符串存储。

```json
"date_created":{
   "type":"text",
   "fields":{
      "keyword":{
         "type":"keyword",
         "ignore_above":256
      }
   }
}
```


但对字符串的字段类型，进行 `range` 过滤并不高效。

字符串范围适用于一个基数较小的字段，一个唯一短语个数较少的字段。你的唯一短语数越多，搜索就越慢。

数字和日期字段的索引方式，让它们在计算范围时十分高效。但对于字符串来说却不是这样。为了在字符串上执行范围操作，Elasticsearch 会在这个范围内的每个短语执行 `term` 操作。这比日期或数字的范围操作慢得多。

优化后，`date_created` 字段改成日期类型。


```json
"date_created":{
   "type":"date",
   "format":"yyyy-MM-dd HHLmm:ss,SSS"
}
```

### 过滤器上下文（`filter`）代替查询上下文（`query`）

ES 中提供了「查询上下文（`query`）」和「过滤器上下文（`filter`）」

1. 查询上下文（`query`）
   * `query` 查询子句用于回答「这个文档与此子句相匹配的程度」，ES 会计算相关度并维护一个 `_score` 分值，分值越高就代表越相关越匹配
2. 过滤器上下文（`filter`）
   * `filter` 查询子句用于回答「这个文档是否匹配这个子句」，ES 只需要回答 “是” 或 “否”，不需要为过滤器子句计算相关性分数
   * `filter` 查询的结果可以缓存

**可以看到，`filter` 查询子句不需要计算相关性的分值，并且查询结果可以缓存。所以，在满足业务需求的前提下，尽可能地使用 `filter` 查询子句代替 `query` 查询子句。**


> ES 中 Mapping 有 `norms` 属性值可以设置，表示字段是否支持算分。
> * 如果字段只用来过滤和聚合分析，而不需要被搜索（计算算分），那么可以设置为 false，可节省空间。
> * 默认值为 true。

### 查询的两个阶段：query和fetch


在 ES 中，搜索一般包括两个阶段，`query` 和 `fetch` 阶段
1. `query` 阶段
   * 根据查询条件，确定要取哪些文档（`doc`），筛选出文档 ID（`doc_id`）
2. `fetch` 阶段
   * 根据 `query` 阶段返回的文档 ID（`doc_id`），取出具体的文档（`doc`）


在一次业务场景中，从 1000W 的底池数据中查询出 10W 结果，当查询较多字段信息（返回 20 个字段），耗时约 8s，其中 `query` 阶段耗时约 500ms；当减少查询字段（返回 5 个字段），耗时约 2s，其中 `query` 阶段耗时约 480ms。从中可以得出如下结论 
1. **一次 ES 查询中，若查询字段和信息较多，`fetch` 阶段的耗时，远大于 `query` 阶段的耗时。**
2. **一次 ES 查询中，若查询字段和信息较多，通过减少不必要的查询字段，可以显著缩短查询耗时。**

> 对该业务场景的性能测试数据和技术优化方案，见 [千万级数据查询中CK、ES、RediSearch方案的优化](https://juejin.cn/post/7104090532015505416)

### 减少 Refresh 的次数

Lucene 在新增数据时，采用了延迟写入的策略，默认情况下索引的 `refresh_interval` 为 1 秒。

Lucene 将待写入的数据先写到内存中，超过 1 秒（默认）时就会触发一次 Refresh，然后 Refresh 会把内存中的的数据刷新到操作系统的文件缓存系统中。

如果我们对搜索的实效性要求不高，可以将 Refresh 周期延长，例如 30 秒。

这样还可以有效地减少段刷新次数，但这同时意味着需要消耗更多的 Heap 内存。

```s
index.refresh_interval:30s 
```


### 加大 Flush 设置

Flush 的主要目的是把文件缓存系统中的段持久化到硬盘，当 Translog 的数据量达到 512MB 或者 30 分钟时，会触发一次 Flush。


`index.translog.flush_threshold_size` 参数的默认值是 512MB，我们可以进行修改。


增加参数值意味着文件缓存系统中可能需要存储更多的数据，所以我们需要为操作系统的文件缓存系统留下足够的空间。


### 批量提交

对于大量的写操作，ES 提供了 refresh 操作和 flush 操作。可以进行批量提交，每一次提交都是一次网络开销。网络永久是优化需要考虑的要点。


### 优化磁盘

索引文件需要落地硬盘，段的思想又带来了更多的小文件，磁盘 IO 是 ES 的性能瓶颈。一个固态硬盘比普通硬盘好太多。

### 减少副本的数量

ES 为了保证集群的可用性，提供了 Replicas（副本）支持，然而每个副本也会执行分析、索引及可能的合并过程，所以 Replicas 的数量会严重影响写索引的效率。

当写索引时，需要把写入的数据都同步到副本节点，副本节点越多，写索引的效率就越慢。

如果我们需要大批量进行写入操作，可以先禁止 Replica 复制，设置 `index.number_of_replicas: 0`，关闭副本。在写入完成后，Replica 修改回正常的状态。




## MySQL深翻页方案
* ref 1-[MySQL 千万数据量深分页优化 | Segmentfault](https://segmentfault.com/a/1190000038704015)
* ref 2-[聊聊如何解决MySQL深分页问题](https://mp.weixin.qq.com/s?__biz=Mzg3NzU5NTIwNg==&mid=2247495139&idx=1&sn=9dd98a8e09af48440cc5f01d3aafd87e&chksm=cf2232caf855bbdc4ea538550ecde6c575c91a1d1b1c42f3bc6091c715dde1a4a5e90d3f7ce2&token=1913427154&lang=zh_CN#rd)



关于 MySQL 深分页优化，常见的大概有以下 3 种策略
1. 子查询优化
2. 延迟关联
3. 书签记录

上面 3 种 方案的核心思想都是让 MySQL 尽可能扫描更少的页面，减少不必要的回表。


还有一种解决思路，就是使用 ES 实现，因为 MySQL 并不太适合处理这种深翻页的场景。



### 1. 子查询优化


此处以 查询 300W 行数据后的第 1 条记录为例进行说明。

```sql
SELECT * 
FROM MCS_PROD
WHERE UPDT_TIME >= '1970-01-01 00:00:00.0' 
ORDER BY UPDT_TIME 
LIMIT 3000000, 1
```

如上查询语句所示，按照更新时间 `UPDT_TIME` 排序，筛选出更新时间大于 `'1970-01-01 00:00:00.0'` 的，偏移 300W 条的，下一条数据。



对于上述深翻页查询，可以使用子查询进行优化，如下所示。



```sql
SELECT * 
FROM MCS_PROD
WHERE MCS_PROD_ID >= 
   (SELECT m1.MCS_PROD_ID 
      FROM MCS_PROD m1 
      WHERE m1.UPDT_TIME >= '1970-01-01 00:00:00.0' 
      ORDER BY m1.UPDT_TIME 
      LIMIT 3000000, 1
   ) 
LIMIT 1;
```

在子查询中，先查询出偏移 300W 条后的下一条记录的 `MCS_PROD_ID`（主键）值，
然后再根据子查询返回的值进行查询。


### 2. 延迟关联


```sql
SELECT *
FROM MCS_PROD INNER JOIN 
   (SELECT m1.MCS_PROD_ID 
      FROM MCS_PROD m1 
      WHERE m1.UPDT_TIME >= '1970-01-01 00:00:00.0' 
      ORDER BY m1.UPDT_TIME 
      LIMIT 3000000, 1
   ) AS  MCS_PROD2 
USING(MCS_PROD_ID);
```

延迟关联的思想大体同子查询优化，只不过在 SQL 语法层面使用了 `join`。



### 3. 书签记录

关于 LIMIT 深分页问题，核心在于 OFFSET 值，它会 导致 MySQL 扫描大量不需要的记录行然后抛弃掉。

我们可以先使用「书签」记录获取上次取数据的位置，下次就可以直接从该位置开始扫描，这样可以避免使用 OFFEST。



## CK深翻页方案

CK 采用类 SQL 语法，其优化思路同 MySQL 的优化。


## FAQ


### 有没有既可以深翻页又可以跳页的方式

目前，ES 并没有提供既可以深翻页，又可以跳页的实现方式。（Scroll 和 Search After 均不支持跳页）


这其实一个取舍问题，鱼和熊掌不可兼得，无法既做到海量数据的高效查询，又支持跳转到指定的页数。


如果一定要做的话，可以先试用 Scroll 或 Search After 方案查询出命中的数据，然后将其放入到 Redis 中，在内存中完成跳转指定的页数。

