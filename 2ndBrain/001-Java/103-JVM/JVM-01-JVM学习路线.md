
# JVM-01-JVM学习路线

[TOC]



## 更新
* 2021/12/26，撰写




## 学习路线


### 书籍
* 《深入理解Java虚拟机》JVM高级特性与最佳实践 | 周志明
* 《实战Java虚拟机》JVM故障诊断与性能优化（第2版）
* 《Java虚拟机规范》Java SE 8版

### 参考资料
* [小白JVM学习指南 | 陈树义Blog](https://www.cnblogs.com/chanshuyi/p/the_jvm_roadmap.html)
* [JVM核心技术32讲 | learn.lianglianglee.com](https://learn.lianglianglee.com/)




## 前言


### JDK、JRE、JVM
* JDK（Java Development Kit）是用于开发 Java 应用程序的软件开发工具集合，包括了 Java 运行时的环境（JRE）、解释器（Java）、编译器（javac）、Java 归档（jar）、文档生成器（Javadoc）等工具。
* JRE（Java Runtime Enviroment ）提供 Java 应用程序执行时所需的环境，由 Java 虚拟机（JVM）、核心类、支持文件等组成。
* JVM（Java Virtual Machine）即 Java 虚拟机。



因此，就范围来说
1. JDK = JRE + 开发工具
2. JRE = JVM + 类库


### JDK厂商

常见的 JDK 厂商包括
1. Oracle 公司的 Hotspot 虚拟机、GraalVM，分为 OpenJDK 和 OracleJDK 两种版本
2. IBM 公司的 J9 虚拟机，用在 IBM 的产品套件中
3. Azul Systems 公司提供的高性能的 Zing 和开源的 Zulu
4. 阿里巴巴公司提供的 `Dragonwell`，它是阿里开发的 OpenJDK 定制版
5. 亚马逊公司的 Corretto OpenJDK
6. Red Hat 公司的 OpenJDK


> OpenJDK 和 OracleJDK 的区别
* Oracle JDK 是基于 OpenJDK 源代码构建的，两者并没有重大的技术差异。区别主要体现在版权协议上
  1. OpenJDK 是开源协议，拥有自由的再分发权
  2. OracleJDK 是商业协议，用户不具备再分发权，这也就意味着用户不能把 OracleJDK 打包在用户的应用软件中一起发布
* Oracle JDK 更多地关注稳定性，它重视更多的企业级用户；而 OpenJDK 经常发布以支持其他性能，这可能会导致不稳定。
* Oracle JDK 具有良好的 GC 选项和更好的渲染器，而 OpenJDK 具有较少的 GC 选项。

### Java语言执行流程

![java-code-process-1](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-code-process-1.png)

* 目前常用的虚拟机（JVM）是 Sun HotSpot VM。HotSpot 中，包含了 Java 解释器和 JIT 编译器。
* JIT 编译（`Just-in-time Compilation`），即 “即时编译”，是动态编译的一种特例。JIT 可以提高 Java 程序的运行效率。若没有 JIT 编译，字节码需要经过解释器解释再运行。使用 JIT 编译后，可以将字节码编译成平台相关的原生机器码，进行相关优化后将其缓存下来，以备下次使用。如果 JIT 对每条字节码都进行编译、缓存，会增加开销，因此 JIT 只对「热点代码」（比如高频度使用的方法）进行即时编译。



## 编译器

* ref 1-[从源代码到机器码，发生了什么 | 陈树义Blog](https://www.cnblogs.com/chanshuyi/p/the_jvm_roadmap.html)

编译器可划分为如下几种
1. 前端编译器
2. JIT 编译器
3. AOT 编译器

|   编译器   |  处理的对象    |           实例        |
|-----------|--------------|-----------------------|
| 前端编译器  | 源代码到字节码 | Sun 的 javac，Eclipse JDT 的增量式编译器（ECJ）|
| JIT 编译器 | 字节码到机器码 | HotSpot VM 的 C1、C2 编译器 |
| AOT 编译器 | 源代码到机器码 | GNU Compiler for the Java（GCJ），Excelsior JET |


### 前端编译器

前端编译器负责将源代码编译为字节码。如 Sun 的 `javac`，因为发生在整个编译的前期，所以被称为前端编译器。


`javac` 编译器的处理过程，可以分为下面 4 个阶段
1. 词法、语法分析
2. 填充符号表
3. 注解处理
4. 分析与字节码生成


### JIT 编译器

JIT 编译器（`Just-in-time Compilation`）即 “即时编译”，是动态编译的一种特例，负责将字节码编译为机器码。


Sun HotSpot 虚拟机内置了两个即时编译器，分别称为 `Client Compiler` 和 `Server Compiler`。这两种不同的编译器衍生出两种不同的编译模式，我们分别称之为 `C1` 编译模式、`C2` 编译模式。C1 的优化相对保守，但编译速度比 C2 稍快。C2 编译模式会做一些激进的优化，并且会根据性能监控做针对性优化，所以其编译质量相对较好，但是耗时更长。
1. `Client Compiler`（C1 编译模式）：将字节码编译为本地代码，进行简单、可靠的优化，如有必要将加入性能监控的逻辑。
2. `Server Compiler`（C2 编译模式）：将字节码编译为本地代码，但是会启用一些编译耗时较长的优化，甚至会根据性能监控信息进行一些不可靠的激进优化。


#### HotSpot的运行模式和C1、C2

HotSpot 中，包含了 Java 解释器和 JIT 编译器。对于 HotSpot，有 3 种工作模式可选
1. 混合模式（Mixed Mode）
   * HotSpot VM 默认采用混合模式，既使用解释器也使用 JIT 编译器
   * 混合模式下，默认会同时采用 C1 编译模式和 C2 编译模式
   * 若要单独使用 C1 模式或 C2 模式，可使用 `-client` 或 `-server` 参数指定
2. 解释模式（Interpreted Mode）
   * 所有代码都解释执行
   * 使用 `-Xint` 参数可指定使用该模式
3. 编译模式（Compiled Mode）
   * 优先采用编译模式，无法编译时也会解释执行（如反射，动态类加载等）
   * 使用 `-Xcomp` 参数可指定使用该模式



执行 `java -version` 命令，在输出信息中可以看到当前的工作模式，默认为 `mixed mode`。

```s
lbsMacBook-Pro:~ lbs$ java -version
java version "1.8.0_333"
Java(TM) SE Runtime Environment (build 1.8.0_333-b02)
Java HotSpot(TM) 64-Bit Server VM (build 25.333-b02, mixed mode)
```


#### 优缺点

优点
* 可以根据当前硬件情况实时编译生成最优机器指令
* 可以根据当前程序的运行情况生成最优的机器指令序列
* 当程序需要支持动态链接时，只能使用 JIT
* 可以根据进程中内存的实际情况调整代码，使内存能够更充分的利用

缺点
* 编译需要占用运行时资源，会导致进程卡顿
* 由于编译时间需要占用运行时间，对于某些代码的编译优化不能完全支持，需要在程序流畅和编译时间之间做权衡
* 在编译准备阶段和识别频繁使用的方法阶段，需要占用时间，使得初始编译不能达到最高性能



### AOT 编译器

AOT 编译器（`Ahead-of-time Compilation`）即 “运行前编译”，负责将源代码编译为机器码。AOT 编译器会在程序执行前，将源代码编译为机器码，可以避免运行时的编译性能消耗和内存消耗。


#### 优缺点

优点
* 在程序运行前编译，可以避免在运行时的编译性能消耗和内存消耗
* 可以在程序运行初期就达到最高性能
* 可以显著的加快程序的启动

缺点
* 在程序运行前编译会使程序安装的时间增加
* 牺牲 Java 的一致性
* 将提前编译的内容保存，会占用更多的内存


### 3种编译器的对比
* 编译速度上，解释执行 > AOT 编译器 > JIT 编译器
* 编译质量上，JIT 编译器 > AOT 编译器 > 解释执行



## 字节码


### 字节码文件的结构

* ref 1-[JVM基础之字节码文件的结构 | 陈树义Blog](https://www.cnblogs.com/chanshuyi/p/the_jvm_roadmap.html)



字节码文件结构是一组以 8 位为最小基础的十六进制数据流，各数据项目严格按照顺序紧凑地排列在 `Class` 文件之中，中间没有添加任何分隔符。在字节码结构中，有两种最基本的数据类型来表示字节码文件格式
1. 无符号数
   * 无符号数属于最基本的数据类型。它以 `u1`、`u2`、`u4`、`u8` 分别代表 1 个字节、2 个字节、4 个字节、8 个字节的无符号数。
   * 无符号数可以用来描述数字、索引引用、数量值或者按照 UTF-8 编码构成的字符串值。
2. 表
   * 表是由多个无符号数或者其他表作为数据项构成的复合数据类型。
   * 所有表都习惯性地以 `_info` 结尾。
   * 表用于描述有层次关系的复合结构的数据。




![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/class-file-structure-1.png)


一个字节码文件的组成部分如上图所示，各个组成部分的数据类型和数量信息，如下表所示。


| 类型 |   名称  |    解释   |  数量  |
|----|---------|----------|--------|
| u4 | magic | 魔数 | 1 |
| u2 | minor_version | 次版本号 | 1 |
| u2 | major_version | 主版本号 | 1 |
| u2 | constant_pool_count | 常量池常量个数 | 1 |
| cp_info | constant_pool | 常量池 | constant_pool_count - 1 |
| u2 | access_flags | 访问标记 | 1 |
| u2 | this_class | 类索引 | 1 |
| u2 | super_class | 父类索引 | 1 |
| u2 | interfaces_count | 接口索引数量 | 1 |
| u2 | interfaces | 接口内容 | interfaces_count |
| u2 | field_count | 字段表字段数量 | 1 |
| field_info | fields | 字段表 | field_count |
| u2 | methods_count | 方法表方法数量 | 1 |
| method_info | methods | 方法表 | methods_count |
| u2 | attributes_count | 属性表属性数量 | 1 |
| attribute_info | attributes | 属性表 | attributes_count |


## 虚拟机的内存结构


> Java 虚拟机的「内存结构」并不是官方的说法，在《Java 虚拟机规范》中用的是「运行时数据区」这个术语。
> 
> Java 虚拟机定义了若干种程序运行期间会使用到的运行时数据区，其中有一些会随着虚拟机启动而创建，随着虚拟机退出而销毁。另外一些则是与线程一一对应的，这些与线程对应的数据区域会随着线程开始和结束而创建和销毁。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/jvm-running-data-area-1.png)


根据《Java 虚拟机规范》，Java 虚拟机的内存结构可以分为公有和私有两部分。
* 公有部分（所有线程共用）
  1. Java 堆（Heap）
  2. 方法区
  3. 常量池
* 私有部分（每个线程的私有数据）
  1. PC寄存器
  2. Java 虚拟机栈
  3. 本地方法栈


下图是一张私有的 Java 虚拟机栈和公有的 Java 堆的示意图。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-jvm-jmm-1.png)


**需要注意的是，原始数据类型和对象引用地址在栈上；对象、对象成员与类定义、静态变量在堆上。**
1. 如果是原生数据类型的局部变量，那么它的内容就全部保留在线程栈上。
2. 如果是对象引用，则栈中的局部变量槽位中保存着对象的引用地址，而实际的对象内容保存在堆中。
3. 对象的成员变量与对象本身一起存储在堆上, 不管成员变量的类型是原生数值，还是对象引用。
4. 类的静态变量则和类定义一样都保存在堆中。



### 堆（Heap）

GC 理论中，根据对象存活时间的不同，引入了「分代思想」，将堆（Heap）划分为年轻代和老年代两部分。年轻代又被划分为 3 个内存池，新生代（Eden space）和存活区（Survivor space）。
* 年轻代（Young generation）
  1. 新生代（Eden space）
  2. 存活区 S0 （From Survivor 0 区）
  3. 存活区 S1 （To Survivor 1 区）
* 老年代（Old generation）




![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/jvm-heap-space-1.png)





当有对象需要分配时，一个对象永远优先被分配在年轻代的 `Eden` 区，等到 `Eden` 区域内存不够时，Java 虚拟机会启动垃圾回收。此时 `Eden` 区中没有被引用的对象的内存就会被回收，而一些存活时间较长的对象则会进入到老年代。在 JVM 中有一个名为 `-XX:MaxTenuringThreshold` 的参数专门用来设置晋升到老年代所需要经历的 GC 次数，即在年轻代的对象经过了指定次数的 GC 后，将在下次 GC 时进入老年代。


此处对「“当有对象需要分配时，一个对象永远优先被分配在年轻代的 `Eden` 区”」这句话进行补充说明。

在具体为对象分配内存时，引入了 TLAB（`Thread Local Allocation Buffer`) 进行优化，如下图所示
* 为每个线程分配一小片内存空间，创建的对象先在这里分配。
* 如果 TLAB 中没有足够的内存空间，则在共享的 Eden 区中分配。
* TLAB 的使用，极大降低了并发资源锁定的开销。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/jvm-young-generation-tlab-1.png)






### 非堆（Non-Heap）

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/java-jvm-jmm-2.png)


JMM中，还划分了一部分内存空间作为「非堆（Non-Heap）」。**非堆（Non-Heap）本质上还是堆（Heap），只是一般不归 GC 管理，非堆中划分了 3 个内存池。**
1. 元空间（`Metaspace`）
   * JDK 1.8 之前被叫做「持久代（或永久代, `Permanent generation`)」
   * JDK 1.8 后被称为 `Metaspace`。
   * JDK 1.8 中将方法区移动到了 `Metaspace` 区里面
2. 压缩类空间（CCS，Compressed Class Space）
   * 存放 class 信息，和 Metaspace 有交叉。
3. Code Cache
   * 存放 JIT 编译器编译后的本地机器代码。


#### 永久代（JDK 1.7）
* ref 1-[JVM参数之堆栈空间配置 | 陈树义Blog](https://www.cnblogs.com/chanshuyi/p/jvm_serial_11_jvm_param_heap_stack.html)


在 JDK 1.8 之前，所加载的类信息都放在永久代中，内部化的字符串（`internalized strings`）等信息也存放到永久代中。我们用 `-XX:PermSize` 设置永久代初始大小，用 `-XX:MaxPermSize` 设置永久代最大大小。

```java
java -XX:PermSize10m -XX:MaxPermSize50m -XX:+PrintGCDetails GCDemo
```

在上面的启动参数中，我们设置永久代初始大小为 10M，最大大小为 50M。


在实际开发中，很难去计算这块区域到底需要占用多少内存空间。预测失败导致的结果就是产生 `java.lang.OutOfMemoryError: Permgen space` 这种形式的错误。既然估算元数据所需空间那么复杂，Java 8 直接删除了永久代，改用 `Metaspace`。

#### 元空间（JDK 1.8）

**在 JDK 1.8 之前，所有加载的类信息都放在永久代中。但在 JDK1.8 时，永久代被移除，取而代之的是元空间（`Metaspace`）。**

我们用 `-XX:MetaspaceSize` 设置元空间的初始大小，用  `-XX:MaxMetaspaceSize` 设置永久代最大大小。

```java
java -XX:MetaspaceSize=10m -XX:MaxMetaspaceSize=50m -XX:+PrintGCDetails GCDemo
```

上面的命令中，我们设置 `MetaspaceSize` 为 10M，`MaxMetaspaceSize` 为 50M。但其实它们并不是设置初始大小和最大大小的。


```s
lbsMacBook-Pro:downloads lbs$ java -XX:MetaspaceSize=10m -XX:MaxMetaspaceSize=50m -XX:+PrintGCDetails GCDemo

Heap
 PSYoungGen      total 76288K, used 2621K [0x00000007a8100000, 0x00000007ad600000, 0x00000007fd600000)
  eden space 65536K, 4% used [0x00000007a8100000,0x00000007a838f5e8,0x00000007ac100000)
  from space 10752K, 0% used [0x00000007acb80000,0x00000007acb80000,0x00000007ad600000)
  to   space 10752K, 0% used [0x00000007ac100000,0x00000007ac100000,0x00000007acb80000)
 ParOldGen       total 175104K, used 0K [0x00000006fd600000, 0x0000000708100000, 0x00000007a8100000)
  object space 175104K, 0% used [0x00000006fd600000,0x00000006fd600000,0x0000000708100000)
 Metaspace       used 2639K, capacity 4486K, committed 4864K, reserved 1056768K
  class space    used 286K, capacity 386K, committed 512K, reserved 1048576K
```

从上面的执行结果可以看到
* `Metaspace` 空间的大小为 2.6M 左右，并不是我们设置的 10M。这是因为 `MetaspaceSize` 设置的是元空间发生 GC 的初始阈值。当达到这个值时，元空间发生 GC 操作，这个值默认是 20.8M。
* `MaxMetaspaceSize` 则是设置元空间的最大大小，默认基本是机器的物理内存大小。虽然可以不设置，但还是建议设置一下，因为如果一直不断膨胀，那么 JVM 进程可能会被 OS kill 掉。


## JVM线程模型

以 Hotspot 虚拟机为例，VM 将 Java 线程（`java.lang.Thread`）与底层操作系统线程之间进行 1:1 的映射。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/jvm-thread-os-info-1.png)

上图中，`OSThread` 实例表示一个操作系统线程（有时候我们也叫物理线程），包含跟踪线程状态时所需的系统级信息。`OSThread` 持有了对应的 “句柄”，以标识实际指向的底层线程。
