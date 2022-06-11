
# LeetCode Notes-032


[TOC]



## 更新
* 2021/04/27，撰写
* 2021/05/03，完成


## Overview
* [LeetCode-637. 二叉树的层平均值](https://leetcode-cn.com/problems/average-of-levels-in-binary-tree/)
* [LeetCode-112. 路径总和](https://leetcode-cn.com/problems/path-sum/)
* [LeetCode-113. 路径总和 II](https://leetcode-cn.com/problems/path-sum-ii/)
* [LeetCode-129. 求根节点到叶节点数字之和](https://leetcode-cn.com/problems/sum-root-to-leaf-numbers/)
* [LeetCode-404. 左叶子之和](https://leetcode-cn.com/problems/sum-of-left-leaves/)




## 637. 二叉树的层平均值
### Description
* [LeetCode-637. 二叉树的层平均值](https://leetcode-cn.com/problems/average-of-levels-in-binary-tree/)

### Approach 1-BFS
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public List<Double> averageOfLevels(TreeNode root) {
        List<Double> list = new ArrayList<Double>();
        if(null == root){
            return list;
        } 
        Queue<TreeNode> queue = new LinkedList<TreeNode>();
        queue.offer(root);
  
        while(!queue.isEmpty()){
            int currentSize = queue.size();
            double sum = 0;
            for(int i=0;i<currentSize;i++){
                TreeNode node = queue.poll();
                sum += node.val;
                if(node.left != null){
                    queue.offer(node.left);
                }
                if(node.right != null){
                    queue.offer(node.right);
                }
            }
            list.add((double)sum/currentSize);
        }
        return list;
    }
}
```

### Approach 2-DFS
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution

```java
class Solution {
    public List<Double> averageOfLevels(TreeNode root) {
        List<Integer> counts = new ArrayList<Integer>();
        List<Double> sums = new ArrayList<Double>();
        dfs(root, 0, counts, sums);
        List<Double> averages = new ArrayList<Double>();
        int size = sums.size();
        for (int i = 0; i < size; i++) {
            averages.add(sums.get(i) / counts.get(i));
        }
        return averages;
    }

    public void dfs(TreeNode root, int level, List<Integer> counts, List<Double> sums) {
        if (root == null) {
            return;
        }
        if (level < sums.size()) {
            sums.set(level, sums.get(level) + root.val);
            counts.set(level, counts.get(level) + 1);
        } else {
            sums.add(1.0 * root.val);
            counts.add(1);
        }
        dfs(root.left, level + 1, counts, sums);
        dfs(root.right, level + 1, counts, sums);
    }
}
```



## 112. 路径总和
### Description
* [LeetCode-112. 路径总和](https://leetcode-cn.com/problems/path-sum/)

### Approach 1-BFS+前缀和
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(N)`，其中 N 是树的节点数。对每个节点访问一次。
* 空间复杂度：`O(N)`，其中 N 是树的节点数。空间复杂度主要取决于队列的开销，队列中的元素个数不会超过树的节点数。


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
    public boolean hasPathSum(TreeNode root, int sum) {
        if(null == root){
            return false;
        }
        Queue<TreeNode> queNode = new LinkedList<TreeNode>();
        Queue<Integer> queVal = new LinkedList<Integer>();
        queNode.offer(root);
        queVal.offer(root.val);
        while(!queNode.isEmpty()){
            TreeNode node = queNode.poll();
            int temp = queVal.poll();
            if(node.right == null && node.left == null){ //root为子节点
                if(temp == sum){
                    return true;
                }
                continue;  //opt 若进入到此处，广度遍历，则后续都为子节点，后面两处if判断一定也都为false 可直接跳过
            }
            if(node.left != null){
                queNode.offer(node.left);
                queVal.offer(node.left.val + temp);
            }
             if(node.right != null){
                queNode.offer(node.right);
                queVal.offer(node.right.val + temp);
            }

        }
        return false;
    }
}
```

### Approach 2-DFS
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(N)`，其中 N 是树的节点数。对每个节点访问一次。
* 空间复杂度：`O(H)`，其中 H 是树的节点数。空间复杂度主要取决于递归时栈空间的开销，最坏情况下，树呈现链状，空间复杂度为 `O(N)`。平均情况下树的高度与节点数的对数正相关，空间复杂度为 `O(logN)`。



#### Solution


```java
class Solution {
    public boolean hasPathSum(TreeNode root, int sum) {
        if(null == root){
            return false;
        }
        if(root.left == null && root.right == null){
            return sum == root.val;
        }
        return hasPathSum(root.left,sum - root.val) || hasPathSum(root.right, sum - root.val);
    }
}
```





## 113. 路径总和 II
### Description
* [LeetCode-113. 路径总和 II](https://leetcode-cn.com/problems/path-sum-ii/)

### Approach 1-BFS
#### Analysis

参考 `leetcode-cn` 官方题解。


我们使用哈希表记录树中的每一个节点的父节点。每次找到一个满足条件的节点，我们就从该节点出发不断向父节点迭代，即可还原出从根节点到当前节点的路径。


复杂度分析
* 时间复杂度：`O(N^2)`，其中 N 是树的节点数。在最坏情况下，树的上半部分为链状，下半部分为完全二叉树，并且从根节点到每一个叶子节点的路径都符合题目要求。此时，路径的数目为`O(N)`，并且每一条路径的节点个数也为 `O(N)`，因此要将这些路径全部添加进答案中，时间复杂度为 `O(N^2)`。
* 空间复杂度：`O(N)`，其中 N 是树的节点数。空间复杂度主要取决于哈希表和队列空间的开销，哈希表需要存储除根节点外的每个节点的父节点，队列中的元素个数不会超过树的节点数。





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
    private List<List<Integer>> list = new LinkedList<List<Integer>>(); // ArrayList
    private Map<TreeNode,TreeNode> nodeMap = new HashMap<TreeNode,TreeNode>();

    public List<List<Integer>> pathSum(TreeNode root, int targetSum) {
        if(null == root){
            return list;
        }
        Queue<TreeNode> queueNode = new LinkedList<TreeNode>();
        Queue<Integer> queueVal = new LinkedList<Integer>();

        queueNode.offer(root);
        queueVal.offer(root.val);
        
        while(!queueNode.isEmpty()){
            TreeNode node = queueNode.poll();
            int tempVal = queueVal.poll();

            if(node.left == null && node.right == null){
                if(tempVal == targetSum){
                    getPath(node);
                }
           
                continue; //opt 若进入到此处，广度遍历，则后续都为子节点，后面两处if判断一定也都为false 可直接跳过
            }

            if(node.left != null){
                queueNode.offer(node.left);
                queueVal.offer(node.left.val + tempVal);
                nodeMap.put(node.left,node);
            }

            if(node.right != null){
                queueNode.offer(node.right);
                queueVal.offer(node.right.val + tempVal);
                nodeMap.put(node.right,node);
            }
        }
        return list;
    }

    private void getPath(TreeNode node){
        if(node == null){
            return;
        }
        List<Integer> pathList = new ArrayList<>();
        while(node != null){
            pathList.add(node.val);
            node = nodeMap.get(node);
        }
        Collections.reverse(pathList);
        list.add(pathList);
    }
}
```




### Approach 2-DFS
#### Analysis

参考 `leetcode-cn` 官方题解。





#### Solution


```java
class Solution {
    List<List<Integer>> ret = new LinkedList<List<Integer>>();
    Deque<Integer> path = new LinkedList<Integer>();

    public List<List<Integer>> pathSum(TreeNode root, int sum) {
        dfs(root, sum);
        return ret;
    }

    public void dfs(TreeNode root, int sum) {
        if (root == null) {
            return;
        }
        path.offerLast(root.val);
        sum -= root.val;
        if (root.left == null && root.right == null && sum == 0) {
            ret.add(new LinkedList<Integer>(path));
        }
        dfs(root.left, sum);
        dfs(root.right, sum);
        path.pollLast(); //移除队列最后一个元素
    }
}
```


## 129. 求根节点到叶节点数字之和
### Description
* [LeetCode-129. 求根节点到叶节点数字之和](https://leetcode-cn.com/problems/sum-root-to-leaf-numbers/)

### Approach 1-BFS
#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution



```java
class Solution {
    public int sumNumbers(TreeNode root) {
        if (root == null) {
            return 0;
        }
        int sum = 0;
        Queue<TreeNode> nodeQueue = new LinkedList<TreeNode>();
        Queue<Integer> numQueue = new LinkedList<Integer>();
        nodeQueue.offer(root);
        numQueue.offer(root.val);
        while (!nodeQueue.isEmpty()) {
            TreeNode node = nodeQueue.poll();
            int num = numQueue.poll();
            TreeNode left = node.left, right = node.right;
            if (left == null && right == null) {
                sum += num;
            } else {
                if (left != null) {
                    nodeQueue.offer(left);
                    numQueue.offer(num * 10 + left.val);
                }
                if (right != null) {
                    nodeQueue.offer(right);
                    numQueue.offer(num * 10 + right.val);
                }
            }
        }
        return sum;
    }
}
```

### Approach 2-DFS
#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution

```java
class Solution {
    public int sumNumbers(TreeNode root) {
        return dfs(root, 0);
    }

    public int dfs(TreeNode root, int prevSum) {
        if (root == null) {
            return 0;
        }
        int sum = prevSum * 10 + root.val;
        if (root.left == null && root.right == null) {
            return sum;
        } else {
            return dfs(root.left, sum) + dfs(root.right, sum);
        }
    }
}
```

## 404. 左叶子之和
### Description
* [LeetCode-404. 左叶子之和](https://leetcode-cn.com/problems/sum-of-left-leaves/)

### Approach 1-BFS
#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution

```java
class Solution {
    public int sumOfLeftLeaves(TreeNode root) {
        if(null == root){
            return 0;
        }
        int sum = 0;
        Queue<TreeNode> queueNode = new LinkedList<TreeNode>();
        queueNode.offer(root);
        while(!queueNode.isEmpty()){
            TreeNode node = queueNode.poll();
            if(node.left != null && node.left.right == null && node.left.left == null){
                sum += node.left.val;
            }
            if(node.left != null){
                queueNode.offer(node.left);
            }
            if(node.right != null){
                queueNode.offer(node.right);
            }
        }
        return sum;
    }
}
```


### Approach 2-DFS
#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution


```java

class Solution {
    public int sumOfLeftLeaves(TreeNode root) {
        return null == root ? 0:dfs(root);
    }

    public int dfs(TreeNode node) {
        int ans = 0;
        if (node.left != null) {
            ans += isLeafNode(node.left) ? node.left.val : dfs(node.left);
        }
        if (node.right != null && !isLeafNode(node.right)) {
            ans += dfs(node.right);
        }
        return ans;
    }

    public boolean isLeafNode(TreeNode node) {
        return node.left == null && node.right == null;
    }
}
```