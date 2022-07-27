# Spring-02-Spring Framework


[TOC]


## 更新
* 2022/05/16，撰写
* 2022/05/21，添加 *过滤器和拦截器*

## 参考资料

* [spring.io](https://spring.io/)
* [Spring Framework & Spring Boot | Java全栈知识体系](https://pdai.tech/md/spring/spring.html)

  






## 控制反转（IoC）

### 相关术语


#### IoC和DI
* IOC（`Inversion of Control`)，即「控制反转」。IoC 不是什么技术，而是一种设计思想。在 Java 开发中，IoC 意味着将你设计好的对象交给容器控制，而不是传统的在你的对象内部直接控制。
* 应用程序代码从IoC容器中获取到依赖的 Bean，注入到应用程序中，这个过程叫「依赖注入(`Dependency Injection`，DI)」。

控制反转（IoC）是一种设计思想，依赖注入（DI）是一种具体的技术，是实现 IoC 设计思想的一种具体实现方式。


#### Spring Bean

> In Spring, the objects that form the backbone of your application and that are managed by the Spring IoC container are called beans. A bean is an object that is instantiated, assembled, and otherwise managed by a Spring IoC container. -- [What is Spring Bean | spring.io](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#spring-core)


在 Spring 中，构成应用程序主干，并由 Spring IoC 容器管理的对象称为「Bean」。「Bean」是一个由 Spring IoC 容器实例化、组装和管理的对象。


#### IoC容器
* IoC 容器就是具有依赖注入功能的容器。
* IoC 容器负责实例化、定位、配置应用程序中的 Bean 对象及建立这些 Bean 对象间的依赖。


### IoC容器的两种类型


Spring 提供了两种不同类型的 Ioc 容器。
1. `BeanFactory`
   * 只提供基本的依赖注入（DI）支持，`BeanFactory` 是一个 Java 接口，最常见的实现是 `XmlBeanFactory` 类。
   * 它是最简单的容器，给 DI 提供了基本的支持，它用 `org.springframework.beans.factory.BeanFactory` 接口来定义。
   * `BeanFactory` 或者相关的接口，如 `BeanFactoryAware`，`InitializingBean`，`DisposableBean` 等，仍旧保留在 Spring 中，主要目的是向后兼容已经存在的和那些 Spring 整合在一起的第三方框架 
2. `ApplicationContext`
   * 继承并扩展了 `BeanFactory` 的功能，该容器添加了更多的企业特定的功能，例如从一个属性文件中解析文本信息的能力，发布应用程序事件给感兴趣的事件监听器的能力。
   * `ApplicationContext` 也是一个接口，常用的实现类包括`FileSystemXmlApplicationContext`、 `ClassPathXmlApplicationContext` 和 `WebXmlApplicationContext`


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/spring-ioc-bean_factory_2.png)


`ApplicationContext` 容器包括 `BeanFactory` 容器的所有功能，所以通常不建议使用 `BeanFactory`。`BeanFactory` 仍然可以用于轻量级的应用程序，如移动设备或基于 Applet 的应用程序。



### BeanFactory和FactoryBean的区别
* ref 1-[Spring 中 BeanFactory 和 FactoryBean 的区别](https://zhuanlan.zhihu.com/p/124119677)
* ref 2-[Spring中BeanFactory与FactoryBean的区别](https://juejin.cn/post/6844903967600836621)


两者的区别表现在
1. `BeanFactory` 是个 `Factory`，也就是 IOC 容器或对象工厂。
2. `FactoryBean` 是个 `Bean`。在 Spring 中，所有的 Bean 都是由`BeanFactory` （也就是 IOC 容器）来进行管理的。但对 `FactoryBean` 而言，这个 `Bean` 不是简单的 `Bean`，而是一个能生产或者修饰对象生成的工厂 `Bean`，它的实现与设计模式中的工厂模式和修饰器模式类似。
3. `BeanFactory` 的使用场景主要包括
   * 从 IoC 容器中获取 Bean（byName or byType）
   * 检索 IoC 容器中是否包含指定的 Bean
   * 判断 Bean 是否为单例



> BeanFactory
1. `BeanFactory` 定义了 IOC 容器的最基本形式，并提供了 IOC 容器应遵守的的最基本的接口，也就是 Spring IOC 所遵守的最底层和最基本的编程规范。
2. 在 Spring 代码中，BeanFactory 只是个接口，并不是 IOC 容器的具体实现，但是 Spring 容器给出了很多种实现，如 `DefaultListableBeanFactory`、`XmlBeanFactory`、`ApplicationContext` 等，都是附加了某种功能的实现。


> FactoryBean
1. `FactoryBean` 是个 `Bean`。在 Spring 中，所有的 Bean 都是由`BeanFactory` （也就是 IOC 容器）来进行管理的。
2. 但对 `FactoryBean` 而言，这个 `Bean` 不是简单的 `Bean`，而是一个能生产或者修饰对象生成的工厂 `Bean`，它的实现与设计模式中的工厂模式和修饰器模式类似。
3. 一般情况下，Spring 通过反射机制利用 `<bean>` 的 `class` 属性指定实现类实例化 Bean，在某些情况下，实例化 Bean 过程比较复杂，如果按照传统的方式，则需要在 `<bean>` 中提供大量的配置信息。配置方式的灵活性是受限的，这时采用编码的方式可能会得到一个简单的方案。Spring 为此提供了一个 `org.springframework.bean.factory.FactoryBean` 的工厂类接口，用户可以通过实现该接口定制实例化 Bean 的逻辑。
4. `FactoryBean` 接口对于 Spring 框架来说占用重要的地位，Spring 自身就提供了 70 多个 `FactoryBean` 的实现。它们隐藏了实例化一些复杂 Bean 的细节，给上层应用带来了便利。从 Spring 3.0 开始，FactoryBean 开始支持泛型，即接口声明改为 `FactoryBean<T>` 的形式。

```java
package org.springframework.beans.factory;  
public interface FactoryBean<T> {  
    //从工厂中获取bean
	@Nullable
	T getObject() throws Exception;

	//获取Bean工厂创建的对象的类型
	@Nullable
	Class<?> getObjectType();

	//Bean工厂创建的对象是否是单例模式
	default boolean isSingleton() {
		return true;
	}
}   
```

从 `FactoryBean` 的定义可以看出，`FactoryBean` 表现的是一个工厂的职责。即一个 Bean A 如果实现了 `FactoryBean` 接口，那么 A 就变成了一个工厂，根据 A 的名称获取到的，实际上是工厂调用 `getObject()` 返回的对象，而不是 A 本身。如果要获取工厂 A 自身的实例，那么需要在名称前面加上 `'&'` 符号。

```java
// 返回工厂中的实例
getObject('name')

// 返回工厂本身的实例
getObject('&name')
```

**通常情况下，bean 无须自己实现工厂模式，Spring 容器担任了工厂的角色；但少数情况下，容器中的 bean 本身就是工厂，作用是产生其他 bean 实例。由工厂 bean 产生的其他 bean 实例，不再由 Spring 容器产生，因此与普通 bean 的配置不同，不再需要提供 class 元素。**

### 配置IoC容器的3种方式

配置IoC容器的方式有 3 种
1. XML 配置
2. Java 配置
3. 注解配置：Spring 会自动扫描带有 `@Component`，`@Controller`，`@Service`，`@Repository` 这四个注解的类（需要设置 `<context:component-scan base-package="xxx" />`）







#### XML配置IoC容器示例

* ref-[ClassPathXmlApplicationContext读取配置文件 | Demo](https://www.w3cschool.cn/wkspring/dgte1ica.html)



此处给出一个使用 XML 方式配置 IoC 容器的示例。



**使用 `ApplicationContext context = new ClassPathXmlApplicationContext("BeanConfig.xml")` 可以读取指定的配置文件，并创建应用程序的上下文对象 `context`。再通过 `context.getBean()` 可以获取到指定的 Bean 对象。**

1. `ClassPathXmlApplicationContext` 读取配置文件
  
```java
@SpringBootApplication
public class SpringbootAppApplication {

	/**
	 * main方法
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println("SpringbootAppApplication Server is running ...");
		SpringApplication.run(SpringbootAppApplication.class, args);
		//使用框架 API ClassPathXmlApplicationContext() 来创建应用程序的上下文。这个 API 加载 beans 的配置文件并最终基于所提供的 API，它处理创建并初始化所有的对象，即在配置文件中提到的 beans
		ApplicationContext context = new ClassPathXmlApplicationContext("BeanConfig.xml");
		HelloWorld helloWorldObj = (HelloWorld) context.getBean("helloWorld");
		System.out.println(helloWorldObj.getMessage());
	}
}
```

2. 创建配置文件 `BeanConfig.xml` 并存放于 `springboot-app/src/main/resources` 目录下

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

    <bean id="helloWorld" class="com.lbs0912.springboot.app.service.HelloWorld">
        <property name="message" value="Hello World!"/>
    </bean>

</beans>
```


3. Bean实体类

```java
package com.lbs0912.springboot.app.service;

import lombok.Data;

@Data
public class HelloWorld {
    private String message;
}
```



此处，对 `BeanConfig.xml` 配置文件的位置做如下说明。**Spring 工程中默认的存放资源的路径为 `./src/main/resources`，即 `classPath` 的根目录。** 该默认路径可以修改，参考 [Spring Boot资源文件问题 | 掘金](https://juejin.cn/post/6989109110172024840)。

在使用 `new ClassPathXmlApplicationContext("BeanConfig.xml");` 时，默认情况下是从 `classPath` 的根目录，即 `./src/main/resources` 路径下读取配置文件。

如果将配置文件 `BeanConfig.xml` 存放于 `springboot-app/src/main/resources/beanConfig` 目录下，则对应的加载配置文件应修改为

```java
ApplicationContext context = new ClassPathXmlApplicationContext("beanConfig/BeanConfig.xml");
```







#### XML配置中注入集合类型值和NULL值


在注入属性时，Spring 允许注入集合类型的属性值，具体可分为

|   元素  |                 描述               |
|--------|------------------------------------|
| `<list>` |	注入一列值，允许重复                 |
| `<set>`  |   注入一组值，但不能重复              |
| `<map>`  | 注入 key-value 的集合，key 和 value 可以是任何类型 | 
| `<props>` |	注入 key-value 的集合，key 和 value 都是字符串类型 | 



* Bean


```java
@Data
public class JavaCollection {
    List addressList;
    Set addressSet;
    Map  addressMap;
    Properties addressProp;
}
```

* XML 配置

```xml
    <!-- Definition for javaCollection -->
    <bean id="javaCollection" class="com.lbs0912.springboot.app.service.JavaCollection">
        <!-- results in a setAddressList(java.util.List) call -->
        <property name="addressList">
            <list>
                <value>INDIA</value>
                <value>Pakistan</value>
                <value>USA</value>
                <value>USA</value>
            </list>
        </property>

        <!-- results in a setAddressSet(java.util.Set) call -->
        <property name="addressSet">
            <set>
                <value>INDIA</value>
                <value>Pakistan</value>
                <value>USA</value>
                <value>USA</value>
            </set>
        </property>

        <!-- results in a setAddressMap(java.util.Map) call -->
        <property name="addressMap">
            <map>
                <entry key="1" value="INDIA"/>
                <entry key="2" value="Pakistan"/>
                <entry key="3" value="USA"/>
                <entry key="4" value="USA"/>
            </map>
        </property>

        <!-- results in a setAddressProp(java.util.Properties) call -->
        <property name="addressProp">
            <props>
                <prop key="one">INDIA</prop>
                <prop key="two">Pakistan</prop>
                <prop key="three">USA</prop>
                <prop key="four">USA</prop>
            </props>
        </property>

    </bean>
```



* 更进一步地，可以在注入的集合元素中，注入 bean。



```xml
<property name="addressList">
    <list>
        <ref bean="address1"/>
        <ref bean="address2"/>
        <value>Pakistan</value>
    </list>
</property>

<property name="addressMap">
    <map>
        <entry key="one" value="INDIA"/>
        <entry key ="two" value-ref="address1"/>
        <entry key ="three" value-ref="address2"/>
    </map>
</property>
```


在注入属性时，也可以注入空值和NULL值，如下所示。

```xml
<bean id="userInfo" class="com.lbs0912.springboot.app.entity.UserInfo">
    <property name="name"><null/></property>
    <property name="age" value="" />
</bean>
```









#### @Component、@Controller、@Service、@Repository的区别
* ref 1-[Spring注解之@Component、@Controller、@Service、@Repository | 掘金](https://juejin.cn/post/6844904034596290568)
* ref 2-[Spring的@Component注解的理解 | CSDN](https://blog.csdn.net/weixin_37848710/article/details/79609130)
* ref 3-[@Repository注解的作用 | CSDN](https://blog.csdn.net/wqh0830/article/details/96109587)


##### @Component

**`@Component` 用于把当前类对象存入 Spring 容器中（把普通 `pojo` 实例化到 `Spring` 容器中），其效果等价于在 XML 文件中显示配置 `<bean id="" class="" />`。即下面 2 处代码效果等价。**

* `@Component` 注解

```xml
<!-- 使用注解配置IOC容器时，需要先配置 component-scan 属性 -->
<context:component-scan base-package="xxx.xxx.xxx"/>
```

```java
@Component
public class AccountServiceImpl implements AccountService{
    // ...
}
```


* XML配置

```xml
<bean id="accountServiceImpl" class="com.lbs.demo.AccountServiceImpl" />
```


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/spring-%40component-1.png)


`@Component` 注解具有 `value` 属性。`value` 属性用于指定 `bean` 的 `id`。当我们不写时，它的默认值是当前类名首字母改小写。当然一般情况下是不写的。


```java
@Component
//等价于 @Component("accountServiceImpl")
//等价于 @Component(value="accountServiceImpl")
public class AccountServiceImpl implements AccountService{
    // ...
}
```


##### @Controller、@Service、@Repository

`@Component`、`@Controller`、`@Service`、`@Repository` 这 4 个注解实际上没有任何本质区别，只是后三者是涉及一些命名规范而已，四者的注解效果是一致的。


|      注解	   |         含义        |
|-------------|---------------------|
| @Component  |	最普通的组件，可以被注入到 Spring 容器进行管理 |
| @Repository |	作用于持久层          |
| @Service	  | 作用于业务逻辑层       |
| @Controller | 作用于控制层（Spring Mvc的注解） |


下面，进行必要的补充说明。


* `@Repository` 注解作用于持久层，用来表明该类是用来执行与数据库相关的操作（即 DAO 对象），**并支持自动处理数据库操作产生的异常**。

>  原生 JAVA 操作数据库所产生的异常只定义了几种，但是产生数据库异常的原因却有很多种，这样对于数据库操作的报错排查造成了一定的影响。而 Spring 拓展了原生的持久层异常，针对不同的产生原因有了更多的异常进行描述。所以，在注解了 `@Repository` 的类上如果数据库操作中抛出了异常，就能对其进行处理，转而抛出的是翻译后的 Spring 专属数据库异常，方便我们对异常进行排查处理。

* 使用这 4 个注解配置IoC 容器时，都需要在 XML 配置文件中启用 Bean 的自动扫描功能。

```xml
<!-- 使用注解配置IOC容器时，需要先配置 component-scan 属性 -->
<context:component-scan base-package="xxx.xxx.xxx"/>
```






### 依赖注入的3种方式

常用的依赖注入（DI）方式有 3 种
1. 构造方法（Construct）注入
2. Setter 注入
3. 基于注解的注入（Field注入）：使用 `@Autowired`和 `@Resource` 注解实现依赖注入




#### 4种自动装配策略


当涉及到自动装配 Bean 的依赖关系时，Spring 有多种处理方式。Spring 提供了 4 种自动装配策略。


```java
public interface AutowireCapableBeanFactory{

	//无需自动装配
	int AUTOWIRE_NO = 0;

	//按名称自动装配bean属性
	int AUTOWIRE_BY_NAME = 1;

	//按类型自动装配bean属性
	int AUTOWIRE_BY_TYPE = 2;

	//按构造器自动装配
	int AUTOWIRE_CONSTRUCTOR = 3;

	//过时方法，Spring3.0之后不再支持
	@Deprecated
	int AUTOWIRE_AUTODETECT = 4;
}
```


#### @Autowired、@Resource和@Inject实现依赖注入的区别

1. `@Autowired` 是 Spring 自带的注解，`@Resource` 和 `@Inject` 属于 JDK 的注解，减少了和 Spring 的耦合。
   * `@Resource` 是 JSR250 规范的实现，在 `javax.annotation` 包下，属于 J2EE
   * `@Inject` 是 JSR330 中的规范，需要导入 `javax.inject.Inject jar`包
2. `@Autowired` 和 `@Inject` 默认是根据类型（`byType`）进行自动装配的。如果有多个类型一样的 Bean，需要组合其他注解使用，指定 Bean 的名称（`byName`）实现依赖注入
   * `@Autowired` 需要组合使用 `@Qualifier()` 注解
   * `@Inject` 需要组合使用 `@Named()` 注解
3. `@Resource` 是默认根据属性名称（`byName`）进行自动装配的。



##### @Autowired


Spring 2.5 中引入了 `@Autowired` 注解，源码如下。

```java
@Target({ElementType.CONSTRUCTOR, ElementType.METHOD, ElementType.PARAMETER, ElementType.FIELD, ElementType.ANNOTATION_TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Autowired {
  boolean required() default true;
}
```

可见，`@Autowired` 可以在下面这些地方使用。

```java
@Target(ElementType.CONSTRUCTOR)  //构造函数
@Target(ElementType.METHOD) //方法
@Target(ElementType.PARAMETER)  //方法参数
@Target(ElementType.FIELD) //字段、枚举的常量
@Target(ElementType.ANNOTATION_TYPE) //注解
```

* `@Autowired` 是 Spring 自带的注解，通过 `AutowiredAnnotationBeanPostProcessor` 类实现的依赖注入。 
* `@Autowired` 可以作用在 `CONSTRUCTOR`、`METHOD`、`PARAMETER`、`FIELD`、`ANNOTATION_TYPE`。 
* `@Autowired` 默认是根据类型（`byType`）进行自动装配的。
* 如果有多个类型一样的 Bean，需要组合使用 `@Qualifier()` 注解，指定 Bean 的名称进行依赖注入。此时，自动注入的策略会从默认根据类型（`byType`）变成根据名称（`byName`）。

```java
@Autowired
@Qualifier("helloWorldDao")
private HelloDao helloDao;
```

* 如果有多个类型一样的 Bean，也可以使用 `@Primary` 注解，设置首选的 Bean。
* 使用 `@Autowired` 注入 Bean 时，若 Bean 不存在，会抛出 `NoSuchBeanDefinitionException` 异常。可以使用 `@Autowired(require=false)`，当 Bean 不存在时不会抛出异常。


##### @Resource

`@Resource`是 JSR250 规范的实现，位于 `javax.annotation` 包下，其源码如下。


```java
@Target({TYPE, FIELD, METHOD})
@Retention(RUNTIME)
public @interface Resource {
    String name() default "";
    // 其他省略
}
```


可见，`@Resource` 可以在下面这些地方使用。

```java
@Target(ElementType.TYPE)  //接口、类、枚举、注解
@Target(ElementType.FIELD) //字段、枚举的常量
@Target(ElementType.METHOD) //方法
```

* `@Resource` 是 JSR250 规范的实现，在 `javax.annotation` 包下，属于 J2EE，减少了和 Spring 的耦合。
* `@Resource` 可以作用 `TYPE`、`FIELD`、`METHOD` 上。
* `@Resource` 是默认根据属性名称（`byName`）进行自动装配的。



##### @Inject

`@Inject` 是 JSR330 (Dependency Injection for Java）中的规范，需要导入 `javax.inject.Inject jar`包，才能实现注入。

```java
@Target({ METHOD, CONSTRUCTOR, FIELD })
@Retention(RUNTIME)
@Documented
public @interface Inject {

}
```


可见，`@Inject` 可以在下面这些地方使用。

```java
@Target(ElementType.CONSTRUCTOR)  //构造函数
@Target(ElementType.METHOD) //方法
@Target(ElementType.FIELD) //字段、枚举的常量
```

* `@Inject` 可以作用 `CONSTRUCTOR`、`METHOD`、`FIELD` 上。
* `@Inject` 是根据类型（`byType`）进行自动装配的，如果需要按名称进行装配，则需要配合 `@Named`。`@Autowired` 默认也是根据类型进行装配，若要按照名字装配，需要配合使用 `@Qualifier`。`@Named` 和 `@Qualifier` 的作用类似。

```java
@Inject
@Named("BMW")
private Car car;
```




#### 注入方式的选择
* ref 1-[为什么推荐构造器注入方式 | Java全栈知识体系](https://pdai.tech/md/spring/spring-x-framework-ioc.html)
* ref 1-[Spring为啥不推荐使用@Autowired注解 | 掘金](https://juejin.cn/post/7023618746501562399#comment)


> Since you can mix constructor-based and setter-based DI, it is a good rule of thumb to use constructors for mandatory dependencies and setter methods or configuration methods for optional dependencies.  -- [spring.io](https://spring.io/)


注入方式的选择策略

* 对于强制依赖的情况，建议使用用构造器方式注入
* 对于可选或可变的依赖，建议使用 Setter 注入


##### 为什么推荐构造器注入方式



> The Spring team generally advocates constructor injection as it enables one to implement application components as immutable objects and to ensure that required dependencies are not null. Furthermore constructor-injected components are always returned to client (calling) code in a fully initialized state.    -- [spring.io](https://spring.io/)


**Spring 官方推荐使用构造器注入的方式。构造器注入的方式能够保证注入的组件不可变，并且确保需要的依赖不为空。此外，构造器注入的依赖总是能够在返回客户端（组件）代码的时候保证完全初始化的状态。**


下面结合一段代码，对上面这句话进行解读。

```java
@Service
public class UserServiceImpl {
    /**
     * user dao impl.
     */
    private final UserDaoImpl userDao;

    /**
     * init.
     * @param userDaoImpl user dao impl
     */
    public UserServiceImpl(final UserDaoImpl userDaoImpl) {
        this.userDao = userDaoImpl;
    }
}
```

1. **依赖不可变**
对注入的依赖项，可以添加 `final` 关键字，保证其不可变，。

2. **依赖不为空**
当要实例化 `UserServiceImpl` 的时候，由于实现了含参的构造函数，所以不会调用默认的无参构造函数。Spring 在传入构造函数的参数时，若有所需的参数，则正常传入；若没有所需的参数，则会报错。


3. **完全初始化的状态**
向构造器传参之前，要确保注入的内容不为空（即「依赖不为空」），那么肯定要调用依赖组件的构造方法完成实例化。而在 Java 类加载实例化的过程中，构造方法是最后一步调用的，所以返回来的依赖项，都是初始化之后的状态。



##### 循环依赖时Field注入方式在项目启动时不会报错


若发生循环依赖
* Field 注入方式下，项目启动时并不会报错。
* 使用构造器注入的方式，项目启动时即可抛出异常。


```java
public class A {
    @Autowired
    private B b;
}

public class B {
    @Autowired
    private A a;
}
```

如上代码所示，发生了循环依赖，即 A 里面注入 B，B 里面又注入 A。
1. Field 注入方式下，项目启动时并不会报错，只有在使用到这个 Bean 时候才会报错。
2. 如果使用构造器注入，在 Spring 项目启动的时候，就会抛出`BeanCurrentlyInCreationException：Requested bean is currently in creation: Is there an unresolvable circular reference` 的错误，从而提醒你避免循环依赖。




##### 构造函数中使用Field注入导致的NPE


下面，给出一个在构造函数中使用 `@Autowired` 注入项导致 NPE 的示例。


```java
@Autowired
private User user;

private String company;

public UserDaoImpl(){
    this.company = user.getCompany();
}
```

上述代码在编译时并不会报错，但在运行之后会产生 NPE。

```java
Instantiation of bean failed; nested exception is org.springframework.beans.BeanInstantiationException: Failed to instantiate [...]: Constructor threw exception; nested exception is java.lang.NullPointerException
```

**这是因为 Java 在初始化一个类时，是按照「静态变量或静态语句块」–>「实例变量或初始化语句块」 –>「构造方法」-> 「@Autowired」的顺序。** 所以在执行这个类的构造方法时，`user` 对象尚未被注入，它的值还是 `null`。






## 面向切面编程（AOP）

面向切面编程（`Aspect Oriented Programming`，AOP），是一种设计思想（同 IoC，都是一种设计思想），指的是通过预编译方式和运行期间动态代理的方式，实现程序的统一维护。

AOP模式下，会将分散在各个业务逻辑代码中相同的代码，通过「横向切割」的方式抽取到一个独立的模块中，如下图所示。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/java-aop-introduce-0.png)



> OOP 和 AOP 的设计思想对比

面向对象编程（OOP）强调的是对业务处理过程的实体及其属性和行为，进行抽象封装，以获得更加清晰高效的逻辑单元划分。而 AOP 则是针对业务处理过程中的切面进行提取，它所面对的是处理过程的某个步骤或阶段，以获得逻辑过程的中各部分之间低耦合的隔离效果。这两种设计思想在目标上有着本质的差异。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/java-aop-introduce-1.png)

### 相关术语
* ref 1-[Spring AOP中通知、连接点、切点、切面的区分 | CSDN](https://blog.csdn.net/fly910905/article/details/84025425)


#### 通知

* AOP中，切面的工作被称为通知（`Advice`）。
* 通知定义了切面是什么以及何时使用。除了描述切面要完成的工作，通知的类型还决定了何时执行这个工作。
* Spring 支持 5 种通知类型
    * 前置通知（Before Advice）
    * 后置通知（After Returning Advice）
    * 最终通知（After finally Advice）
    * 异常通知（After throwing Advice）
    * 环绕通知（Around Advice）

#### 连接点
* 连接点（`Joinpoint`）是一个应用执行过程中能够插入一个切面的点。在 AOP 中表示为 “在哪里干”。
* 连接点可以是调用方法时、抛出异常时、甚至修改字段时。Spring 只支持方法执行连接点。
* 切面代码可以利用这些连接点插入到应用的正规流程中。


#### 切点
* 如果通知定义了 “什么” 和 “何时”。那么切点（`Pointcut`）就定义了 “何处”。
* 切点会匹配通知所要织入的一个或者多个连接点。
* 连接点和切点的示意图如下。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/spring-aop-basic-1.png)

#### 切面
* 切面（`Aspect`）是通知和切点的集合，通知和切点共同定义了切面的全部功能，即—它是什么，在何时何处完成何功能。

#### 引入 
* 引入（`Introduction`）允许我们向现有的类中添加方法或属性

#### 织入
* 织入（`Weaving`）是把切面应用到目标对象并创建新的代理对象的过程。
* **切面在指定的连接点被织入到目标对象中。** 在目标对象的生命周期里有多个点可以进行织入
  1. 编译期：切面在目标类编译时被织入
  2. 类加载期：切面在目标类加载到 JVM 时被织入
  3. 运行期：切面在应用运行的某个时刻被织入
* Spring AOP 的实现方式是动态织入，基于运行时增强的代理技术。



### AspectJ
* AspectJ 是一个 Java 实现的 AOP 框架，它能对 Java 代码进行 AOP 编译（一般在编译期进行）。
* AspectJ 是 AOP 编程的完全解决方案，Spring AOP 则致力于解决企业级开发中最普遍的 AOP（方法织入）。


|         Spring AOP         |          AspectJ       |
|----------------------------|------------------------|
|     在纯 Java 中实现         |   使用 Java 编程语言的扩展实现 |
|    不需要单独的编译过程        | 除非设置 LTW，否则需要 AspectJ 编译器 (ajc) | 
| 只能使用运行时织入        |  运行时织入不可用。支持编译时、编译后和加载时织入 | 
| 功能不强，仅支持方法级编织  | 功能更强大，可以编织字段、方法、构造函数、静态初始值设定项、最终类/方法等 | 
| 只能在由 Spring 容器管理的 bean 上实现 | 可以在所有域对象上实现 | 
| 仅支持方法执行切入点   | 支持所有切入点  |
| 代理是由目标对象创建的，并且切面应用在这些代理上 | 在执行应用程序之前（运行前），各方面直接在代码中进行织入 | 
| 性能弱于 AspectJ     |  较好的性能  | 
| 易于学习和应用      | 相对于 Spring AOP 来说更复杂 |


### AOP的配置方式

Spring AOP 的配置方式，可分为两种
1. XML Schema 配置方式
2. 基于 `@AspectJ` 注解的配置方式


#### XML Schema 配置方式

Spring 提供了使用 `aop` 命名空间来定义一个切面。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
 http://www.springframework.org/schema/beans/spring-beans.xsd
 http://www.springframework.org/schema/aop
 http://www.springframework.org/schema/aop/spring-aop.xsd
 http://www.springframework.org/schema/context
 http://www.springframework.org/schema/context/spring-context.xsd
">

    <context:component-scan base-package="tech.pdai.springframework" />

    <aop:aspectj-autoproxy/>

    <!-- 目标类 -->
    <bean id="demoService" class="tech.pdai.springframework.service.AopDemoServiceImpl">
        <!-- configure properties of bean here as normal -->
    </bean>

    <!-- 切面 -->
    <bean id="logAspect" class="tech.pdai.springframework.aspect.LogAspect">
        <!-- configure properties of aspect here as normal -->
    </bean>

    <aop:config>
        <!-- 配置切面 -->
        <aop:aspect ref="logAspect">
            <!-- 配置切入点 -->
            <aop:pointcut id="pointCutMethod" expression="execution(* tech.pdai.springframework.service.*.*(..))"/>
            <!-- 环绕通知 -->
            <aop:around method="doAround" pointcut-ref="pointCutMethod"/>
            <!-- 前置通知 -->
            <aop:before method="doBefore" pointcut-ref="pointCutMethod"/>
            <!-- 后置通知；returning属性：用于设置后置通知的第二个参数的名称，类型是Object -->
            <aop:after-returning method="doAfterReturning" pointcut-ref="pointCutMethod" returning="result"/>
            <!-- 异常通知：如果没有异常，将不会执行增强；throwing属性：用于设置通知第二个参数的的名称、类型-->
            <aop:after-throwing method="doAfterThrowing" pointcut-ref="pointCutMethod" throwing="e"/>
            <!-- 最终通知 -->
            <aop:after method="doAfter" pointcut-ref="pointCutMethod"/>
        </aop:aspect>
    </aop:config>

    <!-- more bean definitions for data access objects go here -->
</beans>
```





#### 基于@AspectJ注解的配置方式


Spring 使用了 AspectJ 框架为 AOP 的实现提供了一套注解，常用的注解包括
* `@Aspect`
* `@Pointcut`
* `@Before`
* `@AfterReturning`
* `@Around`
* `@After`



Spring AOP 的实现方式是动态织入，动态织入的方式是在运行时动态将要增强的代码织入到目标类中，这样往往是通过「动态代理技术」完成的，如 Java JDK 的动态代理（Proxy，底层通过反射实现）或者 CGLIB 的动态代理（底层通过继承实现）。Spring AOP 采用的就是基于运行时增强的代理技术。




## Spring MVC

Spring MVC 是 Spring 在 Spring Container Core 和 AOP 等技术基础上，遵循 Web MVC 的规范推出的 Web 开发框架，目的是为了简化 Java 栈的 Web 开发。


> MVC（Model View Controller）是模型（Model）－ 视图（View）－ 控制器（Controller）的缩写，是一种软件设计规范。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/spring-mvc-structure-1.png)



### Spring MVC的请求流程



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/spring-mvc-step-by-step-1.png)


结合上图，Spring MVC 的请求流程如下
1. 用户发送请求 -> `DispatcherServlet`
   * 前端控制器收到请求后自己不进行处理，而是委托给其他的解析器进行处理，作为统一访问点，进行全局的流程控制。

2. `DispatcherServlet` -> `HandlerMapping`
    * `HandlerMapping` 将会把请求映射为 `HandlerExecutionChain` 对象（包含一
个 `Handler` 处理器、多个 `HandlerInterceptor` 拦截器）。
   * 通过这种「策略模式」，很容易添加新的映射策略。

3. `DispatcherServlet` -> `HandlerAdapter`
    * `HandlerAdapter` 将会把处理器包装为适配器，从而支持多种类型的处理器。
    * 采用这种「适配器设计模式」，可以很容易地支持多种类型的处理器。
4. `HandlerAdapter` -> 处理器功能处理方法的调用
    * `HandlerAdapter` 将会根据适配的结果，调用真正的处理器的功能处理方法，完成功能处理。
    * `HandlerAdapter` 会返回一个 `ModelAndView` 对象（包含模型数据、逻辑视图名）。 
5. `ModelAndView` 的逻辑视图名 -> `ViewResolver`
    * `ViewResolver` 将把逻辑视图名解析为具体的 `View`。
    * 通过这种「策略模式」，很容易更换其他视图技术。
6. `View` -> 渲染
    * `View` 会根据传进来的 `Model` 模型数据进行渲染。
    * 此处的 `Model` 实际是一个 `Map` 数据结构，因此很容易支持其他视图技术。
7. 返回控制权给 `DispatcherServlet`，由 `DispatcherServlet` 返回响应给用户。




### 创建Controller的3种方式

有 3 种方式来实现一个 MVC 中的 `Controller`
1. 通过 `@Controller` 注解来标记某个类是 `Controller` 类，通过 `@RequesMapping` 注解来标记函数对应的 URL
2. 让类实现 `Controller` 接口，来定义一个 `Controller`
3. 让类实现 `Servlet` 接口，来定义一个 `Controller`


```java
// 方法1：通过@Controller、@RequestMapping来定义
@Controller
public class DemoController {
    @RequestMapping("/FlyFish")
    public ModelAndView getEmployeeName() {
        ModelAndView model = new ModelAndView("FlyFish");        
        model.addObject("message", "FlyFish");       
        return model; 
    }  
}

// 方法2：实现Controller接口 + xml配置文件，配置 DemoController 与 URL 的对应关系
public class DemoController implements Controller {
    @Override
    public ModelAndView handleRequest(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        ModelAndView model = new ModelAndView("FlyFish");
        model.addObject("message", "FlyFish");
        return model;
    }
}

// 方法3：实现 Servlet 接口 + xml配置文件，配置 DemoController 类与 URL的对应关系
public class DemoServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.getWriter().write("Hello World.");
  }
}
```


### HandlerAdapter和适配器设计模式

Spring MVC 项目启动的时候，Spring 容器会加载 `Controller` 类，并且解析出 URL 对应的处理函数，封装成 `Handler` 对象，存储到 `HandlerMapping` 对象中。

当有请求到来的时候，`DispatcherServlet` 从 `HanderMapping` 中，查找请求 URL 对应的 `Handler`，然后调用执行 `Handler` 对应的函数代码，最后将执行结果返回给客户端。

但是，对不同方式定义的 `Controller`（有 3 种实现方式），其函数的定义（函数名、入参、返回值等）是不统一的。这样的话，`DispatcherServlet` 就需要根据不同类型的 `Controller` 来调用不同的函数。


Spring 利用「适配器设计模式」来解决该问题，Spring 定义了统一的接口 `HandlerAdapter`，将不同方式定义的 `Controller` 类中的函数，适配为统一的函数定义。Spring 对每种 `Controller` 定义了对应的适配器类，包括
1. `AnnotationMethodHandlerAdapter`
2. `SimpleControllerHandlerAdapter`
3. `SimpleServletHandlerAdapter`


利用「适配器设计模式」，在 `DispatcherServlet` 类中就不需要区分对待不同的 `Controller` 对象了，统一调用`HandlerAdapter` 的 `handle()` 方法就可以了。




### Servlet

* [Servlet 教程 | 菜鸟教程](https://www.runoob.com/servlet/servlet-tutorial.html)


Servlet 为创建基于 web 的应用程序提供了基于组件、独立于平台的方法，可以不受 CGI 程序的性能限制。Servlet 有权限访问所有的 Java API，包括访问企业级数据库的 JDBC API。

使用 Java Servlet 来开发基于 web 的应用程序。（和 Spring 无关，放在此处，只是为了对比 Spring MVC 和 Servlet）



#### Servlet的生命周期

* [Servlet 生命周期 | 菜鸟教程](https://www.runoob.com/servlet/servlet-life-cycle.html)


Servlet 生命周期可被定义为从创建直到毁灭的整个过程。以下是 Servlet 遵循的过程
1. Servlet 初始化后调用 `init()` 方法。
2. Servlet 调用 `service()` 方法来处理客户端的请求。
3. Servlet 销毁前调用 `destroy()` 方法。
4. 最后，Servlet 是由 JVM 的垃圾回收器进行垃圾回收的。

##### init方法

init 方法被设计成只调用一次。它在第一次创建 Servlet 时被调用，在后续每次用户请求时不再调用。因此，它是用于一次性初始化，就像 Applet 的 init 方法一样。

Servlet 创建于用户第一次调用对应于该 Servlet 的 URL 时，但是您也可以指定 Servlet 在服务器第一次启动时被加载。

当用户调用一个 Servlet 时，就会创建一个 Servlet 实例，每一个用户请求都会产生一个新的线程，适当的时候移交给 doGet 或 doPost 方法。init() 方法简单地创建或加载一些数据，这些数据将被用于 Servlet 的整个生命周期。


##### service方法

service() 方法是执行实际任务的主要方法。Servlet 容器（即 Web 服务器）调用 service() 方法来处理来自客户端（浏览器）的请求，并把格式化的响应写回给客户端。

每次服务器接收到一个 Servlet 请求时，服务器会产生一个新的线程并调用服务。service() 方法检查 HTTP 请求类型（GET、POST、PUT、DELETE 等），并在适当的时候调用 doGet、doPost、doPut，doDelete 等方法。

下面是该方法的特征

```java
public void service(ServletRequest request, 
                    ServletResponse response) 
      throws ServletException, IOException{
}
```

service() 方法由容器调用，service 方法在适当的时候调用 doGet、doPost、doPut、doDelete 等方法。所以，您不用对 service() 方法做任何动作，您只需要根据来自客户端的请求类型来重写 doGet() 或 doPost() 即可。

doGet() 和 doPost() 方法是每次服务请求中最常用的方法。下面是这两种方法的特征。


##### doGet方法

GET 请求来自于一个 URL 的正常请求，或者来自于一个未指定 METHOD 的 HTML 表单，它由 doGet() 方法处理。

```java
public void doGet(HttpServletRequest request,
                  HttpServletResponse response)
    throws ServletException, IOException {
    // Servlet 代码
}
```

##### doPost方法

POST 请求来自于一个特别指定了 METHOD 为 POST 的 HTML 表单，它由 doPost() 方法处理。

```java
public void doPost(HttpServletRequest request,
                   HttpServletResponse response)
    throws ServletException, IOException {
    // Servlet 代码
}
```

##### destroy方法

destroy() 方法只会被调用一次，在 Servlet 生命周期结束时被调用。destroy() 方法可以让您的 Servlet 关闭数据库连接、停止后台线程、把 Cookie 列表或点击计数器写入到磁盘，并执行其他类似的清理活动。

在调用 destroy() 方法之后，servlet 对象被标记为垃圾回收。destroy 方法定义如下所示：

```java
public void destroy() {
    // 终止化代码...
}
```



## AOP的具体实现


在上文中提到，面向切面编程（AOP）是一种设计思想，类比于「控制反转是一种设计思想，依赖注入（DI）是 IoC 的具体实现方式」，Spring 中 AOP 的具体实现包括
1. 过滤器 `Filter`（接口在 `Servlet` 包中，多用于 Spring MVC项目，过滤的是请求）
2. 拦截器 `Interceptor`
   * `HandlerInterceptor`（接口在 `Servlet` 包中，多用于 Spring MVC项目，拦截的是请求）
   * `MethodInterceptor` （环绕通知对应的接口，拦截的是方法）



### 通知对应的接口

* ref 1-[Spring Aop MethodInterceptor接口 | CSDN](https://blog.csdn.net/Viogs/article/details/49704185)


在上文中提到，AOP 支持 5 种类型的通知，其对应的接口对照如下表所示。
* 前置通知（Before Advice）对应的接口是 `MethodBeforeAdvice`
* 后置通知（After Returning Advice）对应的接口是 `AfterReturningAdvice`
* 异常通知（After throwing Advice）对应的接口是 `ThrowsAdvice`
* 环绕通知（Around Advice）对应的接口是 `MethodInterceptor`  




### 过滤器（Filter）

* ref 1-[过滤器 Filter | Spring Boot 指南](https://snailclimb.gitee.io/springboot-guide/#/)


过滤器（`Filter`）主要是用来过滤用户请求的，它允许我们对用户请求进行前置处理和后置处理，比如实现 URL 级别的权限控制、过滤非法请求等等。

`Filter` 是依赖于 `Servlet` 容器，`Filter` 接口就在 `Servlet` 包下面，属于 `Servlet` 规范的一部分。

若要自定义一个过滤器（`Filter`），只需要实现 `javax.Servlet.Filter` 接口并重写其方法即可。

```java
public interface Filter {

    //初始化过滤器后执行的操作
    default void init(FilterConfig filterConfig) throws ServletException {
    
    }
   
    // 对请求进行过滤
    void doFilter(ServletRequest var1, ServletResponse var2, FilterChain var3) throws IOException, ServletException;
   
    // 销毁过滤器后执行的操作，主要用户对某些资源的回收
    default void destroy() {
    
    }
}
```


使用过滤器（`Filter`）的步骤如下
1. 自定义一个过滤器，实现 `javax.Servlet.Filter` 接口并重写其方法，在 `doFilter()` 方法中进行过滤逻辑。
2. 在配置中注册自定义的过滤器，也可以使用 `@WebFilter` 注解配置自定义的过滤器。
3. 若要使用多个过滤器，可通过 `FilterRegistrationBean` 的 `setOrder()` 方法指定过滤器的执行顺序。


### 拦截器（Interceptor）

* ref 1-[拦截器 Filter | Spring Boot 指南](https://snailclimb.gitee.io/springboot-guide/#/)
* ref 2-[拦截器的创建和使用 | Blog](https://aijishu.com/a/1060000000004605)



常用的拦截器（`Interceptor`）有两种 
1. `HandlerInterceptor`（接口在 `Servlet` 包中，多用于 Spring MVC项目，拦截的是请求）
2. `MethodInterceptor` （环绕通知对应的接口，拦截的是方法）



#### HandlerInterceptor

使用 `HandlerInterceptor` 的步骤如下
1. 实现 `org.springframework.web.servlet.HandlerInterceptor` 接口或继承 `org.springframework.web.servlet.handler.HandlerInterceptorAdapter` 类并且其方法。其中，`preHandle` 方法会返回一个布尔值，若为 `true`，意味着请求将继续到达 `Controller` 被处理。


```java
//HandlerInterceptor接口
public interface HandlerInterceptor {
    default boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        return true;
    }

    default void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable ModelAndView modelAndView) throws Exception {
    }

    default void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable Exception ex) throws Exception {
    }
}
```

```java
//HandlerInterceptorAdapter抽象类
//Spring 5 中已经被废弃
public abstract class HandlerInterceptorAdapter implements AsyncHandlerInterceptor {
    public HandlerInterceptorAdapter() {
    }

    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        return true;
    }

    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable ModelAndView modelAndView) throws Exception {
    }

    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable Exception ex) throws Exception {
    }

    public void afterConcurrentHandlingStarted(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    }
}
```


> 需要注意的是，`HandlerInterceptorAdapter` 类在 Spring 5 中已经被废弃，新版本中改为
解决办法实现 `HandlerInterceptor` 接口实现拦截器。 —— [Spring MVC中HandlerInterceptorAdapter和WebMvcConfigurerAdapter过时被弃用的问题](https://blog.csdn.net/qq_45804925/article/details/113801375)。




2. 配置拦截器，实现 `org.springframework.web.servlet.config.annotation.WebMvcConfigurer` 接口并重写其 `addInterceptors()` 方法，注册自定义的拦截器。

```java
@Configuration
public class MyWebConfig implements WebMvcConfigurer {
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        //注册拦截器
        registry.addInterceptor(new MyDefInterceptor());
                .addPathPatterns("/myUrl");
    }
}
```


#### MethodInterceptor

`MethodInterceptor` 是 AOP 项目中的拦截器（对应于环绕通知），它拦截的目标是方法。实现 `MethodInterceptor` 拦截器有两种方案
1. 实现 `MethodInterceptor` 接口并重写其 `invoke()` 方法


```java
public interface MethodInterceptor {
    Object invoke(MethodInvocation var1) throws Throwable;
}
```

2. 使用 `@AspectJ` 注解

```java
@Component
@Aspect
public class CustomAutoAspectJInterceptor {
    private Logger logger = LoggerFactory.getLogger(CustomAutoAspectJInterceptor.class);
    
    @Around("execution (* com.lbs.springboot.controller.*.*(..))")
    public Object around(ProceedingJoinPoint point) throws Throwable{
        logger.info("CustomAutoAspectJInterceptor ==> invoke method: process method class is {}", point.getTarget().getClass());
        
        //TODO 处理操作
        
        return point.proceed();
    }
}
```






此处，给出一个 `MethodInterceptor` 应用实例（@JD投放-素材中心JSF），通过 `MethodInterceptor` 自定义拦截器，对接口请求的四级地址入参进行校验。


* `spring-config-jsf-interceptor.xml` 配置文件


```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.2.xsd"
       default-autowire="byName">


    <bean id="debugLogMethodInterceptor" class="com.jd.material.jsf.intercepter.DebugLogMethodInterceptor"/>
    <bean id="accessAuthMethodInterceptor" class="com.jd.material.jsf.intercepter.AccessAuthMethodInterceptor" init-method="syncAuthConfigInfo"/>
    <bean id="cacheMethodInterceptor" class="com.jd.material.jsf.intercepter.CacheMethodInterceptor"/>
    <bean id="logMethodInterceptor" class="com.jd.material.jsf.intercepter.LogMethodInterceptor"/>
    <bean id="rateLimitMethodInterceptor" class="com.jd.material.jsf.intercepter.RateLimitMethodInterceptor"/>

    <bean class="org.springframework.aop.framework.autoproxy.BeanNameAutoProxyCreator">
        <property name="beanNames">
            <list>
                <value>productInfoService</value>
                <value>advertInfoService</value>
                <value>materialInfoService</value>
                <value>adAndPrdInfoService</value>
                <value>spAdAndPrdInfoService</value>
                <value>materialChannelInfoService</value>
            </list>
        </property>
        <property name="proxyTargetClass" value="true"/>
        <property name="interceptorNames">
            <list>
                <value>logMethodInterceptor</value>
                <value>debugLogMethodInterceptor</value>
                <value>accessAuthMethodInterceptor</value>
            </list>
        </property>
    </bean>
 
</beans>
```


* `AccessAuthMethodInterceptor` 权限校验类如下，在该类中进行四级地址入参的校验。

```java
@Slf4j
public class AccessAuthMethodInterceptor implements MethodInterceptor {
    @Override
    public Object invoke(MethodInvocation invocation) throws Throwable {
        if(!RpcContext.getContext().isProviderSide()){
            return invocation.proceed();
        }
        String authStatus = (String) RpcContext.getContext().getAttachment(MATERIAL_AUTH_KEY);
        MaterialAccess annotation = invocation.getMethod().getAnnotation(MaterialAccess.class);
        //不需要验证权限，或者已经验证过权限的，直接跳过
        if(annotation == null || (!StringUtils.isBlank(authStatus) && "true".equals(authStatus))){
            return invocation.proceed();
        }

        if(privateKeyAuth(invocation)){
           return invocation.proceed();
        }
        String appId = getAppId(invocation.getArguments());
 
        //防止误拦截内部调用，加上标记
        RpcContext.getContext().setAttachment(MATERIAL_AUTH_KEY, "true");
        CallerInfo info = Ump.methodReg(getUmpKey(invocation,appId));

        // ...
        
        // 四级地址校验
        if(null != invocation.getArguments()){
            this.checkOrFormatAreaCode(invocation);
        }
        Object ret =  invocation.proceed();
        Ump.methodRegEnd(info);
        //释放权限校验标识
        RpcContext.getContext().setAttachment(MATERIAL_AUTH_KEY, null);
        return ret;
    }
     
    // ...
}
```


* 四级地址校验方法 `checkOrFormatAreaCode` 如下。**需要指出的是，`Object[] arguments = invocation.getArguments();` 得到的是对象的引用，在后续 `arguments[i] = sysParam;` 更新参数时，会直接改变 `invocation` 对象的值。**


```java
    /**
     * 四级地址校验 若格式不符则置空
     * @param invocation  invocation
     */
    private void checkOrFormatAreaCode(MethodInvocation invocation) {
        Object[] arguments = invocation.getArguments();
        try{
            if(null != arguments){
                for(int i=0;i<arguments.length;i++){
                    if(arguments[i] instanceof SysParam){
                        SysParam sysParam = (SysParam) arguments[i];
                        if(null != sysParam.getClientInfo() && StringUtils.isNotEmpty(sysParam.getClientInfo().getArea())){
                            String areaCode =  EasyUtils.toStringTrim(sysParam.getClientInfo().getArea());
                            if(!Pattern.matches(AREA_FORMAT, areaCode)){
                                sysParam.getClientInfo().setArea("");
                                arguments[i] = sysParam; //update
                            }
                        }
                    }
                }
            }
        }catch (Exception e){
            log.error("checkOrFormatAreaCode exception: ",e);
        }
    }
    
    private boolean checkArea(MethodInvocation invocation){
        if(invocation.getArguments()==null){
            return true;
        }
        for(Object arg : invocation.getArguments()){
            if(arg instanceof SysParam){
                SysParam sysParam = (SysParam) arg;
                if(sysParam.getClientInfo()==null || StringUtils.isEmpty(sysParam.getClientInfo().getArea())){
                    return true;
                }
                return Pattern.matches(AREA_FORMAT, sysParam.getClientInfo().getArea());
            }
        }
        return true;
    }
```

### 过滤器和拦截器的区别
* ref 1-[过滤器和拦截器的 6 个区别 | Segmentfault](https://segmentfault.com/a/1190000022833940)



1. 实现原理不同
   * 过滤器和拦截器的底层实现方式大不相同。
   * 过滤器是基于函数回调的。
   * 拦截器则是基于 Java 的反射机制（动态代理）实现的。
2. 使用范围不同
   * 过滤器实现的是 `javax.servlet.Filter` 接口，而这个接口是在 Servlet 规范中定义的，也就是说过滤器 Filter 的使用要依赖于 Tomcat 等容器，导致它只能在 web 程序中使用。
   * 拦截器（Interceptor）是一个 Spring 组件，并由 Spring 容器管理，并不依赖 Tomcat 等容器，是可以单独使用的。不仅能应用在 web 程序中，也可以用于 Application、Swing 等程序中。
3. 触发时机不同
   * 如下图所示，过滤器 Filter 是在请求进入容器后，但在进入 servlet 之前进行预处理，请求结束是在 servlet 处理完以后。
   * 拦截器 Interceptor 是在请求进入 servlet 后，在进入 Controller 之前进行预处理的，Controller 中渲染了对应的视图之后请求结束。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/spring-interceptor-filter-1.png)



## Spring中用到的设计模式

* ref 1-[Spring用到了哪些设计模式 | 掘金](https://juejin.cn/post/7066266639355871268)


Spring 框架中用到的设计模式，主要包括
1. 代理模式
2. 策略模式
3. 装饰器模式
4. 单例模式
5. 工厂模式
6. 观察者模式
7. 模板方法
8. 适配器模式

下面进行简要的分析。


> 1. 代理模式
* 代理模式可分为静态代理和动态代理两种方式。Spring 的 AOP 采用的是动态代理的方式。
* **Spring 通过动态代理对类进行方法级别的切面增强，动态生成目标对象的代理类，并在代理类的方法中设置拦截器，通过执行拦截器中的逻辑增强了代理方法的功能，从而实现 AOP。**

> 2. 策略模式
* Spring AOP 是通过动态代理来实现的。动态代理又可分为 JDK 动态代理和 CGLIB 代理。Spring 会在运行时，动态地选择不同的动态代理实现方式，这个应用场景就是策略模式的应用。
* Spring 的 `AopProxy` 是策略接口，`JdkDynamicAopProxy`、`CglibAopProxy` 是两个实现了 `AopProxy` 接口的策略类。
* 在策略模式中，策略的创建一般通过工厂方法来实现。对应到 Spring 源码，`AopProxyFactory` 是一个工厂类接口，`DefaultAopProxyFactory` 是一个默认的工厂类，用来创建 `AopProxy` 对象。


> 3. 装饰器模式
* 装饰模式（Decorator）是一种结构型设计模式，允许向一个现有的对象添加新的功能，同时又不改变其结构。
* **装饰模式中创建了一个「装饰类」，用来包装原有的类**，并在保持类方法签名完整性的前提下，提供了额外的功能。
* 装饰模式中，动态地给一个对象添加一些额外的职责。就增加功能来说，装饰器模式相比生成子类更为灵活。
* Spring 中的 `TransactionAwareCacheDecorator` 增加了对事务的支持，在事务提交、回滚的时候分别对 `Cache` 的数据进行处理；同时，它也实现了 `Cache` 接口，将所有的操作都委托给`targetCache` 来实现，并对其中的写操作添加了事务功能。


> 4. 单例模式
* Spring 中，Bean 可以被定义为多例模式 `Prototype` 和单例模式 `Singleton`，默认为单例模式。
* Spring 的 `DefaultSingletonBeanRegistry` 类的 `getSingleton()` 方法，通过单例注册表的方式，借助并发容器 `ConcurrentHashMap`，实现了获取单例 Bean。对应代码如下。

```java
public class DefaultSingletonBeanRegistry {
    
    //使用了线程安全容器ConcurrentHashMap，保存各种单实例对象
    private final Map singletonObjects = new ConcurrentHashMap;

    protected Object getSingleton(String beanName) {
        //先到HashMap中拿Object
        Object singletonObject = singletonObjects.get(beanName);
    
        //如果没拿到通过反射创建一个对象实例，并添加到HashMap中
        if (singletonObject == null) {
            singletonObjects.put(beanName,Class.forName(beanName).newInstance();
        }
        //返回对象实例
        return singletonObjects.get(beanName);
    }
}
```

> 5. 工厂模式
* Spring 的 `BeanFactory` 就是工厂模式的体现。我们可以通过它的具体实现类（比如 `ClassPathXmlApplicationContext`）来获取 Bean。
* 如下代码所示，使用者不需要自己来 `new` 对象，而是通过工厂类的方法 `getBean()` 来获取对象实例。Spring 是通过反射机制来创建 Bean 的。

```java
BeanFactory bf = new ClassPathXmlApplicationContext("spring.xml");
FlyFish flyFishBean = (FlyFish) bf.getBean("flyfishBean");
```

> 6. 观察者模式
* Spring 中实现的观察者模式包含 3 部分，Event事件（相当于消息）、Listener监听者（相当于观察者）、Publisher发送者（相当于被观察者）。

```java
// Event事件
public class DemoEvent extends ApplicationEvent {
  private String message;

  public DemoEvent(Object source, String message) {
    super(source);
  }

  public String getMessage() {
    return this.message;
  }
}

// Listener监听者
@Component
public class DemoListener implements ApplicationListener {
  @Override
  public void onApplicationEvent(DemoEvent demoEvent) {
    String message = demoEvent.getMessage();
    System.out.println(message);
  }
}

// Publisher发送者
@Component
public class DemoPublisher {
  @Autowired
  private ApplicationContext applicationContext;

  public void publishEvent(DemoEvent demoEvent) {
    this.applicationContext.publishEvent(demoEvent);
  }
}
```

* 如上代码所示，Spring 中
    1. 通过继承 `ApplicationEvent` 来定义一个事件（消息）
    2. 通过实现 `ApplicationListener` 接口来定义一个监听者（观察者）
    3. 通过调用 `ApplicationContext` 的 `publishEvent` 方法来发送消息。

> 7. 模板模式
* 模板方法（Template Method）是一种行为设计模式，它在超类中定义了一个算法的框架，允许子类在不修改结构的情况下重写算法的特定步骤。
* 超类中可以定义 3 种类型的步骤
    1. 抽象步骤：必须由各个子类来实现的步骤
    2. 可选步骤：一些通用的或默认的实现，但仍可在需要时进行重写
    3. 钩子方法步骤：钩子是内容为空的可选步骤。即使不重写钩子，模板方法也能工作。钩子通常放置在算法重要步骤的前后，为子类提供额外的算法扩展点
* 在 Spring Bean 的生命周期中，利用模板模式，对 Bean 的生命周期进行了扩展。Bean 的生命周期扩展点如下图所示。



![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/java-2020/spring-bean-lifecycle-2.png)


1. 实例化（Instantiation）
    * 图中的第 1 步，实例化一个 bean 对象
    * **对象的构造函数是在实例化阶段调用的**
2. 属性赋值（Populate）
   * 图中的第 2 步，为bean对象设置相关属性和依赖
3. 初始化（Initialization）
   * 图中的第 3~7 步，其中第 5、6 步为初始化操作，第 3、4 步为在初始化前执行，第 7 步在初始化后执行。
   * 检查 Aware 相关接口并设置依赖
   * BeanPostProcessor 前置处理
   * 若实现了 InitializingBean 接口，则调用该接口的 `afterPropertiesSet()` 方法
   * 若配置了自定义的 `init-method` 方法，则执行该方法
   * BeanPostProcessor 后置处理
4. 销毁（Destruction）
   * 图中的第 8~10 步，第 8 步不是真正意义上的销毁（还没使用呢），而是先在使用前注册了销毁的相关调用接口，为了后面第 9、10 步真正销毁 bean 时再执行相应的方法 
   * 注册 Destruction 相关回调接口 (不是真正意义上的销毁)
   * 是否实现 DisposableBean 接口
   * 是否配置自定义的 destory-method




> 8. 适配器模式
* 在 Spring MVC 中，有 3 种方式来实现一个 MVC 中的 `Controller`。不同创建方式的 `Controller`，其函数的定义（函数名、入参、返回值等）是不统一的。这样的话，`DispatcherServlet` 就需要根据不同类型的 `Controller` 来调用不同的函数。
* Spring 利用「适配器模式」来解决该问题，Spring 定义了统一的接口 `HandlerAdapter`，将不同方式定义的 `Controller` 类中的函数，适配为统一的函数定义。
* 通过「适配器设计模式」，在 `DispatcherServlet` 类中就不需要区分对待不同的 `Controller` 对象了，统一调用`HandlerAdapter` 的 `handle()` 方法就可以了。详情参考本文的「HandlerAdapter和适配器设计模式」章节。