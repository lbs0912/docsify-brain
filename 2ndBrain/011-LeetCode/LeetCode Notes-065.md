
# LeetCode Notes-065


[TOC]



## 更新
* 2021/08/22，撰写
* 2021/09/06，完成



## Overview

* [LeetCode-744. 寻找比目标字母大的最小字母](https://leetcode-cn.com/problems/find-smallest-letter-greater-than-target/description/)
* [LeetCode-674. 最长连续递增序列](https://leetcode-cn.com/problems/longest-continuous-increasing-subsequence/description/)
* [LeetCode-643. 子数组最大平均数 I](https://leetcode-cn.com/problems/maximum-average-subarray-i/description/)
* [LeetCode-1071. 字符串的最大公因子](https://leetcode-cn.com/problems/greatest-common-divisor-of-strings/description/)
* [LeetCode-1979. 找出数组的最大公约数](https://leetcode-cn.com/problems/find-greatest-common-divisor-of-array/)








## 744. 寻找比目标字母大的最小字母
### Description
* [LeetCode-744. 寻找比目标字母大的最小字母](https://leetcode-cn.com/problems/find-smallest-letter-greater-than-target/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public char nextGreatestLetter(char[] letters, char target) {
        int length = letters.length;
        for(int i=0;i<length;i++){
            if(letters[i] - target > 0){
                return letters[i];
            }
        }
        return letters[0];
    }
}
```

## 674. 最长连续递增序列
### Description
* [LeetCode-674. 最长连续递增序列](https://leetcode-cn.com/problems/longest-continuous-increasing-subsequence/description/)

### Approach 1-双指针
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int findLengthOfLCIS(int[] nums) {
        int max = 1; //数组长度>=1
        int right = 0;
        int left = 0;
        for(int i=1;i<nums.length;i++){
            if(nums[i] - nums[i-1] <= 0){
                max = Math.max(max,left-right+1);
                right = i;
                left = i;
            } else {
                left++;
            }
        }
        return Math.max(max,left-right+1); //若数组一直递增 处理最后一次
    }
}
```


## 643. 子数组最大平均数 I
### Description
* [LeetCode-643. 子数组最大平均数 I](https://leetcode-cn.com/problems/maximum-average-subarray-i/description/)

### Approach 1-滑动窗
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public double findMaxAverage(int[] nums, int k) {
        int sum = 0;
        double avg = 0.0;
        for(int i=0;i<k;i++){
            sum += nums[i];
        }
        avg = 1.0 * sum/k;

        for(int j=k;j<nums.length;j++){
            sum += nums[j];
            sum -= nums[j-k];
            avg = Math.max(avg,1.0*sum/k); //注意1.0 精度转换
        }
        return avg;

    }
}
```





## 1071. 字符串的最大公因子
### Description
* [LeetCode-1071. 字符串的最大公因子](https://leetcode-cn.com/problems/greatest-common-divisor-of-strings/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public String gcdOfStrings(String str1, String str2) {
        int len1 = str1.length();
        int len2 = str2.length();
        for(int i=Math.min(len1,len2);i>=1;i--){// 从长度大的开始枚举
            if (len1 % i == 0 && len2 % i == 0) {  //i必须是两个字符串长度的公约数
                String X = str1.substring(0, i);
                if (check(X, str1) && check(X, str2)) {
                    return X;
                }
            }
        }
        return "";
    }
    public boolean check(String t, String s) {
        int lenx = s.length() / t.length();
        StringBuffer ans = new StringBuffer();
        for (int i = 1; i <= lenx; ++i) {
            ans.append(t);
        }
        return ans.toString().equals(s);
    }
}
```

### Approach 2-辗转相除法
#### Analysis

参考 `leetcode-cn` 官方题解。




**如果存在一个符合要求的字符串 X，那么也一定存在一个符合要求的字符串 X'，它的长度为 str1 和 str2 长度的最大公约数。**

**使用辗转相除法求最大公约数。**

#### Solution


```java
class Solution {
    public String gcdOfStrings(String str1, String str2) {
        int len1 = str1.length(), len2 = str2.length();
        String T = str1.substring(0, gcd(len1, len2));
        if (check(T, str1) && check(T, str2)) {
            return T;
        }
        return "";
    }

    public boolean check(String t, String s) {
        int lenx = s.length() / t.length();
        StringBuffer ans = new StringBuffer();
        for (int i = 1; i <= lenx; ++i) {
            ans.append(t);
        }
        return ans.toString().equals(s);
    }

    public int gcd(int a, int b) {
        int remainder = a % b;
        while (remainder != 0) {
            a = b;
            b = remainder;
            remainder = a % b;
        }
        return b;
    }
}
```





## 1979. 找出数组的最大公约数
### Description
* [LeetCode-1979. 找出数组的最大公约数](https://leetcode-cn.com/problems/find-greatest-common-divisor-of-array/)

### Approach 1-辗转相除法
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int findGCD(int[] nums) {
        Arrays.sort(nums);
        int max = nums[nums.length-1];
        int min = nums[0];
        return gcd(max,min);
    }

    //辗转相除法 求最大公约数
    private int gcd(int max,int min){
        int val = max%min;
        while(val != 0){
            max = min;
            min = val;
            val = max%min;
        }
        return min;
    }
}
```