

# Spring-06-Spring中定时任务

[TOC]



## 更新
* 2020/06/23，撰写
* 2022/05/19，整理


## 参考资料

* [SpringBoot几种定时任务的实现方式 | CSDN](https://blog.csdn.net/wqh8522/article/details/79224290)
* [定时任务框架Quartz-(一)Quartz入门与Demo搭建 | CSDN](https://blog.csdn.net/noaman_wgs/article/details/80984873)
* [SpringBoot中使用Quartz| 掘金](https://juejin.im/post/6885869364180942862)



## 定时任务的实现方式

Spring 中实现一个定时任务，有如下方案可选
1. 基于 `java.util.Timer` 定时器，实现类似闹钟的定时任务
2. 基于 `java.util.concurrent.ScheduledExecutorService`
3. 使用 Spring 提供的 `@Schedule` 注解，开发简单，使用比较方便
4. 使用 Quartz、elastic-job、xxl-job 等开源第三方定时任务框架，适合分布式项目应用，但配置相比前几种方案，略显复杂


## 基于java.util.Timer实现定时任务


基于 `java.util.Timer` 定时器，实现类似闹钟的定时任务。 这种方式在项目中使用较少，参考如下示例。

```java
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

public class SpringbootAppApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringbootAppApplication.class, args);
		System.out.println("Server is running ...");

		TimerTask timerTask =  new TimerTask() {
			@Override
			public void run() {
				System.out.println("task  run:"+ new Date());
			}
		};
		Timer timer = new Timer();
		timer.schedule(timerTask,10,3000);
	}
}
```


## 基于ScheduledExecutorService实现定时任务

使用 `java.util.concurrent.ScheduledExecutorService` 实现定时任务，该方案类似 `Timer` ，参考如下示例。


```java
public class TestScheduledExecutorService {
    public static void main(String[] args) {
        ScheduledExecutorService service = Executors.newSingleThreadScheduledExecutor();
        
        /**
         *  @param command the task to execute 任务体
         *  @param initialDelay the time to delay first execution 首次执行的延时时间
         *  @param period the period between successive executions 任务执行间隔
         *  @param unit the time unit of the initialDelay and period parameters 间隔时间单位
         */
         service.scheduleAtFixedRate(()->System.out.println("task ScheduledExecutorService "+new Date()), 0, 3, TimeUnit.SECONDS);
    }
}
```



## 使用@Schedule注解实现定时任务

* ref 1-[Spring Schedule 实现定时任务 | github](https://github.com/Snailclimb/springboot-guide/blob/master/docs/advanced/SpringBoot-ScheduleTasks.md)

### 示例

1. 首先，在项目启动类上添加 `@EnableScheduling` 注解，开启对定时任务的支持。**`@EnableScheduling` 注解的作用是发现注解 `@Scheduled` 的任务并在后台执行该任务。**


```java
@SpringBootApplication
@EnableScheduling
public class ScheduledApplication {

	public static void main(String[] args) {
		SpringApplication.run(ScheduledApplication.class, args);
	}

}
```

2. 编写定时任务类和方法，定时任务类通过 Spring IOC 加载，使用 `@Component` 注解。
3. 定时方法使用 `@Scheduled`注解。下述代码中，`fixedRate` 是 `long` 类型，表示任务执行的间隔毫秒数，下面代码中的定时任务每 3 秒执行一次。

```java
@Component
public class ScheduledTask {

    @Scheduled(fixedRate = 3000)
    public void scheduledTask() {
        System.out.println("任务执行时间：" + LocalDateTime.now());
    }

}
```
4. 运行工程，项目启动和运行日志如下，可见每 3 秒打印一次日志执行记录。

```s
Server is running ...
任务执行时间-ScheduledTask：2020-06-23T18:02:14.747
任务执行时间-ScheduledTask：2020-06-23T18:02:17.748
任务执行时间-ScheduledTask：2020-06-23T18:02:20.746
任务执行时间-ScheduledTask：2020-06-23T18:02:23.747
```


### @Scheduled注解

在上面 Demo 中，使用了 `@Scheduled(fixedRate = 3000)` 注解来定义每过 3 秒执行的任务。对于 `@Scheduled` 的使用可以总结如下几种方式。

* `@Scheduled(fixedRate = 3000)` 
上一次开始执行时间点之后 3 秒再执行（`fixedRate` 属性：定时任务开始后再次执行定时任务的延时（需等待上次定时任务完成），单位毫秒）。

* `@Scheduled(fixedDelay = 3000)`
上一次执行完毕时间点之后 3 秒再执行（`fixedDelay` 属性：定时任务执行完成后再次执行定时任务的延时（需等待上次定时任务完成），单位毫秒）。

* `@Scheduled(initialDelay = 1000, fixedRate = 3000)`
第一次延迟1秒后执行，之后按 `fixedRate` 的规则每 3 秒执行一次（ `initialDelay` 属性：第一次执行定时任务的延迟时间，需配合 `fixedDelay` 或者 `fixedRate` 来使用）。

* `@Scheduled(cron="0 0 2 1 * ? *")`
通过 `cron` 表达式定义规则。


> 关于「Corn表达式」，将在文末介绍。

### 多线程执行定时任务

创建多个定时任务，并打印线程名称，示例代码如下。


```java
import org.slf4j.LoggerFactory;

@Component
public class ScheduledTask {
    private static final org.slf4j.Logger logger = LoggerFactory.getLogger(ScheduledTask.class);

    @Scheduled(cron = "0/5 * * * * *")
    public void scheduled(){
        logger.info("使用cron---任务执行时间：{}  线程名称：{}",LocalDateTime.now(),Thread.currentThread().getName());
    }
    
    @Scheduled(fixedRate = 5000)
    public void scheduled1() {
        logger.info("fixedRate---任务执行时间：{}  线程名称：{}",LocalDateTime.now(),Thread.currentThread().getName());
    }
    @Scheduled(fixedDelay = 5000)
    public void scheduled2() {
        logger.info("fixedDelay---任务执行时间：{}  线程名称：{}",LocalDateTime.now(),Thread.currentThread().getName());
    }
}
```

程序输出如下。


```s
2020-06-23 23:31:04.447  INFO 34069 : fixedRate---任务执行时间：2020-06-23T23:31:04.447  线程名称：scheduling-1
2020-06-23 23:31:04.494  INFO 34069 : fixedDelay---任务执行时间：2020-06-23T23:31:04.494  线程名称：scheduling-1
2020-06-23 23:31:05.004  INFO 34069 : 使用cron---任务执行时间：2020-06-23T23:31:05.004  线程名称：scheduling-1
2020-06-23 23:31:09.445  INFO 34069 : fixedRate---任务执行时间：2020-06-23T23:31:09.445  线程名称：scheduling-1
2020-06-23 23:31:09.498  INFO 34069 : fixedDelay---任务执行时间：2020-06-23T23:31:09.498  线程名称：scheduling-1
2020-06-23 23:31:10.003  INFO 34069 : 使用cron---任务执行时间：2020-06-23T23:31:10.003  线程名称：scheduling-1
2020-06-23 23:31:14.444  INFO 34069 : fixedRate---任务执行时间：2020-06-23T23:31:14.444  线程名称：scheduling-1
2020-06-23 23:31:14.503  INFO 34069 : fixedDelay---任务执行时间：2020-06-23T23:31:14.503  线程名称：scheduling-1
2020-06-23 23:31:15.002  INFO 34069 : 使用cron---任务执行时间：2020-06-23T23:31:15.002  线程名称：scheduling-1
```

可以看到，3 个定时任务都已经执行，并且使同一个线程中串行执行。当定时任务增多，如果一个任务卡死，会导致其他任务也无法执行。

因此，需要考虑多线程执行定时任务的情况。

1.  创建配置类：在传统的 Spring 项目中，我们可以在 xml 配置文件添加 task 的配置，而在 Spring Boot 项目中一般使用 `config` 配置类的方式添加配置，所以新建一个 `AsyncConfig` 类。**在配置类中，使用 `@EnableAsync` 注解开启异步事件的支持。**


```java
package com.lbs0912.spring.demo.app;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

@Configuration
@EnableAsync

public class AsyncConfig {

    private int corePoolSize = 10;
    private int maxPoolSize = 200;
    private int queueCapacity = 10;

    @Bean
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(corePoolSize);
        executor.setMaxPoolSize(maxPoolSize);
        executor.setQueueCapacity(queueCapacity);
        executor.initialize();
        return executor;
    }
}
```

* `@Configuration`：表明该类是一个配置类
* `@EnableAsync`：开启异步事件的支持


2. 在定时任务的类或者方法上添加 `@Async` 注解，表示是异步事件的定时任务。

```java
@Component
@Async
public class ScheduledTask {
    private static final org.slf4j.Logger logger = LoggerFactory.getLogger(ScheduledTask.class);
    

    @Scheduled(cron = "0/5 * * * * *")
    public void scheduled(){
        logger.info("使用cron  线程名称：{}",Thread.currentThread().getName());
    }
    
    @Scheduled(fixedRate = 5000)
    public void scheduled1() {
        logger.info("fixedRate--- 线程名称：{}",Thread.currentThread().getName());
    }
    @Scheduled(fixedDelay = 5000)
    public void scheduled2() {
        logger.info("fixedDelay  线程名称：{}",Thread.currentThread().getName());
    }
}
```

3. 运行程序，控制台输出如下，可以看到，定时任务是在多个线程中执行的。


```java
2020-06-23 23:45:08.514  INFO 34824 : fixedRate--- 线程名称：taskExecutor-1
2020-06-23 23:45:08.514  INFO 34824 : fixedDelay  线程名称：taskExecutor-2
2020-06-23 23:45:10.005  INFO 34824 : 使用cron  线程名称：taskExecutor-3

2020-06-23 23:45:13.506  INFO 34824 : fixedRate--- 线程名称：taskExecutor-4
2020-06-23 23:45:13.510  INFO 34824 : fixedDelay  线程名称：taskExecutor-5
2020-06-23 23:45:15.005  INFO 34824 : 使用cron  线程名称：taskExecutor-6

2020-06-23 23:45:18.509  INFO 34824 : fixedRate--- 线程名称：taskExecutor-7
2020-06-23 23:45:18.511  INFO 34824 : fixedDelay  线程名称：taskExecutor-8
2020-06-23 23:45:20.005  INFO 34824 : 使用cron  线程名称：taskExecutor-9

2020-06-23 23:45:23.509  INFO 34824 : fixedRate--- 线程名称：taskExecutor-10
2020-06-23 23:45:23.511  INFO 34824 : fixedDelay  线程名称：taskExecutor-1
2020-06-23 23:45:25.005  INFO 34824 : 使用cron  线程名称：taskExecutor-2

2020-06-23 23:45:28.509  INFO 34824 : fixedRate--- 线程名称：taskExecutor-3
2020-06-23 23:45:28.512  INFO 34824 : fixedDelay  线程名称：taskExecutor-4
2020-06-23 23:45:30.005  INFO 34824 : 使用cron  线程名称：taskExecutor-5

2020-06-23 23:45:33.509  INFO 34824 : fixedRate--- 线程名称：taskExecutor-6
2020-06-23 23:45:33.513  INFO 34824 : fixedDelay  线程名称：taskExecutor-7
2020-06-23 23:45:35.005  INFO 34824 : 使用cron  线程名称：taskExecutor-8

...

```


## Quartz实现定时任务
* ref 1-[Quartz Documentation](http://www.quartz-scheduler.org/documentation/)

`Quartz` 是一个开源项目，完全由 Java 开发，可以用来执行定时任务，类似于 `java.util.Timer`。但是相较于 `Timer`， `Quartz` 增加了很多功能
* 持久性作业 - 即保持调度定时的状态
* 作业管理 - 对调度作业进行有效的管理


### 任务、触发器、调度器

Quartz 中可以划分出 3 个基本部分，如下图所示

* 任务：`JobDetail`，具体的定时任务。
* 触发器：`Trigger`，包括 `SimpleTrigger` 和 `CronTrigger`。触发器负责触发定时任务，其最基本的功能是指定 Job 的执行时间，执行间隔，运行次数等。
* 调度器：`Scheduler`，进行调度，实现如何指定触发器去执行指定的任务。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/programming-2019/quartz-structure-1.png)


下面结合具体的代码，理解任务、触发器、调度器的使用。

1. 添加依赖

添加  `spring-boot-starter-quartz` 依赖。

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-quartz</artifactId>
</dependency>
```

对于 SpringBoot 1.5.9 以下的版本，还需要添加如下依赖。

```xml
<dependency>
  <groupId>org.springframework</groupId>
  <artifactId>spring-context-support</artifactId>
</dependency>
```


2. 创建定时任务类 `JobQuartz`，该类继承 `QuartzJobBean`，并重写 `executeInternal` 方法。


```java
package com.lbs0912.spring.demo.app.quartz;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.QuartzJobBean;

import java.util.Date;

/**
 * @author lbs
 */
public class JobQuartz extends QuartzJobBean {

    /**
     * 执行定时任务
     * @param jobExecutionContext  jobExecutionContext
     * @throws JobExecutionException JobExecutionException
     */
    @Override
    protected void executeInternal(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        System.out.println("quartz task: " +  new Date());
    }
}
```


3. 创建配置类 `QuartzConfig`

```java
package com.lbs0912.spring.demo.app.quartz;


import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.quartz.SimpleScheduleBuilder;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @author lbs
 */
@Configuration
public class QuartzConfig {
    @Bean
    //创建JobDetail实例
    public JobDetail testJobDetail(){
        return JobBuilder.newJob(JobQuartz.class).withIdentity("jobQuartz").storeDurably().build();
    }
    @Bean
    public Trigger testTrigger(){
     
        SimpleScheduleBuilder scheduleBuilder = SimpleScheduleBuilder.simpleSchedule()
                .withIntervalInSeconds(10)  //设置时间周期单位秒
                .repeatForever();
        //构建Trigger实例,每隔10s执行一次
        return TriggerBuilder.newTrigger().forJob(testJobDetail())
                .withIdentity("jobQuartz")
                .withSchedule(scheduleBuilder)
                .build();
    }
}

```


4. 启动项目，查看日志输出。


```s
Server is running ...
quartz task: Wed Jun 24 00:49:07 CST 2020
quartz task: Wed Jun 24 00:49:17 CST 2020
quartz task: Wed Jun 24 00:49:27 CST 2020
```

### 示例
* ref 1-[定时任务框架Quartz-(一)Quartz入门与Demo搭建 | CSDN](https://blog.csdn.net/noaman_wgs/article/details/80984873)


1. 添加依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-quartz</artifactId>
</dependency>
```

2. 创建一个任务 `PrintWordsJob` 类，实现 `Job`接口，重写 `execute` 方法。

```java
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

/**
 * @author liubaoshuai1
 */
public class PrintWordsJob implements Job {
    @Override
    public void execute(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        String printTime = new SimpleDateFormat("yy-MM-dd HH-mm-ss").format(new Date());
        System.out.println("PrintWordsJob start at:" + printTime + ", prints: Hello Job-" + new Random().nextInt(100));
    }
}
```

3. 创建一个调度器 `Schedule`，并在该类中创建触发器 `Trigger` 实例，执行任务。

```java
import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.SimpleScheduleBuilder;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
import org.quartz.impl.StdSchedulerFactory;

@SpringBootApplication
@EnableScheduling
public class SpringbootAppApplication {

    /**
     * main方法
     *
     * @param args
     */
    public static void main(String[] args) throws SchedulerException, InterruptedException {
        System.out.println("Server is running ...");

        // 1、创建调度器Scheduler
        SchedulerFactory schedulerFactory = new StdSchedulerFactory();
        Scheduler scheduler = schedulerFactory.getScheduler();

        // 2、创建JobDetail实例，并与PrintWordsJob类绑定(Job执行内容)
        JobDetail jobDetail = JobBuilder.newJob(PrintWordsJob.class)
                .withIdentity("job1", "group1").build();

        // 3、构建Trigger实例,每隔1s执行一次
        Trigger trigger = TriggerBuilder.newTrigger().withIdentity("trigger1", "triggerGroup1")
                .startNow()//立即生效
                .withSchedule(SimpleScheduleBuilder.simpleSchedule()
						.withIntervalInSeconds(1)//每隔1s执行一次
                        .repeatForever()).build();//一直执行

        //4、执行
        scheduler.scheduleJob(jobDetail, trigger);
        System.out.println("--------scheduler start ! ------------");
        scheduler.start();

        //睡眠
        TimeUnit.MINUTES.sleep(1);
        scheduler.shutdown();
        System.out.println("--------scheduler shutdown ! ------------");

    }
}
```

4. 运行程序，可以看到程序每隔 1s 会打印出内容，且在一分钟后结束。

```s
11:05:27.551 [DefaultQuartzScheduler_Worker-9] DEBUG org.quartz.core.JobRunShell - Calling execute on job group1.job1
PrintWordsJob start at:20-06-24 11-05-27, prints: Hello Job-5

11:05:28.548 [DefaultQuartzScheduler_Worker-10] DEBUG org.quartz.core.JobRunShell - Calling execute on job group1.job1
PrintWordsJob start at:20-06-24 11-05-28, prints: Hello Job-56

11:05:29.548 [DefaultQuartzScheduler_Worker-1] DEBUG org.quartz.core.JobRunShell - Calling execute on job group1.job1
PrintWordsJob start at:20-06-24 11-05-29, prints: Hello Job-82

11:05:29.550 [main] INFO org.quartz.core.QuartzScheduler - Scheduler DefaultQuartzScheduler_$_NON_CLUSTERED shutdown complete.
--------scheduler shutdown ! ------------
```

### Quartz代码分析

结合上述示例代码，对 Quartz 框架中的几个参数进行说明
* Job和JobDetail
* JobExecutionContext
* JobDataMap
* Trigger、SimpleTrigger、CronTrigger

#### Job

`Job` 是 Quartz 中的一个接口，接口下只有 `execute` 方法，在这个方法中编写业务逻辑。

```java
package org.quartz;

public interface Job {
    void execute(org.quartz.JobExecutionContext jobExecutionContext) throws org.quartz.JobExecutionException;
}
```

####  JobDetail

`JobDetail` 用来绑定 Job，为 Job 实例提供许多属性
* name
* group
* jobClass
* jobDataMap

`JobDetail` 绑定指定的 Job，每次 `Scheduler` 调度执行一个 Job 的时候，首先会拿到对应的 Job，然后创建该 Job 实例，再去执行 Job 中的 `execute()` 的内容。任务执行结束后，关联的 Job 对象实例会被释放，且会被 JVM GC 清除。


> 为什么设计成 `JobDetail + Job`，不直接使用 `Job`

`JobDetail` 定义的是任务数据，而真正的执行逻辑是在 Job 中。这是因为任务是有可能并发执行，如果 `Scheduler` 直接使用 Job，就会存在对同一个 Job 实例并发访问的问题。而 `JobDetail + Job` 方式，Sheduler 每次执行，都会根据 `JobDetail` 创建一个新的 Job 实例，这样就可以规避并发访问的问题。

#### JobExecutionContext

`JobExecutionContext` 中包含了 Quartz 运行时的环境以及 Job 本身的详细数据信息。 当 Schedule 调度执行一个 Job 的时候，就会将 `JobExecutionContext` 传递给该 Job 的 `execute()` 中，Job 就可以通过 `JobExecutionContext` 对象获取信息。

`JobExecutionContext` 提供的信息如下

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/programming-2019/quartz-jobexecution-context-1.png)

#### Trigger

`Trigger` 是 Quartz 的触发器，会去通知 Scheduler 何时去执行对应 Job。
* `new Trigger().startAt()` ： 表示触发器首次被触发的时间
* `new Trigger().endAt()` ：表示触发器结束触发的时间


`SimpleTrigger` 可以实现在一个指定时间段内执行一次作业任务或一个时间段内多次执行作业任务。
`CronTrigger` 是基于日历的作业调度，而 `SimpleTrigger` 是精准指定间隔，所以相比 `SimpleTrigger`，`CroTrigger` 更加常用。`CroTrigger` 是基于 `Cron` 表达式的。



## Quartz中使用XML配置定时任务

* ref 1-[spring定时任务quartz使用xml配置文件](https://blog.csdn.net/dhq_blog/article/details/80390810)

参考如上链接，结合「投放@JD」实战项目，介绍如何使用 XML 对定时任务进行配置，步骤如下
1. 在 Spring 的配置文件中引入 `spring-config-quartz.xml` 配置文件
2. 编写 `spring-config-quartz.xml` 配置文件，指定对应的定时任务的 `bean`
3. 编写具体的定时任务 `bean`



此处以 `deliveryCMS-server` (投放@JD) 项目为例进行说明。

### 引入quartz配置文件


在 `deliveryCMS-server` (投放@JD) 项目的 `spring-config.xml`配置文件中，引入 `quzrtz` 的配置文件 `spring-config-quartz.xml`，如下所示。


```xml
<?xml version="1.0" encoding="GBK"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd 
       http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop.xsd 
       http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx.xsd 
       http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">
       


    <!-- active annotation drive bean creation -->
	<context:component-scan base-package="com.jd.deliveryCms"/>
    <context:component-scan base-package="com.jd.deliveryTransition"/>
	<import resource="jsf-provider.xml"/>
	<import resource="spring-config-jdredis.xml"/>
	
	<!--引入quartz配置文件-->
	<import resource="spring-config-quartz.xml"/>  
	
	<import resource="spring-config-jsf.xml"/>
    
    </beans>
    
```



### 编写quartz配置文件并指定定时任务的bean


如下代码所示，在 `spring-config-quartz.xml` 配置文件中，指定对应定时任务的 `bean`，如潘多拉的定时任务 `pandoraSyncScheduler`。
 
```xml
<?xml version="1.0" encoding="GBK"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd"
       default-autowire="byName">

    <!-- 定时启动，定时更新通天塔入口图对应活动的第一个商品组的所有分期信息 -->
    <bean id="babelActivityInfoManager" class="com.jd.deliveryCms.manager.impl.BabelActivityInfoManagerImpl">
    </bean>
    
    <!--潘多拉定时任务-->
    <bean id="pandoraSyncScheduler" class="com.jd.deliveryCms.manager.job.PandoraSyncScheduler"/>
    
    <bean id="babelUpdateActivityInfoDetail" class="org.springframework.scheduling.quartz.MethodInvokingJobDetailFactoryBean">
    	<property name="targetObject" ref="babelActivityInfoManager"/>
        <property name="targetMethod" value="updateBabelActivityInfo"/>
        <property name="concurrent" value="false"/>
    </bean>
    
    <bean id="babelUpdateActivityInfoTrigger" class="org.springframework.scheduling.quartz.CronTriggerFactoryBean">
        <property name="jobDetail" ref="babelUpdateActivityInfoDetail"/>
        <!--每隔2分钟启动-->
        <property name="cronExpression" value="0 */5 * * * ?"/>
    </bean>

    <!-- 热词定时任务 -->
    <bean id="searchWordsScheduler" class="com.jd.deliveryCms.manager.impl.SearchWordsSchedulerImpl">
    </bean>
    
    <bean id="searchWordsSchedulerDetail" class="org.springframework.scheduling.quartz.MethodInvokingJobDetailFactoryBean">
    	<property name="targetObject" ref="searchWordsScheduler"/>
        <property name="targetMethod" value="updateSearchWords"/>
        <property name="concurrent" value="false"/>
    </bean>
    
    <bean id="searchWordsSchedulerTrigger" class="org.springframework.scheduling.quartz.CronTriggerFactoryBean">
        <property name="jobDetail" ref="searchWordsSchedulerDetail"/>
        <!--每隔5分钟启动-->
        <property name="cronExpression" value="0 */2 * * * ?"/>
    </bean>
    
    <!-- 全量每小时启动一次，定时获取配置的活动url下的sku和店铺id-->
    <bean id="activityUrlCheckQuartz" class="com.jd.deliveryCms.manager.job.ActivityUrlCheckQuartz">
    </bean>
    
</beans>
```


### 具体定时任务bean的实现

此处以潘多拉定时任务 `pandoraSyncScheduler` 为例进行说明，定时发送 MQ 消息。


```java
@Slf4j
public class PandoraSyncScheduler {
    private static final String LOCK_KEY = "PandoraSyncJobLock";

    private static final String TOPIC = "respoolsync";

    public void sync() {
        if (RedisDistributeLocker.isLocked(babelImgRedis, LOCK_KEY, 1 * 60 * 1000L)) {
            return;
        }
        CallerInfo callerInfo = Ump.methodReg("delivery.pandora.sync");
        try {
            log.error("PandoraSyncScheduler begin");
            sycPandoraInfo();
        } catch (Exception e) {
            log.error("PandoraSyncScheduler error", e);
        }
        Ump.methodRegEnd(callerInfo);
    }

    private void sycPandoraInfo() {
        //查询10分钟内有更新的规则 并发送 MQ 
        //代码省略
        //sendMqp(mq, action, did, msg_type);
    }
}

```



## Cron表达式

* ref 1-[详解定时任务中的 cron 表达式 | 掘金](https://juejin.im/post/5e1c95e4e51d4558850e99c0)
* ref 2-[Spring Task中cron表达式详解](https://cloud.tencent.com/developer/article/1359706)
* ref 3-[Cron 可视化工具](https://www.pppet.net/)
* ref 4-IDEA-Cron Description 插件

### 表达式定义

`cron` 表达式是一个字符串，该字符串由 6 个空格分为 7 个域，每一个域代表一个时间含义。 通常定义 “年” 的部分可以省略，实际常用的 Cron 表达式由前 6 部分组成。格式如下

```
 [秒] [分] [时] [日] [月] [周] [年]
```

| 域 | 是否必填 | 值以及范围 | 通配符 |
|----|---------|----------|-------|
| 秒  |   是    |  0-59   | , - * / |
| 分  |   是    |  0-59   | , - * / |
| 时  |   是    |  0-23   | , - * / |
| 日  |   是    |  1-31   | , - * ? / L W  |
| 月  |   是    |  1-12 或 JAN-DEC  | , - * / |
| 周  |   是    |  1-7 或 SUN-SAT   | , - * ? / L # |
| 年  |   否    |  1970-2099   | , - * / |


需要说明的是，Cron 表达式中，“周” 是从周日开始计算的。“周” 域上的 `1` 表示的是周日，`7` 表示周六。

###  Cron中的通配符


* `,` ：指的是在两个以上的时间点中都执行。如果在 “分” 这个域中定义为 `8,12,35`，则表示分别在第8分，第12分，第35分执行该定时任务。
* `-` ：指定在某个域的连续范围。如果在 “时” 这个域中定义 `1-6`，则表示在 1 到 6 点之每小时都触发一次，等价于 `1,2,3,4,5,6`。
* `*` ：表示所有值，可解读为 “每”。 如果在 “日” 这个域中设置 `*`，表示每一天都会触发。
* `?` ：表示不指定值。使用的场景为不需要关心当前设置这个字段的值。例如，要在每月的 8 号触发一个操作，但不关心是周几，我们可以这么设置 `0 0 0 8 * ?`。
* `/` ：表示触发步进(step)，`"/"` 前面的值代表初始值( `"*"` 等同 `"0"`)，后面的值代表偏移量，在某个域上周期性触发。比如 在 “秒” 上定义 `5/10` 表示从 第 5 秒开始，每 10 秒执行一次；而在 “分” 上则表示从第 5 分钟开始，每 10 分钟执行一次。
* `L` ：表示英文中的 `LAST` 的意思，只能在 “日” 和 “周” 中使用。在 “日” 中设置，表示当月的最后一天(依据当前月份，如果是二月还会依据是否是润年), 在 “周” 上表示周六，相当于 "7" 或 "SAT"。如果在 "L" 前加上数字，则表示该数据的最后一个。例如在 “周” 上设置 "7L" 这样的格式，则表示 “本月最后一个周六”。
* `W` ：表示离指定日期的最近那个工作日(周一至周五)触发，只能在 “日” 中使用且只能用在具体的数字之后。若在 “日” 上置 "15W"，表示离每月 15 号最近的那个工作日触发。假如 15 号正好是周六，则找最近的周五(14号)触发；如果 15 号是周未，则找最近的下周一(16号)触发；如果 15 号正好在工作日(周一至周五)，则就在该天触发。如果是 "1W" 就只能往本月的下一个最近的工作日推不能跨月往上一个月推。
* `#`： 例如，`A#B` 表示每月的第 `B` 个周的周 `A`（周的计数从周日开始），只能作用于 “周” 上。例如 `2#3` 表示在每月的第 3 个周二，`5#3` 表示本月第 3 周的星期四。


> 注意，`L` 用在 “周” 这个域上，每周最后一天是周六。“周” 域上的 `1` 表示的是周日，`7` 表示周六，即每周计数是从周日开始的。



### 可视化工具
* IDEA-Cron Description 插件
* [Cron 可视化工具](https://www.pppet.net/)
  
在上述可视化工具网站上，点击“反解析到UI”，可以看到定时任务最近5次运行时间，便于理解。

另外，在IDEA中，安装 `Cron Description` 插件也可以进行可视化语义展示，如下图所示，鼠标悬浮到Cron表达式上，即可看到可视化语义。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/programming-2019/idea-cron-description-1.png)


### Corn示例

下面给出一些示例，可根据上面的解释进行解读。

* 每天晚上12点触发任务：`0 0 0 * * ?`
* 每隔 1 分钟执行一次：`0 */1 * * * ?`
* 每月 1 号凌晨 1 点执行一次：`0 0 1 1 * ?`
* 每月最后一天 23 点执行一次：`0 0 23 L * ?`
* 每周周六凌晨 3 点实行一次：`0 0 3 ? * L`
* 在24分，30分执行一次：`0 24,30 * * * ?`



