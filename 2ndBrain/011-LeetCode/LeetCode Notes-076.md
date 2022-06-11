
# LeetCode Notes-076


[TOC]



## 更新
* 2021/12/24，撰写
* 2021/12/25，完成



## Overview
* [LeetCode-2053. 数组中第 K 个独一无二的字符串](https://leetcode-cn.com/problems/kth-distinct-string-in-an-array/description/)
* [LeetCode-2018. 找出数组中的第一个回文字符串](https://leetcode-cn.com/problems/find-first-palindromic-string-in-the-array/description)
* [LeetCode-2099. 找到和最大的长度为 K 的子序列](https://leetcode-cn.com/problems/find-subsequence-of-length-k-with-the-largest-sum/description/)
* 【水题】[LeetCode-2089. 找出数组排序后的目标下标](https://leetcode-cn.com/problems/find-target-indices-after-sorting-array/description)
* [LeetCode-2085. 统计出现过一次的公共字符串](https://leetcode-cn.com/problems/count-common-words-with-one-occurrence/description/)


## 2053. 数组中第 K 个独一无二的字符串
### Description
* [LeetCode-2053. 数组中第 K 个独一无二的字符串](https://leetcode-cn.com/problems/kth-distinct-string-in-an-array/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public String kthDistinct(String[] arr, int k) {
        Map<String,Integer> map = new HashMap<>();
        for(String str:arr){
            map.put(str,1+map.getOrDefault(str, 0));
        }
        int count = 0;
        for(String str:arr){
            if(1 == map.get(str)){
                if(count == k-1){
                    return str;
                } else {
                    count++;
                }
            }
        }
        return "";

    }
}
```



## 2018. 找出数组中的第一个回文字符串
### Description
* [LeetCode-2018. 找出数组中的第一个回文字符串](https://leetcode-cn.com/problems/find-first-palindromic-string-in-the-array/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution

```java
class Solution {
    public String firstPalindrome(String[] words) {
        for(String str:words){
            if(isPalindromicStr(str)){
                return str;
            }
        }
        return "";
    }

    private boolean isPalindromicStr(String str){
        int begin = 0;
        int end = str.length() -1;
        while(begin < end){
            if(str.charAt(begin++) != str.charAt(end--)){
                return false;
            }
        }
        return begin >= end;
    }
}
```



## 2099. 找到和最大的长度为 K 的子序列
### Description
* [LeetCode-2099. 找到和最大的长度为 K 的子序列](https://leetcode-cn.com/problems/find-subsequence-of-length-k-with-the-largest-sum/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution

```java
class Solution{
    public int[] maxSubsequence(int[] nums, int k) {
        int len = nums.length;
        int[][] pairArr = new int[len][2];
        for(int i=0;i<len;i++){
            pairArr[i] = new int[]{nums[i],i};
        }
        //按照数组值升序排序  若数组值相同 按照索引从小到大排序
        Arrays.sort(pairArr,((o1, o2) -> o1[0] == o2[0] ? o1[1] - o2[1] : o1[0] - o2[0]));
        int[][] resPairArr = new int[k][2];
        for(int i=0;i<k;i++){
            resPairArr[i] = pairArr[len-1-i];
        }
        //按照索引升序排序
        Arrays.sort(resPairArr,((o1,o2) -> o1[1] - o2[1]));   
        int[] arr = new int[k];
        for(int i=0;i<k;i++){
            arr[i] = resPairArr[i][0];
        }
        return arr;
    }
}
```





## 【水题】2089. 找出数组排序后的目标下标
### Description
* 【水题】[LeetCode-2089. 找出数组排序后的目标下标](https://leetcode-cn.com/problems/find-target-indices-after-sorting-array/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public List<Integer> targetIndices(int[] nums, int target) {
        Arrays.sort(nums);
        List<Integer> list = new ArrayList<>();
        for(int i=0;i<nums.length;i++){
            if(nums[i] == target){
                list.add(i);
            }
        }
        return list;

    }
}
```


采用二分查找


```java
class Solution {
    public List<Integer> targetIndices(int[] nums, int target) {
        Arrays.sort(nums);
        List<Integer> list = new ArrayList<>();
        int low = 0;
        int high = nums.length -1;
        int mid = 0;
        while(low <= high){
            mid = low + (high - low) /2;
            if(nums[mid] == target){
                break;
            } else if(nums[mid] > target){

                high = mid-1;
            } else {
                low = mid + 1;
            }
        }
        if(nums[mid] == target){
            list.add(mid);
            for(int i=mid-1;i>=0;i--){
                if(nums[i] == target){
                    list.add(0,i);
                }
            }
            for(int i=mid+1;i<nums.length;i++){
                if(nums[i] == target){
                    list.add(i);
                }
            }
        }

        return list;
    }
}
```



## 2085. 统计出现过一次的公共字符串
### Description
* [LeetCode-2085. 统计出现过一次的公共字符串](https://leetcode-cn.com/problems/count-common-words-with-one-occurrence/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public int countWords(String[] words1, String[] words2) {
        Map<String,Integer> map1 = new HashMap<>();
        Map<String,Integer> map2 = new HashMap<>();
        int count = 0;
        for(String str:words1){
            map1.put(str, 1+map1.getOrDefault(str, 0));
        }
        for(String str:words2){
            map2.put(str, 1+map2.getOrDefault(str, 0));
        }
        for(Map.Entry<String,Integer> entry:map1.entrySet()){
            String key = entry.getKey();
            Integer value = entry.getValue();
            if(1 == value && map2.containsKey(key) && 1 == map2.get(key)){
                count++;
            }
        }
        return count;
    }
}
```