
# LeetCode Notes-050


[TOC]



## 更新
* 2021/07/23，撰写
* 2021/07/23，完成


## Overview
* [LeetCode-1720. 解码异或后的数组](https://leetcode-cn.com/problems/decode-xored-array/)
* [LeetCode-832. 翻转图像](https://leetcode-cn.com/problems/flipping-an-image/)
* [LeetCode-1299. 将每个元素替换为右侧最大元素](https://leetcode-cn.com/problems/replace-elements-with-greatest-element-on-right-side/)
* [LeetCode-1725. 可以形成最大正方形的矩形数目](https://leetcode-cn.com/problems/number-of-rectangles-that-can-form-the-largest-square/)
* [LeetCode-1732. 找到最高海拔](https://leetcode-cn.com/problems/number-of-students-doing-homework-at-a-given-time/)



## 1720. 解码异或后的数组
### Description
* [LeetCode-1720. 解码异或后的数组](https://leetcode-cn.com/problems/decode-xored-array/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public int[] decode(int[] encoded, int first) {
        int length = encoded.length;
        int[] arr = new int[length+1];
        arr[0] = first;
        for(int i=1;i<length+1;i++){
            arr[i] = arr[i-1] ^ encoded[i-1];
        }
        return arr;
    }
}
```



## 832. 翻转图像
### Description
* [LeetCode-832. 翻转图像](https://leetcode-cn.com/problems/flipping-an-image/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution

```
class Solution {
    public int[][] flipAndInvertImage(int[][] image) {
        int m = image.length;
        for(int i=0;i<m;i++){
            int n = image[i].length;
            for(int j=0;j<(n+1)/2;j++){
                int temp = image[i][j];
                image[i][j] = 1^ image[i][n-1-j];//异或
                image[i][n-1-j] = 1^ temp;
            }
        }
        return image;
    }
}
```




## 1299. 将每个元素替换为右侧最大元素
### Description
* [LeetCode-1299. 将每个元素替换为右侧最大元素](https://leetcode-cn.com/problems/replace-elements-with-greatest-element-on-right-side/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public int[] replaceElements(int[] arr) {
        int length = arr.length;
        int[] ans = new int[length];
        ans[length-1] = -1;
        int max = arr[length-1];
        for(int i=length-2;i>=0;i--){
           int temp = arr[i];
           ans[i] = max;
           max = Math.max(max,temp);
        }
        return ans;
    }
}
```


## 【水题】1725. 可以形成最大正方形的矩形数目
### Description
* [LeetCode-1725. 可以形成最大正方形的矩形数目](https://leetcode-cn.com/problems/number-of-rectangles-that-can-form-the-largest-square/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution



```java
class Solution {
    public int countGoodRectangles(int[][] rectangles) {
        int max = 0;
        int length = rectangles.length;
        int[] arr = new int[length];
        for(int i=0;i<length;i++){
            arr[i] = Math.min(rectangles[i][0],rectangles[i][1]);
            max = Math.max(max,arr[i]);
        }
        int count = 0;
        for(int i=0;i<length;i++){
            if(max == arr[i]){
                count++;
            }
        }
        return count;

    }
}
```



## 【水题】1732. 找到最高海拔
### Description
* [LeetCode-1732. 找到最高海拔](https://leetcode-cn.com/problems/number-of-students-doing-homework-at-a-given-time/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution





```java
class Solution {
    public int largestAltitude(int[] gain) {
        int max = 0;
        int val = 0;
        for(int i=0;i<gain.length;i++){
            val += gain[i];
            max = Math.max(max,val);
        }
        return max;

    }
}
```
