
# Redis-06-Redis优化项


[TOC]

## 更新
* 2022/05/15，撰写






## 管道
* ref 1-[Redis中的管道Pipeline操作 | 腾讯云](https://cloud.tencent.com/developer/article/1669677)
* ref 2-[Redis如何解决频繁的命令往返造成的性能瓶颈 | 掘金](https://juejin.cn/post/7089081484958679077)
* ref 3-[Redis管道Pipelining原理详解 | 华为云](https://bbs.huaweicloud.com/blogs/273922)


### 请求/响应协议和RTT

Redis 是一种基于客户端-服务端模型及请求/响应协议的 TCP 服务。这意味着一个请求会遵循以下步骤
1. 客户端向服务端发送一个查询请求，并监听 Socket 返回，通常以阻塞模式等待服务端响应
2. 服务端处理命令，并将结果返回给客户端。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-pipelin-1.png)


客户端将数据包发送至服务器，然后服务器再将响应数据发送回客户端，这都需要花费一定时间的。这段时间被称为「往返时间」，即RTT（`Round Trip Time`）。此时，每个命令的执行时间可表示为

```s
每个命令的执行时间 = 客户端发送时间 + 服务器处理和返回时间 + 一个网络往返时间（RTT）
```

### 管道技术

可以看到，当执行较多命令时，每个命令的「往返时间」累加起来，对性能还是有一定影响的。

Redis 的底层通信协议对管道（`Pipelineing`）提供了支持。通过管道可以一次性发送多条命令并在执行完后一次性将结果返回。当一组命令中每条命令都不依赖于之前命令的执行结果时就可以将这组命令一起通过管道发出。

管道通过减少客户端与 Redis 的通信次数，来实现降低往返时延累计值的目的。



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-pipelin-2.png)

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-pipelin-4.png)



**管道（`Pipelineing`）不仅是一种减少往返时间的延迟成本的方法，还大大提高了你在给定的Redis服务器中每秒可执行的总操作量。**

使用管道（`Pipelineing`）时，通常使用单个 `read` 系统调用读取许多命令，并且通过单个 `write` 系统调用传递多个答复。因此，每秒执行的总查询数最初随着较长的管道而几乎呈线性增加，最终可达到不使用流水线获得的基准的 10 倍左右，如下图所示。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-pipelin-3.png)

### 管道压力测试

Redis 自带了一个压力测试工具 `redis-benchmark`，使用这个工具就可以进行管道测试。

1. 首先我们对一个普通的 `set` 指令进行压测，QPS 大约 11W/S。

```s
lbsmacbook-pro:~ lbs$ redis-benchmark -t set  -q
SET: 109289.62 requests per second, p50=0.239 msec 
```

2. 然后我们加入管道选项 `-P` 参数，它表示单个管道内并行的请求数量。可以看到 `P=2` 时，QPS可达 20W/S；`P=5` 时，QPS可达 62W/S。

```s
lbsmacbook-pro:~ lbs$ redis-benchmark -t set -P 2 -q
SET: 208768.27 requests per second, p50=0.247 msec                    

lbsmacbook-pro:~ lbs$ redis-benchmark -t set -P 5 -q
SET: 465116.28 requests per second, p50=0.415 msec      

lbsmacbook-pro:~ lbs$ redis-benchmark -t set -P 10 -q
SET: 625000.00 requests per second, p50=0.663 msec 
```


3. 继续加大 `P` 参数，当 `P=50` 时，QPS 为 67W/S，和 `P=5` 相比，QPS 增幅并不明显。这是因为 Redis 的单线程 CPU 处理能力已经达到了瓶颈。

```s
lbsmacbook-pro:~ lbs$ redis-benchmark -t set -P 50 -q
SET: 675675.69 requests per second, p50=3.207 msec 
```




### 管道不保证原子性
* Redis 执行 LUA 脚本时，会把脚本当成一个命令，故 LUA 脚本可以保证原子性，在执行脚本的时候不会被其他的命令插入。因此，LUA 脚本更适合处理事务。
* 管道虽然也会将多个命令一次性传输到服务端，但在服务端执行的时候仍然是多个命令，所以管道是不具有原子性的，不适合处理事务。
* 就场景上来说，正因为 LUA 脚本会被视为一个命令去执行，因为 Redis 是单线程执行命令的，所以我们不能在 LUA 脚本里写过于复杂的逻辑，否则会造成阻塞，因此 LUA 脚本适合于相对简单的事务场景。


### 管道和脚本

* 大量 Pipelining 应用场景可通过 Redis 脚本（Redis 版本 >= 2.6）得到更高效的处理，后者可在服务器端执行大量工作。
* 脚本的一大优势是可通过最小的延迟读写数据，让读、计算、写等操作变得非常快。Pipeline 在这种情况下不能使用，因为客户端在写命令前需要读命令返回的结果。



### 集群模式下不能使用管道

管道技术，只能作用在一个 Redis 节点上；集群模式下不能使用管道技术。


Redis 集群的键空间被分割为 16384 个槽（`slot`），每个主节点都负责处理 16384 个哈希槽中的一部分。在执行具体的 Redis 命令时，会根据 `key` 计算出一个槽位（`slot`），然后根据槽位去特定的节点 Redis 上执行操作。

```s
# 卡槽示例
master1（slave1）： 0~5460
master2（slave2）：5461~10922
master3（slave3）：10923~16383
```

使用管道技术时，一次会批量执行多个命令，那么每个命令都需要根据 `key` 运算一个槽位，然后根据槽位去特定的节点上执行命令，也就是说一次管道操作会使用多个节点的 Redis 连接，而目前集群是不支持这种多节点操作的。


### 优缺点

优点
1. 打包多个命令，减少往返时间
2. 提高了在 Redis服务器中每秒可执行的总操作量，使用管道时，通常使用单个 `read` 系统调用读取许多命令，并且通过单个 `write` 系统调用传递多个答复。


缺点
1. 管道每批打包的命令不能过多，因为使用管道时，Redis 必须在处理完所有命令前，先缓存起所有命令的处理结果，这样就有一个内存的消耗。
2. 管道不保证原子性，执行命令过程中，如果一个命令出现异常也会继续执行其他命令。因此，不适用对可靠性和实时性要求较高的场景。
3. **管道每次只能作用在一个 Redis 节点上，集群模式下不能使用管道技术**






### 适用场景

有些系统可能对可靠性要求很高，每次操作都需要立马知道这次操作是否成功，是否数据已经写进 Redis 了，那这种场景就不适合使用管道技术。



### 深入理解管道本质

* ref 1-[管道 | Redis深度历险](https://juejin.cn/book/684473324618129422/section/6844733724714598414)

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/redis-pipelin-5.png)