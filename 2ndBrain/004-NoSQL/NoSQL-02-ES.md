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

