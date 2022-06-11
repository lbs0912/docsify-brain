# JVM-06-JVM问题排查

[TOC]

## 更新
* 2022/05/25，撰写



## 参考资料
* [小白JVM学习指南 | 陈树义Blog](https://www.cnblogs.com/chanshuyi/p/the_jvm_roadmap.html)
* [JVM核心技术32讲 | learn.lianglianglee.com](https://learn.lianglianglee.com/)




## 前言

遇到 GC 问题，不要直接想着修改堆栈配置参数，要结合具体问题具体分析
1. 先观察 GC 之后，内存是否得到有效回收
2. 若 GC 后，内存没有得到有效回收，则可能是产生了内存泄露
3. 若 GC 后，内存得到有效回收，可去检查堆栈配置参数

## 排查问题常用Shell命令


```s
# 查看当前路径
pwd

# 查看当前目录下有哪些文件
ls -l

# 查看系统负载
top

# 查看剩余内存
free -h

# 查看剩余磁盘
df -h

# 查看当前目录的使用量
du -sh *
```




## 排查CPU使用率飙升问题

若遇到 CPU 使用率飙升问题，如何排查？

### 排查思路
1. 收集不同的指标（CPU、内存、磁盘 IO、网络等）
2. 分析应用日志
3. 分析 GC 日志
4. 获取线程转储（Thread Dump）并分析，使用 `jstack` 命令来获取 Thread Dump
5. 获取堆转储（Heap Dump）来进行分析，使用 `jmap` 命令来获取堆内存快照

```s
# 获取 Thread Dump
jstack -l PID >> threadDump.log

# 获取 Heap Dump
jmap -dump:format=b,file=3826.hprof 3826
```


### 如何衡量系统性能

将「系统性能」量化为具体的性能指标
1. 系统容量
   * 如硬件配置，设计容量
2. 吞吐量
   * 最直观的指标是 TPS；
3. 响应时间（系统延迟）
   * 包括服务端延时和网络延迟




## JVM调优

> GC 和内存是最常见的 JVM 调优场景。


截止目前（2020 年 3 月），JVM 可配置参数已经达到 1000 多个，其中 GC 和内存配置相关的 JVM 参数就有 600 多个。从这个参数比例也可以看出，**JVM 问题排查和性能调优的重点领域还是 GC 和内存。**




### 常用的JVM参数配置

参数太多是个大麻烦，让人难以下手。但在绝大部分业务场景下，常用的 JVM 配置参数也就 10 来个，如下所示。


```s
# 设置堆内存
-Xmx4g -Xms4g 

# 指定 GC 算法
-XX:+UseG1GC -XX:MaxGCPauseMillis=50 

# 指定 GC 并行线程数
-XX:ParallelGCThreads=4 

# 打印 GC 日志
-XX:+PrintGCDetails -XX:+PrintGCDateStamps 

# 指定 GC 日志文件
-Xloggc:gc.log 

# 指定 Meta 区的最大值
-XX:MaxMetaspaceSize=2g 

# 设置单个线程栈的大小
-Xss1m 

# 指定堆内存溢出时自动进行 Dump
-XX:+HeapDumpOnOutOfMemoryError 
-XX:HeapDumpPath=/usr/local/
```


### 常用的属性配置

此外，还有一些常用的属性配置，如下所示。

```s
# 指定默认的连接超时时间
-Dsun.net.client.defaultConnectTimeout=2000
-Dsun.net.client.defaultReadTimeout=2000

# 指定时区
-Duser.timezone=GMT+08 

# 设置默认的文件编码为 UTF-8
-Dfile.encoding=UTF-8 

# 指定随机数熵源（Entropy Source）
-Djava.security.egd=file:/dev/./urandom 
```


## 分析指标

* ref 1-[GC问题分析常用两大指标 | InfoQ](https://xie.infoq.cn/article/5b50ac33b492aed286d77ff4e)

在分析 GC 问题时，最常用的两个指标就是
1. 分配速率（`Allocation Rate`）
2. 提升速率（`Promotion Rate`）


### 分配速率

分配速率（`Allocation Rate`）表示单位时间内分配的内存量。通常使用 `MB/sec` 作为单位，也可以使用 `PB/year` 等。

**分配速率过高就会严重影响程序的性能，在 JVM 中可能会导致巨大的 GC 开销。**


#### 如何测量分配速率

指定 JVM 参数 `-XX:+PrintGCDetails -XX:+PrintGCTimeStamps`，通过 GC 日志来计算分配速率。GC 日志如下所示。

```s
0.291: [GC (Allocation Failure)
            [PSYoungGen: 33280K->5088K(38400K)]
            33280K->24360K(125952K), 0.0365286 secs]
        [Times: user=0.11 sys=0.02, real=0.04 secs]
    0.446: [GC (Allocation Failure)
            [PSYoungGen: 38368K->5120K(71680K)]
            57640K->46240K(159232K), 0.0456796 secs]
        [Times: user=0.15 sys=0.02, real=0.04 secs]
    0.829: [GC (Allocation Failure)
            [PSYoungGen: 71680K->5120K(71680K)]
            112800K->81912K(159232K), 0.0861795 secs]
        [Times: user=0.23 sys=0.03, real=0.09 secs]
```

具体就是计算上一次垃圾收集之后，与下一次 GC 开始之前的年轻代使用量，两者的差值除以时间，就是分配速率。通过上面的日志，可以计算出以下信息。
* JVM 启动之后 291ms，共创建了 33280KB 的对象。第一次 Minor GC（小型 GC）完成后，年轻代中还有 5088KB 的对象存活。
* 在启动之后 446ms，年轻代的使用量增加到 38368KB，触发第二次 GC，完成后年轻代的使用量减少到 5120KB。
* 在启动之后 829ms，年轻代的使用量为 71680KB，GC 后变为 5120KB。

可以通过年轻代的使用量来计算分配速率，如下表所示。


|  Event |  Time |  Young before |  Young after	|  Allocated during	 | Allocation rate | 
|------|------|------|------|-------|---------|
| 1st GC | 291ms | 33,280KB |5,088KB | 33,280KB |114MB/sec |
| 2nd GC |446ms | 	38,368KB |5,120KB | 33,280KB | 215MB/sec |
| 3rd GC | 829ms | 	71,680KB |5,120KB | 66,560KB | 174MB/sec |
| Total | 829ms | N/A |	N/A |133,120KB |161MB/sec |  


通过这些信息可以知道，在此期间，该程序的内存分配速率为 16MB/sec。


#### 分配速率的意义

**分配速率的变化，会增加或降低 GC 暂停的频率，从而影响吞吐量。但只有年轻代的 Minor GC 受分配速率的影响，老年代 GC 的频率和持续时间一般不受分配速率（Allocation Rate）的直接影响，而是受到提升速率（Promotion Rate）的影响。**




**当 JVM 中当分配速率过高，就会严重影响程序的性能，可能会导致巨大的 GC 开销。**
* 如果 Eden 区过小，分配速率高，就会出现大量的 GC；
* 增大年轻代（即增大 Eden 区），虽然不能降低分配速率，但能够减少 Minor GC 的次数


需要注意的是，分配速率可能会，也可能不会影响程序的实际吞吐量。

总而言之，吞吐量和分配速率有一定关系，因为分配速率会影响 Minor GC 暂停，但对于总体吞吐量的影响，还要考虑 Major GC 暂停等。



#### 分配速率的三种情况
* 正常系统：分配速率较低，回收速率健康
* 内存泄露：分配速率持续大于回收速率，最后会导致 OOM
* 性能劣化：分配速率较高，回收速率能够维持，系统处于亚健康状态


#### 如何解决高分配速率
1. 调高「年轻代」的大小，降低 Minor GC 的次数
2. 优化代码，降低分配速率


### 提升速率

提升速率（`Promotion Rate`）用于衡量单位时间内从年轻代提升到老年代的数据量。一般使用 `MB/sec` 作为单位。




#### 如何测量提升速率

指定 JVM 参数 `-XX:+PrintGCDetails -XX:+PrintGCTimeStamps`，通过 GC 日志来测量提升速率。JVM 记录的 GC 暂停信息如下所示。


```s
0.291: [GC (Allocation Failure)
            [PSYoungGen: 33280K->5088K(38400K)]
            33280K->24360K(125952K), 0.0365286 secs]
        [Times: user=0.11 sys=0.02, real=0.04 secs]
    0.446: [GC (Allocation Failure)
            [PSYoungGen: 38368K->5120K(71680K)]
            57640K->46240K(159232K), 0.0456796 secs]
        [Times: user=0.15 sys=0.02, real=0.04 secs]
    0.829: [GC (Allocation Failure)
            [PSYoungGen: 71680K->5120K(71680K)]
            112800K->81912K(159232K), 0.0861795 secs]
        [Times: user=0.23 sys=0.03, real=0.09 secs]
```

从上面的日志可以得知：GC 之前和之后的年轻代使用量以及堆内存使用量。这样就可以通过差值算出老年代的使用量。GC 日志中的信息可表述为


| Event	| Time | Young decreased | Total decreased |Promoted	|  Promotion rate |
|-----|-----|--------|-------|-------|-------| 
| 事件 | 耗时 | 年轻代减少 | 整个堆内存减少 | 提升量 | 提升速率  | 
| 1st GC | 291ms | 28192K | 8920K | 19272K | 66.2 MB/sec | 
| 2nd GC | 446ms | 33248K | 11400K | 21848K| 140.95 MB/sec | 
| 3rd GC | 829ms | 66560K | 30888K	| 35672K| 93.14 MB/sec | 
| Total	| 829ms	| N/A | N/A | 76792K	| 92.63 MB/sec| 


根据这些信息，就可以计算出观测周期内的提升速率，平均提升速率为 92MB/秒，峰值为 140.95MB/秒。

请注意，只能根据 Minor GC 计算提升速率。Full GC 的日志不能用于计算提升速率，因为 Major GC 会清理掉老年代中的一部分对象。


#### 提升速率的意义

**和分配速率一样，提升速率也会影响 GC 暂停的频率。但分配速率主要影响 Minor GC，而提升速率则影响 Major GC 的频率。有大量的对象提升，自然很快将老年代填满，老年代填充的越快，则 Major GC 事件的频率就会越高。**


#### 过早提升

JVM 会将长时间存活的对象从年轻代提升到老年代。根据分代假设，可能存在一种情况，老年代中不仅有存活时间长的对象，也可能有存活时间短的对象。这就是过早提升（Premature Promotion），即对象存活时间还不够长的时候就被提升到了老年代。


Major GC 不是为频繁回收而设计的，但 Major GC 现在也要清理这些生命短暂的对象，就会导致 GC 暂停时间过长。这会严重影响系统的吞吐量。


#### 过早提升的影响

「过早提升」会造成如下影响
* 短时间内频繁地执行 Full GC
* 每次 Full GC 后老年代的使用率都很低，在 10~20% 或以下
* 提升速率接近于分配速率


#### 如何解决过早提升

要解决过早提升，就需要让年轻代存放得下暂存的数据，有两种简单的方法
1. 增加年轻代的大小
2. 减少每次批处理的数量

在某些情况下，业务逻辑不允许减少批处理的数量，那就只能增加堆内存，或者重新指定年轻代的大小。

如果都不可行，就只能优化数据结构，减少内存消耗。但总体目标依然是一致的，就是让临时数据能够在年轻代存放得下。



## GC问题排查

### 排查思路

* 指标监控
* 指定 JVM 启动内存
* 指定垃圾收集器
* 打印和分析 GC 日志



### GC问题实战案例

#### 案例-K8S和CPU核心数

* ref 1-[GC 问题排查实战案例 | JVM核心技术32讲 | learn.lianglianglee.com](https://learn.lianglianglee.com/%E4%B8%93%E6%A0%8F/JVM%20%E6%A0%B8%E5%BF%83%E6%8A%80%E6%9C%AF%2032%20%E8%AE%B2%EF%BC%88%E5%AE%8C%EF%BC%89/28%20JVM%20%E9%97%AE%E9%A2%98%E6%8E%92%E6%9F%A5%E5%88%86%E6%9E%90%E4%B8%8B%E7%AF%87%EF%BC%88%E6%A1%88%E4%BE%8B%E5%AE%9E%E6%88%98%EF%BC%89.md)

GC 问题实战案例，详情见上述参考链接 *ref-1*，此处仅做大纲记录，记录该案例的排查步骤。

* 通过监控指标发现，有一个服务节点的最大 GC 暂停时间经常会达到 400ms 以上。
* 使用 `jcmd` 或 `jinfo` 命令查看 JVM 启动参数，结果如下。案例中使用的是 JDK 8，启动参数中没有指定 GC，则默认使用 ParallelGC 垃圾收集器。

```s
-Xmx4g -Xms4g
```
* 怀疑问题出在「使用了 ParallelGC 垃圾收集器」。ParallelGC 垃圾收集器为了最大的系统处理能力，即吞吐量，而牺牲掉了单次的暂停时间，导致暂停时间会比较长。
* 继续，执行如下命令重启 JVM，指定使用 G1 垃圾回收器。

```s
-Xmx4g -Xms4g -XX:+UseG1GC -XX:MaxGCPauseMillis=50
```

* 重启 JVM 后，继续观察监控指标，发现每个节点的 GC 暂停时间都降下来了，基本上在 50ms 以内，比较符合我们的预期。
* 运行一段时间后，产生了一次 GC，最大 GC 暂停时间达到了 1300ms。
* 继续，尝试其他手段定位和分析该问题    
  1. 通过 JMX 注册 GC 事件监听，把相关的信息直接打印出来
  2. 通过 `-Xloggc:gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps` 打印 GC 日志
* 查看 GC 日志，查看到 GC 的线程数为 48 个，如下所示。

```s
[GC pause (G1 Evacuation Pause) (young), 1.8683418 secs]
[Parallel Time: 1861.0 ms, GC Workers: 48]
```
* 该服务通过 K8S 部署到服务器上，服务器 CPU 共 72 核。
* 通过和运维同学的沟通，知道产生 GC 的节点的配置为 4 核 8 GB。
* 至此，推测 GC 产生原因是「K8S 的资源隔离和 JVM 未协调好」
  1. JVM 看见了 72 个 CPU 内核，默认的并行 GC 线程设置为 `72 * 5/8 ~= 48` 个
  2. K8S 限制了这个节点只能使用 4 个 CPU 内核的计算量
  3. 这会导致 GC 发生时，48 个线程在 4 个 CPU 核心上发生资源竞争，导致大量的上下文切换
* 解决办法为限制 GC 的并行线程数量，设置如下 JVM 参数

```s
-XX:ParallelGCThreads=4
```
* 修改后，再次重启 JVM，观察监控指标，发现系统恢复正常。
  

> GC 线程数设置参考准则
> 1. 若 CPU 核数 `N` 小于等于 8，推荐设置 GC 线程数 `ParallelGCThreads` 等于 CPU 核数 `N` 。
> 2. 若 CPU 核数 `N` 大于 8，推荐设置 GC 线程数 `ParallelGCThreads` 为于 CPU 核数 `N` 的 `5/8`。


#### 案例-分配速率过大导致GC
* ref 1-[记一次公司JVM堆溢出抽丝剥茧定位的过程](https://www.cnblogs.com/bryan31/p/13343926.html)


详情见上述参考链接 *ref-1*，此处仅做大纲记录，记录该案例的排查步骤。

1. 线上产生频繁的 FullGC，一分钟最高能进行 10 次 FullGC，Minor GC 每分钟竟然接近 60 次，相当于每秒钟都有 Minor GC。
2. 先使用 `top -H -p pid` 查看占用 CPU 较多的线程，获取到线程 ID 后，使用 `jstack` 查看线程的堆栈信息。
3. 根据问题现状，将问题表述为「年轻代大量的 Minor GC 后，老年代在几分钟之内被快速的填满，导致了 FullGC」。
4. 下面开始排查「为什么老年代会被快速填满」，排查老年代参数设置后发现老年代空间设置合理，并无不妥之处。
5. 此时，将排查问题转向「为什么大量的对象从年轻代提升到老年代」，即「分配速率过大」的问题。
6. 使用 `jmap -histo` 查看堆栈信息，发现产生了 9000W 个 `String` 类型对象，占用堆超过 2G。
7. 查看代码发现，发现在向 ArrayList 插入 String 字符串时，某些情况下会产生死循环，导致不断的向数组中插入 String 字符串。
8. 至此，问题排查结束。死循环中不断插入 String 字符串，导致年轻代迅速被占满，并晋升到老年代，老年代被填满后导致 FullGC。


## Arthas
* [Arthas](https://arthas.aliyun.com/doc/)
* [Java动态追踪技术探究 | 美团技术](https://tech.meituan.com/2019/02/28/java-dynamic-trace.html)

Arthas 是 Alibaba 开源的 Java 诊断工具，支持 JDK 6+，支持 Linux/Mac/Windows，采用命令行交互模式，同时提供丰富的 Tab 自动补全功能，进一步方便进行问题的定位和诊断。


## HPROF

* [HPROF | A Heap/CPU Profiling Tool](https://github.com/cncounter/translation/blob/master/tiemao_2017/20_hprof/20_hprof.md)

JDK 始终提供一款名为 `HPROF` 的简单命令行分析工具，用于堆内存和 CPU 分析。 HPROF 实际上是 JVM 中的一个本地 agent，通过命令行参数可以在 JVM 启动时动态加载，并成为 JVM 进程的一部分。


通过在启动时指定不同的 HPROF 选项，可以让 HPROF 执行各种类型的堆/CPU 分析功能。HPROF 生成的二进制文件可以用 `jhat` 等工具来查看堆内存中的对象。

HPROF 能够提供的数据包括
1. CPU 使用率
2. 堆内存分配情况统计
3. 管程（`Monitor`）的争用情况分析
4. 执行完整的堆转储

调用 HPROF 的方法如下。

```s
java -agentlib:hprof[=options] xxxClass
#或
java -Xrunhprof[:options] xxxClass
```
