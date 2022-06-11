
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