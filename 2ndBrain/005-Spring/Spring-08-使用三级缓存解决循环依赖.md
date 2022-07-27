# Spring-08-使用三级缓存解决循环依赖


[TOC]



## 更新
* 2022/03/05，撰写
* 2022/05/20，排版整理


## 参考资料
* [Spring IoC 进阶之循环依赖 | Java 全栈知识体系](https://pdai.tech/md/spring/spring-x-framework-ioc-source-3.html)
* [Spring为什么使用三级缓存而不是两级](https://www.zhihu.com/question/445446018)
* [Spring三级缓存机制](https://www.cnblogs.com/semi-sub/p/13548479.html)
* [Spring 是如何解决循环依赖的 | 腾讯云](https://cloud.tencent.com/developer/article/1769948)



## 前言

**Spring 中使用了三级缓存的设计，来解决单例模式下的属性循环依赖问题。**

这句话有两点需要注意
1. 解决问题的方法是「三级缓存的设计」
2. 解决的只是单例模式下的 Bean 属性循环依赖问题，对于多例 Bean 和 Prototype 作用域的 Bean的循环依赖问题，并不能使用三级缓存设计解决。


## Bean 的生命周期

Spring Bean 的生命周期可以简单概括为 4 个阶段
1. 实例化（Instantiation）
2. 属性赋值（Populate）
3. 初始化（Initialization）
4. 销毁（Destruction）




## 什么是循环依赖



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


如上代码所示，即 A 里面注入 B，B 里面又注入 A。此时，就发生了「循环依赖」。




## 三级缓存

> Spring 中，单例 Bean 在创建后会被放入 IoC 容器的缓存池中，并触发 Spring 对该 Bean 的生命周期管理。

单例模式下，在第一次使用 Bean 时，会创建一个 Bean 对象，并放入 IoC 容器的缓存池中。后续再使用该 Bean 对象时，会直接从缓存池中获取。

保存单例模式 Bean 的缓存池，采用了三级缓存设计，如下代码所示。


```java
/** Cache of singleton objects: bean name --> bean instance */
/** 一级缓存：用于存放完全初始化好的 bean **/
private final Map<String, Object> singletonObjects = new ConcurrentHashMap<String, Object>(256);
 
/** Cache of early singleton objects: bean name --> bean instance */
/** 二级缓存：存放原始的 bean 对象（尚未填充属性），用于解决循环依赖 */
private final Map<String, Object> earlySingletonObjects = new HashMap<String, Object>(16);

/** Cache of singleton factories: bean name --> ObjectFactory */
/** 三级级缓存：存放 bean 工厂对象，用于解决循环依赖 */
private final Map<String, ObjectFactory<?>> singletonFactories = new HashMap<String, ObjectFactory<?>>(16);
```






|   缓存层级   |       名称        |                    描述                 |
|-------------|-------------------|----------------------------------------|
| 第一层缓存 | `singletonObjects`  | 单例对象缓存池，存放的 Bean 已经实例化、属性赋值、完全初始化好（成品）|
| 第二层缓存 | `earlySingletonObjects`  | 早期单例对象缓存池，存放的 Bean 已经实例化但尚未属性赋值、未执行 `init` 方法（半成品）  |
| 第三层缓存 | `singletonFactories`  | 单例工厂的缓存 |




## 使用三级缓存解决循环依赖


### getSingleton方法中三级缓存的使用


```java
protected Object getSingleton(String beanName, boolean allowEarlyReference) {
  // Spring首先从singletonObjects（一级缓存）中尝试获取
  Object singletonObject = this.singletonObjects.get(beanName);
  // 若是获取不到而且对象在建立中，则尝试从earlySingletonObjects(二级缓存)中获取
  if (singletonObject == null && isSingletonCurrentlyInCreation(beanName)) {
    synchronized (this.singletonObjects) {
        singletonObject = this.earlySingletonObjects.get(beanName);
        if (singletonObject == null && allowEarlyReference) {
          ObjectFactory<?> singletonFactory = this.singletonFactories.get(beanName);
          if (singletonFactory != null) {
            //若是仍是获取不到而且允许从singletonFactories经过getObject获取，则经过singletonFactory.getObject()(三级缓存)获取
              singletonObject = singletonFactory.getObject();
              //若是获取到了则将singletonObject放入到earlySingletonObjects,也就是将三级缓存提高到二级缓存中
              this.earlySingletonObjects.put(beanName, singletonObject);
              this.singletonFactories.remove(beanName);
          }
        }
    }
  }
  return (singletonObject != NULL_OBJECT ? singletonObject : null);
}
```


> `getSingleton()` 方法中
> * `isSingletonCurrentlyInCreation()` 方法用于判断当前单例 Bean 是否正在创建中，即「还没有执行初始化方法」。比如，A 的构造器依赖了 B 对象因此要先去创建 B 对象，或者在 A 的属性装配过程中依赖了 B 对象因此要先创建 B 对象，这时 A 就是处于创建中的状态。
> * `allowEarlyReference` 变量表示是否允许从三级缓存 `singletonFactories` 中经过 `singletonFactory` 的 `getObject()` 方法获取 Bean 对象。


分析 `getSingleton()` 的整个过程，可知三级缓存的使用过程如下
1. Spring 会先从一级缓存 `singletonObjects` 中尝试获取 Bean。
2. 若是获取不到，而且对象正在建立中，就会尝试从二级缓存 `earlySingletonObjects` 中获取 Bean。
3. 若还是获取不到，且允许从三级缓存 `singletonFactories` 中经过 `singletonFactory` 的 `getObject()` 方法获取 Bean 对象，就会尝试从三级缓存 `singletonFactories` 中获取 Bean。
4. 若是在三级缓存中获取到了 Bean，会将该 Bean 存放到二级缓存中。



### 第三级缓存为什么可以解决循环依赖


**Spring 解决循环依赖的诀窍就在于 `singletonFactories` 这个三级缓存。** 三级缓存中使用到了`ObjectFactory` 接口，定义如下

```java
public interface ObjectFactory<T> {
    T getObject() throws BeansException;
}
```


在 Bean 建立过程当中，有两处比较重要的匿名内部类实现了该接口。一处是 Spring 利用其建立 Bean 的时候，另外一处就是在 `addSingletonFactory` 方法中，如下代码所示。

```java
addSingletonFactory(beanName, new ObjectFactory<Object>() {
   @Override   
   public Object getObject() throws BeansException {
       return getEarlyBeanReference(beanName, mbd, bean);
   }
});
```  

**此处就是解决循环依赖的关键，这段代码发生在 `createBeanInstance` 以后**
1. 此时，单例 Bean 对象已经实例化（可以通过对象引用定位到堆中的对象），但尚未属性赋值和初始化。
2. **Spring 会将该状态下的 Bean 存放到三级缓存中，提早曝光给 IoC 容器（“提早”指的是不必等对象完成属性赋值和初始化后再交给 IoC 容器）。也就是说，可以在三级缓存 `singletonFactories` 中找到该状态下的 Bean 对象。**



### 解决循环依赖示例分析

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

在上文章节铺垫的基础上，此处结合一个循环依赖的案例，分析下如何使用三级缓存解决单例 Bean 的循环依赖。

1. **创建对象 A，完成生命周期的第一步，即实例化（Instantiation），在调用 `createBeanInstance` 方法后，会调用 `addSingletonFactory` 方法，将已实例化但未属性赋值未初始化的对象 A 放入三级缓存 `singletonFactories` 中。即将对象 A 提早曝光给 IoC 容器。**
2. 继续，执行对象 A 生命周期的第二步，即属性赋值（Populate）。此时，发现对象 A 依赖对象，所以就会尝试去获取对象 B。
3. 继续，发现 B 尚未创建，所以会执行创建对象 B 的过程。
4. 在创建对象 B 的过程中，执行实例化（Instantiation）和属性赋值（Populate）操作。此时发现，对象 B 依赖对象 A。
5. 继续，尝试在缓存中查找对象 A。先查找一级缓存，发现一级缓存中没有对象 A（因为对象 A 还未初始化完成）；转而查找二级缓存，二级缓存中也没有对象 A（因为对象 A 还未属性赋值）；转而查找三级缓存 `singletonFactories`，对象 B 可以通过 `ObjectFactory.getObject` 拿到对象 A。
6. 继续，对象 B 在获取到对象 A 后，继续执行属性赋值（Populate）和初始化（Initialization）操作。对象 B 完成初始化操作后，会被存放到一级缓存中。
7. 继续，转到「对象 A 执行属性赋值过程并发现依赖了对象 B」的场景。此时，对象 A 可以从一级缓存中获取到对象 B，所以可以顺利执行属性赋值操作。
8. 继续，对象 A 执行初始化（Initialization）操作，完成后，会被存放到一级缓存中。



  



## Spring为何不能解决非单例Bean的循环依赖

Spring 为何不能解决非单例 Bean 的循环依赖？ 这个问题可以细分为下面几个问题
1. Spring 为什么不能解决构造器的循环依赖？
2. Spring 为什么不能解决 `prototype` 作用域循环依赖？
3. Spring 为什么不能解决多例的循环依赖？


### Spring 为什么不能解决构造器的循环依赖

> **对象的构造函数是在实例化阶段调用的。**


上文中提到，在对象已实例化后，会将对象存入三级缓存中。在调用对象的构造函数时，对象还未完成初始化，所以也就无法将对象存放到三级缓存中。

在构造函数注入中，对象 A 需要在对象 B 的构造函数中完成初始化，对象 B 也需要在对象 A 的构造函数中完成初始化。此时两个对象都不在三级缓存中，最终结果就是两个 Bean 都无法完成初始化，无法解决循环依赖问题。


### Spring 为什么不能解决prototype作用域循环依赖


Spring IoC 容器只会管理单例 Bean 的生命周期，并将单例 Bean 存放到缓存池中（三级缓存）。Spring 并不会管理 `prototype` 作用域的 Bean，也不会缓存该作用域的 Bean，而 Spring 中循环依赖的解决正是通过缓存来实现的。

### Spring 为什么不能解决多例的循环依赖

多实例 Bean 是每次调用 `getBean` 都会创建一个新的 Bean 对象，该 Bean 对象并不能缓存。而 Spring 中循环依赖的解决正是通过缓存来实现的。



### 非单例Bean的循环依赖如何解决

* 对于构造器注入产生的循环依赖，可以使用 `@Lazy` 注解，延迟加载。
* 对于多例 Bean 和 `prototype` 作用域产生的循环依赖，可以尝试改为单例 Bean。



## 为什么一定要三级缓存

为什么一定要三级缓存，使用两级缓存可以解决循环依赖吗？ 

带着这个思考，进入下文。

### 尝试使用两级缓存解决依赖冲突


**第三级缓存的目的是为了延迟代理对象的创建，因为如果没有依赖循环的话，那么就不需要为其提前创建代理，可以将它延迟到初始化完成之后再创建。**

既然目的只是延迟的话，那么我们是不是可以不延迟创建，而是在实例化完成之后，就为其创建代理对象，这样我们就不需要第三级缓存了。因此，我们可以将 `addSingletonFactory()` 方法进行改造。


```java
protected void addSingletonFactory(String beanName, ObjectFactory<?> singletonFactory) {
    Assert.notNull(singletonFactory, "Singleton factory must not be null");

    synchronized (this.singletonObjects) {
        // 判断一级缓存中不存在此对象
        if (!this.singletonObjects.containsKey(beanName)) { 
            // 直接从工厂中获取 Bean
            Object o = singletonFactory.getObject();

            // 添加至二级缓存中
            this.earlySingletonObjects.put(beanName, o);
            this.registeredSingletons.add(beanName);
        }
    }
}
```

这样的话，每次实例化完 Bean 之后就直接去创建代理对象，并添加到二级缓存中。

测试结果是完全正常的，Spring 的初始化时间应该也是不会有太大的影响，因为如果 Bean 本身不需要代理的话，是直接返回原始 Bean 的，并不需要走复杂的创建代理 Bean 的流程。



### 三级缓存的意义

测试证明，二级缓存也是可以解决循环依赖的。为什么 Spring 不选择二级缓存，而要额外多添加一层缓存，使用三级缓存呢？

**如果 Spring 选择二级缓存来解决循环依赖的话，那么就意味着所有 Bean 都需要在实例化完成之后就立马为其创建代理，而 Spring 的设计原则是在 Bean 初始化完成之后才为其创建代理。**


> 使用三级缓存而非二级缓存并不是因为只有三级缓存才能解决循环引用问题，其实二级缓存同样也能很好解决循环引用问题。使用三级而非二级缓存并非出于 IOC 的考虑，而是出于 AOP 的考虑，即若使用二级缓存，在 AOP 情形注入到其他 Bean 的，不是最终的代理对象，而是原始对象。 