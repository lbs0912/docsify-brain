
# LeetCode Notes-073


[TOC]



## 更新
* 2021/12/16，撰写
* 2021/12/19，完成



## Overview
* 【水题】[LeetCode-2057. 值相等的最小索引](https://leetcode-cn.com/problems/smallest-index-with-equal-value/)
* [LeetCode-2022. 将一维数组转变成二维数组](https://leetcode-cn.com/problems/convert-1d-array-into-2d-array/)
* [LeetCode-2016. 增量元素之间的最大差值](https://leetcode-cn.com/problems/maximum-difference-between-increasing-elements/)
* 【经典好题】[LeetCode-221. 最大正方形](https://leetcode-cn.com/problems/maximal-square/)
* 【经典好题】[LeetCode-1277. 统计全为 1 的正方形子矩阵](https://leetcode-cn.com/problems/count-square-submatrices-with-all-ones/)



## 【水题】2057. 值相等的最小索引
### Description
* 【水题】[LeetCode-2057. 值相等的最小索引](https://leetcode-cn.com/problems/smallest-index-with-equal-value/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int smallestEqual(int[] nums) {
        for(int i=0;i<nums.length;i++){
            if(i%10 == nums[i]){
                return i;
            }
        }
        return -1;
    }
}
```



## 2022. 将一维数组转变成二维数组
### Description
* [LeetCode-2022. 将一维数组转变成二维数组](https://leetcode-cn.com/problems/convert-1d-array-into-2d-array/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int[][] construct2DArray(int[] original, int m, int n) {
        int totalCount = original.length;
        if(m*n != totalCount){
            return new int[0][0];
        }
        int[][] arr = new int[m][n];
        int row = 0;
        int column = 0;
        for(int i=0;i<totalCount;i++){
            row = i / n;
            column = i % n;
            arr[row][column] = original[i];
        }
        return arr;
    }
}
```




## 2016. 增量元素之间的最大差值
### Description
* [LeetCode-2016. 增量元素之间的最大差值](https://leetcode-cn.com/problems/maximum-difference-between-increasing-elements/)

### Approach 1-暴力
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int maximumDifference(int[] nums) {
        int  diff = -1;
        for(int i=0,len=nums.length;i<len-1;i++){
            for(int j=i+1;j<len;j++){
                if(nums[j] > nums[i]){
                    diff = Math.max(nums[j]-nums[i],diff);
                }
            }
        }
        return diff;
    }
}
```

### Approach 2-一次遍历
#### Analysis

参考 `leetcode-cn` 官方题解。


维护数组的最小值，一次遍历数组。


#### Solution

```java
class Solution {
    public int maximumDifference(int[] nums) {
        int min = nums[0];
        int diff = -1;
        for(int i=0,len=nums.length;i<len;i++){
            min = Math.min(min,nums[i]);
            if(nums[i] > min){
                diff = Math.max(diff,nums[i]-min);
            } 
        }
        return diff;
    }
}
```




## 【经典好题】221. 最大正方形
### Description
* 【经典好题】[LeetCode-221. 最大正方形](https://leetcode-cn.com/problems/maximal-square/)

### Approach 1-暴力
#### Analysis

参考 `leetcode-cn` 官方题解。


1. 遍历矩阵中的每个元素，每次遇到 1，则将该元素作为正方形的左上角；
2. 确定正方形的左上角后，根据左上角所在的行和列计算可能的最大正方形的边长（正方形的范围不能超出矩阵的行数和列数），在该边长范围内寻找只包含 11 的最大正方形；
3. 每次在下方新增一行以及在右方新增一列，判断新增的行和列是否满足所有元素都是 1。

#### Solution


```java
class Solution {
    public int maximalSquare(char[][] matrix) {
        int maxSide = 0; //最大的边长
        if(null == matrix || matrix.length == 0 || matrix[0].length == 0){
            return 0;
        }
        int rows = matrix.length;
        int columns = matrix[0].length;

        for(int i=0;i<rows;i++){
            for(int j=0;j<columns;j++){
                //遇到一个 1 作为正方形的左上角
                if ('1' == matrix[i][j]) {
                    maxSide = Math.max(maxSide, 1);  //如果遇到了元素1  表示maxSize至少为1  [["0","1"],["1","0"]]
                    // 计算可能的最大正方形边长
                    int currentMaxSide = Math.min(rows-i,columns-j);
                    for(int k=1;k<currentMaxSide;k++){
                        // 判断新增的一行一列是否均为 1
                        boolean flag = true;
                        //先判断对角线元素是否为1
                        if (matrix[i + k][j + k] == '0') {
                            break;
                        }
                        for (int m = 0; m < k; m++) {
                            if (matrix[i + k][j + m] == '0' || matrix[i + m][j + k] == '0') {
                                flag = false;
                                break;
                            }
                        }
                        if (flag) {
                            maxSide = Math.max(maxSide, k + 1);
                        } else {
                            break;
                        }
                    }
                }
            }
        }
        return maxSide * maxSide;
    }
}
```



### Approach 2-动态规划
#### Analysis

参考 `leetcode-cn` 官方题解。


使用 `dp(i,j)` 表示以 `(i,j)` 为右下角，且只包含 1 的正方形的边长最大值。

1. 如果该位置的值是 0，则 `dp(i,j)=0`，因为当前位置不可能在由 1 组成的正方形中；
2. 如果该位置的值是 1，则 `dp(i,j)` 的值由其上方、左方和左上方的三个相邻位置的 \textit{dp}dp 值决定。具体而言，当前位置的元素值等于三个相邻位置的元素中的最小值加 1

```math
dp(i, j)=min(dp(i−1, j), dp(i−1, j−1), dp(i, j−1))+1
```


#### Solution

```java
class Solution {
    public int maximalSquare(char[][] matrix) {
        int maxSide = 0;
        if (matrix == null || matrix.length == 0 || matrix[0].length == 0) {
            return maxSide;
        }
        int rows = matrix.length, columns = matrix[0].length;
        int[][] dp = new int[rows][columns];
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < columns; j++) {
                if (matrix[i][j] == '1') {
                    if (i == 0 || j == 0) {
                        dp[i][j] = 1;
                    } else {
                        dp[i][j] = Math.min(Math.min(dp[i - 1][j], dp[i][j - 1]), dp[i - 1][j - 1]) + 1;
                    }
                    maxSide = Math.max(maxSide, dp[i][j]);
                }
            }
        }
        return maxSide * maxSide;
    }
}
```

## 【经典好题】1277. 统计全为 1 的正方形子矩阵
### Description
* 【经典好题】[LeetCode-1277. 统计全为 1 的正方形子矩阵](https://leetcode-cn.com/problems/count-square-submatrices-with-all-ones/)

### Approach 1-动态规划

#### Analysis


参考 `leetcode-cn` 官方题解。

本题同「[LeetCode-221. 最大正方形](https://leetcode-cn.com/problems/maximal-square/)」。


#### Solution




```java
class Solution {
    public int countSquares(int[][] matrix) {
        int count = 0;
        if (matrix == null || matrix.length == 0 || matrix[0].length == 0) {
            return 0;
        }
        int rows = matrix.length;
        int columns = matrix[0].length;
        int[][] dp = new int[rows][columns];

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < columns; j++) {
                if (matrix[i][j] == 1) {
                    if (i == 0 || j == 0) {
                        dp[i][j] = 1;
                    } else {
                        dp[i][j] = Math.min(Math.min(dp[i - 1][j], dp[i][j - 1]), dp[i - 1][j - 1]) + 1;
                    }
                }
                count += dp[i][j];
            }
        }
        return count;
    }
}
```