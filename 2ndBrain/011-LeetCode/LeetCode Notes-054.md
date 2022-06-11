# LeetCode Notes-054


[TOC]



## 更新
* 2021/07/31，撰写
* 2021/07/31，撰写


## Overview
* [LeetCode-1380. 矩阵中的幸运数](https://leetcode-cn.com/problems/lucky-numbers-in-a-matrix/description/)
* [LeetCode-1394. 找出数组中的幸运数](https://leetcode-cn.com/problems/find-lucky-integer-in-an-array/description/)
* [LeetCode-1399. 统计最大组的数目](https://leetcode-cn.com/problems/count-largest-group/description/)
* [LeetCode-1784. 检查二进制字符串字段](https://leetcode-cn.com/problems/check-if-binary-string-has-at-most-one-segment-of-ones/description/)
* [LeetCode-1790. 仅执行一次字符串交换能否使两个字符串相等](https://leetcode-cn.com/problems/check-if-one-string-swap-can-make-strings-equal/description/)





## 1380. 矩阵中的幸运数
### Description
* [LeetCode-1380. 矩阵中的幸运数](https://leetcode-cn.com/problems/lucky-numbers-in-a-matrix/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public List<Integer> luckyNumbers (int[][] matrix) {
        List<Integer> list = new ArrayList<>();

        int m = matrix.length;
        int n = matrix[0].length;

        for(int i=0;i<m;i++){
            int rowMinIndex = findRowMinIndex(i,n,matrix);
            if(isColumnMax(i,rowMinIndex,m,matrix)){
                list.add(matrix[i][rowMinIndex]);
            }
        }
        return list;
    }

    //返回在同一行的最小元素的列坐标
    private int findRowMinIndex(int i,int n,int[][] matrix){
        int index = 0;
        int min = matrix[i][0];
        for(int j=1;j<n;j++){
            if(matrix[i][j] < min){ //所有元素不相等 不存在多个最小值
                min = matrix[i][j];
                index = j;
            }
        }
        return index;
    }

    //判断元素是否列的最大值
    private boolean isColumnMax(int i,int j,int len,int[][] matrix){
        for(int i0=0;i0<len;i0++){
            if(i0 != i && matrix[i0][j] > matrix[i][j]){
                return false;
            }
        }
        return true;
    }
}
```

## 1394. 找出数组中的幸运数
### Description
* [LeetCode-1394. 找出数组中的幸运数](https://leetcode-cn.com/problems/find-lucky-integer-in-an-array/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int findLucky(int[] arr) {
        int maxVal = -1;
        int len = arr.length;
        Map<Integer,Integer> map = new HashMap<>();
        for(int i=0;i<len;i++){
            map.put(arr[i],map.getOrDefault(arr[i], 0) + 1);
        }
        for(Map.Entry<Integer,Integer> entry:map.entrySet()){
            if(entry.getKey() == entry.getValue()){
                maxVal = Math.max(entry.getKey(),maxVal);
            }
        }
        return maxVal;
    }
}
```

## 1399. 统计最大组的数目
### Description
* [LeetCode-1399. 统计最大组的数目](https://leetcode-cn.com/problems/count-largest-group/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public int countLargestGroup(int n) {
        Map<Integer,Integer> map = new HashMap<>();
        int maxValue = 0;
        for(int i=1;i<=n;i++){
            int i0 = i;
            int key = 0;
            while(i0 > 0){
                key += i0%10;
                i0 /= 10;
            }
            map.put(key, 1 + map.getOrDefault(key, 0));
            maxValue = Math.max(maxValue,map.get(key));
        }
        int count = 0;
        for(Map.Entry<Integer,Integer> entry:map.entrySet()){
            if(entry.getValue() == maxValue){
                count++;
            }
        }
        return count;
    }
}
```

## 1784. 检查二进制字符串字段
### Description
* [LeetCode-1784. 检查二进制字符串字段](https://leetcode-cn.com/problems/check-if-binary-string-has-at-most-one-segment-of-ones/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public boolean checkOnesSegment(String s) {
        return !s.contains("01");
    }
}
```

## 1790. 仅执行一次字符串交换能否使两个字符串相等
### Description
* [LeetCode-1790. 仅执行一次字符串交换能否使两个字符串相等](https://leetcode-cn.com/problems/check-if-one-string-swap-can-make-strings-equal/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public boolean areAlmostEqual(String s1, String s2) {
        if(s1.equals(s2)){
            return true;
        }
        if(s1.length() != s2.length()){
            return false;
        }
        int count = 0;
        int index = -1; //第1处不一样的地方
        for(int i= 0;i<s1.length();i++){
            if(s1.charAt(i) != s2.charAt(i)){
                if(index != -1){ //已经有了1处不一样
                    if(s1.charAt(i) != s2.charAt(index) || s1.charAt(index) != s2.charAt(i)){
                        return false; 
                    }
                } else {
                    index = i;
                }
                count++;
            }
            if(count > 2){
                return false;
            }
        }
        return (count == 2);  //count=1 时只有1处不同 返回false
    }
}
```
