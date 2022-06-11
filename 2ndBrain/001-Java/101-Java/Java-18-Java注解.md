
# Java-18-注解

[TOC]


## 更新
* 2021/02/15，撰写
* 2022/05/18，排版更新


## 参考资料
* [JAVA自定义注解 | Segmentfault](https://segmentfault.com/a/1190000022800544)
* [Java 自定义注解及使用场景 | 掘金](https://juejin.cn/post/6844903949233815566)



## 什么是注解

注解（`Annotation`）是Java SE 5.0 版本开始引入的概念，它是对 Java 源代码的说明，是一种元数据（描述数据的数据）。

* 注解的定义通过 `@interface` 表示，所有的注解会自动继承 `java.lang.Annotation` 接口，且不能再继承别的类或是接口。
* 注解的成员参数只能用 `public` 或默认 (`default`) 访问权修饰来进行修饰。
* 成员参数只能使用 8 种基本类型（byte、short、char、int、long、float、double、boolean）和 String、Enum、Class、annotations等数据类型，及其数组。
* 获取类方法和字段的注解信息，只能通过 Java 的反射技术来获取 Annotation 对象。
* 注解可以没有定义成员，只做标识。


## 注解的分类

按照来源划分，注解可以分为 3 类
1. JDK的注解
2. 第三方的注解
3. 自定义注解


### 1.JDK注解

JAVA内置注解在 `java.lang` 中，4个元注解在 `java.lang.annotation` 中。


#### JAVA内置注解
* @Override （标记重写方法）
* @Deprecated （标记过时）
* @SuppressWarnings （忽略警告）

#### 元注解 (注解的注解)
* @Target （注解的作用目标）
* @Retention （注解的生命周期）
* @Document （注解是否被包含在JavaDoc中）
* @Inherited （是否允许子类继承该注解）


##### @Target

`@Target` 注解表明该注解可以应用的JAVA元素类型。


| Target类型  | 	描述   |
|-------------|------------|
| ElementType.TYPE |	应用于类、接口（包括注解类型）、枚举 | 
| ElementType.FIELD	 | 应用于属性（包括枚举中的常量） | 
| ElementType.METHOD  | 	应用于方法 | 
| ElementType.PARAMETER  | 	应用于方法的形参 | 
| ElementType.CONSTRUCTOR  | 	应用于构造函数 | 
| ElementType.LOCAL_VARIABLE  | 	应用于局部变量 | 
| ElementType.ANNOTATION_TYPE | 	应用于注解类型 | 
| ElementType.PACKAGE	| 应用于包 | 
| ElementType.TYPE_PARAMETER | 	1.8版本新增，应用于类型变量 | 
| ElementType.TYPE_USE  | 	1.8版本新增，应用于任何使用类型的语句中（例如声明语句、泛型和强制转换语句中的类型）| 


##### @Retention

`@Retention`  表明该注解的生命周期。

| 生命周期类型  |	描述 |
|-------------|------------|
| RetentionPolicy.SOURCE	 | 编译时被丢弃，不包含在类文件中 |
| RetentionPolicy.CLASS  | 	JVM加载时被丢弃，包含在类文件中，默认值 |
| RetentionPolicy.RUNTIME	 | 始终不会丢弃，可以使用反射获得该注解的信息。由JVM 加载，包含在类文件中，在运行时可以被获取到。自定义的注解最常用的使用方式。  |


##### @Document

表明该注解标记的元素可以被Javadoc 或类似的工具文档化

##### @Inherited

表明使用了@Inherited注解的注解，所标记的类的子类也会拥有这个注解。


### 2.第三方注解

如各种框架的注解，如 Spring 的注解
* @Autowired
* @Service
* ...

### 3.自定义注解

使用元注解自己定义的注解，详见下文。



## 注解的语法

注解的语法如下。

```java
/**
 * 修饰符 @interface 注解名 {
 * 注解元素的声明1
 * 注解元素的声明2
 * }
 * 修饰符：访问修饰符必须为public,不写默认为pubic；
 * 关键字：必须为@interface；
 * 注解名： 注解名称为自定义注解的名称，使用时还会用到；
 * 注解类型元素：注解类型元素是注解中内容，可以理解成自定义接口的实现部分；
 */
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface MyTestAnnotation {
    /**
     *    注解的元素声明的两种形式
     *    type elementName();
     *    type elementName() default value;  
     */
    String value() default "test";
}
```


下面结合注解的语法，给出 `@Service` 注解的示例。


```java
@Target({ElementType.TYPE})// ElementType.TYPE 代表在注解上使用
@Retention(RetentionPolicy.RUNTIME)// RetentionPolicy.RUNTIME 代表运行时使用，可以通过反射获取到
@Documented//包含在JavaDoc中
@Component//允许通过包扫描的方式自动检测
public @interface Service {

    /**
     * The value may indicate a suggestion for a logical component name,
     * to be turned into a Spring bean in case of an autodetected component.
     * @return the suggested component name, if any (or empty String otherwise)
     */
    @AliasFor(annotation = Component.class)
    String value() default "";
}
```




## 利用反射解析注解



**注解本质是一个继承了 Annotation 的特殊接口，其具体实现类是 Java 运行时生成的动态代理类。**

我们通过反射获取注解时，返回的是 Java 运行时生成的动态代理对象 `$Proxy1`。通过代理对象调用自定义注解（接口）的方法，会最终调用 `AnnotationInvocationHandler` 的 `invoke` 方法。

例如，注解 `@Override` 的定义和反编译代码如下所示。


```java
// Override 定义
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
public @interface Override {

}
```

```java
// 反编译后
public interface Override extends Annotation{

}
```






### 相关API

对于定义的注解，可以使用反射技术对注解进行处理。`java.lang.reflect.AnnotationElement` 接口提供了该功能。如下图所示，反射相关的类 `Class`, `Method`, `Field` 都实现了 `AnnotationElement` 接口。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-annotation-reflect-1.png)


因此，只要我们通过反射拿到 `Class`, `Method`, `Field` 类，就能够通过 `getAnnotation(Class)` 拿到我们想要的注解并取值。获取类方法和字段的注解信息，常用的方法包括

* `isAnnotationPresent`：判断当前元素是否被指定注解修饰
* `getAnnotation`：返回指定的注解
* `getAnnotations`：返回所有的注解






![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-annotation-reflect-2.png)



### 示例



此处给出利用反射技术，对自定义注解进行解析的示例。

1. 定义自定义注解
2. 配置注解
3. 利用反射解析注解



#### 1.定义自定义注解

```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface MyTestAnnotation {
    String value() default "test";
}
```

#### 2.配置注解

```java
@Data
@Builder
@MyTestAnnotation
public class MyBean {
    private String name;
    private int age;
}
```

#### 3.利用反射解析注解

```java
public class MyTest {

    //isAnnotationPresent：判断当前元素是否被指定注解修饰
    //getAnnotation：返回指定的注解
    //getAnnotations：返回所有的注解
    public static void main(String[] args) {
        try {
            //获取MyBean的Class对象
            MyBean myBean = MyBean.builder().build();
            Class clazz = myBean.getClass();
            
            //判断myBean对象上是否有MyTestAnnotation注解
            if (clazz.isAnnotationPresent(MyTestAnnotation.class)) {
                System.out.println("MyBean类上配置了MyTestAnnotation注解！");
                //获取该对象上MyTestAnnotation类型的注解
                MyTestAnnotation myTestAnnotation = (MyTestAnnotation) clazz.getAnnotation(MyTestAnnotation.class);
                System.out.println(myTestAnnotation.value());
            } else {
                System.out.println("MyBean类上没有配置MyTestAnnotation注解！");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

运行程序，结果如下

```s
MyBean类上配置了MyTestAnnotation注解！
test
```




## 注解实战示例

### 校验年龄


下面的示例将展示如何通过自定义注解校验年龄。


* 定义两个个注解，一个用来赋值，一个用来校验。


```java
/**
 * 性别赋值
 */
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.FIELD,ElementType.METHOD})
@Inherited
public @interface InitSex {
    /**
     * sex enum
     */
    enum SEX_TYPE {MAN, WOMAN}
    SEX_TYPE sex() default SEX_TYPE.MAN;
}
```


```java
/**
 * 年龄校验
 */
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.FIELD,ElementType.METHOD})
@Inherited
public @interface ValidateAge {
    /**
     * 最小值
     */
    int min() default 18;
    /**
     * 最大值
     */
    int max() default 99;
    /**
     * 默认值
     */
    int value() default 20;
}
```


* 定义数据模型，这里用 `User` 类来表示具体待处理的数据对象。


```java
/**
 * user
 */
public class User {
    private String username;
    @ValidateAge(min = 20, max = 35, value = 22)
    private int age;
    @InitSex(sex = InitSex.SEX_TYPE.MAN)
    private String sex;
    // 省略getter/setter方法
}
```


* 编写测试方法，其中 `initUser` 方法来演示通过反射给属性赋值；`checkUser` 方法中，先通过反射拿到当前属性的值，再进行校验。


```java

package com.lbs0912.java.demo;

import com.lbs0912.java.demo.annotation.InitSex;
import com.lbs0912.java.demo.annotation.ValidateAge;
import com.lbs0912.java.demo.entity.User;
import java.lang.reflect.Field;

public class TestInitParam {
    public static void main(String[] args) throws IllegalAccessException {
        User user = new User();
        initUser(user);
        // user.age未赋值 初始化值为0，校验不通过
        boolean checkResult = checkUser(user);
        printResult(checkResult);
        // 重新设置年龄，校验通过情况
        user.setAge(22);
        checkResult = checkUser(user);
        printResult(checkResult);
    }
    static void initUser(User user) throws IllegalAccessException {
        // 获取User类中所有的属性(getFields无法获得private属性)
        Field[] fields = User.class.getDeclaredFields();
        // 遍历所有属性
        for (Field field : fields) {
            System.out.println("field:" + field.getName());
            // 如果属性上有此注解，则进行赋值操作
            if (field.isAnnotationPresent(InitSex.class)) {
                InitSex init = field.getAnnotation(InitSex.class);
                field.setAccessible(true);
                // 设置属性的性别值
                field.set(user, init.sex().toString());
                System.out.println("完成属性值的修改，修改值为：" + init.sex().toString());
            }
        }
    }
    static boolean checkUser(User user) throws IllegalAccessException {
        // 获取User类中所有的属性(getFields无法获得private属性)
        Field[] fields = User.class.getDeclaredFields();
        boolean result = true;
        // 遍历所有属性
        for (Field field : fields) {
            // 如果属性上有此注解，则进行赋值操作
            if (field.isAnnotationPresent(ValidateAge.class)) {
                ValidateAge validateAge = field.getAnnotation(ValidateAge.class);
                field.setAccessible(true);
                int age = (int) field.get(user);
                if (age < validateAge.min() || age > validateAge.max()) {
                    result = false;
                    System.out.println("年龄值不符合条件");
                }
            }
        }
        return result;
    }

    static void printResult(boolean checkResult) {
        if (checkResult) {
            System.out.println("校验通过");
        } else {
            System.out.println("校验未通过");
        }
    }
}
```


* 打印日志

```s
完成属性值的修改，修改值为：MAN
年龄值不符合条件
校验未通过
校验通过
```




### 登陆校验


使用自定义注解 + Spring Boot 的拦截器，进行用户校验登陆。如果方法上加了 `@LoginRequired` 注解，则提示用户该接口需要登录才能访问，否则不需要登录。



* 自定义 `@LoginRequired` 注解

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface LoginRequired {
    
}
```

* 创建两个接口服务，访问 `sourceA`，`sourceB` 资源。`sourceB` 接口访问添加 `@LoginRequired` 注解，表示进行登陆校验。

```java
@RestController
public class IndexController {

    @GetMapping("/sourceA")
    public String sourceA(){
        return "你正在访问sourceA资源";
    }

    @GetMapping("/sourceB")
    @LoginRequired
    public String sourceB(){
        return "你正在访问sourceB资源";
    }
}
```

* 创建 `SourceAccessInterceptor` 类，实现 Spring 的拦截器，使用反射拿到注解后，进行登陆提示。

```java
public class SourceAccessInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("进入拦截器了");
        System.out.println("\n-------- SourceAccessInterceptor.preHandle --- ");


        // 反射获取方法上的LoginRequired注解
        HandlerMethod handlerMethod = (HandlerMethod)handler;

        Method method = handlerMethod.getMethod();
        if(method.isAnnotationPresent(LoginRequired.class)){
            LoginRequired loginRequired = method.getAnnotation(LoginRequired.class);
            //提示用户登录
            response.setContentType("application/json; charset=utf-8");
            response.getWriter().print("你访问的资源需要登录");
            System.out.println("methodName:" + method.getName() + " ,你访问的资源需要登录--- ");
            
            return false; //返回false 进行拦截
        }

        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        System.out.println("\n-------- SourceAccessInterceptor.postHandle --- ");
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        System.out.println("\n-------- SourceAccessInterceptor.afterCompletion --- ");
    }
}
```


* 实现 Spring 类 `WebMvcConfigurer`，创建配置类，把拦截器添加到拦截器链中


```java
@Configuration
public class InterceptorTrainConfigurer implements WebMvcConfigurer {
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new SourceAccessInterceptor()).addPathPatterns("/**");
    }
}
```

* 访问路径 `http://localhost:8081/sourceB`，会看到页面内容 “你访问的资源需要登录”，对应日志如下


```s
进入拦截器了

-------- SourceAccessInterceptor.preHandle --- 
methodName:sourceB ,你访问的资源需要登录--- 
```




### 打印日志

* [SpringBoot自定义注解+AOP打印日志 | Blog](https://www.cnblogs.com/sword-successful/p/10850168.html)
* [打印整个系统每个方法的执行时间 | 掘金](https://juejin.cn/post/6923737436317188103)




使用自定义注解 + AOP，进行日志打印。

* 导入切面需要的依赖包

```xml
<dependency>
      <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-aop</artifactId>
</dependency>
```

* 创建自定义注解 `@WebLogger`

```java
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD})
@Documented
public @interface WebLogger {

    String value() default "";
}
```


* 定义一个切面类，并进行日志打印逻辑


```java


@Aspect
@Component
public class WebLoggerAspect {

    @Pointcut("@annotation(com.lbs.spring.my_app.annotation.WebLogger)")
    public void log() {
    }

    @Around("log()")
    public Object doAround(ProceedingJoinPoint joinPoint) throws Throwable {
        long startTime = System.currentTimeMillis();

        Object result = null;
        try {
            result = joinPoint.proceed();
        } catch (Throwable throwable){
            throwable.printStackTrace();
        } finally {
            System.out.println("Response："+new Gson().toJson(result));
            System.out.println("耗时（ms）：" + (System.currentTimeMillis() - startTime));
        }
        return result;
    }

    @Before("log()")
    public void doBefore(JoinPoint joinPoint) {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes.getRequest();

        System.out.println("==================Start=================");
        System.out.println("URL：" + request.getRequestURL().toString());
        System.out.println("Description：" + getLogValue(joinPoint));
        System.out.println("Method：" + request.getMethod().toString());

        //打印controller全路径及method
        System.out.println("Class Method：" + joinPoint.getSignature().getDeclaringTypeName() + "," + joinPoint.getSignature().getName());
        System.out.println("客户端IP：" + request.getRemoteAddr());

        System.out.println("请求参数：" + new Gson().toJson(joinPoint.getArgs()));

    }

    private String getLogValue(JoinPoint joinPoint) {

        MethodSignature methodSignature = (MethodSignature) joinPoint.getSignature();
        Method method = methodSignature.getMethod();

        WebLogger webLogger = method.getAnnotation(WebLogger.class);

        return webLogger.value();
    }

    @After("log()")
    public void doAfter() {
        System.out.println("==================End=================");
    }
}
```

* 最后创建一个接口服务，用于展示日志打印功能


```java

@RestController
public class IndexController {
    @WebLogger("学生实体")
    @GetMapping("/sourceC/{source_name}")
    //http://localhost:8081/sourceC/lbs0912
    public String sourceC(@PathVariable("source_name") String sourceName){
        return "你正在访问sourceC资源";
    }
}
```


* 访问 `http://localhost:8081/sourceC/lbs0912`，会看到如下日志


```s
==================Start=================
URL：http://localhost:8081/sourceC/lbs0912
Description：学生实体
Method：GET
Class Method：com.lbs.spring.my_app.controller.IndexController,sourceC
客户端IP：0:0:0:0:0:0:0:1
请求参数：["lbs0912"]
==================End=================
Response："你正在访问sourceC资源"
耗时（ms）：1
```