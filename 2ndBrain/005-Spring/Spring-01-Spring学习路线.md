
# Spring-01-Spring学习路线


[TOC]


## 更新
* 2022/05/16，撰写


## 学习路线

### 书籍
* [《Spring Boot 2 实战之旅》](https://cread.jd.com/read/startRead.action?bookId=30510020&readType=3)


### 参考资料
* [spring.io](https://spring.io/)
* [Spring Framework & Spring Boot | Java全栈知识体系](https://pdai.tech/md/spring/spring.html)
* [Spring Boot Guide | Gitbook](https://snailclimb.gitee.io/springboot-guide/#/)
* [Spring教程 | W3Cschool](https://www.w3cschool.cn/wkspring/)


  

## Spring面试汇总


### Spring为什么把Bean设为单例
1. 提高性能，减少了新生成实例的消耗
2. 减少了 JVM 的垃圾回收
3. 可以快速获取到 bean（单例的获取除了第一次生成之外都是从缓存中获取的）


### Spring bean的id和name的区别
* [spring bean id和bean name的区别](https://blog.csdn.net/weixin_34279184/article/details/85743761)

1. id：一个 bean 的唯一标识，命名格式必须符合 XML ID 属性的命名规范
2. name：可以用特殊字符，并且一个 bean 可以用多个名称，`name="bean1,bean2,bean3"`，用逗号或者分号或者空格隔开。
3. **如果一个 bean 没有指定 id，则 name 的第一个名称默认是 id。**


spring 容器如何处理同名 bean？
1. 同一个 spring 配置文件中，bean的 id、name 是不能够重复的，否则 spring 容器启动时会报错。
2. 如果一个 spring 容器从多个配置文件中加载配置信息，则多个配置文件中是允许有同名 bean 的，并且后面加载的配置文件的中的 bean 定义会覆盖前面加载的同名 bean。


spring 容器如何处理没有指定id、name 属性的 bean？
1. 如果 一个 `<bean>` 标签未指定 id、name 属性，则 spring 容器会给其一个默认的id，值为其类全名。
2. 如果有多个 `<bean>` 标签未指定 id、name 属性，则 spring 容器会按照其出现的次序，分别给其指定 id 值为 `"类全名#1"`，`"类全名#2"`。


举个例子，如下配置文件。

```xml
<bean class="com.xxx.UserInfo">  
    <property name="accountName" value="no-id-no-name0"></property>  
</bean>  
  
<bean class="com.xxx.UserInfo">  
    <property name="accountName" value="no-id-no-name1"></property>  
</bean>  
  
<bean class="com.xxx.UserInfo">  
    <property name="accountName" value="no-id-no-name2"></property>  
</bean>  
```

上述 bean 都没有指定 id 和 name，在获取这些bean 时，其对应 id 为 `"类全名#1"`，`"类全名#2"`。

```java
// 获取bean的方式
UserInfo u = (UserInfo)ctx.getBean("com.xxx.UserInfo");  
UserInfo u1 = (UserInfo)ctx.getBean("com.xxx.UserInfo#1");  
UserInfo u2 = (UserInfo)ctx.getBean("com.xxx.UserInfo#2");
```



### Spring中有两个id相同的bean，会报错吗？如果报错，在哪个阶段报错
* [Spring 中，有两个 id 相同的 bean，会报错吗?如果会报错，在哪个阶段报错](https://juejin.cn/post/7112361883327266847)


针对「Spring中有两个id相同的bean，会报错吗？如果报错，在哪个阶段报错」这个问题，回答如下。

1. 首先，在同一个 XML 配置文件里面，不能存在 id 相同的两个 bean，否则 spring 容器启动的时候会报错。因为 id 这个属性表示一个 Bean 的唯一标志符号，所以 Spring 在启动的时候会去验证 id 的唯一性，一旦发现重复就会报错。这个错误发生 Spring 对 XML 文件进行解析，转化为 BeanDefinition 的阶段。

2. 但是，在两个不同的 Spring 配置文件里面，可以存在 id 相同的两个 bean。IOC 容器在加载 Bean 的时候，默认会多个相同 id 的 bean 进行覆盖。不过，在 Spring 3.x 版本以后，这个问题发生了变化。

3. 我们知道 Spring 3.x 里面提供 `@Configuration` 注解去声明一个配置类，然后使用 `@Bean` 注解实现 Bean 的声明，这种方式完全取代了 XMl。在这种情况下，如果我们在同一个配置类里面声明多个相同名字的 bean，在 Spring IOC 容器中只会注册第一个声明的 Bean 的实例。后续重复名字的 Bean 就不会再注册了。

```java
@Configuration
public class SpringConfiguration {
    @Bean(name = "userService")
    public UserService01 userService01(){
        return new UserService01();
    }
    @Bean(name = "userService")
    public UserService02 userService02(){
        return new UserService02();
    }
}
```
像上面这样一段代码，在 Spring IOC 容器里面，只会保存 UserService01 这个实例，后续相同名字的实例不会再加载。

如果使用 `@Autowired` 注解根据类型实现依赖注入，因为 IOC 容器只有 `UserService01` 的实例，所以启动的时候会提示找不到 `UserService02` 这个实例。


```java
@Autowired
private  UserService01 userService01;

@Autowired
private  UserService02 userService02;
```

如果使用 `@Resource` 注解根据名词实现依赖注入，在 IOC 容器里面得到的实例对象是 `UserService01`。于是 Spring 把 `UserService01` 这个实例赋值给 `UserService02`，就会提示类型不匹配错误。


```java
@Resource(name="userService")
private  UserService01 userService01;

@Resource(name="userService")
private  UserService02 userService02;
```

这个错误，是在 Spring IOC 容器里面的 Bean 初始化之后的依赖注入阶段发生的。



### Spring Boot的约定优于配置
* ref 1-[对Spring Boot的约定优于配置的理解 | 掘金](https://juejin.cn/post/7084136380095266823)

对「Spring Boot的约定优于配置」这句话，如何理解？


1. 首先，约定优于配置是一种软件设计的范式，它的核心思想是减少软件开发人员对于配置项的维护，从而让开发人员更加聚焦在业务逻辑上。
2. Spring Boot 就是约定优于配置这一理念下的产物，它类似于 Spring 框架下的一个脚手架，通过 Spring Boot，我们可以快速开发基于 Spring 生态下的应用程序。
3. 基于传统的 Spring 框架开发 web 应用，我们需要做很多和业务开发无关并且只需要做一次的配置，比如
   * 管理 jar 包依赖
   * web.xml 维护
   * Dispatch-Servlet.xml 配置项维护
   * 应用部署到 Web 容器
   * 第三方组件集成到 Spring IOC 容器中的配置项维护

而在 Spring Boot 中，我们不需要再去做这些繁琐的配置，Spring Boot 已经自动帮我们完成了，这就是约定由于配置思想的体现。

4. Spring Boot 约定由于配置的体现有很多，比如
   * Spring Boot Starter 启动依赖，它能帮我们管理所有 jar 包版本。
   * 如果当前应用依赖了 spring mvc 相关的 jar，那么 Spring Boot 会自动内置 Tomcat 容器来运行 web 应用，我们不需要再去单独做应用部署。
   * Spring Boot 的自动装配机制的实现中，通过扫描约定路径下的 spring.factories 文件来识别配置类，实现 Bean 的自动装配。
   * 默认加载的配置文件 application.properties

总的来说，约定优于配置是一个比较常见的软件设计思想，它的核心本质都是为了更高效以及更便捷的实现软件系统的开发和维护。




### 类的静态方法无法使用AOP拦截
* ref 1-[static 方法能被 AOP 动态代理吗 | CSDN](https://blog.csdn.net/sdmanooo/article/details/122467797)
* ref 2-[AOP 不能对类的静态方法进行增强](https://blog.csdn.net/weixin_29576901/article/details/117481744)

> 为什么 static 方法不能被动态代理？

**类的静态方法无法使用 AOP 拦截，即 AOP 不能对类的静态方法进行增强。**


因为不管是 JDK 的动态代理，还是 CGLIB 的动态代理，都是要通过代理的方式获取到代理的**具体对象**，而 static 是不属于对象的，是属于类。所以静态方法是不能被重写的，正因为不能被重写，所以动态代理也不成立。


> 如果一定要增强 static 方法，要如何做？

如果一定要增强静态方法，我们可以对目标类使用单例模式，然后通过调用实例方法去调用那个静态方法，而且对应的对象实例必须纳入 spring 容器管理，因此可以使用`@Component` 声明下（注意不能直接 new，直接 new 的对象不会纳入 IOC 管理，这样就不会被 AOP 识别），然后在 set 实例方法上使用 `@Autowired`，将对象注入到 `static` 修饰的静态类对象。


### AOP的嵌套调用
* ref 1-[解决AOP切面在嵌套方法调用时不生效问题](https://www.freesion.com/article/3329487995/)


在使用 AOP 切面编程中，通常会遇到一个方法嵌套调用，导致 AOP 不生效的问题。如下面所说明的
1. 在一个实现类中，有 2 个方法，方法 A，方法 B，其中方法 B 上面有个注解切面，当方法 B 被外部调用的时候，会进入切面方法。
2. 但当方法 B 是被方法 A 调用时，并不能从方法 B 的注解上，进入到切面方法，即我们经常碰到的方法嵌套时，AOP 注解不生效的问题。


> 问题描述

假设对 `methodDemoA` 方法的 AOP 增强方位为打印 A，对 `methodDemoB` 方法的 AOP 增强方位为打印 B。

* 场景1：单独调用方法 A 和方法 B时，两个方法对应的 AOP 增强方法都会被调用，会打印出 A 和 B

```java
@Autowired
DemoService demoService;

@Test
public void testMethod(){
    demoService.methodDemoA();
    demoService.methodDemoB();
}
```


* 场景2：如果在方法 A 内部去调用方法 B，则只会打印出 A，不会打印 B


```java
@Service
public class DemoServiceImpl implements DemoService {
    @Override
    public void methodDemoA(){
        System.out.println("this is method A");
        methodDemoB();
    }

    @Override
    @DemoAnno
    public void methodDemoB() {
        System.out.println("this is method B");
    }
}
```

```java
@Autowired
DemoService demoService;

@Test
public void testMethod(){
    demoService.methodDemoA();
    //demoService.methodDemoB();
}
```




> 原因分析

场景 1 中，方法 A 和方法 B 都是通过外部调用的。Spring 在启动时，根据切面类及注解，生成了 DemoService 的代理类，在调用方法 B 时，实际上是代理类先对目标方法进行了业务增强处理（执行切面类中的业务逻辑，如执行 `proxyB` 代理方法），然后再调用方法 B 本身。所以场景 1 可以正常进入切面方法，表现为打印 A 和 B。

场景 2 中，通过外部调用的是方法 A，方法 B 是内部调用的。虽然 Spring 也会创建一个代理类去调用方法 A，**但当方法 A 调用方法 B 的时候，属于类里面的内部调用，使用的是实例对象本身去去调用方法 B**，非 AOP 的代理对象调用，方法 B 自然就不会进入到切面方法了。


> 如何解决


对于场景 2，我们在业务开发过程中经常会碰到，但我们期望的是，方法 A 在调用方法 B 的时候，仍然能够进入切面方法，即需要 AOP 切面生效。

这种情况下，我们在调用方法 B 的时候，需要使用 `AopContext.currentProxy()` 获取当前的代理对象，然后使用代理对象调用方法 B。

> 需要开启 `exposeProxy=true` 的配置，SpringBoot 项目中，可以在启动类上面，添加 `@EnableAspectJAutoProxy(exposeProxy = true)` 注解。


```java
@Service
public class DemoServiceImpl implements DemoService {
    @Override
    public void methodDemoA(){
        System.out.println("this is method A");
        DemoService service = (DemoService) AopContext.currentProxy();
        service.methodDemoB();
    }

    @Override
    @DemoAnno
    public void methodDemoB() {
        System.out.println("this is method B");
    }
}
```



### Spring 中 Bean 的 ID 一定要有吗

* ref 1-[Spring 中 bean 的 id 是否一定要有](https://blog.csdn.net/guan3515/article/details/85675419)

1. 每个 Bean 可以有一个 id 属性，并可以根据该 id 在 IoC 容器中查找该 Bean，该 id 属性值必须在 IoC 容器中唯一。
2. 可以不指定 id 属性，只指定全限定类名，如下代码所示。此时需要通过接口 `getBean(Class<T> requiredType)` 来获取 Bean。


```xml
<bean class="com.zyh.spring3.hello.StaticBeanFactory"></bean>
```


如果该 Bean 找不到则抛异常 `NoSuchBeanDefinitionException`。如果该类型的 Bean 有多个，也会抛异常 `NoUniqueBeanDefinitionException`。

3. 如果不指定 id，只指定 name，那么 name 为 Bean 的标识符，并且需要在容器中唯一。
4. 同时指定 name 和 id，此时 id 为标识符，而 name 为 Bean 的别名，两者都可以找到目标Bean。




## Spring 全家桶
Spring 全家桶包括
* Spring Framework
* Spring Boot
* Spring MVC
Spring MVC 构建于 Servlet API 之上，使用的是同步阻塞式 I/O 模型，每一个请求对应一个线程去处理。
* Spring WebFlux
一个异步非阻塞式的 Web 框架，它能够充分利用多核 CPU 的硬件资源去处理大量的并发请求。WebFlux 内部使用的是响应式编程（`Reactive Programming`），以 `Reactor` 库为基础，基于异步和事件驱动，可以让我们在不扩充硬件资源的前提下，提升系统的吞吐量和伸缩性。










## Spring Boot 实战项目

* ref 1-[Github 上热门的 Spring Boot 项目实战推荐](https://juejin.im/post/5da3c3dce51d4578034d2dc3)
* ref 2-[springboot-guide | github](https://github.com/Snailclimb/springboot-guide): 适合新手入门以及有经验的开发人员查阅的 Spring Boot 教程
* ref 3-[spring-security-jwt-guide | github](https://github.com/Snailclimb/spring-security-jwt-guide): Spring Security With JWT（含权限验证）学习资料


> mall

* [mall | github](https://github.com/macrozheng/mall)
* [mall-learning](http://www.macrozheng.com/#/)
* [mall架构及功能概览 | 掘金](https://juejin.im/post/5cf7c305e51d4510b71da5c5)
* star: 22.9k
* 介绍: mall 项目是一套电商系统，包括前台商城系统及后台管理系统，基于 SpringBoot + MyBatis 实现。 前台商城系统包含首页门户、商品推荐、商品搜索、商品展示、购物车、订单流程、会员中心、客户服务、帮助中心等模块。 后台管理系统包含商品管理、订单管理、


> jeecg-boot

* [jeecg-boot | github](https://github.com/zhangdaiscott/jeecg-boot)
* star: 6.4k
* 介绍: 一款基于代码生成器的 JAVA 快速开发平台！采用最新技术，前后端分离架构：SpringBoot 2.x，Ant Design & Vue，Mybatis，Shiro，JWT。强大的代码生成器让前后端代码一键生成，无需写任何代码，绝对是全栈开发福音！！ JeecgBoot 的宗旨是提高 UI 能力的同时，降低前后分离的开发成本，JeecgBoot 还独创在线开发模式，No代码概念，一系列在线智能开发：在线配置表单、在线配置报表、在线设计流程等等。

> eladmin
* [eladmin | github](https://github.com/elunez/eladmin)
* star: 3.9k
* 介绍: 项目基于 Spring Boot 2.1.0 、 Jpa、 Spring Security、redis、Vue 的前后端分离的后台管理系统，项目采用分模块开发方式， 权限控制采用 RBAC，支持数据字典与数据权限管理，支持一键生成前后端代码，支持动态路由。


> paascloud-master
* [paascloud-master](https://github.com/paascloud/paascloud-master)
* star: 5.9k
* 介绍: spring cloud + vue + oAuth2.0 全家桶实战，前后端分离模拟商城，完整的购物流程、后端运营平台，可以实现快速搭建企业级微服务项目。支持微信登录等三方登录。

> vhr
* [vhr | github](https://github.com/lenve/vhr)
* star: 10.6k
* 介绍: 微人事是一个前后端分离的人力资源管理系统，项目采用 SpringBoot + Vue 开发。


>  One mall
* [One mall](https://github.com/YunaiV/onemall)
* star: 1.2k
* 介绍: mall 商城，基于微服务的思想，构建在 B2C 电商场景下的项目实战。核心技术栈是 Spring Boot + Dubbo 。未来，会重构成 Spring Cloud Alibaba 



> Guns
* [Guns](https://github.com/stylefeng/Guns)
* star: 2.3k
* 介绍:  Guns 基于 SpringBoot 2，致力于做更简洁的后台管理系统，完美整合 springmvc + shiro + mybatis-plus + beetl! Guns 项目代码简洁，注释丰富，上手容易，同时Guns包含许多基础模块(用户管理，角色管理，部门管理，字典管理等10个模块)，可以直接作为一个后台管理系统的脚手架!


>  SpringCloud
* [SpringCloud](https://github.com/YunaiV/onemall)
* star: 1.2k
* 介绍: mall 商城，基于微服务的思想，构建在 B2C 电商场景下的项目实战。核心技术栈是 Spring Boot + Dubbo 。未来，会重构成 Spring Cloud Alibaba 。



> SpringBoot-Shiro-Vue
* [SpringBoot-Shiro-Vue](https://github.com/Heeexy/SpringBoot-Shiro-Vue)
* star: 1.8k
* 介绍: 提供一套基于 Spring Boot-Shiro-Vue 的权限管理思路。前后端都加以控制，做到按钮/接口级别的权限。


> newbee-mall
* [newbee-mall](https://github.com/newbee-ltd/newbee-mall)
* star: 50
* 介绍: newbee-mall 项目是一套电商系统，包括 newbee-mall 商城系统及 newbee-mall-admin 商城后台管理系统，基于 Spring Boot 2.X 及相关技术栈开发。 前台商城系统包含首页门户、商品分类、新品上线、首页轮播、商品推荐、商品搜索、商品展示、购物车、订单结算、订单流程、个人订单管理、会员中心、帮助中心等模块。后台管理系统包含数据面板、轮播图管理、商品管理、订单管理、会员管理、分类管理、设置等模块。







## Spring WebFlux
* ref 1-[Spring Boot 2.0 WebFlux 教程  | 掘金](https://juejin.im/post/5cb5d71d51882545dd09b634)
* ref 2-[Spring WebFlux 和 Spring MVC 对比分析 | 掘金](https://juejin.cn/post/6844904193946451981)




### 响应式编程

响应式编程（`Reactive Programming`）是基于异步和事件驱动的非阻塞程序，只是垂直通过在 JVM 内启动少量线程扩展，而不是水平通过集群扩展。


### WebFlux简介

* Spring WebFlux 是一个异步非阻塞式的 Web 框架，它能够充分利用多核 CPU 的硬件资源去处理大量的并发请求。
* WebFlux 内部使用的是响应式编程（`Reactive Programming`），以 `Reactor` 库为基础，基于异步和事件驱动，可以让我们在不扩充硬件资源的前提下，提升系统的吞吐量和伸缩性。
* 需要明确的是，WebFlux 并不能使接口的响应时间缩短，它仅仅能够提升吞吐量和伸缩性。


> Reactive and non-blocking generally do not make applications run faster.
> 
> **WebFlux 并不能使接口的响应时间缩短，它仅仅能够提升吞吐量和伸缩性。**


### Spring MVC和Spring WebFlux对比

#### 异同点

> Spring MVC is built on the Servlet API and uses a synchronous blocking I/O architecture with a one-request-per-thread model.

Spring MVC 构建于 Servlet API 之上，使用的是同步阻塞式 I/O 模型（每一个请求对应一个线程去处理）。


> Spring WebFlux is a non-blocking web framework built from the ground up to take advantage of multi-core, next-generation processors and handle massive numbers of concurrent connections.


Spring WebFlux 是一个异步非阻塞式的 Web 框架，它能够充分利用多核 CPU 的硬件资源去处理大量的并发请求。Spring WebFlux 特别适合应用在 IO 密集型的服务中，比如微服务网关这样的应用中。

> IO 密集型包括磁盘 IO 密集型和网络 IO 密集型。微服务网关就属于网络 IO 密集型，使用异步非阻塞式编程模型，能够显著地提升网关对下游服务转发的吞吐量。


Spring MVC 和 Spring WebFlux 的对比如下图所示。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/spring-webflux-mvc-diff-1.png)

可以看到，两者相同点包括
* 都可以使用 Spring MVC 注解，如 `@Controller`
* 均可以使用 `Tomcat`, `Jetty`, `Undertow Servlet` 容器（Servlet 3.1+）
* ...

在使用过程中，需要注意的是
* Spring MVC 因为是使用的同步阻塞式，更方便开发人员编写功能代码，Debug 测试等。一般来说，如果 Spring MVC 能够满足的场景，就尽量不要用 WebFlux。
* WebFlux 默认情况下使用 Netty 作为服务器。
* **WebFlux 不支持 MySql等关系型数据库，只支持 NoSQL。**
* Spring MVC 支持 NoSQL 和 MySQL。




#### 响应请求的过程对比

以「响应一次请求」为例，对比 Spring MVC 和 Spring  WebFlux 在处理请求上的差异。

> MVC 工作方式
1. 主线程接收到请求（request）
2. 准备数据
3. 返回数据

整个过程是单线程阻塞的。用户感觉等待时间较长是因为在结果处理好之后才返回数据给浏览器。因此，如果请求很多，则吞吐量就上不去。


> WebFlux 的工作流程
1. 主线程接收到请求（request）
2. 立刻返回数据和函数的组合（`Mono` 或者 `Flux`，如下代码示例）


```java
@RestController
public class HelloWebFluxController {
    @GetMapping("/user")
    public Mono<User> getUser() {
        User user = new User();
        user.setName("lbs0912");
        user.setDesc("desc info");
        return Mono.just(user);
    }
}
```
需要注意的是，`User` 对象是通过 `Mono` 对象包装的。`Mono` 是非阻塞的写法。在 WebFlux 中，`Mono` 和 `Flux` 均能充当响应式编程中发布者的角色
   * `Mono` 使用在 返回 0 或 1 个元素的场景，即单个对象
   * `Flux` 使用在返回 N 个元素的场景，即 `List` 列表对象




2. 开启一个新 Work 线程去做实际的数据准备工作，进行真正的业务操作
3. Work 线程完成工作
4. 返给用户真实数据（结果）


这种方式给人的感觉是响应时间很短，因为返回的是不变的常数，它不随用户数量的增加而变化。








## FAQ

### 运行Tomcat服务报错“目录不可用”


在IntelliJ IDEA中运行 Tomcat 本地服务时，若出现如下信息，则表示对应的目录有权限限制。


```
Error running 'Tomcat 9.0.29': Error copying configuration files from /Library/apache-tomcat-9.0.29/conf to /Users/lbs/Library/Caches/IntelliJIdea2019.3/tomcat/Tomcat_9_0_29_Spittr_2/conf: Directory is invalid /Library/apache-tomcat-9.0.29/conf/Catalina
```

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/spring-web-tomcat-faq-1.png)

针对本例情况，找到 `/Library/apache-tomcat-9.0.29/conf/Catalina` 文件夹，并设置读写权限即可。


### Tomcat运行项目时出现 `no artifacts configured` 警告

* [【错误解决】Intellj（IDEA） warning no artifacts configured | CSDN](https://blog.csdn.net/small_mouse0/article/details/77506060)