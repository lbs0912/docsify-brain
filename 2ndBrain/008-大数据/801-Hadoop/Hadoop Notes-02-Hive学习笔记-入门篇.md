# Hadoop Notes-02-Hive学习笔记-入门篇


[TOC]

## 更新
* 2020/03/28，撰写



## 学习资料汇总
* [Hive官网](http://hive.apache.org/)
* [一起学Hive系列文章](http://lxw1234.com/archives/2015/07/365.htm) !!
* [User Documentation - Apache Hive](https://cwiki.apache.org/confluence/display/Hive#Home-UserDocumentation)
* [Hive学习路线图谱 | 粉丝日志](http://blog.fens.me/hadoop-hive-roadmap/)
* [Hive安装及使用攻略 | 粉丝日志](http://blog.fens.me/hadoop-hive-intro/)



## Overview

> Hive是建立在 Hadoop 上的数据仓库基础构架。

Hive 是 Hadoop 家族中一款数据仓库产品，Hive 最大的特点就是提供了类 SQL 的语法，封装了底层的 MapReduce 过程，让有 SQL 基础的业务人员，也可以直接利用 Hadoop 进行大数据的操作。就是这一个点，解决了原数据分析人员对于大数据分析的瓶颈。


**Hive 可以将结构化的数据文件映射为一张数据库表，并提供完整的 SQL 查询功能，可以将 SQL 语句转换为 MapReduce 任务运行。Hive 定义了简单的类 SQL 查询语言，称为 HQL**。

Hive 构建在 Hadoop 的 HDFS 和 MapReduce 之上，用于管理和查询结构化/非结构化数据的数据仓库。
* 使用 HQL 作为查询接口
* 使用 HDFS 作为底层存储
* 使用 MapReduce 作为执行层



Hive 的知识图谱如下图所示。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hadoop-hive-roadmap.png)



Hive 已经用类 SQL 的语法封装了 MapReduce 过程，这个封装过程就是 MapReduce 的标准化的过程。

我们在做业务或者工具时，会针对场景用逻辑封装，这里的第2层封装是在Hive之上的封装。在第2层封装时，我们要尽可能多的屏蔽 Hive 的细节，让接口单一化，低少灵活性，再次精简 HQL 的语法结构。只满足我们的系统要求，专用的接口。

在使用二次封装的接口时，我们已经可以不用知道 Hive 是什么, 更不用知道 Hadoop 是什么。只需要知道，SQL查询(SQL92标准)，怎么写效率高，怎么写可以完成业务需要就可以了。

当我们完成了 Hive 的二次封装后，我们可以构建标准化的 MapReduce 开发过程。



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hive-architect-2.jpg)



Hive 不适合用于联机（`online`）事务处理，也不提供实时查询功能。它最适合用在基于大量不可变数据的批处理作业。Hive特点是可伸缩（在Hadoop的集群上动态地添加设备），可扩展，容错，输入格式的松散耦合。

Hive 的最佳使用场合是大数据集的批处理作业，例如，网络日志分析。

### Hive和关系型数据库的区别

Hive 在很多方面与传统关系数据库类似（例如支持 SQL 接口），但是其底层对 HDFS 和 MapReduce 的依赖意味着它的体系结构有别于传统关系数据库，而这些区别又影响着 Hive 所支持的特性，进而影响着 Hive 的使用。

下面列举一些简单区别
* Hive 和关系数据库存储文件的系统不同，Hive 使用的是 Hadoop 的HDFS（Hadoop的分布式文件系统），关系数据库则是服务器本地的文件系统
* Hive 使用的计算模型是 MapReduce，而关系数据库则是自己设计的计算模型
* 关系数据库都是为实时查询的业务进行设计的，而 Hive 则是为海量数据做数据挖掘设计的，实时性很差；实时性的区别导致 Hive 的应用场景和关系数据库有很大的不同
* Hive 很容易扩展自己的存储能力和计算能力，这个是继承 Hadoop 的，而关系数据库在这个方面要差很多



## Hive 安装配置
Hive 安装参考资料如下
* [Mac 上 Hive 环境搭建 | blog](https://www.cnblogs.com/micrari/p/7067968.html)
* [MacOS 下hive的安装与配置 | 知乎](https://zhuanlan.zhihu.com/p/70601668)
* [Hive安装及使用攻略 | 粉丝日志](http://blog.fens.me/hadoop-hive-intro/)
* [mac下Hive+MySql环境配置 | blog](https://jyzhangchn.github.io/hive.html)
* [Mac Hive 配置和安装 | 简书](https://www.jianshu.com/p/5c11073d19d3)

此处，简单记录Hive的安装和配置步骤


### 安装mysql

1. 通过 Homebrew 安装 mysql

```
brew install mysql
```

安装结束后，会有如下提示

```
We've installed your MySQL database without a root password. To secure it run:
    mysql_secure_installation

MySQL is configured to only allow connections from localhost by default

To connect run:
    mysql -uroot

To have launchd start mysql now and restart at login:
  brew services start mysql
Or, if you don't want/need a background service you can just run:
  mysql.server start

```

上述信息提示，
* 运行 `brew services start mysql`，可以在后台启动 mysql
* 运行 `mysql.server start`，可以在前台启动 mysql（关闭控制台，服务停止）
* 运行 `mysql_secure_installation`，可以进行密码设置


2. 使用 `mysql --version` 校验 mysql 版本号


```
mysql --version

// mysql  Ver 8.0.19 for osx10.15 on x86_64 (Homebrew)
```



3. 设置mysql秘密，设定密码为 `mysql113459`

```
brew services start mysql   //设定密码前需要先启动mysql

mysql_secure_installation
//密码设定为 mysql113459
```



MySQL 新版本中引入了密码安全级别的概念，设置低强度的密码有时会被禁止。为此可以直接指定密码安全强度，执行下述命令。


```
mysql> set global validate_password_policy=0;  //设置密码强度级别为low
mysql> set global validate_password_length=1;   //设置密码最小长度为4

mysql> SHOW VARIABLES LIKE 'validate_password%';    //查看密码相关参数设置

+--------------------------------------+--------+
| Variable_name                        | Value  |
+--------------------------------------+--------+
| validate_password.check_user_name    | ON     |
| validate_password.dictionary_file    |        |
| validate_password.length             | 8      |
| validate_password.mixed_case_count   | 1      |
| validate_password.number_count       | 1      |
| validate_password.policy             | MEDIUM |
| validate_password.special_char_count | 1      |
| validate_password_check_user_name    | ON     |
| validate_password_dictionary_file    |        |
| validate_password_length             | 4      |
| validate_password_mixed_case_count   | 1      |
| validate_password_number_count       | 1      |
| validate_password_policy             | LOW    |
| validate_password_special_char_count | 1      |
+--------------------------------------+--------+
```






若执行 `SHOW VARIABLES LIKE 'validate_password%';` 遇到 `Unknown system variable 'validate_password_policy'` 报错信息，可以参考 [MySQL validate_password_policy unknown system variable | StackOverflow](https://stackoverflow.com/questions/55237257/mysql-validate-password-policy-unknown-system-variable) 进行处理。


> This problem has happened because validate_password plugin is by default NOT activated. 

```
mysql> select plugin_name, plugin_status from information_schema.plugins where plugin_name like 'validate%';

mysql> install plugin validate_password soname 'validate_password.so';

mysql> select plugin_name, plugin_status from information_schema.plugins where plugin_name like 'validate%';

mysql> SHOW VARIABLES LIKE 'validate_password%';
```

4. mysql启动


```
brew services start mysql   //后台启动

sudo mysql.server start     //前台启动

//若遇到权限问题，可执行下述命令
sudo chmod -R a+rwx /usr/local/var/mysql
```

5. mysql关闭


```
sudo mysql.server stop
```


6. mysql重启


```
sudo mysql.server restart
```


7. 查看默认数据库


```
mysql -u root -p    //密码  mysql113459

show databases

exit  //退出mysql交互CI
```

### Hive 安装


1. 通过 Homebrew 安装 Hive

```
brew install hive
```

安装结束后，会有如下提示

```
==> Caveats
Hadoop must be in your path for hive executable to work.

If you want to use HCatalog with Pig, set $HCAT_HOME in your profile:
  export HCAT_HOME=/usr/local/opt/hive/libexec/hcatalog
==> Summary
🍺  /usr/local/Cellar/hive/3.1.2: 1,126 files, 231.8MB, built in 7 seconds

```


2. 使用 `hive --version` 校验 hive 版本号


```
lbsMacBook-Pro:~ lbs$ hive --version
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/usr/local/Cellar/hive/3.1.2/libexec/lib/log4j-slf4j-impl-2.10.0.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/Library/hadoop-2.10.0/share/hadoop/common/lib/slf4j-log4j12-1.7.25.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]
Hive 3.1.2
Git git://HW13934/Users/gates/tmp/hive-branch-3.1/hive -r 8190d2be7b7165effa62bd21b7d60ef81fb0e4af
Compiled by gates on Thu Aug 22 15:01:18 PDT 2019
From source with checksum 0492c08f784b188c349f6afb1d8d9847
```


3. hive 环境变量配置

(1) 打开配置文件

```
vim ~/.bash_profile
```

(2) 更新配置文件

```
HIVE_HOME=/usr/local/Cellar/hive/3.1.2 
HCAT_HOME=/usr/local/opt/hive/libexec/hcatalog
PATH=$PATH:${HIVE_HOME}/bin

export HIVE_HOME
export HCAT_HOME
```

(3) 使配置文件生效

```
source ~/.bash_profile
```


### 修改 Hive 默认元数据库

> 默认情况下，Hive 元数据保存在内嵌的 Derby 数据库中，只能允许一个会话连接，只适合简单的测试。实际生产环境中不使用，为了支持多用户会话，则需要一个独立的元数据库，可以使用 MySQL 作为元数据库，Hive 内部对 MySQL 提供了很好的支持。

1. Hive 将元数据存储在 `RDBMS` 中,一般常用的有 `MYSQL` 和 `DERBY`。由于 `DERBY` 只支持单客户端登录，所以一般采用 `MySql` 来存储元数据。Hive 默认元数据库是 `derby`。为了方便，这里给出用 mysql 储存元数据的配置


```
//创建数据库metastore
mysql> create database metastore; 

//创建用户名为hive，登录密码为Hive113459...的账户
mysql> create user 'hive'@'localhost' identified by 'Hive113459...'; 

//给建好的数据库添加权限
grant select,insert,update,delete,alter,create,index,references on metastore.* to 'hive'@'localhost'; 

// 刷新权限
mysql> flush privileges; 
```


### Hive 配置

1. 进入 Hive 的安装目录，创建 `hive-site.xml` 文件


```
$ cd /usr/local/Cellar/hive/3.1.2/libexec/conf
$ cp hive-default.xml.template hive-site.xml    //复制提供的模板文件 
```

在配置文件中，对以下几个属性进行修改。


```
<property>
  <name>javax.jdo.option.ConnectionURL</name>
  <value>jdbc:mysql://localhost/metastore</value>
</property>

<property>
  <name>javax.jdo.option.ConnectionDriverName</name>
  <value>com.mysql.jdbc.Driver</value>
</property>

<property>
  <name>javax.jdo.option.ConnectionUserName</name>
  <value>hive(上述mysql中创建的用户名)</value>
</property>

<property>
  <name>javax.jdo.option.ConnectionPassword</name>
  <value>Hive113459...(上述mysql中创建的用户密码)</value>
</property>

<property>
  <name>hive.exec.local.scratchdir</name>
  <value>/tmp/hive</value>
</property>

<property>
  <name>hive.querylog.location</name>
  <value>/tmp/hive</value>
</property>

<property>
  <name>hive.downloaded.resources.dir</name>
  <value>/tmp/hive</value>
</property>

<property>
  <name>hive.server2.logging.operation.log.location</name>
  <value>/tmp/hive/operation_logs</value>
</property>
```

2. 拷贝 `mysql-connector` 到 hive 的安装目录下

```
$ curl -L 'http://www.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.15.tar.gz/from/http://mysql.he.net/' | tar xz

$ cp mysql-connector-java-8.0.15/mysql-connector-java-8.0.15-bin.jar /usr/local/Cellar/hive/3.1.2/libexec/lib/
```


3. 初始化 metastore 数据库


目前直接查看 `metastore` 数据库，可以发现数据库是空的。

```
mysql> show databases;
mysql> use metastore;
mysql> show tables;   // empty
```

在命令行模式（非mysql CLI）下执行下述命令，初始化 metastore 数据库

```
$ schematool -initSchema -dbType mysql

//Initialization script completed
//schemaTool completed
```

执行完毕后，再次查看数据库，会发现如下信息

```
mysql> show tables;
+-------------------------------+
| Tables_in_metastore           |
+-------------------------------+
| AUX_TABLE                     |
| BUCKETING_COLS                |
| CDS                           |
| COLUMNS_V2                    |
| COMPACTION_QUEUE              |
| COMPLETED_COMPACTIONS         |
| COMPLETED_TXN_COMPONENTS      |
| CTLGS                         |
| DATABASE_PARAMS               |
| DB_PRIVS                      |
| DBS                           |
| DELEGATION_TOKENS             |
| FUNC_RU                       |
| FUNCS                         |
| GLOBAL_PRIVS                  |
| HIVE_LOCKS                    |
| I_SCHEMA                      |
| IDXS                          |
| INDEX_PARAMS                  |
| KEY_CONSTRAINTS               |
| MASTER_KEYS                   |
| MATERIALIZATION_REBUILD_LOCKS |
| METASTORE_DB_PROPERTIES       |
| MIN_HISTORY_LEVEL             |
| MV_CREATION_METADATA          |
| MV_TABLES_USED                |
| NEXT_COMPACTION_QUEUE_ID      |
| NEXT_LOCK_ID                  |
| NEXT_TXN_ID                   |
| NEXT_WRITE_ID                 |
| NOTIFICATION_LOG              |
| NOTIFICATION_SEQUENCE         |
| NUCLEUS_TABLES                |
| PART_COL_PRIVS                |
| PART_COL_STATS                |
| PART_PRIVS                    |
| PARTITION_EVENTS              |
| PARTITION_KEY_VALS            |
| PARTITION_KEYS                |
| PARTITION_PARAMS              |
| PARTITIONS                    |
| REPL_TXN_MAP                  |
| ROLE_MAP                      |
| ROLES                         |
| RUNTIME_STATS                 |
| SCHEMA_VERSION                |
| SD_PARAMS                     |
| SDS                           |
| SEQUENCE_TABLE                |
| SERDE_PARAMS                  |
| SERDES                        |
| SKEWED_COL_NAMES              |
| SKEWED_COL_VALUE_LOC_MAP      |
| SKEWED_STRING_LIST            |
| SKEWED_STRING_LIST_VALUES     |
| SKEWED_VALUES                 |
| SORT_COLS                     |
| TAB_COL_STATS                 |
| TABLE_PARAMS                  |
| TBL_COL_PRIVS                 |
| TBL_PRIVS                     |
| TBLS                          |
| TXN_COMPONENTS                |
| TXN_TO_WRITE_ID               |
| TXNS                          |
| TYPE_FIELDS                   |
| TYPES                         |
| VERSION                       |
| WM_MAPPING                    |
| WM_POOL                       |
| WM_POOL_TO_TRIGGER            |
| WM_RESOURCEPLAN               |
| WM_TRIGGER                    |
| WRITE_SET                     |
+-------------------------------+
74 rows in set (0.01 sec)
```


### 启动 Hive

启动Hive前，需要先运行Hadoop。之后运行 `hive` 或者 `hive shell` 可以进入Hive Shell

```
hive 

//or
 hive shell
 
 
hive>
```

### 可视化工具 DbVisualizer

* [DbVisualizer Software](https://www.dbvis.com/download/11.0)
* [DbVisualizer User Guide](http://confluence.dbvis.com/display/UG110/Installing)
* [Installing a JDBC Driver](http://confluence.dbvis.com/display/UG110/Installing+a+JDBC+Driver)
* [Supported databases and JDBC drivers Download](https://www.dbvis.com/features/database-drivers/)
* [在mac上DbVisualizer图形化客户端配置连接Hive | Blog](https://juejin.im/post/5d04675051882518e845cb8f)
* [hive-jdbc-uber-jar | github](https://github.com/timveil/hive-jdbc-uber-jar/releases)




1. 下载 `dbvis_macos_11_0_jre.dmg` 并执行安装

2. 也可以下载 `.tar.gz` 包进行安装 

```
gunzip dbvis_unix_11_0.tar.gz
tar xf dbvis_unix_11_0.tar
```

3. 点击 Docker 中 DbVisualizer图标启动，或使用如下脚本启动

```
DbVisualizer/dbvis.sh
```

4. 从 [hive-jdbc-uber-jar | github](https://github.com/timveil/hive-jdbc-uber-jar/releases) 下载 `hive-jdbc-uber-jar`，放置到 `/Users/lbs/.dbvis/jdbc` 路径下，并导入到 DbVisualizer 配置中


5. 在 DbVisualizer 的偏好设置中的 `Specify overridden Java VM Prperties here` 中添加如下设置

```
-Dsun.security.krb5.debug=true
-Djavax.security.auth.useSubjectCredsOnly=false
```



## Hive交互式模式 CLI 

运行 `hive` 或者 `hive shell` 可以进入Hive Shell。Hive的交互模式遵循下述规则。


1. `quit`,`exit`:  退出交互式shell
2. `reset`: 重置配置为默认值
3. `set <key>=<value>` : 修改特定变量的值(如果变量名拼写错误，不会报错)
4. `set` :  输出用户覆盖的 hive配置变量
5. `set -v` : 输出所有Hadoop和Hive的配置变量
6. `add FILE[S] *`, `add JAR[S] *`, `add ARCHIVE[S] *` : 添加 一个或多个 file, jar, archives到分布式缓存
7. `list FILE[S]`, `list JAR[S]`, `list ARCHIVE[S]` : 输出已经添加到分布式缓存的资源
8. `list FILE[S] *`, `list JAR[S] *`,`list ARCHIVE[S] *` : 检查给定的资源是否添加到分布式缓存
9. `delete FILE[S] *`, `delete JAR[S] *`, `delete ARCHIVE[S] *` : 从分布式缓存删除指定的资源
10. `! <command>` :  从 Hive shell 执行一个 shell 命令
11. `dfs <dfs command>` :  从 Hive shell 执行一个 dfs 命令
12. `<query string>` : 执行一个 Hive 查询，然后输出结果到标准输出
13. `source FILE <filepath>`:  在 CLI 里执行一个 hive 脚本文件
14. `!clear;`: 清除命令行
15. `show tables;`： 展示数据表
16. `desc tableName`：展示一个数据表的结构




和SQL类似，HiveQL一般是大小写不敏感的（除了字符串比较以外），因此 `show tables;` 等同于 `SHOW TABLES;`。制表符（Tab）会自动补全 Hive 的关键字和函数。


下面给出一个简单的 Hive Shell 操作 Demo，详情参考 [Hive安装及使用攻略 | 粉丝日志](http://blog.fens.me/hadoop-hive-intro/)。


* 创建本地数据文件(文本以tab分隔)

```
~ vi /home/cos/demo/t_hive.txt

16      2       3
61      12      13
41      2       31
17      21      3
71      2       31
1       12      34
11      2       34
```

* 进入Hive Shell，创建新表

```
#创建新表
hive> CREATE TABLE t_hive (a int, b int, c int) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
OK
Time taken: 0.489 seconds
```


* 查看表

```
hive> show tables;
OK
t_hive
Time taken: 0.099 seconds
```


* 正则匹配表名

```
hive>show tables '*t*';
OK
t_hive
Time taken: 0.065 seconds
```


* 查看表数据

```
hive> select * from t_hive;
OK
16      2       3
61      12      13
41      2       31
17      21      3
71      2       31
1       12      34
11      2       34
Time taken: 0.264 seconds
```

* 查看表结构

```
hive> desc t_hive;
OK
a       int
b       int
c       int
Time taken: 0.1 seconds
```
* 修改表，增加一个字段

```
hive> ALTER TABLE t_hive ADD COLUMNS (new_col String);
OK
Time taken: 0.186 seconds
hive> desc t_hive;
OK
a       int
b       int
c       int
new_col string
Time taken: 0.086 seconds
```


* 删除表

```
hive> DROP TABLE t_hadoop;
OK
Time taken: 0.767 seconds

hive> show tables;
OK
Time taken: 0.064 seconds
```


## Beeline

### HiveServer2

Hive 内置了 `HiveServer` 和 `HiveServer2` 服务，两者都允许客户端使用多种编程语言进行连接，但是 HiveServer 不能处理多个客户端的并发请求，所以产生了 `HiveServer2`。

`HiveServer2`（`HS2`）允许远程客户端可以使用各种编程语言向 Hive 提交请求并检索结果，支持多客户端并发访问和身份验证。HS2 是由多个服务组成的单个进程，其包括基于 Thrift 的 Hive 服务（TCP 或 HTTP）和用于 Web UI 的 Jetty Web 服务器。

HiveServer2 拥有自己的 CLI(`Beeline`)，Beeline 是一个基于 SQLLine 的 JDBC 客户端。由于 HiveServer2 是 Hive 开发维护的重点 (Hive0.15 后就不再支持 hiveserver)，所以 Hive CLI 已经不推荐使用了，官方更加推荐使用 Beeline。

* [Hive CLI 和 Beeline 命令行的基本使用](https://juejin.im/post/5d8593905188254009777049)


### Beeline 参数

Beeline 拥有更多可使用参数，可以使用 `beeline --help` 查看，完整参数如下

```
    // ...
    // ...
    
   Example:
    1. Connect using simple authentication to HiveServer2 on localhost:10000
    $ beeline -u jdbc:hive2://localhost:10000 username password

    2. Connect using simple authentication to HiveServer2 on hs.local:10000 using -n for username and -p for password
    $ beeline -n username -p password -u jdbc:hive2://hs2.local:10012

    3. Connect using Kerberos authentication with hive/localhost@mydomain.com as HiveServer2 principal
    $ beeline -u "jdbc:hive2://hs2.local:10013/default;principal=hive/localhost@mydomain.com"

    4. Connect using SSL connection to HiveServer2 on localhost at 10000
    $ beeline "jdbc:hive2://localhost:10000/default;ssl=true;sslTrustStore=/usr/local/truststore;trustStorePassword=mytruststorepassword"

    5. Connect using LDAP authentication
    $ beeline -u jdbc:hive2://hs2.local:10013/default <ldap-username> <ldap-password>
```


在 Hive CLI 中支持的参数，Beeline 都支持，常用的参数如下。更多参数说明可以参见官方文档 [Beeline Command Options](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-Beeline%E2%80%93NewCommandLineShell)。



| 参数 | 说明 |
| --- | --- |
| -u <database URL>	 | 数据库地址 |
| -n <username> | 用户名 |
| -p <password> | 密码 |
| -d <driver class> | 驱动 (可选) |
| -e <query> | 执行 SQL 命令 |
| -f <file> | 执行 SQL 脚本 |


例如，使用用户名和密码连接 Hive

```
// $ beeline -u jdbc:hive2://localhost:10000  -n username -p password 
$ beeline -u jdbc:hive2://localhost:10000  -n hive -p Hive113459... 
```

## Ambari

* [Ambari User Guide](http://ambari.apache.org/1.2.2/installing-hadoop-using-ambari/content/index.html)
* [Ambari——大数据平台的搭建利器](https://www.ibm.com/developerworks/cn/opensource/os-cn-bigdata-ambari/index.html)
* [Ambari——大数据平台的搭建利器之进阶篇](https://www.ibm.com/developerworks/cn/opensource/os-cn-bigdata-ambari2/)

和Hive进行交互的方式主要有2种：命令行和Ambari视图。

就 Ambari 的作用来说，就是创建、管理、监视 Hadoop 的集群，但是这里的 Hadoop 是广义，指的是 Hadoop 整个生态圈（例如 Hive，Hbase，Sqoop，Zookeeper 等），而并不仅是特指 Hadoop。用一句话来说，Ambari 就是为了让 Hadoop 以及相关的大数据软件更容易使用的一个工具。

Ambari 自身也是一个分布式架构的软件，主要由两部分组成：`Ambari Server` 和 `Ambari Agent`。简单来说，
* 用户通过 Ambari Server 通知 Ambari Agent 安装对应的软件
* Agent 会定时地发送各个机器每个软件模块的状态给 Ambari Server
* 最终这些状态信息会呈现在 Ambari 的 GUI，方便用户了解到集群的各种状态，并进行相应的维护

## Hive实战Demo
* [Hive导入10G数据的测试 | 粉丝日志](http://blog.fens.me/hadoop-hive-10g/)
* [用RHive从历史数据中提取逆回购信息 | 粉丝日志](http://blog.fens.me/finance-rhive-repurchase/)
* [网站日志统计案例分析与实现 | blog](https://www.cnblogs.com/smartloli/p/4272705.html)



## Hive架构

尽管Hive使用起来类似SQL，但它仍然不是SQL，尤其体现在处理速度方面。底层的Hive查询仍然是以 MapReduce 作业的形式运行。MapReduce是批处理，而SQL则是一种交互式处理语音。


### HCatalog
HCatalog 提供了一个统一的元数据服务，允许不同的工具如 Pig、MapReduce 等通过 HCatalog 直接访问存储在 HDFS 上的底层文件。

HCatalog 本质上是数据访问工具（如Hive或Pig）和底层文件之间的抽象层。



## Hive 数据类型

* [User Documentation - Apache Hive](https://cwiki.apache.org/confluence/display/Hive#Home-UserDocumentation)

### 基本数据类型
*  tinyint/smallint/int/bigint：整数类型
*  float/double：浮点数类型
*  boolean：布尔类型
*  string：字符串类型

`string` 类型下又包括 变长字符串 `VARCHAR` 和 定长字符串 `CHAR`。下面给出例子，说明两者区别

```
hive > create table test1
     > (vname varchar(20), cname char(20));
     > desc test1;
     
vname   varchar(20)
cname   char(20)
```

上述例子中，`varchar(20)` 表示最大长度为20，实际长度可能不足20。`char(20)` 表示长度固定为20。


### 复杂数据类型
* Array：数组，由一系列相同数据类型的元素组成
* Map：集合，包含 `key->value` 键值对，可以通过 `key` 来访问元素
* Struct：结构类型，可以包含不同数据类型的元素，这些元素可以通过 “点语法” 的方式访问


```
hive> create table student
    > (sid int,
    > sname string,
    > grade1 array<float>,
    > grade2 map<string,float>
    > info struct<name:string, age:int>);
OK
Time taken: 0.246 seconds

hive> desc student;
OK
sid                 	int
sname               	string
grade1               	array<float>
grade2                  map<string,float>
info                    struct<name:string, age:int>
Time taken: 0.077 seconds, Fetched: 5 row(s)
```


### 时间类型
* Date：从 Hive 0.12.0 开始支持
* Timestamp：从 Hive 0.8.0 开始支持




## Hive 文件格式

Hive 支持4种文件格式
1. `TextFile` （默认格式）：基于行列混合的思想
2. `SequenceFile` ：基于行存储
3. `RCFile` ：基于行存储
4. 自定义



基于 HDFS 的行存储具备快速数据加载和动态负载的高适应能力，因为行存储保证了相同记录的所有域都在同一个集群节点。但是它不能满足快速的查询响应时间的要求，因为当查询仅仅针对所有列中的少数几列时，他就不能跳过不需要的列，直接定位到所需的列。此外，行存储也不易获得一个较高的压缩比。


### TextFile
TextFile 是默认格式，数据不做压缩，磁盘开销大，数据解析开销大。可结合 Gzip，Bzip2使用。但使用这方式，Hive 不会对数据进行切分，从而无法对数据进行并行操作。


### SequenceFile

SequenceFile 是Hadoop API 提供的一种二进制文件支持，其具有使用方便，可分割，可压缩的特点。 SequenceFile 支持三种压缩选择：`NONE`, `RECORD`, `BLOCK`。`RECORD` 压缩率较低，一般建议使用 `BLOCK` 压缩。


### RCFile

RCFile 是 Facebook 开发的一个集行存储和列存储的优点于一身，压缩比更高，读取列更快。

RCFile 存储结构遵循“先水平划分，再垂直划分”的设计理念。RCFile保证同一行的数据位于同一节点，因此元组重构的开销很低。其次，像列存储一样，RCFile 能够利用列维度的数据压缩，并且能跳过不必要的列读取。


> 在 RC File 的基础上，进一步改进，引入了 ORC （`Optimized Record Columnar`），ORC 主要在压缩编码、查询性能上进行了升级。

### 自定义文件格式

当用户的数据文件格式不能被当前Hive识别的时候，可以自定义文件格式，通过实现 `InputFormat` 和 `OutputFormat` 自定义输入/输出格式。


## Hive的数据存储

Hive 的存储是建立在 Hadoop 文件系统之上的。Hive 本身没有专门的数据存储格式，也不能为数据建立索引，因此用户可以非常自由地组织 Hive 中的表，只需要在创建表的时候告诉 Hive 数据中的列分隔符就可以解析数据了。

例如，打开 `http://localhost:50070/`，选择顶部分类栏中的 `Utilities -> Browse the file system`，可以查看到 Hive 中创建的数据库表对应的文件（存储在 `/user/hive/warehouse` 路径下）。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hadoop-hive-hdfs-1.png)

### Hive的数据模型

Hive 中主要包括 4 种数据模型
1. 表（Table）
2. 外部表（External Table）
3. 分区（Partition）
4. 桶（Bucket）

Hive 的表和数据库中的表在概念上没有什么本质区别，在 Hive 中每个表都有一个对应的存储目录。而外部表指向已经在 HDFS 中存在的数据，也可以创建分区。

Hive 中的每个分区都对应数据库中相应分区列的一个索引，但是其对分区的组织方式和传统关系数据库不同。

桶在指定列进行 Hash 计算时，会根据哈希值切分数据，使每个桶对应一个文件。



#### 表
表可以细分为
1. Table 内部表
2. Partition 分区表
3. External Table 外部表
4. Bucket Table 桶表


#### 视图 View

* 视图是一种虚表，是一个逻辑概念，Hive 暂不支持物化视图
* 视图可以跨越多张表
* 视图建立在已有表的基础上，视图赖以建立的这些表称为基表
* 视图可以简化复杂的查询
* 视图 VIEW 是只读的，不支持 `LOAD/INSERT/ALTER`。可以使用 `ALTER VIEW` 改变 VIEW 定义
* Hive 支持迭代视图






## Hive 数据操作

> 在执行操作前，请确保 `localhost:50070` 页面访问到的 `Live Node` 个数大于0。


### 向表中装载数据
* [Hive之导入外部数据 | CSDN](https://blog.csdn.net/jclian91/article/details/78481673)
* [Hive 写入数据到Hive表(命令行)](http://www.tracefact.net/tech/067.html)
* [一起学Hive——详解四种导入数据的方式 | blog](http://www.bigdata17.com/2018/10/07/hiveimportdata.html)




#### Demo-Insert插入数据 

1. 创建 `hiveDemo` 数据库并使用该数据库

```
create datbase IF NOT EXISTS hiveDemo;
show databases;
use hiveDemo;
```

2. 建表/查看/删除 数据表


```
hive> Create Table golds_log(user_id bigint, accounts string, change_type string, golds bigint, log_time int);

hive> show tables;

hive> drop table golds_log;

hive> desc golds_log;
```

3. 使用 `Insert...Values` 语句写入数据

```
hive> Insert into table golds_log values
(3645356,'wds7654321(4171752)','新人注册奖励',1700,1526027152),
(2016869,'dqyx123456789(2376699)','参加一场比赛',1140,1526027152),
(3630468,'dke3776611(4156064)','大转盘奖励',1200,1526027152),
(995267,'a254413189(1229417)','妞妞拼十翻牌',200,1526027152),
(795276,'li8762866(971402)','妞妞拼十翻牌',1200,1526027152);
```



正常情况下可以看到下面的结果输出，说明在执行 `Insert...values` 语句时，底层是在执行 MapReduce 作业。



```
Query ID = lbs_20200422053833_55b98d5a-ba4c-470d-909a-098213d1d937
Total jobs = 3
Launching Job 1 out of 3
Number of reduce tasks determined at compile time: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Starting Job = job_1587504428431_0001, Tracking URL = http://localhost:8088/proxy/application_1587504428431_0001/
Kill Command = /Library/hadoop-2.10.0/bin/mapred job  -kill job_1587504428431_0001
Hadoop job information for Stage-1: number of mappers: 1; number of reducers: 1
2020-04-22 05:39:14,966 Stage-1 map = 0%,  reduce = 0%
2020-04-22 05:39:21,154 Stage-1 map = 100%,  reduce = 0%
2020-04-22 05:39:27,296 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_1587504428431_0001
Stage-4 is selected by condition resolver.
Stage-3 is filtered out by condition resolver.
Stage-5 is filtered out by condition resolver.
Moving data to directory hdfs://localhost:9000/user/hive/warehouse/hivedemo.db/golds_log/.hive-staging_hive_2020-04-22_05-38-33_916_330193107719508203-1/-ext-10000
Loading data to table hivedemo.golds_log
MapReduce Jobs Launched: 
Stage-Stage-1: Map: 1  Reduce: 1   HDFS Read: 20647 HDFS Write: 764 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
Time taken: 54.82 seconds
```




此时在 `http://localhost:50070/` 页面查看 `Utillities -> Browser the file system`，在 `/user/hive/warehouse/hivedemo.db/golds_log` 路径下可以看到一个 `000000_0` 的文件，下载到本地，查看其内容为


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hadoop-namenode-manage-web-1.png)

```
3645356 wds7654321(4171752) 新人注册奖励 1700 1526027152
2016869 dqyx123456789(2376699) 参加一场比赛 1140 1526027152
3630468 dke3776611(4156064) 大转盘奖励 1200 1526027152
995267 a254413189(1229417) 妞妞拼十翻牌 200 1526027152
795276 li8762866(971402) 妞妞拼十翻牌 1200 1526027152
```

> `000000_0` 文件是一个普通的文本文件（Hive中默认的文件存储格式），可以用 VSCode 打开。


4. 继续执行2次 `Insert...values` 命令，再次访问 `http://localhost:50070/explorer.html#/user/hive/warehouse/hivedemo.db/golds_log` 页面，可以发现有3个文件，即**每次任务都生成了单独的数据文件。**


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hadoop-namenode-manage-web-2.png)

**Hive中，每次执行 `Insert` 语句（底层执行 MapReduce 任务）都会生成独立的数据文件。对于 HDFS 来说，优势是存储少量大文件，不是存储大量小文件。**

而对于我们的应用而言，每 10 分钟就会同步一次数据到 Hive 仓库，如此一来会生成无数的小文件，系统的运行速度会越来越慢。所以第一个问题就是：如何合并小文件？


#### Demo-合并数据库小文件

在建表的时候，我们没有指定表存储的文件类型（`file format`），默认的文件类型是 `Textfile`，所以，当我们下载生成的 `000000_0` 文件后，使用编辑器可以直接查看其内容。

Hive 提供了一个 `ALTER TABLE table_name CONCATENATE` 语句，用于合并小文件。但是只支持 `RCFILE` 和 `ORC`文件类型。


因此，如果想合并小文件，可以删除表，然后再使用下面的命令重建


```
hive> drop table golds_log;
```

```
hive> Create Table golds_log(user_id bigint, accounts string, change_type string, golds bigint, log_time int)
STORED AS RCFile;
```



```
hive> Insert into table golds_log values
(3645356,'wds7654321(4171752)','新人注册奖励',1700,1526027152),
(2016869,'dqyx123456789(2376699)','参加一场比赛',1140,1526027152),
(3630468,'dke3776611(4156064)','大转盘奖励',1200,1526027152),
(995267,'a254413189(1229417)','妞妞拼十翻牌',200,1526027152),
(795276,'li8762866(971402)','妞妞拼十翻牌',1200,1526027152);
```

重复上面的过程，执行 3 次 `insert` 语句，每次插入 5 条数据。刷新 WebUI，会看到和前面一样产生 3 个文件。

> Tip: 如果此时再将 `000000_0` 文件下载下来，用文本编辑器或者 VSCode 打开查看，发现已经是乱码了。因为它已经不再是文本文件了。

接下来，执行下面的语句，对文件进行合并

```
hive> alter table golds_log concatenate;
```

输出结果如下

```
Starting Job = job_1587504428431_0006, Tracking URL = http://localhost:8088/proxy/application_1587504428431_0006/
Kill Command = /Library/hadoop-2.10.0/bin/mapred job  -kill job_1587504428431_0006
Hadoop job information for null: number of mappers: 1; number of reducers: 0
2020-04-22 06:10:40,875 null map = 0%,  reduce = 0%
2020-04-22 06:10:47,012 null map = 100%,  reduce = 0%
Ended Job = job_1587504428431_0006
Loading data to table hivedemo.golds_log
MapReduce Jobs Launched: 
Stage-null: Map: 1   HDFS Read: 3137 HDFS Write: 632 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
Time taken: 43.978 seconds
```



刷新WebUI，会发现文件已经合并了，只有一个文件存在。

最后，使用 `SELECT` 语句查看数据表的内容。

```
hive> select * from  golds_log;

OK
3645356	wds7654321(4171752)	新人注册奖励	1700	1526027152
2016869	dqyx123456789(2376699)	参加一场比赛	1140	1526027152
3630468	dke3776611(4156064)	大转盘奖励	1200	1526027152
995267	a254413189(1229417)	妞妞拼十翻牌	200	1526027152
795276	li8762866(971402)	妞妞拼十翻牌	1200	1526027152
3645356	wds7654321(4171752)	新人注册奖励	1700	1526027152
2016869	dqyx123456789(2376699)	参加一场比赛	1140	1526027152
3630468	dke3776611(4156064)	大转盘奖励	1200	1526027152
995267	a254413189(1229417)	妞妞拼十翻牌	200	1526027152
795276	li8762866(971402)	妞妞拼十翻牌	1200	1526027152
3645356	wds7654321(4171752)	新人注册奖励	1700	1526027152
2016869	dqyx123456789(2376699)	参加一场比赛	1140	1526027152
3630468	dke3776611(4156064)	大转盘奖励	1200	1526027152
995267	a254413189(1229417)	妞妞拼十翻牌	200	1526027152
795276	li8762866(971402)	妞妞拼十翻牌	1200	1526027152
Time taken: 0.133 seconds, Fetched: 15 row(s)
```


#### Demo-Load 导入外部数据

下面给出一个实例，如何将本地数据文件 `test.txt` 导入到 Hive 数据表中。

1. 本地数据文件 `test.txt` 内容如下

```
3645356|wds7654321(4171752)|新人注册奖励|1700|1526027152
2016869|dqyx123456789(2376699)|参加一场比赛|1140|1526027152
3630468|dke3776611(4156064)|大转盘奖励|1200|1526027152
3642022|黑娃123456(4168266)|新人注册奖励|500|1526027152
2016869|dqyx123456789(2376699)|大转盘奖励|1500|1526027152
```

2. 创建数据表，与本地 `test.txt` 的数据类型一致


```
hive> Create Table golds_log(user_id bigint, accounts string, change_type string, golds bigint, log_time int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|';
```
上面最重要的一句就是 `ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'`，说明表的字段由符号 `"|"` 进行分隔。

> Tip: `test.txt` 中包含有中文，确保文件格式是 `utf-8`（`GB2312` 导入后会有乱码）



3. 查看数据表的结构

```
describe golds_log;

describe formatted student1;
```

4. 查看数据表内容（此时为空）


```
select * from student1;
```

5. 导入本地数据


```
hive> load data local inpath '/Users/lbs/Downloads/test.txt' into table golds_log;

Loading data to table hivedemo.golds_log
OK
Time taken: 0.139 seconds
```

你会发现使用 `load` 语句写入数据比 `insert` 语句要快许多倍，因为 HIVE 并不对 `scheme` 进行校验，仅仅是将数据文件挪到 HDFS 系统上，也没有执行 MapReduce 作业。所以从导入数据的角度而言，使用 load 要优于使用 insert...values。





6. 再次数据表内容

```
hive> select * from golds_log;
OK
3645356	wds7654321(4171752)	新人注册奖励	1700	1526027152
2016869	dqyx123456789(2376699)	参加一场比赛	1140	1526027152
3630468	dke3776611(4156064)	大转盘奖励	1200	1526027152
3642022	黑娃123456(4168266)	新人注册奖励	500	1526027152
2016869	dqyx123456789(2376699)	大转盘奖励	1500	1526027152
Time taken: 0.087 seconds, Fetched: 5 row(s)
```


7. 反复导入 3 次后，打开 Web UI，刷新后，发现和使用 Insert 语句时一样，每次 load 语句都会生成一个数据文件，同样存在小文件的问题。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/BigData2020/hadoop-namenode-manage-web-3.png)


和前面的方法一样，我们可以将表的存储类型改为 RCFile，然后再进行合并，但是因为使用 load 语句的时候，要导入的文件类型是 txt，和表的存储类型不一致，所以会报错。

这时候，只能曲线救国了：将主表创建为 RCFile 类型，再创建一张临时表，类型是 Textfile，然后 load 时导入到临时表，然后再使用下一节要介绍的 `Insert...select` 语句，将数据从临时表导入到主表。


#### Demo-使用 Insert...Select 语句写入数据

1. 使用下面的语句创建一张临时表，临时表的名称为 `golds_log_tmp`。临时表在当前会话(`session`)结束后会被 HIVE 自动删除，临时表可以保存在SSD、内存或者是文件系统上。

```
hive> Create TEMPORARY Table golds_log_tmp(user_id bigint, accounts string, change_type string, golds bigint, log_time int)
ROW FORMAT DELIMITED  FIELDS TERMINATED BY '|';
```

2. 使用下面的语句创建主表


```
hive> drop table golds_log;
```

```
hive> Create Table golds_log(user_id bigint, accounts string, change_type string, golds bigint, log_time int)
STORED AS RCFile;
```

3. 使用下面的语句将数据导入到临时表

```
hive> load data local inpath '/Users/lbs/Downloads/test.txt' into table golds_log_tmp;
```

4. 使用insert...select语句将数据从临时表转移到主表

```
hive> Insert into table golds_log select * from golds_log_tmp;

Query ID = lbs_20200422063734_475e168a-5016-4ba7-a67f-9c7f76373f98
Total jobs = 1
Launching Job 1 out of 1
Number of reduce tasks determined at compile time: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Starting Job = job_1587504428431_0007, Tracking URL = http://localhost:8088/proxy/application_1587504428431_0007/
Kill Command = /Library/hadoop-2.10.0/bin/mapred job  -kill job_1587504428431_0007
Hadoop job information for Stage-1: number of mappers: 1; number of reducers: 1
2020-04-22 06:38:10,330 Stage-1 map = 0%,  reduce = 0%
2020-04-22 06:38:16,479 Stage-1 map = 100%,  reduce = 0%
2020-04-22 06:38:21,572 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_1587504428431_0007
Stage-4 is selected by condition resolver.
Stage-3 is filtered out by condition resolver.
Stage-5 is filtered out by condition resolver.
Moving data to directory hdfs://localhost:9000/user/hive/warehouse/hivedemo.db/golds_log/.hive-staging_hive_2020-04-22_06-37-34_112_939503175258871139-1/-ext-10000
Loading data to table hivedemo.golds_log
MapReduce Jobs Launched: 
Stage-Stage-1: Map: 1  Reduce: 1   HDFS Read: 18494 HDFS Write: 794 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
Time taken: 48.647 seconds
```

需要注意的是，`insert...select` 语句底层也会执行一个 MapReduce 作业，速度会比较慢。


5. 在多次执行 `insert...select` 后，`golds_log` 下仍然会生成多个小文件，此时，只要执行一下合并小文件的语句就可以了

```
hive> alter table golds_log concatenate;
```



## Hive 数据查询

### 表操作
Hive的数据表分为2种：内部表和外部表
1. 内部表：Hive创建并通过 LOAD DATA INPATH 进数据库的表，这种表可以理解为数据和表结构都保存在一起的数据表。当通过 `DROP TABLE table_name` 删除元数据中表结构的同时，表中的数据也同样会从 HDFS 中被删除。
2. 外部表：在表结构创建以前，数据已经保存在HDFS中，通过创建表结构，将数据格式化到表的结构里。当通过 `DROP TABLE table_name` 操作的时候，Hive 仅仅删除元数据的表结构，而不删除HDFS上的文件。所以，相比内部表，外部表可以更放心地大胆使用。


* **创建表时，`LIKE` 允许用户复制现有的表结构，但不是复制数据**

```
LIKE existing_table_name
```

* 创建表时，如果文件数据是纯文本，可以使用 `STORED AS TEXTFILE`（也是默认的格式）。如果数据需要压缩，使用 `STORED AS SEQUENCE` 
* 


* 创建表时，使用 `EXTERNAL` 声明外部表

```
CREATE EXTERNAL TABLE tablename IF NOT EXISTS tablename
```

* 数据表在删除时候，内部表会连数据一起删除，而外部表只删除表结构，数据还是保留的。


```
DROP TABLE table_name
```

* 在表查询时候，使用 `ALL` 和 `DISTINCT` 选项区分对重复记录的处理。默认是 `ALL`,表示查询所有记录，`DISTINCT` 表示去掉重复的记录。

```
SELECT age, grade FROM table;
SELECT ALL age, grade FROM table;
SELECT DISTINCT age, grade FROM table;
```


* Hive 不支持 `HAVING` 子句，可以将 HAVING 子句转化为一个子查询。



```
//Hive 不支持 HAVING 子句
SELECT  col1 FROM table GROUP BY col1 HAVING SUM(col2) > 10;


//可以改为下述子查询格式  Hive支持下述命名
SELECT  col1 FROM (SELECT col1, SUM(col2) AS col2 sum FROM table GROUP BU col1) table2 WHERE table2.col2sum > 10;
```

### 视图操作

视图 VIEW 是只读的，不支持 `LOAD/INSERT/ALTER`。可以使用 `ALTER VIEW` 改变 VIEW 定义


下面介绍下视图VIEW常见的操作语句

* 创建 VIEW 

```
CREATE  VIEW [IF NOT EXISTS] view_name
```

* 删除 VIEW 

```
DROP VIEW [IF EXISTS] view_name
```


### 索引操作

索引是标准的数据库技术。Hive 0.7 版本之后支持索引。




### GROUP BY


#### GROUP BY 1 2 3

* [What does SQL clause “GROUP BY 1” mean? | StackOverflow](https://stackoverflow.com/questions/7392730/what-does-sql-clause-group-by-1-mean)


```
SELECT account_id, open_emp_id
         ^^^^        ^^^^
          1           2
          
FROM account
GROUP BY 1;
```

在上述例子中，`GROUP BY 1` 中的 `1` 指的是 `SELECT` 语句后面的第 `1` 个列名（`coloumn`）。 上述查询语句，等价于下述查询

```
SELECT account_id, open_emp_id
FROM account
GROUP BY account_id;
```

需要注意的，在 `GROUP BY 1 2 3 4 ... index` 语法中，序号 `index` 是从 1 开始计数的。


> Note: The number in ORDER BY and GROUP BY always start with 1 not with 0.



## 聚合函数

### count(*) count(1) count(col)

#### 查询规则

* `count(*)` ：对表中行数进行统计计算，包含 `null` 值
* `count(1)` ：对表中行数进行统计计算，包含 `null` 值
* `count(col_name)`：对表中某字段的行数进行统计，不包含 `null` 值。但是如果出现空字符串，同样会进行统计



#### 查询效率


1. 如果列为主键，`count(列名)` 效率优于 `count(1)` 
2. 如果列不为主键，`count(1)` 效率优于 `count(列名)`
3. 如果有主键的话，那么 `count(主键列名)` 效率最优
4. 如果表只有一列，那么 `count(*)` 效率最优
5. **如果表有多列且不存在主键，那么 `count(1)` 比 `count(*)` 快** 




#### Demo-数据查询实例

1. 准备一个 `golds_log` 数据表，其结构如下

```
hive> desc golds_log;
OK
user_id             	bigint              	                    
accounts            	string              	                    
change_type         	string              	                    
golds               	bigint              	                    
log_time            	int                 	                    
Time taken: 0.246 seconds, Fetched: 5 row(s)
```

2. 在数据表中插入 6 条测试数据，其中 1 条数据中部分字段为 `null`


```
hive> select *  from golds_log;
OK
3645356	wds7654321(4171752)	新人注册奖励	1700	1526027152
2016869	dqyx123456789(2376699)	参加一场比赛	1140	1526027152
3630468	dke3776611(4156064)	大转盘奖励	1200	1526027152
3642022	黑娃123456(4168266)	新人注册奖励	500	1526027152
2016869	dqyx123456789(2376699)	大转盘奖励	1500	1526027152
36453522	NULL	新人注册奖励	NULL	NULL
Time taken: 0.108 seconds, Fetched: 6 row(s)
```

3. 使用 `count(*)` 对表中行数进行统计计算，包含 `null` 值


```
hive> select count(*) from golds_log;
OK
6
Time taken: 0.273 seconds, Fetched: 1 row(s)
```


4. 使用 `count(1)` 对表中行数进行统计计算，包含 `null` 值


```
hive> select count(1) from golds_log;
OK
6
Time taken: 0.091 seconds, Fetched: 1 row(s)
```

5. 使用 `count(accounts)` 对表中 `accounts` 字段的行数进行统计，`accounts` 字段记录中包含 `null` 值

```
hive> select count(accounts) from golds_log;
OK
5
Time taken: 0.103 seconds, Fetched: 1 row(s)
```


6. 使用 `count(change_type)` 对表中 `change_type` 字段的行数进行统计，`change_type` 字段记录中不包含 `null` 值


```
hive> select count(change_type) from golds_log;
OK
6
Time taken: 0.1 seconds, Fetched: 1 row(s)
```