# JVM-05-JDK内置工具和JVM参数设置


[TOC]

## 更新
* 2021/12/26，撰写


## 参考资料
* [小白JVM学习指南 | 陈树义Blog](https://www.cnblogs.com/chanshuyi/p/the_jvm_roadmap.html)
* [JVM核心技术32讲 | learn.lianglianglee.com](https://learn.lianglianglee.com/)







## JDK 内置命令行工具

JDK 内置命令行工具可以分为 2 大类型
1. 开发工具
2. 诊断分析工具


### 开发工具

|   工具	|               简介            |
|----------|-------------------------------|
| java	| Java 应用的启动程序 | 
| javac	| JDK 内置的编译工具  | 
| javap	| 反编译 `class` 文件的工具  | 
| javadoc | 根据 Java 代码和标准注释，自动生成相关的 API 说明文档 | 
| javah	| JNI 开发时，根据 Java 代码生成需要的 `.h` 文件  | 
| jdb  | Java Debugger，调试本地和远端程序 | 
| jdeps	 | 探测 `class` 或 `jar` 包需要的依赖 | 
| jar  | 打包工具，可以将文件和目录打包成为 `.jar` 文件 | 
| keytool  | 安全证书和密钥的管理工具（支持生成、导入、导出等操作） | 
| jarsigner | `jar` 文件签名和验证工具 | 
| policytool | 管理本机的 Java 安全策略 | 



### 诊断分析工具

#### jps

`jps` 用于展示 Java 进程信息（`process status`）。

* `jsp -v` 可以展示传递给 JVM 的启动参数
* `jps -q` 将只查看进程号

```s
lbsMacBook-Pro:downloads lbs$ jps
96454 Solution
97145 Jps
96381 

lbsMacBook-Pro:downloads lbs$ jps -q
96454
96381
97148
```

#### jstat

`jstat` 用来监控 JVM 内置的各种统计信息，主要是内存和 GC 相关的信息。

`jstat -options` 中 `-options` 可选参数包括
* `-class`：类加载（Class loader）信息统计
* `-compiler`：JIT 即时编译器相关的统计信息
* `-gc`：GC 相关的堆内存信息，如 `jstat -gc -h 10 -t 864 1s 20`
* `-gccapacity`：各个内存池分代空间的容量
* `-gccause`：看上次 GC、本次 GC（如果正在 GC 中）的原因
* `-gcnew`：年轻代的统计信息（Eden + S0 + S1）
* `-gcnewcapacity`：年轻代空间大小统计
* `-gcold`：老年代和元数据区的行为统计
* `-gcoldcapacity`：老年代空间大小统计
* `-gcmetacapacity`：Meta 区大小统计
* `-gcutil`：GC 相关区域的使用率（utilization）统计
* `-printcompilation`：打印 JVM 编译统计信息



#### jmap

`jmap` 用来 Dump 堆内存，也支持输出统计信息。官方推荐使用 JDK 8 自带的 `jcmd` 工具来取代 `jmap`。

> IDEA 的 Debug 面板中，提供了 Dump 堆内存的功能，点击 “照相机” 图标，可执行 `Get Thread Dump`。

`jmap` 常用选项如下
* `-heap`：打印堆内存的配置和使用信息
* `-histo`：查看哪些类占用的空间最多，信息输出格式为直方图
* `-dump:format=b,file=xxxx.hprof`
  1. Dump 堆内存
  2. 如 `jmap -dump:format=b,file=3826.hprof 3826`，将生成一个 `3826.hprof` 文件
  3. 分析 `hprof` 文件可以使用 `jhat` 或者 `mat` 工具




`-histo` 的一个使用示例如下，输出信息中会包含 `[C`、`[S`、`I`、`[B`、`[[I`
* `[C` 表示 `char[]`。Java 中的 `String` 是用 `final char[]` 来保存的，所以 `String` 对象分配的内存空间，将被统计到 `[C` 行中。
* `[S` 表示 `short[]`
* `[I` 表示 `int[]`
* `[B` 表示 `byte[]`
* `[[I` 表示 `int[][]`



```s
lbsMacBook-Pro:~ lbs$ jmap -histo 4524

num     #instances         #bytes  class name
----------------------------------------------
   1:         52214       11236072  [C
   2:        126872        5074880  java.util.TreeMap$Entry
   3:          5102        5041568  [B
   4:         17354        2310576  [I
   5:         45258        1086192  java.lang.String
......
```



#### jhat

`jhat（Java heap Analyzes Tool）` 是 Java 堆分析工具。
* 在上文中提到，使用 `jmap` Dump 下来的 `hprof` 文件，可以使用 `jhat` 或者 `mat` 工具进行分析。
* `jhat` 会解析 `hprof` 文件，并在本地启动一个 Web 服务器（默认端口是 7000）。我们可访问 `localhost:7000` 查看分析结果。


`jhat` 从 JDK 9 已被移除了。现在 Oracle 官方推荐的分析工具是 Eclipse Memory Analyzer Tool (MAT) 和 VisualVM。

#### jcmd

`jcmd` 是 JDK 8 推出的一款本地诊断工具，只支持连接本机上同一个用户空间下的 JVM 进程。


* 查看进程ID

```s
lbsMacBook-Pro:downloads lbs$ jcmd
98424 
98524 sun.tools.jcmd.JCmd
```

* 向进程发送 `help` 指令，查看获取的信息

```s
lbsMacBook-Pro:downloads lbs$ jcmd 98424 help

98424:
The following commands are available:
Compiler.CodeHeap_Analytics
Compiler.codecache
Compiler.codelist
...

GC.class_histogram
GC.class_stats
GC.finalizer_info
GC.heap_dump
GC.heap_info
GC.run
...
Thread.print
VM.class_hierarchy
VM.classloader_stats
VM.classloaders
VM.command_line
VM.dynlibs
VM.metaspace
VM.native_memory
VM.print_touched_methods
VM.set_flag
VM.stringtable
VM.symboltable
VM.system_properties
VM.systemdictionary
VM.uptime
VM.version
help
```

* 根据 `jcmd 98424 help`返回的结果，去查看具体的 `VM`相关信息、`GC` 相关信息。

```s
# JVM 实例运行时间
jcmd 98424 VM.uptime
9307.052 s

#JVM 版本号
jcmd 98424 VM.version
OpenJDK 64-Bit Server VM version 25.76-b162
JDK 8.0_76
```

```s
# 统计每个类的实例占用字节数
jcmd 98424 GC.class_histogram

 num     #instances         #bytes  class name
----------------------------------------------
   1:         11613        1420944  [C
   2:          3224         356840  java.lang.Class
   3:           797         300360  [B
   4:         11555         277320  java.lang.String
   5:          1551         193872  [I
   6:          2252         149424  [Ljava.lang.Object;
```

* 使用 `jcmd process_id GC.heap_dump` 可以 Dump 堆内存


```s
Syntax : GC.heap_dump [options] <filename>
Arguments: filename :  Name of the dump file (STRING, no default value)
Options:  -all=true 或者 -all=false (默认)

# 两者效果差不多
# jcmd 需要指定绝对路径
# jmap 不能指定绝对路径
jcmd 11155 GC.heap_dump -all=true ~/11155-by-jcmd.hprof

jmap -dump:file=./11155-by-jmap.hprof 11155
```


#### jstack

`jstack` 可以打印出 Java 线程的调用栈信息（`Stack Trace`），一般用来查看存在哪些线程，诊断是否存在死锁等。

`jstack` 的可选参数包括
* `-F`：强制执行 Thread Dump，可在 Java 进程卡死时使用，此选项可能需要系统权限
* `-m`：混合模式，将 Java 帧和 native 帧一起输出，此选项可能需要系统权限
* `-l`：长列表模式，将线程相关的 `locks` 信息一起输出，比如持有的锁，等待的锁


```s
jstack 4524
jstack -l 4524

# 将 Thread Dump 保存到本地文件中
jstack -l PID >> threadDump.log
```

使用 `jstack -l PID >> threadDump.log` 可以获取线程转储（Thread Dump）并保存到本地文件中，其效果同 Linux 下的 `kill -3 PID` 命令。




#### jinfo

`jinfo` 用来查看具体生效的配置信息以及系统属性，还支持动态增加一部分参数。

获取线程ID（`process_id`）后，执行 `jinfo process_id`，可以看到所有的系统属性和启动使用的 VM 参数、命令行参数，这非常有利于我们排查问题。

## JDK 内置的图形界面工具

JDK内置的图形界面工具，包括
1. JConsole
2. JVisualVM
   * 默认情况下，JVisualVM 比 JConsole 多了抽样器和 Profiler 这两个工具
   * JVisualVM 支持安装插件
3. JMC（Java Mission Control）
   * Oracle 试图用 JMC 来取代 JVisualVM

这三个工具都支持我们分析本地 JVM 进程，或者通过 JMX 等方式连接到远程 JVM 进程。


## Java 平台调试体系

Java 平台调试体系（Java Platform Debugger Architecture，`JPDA`）由 3 个相对独立的层次共同组成。这三个层次由低到高分别是 Java 虚拟机工具接口（JVMTI）、Java 调试连接协议（`JDWP`）以及 Java 调试接口（JDI）。

| 模块	| 层次 | 编程语言 | 作用 | 
|-------|------|----------|-----|
| JVMTI	| 底层	| C | 获取及控制当前虚拟机状态 | 
| JDWP | 中间层	|  C | 定义 JVMTI 和 JDI 交互的数据格式 | 
| JDI | 高层 | Java | 	提供 Java API 来远程控制被调试虚拟机 | 


此处，介绍下如何在 JVM 中启用 `JDWP`，以供远程调试。假设主启动类是   `com.xxx.Test`。

* Windows 系统

```s
java -Xdebug -Xrunjdwp:transport=dt_shmem,address=debug,server=y,suspend=y com.xxx.Test
```

* Linux 系统

```s
java -Xdebug -Xrunjdwp:transport=dt_socket,address=8888,server=y,suspend=y com.xxx.Test
```


启用了 `JDWP` 之后，可以使用各种客户端来进行调试/远程调试。比如 `JDB` 调试本地 JVM。

```s
jdb -attach 'debug'
jdb -attach 8888
```

## JVM 启动参数

直接通过命令行启动 Java 程序的格式为

```s
java [options] classname [args]

java [options] -jar filename [args]
```
* [options] 部分称为「JVM 选项」，对应 IDE 中的 VM options，可用  `jps -v` 查看。
* [args] 部分是指「传给 main 函数的参数」，对应 IDE 中的 Program arguments，可用 `jps -m` 查看。
* 如果是使用 Tomcat 之类自带 `startup.sh` 等启动脚本的程序，我们一般把相关参数都放到一个脚本定义的 `JAVA_OPTS` 环境变量中，最后脚本启动 JVM 时会把 `JAVA_OPTS` 变量里的所有参数都加到命令的合适位置。



Java 和 JDK 内置的工具，指定参数时都是以`-` 开头，不管是长参数还是短参数。JVM 的启动参数, 从形式上可以简单分为
1. 以 `-` 开头
   * 标准参数，所有的 JVM 都要实现这些参数，并且向后兼容。
2. 以 `-X` 开头
   * 非标准参数，基本都是传给 JVM 的，默认 JVM 实现这些参数的功能，但是并不保证所有 JVM 实现都满足，且不保证向后兼容
3. 以 `-XX:` 开头
   * 非稳定参数，专门用于控制 JVM 的行为，跟具体的 JVM 实现有关，随时可能会在下个版本取消
4. `-XX:+-Flags`
   * `+-` 是对布尔值进行开关
5. `-XX:key=value`
   * 指定某个选项的值


## JVM 的运行模式

### Server模式和Client模式

JVM 有两种运行模式
1. `-server`
   * 启动速度比较慢，但运行时性能和内存管理效率很高，适用于生产环境
   * 在具有 64 位能力的 JDK 环境下将默认启用该模式，而忽略 `-client` 参数
2. `-client`
   * 启动速度比较快，但运行时性能和内存管理效率不高，通常用于客户端应用程序或者 PC 应用开发和调试
   * JDK 1.7 之前的版本，在 32 位的 x86 机器上的默认值是 `-client` 选项

### 解释模式、编译模式和混合模式

JVM 加载字节码后，可以解释执行，也可以编译成本地代码再执行。所以可以配置 JVM 对字节码的处理模式
1. `-Xint` 表示采用解释模式（`Interpreted Mode`）
   * 解释模式下，会强制 JVM 解释执行所有的字节码。这会降低运行速度，通常低 10 倍或更多
2. `-Xcomp` 表示采用编译模式（`Compiled Mode`）
   * 编译模式下，JVM 在第一次使用时会把所有的字节码编译成本地代码，从而带来最大程度的优化。
3. `-Xmixed` 表示采用混合模式
   * 将解释模式和变异模式进行混合使用，这是 JVM 的默认模式，也是推荐模式

执行 `java -version` 命令，在输出信息中可以看到当前的工作模式，默认为 `mixed mode`。

```s
lbsMacBook-Pro:~ lbs$ java -version
java version "1.8.0_333"
Java(TM) SE Runtime Environment (build 1.8.0_333-b02)
Java HotSpot(TM) 64-Bit Server VM (build 25.333-b02, mixed mode)
```


## 内存参数设置

> **JVM 总内存 = 堆 + 栈 + 非堆 + 堆外内存**


| 参数 |     作用      |        说明       |
|------|--------------|------------------|
| `-Xmx` | 指定最大堆内存 | 只是限制了堆（Heap）的最大内存，不包括其余部分内存 |
| `-Xms` | 指定堆内存的初始大小 | 指定的内存大小，并不是操作系统实际分配的初始值，而是 GC 先规划好，用到才分配。专用服务器上需要保持 `-Xms` 和 `-Xmx` 一致，否则应用刚启动可能就有好几个 FullGC。当两者配置不一致时，堆内存扩容可能会导致性能抖动 |
| `-Xmn` | 指定年轻代的大小，等价于 `-XX:NewSize` | 使用 G1 垃圾收集器时不应该设置该选项，其他的某些业务场景下可以设置。官方建议设置为 `-Xmx` 的 `1/2` ~ `1/4` |
| `-XX:MaxPermSize=size` | 指定永久代的最大大小（JDK 1.8 前） |JDK 1.8 中废弃了永久代，改为元空间 |
| `-XX:MaxMetaspaceSize=size` | 指定元空间的最大大小（JDK 1.8 后）| Java 8 默认不限制 Meta 空间， 一般不允许设置该选项 |
| `-XX:MaxDirectMemorySize=size` | 指定系统可以使用的最大堆外内存的大小 | 效果同 `-Dsun.nio.MaxDirectMemorySize` |
| `-Xss` | 指定每个线程栈的字节数 | 如 `-Xss1m` 指定线程栈为 1MB，与 `-XX:ThreadStackSize=1m` 等价 |


需要注意的是
* `-Xmx` 只是指定了堆（Heap）的最大内存，不包括其余部分的内存。所以在设置该值时候，要给其余内存（如堆外内存）留有余地。推荐配置最大堆内存为系统或容器可用内存的 `70%` - `80%`。例如，若系统有 8G 物理内存，除去系统自身占用的内存，大概还有 7.5G 可用，则可以配置 `-Xmx6g`（7.5G * 0.8 = 6G）。
* 一般情况下，我们的服务器是专用的，就是一个机器（也可能是云主机或 docker 容器）只部署一个 Java 应用，这样的时候建议配置 `-Xmx` 和 `-Xms` 为一样的值。这样就不会再动态去分配堆内存了，当两者配置不一致时，堆内存扩容可能会导致性能抖动。




## 指定垃圾收集器相关参数

|    参数   |       说明        |
|----------|-------------------|
| `-XX:+UseG1GC` | 使用 G1 垃圾回收器 |
| `-XX:+UseConcMarkSweepGC` | 使用 CMS 垃圾回收器 |
| `-XX:+UseSerialGC` | 使用串行垃圾回收器 |
| `-XX:+UseParallelGC` | 使用并行垃圾回收器 |

