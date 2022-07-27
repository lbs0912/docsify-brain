# NoSQL-02-ES



[TOC]



## 更新
* 2022/05/22，撰写




## 参考资料
* [Getting Started with ES | Elasticsearch Cookbook](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html)
* [ElasticSearch 中必须掌握的七个概念](https://mp.weixin.qq.com/s/auyiJgXjphWp_CurTM6jBg)
* [全文搜索引擎 Elasticsearch 入门教程 | 阮一峰](https://www.ruanyifeng.com/blog/2017/08/elasticsearch.html)
* [ElasticSearch深度分页解决方案 | CSDN](https://blog.csdn.net/weixin_36380516/article/details/120858001)





## 前言

开源的 [Elasticsearch](https://www.elastic.co/cn/) 是目前全文搜索引擎的首选，可以快速地储存、搜索和分析海量数据。

Elastic 底层是开源库 [Lucene](https://lucene.apache.org/)，`Elastic` 是 `Lucene` 的封装，对外提供了 `RESTful Web` 接口，开箱即用。





## ES 高频面试

### ES 索引数据多了怎么办，如何调优、部署


索引数据的规划，应在前期做好规划，正所谓 “设计先行，编码在后”，这样才能有效的避免突如其来的数据激增，导致集群处理能力不足引发的线上客户检索或者其他业务受到影响。

那么如何调优化呢？

#### 1. 动态索引层面

**基于「模板 + 时间 + rollover api」滚动创建索引。**


**比如定义 blog 索引的模板格式为 `blog_index_时间戳` 的形式，每天递增数据。这样做的好处是不至于数据量激增导致单个索引数据量非常大，一旦单个索引很大，存储等各种风险也随之而来，所以要提前考虑和及早避免。**

#### 2. 存储层面

冷热数据分离存储，热数据（比如最近 3 天或者一周的数据），其余为冷数据。
对于冷数据不会再写入新数据，可以考虑定期 `force_merge` 加 `shrink` 压缩操作，节省存储空间和检索效率。


#### 3. 部署层面

一旦之前没有规划，这里就属于应急策略。

结合 ES 自身的支持动态扩展的特点，动态新增机器的方式可以缓解集群压力，注意，如果之前主节点等规划合理，不需要重启集群也能完成动态新增的。




### 你们公司ES的集群架构，索引数据大小和分片大小

ES 集群架构 13 个节点，索引根据通道不同共 20+ 索引，根据日期，每日递增 20+，索引：10 分片，每日递增 1 亿+ 数据，每个通道每天索引大小控制：150GB 之内。




## 安装和配置


* [Install ES on MacOS with Homebrew](https://www.elastic.co/guide/en/elasticsearch/reference/7.6/brew.html)


使用 Homebrew 安装 Elasticsearch。
  
```s
brew tap elastic/tap

brew install elastic/tap/elasticsearch-full
```



* Elastic 默认一次返回 10 条结果，可以通过 `size` 字段改变这个设置。还可以通过 `from` 字段指定位移。

```s
$ curl -H "Content-Type: application/json" 'localhost:9200/accounts/person/_search'  -d '

{
  "query" : { "match" : { "desc" : "管理" }},
  "size": 20   //定义size
  “from": 1,   // 从位置1开始（默认是从位置0开始）
}'
```


* ES 默认的单页查询最大限制（`max_result_window`）为 10000。

## 基本概念

* ref 1-[ElasticSearch 中必须掌握的七个概念](https://mp.weixin.qq.com/s/auyiJgXjphWp_CurTM6jBg)


**ES中概念和关系型数据库的概念类比关系如下表所示。**



| Relational Database | Elasticsearch |
|--------------------|----------------|
| Database  | Index（索引） | 
| Table     | Type（类型） | 
| Row       | Document（文档） | 
| Column    |  Field（字段） | 
| Scheme    | Mapping（映射） | 
| Index     | Everything is indexed | 
| SQL       |  Query DSL  | 
| SELECT * FROM ... | GET `http://...`  | 
| UPDATE table_name SET ... | PUT `http://...`  | 



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/es-index-document-1.png)



* 每个 `index`（索引）由一个或者多个 `shard`（分片）组成，分布在不同的 `node`（节点）。`document`（文档）由 `field`（字段）组成，存储在这些 `shard`（分片）中。

### Node 与 Cluster

Elastic 本质上是一个分布式数据库，允许多台服务器协同工作，每台服务器可以运行多个 Elastic 实例。

单个 Elastic 实例称为一个节点（`node`）。一组节点构成一个集群（`cluster`）。

### Index

Elastic 会索引所有字段，经过处理后写入一个反向索引（`Inverted Index`）。查找数据的时候，直接查找该索引。

所以，**Elastic 数据管理的顶层单位就叫做 `Index`（索引）。它是单个数据库的同义词。每个 `Index` （即数据库）的名字必须是小写。**


下面的命令可以查看当前节点的所有 Index。

```s
$ curl -X GET 'http://localhost:9200/_cat/indices?v'
```

### Document

`Index` 里面单条的记录称为 `Document`（文档）。许多条 `Document` 构成了一个 `Index`。

`Document` 使用 JSON 格式表示，下面是一个例子。

```json
{
  "user": "张三",
  "title": "工程师",
  "desc": "数据库管理"
}
```

同一个 `Index` 里面的 `Document`，不要求有相同的结构（`scheme`），但是最好保持相同，这样有利于提高搜索效率。


### Type


可以对 `Document` 进行分组，分成不同的 `Type`。


举个例子，创建一个 `weather` 的 索引（`Index`）用于记录天气信息。对存储的信息，可以按城市分组（北京和上海），也可以按气候分组（晴天和雨天），这种分组就叫做 `Type`，**它是虚拟的逻辑分组，用来过滤 `Document`**。


需要注意的是
* ES 中一个 `index` 下最好只创建一个 `type`，不要创建多个 `type`。Elastic 6.x 版只允许每个 `Index` 包含一个 `Type`，7.x 版将会彻底移除 `Type`。
* 不同的 `Type` 应该有相似的结构（`schema`）。举例来说，`id` 字段不能在这个组是字符串，在另一个组是数值。
* 性质完全不同的数据（比如 `products` 和 `logs`）应该存成两个 `Index`，而不是一个 `Index` 里面的两个 `Type`（虽然可以做到）。

### Mapping（映射）
* ref 1-[ElasticSearch 中的 Mapping](https://www.cnblogs.com/codeshell/p/14445420.html)



字段的 `mapping` 可以设置很多参数，详情见上述参考链接 *ref-1*。此处仅记录一些常用的参数。
1. `analyzer`
   * 指定分词器，只有 text 类型的数据支持。
2. `enabled`
   * 如果设置成 false，表示数据仅做存储，不支持搜索和聚合分析（数据保存在 `_source` 中）。
   * 默认值为 true。
3. `index`：字段是否建立倒排索引。
   * 如果设置成 false，表示不建立倒排索引（节省空间），同时数据也无法被搜索，但依然支持聚合分析，数据也会出现在 `_source` 中。
   * 默认值为 true。
4. `norms`：字段是否支持算分。
   * 如果字段只用来过滤和聚合分析，而不需要被搜索（计算算分），那么可以设置为 false，可节省空间。
   * 默认值为 true。
5. `doc_values`
   * 如果确定不需要对字段进行排序或聚合，也不需要从脚本访问字段值，则可以将其设置为 false，以节省磁盘空间。
   * 默认值为 true。
6. `fielddata`
   * 如果要对 text 类型的数据进行排序和聚合分析，则将其设置为 true。
   * 默认为 false。
7. `dynamic`
   * 控制 mapping 的自动更新。
   * 取值有 true，false，strict。


## ES的元字段
* ref 1-[ES的元字段 | CSDN](https://blog.csdn.net/zhoushimiao1990/article/details/105967651)


ES 文档字段分为两类
1. 元字段（Meta-field）：不需要用户定义，在任一文档中都存在，如 `_id`、`_index`、`_type` 等。
2. 业务字段：用户自定义的字段，也就是我们添加数据时，JSON 串中的 key。



元字段（Meta-field）在名称上有一个显著的特征，就是以下划线 `"_"` 开头，有些字段只是为了存储，它们会出现在文档检索的结果中，却不能通过这个字段本身做检索，如 `_source`；有些字段则只是为了索引，它会创建出一个索引，用户可以在这个索引上检索文档，但这个字段却不会出现在最终的检索结果中，如 `_all` 字段。 且不是所有的字段都是默认开启的，有些元字段需要在索引中配置开启才可使用。

| 序号	| 名称	| 是否索引  | 是否存储	|  说明	 | 大类  | 
|-------|------|---------|---------|--------|-------|
| 1 | `_id`	| 是 | 	是 | 	文档ID，在映射类型内唯一 | 标识 |
| 2	| `_index` | 否 | 否	| 文档所属索引 |  标识 |
| 3	| `_type`	| 是	| 否	| 文档所属映射类型 | 标识 |
| 4	| `_uid`	| \ |	\	| 在索引内唯一，由映射类型和 ID 共同组成，格式为 `{type}#{id}`，在 6.0 版本已废除 |  标识 | 
| 5	| `_source`	| 否	| 是	| 原始 JSON 文档	| 源文档 |
| 6	| `_size`	| 是	| 是	| `_source` 的字节数，需要安装 `mapper-size` 插件	索引 |  索引 | 
| 7	| `_all` |是|否|所有字段一起创建索引，6.0 版本废止 |索引| 
| 8	| `_field_names`	| 是	| 否	| 为文档非空字段名创建索引 | 索引 |
| 9	| `_ignored`	| 是	| 是	| 为忽略字段创建索引 | 索引 |
| 10 | 	`_routing`	| \ |	\	| 文档到具体分片的路由	| 其他 | 
| 11	| `_meta` |	\ | \ |	应用相关元信息 | 其他 |


## ES的数据类型
* ref 1-[ES 的数据类型](https://www.cnblogs.com/shoufeng/p/10692113.html)


ES 的数据类型包括
1. 字符串类型
   * string（不再支持）
   * text
   * keyword
2. 整数类型
   * long
   * integer
   * short
   * byte
3. 浮点数类型
   * double
   * float
   * half_float
   * scaled_float
4. 逻辑类型 - boolean
5. 日期类型 - date
6. 二进制类型 - binary 
7. 范围类型 - range
   * integer_range
   * long_range
   * float_range
   * double_range
   * date_range
   * ip_range
8. 复合类型
   * 数组类型 array 
   * 对象类型 object ：JSON 格式对象数据
   * 嵌套类型 nested 
   * 地理类型 地理坐标类型 geo_point 
   * 地理地图 geo_shape 
   * 特殊类型 IP类型 ip 
   * 范围类型 completion 
   * 令牌计数类型 token_count 
   * 附件类型 attachment 
   * 抽取类型 percolator 


### 字符串类型 

> string（不再支持）

`"index": "not_analyzed"` 表示对该字符串不进行分词。


```json
PUT website
{
    "mappings": {
        "blog": {
            "properties": {
                "title": {"type": "string"}, 	// 全文本
                "tags": {"type": "string", "index": "not_analyzed"}	// 关键字, 不分词
            }
        }
    }
}
```

从 ES 5.x 开始不再支持 string，由 text 和 keyword 类型替代。



> text 和 keyword

从 ES 5.x 开始不再支持 string，由 text 和 keyword 类型替代。
1. 当一个字段是要被全文搜索的，设置 text 类型，字段内容会被分析，会被分词，会被全文检索，text 类型的字段不用于排序，很少用于聚合。
2. keyword 类型的字段只能通过精确值搜索到，如果字段需要进行过滤、排序、聚合，设置 keyword 类型。
  


> `"index": "true|false"`

`"index": "true|false"` 表示是否给字段建立倒排索引
1. 如果设置 false，表示不建立倒排索引（节省空间），同时数据也无法被搜索，但依然支持聚合分析，数据也会出现在 `_source` 中。
2. text 的内容默认会被分词，可以设置是否需存储：`"index": "true|false"`
3. keyword 的内容默认不会被分词，可以设置是否需要存储：`"index": "true|false"`。



### 整数和浮点数


1. 整数类型
   * long
   * integer
   * short
   * byte
2. 浮点数类型
   * double
   * float
   * half_float
   * scaled_float

|     类型    |            说明          |
|------------|--------------------------| 
| byte	|  有符号的 8 位整数，范围 [-128 ~ 127] | 
| short	| 有符号的 16 位整数，范围 [-32768 ~ 32767] | 
| integer	| 有符号的 32 位整数，范围 [−2^31 ~ 2^31-1] | 
| long	| 有符号的 64 位整数，范围 [−2^63 ~ 2^63-1] | 
| float	| 32 位单精度浮点数 | 
| double	| 64 位双精度浮点数 | 
| half_float	| 16 位半精度 IEEE 754 浮点类型 | 
| scaled_float	| 缩放类型的的浮点数，比如 price 字段只需精确到分， 57.34 缩放因子为 100, 存储结果为 5734 | 


在使用数字类型时，需要注意
1. **尽可能选择范围小的数据类型，字段的长度越短，索引和搜索的效率越高**
2. 优先考虑使用带缩放因子的浮点类型


### 日期类型-date

JSON 没有日期数据类型，所以在 ES 中，日期可以是
1. 包含格式化日期的字符串, `"2018-10-01"` 或 `"2018/10/01 12:10:30"`
2. 代表时间毫秒数的长整型数字
3. 代表时间秒数的整数
  
如果时区未指定，日期将被转换为 UTC 格式，但存储的却是长整型的毫秒值。

可以自定义日期格式，若未指定，则使用默认格式。

```
strict_date_optional_time||epoch_millis
```

## 分词器

* ref 1-[ElasticSearch中文分词 | 简书](https://www.jianshu.com/p/bb89ad7a7f7d)
* ref 2-[IK在线分词器](https://www.sojson.com/analyzer)



当一个文档被存储时，ES 会使用分词器从文档中提取出若干词元（`token`）来支持索引的存储和搜索。ES 内置了很多分词器，但内置的分词器对中文的处理不好。下面通过例子来看内置分词器的处理。在 Web 客户端发起如下的一个 REST 请求，对英文语句进行分词。


```s
curl -H "Content-Type: application/json" -PUT 'localhost:9200/_analyze' -d '
{  
    "text": "hello world"  
}' | json

# |json 表示对返回结果进行json化展示
# 使用默认的内置分词器  "analyzer": "standard"
```

返回结果如下。

```s
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   213  100   179  100    34  44750   8500 --:--:-- --:--:-- --:--:-- 53250
{
  "tokens": [
    {
      "token": "hello",
      "start_offset": 0,
      "end_offset": 5,
      "type": "<ALPHANUM>",
      "position": 0
    },
    {
      "token": "world",
      "start_offset": 6,
      "end_offset": 11,
      "type": "<ALPHANUM>",
      "position": 1
    }
  ]
}
```

上面结果显示 `"hello world"` 语句被分为两个单词。因为英文天生以空格分隔，自然就以空格来分词，这没有任何问题。

下面我们看一个中文的语句例子，请求 `REST` 如下。

```s
curl -H "Content-Type: application/json" -PUT 'localhost:9200/_analyze' -d '
{  
    "text": "我爱编程"  
}' | json
```

操作成功后，响应的内容如下。

```s
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   383  100   348  100    35  69600   7000 --:--:-- --:--:-- --:--:-- 76600
{
  "tokens": [
    {
      "token": "我",
      "start_offset": 0,
      "end_offset": 1,
      "type": "<IDEOGRAPHIC>",
      "position": 0
    },
    {
      "token": "爱",
      "start_offset": 1,
      "end_offset": 2,
      "type": "<IDEOGRAPHIC>",
      "position": 1
    },
    {
      "token": "编",
      "start_offset": 2,
      "end_offset": 3,
      "type": "<IDEOGRAPHIC>",
      "position": 2
    },
    {
      "token": "程",
      "start_offset": 3,
      "end_offset": 4,
      "type": "<IDEOGRAPHIC>",
      "position": 3
    }
  ]
}
```

从结果可以看出，这种分词把每个汉字都独立分开来了，这对中文分词就没有意义了，所以 ES 默认的分词器（`"analyzer": "standard"`）对中文处理是有问题的。


好在有很多不错的第三方的中文分词器，可以很好地和 ES 结合起来使用。当我们换一个分词器处理分词时，只需将 `"analyzer"` 字段设置相应的分词器名称即可。对于第三方的中文分词器，比较常用的是中科院 `ICTCLAS` 的 `smartcn` 和 `IKAnanlyzer` 分词器。





## Java High Level REST Client

* ref 1-[Java Elasticsearch 教程](https://www.tizi365.com/archives/874.html)



> Elasticsearch 有两种连接方式，`transport` 和 `rest`。
> 1. `transport` 通过 TCP 方式访问 ES，目前仅 Java 支持
> 2. `rest` 方式通过 HTTP API 访问 ES，没有语言限制
> 
> ES 官方建议使用 `rest` 方式, `transport` 方式将在 8.x 版本中废弃。

`Java High Level REST Client` 提供了相关 API，可在 Java 中使用 ES。

* Maven 配置

```xml
<dependency>
    <groupId>org.elasticsearch.client</groupId>
    <artifactId>elasticsearch-rest-high-level-client</artifactId>
    <version>7.8.1</version>
</dependency>
```


* 创建 `RestHighLevelClient` 客户端

```java
RestHighLevelClient client = new RestHighLevelClient(
        RestClient.builder(
                new HttpHost("localhost", 9200, "http"),
                new HttpHost("localhost", 9201, "http")));
```


* Java ES 查询
  1. 创建 `RestHighLevelClient`，即 Java ES Client 对象
  2. 创建 `SearchRequest` 对象，负责设置搜索参数
     * 创建 `SearchRequest` 对象
     * 通过 `SearchSourceBuilder` 设置搜索参数
     * 将 `SearchSourceBuilder` 绑定到 `SearchRequest` 对象
  3. 通过 `Client` 对象发送请求
  4. 处理搜索结果



## spring-boot-starter-data-elasticsearch
* ref 1-[《Spring Boot 2 实战》](https://cread.jd.com/read/startRead.action?bookId=30510020&readType=3)，第 10 章节
* ref 2-[Spring Boot 集成 ElasticSearch 7.x | 掘金](https://juejin.cn/post/6844904122034946055)


Spring Boot 提供了使用 ES 的 `spring-boot-starter-data-elasticsearch`（下文简称为 `starter`），Maven 依赖如下。

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-elasticsearch</artifactId>
</dependency>
```


* 该 `starter` 提供了像 JPA 一样操作的 `Elasticsearch Repository`。
* 该 `starter` 提供了 `Elasticsearch Template`，可进行查询之类的操作，也可以进行配置相关的操作，如创建和删除索引，设置 `Mapping` 等。




## 倒排索引

* [ElasticSearch索引机制 | CSDN](https://blog.csdn.net/Zong_0915/article/details/107289478)



先给出一个例子，对于下面的数据，传统的 MySQL 中会用一个自增 ID 作为主键，也就是主键索引。


```s
| ID |   Name   | Age  | Sex |
| 1  |   Kate   |  20  |  F  |
| 2  |   Tom    |  20  |  M  |
| 3  |   Bill   |  30  |  M  |
```


对上述数据，ES 建立的倒排索引如下。

* 对 Name

```s
|   Term   | Posting List |
|   Kate   |      1       |
|   Tom    |      2       |
|   Bill   |      3       | 
```


* 对 Age

```s
|   Term   | Posting List |
|   20     |      [1,2]   |
|   30     |      3       | 
```

* 对 Sex

```s
|   Term   | Posting List |
|   F      |       1      |
|   M      |      [2,3]   | 
```



ElasticSearch 采用的是 Lucene 的倒排索引技术，即以分词的形式，将文档分解成「**单词 + 频率 + 位置**」的形式。
* ES 为每一个字段都建立了一个倒排索引，而每个字段下的值叫做 `Term`。
* `Posting List`：一个 int 类型的数组，存储了所有符合某一个 Term 的文档的 id，也可以理解为位置集合。




### Term Dictionary和Term Index

基本上会有 3 种文件去存储某一条数据
1. Term Dictionary：词典文件，存储一些分词的前缀
2. frequencies： 词频文件，存储这个分词出现的频率
3. positions：位置文件，存储这个分词出现的位置



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/es-term-index-diction-position-1.png)


> **`Term Index`（内存中） -> `Term Dictionary` -> `Position List` -> `Target Data`**

ES 索引的优点
1. 写入磁盘的倒排索引是不变的。也因此，不需要添加锁。
2. 增强读性能。
3. 提升其他的缓存性能。新增的数据存储在 Segment，Segment 又存储在文件系统的缓存当中。


> Term Dictionary

ES 为了快速定位到某一个 Term，会将所有的 Term 进行一个排序，需要查询的时候，用「二分法」的方式去查找。形如字典里先查偏旁。

> Term Index

ES 采用与 B-Tree 一样的想法，用内存去查找 Term（快），而不是磁盘。Term Index 像一棵树，包含了 Term 所在的地址。

形象的说，查询从 Term Dictionary 中查找偏旁，查到对应的偏旁后，可以看到这个偏旁下，有哪些字，分别在哪一页，这就是 Term Index。

因此这里说明一个很重要的点，就是 Term Index 不是存储所有的 Term，而是存储一个 Term Dictionary 的一个映射关系。比如以字母 A 开头的存在哪些分词，在哪些位置，而 Index存储的就是这些位置。


### ES的索引压缩


ES 的索引是存储在内存当中的，也因此查询的速度非常的快，但是内存的大小是有限的，也因此 ES 会对它的索引进行压缩。

一般查询是从 Index 中查找到 Dictionary 中对应的 block，再去磁盘中去查找，而不是直接去磁盘当中去随机的查询，这样有个好处就是，减少磁盘的随机 IO 次数，增加效率。

言归正传，ES 采用 FST 的形式去把索引进行压缩的。

简而言之就是，FST 以字节的形式去存储所有的 Term Index，用字节存储的话，肯定是占用空间很小的。因此能够有效的缩减存储所需的空间。

另外 FST 还有另外一个作用：快速确定某一个 Term 是否存在系统当中。


## ES查询为什么这么快
* ref 1-[ES查询速度快的原因 | CSDN](https://blog.csdn.net/qq924862077/article/details/80382634)
* ref 2-[Elasticsearch查询速度为什么这么快 | 知乎](https://zhuanlan.zhihu.com/p/280676094)


1. `filesystem cache`
   * ES 会将磁盘中的数据自动缓存到 `filesystem cache`，在内存中查找，提升了速度
   * 若 `filesystem cache` 无法容纳索引数据文件，则会基于磁盘查找，此时查询速度会明显变慢
   * 若数量两过大，基于「ES 查询的的 query 和 fetch 两个阶段」，可使用 ES + HBase 架构，保证 ES 的数据量小于 `filesystem cache`，保证查询速度
2. 数据预热，将数据手动刷入 `filesystem cache`
3. 深翻页的优化选项
4. 倒排索引
   * ES 的索引并没有采用正排索引，而是倒排索引，更适合全文搜索
5. `Term Index`（内存中） -> `Term Dictionary` -> `Position List` -> `Target Data`
6. ES 的 refresh、flush、merge机制，保证了近实时搜索




| 比较项 |  MySQL  |     ES     |
|---------|---------|------------|
| 索引类型 | B+树 | 倒排索引 |
| 特性1 | 降低树的高度，少量的IO便能查询大量数据 | 将 Term Index 放入内存，减少IO次数，查询效率更高 |
| 特性2 | 适合存储结构化数据，支持 Join 查询 | 适合存储非结构化数据，适合全文检索 |
### ES为什么选择倒排索引而不选择B+树索引

* ref 1-[ES为什么选择倒排索引而不选择B+树索引 | 掘金](https://juejin.cn/post/7023194420463796238)


ES 主要用于全文索引，而 B+ 树并不适合处理全文索引的场景
1. 全文索引的文本字段通常会比较长，索引值本身会占用较大空间，从而会加大 B+ 树的深度，影响查询效率。
2. 全文索引往往需要全文搜索，不遵循最左匹配原则，使用 B+ 树可能导致索引失效。



## MySQL数据同步到ES
* ref 1-[MySQL与ES之间的数据一致性问题](https://www.silince.cn/2021/05/15/MySQL%E4%B8%8EES%E4%B9%8B%E9%97%B4%E7%9A%84%E6%95%B0%E6%8D%AE%E4%B8%80%E8%87%B4%E6%80%A7%E9%97%AE%E9%A2%98/)



将 MySQL 的数据同步到 ES，有以下几种实现思路
1. 监听 MySQL 的 binlog（类似 MySQL 主从同步的思想）。阿里开源的 `canal` 工具就是采用了这种方案。
2. 若 MySQL 发生了数据变更，使用 Kafka 或 MQ，通过发消息，通知 ES 数据更新
3. 使用 ES API，读取 MySQL 的数据并写入 ES


### cannal

阿里开源的 `canal` 可以把 MySQL 中的数据实时同步到 Elasticsearch 中，能很好地解决数据同步问题。

`canal` 主要用途是对 MySQL 数据库增量日志进行解析，提供增量数据的订阅和消费，简单说就是可以对 MySQL 的增量数据进行实时同步，支持同步到 MySQL、Elasticsearch、HBase 等数据存储中去。

`canal` 会模拟 MySQL 主库和从库的交互协议，从而伪装成 MySQL 的从库，然后向MySQL 主库发送 dump 协议，MySQL 主库收到 dump 请求会向 canal 推送 binlog，canal 通过解析 binlog 将数据同步到其他存储中去。




## refresh、flush、merge

* ref 1-[理解ES的 refresh、flush、merge | CSDN](https://blog.csdn.net/weixin_37692493/article/details/108182161)




![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/es-flush-merge-fsync-1.png)



### refresh

对于任何数据库的写入来讲，fsync 刷盘虽然保证的数据的安全。但是如果每次操作都必须 fsync 一次，那 fsync 操作将是一个巨大的操作代价。在衡量对数据安全与操作代价下，ES 引入了一个较轻量的操作 refresh 操作来避免频繁的 fsync 操作。


在 ES 中，当写入一个新文档时，首先被写入到内存缓存中，默认每 1 秒将 `in-memory index buffer` 中的文档生成一个新的段并清空原有 `in-memory index buffer`，新写入的段变为可读状态，但是还没有被完全提交。该新的段首先被写入文件系统缓存，保证段文件可以正常被正常打开和读取，后续再进行刷盘操作。由此可以看到，ES 并不是写入文档后马上就可以搜索到，而是一个近实时的搜索（默认 1s 后）。


如下图所示，文档被写入一个新的段后处于 `searchable` 状态，但是仍是未提交状态。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/es-flush-merge-fsync-2.png)


文档写入内存缓存区中，默认每 1s 生成一个新的段，这个写入并打开一个新段的轻量的过程叫做 `refresh`。

虽然 refresh 是一个较轻量的操作，但也是有一定的资源消耗的，必要时刻可以手动执行refresh api 保证文档可立即被读到。生产环境建议正确使用 refresh api，接受 ES 本身1s 后可读的近实时特性。


> refresh 的特点
1. 不完整提交（因为没有刷盘）
2. refresh 资源消耗相对较小，避免每次文档写入 fsync 导致资源上的瓶颈
3. 默认每 1s 进行一次 refresh，refresh 后的段可以被打开，实现近实时搜索


### translog

translog 就是 ES 的一个事务日志，当发生一个文档变更操作时，文档不仅会写入到内存缓存区也会同样记录到事务日志中，事务日志保证还没有被刷到磁盘的操作的进行持久化。translog 持久化后，保证即使意外断电或者 ES 程序重启，ES 首先通过磁盘中最后一次提交点恢复已经落盘的段，然后将该提交点之后的变更操作，通过 translog 进行重放，重构内存中的 segment。

translog 也可以被用来实时 CRUD 搜索，当我们通过 `_id` 进行查询/更新/删除文档时，ES 在检索该文档对应的 segment 时会优先检查 translog 中最近一次的变更操作，以便获取到最新版本的文档记录。




> translog 的基本流程
1. 一个文档被索引之后，就会被添加到内存缓冲区，并且追加到了 translog
2. 默认每秒 refresh 一次，refresh 会清空内存缓存，但是不会清空 translog
3. refresh 操作不断发生，更多的文档被添加到内存缓冲区和追加到 translog
4. translog 周期性通过 fsync 进行刷盘，默认 5s，可通过参数 `index.translog.sync_interval`、`index.translog.durability` 控制，保证应用重启后先确认最后记录的 `commit point`，`commit point` 之后的变更操作通过落盘的 `translog` 进行重构恢复段
5. 默认当 translog 太大（512MB）时，进行 flush 操作




### flush

将 translog 中所有的段进行全量提交，并对 translog 进行截断的操作叫做 flush，flush 操作期间会做的事项主要有
1. 强制 refresh，将内存缓冲区所有文档写入一个新的段，写入到文件系统缓存并将旧的内存缓冲区被清空（refresh）
2. 将最新的 commit point 写入磁盘
3. 将文件系统缓存中的段通过 fsync 进行刷盘
4. 删除老的 translog，启动新 translog

> flush的特点
1. refresh 会清空内存缓存，但是不会清空 translog
2. flush 操作将文件系统缓存中的 segment 进行 fsync 刷盘，并更新 commit point
3. 当程序意外重启后，es 首先找到 commit point，然后通过 translog 重构 commit point 之后的 segment


> flush 触发时机
1. Flush 的主要目的是把文件缓存系统中的段持久化到硬盘，当 Translog 的数据量达到 512MB 或者 30 分钟时，会触发一次 Flush。
2. `index.translog.flush_threshold_size` 参数的默认值是 512MB，我们可以进行修改。
3. 增加参数值意味着文件缓存系统中可能需要存储更多的数据，所以我们需要为操作系统的文件缓存系统留下足够的空间。

### merge

每次 refresh 操作都会生成一个新的 segment，随着时间的增长 segmengt 会越来越多。这就出现一个比较严重的问题，每次 search 操作必须依次扫描所有的 segment，导致查询效率变慢，为了避免该问题，es 会定期多这个 segment 进行合并操作。


> 什么是merge

将 refresh 产生的多个小 segment 整合为一个大的 segment 的操作就叫做 merge。同时merge 操作会将已经打 `.del` 标签的文档从文件系统进行物理删除。merge 属于一个后台操作。

在 es 中每个 delete 操作其实都是对将要删除的文档打一个 `.del` 的标签，同理 update 操作就是将原文档进行 `.del` 打标然后插入新文档，只有 merge 操作才会将这些已经打标的 `.del` 文件真正进行物理删除。

一个大 segment 的 merge 操作是很消耗 CPU、IO 资源的，如果使用不当会影响到本身的 serach 查询性能。es 默认会控制 merge 进程的资源占用，以保证 merge 期间 search 具有足够资源。


> merge 操作相关流程

1. es 可以对这些零散的小 segment 文件进行合并（包含完全提交以及 searchalbe 的segment）
2. es 会对 merge 操作后的 segment 进行一次 flush 操作，更新磁盘 commit point
3. 将 merge 之后的 segment 打开保证 searchalbe，然后删除 merge 之前的零散的小 segment


> merge 的特点
1. 对文件系统中零散的小 segment 进行合并，合并为一个大的 segment，减少 search 期间依次扫描多个 segment 带来的资源消耗
2. merge 操作会消耗 CPU、IO 资源，ES 对于 merge 操作相对比较保守，会控制每次 merge 操作的带宽限制
3. merge 操作不适用于频繁更新的动态索引，相反它更适合只有 index 的日志型索引，定期将历史索引 segment 进行合并，加快 search 效率



## ES 集群

ES 集群中，主要设计两个概念
1. 分片
2. 副本


一个节点的存储是有限的，所以有了「分片」的概念。但是「分片」存在单点故障问题，于是有了「副本」的概念。

举个例子，ES 有 3 个分片，分片 A、分片 B、分片 C，那么分片 A + 分片 B + 分片 C = 所有数据，每个分片大概只存 1/3 的数据。同时，为了防止分片 A 上的数据丢失，对分片 A 可以设置三个副本 A1、A2、A3，这三个副本上的数据是一样的。




## FAQ
### not_analyzed的String长度大于32766
* ref 1-[whose UTF8 encoding is longer than the max length 32766](https://my.oschina.net/xiaominmin/blog/4329421)


当 ES mapping 中 String 类型的字段，设置了 `"index": "not_analyzed",`，但长度大于 32766 时，会出现如下错误，提示超过了 Lucene 处理的最大值（32766），不予处理并抛出异常。

```s
java.lang.IllegalArgumentException: Document contains at least one immense term in field="reqParams.data" (whose UTF8 encoding is longer than the max length 32766)
```


解决办法为使用 `"ignore_above": xxx` 限定索引的最大长度。

```json
"mappings": {
    "rule": {
        "properties": {
            "dt": {
                "sku_name": "not_analyzed",
                "type": "string",
                "ignore_above": 256
            }
        }
    }
}
```

