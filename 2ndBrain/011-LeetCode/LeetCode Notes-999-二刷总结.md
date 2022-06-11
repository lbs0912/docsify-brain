# LeetCode Notes-999-二刷总结

[TOC]

## 更新
* 2021/06/08，撰写，总结常见题型和解题思路，不纠结具体题目的细节。


## 链表类

<font color="red">**在对链表进行操作时，一种常用的技巧是添加一个哑节点（dummy node），它的 `next` 指针指向链表的头节点。这样一来，我们就不需要对头节点进行特殊的判断了。**</font>

### 经典题目赏析
#### 19. 删除链表的倒数第 N 个结点

* [LeetCode-19. 删除链表的倒数第 N 个结点](https://leetcode-cn.com/problems/remove-nth-node-from-end-of-list/description/) 「@LeetCode Notes-033」

解法
1. Approach 1-计算链表长度
2. Approach 2-栈
3. Approach 3-双指针




## 字符串

### 最长公共子串和最长公共子序列
* 最长公共子串（`Longest Common Substring`）
* 最长公共子序列（`Longest Common Subsequence`）


#### 二者区别

最长公共子串和最长公共子序列是不一样的。子串要求在原字符串中是连续的，而子序列则只需保持相对顺序，并不要求连续。

例如 `X = {a, Q, 1, 1}; Y = {a, 1, 1, d, f}`，那么，`{a, 1, 1}` 是 X 和 Y 的最长公共子序列，但不是它们的最长公共字串。





#### 经典题目赏析-最长公共子序列


##### 583. 两个字符串的删除操作

* [LeetCode-583. 两个字符串的删除操作](https://leetcode-cn.com/problems/delete-operation-for-two-strings/) 「@LeetCode Notes-035」

参考 `leetcode-cn` 官方题解。<font color="red">**掌握最长公共子序列的递归求解和动态规划求解。**</font>