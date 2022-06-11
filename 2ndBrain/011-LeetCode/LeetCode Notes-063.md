
# LeetCode Notes-063


[TOC]



## 更新
* 2021/08/18，撰写
* 2021/08/22，撰写



## Overview
* [LeetCode-389. 找不同](https://leetcode-cn.com/problems/find-the-difference/description/)
* [LeetCode-389. 找不同](https://leetcode-cn.com/problems/find-the-difference/description/)
* [LeetCode-242. 有效的字母异位词](https://leetcode-cn.com/problems/valid-anagram/description/)
* [LeetCode-263. 丑数](https://leetcode-cn.com/problems/ugly-number/description/)
* [LeetCode-1763. 最长的美好子字符串](https://leetcode-cn.com/problems/longest-nice-substring/description/)


## 【水题】1051. 高度检查器
### Description
* [LeetCode-1051. 高度检查器](https://leetcode-cn.com/problems/height-checker/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int heightChecker(int[] heights) {
        int count = 0;
        int[] expected = heights.clone();  //数组拷贝 若不影响原数组 不能直接赋值 要使用clone
        Arrays.sort(expected);
        for(int i=0;i<expected.length;i++){
            if(expected[i] != heights[i]){
                count++;
            }
        }
        return count;

    }
}
```




## 389. 找不同
### Description
* [LeetCode-389. 找不同](https://leetcode-cn.com/problems/find-the-difference/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public char findTheDifference(String s, String t) {
        Map<Character,Integer> map = new HashMap<>();
        for(int i=0;i<s.length();i++){
            char c = s.charAt(i);
            map.put(c,1+ map.getOrDefault(c, 0));
        }
        for(int i=0;i<t.length();i++){
            char c = t.charAt(i);
            if(!map.containsKey(c)){
                return c;
            }
            map.put(c,map.get(c)-1);
        }
        for(Map.Entry<Character,Integer> entry:map.entrySet()){
            if(entry.getValue() < 0){
                return entry.getKey();
            }
        }

        return s.charAt(0);

    }
}
```

### Approach 2-ASCII
#### Analysis

参考 `leetcode-cn` 官方题解。


将字符串的ASCII累加，最后作差。
#### Solution



```java
class Solution {
    public char findTheDifference(String s, String t) {
        int as = 0, at = 0;
        for (int i = 0; i < s.length(); ++i) {
            as += s.charAt(i);
        }
        for (int i = 0; i < t.length(); ++i) {
            at += t.charAt(i);
        }
        return (char) (at - as);
    }
}
```



### Approach 3-异或
#### Analysis

参考 `leetcode-cn` 官方题解。

将两个字符串拼接成一个字符串，则问题转换成求字符串中出现奇数次的字符。类似于 *「136. 只出现一次的数字」*，我们使用位运算的技巧——异或，解决本题。 


#### Solution


```java
class Solution {
    public char findTheDifference(String s, String t) {
        int ret = 0;
        for (int i = 0; i < s.length(); ++i) {
            ret ^= s.charAt(i);
        }
        for (int i = 0; i < t.length(); ++i) {
            ret ^= t.charAt(i);
        }
        return (char) ret;

    }
}
```



## 242. 有效的字母异位词
### Description
* [LeetCode-242. 有效的字母异位词](https://leetcode-cn.com/problems/valid-anagram/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public boolean isAnagram(String s, String t) {
        if(s.length() != t.length()){
            return false;
        }
        Map<Character,Integer> map = new HashMap<>();
        for(int i=0;i<s.length();i++){
            char c = s.charAt(i);
            map.put(c,1+ map.getOrDefault(c, 0));
        }
        for(int i=0;i<t.length();i++){
            char c = t.charAt(i);
            if(!map.containsKey(c)){
                return false;
            }
            map.put(c,map.get(c)-1);
            
        }
        for(Map.Entry<Character,Integer> entry:map.entrySet()){
            if(entry.getValue() != 0){
                return false;
            }
        }
        return true;
    }
}
```


## 263. 丑数
### Description
* [LeetCode-263. 丑数](https://leetcode-cn.com/problems/ugly-number/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


根据丑数的定义，**0 和负整数一定不是丑数**（负数有因数-1）。

当 n>0 时，若 n 是丑数，则 nn 可以写成 `n = 2^a * 3^b * 5^c` 的形式，其中 a,b,c 都是非负整数。

需要明确的是，**因数 2，3，5 的顺序并不影响判断结果**。因此，代码实现时，采用如下形式。


```java
int[] factors = {2, 3, 5};
for (int factor : factors) {
    while (n % factor == 0) {
        n /= factor;
    }
}
```


#### Solution



```java
class Solution {
    public boolean isUgly(int n) {
        if (n <= 0) {
            return false;
        }
        int[] factors = {2, 3, 5};
        for (int factor : factors) {
            while (n % factor == 0) {
                n /= factor;
            }
        }
        return n == 1;
    }
}
```



## 1763. 最长的美好子字符串
### Description
* [LeetCode-1763. 最长的美好子字符串](https://leetcode-cn.com/problems/longest-nice-substring/description/)


### Approach 1-滑动窗口+O(n^2)
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public String longestNiceSubstring(String s) {
        int n = s.length();
        if(n < 2){
            return "";
        }
        String ans = "";
        // len 滑动窗口的长度
        for(int len = 2;len<=n;len++){
            // i 滑动窗口起始位置
            for(int i=0;i+len-1<n;i++){
                String subStr = s.substring(i,i+len);
                //记录最长的美好的子串
                if(subStr.length() > ans.length() && isNicety(subStr)){
                    ans = subStr;
                }
            }
        }
        return ans;
    }

    private boolean isNicety(String s){
        HashSet<Character> upperSet = new HashSet<>();
        HashSet<Character> lowerSet = new HashSet<>();

        for (char ch : s.toCharArray()) {
            if (Character.isUpperCase(ch)) {
                upperSet.add(ch);
            } else {
                lowerSet.add(Character.toUpperCase(ch));
            }
        }
        if (upperSet.size() != lowerSet.size()) {
            return false;
        }
    
        upperSet.removeAll(lowerSet);  //removeAll判断
        return upperSet.size() == 0;

    }
}
```
