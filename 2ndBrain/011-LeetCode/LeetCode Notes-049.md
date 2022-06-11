
# LeetCode Notes-049


[TOC]



## 更新
* 2021/07/23，撰写
* 2021/07/23，完成


## Overview
* [LeetCode-1450. 在既定时间做作业的学生人数](https://leetcode-cn.com/problems/number-of-students-doing-homework-at-a-given-time/)
* [LeetCode-1221. 分割平衡字符串](https://leetcode-cn.com/problems/split-a-string-in-balanced-strings/)
* [LeetCode-627. 变更性别](https://leetcode-cn.com/problems/swap-salary/)
* [LeetCode-1822. 数组元素积的符号](https://leetcode-cn.com/problems/sign-of-the-product-of-an-array/)
* [LeetCode-1672. 最富有客户的资产总量](https://leetcode-cn.com/problems/richest-customer-wealth/)





## 1450. 在既定时间做作业的学生人数
### Description
* [LeetCode-1450. 在既定时间做作业的学生人数](https://leetcode-cn.com/problems/number-of-students-doing-homework-at-a-given-time/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution




```java
class Solution {
    public int busyStudent(int[] startTime, int[] endTime, int queryTime) {
        int count = 0;
        for(int i=0;i<startTime.length;i++){
            if(startTime[i] <= queryTime && queryTime <= endTime[i]){
                count++;
            }
        }
        return count;
    }
}
```




## 1221. 分割平衡字符串
### Description
* [LeetCode-1221. 分割平衡字符串](https://leetcode-cn.com/problems/split-a-string-in-balanced-strings/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public int balancedStringSplit(String s) {
        int l = 0;
        int r = 0;
        int count = 0;
        for(int i=0;i<s.length();i++){
            if(s.charAt(i) == 'L'){
                l++;
            } else{
                r++;
            }
            if(l == r && l != 0){
                count++;
                l = 0;
                r = 0;
            }
        }
        return count;
    }
}
```


## 627. 变更性别
### Description
* [LeetCode-627. 变更性别](https://leetcode-cn.com/problems/swap-salary/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```sql
# Write your MySQL query statement below

UPDATE salary
SET 
    sex = CASE sex
        WHEN 'm' THEN 'f'
        ELSE 'm'
END;
```



## 1822. 数组元素积的符号
### Description
* [LeetCode-1822. 数组元素积的符号](https://leetcode-cn.com/problems/sign-of-the-product-of-an-array/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public int arraySign(int[] nums) {
        int ans = 1;
        for(int num:nums){
            if(num < 0){
                ans = -ans;
            } else if(num == 0){
                ans = 0;
                break;
            }
        }
        return ans;

    }
}

```






## 1672. 最富有客户的资产总量
### Description
* [LeetCode-1672. 最富有客户的资产总量](https://leetcode-cn.com/problems/richest-customer-wealth/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public int maximumWealth(int[][] accounts) {
        int m = accounts.length;
        int max = Integer.MIN_VALUE;
        for(int i = 0;i<m;i++){
            int sum = 0;
            for(int j=0;j<accounts[i].length;j++){
                sum += accounts[i][j];
            }
            max = Math.max(max,sum);
        }
        return max;
    }
}
```