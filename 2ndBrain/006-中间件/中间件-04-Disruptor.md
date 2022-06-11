# 中间件-04-Disruptor


[TOC]

## 更新
* 2022/06/06，撰写

## 参考资料
* [高性能队列 Disruptor | 美团技术](https://tech.meituan.com/2016/11/18/disruptor.html)


## 前言

Disruptor 是英国外汇交易公司 LMAX 开发的一个高性能队列。Disruptor 通过精巧的无锁设计实现了在高并发情形下的高性能，基于 Disruptor 开发的系统单线程能支撑每秒 600 万订单。