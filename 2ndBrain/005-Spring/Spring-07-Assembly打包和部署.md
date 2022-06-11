# Spring-07-Assembly打包和部署


[TOC]



## 更新
* 2021/03/09，撰写


## 参考资料
* [SpringBoot - 使用assembly进行项目打包教程1（启动脚本、读外部配置文件）](https://www.hangge.com/blog/cache/detail_2862.html)
* [SpringBoot - 使用assembly进行项目打包教程2（将项目代码与依赖分开打包）](https://www.hangge.com/blog/cache/detail_2865.html)



## Spring Boot项目的2种部署方式

目前来说，Spring Boot 项目有如下 2 种常见的部署方式
1. 一种是使用 docker 容器去部署。将 Spring Boot 的应用构建成一个 docker image，然后通过容器去启动镜像。这种方式在需要部署大规模的应用以及对应用进行扩展时，是非常方便的，属于目前工业级的部署方案，但是需要掌握 docker 的生态圈技术。 
2. 另一种则是使用 `FatJar` 直接部署启动（将一个 jar 及其依赖的三方 jar 全部打到一个包中，这个包即为 FatJar）。这是很多初学者或者极小规模情况下的一个简单应用部署方式。  

## Assembly 的优势

上面介绍的 `Fatjar` 部署方案存在一些缺陷。因为我们如果直接构建一个 Spring Boot 的 FatJar 交由运维人员部署的话，整个配置文件都被隐藏到 jar 中，想要针对不同的环境修改配置文件就变成了一件很困难的事情。如果存在环境不确定，或者需要启动脚本启动项目的时候，这种直接通过 jar 的方式后续会需要处理很多工作。

而通过 `assembly` 将 Spring Boot 服务化打包，便能解决上面提到的 2 个问题
* 使得 Spring Boot 能够加载 jar 外的配置文件。
* 提供一个服务化的启动脚本，这个脚本一般是 shell 或者 windows 下的 bat ，有了 Spring Boot 的应用服务脚本后，就可以很容易地去启动和停止 Spring Boot 的应用了。



## 项目配置
### 添加插件

1. 编辑项目的 `pom.xml` 文件，加入 `assembly` 打包插件。


```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
        <plugin>
            <!--主要使用的是maven提供的assembly插件完成-->
            <artifactId>maven-assembly-plugin</artifactId>
            <version>3.1.1</version>
            <configuration>
                <descriptors>
                    <!--具体的配置文件-->
                    <descriptor>src/main/assembly/assembly.xml</descriptor>
                </descriptors>
            </configuration>
            <executions>
                <execution>
                    <id>make-assembly</id>
                    <!--绑定到maven操作类型上-->
                    <phase>package</phase>
                    <!--运行一次-->
                    <goals>
                        <goal>single</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>

```


2. 从上面代码可以看出，把 `assembly` 的配置都放在 `main/assembly` 目录下（具体目录里面的文件接下来会创建）。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/spring-boot-assembly-1.png)



### 编写服务启动/停止脚本

1. 在 `assembly` 目录下创建一个 `bin` 文件夹
2. 在该文件夹下创建一个 `start.sh` 文件，这个是 linux 环境下的启动脚本，具体内容如下。

> 开头的项目名称、jar 包名称不用我们手动设置，这里使用参数变量，在项目打包后这些参数自动会替换为 pom 的 `profiles` 中 `properties` 的值（assembly 配置文件需要开启属性替换功能），下面另外两个配置文件也同理。



```s
#!/bin/bash

# 项目名称
SERVER_NAME="${project.artifactId}"

# jar名称
JAR_NAME="${project.build.finalName}.jar"

# 进入bin目录
cd `dirname $0`
# bin目录绝对路径
BIN_DIR=`pwd`
# 返回到上一级项目根目录路径
cd ..
# 打印项目根目录绝对路径
# `pwd` 执行系统命令并获得结果
DEPLOY_DIR=`pwd`

# 外部配置文件绝对目录,如果是目录需要/结尾，也可以直接指定文件
# 如果指定的是目录,spring则会读取目录中的所有配置文件
CONF_DIR=$DEPLOY_DIR/config
# SERVER_PORT=`sed '/server.port/!d;s/.*=//' config/application.properties | tr -d '\r'`
# 获取应用的端口号
SERVER_PORT=`sed -nr '/port: [0-9]+/ s/.*port: +([0-9]+).*/\1/p' config/application.yml`

PIDS=`ps -f | grep java | grep "$CONF_DIR" |awk '{print $2}'`
if [ "$1" = "status" ]; then
    if [ -n "$PIDS" ]; then
        echo "The $SERVER_NAME is running...!"
        echo "PID: $PIDS"
        exit 0
    else
        echo "The $SERVER_NAME is stopped"
        exit 0
    fi
fi

if [ -n "$PIDS" ]; then
    echo "ERROR: The $SERVER_NAME already started!"
    echo "PID: $PIDS"
    exit 1
fi

if [ -n "$SERVER_PORT" ]; then
    SERVER_PORT_COUNT=`netstat -tln | grep $SERVER_PORT | wc -l`
    if [ $SERVER_PORT_COUNT -gt 0 ]; then
        echo "ERROR: The $SERVER_NAME port $SERVER_PORT already used!"
        exit 1
    fi
fi

# 项目日志输出绝对路径
LOGS_DIR=$DEPLOY_DIR/logs
# 如果logs文件夹不存在,则创建文件夹
if [ ! -d $LOGS_DIR ]; then
    mkdir $LOGS_DIR
fi
STDOUT_FILE=$LOGS_DIR/catalina.log

# JVM Configuration
JAVA_OPTS=" -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true "
JAVA_DEBUG_OPTS=""
if [ "$1" = "debug" ]; then
    JAVA_DEBUG_OPTS=" -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n "
fi

JAVA_JMX_OPTS=""
if [ "$1" = "jmx" ]; then
    JAVA_JMX_OPTS=" -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false "
fi

JAVA_MEM_OPTS=""
BITS=`java -version 2>&1 | grep -i 64-bit`
if [ -n "$BITS" ]; then
    JAVA_MEM_OPTS=" -server -Xmx512m -Xms512m -Xmn256m -XX:PermSize=128m -Xss256k -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 "
else
    JAVA_MEM_OPTS=" -server -Xms512m -Xmx512m -XX:PermSize=128m -XX:SurvivorRatio=2 -XX:+UseParallelGC "
fi

# 加载外部log4j2文件的配置
LOG_IMPL_FILE=log4j2.xml
LOGGING_CONFIG=""
if [ -f "$CONF_DIR/$LOG_IMPL_FILE" ]
then
    LOGGING_CONFIG="-Dlogging.config=$CONF_DIR/$LOG_IMPL_FILE"
fi
CONFIG_FILES=" -Dlogging.path=$LOGS_DIR $LOGGING_CONFIG -Dspring.config.location=$CONF_DIR/ "
echo -e "Starting the $SERVER_NAME ..."
nohup java $JAVA_OPTS $JAVA_MEM_OPTS $JAVA_DEBUG_OPTS $JAVA_JMX_OPTS $CONFIG_FILES -jar $DEPLOY_DIR/lib/$JAR_NAME > $STDOUT_FILE 2>&1 &

COUNT=0
while [ $COUNT -lt 1 ]; do
    echo -e ".\c"
    sleep 1
    if [ -n "$SERVER_PORT" ]; then
        COUNT=`netstat -an | grep $SERVER_PORT | wc -l`
    else
       COUNT=`ps -f | grep java | grep "$DEPLOY_DIR" | awk '{print $2}' | wc -l`
    fi
    if [ $COUNT -gt 0 ]; then
        break
    fi
done


echo "OK!"
PIDS=`ps -f | grep java | grep "$DEPLOY_DIR" | awk '{print $2}'`
echo "PID: $PIDS"
echo "STDOUT: $STDOUT_FILE"

```



3. 创建一个 `stop.sh` 文件，这个是 linux 环境下的停止脚本，具体内容如下。


```s
#!/bin/bash

# 项目名称
APPLICATION="${project.artifactId}"

# 项目启动jar包名称
APPLICATION_JAR="${project.build.finalName}.jar"

# 通过项目名称查找到PI，然后kill -9 pid
PID=$(ps -ef | grep "${APPLICATION_JAR}" | grep -v grep | awk '{ print $2 }')
if [[ -z "$PID" ]]
then
    echo ${APPLICATION} is already stopped
else
    echo kill  ${PID}
    kill -9 ${PID}
    echo ${APPLICATION} stopped successfully
fi
```


4. 创建一个 `start.bat` 文件，这个是 Windows 环境下的启动脚本，具体内容如下。



```s
echo off
 
set APP_NAME=${project.build.finalName}.jar
set LOG_IMPL_FILE=log4j2.xml
set LOGGING_CONFIG=
if exist ../config/%LOG_IMPL_FILE% (
    set LOGGING_CONFIG=-Dlogging.config=../config/%LOGGING_CONFIG%
)
set CONFIG= -Dlogging.path=../logs %LOGGING_CONFIG% -Dspring.config.location=../config/
 
set DEBUG_OPTS=
if ""%1"" == ""debug"" (
   set DEBUG_OPTS= -Xloggc:../logs/gc.log -verbose:gc -XX:+PrintGCDetails -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=../logs
   goto debug
)
 
set JMX_OPTS=
if ""%1"" == ""jmx"" (
   set JMX_OPTS= -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9888 -Dcom.sun.management.jmxremote.ssl=FALSE -Dcom.sun.management.jmxremote.authenticate=FALSE
   goto jmx
)
 
echo "Starting the %APP_NAME%"
java -Xms512m -Xmx512m -server %DEBUG_OPTS% %JMX_OPTS% %CONFIG% -jar ../lib/%APP_NAME%
echo "java -Xms512m -Xmx512m -server %DEBUG_OPTS% %JMX_OPTS% %CONFIG% -jar ../lib/%APP_NAME%"
goto end
 
:debug
echo "debug"
java -Xms512m -Xmx512m -server %DEBUG_OPTS% %CONFIG% -jar ../lib/%APP_NAME%
goto end
 
:jmx
java -Xms512m -Xmx512m -server %JMX_OPTS% %CONFIG% -jar ../lib/%APP_NAME%
goto end
 
:end
pause
```



### 创建打包配置文件


我们在 assembly 文件夹下创建一个 `assembly.xml` 配置文件，具体内容如下。



```xml
<assembly>
    <!--
        必须写，否则打包时会有 assembly ID must be present and non-empty 错误
        这个名字最终会追加到打包的名字的末尾，如项目的名字为 hangge-test-0.0.1-SNAPSHOT,
        则最终生成的包名为 hangge-test-0.0.1-SNAPSHOT-bin.tar.gz
     -->
    <id>bin</id>
    <!-- 打包的类型，如果有N个，将会打N个类型的包 -->
    <formats>
        <format>tar.gz</format>
        <!--<format>zip</format>-->
    </formats>
    <includeBaseDirectory>true</includeBaseDirectory>
    <!--文件设置-->
    <fileSets>
        <!--
            0755->即用户具有读/写/执行权限，组用户和其它用户具有读写权限；
            0644->即用户具有读写权限，组用户和其它用户具有只读权限；
        -->
        <!-- 将src/main/assembly/bin目录下的所有文件输出到打包后的bin目录中 -->
        <fileSet>
            <directory>src/main/assembly/bin</directory>
            <outputDirectory>bin</outputDirectory>
            <fileMode>0755</fileMode>
            <!--如果是脚本，一定要改为unix.如果是在windows上面编码，会出现dos编写问题-->
            <lineEnding>unix</lineEnding>
            <filtered>true</filtered><!-- 是否进行属性替换 -->
        </fileSet>
        <!-- 将src/main/assembly/config目录下的所有文件输出到打包后的config目录中 -->
        <fileSet>
            <directory>src/main/assembly/config</directory>
            <outputDirectory>config</outputDirectory>
            <fileMode>0644</fileMode>
        </fileSet>
        <!-- 将src/main/resources下配置文件打包到config目录 -->
        <fileSet>
            <directory>src/main/resources</directory>
            <outputDirectory>/config</outputDirectory>
            <includes>
                <include>**/*.xml</include>
                <include>**/*.properties</include>
                <include>**/*.yml</include>
            </includes>
            <filtered>true</filtered><!-- 是否进行属性替换 -->
        </fileSet>
        <!-- 将项目启动jar打包到lib目录中 -->
        <fileSet>
            <directory>target</directory>
            <outputDirectory>lib</outputDirectory>
            <includes>
                <include>*.jar</include>
            </includes>
        </fileSet>
        <!-- 将项目说明文档打包到docs目录中 -->
        <fileSet>
            <directory>.</directory>
            <outputDirectory>docs</outputDirectory>
            <includes>
                <include>*.md</include>
            </includes>
            <fileMode>0644</fileMode>
        </fileSet>
        <fileSet>
            <directory>docs</directory>
            <outputDirectory>docs</outputDirectory>
            <fileMode>0644</fileMode>
        </fileSet>
        <fileSet>
            <directory>src/main/assembly/docs</directory>
            <outputDirectory>docs</outputDirectory>
            <fileMode>0644</fileMode>
        </fileSet>
      </fileSets>
  </assembly>
```


## 打包测试

### 打包项目

1. 我们使用 `mvn package` 命令对项目进行打包。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/spring-boot-assembly-2.png)



2. 打包后在 `target` 下便会生成一个名为 `xxx.tar.gz` 的压缩文件。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/spring-boot-assembly-3.png)


3. 将这个压缩包解压后可以看到内部包含的目录如下。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/spring-boot-assembly-4.png)



### 启动服务

1. 上述打包文件解压后，在 bin 目录有如下几个启动文件
   * Linux、macOS 系统：执行 `start.sh` 启动服务，执行 `stop.sh` 停止服务。
   * Windows 系统：双击 `start.bat` 即可启动服务


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/spring-boot-assembly-5.png)



2. 服务启动后，相应的日志文件会生成到 logs 目录下（logs 目录会自动创建）


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/spring-boot-assembly-6.png)


### 修改配置

1. 修改 `config` 文件夹下面的配置文件，此处的配置文件是 `application.properties`。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/spring-boot-assembly-7.png)


2. 这里我们将服务端口改成 9090。


```s
server.port=9090
```

3. 重启服务，可以看到端口确实发生了变化，说明外部配置文件加载成功。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/spring-boot-assembly-8.png)





## 将项目与依赖分开打包

至此，上文中介绍的使用 assembly 对项目打包时，项目代码和项目所有的依赖文件会一起打成一个可执行的 jar 包。

如果项目的依赖包很多，那么这个文件就会非常大。每次发布版本如果都要上传这个整个的 jar 包，既浪费带宽也浪费时间。

下面介绍如何将项目的外部依赖跟自己的代码包分开打包，这样当项目修改后，只需要上传覆盖修改后的包即可。


### 修改配置


1. 首先我们编辑 `assembly.xml` 配置文件。在前文的基础上新增第三方依赖设置，实现将第三方的 jar 包添加到压缩包里的 lib 目录。


```xml
<assembly>
    <!--
        必须写，否则打包时会有 assembly ID must be present and non-empty 错误
        这个名字最终会追加到打包的名字的末尾，如项目的名字为 hangge-test-0.0.1-SNAPSHOT,
        则最终生成的包名为 hangge-test-0.0.1-SNAPSHOT-bin.tar.gz
     -->
    <id>bin</id>
    <!-- 打包的类型，如果有N个，将会打N个类型的包 -->
    <formats>
        <format>tar.gz</format>
        <!--<format>zip</format>-->
    </formats>
    <includeBaseDirectory>true</includeBaseDirectory>
 
    <!--第三方依赖设置-->
    <dependencySets>
        <dependencySet>
            <!-- 不使用项目的artifact，第三方jar不要解压，打包进zip文件的lib目录 -->
            <useProjectArtifact>false</useProjectArtifact>
            <outputDirectory>lib</outputDirectory>
            <unpack>false</unpack>
        </dependencySet>
    </dependencySets>
 
    <!--文件设置-->
    <fileSets>
        <!--
            0755->即用户具有读/写/执行权限，组用户和其它用户具有读写权限；
            0644->即用户具有读写权限，组用户和其它用户具有只读权限；
        -->
        <!-- 将src/main/assembly/bin目录下的所有文件输出到打包后的bin目录中 -->
        <fileSet>
            <directory>src/main/assembly/bin</directory>
            <outputDirectory>bin</outputDirectory>
            <fileMode>0755</fileMode>
            <!--如果是脚本，一定要改为unix.如果是在windows上面编码，会出现dos编写问题-->
            <lineEnding>unix</lineEnding>
            <filtered>true</filtered><!-- 是否进行属性替换 -->
        </fileSet>
        <!-- 将src/main/assembly/config目录下的所有文件输出到打包后的config目录中 -->
        <fileSet>
            <directory>src/main/assembly/config</directory>
            <outputDirectory>config</outputDirectory>
            <fileMode>0644</fileMode>
        </fileSet>
        <!-- 将src/main/resources下配置文件打包到config目录 -->
        <fileSet>
            <directory>src/main/resources</directory>
            <outputDirectory>/config</outputDirectory>
            <includes>
                <include>**/*.xml</include>
                <include>**/*.properties</include>
                <include>**/*.yml</include>
            </includes>
            <filtered>true</filtered><!-- 是否进行属性替换 -->
        </fileSet>
        <!-- 将项目启动jar打包到lib目录中 -->
        <fileSet>
            <directory>target</directory>
            <outputDirectory>lib</outputDirectory>
            <includes>
                <include>*.jar</include>
            </includes>
        </fileSet>
        <!-- 将项目说明文档打包到docs目录中 -->
        <fileSet>
            <directory>.</directory>
            <outputDirectory>docs</outputDirectory>
            <includes>
                <include>*.md</include>
            </includes>
            <fileMode>0644</fileMode>
        </fileSet>
        <fileSet>
            <directory>docs</directory>
            <outputDirectory>docs</outputDirectory>
            <fileMode>0644</fileMode>
        </fileSet>
        <fileSet>
            <directory>src/main/assembly/docs</directory>
            <outputDirectory>docs</outputDirectory>
            <fileMode>0644</fileMode>
        </fileSet>
      </fileSets>
  </assembly>
```


2. 接着编辑项目的 `pom.xml` 文件，先前使用的是 `spring-boot-maven-plugin` 来打包，这个插件会将项目所有的依赖打入项目 jar 包里面。我们将其替换为 `maven-jar-plugin`，并进行相关设置。


```xml
<build>
    <plugins>
        <!-- 指定启动类，将依赖打成外部jar包 -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-jar-plugin</artifactId>
            <configuration>
                <archive>
                    <!-- 生成的jar中，不要包含pom.xml和pom.properties这两个文件 -->
                    <addMavenDescriptor>false</addMavenDescriptor>
                    <manifest>
                        <!-- 是否要把第三方jar加入到类构建路径 -->
                        <addClasspath>true</addClasspath>
                        <!-- 外部依赖jar包的最终位置 -->
                        <!-- 因为我们将第三方jar和本项目jar放在同一个目录下，这里就使用./ -->
                        <classpathPrefix>./</classpathPrefix>
                        <!-- 项目启动类 -->
                        <mainClass>com.example.hanggetest.HanggeTestApplication</mainClass>
                    </manifest>
                </archive>
            </configuration>
        </plugin>
        <plugin>
            <!--主要使用的是maven提供的assembly插件完成-->
            <artifactId>maven-assembly-plugin</artifactId>
            <version>3.1.1</version>
            <configuration>
                <descriptors>
                    <!--具体的配置文件-->
                    <descriptor>src/main/assembly/assembly.xml</descriptor>
                </descriptors>
            </configuration>
            <executions>
                <execution>
                    <id>make-assembly</id>
                    <!--绑定到maven操作类型上-->
                    <phase>package</phase>
                    <!--运行一次-->
                    <goals>
                        <goal>single</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>

```



### 打包测试

上面两个配置修改完毕后，我们重新对项目进行打包。将生成的压缩包解压后可以发现，`lib` 文件夹下项目 `jar` 包以及第三方 `jar` 都分开了，并且项目 jar 体积也十分小巧。




![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/spring-boot-assembly-9.png)