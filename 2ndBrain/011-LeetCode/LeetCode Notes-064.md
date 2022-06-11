
# LeetCode Notes-064


[TOC]



## 更新
* 2021/08/30，撰写
* 2021/09/01，完成



## Overview

* [LeetCode-108. 将有序数组转换为二叉搜索树](https://leetcode-cn.com/problems/convert-sorted-array-to-binary-search-tree/description/)
* [LeetCode-110. 平衡二叉树](https://leetcode-cn.com/problems/balanced-binary-tree/description/)
* [LeetCode-109. 有序链表转换二叉搜索树](https://leetcode-cn.com/problems/convert-sorted-list-to-binary-search-tree/)
* [LeetCode-1382. 将二叉搜索树变平衡](https://leetcode-cn.com/problems/balance-a-binary-search-tree/)
* [LeetCode-728. 自除数](https://leetcode-cn.com/problems/self-dividing-numbers/description/)


## 【经典好题】108. 将有序数组转换为二叉搜索树
### Description
* [LeetCode-108. 将有序数组转换为二叉搜索树](https://leetcode-cn.com/problems/convert-sorted-array-to-binary-search-tree/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

* [二叉查找树 | BST](https://www.cnblogs.com/gaochundong/p/binary_search_tree.html)



**二叉搜索树的中序遍历是升序序列，题目给定的数组是按照升序排序的有序数组，因此可以确保数组是二叉搜索树的中序遍历序列。**

给定二叉搜索树的中序遍历，是否可以唯一地确定二叉搜索树？答案是否定的。如果没有要求二叉搜索树的高度平衡，则任何一个数字都可以作为二叉搜索树的根节点，因此可能的二叉搜索树有多个。



如果增加一个限制条件，即要求二叉搜索树的高度平衡，是否可以唯一地确定二叉搜索树？答案仍然是否定的。


**直观地看，我们可以选择中间数字作为二叉搜索树的根节点，这样分给左右子树的数字个数相同或只相差 1，可以使得树保持平衡。如果数组长度是奇数，则根节点的选择是唯一的，如果数组长度是偶数，则可以选择中间位置左边的数字作为根节点或者选择中间位置右边的数字作为根节点，选择不同的数字作为根节点则创建的平衡二叉搜索树也是不同的。**



**确定平衡二叉搜索树的根节点之后，其余的数字分别位于平衡二叉搜索树的左子树和右子树中，左子树和右子树分别也是平衡二叉搜索树，因此可以通过递归的方式创建平衡二叉搜索树。**






#### Solution


```java
class Solution {
    public TreeNode sortedArrayToBST(int[] nums) {
        return helper(nums, 0, nums.length - 1);
    }

    public TreeNode helper(int[] nums, int left, int right) {
        if (left > right) {
            return null;
        }

        // 总是选择中间位置左边的数字作为根节点
        int mid = (left + right) / 2;

        TreeNode root = new TreeNode(nums[mid]);
        root.left = helper(nums, left, mid - 1);
        root.right = helper(nums, mid + 1, right);
        return root;
    }
}
```




## 110. 平衡二叉树
### Description
* [LeetCode-110. 平衡二叉树](https://leetcode-cn.com/problems/balanced-binary-tree/description/)

### Approach 1-自顶向下递归
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java

class Solution {
    public boolean isBalanced(TreeNode root){
        if(root == null){
            return true;
        } else {
            return  Math.abs(height(root.left) - height(root.right)) <= 1 && isBalanced(root.left) && isBalanced(root.right);
        }
    }
    public int height(TreeNode root){
        if(null == root){
            return 0;
        } else {
            return Math.max(height(root.left), height(root.right)) + 1;
        }
    }
}
```



### Approach 2-自底向上递归
#### Analysis

参考 `leetcode-cn` 官方题解。

方法1中由于是自顶向下递归，因此对于同一个节点，函数 `height` 会被重复调用，导致时间复杂度较高。如果使用自底向上的做法，则对于每个节点，函数 `height` 只会被调用一次。



自底向上递归的做法类似于后序遍历，对于当前遍历到的节点，先递归地判断其左右子树是否平衡，再判断以当前节点为根的子树是否平衡。如果一棵子树是平衡的，则返回其高度（高度一定是非负整数），否则返回 -1。如果存在一棵子树不平衡，则整个二叉树一定不平衡。


#### Solution

```java
class Solution {
    public boolean isBalanced(TreeNode root) {
        return height(root) >= 0;
    }

    public int height(TreeNode root) {
        if (root == null) {
            return 0;
        }
        int leftHeight = height(root.left);
        int rightHeight = height(root.right);
        if (leftHeight == -1 || rightHeight == -1 || Math.abs(leftHeight - rightHeight) > 1) {
            return -1;
        } else {
            return Math.max(leftHeight, rightHeight) + 1;
        }
    }
}
```







## 109. 有序链表转换二叉搜索树
### Description
* [LeetCode-109. 有序链表转换二叉搜索树](https://leetcode-cn.com/problems/convert-sorted-list-to-binary-search-tree/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

本题解法同 [LeetCode-108. 将有序数组转换为二叉搜索树](https://leetcode-cn.com/problems/convert-sorted-array-to-binary-search-tree/description/)

#### Solution



```java
class Solution {
    public TreeNode sortedListToBST(ListNode head) {
        List<Integer> list = new ArrayList<>();
        while(head != null){
            list.add(head.val);
            head = head.next;
        }
        return helper(list,0,list.size()-1);
    }

    private TreeNode helper(List<Integer> list,int left,int right){
        if(left > right){
            return null;
        }
        // 总是选择中间位置左边的数字作为根节点
        int mid = (left + right) /2;
        TreeNode root = new TreeNode(list.get(mid));
        root.left = helper(list, left, mid-1);
        root.right = helper(list, mid+1, right);

        return root;
    }
}
```





## 1382. 将二叉搜索树变平衡
### Description
* [LeetCode-1382. 将二叉搜索树变平衡](https://leetcode-cn.com/problems/balance-a-binary-search-tree/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

本题解法同 [LeetCode-108. 将有序数组转换为二叉搜索树](https://leetcode-cn.com/problems/convert-sorted-array-to-binary-search-tree/description/)



**二叉搜索树的中序遍历结果为升序，因此先对二叉搜索树进行中序遍历。**
#### Solution




```java
class Solution {
    public TreeNode balanceBST(TreeNode root) {
        //二叉搜索树的中序遍历 为升序
        List<Integer> list = new ArrayList<>();
        inOrderTraverse(root,list);

        return helper(list,0,list.size()-1);

    }

    private void inOrderTraverse(TreeNode root,List<Integer> list){
        if(root == null){
            return;
        }
        inOrderTraverse(root.left, list);
        list.add(root.val);
        inOrderTraverse(root.right, list);
    }

    private TreeNode helper(List<Integer> list,int left,int right){
        if(left > right){
            return null;
        }
        // 总是选择中间位置左边的数字作为根节点
        int mid = (left + right) /2;
        TreeNode root = new TreeNode(list.get(mid));
        root.left = helper(list, left, mid-1);
        root.right = helper(list, mid+1, right);

        return root;
    }
}
```





## 【水题】728. 自除数
### Description
* [LeetCode-728. 自除数](https://leetcode-cn.com/problems/self-dividing-numbers/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public List<Integer> selfDividingNumbers(int left, int right) {
        List<Integer> list = new ArrayList<>();
        for(int i=left;i<=right;i++){
            if(isSelffDivide(i)){
                list.add(i);
            }
        }
        return list;
    }
    private boolean isSelffDivide(int val){
        int initVal = val; //保存最初的值
        while(val > 0){
            int tmp = val%10;
            if(tmp == 0){
                return false;
            }
            if(tmp !=0 && initVal%tmp != 0){
                return false;
            }
            val = val/10;
        }
        return true;
    }
}
```



