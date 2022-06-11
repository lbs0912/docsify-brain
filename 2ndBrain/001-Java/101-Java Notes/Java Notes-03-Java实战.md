
# Java Notes-03-Java实战

[TOC]

## 更新
* 2020/05/12，撰写
* 2020/05/12，添加 Swagger 使用说明
* 2020/05/12，添加 *Java 反编译操作*
* 2020/05/20，添加 *fastjson 使用*
* 2020/06/14，添加 *JMH 使用*





## 学习资料
* [在 Spring Boot 项目中使用 Swagger 文档 | IBM 文档](https://www.ibm.com/developerworks/cn/java/j-using-swagger-in-a-spring-boot-project/index.html)
* [GitHub上最牛逼的10个Java项目](https://zhuanlan.zhihu.com/p/120913117)
* [JMH | Oracle官方推荐的性能测试工具](https://mp.weixin.qq.com/s?__biz=MzU1NTkwODE4Mw==&mid=2247486145&idx=1&sn=06e9e09018787f968fa05577e2663b42&scene=21#wechat_redirect)



## Java开源项目推荐

* [GitHub上最牛逼的10个Java项目](https://zhuanlan.zhihu.com/p/120913117)


1. [CS-Notes](https://cyc2018.github.io/CS-Notes/#/)
2. JavaGuide
3. java-design-patterns
4. elasticsearch
5. SpringBoot
6. interviews
7. RxJava
8. advanced-java
9. okhttp
10. guava



## JMH

* [JMH | Oracle官方推荐的性能测试工具](https://mp.weixin.qq.com/s?__biz=MzU1NTkwODE4Mw==&mid=2247486145&idx=1&sn=06e9e09018787f968fa05577e2663b42&scene=21#wechat_redirect)



### Overview

JMH(`Java Microbenchmark Harness`)是用于代码微基准测试的工具套件，主要是基于方法层面的基准测试，精度可以达到纳秒级。

当你定位到热点方法，希望进一步优化方法性能的时候，就可以使用 JMH 对优化的结果进行量化的分析。

JMH 比较典型的应用场景如下
* 想准确地知道某个方法需要执行多长时间，以及执行时间和输入之间的相关性
* 对比接口不同实现在给定条件下的吞吐量
* 查看多少百分比的请求在多长时间内完成

下面以字符串拼接的两种方法为例子使用 JMH 做基准测试。


### 加入依赖

因为 JMH 是 JDK9 自带的，如果是 JDK9 之前的版本需要加入如下依赖（目前 JMH 的最新版本为 1.23）


```xml
<dependency>
    <groupId>org.openjdk.jmh</groupId>
    <artifactId>jmh-core</artifactId>
    <version>1.23</version>
</dependency>
<dependency>
    <groupId>org.openjdk.jmh</groupId>
    <artifactId>jmh-generator-annprocess</artifactId>
    <version>1.23</version>
</dependency>
```


### 编写基准测试

接下来，创建一个 JMH 测试类，用来判断 `+` 和 `StringBuilder.append()` 两种字符串拼接哪个耗时更短，具体代码如下所示


```java
@BenchmarkMode(Mode.AverageTime)
@Warmup(iterations = 3, time = 1)
@Measurement(iterations = 5, time = 5)
@Threads(4)
@Fork(1)
@State(value = Scope.Benchmark)
@OutputTimeUnit(TimeUnit.NANOSECONDS)
public class SpringbootDemoApplication {

    @Param(value = {"10","50","100"})
    private  int length;

    public static void main(String[] args) throws Exception {
        SpringApplication.run(SpringbootDemoApplication.class, args);
        System.out.println("Spring Server is running...");

        Options options = new OptionsBuilder()
                .include(SpringbootDemoApplication.class.getSimpleName())
                .result("result.json")
                .resultFormat(ResultFormatType.JSON)
                .build();
        new Runner(options).run();
    }
    @Benchmark
    public void testStringAdd(Blackhole blackhole){
        String a= "";
        for(int i=0;i<length;i++){
            a += i;
        }
        blackhole.consume(a);

    }


    @Benchmark
    public void testStringBuilderAdd(Blackhole blackhole) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            sb.append(i);
        }
        blackhole.consume(sb.toString());
    }
}
```


在 `main()` 函数中，首先对测试用例进行配置，使用 `Builder` 模式配置测试，将配置参数存入 `Options` 对象，并使用 `Options` 对象构造 `Runner` 启动测试。

其中需要测试的方法用 `@Benchmark` 注解标识，这些注解的具体含义将在下面介绍。


### 执行基准测试

准备工作做好了，接下来，运行代码，等待片刻，测试结果就出来了，下面对结果做下简单说明。


1. 下面信息为测试的基本信息，比如使用的 Java 路径，预热代码的迭代次数，测量代码的迭代次数，使用的线程数量，测试的统计单位等。


```
# JMH version: 1.23
# VM version: JDK 1.8.0_201, Java HotSpot(TM) 64-Bit Server VM, 25.201-b09
# VM invoker: D:\Software\Java\jdk1.8.0_201\jre\bin\java.exe
# VM options: -javaagent:D:\Software\JetBrains\IntelliJ IDEA 2019.1.3\lib\idea_rt.jar=61018:D:\Software\JetBrains\IntelliJ IDEA 2019.1.3\bin -Dfile.encoding=UTF-8
# Warmup: 3 iterations, 1 s each
# Measurement: 5 iterations, 5 s each
# Timeout: 10 min per iteration
# Threads: 4 threads, will synchronize iterations
# Benchmark mode: Average time, time/op
# Benchmark: com.wupx.jmh.StringConnectTest.testStringBuilderAdd
# Parameters: (length = 100)
```

2.下面部分为每一次热身中的性能指标，预热测试不会作为最终的统计结果。预热的目的是让 JVM 对被测代码进行足够多的优化，比如，在预热后，被测代码应该得到了充分的 JIT 编译和优化。

```
# Warmup Iteration   1: 1083.569 ±(99.9%) 393.884 ns/op
# Warmup Iteration   2: 864.685 ±(99.9%) 174.120 ns/op
# Warmup Iteration   3: 798.310 ±(99.9%) 121.161 ns/op
```

3. 下面部分显示测量迭代的情况，每一次迭代都显示了当前的执行速率，即一个操作所花费的时间。在进行 5 次迭代后，进行统计。在本例中，`length` 为 100 的情况下 `testStringBuilderAdd` 方法的平均执行花费时间为 819.329 ns，误差为 72.698 ns。

```
Iteration   1: 810.667 ±(99.9%) 51.505 ns/op
Iteration   2: 807.861 ±(99.9%) 13.163 ns/op
Iteration   3: 851.421 ±(99.9%) 33.564 ns/op
Iteration   4: 805.675 ±(99.9%) 33.038 ns/op
Iteration   5: 821.020 ±(99.9%) 66.943 ns/op

Result "com.wupx.jmh.StringConnectTest.testStringBuilderAdd":
  819.329 ±(99.9%) 72.698 ns/op [Average]
  (min, avg, max) = (805.675, 819.329, 851.421), stdev = 18.879
  CI (99.9%): [746.631, 892.027] (assumes normal distribution)

Benchmark                               (length)  Mode  Cnt     Score     Error  Units
StringConnectTest.testStringBuilderAdd       100  avgt    5   819.329 ±  72.698  ns/op
```


4. 下面部分为最后的测试结果。

```
Benchmark                               (length)  Mode  Cnt     Score     Error  Units
StringConnectTest.testStringAdd               10  avgt    5   161.496 ±  17.097  ns/op
StringConnectTest.testStringAdd               50  avgt    5  1854.657 ± 227.902  ns/op
StringConnectTest.testStringAdd              100  avgt    5  6490.062 ± 327.626  ns/op
StringConnectTest.testStringBuilderAdd        10  avgt    5    68.769 ±   4.460  ns/op
StringConnectTest.testStringBuilderAdd        50  avgt    5   413.021 ±  30.950  ns/op
StringConnectTest.testStringBuilderAdd       100  avgt    5   819.329 ±  72.698  ns/op
```

5. 结果表明，在拼接字符次数越多的情况下，`StringBuilder.append()` 的性能就更好。


### 生成jar包执行


对于一些小测试，直接用上面的方式写一个 main 函数手动执行就好了。

对于大型的测试，需要测试的时间比较久、线程数比较多，加上测试的服务器需要，一般要放在 Linux 服务器里去执行。

JMH 官方提供了生成 `jar` 包的方式来执行，我们需要在 maven 里增加一个 `plugin`，具体配置如下

```xml
<plugins>
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-shade-plugin</artifactId>
        <version>2.4.1</version>
        <executions>
            <execution>
                <phase>package</phase>
                <goals>
                    <goal>shade</goal>
                </goals>
                <configuration>
                    <finalName>jmh-demo</finalName>
                    <transformers>
                        <transformer
                                implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                            <mainClass>org.openjdk.jmh.Main</mainClass>
                        </transformer>
                    </transformers>
                </configuration>
            </execution>
        </executions>
    </plugin>
</plugins>
```

接着执行 maven 的命令生成可执行 jar 包并执行

```
mvn clean install
java -jar target/jmh-demo.jar StringConnectTest
```



### JMH基础


为了能够更好地使用 JMH 的各项功能，下面对 JMH 的基本概念进行讲解

#### @BenchmarkMode

用来配置 Mode 选项，可用于类或者方法上，这个注解的 value 是一个数组，可以把几种 Mode 集合在一起执行，如  `@BenchmarkMode({Mode.SampleTime, Mode.AverageTime})`，还可以设置为 Mode.All，即全部执行一遍。
1. Throughput：整体吞吐量，每秒执行了多少次调用，单位为 ops/time
2. AverageTime：用的平均时间，每次操作的平均时间，单位为 time/op
3. SampleTime：随机取样，最后输出取样结果的分布
4. SingleShotTime：只运行一次，往往同时把 Warmup 次数设为 0，用于测试冷启动时的性能
5. All：上面的所有模式都执行一次

#### @State

通过 State 可以指定一个对象的作用范围，JMH 根据 scope 来进行实例化和共享操作。`@State` 可以被继承使用，如果父类定义了该注解，子类则无需定义。由于 JMH 允许多线程同时执行测试，不同的选项含义如下

1. `Scope.Benchmark`：所有测试线程共享一个实例，测试有状态实例在多线程共享下的性能
2. `Scope.Group`：同一个线程在同一个 group 里共享实例
3. `Scope.Thread`：默认的 State，每个测试线程分配一个实例

#### @OutputTimeUnit

为统计结果的时间单位，可用于类或者方法注解

#### @Warmup

预热所需要配置的一些基本测试参数，可用于类或者方法上。一般前几次进行程序测试的时候都会比较慢，所以要让程序进行几轮预热，保证测试的准确性。参数如下所示

1. `iterations`：预热的次数
2. `time`：每次预热的时间
3. `timeUnit`：时间的单位，默认秒
4. `batchSize`：批处理大小，每次操作调用几次方法


**为什么需要预热？**

因为 JVM 的 JIT 机制的存在，如果某个函数被调用多次之后，JVM 会尝试将其编译为机器码，从而提高执行速度，所以为了让 benchmark 的结果更加接近真实情况就需要进行预热。


#### @Measurement

实际调用方法所需要配置的一些基本测试参数，可用于类或者方法上，参数和 @Warmup 相同。

#### @Threads

每个进程中的测试线程，可用于类或者方法上。

#### @Fork
进行 fork 的次数，可用于类或者方法上。如果 fork 数是 2 的话，则 JMH 会 fork 出两个进程来进行测试。

#### @Param

指定某项参数的多种情况，特别适合用来测试一个函数在不同的参数输入的情况下的性能，只能作用在字段上，**使用该注解必须定义 `@State` 注解。**

```
import org.openjdk.jmh.annotations.Param;
import org.openjdk.jmh.annotations.Scope;
import org.openjdk.jmh.annotations.State;

@State(value = Scope.Benchmark)

public class SpringbootDemoApplication {

    @Param(value = {"10","50","100"})
    private  int length;
    
    ...
}
```



在介绍完常用的注解后，让我们来看下 JMH 有哪些陷阱。

### JMH陷阱

在使用 JMH 的过程中，一定要避免一些陷阱。

比如 JIT 优化中的死码消除，比如以下代码

```java
import org.openjdk.jmh.infra.Blackhole;


@Benchmark
public void testStringAdd(Blackhole blackhole) {
    String a = "";
    for (int i = 0; i < length; i++) {
        a += i;
    }
}
```

JVM 可能会认为变量 `a` 从来没有使用过，从而进行优化把整个方法内部代码移除掉，这就会影响测试结果。

JMH 提供了 2 种方式避免这种问题
* 一种是将这个变量作为方法返回值 `return a`
* 一种是通过 `Blackhole` 的 `consume` ，来避免 JIT 的优化消除


```java
 blackhole.consume(a);
```

其他陷阱还包括
* 常量折叠与常量传播
* 永远不要在测试中写循环
* 使用 Fork 隔离多个测试方法
* 方法内联
* 伪共享与缓存行
* 分支预测
* 多线程测试
* ...

感兴趣的可以阅读 [JMH-samples | github](https://github.com/lexburner/JMH-samples) 了解全部的陷阱。

### JMH插件

IDEA中可以选择安装JMH插件 —— `JMH plugin`，这个插件可以让我们能够以 JUnit 相同的方式使用 JMH，主要功能如下
1. 自动生成带有 `@Benchmark` 的方法
2. 像 JUnit 一样，运行单独的 Benchmark 方法
3. 运行类中所有的 Benchmark 方法



### JMH 可视化

除此以外，如果你想将测试结果以图表的形式可视化，可以试下这些网站
* [JMH Visual Chart](http://deepoove.com/jmh-visual-chart/)
* [JMH Visualizer](https://jmh.morethan.io/)

比如将上面测试例子结果的 `json` 文件导入，就可以实现可视化


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-jmh-visual-1.png)




## Java 反编译

### javap

`javap` 是 Java class 文件分解器，可以反编译，也可以查看 Java 编译器生成的字节码，从而对代码内部的执行逻辑进行分析。

`javac` 命令可以把文件 `.java` 编译成 `.class` 文件。
 
`javap` 命令可以把文件 `.class` 反编译成字节码文件，如 `javap -c Test.class`。



### jad
* [jad 官网](https://varaneckas.com/jad/)

Mac上可以直接从上述 [jad 官网](https://varaneckas.com/jad/) 官网下载 `jad`，使用命令行中使用该工具。

```
jad Test.class
```
在IDEA中，也可以直接安装 `IdeaJad` 插件。安装完成之后，选定 `.class` 文件，选中并单击，在弹出的菜单栏中有 `DeCompile` 的选项。



## fastjson

### 参考资料
* [alibaba/fastjson | github](https://github.com/alibaba/fastjson/wiki/Quick-Start-CN)
* [JSON最佳实践 | blog](https://kimmking.github.io/2017/06/06/json-best-practice/)


### Overview
> `fastjson` 是阿里巴巴的开源 JSON 解析库，它可以解析 JSON 格式的字符串，支持将 Java Bean 序列化为 JSON 字符串，也可以从 JSON 字符串反序列化到 JavaBean。

1. 引入依赖


```xml
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>fastjson</artifactId>
    <version>1.2.68</version>
</dependency>
```

```
//gradle
compile 'com.alibaba:fastjson:1.2.68'
```

2. 创建一个 Java 实体类 `TextInfo`，用于后续测试

```java
class TextInfo {
    private String label;
    private String name;

    public TextInfo(String label, String name) {
        this.label = label;
        this.name = name;
    }
    
    public TextInfo() {
    }


    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getLabel() {
        return label;
    }
    public void setLabel(String label) {
        this.label = label;
    }
}
```

3. 序列化一个对象成JSON字符串


```java
TextInfo textInfo1 = new TextInfo();
textInfo1.setLabel("bad");
textInfo1.setName("test");
String jsonString = JSON.toJSONString(textInfo1);
System.out.println(jsonString);

//程序输出
{"label":"bad","name":"test"}
```

4. 反序列化一个JSON字符串为Java对象


```java
String str = "{\"name\":\"lbs0912\",\"label\":\"good\"}";
TextInfo textInfo =  JSON.parseObject(str, TextInfo.class);
System.out.printf("className=%s , Label=%s \n",textInfo.getName(),textInfo.getLabel());

//程序输出
className=lbs0912 , Label=good 
```
```java
String jsonStringArray = "[{\"name\":\"lbs0912\",\"label\":\"good\"},{\"name\":\"lbs0912\",\"label\":\"good\"}]";
List<TextInfo> textInfoList = JSON.parseArray(jsonStringArray,TextInfo.class);
System.out.println(textInfoList.size());

//程序输出
2
```

## Swagger

### 参考资料

* [在 Spring Boot 项目中使用 Swagger 文档 | IBM 文档](https://www.ibm.com/developerworks/cn/java/j-using-swagger-in-a-spring-boot-project/index.html)
* [Swagger UI教程 API 文档神器 搭配Node使用](https://www.jianshu.com/p/d6626e6bd72c)
* [还在手动整合Swagger？Swagger官方Starter是真的香！](https://juejin.im/post/6890692970018766856)




### Swagger 简介
Swagger 是一套基于 OpenAPI 规范构建的开源工具，可以帮助我们设计、构建、记录以及使用 Rest API。Swagger 主要包含了以下三个部分

1. Swagger Editor：基于浏览器的编辑器，我们可以使用它编写我们 OpenAPI 规范。
2. Swagger UI：它会将我们编写的 OpenAPI 规范呈现为交互式的 API 文档，后文我将使用浏览器来查看并且操作我们的 Rest API。
3. Swagger Codegen：它可以通过为 OpenAPI（以前称为 Swagger）规范定义的任何 API 生成服务器存根和客户端 SDK 来简化构建过程。


### Swagger 优点
1. 代码变，文档变。只需要少量的注解，Swagger 就可以根据代码自动生成 API 文档，很好的保证了文档的时效性。
2. 跨语言性，支持 40 多种语言。
3. Swagger UI 呈现出来的是一份可交互式的 API 文档，我们可以直接在文档页面尝试 API 的调用，省去了准备复杂的调用参数的过程。
4. 还可以将文档规范导入相关的工具（例如 SoapUI）, 这些工具将会为我们自动地创建自动化测试。


### 依赖添加

对于 Maven 工程，在 `pom.xml` 中添加 `swagger2` 和 `swagger-ui` 依赖

```xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.2.2</version>
</dependency>

<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>2.2.2</version>
</dependency>
```



### Swagger 配置

Springfox 提供了一个 `Docket` 对象，让我们可以灵活的配置 `Swagger` 的各项属性。

```
@Configuration
@EnableSwagger2
public class SwaggerConfig {
    @Bean
    public Docket api() {
        return new Docket(DocumentationType.SWAGGER_2)
                .select()
                .apis(RequestHandlerSelectors.any())
                .paths(PathSelectors.any())
                .build();
    }
}
```

`@Configuration` 是告诉 Spring Boot 需要加载这个配置类，`@EnableSwagger2` 是启用 Swagger2，如果没加的话自然而然也就看不到后面的验证效果了。



### Swagger2 效果 


参考文档 [在 Spring Boot 项目中使用 Swagger 文档 | IBM 文档](https://www.ibm.com/developerworks/cn/java/j-using-swagger-in-a-spring-boot-project/index.html) 提供了一个用于Swagger 测试的工程配置。创建此工程后，可以验证 Swagger2 的效果。

>Tip：对比参考文档的 Swagger2 版本号，此处使用 `springfox-swagger2` 的 2.2.2 版本，以及 `springfox-swagger-ui` 的 2.2.2 版本。



此处仅给出 `UserContrller.java` 类的代码配置

```java
package com.example.swaggerdemo;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.*;
import springfox.documentation.annotations.ApiIgnore;


@RestController
@RequestMapping("/user")
@Api(tags = "用户相关接口", description = "提供用户相关的Rest API")
public class UserController {

    @ApiOperation("新增用户接口")
    @PostMapping("/add")
    public boolean addUser(@RequestBody User user) {
        return false;
    }

    @ApiOperation("通过id查找用户接口")
    @GetMapping("/find/{id}")
    public User findById(@PathVariable("id") int id) {
        return new User();
    }

    @ApiOperation("更新用户信息接口")
    @PutMapping("/update")
    public boolean update(@RequestBody User user) {
        return true;
    }

    @ApiOperation("删除用户接口")
    @DeleteMapping("/delete/{id}")
    @ApiIgnore
    public boolean delete(@PathVariable("id") int id) {
        return true;
    }
}
```

启动程序后，访问 `http://localhost:8080/v2/api-docs` 可以看到返回的JSON格式的接口文档描述。 

```json
{
    "swagger": "2.0",
    "info": {
        "description": "Api Documentation",
        "version": "1.0",
        "title": "Api Documentation",
        "termsOfService": "urn:tos",
        "contact": {},
        "license": {
            "name": "Apache 2.0",
            "url": "http://www.apache.org/licenses/LICENSE-2.0"
        }
    },
    "host": "localhost:8080",
    "basePath": "/",
    "tags": [
        {
            "name": "basic-error-controller",
            "description": "Basic Error Controller"
        },
        {
            "name": "测试相关接口",
            "description": "提供测试相关的Rest API"
        },
        {
            "name": "用户相关接口",
            "description": "提供用户相关的Rest API"
        }
    ],
    "paths": {
        ...
    }
}
```

这种 JSON 格式可读性较差。幸运的是，Swagger2 为我们提供了可视化的交互界面 SwaggerUI，下面我们就一起来试试吧。


### Swagger UI 效果 


在添加 Swagger UI 依赖后，访问 `http://localhost:8080/swagger-ui.html` 就可以看到页面效果。


**在 Swagger UI 页面上，对于一个具体的接口，点击 `Try it out`，Swagger UI 会给我们自动填充请求参数的数据结构。我们只需要点击 `Execute` 即可发起调用。**

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/swagger-ui-execute-1.png)



###  Swagger 高级配置

#### 文档相关描述配置

1. 通过在控制器类上增加 `@Api` 注解，可以给控制器增加描述和标签信息。

```java
@Api(tags = "用户相关接口", description = "提供用户相关的 Rest API")
public class UserController
```

2. 通过在接口方法上增加 `@ApiOperation` 注解来展开对接口的描述


```java
@ApiOperation("新增用户接口")
@PostMapping("/add")
public boolean addUser(@RequestBody User user) {
    return false;
}
```

3. 可以通过 `@ApiModel` 和 `@ApiModelProperty`注解来对实体 Model 进行描述。


```java
@ApiModel("用户实体")
public class User {
    @ApiModelProperty("用户 id")
private int id;
}
```

#### 接口过滤
1. `@ApiIgnore`：如果想在文档中屏蔽某接口，那么只需要在该接口方法上加上 `@ApiIgnore` 注解即可。
2. 在 `Docket` 上增加筛选。`Docket` 类提供了 `apis()` 和 `paths()` 两 个方法来帮助我们在不同级别上过滤接口
    * `apis()`：这种方式我们可以通过指定包名的方式，让 Swagger 只去某些包下面扫描。
    * `paths()`：这种方式可以通过筛选 API 的 url 来进行过滤。



### springfox-boot-starter

* [还在手动整合Swagger？Swagger官方Starter是真的香！](https://juejin.im/post/6890692970018766856)



使用 `springfox-boot-starter` 3.0 版本整合 Swagger的步骤如下。

1. 引入依赖

```xml
<!--springfox swagger官方Starter-->
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-boot-starter</artifactId>
    <version>3.0.0</version>
</dependency>
```




2. 添加 Swagger 的 Java 配置


```java
/**
 * Swagger2API文档的配置
 */
@Configuration
public class Swagger2Config {
    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.macro.mall.tiny.controller"))
                .paths(PathSelectors.any())
                .build();
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("SwaggerUI演示")
                .description("mall-tiny")
                .contact(new Contact("macro", null, null))
                .version("1.0")
                .build();
    }
}
```


3.访问 Swagger 地址： `http://localhost:8088/swagger-ui/`