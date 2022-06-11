# LeetCode Notes-041


[TOC]



## 更新
* 2021/07/19，撰写
* 2021/07/22，完成


## Overview
* [LeetCode-1838. 最高频元素的频数](https://leetcode-cn.com/problems/frequency-of-the-most-frequent-element/)
* [LeetCode-35. 搜索插入位置](https://leetcode-cn.com/problems/search-insert-position/)
* [LeetCode-278. 第一个错误的版本](https://leetcode-cn.com/problems/first-bad-version/)
* [LeetCode-1920. 基于排列构建数组](https://leetcode-cn.com/problems/build-array-from-permutation/)
* [LeetCode-1913. 两个数对之间的最大乘积差](https://leetcode-cn.com/problems/maximum-product-difference-between-two-pairs/)




## 1838. 最高频元素的频数


### Description
* [LeetCode-1838. 最高频元素的频数](https://leetcode-cn.com/problems/frequency-of-the-most-frequent-element/)

### Approach 1-常规遍历-会出现超时
#### Analysis

参考 `leetcode-cn` 官方题解。


常规倒序遍历数组，求解正确，但会出现超时，无法AC。

数组长度为 `10^5`，两次遍历会导致超时。

#### Solution


```java
class Solution {
    public int maxFrequency(int[] nums, int k) {
        Arrays.sort(nums);
        int length = nums.length;
        int maxFrequency = 0;
        for(int i=length-1;i>0;i--){
            int tempFrequency = 1;
            int leftK = k;
            for(int j=i-1;j>=0;j--){
                if(leftK <=0){
                    break;
                }
                if(nums[j] == nums[i]){
                    tempFrequency++;
                }else if(nums[i] - nums[j] <= leftK){
                    tempFrequency++;
                    leftK = leftK - (nums[i] - nums[j]);
                }
            }
            maxFrequency = Math.max(maxFrequency,tempFrequency);
        }
        return maxFrequency;

    }
}
```





### Approach 2-排序 + 滑动窗口
#### Analysis

参考 `leetcode-cn` 官方题解。

参考 [leetcode-cn 图解滑动窗口](https://leetcode-cn.com/problems/frequency-of-the-most-frequent-element/solution/pai-xu-hua-dong-chuang-kou-tu-jie-by-aut-62jj/)。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/leetcode/leetcode-1838-1.png)


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/leetcode/leetcode-1838-2.png)




#### Solution


```java

class Solution {
    public int maxFrequency(int[] nums, int k) {
        Arrays.sort(nums);
        int n=nums.length;
        int left=0,right=1;
        int ans=1;
        while(right<n)
        {
            //对应上图红色部分
            k-=((nums[right]-nums[right-1])*(right-left));
            if(k>=0)
            {
                ans=right-left+1;//符合题意的答案
            }
            else{
                //不符合题意的答案，left要相应右移一位
                left++;
                //对应上图蓝色部分
                k+=(nums[right]-nums[left-1]);
            }
            right++;//right是一直右移的
        }
        return ans;
    }
}
```


## 35. 搜索插入位置

### Description
* [LeetCode-35. 搜索插入位置](https://leetcode-cn.com/problems/search-insert-position/)

### Approach 1-二分查找
#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public int searchInsert(int[] nums, int target) {
        int n = nums.length;
        int left = 0, right = n - 1, ans = n;
        while (left <= right) {
            int mid = ((right - left) >> 1) + left;
            if (target <= nums[mid]) {
                ans = mid;
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return ans;
    }
}
```



## 278. 第一个错误的版本

### Description
* [LeetCode-278. 第一个错误的版本](https://leetcode-cn.com/problems/first-bad-version/)

### Approach 1-二分查找
#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution


```java
public class Solution extends VersionControl {
    public int firstBadVersion(int n) {
        int left = 1, right = n;
        while (left < right) { // 循环直至区间左右端点相同
            int mid = left + (right - left) / 2; // 防止计算时溢出
            if (isBadVersion(mid)) {
                right = mid; // 答案在区间 [left, mid] 中 注意答案可能为mid 因此此处不要 right = mid-1
            } else {
                left = mid + 1; // 答案在区间 [mid+1, right] 中
            }
        }
        // 此时有 left == right，区间缩为一个点，即为答案
        return left;
    }
}
```





## 1920. 基于排列构建数组

### Description
* [LeetCode-1920. 基于排列构建数组](https://leetcode-cn.com/problems/build-array-from-permutation/)

### Approach 1-额外空间
#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public int[] buildArray(int[] nums) {
        int length = nums.length;
        int[] arr = new int[length];
        for(int i=0;i<length;i++){
            arr[i] = nums[nums[i]];
        }
        return arr;
    }
}
```


### Approach 2-本地修改
#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public int[] buildArray(int[] nums) {
        int length = nums.length;
        //第一次遍历 存储编码的最终值 nums[nums[i]]
        // 大于1000的部分 存储最终值
        // 小于1000的部分 存储初始值
        for(int i=0;i<length;i++){
            //在计算 nums[i] 的「最终值」并修改该元素时，nums[i] 的元素可能已被修改，因此我们需要将取下标得到的值对 1000 取模得到「最终值」。
            nums[i] += 1000 * (nums[nums[i]] % 1000);
        }
        //第二次遍历 修改为最终值
        for(int i=0;i<length;i++){
            nums[i] /= 1000;
        }
        return nums;
    }
}
```



## 1913. 两个数对之间的最大乘积差

### Description
* [LeetCode-1913. 两个数对之间的最大乘积差](https://leetcode-cn.com/problems/maximum-product-difference-between-two-pairs/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution

```java
class Solution {
    public int maxProductDifference(int[] nums) {
        Arrays.sort(nums);
        int length = nums.length;
        return nums[length-1]*nums[length-2] - nums[0]*nums[1];

    }
}
```