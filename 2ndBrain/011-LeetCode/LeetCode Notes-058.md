# LeetCode Notes-058


[TOC]



## 更新
* 2021/08/08，撰写
* 2021/08/10，撰写


## Overview
* [LeetCode-121. 买卖股票的最佳时机](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock/)
* [LeetCode-122. 买卖股票的最佳时机 II](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-ii/description/)
* [LeetCode-123. 买卖股票的最佳时机 III](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-iii/description/)
* [LeetCode-188. 买卖股票的最佳时机 IV](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-iv/description/)
* [LeetCode-504. 七进制数](https://leetcode-cn.com/problems/base-7/description/)


## 121. 买卖股票的最佳时机
### Description
* [LeetCode-121. 买卖股票的最佳时机](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock/)

### Approach 1-暴力
#### Analysis

参考 `leetcode-cn` 官方题解。


该方法会超时，此处仅做记录。

#### Solution



```java
class Solution {
    public int maxProfit(int[] prices) {
        int maxProfit = 0;
        int len = prices.length;
        for(int i=0;i<len-1;i++){
            for(int j=i+1;j<len;j++){
                maxProfit = Math.max(maxProfit,prices[j] - prices[i]);
            }
        }
        return maxProfit;
    }
}
```




### Approach 2-一次遍历
#### Analysis

参考 `leetcode-cn` 官方题解。


由于卖出点一定要在买进点之后，即符合条件的最大利润的值，max 一定是在 min 之后出现的，因此可以一次遍历数组。

#### Solution


```java
public class Solution {
    public int maxProfit(int prices[]) {
        int minprice = Integer.MAX_VALUE;
        int maxprofit = 0;
        for(int i=0;i<prices.length;i++){
            if(prices[i] < minprice){
                minprice = prices[i];
            }
            maxprofit = Math.max(maxprofit,prices[i] - minprice);
        }
        return maxprofit;
    }
}
```




## 122. 买卖股票的最佳时机 II
### Description
* [LeetCode-122. 买卖股票的最佳时机 II](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-ii/description/)


计算数组的上升区间段，**由于不限制交易次数**，故取出所有上升区间段，累加求和即可。

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int maxProfit(int[] prices) {
        //计算数组的前缀查
        // arr  = [7  1  5  3  6  4]
        // diff = [0 -6 +4 -2 +3 -2]  
        // 计算diff中元素大于0的和
        int sum = 0;
        for(int i=1;i<prices.length;i++){
            sum += Math.max(0, prices[i] - prices[i-1]);
        }
        return sum;
    }
}
```



## 123. 买卖股票的最佳时机 III
### Description
* [LeetCode-123. 买卖股票的最佳时机 III](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-iii/description/)

### Approach 1-常规-未通过
#### Analysis

参考 `leetcode-cn` 官方题解。



参考 [LeetCode-122. 买卖股票的最佳时机 II](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-ii/description/) 的解法，计算数组的上升区间段，取出两个最大的区间。 

但是该算法并未通过，此处仅做记录。



这是因为，第122题目中，**不限制交易次数**，故所有的上升区间段都可通过交易得到，累加求和即可。


第123题目中，只限制了最大2次交易，完全可以在一个上升区间段后，先下跌再上升，最后最大利润为该3段线段的总和。考虑如下例子


```java
arr = [1,2,4,2,5,7,2,4,9,0]
diff = [0 1 2 -2 3 2 -5 2 5 -9]
```

如果直接计算两段最大的上升区间，则为 5（=3+2）和 7（=2+5），最终答案为12。即[2,7] 和 [2,9] 区间进行交易。

实际正确的答案为 [1,7] 和 [2,9] 区间进行交易，最终答案为6+7=13。



#### Solution



```java
class Solution {
    public int maxProfit(int[] prices) {
        int max1 = 0;
        int max2 = 0;  //维护最大值和第2大的最大值
        int ascendZone = 0; // 上升区间

        for(int i=1;i<prices.length;i++){
            int profit = prices[i] - prices[i-1];
            if(profit > 0){
                ascendZone += profit;
            } else  {
                if(ascendZone > max1){
                    max2 = max1;
                    max1 = ascendZone;
                } else if(ascendZone > max2){
                    max2 = ascendZone;
                }
                ascendZone = 0;
            }
        }
        //处理最后的上升区间
        if(ascendZone > max1){
            max2 = max1;
            max1 = ascendZone;
        } else if(ascendZone > max2){
            max2 = ascendZone;
        }
        return max1+max2;
    }
}
```




### Approach 2-动态规划
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public int maxProfit(int[] prices) {
        int n = prices.length;
        int buy1 = -prices[0], sell1 = 0;
        int buy2 = -prices[0], sell2 = 0;
        for (int i = 1; i < n; ++i) {
            buy1 = Math.max(buy1, -prices[i]);
            sell1 = Math.max(sell1, buy1 + prices[i]);
            buy2 = Math.max(buy2, sell1 - prices[i]);
            sell2 = Math.max(sell2, buy2 + prices[i]);
        }
        return sell2;
    }
}
```




## 188. 买卖股票的最佳时机 IV
### Description
* [LeetCode-188. 买卖股票的最佳时机 IV](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-iv/description/)

### Approach 1-动态规划
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int maxProfit(int k, int[] prices) {
        if (prices.length == 0) {
            return 0;
        }

        int n = prices.length;
        k = Math.min(k, n / 2);
        int[] buy = new int[k + 1];
        int[] sell = new int[k + 1];

        buy[0] = -prices[0];
        sell[0] = 0;
        for (int i = 1; i <= k; ++i) {
            buy[i] = sell[i] = Integer.MIN_VALUE / 2;
        }

        for (int i = 1; i < n; ++i) {
            buy[0] = Math.max(buy[0], sell[0] - prices[i]);
            for (int j = 1; j <= k; ++j) {
                buy[j] = Math.max(buy[j], sell[j] - prices[i]);
                sell[j] = Math.max(sell[j], buy[j - 1] + prices[i]);   
            }
        }

        return Arrays.stream(sell).max().getAsInt();
    }
}
```




## 504. 七进制数
### Description
* [LeetCode-504. 七进制数](https://leetcode-cn.com/problems/base-7/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public String convertToBase7(int num) {
        StringBuilder sb = new StringBuilder();
        boolean negative = (num < 0);
        if(num == 0){
            return "0";
        }
        num = Math.abs(num);
        while(num > 0){
            int digit = num%7;
            sb.append(digit);
            num = num/7;
        }
        if(negative){
            sb.append("-");
        }        
        return sb.reverse().toString();

    }
}
```



