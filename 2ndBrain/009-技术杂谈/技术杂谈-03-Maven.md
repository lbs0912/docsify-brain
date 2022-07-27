

# 技术杂谈-03-Maven 


[TOC]

## 更新
* 2020/02/07，撰写
* 2020/05/04，添加 *Maven 国内镜像加速*
* 2020/05/04，添加 *Maven 依赖冲突处理方案*
* 2020/06/07，添加 *mvn -U idea:idea | IDEA 更新不完整依赖命令*
* 2020/09/08，添加 *理解 maven 命令 package、install、deploy 的联系与区别*
* 2020/09/23，添加 *Snapshot 包和 Release 包区别*
* 2022/04/23，复习 Maven，笔记整理


## 学习资料汇总
* [你确定 Maven 相关的东西全部了解吗 | 掘金](https://juejin.cn/post/6844904182487449614)
* [项目管理利器 Maven | 慕课网](https://www.imooc.com/learn/443)
* [理解maven命令package、install、deploy的联系与区别 | CSDN](https://blog.csdn.net/zhaojianting/article/details/80324533)




## Snapshot包和Release包区别

* [Maven 中 jar 包的 Snapshot 和 Release 版本区别 | 掘金](https://juejin.im/post/6844903855860219912)



对于Snapshot 快照包，当更新时，其他系统会自动加载最新版本。

对于Release 包，当有内容更改时，其他系统必须手动。**假设第三方对 `1.0 version` 更新了，但本地有旧的 `1.0 version`，其他系统不会更新引入私服中最新的1.0。**


### SNAPSHOT快照包@JD

在国际站JSF开发过程中，修改了 `ProductBaseInfo` 类，该类位于 `com.jd.materialjsf.i18n.core` 包下。下游调用方（如通天塔等）会解析该 `core` 包中的字段，因此，在修改该 `core` 包下的文件后，需要重新发布 JAR 包，步骤如下

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/jd-base/jd-i18n-baseinfo-core-deploy-1.png)

### release包@JD

如下图所示，修改打包脚本。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/jd-base/jd-i18n-jsf-release-maven-1.png)









## 配置 Maven 环境

### 通过homebrew安装

推荐使用 homebrew 方式一键安装，系统会自动配置好 `path` 路径

* 安装 maven

```s
brew install maven
```

* 查看当前系统使用的 maven 信息

```s
lbsmacbook-pro:~ lbs$ which mvn
/usr/local/bin/mvn
```

* 查看 maven 版本号

```s
lbsmacbook-pro:~ lbs$ mvn -v

Apache Maven 3.8.5 (3599d3414f046de2324203b78ddcf9b5e4388aa0)
Maven home: /usr/local/Cellar/maven/3.8.5/libexec
Java version: 1.8.0_333, vendor: Oracle Corporation, runtime: /Library/Java/JavaVirtualMachines/jdk1.8.0_333.jdk/Contents/Home/jre
Default locale: zh_CN, platform encoding: UTF-8
OS name: "mac os x", version: "12.3.1", arch: "x86_64", family: "mac"
```

* 查看系统 `path` 变量。

```s
lbsmacbook-pro:~ lbs$ echo $PATH
/Library/Java/JavaVirtualMachines/jdk1.8.0_333.jdk/Contents/Home/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:.
```

从 `which mvn` 返回的信息可知，通过 homebew 方式安装maven时会在 `/usr/local/bin/` 路径下生产一个 `mvn` 的文件替身，而 `/usr/local/bin:` 是已经被添加在 `$PATH` 系统变量中的。所以省去了手动配置 maven 环境变量的步骤。


### 手动安装maven

* 在网站 [maven.apache.org](http://maven.apache.org/download.cgi#) 上下载 `Maven` 的压缩包，如 `apache-maven-3.6.3-bin.zip`
* 将上述压缩包解压到指定路径，如 `/Library/apache-maven-3.6.3`
* 配置环境变量，在 `.bash_profile` 文件中添加 Maven 环境变量
* 执行 `source ~/.bash_profile` 使环境配置生效，最后使用 `mvn -v` 验证 Maven 配置是否成功


```s
# 等号前后不要添加空格

M2_HOME=/Library/apache-maven-3.6.3
M2=$M2_HOME/bin
PATH=$M2:$PATH

export M2_HOME 
export M2
export PATH
```


```s
// 验证maven配置是否成功
$ mvn -v

//返回如下信息
Apache Maven 3.6.3 (cecedd343002696d0abb50b32b541b8a6ba2883f)
Maven home: /Library/apache-maven-3.6.3
Java version: 1.8.0_231, vendor: Oracle Corporation, runtime: /Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home/jre
Default locale: zh_CN, platform encoding: UTF-8
OS name: "mac os x", version: "10.15.3", arch: "x86_64", family: "mac"
```

* 若使用 IDEA 工具，可以在属性设置中的 `BuildTools/Maven` 中指定本地 Maven 路径，即  `/Library/apache-maven-3.6.3`



## 常用的构建命令

* [ref-Maven 常用命令 | blog](https://maizitoday.github.io/post/maven%E5%B8%B8%E7%94%A8%E5%91%BD%E4%BB%A4/)



* `mvn -v`: 查看 maven 版本
* `mvn compile`: 编译
* `mvn test`: 测试
* `mvn package` ： 根据 `pom.xml` 打成 `war` 或 `jar`,生成 `target` 目录，编译、测试代码，生成测试报告，生成 `jar/war`文件。 
* `mvn install`： 把 `jar` 放在本地 Repository 中
* `mvn clean`： 清除产生的项目，清除 target 目录
* `mvn jar:jar`： 只打 jar 包
* `mvn war:war`： 只打 war 包




## 自动建立项目目录骨架

使用 `archetype` 插件，可以创建符合 maven 规定的目录骨架



```s
mvn archetype:generate    //后续按照提示设置参数


// 注意，也可一次性传入配置参数
mvn archetype:generate -DgroupId=XXX -DartifactId=XXX -Dversion=XXX -Dpackage=XXX
```





执行上述命令，生成的项目目录骨架结构如下

```s

-- srv
    | -- main   //源文件
    | -- test   //测试类文件
-- pom.xml      //maven 配置文件
```

一个实际的项目目录示例如下

```s
-- srv
    | -- main
          | -- java  
                | -- com
                      | -- packageName
                               | -- ProjectName 
                                        |  -- App.java   
    | -- test
          | -- java
                | -- com
                     | -- packageName
                               | -- ProjectName 
                                        |  -- AppTest.java   
-- pom.xml     
```

## 坐标和构件


* maven 世界中，任何一个依赖，插件，项目构建输出，都可以成为构件
* maven 中，所有构件都通过坐标作为其唯一标识。
* maven中，通过 `groupId`，`artifactId` 和 `version` 确定坐标参数
    -  `groupId` = 组织名，一般为公司网址的反写 + 项目名
    -  `artifactId` = 项目名-模块名
    -  `version` = 版本号，如 `1.0.0-SNAPSHORT` 表示快照版

```xml
//pom.xml 示例
   <dependencies>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-core</artifactId>
            <version>5.2.2.RELEASE</version>
        </dependency>

        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-beans</artifactId>
            <version>5.2.2.RELEASE</version>
        </dependency>

        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>5.2.2.RELEASE</version>
        </dependency>
    </dependencies>
```

## 仓库

### 本地仓库和远程仓库
maven中的所有构件，都存储在 *仓库* 中，仓库分为2种
* 本地仓库
* 远程仓库：由maven提供，包含了绝大多数的开源Java项目

例如，在执行 `mvn compile` 构件过程中，会先在本地仓库寻找对应的依赖；若找不到，则去maven的远程仓库查找，并下载到本地仓库中。

### 镜像仓库
使用镜像仓库，将国外的仓库替换为国内的仓库，提高访问速度。

修改Maven安装目录（可以使用 `mvn -v` 查看安装路径）下的 `conf/settings.xml` 文件即可，具体如下

```xml
// 可选的国内maven镜像 地址
// <url>http://maven.net.cn/content/groups/public</url>

<mirrors>
    <!-- mirror
     | Specifies a repository mirror site to use instead of a given repository. The repository that
     | this mirror serves has an ID that matches the mirrorOf element of this mirror. IDs are used
     | for inheritance and direct lookup purposes, and must be unique across the set of mirrors.
     |
    <mirror>
      <id>mirrorId</id>
      <mirrorOf>repositoryId</mirrorOf>
      <name>Human Readable Name for this Mirror.</name>
      <url>http://my.repository.com/repo/path</url>
    </mirror>
     -->
  </mirrors>
```

## maven 生命周期


* [ref-maven生命周期](https://segmentfault.com/a/1190000020590302)



### 9个声明周期

Maven 的生命周期共 9 步
1. clean 
2. validate 
3. compile
4. test
5. package
6. verify 
7. install
8. site
9. deploy



一个完整的项目构建过程包括： 清理（`clean`），编译（`compile`），测试（`test`），打包（`package`），集成测试，验证，部署。

maven 定义了3套相互独立的生命周期，分别为
* `clean`: 用于清理项目
* `default`: 用于构建项目
* `site`: 生成项目站点

上述 3 套生命周期互相独立，每套生命周期又包含多个阶段。



### package、install和deploy的区别

* [理解maven命令package、install、deploy的联系与区别 | CSDN](https://blog.csdn.net/zhaojianting/article/details/80324533)
仔细查看上面的输出结果截图，可以发现，

**参考上述链接，图表形式解释了各个步骤的执行。**

* `mvn clean package` 依次执行了 `clean`、`resources`、`compile`、`testResources`、`testCompile`、`test`、`jar`(打包)等７个阶段。
* `mvn clean install` 依次执行了 `clean`、`resources`、`compile`、`testResources`、`testCompile`、`test`、`jar`(打包)、`install`等8个阶段。
* `mvn clean deploy` 依次执行了`clean`、`resources`、`compile`、`testResources`、`testCompile`、`test`、`jar`(打包)、`install`、`deploy` 等９个阶段。

由上面的分析可知主要区别如下
1. `package` 命令完成了项目编译、单元测试、打包功能，但没有把打好的可执行jar包（war包或其它形式的包）布署到本地 maven 仓库和远程 maven 私服仓库
2. `install` 命令完成了项目编译、单元测试、打包功能，同时把打好的可执行jar包（war包或其它形式的包）布署到本地 maven 仓库，但没有布署到远程 maven 私服仓库
3. `deploy` 命令完成了项目编译、单元测试、打包功能，同时把打好的可执行jar包（war包或其它形式的包）布署到本地 maven 仓库和远程 maven 私服仓库








### clean 清理项目
* `pre-clean`: 执行清理前的工作
* `clean`: 清理上一次构建生成的所有文件
* `post-clean`: 执行清理后的工作

### default 构建项目
* `compile`
* `test`
* `package`
* `install`

### site 生成项目站点

* `pre-site`
* `site`
* `post-site`
* `site-deploy`


## maven依赖

### scope 依赖范围

maven依赖范围:使用 `<scope>` 标签设定maven依赖范围，如下 `<scope>test</scope>` 表示只在测试环境下依赖该项。默认选择为 `compile`，表示编译，测试，运行着3种环境下都有效。

> Maven 提供了3种 `classpath`：（1）编译（2）测试（3）运行


```xml
<dependency>
    <groupId>xxx</groupId>        
    <artifactId>xxx</artifactId>
    <version>xxx</version>
    <scope>test</scope>
</dependency>
```

### 依赖传递

若A依赖B，B依赖C，那么在安装A的依赖时，在A的 `Maven Dependencies` 目录下，也会看到C。即，依赖是有传递性的。


```s
Model-A Maven Dependencies
    | --- B
    | --- C
```

使用 `<exclusion>` 可以排除依赖

```xml
<exclusions>
    <groudId>xxxA</groupId>
    <artifactId>xxxA</artifactId>
    <version>xxxA</version>
</exclusions>
```
 
如上代码所示，在 `<exclusion>` 中传入C的坐标后，再次安装依赖，在A的 `Maven Dependencies` 目录下，排除了依赖到C。


```s
Model-C Maven Dependencies
    | --- A
```

### 依赖传递遵循的2个原则

* [你确定 Maven 相关的东西全部了解吗 | 掘金](https://juejin.cn/post/6844904182487449614)

依赖传递遵循如下两个原则
1. 最短路径原则
2. 最先声明原则


#### 最短路径原则

若A依赖B，B依赖C-v2.0。同时，A依赖C-v1.0。根据最短路径原则，项目A最终依赖的是C-v1.0。



#### 最先声明原则

当最短路径一样时，遵循最先声明原则。

若A依赖C-v1.0，同时依赖C-v2.0。则在POM文件中先引入的谁，谁有效。






## Maven依赖冲突解决
* [ref-解决 Maven 依赖冲突的好帮手，必须了解一下](https://mp.weixin.qq.com/s/gvU_4JhpE87q8gt3YgnHsQ)


### 何为依赖冲突

Maven 的依赖机制可能会导致 Jar 包的冲突。举个例子
* 在项目中使用了两个 Jar 包，分别是 A 和 B。
* 现在 A 需要依赖另一个 Jar 包 C，B 也需要依赖 C。
* 但是 A 依赖的 C 的版本是 1.0，B 依赖的 C 的版本是 2.0。
* 这时候，Maven 会将这 1.0 的 C 和 2.0 的 C 都下载到你的项目中，这样你的项目中就存在了不同版本的 C。
* 这时 Maven 会依据依赖**路径最短优先原则**，来决定使用哪个版本的 Jar 包，而另一个无用的 Jar 包则未被使用，这就是所谓的依赖冲突 。


在大多数时候，依赖冲突可能并不会对系统造成什么异常，因为 Maven 始终选择了一个 Jar 包来使用。但是，不排除在某些特定条件下，会出现类似找不到类的异常。所以，只要存在依赖冲突，最好还是解决掉，不要给系统留下隐患。

### 冲突解决方法

解决依赖冲突的方法，就是使用 Maven 提供的标签 `<exclusions>` 进行处理，排除不必要的依赖。标签需要放在标签内部，如下所示

```xml
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-core</artifactId>
    <version>2.10.0</version>
    <exclusions>
        <exclusion>
            <artifactId>log4j-api</artifactId>
            <groupId>org.apache.logging.log4j</groupId>
        </exclusion>
    </exclusions>
</dependency>
```

`log4j-core` 本身是依赖了 `log4j-api` 的，但是因为一些其他的模块也依赖了 `log4j-api`，并且两个 `log4j-api` 版本不同，所以我们使用 `<exclusions>` 标签排除掉 `log4j-core` 所依赖的 `log4j-api`，这样 Maven 就不会下载 `log4j-core` 所依赖的 `log4j-api` 了，也就保证了我们的项目中只有一个版本的 `log4j-api`。


### Maven Helper

看到这里，你可能会有一个疑问 —— 如何才能知道自己的项目中哪些依赖的 Jar 包冲突了呢？

InteliJ IDEA中提供了一个 `Maven Helper` 的插件，可以帮我们解决了这个问题。



1. 在插件安装好之后，打开 `pom.xml`文件，在底部会多出一个 `Dependency Analyzer` 选项

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/maven-dependency-conflict-1.png)

2. 打开选项面板后，可以在右侧看到冲突（若存在）。找到冲突，点击右键，然后选择 `Exclude` 即可排除冲突版本的 JAR 包。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/maven-dependency-conflict-2.png)

需要注意的是，某个JAR 包可能被多次依赖，即存在多处冲突。因此，在解决一个冲突之后，需要点击 `REFRESH UI` 进行刷新，重新查看冲突。

### Maven依赖结构图

除了使用 `Maven Helper` 查看依赖冲突，也可以使用 IDEA 提供的方法—— Maven依赖结构图。


1. 打开 IDEA 右边栏 Maven 窗口，选择 Dependencies，然后点击 `Show Dependencies`，即可打开 Maven 依赖关系结构图

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/maven-dependency-conflict-3.png)

2. 在图中，若存在冲突，会看到有一些红色的实线，这些红色实线就是依赖冲突。蓝色实线则是正常的依赖。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/maven-dependency-conflict-4.png)



## Maven 国内镜像加速

* [ref-Maven国内镜像加速深度测试 | 掘金](https://juejin.im/post/5eacbfe0f265da7bf7328cf6)
* 阿里云：https://maven.aliyun.com/mvn/view
* 腾讯云：https://mirrors.cloud.tencent.com/
* 华为云：https://mirrors.huaweicloud.com/


根据上述参考文章 - [ref-Maven国内镜像加速深度测试 | 掘金](https://juejin.im/post/5eacbfe0f265da7bf7328cf6) 的测试结果，华为云的下载速度远远快于阿里云和腾讯云。此处，列出华为云的配置方法。





修改Maven安装目录（可以使用 `mvn -v` 查看安装路径）下的 `conf/settings.xml` 文件即可，具体如下。

* Maven 配置


```xml
<mirror>
    <id>huaweicloud</id>
    <mirrorOf>*</mirrorOf>
    <url>https://repo.huaweicloud.com/repository/maven/</url>
</mirror>
```

* Gradle 配置

```s
allprojects{
	repositories {
		maven {
			url 'https://repo.huaweicloud.com/repository/maven/'
		}
	}
	buildscript {
		repositories {
			maven {
				url 'https://repo.huaweicloud.com/repository/maven/'
			}
		}
	}
}
```




## FAQ

### IDEA中更新不完整依赖命令

在 IDEA 中使用 Maven 时，常常出现配置好 POM 依赖后，怎么 reimport 都无法下载 jar 包的情况。

这个时候可以使用 IDEA 中的更新不完整依赖命令 `mvn -U idea:idea` 进行解决。直接在 IDEA 的命令行中执行下述命令即可

```s
mvn -U idea:idea
```

Ref
* [解决Idea中Maven下载不来jar包问题—— mvn -U idea:idea](http://www.luyixian.cn/news_show_327252.aspx)
* [Intellij idea cannot resolve anything in maven](https://stackoverrun.com/cn/q/4269199)

