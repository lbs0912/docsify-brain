# Redis-02-Jedis使用

[TOC]

## 更新
* 2021/12/19，撰写
* 2022/05/05，添加 *Jedis事务*


## 参考资料
* [jedis | github](https://github.com/redis/jedis)
* [jedis-maven](https://mvnrepository.com/artifact/redis.clients/jedis)
* [使用Jedis操作Redis](https://www.cnblogs.com/-beyond/p/10991139.html)
* [Redis入门-在Java中使用Redis](https://juejin.im/post/5eb610c76fb9a0436d41a6d9)
* [Jedis操作 —— Redis的事务、管道和脚本](https://blog.csdn.net/KingCat666/article/details/77942830)





## 入门Demo


1. 在项目中添加 Jedis （Java 和 Redis 的混拼）


```xml
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
    <version>3.2.0</version>
</dependency>
```

2. 新建 `UserInfo` 实体类

```java
public class UserInfo {
    private String name;
    private int age;
     public UserInfo(String name,int age){
         this.name = name;
         this.age = age;
     }

    @Override
    public String toString() {
         return "UserInfo{" +
                 "name = ' " + name + '\'' +
                 ", age = " + age +
                 '}';
    }
    
    // getter / setter
}
```

3. 在项目中添加 Gson（用于序列化和反序列化用户信息） 依赖


```xml
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.8.6</version>
    <scope>compile</scope>
</dependency>
```

4. 新建测试类


```java
public class RedisTestApplication {
    private  static  final  String  REDIS_KEY = "user";
    public static void main(String[] args) {
        Jedis jedis = new Jedis("localhost", 6379);

        //测试jedis连接
        String str = jedos.ping();
        System.out.println("测试连接：" + str); //PONG

        Gson gson = new Gson();
        UserInfo userInfo  = new UserInfo("沉默的羔羊",18);

        jedis.set(redisKey,gson.toJson(userInfo));
        UserInfo getUserInfoFromRedis = gson.fromJson(jedis.get(redisKey),UserInfo.class);

        System.out.println("get: " + getUserInfoFromRedis);
        System.out.println("exists: " + jedis.exists(redisKey));
        System.out.println("del: " + jedis.del(redisKey));
        System.out.println("get: " + jedis.get(redisKey));
    }
}
```

* `REDIS_KEY` 常量为存储用户信息到 Redis 的 key。
* 在 Jedis 的帮助下，Java 连接 Redis 服务变得非常简单，只需要一行代码。参数分别是主机名，端口号。

```java
Jedis jedis = new Jedis("localhost",6379);复制代码
```

* 存储键值对用 `set()` 方法，获取键值对用 `get()` 方法，判断键值对是否存在用 `exists()` 方法，删除键值对用 `del()` 方法

运行程序，可以看到如下输出

```s
测试连接：PONG
get: UserInfo{name = ' 沉默的羔羊', age = 18}
exists: true
del: 1
get: null
```



此时，使用 `redis-cli` 进入本地 Redis 命令窗模式，直接查看 Redis 中内容。



```s
lbsmacbook-pro:~ lbs$ redis-cli
127.0.0.1:6379> kget user
(error) ERR unknown command `kget`, with args beginning with: `user`, 
127.0.0.1:6379> get user
"{\"name\":\"lbs0912\",\"age\":1992}"
127.0.0.1:6379> 
```



## Jedis基本使用


Jedis 的基本使用非常简单，只需要创建 Jedis 对象的时候指定 host，port, password 即可。

```java
Jedis jedis = new Jedis("localhost", 6379);  //指定Redis服务Host和port

jedis.auth("xxxx"); //如果Redis服务连接需要密码，制定密码

String value = jedis.get("key"); //访问Redis服务

jedis.close(); //使用完关闭连接
```


在 Jedis 对象构建好之后，Jedis 底层会打开一条 Socket 通道和 Redis 服务进行连接。所以在使用完 Jedis 对象之后，需要调用 `jedis.close()` 方法把连接关闭，不然会占用系统资源。





## Jedis连接池

如果应用非常频繁的创建和销毁 Jedis 对象，对应用的性能是很大影响的，因为构建 Socket 的通道是很耗时的(类似数据库连接)。我们应该使用连接池来减少 Socket 对象的创建和销毁过程。



使用 Jedis 连接池，一定要手动关闭连接（释放连接），否则会因为连接耗尽而导致操作阻塞。



```java
public class JedisPoolExample {
 
    @Test
    public void testUsePool() {
 
        // 配置连接池
        JedisPoolConfig config = new JedisPoolConfig();
        config.setMaxTotal(20);
        config.setMaxIdle(10);
        config.setMinIdle(5);
 
        // 创建连接池
        JedisPool jedisPool = new JedisPool(config, "localhost", 6379);
 
        Jedis jedis = jedisPool.getResource();
 
        // 使用jedis进行操作
        jedis.set("name", "otherNameVal");
 
        // 用完之后，一定要手动关闭连接（归还给连接池）
        jedis.close();
        pool.close();
    }
}
```


## Jedis工具类封装

对于 Jedis 连接池来说，只需要初始化一次即可，所以可以将其在工具类中实现。



```java
package cn.ganlixin.redis.util;
 
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
 
/**
 * 描述: Jedis工具类（封装了连接池）
 */
public class JedisUtils {
 
    private static JedisPool jedisPool;
 
    static {
        // 配置连接池
        JedisPoolConfig config = new JedisPoolConfig();
        config.setMaxTotal(5);
        config.setMaxIdle(3);
        config.setMinIdle(2);
 
        // 创建连接池
        jedisPool = new JedisPool(config, "localhost", 6379);
    }
 
    /**
     * 获取redis连接
     */
    public static Jedis getJedis() {
        return jedisPool.getResource();
    }
}
```


## Jedis事务


```java
    Jedis jedis = RedisCacheClient.getInstrance().getClient();
    //乐观锁 WATCH
    String watch = jedis.watch("watchKey");
    //MULTI
    Transaction multi = jedis.multi();
    //事务的具体操作
    multi.set("testabcd", "23432");
    //EXEC
    List<Object> exec = multi.exec();
    //UNWATCH
    jedis.unwatch();
```



