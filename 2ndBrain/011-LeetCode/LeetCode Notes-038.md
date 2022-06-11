

# LeetCode Notes-038


[TOC]



## 更新
* 2021/07/06，撰写
* 2021/07/10，完成


## Overview
* [LeetCode-693. 交替位二进制数](https://leetcode-cn.com/problems/binary-number-with-alternating-bits/description/)
* [LeetCode-1385. 两个数组间的距离值](https://leetcode-cn.com/problems/find-the-distance-value-between-two-arrays/description/)
* [LeetCode-1200. 最小绝对差](https://leetcode-cn.com/problems/minimum-absolute-difference/description/)
* [LeetCode-205. 同构字符串](https://leetcode-cn.com/problems/isomorphic-strings/description/)
* [LeetCode-290. 单词规律](https://leetcode-cn.com/problems/word-pattern/description/)



## 693. 交替位二进制数
### Description
* [LeetCode-693. 交替位二进制数](https://leetcode-cn.com/problems/binary-number-with-alternating-bits/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public boolean hasAlternatingBits(int n) {
        boolean flag = true;
        int prev = n%2;
        int cur = 0;
        n = n/2;
        while(n > 0){
            cur = n%2;
            if(cur == prev){
                return false;
            }
            n = n/2;
            prev = cur;
        }
        return flag;

    }
}
```




## 1385. 两个数组间的距离值
### Description
* [LeetCode-1385. 两个数组间的距离值](https://leetcode-cn.com/problems/find-the-distance-value-between-two-arrays/description/)

### Approach 1-双重for循环
#### Analysis

参考 `leetcode-cn` 官方题解。




复杂度分析
* 假设 arr1 中元素个数为 n，arr2 中元素个数为 m。
* 时间复杂度：`O(n×m)`。
* 空间复杂度：`O(1)`。
#### Solution



```java
class Solution {
    public int findTheDistanceValue(int[] arr1, int[] arr2, int d) {
        int count = 0;
        boolean flag = true;
        for(int i=0;i<arr1.length;i++){
            flag = true;
            for(int j=0;j<arr2.length;j++){
                if(Math.abs(arr1[i]-arr2[j]) <= d){
                    flag = false;
                    continue;
                }
            }
            if(flag){
                count++;
            }
        }
        return count;
    }   
}
```



### Approach 2-二分查找
#### Analysis

参考 `leetcode-cn` 官方题解。

**要知道是否每一个 `y_j` 是不是满足 `|x_i - y_j| > d`，我们枚举了所有 `y_j`。实际上我们只要找到大于等于 `x_i` 的第一个 `y_j` 和小于 `x_i` 的第一个 `y_j` 即可。**


我们可以对 `arr2` 进行排序，然后对于 `arr1` 中的每个元素 `x_i` 在 `arr2` 中二分寻找上述的两个 `y_j`，如果这两个元素满足性质，则所有元素都满足性质，将答案增加 1。


复杂度分析
* 假设 arr1 中元素个数为 n，arr2 中元素个数为 m。
* 时间复杂度：`O((n+m)logm)`。给 `arr2` 排序的时间代价是 `O(mlogm)`，对于 `arr1` 中的每个元素都在 `arr2` 中二分的时间代价是 `O(nlogm)`，故渐进时间复杂度为 `O((n+m)logm)`。
* 空间复杂度：`O(1)`。


#### Solution

```java
class Solution {
    public int findTheDistanceValue(int[] arr1, int[] arr2, int d) {
        Arrays.sort(arr2);
        int cnt = 0;
        for (int x : arr1) {
            int p = binarySearch(arr2, x);
            boolean ok = true;
            if (p < arr2.length) {
                ok &= arr2[p] - x > d;
            }
            if (p - 1 >= 0 && p - 1 <= arr2.length) {
                ok &= x - arr2[p - 1] > d;
            }
            cnt += ok ? 1 : 0;
        }
        return cnt;
    }

    public int binarySearch(int[] arr,int target){
        int low = 0;
        int high = arr.length - 1;
        if(arr[high] < target){
            return high + 1; //数组本身升序排序 返回high+1 即arr.length 超过数组索引 用此表示查找不到元素
        }
        while(low < high){
            int mid = (high-low)/2 + low;
            if(arr[mid] < target){
                low = mid+1;
            } else{
                high = mid;
            }
        }
        return low;

    }
}
```






## 1200. 最小绝对差
### Description
* [LeetCode-1200. 最小绝对差](https://leetcode-cn.com/problems/minimum-absolute-difference/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public List<List<Integer>> minimumAbsDifference(int[] arr) {
        int length = arr.length;
        List<List<Integer>> list = new ArrayList<>();
        int minDistance = Integer.MAX_VALUE;
        Arrays.sort(arr);
        for(int i=1;i<length;i++){
            minDistance = Math.min(minDistance,arr[i]-arr[i-1]);
        }
        for(int i=1;i<length;i++){
            if(minDistance == arr[i]-arr[i-1]){
                list.add(Arrays.asList(arr[i-1],arr[i]));
            }
        }
        return list;

    }
}
```







## 205. 同构字符串
### Description
* [LeetCode-205. 同构字符串](https://leetcode-cn.com/problems/isomorphic-strings/description/)

### Approach 1-哈希表存储映射
#### Analysis

参考 `leetcode-cn` 官方题解。

本题同 [LeetCode-290. 单词规律](https://leetcode-cn.com/problems/word-pattern/description/)。


注意存储正向映射（s->t）和反向映射(t->s)。
#### Solution






```java
class Solution {
    public boolean isIsomorphic(String s, String t) {
        if(s.length() != t.length()){
            return false;
        }
        int length = s.length();
        int index = 0;
        Map<Character,Character> map = new HashMap<>();
        Map<Character,Character> reverseMap = new HashMap<>(); //反向映射
        while(index < length){
            char key = s.charAt(index);
            char val = t.charAt(index);
            if((map.containsKey(key) && val != map.get(key)) || (reverseMap.containsKey(val) && key != reverseMap.get(val))){
                return false;
            }
            map.put(key,val);
            reverseMap.put(val,key);
        
            index++;

        }
        return true;
    }
}
```


## 290. 单词规律
### Description
* [LeetCode-290. 单词规律](https://leetcode-cn.com/problems/word-pattern/description/)

### Approach 1-哈希表存储映射
#### Analysis

参考 `leetcode-cn` 官方题解。

本题同 [LeetCode-205. 同构字符串](https://leetcode-cn.com/problems/isomorphic-strings/description/)。


注意存储正向映射（s->t）和反向映射(t->s)。
#### Solution


```java
class Solution {
    public boolean wordPattern(String pattern, String s) {
        String[] arr = s.split(" ");
        int arrLength = arr.length;
        int patternLength = pattern.length();
        //  "aaa"    "aa aa aa aa"
        // 注意 二者长度必须相等 不相等可以直接返回false
        if(arrLength != patternLength){
            return false;
        }
        Map<Character, String> map = new HashMap<>();  //pattern -> s
        Map<String, Character> reverseMap = new HashMap<>();  // s-> pattern
        int index = 0;
        while(index < patternLength){
            char key = pattern.charAt(index);
            String val = arr[index];
            if((map.containsKey(key) && !map.get(key).equals(val)) || (reverseMap.containsKey(val) && reverseMap.get(val) != key)){
                return false;
            }
            map.put(key,val);
            reverseMap.put(val,key);
            index++;
        }
        return true;

    }
}
```



