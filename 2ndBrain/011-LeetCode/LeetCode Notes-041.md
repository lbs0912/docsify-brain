# LeetCode Notes-041


[TOC]



## 更新
* 2021/07/19，撰写
* 2021/07/22，完成


## Overview
* [LeetCode-908. 最小差值 I](https://leetcode-cn.com/problems/smallest-range-i/description/)
* [LeetCode-910. 最小差值 II](https://leetcode-cn.com/problems/smallest-range-ii/description/)
* [LeetCode-387. 字符串中的第一个唯一字符](https://leetcode-cn.com/problems/first-unique-character-in-a-string/description/)
* [LeetCode-459. 重复的子字符串](https://leetcode-cn.com/problems/repeated-substring-pattern/description/)
* [LeetCode-821. 字符的最短距离](https://leetcode-cn.com/problems/shortest-distance-to-a-character/description/)




## 908. 最小差值 I

### Description
* [LeetCode-908. 最小差值 I](https://leetcode-cn.com/problems/smallest-range-i/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

先计算出原始数组的 `max-min`，则修改后的数组的最小差值为
1. (max-min) > 2*k，则返回 max-min-2*k
2. (max-min) <= 2*k，则返回0

#### Solution


```java
class Solution {
    public int smallestRangeI(int[] nums, int k) {
        Arrays.sort(nums);
        int max = nums[nums.length-1];
        int min = nums[0];
        return (max-min) > 2*k ? max-min-2*k:0;

    }
}
```



## 910. 最小差值 II
### Description
* [LeetCode-910. 最小差值 II](https://leetcode-cn.com/problems/smallest-range-ii/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/leetcode/leetcode-910-1.png)


#### Solution


```java
class Solution {
    public int smallestRangeII(int[] nums, int k) {
        int length = nums.length;
        Arrays.sort(nums);
        int oldMax = nums[length-1];
        int oldMin = nums[0];
        int distance = nums[length-1] - nums[0];

        //遍历分隔点
        for(int i=0;i<length-1;i++){
            int max = Math.max(nums[i]+k,oldMax-k);
            int min = Math.min(nums[0]+k,nums[i+1]-k);
            distance = Math.min(distance,max-min);
        }

        return distance;
    }
}

```



## 387. 字符串中的第一个唯一字符
### Description
* [LeetCode-387. 字符串中的第一个唯一字符](https://leetcode-cn.com/problems/first-unique-character-in-a-string/description/)

### Approach 1-哈希表
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int firstUniqChar(String s) {
        int length = s.length();
        if(length <= 0){
            return 0;
        }
        int res = length;
        boolean hasSingle = false;
        //哈希表 List<Integer> 中第0个元素表示字符出现的次数，第1个元素表示该字符第一次出现的索引位置
        Map<Character,List<Integer>> map = new HashMap<>();  
        for(int i=0;i<length;i++){
            char c = s.charAt(i);
            List<Integer> list;
            if(map.containsKey(c)){
                list = map.get(c);
                list.set(0,list.get(0)+1);
            } else{
                list = new ArrayList<>();
                list.add(1);
                list.add(i);
            }
            map.put(c,list);
        }
        for(Map.Entry<Character,List<Integer>> entry:map.entrySet()){
            List<Integer> list = entry.getValue();
            if(list.get(0) == 1){
                res = Math.min(res, list.get(1));
                hasSingle = true;
            }

        }
        return hasSingle? res:-1;

    }
}
```








## 459. 重复的子字符串
### Description
* [LeetCode-459. 重复的子字符串](https://leetcode-cn.com/problems/repeated-substring-pattern/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(n^2)`，其中 `n` 是字符串 `s` 的长度。
* 空间复杂度：`O(1)`。

#### Solution

```java
class Solution {
    public boolean repeatedSubstringPattern(String s) {
        int n = s.length();
        //枚举字符串的长度i 从1到n/2 因为子串至少重复出现2次
        for(int i=1;(i*2) <=n;i++){
            if(n % i != 0){ //总长度需为子串的整数倍
                continue;
            }
            boolean match = true;
            for(int j=i;j<n;j++){
                if(s.charAt(j) != s.charAt(j-i)){
                    match = false;
                    break;
                }
            }
            if(match){
                return true;
            }
        }
        return false;
    }
}
```

### Approach 2-字符串匹配
#### Analysis

参考 `leetcode-cn` 官方题解。

仔细体会。

#### Solution

```java
class Solution {
    public boolean repeatedSubstringPattern(String s) {
        return (s + s).indexOf(s, 1) != s.length();
    }
}
```




## 821. 字符的最短距离
### Description
* [LeetCode-821. 字符的最短距离](https://leetcode-cn.com/problems/shortest-distance-to-a-character/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution




```java
class Solution {
    public int[] shortestToChar(String s, char c) {
        int length = s.length();
        int[] arr = new int[length];
        List<Integer> list = new ArrayList<>();
        for(int i=0;i<length;i++){
            if(c == s.charAt(i)){
                list.add(i);
            }
        }
        for(int i=0;i<length;i++){
            char ele = s.charAt(i);
            arr[i] = search(i,list);
        }
        return arr;
    }

    private int search(int index,List<Integer> list){

        int size = list.size();
        if(list.get(0) >= index){
            return list.get(0) - index;
        } 
        if(list.get(size-1) <= index){
            return index - list.get(size-1);
        }
        for(int i=0;i<list.size();i++){
            if(list.get(i) >= index){
                return Math.min(Math.abs(list.get(i) - index),Math.abs(list.get(i-1)-index));
            }
        }
        return 0;
    }
}
```