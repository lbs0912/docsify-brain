
# LeetCode Notes-069


[TOC]



## 更新
* 2021/11/21，撰写
* 2021/11/21，完成



## Overview
* [LeetCode-剑指 Offer II 003. 前 n 个数字二进制中 1 的个数](https://leetcode-cn.com/problems/w3tCBm/)
* [LeetCode-剑指 Offer II 014. 字符串中的变位词](https://leetcode-cn.com/problems/MPnaiL/)
* [LeetCode-567. 字符串的排列](https://leetcode-cn.com/problems/permutation-in-string/)
* [LeetCode-剑指 Offer II 015. 字符串中的所有变位词](https://leetcode-cn.com/problems/VabMRr/)
* [LeetCode-438. 找到字符串中所有字母异位词](https://leetcode-cn.com/problems/find-all-anagrams-in-a-string/)




## 剑指 Offer II 003. 前 n 个数字二进制中 1 的个数
### Description
* [LeetCode-剑指 Offer II 003. 前 n 个数字二进制中 1 的个数](https://leetcode-cn.com/problems/w3tCBm/)

### Approach 1-Brian Kernighan 算法
#### Analysis

参考 `leetcode-cn` 官方题解。


Brian Kernighan 算法的原理是：对于任意整数 x，令 `x =x & (x−1)`，该运算将 `x` 的二进制表示的最后一个 1 变成 0。因此，对 `x` 重复该操作，直到 x 变成 0，则操作次数即为 x 的「一比特数」。

复杂度分析
* 时间复杂度: `O(nlogn)`
* 空间复杂度: `O(1)`




#### Solution

```java
class Solution {
    public int[] countBits(int n) {
        int[] list = new int [n+1];
        for(int i=0;i<n+1;i++){
            list[i] = countOneNum(i);
        }
        return list;
    }
    private int countOneNum(int val){
        int ones = 0;
        while(val > 0){
            val &= (val-1);
            ones++;
        }
        return ones;
    }
}
```



### Approach 2-动态规划-最高有效位
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度: `O(n)`
* 空间复杂度: `O(1)`





#### Solution


```java
class Solution {
    public int[] countBits(int n) {
        int[] list = new int [n+1];
        int highBit = 0;//最高有效位
        for(int i=1;i<n+1;i++){ //判断i是否2的整数次幂
            if((i & (i-1)) == 0){
                highBit = i; 
            }
            list[i] = list[i-highBit] + 1;
        }
        return list;
    }
}

```





## 剑指 Offer II 014. 字符串中的变位词
### Description
* [LeetCode-剑指 Offer II 014. 字符串中的变位词](https://leetcode-cn.com/problems/MPnaiL/)

### Approach 1-滑动窗口
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public boolean checkInclusion(String s1, String s2) {
        int len1 = s1.length();
        int len2 = s2.length();
        if(len1 > len2){
            return false;
        }
        int[] cnt1 = new int[26];
        int[] cnt2 = new int[26];

        //先计算s2中[0,len1) 
        for(int i=0;i<len1;i++){
            ++cnt1[s1.charAt(i) - 'a'];
            ++cnt2[s2.charAt(i) - 'a'];
        }
        if(Arrays.equals(cnt1,cnt2)){
            return true;
        }
        //此时cnt1和cnt2统计的区间都是宽度为len1的滑动窗口
        //下面继续计算s2中[len1,len2) 维持数组对应的滑动窗口宽度为len1
        for(int i=len1;i<len2;i++){
            //滑动窗有进有出
            ++cnt2[s2.charAt(i) - 'a'];
            --cnt2[s2.charAt(i-len1) - 'a'];
            if (Arrays.equals(cnt1, cnt2)) {
                return true;
            }
        }
        return false;
    }
}
```








## 567. 字符串的排列
### Description
* [LeetCode-567. 字符串的排列](https://leetcode-cn.com/problems/permutation-in-string/)

### Approach 1-滑动窗口
#### Analysis

参考 `leetcode-cn` 官方题解。


本题「剑指 Offer II 014. 字符串中的变位词」。

#### Solution


```json


class Solution {
    public boolean checkInclusion(String s1, String s2) {
        int len1 = s1.length();
        int len2 = s2.length();
        if(len1 > len2){
            return false;
        }
        int[] cnt1 = new int[26];
        int[] cnt2 = new int[26];

        //先计算s2中[0,len1) 
        for(int i=0;i<len1;i++){
            ++cnt1[s1.charAt(i) - 'a'];
            ++cnt2[s2.charAt(i) - 'a'];
        }
        if(Arrays.equals(cnt1,cnt2)){
            return true;
        }
        //此时cnt1和cnt2统计的区间都是宽度为len1的滑动窗口
        //下面继续计算s2中[len1,len2) 维持数组对应的滑动窗口宽度为len1
        for(int i=len1;i<len2;i++){
            //滑动窗有进有出
            ++cnt2[s2.charAt(i) - 'a'];
            --cnt2[s2.charAt(i-len1) - 'a'];
            if (Arrays.equals(cnt1, cnt2)) {
                return true;
            }
        }
        return false;
    }
}
```




## 剑指 Offer II 015. 字符串中的所有变位词
### Description
* [LeetCode-剑指 Offer II 015. 字符串中的所有变位词](https://leetcode-cn.com/problems/VabMRr/)

### Approach 1-暴力-超时
#### Analysis

参考 `leetcode-cn` 官方题解。


如下所示，暴力求解，会超时，NO AC。


#### Solution


```java
class Solution {
    public List<Integer> findAnagrams(String s, String p) {
        int len1 = s.length();
        int len2 = p.length();
        List<Integer> resList = new ArrayList<>();
        if(len1 >= len2){
            for(int i=len2;i<=len1;i++){
                String str = s.substring(i-len2,i);
                if(isSame(str,p)){
                    resList.add(i-len2);
                }
            }
        }
        return resList;
    }
    private boolean isSame(String str,String p){
        char[] ar1 = str.toCharArray();
        char[] ar2 = p.toCharArray();
        Arrays.sort(ar1);
        Arrays.sort(ar2);
        return String.valueOf(ar1).equals(String.valueOf(ar2));
    }
}
```


### Approach 2-滑动窗口
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public List<Integer> findAnagrams(String s, String p) {
        List<Integer> resList = new ArrayList<>();
        int len1 = p.length();
        int len2 = s.length();
        if(len1 > len2){
            return resList;
        }
        int[] cnt1 = new int[26];
        int[] cnt2 = new int[26];

        //先计算s中[0,len1) 
        for(int i=0;i<len1;i++){
            ++cnt1[s.charAt(i) - 'a'];
            ++cnt2[p.charAt(i) - 'a'];
        }
        if(Arrays.equals(cnt1,cnt2)){
            resList.add(0);
        }
        //此时cnt1和cnt2统计的区间都是宽度为len1的滑动窗口
        //下面继续计算s中[len1,len2) 维持数组对应的滑动窗口宽度为len1
        for(int i=len1;i<len2;i++){
            //滑动窗有进有出
            ++cnt1[s.charAt(i) - 'a'];
            --cnt1[s.charAt(i-len1) - 'a'];
            if (Arrays.equals(cnt1, cnt2)) {
                 resList.add(i-len1+1);  //记得加1 i-len1是被移除掉的元素 因此窗口的开始位置需要+1
            }
        }
        return resList;
    }
}
```






## 438. 找到字符串中所有字母异位词
### Description
* [LeetCode-438. 找到字符串中所有字母异位词](https://leetcode-cn.com/problems/find-all-anagrams-in-a-string/)

### Approach 2-滑动窗口
#### Analysis

参考 `leetcode-cn` 官方题解。


本题同 「剑指 Offer II 015. 字符串中的所有变位词」。


#### Solution


```json
class Solution {
    public List<Integer> findAnagrams(String s, String p) {
        List<Integer> resList = new ArrayList<>();
        int len1 = p.length();
        int len2 = s.length();
        if(len1 > len2){
            return resList;
        }
        int[] cnt1 = new int[26];
        int[] cnt2 = new int[26];

        //先计算s中[0,len1) 
        for(int i=0;i<len1;i++){
            ++cnt1[s.charAt(i) - 'a'];
            ++cnt2[p.charAt(i) - 'a'];
        }
        if(Arrays.equals(cnt1,cnt2)){
            resList.add(0);
        }
        //此时cnt1和cnt2统计的区间都是宽度为len1的滑动窗口
        //下面继续计算s中[len1,len2) 维持数组对应的滑动窗口宽度为len1
        for(int i=len1;i<len2;i++){
            //滑动窗有进有出
            ++cnt1[s.charAt(i) - 'a'];
            --cnt1[s.charAt(i-len1) - 'a'];
            if (Arrays.equals(cnt1, cnt2)) {
                 resList.add(i-len1+1);  //记得加1 i-len1是被移除掉的元素 因此窗口的开始位置需要+1
            }
        }
        return resList;
    }
}
```