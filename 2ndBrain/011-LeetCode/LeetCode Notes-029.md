
# LeetCode Notes-029


[TOC]



## 更新
* 2021/03/22，撰写
* 2021/03/25，完成


## Overview
* [LeetCode-13. 罗马数字转整数](https://leetcode-cn.com/problems/roman-to-integer/description/)
* [LeetCode-9. 回文数](https://leetcode-cn.com/problems/palindrome-number/description/)
* [LeetCode-4. 寻找两个正序数组的中位数](https://leetcode-cn.com/problems/median-of-two-sorted-arrays/description/)
* [LeetCode-面试题 02.03. 删除中间节点](https://leetcode-cn.com/problems/delete-middle-node-lcci/)
* [LeetCode-279. 完全平方数](https://leetcode-cn.com/problems/perfect-squares/)





## 9. 回文数
### Description
* [LeetCode-9. 回文数](https://leetcode-cn.com/problems/palindrome-number/description/)

### Approach 1-转化为字符串
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public boolean isPalindrome(int x) {
        if(x < 0 ){
            return false;
        }
        if(x == 0 ){
            return true;
        }
        String str = String.valueOf(x);
        int left = 0;
        int right = str.length()-1;
        while(left<=right){
            if(str.charAt(left) != str.charAt(right)){
                return false;
            }
            left++;
            right--;
        }
        return true;
    }
}
```



### Approach 2-不借助字符串+反转一半
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public boolean isPalindrome(int x) {
        // 特殊情况：
        // 如上所述，当 x < 0 时，x 不是回文数。
        // 同样地，如果数字的最后一位是 0，为了使该数字为回文，
        // 则其第一位数字也应该是 0
        // 只有 0 满足这一属性
        if (x < 0 || (x % 10 == 0 && x != 0)) {
            return false;
        }

        int revertedNumber = 0;
        while (x > revertedNumber) {
            revertedNumber = revertedNumber * 10 + x % 10;
            x /= 10;
        }

        // 当数字长度为奇数时，我们可以通过 revertedNumber/10 去除处于中位的数字。
        // 例如，当输入为 12321 时，在 while 循环的末尾我们可以得到 x = 12，revertedNumber = 123，
        // 由于处于中位的数字不影响回文（它总是与自己相等），所以我们可以简单地将其去除。
        return x == revertedNumber || x == revertedNumber / 10;
    }
}
```




## 13. 罗马数字转整数
### Description
* [LeetCode-13. 罗马数字转整数](https://leetcode-cn.com/problems/roman-to-integer/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution




```java
class Solution {
    public int romanToInt(String s) {
        int length = s.length();
        int i = 0;
        int count = 0;
        Character prev = null;
        Map<Character,Integer> map = new HashMap<>();
        map.put('M',1000);
        map.put('D',500);
        map.put('C',100);
        map.put('L',50);
        map.put('X',10);
        map.put('V',5);
        map.put('I',1);


        while(i<length){
            Character cur = s.charAt(i);
            if(map.containsKey(cur)){
                count += map.get(cur);
                i++;
            }
            if(prev != null){
                if(prev == 'I' && (cur == 'V' || cur == 'X')){
                    count -= 2;
                }
                else if(prev == 'X' && (cur == 'L' || cur == 'C')){
                    count -= 2*10;
                }
                else if(prev == 'C' && (cur == 'D' || cur == 'M')){
                    count -= 2*100;
                }
            }
            prev = cur;
        }
        return count;
    }
}
```





## 4. 寻找两个正序数组的中位数
### Description
* [LeetCode-4. 寻找两个正序数组的中位数](https://leetcode-cn.com/problems/median-of-two-sorted-arrays/description/)

### Approach 1-常规双指针
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public double findMedianSortedArrays(int[] nums1, int[] nums2) {
        int m = nums1.length;
        int n = nums2.length;
        int val1 = 0;
        int val2 = 0;
        int targetIndex1 = -1;
        int targetIndex2 = -1;
        if((m+n)%2 == 0){ //中位数有2个元素
            targetIndex1 = (m+n)/2;
            targetIndex2 = targetIndex1 - 1;
        }
        else {
            targetIndex1 = (m+n)/2;
        }
        int left = 0;
        int right = 0;
        int index  = 0;
        int curVal = 0;
        while(left < m && right < n){
            if(nums1[left] <= nums2[right]){
                curVal = nums1[left++];
            }
            else{
                curVal = nums2[right++];
            }
            if(index == targetIndex1){
                val1 = curVal;
            }
            if(index == targetIndex2){
                val2 = curVal;
            }
            index++;
        }
        while(left < m){
            curVal = nums1[left++];
            if(index == targetIndex1){
                val1 = curVal;
            }
            if(index == targetIndex2){
                val2 = curVal;
            }
            index++;
        }
        while(right < n){
            curVal = nums2[right++];

            if(index == targetIndex1){
                val1 = curVal;
            }
            if(index == targetIndex2){
                val2 = curVal;
            }
            index++;
        }
        return (m+n)%2 == 0 ? (double)(val1 + val2)/2: (double)val1;
    }
}
```
### Approach 2-二分查找
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public double findMedianSortedArrays(int[] nums1, int[] nums2) {
        int length1 = nums1.length, length2 = nums2.length;
        int totalLength = length1 + length2;
        if (totalLength % 2 == 1) {
            int midIndex = totalLength / 2;
            double median = getKthElement(nums1, nums2, midIndex + 1);
            return median;
        } else {
            int midIndex1 = totalLength / 2 - 1, midIndex2 = totalLength / 2;
            double median = (getKthElement(nums1, nums2, midIndex1 + 1) + getKthElement(nums1, nums2, midIndex2 + 1)) / 2.0;
            return median;
        }
    }

    public int getKthElement(int[] nums1, int[] nums2, int k) {
        /* 主要思路：要找到第 k (k>1) 小的元素，那么就取 pivot1 = nums1[k/2-1] 和 pivot2 = nums2[k/2-1] 进行比较
         * 这里的 "/" 表示整除
         * nums1 中小于等于 pivot1 的元素有 nums1[0 .. k/2-2] 共计 k/2-1 个
         * nums2 中小于等于 pivot2 的元素有 nums2[0 .. k/2-2] 共计 k/2-1 个
         * 取 pivot = min(pivot1, pivot2)，两个数组中小于等于 pivot 的元素共计不会超过 (k/2-1) + (k/2-1) <= k-2 个
         * 这样 pivot 本身最大也只能是第 k-1 小的元素
         * 如果 pivot = pivot1，那么 nums1[0 .. k/2-1] 都不可能是第 k 小的元素。把这些元素全部 "删除"，剩下的作为新的 nums1 数组
         * 如果 pivot = pivot2，那么 nums2[0 .. k/2-1] 都不可能是第 k 小的元素。把这些元素全部 "删除"，剩下的作为新的 nums2 数组
         * 由于我们 "删除" 了一些元素（这些元素都比第 k 小的元素要小），因此需要修改 k 的值，减去删除的数的个数
         */

        int length1 = nums1.length, length2 = nums2.length;
        int index1 = 0, index2 = 0;
        int kthElement = 0;

        while (true) {
            // 边界情况
            if (index1 == length1) {
                return nums2[index2 + k - 1];
            }
            if (index2 == length2) {
                return nums1[index1 + k - 1];
            }
            if (k == 1) {
                return Math.min(nums1[index1], nums2[index2]);
            }
            
            // 正常情况
            int half = k / 2;
            int newIndex1 = Math.min(index1 + half, length1) - 1;
            int newIndex2 = Math.min(index2 + half, length2) - 1;
            int pivot1 = nums1[newIndex1], pivot2 = nums2[newIndex2];
            if (pivot1 <= pivot2) {
                k -= (newIndex1 - index1 + 1);
                index1 = newIndex1 + 1;
            } else {
                k -= (newIndex2 - index2 + 1);
                index2 = newIndex2 + 1;
            }
        }
    }
}

```





## 面试题 02.03. 删除中间节点
### Description
* [LeetCode-面试题 02.03. 删除中间节点](https://leetcode-cn.com/problems/delete-middle-node-lcci/)

### Approach 1
#### Analysis

参考 `leetcode-cn` 官方题解。




#### Solution

```java
class Solution {
    public void deleteNode(ListNode node) {
        //这个node就是中间的某个结点
        node.val=node.next.val;
        node.next=node.next.next;
    }
}
```


## 279. 完全平方数
### Description
* [LeetCode-279. 完全平方数](https://leetcode-cn.com/problems/perfect-squares/)

### Approach 1-动态规划
#### Analysis

参考 `leetcode-cn` 官方题解。

参考 [画解算法：279. 完全平方数](https://leetcode-cn.com/problems/perfect-squares/solution/hua-jie-suan-fa-279-wan-quan-ping-fang-shu-by-guan/)。




使用动态规划思路求解
1. 创建数组 `dp[i]`，表示和为 `i` 的完全平方数的最少数量，则最终返回答案为 `dp[n]`。
2. 初始化长度为 `n+1` 的数组 `dp`，每个位置都为 0。如果 `n=0`，则结果为 0
3. 对数组进行遍历，下标为 `i`，每次都将当前数字先更新为最大的结果，即 `dp[i]=i`。比如 `i=4`，最坏结果为 `4=1+1+1+1`，即为 4 个数字。
4. 动态转移方程为

```
dp[i] = MIN(dp[i], dp[i - j * j] + 1)

i 表示当前数字，j*j 表示平方数
```


复杂度分析
* 时间复杂度：`O(n*sqrt(n))`，`sqrt` 为平方根
* 空间复杂度：`O(n)`



#### Solution


```java
class Solution {
    public int numSquares(int n) {
        int[] dp = new int[n + 1]; // 默认初始化值都为0
        for (int i = 1; i <= n; i++) {
            dp[i] = i; // 最坏的情况就是每次+1
            for (int j = 1; i - j * j >= 0; j++) { 
                dp[i] = Math.min(dp[i], dp[i - j * j] + 1); // 动态转移方程
            }
        }
        return dp[n];
    }
}
```