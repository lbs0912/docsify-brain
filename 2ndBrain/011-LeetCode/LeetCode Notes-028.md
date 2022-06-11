

# LeetCode Notes-028


[TOC]



## 更新
* 2021/03/20，撰写
* 2021/03/21，完成


## Overview
* [LeetCode-5709. 最大升序子数组和](https://leetcode-cn.com/problems/maximum-ascending-subarray-sum/)
* [LeetCode-234. 回文链表](https://leetcode-cn.com/problems/palindrome-linked-list/solution/hui-wen-lian-biao-by-leetcode-solution/)
* [LeetCode-73. 矩阵置零](https://leetcode-cn.com/problems/set-matrix-zeroes/)
* [LeetCode-92. 反转链表 II](https://leetcode-cn.com/problems/reverse-linked-list-ii/)
* [LeetCode-3. 无重复字符的最长子串](https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/)




## 5709. 最大升序子数组和
### Description
* [LeetCode-5709. 最大升序子数组和](https://leetcode-cn.com/problems/maximum-ascending-subarray-sum/)

### Approach 1-滑动窗口
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution



```java
class Solution {
    public int maxAscendingSum(int[] nums) {
        if(nums.length < 2){
            return nums[0];
        }
        int maxSum = nums[0];
        int preSum = maxSum;
        for(int i=1;i<nums.length;i++){
            if(nums[i] > nums[i-1]){
                preSum += nums[i];
            } else {
                preSum = nums[i];
            }
            maxSum = Math.max(maxSum,preSum);
        }
        return maxSum;

    }
}
```



## 234. 回文链表
### Description
* [LeetCode-234. 回文链表](https://leetcode-cn.com/problems/palindrome-linked-list/solution/hui-wen-lian-biao-by-leetcode-solution/)

### Approach 1-数组+双指针
#### Analysis

参考 `leetcode-cn` 官方题解。

一共为两个步骤
1. 复制链表值到数组列表中。
2. 使用双指针法判断是否为回文。

#### Solution


```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
class Solution {
    public boolean isPalindrome(ListNode head) {
        List<Integer> list = new ArrayList<>();
        while(head != null){
            list.add(head.val);
            head = head.next;
        }
        int left = 0;
        int right =  list.size()-1;
        while(left <= right){
            if(list.get(left++) != list.get(right--)){
                return false;
            }
        }
        return true;

    }
}
```



## 73. 矩阵置零
### Description
* [LeetCode-73. 矩阵置零](https://leetcode-cn.com/problems/set-matrix-zeroes/)

### Approach 1-空间复杂度O(m+n)
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution

```java
class Solution {
    public void setZeroes(int[][] matrix) {
        int m = matrix.length;
        int n = matrix[0].length;
        int[] rows = new int[m];
        int[] columns = new int[n];
        for(int i=0;i<m;i++){
            for(int j=0;j<n;j++){
                if(matrix[i][j] == 0){
                    rows[i] = 1;
                    columns[j] = 1;
                }
            }
        }
        //处理
        for(int i=0;i<m;i++){
            if(rows[i] == 1){
                for(int j=0;j<n;j++){
                    matrix[i][j] = 0;
                }
            }
        }
        //处理
        for(int j=0;j<n;j++){
            if(columns[j] == 1){
                for(int i=0;i<m;i++){
                    matrix[i][j] = 0;
                }
            }
        }
    }
}
```

需要注意的是，上述代码中的处理部分，可以合并到一起，如下所示


```java
class Solution {
    public void setZeroes(int[][] matrix) {
        int m = matrix.length, n = matrix[0].length;
        boolean[] row = new boolean[m];
        boolean[] col = new boolean[n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (matrix[i][j] == 0) {
                    row[i] = col[j] = true;
                }
            }
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (row[i] || col[j]) {
                    matrix[i][j] = 0;
                }
            }
        }
    }
}
```

### Approach 2-空间复杂度O(1)
#### Analysis

参考 `leetcode-cn` 官方题解。

我们可以用矩阵的第一行和第一列代替方法一中的两个标记数组，以达到 `O(1)` 的额外空间。但这样会导致原数组的第一行和第一列被修改，无法记录它们是否原本包含 0。因此我们需要额外使用两个标记变量分别记录第一行和第一列是否原本包含 0。

#### Solution

```java
class Solution {
    public void setZeroes(int[][] matrix) {
        int m = matrix.length, n = matrix[0].length;
        boolean flagCol0 = false, flagRow0 = false;
        for (int i = 0; i < m; i++) {
            if (matrix[i][0] == 0) {
                flagCol0 = true;
            }
        }
        for (int j = 0; j < n; j++) {
            if (matrix[0][j] == 0) {
                flagRow0 = true;
            }
        }
        for (int i = 1; i < m; i++) {
            for (int j = 1; j < n; j++) {
                if (matrix[i][j] == 0) {
                    matrix[i][0] = matrix[0][j] = 0;
                }
            }
        }
        for (int i = 1; i < m; i++) {
            for (int j = 1; j < n; j++) {
                if (matrix[i][0] == 0 || matrix[0][j] == 0) {
                    matrix[i][j] = 0;
                }
            }
        }
        if (flagCol0) {
            for (int i = 0; i < m; i++) {
                matrix[i][0] = 0;
            }
        }
        if (flagRow0) {
            for (int j = 0; j < n; j++) {
                matrix[0][j] = 0;
            }
        }
    }
}

```



## 92. 反转链表 II
### Description
* [LeetCode-92. 反转链表 II](https://leetcode-cn.com/problems/reverse-linked-list-ii/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution



```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode() {}
 *     ListNode(int val) { this.val = val; }
 *     ListNode(int val, ListNode next) { this.val = val; this.next = next; }
 * }
 */
class Solution {
    public ListNode reverseBetween(ListNode head, int left, int right) {
        // 因为头节点有可能发生变化，使用虚拟头节点可以避免复杂的分类讨论
        ListNode dummyNode = new ListNode(-1);
        dummyNode.next = head;

        ListNode pre = dummyNode;
        // 第 1 步：从虚拟头节点走 left - 1 步，来到 left 节点的前一个节点
        // 建议写在 for 循环里，语义清晰
        for (int i = 0; i < left - 1; i++) {
            pre = pre.next;
        }

        // 第 2 步：从 pre 再走 right - left + 1 步，来到 right 节点
        ListNode rightNode = pre;
        for (int i = 0; i < right - left + 1; i++) {
            rightNode = rightNode.next;
        }

        // 第 3 步：切断出一个子链表（截取链表）
        ListNode leftNode = pre.next;
        ListNode curr = rightNode.next;

        // 注意：切断链接
        pre.next = null;
        rightNode.next = null;

        // 第 4 步：同第 206 题，反转链表的子区间
        reverseLinkedList(leftNode);

        // 第 5 步：接回到原来的链表中
        pre.next = rightNode;
        leftNode.next = curr;
        return dummyNode.next;
    }

    private void reverseLinkedList(ListNode head) {
        // 也可以使用递归反转一个链表
        ListNode pre = null;
        ListNode cur = head;

        while (cur != null) {
            ListNode next = cur.next;
            cur.next = pre;
            pre = cur;
            cur = next;
        }
    }
}
```


## 3. 无重复字符的最长子串
### Description
* [LeetCode-3. 无重复字符的最长子串](https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/)

### Approach 1-滑动窗口
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(N)`，其中 N 是字符串的长度。左指针和右指针分别会遍历整个字符串一次。
* 空间复杂度：`O(∣Σ∣)`，其中 `Σ` 表示字符集（即字符串中可以出现的字符），`∣Σ∣` 表示字符集的大小。在本题中没有明确说明字符集，因此可以默认为所有 ASCII 码在 `[0, 128)` 内的字符，即 `∣Σ∣ = 128`。


#### Solution


```java
class Solution {
    public int lengthOfLongestSubstring(String s) {
        Set<Character> set  = new HashSet<>();
        int left = 0;
        int right = 0;
        int maxCount = 0;
        for(int i=0;i<s.length();i++){
            char c = s.charAt(i);
            while(set.contains(c)){
                set.remove(s.charAt(left));
                left++;
            }
            set.add(c);
            maxCount = Math.max(maxCount,i - left + 1);
        }
        return maxCount;
    }
}
```