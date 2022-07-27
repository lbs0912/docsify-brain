
# Spring-06-Spring的事务管理

[TOC]



## 更新
* 2020/08/26，撰写
* 2020/08/31，添加 `@Transactional` 内容
* 2022/05/21，排版整理


## 参考资料

* [7000+字的Spring事务总结 | 掘金](https://juejin.im/post/6844904160005996552)
* 笔记-「MySQL-03-MySQL事务」，同 [MySQL事务和MVVC | 掘金](https://juejin.cn/post/7096372460185993253)



## Spring中管理事务的 2 种方式

Spring 支持 2 种方式的事务管理
1. 编程式事务管理
2. 声明式事务管理


### 编程式事务管理

通过 `TransactionTemplate` 或者 `TransactionManager` 手动管理事务，实际应用中很少使用，但是对于理解 Spring 事务管理原理有帮助。

* 使用 `TransactionTemplate` 进行编程式事务管理的示例代码如下。

```java
@Autowired
private TransactionTemplate transactionTemplate;
public void testTransaction() {

        transactionTemplate.execute(new TransactionCallbackWithoutResult() {
            @Override
            protected void doInTransactionWithoutResult(TransactionStatus transactionStatus) {

                try {

                    // ....  业务代码
                } catch (Exception e){
                    //回滚
                    transactionStatus.setRollbackOnly();
                }

            }
        });
}

```



* 使用 `TransactionManager` 进行编程式事务管理的示例代码如下。


```java
@Autowired
private PlatformTransactionManager transactionManager;

public void testTransaction() {

  TransactionStatus status = transactionManager.getTransaction(new DefaultTransactionDefinition());
          try {
               // ....  业务代码
              transactionManager.commit(status);
          } catch (Exception e) {
              transactionManager.rollback(status);
          }
}
```


### 声明式事务管理


使用 `@Transactional` 注解进行事务管理，该方式是基于 AOP 实现的，代码侵入性较小，推荐使用该方式进行事务管理。


使用 `@Transactional` 注解进行事务管理的示例代码如下。

```java
@Transactional(propagation=propagation.PROPAGATION_REQUIRED)
public void aMethod {
    //do something
    B b = new B();
    C c = new C();
    b.bMethod();
    c.cMethod();
}
```


## Spring事务管理相关接口

Spring 框架中，事务管理相关最重要的 3 个接口如下
* `PlatformTransactionManager`：（平台）事务管理器，Spring 事务策略的核心。
* `TransactionDefinition`：事务定义信息(事务隔离级别、传播行为、超时、只读、回滚规则)。
* `TransactionStatus`：事务运行状态。


### 事务管理接口（PlatformTransactionManager）

Spring 并不直接管理事务，而是提供了多种事务管理器 。Spring 事务管理器的接口是 `PlatformTransactionManager`。

通过这个接口，Spring 为各个平台如 `JDBC` (`DataSourceTransactionManager`)、`Hibernate`( `HibernateTransactionManager`)、`JPA` (`JpaTransactionManager`) 等都提供了对应的事务管理器，但是具体的实现就是各个平台自己的事情了。

`PlatformTransactionManager` 接口的具体实现如下。


```java
package org.springframework.transaction;

import org.springframework.lang.Nullable;

public interface PlatformTransactionManager {
    //获得事务
    TransactionStatus getTransaction(@Nullable TransactionDefinition var1) throws TransactionException;
    //提交事务
    void commit(TransactionStatus var1) throws TransactionException;
    //回滚事务
    void rollback(TransactionStatus var1) throws TransactionException;
}
```


### 事务属性（TransactionDefinition）

`TransactionDefinition` 接口定义了事务的一些基本属性。事务属性包括 5 个方面
1. 隔离级别
2. 传播行为
3. 回滚规则
4. 是否只读
5. 事务超时




```java
package org.springframework.transaction;

import org.springframework.lang.Nullable;

public interface TransactionDefinition {
    int PROPAGATION_REQUIRED = 0;
    int PROPAGATION_SUPPORTS = 1;
    int PROPAGATION_MANDATORY = 2;
    int PROPAGATION_REQUIRES_NEW = 3;
    int PROPAGATION_NOT_SUPPORTED = 4;
    int PROPAGATION_NEVER = 5;
    int PROPAGATION_NESTED = 6;
    int ISOLATION_DEFAULT = -1;
    int ISOLATION_READ_UNCOMMITTED = 1;
    int ISOLATION_READ_COMMITTED = 2;
    int ISOLATION_REPEATABLE_READ = 4;
    int ISOLATION_SERIALIZABLE = 8;
    int TIMEOUT_DEFAULT = -1;
    // 返回事务的传播行为，默认值为 REQUIRED。
    int getPropagationBehavior();
    //返回事务的隔离级别，默认值是 DEFAULT
    int getIsolationLevel();
    // 返回事务的超时时间，默认值为-1。如果超过该时间限制但事务还没有完成，则自动回滚事务。
    int getTimeout();
    // 返回是否为只读事务，默认值为 false
    boolean isReadOnly();

    @Nullable
    String getName();
}

```




### 事务状态（TransactionStatus）


`TransactionStatus` 接口用来记录事务的状态。该接口定义了一组方法，用来获取或判断事务的相应状态信息。事务管理接口 `PlatformTransactionManager` 的 `getTransaction()` 方法会返回一个 `TransactionStatus` 对象。

`TransactionStatus` 接口接口内容如下。

```java
public interface TransactionStatus{
    boolean isNewTransaction(); // 是否是新的事物
    boolean hasSavepoint(); // 是否有恢复点
    void setRollbackOnly();  // 设置为只回滚
    boolean isRollbackOnly(); // 是否为只回滚
    boolean isCompleted; // 是否已完成
}
```



##  @Transactional注解

###  @Transactional的作用范围

1. 方法：推荐将注解使用于方法上，不过需要注意的是，该注解只能应用到 `public` 方法上，否则不生效。
2. 类：如果这个注解使用在类上的话，表明该注解对该类中所有的 `public` 方法都生效。
3. 接口：不推荐在接口上使用。



### @Transactional的常用配置参数


`@Transactional` 的常用配置参数总结（只列出 5 个比较常用的）



|       属性名      |     说明      |
|-------------------|---------------|
| `propagation`  | 事务的传播行为，默认值为 `REQUIRED` | 
| `isolation`  | 事务的隔离级别，默认值采用 DEFAULT | 
| `timeout`    | 事务的超时时间，默认值为 -1（不会超时）。如果超过该时间限制但事务还没有完成，则自动回滚事务。 | 
| `readOnly`    | 指定事务是否为只读事务，默认值为 false  | 
| `rollbackFor`  | 用于指定能够触发事务回滚的异常类型，并且可以指定多个异常类型，默认只捕获 `RuntimeException`  | 




#### 传播机制（propagation）
* ref 1-[Spring 事务传播机制 | CSDN](https://blog.csdn.net/mccand1234/article/details/117227055)
  

此处对 `@Transactional(propagation = xxx)` 注解的传播机制 `propagation` 属性值进行介绍。

`propagation` 参数用于指定事务的传播特性，默认值为 `REQUIRED`，Spring目前支持 7 种传播机制。


|     传播机制      |              说明                 |
|-----------------|-----------------------------------|
| `REQUIRED`  | 如果当前上下文中存在事务则加入该事务；如果不存在事务则创建一个事务 | 
| `SUPPORTS` |  如果当前上下文存在事务则支持事务加入事务；如果不存在事务则使用非事务的方式执行 |
| `MANDATORY` | 方法只能在当前上下文中已经存在的事务中允许，若不存在已有的事务则抛出异常 |
| `REQUIRES_NEW` |  每次都会新建一个事务，并且同时将上下文中的事务挂起，执行当前新建的事务。完成以后，上下文事务恢复再执行 |
| `NOT_SUPPORTED` |  如果当前上下文中存在事务则挂起当前事务，然后新的方法在没有事务的环境中执行 | 
| `NEVER` |  如果当前上下文中存在事务则抛出异常，否则在无事务环境上执行代码|
| `NESTED` |  如果当前上下文中存在事务则嵌套事务执行，如果不存在事务则新建事务 | 



如上表所示，目前只有 `REQUIRED`、`REQUIRES_NEW`、`NESTED` 这三种传播机制会新建事务。

设置传播机制 `propagation` 参数错误，会导致事务失效。比如，若设置 `@Transactional(propagation = Propagation.NEVER)`，方法执行时，如果当前上下文中存在事务会抛出异常。


### @Transactional 注解原理

**`@Transactional` 的工作机制是基于 AOP 实现的，AOP 又是使用动态代理实现的。如果目标对象实现了接口，默认情况下会采用 JDK 的动态代理，如果目标对象没有实现接口，会使用 `CGLIB` 动态代理。** 

Spring 的 `DefaultAopProxyFactory` 的 `createAopProxy()` 方法决定了是使用 JDK 还是 `CGLIB` 来做动态代理，源码如下。


```java
public class DefaultAopProxyFactory implements AopProxyFactory, Serializable {
    @Override
    public AopProxy createAopProxy(AdvisedSupport config) throws AopConfigException {
        if (config.isOptimize() || config.isProxyTargetClass() || hasNoUserSuppliedProxyInterfaces(config)) {
            Class<?> targetClass = config.getTargetClass();
            if (targetClass == null) {
                throw new AopConfigException("TargetSource cannot determine target class: " +
                        "Either an interface or a target is required for proxy creation.");
            }
            if (targetClass.isInterface() || Proxy.isProxyClass(targetClass)) {
                return new JdkDynamicAopProxy(config);
            }
            return new ObjenesisCglibAopProxy(config);
        } else {
            return new JdkDynamicAopProxy(config);
        }
    }

   ...
}
```


## Spring AOP 自调用问题

**若同一类中的其他没有 `@Transactional` 注解的方法内部调用有 `@Transactional` 注解的方法，有 `@Transactional` 注解的方法的事务会失效。这是由于 Spring AOP 代理的原因造成的，因为只有当 `@Transactional` 注解的方法在类以外被调用的时候，Spring 事务管理才生效。**

下述代码中，`MyService` 类中的 `method1()` 调用 `method2()` 就会导致 `method2()` 的事务失效。


```java
@Service
public class MyService {
    private void method1() {
        method2();
        //......
    }

    @Transactional
    public void method2() {
        //......
    }
}
```

解决「Spring AOP 自调用问题导致事务失效」的方法如下。

1. 新创建一个类，在新创建的类中调用该类，避免在类中自调用。

```java
@Servcie
public class ServiceA {
    @Autowired
    private ServiceB serviceB;

    public void save(User user) {
        queryData1();
        queryData2();
        serviceB.doSave(user);
    }
}

@Servcie
public class ServiceB {

    @Transactional(rollbackFor=Exception.class)
    public void doSave(User user) {
        addData1();
        updateData2();
    }
}
```

2. 若不想新创建一个类，也可以在该类中注入自己。(Spring 通过三级缓存解决了循环依赖问题)

```java
@Servcie
public class ServiceA {
    @Autowired
    private ServiceA serviceA;

    public void save(User user) {
        queryData1();
        queryData2();
        serviceA.doSave(user);
   }

    @Transactional(rollbackFor=Exception.class)
    public void doSave(User user) {
        addData1();
        updateData2();
    }
}
```


3. 通过 `AopContent.currentProxy()` 获取代理对象。

```java
@Servcie
public class ServiceA {

    public void save(User user) {
        queryData1();
        queryData2();
        ((ServiceA)AopContext.currentProxy()).doSave(user);
    }

    @Transactional(rollbackFor=Exception.class)
    public void doSave(User user) {
        addData1();
        updateData2();
    }
}
```

> 关于 AOP 自身调用问题，参见笔记「Spring-01-Spring学习路线」中的「AOP的嵌套调用」。



## @Transactional 使用注意

* `@Transactional` 注解只有作用到 `public` 方法上事务才生效（因为底层是通过 AOP 实现的，AOP 又是通过动态代理实现的），不推荐在接口上使用。
* **避免同一个类中调用 `@Transactional` 注解的方法，这样会导致事务失效。**
* 正确的设置 `@Transactional` 的 `rollbackFor` 和 `propagation` 属性，否则事务可能会回滚失败。
* **使用 `@Transactional` 处理事务时，方法中需要显示抛出异常，这样 AOP 代理才能捕获到方法的异常，才能进行回滚。默认情况下 AOP 只捕获 `RuntimeException` 的异常，但可以通过配置来捕获特定的异常并回滚。**



## 事务失效的场景
* ref 1-[Spring中产生事务失效的场景 | 掘金](https://juejin.cn/post/7095199944163721247?share_token=9bb97a87-a800-4138-9170-11426874c9e5)


在开发中，若遇到事务失效的场景，其产生原因可能包括
* 事务不生效
  1. 方法访问权限问题：使用 `@Transactional` 注解管理事务，底层是通过 AOP 实现的，AOP 又是通过动态代理实现的，这就要求该注解必须作用到 `public` 方法上，若注解到 `private`、`default` 和 `protected` 方法上，会导致事务不生效。同理，若方法被 `final` 修饰（动态代理中无法重写 `final` 方法），也会导致事务不生效。
  2. 方法内部调用，即上文中的「Spring AOP 自调用问题」。
  3. Bean 未被 Spring IoC 容器管理：使用 `@Transactional` 注解管理事务的前提是该 Bean 需要被 IoC 容器管理。
  4. 数据库的存储引擎不支持事务，如采用 MyISAM 存储引擎时不支持事务。
* 事务不回滚
  1. 事务的传播特性设置错误，如 `@Transactional(propagation = Propagation.NEVER)`。
  2. 自己吞掉了异常：使用 `@Transactional` 处理事务时，方法中需要显示抛出异常。这样 AOP 代理才能捕获到方法的异常，才能进行回滚。
  3. 抛出了别的异常：默认情况下 AOP 只捕获 `RuntimeException` 的异常，但可以通过配置来捕获特定的异常并回滚，如 `@Transactional(rollbackFor = RuntimeException.class)`。




## @Transactional实战


```sql
mysql> select * from user;
+----+-----------+---------------+
| id | user_name | user_password |
+----+-----------+---------------+
| 12 | lbs0912   | 123           |
| 13 | lbs0912   | 123           |
| 14 | lbs0912   | 123           |
| 15 | lbs0912   | 123           |
+----+-----------+---------------+
4 rows in set (0.00 sec)
```



对于上述 `user` 数据表，删除 `id = 12，13，14` 三条数据。其中，在执行 `id = 14` 的删除时，抛出一个异常，验证事务的回滚。代码如下。



```java
    //http://localhost:8080/deleteUserById?id=1
    @Transactional(rollbackFor = RuntimeException.class)
    @GetMapping("deleteUserById")
    public String deleteUserById(int id){
        int sum = 0;
        try{
            int rows= jdbcTemplate.update("DELETE FROM  USER  WHERE ID = ?",12);
            int rows2= jdbcTemplate.update("DELETE FROM  USER  WHERE ID = ?",13);
            int idValue = 14;
            if(14 == id){
                throw new RuntimeException("test");
                //int rows3= jdbcTemplate.update("DELETE FROM  USER  WHERE ID = ?",idValue);
            }

            sum += rows + rows2;
            int exceptionTest = 10/0;//
        }catch (RuntimeException  e){
            System.out.println("RuntimeException:" + e);
            throw new RuntimeException("test");
        }
        return "执行成功，影响"+sum+"行";
    }
```


执行上述代码后，再查看数据库，发现对应的三条数据都还在，数据库没有任何变化。这说明事务回滚生效了。


下面进行对比测试，注释掉 `@Transactional(rollbackFor = RuntimeException.class)`，再次运行代码，查看数据库的数据。可以看到，由于没有采用事务注解，前面两条 SQL 执行成功，并影响数据库中的数据。




```sql
mysql> select * from user;
+----+-----------+---------------+
| id | user_name | user_password |
+----+-----------+---------------+
| 14 | lbs0912   | 123           |
| 15 | lbs0912   | 123           |
+----+-----------+---------------+
2 rows in set (0.00 sec)
```










## FAQ


### 异常不抛出事务就不会回滚

* [Spring事务异常回滚，捕获异常不抛出就不会回滚 | CSDN](https://blog.csdn.net/yipanbo/article/details/46048413)


`@Transactional` 注解只能应用到 `public` 方法才有效。

默认 Spring 事务只在发生未被捕获的 `RuntimeexEetpion` 时才回滚。

**方法中需要显示抛出异常，这样 AOP 代理才能捕获到方法的异常，才能进行回滚。默认情况下 AOP 只捕获 `RuntimeException` 的异常，但可以通过配置来捕获特定的异常并回滚**，如下代码所示。

```java
@Transactional(rollbackFor = RuntimeException.class)
public void testFunc(){
    // ...
}
```


对于显示抛出异常，有如下 2 种方案

* 方案 1
若 `service` 层处理事务，那么 `service` 中的方法中不做异常捕获，或者在 `catch` 语句中最后增加 `throw new RuntimeException()` 语句，以便让 AOP 捕获异常再去回滚，并且在 `service`上层要继续捕获这个异常并处理。

* 方案 2
在 `service` 层方法的 `catch` 语句中增加 `TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();` 语句，手动回滚，这样上层就无需去处理异常。



