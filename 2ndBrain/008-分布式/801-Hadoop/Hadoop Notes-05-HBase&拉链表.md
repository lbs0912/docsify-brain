


# Hadoop Notes-05-HBase


[TOC]

## 更新
* 2021/03/15，撰写
* 2021/04/21，添加 *拉链表*

## 参考资料


* [HBase入门教程 | 阿里云](https://edu.aliyun.com/course/73/lesson/list?utm_campaign=aliyunedu&spm=5176.12901015.0.i12901015.78c4525czj50Ig)
 




## 拉链表
* [深入讲解拉链表 | 掘金](https://juejin.cn/post/6914305417912958983)
* [数仓缓慢变化维深层讲解 | CSDN](https://blog.csdn.net/qq_43791724/article/details/112204356)


* 拉链表不存储冗余的数据，只有某行的数据发生变化，才需要保存下来，相比每次全量同步会节省存储空间
* 拉链表能够查询到历史快照
* 拉链表额外的增加了两列（`dw_start_date`、`dw_end_date`），为数据行的生命周期

