
# Spring-03-Spring Boot


[TOC]


## 更新
* 2022/05/16，撰写
* 2022/05/22，添加 *任务调度和多线程*

## 参考资料

* [spring.io](https://spring.io/)
* [Spring Framework & Spring Boot | Java全栈知识体系](https://pdai.tech/md/spring/spring.html)
* [《Spring Boot 2 实战之旅》](https://cread.jd.com/read/startRead.action?bookId=30510020&readType=3)






## 什么是Spring Boot

Spring Boot 是一个基于 Spring 框架的项目模板，用于简化 Spring 应用开发。Spring Boot 的优点包括
* 简化繁琐的 Spring 配置（xml/java 配置）。**Spring Boot 的核心思想是约定大于配置，应用只需要很少的配置即可，简化了应用开发模式。**
* 提供内嵌的 http 服务器（tomcat/jetty），每个 Spring boot 应用都是独立的 web 服务，简化部署（这点特别适用于微服务）
* 简化 maven 依赖配置
* 提供运行监测工具
* 微服务的入门级微框架


Spring 的组件代码是轻量级的，但它的配置却是重量级的。**Spring Boot 不是对 Spring 功能上的增强，只是提供了一种快速使用 Spring 的方式，基于「约定优于配置」的思想，开箱即用。**




## 热部署


引入 `spring-boot-devtools` 依赖，重新编译修改的文件或配置文件（快捷键是 `Command + F9`，即 `Build Project`），Spring Boot 框架会自动重启服务。


```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
</dependency>
```





## 任务调度
* ref 1-[Spring中的线程池与任务调度 | 掘金](https://juejin.cn/post/6900539703113154567)

Spring 中对与任务的执行提供了两种抽象
1. `TaskExecutor`：继承了 JDK 中的 `Executor`接，可用来创建线程池，用于执行异步任务
2. `TaskScheduler`：用于执行定时任务。

> `Executor` 在 JDK 中是线程池的名称。一个 `Executor` 用来表示执行任务的线程池，线程池中至少有一个线程，每个线程都可以用来执行同步或者异步任务。
> 
> `Scheduler` 表示的是定时任务，定时任务的触发，支持 JDK 中的 `Timer` 和 `Quartz Scheduler`。



### TaskExecutor

关于「`TaskExecutor`」，将在「多线程/线程池」章节中介绍。

### TaskScheduler

`TaskScheduler` 用来执行定时任务，`TaskScheduler` 提供了多个方法，方法接受一个 `Runnable` 实例，并返回一个 `ScheduledFuture` 对象。

```java
public interface TaskScheduler {
    ScheduledFuture schedule(Runnable task, Trigger trigger);
    ScheduledFuture schedule(Runnable task, Instant startTime);
    ScheduledFuture schedule(Runnable task, Date startTime);
    ScheduledFuture scheduleAtFixedRate(Runnable task, Instant startTime, Duration
  period);
    ScheduledFuture scheduleAtFixedRate(Runnable task, Date startTime, long period);
    ScheduledFuture scheduleAtFixedRate(Runnable task, Duration period);
    ScheduledFuture scheduleAtFixedRate(Runnable task, long period);
    ScheduledFuture scheduleWithFixedDelay(Runnable task, Instant startTime, Duration
  delay);
    ScheduledFuture scheduleWithFixedDelay(Runnable task, Date startTime, long delay);
    ScheduledFuture scheduleWithFixedDelay(Runnable task, Duration delay);
    ScheduledFuture scheduleWithFixedDelay(Runnable task, long delay);
  }
```


接口 `TaskScheduler` 的实现类有 3 个
1. `ThreadPoolTaskScheduler`：使用的比较多，是对 JDK 中的 `ScheduledThreadPoolExecutor` 的包装。
2. `ConcurrentTaskScheduler`：同样也是对 `ScheduledThreadPoolExecutor` 进行了包装，但是同时也继承了 `ConcurrentTaskExecutor`，提供了更好的并发度。
3. `DefaultManagedTaskScheduler`：基于 JDNI 规范的实现，功能上与 `ConcurrentTaskScheduler` 相同。




## 多线程

### Spring提供的线程池

JDK 中的 `ThreadPoolExecutor` 继承了 `Executor` 接口，我们可以通过 `ThreadPoolExecutor` 来创建线程池。


```java
@FunctionalInterface
public interface TaskExecutor extends Executor {
    void execute(Runnable var1);
}
```

在上文的「任务调度」章节中提到，Spring 中对与任务的执行提供了两种抽象，`TaskExecutor` 和 `TaskScheduler`。其中，`TaskExecutor` 继承了 JDK 中的 `Executor`。类比于 JDK 中的 `ThreadPoolExecutor`，我们也可以通过 `TaskExecutor` 来创建线程池。


对于线程池，Spring 提供了非常完备的封装，提供了多种 `TaskExecutor` 接口的实现
1. `SyncTaskExecutor`
   * 用来执行非异步（同步）的任务，通常用于不需要多线程的场景，实际用的比较少，通常用来执行测试用例。
2. `SimpleAsyncTaskExecutor`
   * 这个实现不会重用任何的线程，每当有新任务的时候，都是重新创建一个线程。所以并没有实现「线程池复用线程」的功能。
3. `ConcurrentTaskExecutor`
   * 这个实现是对 `Executor` 的适配，可以配置 `Executor` 的全部参数。一般很少使用，除非需要完全自主配置线程池。
4. `ThreadPoolTaskExecutor`
   * 较为常用，内部封装了 JDK 的 `ThreadPoolExecutor`。
   * 如果还需要使用 `Executor` 的其他实现，可以使用 `ConcurrentTaskExecutor`。



### @EnableAsync和@Async开启多线程异步执行

* ref 1-[Spring Boot 中如何优雅的使用多线程 | 掘金](https://juejin.cn/post/6844904173977206797)
* ref 2-[Spring 的 @Async 注解实现异步方法 | Segmentfault](https://segmentfault.com/a/1190000041380298)


下面，先通过一个示例了解如何在 Spring 中开启多线程来异步执行任务。


1. 在 Spring Boot 应用中，使用 `@EnableAsync` 注解可以开启异步调用。异步调用时，一般会配置一个线程池，异步的方法交给特定的线程池完成。


```java
@Configuration
@EnableAsync
public class AsyncConfiguration {

    @Bean("doSomethingExecutor")
    public Executor doSomethingExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        // 核心线程数：线程池创建时候初始化的线程数
        executor.setCorePoolSize(10);
        // 最大线程数：线程池最大的线程数，只有在缓冲队列满了之后才会申请超过核心线程数的线程
        executor.setMaxPoolSize(20);
        // 缓冲队列：用来缓冲执行任务的队列
        executor.setQueueCapacity(500);
        // 允许线程的空闲时间60秒：当超过了核心线程之外的线程在空闲时间到达之后会被销毁
        executor.setKeepAliveSeconds(60);
        // 线程池名的前缀：设置好了之后可以方便我们定位处理任务所在的线程池
        executor.setThreadNamePrefix("do-something-");
        // 缓冲队列满了之后的拒绝策略：由调用线程处理（一般是主线程）
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.DiscardPolicy());
        executor.initialize();
        return executor;
    }
}
```


2. 使用 `@EnableAsync` 开启异步调用后，在需要异步调用的方法上添加 `@Async` 注解，即可异步调用该方法。

```java
@RestController
public class AsyncController {

    @Autowired
    private AsyncService asyncService;

    @GetMapping("/open/something")
    public String something() {
        int count = 10;
        for (int i = 0; i < count; i++) {
            asyncService.doSomething("index = " + i);
        }
        return "success";
    }
}


@Slf4j
@Service
public class AsyncService {

    // 指定使用beanname为doSomethingExecutor的线程池
    @Async("doSomethingExecutor")
    public String doSomething(String message) {
        log.info("do something, message={}", message);
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            log.error("do something error: ", e);
        }
        return message;
    }
}
```


3. 使用 `@Async()` 注解时，可以为异步方法指定执行的线程池，如上述代码的 `@Async("doSomethingExecutor")`。如果没有显式指定线程池，默认使用 `SimpleAsyncTaskExecutor` 作为异步方法的默认线程池。




下面，对「`@Async` 注解的使用」和「为异步方法配置线程池」这两个问题，做进一步说明。


#### @Async注解的使用
* `@Async` 标注在方法上，表示该方法进行异步调用。调用者在调用异步方法时将立即得到返回，方法的实际执行将提交给指定的线程池中的线程执行。
* `@Async` 标注在类上时，表示该类的所有方法都是异步方法。


使用 `@Async` 注解让被标注的方法异步执行，需要满足以下前提条件
1. 配置类上添加了 `@EnableAsync` 注解，开启了异步调用。
2. 需要异步执行的方法的所在类，已经交由 Spring 管理。
3. `@Async` 注解的方法一定要通过依赖注入调用（因为要通过代理对象调用），不能直接通过 `this` 对象调用，否则不生效。


使用 `@Async` 来标注方法异步执行，有 3 种应用场景
1. 最简单的异步调用，返回值为 `void` 
2. 带参数的异步调用，返回值为 `void` 
3. 带参数的异步调用，返回值为 `Future` 对象

```java
@Component
public class AsyncDemo {
    // 最简单的异步调用，返回值为 void
    @Async
    public void asyncInvokeSimplest() {
        // ...
    }
    
    // 带参数的异步调用，返回值为 void  
    @Async
    public void asyncInvokeWithParameter(String s) {
        // ...
    }

    // 带参数的异步调用，返回值为 Future 对象
    @Async
    public Future<String> asyncInvokeReturnFuture(int i) {
        Future<String> future;
        try {
            Thread.sleep(1000 * 1);
            future = new AsyncResult<String>("success:" + i);
        } catch (InterruptedException e) {
            future = new AsyncResult<String>("error");
        }
        return future;
    }
}
```



#### 为异步方法配置线程池


在上文中提到，使用 `@Async()` 注解时，可以为异步方法指定执行的线程池，如上述代码的 `@Async("doSomethingExecutor")`。如果没有显式指定线程池，默认使用 `SimpleAsyncTaskExecutor` 作为异步方法的默认线程池。


使用默认的 `SimpleAsyncTaskExecutor` 线程池去执行 `@Async` 标注的异步方法，由于该线程池不会重用线程，所以项目中推荐使用自定义的线程池。


为异步方法配置线程池（自定义线程池），有多种实现方式
1. 实现接口 `AsyncConfigurer`

```java
//AsyncConfigurer接口源码
public interface AsyncConfigurer {
    @Nullable
    default Executor getAsyncExecutor() {
        return null;
    }

    @Nullable
    default AsyncUncaughtExceptionHandler getAsyncUncaughtExceptionHandler() {
        return null;
    }
}

// 配置类实现AsyncConfigurer接口的getAsyncExecutor()方法
@Configuration
@EnableAsync
public class SpringAsyncConfig implements AsyncConfigurer {
    @Override
    public Executor getAsyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(3);//核心池大小
        executor.setMaxPoolSize(6);//最大线程数
        executor.setKeepAliveSeconds(60);//线程空闲时间
        executor.setQueueCapacity(10);//队列程度
        executor.setThreadNamePrefix("my-executor1-");//线程前缀名称
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.AbortPolicy());//配置拒绝策略
        executor.setAllowCoreThreadTimeOut(true);// 允许销毁核心线程
        executor.initialize();
        return executor;
    }
}

```
2. 继承 `AsyncConfigurerSupport`
3. 自定义一个 `TaskExecutor` 类型的 Bean
4. 自定义一个 `Executor` 类型的 Bean （「@EnableAsync和@Async开启多线程异步执行」章节中的 `@Bean("doSomethingExecutor")` 即采用了该方式来自定义线程池）





## 配置文件

### Properties优先级高于YAML

Spring Boot 支持使用 `Properties` 和 `YAML` 两种格式的配置文件。**`Properties` 的优先级高于 `YAML`。**
1. 若两个配置文件同时存在，会先加载优先级低的 `YAML` 文件，再加载优先级高的 `Properties` 文件。
2. 若在 `Properties` 和 `YAML` 中同时定义了一个属性，则最终以 `Properties` 配置文件的配置为准。这是因为 `Properties` 的优先级较高，所以会在最后被加载，`Properties` 中的属性设置会覆盖 `YAML` 中的属性设置。


Spring Boot 中默认的配置文件是 `application.properties`，也可以使用 YAML 格式的配置文件。YAML 文件采用了树状结构，便于阅读。使用 YML 文件时需要注意

1. `application.properties` 文件中以 `.` 分隔的 `key`，在 YAML 文件中会变成树壮结构，以缩进表示层级关系，如 `server.port=8080` 会变成
  
```s
server
    port: 8080
    servlet:
        session:
            timeout: 30  // 设置超时时间为30s  
```
2. 在 `key` 后的冒号一定要跟一个空格，如 `port: 8080`。
3. 如果把原有的 `application.properties` 删除，建议执行一下 `maven -X clean install` 命令。
4. YAML 格式不支持使用注解 `@PropertySource` 导入配置。
5. YAML 文件中大小写敏感


### 不同路径下配置文件的优先级
* ref 1-[Spring 中配置文件的加载顺序以及优先级覆盖 | Blog](https://gschaos.club/641.html)




若在不同路径下同时存在多个配置文件（此处以 YAML 文件为例，Properties 文件同理），应用程序在启动时会遵循下面的顺序加载配置文件（加载顺序如下1/2/3/4，优先级从低到高）
1. 类路径下的配置文件
2. 类路径内 `config` 子目录的配置文件
3. 当前项目根目录下的配置文件
4. 当前项目根目录下 `config` 子目录的配置文件


```s
. project-sample
├── config
│   ├── application.yml （4）
│   └── src/main/resources
|   │   ├── application.yml （1）
|   │   └── config
|   |   │   ├── application.yml （2）
├── application.yml （3）
```

如上工程目录所示
* 启动时加载配置文件顺序为 `1 -> 2 -> 3 -> 4`
* 配置文件优先级为 `4 -> 3 -> 2 -> 1`，优先级高的配置文件最后加载。


### 多环境下配置文件


在实际项目开发中，经常需要配置多个环境，以便不同的环境使用不同的配置参数，比如 
* `application-dev.properties`，`application-prod.properties` 和 `application.properties`（主配置文件）
* `application-dev.yml`，`application-prod.yml` 和 `application.yml`





下面给出一个多环境下配置文件的使用示例。
1. 在申请调用第三方接口时，针对线上/预发环境，会有不同的接口 `token` 配置信息，可以将 `token` 信息存放到不同的配置文件中，如 `production.properties` 和 `beta.properties`配置文件。

2. 创建 `production.properties` 配置文件，用于线上环境
   
```s
# production.properties
user.inc.pool.service.token=252c3fc6f6526272222168999jkjh39
```

3. 创建 `beta.properties` 配置文件，用于预发环境

```s
# beta.properties
user.inc.pool.service.token=252c3fc6f65c55fb8259597963921e9f
```

4. 使用 `@Value("${xxx}")` 注解读取配置信息

```java
@Service
public class UserIncPoolService extends SimpleDeliverySortService {
    @Value("${user.inc.pool.service.token}")
    private String token;
    @Autowired
    DeliveryCmsService deliveryCmsService;
    @Autowired
    private PoolRpcService poolRpcService;
    
    // ...
    
    @Override
    public BaseBiHandler newHandler(DeliverySortHandleParam deliverySortHandleParam) {
        return new UserIncPoolHandler(deliverySortHandleParam.getDids(), deliverySortHandleParam.getUserInfo(), deliveryCmsService, deliverySortHandleParam.getParamMap(), poolRpcService, token);
    }
}
```











### @Proflle实现多环境配置
* ref 1-[使用 @Profile 注解根据环境动态激活相应的组件）](https://www.hangge.com/blog/cache/detail_3105.html)
* ref 2-[Spring 之 @Profile 注解 | 掘金](https://juejin.cn/post/6844904128238501896)



**`@Profile` 是一种条件化配置**，基于运行时激活的环境，会使用或者忽略不同的 Bean 或配置类。可以为生产，开发，测试等不同的环境配置不同的属性。
1. 在 Bean 上使用了 `@Profile` 注解，则只有在 `@Profile` 中指定的环境被激活时，才会将这个Bean 注入到 IoC 容器中。若不指定，默认任何环境下都能注册这个组件。
2. 在配置类上使用了 `@Profile` 注解，则只有在 `@Profile` 中指定的环境被激活时，该配置类中的配置才能生效。

> Spring 3.2 之前，@Profile 注解只能使用在类上。Spring 3.2 之后，@Profile注解也可以使用在方法上。



`@Profile` 的一个常见应用是为不同的环境配置不同的 DataSource，如下代码所示。


```java
@Configuration
@PropertySource(value = {"classpath:/dbconfig.properties"})
public class ProfileBeanConfig implements EmbeddedValueResolverAware {
 
  //数据库连接用户名
  @Value(value = "${jdbc.username}")
  private String username;
  //数据库连接密码
  private String password;
 
  //开发环境数据源
  @Bean(value = "dataSourceDev")
  @Profile(value = "dev")
  public DataSource dataSourceDev(@Value("${jdbc.driverClass}") String driverClass)
          throws PropertyVetoException {
    ComboPooledDataSource comboPooledDataSource = new ComboPooledDataSource();
    comboPooledDataSource.setUser(this.username);
    comboPooledDataSource.setPassword(this.password);
    comboPooledDataSource.setDriverClass(driverClass);
    comboPooledDataSource.setJdbcUrl("jdbc:mysql://localhost:3306/dev");
    return comboPooledDataSource;
  }
 
  //生产环境数据源
  @Bean(value = "dataSourceProduction")
  @Profile("prod")
  public DataSource dataSourceProduction(@Value("${jdbc.driverClass}") String driverClass)
          throws PropertyVetoException {
    ComboPooledDataSource comboPooledDataSource = new ComboPooledDataSource();
    comboPooledDataSource.setUser(this.username);
    comboPooledDataSource.setPassword(this.password);
    comboPooledDataSource.setDriverClass(driverClass);
    comboPooledDataSource.setJdbcUrl("jdbc:mysql://localhost:3306/production");
    return comboPooledDataSource;
  }
}
```



在实际项目中，需要将项目打包为 `.jar` 包部署到服务器上。在打包时，可以通过打包参数指定配置环境，如下所示。


```s
# 使用beta环境
java -jar XXX.jar --spring.profiles.active=beta  
```





### 读取配置文件


#### @Value("${xxx}")


使用 `@Value()` 注解可以读取配置文件中配置的属性值。


* application.properties

```s
# application.properties
book.name = Spring Boot App
book.author = lbs0912
```

* Controller

```java
@RestController
public class HelloController {

    @Value("${book.name}")
    private String bookName;

    @Value("${book.author}")
    private String bookAuthor;

    @GetMapping("/hello")
    public String hello(){
        return "Hello," + bookName + " ,author is " + bookAuthor;
    }
}
```




#### 中文乱码问题

需要注意的是，如果在 `application.properties` 配置文件中配置中文值，在读取时候会出现中文乱码的问题。这是因为 Java 默认采用 ISO-8859-1 的编码方式来读取 `*.properties` 配置文件，而 Spring Boot 应用则使用 UTF-8 编码方式来读取属性值，这就导致了中文乱码问题。


对于这个问题，官方推荐的解决方案是使用 Unicode 的方式来展示中文字符，如下示例。

> 在 [Unicode编码转换 | 站长工具](http://tool.chinaz.com/tools/unicode.aspx) 网站可以进行编码的转换。

```s
# application.properties

book.name = Spring Boot App

# Unicode编码-软件开发
book.author = lbs0912 \u8f6f\u4ef6\u5f00\u53d1
```




#### @ConfigurationProperties


在类上使用 `@ConfigurationProperties(prefix = "xxx")` 注解，表示该类似下所有属性值在读取时，会包括 `prefix=xxx` 中指定的前缀。下面两种代码是等效的。


```java
//使用ConfigurationProperties指定属性的前缀
@ConfigurationProperties(prefix = "config.test")
@Component
@Data
public class ConfigBean {
    private String name;
    private int age;
}
```


```java
//不适用ConfigurationProperties指定属性前缀
@Component
@Data
public class ConfigBean {
    @Value("${config.test.name}")
    private String name;
    @Value("${config.test.age}")
    private int age;
}
```



#### @EnableConfigurationProperties


使用 `@EnableConfigurationProperties` 可以启用一个配置类。下面给出一个具体的例子。


* 创建 `BookConfigBean` 类，使用 `@ConfigurationProperties(prefix = "xxx")` 表示读取配置属性的前缀。


```java
@ConfigurationProperties(prefix = "book")
public class BookConfigBean {
    private String name;
    private String author;
    private String value;
    private int intValue;
    private String title;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public int getIntValue() {
        return intValue;
    }

    public void setIntValue(int intValue) {
        this.intValue = intValue;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
```


* `application.properties` 配置文件


```s
book.name = Spring Boot App
# Unicode编码-软件开发
book.author = lbs0912 \u8f6f\u4ef6\u5f00\u53d1

# 随机字符串
book.value = ${random.value}
book.intValue = ${random.int}
# 100以内的随机数
book.randomValue = ${random.int(100)}}
# 自定义属性间接引用
book.title = title is ${book.name}

```

* 在启动类上添加注解 `@EnableConfigurationProperties`，使使用 `@ConfigurationProperties` 注解的类生效。

```java
/**
 * SpbAppApplication
 * EnableConfigurationProperties 启动配置类
 */
@SpringBootApplication
@EnableConfigurationProperties({BookConfigBean.class})
public class SpbAppApplication {
    public static void main(String[] args) {
        SpringApplication.run(SpbAppApplication.class, args);
    }

}
```

* 在控制器类中创建一个测试方法，序列化输出 `BookConfigBean` 对象的属性值


```java
@RestController
public class HelloController {

    @Value("${book.name}")
    private String bookName;

    @Value("${book.author}")
    private String bookAuthor;


    @Autowired
    private BookConfigBean bookConfigBean;

    @GetMapping("/test")
    public BookConfigBean test(){
        return bookConfigBean;
    }
}
```


* 访问 `http://localhost:8080/test` 会得到序列化输出的 `BookConfigBean` 对象的属性值


```json
{
    "name": "Spring Boot App",
    "author": "lbs0912 软件开发",
    "value": "f4ffa7bf24e6557ed62561212031aa1f",
    "intValue": 504242289,
    "title": "title is Spring Boot App"
}
```







## 日志的使用

* ref 1-[log4j2(日志实现框架) | Blog](https://blog.51cto.com/u_15352995/3898815)

### log4j2和slf4j

`log4j2` 是 Apache 推出一个日志实现框架同时也是一个日志门面，是 `log4j` 的升级版，借鉴了 `logback` 的一些优秀设计并修复了一些问题，性能有较大提升。


目前主流使用 `slf4j` 作为日志门面，能够很方便的切换不同的日志框架，常用的日志方案是 `slf4j` + `log4j2`。对应的 Maven 依赖如下。


```xml
<!--使用slf4j作为日志的门面，使用log4j2来记录日志 -->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
    <version>1.7.30</version>
</dependency>
<!--为slf4j绑定日志实现 log4j2的适配器 -->
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-slf4j-impl</artifactId>
    <version>2.10.0</version>
</dependency>
<!--    Log4j2 门面API    -->
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-api</artifactId>
    <version>2.13.3</version>
</dependency>
<!--    Log4j2的日志实现   -->
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-core</artifactId>
    <version>2.11.1</version>
</dependency>
```



### log4j2中异步日志


`log4j2` 中支持异步日志，这可以大大提升性能。`log4j2` 中提供了 2 种方式使用异步日志
1. `AsyncAppender` 方式
2. `AsyncLogger` 方式（该方式下可以使用全局异步，也可以使用混合异步）



下面对比一些同步日志和异步日志的工作流程。

1. 同步日志的工作流程

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/log4j2-sync-log-1.png)

2. 异步日志的工作流程

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/log4j2-async-log-1.png)


对比两图，可以发现
* 对于同步日志操作，先进行 `Logger` 中的操作并传输到 `LogEvent` 对象中，接着再执行`Appender` 操作进行日志输出。主线程将这些步骤都执行完，才算作一条日志结束。
* 对于异步日志操作，主线程执行完 `Logger` 操作并生成一个 `LogEvent` 对象，将该对象放置到一个队列后就结束返回。队列中的 `LogEvent` 会交由另一个线程 `AsyncThread 2` 操作。





### 使用MDC实现全链路调用日志跟踪

* ref 1-[SpringBoot+MDC实现全链路调用日志跟踪](https://mp.weixin.qq.com/s/KQcudqDHAYOjHff-5KAUug)
* ref 2-[SpringBoot+slf4j实现全链路调用日志跟踪](https://www.cnblogs.com/kevin-ying/p/14483171.html)




MDC（`Mapped Diagnostic Context`），即「映射调试上下文」，是 log4j 、logback 及 log4j2 提供的一种方便在多线程条件下记录日志的功能。**MDC 可以看成是一个与当前线程绑定的哈希表，可以往其中添加键值对。MDC 中包含的内容可以被同一线程中执行的代码所访问。** 当前线程的子线程会继承其父线程中的 MDC 的内容。

当需要记录日志时，只需要从 MDC 中获取所需的信息即可。MDC 的内容则由程序在适当的时候保存进去。对于一个 Web 应用来说，通常是在请求被处理的最开始保存这些数据。


MDC 常用的 API 如下
* `clear()`：移除所有MDC
* `get(String key)`：获取当前线程MDC中指定key的值
* `getContext()`：获取当前线程MDC的MDC
* `put(String key, Object o)`：往当前线程的MDC中存入指定的键值对
* `remove(String key)`：删除当前线程MDC中指定的键值对










## Spring Boot 实战

### 优雅停机
* ref 1-[ref-Spring Boot 2.3 新特性优雅停机详解 | 掘金](https://juejin.im/post/5ec1d89de51d454ddf2367ab)

```java
@RestController
public class DemoController {
	@GetMapping("/demo")
	public String demo() throws InterruptedException {
	    // 模拟业务耗时处理流程
		Thread.sleep(20 * 1000L);
		return "hello";
	}
}
```

当我们流量请求到此接口执行业务逻辑的时候，若服务端此时执行关机（kill），Spring Boot 默认情况会直接关闭容器（如 Tomcat），导致业务逻辑执行失败。在一些业务场景下，会出现数据不一致的情况，事务逻辑不会回滚。


可以使用「优雅停机」避免上述问题。Spring boot 2.3 版本，内置了此功能，不需要再自行扩展容器线程池来处理，目前 Spring Boot 嵌入式支持的 Web 服务器（Jetty、Reactor Netty、Tomcat 和 Undertow）以及反应式和基于 Servlet 的 Web 应用程序都支持优雅停机功能。


需要注意的是，「优雅停机」中的停机行为取决于具体的 Web 容器行文，如下表所示。


|      web容器    |         行为说明                |
|----------------|--------------------------------|
| tomcat 9.0.33+ |	停止接收请求，客户端新请求等待超时 | 
| Reactor Netty	 | 停止接收请求，客户端新请求等待超时 |
| Undertow       |	停止接收请求，客户端新请求直接返回 503 |





要「优雅停机」功能，需要在配置文件 `application.yml` 中进行如下设置
* 当 `server.shutdown=graceful` 启用时，在 Web 容器关闭时，Web 服务器将不再接收新请求，并将等待活动请求完成的缓冲期。
* 设置 `timeout-per-shutdown-phase` 属性值，设置缓冲期的最大等待时间


```s
#application.yml
server:
  shutdown: graceful  #开启优雅停机 默认 IMMEDIATE，即立即关机
spring:
  lifecycle:
    timeout-per-shutdown-phase: 30s  #设置缓冲期的最大等待时间
```


配置完成后，下面进行以下测试。


1. 请求服务端接口

```s
ZBMAC-b286c5fb6:~ liubaoshuai1$ curl http://localhost:8080/demo
hello
```

2. 执行关闭应用

```s
ZBMAC-b286c5fb6:~ liubaoshuai1$ kill -2 60341
ZBMAC-b286c5fb6:~ liubaoshuai1$
```

3. 服务端接到关闭指令

```s
2020-05-17 18:28:28.940  INFO 60341 --- [extShutdownHook] o.s.b.w.e.tomcat.GracefulShutdown : Commencing graceful shutdown. Waiting for active requests to complete
2020-05-17 18:28:45.923  INFO 60341 --- [tomcat-shutdown] o.s.b.w.e.tomcat.GracefulShutdown : Graceful shutdown complete
```

4. 接口请求执行完成


上述测试部分，使用的 `kill -2`，而不是 `kill -9`，两者区别如下

* `kill -2` 相当于快捷键 `Ctrl + C`， 会触发 Java 的 ShutdownHook 事件处理（优雅停机或者一些后置处理可参考以下源码）

```java
//ApplicationContext
@Override
public void registerShutdownHook() {
	if (this.shutdownHook == null) {
		// No shutdown hook registered yet.
		this.shutdownHook = new Thread(SHUTDOWN_HOOK_THREAD_NAME) {
			@Override
			public void run() {
				synchronized (startupShutdownMonitor) {
					doClose();
				}
			}
		};
		Runtime.getRuntime().addShutdownHook(this.shutdownHook);
	}
}
```

* `kill -9`，暴力美学强制杀死进程，不会执行 ShutdownHook



