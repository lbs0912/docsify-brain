

# LeetCode Notes-070


[TOC]



## 更新
* 2021/12/05，撰写
* 2021/12/06，完成



## Overview
* [LeetCode-1984. 学生分数的最小差值](https://leetcode-cn.com/problems/minimum-difference-between-highest-and-lowest-of-k-scores/description/)
* [LeetCode-1991. 找到数组的中间位置](https://leetcode-cn.com/problems/find-the-middle-index-in-array/description/)
* [LeetCode-462. 最少移动次数使数组元素相等 II](https://leetcode-cn.com/problems/minimum-moves-to-equal-array-elements-ii/)
* [LeetCode-453. 最小操作次数使数组元素相等](https://leetcode-cn.com/problems/minimum-moves-to-equal-array-elements/)
* [LeetCode-剑指 Offer II 080. 含有 k 个元素的组合](https://leetcode-cn.com/problems/uUsW3B/)







## 1984. 学生分数的最小差值
### Description
* [LeetCode-1984. 学生分数的最小差值](https://leetcode-cn.com/problems/minimum-difference-between-highest-and-lowest-of-k-scores/description/)

### Approach 1-排序+滑动窗
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public int minimumDifference(int[] nums, int k) {
        Arrays.sort(nums);
        int size = nums.length;
        int minDistance = Integer.MAX_VALUE;
        for(int i=k-1;i<size;i++){
            minDistance = Math.min(minDistance, nums[i] - nums[i-k+1]);
        }
        return minDistance;
    }
}
```





## 1991. 找到数组的中间位置

### Description
* [LeetCode-1991. 找到数组的中间位置](https://leetcode-cn.com/problems/find-the-middle-index-in-array/description/)


本题同 [LeetCode-724. 寻找数组的中心下标](https://leetcode-cn.com/problems/find-pivot-index/description/)

### Approach 1-前缀和+后缀和
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int findMiddleIndex(int[] nums) {
        int len = nums.length;
        int[] prefixSum = new int[len]; //前缀和
        int[] suffixSum = new int[len]; //后缀和
        for(int i=0;i<len;i++){
            prefixSum[i] = nums[i] + prefixSum[Math.max(0,i-1)];
            suffixSum[len-1-i] = nums[len-1-i] + suffixSum[Math.min(len-1,len-i)];
        }
        for(int i=0;i<len;i++){
            if(prefixSum[i] == suffixSum[i]){
                return i;
            }
        }
        return -1; //无符合要求的
    }
}
```






## 462. 最少移动次数使数组元素相等 II
### Description
* [LeetCode-462. 最少移动次数使数组元素相等 II](https://leetcode-cn.com/problems/minimum-moves-to-equal-array-elements-ii/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

当 x 为这个 N 个数的中位数时，可以使得距离最小。

具体地，若 N 为奇数，则 x 必须为这 N 个数中的唯一中位数；若 N 为偶数，中间的两个数为 p 和 q，中位数为 `(p + q) / 2`，**此时 x 只要是区间 [p, q] 中的任意一个数即可。**


#### Solution


```java
class Solution {
    public int minMoves2(int[] nums) {
        int len = nums.length;
        int sum = 0;
        Arrays.sort(nums);
        int midVal = nums[len/2]; //中位数

        for (int num : nums) {
            sum += Math.abs(midVal - num);
        }
        return sum;
    }
}
```



## 453. 最小操作次数使数组元素相等
### Description
* [LeetCode-453. 最小操作次数使数组元素相等](https://leetcode-cn.com/problems/minimum-moves-to-equal-array-elements/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

**每次操作既可以理解为使 `n-1` 个元素增加 1，也可以理解使 1 个元素减少 1。显然，后者更利于我们的计算。**


#### Solution

```java
class Solution {
    public int minMoves(int[] nums) {
        int minNum = Arrays.stream(nums).min().getAsInt();
        int res = 0;
        for(int num:nums){
            res += num - minNum;
        }
        return res;
    }
}
```


## 剑指 Offer II 080. 含有 k 个元素的组合
### Description
* [LeetCode-剑指 Offer II 080. 含有 k 个元素的组合](https://leetcode-cn.com/problems/uUsW3B/)

### Approach 1-回溯+剪枝
#### Analysis

参考 `leetcode-cn` 官方题解。


本题与主站 [LeetCode-77. 组合](https://leetcode-cn.com/problems/combinations/) 相同。



#### Solution

```java
class Solution {
    public List<List<Integer>> combine(int n, int k) {
        List<List<Integer>> list = new ArrayList<>();
        List<Integer> path = new ArrayList<>(); //记录的一条路径
        int begin = 1;
        dfs(list,path,n,k,begin);
        return list;
    }

    private void dfs(List<List<Integer>> list,List<Integer> path, int n, int k, int begin){
        if(path.size() == k){
            list.add(new ArrayList<>(path));  //新创建一个数组插入 
        }
        //组合问题 和顺序无关 故为i=begin 不是i=0
        for(int i=begin;i<=n;i++){
            path.add(i);
            dfs(list,path,n,k,i+1); //数字只能取1次 故为i+1
            path.remove(path.size()-1);
        }
    }
}
```