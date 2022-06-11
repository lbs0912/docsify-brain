
# LeetCode Notes-048


[TOC]



## 更新
* 2021/07/23，撰写
* 2021/07/23，完成


## Overview
* [LeetCode-128. 最长连续序列](https://leetcode-cn.com/problems/longest-consecutive-sequence/description/)
* [LeetCode-1859. 将句子排序](https://leetcode-cn.com/problems/sorting-the-sentence/)
* [LeetCode-1863. 找出所有子集的异或总和再求和](https://leetcode-cn.com/problems/sum-of-all-subset-xor-totals/)
* [LeetCode-48. 旋转图像](https://leetcode-cn.com/problems/rotate-image/)
* [LeetCode-1886. 判断矩阵经轮转后是否一致](https://leetcode-cn.com/problems/determine-whether-matrix-can-be-obtained-by-rotation/solution/)




## 128. 最长连续序列
### Description
* [LeetCode-128. 最长连续序列](https://leetcode-cn.com/problems/longest-consecutive-sequence/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

先对数组排序，后 `O(n)` 遍历数组。虽然可AC，但不满足题目要求的 `O(n)` 算法，此处仅做记录。

#### Solution


```java
class Solution {
    public int longestConsecutive(int[] nums) {
        int max = 0;
        if(nums.length == 0){
            return 0;
        }
        Arrays.sort(nums);

        int count = 1;
        for(int i=1;i<nums.length;i++){
            //[0 1 1 2]  //针对重复元素的处理
            if(nums[i] == nums[i-1]){
                continue;
            }
            if(nums[i] == nums[i-1] + 1){
                count++;
            } else{
                max = Math.max(max,count);
                count = 1;
            }
        }
        //若数组一直递增，则上述循环中 else 分支没有执行
        //因此最后输出时需要再判断下 Math.max(max,count)
        //eg [1 2 3 4]
        return Math.max(max,count);
    }
}
```


### Approach 2-哈希表
#### Analysis

参考 `leetcode-cn` 官方题解。

注意代码的优化思路，


```java
//只针对 num-1 不在集合中的元素判断
//因为 [x,y]的长度 一定小于 [x-1,y]的长度
if (!num_set.contains(num - 1)) {
    ...
}
```

#### Solution


```java
class Solution {
    public int longestConsecutive(int[] nums) {
        Set<Integer> num_set = new HashSet<Integer>();
        for (int num : nums) {
            num_set.add(num);
        }

        int longestStreak = 0;

        for (int num : num_set) {
            //只针对 num-1 不在集合中的元素判断
            //因为 [x,y]的长度 一定小于 [x-1,y]的长度
            if (!num_set.contains(num - 1)) {
                int currentNum = num;
                int currentStreak = 1;
                //从x向x+1,x+2 逐个寻找 
                while (num_set.contains(currentNum + 1)) {
                    currentNum += 1;
                    currentStreak += 1;
                }

                longestStreak = Math.max(longestStreak, currentStreak);
            }
        }

        return longestStreak;
    }
}

```





## 1859. 将句子排序
### Description
* [LeetCode-1859. 将句子排序](https://leetcode-cn.com/problems/sorting-the-sentence/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public String sortSentence(String s) {
        StringBuilder sb = new StringBuilder();
        String[] arr = s.split(" ");
        int length = arr.length;
        String[] list = new String[length];
        for(int i = 0;i<length;i++){
            int size = arr[i].length();
            int index =  Integer.parseInt(arr[i].substring(size-1));
            list[index-1] = arr[i].substring(0,size-1);
        }
        for(int i=0;i<length-1;i++){
            sb.append(list[i]);
            sb.append(" ");
        }
        sb.append(list[length-1]);
        return sb.toString();
    }
}
```





## 1863. 找出所有子集的异或总和再求和
### Description
* [LeetCode-1863. 找出所有子集的异或总和再求和](https://leetcode-cn.com/problems/sum-of-all-subset-xor-totals/)


### Approach 1-递归法枚举子集
#### Analysis

参考 `leetcode-cn` 官方题解。




我们用函数 `dfs(val,index,nums)` 来递归枚举数组 `nums` 的子集。其中 `val` 代表当前选取部分的异或值，`index` 代表递归的当前位置。

我们用 `length` 来表示 nums 的长度。在进入 `dfs(val,index,nums)` 时，数组中 `[0,index−1]` 部分的选取情况是已经确定的，而 `[idx,length)` 部分的选取情况还未确定。我们需要确定 `index` 位置的选取情况，然后求解子问题 `dfs(val’,index+1)`。

此时选取情况有两种
1. 选取 `nums[index]`，此时 `val' =  val XOR nums[index]`
2. 不选取 `nums[index]`，此时 `val’ = val`

当 `index = length` 时，递归结束。




#### Solution



```java
class Solution {
    private int length;
    private int res;

    public int subsetXORSum(int[] nums) {
        res = 0;
        length = nums.length;
        dfs(0,0,nums);
        return res;
    }
    private void dfs(int val,int index,int[] nums){
        //终止递归
        if(index == length){
            res += val;
            return;
        }
        // 考虑选择当前数字
        dfs(val ^ nums[index], index + 1, nums);
        // 考虑不选择当前数字
        dfs(val, index + 1, nums);

    }
}

```




## 48. 旋转图像
### Description
* [LeetCode-48. 旋转图像](https://leetcode-cn.com/problems/rotate-image/)


### Approach 1-暴力-非原地
#### Analysis

参考 `leetcode-cn` 官方题解。



**对于矩阵中第 `i` 行的第 `j` 个元素，在旋转后，它出现在倒数第 `i` 列的第 `j` 个位置。数学公式可表达为**



```java
arr[i][j] -> arr[j][n−1-i]
```




复杂度分析
* 时间复杂度：`O(N^2)`
* 空间复杂度：`O(N^2)`


#### Solution

```java
class Solution {
    public void rotate(int[][] matrix) {
        int n = matrix.length;
        int[][] matrix_new = new int[n][n];
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                matrix_new[j][n - i - 1] = matrix[i][j];
            }
        }
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                matrix[i][j] = matrix_new[i][j];
            }
        }
    }
}
```

### Approach 2-原地求解

#### Analysis

参考 `leetcode-cn` 官方题解。



在方法1的基础上进一步优化。


**对于矩阵中第 `i` 行的第 `j` 个元素，在旋转后，它出现在倒数第 `i` 列的第 `j` 个位置。数学公式可表达为**



```java
arr[i][j] -> arr[j][n−1-i]
```

现在考虑原数组中 `arr[j][n-1-i]` 的元素，在旋转后被放置在了哪里？

如下图所示，每旋转一次，四个元素会形成一次循环。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/leetcode/leetcode-48-rotate-1.png)








复杂度分析
* 时间复杂度：`O(N^2)`
* 空间复杂度：`O(1)`


#### Solution

```java
class Solution {
    public void rotate(int[][] matrix) {
        int n = matrix.length;
        for (int i = 0; i < n / 2; ++i) {
            for (int j = 0; j < (n + 1) / 2; ++j) {
                int temp = matrix[i][j];
                matrix[i][j] = matrix[n - j - 1][i];
                matrix[n - j - 1][i] = matrix[n - i - 1][n - j - 1];
                matrix[n - i - 1][n - j - 1] = matrix[j][n - i - 1];
                matrix[j][n - i - 1] = temp;
            }
        }
    }
}
```





### Approach 3-用翻转代替旋转

#### Analysis

参考 `leetcode-cn` 官方题解。




复杂度分析
* 时间复杂度：`O(N^2)`
* 空间复杂度：`O(1)`


#### Solution

```java
class Solution {
    public void rotate(int[][] matrix) {
        int n = matrix.length;
        // 水平翻转
        for (int i = 0; i < n / 2; ++i) {
            for (int j = 0; j < n; ++j) {
                int temp = matrix[i][j];
                matrix[i][j] = matrix[n - i - 1][j];
                matrix[n - i - 1][j] = temp;
            }
        }
        // 主对角线翻转
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < i; ++j) {
                int temp = matrix[i][j];
                matrix[i][j] = matrix[j][i];
                matrix[j][i] = temp;
            }
        }
    }
}
```






## 1886. 判断矩阵经轮转后是否一致
### Description
* [LeetCode-1886. 判断矩阵经轮转后是否一致](https://leetcode-cn.com/problems/determine-whether-matrix-can-be-obtained-by-rotation/solution/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

参考 [LeetCode-48. 旋转图像](https://leetcode-cn.com/problems/rotate-image/) 中的矩阵原地旋转实现方案。


#### Solution

```java
class Solution {
    public boolean findRotation(int[][] mat, int[][] target) {
        int n = mat.length;
        
        //先检查是否本身相等
        if (check(mat,target)) {
            return true;
        }

        // 最多旋转 3 次
        for (int k = 0; k < 3; ++k) {
            // 旋转操作
            for (int i = 0; i < n / 2; ++i) {
                for (int j = 0; j < (n + 1) / 2; ++j) {
                    int temp = mat[i][j];
                    mat[i][j] = mat[n-1-j][i];
                    mat[n-1-j][i] = mat[n-1-i][n-1-j];
                    mat[n-1-i][n-1-j] = mat[j][n-1-i];
                    mat[j][n-1-i] = temp;
                }
            }
        
            if (check(mat,target)) {
                return true;
            }
        }
        return false;
    }

    private boolean check(int[][] mat1, int[][] mat2){
        for(int i = 0; i < mat1.length; i ++){
            for(int j = 0; j < mat1[0].length; j++){
                if(mat1[i][j] != mat2[i][j]){
                    return false;
                }
            }
        }
        return true;
    }
}
```