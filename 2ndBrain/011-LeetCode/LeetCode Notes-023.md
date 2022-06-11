
# LeetCode Notes-023


[TOC]



## 更新
* 2021/03/08，撰写
* 2021/03/08，完成


## Overview
* [LeetCode-442. 数组中重复的数据](https://leetcode-cn.com/problems/find-all-duplicates-in-an-array/description/)
* [LeetCode-217. 存在重复元素](https://leetcode-cn.com/problems/contains-duplicate/)
* [LeetCode-219. 存在重复元素 II](https://leetcode-cn.com/problems/contains-duplicate-ii/)
* [LeetCode-414. 第三大的数](https://leetcode-cn.com/problems/third-maximum-number/)
* [LeetCode-628. 三个数的最大乘积](https://leetcode-cn.com/problems/maximum-product-of-three-numbers/)




## 442. 数组中重复的数据
### Description
* [LeetCode-442. 数组中重复的数据](https://leetcode-cn.com/problems/find-all-duplicates-in-an-array/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public List<Integer> findDuplicates(int[] nums) {
        List<Integer> list = new ArrayList<>();
        Set<Integer> set = new HashSet<>();
        for(int val:nums){
            if(!set.add(val)){
                list.add(val);
            }
        }
        return list;
    }
}
```


### Approach 2-原地标记
#### Analysis

参考 `leetcode-cn` 官方题解。


> 给定一个整数数组 a，其中 `1 ≤ a[i] ≤ n `（n为数组长度）, 其中有些元素出现两次而其他元素出现一次。

注意题目的条件，`1 ≤ a[i] ≤ n `，因此可以不适用额外的空间，在原数组上对值进行标记。
* 我们用 `nums[nums[i]-1]` 来判断 `nums[i]` 是否出现过（减 1 是为了防止下标越界，数组下标从 0 开始，而数值从 1 开始）
* 如果 `nums[i]` 第一次出现则将 `nums[nums[i]-1] * -1`，标记为负数，使用这样的方法就可以实现在原数组上对值进行标记。


#### Solution


```java
class Solution {
    public List<Integer> findDuplicates(int[] nums) {
        List<Integer> list = new ArrayList<>();
        for (int i = 0; i < nums.length; i++) {
            int tmp = Math.abs(nums[i]) - 1;
            // 如果 nums[tmp] < 0 则表示该数已出现过进行记录
            if (nums[tmp] > 0) {
                nums[tmp] = -nums[tmp];
            } else {
                list.add(tmp + 1);
            }
        }
        return list;
    }
}
```






## 217. 存在重复元素
### Description
* [LeetCode-217. 存在重复元素](https://leetcode-cn.com/problems/contains-duplicate/)

### Approach 1-Set-哈希表
#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(N)`，其中 N 为数组的长度。
* 空间复杂度：`O(N)`，其中 NN 为数组的长度。


#### Solution


```java
class Solution {
    public boolean containsDuplicate(int[] nums) {
        Set<Integer> set = new HashSet<>();
        for(int val:nums){
            set.add(val);
        }
        return (set.size() != nums.length);

    }
}
```


下面给出一个更优的求解，当 `set.add(ele)` 失败时，直接返回结果。


> boolean add(E e);
> 
> Returns: true if this set did not already contain the specified element

```java
class Solution {
    public boolean containsDuplicate(int[] nums) {
        Set<Integer> set = new HashSet<Integer>();
        for (int x : nums) {
            if (!set.add(x)) {
                return true;
            }
        }
        return false;
    }
}
```



## 219. 存在重复元素 II
### Description
* [LeetCode-219. 存在重复元素 II](https://leetcode-cn.com/problems/contains-duplicate-ii/)

### Approach 1-线性搜索
#### Analysis

参考 `leetcode-cn` 官方题解。


线性搜索数组，维护了一个 k 大小的滑动窗口，然后在这个窗口里面搜索是否存在跟当前元素相等的元素。

复杂度分析
* 时间复杂度：`O(nmin(k,n))`。每次搜索都要花费 `O(min(k,n))` 的时间，哪怕 k 比 n 大，一共需要比较 n 次。
* 空间复杂度：`O(1)`

提交记录
* 耗时：1310 ms	
* 内存：41.1 MB


#### Solution

```java
class Solution {

    public boolean containsNearbyDuplicate(int[] nums, int k) {
        for (int i = 0; i < nums.length; ++i) {
            for (int j = Math.max(i - k, 0); j < i; ++j) {
                if (nums[i] == nums[j]) return true;
            }
        }
        return false;
    }
    // Time Limit Exceeded.
}
```





### Approach 2-Set优化
#### Analysis

参考 `leetcode-cn` 官方题解。


借助 `Set` 去重，仅针对存在的重复的元素，比较其 `[index-k,index+k]` 区间范围内的元素，注意在区间遍历时，需排除 `index` ，即遍历区间为 `[index-k,index-1] & [index+1,index+k]`。


复杂度分析
* 时间复杂度：`O(nk)`。
* 空间复杂度：`O(n)`

提交记录
* 耗时：7 ms	
* 内存：41.1 MB



#### Solution



```java
class Solution {
    public boolean containsNearbyDuplicate(int[] nums, int k) {
        Set<Integer> set = new HashSet<>();
        int length = nums.length;
        for(int i = 0;i < length; i++){
            if(set.contains(nums[i]) && findDuplicateEleWithDistance(nums,Math.max(0,i-k),Math.min(length-1,i+k),i)){
                return true;
            } else {
                set.add(nums[i]);
            }
        }
        return false;
    }
    private boolean findDuplicateEleWithDistance(int[] nums, int start, int end, int index){
        for(int i = start;i<=end;i++){
            if(nums[index] == nums[i] && index != i) {
                return true;
            }
        }
        return false;
    }
}
```


### Approach 3-Set优化+k大小的滑动窗
#### Analysis

参考 `leetcode-cn` 官方题解。


用散列表来维护这个 k 大小的滑动窗口。

复杂度分析
* 时间复杂度：`O(n)`。会做 n 次 搜索，删除，插入操作，每次操作都耗费常数时间。
* 空间复杂度：`O(min(n,k))`，开辟的额外空间取决于散列表中存储的元素的个数，也就是滑动窗口的大小。



提交记录
* 耗时：10 ms	
* 内存：41.1 MB



#### Solution


```java
class Solution {

    public boolean containsNearbyDuplicate(int[] nums, int k) {
        Set<Integer> set = new HashSet<>();
        for (int i = 0; i < nums.length; ++i) {
            if (set.contains(nums[i])) {
                return true;
            }
            set.add(nums[i]);
            if (set.size() > k) { //维护大小为k的窗
                set.remove(nums[i - k]);
            }
        }
        return false;
    }

}
```



## 414. 第三大的数
### Description
* [LeetCode-414. 第三大的数](https://leetcode-cn.com/problems/third-maximum-number/)

### Approach 1-O(n)+min辅助
#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(N)`，其中 N 为数组长度。
* 空间复杂度：`O(1)`。


在编码过程中，需要注意的是
* 大小重复的数字，只计做1次，因此需要排除和 `max1` 和 `max2` 相等的数字，即
  
```java
    } else if( val > max2 && val != max1){
        max3 = max2;
        max2 = val;
    } else if(val > max3 && val != max1 && val != max2){
        max3 = val;
    }
```

* 情况1：若数字中不存在第3大的数字，如 `[1,1,Integer.MIN_VALUE]`。针对这种情况，可以判断当 `Integer.MIN_VALUE == max2` 时，返回 `max1`。
* 情况2：若数字中不存在第3大的数字，如 `[1,1,2]`。此时 `max1 = 2, max2 = 1, max3 = Integer.MIN_VALUE`。
* 情况3：若数字中第3大的数字恰巧为 `Integer.MIN_VALUE`，如 `[1,2,Integer.MIN_VALUE]`。此时 `max1 = 2, max2 = 1, max3 = Integer.MIN_VALUE`。

可以发现，情况2和情况3相同。这个时候可以引入 `min` 最小值辅助判断。
1. 若 `min = Integer.MIN_VALUE`，则对应情况3，返回 `max3`
2. 若 `min != Integer.MIN_VALUE`，则对应情况2，返回 `max1`


#### Solution

```java
class Solution {
    public int thirdMax(int[] nums) {
        int length = nums.length;
        if(length == 1){
            return nums[0];
        } else if(length == 2){
            return Math.max(nums[0],nums[1]);
        }
        int max1 = Integer.MIN_VALUE;
        int max2 = Integer.MIN_VALUE;
        int max3 = Integer.MIN_VALUE;
        int min = Integer.MAX_VALUE;
    
        for(int val:nums){
            if(val > max1){
                max3 = max2;
                max2 = max1;
                max1 = val;
            } else if( val > max2 && val != max1){
                max3 = max2;
                max2 = val;
            } else if(val > max3 && val != max1 && val != max2){
                max3 = val;
            }
            min = Math.min(min,val);
        }
        //针对 [1,1,Integer.MIN_VALUE] 不存在第3大
        if(Integer.MIN_VALUE == max2){
            return max1;
        }
        //针对 [1,2,Integer.MIN_VALUE] 第3大本身就是Integer.MIN_VALUE
        return (Integer.MIN_VALUE == max3 && min != Integer.MIN_VALUE)? max1:max3; 
    }
}
```





### Approach 2-O(n)+Long.MIN_VALUE辅助
#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(N)`，其中 N 为数组长度。
* 空间复杂度：`O(1)`。


回顾方法 1 中，之所以要对对情况 2 和情况 3 分类处理，是因为数组的元素可能等于 `Integer.MIN_VALUE`，如果可以初始化 `max3` 为一个更小的且数组元素不可能取到的值呢？是不是就可以不再区分情况2和情况3了？

答案是肯定的，代码中我们借助 `Long.MIN_VALUE` 对值进行初始化。


#### Solution

```java
class Solution {
    public int thirdMax(int[] nums) {
        int length = nums.length;
        if(length == 1){
            return nums[0];
        } else if(length == 2){
            return Math.max(nums[0],nums[1]);
        }
        long max1 = Long.MIN_VALUE;
        long max2 = Long.MIN_VALUE;
        long max3 = Long.MIN_VALUE;
    
        for(int val:nums){
            if(val > max1){
                max3 = max2;
                max2 = max1;
                max1 = val;
            } else if( val > max2 && val != max1){
                max3 = max2;
                max2 = val;
            } else if(val > max3 && val != max1 && val != max2){
                max3 = val;
            }

        }
        return (Long.MIN_VALUE == max3)? (int)max1:(int)max3; 
    }
}
```




## 628. 三个数的最大乘积
### Description
* [LeetCode-628. 三个数的最大乘积](https://leetcode-cn.com/problems/maximum-product-of-three-numbers/)

### Approach 1-数组排序
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(NlogN)`，其中 N 为数组长度。排序需要 `O(NlogN)` 的时间
* 空间复杂度：`O(logN)`，主要为排序的空间开销



#### Solution



```java
class Solution {
    public int maximumProduct(int[] nums) {
        Arrays.sort(nums);
        int n = nums.length;
        return Math.max(nums[0] * nums[1] * nums[n - 1], nums[n - 3] * nums[n - 2] * nums[n - 1]);
    }
}
```

### Approach 2-线性扫描
#### Analysis

参考 `leetcode-cn` 官方题解。

在方法一中，我们实际上只要求出数组中最大的三个数以及最小的两个数，因此我们可以不用排序，用线性扫描直接得出这五个数。


复杂度分析
* 时间复杂度：`O(N)`，其中 N 为数组长度。
* 空间复杂度：`O(1)`。



#### Solution



```java
class Solution {
    public int maximumProduct(int[] nums) {
        // 最小的和第二小的
        int min1 = Integer.MAX_VALUE, min2 = Integer.MAX_VALUE;
        // 最大的、第二大的和第三大的
        int max1 = Integer.MIN_VALUE, max2 = Integer.MIN_VALUE, max3 = Integer.MIN_VALUE;

        for (int x : nums) {
            if (x < min1) {
                min2 = min1;
                min1 = x;
            } else if (x < min2) {
                min2 = x;
            }

            if (x > max1) {
                max3 = max2;
                max2 = max1;
                max1 = x;
            } else if (x > max2) {
                max3 = max2;
                max2 = x;
            } else if (x > max3) {
                max3 = x;
            }
        }

        return Math.max(min1 * min2 * max1, max1 * max2 * max3);
    }
}
```