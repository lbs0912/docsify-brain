# Hadoop Notes-01-Hadoop基础入门


[TOC]

## 更新
* 2020/03/23，撰写
* 2020/03/28，添加《Hadoop 权威指南》阅读笔记
* 2020/03/29，添加《Hadoop 应用开发技术详解》阅读笔记
* 2020/04/21，添加 Hadoop 伪分布式配置


## 学习资料汇总

* [Hadoop官网](https://hadoop.apache.org/)

### 参考资料

* [BigDataGuide | github](https://github.com/Dr11ft/BigDataGuide)
* [张子阳的大数据博客](http://www.tracefact.net/tech/)
* [零基础学习 Hadoop 该如何下手？ | 知乎](https://www.zhihu.com/question/19795366)
* [Hadoop家族学习路线图 | Blog](http://blog.fens.me/hadoop-family-roadmap/)
* [在Mac上配置Hadoop娱乐环境 | Blog](https://fuhailin.github.io/Hadoop-on-MacOS/)

### 《Hadoop权威指南》随书资料
* 随书源码：[Source Code](http://www.hadoopbook.com/code.html)
* 随书数据集：[Full Dataset](http://www.hadoopbook.com/code.html)


## Hadoop基础

### Hadoop和Spark

Hadoop和Spark是两种不同的大数据处理框架，如下图所示。



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/bigdata-basic-0.png)

* 上图中的蓝色部分是Hadoop生态系统组件，黄色部分是Spark生态组件。
* 虽然它们是两种不同的大数据处理框架，但它们不是互斥的。Spark与Hadoop 中的 MapReduce 是一种相互共生的关系。
* Hadoop 提供了 Spark 许多没有的功能，比如分布式文件系统，而 Spark 提供了实时内存计算，速度非常快。

Hadoop 通常包括2个部分：存储和处理。存储部分就是Hadoop的分布式文件系统（HDFS），处理指的是MapReduce（MP）。

### Hadoop 安装和配置

* ref-1：[在Mac上配置Hadoop娱乐环境 | Blog](https://fuhailin.github.io/Hadoop-on-MacOS/)
* ref-2：[Mac OS X 上搭建 Hadoop 开发环境指南 | 知乎](https://zhuanlan.zhihu.com/p/33117305)
* ref-3: [Mac环境下Hadoop的安装与配置 | Segmentfault](https://segmentfault.com/a/1190000009103629)

#### Hadoop 安装模式

Hadoop 安装模式分为3种，分别是单机模式，伪分布模式和全分布模式。默认安装是单机模式。可以通过配置文件 `core-site.xml`，将默认的单机模式更改为伪分布模式。

> 关于Hadoop 3种安装模式和如何使用虚拟机进行分布式安装，可以参考《Hadoop应用技术详解》书籍的第2章节——Hadoop安装。

> Hadoop 的运行方式是由配置文件决定的，因此如果需要从伪分布式模式切换回非分布式模式，需要删除 `core-site.xml` 中的配置项。



1. 机器资源不足且只有一台机器的情况下，可以使用单台机器构建伪分布式集群
2. 单台机器资源充足的情况下，使用 Docker 构建一个分布式集群
3. 服务器资源充足且有多台服务器的情况下，使用 Cloudera Manager 构建一个完全的分布式集群

上面 3 种构建大数据集群方式中，主要依赖于 Docker 和 Cloudera Manager。



下面简单记录，如何通过修改配置文件，在 Mac 上搭建伪分布模式 Hadoop 环境。

#### Hadoop 安装步骤

Hadoop的安装和配置步骤如下（具体细节参考上述参考链接）
1. 安装Java。
2. Mac设置中，进入“共享”设置页面，允许远程登录，使用 `ssh localhost` 进行验证。
3. 下载Hadoop源码，在 [Hadoop官网](https://hadoop.apache.org/) 可下载，此处选择下载 `hadoop 2.10.0`。将下载的 `.tar.gz` 压缩包解压并放置到 `/Library/hadoop-2.10.0` 路径。
4. 设置Hadoop环境变量

(1) 打开配置文件

```
vim ~/.bash_profile
```

(2) 设置环境变量

```
HADOOP_HOME=/Library/hadoop-2.10.0
PATH=$PATH:${HADOOP_HOME}/bin

HADOOP_CONF_DIR=/Library/hadoop-2.10.0/etc/hadoop

HADOOP_COMMON_LIB_NATIVE_DIR=/Library/hadoop-2.10.0/lib/native

export HADOOP_HOME
export PATH

export HADOOP_CONF_DIR

export HADOOP_COMMON_LIB_NATIVE_DIR
```

(3) 使配置文件生效，并验证Hadoop版本号
```
source ~/.bash_profile

hadoop version  
```

5. 修改 Hadoop 的配置文件

需要修改的 Hadoop 配置文件都在目录 `etc/hadoop` 下，包括
* `hadoop-env.sh`
* `core-site.xml`
* `hdfs-site.xml`
* `mapred-site.xml`
* `yarn-site.xml`

下面逐步进行修改

(1) 修改 `hadoop-env.sh` 文件

```
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home
export HADOOP_HOME=/Library/hadoop-2.10.0
export HADOOP_CONF_DIR=/Library/hadoop-2.10.0/etc/hadoop
```

(2) 修改 `core-site.xml` 文件

设置 Hadoop 的临时目录和文件系统，`localhost:9000` 表示本地主机。如果使用远程主机，要用相应的 IP 地址来代替，填写远程主机的域名，则需要到 `/etc/hosts` 文件中做 DNS 映射。


```
<configuration>
  <!--localhost:9000 表示本地主机-->>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:9000</value>
  </property>

  <!--用来指定hadoop运行时产生文件的存放目录  自己创建-->
  <property>
    <name>hadoop.tmp.dir</name>
    <value>/Users/lbs/devfiles/hadoop/hadoop-2.10.0/tmp</value>
    <description>Directories for software develop and save temporary files.</description>
  </property>
</configuration>
```

(3) 修改 `hdfs-site.xml` 文件

`hdfs-site.xml` 指定了 HDFS 的默认参数副本数，因为仅运行在一个节点上（伪分布模式），所以这里的副本数为1。

```
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>    
  </property>

	<!--不是root用户也可以写文件到hdfs-->
	<property>
		<name>dfs.permissions</name>
		<value>false</value>    <!--关闭防火墙-->
	</property>
  
  <!--把路径换成本地的name位置-->
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>/Users/lbs/devfiles/hadoop/hadoop-2.10.0/tmp/dfs/name</value>
  </property>
        
  <!--在本地新建一个存放hadoop数据的文件夹，然后将路径在这里配置一下-->
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>/Users/lbs/devfiles/hadoop/hadoop-2.10.0/tmp/dfs/data</value>
  </property>
</configuration>
```

(4) 修改 `mapred-site.xml` 文件

复制 `mapred-site.xml.template` 模板文件，并修改为 `mapred-site.xml` 文件，然后将 `yarn` 设置成数据处理框架，并设置 JobTracker 的主机名与端口。


```
<configuration>
  <property>
    <!--指定mapreduce运行在yarn上-->
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
```


(5) 修改 `yarn-site.xml` 文件

配置数据的处理框架 `yarn`

```
<configuration>
  <!-- Site specific YARN configuration properties -->
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.resourcemanager.address</name>
    <value>localhost:8088</value>
  </property>
</configuration>
```


#### 启动Hadoop

(1) 第一次启动Hadoop，需要对 NameNode 进行格式化，后续启动不再需要执行此步骤。

```
hadoop namenode -format
```

(2) 启动 HDFS：进入Hadoop 安装目录下的 `sbin` 目录，并启动HDFS（需要设置Mac允许远程登录，过程中共需要3次输入密码）

> Tip: 初次安装和启动时，可以执行 `./start-all.sh`，进行必要的初始化安装


```
cd /Library/hadoop-2.10.0/sbin

./start-dfs.sh
```

若出现下述信息，表示启动成功

```
lbsMacBook-Pro:sbin lbs$ ./start-dfs.sh
Starting namenodes on [localhost]
Password:
localhost: namenode running as process 12993. Stop it first.
Password:
localhost: datanode running as process 32400. Stop it first.
Starting secondary namenodes [0.0.0.0]
Password:
0.0.0.0: Connection closed by 127.0.0.1 port 22
```

需要注意的是，在`log`中会显示警告

```
WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicabled的
```

上述提醒是关于 Hadoop 本地库的——Hadoop本地库是为了提高效率或者某些不能用Java实现的功能组件库。可以参考 [Mac OSX 下 Hadoop 使用本地库提高效率](http://rockyfeng.me/hadoop_native_library_mac.html) 了解详情。


停止 Hadoop 方法如下

```
cd /Library/hadoop-2.10.0/sbin

./sbin/stop-dfs.sh
```




(3) 在终端执行 `jps`，若看到如下信息，证明 Hadoop 可以成功启动。**看到 `DataNode`，`NameNode` 和 `SecondaryNameNode` 信息，表明启动的是一个伪分布模式Hadoop。**


```
lbsMacBook-Pro:sbin lbs$ jps

32400 DataNode
12993 NameNode
30065 BootLanguagServerBootApp
13266 SecondaryNameNode
30039 org.eclipse.equinox.launcher_1.5.700.v20200207-2156.jar
35019 ResourceManager
35117 NodeManager
32926 RunJar
35199 Jps
```

也可以访问 `http://localhost:50070/dfshealth.html#tab-overview` 来查看 Hadoop的启动情况。**看到 `Live Node` 参数，证明伪分布模式 Hadoop 启动成功。**

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hadoop-jps-live-node-1.png)




(4) 启动 yarn：进入Hadoop 安装目录下的 `sbin` 目录，并启动 yarn

```
cd /Library/hadoop-2.10.0/sbin

./start-yarn.sh
```

之后，访问 `localhost:8088` 可以查看资源管理页面，如下图所示。
 
 
![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hadoop-resource-manage-web-1.png)

至此，Hadoop的安装，配置和启动就完成啦！接下来可以通过一些 shell 命令来操作 Hadoop 下的文件了，例如

```
hadoop fs -ls /　　　　　　　 查看根目录下的文件及文件夹
hadoop fs -mkdir /test      在根目录下创建一个文件夹 testdata
hadoop fs -rm /.../...      移除某个文件
hadoop fs -rmr /...         移除某个空的文件夹
```


#### Hadoop 集群安装
* [从 0 开始使用 Docker 快速搭建 Hadoop 集群环境 | 掘金](https://juejin.im/post/58d7ef235c497d0057fea8b5#heading-5)
* [kiwenlau/hadoop-cluster-docker | github](https://github.com/kiwenlau/hadoop-cluster-docker)

此处介绍一下Mac上如何使用 Docker 安装 Hadoop 集群。

1. Mac上安装 Docker
2. 拉取 Docker 镜像，此处采用 [kiwenlau/hadoop-cluster-docker | github](https://github.com/kiwenlau/hadoop-cluster-docker) 镜像

```
sudo docker pull kiwenlau/hadoop:1.0
```

3. 拉取 git 仓库

```
git clone https://github.com/kiwenlau/hadoop-cluster-docker
```

4. 创建Hadoop网络连接


```
sudo docker network create --driver=bridge hadoop
```

5. 启动容器


```
cd hadoop-cluster-docker
sudo ./start-container.sh
```

会输出如下结果

```
start hadoop-master container...
start hadoop-slave1 container...
start hadoop-slave2 container...
root@hadoop-master:~# 
```

可以发现
* 一共启动了3个容器，一个是master，另外两个是salve
* 上述命令执行结束后，会进入master节点的根目录下


6. 启动 Hadoop

```
./start-hadoop.sh
```


7. 运行自带的词频统计Demo

```
./run-wordcount.sh
```


会看到如下输出内容

```
input file1.txt:
Hello Hadoop

input file2.txt:
Hello Docker

wordcount output:
Docker    1
Hadoop    1
Hello    2
```

8. 访问 `localhost:50070` 可以进入节点管理页面
9. 访问 `localhost:8088`  可以进入资源管理页面

#### FAQ

#####  Unable to load native-hadoop library for your platform

在启动 HDFS时，若看到如下警告

```
./start-dfs.sh
```


```
lbsMacBook-Pro:~ lbs$ cd /Library/hadoop-2.10.0/sbin

lbsMacBook-Pro:sbin lbs$ ./start-dfs.sh

20/03/23 08:46:43 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Starting namenodes on [localhost]
Password:
localhost: namenode running as process 93155. Stop it first.
Password:
localhost: datanode running as process 93262. Stop it first.
Starting secondary namenodes [0.0.0.0]
Password:
0.0.0.0: secondarynamenode running as process 93404. Stop it first.
```

上述提醒是关于 Hadoop 本地库的——Hadoop本地库是为了提高效率或者某些不能用Java实现的功能组件库。可以参考 [Mac OSX 下 Hadoop 使用本地库提高效率](http://rockyfeng.me/hadoop_native_library_mac.html) 了解详情。











## 《Hadoop 应用开发技术详解》 学习笔记


### MapReduce快速入门-WordCount


* [Intellij 开发Hadoop环境搭建 - WordCount | 简书](https://www.jianshu.com/p/35ef70dfb651)
* [使用IDEA编写第一个MapReduce程序](https://www.cnblogs.com/airnew/p/9540982.html)
* [Intellij结合Maven本地运行和调试MapReduce程序](https://www.polarxiong.com/archives/Hadoop-Intellij%E7%BB%93%E5%90%88Maven%E6%9C%AC%E5%9C%B0%E8%BF%90%E8%A1%8C%E5%92%8C%E8%B0%83%E8%AF%95MapReduce%E7%A8%8B%E5%BA%8F-%E6%97%A0%E9%9C%80%E6%90%AD%E8%BD%BDHadoop%E5%92%8CHDFS%E7%8E%AF%E5%A2%83.html)
* [一起学Hadoop——第一个MapReduce程序](https://zhuanlan.zhihu.com/p/43042078)


#### 工程创建

1. 使用IDEA创建一个基于Maven的工程——WordCount
2. 在 `pom.xml` 中添加如下依赖


```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.lbs0912</groupId>
    <artifactId>wordcount</artifactId>
    <version>1.0-SNAPSHOT</version>

    <!--添加 apache 镜像源-->
    <repositories>
        <repository>
            <id>apache</id>
            <url>http://maven.apache.org</url>
        </repository>
    </repositories>


    <!--添加如下依赖-->
    <dependencies>
        <dependency>
            <groupId>org.apache.hadoop</groupId>
            <artifactId>hadoop-core</artifactId>
            <version>1.2.1</version>
        </dependency>
        <dependency>
            <groupId>org.apache.hadoop</groupId>
            <artifactId>hadoop-common</artifactId>
            <version>2.7.2</version>
        </dependency>
    </dependencies>

</project>
```

3. 创建 `WordMapper` 类


```
package wordcount;

import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class WordMapper extends Mapper<Object, Text, Text, IntWritable> {
    IntWritable one = new IntWritable(1);
    Text word = new Text();


    public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
        StringTokenizer itr = new StringTokenizer(value.toString());
        while (itr.hasMoreTokens()) {
            word.set(itr.nextToken());
            context.write(word, one);
        }
    }
}

```


4. 创建 `WordReducer` 类

```
package wordcount;


import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class WordReducer extends Reducer<Text, IntWritable, Text, IntWritable>{
    private IntWritable result = new IntWritable();

    public void reduce(Text	key, Iterable<IntWritable> values, Context context) throws IOException,InterruptedException {
        int sum = 0;
        for(IntWritable val:values) {
            sum += val.get();
        }
        result.set(sum);
        context.write(key,result);
    }
}
```


5. 创建 `WordMain` 驱动类


```
package wordcount;


import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

public class WordMain {
    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
        /**
         * 这里必须有输入/输出
         */
        if (otherArgs.length != 2) {
            System.err.println("Usage: WordCount <in> <out>");
            System.exit(2);
        }

        Job job = new Job(conf, "wordcount");
        job.setJarByClass(WordMain.class);       //主类
        job.setMapperClass(WordMapper.class);     //Mapper
        job.setCombinerClass(WordReducer.class);  //作业合成类
        job.setReducerClass(WordReducer.class);    //Reducer
        job.setOutputKeyClass(Text.class);       //设置作业输出数据的关键类
        job.setOutputValueClass(IntWritable.class);  //设置作业输出值类
        FileInputFormat.addInputPath(job, new Path(otherArgs[0]));   //文件输入
        FileOutputFormat.setOutputPath(job, new Path(otherArgs[1]));  //文件输出
        System.exit(job.waitForCompletion(true) ? 0 : 1);   //等待完成退出
    }
}
```




#### IDEA中直接运行程序

* [Intellij 开发Hadoop环境搭建 - WordCount | 简书](https://www.jianshu.com/p/35ef70dfb651)


选择 `Run -> Edit Configurations`, 在程序参数栏目中输入 `input/ output`，如下图所示

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hadoop-wordcount-2.png)


在 `input` 目录中添加统计单词个数的测试的文件 `wordcount1.txt`

```
Hello，i love coding
are you ok?
Hello, i love hadoop
are you ok?
```

再次运行程序，会看到如下的 `output` 目录结构

```
- input
- output
    | - ._SUCCESS.crc
    | - .part-r-00000.crc
    | - ._SUCCESS
    | - part-r-00000
```

打开 `part-r-00000` 文件，即可看到单词出现次数的统计结果

```
Hello,	1
Hello，i	1
are	2
coding	1
hadoop	1
i	1
love	2
ok?	2
you	2
```

需要注意的是，由于Hadoop的设定，下次运行程序前，需要先删除output文件目录。

#### 导出jar包运行程序

1. 在 `File -> Project Structure` 选项中，为工程添加 `Artifacts`，选择 `WordMain` 类

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hadoop-wordcount-0.png)


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hadoop-wordcount-1.png)


2. 选择 `Build -> Build Artifacts...`，生成 `.jar` 文件

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hadoop-wordcount-3.png)



3. 进入HDFS系统目录(不是其余文件系统目录)，执行下述命令


```
hadoop jar WordCount.jar input/ out/
```




### HDFS分布式文件系统详解

#### 认识HDFS

HDFS（`Hadoop Distributed File System`）是一个用在普通硬件设备上的分布式文件系统。 HDFS 具有高容错性（`fault-tolerant`）和高吞吐量（`high throughput`），适合有超大数据集的应用程序，可以实现通过流的形式访问文件系统中的数据。


运行在HDFS之上的应用程序必须流式地访问它们的数据集，它不是典型的运行在常规的文件系统之上的常规程序。HDFS的设计适合批量处理，而不是用户交互式的，重点是数据吞吐量，而不是数据访问的反应时间。



HDFS以块序列的形式存储每一个文件，文件中除了最后一个块的其他块都是相同的大小。


#### HDFS架构

HDFS 为Hadoop 这个分布式计算框架一共高性能，高可靠，高可扩展的存储服务。HDFS是一个典型的主从架构，一个HDFS集群是由一个主节点（`Namenode`）和一定数目的从节点（`Datanodes`）组成。
* Namenode 是一个中心服务器，负责管理文件系统的名字空间（`namespace`）以及客户端对文件的访问。同时确定块和数据节点的映射。
    - 提供名称查询服务，它是一个 Jetty 服务器
    - 保存 `metadata` 信息，包括文件 `owership` 和 `permissions`，文件包含有哪些块，`Block` 保存在哪个 `DataNode` 等
    - NameNode 的 `metadata` 信息在启动后会加载到内存中
* Datanode一般是一个节点一个，负责管理它所在节点上的存储。**DataNode 通常以机架的形式组织，机架通过一个交换机将所有系统连接起来。** DataNode的功能包括
    - 保存Block，每个块对应一个元数据信息文件
    - 启动DataNode线程的时候会向NameNode汇报Block信息
    - 通过向NameNode发送心跳保持与其联系（3秒一次）


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hadoop-hdfs-architecture-1.png)





* 机架（`Rack`）：一个 Block 的三个副本通常会保存到两个或者两个以上的机架中，进行防灾容错
* 数据块（`Block`）是 HDFS 文件系统基本的存储单位，Hadoop 1.X 默认大小是 64MB，Hadoop 2.X 默认大小是 128MB。HDFS上的文件系统被划分为块大小的多个分块（`Chunk`）作为独立的存储单元。和其他文件系统不同的是，HDFS上小于一个块大小的文件不会占据整个块的空间。使用块抽象而非整个文件作为存储单元，大大简化了存储子系统的设计。
* 辅助元数据节点（`SecondaryNameNode`）负责镜像备份，日志和镜像的定期合并。

> 使用 `hadoop fsk / -files -blocks` 可以显示块的信息。

Block 数据块大小设置的考虑因素包括
1. 减少文件寻址时间
2. 减少管理快的数据开销，因每个快都需要在 NameNode 上有对应的记录
3. 对数据块进行读写，减少建立网络的连接成本

#### 块备份原理

Block 是 HDFS 文件系统的最小组成单元，它通过一个 `Long` 整数被唯一标识。每个 Block 会有多个副本，默认有3个副本。为了数据的安全和高效，Hadoop 默认对3个副本的存放策略如下图所示

* 第1块：在本地机器的HDFS目录下存储一个 Block
* 第2块：不同 Rack 的某个 DataNode 上存储一个 Block
* 第3块：在该机器的同一个 Rack 下的某台机器上存储一个Block

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hadoop-hdfs-architecture-block-1.png)

这样的策略可以保证对该 Block 所属文件的访问能够优先在本 Rack 下找到。如果整个 Rack 发生了异常，也可以在另外的 Rack 找到该 Block 的副本。这样足够高效，并且同时做到了数据的容错。


#### Hadoop的RPC机制

RPC（`Remote Procedure Call`）即远程过程调用机制会面临2个问题
1. 对象调用方式
2. 序列/反序列化机制


RPC 架构如下图所示。Hadoop 自己实现了简单的 RPC 组件，依赖于 `Hadoop Writable` 类型的支持。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hadoop-hdfs-architecture-rpc-1.png)

`Hadoop Writable` 接口要求每个实现类多要确保将本类的对象正确序列化（`writeObject`）和反序列化（`readObject`）。因此，Hadoop RPC 使用 Java 动态代理和反射实现对象调用方式，客户端到服务器数据的序列化和反序列化由 Hadoop框架或用户自己来实现，也就是数据组装定制的。

> Hadoop RPC = 动态代理 + 定制的二进制流


### 开源数据库HBase

#### Overview

* HBase 是一个可伸缩的分布式的，面向列的开源数据库，是一个适合于非结构化数据存储的数据库。需要注意的是，HBase 是基于列的而不是基于行的模式。
* 利用 HBase 技术可以在廉价 PC Server上搭建大规模结构化存储集群。
* HBase 是 Google Bigtable 的开源实现，与 Google Bigtable 利用GFS作为其文件存储系统类似， HBase 利用 Hadoop HDFS 作为其文件存储系统。Google 运行 MapReduce 来处理 Bigtable 中的海量数据，HBase 同样利用 Hadoop MapReduce 来处理海量数据。Google Bigtable 利用 Chubby 作为协同服务，HBase 利用 Zookeeper 作为对应。


HBase 的特点如下
1. 大：一个表可以有上亿行，上百万列
2. 面向列：面向列（族）的存储和权限控制，列（族）独立检索
3. 稀疏：对于为空（NULL）的列，并不占用存储空间，因此，表可以设计的非常稀疏。
4. 



## Hadoop 实战Demo

> 有句话说得好，“大数据胜于算法”，意思是说对于某些应用（例如根据以往的偏好来推荐电影和音乐），不论算法有多牛，基于小数据的推荐效果往往都不如基于大量可用数据的一般算法的推荐效果。 —— 《Hadoop 权威指南》


* [用Hadoop构建电影推荐系统 | 粉丝日志](http://blog.fens.me/hadoop-mapreduce-recommend/)
* [用Mahout构建职位推荐引擎 | 粉丝日志](http://blog.fens.me/hadoop-mahout-recommend-job/)


## 大数据常用组件默认端口号

* [ref-大数据常用组件默认端口号](http://www.tracefact.net/tech/076.html)


* Hadoop HDFS 

| 端口	|   配置项	|   说明  |
|-------|-----------|----------|
| 8020	 |   fs.defaultFS	  | hdfs:// 连接 | 
| 50090	  | dfs.namenode.secondary.http-address   |   |	 
| 50091	  | dfs.namenode.secondary.https-address  |   |	 
| 50010	| dfs.datanode.address	   |   |	 
| 50075	| dfs.datanode.http.address	DataNode WebUI |   |	 
| 50020	| dfs.datanode.ipc.address	  |   |	 
| 50070	| dfs.namenode.http-address	NameNode WebUI |   |	 
| 50475	| dfs.datanode.https.address	  |   |	 
| 50470	| dfs.namenode.https-address	 |   |	  
| 50100	| dfs.namenode.backup.address	  |   |	 
| 50105	| dfs.namenode.backup.http-address	  |   |	 
| 8485	| dfs.journalnode.rpc-address	  |   |	 
| 8480	| dfs.journalnode.http-address	  |   |	 
| 8481	| dfs.journalnode.https-address	  |   |	 
| 8019	| dfs.ha.zkfc.port |   |	 



* Hadoop YARN


| 端口	|   配置项	|   说明  |
|-------|-----------|----------|
| 8032	| yarn.resourcemanager.address	   |   |	 
| 8030	| yarn.resourcemanager.scheduler.address	   |   |	 
| 8088	| yarn.resourcemanager.webapp.address |	Yarn ResourceManager WebUI   |	 
| 8090	| yarn.resourcemanager.webapp.https.address	    |   |	 
| 8031	| yarn.resourcemanager.resource-tracker.address	   |   |	 
| 8033	|yarn.resourcemanager.admin.address	   |   |	 
| 8042	| 	| Yarn NodeManager WebUI    |	 
| 8044	| yarn.nodemanager.webapp.https.address	   |   |	 
| 8047	| yarn.sharedcache.admin.address	   |   |	 
| 8788	| yarn.sharedcache.webapp.address	   |   |	 
| 8046	| yarn.sharedcache.uploader.server.address	   |   |	 
| 8045	| yarn.sharedcache.client-server.address  |   |	 	 
| 8049	| yarn.nodemanager.amrmproxy.address	  |   |	  
| 8089	| yarn.router.webapp.address	   |   |	 
| 8091	| yarn.router.webapp.https.address  |   |	 


* Hadoop  MapReduce


| 端口	|   配置项	|   说明  |
|-------|-----------|----------|
| 10020	| mapreduce.jobhistory.address	  |   |	 
| 19888	| mapreduce.jobhistory.webapp.address	 |   |	 
| 19890	| mapreduce.jobhistory.webapp.https.address |   |	 


* Hive


| 端口	|   配置项	|   说明  |
|-------|-----------|----------|
| 9083	| metastore	  |   |
| 10000	| thrift	  |   |


* Zookeeper


| 端口	|   配置项	|   说明  |
|-------|-----------|----------|
| 2181	| /etc/zookeeper/conf/zoo.cfg clientPort | 	客户端连接端口 |
| 2888	| server.x	| follower连接到leader的端口  |
| 3888	| server.x	| leader选举时的端口  | 


* Spark


| 端口	|   配置项	|   说明  |
|-------|-----------|----------|
| 8080	| spark.master.ui.port	| Master WebUI | 
| 8081	| spark.worker.ui.port	| Worker WebUI | 
| 18080	| spark.history.ui.port	| History server WebUI | 
| 7077	| SPARK_MASTER_PORT	| Master port | 
| 6066	| spark.master.rest.port  | 	Master REST port| 
| 4040	| spark.ui.port	| Driver WebUI | 


* Kafka


| 端口	|   配置项	|   说明  |
|-------|-----------|----------|
| 9092	| server.properties	| 客户端连接 | 