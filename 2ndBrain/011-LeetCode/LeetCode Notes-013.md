
# LeetCode Notes-013


[TOC]


## 更新
* 2020/11/07，撰写
* 2020/11/12，完成


## Overview
* [LeetCode-面试题 17.10. 主要元素](https://leetcode-cn.com/problems/find-majority-element-lcci/submissions/)
* [LeetCode-1470. 重新排列数组](https://leetcode-cn.com/problems/shuffle-the-array/)
* [LeetCode-160. 相交链表](https://leetcode-cn.com/problems/intersection-of-two-linked-lists/)
* [LeetCode-剑指 Offer 52. 两个链表的第一个公共节点](https://leetcode-cn.com/problems/liang-ge-lian-biao-de-di-yi-ge-gong-gong-jie-dian-lcof/)
* [LeetCode-226. 翻转二叉树](https://leetcode-cn.com/problems/invert-binary-tree/)
* [LeetCode-283. 移动零](https://leetcode-cn.com/problems/move-zeroes/)







## 面试题 17.10. 主要元素
### Description
* [LeetCode-面试题 17.10. 主要元素](https://leetcode-cn.com/problems/find-majority-element-lcci/submissions/)

### Approach 1-HashMap


#### Analysis

使用 `HashMap` 解决问题，复杂度分析如下
* 时间复杂度：`O(n)`
* 空间复杂度：`O(n)`


#### Solution

* Java

```java
class Solution {
    public int majorityElement(int[] nums) {
        int length = nums.length;
        Map<Integer,Integer> map = new HashMap<>();
        for(int i=0;i<nums.length;i++){
            map.put(nums[i],1+map.getOrDefault(nums[i],0));
        }
        for(Map.Entry<Integer,Integer> entry : map.entrySet()){
            if(entry.getValue() > length/2){
                return entry.getKey();
            }
        }
        return -1;
    }
}
```





### Approach 2-摩尔投票法



#### Analysis

设置一个众数 `major`，一个计数器 `cnt`，初始时 `major` 任意值，`cnt=0`
* 从下标 0 开始枚举数组，如果 `cnt=0`，`major=nums[i]`
* 如果 `cnt!=0`，若 `nums[i] == major`，`cnt++`，否则 `cnt--`
* 继续循环，循环结束后如果 `cnt<=0`，则不存在众数。如果 `cnt>0`，要进行一轮数组遍历，判断 `major` 是否为众数。




复杂度分析如下
* 时间复杂度：`O(n)`
* 空间复杂度：`O(1)`


#### Solution

* Java


```java
class Solution {
    public int majorityElement(int[] nums) {
        // 摩尔投票算法
        int major = 0;
        int cnt = 0;
        for(int value : nums){
            if(0 == cnt){
                major = value;
                cnt++;
            } else {
                if(value == major){
                    cnt++;
                } else {
                    cnt--;
                }
            }
        }
        if(cnt>0){
            int total = 0;
            for(int value : nums){
                if(value == major){
                    total++;
                }
            }
            if(total > nums.length/2){
                return major;
            }
        }
        return -1;
    }
}
```

## 1470. 重新排列数组
### Description
* [LeetCode-1470. 重新排列数组](https://leetcode-cn.com/problems/shuffle-the-array/)

### Approach 1-基本法

#### Analysis


基本方法解决，复杂度分析如下
* 时间复杂度：`O(n)`
* 空间复杂度：`O(n)`

#### Solution

* Java

```java
class Solution {
    public int[] shuffle(int[] nums, int n) {
        int[] arr = new int[2*n];
        int j=0;
        for(int i=0;i<n;i++){
            arr[j++] = nums[i];
            arr[j++] = nums[i+n];
        }
        return arr;
    }
}
```




### Approach 2-O(1)优化-1

#### Analysis


参考 `leetcode-cn` 官方题解。


因为题目限制了每一个元素 `nums[i]` 最大只有可能是 1000，这就意味着每一个元素只占据了 10 个 bit。（`2^10 - 1 = 1023 > 1000`）

**而一个 int 有 32 个 bit，所以我们还可以使用剩下的 22 个 bit 做存储。实际上，每个 int，我们再借 10 个 bit 用就好了。**

**因此，在下面的代码中，每一个 `nums[i]` 的最低的十个 bit（0-9 位），我们用来存储原来 nums[i] 的数字；再往前的十个 bit（10-19 位），我们用来存储重新排列后正确的数字是什么。**

在循环中，我们每次首先计算 `nums[i]` 对应的重新排列后的索引 j，之后，取 `nums[i]` 的低 10 位（`nums[i] & 1023`），即 `nums[i]` 的原始信息，把它放到 `nums[j]` 的高十位上。

最后，每个元素都取高 10 位的信息(`e >> 10`)，即是答案。




基本方法解决，复杂度分析如下
* 时间复杂度：`O(n)`
* 空间复杂度：`O(1)`

#### Solution


* Java


```java
class Solution {
    public int[] shuffle(int[] nums, int n) {
        int j=0;
        for(int i=0;i<n;i++){
            nums[j++] |= (nums[i] & 1023) << 10;
            nums[j++] |= (nums[i+n] & 1023) << 10;
        }
        for(int i=0;i<2*n;i++){
            nums[i] = nums[i] >> 10; 
        }
        return nums;
    }
}
```



## 160. 相交链表
### Description
* [LeetCode-160. 相交链表](https://leetcode-cn.com/problems/intersection-of-two-linked-lists/)




### Approach 1-哈希表

#### Analysis

参考 `leetcode-cn` 官方题解。


使用哈希表存储一条链表的访问路径。

复杂度分析
* 时间复杂度 : `O(m+n)`
* 空间复杂度 : `O(Math.min(m,n))`

#### Solution


```java
public class Solution {
    public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
        Set<ListNode> visited = new HashSet<ListNode>();
        ListNode temp = headA;
        while (temp != null) {
            visited.add(temp);
            temp = temp.next;
        }
        temp = headB;
        while (temp != null) {
            if (visited.contains(temp)) {
                return temp;
            }
            temp = temp.next;
        }
        return null;
    }
}
```



### Approach 2-双指针

#### Analysis

创建两个指针 `pA` 和 `pB`，分别初始化为链表 A 和 B 的头结点，然后让它们向后逐结点遍历。
* 当 `pA` 到达链表的尾部时，将它重定位到链表 B 的头结点; 类似的，当 `pB` 到达链表的尾部时，将它重定位到链表 A 的头结点。
* 若在某一时刻 `pA` 和 `pB` 相遇，则 `pA/pB` 为相交结点。


想弄清楚为什么这样可行, 可以考虑以下两个链表: `A={1,3,5,7,9,11}` 和 `B={2,4,9,11}`，相交于结点 9。 由于 `B.length (=4) < A.length (=6)`，`pB` 比 `pA` 少经过 2 个结点，会先到达尾部。将 `pB` 重定向到 A 的头结点，`pA` 重定向到 B 的头结点后，`pB` 要比 `pA` 多走 2 个结点。因此，它们会同时到达交点。

如果两个链表存在相交，它们末尾的结点必然相同。因此当 `pA/pB` 到达链表结尾时，记录下链表 A/B 对应的元素。若最后元素不相同，则两个链表不相交。




复杂度分析
* 时间复杂度 : `O(m+n)`
* 空间复杂度 : `O(1)`

#### Solution

* Java

```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) {
 *         val = x;
 *         next = null;
 *     }
 * }
 */
public class Solution {
    public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
        if(null == headA || null == headB){
            return null;
        }
        ListNode pA = headA;
        ListNode pB = headB;
        while(pA != pB){
            pA = (null == pA)? headB : pA.next;
            pB = (null == pB)? headA : pB.next;
        }
        return pA;
    }
}
```



## 剑指 Offer 52. 两个链表的第一个公共节点
### Description
* [LeetCode-剑指 Offer 52. 两个链表的第一个公共节点](https://leetcode-cn.com/problems/liang-ge-lian-biao-de-di-yi-ge-gong-gong-jie-dian-lcof/)




### Approach 1-常规

#### Analysis

参考 `leetcode-cn` 官方题解。


本题同 「LeetCode-160. 相交链表」，此处不再赘叙。



#### Solution



## 226. 翻转二叉树
### Description

* [LeetCode-226. 翻转二叉树](https://leetcode-cn.com/problems/invert-binary-tree/)



### Approach 1-递归


#### Analysis

从根节点开始，递归地对树进行遍历，并从叶子结点先开始翻转。

复杂度分析
* 时间复杂度：`O(N)`，其中 `N` 为二叉树节点的数目。我们会遍历二叉树中的每一个节点，对每个节点而言，我们在常数时间内交换其两棵子树。
* 空间复杂度：`O(N)`。使用的空间由递归栈的深度决定，它等于当前节点在二叉树中的高度。在平均情况下，二叉树的高度与节点个数为对数关系，即 `O(logN)`。而在最坏情况下，树形成链状，空间复杂度为 `O(N)`。


#### Solution

* Java

```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
class Solution {
    public TreeNode invertTree(TreeNode root) {
        if(root == null){
            return root;
        }
        TreeNode left = invertTree(root.left);
        TreeNode right = invertTree(root.right);
        root.left = right;
        root.right = left;
        return root;
    }
}
```


### Approach 2-迭代


#### Analysis


递归实现也就是深度优先遍历的方式，那么迭代方案中对应的就是广度优先遍历。


**广度优先遍历需要额外的数据结构--队列，来存放临时遍历到的元素。**

深度优先遍历的特点是一竿子插到底，不行了再退回来继续；而广度优先遍历的特点是层层扫荡。
所以，我们需要先将根节点放入到队列中，然后不断的迭代队列中的元素。
对当前元素调换其左右子树的位置，然后：
* 判断其左子树是否为空，不为空就放入队列中
* 判断其右子树是否为空，不为空就放入队列中

复杂度分析
* 时间复杂度：`O(N)`，其中 `N` 为二叉树节点的数目。每个节点都需要入队列/出队列一次。
* 空间复杂度：`O(N)`。使用的空间由递归栈的深度决定，它等于当前节点在二叉树中的高度。在平均情况下，二叉树的高度与节点个数为对数关系，即 `O(logN)`。而在最坏情况下，树形成链状，空间复杂度为 `O(N)`。


#### Solution


* Java


```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
class Solution {
    public TreeNode invertTree(TreeNode root) {
        if(root == null){
            return root;
        }
        //将二叉树中的节点逐层放入队列中，再迭代处理队列中的元素
        LinkedList<TreeNode> queue = new LinkedList<TreeNode>();
        queue.add(root);
        while(!queue.isEmpty()){
            //每次都从队列中拿一个节点，并交换这个节点的左右子树
			TreeNode tmp = queue.poll();
			TreeNode left = tmp.left;
			tmp.left = tmp.right;
			tmp.right = left;

            //如果当前节点的左子树不为空，则放入队列等待后续处理
			if(tmp.left!=null) {
				queue.add(tmp.left);
			}
			//如果当前节点的右子树不为空，则放入队列等待后续处理
			if(tmp.right!=null) {
				queue.add(tmp.right);
			}
        }
        return root;
    }
}
```

## 283. 移动零
### Description

* [LeetCode-283. 移动零](https://leetcode-cn.com/problems/move-zeroes/)



### Approach 1-快排+双指针(1次遍历)


#### Analysis

参考快速排序的思想解决问题。快速排序中，首先要确定一个待分割的元素做中间点 `x`，然后把所有小于等于 `x` 的元素放到 `x` 的左边，大于 `x` 的元素放到其右边。

这里我们可以用 `0` 当做这个中间点，把不等于 0 的放到中间点的左边，等于 0 的放到其右边。

我们使用两个指针 `i` 和 `j`，指针 `i` 记录当前遍历数组的位置，指针 `j` 记录数组中第一个 0 元素的位置。只要 `nums[i]!=0`，我们就交换 `nums[i]` 和 `nums[j]`。


复杂度分析
* 时间复杂度：`O(n)`
* 空间复杂度：`O(1)`


#### Solution

* Java

```java
class Solution {
    public void moveZeroes(int[] nums) {
        if(null == nums || nums.length == 0){
            return;
        }
        int j=0;
        for(int i=0;i<nums.length;i++){
            //当前元素不等于0 将其交换到左边，元素0交换到右边
            if(nums[i] != 0){
                int tmp = nums[i];
                nums[i] = nums[j];
                nums[j] = tmp;
                j++;
            }
        }
    }
}
```


### Approach 2-双指针(2次遍历)


#### Analysis

创建两个指针 `i` 和 `j`。第 1 次遍历的时候，指针 `j` 用来记录当前有多少非 0 元素。即遍历的时候每遇到一个非 0 元素就将其往数组左边挪，第一次遍历完后，`j` 指针的下标就指向了最后一个非 0 元素下标。

第 2 次遍历的时候，起始位置就从 `j` 开始到结束，将剩下的这段区域内的元素全部置为 0。




#### Solution

* Java


```java
class Solution {
    public void moveZeroes(int[] nums) {
        if(null == nums || nums.length == 0){
            return;
        }
        int j=0;
        for(int i=0;i<nums.length;i++){
            if(nums[i] != 0){
                nums[j++] = nums[i];
            }
        }
        for(int k=j;k<nums.length;k++){
            nums[k] = 0;
        }
    }
}
```