
# Spring-05-Spring缓存操作


[TOC]





## 更新
* 2022/05/16，撰写




## 参考资料
* [实战 Spring Cache | 掘金](https://juejin.cn/post/6997440726627778597)
* [SpringBoot 缓存技术实战 | 掘金](https://juejin.im/post/5eb633fc51882560d56d6f63)
* [Spring Data Redis 最佳实践 | 掘金](https://juejin.im/post/5e6f703fe51d45270531a214)



## 前言

本文将对 Spring 中缓存技术的使用进行介绍。
* 常用的缓存技术包括本地缓存和 Redis 缓存。
* 介绍 Spring 中常用的 3 种缓存框架
    1. Spring Cache
    2. Layering Cache
    3. Alibaba JetCache





## 本地缓存和Redis缓存

常用的缓存技术包括本地缓存和 Redis 缓存。

1. 本地缓存
使用内存进行缓存，速度快，缺点是不能持久化，一旦项目关闭，数据就会丢失。而且不能满足分布式系统的应用场景（比如数据不一致的问题）。

2. Redis 缓存
利用数据库等进行缓存，最常见的就是 Redis。Redis 的访问速度同样很快，可以设置过期时间、设置持久化方法。缺点是会受到网络和并发访问的影响。



## Spring Cache


Spring Cache 是 Spring 自带的缓存方案，使用简单，既可以使用本地缓存，也可以使用 Redis 缓存。



### Cache接口
* Spring Cache 是 Spring 提供的一整套的缓存解决方案。Spring Cache 并没有提供缓存的实现，提供的是一整套的接口和代码规范、配置、注解等。这样，通过 Spring Cache 就可以整合各种缓存方案了，比如 Redis、EhCache等。
* Spring 3.1 开始定义了 `org.springframework.cache.Cache` 和 `org.springframework.cache.CacheManager` 接口来统一不同的缓存技术，并**支持使用注解**来简化开发（使用到了 AOP 技术）。
* Cache 接口包含了缓存的各种操作方式，同时还提供了各种 `xxxCache` 缓存的实现
  * 针对 Redis 提供了 `RedisCache`
  * 针对 EhCache 提供了 `EhCacheCache`
  * 针对 ConCurrentMap 提供了 `ConcurrentMapCache` 
  * 针对 Caffeine 提供了 `CaffeineCache`



> Spring Framework 5.0（Spring Boot 2.0）版本后，将 `Caffeine` 代替 `Guava` 作为默认的缓存组件。


### 缓存配置


#### 缓存实现方案配置

Spring Cache 并没有提供具体的缓存实现，只是提供了一套接口和和代码规范、配置、注解等。所以在使用 Spring Cache时，要配置具体的缓存实现方案。Spring Cache 支持多种缓存中间件作为框架中的缓存，共有 9 种选择
1. caffeine 
2. couchbase
3. generic
4. hazelcast
5. infinispan
6. jcache
7. redis
8. simple（使用本地内存作为缓存）
9. none（没有缓存）


在配置文件中，可以使用 `spring.cache.type` 指定具体的缓存实现方案，如下所示。

```s
spring.cache.type = redis;
```

若不指定 `spring.cache.type` 属性值，则该值默认为 `simple`，使用内存作为缓存，其底层存储是基于 `ConcurrentHashMap`。

#### 自定义配置


在配置文件中，使用 `spring.cache.type` 指定具体的缓存实现方案后，还可以进行一些自定义配置。此处给出一个针对 Redis 的配置



```s
# 使用 Redis 作为缓存组件
spring.cache.type=redis

# 缓存过期时间为 3600s
spring.cache.redis.time-to-live=3600000

# 缓存的键的名字前缀
spring.cache.redis.key-prefix=my_key_prefix_

# 是否使用缓存前缀
spring.cache.redis.use-key-prefix=true

# 是否缓存空值 防止缓存穿透
spring.cache.redis.cache-null-values=true
```




### 相关注解


|        注解        |       	说明              |
|-------------------|----------------------------|
|    @EnableCaching |             开启缓存         |
|     @Cacheable	|    将方法返回结果存入缓存      |
|     @CachePut	    |    更新缓存中的数据           |
|     @CacheEvict	|    删除缓存中的数据           |
|     @Caching  	| 复杂缓存的实现，如组合多个缓存操作 |
|     @CacheConfig	|  用于配置该类中会用到的一些共用的缓存配置   |



#### @EnableCaching


`@EnableCaching` 用于开启基于注解的缓存功能


```java
@EnableCaching
@Configuration
public class CacheConfig {
    @Bean
    public CacheManager cacheManager() {
        SimpleCacheManager cacheManager = new SimpleCacheManager();
        cacheManager.setCaches(Arrays.asList(new ConcurrentMapCache("default"));
        return cacheManager;
    }
}
```

使用 `@EnableCaching`，和使用如下 XML 配置，在功能上是等效的。


```xml
<beans>
    <cache:annotation-driven/>
    <bean id="cacheManager" class="org.springframework.cache.support.SimpleCacheManager>
        <property name="caches">
            <set>
                <bean class="org.springframework.cache.concurrent.
                             ConcurrentMapCacheFactoryBean>
                    <property name="name" value="default"/>
                </bean>
            </set>
        </property>
    </bean>
</beans>
```



#### @Cacheable


`@Cacheable` 注解的属性值说明如下表所示。


| 属性值  |       描述       |
|--------|------------------|
|  value |  缓存的名称，必须指定至少一个 |
|  key   | 缓存的key，可以为空，也可以使用SpEL表达式指定 |
| condition | 缓存的条件，可使用SpEL表达式指定，如果得到的值为false，则不会缓存 |
|  unless   | SpEL表达式，如果得到的值为true，返回值不会放到缓存中 |
|  sync   | 是否同步模式，默认false，即采用异步模式。设为true时，在缓存不存在时只允许一个线程执行对应方法（如请求DB），其他线程将阻塞，直到将方法返回的结果写入缓存中 |


下面给出一些 `@Cacheable` 使用示例。

```java
//当返回的结果的message字段包 NoCache 就不会进行缓存
@Cacheable(value = "cache", 
    key = "#root.method.name"
    unless = "#result.message.containss('NoCache')"
)

//当返回的结果的为null时不缓存
//当用户名字长度大于2时才缓存
@CachePut(value = "cache", 
    unless="#result == null"
    condition="#userName.length()>2"
)
```


#### @Cacheable中value、key与Redis中key、field的对应关系

* ref 1-[@Cacheable与redis整合时Value和Key的理解 | CSDN](https://blog.csdn.net/hui85206/article/details/97835525?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-97835525-blog-104709595.pc_relevant_antiscanv2&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-97835525-blog-104709595.pc_relevant_antiscanv2&utm_relevant_index=1)
* ref 2-[Spring中的@Cacheable注解的value属性与redis的整合 | 掘金](https://blog.csdn.net/qq_39559641/article/details/104709595)



先给出结论
1. `@Cacheable` 注解的 `value` 参数，对应着 Redis 中 hset 命令的 `key` 字段
2. `@Cacheable` 的 `key` 参数是，对应着 Redis 中 hset命令的 `field` 字段


```java
// 使用 @Cacheable 注解指定 value 和 key 属性
@Cacheable(value='testcache',key='#userName)
```

```s
# Redis 中 hset 设置一个键
hset key field value
```



下面给出一个示例，加深理解。

```java
@Cacheable(value = "userCache", key = "#id")
public User selectUserById(int id) {
    User user = userDao.selectByPrimaryKey(id);
    if(user == null){
        user = new User();
        user.setId(id);
    }
    return user;
}
```

使用 Redis 作为缓存实现方案，并使用 `@Cacheable(value = "userCache", key = "#id")` 进行缓存设置，则会在 Redis 中生产一个键值（key）为 `userCache` 的 Hash 对象，该对象的 `filed` 为 `#id` 对应的值，如下图所示。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/spring-cache-key-value-redis-1.png)






#### @CacheConfig

*  `@CacheConfig` 注解作用于类上，配置该类中一些共用的缓存配置项，如 `value` 属性。
*  若在一个类上使用 `@CacheConfig(value="xxx")` 指定了 `value` 属性，在该类的方法上又指定了 `value` 属性（如 `@Cacheable(value="xxx")`），则以方法上的注解配置为准。




#### @Caching

* `@Caching` 注解是 `@CacheEvict`、`@CachePut`、`@Cacheable` 这三个注解的组合注解。

```java
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Inherited
@Documented
public @interface Caching {

	Cacheable[] cacheable() default {};

	CachePut[] put() default {};

	CacheEvict[] evict() default {};

}
```


* `@Caching` 注解可以用于复杂缓存的实现，如组合多个缓存操作。


```java
@Caching(put = {
    @CachePut(value = "user", key = "#user.id"),
    @CachePut(value = "user", key = "#user.username"),
    @CachePut(value = "user", key = "#user.email")
})
public User save(User user) {
    
}
```

### Spring Cache和缓存击穿、缓存穿透

* ref 1-[一行代码解决缓存击穿问题 | 掘金](https://juejin.cn/post/7088148239572008974#heading-5)
* ref 2-[@Cacheable注解中sync属性 | CSDN](https://blog.csdn.net/yb223731/article/details/107619718)




#### 缓存击穿


系统中若有热点数据缓存过期，此时大量的请求访问了该热点数据，就无法从缓存中读取，直接访问数据库，数据库很容易就被高并发的请求冲垮，造成缓存击穿。


在使用 Spring Cache 时，可使用 `@Cacheable` 注解的 `sync=true`属性，采用同步方式，在缓存不存在时只允许一个线程执行对应方法（如请求DB），其他线程将阻塞，直到将方法返回的结果写入缓存中。

```java
@Cacheable(cacheNames="expensiveOp", sync=true)
public void executeExpensiveOperation(String id) {
    //若无缓存，则请求DB
}
```


#### 缓存穿透

当用户访问的数据，**既不在缓存中，也不在数据库中**。那么当有大量这样的请求到来时，数据库的压力骤增，这就是缓存穿透的问题。


在使用 Spring Cache 时，若采用 Redis 作为缓存实现方案，可以在配置文件中，指定如下属性，避免缓存穿透。

```s
# 是否缓存空值 防止缓存穿透
spring.cache.redis.cache-null-values=true
```




## 其余缓存框架

Spring Cache 是 Spring 自带的缓存方案，也可以采用其余方案进行缓存设计，如
1. Layering Cache
2. Alibaba JetCache


### Layering Cache
* [Layering Cache | github](https://github.com/xiaolyuh/layering-cache)


### Alibaba JetCache
* [Alibaba JetCache | github](https://github.com/alibaba/jetcache)


JetCache 是一个基于 Java 的缓存系统封装，提供统一的 API 和注解来简化缓存的使用。 JetCache 提供了比 SpringCache 更加强大的注解，可以原生的支持 TTL、两级缓存、分布式自动刷新，还提供了 Cache 接口用于手工缓存操作。
