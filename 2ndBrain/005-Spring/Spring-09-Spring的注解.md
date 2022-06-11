# Spring-09-Spring的注解

[TOC]



## 更新
* 2020/06/23，撰写
* 2022/05/19，整理


## 参考资料
* [Spring 中常用的注解 | Java全栈知识体系](https://pdai.tech/md/spring/springboot/springboot-x-hello-anno.html#bean)




## @Autowired、@Resource、@Inject

参见「笔记-Spring-02-Spring Framework」。

## @Component、@Service、@Controller、@Repository

参见「笔记-Spring-02-Spring Framework」。


## @Bean
* ref 1-[Spring @Bean注解的使用 | CSDN](https://blog.csdn.net/lswnew/article/details/79234297)


**Spring 的 `@Bean` 用于方法上**，表示将产生一个 Bean 对象，并将该 Bean 交给 Spring IoC 容器管理。



> `@Bean` 和 `@Component` 的区别
> * `@Bean` 用于方法上
> * `@Component` 用于类上


下面给出几个 `@Bean` 的使用示例。


1. 生成一个 Bean 并交给 IoC 容器管理

```java
@Bean
public PersonService personService() {
	return new PersonService();  //生成一个 Bean 并交给 IoC 容器管理
}
```


上述配置，等同于在 XML 里的如下配置

```xml
<beans>
    <bean id="personService" class="com.lbs.PersonService"/>
</beans>
```

2. 在 `@Bean` 中指定生命周期的回调函数。


```java
public class Foo {
    public void init() {
        // initialization logic
    }
}
 
public class Bar {
    public void cleanup() {
        // destruction logic
    }
}
 
@Configuration
public class AppConfig {
    @Bean(initMethod = "init")
    public Foo foo() {
        return new Foo();
    }
 
    @Bean(destroyMethod = "cleanup")
    public Bar bar() {
        return new Bar();
    }
}
```


3. 自定义 Bean 的命名。默认情况下 Bean 的名称和方法名称相同，你也可以使用 `name` 属性来指定 Bean 的名称。

```java
@Configuration
public class AppConfig {
    @Bean(name = "myFoo")
    public Foo foo() {
        return new Foo();
    }
}
```

4. 使用 `@Bean` 生成的 Bean 对象，可以搭配使用 `@Scope` 注解指定该 Bean 的作用域。


```java
@Configuration
public class MyConfiguration {
 
    @Bean
    @Scope("prototype")
    public Encryptor encryptor() {
        // ...
    }
}
```
 
5. 使用 `@Bean` 生成的 Bean 对象，可以搭配使用 `@Description` 注解为该 Bean 提供必要的描述。


```java
@Configuration
public class AppConfig {
 
    @Bean
    @Description("Provides a basic example of a bean")
    public Foo foo() {
        return new Foo();
    }
}
```








## @Conditional
* ref 1-[一文了解@Conditional注解说明和使用](https://www.cnblogs.com/cxuanblog/p/10960575.html)
* ref 2-[详解Spring @Conditional 注解 | 掘金](https://juejin.cn/post/6844904200401321997)





Spring 4 中引入了 `@Conditional` 注解，可以用到带有 `@Bean` 注解的方法上，实现了条件化注册 Bean。若给定条件满足，则创建并注册这个 Bean；否则不注入。



### Class[]和Condition接口

```java
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Conditional {

	/**
	 * All {@link Condition Conditions} that must {@linkplain Condition#matches match}
	 * in order for the component to be registered.
	 */
	Class<? extends Condition>[] value();
}
```



从代码中可以看到，使用 `@Conditional` 注解是需传入一个 `Class` 数组，并实现 `Condition` 接口，重写该接口的 `matches()` 方法。`matches()` 方法若返回 true 则创建并注入 Bean，false 则不注入。

```java
@FunctionalInterface
public interface Condition {
	boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata);
}
```

另外，`@Conditional` 注解中传入的是一个 `Class` 数组，当数组中存在多个条件时，所有 `Condition` 实现类 `match` 方法均返回 true 时，才会将 Bean 注入到容器。



下面给出一个示例加深理解。


* 创建 `System` 类


```java
public class System {

    private String name;

    public System(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "System{" +
                "name='" + name + '\'' +
                '}';
    }
}
```

* 创建 `BeanConfig` 类，用于配置 3个 `System` 实例，并注入 `Windows`、`Linux` 和 `Mac`


```java
@Configuration
public class BeanConfig {

    @Bean(name = "windows")
    public System system1() {
        return new System("Windows");
    }

    @Bean(name = "linux")
    public System system2() {
        return new System("Linux");
    }
 
    @Bean(name = "mac")
    public System system3() {
        return new System("Mac");
    }
}
```


* 创建 `ConditionalTest` 测试类，验证上述 3 个 Bean 是否注入成功


```java
public class ConditionalTest {
    AnnotationConfigApplicationContext applicationContext = new AnnotationConfigApplicationContext(BeanConfig.class);

    @Test
    public void test1() {
        Map<String, System> beans = applicationContext.getBeansOfType(System.class);
        java.lang.System.out.println(beans);
    }
}
```

* 执行上述测试方法，可看到如下的控制台输出，验证了 3 个 Bean 都已经注入成功


```s
{windows=System{name='Windows'},linux=System{name='Linux'},mac=System{name='Mac'}}
```


* 下面使用 `@Conditional` 注解，根据程序运行环境，注入系统匹配的 Bean。此处，创建 `WindowsCondition`，`LinuxCondition` 和 `MacCondition` 三个类，并实现 `Condition` 接口


```java
import org.springframework.context.annotation.Condition;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.core.type.AnnotatedTypeMetadata;

public class WindowsCondition implements Condition {
    @Override
    public boolean matches(ConditionContext conditionContext, AnnotatedTypeMetadata annotatedTypeMetadata) {
        //获得当前系统名
        String property = conditionContext.getEnvironment().getProperty("os.name");
        //包含Windows则说明是windows系统，返回true
        return property != null && property.contains("Windows");
    }
}

public class MacCondition implements Condition {
    @Override
    public boolean matches(ConditionContext conditionContext, AnnotatedTypeMetadata annotatedTypeMetadata) {
        String property = conditionContext.getEnvironment().getProperty("os.name"); //Mac OS X
        return property != null && property.contains("Mac");
    }
}

public class LinuxCondition implements Condition {
    @Override
    public boolean matches(ConditionContext conditionContext, AnnotatedTypeMetadata annotatedTypeMetadata) {
        String property = conditionContext.getEnvironment().getProperty("os.name");
        return property != null && property.contains("Linux");
    }
}
```



* 修改 `BeanConfig` 类，添加 `@Conditional` 注解

```java


@Configuration
public class BeanConfig {

    @Conditional(WindowsCondition.class)
    @Bean(name = "windows")
    public System system1() {
        return new System("Windows");
    }

    @Conditional(LinuxCondition.class)
    @Bean(name = "linux")
    public System system2() {
        return new System("Linux");
    }

    @Conditional(MacCondition.class)
    @Bean(name = "mac")
    public System system3() {
        return new System("Mac");
    }
}
```

* 在 `ConditionalTest` 测试类中编写测试方法
  

```java
public class ConditionalTest {
    AnnotationConfigApplicationContext applicationContext = new AnnotationConfigApplicationContext(BeanConfig.class);

    @Test
    public void test1() {
        String osName = applicationContext.getEnvironment().getProperty("os.name");
        java.lang.System.out.println(osName);
        Map<String, System> beans = applicationContext.getBeansOfType(System.class);
        java.lang.System.out.println(beans);
    }
}
```

* 程序执行结果如下，可以看到此时只注入了一个 Bean

```s
Mac OS X
{mac=System{name='Mac'}}
```

* `@Conditional` 注解是需传入一个 `class` 数组，当数组中存在多个条件时，所有 `Condition` 实现类 `match` 方法均返回 true时，才会将 Bean 注入到容器。如下代码所示，只有 `LinuxCondition` 和 `WindowsCondition` 均满足时候，才会注入对应的 Bean
  


```java
@Conditional({LinuxCondition.class,WindowsCondition.class})
@Bean(name = "linux")
public System system2() {
    return new System("Linux");
}
```




### @Conditional实战


下面给出一个在「国际站JSF@JD投放」工程中，使用 `@Conditional` 注解实现条件化注入 Bean的案例。


* 使用业务 `BU` 来区分泰国环境和印尼环境。
* 创建 `ThaiCondition` 和 `InaCondition`，实现 `Condition` 接口并重写 `matches()` 方法。


```java
public class ThaiCondition implements Condition {

    @Override
    public boolean matches(ConditionContext conditionContext, AnnotatedTypeMetadata annotatedTypeMetadata) {
        int buid = EasyUtils.parseInt(conditionContext.getEnvironment().getProperty("materialjsf.i18n.buId"));
        return BU.JD_TH.equals(BU.getBU(buid));
    }
}


public class InaCondition implements Condition {

    @Override
    public boolean matches(ConditionContext conditionContext, AnnotatedTypeMetadata annotatedTypeMetadata) {
        int buid = EasyUtils.parseInt(conditionContext.getEnvironment().getProperty("materialjsf.i18n.buId"));
        return BU.JD_ID.equals(BU.getBU(buid));
    }
}

```


* 在创建的 Bean 对象上，添加 `@Conditional({ThaiCondition.class})` 或 `@Conditional({InaCondition.class})`，实现条件化注入 Bean。


```java
@Configuration
public class ProductHandlersConfig {
    //仅针对泰国环境注入
    @Bean(name = "skuProductHandlers")
    @Conditional({ThaiCondition.class})
    public List<EventHandler<ProductInfoEvent>> thaiSkuProductHandlers(ProductBaseInfoEventHandler productBaseInfoEventHandler,
                                                                       ProductPriceEventHandler productPriceEventHandler,
                                                                       ProductAreaStockEventHandler productAreaStockEventHandler,
                                                                       ProductRealStockEventHandler productRealStockEventHandler) {
        List<EventHandler<ProductInfoEvent>> skuProductHandlers = new ArrayList<>();
        skuProductHandlers.add(productBaseInfoEventHandler);
        skuProductHandlers.add(productPriceEventHandler);
        skuProductHandlers.add(productAreaStockEventHandler);
        skuProductHandlers.add(productRealStockEventHandler);
        return skuProductHandlers;
    }

    //仅针对印尼环境注入
    @Bean(name = "promotionProductHandlers")
    @Conditional({InaCondition.class})
    public List<EventHandler<ProductInfoEvent>> inaPromotionProductHandlers(ProductBaseInfoEventHandler productBaseInfoEventHandler,
                                                                            ProductPriceEventHandler productPriceEventHandler,
                                                                            ProductAreaStockEventHandler productAreaStockEventHandler,
                                                                            ProductRealStockEventHandler productRealStockEventHandler,
                                                                            ProductPromoInfoEventHandler productPromoInfoEventHandler,
                                                                            ProductPromoStockEventhandler productPromoStockEventhandler) {
        List<EventHandler<ProductInfoEvent>> promotionProductHandlers = new ArrayList<>();
        promotionProductHandlers.add(productBaseInfoEventHandler);
        promotionProductHandlers.add(productPriceEventHandler);
        promotionProductHandlers.add(productAreaStockEventHandler);
        promotionProductHandlers.add(productRealStockEventHandler);
        promotionProductHandlers.add(productPromoInfoEventHandler);
        promotionProductHandlers.add(productPromoStockEventhandler);
        return promotionProductHandlers;
    }
}
```








## @Configuration
* ref 1-[@Configuration注解使用 | 掘金](https://juejin.cn/post/6844903842476195848)



Spring 3.0 引入了 `@Configuration` 注解，用于定义配置类，可替换 XML 配置文件。被注解的类内部包含有一个或多个被 `@Bean` 注解的方法，这些方法将会被 `AnnotationConfigApplicationContext` 或 `AnnotationConfigWebApplicationContext` 类进行扫描，并用于构建 Bean 定义，初始化 Spring 容器。

```java
//表示这是一个配置信息类,可以给这个配置类也起一个名称
@Configuration("name")
//类似于xml中的<context:component-scan base-package="spring4"/>
@ComponentScan("spring4")
public class Config {

    //自动注入，如果容器中有多个符合的bean时，需要进一步明确
    @Autowired
    //进一步指明注入bean名称为compent的bean
    @Qualifier("compent")
    private Compent compent;

    //类似于xml中的<bean id="newbean" class="spring4.Compent"/>
    @Bean
    public Compent newbean(){
        return new Compent();
    }   
}
```


## @RestController和@Controller

* ref 1-[@RestController和@Controller | 掘金](https://juejin.im/post/6844903922465783816)


两者主要区别如下
* `@Controller` 用于返回一个视图操作
* `@RestController`（Spring 4+）相当于 `@Controller` + `@ResponseBody`，返回 JSON 或者 XML 格式数据



## @RequestMapping()


`@RequestMapping()` 用来映射 Web 请求(访问路径和参数)、处理类和方法，可以注解在类或方法上。注解在方法上的路径会继承注解在类上的路径。


```java
// 通过@Controller定义一个Controller，通过@RequestMapping来定义URL请求路径
@Controller
public class DemoController {
    @RequestMapping("/api/test1")
    public ModelAndView getEmployeeName() {
        ModelAndView model = new ModelAndView("FlyFish");        
        model.addObject("message", "FlyFish");       
        return model; 
    }  
}
```

`@RequestMapping("/api/test1")` 是 `@RequestMapping(value="/api/test1")` 的简写。`@RequestMapping()` 注解除了 `value` 属性外，还有如下 `produces` 和 `method` 属性。其中，`produces` 属性用于定制返回的 `response` 的媒体类型和字符集。


```java
@RequestMapping(value="/api/copper", produces="application/json;charset=UTF-8", method = RequestMethod.POST)
```

## @SpringBootApplication



```java
//开启组件扫描和自动配置
@SpringBootApplication
public class ReadingListApplication {

    public static void main(String[] args) {
        //负责启动引导应用程序
        SpringApplication.run(ReadingListApplication.class, args);
    }

}
```

**`@SpringBootApplication` 开启了 Spring 的组件扫描和 Spring Boot 的自动配置功能。** 实际上，`@SpringBootApplication` 将以下 3 个注解组合在了一起
* Spring 的 `@Configuration`
* Spring 的 `@ComponentScan`
* Spring Boot的 `@EnableAutoConfiguration`

> 在早期 Spring Boot 版本中需要同时使用上面3个注解。从 Spring Boot 1.2.0 开始，使用 `@SpringBootApplication` 就可以了。




