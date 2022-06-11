
# LeetCode Notes-047


[TOC]



## 更新
* 2021/07/19，撰写
* 2021/07/22，完成


## Overview
* [LeetCode-1837. K进制表示下的各位数字总和](https://leetcode-cn.com/problems/sum-of-digits-in-base-k/)
* [LeetCode-658. 找到 K 个最接近的元素](https://leetcode-cn.com/problems/find-k-closest-elements/description/)
* [LeetCode-1876. 长度为三且各字符不同的子字符串](https://leetcode-cn.com/problems/substrings-of-size-three-with-distinct-characters/description/)
* [LeetCode-1848. 到目标元素的最小距离](https://leetcode-cn.com/problems/minimum-distance-to-the-target-element/description/)
* [LeetCode-1576. 替换所有的问号](https://leetcode-cn.com/problems/replace-all-s-to-avoid-consecutive-repeating-characters/description/)
 


## 【水题】1837. K 进制表示下的各位数字总和
### Description
* [LeetCode-1837. K进制表示下的各位数字总和](https://leetcode-cn.com/problems/sum-of-digits-in-base-k/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution



```java
class Solution {
    public int sumBase(int n, int k) {
        
        int sum = 0;
        while(n > 0){
            sum += (n%k);
            n = n/k;
        }
        return sum;

    }
}
```




## 658. 找到 K 个最接近的元素
### Description
* [LeetCode-658. 找到 K 个最接近的元素](https://leetcode-cn.com/problems/find-k-closest-elements/description/)


### Approach 1-双指针
#### Analysis

参考 `leetcode-cn` 官方题解。

* [双指针排除法题解](https://leetcode-cn.com/problems/find-k-closest-elements/solution/pai-chu-fa-shuang-zhi-zhen-er-fen-fa-python-dai-ma/)


#### Solution

```java
class Solution {
    public List<Integer> findClosestElements(int[] arr, int k, int x) {
        int size  = arr.length;
        int left = 0;
        int right = size -1;
        int removeNums = size - k;

        while(removeNums > 0){
            if(x-arr[left] <= arr[right]-x){
                //若距离相等 优先移除小元素
                right--;
            } else {
                left++;
            }
            removeNums--;
        }
        List<Integer> res = new ArrayList<>();
        for (int i = left; i < left + k; i++) {
            res.add(arr[i]);
        }
        return res;

    }
}
```








## 【水题】1876. 长度为三且各字符不同的子字符串
### Description
* [LeetCode-1876. 长度为三且各字符不同的子字符串](https://leetcode-cn.com/problems/substrings-of-size-three-with-distinct-characters/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int countGoodSubstrings(String s) {
        int count = 0;
        for(int i=2;i<s.length();i++){
            if(s.charAt(i) != s.charAt(i-1) && s.charAt(i) != s.charAt(i-2) && s.charAt(i-2) != s.charAt(i-1)){
                count++;
            }
        }
        return count;

    }
}
```





## 1848. 到目标元素的最小距离
### Description
* [LeetCode-1848. 到目标元素的最小距离](https://leetcode-cn.com/problems/minimum-distance-to-the-target-element/description/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public int getMinDistance(int[] nums, int target, int start) {
        int length = nums.length;

        if(start >= length){
            for(int i=length-1;i>=0;i--){
                if(nums[i] == target){
                    return Math.abs(i-start);
                }
            }
        } else if(start <=0){
            for(int i=0;i<length;i++){
                if(nums[i] == target){
                    return Math.abs(i-start);
                }
            }
        } else{
            if(nums[start] == target){
                return 0;
            }
            int left = start-1;
            int right = start+1;
            while(left >=0 || right < length){
                if(left >=0 && nums[left] == target){
                    return  Math.abs(left-start);
                }
                if(right < length && nums[right] == target){
                    return  Math.abs(right-start);
                }
                left--;
                right++;
            }
        }
        return -1;

    }
}
```



## 1576. 替换所有的问号
### Description
* [LeetCode-1576. 替换所有的问号](https://leetcode-cn.com/problems/replace-all-s-to-avoid-consecutive-repeating-characters/description/)
 

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public String modifyString(String s) {
        char[] chars = s.toCharArray();

        for (int i = 0; i < chars.length; i++) {
            if (chars[i] == '?') {
                //前面一个字符  如果当前是第0个的话 字符就为‘ ’
                char ahead = i == 0 ? ' ' : chars[i - 1];
                //后面一个字符  如果当前是最后一个的话 字符就为‘ ’
                char behind  = i == chars.length - 1 ? ' ' : chars[i + 1];
                //从a开始比较  如果等于前面或者后面的话 就+1
                char temp = 'a';
                while (temp == ahead || temp == behind ) {
                    temp++;
                }
                //找到目标字符后 做替换
                chars[i] = temp;
            }
        }
        return new String(chars);
    }
}
```


