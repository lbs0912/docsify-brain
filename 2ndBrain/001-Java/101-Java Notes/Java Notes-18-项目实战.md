

# Java Notes-18-项目实战

[TOC]


## 更新
* 2020/08/25，撰写
* 2020/08/29，添加 *IDEA中多线程调试*




##  学习资料

* [线上CPU飙升100%问题排查 | CSDN](https://blog.csdn.net/u011277123/article/details/103495338)




## IDEA中多线程调试
* [IDEA中多线程并发代码的调试方法](https://juejin.im/post/6857365822445191182)


## CPU占用率偏高排查


* [线上CPU飙升100%问题排查 | CSDN](https://blog.csdn.net/u011277123/article/details/103495338)

问题排查思路为先查看CPU的线程，后查看GC情况。核心排查步骤如下

1. 定位进程：执行 `top` 命令，查看所有进程占系统CPU的排序。


```
$top
  
  PID  USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  1893 admin     20   0 7127m 2.6g  38m S 181.7 32.6  10:20.26 java
```

2. 定位线程：执行 `top -Hp` 命令


```
$top -Hp 1893
   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  4519 admin     20   0 7127m 2.6g  38m R 18.6 32.6   0:40.11 java
```

通过 `top -Hp 1893` 命令，我们可以发现，当前 1893 这个进程中，ID为 4519 的线程占用 CPU 最高。


3. 定位代码：将 4519 这个线程转成 16 进制


```
$printf %x 4519

11a7
```

4. 查看栈信息：使用 `jstack` 查看栈信息


```
$sudo -u admin  jstack 1893 |grep -A 200 11a7
"HSFBizProcessor-DEFAULT-8-thread-5" #500 daemon prio=10 os_prio=0 tid=0x00007f632314a800 nid=0x11a2 runnable [0x000000005442a000]
   java.lang.Thread.State: RUNNABLE
  at sun.misc.URLClassPath$Loader.findResource(URLClassPath.java:684)
  at sun.misc.URLClassPath.findResource(URLClassPath.java:188)
  at java.net.URLClassLoader$2.run(URLClassLoader.java:569)
  at java.net.URLClassLoader$2.run(URLClassLoader.java:567)
  at java.security.AccessController.doPrivileged(Native Method)
  at java.net.URLClassLoader.findResource(URLClassLoader.java:566)
  at java.lang.ClassLoader.getResource(ClassLoader.java:1093)
  at java.net.URLClassLoader.getResourceAsStream(URLClassLoader.java:232)
  at org.hibernate.validator.internal.xml.ValidationXmlParser.getInputStreamForPath(ValidationXmlParser.java:248)
  at org.hibernate.validator.internal.xml.ValidationXmlParser.getValidationConfig(ValidationXmlParser.java:191)
  at org.hibernate.validator.internal.xml.ValidationXmlParser.parseValidationXml(ValidationXmlParser.java:65)
  at org.hibernate.validator.internal.engine.ConfigurationImpl.parseValidationXml(ConfigurationImpl.java:287)
  at org.hibernate.validator.internal.engine.ConfigurationImpl.buildValidatorFactory(ConfigurationImpl.java:174)
  at javax.validation.Validation.buildDefaultValidatorFactory(Validation.java:111)
  at com.test.common.util.BeanValidator.validate(BeanValidator.java:30)
```

通过以上代码，可以清楚的看到，`BeanValidator.java` 的第 30 行是有可能存在问题的。