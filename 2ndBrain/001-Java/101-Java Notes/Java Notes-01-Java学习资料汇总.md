# Java Notes-01-Java学习资料汇总

[TOC]

## 更新
* 2019/10/27，撰写
* 2019/12/12，添加 [Java Guide | github](https://github.com/Snailclimb/awsome-java)
* 2019/12/12，添加 [Java教程 | 廖雪峰](https://www.liaoxuefeng.com/wiki/1252599548343744) 阅读笔记
* 2020/05/11，添加 [Java技术系列文章汇集 | blog](https://my.oschina.net/90888/blog/821871) 阅读笔记
* 2020/05/11，添加 *JSR 说明*
* 2020/06/14，添加 *Arrays.binarySearch 返回值说明*



## 学习资料汇总
* [Java 全栈知识体系](https://pdai.tech/)
* [Java教程 | 廖雪峰](https://www.liaoxuefeng.com/wiki/1252599548343744)
* [To Be Top Javaer - Java工程师成神之路](https://hollischuang.github.io/toBeTopJavaer/#/)
* [Java技术系列文章汇集 | blog](https://my.oschina.net/90888/blog/821871)
* [NotFound9/interviewGuide | github](https://github.com/NotFound9/interviewGuide)
* [Google Java 编程规范](https://legacy.gitbook.com/book/jervyshi/google-java-styleguide-zh/details)

### Java书籍推荐
* 入门 - 《Head First Java》，《疯狂 Java 讲义》
* 《Java 编程思想》
* 《Java核心技术》
* 《Effective Java》3rd
    - [《Effective Java》3rd | github](http://sjsdfg.gitee.io/effective-java-3rd-chinese/#/README)
    - [《Effective Java》3rd | 中文校对](https://www.jianshu.com/c/ce8cf0e13b23)
* 《Java并发编程实战》
* 《Head First 设计模式》
* 《深入理解Java虚拟机》
* 《高性能MySQL》

### 学习方向
* Spring
* Spring boot
* Spring cloud
* dubbo
* mybatis
* hibernate


投放@JD 技术栈方向
* hive 
* sql
* spark
* elasticsearch
* spring
* JD大数据平台：bdp.jd.com （考证hive相关）


## JDK环境安装
* 在 [Java Downloads | Oracle](https://www.oracle.com/java/technologies/downloads/#jdk17-mac) 网站上下载对应的 JDK 版本，并执行安装
* 创建/打开 `.bash_profile`

```s
# 若本地无 .bash_profile 可使用touch命令创建
touch .bash_profile

open -e .bash_profile
```

* 编辑 `.bash_profile`

```s
JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_333.jdk/Contents/Home
PATH=$JAVA_HOME/bin:$PATH:.
CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:.

export JAVA_HOME
export PATH
export CLASSPATH
```

* 使配置文件生效

```s
source .bash_profile
```

* 打印环境变量，验证配置文件生效

```s
lbs@lbsmacbook-pro ~ % echo $JAVA_HOME
/Library/Java/JavaVirtualMachines/jdk1.8.0_333.jdk/Contents/Home
```

* 查看 JDK 版本号，验证安装成功

```s
lbs@lbsmacbook-pro ~ % java -version 
java version "1.8.0_333"
Java(TM) SE Runtime Environment (build 1.8.0_333-b02)
Java HotSpot(TM) 64-Bit Server VM (build 25.333-b02, mixed mode)
```
## Java Guide | github

> Tip: 本章节以下内容来自 [Java Guide | github](https://github.com/Snailclimb/awsome-java)


### Java

1. **[JavaGuide](https://github.com/Snailclimb/JavaGuide)** :【Java学习+面试指南】 一份涵盖大部分Java程序员所需要掌握的核心知识。
2. **[CS-Notes](https://github.com/CyC2018/CS-Notes)** ：技术面试必备基础知识、Leetcode 题解、后端面试、Java 面试、春招、秋招、操作系统、计算机网络、系统设计。
3.  **[advanced-java](https://github.com/doocs/advanced-java)** :互联网 Java 工程师进阶知识完全扫盲：涵盖高并发、分布式、高可用、微服务、海量数据处理等领域知识。
4. **[architect-awesome](https://github.com/xingshaocheng/architect-awesome)** ：后端架构师技术图谱。
5. **[toBeTopJavaer](https://github.com/hollischuang/toBeTopJavaer/issues)** ：Java工程师成神之路 。
6. **[tutorials](https://github.com/eugenp/tutorials)**：该项目是一系列小而专注的教程 - 每个教程都涵盖 Java 生态系统中单一且定义明确的开发领域。 当然，它们的重点是 Spring Framework  -  Spring，Spring Boot 和 Spring Securiyt。 除了 Spring 之外，还有以下技术：核心 Java，Jackson，HttpClient，Guava。
7. **[JCSprout](https://github.com/crossoverJie/JCSprout)** :处于萌芽阶段的Java核心知识库。
8. **[JavaFamily](https://github.com/AobingJava/JavaFamily)** ：【互联网一线大厂面试+学习指南】进阶知识完全扫盲。
9. **[JGrowing](https://github.com/javagrowing/JGrowing)** ：Java is Growing up but not only Java。Java成长路线，但学到不仅仅是Java。

### 数据结构/算法

1. **[LeetCodeAnimation](https://github.com/MisterBooo/LeetCodeAnimation)** :Demonstrate all the questions on LeetCode in the form of animation.（用动画的形式呈现解LeetCode题目的思路）。
2. **[TheAlgorithms-Java](https://github.com/TheAlgorithms/Java)** :All Algorithms implemented in Java。

### SpringBoot

1. **[SpringAll](https://github.com/wuyouzhuguli/SpringAll)** ：循序渐进，学习Spring Boot、Spring Boot & Shiro、Spring Cloud、Spring Security & Spring Security OAuth2，博客Spring系列源码。
2. **[springboot-learning-example](https://github.com/JeffLi1993/springboot-learning-example)** ：Spring Boot 实践学习案例，是 Spring Boot 初学者及核心技术巩固的最佳实践。

### SpringCloud

1. **[SpringCloudLearning](https://github.com/forezp/SpringCloudLearning)** : 《史上最简单的Spring Cloud教程源码》。
2. **[SpringCloud](https://github.com/zhoutaoo/SpringCloud)** ：基于SpringCloud2.1的微服务开发脚手架，整合了spring-security-oauth2、nacos、feign、sentinel、springcloud-gateway等。服务治理方面引入elasticsearch、skywalking、springboot-admin、zipkin等，让项目开发快速进入业务开发，而不需过多时间花费在架构搭建上。

### 大数据

1. **[BigData-Notes](https://github.com/heibaiying/BigData-Notes)** :大数据入门指南 ⭐️。
2. **[flink-learning](https://github.com/zhisheng17/flink-learning)** ：含 Flink 入门、概念、原理、实战、性能调优、源码解析等内容。

### 设计模式

1. **[java-design-patterns](https://github.com/iluwatar/java-design-patterns)** ： Design patterns implemented in Java。

### 框架

1. **[spring-boot](https://github.com/spring-projects/spring-boot)** ：Spring Boot可以轻松创建独立的生产级基于Spring的应用程序,内置 web 服务器让你可以像运行普通 Java 程序一样运行项目。另外，大部分Spring Boot项目只需要少量的配置即可，这有别于 Spring 的重配置。
2.  **[flink](https://github.com/apache/flink)** ：Apache Flink 是一个框架和分布式处理引擎，用于在*无边界和有边界*数据流上进行有状态的计算。Flink 能在所有常见集群环境中运行，并能以内存速度和任意规模进行计算。
3. **[Sentinel](https://github.com/alibaba/Sentinel)** ：A lightweight powerful flow control component enabling reliability and monitoring for microservices. (轻量级的流量控制、熔断降级 Java 库)。
4. **[dubbo](https://github.com/apache/dubbo)** ：Apache Dubbo是一个基于Java的高性能开源RPC框架。
5. **[spring-cloud-kubernetes](https://github.com/spring-cloud/spring-cloud-kubernetes)** ： Kubernetes 集成 Spring Cloud Discovery Client, Configuration, etc...。
6. **[seata](https://github.com/seata/seata)** : Seata 是一种易于使用，高性能，基于 Java 的开源分布式事务解决方案。
7. **[skywalking](https://github.com/apache/skywalking)** : 针对分布式系统的应用性能监控，尤其是针对微服务、云原生和面向容器的分布式系统架构。



### 开发

1. **[elasticsearch](https://github.com/elastic/elasticsearch)**：开源，分布式，RESTful搜索引擎。
2. **[zipkin](https://github.com/openzipkin/zipkin)**  ：Zipkin是一个分布式跟踪系统。它有助于收集解决服务体系结构中的延迟问题所需的时序数据。功能包括该数据的收集和查找。
3. **[apollo](https://github.com/ctripcorp/apollo)** ：Apollo（阿波罗）是携程框架部门研发的分布式配置中心，能够集中化管理应用不同环境、不同集群的配置，配置修改后能够实时推送到应用端，并且具备规范的权限、流程治理等特性，适用于微服务配置管理场景。
4. **[canal](https://github.com/alibaba/canal)** :阿里巴巴 MySQL binlog 增量订阅&消费组件。
5. **[DataX](https://github.com/alibaba/DataX)** ：DataX 是阿里巴巴集团内被广泛使用的离线数据同步工具/平台，实现包括 MySQL、Oracle、SqlServer、Postgre、HDFS、Hive、ADS、HBase、TableStore(OTS)、MaxCompute(ODPS)、DRDS 等各种异构数据源之间高效的数据同步功能。
6. **[cat](https://github.com/dianping/cat)** ： CAT 作为服务端项目基础组件，提供了 Java, C/C++, Node.js, Python, Go 等多语言客户端，已经在美团点评的基础架构中间件框架（MVC框架，RPC框架，数据库框架，缓存框架等，消息队列，配置系统等）深度集成，为美团点评各业务线提供系统丰富的性能指标、健康状况、实时告警等。
7. **[server](https://github.com/wildfirechat/server)** ： 野火IM是一套跨平台、核心功能开源的即时通讯解决方案。
8. **[EasyScheduler](https://github.com/analysys/EasyScheduler)** ： Easy Scheduler是一个分布式工作流任务调度系统，主要解决“复杂任务依赖但无法直接监控任务健康状态”的问题。Easy Scheduler以DAG方式组装任务，可以实时监控任务的运行状态。同时，它支持重试，重新运行等操作... 。

### 其他

1. **[halo](https://github.com/halo-dev/halo)** :Halo 可能是最好的 Java 博客系统。

### 实战

1. **[mall](https://github.com/macrozheng/mall)** ：mall 项目是一套电商系统，包括前台商城系统及后台管理系统，基于 SpringBoot+MyBatis 实现。 
2. **[mall-swarm](https://github.com/macrozheng/mall-swarm)** : mall-swarm是一套微服务商城系统，采用了 Spring Cloud Greenwich、Spring Boot 2、MyBatis、Docker、Elasticsearch等核心技术，同时提供了基于Vue的管理后台方便快速搭建系统。
3. **[litemall](https://github.com/linlinjava/litemall)** ： 又一个小商城。litemall = Spring Boot后端 + Vue管理员前端 + 微信小程序用户前端 + Vue用户移动端。
4. **[vhr](https://github.com/lenve/vhr)** ：微人事是一个前后端分离的人力资源管理系统，项目采用SpringBoot+Vue开发。
5. **[FEBS-Shiro](https://github.com/wuyouzhuguli/FEBS-Shiro)** ：Spring Boot 2.1.3，Shiro1.4.0 & Layui 2.5.4 权限管理系统。

### 工具

1. **[guava](https://github.com/google/guava)** ：Guava 是一组核心库，其中包括新的集合类型（例如multimap 和 multiset），不可变集合，图形库以及用于并发、I / O、哈希、原始类型、字符串等的实用程序！
2. **[p3c](https://github.com/alibaba/p3c)** ：Alibaba Java Coding Guidelines pmd implements and IDE plugin。Eclipse 和 IDEA 上都有该插件，推荐使用！
3. **[arthas](https://github.com/alibaba/arthas)**  ： Arthas 是Alibaba开源的Java诊断工具。
4. **[hutool](https://github.com/looly/hutool)** : Hutool是一个Java工具包，也只是一个工具包，它帮助我们简化每一行代码，减少每一个方法，让Java语言也可以“甜甜的”。
5. **[thingsboard](https://github.com/thingsboard/thingsboard)** ：开源物联网平台 - 设备管理，数据收集，处理和可视化。






## Java程序设计环境

### JDK 
* Java Development Kit，编写Java程序的程序员使用的软件

> 使用 `whereis Java` 可以查看当前运行的Java的安装目录。


```
$ whereis Java 
  
/usr/bin/java
```


### JRE
* Java Runtime Environment，运行Java程序的用户使用的软件。
* JRE是一个运行时环境，包含虚拟机但不包含编译器。

### javac

* `javac` 负责将 Java 源程序（`.java`文件）编译成字节码程序（`.class` 文件）
* `java` 命令可以执行字节码程序（`.class` 文件）

```java
javac HelloWorld.java    // 将 .java 文件编译成 .class 文件
java HelloWorld          // 执行 .class 文件
```




### JSR 

* [JSR 规范 | CSDN](https://blog.csdn.net/Stubborn_Cow/article/details/78800409)

`JSR` 是 `Java Specification Requests` 的缩写，意思是 Java 规范提案。是指向 `JCP` (`Java Community Process` ) 提出新增一个标准化技术规范的正式请求。

任何人都可以提交 JSR，以向 Java 平台增添新的 API 和服务。JSR 已成为 Java 界的一个重要标准。





### applet
在网页中运行的Java程序被称为 `applet`





## Jar包反编译查看源码

* [Jar包反编译工具: JD-GUI 与 fernflower](https://chenyongjun.vip/articles/125)


当需要处理无源代码的久远 `jar` 包，获取其 Java 源码时需要反编译工具的支持。此处介绍 2 种工具
1. JD-GUI
2. IDEA 自带的 `Java Decompiler`



### Java Decompiler

在 Mac 下，`java-decompiler.jar` 位于 `/Applications/IntelliJ IDEA.app/Contents/plugins/java-decompiler/lib`，执行以下命令

```
cd /Applications/IntelliJ\ IDEA.app/Contents/plugins/java-decompiler/lib/;

java -cp java-decompiler.jar org.jetbrains.java.decompiler.main.decompiler.ConsoleDecompiler  ~/jd/logback-core-1.1.11.jar ~/jd/src/
```

命令格式为：`java -jar java-decompiler.jar [-<option>=<value>]* [<source>]+ <destination>`
* `source` 表示 jar 包所在目录，可以填写单个 jar 包，也可以填写一个目录(将解压目录下所有jar包)
* `destination` 表示反编译的 java 源码生成目录


执行命令后，将在 `~/jd/src` 下生成 `logback-core-1.1.11.jar` 文件，这个 `jar` 包就是源文件，解压该 jar 包即可。

```
unzip ~/jd/src/logback-core-1.1.11.jar;
```

### JD-GUI
* [JD-GUI 官网 | 下载](http://java-decompiler.github.io/)
* [ref-Mac Big Sur 升级后 JD-GUI 无法打开的问题修复 | 简书](https://www.jianshu.com/p/ee2932b46d80)



针对新版 Mac OS 系统，遇到如下错误。解决办法参考上述链接。


```
ERROR launching 'JD-GUI'

No suitable Java version found on your system!
This program requires Java 1.8+
Make sure you install the required Java version.
```






## Java 工具
* [ref-Java技术系列文章汇集 | blog](https://my.oschina.net/90888/blog/821871) 

在 JDK 的 bin 目彔下，包含了 JAVA 命令及其他实用工具。
* jps：查看本机的Java中进程信息
* jstack：打印线程的栈信息，制作线程Dump
* jmap：打印内存映射，制作堆Dump
* jstat：性能监控工具
* jhat：内存分析工具
* jconsole：简易的可视化控制台
* jvisualvm：功能强大的控制台

 
### Java Dump

#### 什么是Java Dump
Java Dump 是 Java 虚拟机的运行时快照，可以将 Java 虚拟机运行时的状态和信息保存到文件。
* 线程Dump：包含所有线程的运行状态。纯文本格式。
* 堆Dump：包含线程Dump，包含所有堆对象的状态。二进制格式。

#### 作用
1. 补足传统Bug分析手段的不足: 可在任何Java环境使用；信息量充足。
2. 可以用于多线程幵发、内存泄漏等场景的开发和调试。


#### 制作Java Dump
* 方式1：使用Java虚拟机制作Dump：指示虚拟机在发生内存不足错误时，自动生成堆Dump

```
-XX:+HeapDumpOnOutOfMemoryError
```

* 方式2：使用图形化工具制作Dump：使用JDK(1.6)自带的工具-Java VisualVM

* 方式3：使用命令行制作Dump
    - jstack：打印线程的栈信息，制作线程Dump
    - jmap：打印内存映射，制作堆Dump


使用命令行制作Dump步骤如下
1. 检查虚拟机版本（`java -version`）
2. 找出目标Java应用的进程ID（`jps`）
3. 使用 `jstack` 命令制作线程 Dump（Linux环境下使用kill命令制作线程Dump）
4. 使用 `jmap` 命令制作堆 Dump

## Java基本程序设计结构

### Tips

* **源代码的文件名必须和公共类的名字相同，并用 `.java` 作为扩展名。** 非公有类无此限制。
* Java 中的所有函数都属于某个类的方法，因此，Java中的 `main` 方法必须有一个外壳类。
* **Java中的 `main` 方法必须是静态的(`static`)**


### 数据类型
**Java中，共有8种基本类型（`primitive type`）**，其中有
* 4种整型 （`int`, `short`,`long`,`byte`）
* 2种浮点类型（`float`, `double`）
* 1种用于表示 Unicode 编码的字符单元的字符类型 `char`
* 1种用于表示真值的 `boolean` 类型

> Tip: Java中的“大数值”(`big number`) 虽然被称为大数值，但它并不是一种新的 Java 类型，而是一个 Java 对象。


#### 整型
* `int`，4字节，32位
* `short`，2字节，16位
* `long`，8字节，64位
* `byte`，1字节，8位

例如，`byte` 类型为1字节存储，即`2^8`，考虑到数值正负，因此，`byte` 类型可表示的数值范围为 `-128 ~ 127`。

Java 中，`int` 永远为32位的整数，而在 C++ 中，`int` 可能为 16 位整数，也可能为 32 位整数，也可能是编译器提供商指定的其他位数大小。在Java中，整型的范围和运行Java代码的机器无关，因此保证了代码的可移植性。
 
 

#### 浮点数
* 单精度：`float`，4字节，32位
* 双精度：`double`，8字节，64位

`float` 类型的数值后面有一个 `F` 或 `f` 后缀。没有后缀的浮点数值默认为 `double` 类型。当然，也可以使用 `D` 或 `d` 后缀，表示双精度 `double` 类型。


#### char
* `char` 类型用于表示单个字符，或者一些 Unicode 字符。
* `char` 类型的字面量值要用单引号括起来，比如 'A' 是编码值为 65 所对应的字符常量。它与 "A" 不同，"A" 是包含一个字符 A 的字符串(`String`)。
* Java 中，`char` 类型描述了 UTF-16 编码中的一个代码单元。强烈建议不要在程序中使用 `char` 类型，除非确实需要处理 UTF-16 代码单元。最后将字符串作为抽象数据类型处理。 


#### boolean

* **Java 中，整型值和布尔值之间不能相互转换。**




### 变量

Java中不区分变量的声明和定义。在C++中，区分变量的声明和定义。

```
//C++ 变量声明
extern int i;

//C++ 变量定义
int i = 10;
```


#### 基本类型和引用类型

Java数据类型可分为2类
* 8种基本类型：`byte`，`short`，`int`，`long`，`double`，`float`，`boolean`，`char`
* 引用类型： `class`，`interface`，`String`，`Array`

引用类型可以赋值为 `null` 表示空，但基本类型不能赋值为 `null`。

> **Java 中 `String` 是个对象，是一个类，是引用类型。**

此外需要注意的是，

* 实例变量在类内声明，局部变量在方法中声明
* 局部变量没有默认初始值，在使用前必须初始化赋值
* 实例变量有默认的初始值，原始类型 (`primitive`)的默认值是 `0/0.0/false`，引用类型的默认值是 `null`







#### equals() 和 ==

* 使用 `==` 来比较两个 `primitive` 主数据类型，或者判断两个引用是否引用同一个对象
* 使用 `equals()` 来判断两个对象是否在意义上相等

### 常量
Java 中，使用关键字 `final` 指示常量。 习惯上，常量名使用全大写。

```
final double CM_PER_INCH = 8.5;
```

关键字 `final` 表示这个变量只能被赋值一次。一旦被赋值之后，就不能再次更改。


### 类常量

在Java中， 经常希望某个常量可以在一个类中的多个方法中使用，通常将这些常量成为 *类常量*，使用关键字 `static final` 修饰一个类常量。

```
public class DemoTest {
    public static final double CM_PER_INCH = 2.54;
    
    //...
}
```

> `final` means that the value cannot be changed after initialization, that's what makes it a constant. `static` means that instead of having space allocated for the field in each object, only one instance is created for the class.
> 
> So, `static final` means only one instance of the variable no matter how many objects are created and the value of that variable can never change. --- [stackoverflow.com](https://stackoverflow.com/questions/12792260/how-to-declare-a-constant-in-java)


### 字符串 String
* 子串：`substring(start,end)`，返回区间 `[start,end)` 的子串
* 拼接：Java语言允许使用 `+ ` 号拼接两个字符串，也可以使用 `str1.concat(str2)` 进行字符串拼接
* 不可变字符串：**由于不能修改Java中字符串中的字符，所以Java文档中将 `String` 类型对象成为不可变字符串**
* 检查字符串是否相等： `equals()` 和 `equalsIgnoreCase()`。**不能使用 `==` 运算符检查两个字符串是否相等，这个运算符只能确定两个字符串是否放在同一个位置。**

> Tip: C++的 `string` 类重载了 `==` 运算符，因此可以使用 `==`检查两个字符串是否相等。但是Java没有采用这种方式，因此必须使用 `equals()` 进行判断


* 空串 `""` 是长度为0的字符串，内容为空

```
//检查空串

if(str.equals(""))  
//或者
if(str.length() == 0) 
```

* 字符串赋值为 `null`，表示没有任何对象和该变量关联。

```
//检查null串
if(str == null) 
```
* 程序开发中，经常会判断字符串既不是空串也不是 `null` 串再进行后续操作，代码为

```
if(str != null && str.length() != 0){
    // ...
}
```

* `str.charAt(index)` 返回字符串第 `index` 索引处的字符



#### Object转String

* [Object转String的几种方法总结](https://blog.csdn.net/qingmengwuhen1/article/details/75675733)

Java 中 `Obejct` 转 `String` 有以下几种方法

1. `object.toString()` 方法：本方法中 `object` 不能为 `null`,否则会报 `NullPointException`。一般不要使用该方法进行转换。
2. `String.valueOf(object)` 方法：本方法不必担心对象为 `null` 的情况。若 `object` 为 `null`，则会转化为 `"null"` 字符串。
3. `(String)(object)` 方法：本方法也不必担心对象为 `null` 的情况，但 `object` 需要是能转换为 `String` 的对象。例如对 `Object object = 1`，执行 `(String)1`，则会报类转换异常的错误。若 `object` 为 `null`，则不会转化为 `"null"` 字符串，这点需要注意。
4. `"" + object` 方法：本方法不必担心对象为 `null` 的情况。若 `object` 为 `null`，则会转化为 `"null"` 字符串，同 `String.valueOf(object)`。


下面给出测试代码。


```java
Object object = null;

System.out.println("(String)null和\"null\"比较的结果为：" + ("null".equals((String)object)));

System.out.println("String.valueOf(null)和\"null\"比较的结果为：" + "null".equals(String.valueOf(object)));

System.out.println("(\"\" + null)和\"null\"比较的结果为：" + "null".equals("" + object));
```

程序运行结果如下。

```
(String)null和"null"比较的结果为：false
String.valueOf(null)和"null"比较的结果为：true
("" + null)和"null"比较的结果为：true
```







#### 构建字符串 

Java中 `String`类 是不可变字符串，使用 `+` 拼接字符串时，每次拼接字符串都会生成一个新的 `String` 对象，既耗时，也浪费空间。

因此，在构建字符串过程中，可以使用 `StringBuilder`类 或者 `StringBuffer` 类。

和 `String` 类不同的是，`StringBuffer` 和 `StringBuilder` 类的对象能够被多次的修改，并且不产生新的未使用对象。

`StringBuilder` 类在 Java 5 中被提出，它和 `StringBuffer` 之间的最大不同在于 `StringBuilder` 的方法不是线程安全的（不能同步访问）。

由于 `StringBuilder` 相较于 `StringBuffer` 有速度优势，所以多数情况下建议使用 `StringBuilder` 类。然而在应用程序要求线程安全的情况下，则必须使用 `StringBuffer` 类。


例如，如果需要用许多小段的字符串构建一个字符串，那么应该按照下列步骤进行
1. 创建一个新的字符串构建器
2. 调用 `append()` 方法添加新的字符串内容
3. 调用 `toString()` 方法，得到一个 `String` 对象


```
StringBuilder builder = new StringBuilder();  
// 可以接受参数，如 new StringBuilder("test")

builder.append("abc");
builder.append("def");

String completedString = builder.toString();
```



#### String 性能提升

* [String性能提升的几个小技巧（源码+原理分析） | 掘金](https://juejin.im/post/5ea4e8db51882573bc7c31d7)

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-string-performance-1.png)


##### String 源码

```
// 源码基于 JDK 1.8
public final class String
    implements java.io.Serializable, Comparable<String>, CharSequence {
    // String 值的实际存储容器
    private final char value[];
    public String() {
        this.value = "".value;
    }
    public String(String original) {
        this.value = original.value;
        this.hash = original.hash;
    }
    // 忽略其他信息
}
```

查看 `String` 源码可知，该类被修饰符 `final` 修饰（该类无法被继，不能有子类），其实例变量 `value[]` 被修饰符 `final` 修饰（`value[]` 是实现字符串存储的最终结构），因此，一旦创建了 `String` 对象，该对象就是不变的，不能被修改了。


##### String为什么不能被修改？

String 的类和属性 `value[]` 都被定义为 `final` 了，这样做的好处有以下3点

1. 安全性：考虑对字符串校验的场景，如果 String 是可变类的话，可能在你校验过后，它内部的值又被改变了，这样校验就会失效，有可能会引起严重的系统崩溃问题。所以迫使 `String` 设计为 `final` 类的一个重要原因就是出于安全考虑。
2. 高性能：String 不可变之后，就可以保证 `hash` 值的唯一性，这样它就更加高效，并且更适合做 `HashMap` 的 `key-value` 缓存。
3. 节约内存：String 的不可变性是它实现字符串常量池的基础，字符串常量池指的是字符串在创建时，先去“常量池”查找是否有此“字符串”；如果有，则不会开辟新空间创作字符串，而是直接把常量池中的引用返回给此对象，这样就能更加节省空间。例如，通常情况下 String 创建有两种方式
    * 直接赋值的方式，如 `String str="Java"`。这种方式下，JVM 首先会检查该对象是否在字符串常量池中。如果在，就返回该对象引用，否则新的字符串将在常量池中被创建。这种方式可以减少同一个值的字符串对象的重复创建，节约内存。
    * 另一种是 `new` 形式的创建，如 `String str = new String("Java")`。这种方式下，首先在编译类文件时，“Java”常量字符串将会放入到常量结构中，在类加载时，“Java”将会在常量池中创建；其次，在调用 new 时，JVM 命令将会调用 String 的构造函数，同时引用常量池中的“Java”字符串，在堆内存中创建一个 String 对象，最后 `str` 将引用 String 对象。
 

##### 不要直接+=字符串

通过上面的内容，我们知道了 String 类是不可变的，那么在使用 String 时就不能频繁的 `+=` 字符串了。

* 优化前代码

```
public static String doAdd() {
    String result = "";
    for (int i = 0; i < 10000; i++) {
        result += (" i:" + i);
    }
    return result;
}
```

有人可能会问，我的业务需求是这样的，那我该如何实现？

官方为我们提供了2种字符串拼加的方案： `StringBuffer`（线程安全的） 和 `StringBuilder`（非线程安全的）。其中 `StringBuffer` 的拼加方法使用了关键字 `synchronized` 来保证线程的安全，源码如下

```
@Override
public synchronized StringBuffer append(CharSequence s) {
    toStringCache = null;
    super.append(s);
    return this;
}
```

也因为使用 `synchronized` 修饰，所以 `StringBuffer` 的拼加性能会比 `StringBuilder` 低。


* 下面使用 `StringBuilder` 来实现字符串的拼加，优化后代码如下

```
public static String doAppend() {
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < 10000; i++) {
        sb.append(" i:" + i);
    }
    return sb.toString();
}
```


* 最后，通过一个测试代码，测试优化前后代码的性能


```java
public class StringTest {
    public static void main(String[] args) {
        for (int i = 0; i < 5; i++) {
            // String
            long st1 = System.currentTimeMillis(); // 开始时间
            doAdd();
            long et1 = System.currentTimeMillis(); // 开始时间
            System.out.println("String 拼加，执行时间：" + (et1 - st1));
            // StringBuilder
            long st2 = System.currentTimeMillis(); // 开始时间
            doAppend();
            long et2 = System.currentTimeMillis(); // 开始时间
            System.out.println("StringBuilder 拼加，执行时间：" + (et2 - st2));
            System.out.println();
        }
    }
    public static String doAdd() {
        String result = "";
        for (int i = 0; i < 10000; i++) {
            result += ("Java中文社群:" + i);
        }
        return result;
    }
    public static String doAppend() {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 10000; i++) {
            sb.append("Java中文社群:" + i);
        }
        return sb.toString();
    }
}
```

执行上述程序，会看到如下结果

```
String 拼加，执行时间：429
StringBuilder 拼加，执行时间：1
String 拼加，执行时间：553
StringBuilder 拼加，执行时间：0
String 拼加，执行时间：289
StringBuilder 拼加，执行时间：1
String 拼加，执行时间：210
StringBuilder 拼加，执行时间：2
String 拼加，执行时间：224
StringBuilder 拼加，执行时间：1
```

从结果可以看出，优化前后的性能相差很大。需要注意的是，此性能测试的结果与循环的次数有关，也就是说循环的次数越多，它们性能相差的值也越大。

接下来，思考一个问题：**为什么 `StringBuilder.append()` 方法比 `+=` 的性能高？ 而且拼接的次数越多性能的差距也越大？**

当我们打开 `StringBuilder` 的源码，就可以发现其中的“小秘密”了，`StringBuilder` 父类 `AbstractStringBuilder` 的实现源码如下


```
abstract class AbstractStringBuilder implements Appendable, CharSequence {
    char[] value;
    int count;
    @Override
    public AbstractStringBuilder append(CharSequence s, int start, int end) {
        if (s == null)
            s = "null";
        if ((start < 0) || (start > end) || (end > s.length()))
            throw new IndexOutOfBoundsException(
                "start " + start + ", end " + end + ", s.length() "
                + s.length());
        int len = end - start;
        ensureCapacityInternal(count + len);
        for (int i = start, j = count; i < end; i++, j++)
            value[j] = s.charAt(i);
        count += len;
        return this;
    }
    // 忽略其他信息...
}
```

`StringBuilder` 使用了父类提供的 `char[]` 作为自己值的实际存储单元，每次在拼加时会修改 `char[]` 数组。

`StringBuilder` 的 `toString()` 的源码如下

```
@Override
public String toString() {
    // Create a copy, don't share the array
    return new String(value, 0, count);
}
```

综合以上源码可以看出
1. `StringBuilder` 使用了 `char[]` 作为实际存储单元，每次在拼加时只需要修改 `char[]` 数组即可，只是在 `toString()` 时创建了一个字符串。
2. 而 `String` 一旦创建之后就不能被修改，因此在每次拼加时，都需要重新创建新的字符串。
3. 所以 `StringBuilder.append()` 的性能就会比字符串的 `+=` 性能高很多。



##### 善用 intern 方法

善用 `String.intern()` 方法，可以有效的节约内存并提升字符串的运行效率。先来看 `intern()` 方法的定义与源码


```
/**
* Returns a canonical representation for the string object.
* <p>
* A pool of strings, initially empty, is maintained privately by the
* class {@code String}.
* <p>
* When the intern method is invoked, if the pool already contains a
* string equal to this {@code String} object as determined by
* the {@link #equals(Object)} method, then the string from the pool is
* returned. Otherwise, this {@code String} object is added to the
* pool and a reference to this {@code String} object is returned.
* <p>
* It follows that for any two strings {@code s} and {@code t},
* {@code s.intern() == t.intern()} is {@code true}
* if and only if {@code s.equals(t)} is {@code true}.
* <p>
* All literal strings and string-valued constant expressions are
* interned. String literals are defined in section 3.10.5 of the
* <cite>The Java&trade; Language Specification</cite>.
*
* @return  a string that has the same contents as this string, but is
*          guaranteed to be from a pool of unique strings.
*/
public native String intern();
```


可以看出 `intern()` 是一个高效的本地方法。它的定义中说的是，当调用 `intern` 方法时，如果字符串常量池中已经包含此字符串，则直接返回此字符串的引用；如果不包含此字符串，先将字符串添加到常量池中，再返回此对象的引用。

那什么情况下适合使用 `intern()` 方法？

Twitter 工程师曾分享过一个 `String.intern()` 的使用示例。Twitter 每次发布消息状态的时候，都会产生一个地址信息，以当时 Twitter 用户的规模预估，服务器需要 32G 的内存来存储地址信息。

```
public class Location {
    private String city;
    private String region;
    private String countryCode;
    private double longitude;
    private double latitude;
}
```

考虑到其中有很多用户在地址信息上是有重合的，比如，国家、省份、城市等，这时就可以将这部分信息单独列出一个类，以减少重复，代码如下

```
public class SharedLocation {
  private String city;
  private String region;
  private String countryCode;
}

public class Location {

  private SharedLocation sharedLocation;
  double longitude;
  double latitude;
}
```

通过优化，数据存储大小减到了 20G 左右。但对于内存存储这个数据来说，依然很大，怎么办呢？

Twitter 工程师使用 `String.intern()` 使重复性非常高的地址信息存储大小从 20G 降到几百兆，从而优化了 String 对象的存储。实现的核心代码如下

```
SharedLocation sharedLocation = new SharedLocation();
sharedLocation.setCity(messageInfo.getCity().intern());    
sharedLocation.setCountryCode(messageInfo.getRegion().intern());
sharedLocation.setRegion(messageInfo.getCountryCode().intern());
```

从 JDK1.7 版本以后，常量池已经合并到了堆中，所以不会复制字符串副本，只是会把首次遇到的字符串的引用添加到常量池中。此时只会判断常量池中是否已经有此字符串，如果有就返回常量池中的字符串引用。

这就相当于以下代码

```
String s1 = new String("Java中文社群").intern();
String s2 = new String("Java中文社群").intern();
System.out.println(s1 == s2);
```
代码执行结果为 `true`。


此处如果有人问为什么不直接赋值（使用 `String s1 = "Java中文社群"`），是因为这段代码是简化了上面 Twitter 业务代码的语义而创建的，他使用的是对象的方式，而非直接赋值的方式。更多关于 `intern()` 的内容可以查看 [别再问我new字符串创建了几个对象了！我来证明给你看](https://mp.weixin.qq.com/s/f6VTVXktADP7U1BmlUWM-Q) 这篇文章。


##### 慎重使用 Split 方法


之所以要劝各位慎用 `Split` 方法，是因为 `Split` 方法大多数情况下使用的是正则表达式，这种分割方式本身没有什么问题，但是由于正则表达式的性能是非常不稳定的，使用不恰当会引起回溯问题，很可能导致 CPU 居高不下。

例如以下正则表达式

```
String badRegex = "^([hH][tT]{2}[pP]://|[hH][tT]{2}[pP][sS]://)(([A-Za-z0-9-~]+).)+([A-Za-z0-9-~\\\\/])+$";
String bugUrl = "http://www.apigo.com/dddp-web/pdf/download?request=6e7JGxxxxx4ILd-kExxxxxxxqJ4-CHLmqVnenXC692m74H38sdfdsazxcUmfcOH2fAfY1Vw__%5EDadIfJgiEf";
if (bugUrl.matches(badRegex)) {
    System.out.println("match!!");
} else {
    System.out.println("no match!!");
}
```

执行上述代码，会导致 CPU 负载飙升！


Java 正则表达式使用的引擎实现是 `NFA`（`Non deterministic Finite Automaton`，不确定型有穷自动机）自动机，这种正则表达式引擎在进行字符匹配时会发生回溯（`backtracking`）。而一旦发生回溯，那其消耗的时间就会变得很长，有可能是几分钟，也有可能是几个小时，时间长短取决于回溯的次数和复杂度。

为了更好地解释什么是回溯，我们使用以下面例子进行解释

```
text = "abbc";
regex = "ab{1,3}c";
```

上面的这个例子的目的比较简单，匹配以 `a` 开头，以 `c` 结尾，中间有 `1-3` 个 `b` 字符的字符串。NFA 引擎对其解析的过程是这样子的

1. 首先，读取正则表达式第一个匹配符 `a` 和字符串第一个字符 `a` 比较，匹配上了，于是读取正则表达式第二个字符；
2. 读取正则表达式第二个匹配符 `b{1,3}` 和字符串的第二个字符 `b` 比较，匹配上了。但因为 `b{1,3}` 表示 1-3 个 `b` 字符串，以及 NFA 自动机的贪婪特性（也就是说要尽可能多地匹配），所以此时并不会再去读取下一个正则表达式的匹配符，而是依旧使用 `b{1,3}` 和字符串的第三个字符 `b` 比较，发现还是匹配上了，于是继续使用 `b{1,3}` 和字符串的第四个字符 `c` 比较，发现不匹配了，此时就会发生回溯。
3. 发生回溯后，我们已经读取的字符串第四个字符 `c` 将被吐出去，指针回到第三个字符串的位置，之后程序读取正则表达式的下一个操作符 `c`，然后再读取当前指针的下一个字符 `c` 进行对比，发现匹配上了，于是读取下一个操作符，然后发现已经结束了。

这就是正则匹配执行的流程和简单的回溯执行流程，而上面的示例在匹配到 `com/dzfp-web/pdf/download?request=6e7JGm38jf.....` 时因为贪婪匹配的原因，所以程序会一直读后面的字符串进行匹配，最后发现没有点号，于是就一个个字符回溯回去了，于是就会导致了 CPU 运行过高。

所以我们应该慎重使用 `Split()` 方法，我们可以用 `String.indexOf()` 方法代替 `Split()` 方法完成字符串的分割。如果实在无法满足需求，就在使用 `Split()` 方法时，对回溯问题加以重视就可以了。


### 输入输出

* 输出

使用 `System.out.println()` 和 `System.out.print()` 进行输出，两者区别是 `println()` 会在输出结束后进行换行。

```
//下面两者等价
System.out.println("test");
System.out.print("test\n");
```



* 格式化输出

例如，`System.out.printf("%8.2f",x)` 表示可以使用8个字符宽度且小数点后2个字符的格式输出变量，即打印输出一个空格和7个字符，比如 `1234.56`。


* 输入

要想通过控制台进行输入是，首先要创建一个 `Scanner` 对象，并与 “标准输入流” `System.in` 关联。

```
Scanner in = new Scanner(System.in);
```

现在，就可以使用 `Scanner` 类的各种方法实现输入操作了。`Scanner` 类定义在 `java.util` 包中，因此需要使用 `import` 导入该包。

```
import java.util.*;

Scanner in = new Scanner(System.in);

//读取一行 nextLine()
System.out.println("What's your name?");
String name = in.nextLine();

//读取一个单词（以空白符作为分隔符） next()
String firstName = in.next();

//读取一个整数 nextInt
int age = in.nextInt();

//读取一个浮点数 nextDouble
int age = in.nextDouble();
```






* 读取文件

用 `File` 对象构造一个 `Scanner` 对象

```
Scanner in = new Scanner(Paths.get("myFile.txt"),"UTF-8");
```

* 写入文件

构造一个 `PrintWriter` 对象

```
PrintWriter out = new PrintWriter("myFile.txt","UTF-8");
```

### 大数值

`java.math` 包中的 `BigInteger` 类和 `BigDecimal` 类，可以处理包含任意长度数字序列的数值
* `BigInteger` 类实现了任意精度的整数运算
* `BigDecimal` 类实现了任意精度的浮点数运算

使用 `valueOf` 可以将普通数值转换为大数值。大数值的运算，不能使用加减乘除符号，而要使用 `add()`，`subtract()`，`multiply()` 和 `divide()` 方法。

例如，对下面计算公式进行大数值改写

```
res = res * (n - i + 1) / i;

//大数值改写
res = res.multiply(BigInteger.valueOf(n-i+1)).divide(BigInteger.valueOf(i));
```

> **和C++不同，Java没有提供预算符重载功能。**
>
> 程序员无法重定义 `+ - * /` 运算符，使其应用于大数值的运算。Java语言的设计者确实为字符串的连接重载了 `+` 运算符，但没有重载其他的运算符，也没有给 Java 程序员在自己的类中重载运算符的机会。



### 数组

* 在创建整型数组时，所有元素都被初始化为0；布尔类型数组被初始化为 `false`；对象数组的元素则初始化为 `null`
* **数组一旦创建，无法改变其长度。若要在运行中改变数组大小，请使用数组列表 `arrayList` 数据结构**
* 数组长度为 `arr.length`，字符串长度为 `str.length()` —— 注意二者的语法区别


在创建数组时，使用 `int[] arr` 或者 `int arr[]` 均可，但是习惯上推荐使用 `int[] arr` 这种风格，因为它将类型 `int[]` 和变量名分开了，利于理解。

```java
//不推荐的风格
int arr[] = new int[100];   //创建一个长度为100的数组

//推荐使用的风格
int[] arr = new int[100];
```

#### 数组初始化

Java中，提供了一种创建数组对象并同时赋值的简化书写方式，如下所示。请注意，在使用这种语句时，不需要调用 `new`。

```java
//推荐
int[] arr = {1,2,3,4};

//wrong code  编译可通过，但不建议这么写，不需要调用new
int[] arr = new int[] {1,2,3,4};
```

但是，比如在调用 `int[] arr = {1,2,3,4};` 创建了 `arr` 数组后，若要对该数组重新赋值，但是又不想创建一个新的数组变量，可以使用如下语法实现

```java
//方式1 没有创建多余的变量
arr = new int[] {3,4,5,6};
```

上述语法等价于如下

```java
//方式2 会创建一个临时变量
int[] anotherArr = {3,4,5,6};
arr = anotherArr;
```


#### 增强的for循环语法

```
for(variable : collection) {
    //...
}
```

对于二维度数组，其语法为

```
for(double[] row : arr) {
    for(double value: row){
        // ...
    }
}
```

#### 数组拷贝

直接使用等号进行数组拷贝时，两个变量将引用同一个数组。因此，改变新数组的值，会影响到之前的数组。


```
int[] arr = {1,2,3};
int[] arrB = arr;
arrB[1] = 123;
System.out.println(arr[1]);   // 123 之前数组也会改变
```

使用 `copyOf` 拷贝数组，会生成一个新的数组，两者互不影响。改变新数组的值，不会影响之前的数组。


```
int[] arr = {1,2,3};
int[] arrC = Arrays.copyOf(arr,arr.length);
arrC[1] = 56;
System.out.println(arr[1]);  // 2 之前数组不受影响
```


#### 命令行参数
Java中 `main` 函数的 `String[] args` 表示命令行参数，例如，执行下述命令

```
java DemoTest -g cruel world
```
命令行参数数组 `args` 的信息如下

```
args[0] = "-g";
args[1] = "cruel";
args[2] = "world";
```

#### 数组排序

```
int[] arr = new int(100);
// ...
Arrays.sort(arr);
```

`sort()` 方法使用了优化的快速排序算法进行排序。默认为升序排序。


还可以自定义排序比较器。

```java
//创建一个堆，并设置元素的排序方式
PriorityQueue<ListNode> queue = new PriorityQueue(new Comparator<ListNode>() {
    @Override
    public int compare(ListNode o1, ListNode o2) {
        return (o1.val - o2.val);
    }
});
```


可以使用 Lambda 表达式优化至如下。


```java
//创建一个堆，并设置元素的排序方式
PriorityQueue<ListNode> queue2 = new PriorityQueue((Comparator<ListNode>) (o1, o2) -> (o1.val - o2.val));
```



#### retainAll
* [retainAll方法简介 | blog](https://www.cnblogs.com/jichi/p/12892150.html)

使用 `retainAll` 方法可以求得两个 `List` 或 `Set` 集合的子集。 `retainAll` 是 `Collection` 接口中提供的一个方法，各个实现类有自己的实现方式，其说明如下。

```java

    /**
     * Retains only the elements in this list that are contained in the
     * specified collection (optional operation).  In other words, removes
     * from this list all of its elements that are not contained in the
     * specified collection.
     *
     * @param c collection containing elements to be retained in this list
     * @return <tt>true</tt> if this list changed as a result of the call
     * @throws UnsupportedOperationException if the <tt>retainAll</tt> operation
     *         is not supported by this list
     * @throws ClassCastException if the class of an element of this list
     *         is incompatible with the specified collection
     * (<a href="Collection.html#optional-restrictions">optional</a>)
     * @throws NullPointerException if this list contains a null element and the
     *         specified collection does not permit null elements
     *         (<a href="Collection.html#optional-restrictions">optional</a>),
     *         or if the specified collection is null
     * @see #remove(Object)
     * @see #contains(Object)
     */
    boolean retainAll(Collection<?> c);
```


可以看到，`retainAll` 的返回值为 `boolean`。在 `list1.retainAll(list2)` 中，若 `list1` 的大小发生变化，则返回 `true`，如下示例。

```java
        List<Integer> list1 = new ArrayList<>();
        list1.add(1);
        list1.add(2);

        List<Integer> list2 = new ArrayList<>();
        list2.add(3);
        list2.add(4);

        System.out.println(list1.retainAll(list2));  //true list1大小发生变化
        System.out.println(list1); //list1 [] (交集为0)


```java
        List<Integer> list1 = new ArrayList<>();
        list1.add(1);
        list1.add(2);

        List<Integer> list3 = new ArrayList<>();
        list3.add(1);
        list3.add(2);
        list3.add(3);
        list3.add(4);

        System.out.println(list1); //list1 [1,2] (交集为1 2)
        System.out.println(list1.retainAll(list2));  //false list1大小未变化
       
```




#### Arrays.binarySearch的返回值


`Arrays.binarySearch()` 的源码和注释如下


```java
    /**
     * Searches the specified array of ints for the specified value using the
     * binary search algorithm.  The array must be sorted (as
     * by the {@link #sort(int[])} method) prior to making this call.  If it
     * is not sorted, the results are undefined.  If the array contains
     * multiple elements with the specified value, there is no guarantee which
     * one will be found.
     *
     * @param a the array to be searched
     * @param key the value to be searched for
     * @return index of the search key, if it is contained in the array;
     *         otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
     *         <i>insertion point</i> is defined as the point at which the
     *         key would be inserted into the array: the index of the first
     *         element greater than the key, or <tt>a.length</tt> if all
     *         elements in the array are less than the specified key.  Note
     *         that this guarantees that the return value will be &gt;= 0 if
     *         and only if the key is found.
     */
    public static int binarySearch(int[] a, int key) {
        return binarySearch0(a, 0, a.length, key);
    }
    
    private static int binarySearch0(short[] a, int fromIndex, int toIndex,
                                     short key) {
        int low = fromIndex;
        int high = toIndex - 1;

        while (low <= high) {
            int mid = (low + high) >>> 1;
            short midVal = a[mid];

            if (midVal < key)
                low = mid + 1;
            else if (midVal > key)
                high = mid - 1;
            else
                return mid; // key found
        }
        return -(low + 1);  // key not found.
    }
```


下面对返回值进行必要的说明
* 若查找到 `key` 值，则返回该值对应的数组索引值。
* 若找不到该值，则返回 `-(insert point + 1)`。其中 `insert point` 表示插入该 `key` 值，该值对应的索引值。


最后结合一个示例进行说明

```java
        //定义一个int型的数组
        int []arr ={8,1,2,5,4,9};

        System.out.println("toString:"+Arrays.toString(arr));
        //调用Arrays的排序方法
        Arrays.sort(arr);
        System.out.println("toString:"+Arrays.toString(arr));
        System.out.println("--------------------------------");
        System.out.println("binarySearch:"+Arrays.binarySearch(arr, 8));//4
        System.out.println("binarySearch:"+Arrays.binarySearch(arr, 26));//-7
        System.out.println("binarySearch:"+Arrays.binarySearch(arr, 6));//-5
        System.out.println("binarySearch:"+Arrays.binarySearch(arr, 0));//-1
```

程序执行结果为

```
toString:[8, 1, 2, 5, 4, 9]
toString:[1, 2, 4, 5, 8, 9]
--------------------------------
binarySearch:4
binarySearch:-7
binarySearch:-5
binarySearch:-1
```
1. 查找元素 8，其对应的数组索引值是 4，因此返回 4
2. 查找元素 26，发现未找到，若插入元素 26，则对应的索引值为 6，因此因此返回 `-(6+1)`
3. 查找元素 6，发现未找到，若插入元素 6，则对应的索引值为 4，因此因此返回 `-(4+1)`
4. 查找元素 0，发现未找到，若插入元素 0，则对应的索引值为 0，因此因此返回 `-(0+1)`


## 对象和类

### 面向对象程序设计概述


#### 类之间的3种关系

类之间的关系可以分为以下3种
* 依赖（"`uses-a`"）：程序设计时，应尽可能地将相互依赖的类减少至最少，让类之间的耦合最小
* 聚合（"`has-a`"）
* 继承（"`is-a`"）

例如，订单 `Order` 类中使用了账户 `Account` 类，因为订单对象需要访问账户对象的收获地址信息。因此订单类依赖账户类。即如果一个类的方法操纵了另一个类的对象，我们就说一个类依赖了另一个类。

订单 `Order` 类中包含了商品 `Item` 类。因此，订单类聚合了商品类。即聚合关系意味着类A的对象包含类B的对象。

加急订单 `Rush Order` 类由 订单 `Order`类继承而来，两者为继承关系。 

#### UML 绘制类图
* UML = Unified Modeling Language，即统一建模语言

UML语言中，表达类关系的符号意义如下表所示

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/java-uml-info-1.png)




### JavaBean

`JavaBean` 是一种符合命名规范的类 `class`，即通过 `getter` 和 `setter` 来定义属性，读写方法符合以下规范

```
// 读方法 getter
public Type getXyz()
// 写方法  setter
public void setXyz(Type value)

// 读方法 isXX （布尔型）
public boolean isChild()
// 写方法 setter
public void setChild(boolean value)
```

注意，对于 `boolean` 类型的属性，它的读方法一般命名为 `isXXX()`。

```
// JavaBean Demo
public class Person {
    private String name;
    private boolean man;

    //读方法 getter
    public String getName() { return this.name; }
    //写方法 setter
    public void setName(String name) { this.name = name; }
 
    //读方法 
    public boolean isMan() { return this.man; }
    //写方法 setter
    public void setMan(boolean man) { this.man = man; }
}
```


### 方法参数

在程序设计语言中，将参数传递给方法（或函数）的专业术语包括
* 按值调用（`call by name`）：方法接受的是调用者提供的值
* 按引用调用（`call by reference`）：方法接收的是调用者提供的变量地址


**Java程序设计语言总是采用按值调用。**

> Tip: C++有按值调用和按引用调用两种传参方式。引用参数标有 `&` 符号。

因为方法参数可以分为
* 基本数据类型
* 对象引用

因此有如下结论
1. 一个方法不能修改一个基本数据类型的参数
2. 一个方法可以改变一个对象参数的状态（因为方法得到的对象引用的拷贝，对应引用和其他的拷贝同时引用同一个对象）
3. 一个方法不能让对象参数引用一个新的对象



### 对象构造
可以为任何一个类添加 `finalize` 方法。`finalize` 方法将在垃圾回收清除对象之前调用。

在实际应用中，不要依赖使用 `finalize` 方法回收任何短缺的资源，这是因为很难知道这个方法什么时候才能调用。



### 包(package)
* **包没有父子关系**。`java.util` 和 `java.util.zip` 是不同的包，两者没有任何继承关系
* 没有定义包名的 class，它使用的是默认包，非常容易引起名字冲突，因此不推荐不写包名的做法
* 包的作用域：位于同一个包的类，可以访问包作用域的字段和方法。**不用 `public`、`protected`、`private` 修饰的字段和方法就是包作用域**

```
package hello;
public class Person {
    // 包作用域
    void hello() {
        System.out.println("Hello!");
    }
}
```

Java 编译器最终编译出的 `.class` 文件只使用完整类名。在代码中，当编译器遇到一个 `class` 名称时
1. 如果是完整类名，就直接根据完整类名查找这个 class
2. 如果是简单类名，按下面的顺序依次查找
    * 查找当前 package 是否存在这个 class
    * 查找 import 的包是否包含这个 class
    * 查找 `java.lang` 包是否包含这个 class

如果按照上面的规则还无法确定类名，则编译报错。


为了类名冲突，需要确定唯一的包名。推荐的做法是**使用倒置的域名来确保唯一性**。例如
* `org.apache`
* `org.apache.commons.log`
* `com.liaoxuefeng.sample`


> Tip: C++中，和包机制类似的是命名空间（`namespace`）。在Java中，`package` 和 `import` 语句类似C++中的 `namespace` 和 `using` 指令。


### 类设计技巧
1. 一定要保证数据私有
2. 一定要对数据私有化
3. 将职责过多的类进行分解
4. 类名和方法名要能体现它们的职责
5. 优先使用不可变的类




### 枚举类
#### enum

```
enum Weekday {
    SUN, MON, TUE, WED, THU, FRI, SAT;
}
```

#### 枚举类和普通类的区别
通过 `enum` 定义的枚举类，和其他的 `class` 有什么区别？答案是没有任何区别。

`enum` 定义的类型就是 `class`，只不过它有以下几个特点
* 定义的 `enum` 类型总是继承自 `java.lang.Enum`，且无法被继承
* **只能定义出 `enum` 的实例，而无法通过 `new` 操作符创建 `enum` 的实例**
* 定义的每个实例都是引用类型的唯一实例
* 可以将 `enum` 类型用于 `switch` 语句

例如，定义的 `Color` 枚举类

```
public enum Color {
    RED, GREEN, BLUE;
}
```

编译器编译出来的 `class` 如下

```
public final class Color extends Enum { // 继承自Enum，标记为final class 无法被继承
    // 每个实例均为全局唯一
    public static final Color RED = new Color();
    public static final Color GREEN = new Color();
    public static final Color BLUE = new Color();
    // private构造方法，确保外部无法调用new操作符:
    private Color() {}
}
```

### 枚举类的比较


* [Java 枚举类 | 廖雪峰的网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1260473188087424)


使用 `enum` 定义的枚举类是一种引用类型。引用类型比较，要使用 `equals()` 方法，如果使用 `==` 比较，它比较的是两个引用类型的变量是否是同一个对象。因此，引用类型比较，要始终使用 `equals()` 方法，但 `enum` 类型可以例外。

这是因为 `enum` 类型的每个常量，在 JVM 中只有一个唯一实例，所以可以直接用 `==` 比较。

```
if (day == Weekday.FRI) { // ok!
}
if (day.equals(Weekday.SUN)) { // ok, but more code!
}
```

## 时间和日期

### 参考资料

* [JAVA8新特性时间日期库DATETIME API及示例](https://www.choupangxia.com/2019/10/14/java8%E6%96%B0%E7%89%B9%E6%80%A7%E6%97%B6%E9%97%B4%E6%97%A5%E6%9C%9F%E5%BA%93datetime-api%E5%8F%8A%E7%A4%BA%E4%BE%8B/)
* [Java8中 Date和LocalDateTime的相互转换](https://blog.csdn.net/hspingcc/article/details/73332380)
* [亲，建议你使用LocalDateTime而不是Date哦 | 掘金](https://juejin.im/post/5d7787625188252388753eae) 
* [LocalDateTime | 廖雪峰的网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1303871087444002)




###  标准库API

Java 标准库有 2 套处理日期和时间的API
* 一套定义在 `java.util` 包里面，主要包括 `Date`、`Calendar` 和 `TimeZone` 这几个类
* 一套新的 API 是在 Java 8 引入的，定义在 `java.time` 包里面，主要包括 `LocalDateTime`、`ZonedDateTime`、`ZoneId` 等


### Date转换为LocalDateTime

#### 方法1
1.从日期获取 `ZonedDateTime` 并使用其方法 `toLocalDateTime()` 获取 `LocalDateTime`


```java
package insping;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class Test {

    public static void main(String[] args) {
        Date date = new Date();
        Instant instant = date.toInstant();
        ZoneId zoneId = ZoneId.systemDefault();

        LocalDateTime localDateTime = instant.atZone(zoneId).toLocalDateTime();
        System.out.println("Date = " + date);
        System.out.println("LocalDateTime = " + localDateTime);

    }
}
```

输出结果为

```
Date = Fri Jun 16 15:35:26 CST 2017
LocalDateTime = 2017-06-16T15:35:26.970
```


#### 方法2
1.使用 `LocalDateTime` 的 `Instant()` 工厂方法


```
LocalDateTime localDateTime = LocalDateTime.ofInstant(date.toInstant(), zoneId);
```

### LocalDateTime转换为Date

1.使用 `atZone()` 方法将 `LocalDateTime` 转换为 `ZonedDateTime` 
2.将 `ZonedDateTime` 转换为 `Instant`，并从中获取 `Date`


```java
package insping;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Date;

public class Test {

    public static void main(String[] args) {
        ZoneId zoneId = ZoneId.systemDefault();
        LocalDateTime localDateTime = LocalDateTime.now();
        ZonedDateTime zdt = localDateTime.atZone(zoneId);

        Date date = Date.from(zdt.toInstant());

        System.out.println("LocalDateTime = " + localDateTime);
        System.out.println("Date = " + date);
    }
}
```

输出结果为

```
LocalDateTime = 2017-06-16T15:38:48.580
Date = Fri Jun 16 15:38:48 CST 2017
```

## 继承

### 类 超类 子类

* Java和 `C++` 定义继承的方式十分相似。Java 使用关键字 `extend` 代替了 `C++`  中的冒号(`:`) 。
* **在Java中，所有的继承都是公有继承，而没有C++中的私有继承和保护继承。**
* 关键字 `extend` 表明正在构造的新类派生于一个已经存在的类。已经存在的类成为超类（`super class`），基类（`base class`）或父类（`parent class`）；新类被成为子类（`subclass`）或派生类（`derived class`）。
* Java中使用关键字 `super` 调用父类的方法。
* Java中不支持多继承。
* 定义类的时候如果使用关键字 `final` 修饰，则该类被称为 `final` 类。`final` 类不允许被继承。
* **抽象类不能被实例化。**


### 泛型数组列表

C++中定义数组，需要在编译时就确定数组大小。**Java中允许在运行时确定数组大小。** 如下

```java
int count = ...;

// cal count value
// ...

Employee[] staff = new Employ[count];   //允许程序运行时再确定数组大小
```

但是数组长度一旦确定后，就不能改变。

为了更灵活的动态改变数组大小，Java提供了一个被称为 `ArrayList` 的类，它使用起来有点像数组，但是在添加或删除元素时，具有自动调节数组容量的功能。**`ArrayList` 是一个采用类型参数（`type parameter`）的泛型类（`generic class`）。即 `ArrayList<T>` 中尖括号中的类型参数不允许是基本类型。**



`ArrayList` 类似 `C++` 中的 `Vector` 模板。`ArrayList` 和 `Vector` 都是泛型类型，但是
* `C++` 的`Vector` 模板为了便于访问元素重载了 `[]` 运算符。由于Java没有运算符重载，所以必须调用显式的方法（使用 `set()` 和 `get()` 方法）。
* `C++` 的`Vector` 向量是值拷贝，对于两个向量，执行赋值操作，`a = b`，会构造一个和 `b` 相同的向量 `a`。而在Java中，赋值语句会让两者引用同一个数组列表。




### 包装类型
Java数据类型可分为2类：基本类型和引用类型。那么，如何把一个基本类型视为对象（引用类型）？

**Java提供了包装类型，来实现基本类型转化为对象（引用类型）。**


| 基本类型 | 对应的引用类型 |
| -------- | -------------- |
| boolean | java.lang.Boolean |
| byte | java.lang.Byte |
| short | java.lang.Short |
| int | java.lang.Integer |
| long | java.lang.Long |
| float | java.lang.Float |
| double | java.lang.Double |
| char | java.lang.Character |

**`ArrayList` 是一个采用类型参数（`type parameter`）的泛型类（`generic class`）。即 `ArrayList<T>` 中尖括号中的类型参数不允许是基本类型。** 也就是说不允许写成 `ArrayList<int>`，但是可以使用包装类型，写成 `ArrayList<Integer>`。

### Auto Boxing

因为 `int` 和 `Integer` 可以互相转换

```
int i = 100;
Integer n = Integer.valueOf(i);
int x = n.intValue();
```

所以，Java 编译器可以帮助我们自动在 `int` 和 `Integer` 之间转型

```
Integer n = 100; // 编译器自动使用Integer.valueOf(int)
int x = n; // 编译器自动使用Integer.intValue()
```

这种直接把 `int` 变为 `Integer` 的赋值写法，称为自动装箱（`Auto Boxing`），反过来，把 `Integer` 变为`int` 的赋值写法，称为自动拆箱（`Auto Unboxing`）。

需要注意的是，自动装箱和自动拆箱只发生在编译阶段，目的是为了少写代码。

装箱和拆箱会影响代码的执行效率，因为编译后的 `class` 代码是严格区分基本类型和引用类型的。并且自动拆箱执行时可能会报 `NullPointerException`

```
// NullPointerException
public class Main {
    public static void main(String[] args) {
        Integer n = null;
        int i = n;
    }
}
```

### 不变类

**所有包装类型都是不变类。** 

查看 `Integer` 源码可知，该类被 修饰符 `final` 修饰（该类无法被继承），其实例变量 `value` 被修饰符 `final` 修饰，因此，一旦创建了 `Integer` 对象，该对象就是不变的。


```
public final class Integer {
    private final int value;
}
```

因此，对两个 `Integer` 实例进行比较要特别注意，绝对不能用 `==` 比较，因为 `Integer` 是引用类型，必须使用`equals()` 比较。





## 反射

### Basic

反射（`Reflection`）是为了解决在运行期，对某个实例一无所知的情况下，如何调用其方法，拿到一个对象的所有信息。
 
例如，正常情况下要调用一个对象的方法，或者访问一个对象的字段，通常会传入对象实例
 
```
 // Main.java
import com.itranswarp.learnjava.Person;

public class Main {
    String getFullName(Person p) {
        return p.getFirstName() + " " + p.getLastName();
    }
}
```

但是，如果不能获得 `Person` 类，只有一个 `Object` 实例，比如这样

```
String getFullName(Object obj) {
    return ???
}
```

怎么办？有童鞋会说：强制转型啊！

```
String getFullName(Object obj) {
    Person p = (Person) obj;
    return p.getFirstName() + " " + p.getLastName();
}
```

强制转型的时候，你会发现一个问题：编译上面的代码，仍然需要引用 `Person` 类。

所以，**反射是为了解决在运行期，对某个实例一无所知的情况下，如何调用其方法。**


### Class类
Java中，类（`class`）是由 JVM 在执行过程中动态加载的。JVM 在第一次读取到一种 `class` 类型时，将其加载进内存。

**每加载一种 `class`，JVM 就为其创建一个 `Class` 类型的实例，并关联起来。注意，这里的 `Class` 类型是一个名叫 `Class` 的 `class`。**

```
public final class Class {
    private Class() {}
}
```

以 `String` 类为例，当 JVM 加载 `String` 类时，它首先读取 `String.class` 文件到内存，然后，为 `String` 类创建一个 `Class` 实例并关联起来

```
Class cls = new Class(String);
```

这个 `Class` 实例是 JVM 内部创建的，如果我们查看 JDK 源码，可以发现 `Class` 类的构造方法是`private`，只有 JVM 能创建 `Class` 实例，我们自己的 Java 程序是无法创建 `Class` 实例的。

所以，JVM 持有的每个 `Class` 实例都指向一个数据类型（ `class` 或 `interface`）

```
┌───────────────────────────┐
│      Class Instance       │──────> String
├───────────────────────────┤
│name = "java.lang.String"  │
└───────────────────────────┘
┌───────────────────────────┐
│      Class Instance       │──────> Random
├───────────────────────────┤
│name = "java.util.Random"  │
└───────────────────────────┘
┌───────────────────────────┐
│      Class Instance       │──────> Runnable
├───────────────────────────┤
│name = "java.lang.Runnable"│
└───────────────────────────┘
```

**一个 `Class` 实例包含了该 `class` 的所有完整信息。**

```
┌───────────────────────────┐
│      Class Instance       │──────> String
├───────────────────────────┤
│name = "java.lang.String"  │
├───────────────────────────┤
│package = "java.lang"      │
├───────────────────────────┤
│super = "java.lang.Object" │
├───────────────────────────┤
│interface = CharSequence...│
├───────────────────────────┤
│field = value[],hash,...   │
├───────────────────────────┤
│method = indexOf()...      │
└───────────────────────────┘
```


由于 JVM 为每个加载的 `class` 创建了对应的 `Class` 实例，并在实例中保存了该 `class` 的所有信息，包括类名、包名、父类、实现的接口、所有方法、字段等，因此，如果获取了某个 `Class` 实例，我们就可以通过这个 `Class` 实例获取到该实例对应的 `class` 的所有信息。

**这种通过 `Class` 实例获取 `class` 信息的方法称为反射（`Reflection`）。**


> **反射是一种非常规的用法（设置 `setAccessible(true)`后，反射可以访问对象的非 `public` 字段，破坏了对象封装）。使用反射，首先代码非常繁琐，其次，它更多地是给工具或者底层框架来使用，目的是在不知道目标实例任何信息的情况下，获取特定字段的值。**



### 如何获class的Class实例

如何获取一个 `class` 的 `Class` 实例？有3个方法

* 方法1：直接通过一个 `class` 的静态变量 `class` 获取

```
Class cls = String.class;
```

* 方法2：如果我们有一个实例变量，可以通过该实例变量提供的 `getClass()` 方法获取

```
String s = "Hello";
Class cls = s.getClass();
```

* 方法3：如果知道一个 `class` 的完整类名，可以通过静态方法 `Class.forName()` 获取

```
Class cls = Class.forName("java.lang.String");
```

因为 `Class` 实例在 JVM 中是唯一的，所以，上述方法获取的 `Class` 实例是同一个实例。可以用 `==` 比较两个 `Class` 实例

```
Class cls1 = String.class;

String s = "Hello";
Class cls2 = s.getClass();

boolean sameClass = cls1 == cls2; // true
```

注意一下 `Class` 实例比较和 `instanceof` 的差别


```
Integer n = new Integer(123);

boolean b1 = n instanceof Integer; // true，因为n是Integer类型
boolean b2 = n instanceof Number; // true，因为n是Number类型的子类

boolean b3 = n.getClass() == Integer.class; // true，因为n.getClass()返回Integer.class
boolean b4 = n.getClass() == Number.class; // false，因为Integer.class!=Number.class
```

**用 `instanceof` 不但匹配指定类型，还匹配指定类型的子类。而用 `==` 判断 `class` 实例可以精确地判断数据类型，但不能作子类型比较。**

通常情况下，我们应该用 `instanceof` 判断数据类型，因为面向抽象编程的时候，我们不关心具体的子类型。只有在需要精确判断一个类型是不是某个 `class` 的时候，我们才使用 `==` 判断 `class` 实例。

### 通过反射获取对象信息

因为反射的目的是为了获得某个实例的信息。因此，当我们拿到某个 `Object` 实例时，可以通过反射获取该`Object` 的 `class` 信息

```
void printObjectInfo(Object obj) {
    Class cls = obj.getClass();
}
```

要从 `Class` 实例获取对象的基本信息，参考下面的代码

```
// reflection

public class Main {
    public static void main(String[] args) {
        printClassInfo("".getClass());
        printClassInfo(Runnable.class);
        printClassInfo(java.time.Month.class);
        printClassInfo(String[].class);
        printClassInfo(int.class);
    }

    static void printClassInfo(Class cls) {
        System.out.println("Class name: " + cls.getName());
        System.out.println("Simple name: " + cls.getSimpleName());
        if (cls.getPackage() != null) {
            System.out.println("Package name: " + cls.getPackage().getName());
        }
        System.out.println("is interface: " + cls.isInterface());
        System.out.println("is enum: " + cls.isEnum());
        System.out.println("is array: " + cls.isArray());
        System.out.println("is primitive: " + cls.isPrimitive());
    }
}
```

注意到数组（例如 `String[]`）也是一种 `Class`，而且不同于 `String.class`，它的类名是`[Ljava.lang.String`。此外，JVM 为每一种基本类型如 `int` 也创建了 `Class`，通过 `int.class` 访问。

如果获取到了一个 `Class` 实例，我们就可以通过该 `Class` 实例来创建对应类型的实例

```
// 获取String的Class实例:
Class cls = String.class;
// 创建一个String实例:
String s = (String) cls.newInstance();
```

上述代码相当于 `new String()`。通过 `Class.newInstance()` 可以创建类实例，它的局限是：只能调用`public` 的无参数构造方法。带参数的构造方法，或者非 `public` 的构造方法都无法通过 `Class.newInstance()` 被调用。


### 动态加载class

JVM 在执行 Java 程序的时候，并不是一次性把所有用到的 `class` 全部加载到内存，而是第1次需要用到`class` 时才加载。

**利用 JVM 动态加载 `class` 的特性，我们才能在运行期根据条件加载不同的实现类。**

例如，`Commons Logging` 总是优先使用 `Log4j`，只有当 `Log4j` 不存在时，才使用 JDK 的 `logging`。利用 JVM 动态加载特性，大致的实现代码如下

```
// Commons Logging优先使用Log4j:
LogFactory factory = null;
if (isClassPresent("org.apache.logging.log4j.Logger")) {
    factory = createLog4j();
} else {
    factory = createJdkLog();
}

boolean isClassPresent(String name) {
    try {
        Class.forName(name);
        return true;
    } catch (Exception e) {
        return false;
    }
}
```

这就是为什么我们只需要把 `Log4j` 的 `jar` 包放到 `classpath` 中，`Commons Logging` 就会自动使用 `Log4j` 的原因。

### 访问字段

对任意的一个 `Object` 实例，只要我们获取了它的 `Class`，就可以获取它的一切信息。

`Class` 类提供了以下几个方法来获取字段
* `Field getField(name)`：根据字段名获取某个 `public` 的 `field`（包括父类）
* `Field getDeclaredField(name)`：根据字段名获取当前类的某个 `field`（不包括父类）
* `Field[] getFields()`：获取所有 `public` 的 `field`（包括父类）
* `Field[] getDeclaredFields()`：获取当前类的所有 `field`（不包括父类）

下面看一段示例代码

```
// reflection
public class Main {
    public static void main(String[] args) throws Exception {
        Class stdClass = Student.class;
        // 获取public字段"score":
        System.out.println(stdClass.getField("score"));
        // 获取继承的public字段"name":
        System.out.println(stdClass.getField("name"));
        // 获取private字段"grade":
        System.out.println(stdClass.getDeclaredField("grade"));
    }
}

class Student extends Person {
    public int score;
    private int grade;
}

class Person {
    public String name;
}
```

上述代码首先获取 `Student` 的 `Class` 实例，然后，分别获取 `public` 字段、继承的 `public` 字段以及 `private` 字段，打印出的 `Field` 类似

```
public int Student.score
public java.lang.String Person.name
private int Student.grade
```

一个 `Field` 对象包含了一个字段的所有信息
* `getName()`：返回字段名称，例如，`"name"`；
* `getType()`：返回字段类型，也是一个 `Class` 实例，例如，`String.class;`
* `getModifiers()`：返回字段的修饰符，它是一个 `int`，不同的 `bit` 表示不同的含义。

以 `String` 类的 `value` 字段为例，它的定义是

```
public final class String {
    private final byte[] value;
}
```

我们用反射获取该字段的信息，代码如下

```
Field f = String.class.getDeclaredField("value");
f.getName(); // "value"
f.getType(); // class [B 表示byte[]类型
int m = f.getModifiers();
Modifier.isFinal(m); // true
Modifier.isPublic(m); // false
Modifier.isProtected(m); // false
Modifier.isPrivate(m); // true
Modifier.isStatic(m); // false
```

#### 获取字段值

利用反射拿到字段的一个 `Field` 实例只是第一步，我们还可以拿到一个实例对应的该字段的值。

例如，对于一个 `Person` 实例，我们可以先拿到 `name` 字段对应的 `Field`，然后再使用`Field.get(Object)` 获取这个实例的 `name` 字段的值


```
// reflection
import java.lang.reflect.Field;

public class Main {

    public static void main(String[] args) throws Exception {
        Object p = new Person("Xiao Ming");
        Class c = p.getClass();
        Field f = c.getDeclaredField("name");
        Object value = f.get(p);
        System.out.println(value); // "Xiao Ming"
    }
}

class Person {
    private String name;

    public Person(String name) {
        this.name = name;
    }
}
```

上述代码先获取 `Class` 实例，再获取 `Field` 实例，然后，用 `Field.get(Object)` 获取指定实例的指定字段的值。

运行代码，如果不出意外，会得到一个 `IllegalAccessException`，这是因为 `name` 被定义为一个`private` 字段，正常情况下，Main 类无法访问 Person 类的 private 字段。

要修复错误，可以将 private 改为 public，或者，在调用 `Object value = f.get(p);` 前，先写一句

```
f.setAccessible(true);
```

调用 `Field.setAccessible(true)` 的意思是，别管这个字段是不是 public，一律允许访问。

可以试着加上上述语句，再运行代码，就可以打印出 private 字段的值。

> **反射是一种非常规的用法（设置 `setAccessible(true)`后，反射可以访问对象的非 `public` 字段，破坏了对象封装）。使用反射，首先代码非常繁琐，其次，它更多地是给工具或者底层框架来使用，目的是在不知道目标实例任何信息的情况下，获取特定字段的值。**


#### 设置字段值

通过反射可以直接修改字段的值。


通过 `Field.set(Object, Object)` 可以设置字段值，其中第1个 `Object` 参数是指定的实例，第2个`Object` 参数是待修改的值。

### 调用方法
通过 `Class` 实例可以获取所有 `Method` 信息，方法如下
* `Method getMethod(name, Class...)`：获取某个 public 的 Method（包括父类）
* `Method getDeclaredMethod(name, Class...)`：获取当前类的某个 Method（不包括父类）
* `Method[] getMethods()`：获取所有 public 的 Method（包括父类）
* `Method[] getDeclaredMethods()`：获取当前类的所有 Method（不包括父类）


一个 `Method` 对象包含一个方法的所有信息
* `getName()`：返回方法名称，例如：`"getScore"`；
* `getReturnType()`：返回方法返回值类型，也是一个 `Class` 实例，例如 `String.class；`
* `getParameterTypes()`：返回方法的参数类型，是一个 `Class` 数组，例如 `{String.class, int.class}；`
* `getModifiers()`：返回方法的修饰符，它是一个 `int`，不同的 `bit` 表示不同的含义


当我们获取到一个 `Method` 对象时，就可以对它进行调用。我们以下面的代码为例

```
String s = "Hello world";
String r = s.substring(6); // "world"
```

如果用反射来调用 `substring` 方法，需要以下代码：

```
// reflection
import java.lang.reflect.Method;

public class Main {
    public static void main(String[] args) throws Exception {
        // String对象:
        String s = "Hello world";
        // 获取String substring(int)方法，参数为int:
        Method m = String.class.getMethod("substring", int.class);
        // 在s对象上调用该方法并获取结果:
        String r = (String) m.invoke(s, 6);
        // 打印调用结果:
        System.out.println(r);
    }
}
```

**对 `Method` 实例调用 `invoke` 就相当于调用该方法，`invoke` 的第一个参数是对象实例，即在哪个实例上调用该方法，后面的可变参数要与方法参数一致，否则将报错。**

#### 调用静态方法

如果获取到的 `Method` 表示一个静态方法，调用静态方法时，由于无需指定实例对象，所以 `invoke` 方法传入的第一个参数永远为 `null`。我们以 `Integer.parseInt(String)` 为例


```
// reflection
import java.lang.reflect.Method;

public class Main {
    public static void main(String[] args) throws Exception {
        // 获取Integer.parseInt(String)方法，参数为String:
        Method m = Integer.class.getMethod("parseInt", String.class);
        // 调用该静态方法并获取结果:
        Integer n = (Integer) m.invoke(null, "12345");
        // 打印调用结果:
        System.out.println(n);
    }
}

```

#### 调用非public方法

和 `Field` 类似，对于非 public 方法，我们虽然可以通过 `Class.getDeclaredMethod()` 获取该方法实例，但直接对其调用将得到一个 `IllegalAccessException`。为了调用非 `public` 方法，我们通过`Method.setAccessible(true)` 允许其调用

```
// reflection
import java.lang.reflect.Method;

public class Main {
    public static void main(String[] args) throws Exception {
        Person p = new Person();
        Method m = p.getClass().getDeclaredMethod("setName", String.class);
        m.setAccessible(true);
        m.invoke(p, "Bob");
        System.out.println(p.name);
    }
}

class Person {
    String name;
    private void setName(String name) {
        this.name = name;
    }
}
```

此外，`setAccessible(true)` 可能会失败。如果 JVM 运行期存在 `SecurityManager`，那么它会根据规则进行检查，有可能阻止 `setAccessible(true)`。例如，某个 `SecurityManager` 可能不允许对 java 和 javax 开头的 `package` 的类调用 `setAccessible(true)`，这样可以保证 JVM 核心库的安全。


#### 使用反射调用方法时仍遵循多态原则

使用反射调用方法时，仍遵循多态原则。

考察这样一种情况：一个 `Person` 类定义了 `hello()` 方法，并且它的子类 `Student` 也覆写了 `hello()` 方法，那么，从 `Person.class` 获取的 `Method`，作用于 `Student` 实例时，调用的方法到底是哪个？

```
// reflection
import java.lang.reflect.Method;

public class Main {
    public static void main(String[] args) throws Exception {
        // 获取Person的hello方法:
        Method h = Person.class.getMethod("hello");
        // 对Student实例调用hello方法:
        h.invoke(new Student());
    }
}

class Person {
    public void hello() {
        System.out.println("Person:hello");
    }
}

class Student extends Person {
    public void hello() {
        System.out.println("Student:hello");
    }
}
```

运行上述代码，发现打印出的是 `Student:hello`。

**因此，使用反射调用方法时，仍然遵循多态原则：即总是调用实际类型的覆写方法（如果存在）。**

上述的反射代码

```
Method m = Person.class.getMethod("hello");
m.invoke(new Student());
```

实际上相当于

```
Person p = new Student();
p.hello();
```

### 调用构造方法
一般情况下，我们使用 `new` 操作符创建新的实例

```
Person p = new Person();
```

如果通过反射来创建新的实例，可以调用 `Class` 提供的 `newInstance()` 方法

```
Person p = Person.class.newInstance();
```

**调用 `Class.newInstance()` 的局限是，它只能调用该类的 `public` 无参数构造方法。如果构造方法带有参数，或者不是 `public`，就无法直接通过 `Class.newInstance()` 来调用。**


为了调用任意的构造方法，Java 的反射 API 提供了 `Constructor` 对象，它包含一个构造方法的所有信息，可以创建一个实例。`Constructor` 对象和 `Method` 非常类似，不同之处仅在于它是一个构造方法，并且，调用结果总是返回实例

```
import java.lang.reflect.Constructor;

public class Main {
    public static void main(String[] args) throws Exception {
        // 获取构造方法Integer(int):
        Constructor cons1 = Integer.class.getConstructor(int.class);
        // 调用构造方法:
        Integer n1 = (Integer) cons1.newInstance(123);
        System.out.println(n1);

        // 获取构造方法Integer(String)
        Constructor cons2 = Integer.class.getConstructor(String.class);
        Integer n2 = (Integer) cons2.newInstance("456");
        System.out.println(n2);
    }
}
```

通过 `Class` 实例获取 `Constructor` 的方法如下
* `getConstructor(Class...)`：获取某个 public 的 `Constructor`
* `getDeclaredConstructor(Class...)`：获取某个 `Constructor`
* `getConstructors()`：获取所有 public 的 `Constructor`
* `getDeclaredConstructors()`：获取所有 `Constructor`

注意 `Constructor` 总是当前类定义的构造方法，和父类无关，因此不存在多态的问题。

调用非 public 的 `Constructor` 时，必须首先通过 `setAccessible(true)` 设置允许访问。


### 获取继承关系
通过 `Class` 对象可以获取继承关系
* `Class getSuperclass()`：获取父类类型
* `Class[] getInterfaces()`：获取当前类实现的所有接口

通过 `Class` 对象的 `isAssignableFrom()` 方法可以判断一个向上转型是否可以实现。

判断一个实例是否是某个类型时，正常情况下，使用 `instanceof` 操作符。如果是两个 `Class` 实例，要判断一个向上转型是否成立，可以调用 `isAssignableFrom()`。

```
Object n = Integer.valueOf(123);
boolean isDouble = n instanceof Double; // false
boolean isInteger = n instanceof Integer; // true
boolean isNumber = n instanceof Number; // true
boolean isSerializable = n instanceof java.io.Serializable; // true
```

```
// Integer i = ?
Integer.class.isAssignableFrom(Integer.class); // true，因为Integer可以赋值给Integer
// Number n = ?
Number.class.isAssignableFrom(Integer.class); // true，因为Integer可以赋值给Number
// Object o = ?
Object.class.isAssignableFrom(Integer.class); // true，因为Integer可以赋值给Object
// Integer i = ?
Integer.class.isAssignableFrom(Number.class); // false，因为Number不能赋值给Integer
```


### 动态代理

Java 标准库提供了动态代理功能，允许在运行期动态创建一个接口的实例。

在运行期动态创建一个 `interface` 实例的方法如下
1. 定义一个 `InvocationHandler` 实例，它负责实现接口的方法调用
2. 通过 `Proxy.newProxyInstance()` 创建 `interface` 实例，它需要3个参数
    * 使用的 `ClassLoader`，通常就是接口类的 `ClassLoader`
    * 需要实现的接口数组，至少需要传入一个接口进去
    * 用来处理接口方法调用的 `InvocationHandler` 实例
3. 将返回的 Object 强制转型为接口












## 接口和抽象类

### 抽象类

* **接口是一种100%的抽象类，抽象类无法创建实例。**
* **不能在非抽象类中拥有抽象方法，即如果声明了一个抽象方法，就必须将类也标记为抽象类。**
* **使用 `abstract` 来标记抽象类。抽象类代表此类必须被 `extend`过，抽象的方法代表此方法一定要被覆盖过。抽象的方法没有实体!**

```
// 抽象的方法没有实体! 直接以分号结束
public abstract void eat();
```

### 接口

在抽象类中，抽象方法本质上是定义接口规范：即规定高层类的接口，从而保证所有子类都有相同的接口实现。这样，多态就能发挥出威力。



```
abstract class Person {
    public abstract void run();
    public abstract String getName();
}
```

**如果一个抽象类没有字段，所有方法全部都是抽象方法，那么就可以把该抽象类改写为接口 `interface`。**

```
interface Person {
    void run();
    String getName();
}
```

所谓 `interface`，就是比抽象类还要抽象的纯抽象接口，因为它连字段都不能有。因为接口定义的所有方法默认都是 `public abstract` 的，所以这2个修饰符可以省略。

当一个具体的 `class` 去实现一个 `interface` 时，需要使用 `implements` 关键字，例如

```
class Student implements Person {
    private String name;

    public Student(String name) {
        this.name = name;
    }

    @Override
    public void run() {
        System.out.println(this.name + " run");
    }

    @Override
    public String getName() {
        return this.name;
    }
}
```

**一个接口可以继承自另一个接口，接口继承接口使用关键字 `extends`。**

**Java中，一个类只能继承自另一个类，不能继承多个类。但是一个类可以实现多个接口。**


**在接口中，可以定义 `default` 方法。实现类可以不必覆写 `default` 方法。**

`default` 方法的目的是，当我们需要给接口新增一个方法时，会涉及到修改全部子类。如果新增的是 `default` 方法，那么子类就不必全部修改，只需要在覆写的地方覆写新增方法即可。

`default` 方法和抽象类的普通方法是有所不同的。因为 `interface` 没有字段，`default` 方法无法访问字段，而抽象类的普通方法可以访问实例字段。


### 抽象类和接口对比

| 对比项   | abstract class |	interface|
|----|----------------|----------|
|继承|	只能extends一个class |	可以implements多个interface |
|字段|	可以定义实例字段     |	不能定义实例字段   |
|抽象方法|	可以定义抽象方法 |  可以定义抽象方法 |
|非抽象方法| 可以定义非抽象方法	| 可以定义default方法 |




### interface中定义的成员变量都是public static final
Java的接口 `interface` 中，定义的成员变量都是 `public static final` 的，因为Java不支持多继承。

比如有接口 A 和接口 B，两个接口中都定义了一个变量 N，而类 C 实现了这两个接口。如果 N 不是 `static` 类型的，那么在 C 类中是无法区分变量 N 到底是 A 还是 B 的。

因此，在接口中定义成员变量，下面两种方式是等价的。

```java
// public static final 可省略
public interface ClientType {
    String ANDROID = "android";
    String APPLE = "apple";
    String IPAD = "ipad";
}


public interface ClientType {
    public static final String ANDROID = "android";
    public static final String APPLE = "apple";
    public static final String IPAD = "ipad";
}
```




## 构造器和垃圾收集器

* **编译器只会在开发者完全没有设定构造函数时，才会调用默认的无参构造函数。** 即如果开发者已经自定义了一个含参的构造函数，并且需要一个无参的构造函数，则开发者必须自己手动实现，编译器此时不会调用默认的无参构造函数。
* **在创建新对象时，所有继承下来的构造函数都会执行。** 即在创建子类实例时，会调用其父类的构造函数。调用父类构造函数的唯一方法是调用 `super()`，不能直接显示调用父类的构造函数。


## 静态方法
Java 是面向对象的，但若处于某种特殊的情况下（通常是实用方法），则不需要类的实例。

* **`static` 这个关键字可以标记出不需要类实例的方法。** 例如，`Math.min()` 中 `min()`方法就是静态方法，可以使用类的名称调用静态方法。

```
public static int main(int a, int b){
    return (a<=b)? a:b;
}
```

* **静态的方法不能调用非静态的变量。** 静态的方法是通过类的名称调用的，因此无法引用到该类的任何实例变量。
* **静态的方法不能调用非静态的方法。**
* 静态变量是在类被加载时初始化的。因此保证了
    * 1. 静态变量会在该类的任何对象创建之前就完成初始化 
    * 2. 静态变量会在该类的任何静态方法执行之前就完成初始化 
* 静态变量属于实例变量，因此有默认的初始值。原始类型 (`primitive`)的默认值是 `0/0.0/false`，引用类型的默认值是 `null`。
* 静态方法属于类而不属于实例，因此，静态方法内部，无法访问 `this` 变量，也无法访问实例字段，它只能访问静态字段




## 作用域

> 一个 `.java` 文件只能包含一个 `public` 类，但可以包含多个非 `public` 类



Java 中常见的修饰符如下

* public
* private
* protected
* package：包作用域是指一个类允许访问同一个 `package` 的没有 `public`、`private` 修饰的`class`，以及没有 `public`、`protected`、`private` 修饰的字段和方法
* 局部变量
* final

下面对 `final` 修饰符进行说明。

`final` 修饰符和访问权限不冲突，它可用于

1. `final` 修饰 `class`，阻止类被继承
2. `final` 修饰 `method`，阻止方法被子类覆写
3. `final` 修饰 `field`，可阻止被重新赋值
4. `final` 修饰局部变量，可阻止被重新赋值


```
package abc;

// 1- 修饰class ，阻止类被继承
public final class Hello {
    // 2- 修饰 method ，阻止方法被子类覆写
    protected final void hi() {
    }
    // 3- 修饰 field ，可阻止被重新赋值
    private final int n = 0;
    
    // 4- 修饰局部变量，可阻止被重新赋值
    protected void hi(final int t) {
        t = 1; // error!
    }
}
```

## 异常


### 异常分类

* [一张图搞清楚Java异常机制](https://mp.weixin.qq.com/s/xbopgxZ5BEDdSvwO9ad9Xg)

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-base-exception-uml-1.png)


* `Throwable` 是 Java 异常的顶级类，所有的异常都继承于这个类。`Error` 和 `Exception` 是异常类的两个大分类。
* `Error` 是非程序异常，即程序不能捕获的异常，一般是编译或者系统性的错误，如 `OutOfMemorry` 内存溢出异常等。
* `Exception` 是程序异常类，由程序内部产生。`Exception` 又分为运行时异常（`RuntimeException`）、非运行时异常。
* 运行时异常的特点是 Java 编译器不会检查它，也就是说，当程序中可能出现这类异常，即使没有用 `try-catch` 语句捕获它，也没有用 `throws` 子句声明抛出它，也会编译通过。运行时异常可处理或者不处理。运行时异常一般常出来定义系统的自定义异常，业务根据自定义异常做出不同的处理。常见的运行时异常如 `NullPointException`、`ArrayIndexOutOfBoundsException` 等。
* 非运行时异常是程序必须进行处理的异常，捕获或者抛出，如果不处理程序就不能编译通过。如常见的 `IOException`、`ClassNotFoundException` 等。






### try...catch

* `try...catch...` 处理中，可以有多个 `catch` 语句，但是只有1个能被执行。
* **多个 `catch` 存在时，其顺序非常重要。对于要捕获的异常类，要把子类放到父类前面。**

如下代码示例，`UnsupportedEncodingException` 异常是永远捕获不到的，因为它是 `IOException` 的子类。当抛出 `UnsupportedEncodingException`异常时，会被 `catch (IOException e) { ... }` 捕获并执行。


```
public static void main(String[] args) {
    try {
        process1();
        process2();
        process3();
    } catch (IOException e) {
        System.out.println("IO error");
    } catch (UnsupportedEncodingException e) { // 永远捕获不到
        System.out.println("Bad encoding");
    }
}
```

* `try...catch...finally...` 处理中，`finally` 一定会在最后执行。
* 某些情况下，可以没有 `catch`，只使用 `try ... finally` 结构





### NPE
* NPE(`Null Pointer Exception`)，即空指针异常
  
下面给出一些常见的NPE。

#### 调用equals方法产生NPE

`Object` 的 `equals` 方法容易抛空指针异常，应使用常量或确定有值的对象来调用 `equals`

```java
String str;

```
如上示例，在对字符串调用 `equals` 方法时，容易产生NPE，因为此时不确定字符串是否有值，解决方法为
1. 使用常量或确定有值的对象来调用 `equals`

```java
String str;
"testStr".equals(str);
```
2. 或者在调用 `equals` 方法前先对变量判空

```java
String str;
if(str != null){
    str.equals("testStr");
}else{
    System.out.println("字符为空!");
}
```
3. 或者直接调用 `Objects.equals` 
   
```java
Objects.equals(null,"testStr"); //false
```

查看 `java.util.Objects#equals` 源码，可以发现 `Objects.equals` 方法对接收的第1个参数进行了 `null` 的判断，因此可以避免NPE。

```java
public static boolean equals(Object a, Object b) {
    // 可以避免空指针异常。如果a==null的话此时a.equals(b)就不会得到执行，避免出现空指针异常。
    return (a == b) || (a != null && a.equals(b));
}
```


#### 调用未赋值的变量

变量创建之后未初始化赋值，后续直接调用该变量，会产生NPE。

```java
String str;
str.length();
```

为了避免这样的问题发生，需要在声明变量的时候，先给变量赋值，然后再去引用变量。

#### 对象为空却引用这个对象的方法

```java
String s = null; //对象s为空
int length = s.length();
```






## 注解

### 使用注解

注解（`Annotation`）是放在 Java 源码的类、方法、字段、参数前的一种特殊 “注释”。

注释会被编译器直接忽略，注解则可以被编译器打包进入 class 文件。因此，注解是一种用作标注的“元数据”。

定义一个注解时，可以定义配置参数。配置参数可以包括
* 所有基本类型
* String
* 枚举类型
* 基本类型、String以及枚举的数组

因为配置参数必须是常量，所以，上述限制保证了注解在定义时就已经确定了每个参数的值。

注解可以配置参数，没有指定配置的参数使用默认值。如果参数名称是 value，且只有一个参数，那么可以省略参数名称。

```
public class Hello {
    @Check(min=0, max=100, value=55)
    public int n;

    @Check(value=99)
    public int p;

    @Check(99) // @Check(value=99)
    public int x;

    @Check
    public int y;
}
```

### 注解分类
从 JVM 的角度看，注解本身对代码逻辑没有任何影响，如何使用注解完全由工具决定。Java 的注解可以分为3类

* 第1类是由编译器使用的注解，这类注解不会被编译进入 `.class`文件，它们在编译后就被编译器扔掉了。比如
    * `@Override`：让编译器检查该方法是否正确地实现了覆写
    * `@SuppressWarnings`：告诉编译器忽略此处代码产生的警告


* 第2类是由工具处理 `.class` 文件使用的注解，比如有些工具会在加载 `class` 的时候，对 `class` 做动态修改，实现一些特殊的功能。这类注解会被编译进入 `.class` 文件，但加载结束后并不会存在于内存中。这类注解只被一些底层库使用，一般我们不必自己处理。

* 第3类是在程序运行期能够读取的注解，它们在加载后一直存在于 JVM 中，这也是最常用的注解。例如，一个配置了 `@PostConstruct` 的方法会在调用构造方法后自动被调用（这是 Java 代码读取该注解实现的功能，JVM 并不会识别该注解）。


## 泛型

泛型就是编写模板代码来适应任意类型。

## 集合

参见 *Java Notes-06-Java集合* 笔记。





## 多线程

### 进程和线程
* 进程（`Process`）：在计算机中，把一个任务称为一个进程，浏览器就是一个进程，视频播放器是另一个进程，类似的，音乐播放器和Word都是进程。
* 线程（`Thread`）：操作系统调度的最小任务单位。常用的 Windows、Linux 等操作系统都采用抢占式多任务，如何调度线程完全由操作系统决定，程序自己不能决定什么时候执行，以及执行多长时间。
* 两者关系：进程包含线程，一个进程可以包含一个或多个线程，但至少会有一个线程。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/programming-2019/cs-operating-thread-1.png)


进程和线程是包含关系，但是多任务既可以由多进程实现，也可以由单进程内的多线程实现，还可以混合多进程＋多线程。

和多线程相比，多进程的缺点在于
* 创建进程比创建线程开销大，尤其是在 Windows 系统上
* 进程间通信比线程间通信要慢，因为线程间通信就是读写同一个变量，速度很快。

而多进程的优点在于
* 多进程稳定性比多线程高，因为在多进程的情况下，一个进程崩溃不会影响其他进程，而在**多线程的情况下，任何一个线程崩溃会直接导致整个进程崩溃**。


### 线程的状态

在 Java 程序中，一个线程对象只能调用一次 `start()` 方法启动新线程，并在新线程中执行 `run()` 方法。一旦 `run()` 方法执行完毕，线程就结束了。因此，Java 线程的状态有以下几种
* `New`：新创建的线程，尚未执行
* `Runnable`：运行中的线程，正在执行 `run()` 方法的Java代码
* `Blocked`：运行中的线程，因为某些操作被阻塞而挂起
* `Waiting`：运行中的线程，因为某些操作在等待中
* `Timed Waiting`：运行中的线程，因为执行 `sleep()` 方法正在计时等待
* `Terminated`：线程已终止，因为 `run()`方法执行完毕


当线程启动后，它可以在 `Runnable`、`Blocked`、`Waiting` 和 `Timed Waiting` 这几个状态之间切换，直到最后变成 `Terminated` 状态，线程终止。


## Maven


### 工程文件结构

Maven 是是专门为 Java 项目打造的管理和构建工具。一个使用Maven管理的普通的Java项目，它的目录结构默认如下

```
a-maven-project
├── pom.xml   // 项目描述文件
├── src
│   ├── main
│   │   ├── java
│   │   └── resources
│   └── test
│       ├── java
│       └── resources
└── target
```

项目描述文件 `pom.xml` 的结构如下所示

```
<project ...>
	<modelVersion>4.0.0</modelVersion>
	<groupId>com.itranswarp.learnjava</groupId>
	<artifactId>hello</artifactId>
	<version>1.0</version>
	<packaging>jar</packaging>
	<properties>
        ...
	</properties>
	<dependencies>
        <dependency>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
            <version>1.2</version>
        </dependency>
	</dependencies>
</project>
```

一个 Maven 工程，由 `groudId`，`artifactId` 和 `version`作为唯一标识
* `groudId`：类似于 Java的包名，通常是公司或组织名称
* `artifactId`：类似于 Java的类名，通常是项目名称
* `version`：版本号


### 依赖管理

Maven 通过解析依赖关系确定项目所需的 `jar` 包，常用的4种 `scope` 有
* `compile`（默认）: 编译时需要用到该 `jar` 包
* `test`: 编译 Test 时需要用到该jar包
* `runtime`: 编译时不需要，但运行时需要用到
* `provided`: 编译时需要用到，但运行时由JDK或某个服务器提供
