
# LeetCode Notes-030


[TOC]



## 更新
* 2021/04/12，撰写
* 2021/04/27，完成


## Overview
* [LeetCode-100. 相同的树](https://leetcode-cn.com/problems/same-tree/description/)
* [LeetCode-111. 二叉树的最小深度](https://leetcode-cn.com/problems/minimum-depth-of-binary-tree/)
* [LeetCode-162. 寻找峰值](https://leetcode-cn.com/problems/find-peak-element/description/)
* [LeetCode-27. 移除元素](https://leetcode-cn.com/problems/remove-element/)
* [LeetCode-26. 删除有序数组中的重复项](https://leetcode-cn.com/problems/remove-duplicates-from-sorted-array/description/)




## 100. 相同的树
### Description
* [LeetCode-100. 相同的树](https://leetcode-cn.com/problems/same-tree/description/)

### Approach 1-BFS
#### Analysis

参考 `leetcode-cn` 官方题解。


广度优先遍历树进行判断。

需要注意的是，在判断过程中，需要注意相同的位置一个为null，另一个不为null的情况。此种情况需要排除在外，不然会出现两棵树遍历结果相同，但树不同的情况，如下示例

```json
tree1: [1,null,2]
tree2: [1,2,null]
```

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
    public boolean isSameTree(TreeNode p, TreeNode q) {
        if(null == p && null == q){
            return true;
        }
        if(null == p || null == q){
            return false;
        }
        Queue<TreeNode> queue1 = new LinkedList<>();
        Queue<TreeNode> queue2 = new LinkedList<>();
        queue1.add(p);
        queue2.add(q);
        while(!queue1.isEmpty() && !queue2.isEmpty()){
            TreeNode t1 = queue1.poll();
            TreeNode t2 = queue2.poll();
            if(t1.val != t2.val){
                return false;
            }
            //注意排除1个为null 另一个不为null的情况
            if((null == t1.right && null != t2.right) || (null == t2.right && null != t1.right)){
                return false;
            }
            if((null == t1.left && null != t2.left) || (null == t2.left && null != t1.left)){
                return false;
            }
            if(t1.left != null){
                queue1.add(t1.left);
            }
            if(t1.right != null){
                queue1.add(t1.right);
            }
            if(t2.left != null){
                queue2.add(t2.left);
            }
            if(t2.right != null){
                queue2.add(t2.right);
            }
        }
        if(!queue1.isEmpty() || !queue2.isEmpty()){
            return false;
        }
        return true;
    }
}
```

### Approach 2-DFS
#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution

```java
class Solution {
    public boolean isSameTree(TreeNode p, TreeNode q) {
        return dfs(p,q);
    }
    private boolean dfs(TreeNode p,TreeNode q){
        if(null == p && null == q){
            return true;
        }
        if(null == p || null == q){
            return false;
        }
        if(p.val != q.val){
            return false;
        } 
        return  dfs(p.left,q.left) && dfs(p.right,q.right);
    }
}
```



## 111. 二叉树的最小深度
### Description
* [LeetCode-111. 二叉树的最小深度](https://leetcode-cn.com/problems/minimum-depth-of-binary-tree/)

### Approach 1-深度优先
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java

class Solution {
    public int minDepth(TreeNode root) {
        if(null == root){
            return 0;
        } else if(null == root.left){
            return minDepth(root.right)+1;
        } else if(null == root.right){
            return minDepth(root.left)+1;
        }
        return 1+Math.min(minDepth(root.left),minDepth(root.right));

    }
}
```


```java

class Solution {
    public int minDepth(TreeNode root) {
        if (root == null) {
            return 0;
        }

        if (root.left == null && root.right == null) {
            return 1;
        }

        int min_depth = Integer.MAX_VALUE;
        if (root.left != null) {
            min_depth = Math.min(minDepth(root.left), min_depth);
        }
        if (root.right != null) {
            min_depth = Math.min(minDepth(root.right), min_depth);
        }

        return min_depth + 1;
    }
}
```



### Approach 2-高度优先
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    class QueueNode {
        TreeNode node;
        int depth;

        public QueueNode(TreeNode node, int depth) {
            this.node = node;
            this.depth = depth;
        }
    }

    public int minDepth(TreeNode root) {
        if (root == null) {
            return 0;
        }

        Queue<QueueNode> queue = new LinkedList<QueueNode>();
        queue.offer(new QueueNode(root, 1));
        while (!queue.isEmpty()) {
            QueueNode nodeDepth = queue.poll();
            TreeNode node = nodeDepth.node;
            int depth = nodeDepth.depth;
            if (node.left == null && node.right == null) {
                return depth;
            }
            if (node.left != null) {
                queue.offer(new QueueNode(node.left, depth + 1));
            }
            if (node.right != null) {
                queue.offer(new QueueNode(node.right, depth + 1));
            }
        }

        return 0;
    }
}
```


## 162. 寻找峰值
### Description
* [LeetCode-162. 寻找峰值](https://leetcode-cn.com/problems/find-peak-element/description/)

### Approach 1-寻找最大值
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int findPeakElement(int[] nums) {
        int maxValue = nums[0];
        int result = 0;
        for(int i=1;i<nums.length;i++){
            if(nums[i] > maxValue){
                result = i;
                maxValue = nums[i];
            }
        }
        return result;

    }
}
```

### Approach 2-寻找拐点
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
public class Solution {
    public int findPeakElement(int[] nums) {
        for (int i = 0; i < nums.length - 1; i++) {
            if (nums[i] > nums[i + 1])
                return i;
        }
        return nums.length - 1;
    }
}
```


### Approach 3-二分法
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
public class Solution {
    public int findPeakElement(int[] nums) {
        return search(nums, 0, nums.length - 1);
    }
    public int search(int[] nums, int l, int r) {
        if (l == r)
            return l;
        int mid = (l + r) / 2;
        if (nums[mid] > nums[mid + 1])
            return search(nums, l, mid);
        return search(nums, mid + 1, r);
    }
}
```


## 27. 移除元素
### Description
* [LeetCode-27. 移除元素](https://leetcode-cn.com/problems/remove-element/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int removeElement(int[] nums, int val) {
        int i = 0;
        for (int j = 0; j < nums.length; j++) {
            if (nums[j] != val) {
                nums[i] = nums[j];
                i++;
            }
        }
        return i;
    }
}
```




## 26. 删除有序数组中的重复项
### Description
* [LeetCode-26. 删除有序数组中的重复项](https://leetcode-cn.com/problems/remove-duplicates-from-sorted-array/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int removeDuplicates(int[] nums) {
        int index = 0;
        for(int i=1;i < nums.length;i++){
            if(nums[i] != nums[index]){
                nums[++index] = nums[i];
            }
        }
        return index+1;
    }
}
```
