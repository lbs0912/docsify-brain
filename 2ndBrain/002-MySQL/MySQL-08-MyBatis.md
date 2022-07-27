
# MySQL-08-Mybatis


[TOC]


## 更新
* 2022/05/30，撰写




## 参考资料
* [MyBatis | W3CSchool](https://www.w3cschool.cn/mybatis/)





## 前言

MyBatis 是一个 Java 持久化框架，它通过 XML 描述符或注解，把对象与存储过程或 SQL 语句关联起来。MyBatis 是支持定制化 SQL、存储过程以及高级映射的优秀的持久层框架。



## MyBatis 工作流程

1. 通过 Reader 对象读取 Mybatis 映射文件
2. 通过 `SqlSessionFactoryBuilder` 对象创建 `SqlSessionFactory` 对象
3. 获取当前线程的 `SQLSession`
4. 事务默认开启
5. 通过 `SQLSession` 读取映射文件中的操作编号，从而读取 SQL 语句
6. 提交事务
7. 关闭资源


下面，结合具体的代码对上述步骤进行说明。

* 创建 XML 映射文件

```xml
<!-- CountryMapper.xml -->
<!-- 定义当前XML的命名空间 -->
<mapper namespace="com.lbs0912.model.mapper.CountryMapper">
    <!-- ID属性，定义当前select查询的唯一ID；resultType，定义当前查询的返回值类型，如果没有设置别名，则需要写成cn.mybatis.model.Country -->
    <select id="selectAll" resultType="Country">
		select id, countryname, countrycode from country
	</select>
</mapper>
```

* 通过 `new SqlSessionFactoryBuilder().build(reader)` 创建 `SqlSessionFactory` 对象；再通过 `sqlSessionFactory.openSession()` 获取当前线程的 `SQLSession`，核心代码如下

```java
public class MyBatisDemo {

    private static SqlSessionFactory sqlSessionFactory;

    /**
     * 初始化sqlSessionFactory
     */
    public static void init() {
        try {
            //1.通过 Reader 对象读取 Mybatis 映射文件
            Reader reader = Resources.getResourceAsReader("mybatis-config.xml");
            //2. 通过 SqlSessionFactoryBuilder 对象创建 SqlSessionFactory 对象
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
            reader.close();
        } catch (IOException ignore) {
            ignore.printStackTrace();
        }
    }

    public static void main(String[] args) {

        // 连接数据库
        init();
        // 3.获取当前线程的 SQLSession
        SqlSession sqlSession = sqlSessionFactory.openSession();
        try {
            //5. 通过 SQLSession 读取映射文件中的操作编号，读取 SQL 语句
            List<Country> countryList = sqlSession.selectList("selectAll");
            printCountryList(countryList);
        } finally {
            sqlSession.close();
        }
    }

}
```



## MyBatis XML 映射文件

### DynamicSQL


当需要根据传入参数的值来动态组装 SQL 时，可以使用 `<dynamic>` 标签。 `<dynamic>` 标签中可以包含多个条件比较元素。

```xml

<mapper namespace="com.lbs0912.model.mapper.PersonMapper">
    <select id="selectPerson" resultType="Person">
		select * from Person
        <dynamic prepend="where"> 
        <isNotNull property="name" prepend="and">
            name=#name#
        </isNotNull>
        <isNotNull property="sex" prepend="and">
            sex=#sex#
        </isNotNull>               
    </dynamic>
	</select>
</mapper>
```

在上面的例子中，当 `name` 和 `sex` 都非 `null` 时，执行的 SQL 语句为

```sql
select * from Person where name = xxx  and sex = xxx
```


### #{}和${}

* ref 1-[#{}如何防止SQL注入 | 掘金](https://juejin.cn/post/7064740474057146398)




`#{}` 和 `${}` 的区别如下
* **`#{}` 采用预编译方式，将传入的值作为字符串处理，可以防止 SQL 注入。`${}` 采用直接赋值方式，无法阻止 SQL 注入攻击。**
* 使用 `#{}` 时，会根据传进来的值自动选择是否加上双引号。使用 `${}` 时则不会，只会进行普通的传值。



> `#{}` 在底层使用了 `PreparedStatement` 类的 `setString()` 方法来设置参数。此方法会获取传递进来的参数的每个字符，然后进行循环对比，如果发现有敏感字符，如单引号、双引号等，会在前面加上一个转义字符 `\`，让其变为一个普通的字符串，不参与 SQL 语句的生成，达到防止 SQL 注入的效果。



下面结合一个示例进行说明。

```sql
select * from t_user where username = ?;
```

上述查询语句中，分别使用 `#{}` 和 `${}` 传入查询参数 `username`。

1. 传入 `username` 为 `a'or'1=1`，使用 `#{}`，经过 SQL 动态解析和预编译，会在单引号前面添加转义字符 `\'`，SQL 最终解析为

```sql
select * from t_user where username = "a\' or \'1=1";
```


2. 如果使用 `${}` 接收参数，会直接进行参数的替换，SQL 最终解析为


```sql
select * from t_user where username = 'a' or '1=1';
```


这样会查询所有的用户信息，并不是预期的效果。



### `<iterate>`


使用 `<iterate>` 标签遍历入参，如下代码所示。

```xml
<update id="batchUpdateTitle" parameterClass="java.util.HashMap">
    UPDATE
    material_doc_center_title
    SET
    last_update_time = now()
    <dynamic prepend=",">
        <isNotNull prepend="," property="status">
            status = #status#
        </isNotNull>
        <isNotNull prepend="," property="erpNo">
            last_update_erp = #erpNo#
        </isNotNull>
    </dynamic>
    WHERE
        id in <iterate open="(" close=")" conjunction="," property="idArr">#idArr[]#</iterate>
</update>
```




## MyBatis的缓存

介绍 MyBatis 的缓存前，先回顾下 MySQL 的缓存。

### MySQL的缓存


MySQL 内部自带了一个缓存模块，默认关闭。MySQL 8.0 版本中，查询缓存功能已经被移除了。

MySQL 8.0 版本前，使用 `show global variables like "query_cache%"` 可以查看缓存相关的参数信息，`query_cache_type` 默认只为 `OFF`，即默认缓存查询功能关闭。


对于缓存，我们一般交给 ORM 框架处理，比如 MyBatis 默认开启了一级缓存，或者独立的缓存服务器，比如 Redis。




### MyBatis的缓存机制

* ref 1-[聊聊MyBatis缓存机制 | 美团技术](https://tech.meituan.com/2018/01/19/mybatis-cache.html)
* ref 2-[mybatis的缓存机制 | CSDN](https://blog.csdn.net/u012373815/article/details/47069223)



MyBatis 提供查询缓存，用于减轻数据压力，提高数据库性能。MyBaits 提供了一级缓存和二级缓存。
* MyBatis 的二级缓存相对于一级缓存来说，实现了 `sqlSession` 之间缓存数据的共享，同时粒度更加的细，能够到 `namespace` 级别，通过 `Cache` 接口实现类不同的组合，对 `Cache` 的可控性也更强。
* MyBatis 在多表查询时，极大可能会出现脏数据，有设计上的缺陷，安全使用二级缓存的条件比较苛刻。
* 在分布式环境下，由于默认的 MyBatis Cache 实现都是基于本地的，分布式环境下必然会出现读取到脏数据，需要使用集中式缓存将 MyBatis 的 Cache 接口实现，有一定的开发成本，直接使用 Redis、Memcached 等分布式缓存可能成本更低，安全性也更高。


#### 一级缓存

一级缓存是 `sqlSession` 级别的缓存。Mybatis 默认开启一级缓存。


在操作数据库时需要构造 `sqlSession` 对象，在对象中有一个（内存区域）数据结构（HashMap）用于存储缓存数据。不同的 `sqlSession` 之间的缓存数据区域（HashMap）是互相不影响的。

一级缓存的作用域是同一个 `sqlSession`。在同一个 `sqlSession` 中两次执行相同的 `sql` 语句，第一次执行完毕会将数据库中查询的数据写到缓存（内存），第二次会从缓存中获取数据将不再从数据库查询，从而提高查询效率。当一个 `sqlSession` 结束后该 `sqlSession` 中的一级缓存也就不存在了。

使用 `sqlSession` 第一次查询后，MyBatis 会将其放在缓存中，以后再查询的时候，如果没有声明需要刷新，并且缓存没有超时的情况下，`sqlSession` 都会取出当前缓存的数据，而不会再次发送 SQL 到数据库。



一级缓存的生命周期
* MyBatis 在开启一个数据库会话时，会创建一个新的 `sqlSession` 对象，`sqlSession` 对象中会有一个新的 `Executor` 对象，`Executor` 对象中持有一个新的 `PerpetualCache` 对象。当会话结束时，`sqlSession` 对象及其内部的 `Executor` 对象还有 `PerpetualCache` 对象也一并释放掉。
* 如果 `sqlSession` 调用了 `close()` 方法，会释放掉一级缓存 `PerpetualCache` 对象，一级缓存将不可用。
* 如果 `sqlSession` 调用了 `clearCache()`，会清空 `PerpetualCache` 对象中的数据，但是该对象仍可使用。
* `sqlSession` 中执行了任何一个 `update`、`delete`、`insert` 操作 ，都会清空 `PerpetualCache` 对象的数据，但是该对象可以继续使用。


#### 二级缓存

MyBatis 的二级缓存是 `Application` 级别的缓存，它可以提高对数据库查询的效率，以提高应用的性能。

Mybatis 默认没有开启二级缓存，需要在 `setting` 全局参数中配置开启二级缓存。


二级缓存是 `Mapper` 级别的缓存，多个 `sqlSession` 去操作同一个 `Mapper`的 `sql` 语句，多个 `sqlSession` 去操作数据库得到数据会存在二级缓存区域，多个 `sqlSession` 可以共用二级缓存，二级缓存是跨 `sqlSession` 的。




##  MySQL的连接池
* ref 1-[数据库连接池到底应该设多大 | 掘金](https://juejin.cn/post/7030599868615753758)



**首先，需要明确的是，线程最大个数和内存有关，和 CPU 核数无关。CPU 核数是和线程的运行效率有关。线程过多会涉及上下文的切换，一旦线程的数量超过了 CPU 核心的数量，再增加线程数系统就只会更慢，而不是更快。**

### 连接池的计算公式

下面的公式是由 PostgreSQL 提供的，不过我们认为可以广泛地应用于大多数数据库产品。你应该模拟预期的访问量，并从这一公式开始测试你的应用，寻找最合适的连接数值。

```s
连接数 = ((核心数 * 2) + 有效磁盘数)
```

核心数不应包含超线程（hyper thread），即使打开了 hyperthreading 也是。如果活跃数据全部被缓存了，那么有效磁盘数是0，随着缓存命中率的下降，有效磁盘数逐渐趋近于实际的磁盘数。这一公式作用于 SSD 时的效果如何尚未有分析。

按这个公式，你的 4 核 i7 数据库服务器的连接池大小应该为 `((4 * 2) + 1) = 9`。取个整就算是是 10 吧。是不是觉得太小了？跑个性能测试试一下，我们保证它能轻松搞定 3000 用户以 6000TPS 的速率并发执行简单查询的场景。如果连接池大小超过 10，你会看到响应时长开始增加，TPS 开始下降。

### 公理：你需要一个小连接池和一个充满了等待连接的线程的队列

需要明确的是，你需要的并不是一个较大的连接池，而是一个小连接池和一个充满了等待连接的线程的队列。


如果你有 10000 个并发用户，设置一个 10000 的连接池基本等于失了智。1000 仍然很恐怖。即是 100 也太多了。你需要一个 10 来个连接的小连接池，然后让剩下的业务线程都在队列里等待。连接池中的连接数量应该等于你的数据库能够有效同时进行的查询任务数（通常不会高于 `2*CPU核心数`）。

我们经常见到一些小规模的 web 应用，应付着大约十来个的并发用户，却使用着一个 100 连接数的连接池。这会对你的数据库造成极其不必要的负担。




### 连接池的大小最终与系统特性相关

连接池的大小最终与系统特性相关。

比如一个混合了长事务和短事务的系统，通常是任何连接池都难以进行调优的。最好的办法是创建两个连接池，一个服务于长事务，一个服务于短事务。

再例如一个系统执行一个任务队列，只允许一定数量的任务同时执行，此时并发任务数应该去适应连接池连接数，而不是反过来。



## MyBatis的连接池
* ref 1-[MyBatis 连接池和事务管理 | 掘金](https://juejin.cn/post/6844903968640860173)

MyBatis 主要利用数据源（Date Source）来管理数据库连接，分为
1. 不使用连接池的 `UnpooledDataSource`
2. 使用连接池的 `PooledDataSource`
3. 使用 JNDI 实现的数据源的 `JndiDataSource`

> JNDI 是 Java 命名与目录接口，全称为 `Java Naming and Directory Interface`。


### 使用连接池的 `PooledDataSource`

`PooledDataSource` 将 `connection` 包装成 `PooledConnection` 对象放到 `PoolState` 连接容器中，这个连接容器中有两种连接。


```java
  protected PooledDataSource dataSource;

  //空闲的连接
  protected final List<PooledConnection> idleConnections = new ArrayList<PooledConnection>();
  //活动的连接
  protected final List<PooledConnection> activeConnections = new ArrayList<PooledConnection>();

```


`PooledDataSource` 获取连接会优先从空闲连接 list 中取，当前正在被使用的连接会放入活动连接的 list 中。


从连接池中获取连接的流程如下。
1. while 循环不断尝试获取
2. 先判断空闲连接池中是否还有空闲连接
   * 有空闲连接，则返回连接池第一个连接
   * 没有空闲连接，则查看活动连接池信息
3. 判断活动连接池中是否达到了最大连接数
   * 若没有达到，则直接 new 一个新连接
   * 若达到，则不能再 new 新连接，获取连接池中最老的的连接，删除该连接后 new 一个新连接



## MyBatis-Plus

* [MyBatis-Plus](https://baomidou.com/)


`MyBatis-Plus`（简称 MP）是一个 MyBatis 的增强工具，在 MyBatis 的基础上只做增强不做改变，为简化开发、提高效率而生。



## Spring如何管理Mybatis的Mapper接口

@todo 受限于时间，本章节笔记后续待整理


* ref 1-[Spring 是怎样管理 Mybatis 的及注入Mybatis Mapper Bean的](https://www.cnblogs.com/panxuejun/p/6770386.html)
* ref 2-[Mybatis 的Mapper 是如何注入到Spring 容器](https://blog.51cto.com/u_15103022/2640427)

Spring 启动 Mybatis 的两个重要类如下（这两个类都是 `org.mybatis.spring` 包中的）
1. `org.mybatis.spring.SqlSessionFactoryBean`
2. `org.mybatis.spring.mapper.MapperFactoryBean`


`Mpper` 对象实际上是一个 `MapperProxy`，而且是 JDK 动态代理技术生成的对象。


在 IOC 初始化时，使用 FactoryBean 的方式，通过 `MapperProxyFactory` 生成代理对象，核心调用如下。

```s
IOC 初始化 -> MapperFactoryBean -> SqlSessionTemplate -> Configuration -> mapperRegistry.addMappers -> MapperProxyFactory.newInstance
```

Mybatis Mapper 接口确实是通过动态注册到容器，并通过动态代理生成代理对象。Mapper 对象的实现功能本质上是一样的，就是通过 Mapper 找到对应的 Sql statement，绑定参数、执行SQL、返回封装结果。


## FAQ

### 时间格式出现`.0`的解决

使用 MyBatis 存储时间时，常常会遇到下发的时间戳最后包含 `.0` 的情况，如下所示。

```s
2020-09-03 22:53:34.0
```

解决办法是使用 SQL 的时间格式化函数进行处理。

```s
DATE_FORMAT(create_time,'%Y-%m-%d %H:%i:%S') AS createTime

DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%S') AS createTime
```



其实，时间戳最后的 `.0` 表示纳秒数，详情参考 [SQL Timestamp | Oracle](https://docs.oracle.com/javase/7/docs/api/java/sql/Timestamp.html#toString())

```s
Formats a timestamp in JDBC timestamp escape format. yyyy-mm-dd hh:mm:ss.fffffffff, where ffffffffff indicates nanoseconds.
```