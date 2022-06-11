
# LeetCode Notes-078


[TOC]



## 更新
* 2021/12/28，撰写
* 2021/12/30，完成



## Overview
* [LeetCode-784. 字母大小写全排列](https://leetcode-cn.com/problems/letter-case-permutation/)
* 【经典好题】[LeetCode-236. 二叉树的最近公共祖先](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree/)
* [LeetCode-235. 二叉搜索树的最近公共祖先](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-search-tree/description/)
* [LeetCode-剑指 Offer 68 - I. 二叉搜索树的最近公共祖先](https://leetcode-cn.com/problems/er-cha-sou-suo-shu-de-zui-jin-gong-gong-zu-xian-lcof/)
* [LeetCode-剑指 Offer 68 - II. 二叉树的最近公共祖先](https://leetcode-cn.com/problems/er-cha-shu-de-zui-jin-gong-gong-zu-xian-lcof/)




## 784. 字母大小写全排列
### Description
* [LeetCode-784. 字母大小写全排列](https://leetcode-cn.com/problems/letter-case-permutation/)

### Approach 1-常规


#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public List<String> letterCasePermutation(String S) {
        List<StringBuilder> ans = new ArrayList<>();
        ans.add(new StringBuilder()); //init

        
        for(char c:S.toCharArray()){
            int len = ans.size();
            if(Character.isLetter(c)){
                //如果c是字符，将ans拷贝两份，并在前一份的每个元素后面插入小写c，再后一份的每个元素后插入大写C
                for(int i=0;i<len;i++){
                    ans.add(new StringBuilder(ans.get(i)));
                    ans.get(i).append(Character.toLowerCase(c));
                    ans.get(len+i).append(Character.toUpperCase(c));
                }
            } else {
                for (int i = 0; i < len; ++i){
                    ans.get(i).append(c);
                }
            }
        }

        List<String> finalans = new ArrayList();
        for (StringBuilder sb: ans){
            finalans.add(sb.toString());
        }
        return finalans;
    }
}
```



## 【经典好题】236. 二叉树的最近公共祖先
### Description
* 【经典好题】[LeetCode-236. 二叉树的最近公共祖先](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree/)

### Approach 1-递归法

#### Analysis


参考 `leetcode-cn` 官方题解。


我们递归遍历整棵二叉树，定义 fx 表示 x 节点的子树中是否包含 p 节点或 q 节点，如果包含为 true，否则为 false。

那么符合条件的最近公共祖先 x 一定满足如下条件（其中 lson 和 rson 分别代表 x 节点的左孩子和右孩子）


```java
(lson && rson) || ((root.val == p.val || root.val == q.val) && (lson || rson))
```

上面表达式可以分为两部分
1. `lson && rson` ：即节点 p 或 q 在节点 x 的左子树 `lson` 和右子树 `rson` 中（节点 p 和节点 q 不相等， 故若 `lson` 和 `rson` 均为 true，则表示两个节点分别在左子树和右子树中）
2. `((root.val == p.val || root.val == q.val) && (lson || rson))` ： 节点 `x` 恰巧是节点 `p` 或 `q`，剩下一个节点 `p` 或 `q` 在节点 `x` 的左子树或右子树中


复杂度分析
* 时间复杂度：`O(N)`
* 空间复杂度：`O(N)`



#### Solution

* Java


```java

class Solution {
    private TreeNode ans;

    public Solution(){
        this.ans = null;
    }

    private boolean dfs(TreeNode root, TreeNode p, TreeNode q){
        if(null == root) {
            return false;
        }
        boolean lson = dfs(root.left,p,q);
        boolean rson = dfs(root.right,p,q);
        if((lson && rson) || ((root.val == p.val || root.val == q.val) && (lson || rson))){
            ans = root;
            return true; //此处可优化 直接返回true 结束此次递归
        }
        return lson || rson || root.val == p.val || root.val == q.val;
    }

    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        this.dfs(root,p,q);
        return this.ans;
    }
}
```


### Approach 2-存储父节点

#### Analysis


参考 `leetcode-cn` 官方题解。


1. 利用哈希表存储节点的父节点信息
2. 利用节点的父节点信息，从 `p` 节点开始不断向上访问，并记录访问过的节点，将该访问路径存储到 `Set` 中
3. 再从节点 `q` 开始向上访问，若遇到访问的节点在 `Set` 中，则该节点一定为最近公共祖先


复杂度分析
* 时间复杂度：`O(N)`
* 空间复杂度：`O(N)`




#### Solution


* Java


```java


class Solution {
    Map<Integer,TreeNode> parent = new HashMap<>(); //存储节点的父节点信息
    Set<Integer> visited = new HashSet<>(); //记录节点p向上访问的路径

    //存储节点的父节点信息
    public void dfs(TreeNode root) {
        if(null != root.left){
            parent.put(root.left.val,root);
            dfs(root.left);
        }
        if(null != root.right){
            parent.put(root.right.val,root);
            dfs(root.right);
        }
    }

    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        dfs(root);
        //记录节点p向上访问的路径
        while(null != p){
            visited.add(p.val);
            p = parent.get(p.val);
        }
        //节点q向上访问
        while(null != q){
            if(visited.contains(q.val)){
                return q;
            }
            q = parent.get(q.val);
        }
        return null;
    }
}

```




## 235. 二叉搜索树的最近公共祖先
### Description
* [LeetCode-235. 二叉搜索树的最近公共祖先](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-search-tree/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


参考 「LeetCode-236. 二叉树的最近公共祖先」



#### Solution





```java

class Solution {
    private TreeNode ans;

    public Solution(){
        this.ans = null;
    }

    private boolean dfs(TreeNode root, TreeNode p, TreeNode q){
        if(null == root) {
            return false;
        }
        boolean lson = dfs(root.left,p,q);
        boolean rson = dfs(root.right,p,q);
        if((lson && rson) || ((root.val == p.val || root.val == q.val) && (lson || rson))){
            ans = root;
            return true; //此处可优化 直接返回true 结束此次递归
        }
        return lson || rson || root.val == p.val || root.val == q.val;
    }

    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        this.dfs(root,p,q);
        return this.ans;
    }
}
```


Or

```java
class Solution {
    Map<Integer,TreeNode> parent = new HashMap<>(); //存储节点的父节点信息
    Set<Integer> visited = new HashSet<>(); //记录节点p向上访问的路径

    //存储节点的父节点信息
    public void dfs(TreeNode root) {
        if(null != root.left){
            parent.put(root.left.val,root);
            dfs(root.left);
        }
        if(null != root.right){
            parent.put(root.right.val,root);
            dfs(root.right);
        }
    }

    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        dfs(root);
        //记录节点p向上访问的路径
        while(null != p){
            visited.add(p.val);
            p = parent.get(p.val);
        }
        //节点q向上访问
        while(null != q){
            if(visited.contains(q.val)){
                return q;
            }
            q = parent.get(q.val);
        }
        return null;
    }
}
```



### Approach 2-充分利用二叉搜索性质
#### Analysis

参考 `leetcode-cn` 官方题解。


在「LeetCode-236. 二叉树的最近公共祖先」通用版解题的基础上，充分利用二叉搜索性质，优化解题思路

1. 从根节点开始遍历
2. 如果当前节点就是 p，那么成功地找到了节点
3. 如果当前节点的值大于 p 的值，说明 p 应该在当前节点的左子树，因此将当前节点移动到它的左子节点
4. 如果当前节点的值小于 p 的值，说明 p 应该在当前节点的右子树，因此将当前节点移动到它的右子节点
5. 对于节点 q 同理
6. 在寻找节点的过程中，我们可以顺便记录经过的节点，这样就得到了从根节点到被寻找节点的路径
7. 最后求两个路径的相交点


#### Solution



```java
class Solution {
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        List<TreeNode> path_p = getPath(root, p);
        List<TreeNode> path_q = getPath(root, q);
        TreeNode ancestor = null;
        for (int i = 0; i < path_p.size() && i < path_q.size(); ++i) {
            if (path_p.get(i) == path_q.get(i)) {
                ancestor = path_p.get(i);
            } else {
                break;
            }
        }
        return ancestor;
    }

    public List<TreeNode> getPath(TreeNode root, TreeNode target) {
        List<TreeNode> path = new ArrayList<TreeNode>();
        TreeNode node = root;
        while (node != target) {
            path.add(node);
            if (target.val < node.val) {
                node = node.left;
            } else {
                node = node.right;
            }
        }
        path.add(node);
        return path;
    }
}
```





## 剑指 Offer 68 - I. 二叉搜索树的最近公共祖先
### Description
* [LeetCode-剑指 Offer 68 - I. 二叉搜索树的最近公共祖先](https://leetcode-cn.com/problems/er-cha-sou-suo-shu-de-zui-jin-gong-gong-zu-xian-lcof/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


本题同 「LeetCode-235. 二叉搜索树的最近公共祖先」，此处不再赘叙。


#### Solution




## 剑指 Offer 68 - II. 二叉树的最近公共祖先
### Description
* [LeetCode-剑指 Offer 68 - II. 二叉树的最近公共祖先](https://leetcode-cn.com/problems/er-cha-shu-de-zui-jin-gong-gong-zu-xian-lcof/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


本题同 「LeetCode-236. 二叉树的最近公共祖先」，此处不再赘叙。


#### Solution
