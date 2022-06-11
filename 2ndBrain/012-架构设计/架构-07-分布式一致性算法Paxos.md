# 架构-07-分布式一致性算法Paxos


[TOC]


## 更新
* 2022/06/08，撰写




## 参考资料
* [Paxos 协议介绍](https://www.cnblogs.com/jmcui/p/14633799.html)
* [分布式共识算法 | 凤凰架构](https://icyfenix.cn/distribution/consensus/)

## 前言

分布式系统中有多个节点，所以就会存在节点间通信的问题。节点通讯模型可分为两种
1. 共享内存（Shared memory）
2. 消息传递（Messages passing）

Paxos 是基于消息传递的通讯模型的，Paxos 的假设前提是在分布式系统中进程之间的通信会出现丢失、延迟、重复等现象，但不会出现传错的现象，即不考虑拜占庭将军问题。



## 什么是Paxos

**Paxos 协议是少数在工程实践中证实的强一致性、高可用的去中心化分布式协议，可以用来解决分布式一致性问题。**

Google 的很多大型分布式系统都采用了 Paxos 算法来解决分布式一致性问题，如 Chubby、Megastore 以及 Spanner 等。开源的 ZooKeeper 以及 MySQL 5.7 推出的用来取代传统的主从复制的 MySQL Group Replication 等纷纷采用 Paxos 算法解决分布式一致性问题。

Paxos 协议的流程较为复杂，但其基本思想却不难理解，类似于人类社会的投票过程。Paxos 协议中，有一组完全对等的参与节点，这组节点各自就某一事件做出决议，如果某个决议获得了超过半数节点的同意则生效。Paxos 协议中只要有超过一半的节点正常，就可以工作，能很好对抗宕机、网络分化等异常情况。

## 协议角色

Paxos 协议中，划分出了 3 个角色
1. Proposer（提案者）
   * 提案者可以有多个
   * 提案者提出议案（value），所谓 `value`，在工程中可以是任何操作，如修改某个变量为某个值、设置当前 `primary` 为某个节点等。Paxos 协议中统一将这些操作抽象为 `value`
   * 同一轮 Paxos 过程，最多只有一个 value 被批准
2. Acceptor（批准者）
   * 批准者可以有 N 个
   * Proposer 提出的 value 必须获得超过半数（N/2+1）的 Acceptor 批准后才能通过
   * Acceptor 之间完全对等独立
3. Learner（学习者）
   * 学习者不参与决策
   * 学习被批准的 value 


上述 3 类角色只是逻辑上的划分，实践中一个节点可以同时充当这 3类角色，即可以“身兼数职”。


## 协议流程

**Paxos 算法解决的核心问题是分布式一致性问题，即一个分布式系统中的各个进程如何就某个值（决议）达成一致。**


Paxos 协议一轮一轮的进行，每轮都有一个编号。每轮 Paxos 协议可能会批准一个 value，也可能无法批准一个 value。 如果某一轮 Paxos 协议批准了某个 value，则以后各轮 Paxos 只能批准这个 value，这是整个协议「正确性」的基础。

一次 Paxos 协议实例只能批准一个 value，这也是 Paxos 协议「强一致性」的重要体现。

每轮 Paxos 协议分为两个阶段，即准备阶段和批准阶段。Paxos 协议流程如下图所示。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/paxos-process-1.png)



## Multi-Paxos 算法


Paxos 协议引入了轮数的概念，高轮数的 Paxos 提案可以抢占低轮数的 Paxos 提案，从而避免了「死锁」的发生。然而这种设计却引入了「活锁」的可能，即 Proposer 相互不断以更高的轮数提出议案，使得每轮 Paxos过程都无法最终完成，从而无法批准任何一个value。Multi-Paxos 正是为解决此问题而提出，Multi-Paxos 基于 Basic Paxos 做了两点改进
1. 针对每一个要确定的值，运行一次 Paxos 算法实例（Instance），形成决议。每一个 Paxos 实例使用唯一的 Instance ID 标识。
2. 在所有 Proposers 中选举一个 Leader，由 Leader 唯一的提交 Proposal 给 Acceptors 进行表决。这样没有 Proposer 竞争，解决了活锁问题。在系统中仅有一个 Leader 进行 value 提交的情况下，Prepare 阶段就可以跳过，从而将两阶段变为一阶段，提高效率。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2022/multi-paxos-process-1.png)


Multi-Paxos 首先需要选举 Leader，Leader 的确定也是一次决议的形成，所以可执行一次 Basic Paxos 实例来选举出一个 Leader。选出 Leader 之后只能由 Leader 提交 Proposal，在 Leader 宕机之后服务临时不可用，需要重新选举 Leader 继续服务。在系统中仅有一个 Leader 进行 Proposal 提交的情况下，Prepare 阶段可以跳过。

Multi-Paxos 通过改变 Prepare 阶段的作用范围至后面 Leader 提交的所有实例，从而使得 Leader 的连续提交只需要执行一次 Prepare 阶段，后续只需要执行 Accept 阶段，将两阶段变为一阶段，提高了效率。为了区分连续提交的多个实例，每个实例使用一个 Instance ID 标识，Instance ID 由 Leader 本地递增生成即可。

Multi-Paxos 允许有多个自认为是 Leader 的节点并发提交 Proposal 而不影响其安全性，这样的场景即退化为 Basic Paxos。

Chubby 和 Boxwood 均使用 Multi-Paxos。ZooKeeper 使用的 Zab 也是 Multi-Paxos 的变形。