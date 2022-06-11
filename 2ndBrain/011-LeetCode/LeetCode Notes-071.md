
# LeetCode Notes-071


[TOC]



## 更新
* 2021/12/06，撰写
* 2021/12/07，完成



## Overview
* 【经典好题】[LeetCode-11. 盛最多水的容器](https://leetcode-cn.com/problems/container-with-most-water/)
* [LeetCode-1346. 检查整数及其两倍数是否存在](https://leetcode-cn.com/problems/check-if-n-and-its-double-exist/)
* [LeetCode-1089. 复写零](https://leetcode-cn.com/problems/duplicate-zeros/)
* [LeetCode-1752. 检查数组是否经排序和轮转得到](https://leetcode-cn.com/problems/check-if-array-is-sorted-and-rotated/description/)
* 【经典好题】[LeetCode-1758. 生成交替二进制字符串的最少操作数](https://leetcode-cn.com/problems/minimum-changes-to-make-alternating-binary-string/description/)






## 【经典好题】11. 盛最多水的容器
### Description
* 【经典好题】[LeetCode-11. 盛最多水的容器](https://leetcode-cn.com/problems/container-with-most-water/)

### Approach 1-暴力
#### Analysis

参考 `leetcode-cn` 官方题解。

暴力求解，此方法会超时，此处仅做记录。

#### Solution





```java
class Solution {
    public int maxArea(int[] height) {
        int maxArea = 0;
        int len = height.length;
        for(int i=0;i<len-1;i++){
            for(int j=i;j<len;j++){
                int heightVal = Math.min(height[i],height[j]);
                maxArea = Math.max(maxArea,heightVal*(j-i));
            }
        }
        return maxArea;
    }
}
```





### Approach 2-双指针
#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public int maxArea(int[] height) {
        int maxArea = 0;
        int l = 0;
        int r = height.length -1;
        while(l < r){
            int area = Math.min(height[l], height[r]) * (r - l);
            maxArea = Math.max(maxArea, area);
            //每次移动数值小的指针
            if (height[l] <= height[r]) {
                ++l;
            } else {
                --r;
            }
        }
        return maxArea;
    }
}
```


## 1346. 检查整数及其两倍数是否存在
### Description
* [LeetCode-1346. 检查整数及其两倍数是否存在](https://leetcode-cn.com/problems/check-if-n-and-its-double-exist/)

### Approach 1-双指针
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public boolean checkIfExist(int[] arr) {
        Arrays.sort(arr);
        int len = arr.length;
        int j = 0;  
        //j放到for循环外，复杂度为O(nlogn) 若放到for循环中，则为O(n^2)
        for(int i=0;i<len;i++){
            //int j = i;
            while(j < len && 2*arr[i] > arr[j]){
                j++;
            }
            if(j< len && j != i && arr[j] == 2*arr[i]){
                return true;
            }
        }
        
        //处理数值为负数的情况
        j = len -1;
        for(int i=len-1;i>=0;i--){
            while(j >= 0 && 2*arr[i] < arr[j]){
                j--;
            }
            if(j>=0 && j != i && arr[j] == 2*arr[i]){
                return true;
            }
        }
        return false;
    }
}
```



### Approach 2-哈希表
#### Analysis

参考 `leetcode-cn` 官方题解。

思路巧妙。


#### Solution


```java
class Solution {
    public boolean checkIfExist(int[] arr) {
        Set<Integer> set = new HashSet<>();
        int len = arr.length;
        for(int i=0;i<len;i++){
            if(set.contains(arr[i])){
                return true;
            }
            set.add(2*arr[i]);
            if(arr[i]%2 == 0){
                set.add(arr[i]/2);
            }
        }
        return false;
    }
}
```



## 1089. 复写零
### Description
* [LeetCode-1089. 复写零](https://leetcode-cn.com/problems/duplicate-zeros/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
 public void duplicateZeros(int[] arr) {
        int count = 0; //需要复制的0的个数
        int len = arr.length;
        int i=0;
        // 统计需要复制的0的个数，复制count个0，则会挤出原数组count个值
        // i进行扫描，遇到0则count自增
        // 若i+count大于原数组长度，则停止扫描，后面的直接舍弃
        while(i+count < len){
            if(arr[i] == 0){
                count++;
            }
            i++;
        }
        // 因为循环中i自增到了下一个值 此处i--返回到上一个结束值
        i--;
        int j= len-1;
        // i从结束值开始，j从数组末尾开始，从后往前扫描，开始复制
        // 特别需要注意的是：若最后一个数字是0，统计需要复制的0时统计了该数，但若复制一次，则数组可能越界
        // 此处+1判断，如果越界，则只复制本身
        if(count + i + 1 > len) {
            arr[j] = arr[i];
            count--;
            i--;
            j--;
        }
        // 遇0则复制两次，非0则复制本身
        // count<=0时，说明前面没有0了，保持不变就行
        while(count > 0){
            arr[j] = arr[i];
            j--;
            if(arr[i] == 0){
                arr[j] = arr[i];
                j--;
                count--;
            }
            i--;
        }
    }
}
```




## 1752. 检查数组是否经排序和轮转得到
### Description
* [LeetCode-1752. 检查数组是否经排序和轮转得到](https://leetcode-cn.com/problems/check-if-array-is-sorted-and-rotated/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

数学分析
1. 如果给的数组原本就是非递减的，那么直接返回true；
2. 如果给的数组发生了一次翻转，那么可以有1次机会允许出现递减，当遇到2次递减时，直接返回false；
3. 当发生一次翻转之后，合格的非递减的数组，其最后一个元素必须小于或等于第一个元素，如果不满足，直接返回false。


#### Solution


```java
class Solution {
    public boolean check(int[] nums) {
        int len = nums.length;
        int chance = 1; //递减出现的机会
        for(int i=1;i<len;i++){
            if(nums[i] < nums[i-1]){
                //出现了递减
                chance -= 1;
                if(chance < 0){
                    //1. 如果给的数组发生了一次翻转，那么可以有1次机会允许出现递减，当遇到2次递减时，直接返回false；
                    return false;
                }
            }
        }
        //2. 当发生一次翻转之后，合格的非递减的数组，其最后一个元素必须小于或等于第一个元素，如果不满足，直接返回false。
        if(chance == 0 && nums[len-1] > nums[0]){
            return false;
        }
        //3. 如果给的数组原本就是非递减的，那么直接返回true；
        return true;
    }
}
```





## 【经典好题】1758. 生成交替二进制字符串的最少操作数
### Description
* 【经典好题】[LeetCode-1758. 生成交替二进制字符串的最少操作数](https://leetcode-cn.com/problems/minimum-changes-to-make-alternating-binary-string/description/)

### Approach 1-动态规划
#### Analysis

参考 `leetcode-cn` 官方题解。

ref - [动态规划题解](https://leetcode-cn.com/problems/minimum-changes-to-make-alternating-binary-string/solution/dong-tai-gui-hua-by-robothy-cmt1/)


状态标识

* `dp[0][i+1]` 表示让 `s.charAt(i)` 变为 `0` 需要对 `s.substring(0, i+1)` 操作的次数
* `dp[1][i+1]` 表示让 `s.charAt(i)` 变为 `1` 需要对 `s.substring(0, i+1)` 操作的次数。


转移方程为

```java
if(s.charAt(i)=='0'){
    dp[0][i+1] = dp[1][i];
    dp[1][i+1] = dp[0][i] + 1;
}else{
    dp[0][i+1] = dp[1][i] + 1;
    dp[1][i+1] = dp[0][i];
}
```


则最终结果为 `ans = Math.min(dp[0][n], dp[1][n]);`



#### Solution


```java
class Solution {
    public int minOperations(String s) {
        int n = s.length();
        int[][] dp = new int[2][n+1];

     
        for(int i=0;i<s.length();i++){
            if(s.charAt(i)=='0'){
                dp[0][i+1] = dp[1][i];
                dp[1][i+1] = dp[0][i] + 1;
            } else {
                dp[0][i+1] = dp[1][i] + 1;
                dp[1][i+1] = dp[0][i];
            }
        }
        return Math.min(dp[0][n], dp[1][n]);

    }
}
```


### Approach 2-数学奇偶性
#### Analysis

分两种情况进行分析
1. 偶数位为0，奇数位为1：这种情况下，任意位的值和索引奇偶性相同，即 `s[i]%2==i%2`，若不满足，即需要变动该位，则计数 `cnt1++`
2. 偶数位为1，奇数位为0：这种情况下，任意位的值和索引奇偶性不同，即 `s[i]%2!=i%2`，若不满足，即需要变动该位，则计数 `cnt2++`

最终结果，比较哪种需要变动的位数小。


#### Solution

```java
class Solution {
    public int minOperations(String s) {
        int n = s.length();
        int cnt1 = 0;
        int cnt2 = 0;
        for(int i=0;i<n;i++){
            if(s.charAt(i)%2 != i%2){
                cnt1++;
            } else {
                cnt2++;
            }
        }
        return Math.min(cnt1,cnt2);
    }
}
```
