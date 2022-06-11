
# LeetCode Notes-035


[TOC]



## 更新
* 2021/06/27，撰写
* 2021/06/28，完成
* 2021/06/28，经典题目赏析-[LeetCode-583. 两个字符串的删除操作](https://leetcode-cn.com/problems/delete-operation-for-two-strings/)，考察最长公共子序列的递归求解和动态规划求解

## Overview
* [LeetCode-583. 两个字符串的删除操作](https://leetcode-cn.com/problems/delete-operation-for-two-strings/)
* [LeetCode-剑指 Offer 58 - II. 左旋转字符串](https://leetcode-cn.com/problems/zuo-xuan-zhuan-zi-fu-chuan-lcof/)
* [LeetCode-1903. 字符串中的最大奇数](https://leetcode-cn.com/problems/largest-odd-number-in-string/)
* [LeetCode-165. 比较版本号](https://leetcode-cn.com/problems/compare-version-numbers/description/)
* [LeetCode-961. 重复 N 次的元素](https://leetcode-cn.com/problems/n-repeated-element-in-size-2n-array/description/)






## 583. 两个字符串的删除操作
### Description
* [LeetCode-583. 两个字符串的删除操作](https://leetcode-cn.com/problems/delete-operation-for-two-strings/)

### Approach 1-带记忆化的最长公共子序列

#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
public class Solution {
    public int minDistance(String s1, String s2) {
        int[][] memo = new int[s1.length() + 1][s2.length() + 1];
        return s1.length() + s2.length() - 2 * lcs(s1, s2, s1.length(), s2.length(), memo);
    }
    public int lcs(String s1, String s2, int m, int n, int[][] memo) {
        if (m == 0 || n == 0)
            return 0;
        if (memo[m][n] > 0)
            return memo[m][n];
        if (s1.charAt(m - 1) == s2.charAt(n - 1))
            memo[m][n] = 1 + lcs(s1, s2, m - 1, n - 1, memo);
        else
            memo[m][n] = Math.max(lcs(s1, s2, m, n - 1, memo), lcs(s1, s2, m - 1, n, memo));
        return memo[m][n];
    }
}
```

### Approach 2-最长公共子序列 - 动态规划

#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
public class Solution {
    public int minDistance(String s1, String s2) {
        int[][] dp = new int[s1.length() + 1][s2.length() + 1];
        for (int i = 0; i <= s1.length(); i++) {
            for (int j = 0; j <= s2.length(); j++) {
                if (i == 0 || j == 0)
                    continue;
                if (s1.charAt(i - 1) == s2.charAt(j - 1))
                    dp[i][j] = 1 + dp[i - 1][j - 1];
                else
                    dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
        return s1.length() + s2.length() - 2 * dp[s1.length()][s2.length()];
    }
}
```

### Approach 3-一维动态规划

#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
public class Solution {
    public int minDistance(String s1, String s2) {
        int[] dp = new int[s2.length() + 1];
        for (int i = 0; i <= s1.length(); i++) {
            int[] temp=new int[s2.length()+1];
            for (int j = 0; j <= s2.length(); j++) {
                if (i == 0 || j == 0)
                    temp[j] = i + j;
                else if (s1.charAt(i - 1) == s2.charAt(j - 1))
                    temp[j] = dp[j - 1];
                else
                    temp[j] = 1 + Math.min(dp[j], temp[j - 1]);
            }
            dp=temp;
        }
        return dp[s2.length()];
    }
}
```


## 剑指 Offer 58 - II. 左旋转字符串
### Description
* [LeetCode-剑指 Offer 58 - II. 左旋转字符串](https://leetcode-cn.com/problems/zuo-xuan-zhuan-zi-fu-chuan-lcof/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution

```java
class Solution {
    public String reverseLeftWords(String s, int n) {
        int length = s.length();
        n = n % length;
        return new StringBuilder(s.substring(n,length)).append(s.substring(0,n)).toString();

    }
}
```




## 1903. 字符串中的最大奇数
### Description
* [LeetCode-1903. 字符串中的最大奇数](https://leetcode-cn.com/problems/largest-odd-number-in-string/)

### Approach 1-贪心
#### Analysis

参考 `leetcode-cn` 官方题解。


需要注意的是，将 `char` 转化为 `int`，可以采用如下方法
1. 方法1：`char` -> `String.valueOf(char)` -> `Integer.parsetInt(string)`
2. 方法2：`char - '0'`



```java

//方法1
Integer.parseInt(String.valueOf(num.charAt(i)))

//方法2
num[i] - '0'
```

#### Solution



```java
class Solution {
    public String largestOddNumber(String num) {
        int length  = num.length();
        for(int i=length-1;i>=0;i--){
            // 从右到左  找到第一个值为奇数的字符，返回 num[0:i+1]
            //  if ((num[i] - '0') % 2 == 1){   也可采用此种转化
            if(Integer.parseInt(String.valueOf(num.charAt(i))) % 2 == 1){
                return num.substring(0,i+1);
            }
        }
        // 未找到值为奇数的字符，返回空字符串
        return "";

    }
}
```


## 165. 比较版本号
### Description
* [LeetCode-165. 比较版本号](https://leetcode-cn.com/problems/compare-version-numbers/description/)

### Approach 1-分割比较，两次遍历，线性空间
#### Analysis

参考 `leetcode-cn` 官方题解。

分割比较，两次遍历，线性空间。复杂度分析如下
* 时间复杂度：`O(N+M+max(N,M))`。其中 N 和 M 指的是输入字符串的长度。（两次遍历）
* 空间复杂度：`O(N+M)`，使用了两个数组 nums1 和 nums2 存储两个字符串的块。


#### Solution

```java
class Solution {
    public int compareVersion(String version1, String version2) {
        int res = 0;
        String[] arr1 = version1.split("\\.");
        String[] arr2 = version2.split("\\.");
        int length1 = arr1.length;
        int length2 = arr2.length;
        int i=0;
        int j=0;
        while(i < length1 && j< length2){
            Integer a = Integer.parseInt(arr1[i]);
            Integer b = Integer.parseInt(arr2[j]);
            if( a < b){
                return -1;
            } else if(a > b){
                return 1;
            } else{
                i++;
                j++;
            }
        }
        while(i<length1){
            Integer a = Integer.parseInt(arr1[i]);
            if(a>0){
                return 1;
            }
            i++;
        }
        while(j<length2){
            Integer b = Integer.parseInt(arr2[j]);
            if(b>0){
                return -1;
            }
            j++;
        }
        return res;
    }
}
```

此处给出一个官方的题解，代码更简洁。


```java
class Solution {
  public int compareVersion(String version1, String version2) {
    String[] nums1 = version1.split("\\.");
    String[] nums2 = version2.split("\\.");
    int n1 = nums1.length, n2 = nums2.length;

    // compare versions
    int i1, i2;
    for (int i = 0; i < Math.max(n1, n2); ++i) {
      i1 = i < n1 ? Integer.parseInt(nums1[i]) : 0; 
      i2 = i < n2 ? Integer.parseInt(nums2[i]) : 0;
      if (i1 != i2) {
        return i1 > i2 ? 1 : -1;
      }
    }
    // the versions are equal
    return 0;
  }
}
```


### Approach 2-双指针
#### Analysis

参考 `leetcode-cn` 官方题解。

注意 `Pair` 的使用。函数只能返回一个值或者一个对象，若要返回两个值，可以将其包装为 `Pair` 对象。

> `Pair` 只包含一对 `key-value`，`Map` 包含多个 `key-value`。


复杂度分析
* 时间复杂度：`O(max(N,M))`。其中 N 和 M 指的是输入字符串的长度。
* 空间复杂度：`O(1)`，没有使用额外的数据结构。

#### Solution



```java
class Solution {
    public int compareVersion(String version1, String version2) {
        int p1 = 0, p2 = 0;
        int n1 = version1.length(), n2 = version2.length();

        Pair<Integer, Integer> pair;
        Integer a,b;
        while(p1 < n1 || p2 < n2){
            pair = this.getNextChunk(version1,p1);
            a = pair.getKey();
            p1 = pair.getValue();

            pair = this.getNextChunk(version2,p2);
            b = pair.getKey();
            p2 = pair.getValue();

            if(!a.equals(b)){
                return a > b ? 1:-1;
            }
        }
        return 0;
    }

    private Pair<Integer,Integer> getNextChunk(String version,int p){
        int length = version.length();
        if(p >= length){
            return new Pair(0,p);
        }
        int index = version.indexOf(".",p);
        int val = Integer.parseInt(version.substring(p,(-1 == index)? length:index));
        return new Pair(val,(-1 == index)? length:index+1);
    }
}
```





## 961. 重复 N 次的元素
### Description
* [LeetCode-961. 重复 N 次的元素](https://leetcode-cn.com/problems/n-repeated-element-in-size-2n-array/description/)

### Approach 1-Map计数
#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(N)`，其中 N 是 A 的长度。
* 空间复杂度：`O(N)`。

#### Solution


```java
class Solution {
    public int repeatedNTimes(int[] nums) {
        Map<Integer,Integer> map = new HashMap<>();
        for(int val:nums){
            map.put(val,1 + map.getOrDefault(val,0));
            if(1 < map.getOrDefault(val,0)){
                return val;
            }
        }
        return -1;
    }
}
```

### Approach 2-数学分析
#### Analysis

参考 `leetcode-cn` 官方题解。


**考虑所有长度为 4 的子序列，在子序列中一定至少含有两个主要元素。**

这是因为长度为 2 的子序列中都是主要元素，或者每个长度为 2 的子序列都恰好含有 1 个主要元素，否则无法满足在长度为 2N 的数组中重复元素出现N次。

这意味着长度为 4 的子序列一定含有 2 个主要元素。

因此，只需要比较所有距离为 1，2 或者 3 的邻居元素即可。




复杂度分析
* 时间复杂度：`O(N)`，其中 N 是 A 的长度。
* 空间复杂度：`O(1)`。




#### Solution


```java
class Solution {
    public int repeatedNTimes(int[] A) {
        for (int k = 1; k <= 3; ++k){
            for (int i = 0; i < A.length - k; ++i){
                if (A[i] == A[i+k]){
                    return A[i];
                }   
            } 
        }
        throw null;
    }
}
```



