
# LeetCode Notes-019


[TOC]



## 更新
* 2021/02/19，撰写
* 2021/02/28，完成


## Overview
* [LeetCode-896. 单调数列](https://leetcode-cn.com/problems/monotonic-array/)
* [LeetCode-222. 完全二叉树的节点个数](https://leetcode-cn.com/problems/count-complete-tree-nodes/)
* [LeetCode-1295. 统计位数为偶数的数字](https://leetcode-cn.com/problems/find-numbers-with-even-number-of-digits/)
* [LeetCode-1365. 有多少小于当前数字的数字](https://leetcode-cn.com/problems/how-many-numbers-are-smaller-than-the-current-number/)
* [LeetCode-23. 合并K个升序链表](https://leetcode-cn.com/problems/merge-k-sorted-lists/)







## 896. 单调数列
### Description
* [LeetCode-896. 单调数列](https://leetcode-cn.com/problems/monotonic-array/)

### Approach 1-两次遍历

#### Analysis

本解法不同于官方题解，其思路如下
1. 第1次遍历数组，找到最先出现的不相等的两个元素，判断是递增还是递减。
2. 第2次遍历，若遇到单调情况和步骤1中结果不相符的，直接结束循环，返回 false。
3. 求解过程中，注意对相邻的两个相等元素的处理。


复杂度分析
* 时间复杂度：`O(n)`，其中 n 是数组 A 的长度。
* 空间复杂度：`O(1)`。



#### Solution

```java
class Solution {
    public boolean isMonotonic(int[] A) {
        if(A.length == 1){
            return true;
        }
        int length = A.length;
        int begin = -1;
        boolean descFlag = false;
        for(int i=1;i<length;i++){
            if(A[i-1] == A[i]){
                continue;
            }
            descFlag = A[i-1]-A[i] >=0;
            begin = i;
            break;
        }
        if(begin == length-1 || begin == -1){
            return  true;
        }
        for(int j=begin;j<length;j++){
            if(A[j-1] == A[j]){
                continue;
            }
            boolean flag = A[j-1]-A[j] >=0;
            if(descFlag != flag){
                return false;
            }
        }
        return true;
    }
}
```



### Approach 1-1次遍历

#### Analysis

参考 `leetcode-cn` 官方题解。


遍历数组 A，若既遇到了 `$A[i]>A[i+1]$` 又遇到了 `$A[i']<A[i'+1]$`，则说明 A 既不是单调递增的，也不是单调递减的。


复杂度分析
* 时间复杂度：`O(n)`，其中 n 是数组 A 的长度。
* 空间复杂度：`O(1)`。



#### Solution


```java
class Solution {
    public boolean isMonotonic(int[] A) {
        boolean inc = true, dec = true;
        int n = A.length;
        for (int i = 0; i < n - 1; ++i) {
            if (A[i] > A[i + 1]) {
                inc = false;
            }
            if (A[i] < A[i + 1]) {
                dec = false;
            }
        }
        return inc || dec;
    }
}
```

 

## 222. 完全二叉树的节点个数
### Description
* [LeetCode-222. 完全二叉树的节点个数](https://leetcode-cn.com/problems/count-complete-tree-nodes/)

### Approach 1-递归遍历树

#### Analysis

参考 `leetcode-cn` 官方题解。


对于没有约束的二叉树而言，可以简单粗暴的遍历整个树，是一个普适的解法。

对于此题给的完全二叉树的特点没有利用起来，进一步考虑如何使用完全二叉树的特点更快解出此题。

复杂度分析
* 时间复杂度: `O(n)`
* 空间复杂度: `O(n)`

#### Solution

```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode() {}
 *     TreeNode(int val) { this.val = val; }
 *     TreeNode(int val, TreeNode left, TreeNode right) {
 *         this.val = val;
 *         this.left = left;
 *         this.right = right;
 *     }
 * }
 */
class Solution {
    public int countNodes(TreeNode root) {
        if(null == root){
            return 0;
        }
        return 1 + countNodes(root.left) + countNodes(root.right);
    }
}
```



### Approach 2-完全二叉树性质+二分查找

#### Analysis

参考 `leetcode-cn` 官方题解。


规定根节点位于第 0 层，完全二叉树的最大层数为 h。

当 `0 < i < h` 时，第 `i` 层包含 `2^i-1` 个节点，最底层包含的节点数最少为 1，最多为 `2^h`。


当最底层包含 1 个节点时，完全二叉树的节点个数是

```math
\sum_{i=0}^{h-1}2^i+1=2^h
```

当最底层包含 `$2^h$` 个节点时，完全二叉树的节点个数是

```math
\sum_{i=0}^{h}2^i=2^{h+1}-1
```


因此对于最大层数为 h 的完全二叉树，节点个数一定在 `$[2^h,2^{h+1}-1]$` 的范围内，可以在该范围内通过二分查找的方式得到完全二叉树的节点个数。

具体做法是，根据节点个数范围的上下界得到当前需要判断的节点个数 k，如果第 k 个节点存在，则节点个数一定大于或等于 k，如果第 k 个节点不存在，则节点个数一定小于 k，由此可以将查找的范围缩小一半，直到得到节点个数。


如何判断第 k 个节点是否存在呢？
* **如果第 k 个节点位于第 h 层，则 k 的二进制表示包含 `h+1` 位，其中最高位是 1，其余各位从高到低表示从根节点到第 k 个节点的路径，0 表示移动到左子节点，1 表示移动到右子节点。**
* 通过位运算得到第 k 个节点对应的路径，判断该路径对应的节点是否存在，即可判断第 k 个节点是否存在。






复杂度分析
* 时间复杂度：`$O(\log^2 n)$`，其中 n 是完全二叉树的节点数。
首先需要 `O(h)` 的时间得到完全二叉树的最大层数，其中 `h` 是完全二叉树的最大层数。使用二分查找确定节点个数时，需要查找的次数为 `$O(\log 2^h)=O(h)$`，每次查找需要遍历从根节点开始的一条长度为 h 的路径，需要 `O(h)` 的时间，因此二分查找的总时间复杂度是 `$O(h^2)$`。因此总时间复杂度是 `$O(h^2)$`。由于完全二叉树满足 `$2^h \le n < 2^{h+1}$`，因此有 `$O(h)=O(\log n)O(h)=O(logn)，O(h^2)=O(\log^2 n)$`。
* 空间复杂度：`O(1)`。只需要维护有限的额外空间。


#### Solution


```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode() {}
 *     TreeNode(int val) { this.val = val; }
 *     TreeNode(int val, TreeNode left, TreeNode right) {
 *         this.val = val;
 *         this.left = left;
 *         this.right = right;
 *     }
 * }
 */
class Solution {
    public int countNodes(TreeNode root) {
        if(root ==  null){
            return 0;
        }
        int level = 0;
        TreeNode node  = root;
        while(node.left != null){
            level++;
            node = node.left;
        } 
        // 对于最大层数为 h 的完全二叉树，节点个数一定在 [2^h,2^{h+1}-1]区间内
        int low = 1 << level, high = (1 << (level + 1)) - 1;
        //二分查找
        while (low <= high) {
            int mid = (high - low) / 2 + low;
            if (exists(root, level, mid)) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
        return low-1; //最后一次循环 执行了mid+1 因此此处需要减去1
    }

    public boolean exists(TreeNode root, int level, int k) {
        // 倒数第2层 节点索引最大值为 2^(层高-1)
        int bits = 1 << (level - 1);
        TreeNode node = root;
        while (node != null && bits > 0) {
            // 如果第 k 个节点位于第 h 层，则 k 的二进制表示包含 h+1 位
            // 其中最高位是 1，其余各位从高到低表示从根节点到第 k 个节点的路径，0 表示移动到左子节点，1 表示移动到右子节点
            if ((bits & k) == 0) {
                node = node.left;
            } else {
                node = node.right;
            }
            bits >>= 1;
        }
        return node != null;
    }
}
```



## 1295. 统计位数为偶数的数字
### Description
* [LeetCode-1295. 统计位数为偶数的数字](https://leetcode-cn.com/problems/find-numbers-with-even-number-of-digits/)

### Approach 1-暴力

#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(n*k)`，`k` 为数字的平均长度
* 空间复杂度： `O(1)`


#### Solution


```java
class Solution {
    public int findNumbers(int[] nums) {
        int count = 0;
        for(int i=0;i<nums.length;i++){
            if(getBitNum(nums[i])%2 == 0){
                count++;
            }
        }
        return count;
    }
    public int getBitNum(int val){
        int res = 0;
        if(val == 0) return 1;
        while(val >0){
            res++;
            val = val/10;
        }
        return res;
    }
}

```


### Approach 2-将数字转为字符串

#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(n)`，，其中 n 是数组 nums 的长度。这里假设将整数转换为字符串的时间复杂度为 `O(1)`。
* 空间复杂度： `O(1)`



#### Solution


```java
class Solution {
    public int findNumbers(int[] nums) {
        int count = 0;
        for(int i=0;i<nums.length;i++){
            if(Integer.toString(nums[i]).length()%2 == 0){
                count++;
            }
        }
        return count;
    }
}
```


### Approach 3-对数运算

#### Analysis

参考 `leetcode-cn` 官方题解。



我们也可以使用语言内置的以 10 为底的对数函数 `log10()` 来得到整数 `x` 包含的数字个数。

一个包含 `k` 个数字的整数 `x` 满足不等式 `$10^{k-1} \leq x < 10^k$`。将不等式取对数，得到 `$k - 1 \leq \log_{10}(x) < k$`，因此我们可以用 `$k = \lfloor\log_{10}(x) + 1\rfloor$` 得到 x 包含的数字个数 `k`，其中 `$\lfloor a \rfloor$` 表示将 a 进行下取整，例如 `$\lfloor 5.2 \rfloor = 5$`。




复杂度分析
* 时间复杂度：`O(n)`，，其中 n 是数组 nums 的长度。
* 空间复杂度： `O(1)`



#### Solution

```java
class Solution {
    public int findNumbers(int[] nums) {
        int count = 0;
        for(int i=0;i<nums.length;i++){
            if((int)(1+Math.log10(nums[i]))%2 == 0){
                count++;
            }
        }
        return count;
    }
}
```





## 1365. 有多少小于当前数字的数字
### Description
* [LeetCode-1365. 有多少小于当前数字的数字](https://leetcode-cn.com/problems/how-many-numbers-are-smaller-than-the-current-number/)

### Approach 1-计数排序-前缀和

#### Analysis

参考 `leetcode-cn` 官方题解。


注意到数组元素的值域为 `[0,100]`，所以可以考虑建立一个频次数组 `cnt` ，`cnt[i]` 表示数字 i 出现的次数。那么对于数字 i 而言，小于它的数目就为 `cnt[0...i−1]` 的总和。


复杂度分析
* 时间复杂度：`O(N+K)`，其中 `K` 为值域大小。需要遍历两次原数组，同时遍历一次频次数组 `cnt` 找出前缀和。
* 空间复杂度：`O(K)`。因为要额外开辟一个值域大小的数组。



#### Solution

```java
class Solution {
    public int[] smallerNumbersThanCurrent(int[] nums) {
        int[] cnt = new int[101];
        int n = nums.length;
        for(int i=0;i<n;i++){
            cnt[nums[i]]++;
        }
        for(int i=1;i<=100;i++){
            cnt[i] += cnt[i-1];
        }
        int[] res = new int[n];
        for(int i=0;i<n;i++){
            res[i] = nums[i] == 0 ? 0:cnt[nums[i]-1];
        }
        return res;
    }
}
```



### Approach 2-暴力

#### Analysis

参考 `leetcode-cn` 官方题解。



复杂度分析
* 时间复杂度：`O(N^2)`。
* 空间复杂度：`O(1)`。注意我们不计算答案数组的空间占用。



#### Solution


```java
class Solution {
    public int[] smallerNumbersThanCurrent(int[] nums) {
        int n = nums.length;
        int[] ret = new int[n];
        for (int i = 0; i < n; i++) {
            int cnt = 0;
            for (int j = 0; j < n; j++) {
                if (nums[j] < nums[i]) {
                    cnt++;
                }
            }
            ret[i] = cnt;
        }
        return ret;
    }
}
```



## 23. 合并K个升序链表
### Description
* [LeetCode-23. 合并K个升序链表](https://leetcode-cn.com/problems/merge-k-sorted-lists/)

### Approach 1-归并+顺序合并

#### Analysis

参考 `leetcode-cn` 官方题解。


借鉴归并排序中“并”的实现，采用最朴素的方法，顺序合并，用一个变量 `ans` 来维护以及合并的链表，第 `i` 次循环把第 `i` 个链表和 `ans` 合并，答案保存到 `ans` 中。

在合并过程中，对于链表，注意前置头节点的使用。


复杂度分析
* 时间复杂度：假设每个链表的最长长度是 `n`。在第一次合并后，`ans` 的长度为 `n`；第二次合并后，`ans` 的长度为`2×n`，第 `i` 次合并后，`ans` 的长度为 `i×n`。第 `i` 次合并的时间代价是 `O(n+(i−1)×n)=O(i*n)`，那么总的时间代价为 `$O(\sum_{i = 1}^{k} (i \times n)) = O(\frac{(1 + k)\cdot k}{2} \times n) = O(k^2 n)$`，故渐进时间复杂度为 `$O(k^2n)$`。
* 空间复杂度：没有用到与 k 和 n 规模相关的辅助空间，故渐进空间复杂度为 `O(1)`。





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
    public ListNode mergeKLists(ListNode[] lists) {
        ListNode ans = null;
        for(int i=0;i<lists.length;i++){
            ans = mergeTwoLists(ans,lists[i]);
        }
        return ans;
    }
    public ListNode mergeTwoLists(ListNode a,ListNode b){
        if(null == a || null == b){
            return null == a ? b:a;
        }
        ListNode preHead = new ListNode(0); //前置头节点
        ListNode cur = preHead; //游标
        ListNode index1 = a; //指针1
        ListNode index2 = b; //指针2
        while(null != index1 && null != index2){
            if(index1.val <= index2.val){
                cur.next = index1;
                index1 = index1.next;
            } else{
                cur.next = index2;
                index2 = index2.next;
            }
            cur = cur.next;
        }
        //剩余部分
        cur.next = (index1 != null ? index1 : index2);
        return preHead.next;
    }
}
```


## Approach 2-归并+分治

#### Analysis

参考 `leetcode-cn` 官方题解。


考虑优化方法一，用分治的方法进行合并。
* 将 k 个链表配对并将同一对中的链表合并；
* 第一轮合并以后， k 个链表被合并成了 `$\frac{k}{2}$` 个链表，平均长度为 `$\frac{2n}{k}$`，然后是 `$\frac{k}{4}$` 等等；
* 重复这一过程，直到我们得到了最终的有序链表。



复杂度分析
* 时间复杂度：考虑递归「向上回升」的过程 —— 第一轮合并 `$\frac{k}{2}$` 组链表，每一组的时间代价是 `O(2n)`；第二轮合并 `$\frac{k}{4}$` 组链表，每一组的时间代价是 `O(4n)`......所以总的时间代价是 `$O(\sum_{i = 1}^{\infty} \frac{k}{2^i} \times 2^i n) = O(kn \times \log k)$`，故渐进时间复杂度为 `$O(kn \times \log k)$`。
* 空间复杂度：递归会使用到 `$O(\log k)$` 空间代价的栈空间。


#### Solution



```java
class Solution {
    public ListNode mergeKLists(ListNode[] lists) {
        return merge(lists,0,lists.length-1);
    }

    public ListNode merge(ListNode[] lists,int l,int r){
        if(l == r){
            return lists[l];
        }
        if(l > r){
            return null;
        }
        int mid = l + (r - l) / 2;
        return mergeTwoLists(merge(lists,l,mid),merge(lists,mid+1,r)); //递归
    }

    public ListNode mergeTwoLists(ListNode a,ListNode b){
        if(null == a || null == b){
            return null == a ? b:a;
        }
        ListNode preHead = new ListNode(0); //前置头节点
        ListNode cur = preHead; //游标
        ListNode index1 = a; //指针1
        ListNode index2 = b; //指针2
        while(null != index1 && null != index2){
            if(index1.val <= index2.val){
                cur.next = index1;
                index1 = index1.next;
            } else{
                cur.next = index2;
                index2 = index2.next;
            }
            cur = cur.next;
        }
        //剩余部分
        cur.next = (index1 != null ? index1 : index2);
        return preHead.next;
    }
}
```




## Approach 3-小根堆（优先级队列）

#### Analysis

参考 `leetcode-cn` 官方题解。

采用优先级队列，基于小根堆的性质求解，步骤如下
1. 初始化，将各个链表头部加入小根堆；
2. 将当前堆中头节点 `cur` 加入答案（小根堆的性质保证了堆中头节点一定是最小的），如果这个节点后面还有，就 `push cur.Next`;
3. 不断增长直到堆空（链表用完）



复杂度分析
* 时间复杂度：考虑优先队列中的元素不超过 k 个，那么插入和删除的时间代价为 `O(logk)`，这里最多有 kn 个点，对于每个点都被插入删除各一次，故总的时间代价即渐进时间复杂度为 `O(kn×logk)`。
* 空间复杂度：这里用了优先队列，优先队列中的元素不超过 k 个，故渐进空间复杂度为 `O(k)`。


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
    public ListNode mergeKLists(ListNode[] lists) {
        if (lists == null || lists.length == 0) {
            return null;
        }
        //创建一个堆，并设置元素的排序方式
        PriorityQueue<ListNode> queue = new PriorityQueue(new Comparator<ListNode>() {
            @Override
            public int compare(ListNode o1, ListNode o2) {
                return (o1.val - o2.val);
            }
        });
        //遍历链表数组，然后将每个链表的每个节点都放入堆中
        for (int i = 0; i < lists.length; i++) {
            while (lists[i] != null) {
                queue.add(lists[i]);
                lists[i] = lists[i].next;
            }
        }
        ListNode dummy = new ListNode(-1);
        ListNode head = dummy;
        //从堆中不断取出元素，并将取出的元素串联起来
        while (!queue.isEmpty()) {
            dummy.next = queue.poll();
            dummy = dummy.next;
        }
        dummy.next = null;
        return head.next;
    }
}
```

注意代码中的 `dummy.next = null;` 语句，需要针对输入的链表为 null 的情况进行处理。对应的测试用例为

```
[[-2,-1,-1,-1],[]]
```


此外，对于代码

```java
//创建一个堆，并设置元素的排序方式
PriorityQueue<ListNode> queue = new PriorityQueue(new Comparator<ListNode>() {
    @Override
    public int compare(ListNode o1, ListNode o2) {
        return (o1.val - o2.val);
    }
});
```


可以使用 Lambda表达式优化至如下。


```java
//创建一个堆，并设置元素的排序方式
PriorityQueue<ListNode> queue2 = new PriorityQueue((Comparator<ListNode>) (o1, o2) -> (o1.val - o2.val));
```