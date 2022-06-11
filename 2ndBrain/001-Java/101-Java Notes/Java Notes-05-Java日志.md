
# Java Notes-05-Java日志

[TOC]

## 更新
* 2020/05/20，撰写
* 2020/10/26，添加 *日志调用链-MDC/NDC*





## 学习资料
* [Log4j2异步日志背后的数字 | CSDN](https://blog.csdn.net/zl1zl2zl3/article/details/106053128)
* [Log4j2异步日志 | blog](https://it-linnan.github.io/log4j2%E5%BC%82%E6%AD%A5%E6%97%A5%E5%BF%97.html)
* [Logback配置文件这么写，TPS提高10倍 | 掘金](https://juejin.im/post/5d4d61326fb9a06aff5e5ff5)
* [日志框架，选择Logback Or Log4j2 | 掘金](https://juejin.im/post/5d66a36c518825199701e2ad)



## log4j 2 

### Overview

* [Apache Log4j 2 官网](http://logging.apache.org/log4j/2.x/)

Log4j 2 中记录日志的方式有同步日志和异步日志两种方式，其中异步日志又可分为使用 
* `AsyncAppender` 异步方式： 采用了 `ArrayBlockingQueue` 来保存需要异步输出的日志事件。
* `AsyncLogger` 异步方式：使用了 `Disruptor` 框架来实现高吞。这也是官方推荐使用的异步方式。


日志输出分类 | 说明
-------------|---------------------------
同步方式 Sync | 同步打印日志，日志输出与业务逻辑在同一线程内，当日志输出完毕，才能进行后续业务逻辑操作
异步方式 Async Appender | 	异步打印日志，内部采用 ArrayBlockingQueue，对每个 AsyncAppender 创建一个线程用于处理日志输出
异步方式 Async Logger | 异步打印日志，采用了高性能并发框架 Disruptor，创建一个线程用于处理日志输出


全异步是官方推荐的，也是性能最佳的方式，但同步异步混合使用，能够提供更大的灵活性。使用AsyncRoot、AsyncLogger、Root、Logger 混合配置，可以实现同步异步混合。但是需要注意，配置中只能有一个 root 元素，也就是只能使用 AsyncRoot 或 Root 中的一个。


### 同步日志

下面给出一个 `log4j 2` 的简单 Demo（同步日志）。

1. Maven工程的 `pom.xml` 中添加如下依赖

```xml
        <!-- Log4j2 API接口 -->
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-api</artifactId>
            <version>2.0-rc1</version>
        </dependency>
        <!-- Log4j2 API实现 -->
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-core</artifactId>
            <version>2.0-rc1</version>
        </dependency>
        <!-- Log4j2 web项目支持 -->
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-web</artifactId>
            <version>2.11.2</version>
        </dependency>
        <!-- Apache Commons Logging桥接适配器 -->
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-jcl</artifactId>
            <version>2.11.2</version>
        </dependency>
        <!--SLF4J桥接适配器-->
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-slf4j-impl</artifactId>
            <version>2.11.2</version>
        </dependency>
```

2. 调用 `log4j 2`，输出日志


```java

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


@SpringBootApplication
public class DemoApplication {
    static  final Logger logger = LogManager.getLogger(DemoApplication.class.getName());

    public static void main(String[] args) {
        logger.trace("simple demo-trace"); //trace 跟踪
        logger.debug("simple demo-debug");
        logger.warn("simple demo-warn");
        logger.info("simple demo-info");
        logger.error("simple demo-error");
        logger.fatal("simple demo-fatal");  //fatal  致命错误
    }
}
```

Log4j2 中的日志 Level 分为 8 个级别，优先级从高到低依次为
1. OFF
2. FATAL
3. ERROR
4. WARN
5. INFO
6. DEBUG
7. TRACE
8. ALL






### AsyncAppender 异步日志

`Async Appender` 异步方式中，内部使用的一个队列（`ArrayBlockingQueue`）和一个后台线程，日志先存入队列，后台线程从队列中取出日志。阻塞队列容易受到锁竞争的影响，当更多线程同时记录时性能可能会变差。


### Async Logger 异步日志

`Async Logger` 异步方式中，内部使用的是 `LMAX Disruptor` 技术，`Disruptor` 是一个无锁的线程间通信库，它不是一个队列，不需要排队，从而产生更高的吞吐量和更低的延迟。这也是官方推荐使用的异步方式。


## Logback

### 参考资料

* [Logback配置文件这么写，TPS提高10倍 | 掘金](https://juejin.im/post/5d4d61326fb9a06aff5e5ff5)



## slf4j


### slf4j.Logger打印日志使用占位符{}代替加号(+)拼接

在使用 `slf4j.Logger` 日志类打印日志时，推荐使用占位符 `{}`，而不是直接使用 `+` 进行字符串的拼接。

使用占位符 `{}` 更加高效 ，避免字符串连接操作，避免对 `String` 对象（不可变）的操作。


```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

private final static Logger logger = LoggerFactory.getLogger(MyClass.class);


//good style
log.error("商品会员价过滤，skuId:{}, infoResult:{}", skuId, JsonUtil.write2JsonStr(infoResult)); 

//bad style
log.error("商品会员价过滤，skuId: " + skuId + " ,infoResult:{}" + JsonUtil.write2JsonStr(infoResult)); 
```

## AOP切面统一打印日志

### 参考资料
* [Spring Boot 自定义注解，AOP 切面统一打印出入参请求日志 | Blog](https://www.exception.site/springboot/spring-boot-aop-web-request)
* [又被逼着优化代码，这次我干掉了出入参 Log日志 |知乎](https://juejin.im/post/5f1543205188252e753697ee)
* [AOP切面统一打印日志 | Blog](https://www.cnblogs.com/quanxiaoha/p/10414681.html)




### 实现












## 日志调用链-MDC/NDC
### 基本概念
* [Java日志Log4j或者Logback的NDC和MDC功能](https://blog.csdn.net/FataliBud/article/details/102364278?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-3.channel_param&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-3.channel_param)
* [org.apache.log4j的MDC和NDC](https://blog.csdn.net/wangxr66/article/details/84228368)

#### NDC

NDC采用栈的机制存储上下文，线程独立的，子线程会从父线程拷贝上下文。其调用方法如下
1.开始调用

```
NDC.push(message);
```

2.删除栈顶消息

```
NDC.pop();
```

3.清除全部的消息，必须在线程退出前显示的调用，否则会导致内存溢出。

```
NDC.remove();
```

4.输出模板，注意是小写的[%x]

```
log4j.appender.stdout.layout.ConversionPattern=[%d{yyyy-MM-dd HH:mm:ssS}] [%x] : %m%n
```



#### MDC

MDC 采用 Map 的方式存储上下文，线程独立的，子线程会从父线程拷贝上下文。其调用方法如下

1.保存信息到上下文

```
MDC.put(key, value);
```

2.从上下文获取设置的信息

```
MDC.get(key);
```

3.清楚上下文中指定的key的信息

```
MDC.remove(key);
```

4.清除所有

```
clear()
```

5.输出模板，注意是大写[%X{key}]

```
log4j.appender.consoleAppender.layout.ConversionPattern = %-4r [%t] %5p %c %x - %m - %X{key}%n
```

### Demo

* JSF日志调用链追踪：https://cf.jd.com/pages/viewpage.action?pageId=271173717

素材JSF中，利用 `org.apache.log4j.MDC` 对日志输出内容进行了扩充，可参考文档 https://blog.csdn.net/wangxr66/article/details/84228368。

项目实现业务类为 `LogMethodInterceptor`。

```java
package com.jd.material.jsf.intercepter;

import com.jd.common.util.StringUtils;
import com.jd.jsf.gd.util.Constants;
import com.jd.jsf.gd.util.RpcContext;
import com.jd.material.jsf.data.common.SysParam;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.log4j.MDC;

public class LogMethodInterceptor  implements MethodInterceptor {
    @Override
    public Object invoke( MethodInvocation invocation ) throws Throwable {
        boolean add = false;
        Object reqId = MDC.get("reqId");
        if (reqId == null) {
            MDC.put("reqId", RandomStringUtils.randomAlphanumeric(8));
            MDC.put("appId", getAppId(invocation.getArguments()));
            add = true;
        }
        Object res = invocation.proceed();
        if (add) {
            MDC.remove("reqId");
            MDC.remove("appId");
        }
        return res;
    }

    private String getAppId(Object[] arguments) {
        String appId = (String) RpcContext.getContext().getAttachment(Constants.HIDDEN_KEY_APPID);
        if (StringUtils.isBlank(appId) && arguments != null) {
            for (Object obj : arguments) {
                if (obj instanceof SysParam) {
                    SysParam sysParam = (SysParam) obj;
                    appId = sysParam.getSourceCode();
                    break;
                }
            }
        }
        if (StringUtils.isBlank(appId)) {
            appId = "";
        }
        return appId;
    }
}

```

利用 `traceId` 结合 `logbook` 即可查看某次调用的所有日志。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/jd-base/jd-ndc-logger-1.png)

