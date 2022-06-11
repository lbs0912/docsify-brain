
# Java Notes-24-时间和日期

[TOC]

## 更新
* 2020/09/20，撰写





## SimpleDateFormat-Y和y区别

* [SimpleDateFormat大写Y和小写y的区别 | CSDN](https://blog.csdn.net/chengluchuang2753/article/details/85603338)
* [日期格式化SimpleDateFormat的坑 | CSDN](https://blog.csdn.net/jn19970215/article/details/105446271)


> 日期格式化字符串 `[YYYY-MM-dd HH:mm:ss]` 使用s时，应注意使用小写 `y` 表示当天所在的年，大写 `Y` 代表 `week in which year`。


日期格式化时，`yyyy` 表示当天所在的年，而大写的 `YYYY` 代表是 `week in which year`（JDK7 之后引入的概念），表示当天所在的周属于的年份。

一周从周日开始，周六结束，只要本周跨年，返回的 `YYYY` 就是下一年。如下示例。


```java
Calendar calendar = Calendar.getInstance();
// 2014-12-31
calendar.set(2014, Calendar.DECEMBER, 31);
Date strDate1 = calendar.getTime();
// 2015-01-01
calendar.set(2015, Calendar.JANUARY, 1);
Date strDate2 = calendar.getTime();
// 大写YYYY
DateFormat formatUpperCase = new SimpleDateFormat("YYYY/MM/dd");
System.out.println("2014-12-31 to YYYY/MM/dd: " + formatUpperCase.format(strDate1)); //2014-12-31 to YYYY/MM/dd: 2015/12/31
System.out.println("2015-01-01 to YYYY/MM/dd: " + formatUpperCase.format(strDate2)); //2015-01-01 to YYYY/MM/dd: 2015/01/01

// 小写YYYY
DateFormat formatLowerCase = new SimpleDateFormat("yyyy/MM/dd");
System.out.println("2014-12-31 to yyyy/MM/dd: " + formatLowerCase.format(strDate1)); //2014-12-31 to yyyy/MM/dd: 2014/12/31
System.out.println("2015-01-01 to yyyy/MM/dd: " + formatLowerCase.format(strDate2)); //2015-01-01 to yyyy/MM/dd: 2015/01/01
```



另外需要注意
* 月份对应大写的 `M`
* 分钟对应小写的 `m`
* 24制的小时对应大写的 `H`
* 12制的小时对应小写的 `h`






## 时间戳的3种获取方式

* [new Date().getTime()和System.currentTimeMillis()获取时间戳 | CSDN](https://www.jianshu.com/p/5efbdc579f3d)



Java 中获取时间戳的方式主要有以下 3 种
1. `System.currentTimeMillis()` （性能最佳）
2. `new Date().getTime()` （性能一般）
3. `Calendar.getInstance().getTimeInMillis()` （性能最差）


上述 3 种方式中，`System.currentTimeMillis()` 的性能最佳，下面进行具体的分析。



### new Date().getTime()


打开 `java.util.Date` 的源码可以发现，`new Date()` 其实就是调用了 `System.currentTimeMillis()`。不难看出，如果只是仅仅获取时间戳，即使是匿名的 `new Date()` 对象，也会有些许的性能消耗， 

```java
public Date() {
    this(System.currentTimeMillis());
}
```


从提升性能的角度来看，只是仅仅获取时间戳，不考虑时区的影响，直接调用 `System.currentTimeMillis()` 会更好一些。

### Calendar.getInstance().getTimeInMillis()

使用 `Calendar.getInstance().getTimeInMillis()` 获取时间戳，这种方式的性能是最差的。因为 `Canlendar` 是区分时区的，而 `System.currentTimeMillis()` 方法中是不区分时区的。


### System.currentTimeMillis()

若要获取的时间戳不涉及时区，使用该方式的性能是最佳的。




## 10位和13位时间戳

* [java时间戳 10位和13位分别是怎么来的 | CSDN ](https://blog.csdn.net/qq_28483283/article/details/80583197)
* [13位时间戳（单位为毫秒）转换为10位字符串（单位为秒） | CSDN](https://blog.csdn.net/lin_dianwei/article/details/54616014)



Java 中的 `Date` 默认精度是毫秒，默认情况下生成的时间戳是 13 位的，而像 C++ 或者 PHP 生成的时间戳默认是 10 位的，默认精度是秒。即
1. 13位的时间戳的精度为毫秒
2. 10位的时间戳的精度为秒


将13位的时间戳，转换为10位时间戳，直接使用 `1000` 整除即可，代码如下。


```java
long timeStampSec = System.currentTimeMillis()/1000; //获取精度为秒的时间戳
String timestamp = String.format("%010d", timeStampSec);
```

此外，对于将时间戳转换为字符串的情况，需要使用 `String.format("%010d", timeStampSec)` 进行格式化转换，对于时间戳长度不满10位的情况，要进行补 0 处理，如上代码所示。



## 时间戳-日期转换


* 时间戳转换为日期


```java
long time1 = 1602259199000L;
String result1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date((long) time1));
System.out.println("13位数的时间戳（秒）--->Date:" + result1);
```

* 日期转换为时间戳


```java
DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
Date date = df.parse("2020-09-18 00:00:00");
Calendar cal = Calendar.getInstance();
cal.setTime(date);
long timestamp = cal.getTimeInMillis();
System.out.println("timestamp(13位):" + timestamp);
```