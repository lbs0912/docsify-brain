


# LeetCode Notes-066


[TOC]



## 更新
* 2021/09/06，撰写
* 2021/09/10，完成



## Overview

* [LeetCode-965. 单值二叉树](https://leetcode-cn.com/problems/univalued-binary-tree/description/)
* [LeetCode-993. 二叉树的堂兄弟节点](https://leetcode-cn.com/problems/cousins-in-binary-tree/description/)
* [LeetCode-513. 找树左下角的值](https://leetcode-cn.com/problems/find-bottom-left-tree-value/description/)
* [LeetCode-515. 在每个树行中找最大值](https://leetcode-cn.com/problems/find-largest-value-in-each-tree-row/description/)
* [LeetCode-662. 二叉树最大宽度](https://leetcode-cn.com/problems/maximum-width-of-binary-tree/description/)







## 【水题】965. 单值二叉树
### Description
* [LeetCode-965. 单值二叉树](https://leetcode-cn.com/problems/univalued-binary-tree/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution




```java
class Solution {
    public boolean isUnivalTree(TreeNode root) {
        int val = root.val;
        return isEqualTree(root.right,val) && isEqualTree(root.left,val);
    }

    private boolean isEqualTree(TreeNode node,int val){
        if(node == null){
            return true;
        }
        if(node.val != val){
            return false;
        }

        return isEqualTree(node.right,val) && isEqualTree(node.left,val);
    }
}
```






## 993. 二叉树的堂兄弟节点
### Description
* [LeetCode-993. 二叉树的堂兄弟节点](https://leetcode-cn.com/problems/cousins-in-binary-tree/description/)

### Approach 1-DFS
#### Analysis

参考 `leetcode-cn` 官方题解。



要想判断两个节点 x 和 y 是否为堂兄弟节点，我们就需要求出这两个节点分别的「深度」以及「父节点」。

**因此，我们可以从根节点开始，对树进行一次遍历，在遍历的过程中维护「深度」以及「父节点」这两个信息。**


#### Solution



```java
class Solution {
    //x的信息
    int x;
    TreeNode xParent; //父节点
    int xDepth;
    boolean xFound;// 标记是否已找到
    
    //y的信息
    int y;
    TreeNode yParent; //父节点
    int yDepth;
    boolean yFound;// 标记是否已找到




    public boolean isCousins(TreeNode root, int x, int y) {
        this.x = x;
        this.y = y;

        dfs(root,0,null);

        return this.xDepth == this.yDepth && this.xParent != this.yParent;
    }

    //深度优先遍历
    public void dfs(TreeNode node,int depth,TreeNode parent){
        if(node == null){
            return;
        }

        if (node.val == x) {
            xParent = parent;
            xDepth = depth;
            xFound = true;
        } else if (node.val == y) {
            yParent = parent;
            yDepth = depth;
            yFound = true;
        }

        // 如果两个节点都找到了，就可以提前退出遍历
        // 即使不提前退出，对最坏情况下的时间复杂度也不会有影响
        if (xFound && yFound) {
            return;
        }

        dfs(node.left, depth + 1, node);

        if (xFound && yFound) {
            return;
        }

        dfs(node.right, depth + 1, node);
    }

}
```

### Approach 2-BFS
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    // x 的信息
    int x;
    TreeNode xParent;
    int xDepth;
    boolean xFound = false;

    // y 的信息
    int y;
    TreeNode yParent;
    int yDepth;
    boolean yFound = false;

    public boolean isCousins(TreeNode root, int x, int y) {
        this.x = x;
        this.y = y;

        //BFS 广度优先遍历
        
        Queue<TreeNode> nodeQueue = new LinkedList<TreeNode>();
        Queue<Integer> depthQueue = new LinkedList<Integer>(); //辅助栈 记录深度信息
        nodeQueue.offer(root);
        depthQueue.offer(0);
        update(root, null, 0);

        while (!nodeQueue.isEmpty()) {
            TreeNode node = nodeQueue.poll();
            int depth = depthQueue.poll();
            if (node.left != null) {
                nodeQueue.offer(node.left);
                depthQueue.offer(depth + 1);
                update(node.left, node, depth + 1);
            }
            if (node.right != null) {
                nodeQueue.offer(node.right);
                depthQueue.offer(depth + 1);
                update(node.right, node, depth + 1);
            }
            if (xFound && yFound) {
                break;
            }
        }

        return xDepth == yDepth && xParent != yParent;
    }

    // 用来判断是否遍历到 x 或 y 的辅助函数
    public void update(TreeNode node, TreeNode parent, int depth) {
        if (node.val == x) {
            xParent = parent;
            xDepth = depth;
            xFound = true;
        } else if (node.val == y) {
            yParent = parent;
            yDepth = depth;
            yFound = true;
        }
    }
}
```


## 513. 找树左下角的值
### Description
* [LeetCode-513. 找树左下角的值](https://leetcode-cn.com/problems/find-bottom-left-tree-value/description/)

### Approach 1-BFS
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution




```java
class Solution {
    public int findBottomLeftValue(TreeNode root) {
        int val = root.val;

        Queue<TreeNode> nodeQueue = new LinkedList<TreeNode>();
        Queue<Integer> depthQueue = new LinkedList<Integer>(); //辅助栈 记录深度信息
        nodeQueue.offer(root);
        depthQueue.offer(0);
        int currentDepth = 0;

        while(!nodeQueue.isEmpty()){
            TreeNode node = nodeQueue.poll();
            int depth = depthQueue.poll();
            if(currentDepth + 1 == depth){
                currentDepth = depth; //若深度增加了 则记录第一个值 即最左侧的值
                val = node.val;
            }
            if (node.left != null) {
                nodeQueue.offer(node.left);
                depthQueue.offer(depth + 1);
            }
            if (node.right != null) {
                nodeQueue.offer(node.right);
                depthQueue.offer(depth + 1);
            }
        }
        return val;

    }
}
```




## 515. 在每个树行中找最大值
### Description
* [LeetCode-515. 在每个树行中找最大值](https://leetcode-cn.com/problems/find-largest-value-in-each-tree-row/description/)

### Approach 1-树的层序遍历
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java

class Solution {
    public List<Integer> largestValues(TreeNode root) {

        List<Integer> list = new ArrayList<>();
        if(root == null){
            return list;
        }

        int val = root.val;

        Queue<TreeNode> nodeQueue = new LinkedList<TreeNode>();
        Queue<Integer> depthQueue = new LinkedList<Integer>(); //辅助栈 记录深度信息
        nodeQueue.offer(root);
        depthQueue.offer(0);
        int currentDepth = 0;
     

        while(!nodeQueue.isEmpty()){
            TreeNode node = nodeQueue.poll();
            int depth = depthQueue.poll();
            if(currentDepth + 1 == depth){//若深度增加了  则将上一层的max插入list
                currentDepth = depth; 
                list.add(val);
                val = node.val;
            } else {
                val = Math.max(node.val,val);
            }
            if (node.left != null) {
                nodeQueue.offer(node.left);
                depthQueue.offer(depth + 1);
            }
            if (node.right != null) {
                nodeQueue.offer(node.right);
                depthQueue.offer(depth + 1);
            }
        }
        //插入最后一层的最大值
        list.add(val);
        return list;
    }
}
```


## 【经典好题】662. 二叉树最大宽度
### Description
* [LeetCode-662. 二叉树最大宽度](https://leetcode-cn.com/problems/maximum-width-of-binary-tree/description/)

### Approach 1-DFS
#### Analysis

参考 `leetcode-cn` 官方题解。


**对节点信息进行加强，附加存储节点的高度和编号信息，如下所示。**

```java
class AnnotatedNode{
    TreeNode node;
    int depth; //深度
    int pos; //编号
    AnnotatedNode(TreeNode node,int depth,int pos){
        this.node = node;
        this.depth = depth;
        this.pos = pos;
    }
}
```

**在满二叉树中，若父节点编号为 `pos`，则左子节点为 `2*pos`，右子节点为 `2*pos+1`。**



#### Solution



```java

class Solution {
    public int widthOfBinaryTree(TreeNode root) {
        if(root == null){
            return 0;
        }

        int maxWidth = 1;
        
        Queue<AnnotatedNode> nodeQueue = new LinkedList<>();
        int curDepth = 1;
        int leftPos = 1; //每一层 最左侧的节点的编号
        
        nodeQueue.add(new AnnotatedNode(root,1,1)); //节点编号从1开始 高度从1开始编号

        while(!nodeQueue.isEmpty()){
            AnnotatedNode annotateNode = nodeQueue.poll();
            if(annotateNode.node != null){
                //父节点编号为pos 则左子节点为2*pos 右子节点为2*pos+1
                nodeQueue.add(new AnnotatedNode(annotateNode.node.left, annotateNode.depth+1, annotateNode.pos * 2));
                nodeQueue.add(new AnnotatedNode(annotateNode.node.right, annotateNode.depth+1, 1+ annotateNode.pos * 2));
                if(curDepth != annotateNode.depth){
                    curDepth = annotateNode.depth;
                    leftPos = annotateNode.pos; 
                }
                maxWidth = Math.max(maxWidth, annotateNode.pos - leftPos + 1);
            }
           
        }
        
        return maxWidth;
    }
}



class AnnotatedNode{
    TreeNode node;
    int depth; //深度
    int pos; //编号
    AnnotatedNode(TreeNode node,int depth,int pos){
        this.node = node;
        this.depth = depth;
        this.pos = pos;
    }
}
```


### Approach 2-BFS
#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution


```java

class Solution {
    int ans;
    Map<Integer, Integer> left;
    public int widthOfBinaryTree(TreeNode root) {
        ans = 0;
        left = new HashMap();
        dfs(root, 0, 0);
        return ans;
    }
    public void dfs(TreeNode root, int depth, int pos) {
        if (root == null) return;
        left.computeIfAbsent(depth, x-> pos);
        ans = Math.max(ans, pos - left.get(depth) + 1);
        dfs(root.left, depth + 1, 2 * pos);
        dfs(root.right, depth + 1, 2 * pos + 1);
    }
}
```


