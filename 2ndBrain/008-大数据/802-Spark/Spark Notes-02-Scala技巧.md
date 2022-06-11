
# Spark Notes-02-Scala技巧


[TOC]

## 更新
* 2021/12/28，撰写



## 参考资料





## na.fill使用

* [在Spark DataFrame 中的 na.fill | Scala](http://cn.voidcc.com/question/p-xcmnssdd-bmb.html)
* [Spark Scala 中对Null/Nan的处理](https://www.cnblogs.com/houji/p/9968281.html)



针对不同类型的列，填充不同的默认值。

```s
val typeMap = df.dtypes.map(column => 
    column._2 match { 
     case "IntegerType" => (column._1 -> 0) 
     case "StringType" => (column._1 -> "") 
     case "DoubleType" => (column._1 -> 0.0) 
    }).toMap 

dataDF.withColumn("dt", functions.lit(dt1))
    .na.fill(typeMap)    # .na.fill(0) 
    .write.mode(SaveMode.Overwrite)
    .insertInto(RACE_SHOP_RANK_IND_TABLE_NAME)
```