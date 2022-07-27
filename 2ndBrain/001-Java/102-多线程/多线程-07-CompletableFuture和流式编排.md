# 多线程-07-CompletableFuture和流式编排



[TOC]


## 更新
* 2022/06/01，撰写



## 参考资料

* [Java8 CompletableFuture 使用详解](https://dayarch.top/p/java8-completablefuture-tutorial.html)
* [CompletableFuture的使用](https://mp.weixin.qq.com/s?__biz=MzUyOTg1OTkyMA==&mid=2247485100&idx=1&sn=3c00ec90b2accb812cf5de5e2eeabd96&scene=21#wechat_redirect)
* [CompletableFuture 的使用 | 掘金](https://juejin.cn/post/7100402930083168292?share_token=116be5a7-c1fe-4ba1-8d08-b84731aee69c)





## Executors

为了能更好的控制多线程，JDK 提供了一套 `Executor` 框架，其本质就是一个线程池，它的核心成员如下。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-executer-1.png)



|  接口或类   |         说明         |
|------------|----------------------|
| `Executor` 接口 | 定义了一个接收 `Runnable` 对象的方法 `executor` |
|`ExecutorService` 接口 | 一个比 `Executor` 使用更广泛的子类接口，其提供了生命周期管理的方法，以及可跟踪一个或多个异步任务执行状况返回 `Future` 的方法 |
| `AbstractExecutorService` 抽象类 | `ExecutorService` 执行方法的默认实现 |
| `ScheduledExecutorService` 接口 | 一个可定时调度任务的接口 |
| `ScheduledThreadPoolExecutor`类 | `ScheduledExecutorService` 的实现，一个可定时调度任务的线程池 |
| `ThreadPoolExecutor` 类| 多用于创建线程池 |






## ExecutorService

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-executor-service-class-1.png)




```java
void execute(Runnable command);

<T> Future<T> submit(Callable<T> task);
<T> Future<T> submit(Runnable task, T result);
Future<?> submit(Runnable task);
```

可以看到，使用 `ExecutorService` 的 `execute()` 方法，无返回值；而 `submit()` 方法清一色的返回 `Future` 类型的返回值。


## Future

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-future-class-2.png)



`Future` 常用的方法如下。

```JAVA
// 取消任务
boolean cancel(boolean mayInterruptIfRunning);

// 获取任务执行结果
V get() throws InterruptedException, ExecutionException;

// 获取任务执行结果，带有超时时间限制
V get(long timeout, TimeUnit unit) throws InterruptedException, ExecutionException,  TimeoutException;

// 判断任务是否已经取消
boolean isCancelled();

// 判断任务是否已经结束
boolean isDone();
```

## FutureTask
* ref 1-[Java Future详解与使用 | blog](https://dayarch.top/p/java-future-and-callable.html)



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-future-notes-1.png)




**`FutureTask` 是 `Future` 的实现类。**


```java
/*
 * @since 1.5
 * @author Doug Lea
 * @param <V> The result type returned by this FutureTask's {@code get} methods
 */
public class FutureTask<V> implements RunnableFuture<V> {
    ...
}
```

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-futuretask-class-1.png)


```java
public interface RunnableFuture<V> extends Runnable, Future<V> {
    void run();
}
```

`FutureTask` 实现了 `RunnableFuture` 接口，而 `RunnableFuture` 接口又分别实现了 `Runnable` 和 `Future` 接口，所以可以推断出 `FutureTask` 具有这两种接口的特性
1. 有 `Runnable` 特性，所以可以用在 `ExecutorService` 中配合线程池使用
2. 有 `Future` 特性，所以可以从中获取到执行结果




## CompletableFuture


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-completable-future-1.png)



`CompletableFuture` 是 Java 8 新增的一个类，用于异步编程，继承了 `Future` 和 `CompletionStage`。
* `Future` 主要具备对请求结果独立处理的功能
* **`CompletionStage` 用于实现「流式处理」，实现异步请求的各个阶段组合或链式处理。**
  

**因此，`CompletableFuture` 能实现整个异步调用接口的扁平化和流式处理，解决原有 `Future` 处理一系列链式异步请求时的复杂编码。**


### Future的局限性
1. `Future` 的结果在非阻塞的情况下，不能执行更进一步的操作。`.get()` 方法获取结果时会造成阻塞
2. 不能组合多个 `Future` 的结果
3. 多个 `Future` 不能组成链式调用
4. 没有异常处理


### CompletableFuture相关API

使用 Future 获得异步执行结果时，要么调用阻塞方法 `get()`，要么轮询看 `isDone()` 是否为 true，这两种方法都不是很好，因为主线程也会被迫等待。

从 Java 8 开始引入了 CompletableFuture，它针对 Future 做了改进，可以传入回调对象，当异步任务完成或者发生异常时，自动调用回调对象的回调方法。
* 异步任务结束时，会自动回调某个对象的方法；
* 异步任务出错时，会自动回调某个对象的方法；
* 主线程设置好回调后，不再关心异步任务的执行。


#### 创建任务
* `runAsync` 用于创建不带返回值的异步任务
* `supplyAsync` 用于创建带返回值的异步任务 `CompletableFuture`



#### 异步回调
* `thenApply/thenAccept/thenRun`
* `thenApplyAsync/thenAcceptAsync/thenRunAsync`
* `exceptionally`
* `handle/whenComplete`


> CompletableFuture 的命名规则
> 
> 1. `xxx()`：表示该方法将继续在已有的线程中执行；
> 2. `xxxAsync()`：表示将异步在线程池中执行。


|     方法       |         说明           | 
|---------------|------------------------|
| `thenRun` | 任务 A 执行完毕后再执行任务 B，B 拿不到 A 的执行结果 |
| `thenAccept` | 任务 A 执行完毕后再执行任务 B，B 可以拿到 A 的执行结果，但无返回值，无法拿到 B 的执行结果 |
| `thenApply` | 任务 A 执行完毕后再执行任务 B，B 可以拿到 A 的执行结果，并且最终可获取 B 的执行结果 |
| `whenComplete` | 可设置回调函数，当异步任务执行完毕后进行回调，不会阻塞调用线程 |





#### 组合处理
* `thenCombine/thenAcceptBoth/runAfterBoth`
* `applyToEither/acceptEither/runAfterEither`
* `thenCompose`
* `allOf/anyOf`

|     方法       |         说明           | 
|---------------|------------------------|
| `thenCompose()` | 可用于组合两个或多个 `CompletableFuture` 对象，并将前一个任务的返回结果作为下一个任务的参数，它们之间存在着先后顺序 |
| `thenCombine()` | 会在两个任务都执行完成后，把两个任务的结果合并。两个任务是并行执行的，它们之间并没有先后依赖顺序 |
| `allOf` | 等待多个并发运行的 `CompletableFuture` 任务全部执行完毕 |
| `anyOf` | 多个并发运行的 `CompletableFuture` 任务中有一个执行完毕就返回 |












## Sirector | 京东异步并发开发框架


`Sirector` 是京东的异步并发开发框架（暂未开源），其全称为 `Service Director`，意为服务导演。`Sirector` 的目标是简化具有复杂依赖关系的任务编排，提高整体任务的执行并发度。
* 异步事件类型的设计
* **流式编排，进行整个事务依赖关系分析，找出可以并行的阶段，分别使用事件处理器进行抽象，然后将事件处理器进行编排**


### 使用

* Maven 依赖

```xml
<dependency>
    <groupId>com.jd.sirector</groupId>
    <artifactId>sirector-core</artifactId>
    <version>0.2.2-beta</version>
</dependency>
```



`Sirector` 中的主要方法如下图所示。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/jd-sirector-structure-1.png)



`Sirector` 描述了事件处理器的先后依赖关系。一个 `Sirector` 对应一种事务类型，事务类型描述了事件处理器的先后依赖关系。简单来说，`Sirector` 使用包括下面的 3 个步骤
1. 准备事件处理器实例(handler实现类)
2. 编排事件处理器，构建事件调度器
3. 发布事件(同步和异步两种方式)

```java
sirector.begin(luckyEventHandler);
sirector.ready();
sirector.publish(event,GenericChannelUtils.getVisTimeout());
```


`Sirector` 发布事件有同步和异步两种方式
1. 同步方法会在整个事务完成后，直接返回结果

```java
//编排已经完成，现在可以使用sirector了
//构建一个事件，事件的类型我们可以根据业务需要来定义
Event event = new Event(...);
try{
  Event result = sirector.publish(event);
} catch(SirectorException e) {
   //处理异常
}
```



2. 异步方法则会在事务完成或者抛出异常时进行回调。

```java

//编排已经完成，现在可以使用sirector了
//构建一个事件，事件的类型我们可以根据业务需要来定义
Event event = new Event(...);
SimpleCallback callback = new SimpleCallback();
sirector.publish(event, callback);
class SimpleCallback implement Callback<Event>{
     public void onSuccess(Event event){
          //整个事件处理已经完成，event为结果
     }
     public void onError(Event event, Throwable throwable){
         //处理异常
     }
}
```



### 流式编排


**`Sirector` 可对整个事务依赖关系进行分析，找出可以并行的阶段，分别使用事件处理器进行抽象，然后将事件处理器进行「流式编排」**。


下面给出一个编排示例。

`eh1`,`eh2`,`eh3` 分别表示 3 种不同的事件处理器 `EventHandler`。

1. `eh1`,`eh2`,`eh3` 没有任何依赖关系

```java
sirector.begin(eh1,eh2,eh3);
sirector.ready()
```

2. `Pipeline` 类型依赖关系

```java
sirector.begin(eh1).then(eh2).then(eh3);
sirector.ready()
```

3. `eh3` 依赖 `eh1` 和 `eh2`

```java
sirector.begin(eh1,eh2).then(eh3);
sirector.ready()
```

4. 实现如下依赖关系的处理

```s
            +-----+       +-----+
   +------> | EH2 |-----> | EH3 |-------+
   |        +-----+       +-----+       |
   |                                    v
+-----+                               +-----+
| EH1 |                               | EH6 |
+-----+                               +-----+
   |                                    ^
   |        +-----+       +-----+       |
   +------> | EH4 |-----> | EH5 |-------+
            +-----+       +-----+

```

Sirector 相应的事务编排代码如下。

```java
sirector.begin(eh1).then(eh2, eh4);
sirector.after(eh2).then(eh3);
sirector.after(eh4).then(eh5);
sirector.after(eh3, eh5).then(eh6);
sirector.ready();
```



### asyncTool | 基于Sirector的开源框架

* [手写中间件之并发框架@JD | CSDN](https://blog.csdn.net/tianyaleixiaowu/category_9637010.html?spm=1001.2101.3001.4235)
* [asyncTool@JD | gitee](https://gitee.com/jd-platform-opensource/asyncTool)



`asyncTool` 是一款基于 `Sirector` 的开源的异步并发开发框架，可以解决任意的多线程并行、串行、阻塞、依赖、回调，可以任意组合各线程的执行顺序，带全链路回调和超时控制。






