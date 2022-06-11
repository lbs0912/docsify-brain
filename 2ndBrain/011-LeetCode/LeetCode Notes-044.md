# LeetCode Notes-044


[TOC]



## 更新
* 2021/07/19，撰写
* 2021/07/22，完成


## Overview
* [LeetCode-1464. 数组中两元素的最大乘积](https://leetcode-cn.com/problems/maximum-product-of-two-elements-in-an-array/description/)
* [LeetCode-1460. 通过翻转子数组使两个数组相等](https://leetcode-cn.com/problems/make-two-arrays-equal-by-reversing-sub-arrays/description/)
* [LeetCode-1909. 删除一个元素使数组严格递增](https://leetcode-cn.com/problems/remove-one-element-to-make-the-array-strictly-increasing/description/)
* [LeetCode-1877. 数组中最大数对和的最小值](https://leetcode-cn.com/problems/minimize-maximum-pair-sum-in-array/description/)
* [LeetCode-1539. 第 k 个缺失的正整数](https://leetcode-cn.com/problems/kth-missing-positive-number/description/)



## 【水题】1464. 数组中两元素的最大乘积
### Description
* [LeetCode-1464. 数组中两元素的最大乘积](https://leetcode-cn.com/problems/maximum-product-of-two-elements-in-an-array/description/)
 

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution

```java
class Solution {
    public int maxProduct(int[] nums) {
        Arrays.sort(nums);
        int length = nums.length;
        return (nums[length-1]-1)*(nums[length-2]-1);

    }
}
```



## 1460. 通过翻转子数组使两个数组相等

### Description
* [LeetCode-1460. 通过翻转子数组使两个数组相等](https://leetcode-cn.com/problems/make-two-arrays-equal-by-reversing-sub-arrays/description/)
 

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

【水题】

两个数组排序后，若相等即相等
#### Solution


```java
class Solution {
    public boolean canBeEqual(int[] target, int[] arr) {
        if(target.length != arr.length){
            return false;
        }
        Arrays.sort(target);
        Arrays.sort(arr);
        //排序后相等即相等
        for(int i=0;i<arr.length;i++){
            if(target[i] != arr[i]){
                return false;
            }
        }
        return true;
        

    }
}
```

## 1909. 删除一个元素使数组严格递增  
### Description
* [LeetCode-1909. 删除一个元素使数组严格递增](https://leetcode-cn.com/problems/remove-one-element-to-make-the-array-strictly-increasing/description/)

### Approach 1-寻找驼峰或低谷
#### Analysis

参考 `leetcode-cn` 官方题解。

* [题解-遍历一边数组找驼峰或者低谷](https://leetcode-cn.com/problems/remove-one-element-to-make-the-array-strictly-increasing/solution/bian-li-yi-bian-shu-zu-zhao-tuo-feng-huo-hvyd/)




遍历整个数组，直到找到一个递减的数对，此时大的数为 `k`，小的数为 `k+1`
* 如果 `k - 1 < 0`，说明大的数在开头，删除即可。
* 如果 `nums[k+1] > nums[k-1]`，说明下标为 `k` 这个大数是驼峰，删除即可保证递增。
* 如果 `K+ 2 >= n`，说明小的数在末尾，删除即可。
* 如果 `nums[k] < nums[k+2]`，说明下标为 `k+1` 这个小数是低谷，删除即可保证递增。

此外，以上判断只需要判断一次，如果进入了第二次判断，说明出现了第二组扰乱递增的数对，直接返回 false。

时间复杂度为 `O(n)`，只遍历了一次数组。



#### Solution


```java
class Solution {
    public boolean canBeIncreasing(int[] nums) {
        boolean asc = true;
        int n = nums.length;
        for(int i=0;i<n-1;i++){
            if(nums[i] >= nums[i+1]){
                if(asc){
                    if(i-1 < 0 || nums[i+1] > nums[i-1]){
                        asc = false;
                    } else if(i+2 >= n || nums[i+2] > nums[i]){
                        asc = false;
                    } else {
                        return false;
                    }
                } else {
                    return false;
                }
            }
        }
        return true;

    }
}
```




## 1877. 数组中最大数对和的最小值
### Description
* [LeetCode-1877. 数组中最大数对和的最小值](https://leetcode-cn.com/problems/minimize-maximum-pair-sum-in-array/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int minPairSum(int[] nums) {
        int max = 0;
        Arrays.sort(nums);
        int length = nums.length;
        for(int i=0;i<(length/2);i++){
            max = Math.max(max,nums[i] + nums[length-1-i]);
        }
        return  max;

    }
}
```


## 1539. 第 k 个缺失的正整数
### Description
* [LeetCode-1539. 第 k 个缺失的正整数](https://leetcode-cn.com/problems/kth-missing-positive-number/description/)

### Approach 1-自解
#### Analysis

参考 `leetcode-cn` 官方题解。

自解方案中没有使用数组递增的性质，可以参考官方题解进行优化。


复杂度分析
* 时间复杂度：`O(n)`。最坏情况下遍历完整个数组。
* 空间复杂度：`O(1)`。使用了长度为1001的辅助数组。
#### Solution


```java
class Solution {
    public int findKthPositive(int[] arr, int k) {
        int[] nums = new int[1001];
        for(int val:arr){
            nums[val] = 1;
        }
        int res = 1;
        int index = 1;
        int count = k;
        while(count > 0 ){
            if(index > 1000){ //arr[i] 小于1000 但是缺失的数可能大于1000
                break;
            }
            if(nums[index] == 0){
                count--;
                res = index;
            }
            index++;
        }
    
        return (index > 1000)? 1000+count:res;

    }
}
```



### Approach 2-枚举
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(n+k)`。最坏情况下遍历完整个数组都没有缺失正整数，还要再将 `current` 递增 `k` 次，才能找到最终的答案。
* 空间复杂度：`O(1)`。

#### Solution

```java
class Solution {
    public int findKthPositive(int[] arr, int k) {
        //current 从1开始递增
        //missCount表示缺失的数字的个数
        int missCount = 0, lastMiss = -1, current = 1, ptr = 0; 
        for (missCount = 0; missCount < k; ++current) {
            if (current == arr[ptr]) { 
                //arr是严格递增的 current也是递增的 因此可以用current == arr[ptr] 直接判断数组中是否存在current
                ptr = (ptr + 1 < arr.length) ? ptr + 1 : ptr;
            } else {
                ++missCount;
                lastMiss = current;
            }
        }
        return lastMiss;
    }
}
```


### Approach 3-二分查找
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(logn)`。即二分的时间复杂度。
* 空间复杂度：`O(1)`。


#### Solution

```java
class Solution {
    public int findKthPositive(int[] arr, int k) {
        if (arr[0] > k) {
            return k;
        }

        int l = 0, r = arr.length;
        while (l < r) {
            int mid = (l + r) >> 1;
            int x = mid < arr.length ? arr[mid] : Integer.MAX_VALUE;
            if (x - mid - 1 >= k) {
                r = mid;
            } else {
                l = mid + 1;
            }
        }

        return k - (arr[l - 1] - (l - 1) - 1) + arr[l - 1];
    }
}
```

