
# LeetCode Notes-020


[TOC]



## 更新
* 2021/03/01，撰写
* 2021/03/02，完成


## Overview
* [LeetCode-1332. 删除回文子序列](https://leetcode-cn.com/problems/remove-palindromic-subsequences/)
* [LeetCode-1704. 判断字符串的两半是否相似](https://leetcode-cn.com/problems/determine-if-string-halves-are-alike/)
* [LeetCode-1662. 检查两个字符串数组是否相等](https://leetcode-cn.com/problems/check-if-two-string-arrays-are-equivalent/)
* [LeetCode-1588. 所有奇数长度子数组的和](https://leetcode-cn.com/problems/sum-of-all-odd-length-subarrays/)
* [LeetCode-237. 删除链表中的节点](https://leetcode-cn.com/problems/delete-node-in-a-linked-list/)



## 1332. 删除回文子序列
### Description
* [LeetCode-1332. 删除回文子序列](https://leetcode-cn.com/problems/remove-palindromic-subsequences/)

### Approach 1-常规求解
#### Analysis

参考 `leetcode-cn` 官方题解。


注意审题，每次可以被移除的是一个回文子序列，不是回文子字符串，这个信息非常重要。**子序列不要求各个字符连续，而子字符串要求各个字符连续。**

举个例子，对于原始字符串 `aababbaabaabbabbaaabbabbbaabba`，它的子字符串是什么，就是截取其中连续的一串，例如 `babbaa`；而它的子序列是什么呢，就是不打乱顺序的从中随意取出字符（**不要求连续**），凑成一串，例如 `aaaa`。


因此有如下思路
1. 若字符串为空，则直接返回 0
2. 统计字符 `a` 和字符 `b` 出现的次数 `countA` 和 `countB`
3. 如果次数有一个为空， 说明字符串全部为 `a` 或者全部为 `b`，此时返回 1
4. 判断字符串本身是否已经为回文串，若是，则返回1
5. 否则，需要 2 次操作，第一次删除所有的 `a` 构成的回文子序列，第 2 次删除所有的 `b` 构成的回文子序列。


复杂度分析
* 时间复杂度: `O(n)`
* 空间复杂度: `O(1)`


#### Solution


```java
class Solution {
    public int removePalindromeSub(String s) {
        String res;
        int countA = 0;
        int countB = 0;
        if(s.length() == 0){
            return 0;
        }
        for(int i=0;i<s.length();i++){
            char c = s.charAt(i);
            if('a' == c){
                countA++;
            }
            if('b' == c){
                countB++;
            }
        }
        if(countA == 0 || countB == 0){
            return 1;
        } else if (s.equals(new StringBuilder(s).reverse().toString())){ //本身已经回文串
          return 1;  
        } 
        return 2;
    }
}
```


## 1704. 判断字符串的两半是否相似
### Description
* [LeetCode-1704. 判断字符串的两半是否相似](https://leetcode-cn.com/problems/determine-if-string-halves-are-alike/)

### Approach 1-常规求解
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(N)`
* 空间复杂度：`O(1)`



#### Solution

```java
class Solution {
    public boolean halvesAreAlike(String s) {
        s = s.toLowerCase();
        int length = s.length();
        int countLeft = 0;
        int countRight = 0;
        Set<Character> set = new HashSet(){{
            add('a');
            add('e');
            add('i');
            add('o');
            add('u');
        }};
        for(int i=0;i<(length>>1);i++){
            char left = s.charAt(i);
            char right = s.charAt(length-1-i);
            if(set.contains(left)){
                countLeft++;
            }
            if(set.contains(right)){
                countRight++;
            }
        }
        return countLeft == countRight;
    }
}
```


## 1662. 检查两个字符串数组是否相等
### Description
* [LeetCode-1662. 检查两个字符串数组是否相等](https://leetcode-cn.com/problems/check-if-two-string-arrays-are-equivalent/)

### Approach 1-StringBuilder

#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public boolean arrayStringsAreEqual(String[] word1, String[] word2) {
        StringBuilder sb1 = new  StringBuilder();
        StringBuilder sb2 = new  StringBuilder();
        for(String i:word1){
            sb1.append(i);
        }
        for(String j:word2){
            sb2.append(j);
        }
        return sb1.toString().equals(sb2.toString());
    }
}
```

### Approach 2-String.join

#### Analysis

参考 `leetcode-cn` 官方题解。

使用内置的 `String.join()` 方法求解。 

#### Solution

```java
```


## 1588. 所有奇数长度子数组的和
### Description
* [LeetCode-1588. 所有奇数长度子数组的和](https://leetcode-cn.com/problems/sum-of-all-odd-length-subarrays/)

### Approach 1-O(n^3)

#### Analysis

参考 `leetcode-cn` 官方题解。


三重for循环求解，代码如下。
* 执行用时: 4 ms
* 内存消耗: 35.8 MB


复杂度分析
* 时间复杂度： `O(n^3)`
* 空间复杂度： `O(1)`


#### Solution


```java
class Solution {
    public int sumOddLengthSubarrays(int[] arr) {
        int length = arr.length;
        int sum = 0;
        for(int i=0;i<length;i++){ 
            for(int subLength=1;i+subLength-1<length;subLength +=2){
                sum += getArrSum(arr,i,i+subLength-1);
            }
        }
        return sum;

    }
    private int getArrSum(int[] arr,int begin,int end){
        int sum = 0;
        for(int i=begin;i<=end;i++){
            sum += arr[i];
        }
        return sum;
    }

}
```


### Approach 2-O(n^2)

#### Analysis

参考 `leetcode-cn` 官方题解。


在方法1的基础上进行优化，考虑到方法1中的 `getArrSum` 是求解连续一段区间的数组和，这个可以通过 *数组前缀和* 来求解。这样可以将时间复杂度从 `O(n^3)` 降低到 `O(n^2)`。
* 执行用时: 1 ms
* 内存消耗: 36.2 MB


复杂度分析
* 时间复杂度： `O(n^2)`
* 空间复杂度： `O(n)`，引入了前缀和数组。


#### Solution


```java
class Solution {
    public int sumOddLengthSubarrays(int[] arr) {
        int length = arr.length;
        int sum = 0;
        int[] preSum = new int[length+1];
        for(int i=1;i<=length;i++){ //前缀和
            preSum[i] += preSum[i-1] + arr[i-1];
        }
        for(int i=0;i<length;i++){
            for(int subLength=1;i+subLength-1<length;subLength +=2){
                sum += preSum[i+subLength] - preSum[i];
            }
        }
        return sum;

    }
}
```



### Approach 3-O(n)




#### Analysis

参考 `leetcode-cn` 官方题解。


* [ref-题解-O(N)时间复杂度，O(1)时间复杂度](https://leetcode-cn.com/problems/sum-of-all-odd-length-subarrays/solution/onshi-jian-fu-za-du-o1shi-jian-fu-za-du-by-crj1998/)



没必要计算所有满足条件的数组，只需要知道每个元素会出现的次数，然后乘以其值，求和就可以得到结果，即

```math
result = \sum_{i=0}^{n-1}A[i]*cnt(i)
```


因此问题的关键在于求索引为ii的元素会出现次数 `cnt(i)`。


对于一个有 N 个元素的数组，以索引 `i` 的元素为界，可以把子序列分到 `A[0:i-1]`、`A[i]`、 `A[i+1:n-1]` 这 3 个部分中。显然，一个包含 `A[i]` 的奇数长度的连续子序列只会有 2 种情况
1. 左边和右边的子序列长度均为奇数个
2. 左边和右边的子序列长度均为偶数个

以第 1 种情况为例，要从 `A[0:i−1]` 序列中，选取连续的、紧靠 `A[i]` 的，长度为奇数的子序列，所以可以有下面这些情况：`(i-1)`, `(i-3, i-2, i-1)` ……


总结归纳不难发现
* 数字 `A[i]` 前面共有 `left` 个选择，其中偶数个数字的选择方案有 `left_even = (left + 1) / 2` 个，奇数个数字的选择方案有 `left_odd = left / 2` 个；
* 数字 `A[i]` 后面共有 `right` 个选择，其中偶数个数字的选择方案有 `right_even = (right + 1) / 2` 个，奇数个数字的选择方案有 `right_odd = right / 2` 个；

所以，数字 `A[i]` 一共在 `left_even * right_even + left_odd * right_odd` 个奇数长度的数组中出现过。



本方案中，可以将时间复杂度从 `O(n^2)` 优化到 `O(n)`。
* 执行用时: 0 ms
* 内存消耗: 36.1 MB


复杂度分析
* 时间复杂度： `O(n)`
* 空间复杂度： `O(1)`


#### Solution


```java
class Solution {
    public int sumOddLengthSubarrays(int[] arr) {
        int len = arr.length;
        int res = 0;
        for(int i = 0; i < len; i ++){
            int leftOdd = (i+1)/2;
            int leftEven = i/2+1;
            int rightOdd = (len-i)/2;
            int rightEven = (len-1-i)/2+1;
            res += arr[i] * (leftOdd * rightOdd + leftEven * rightEven);
        }
        return res;
    }
}
```



## 237. 删除链表中的节点

### Description
* [LeetCode-237. 删除链表中的节点](https://leetcode-cn.com/problems/delete-node-in-a-linked-list/)

### Approach 1-常规求解

#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度： `O(1)`
* 空间复杂度： `O(1)`


#### Solution


```java
class Solution {
    public void deleteNode(ListNode node) {
        node.val = node.next.val;
        node.next = node.next.next;
    }
}
```


