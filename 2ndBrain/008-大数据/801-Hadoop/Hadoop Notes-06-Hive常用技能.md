# Hadoop Notes-06-Hive常用技能

[TOC]

## 更新
* 2021/11/21，撰写




## Hive建表对比MySQL建表

* [Hive表如何添加字段和修改注释 | CSDN](https://blog.csdn.net/qq646748739/article/details/81775760)


Hive表添加字段，对比 MySQL表添加字段
1. hive表需要使用 `()`，MySQL则不需要
2. hive表使用的是 `ADD COLUMNS`，MySQL使用的是 `ADD COLUMN`。



```s
//hive
ALTER TABLE 
    app.app_akhal_race_shop_rank_condition_info 
ADD COLUMNS 
    (jd_good_shop string COMMENT '京东好店');
```


```s
//mysql
ALTER TABLE 
    akhal_teke_shop_rank_result_info
ADD COLUMN 
    encrypt_track_id  VARCHAR(100)  DEFAULT NULL COMMENT '源赛道加密id' 
AFTER track_id,
ADD COLUMN 
    encrypt_upgrade_track_id  VARCHAR(100)  DEFAULT NULL COMMENT '晋升赛道加密id' 
AFTER upgrade_track_id
```


Hive 表中添加多个字段，在括号中使用逗号隔开即可。

```s
--添加多个字段
alter table bron_lpss_lpss_order_info_cur add columns
(
    order_source string comment '订单来源',
    mid string comment '新会员id',
    bank_name string comment '银行行名'
);
```







## Hive 联级cascade

* [hive表新增字段使用联级cascade写入历史分区](https://www.cxybb.com/article/programmer_trip/116565862)


对hive表，新增字段后，如何让历史分区的数据（如历史dt分区）也增加新增的字段？


```s
//新增字段 不使用cascade关键字，历史分区表中实际上没有插入这个新字段，新增字段默认为null
alter table test add columns(sex string);

alter table test add columns(sex string) cascade;
```


**cascade 关键字的作用为强制刷新表和所有分区的元数据信息(包括历史数据分区的)**。