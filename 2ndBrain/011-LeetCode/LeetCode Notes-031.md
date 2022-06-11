
# LeetCode Notes-031


[TOC]



## 更新
* 2021/04/27，撰写
* 2021/04/27，完成


## Overview
* [LeetCode-257. 二叉树的所有路径](https://leetcode-cn.com/problems/binary-tree-paths/)
* [LeetCode-102. 二叉树的层序遍历](https://leetcode-cn.com/problems/binary-tree-level-order-traversal/)
* [LeetCode-107. 二叉树的层序遍历 II](https://leetcode-cn.com/problems/binary-tree-level-order-traversal-ii/)
* [LeetCode-剑指 Offer 32 - II. 从上到下打印二叉树 II](https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-ii-lcof/)
* [LeetCode-剑指 Offer 32 - I. 从上到下打印二叉树](https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-lcof/)





## 257. 二叉树的所有路径
### Description
* [LeetCode-257. 二叉树的所有路径](https://leetcode-cn.com/problems/binary-tree-paths/)

### Approach 1-DFS
#### Analysis

参考 `leetcode-cn` 官方题解。



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
    public List<String> binaryTreePaths(TreeNode root) {
        List<String> paths = new ArrayList<String>();
        constructPaths(root, "", paths);
        return paths;
    }

    public void constructPaths(TreeNode root, String path, List<String> paths) {
        if (root != null) {
            StringBuffer pathSB = new StringBuffer(path);
            pathSB.append(Integer.toString(root.val));
            if (root.left == null && root.right == null) {  // 当前节点是叶子节点
                paths.add(pathSB.toString());  // 把路径加入到答案中
            } else {
                pathSB.append("->");  // 当前节点不是叶子节点，继续递归遍历
                constructPaths(root.left, pathSB.toString(), paths);
                constructPaths(root.right, pathSB.toString(), paths);
            }
        }
    }
}
```






## 102. 二叉树的层序遍历
### Description
* [LeetCode-102. 二叉树的层序遍历](https://leetcode-cn.com/problems/binary-tree-level-order-traversal/)

### Approach 1-BFS
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


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
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> res = new ArrayList<>();
        if(null == root){
            return res;
        }
        Queue<TreeNode> queue = new LinkedList<>();
        queue.add(root);
        while(!queue.isEmpty()){
            int currentSize = queue.size();
            List<Integer> list = new ArrayList();
            for(int i=0;i<currentSize;i++){
                TreeNode node = queue.poll();
                list.add(node.val);
                if(null != node.left){
                    queue.add(node.left);
                }
                if(null != node.right){
                    queue.add(node.right);
                }
            }
            res.add(list);
        }
        return  res;
    }
}
```



## 107. 二叉树的层序遍历 II
### Description
* [LeetCode-107. 二叉树的层序遍历 II](https://leetcode-cn.com/problems/binary-tree-level-order-traversal-ii/)

### Approach 1-BFS
#### Analysis

参考 `leetcode-cn` 官方题解。


Java 中向 List 插入数据时，可以指定插入的 `index`，方法如下所示

```java
void add(int index, E element);
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
    public List<List<Integer>> levelOrderBottom(TreeNode root) {
        List<List<Integer>> res = new ArrayList<>();
        if(null == root){
            return res;
        }
        Queue<TreeNode> queue = new LinkedList<>();
        queue.add(root);
        while(!queue.isEmpty()){
            int currentSize = queue.size();
            List<Integer> list = new ArrayList();
            for(int i=0;i<currentSize;i++){
                TreeNode node = queue.poll();
                list.add(node.val);
                if(null != node.left){
                    queue.add(node.left);
                }
                if(null != node.right){
                    queue.add(node.right);
                }
            }
            res.add(0,list); //每次插入顶部
        }
        return  res;
    }
}
```



## 剑指 Offer 32 - II. 从上到下打印二叉树 II
### Description
* [LeetCode-剑指 Offer 32 - II. 从上到下打印二叉树 II](https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-ii-lcof/)

### Approach 1-BFS
#### Analysis

参考 `leetcode-cn` 官方题解。

本题同 [LeetCode-102. 二叉树的层序遍历](https://leetcode-cn.com/problems/binary-tree-level-order-traversal/)。


#### Solution



```java

class Solution {
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> res = new ArrayList<>();
        if(null == root){
            return res;
        }
        Queue<TreeNode> queue = new LinkedList<>();
        queue.add(root);
        while(!queue.isEmpty()){
            int currentSize = queue.size();
            List<Integer> list = new ArrayList();
            for(int i=0;i<currentSize;i++){
                TreeNode node = queue.poll();
                list.add(node.val);
                if(null != node.left){
                    queue.add(node.left);
                }
                if(null != node.right){
                    queue.add(node.right);
                }
            }
            res.add(list);
        }
        return  res;
    }
}
```


## 剑指 Offer 32 - I. 从上到下打印二叉树
### Description
* [LeetCode-剑指 Offer 32 - I. 从上到下打印二叉树](https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-lcof/)

### Approach 1-BFS
#### Analysis

参考 `leetcode-cn` 官方题解。

注意，将 `List<Integer>` 转换为 `int[]` 的方法如下。

```java
list.stream().mapToInt(Integer::valueOf).toArray();
```

#### Solution

```java

class Solution {
    public int[] levelOrder(TreeNode root) {
        int[] arr = new int[0];

        List<Integer> res = new ArrayList<>();

        if(null == root){
            return arr;
        }
        Queue<TreeNode> queue = new LinkedList<>();
        queue.add(root);
        while(!queue.isEmpty()){
            TreeNode node = queue.poll();
    
            if(null != node.left){
                queue.add(node.left);
            }
            if(null != node.right){
                queue.add(node.right);
            }
            res.add(node.val);
        }
        return res.stream().mapToInt(Integer::valueOf).toArray();
    }
}
```