

# LeetCode Notes-046


[TOC]



## 更新
* 2021/07/21，撰写
* 2021/07/22，完成


## Overview

* [LeetCode-1556. 千位分隔数](https://leetcode-cn.com/problems/thousand-separator/description/)
* [LeetCode-1550. 存在连续三个奇数的数组](https://leetcode-cn.com/problems/three-consecutive-odds/description/)
* [LeetCode-1523. 在区间范围内统计奇数数目](https://leetcode-cn.com/problems/count-odd-numbers-in-an-interval-range/description/)
* [LeetCode-1518. 换酒问题](https://leetcode-cn.com/problems/water-bottles/description/)
* [LeetCode-1512. 好数对的数目](https://leetcode-cn.com/problems/number-of-good-pairs/description/)



## 1556. 千位分隔数
### Description
* [LeetCode-1556. 千位分隔数](https://leetcode-cn.com/problems/thousand-separator/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public String thousandSeparator(int n) {
        StringBuffer sBuffer = new StringBuffer();
        if(n<1000){
            return String.valueOf(n);
        }
        while(n > 0){
            int val = n%1000;
            if(sBuffer.length() != 0){
                sBuffer.insert(0,".");
            }
           
            if(n/1000 == 0){
                //首位不补0
                sBuffer.insert(0,String.valueOf(val));
            } else{
                sBuffer.insert(0,String.format("%03d",val));
            }
            n = n/1000;
           
          
        }
        return sBuffer.toString();

    }
}
```




## 1550. 存在连续三个奇数的数组
### Description
* [LeetCode-1550. 存在连续三个奇数的数组](https://leetcode-cn.com/problems/three-consecutive-odds/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public boolean threeConsecutiveOdds(int[] arr) {
        int count = 0;
        for(int i=0;i<arr.length;i++){
            if(arr[i]%2 != 0){
                count++;
                if(count == 3){
                    return true;
                }
            } else{
                count = 0;
            }
        }
        return false;
    }
}
```



## 1523. 在区间范围内统计奇数数目
### Description
* [LeetCode-1523. 在区间范围内统计奇数数目](https://leetcode-cn.com/problems/count-odd-numbers-in-an-interval-range/description/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int countOdds(int low, int high) {
       
        if(low == high){
            return low%2 == 0? 0:1;
        }
        int count = 0;
        if(low%2 != 0){
            count++;
        }
        if(high%2 != 0){
            count++;
        }
        if(count == 2){
            //两个边界都是奇数
            count += (high-low-1)/2;
        } else {
            count += (high-low)/2;
        }
        
        return count;

    }
}
```



### Approach 2-前缀和
#### Analysis

参考 `leetcode-cn` 官方题解。

如果我们暴力枚举 `[low,high]` 中的所有元素会超出时间限制。

我们可以使用前缀和思想来解决这个问题，定义 `pre(x)` 为区间 `[0, x]` 中奇数的个数，很显然

```s
pre(x)=⌊x+1/2⌋  //向下取整
```

故答案为 `pre(high) - pre(low−1)`。

#### Solution


```java
class Solution {
    public int countOdds(int low, int high) {
        return pre(high) - pre(low - 1);
    }

    public int pre(int x) {
        return (x + 1) >> 1;
    }
}
```
## 1518. 换酒问题
### Description
* [LeetCode-1518. 换酒问题](https://leetcode-cn.com/problems/water-bottles/description/)
 

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int numWaterBottles(int numBottles, int numExchange) {
        int sum = numBottles;
        int leftNum = 0;
        int exChangeNum = 0;
        while(numBottles >= numExchange){
            leftNum = numBottles%numExchange;
            exChangeNum = numBottles/numExchange;
            sum += exChangeNum;
            numBottles = leftNum+exChangeNum;
        }
        
        return sum;

    }
}
```


## 1512. 好数对的数目
### Description
* [LeetCode-1512. 好数对的数目](https://leetcode-cn.com/problems/number-of-good-pairs/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution




```java
class Solution {
    public int numIdenticalPairs(int[] nums) {
        Map<Integer,Integer> map = new HashMap<>();
        for(int val:nums){
            map.put(val,1+map.getOrDefault(val, 0));
        }
        int sum = 0;
        for(Map.Entry<Integer,Integer> entry:map.entrySet()){
            int num = entry.getValue();
            sum += num*(num-1)/2;   //对 1 2 ... n-1 求和
        }
        return sum;

    }
}
```
