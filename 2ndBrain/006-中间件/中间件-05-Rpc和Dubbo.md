# 中间件-05-Rpc和Dubbo

[TOC]


## 更新
* 2022/06/06，撰写


## RPC

RPC（`Remote Procedure Call`），即远程过程调用。一个典型 RPC 框架使用场景中，包含了服务注册与发现（注册中心）、负载均衡、容错、网络传输、序列化等组件。RPC 框架有很多，如 Apache Thrift、Apache Dubbo、Google Grpc 等。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/rpc-structure-1.png)




## Dubbo

* [Dubbo Cookbook](https://dubbo.apache.org/zh/)
* 
Dubbo 是一款高性能、轻量级的开源 RPC 框架，提供服务自动注册、自动发现等高效服务治理方案。Dubbo 提供 3 个核心功能
1. 面向接口的远程方法调用
2. 智能容错和负载均衡
3. 服务自动注册和发现




