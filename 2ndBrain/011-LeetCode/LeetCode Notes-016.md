
# LeetCode Notes-016


[TOC]


## 更新
* 2020/11/29，撰写
* 2021/01/12，完成
* 2021/12/28，移动 *[LeetCode-236. 二叉树的最近公共祖先](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree/)，替换为 [LeetCode-182. 查找重复的电子邮箱](https://leetcode-cn.com/problems/duplicate-emails/)*

## Overview

* 【经典好题】[LeetCode-182. 查找重复的电子邮箱](https://leetcode-cn.com/problems/duplicate-emails/)
* [LeetCode-144. 二叉树的前序遍历](https://leetcode-cn.com/problems/binary-tree-preorder-traversal/)
* [LeetCode-94. 二叉树的中序遍历](https://leetcode-cn.com/problems/binary-tree-inorder-traversal/)
* [LeetCode-145. 二叉树的后序遍历](https://leetcode-cn.com/problems/binary-tree-postorder-traversal/)
* [LeetCode-114. 二叉树展开为链表](https://leetcode-cn.com/problems/flatten-binary-tree-to-linked-list/)



## 【经典好题】182. 查找重复的电子邮箱
### Description
* 【经典好题】[LeetCode-182. 查找重复的电子邮箱](https://leetcode-cn.com/problems/duplicate-emails/)

### Approach 1-GROUP BY + 临时表

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```sql
select Email from
(
  select Email, count(Email) as num
  from Person
  group by Email
) as statistic
where num > 1
;
```


### Approach 2-GROUP BY + HAVING

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution

```sql
select Email
from Person
group by Email
having count(Email) > 1;
```




## 144. 二叉树的前序遍历
### Description
* [LeetCode-144. 二叉树的前序遍历](https://leetcode-cn.com/problems/binary-tree-preorder-traversal/)

### Approach 1-递归法

#### Analysis


参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(n)`，其中 `n` 是二叉树的节点数。每一个节点恰好被遍历一次。
* 空间复杂度：`O(n)`，为递归过程中栈的开销，平均情况下为 `O(logn)`，最坏情况下树呈现链状，为 `O(n)`。



#### Solution


* Java

```java
class Solution {
    public List<Integer> preorderTraversal(TreeNode root) {
        List<Integer> res = new ArrayList<Integer>();
        preorder(root, res);
        return res;
    }

    public void preorder(TreeNode root, List<Integer> res) {
        if (root == null) {
            return;
        }
        res.add(root.val);
        preorder(root.left, res);
        preorder(root.right, res);
    }
}
```

### Approach 2-迭代法

#### Analysis

* ref-[二叉树的非递归遍历 | blog](https://www.cnblogs.com/dolphin0520/archive/2011/08/25/2153720.html)

参考 `leetcode-cn` 官方题解。**参考官方题解的动画加深理解。**




我们也可以用迭代的方式实现方法一的递归函数，**两种方式是等价的，区别在于递归的时候隐式地维护了一个栈，而我们在迭代的时候需要显式地将这个栈模拟出来，其余的实现与细节都相同。** 迭代方法中基本流程如下

对于任一结点P
1) 访问结点P，并将结点P入栈;
2) 判断结点P的左孩子是否为空。若为空，则取栈顶结点并进行出栈操作，并将**栈顶结点**的右孩子置为当前的结点P，循环至1); 若不为空，则将P的左孩子置为当前的结点P;
3) 直到P为 NULL 并且栈为空，则遍历结束。



复杂度分析
* 时间复杂度：`O(n)`，其中 `n` 是二叉树的节点数。每一个节点恰好被遍历一次。
* 空间复杂度：`O(n)`，为迭代过程中显式栈的开销，平均情况下为 `O(logn)`，最坏情况下树呈现链状，为 `O(n)`。



#### Solution


```java
class Solution {
    public List<Integer> preorderTraversal(TreeNode root) {
        List<Integer> res = new ArrayList<Integer>();
        if (root == null) {
            return res;
        }

        Deque<TreeNode> stack = new LinkedList<TreeNode>();
        TreeNode node = root;
        while (!stack.isEmpty() || node != null) {
            while (node != null) {
                res.add(node.val);
                stack.push(node);
                node = node.left;
            }
            node = stack.pop();
            node = node.right;
        }
        return res;
    }
}
```



## 94. 二叉树的中序遍历
### Description
* [LeetCode-94. 二叉树的中序遍历](https://leetcode-cn.com/problems/binary-tree-inorder-traversal/)

### Approach 1-递归法

#### Analysis


参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(n)`，其中 `n` 是二叉树的节点数。每一个节点恰好被遍历一次。
* 空间复杂度：`O(n)`，为递归过程中栈的开销，平均情况下为 `O(logn)`，最坏情况下树呈现链状，为 `O(n)`。



#### Solution

```java
class Solution {
    public List<Integer> inorderTraversal(TreeNode root) {
        List<Integer> res = new ArrayList<Integer>();
        inorder(root, res);
        return res;
    }

    public void inorder(TreeNode root, List<Integer> res) {
        if (root == null) {
            return;
        }
        inorder(root.left, res);
        res.add(root.val);
        inorder(root.right, res);
    }
}
```




### Approach 2-迭代法

#### Analysis

* ref-[二叉树的非递归遍历 | blog](https://www.cnblogs.com/dolphin0520/archive/2011/08/25/2153720.html)

参考 `leetcode-cn` 官方题解。**参考官方题解的动画加深理解。**




我们也可以用迭代的方式实现方法一的递归函数，**两种方式是等价的，区别在于递归的时候隐式地维护了一个栈，而我们在迭代的时候需要显式地将这个栈模拟出来，其余的实现与细节都相同。**



根据中序遍历的顺序，对于任一结点，优先访问其左孩子，而左孩子结点又可以看做一根结点，然后继续访问其左孩子结点，直到遇到左孩子结点为空的结点才进行访问，然后按相同的规则访问其右子树。因此其处理过程如下。对于任一结点P，
1) 若其左孩子不为空，则将P入栈并将P的左孩子置为当前的P，然后对当前结点P再进行相同的处理；
2) 若其左孩子为空，则取栈顶元素并进行出栈操作，访问该栈顶结点，然后将当前的P置为栈顶结点的右孩子；
3) 直到P为 NULL 并且栈为空则遍历结束




复杂度分析
* 时间复杂度：`O(n)`，其中 `n` 是二叉树的节点数。每一个节点恰好被遍历一次。
* 空间复杂度：`O(n)`，为迭代过程中显式栈的开销，平均情况下为 `O(logn)`，最坏情况下树呈现链状，为 `O(n)`。



#### Solution


```java
class Solution {
    public List<Integer> inorderTraversal(TreeNode root) {
        List<Integer> res = new ArrayList<Integer>();
        Deque<TreeNode> stk = new LinkedList<TreeNode>();
        while (root != null || !stk.isEmpty()) {
            while (root != null) {
                stk.push(root);
                root = root.left;
            }
            root = stk.pop();
            res.add(root.val);
            root = root.right;
        }
        return res;
    }
}
```



## 145. 二叉树的后序遍历

### Description
* [LeetCode-145. 二叉树的后序遍历](https://leetcode-cn.com/problems/binary-tree-postorder-traversal/)

### Approach 1-递归法

#### Analysis


参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(n)`，其中 `n` 是二叉树的节点数。每一个节点恰好被遍历一次。
* 空间复杂度：`O(n)`，为递归过程中栈的开销，平均情况下为 `O(logn)`，最坏情况下树呈现链状，为 `O(n)`。



#### Solution

```java
class Solution {
    public List<Integer> postorderTraversal(TreeNode root) {
        List<Integer> res = new ArrayList<Integer>();
        postorder(root, res);
        return res;
    }

    public void postorder(TreeNode root, List<Integer> res) {
        if (root == null) {
            return;
        }
        postorder(root.left, res);
        postorder(root.right, res);
        res.add(root.val);
    }
}
```





### Approach 2-迭代法

#### Analysis

* ref-[二叉树的非递归遍历 | blog](https://www.cnblogs.com/dolphin0520/archive/2011/08/25/2153720.html)

参考 `leetcode-cn` 官方题解。**参考官方题解的动画加深理解。**




我们也可以用迭代的方式实现方法一的递归函数，**两种方式是等价的，区别在于递归的时候隐式地维护了一个栈，而我们在迭代的时候需要显式地将这个栈模拟出来，其余的实现与细节都相同。**




后序遍历的非递归实现，是三种遍历方式中最难的一种。因为在后序遍历中，要保证左孩子和右孩子都已被访问并且左孩子在右孩子前访问的情况下，才能访问根结点。这就为流程的控制带来了难题。一种思路如下
* 对于任一结点P，将其入栈，然后沿其左子树一直往下搜索，直到搜索到没有左孩子的结点，此时该结点出现在栈顶。但是此时不能将其出栈并访问，因此其右孩子还为被访问。
* 所以接下来按照相同的规则对其右子树进行相同的处理，当访问完其右孩子时，**该结点又出现在栈顶**，此时可以将其出栈并加入到结果集合中。这样就保证了正确的访问顺序。
* 可以看出，在这个过程中，**每个结点都两次出现在栈顶，只有在第二次出现在栈顶时，才能将其出栈并加入到结果集合中**。因此需要多设置一个变量，标识该结点是否是第2次出现在栈顶（或其右节点已被访问）。
* 为了表示该状态，可以用一个结点 `prev` 记录上一次访问的右节点，当 `root.right == prev` 时，则表示该结点是第 2 次出现在栈顶（或其右节点已被访问）。


复杂度分析
* 时间复杂度：`O(n)`，其中 `n` 是二叉树的节点数。每一个节点恰好被遍历一次。
* 空间复杂度：`O(n)`，为迭代过程中显式栈的开销，平均情况下为 `O(logn)`，最坏情况下树呈现链状，为 `O(n)`。





下面结合具体实例，进行分析。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/tree-order-last-1.png)




1. 从根节点3开始遍历，沿其左子树一直向下，直到访问到结点 8。

```
| 8 |
-----
| 9 |
-----
| 3 |
-----
```


2. 将结点8加入结果集合，为了将栈的下一个元素 `9` 出栈，此处将 `root` 设为 `null`，代码如下


```java
if (root.right == null || ...) {
    res.add(root.val);
    root = null;
} else {
    // ...
}
```

此时，栈的信息如下。

```
| 9 |
-----
| 3 |
-----
```


3. 继续，将结点 `9` 出栈。此时，其右子树还没访问，不能将结点 `9` 出栈。所以继续将 `9` 入栈，并设置 `root = root.right`。代码如下


```java
if (root.right == null || ...) {
    // ...
} else {
    stack.push(root);
    root = root.right;
}
```

此时，栈的信息如下。

```
| 6 |
-----
| 9 |   //结点9 入栈了2次
-----
| 3 |
-----
```


4. 当结点 `6` 出栈后，结点 `9` 继续第2次出栈。这个时候按照现有代码逻辑(如下所示)，会继续将结点 `9` 入栈，从而造成死循环。


```java
if (root.right == null || ...) {
    // ...
} else {
    stack.push(root);
    root = root.right;
}
```

5. 根据分析，当结点第2次出栈（或其右节点已被访问）时，需要执行 `if` 分支逻辑。为了表示该状态，可以用一个结点 `prev` 记录上一次访问的右节点，当 `root.right == prev` 时，则表示该结点是第 2 次出现在栈顶（或其右节点已被访问）。此时，代码完善如下。


```
            //使用prev记录上次访问的右子节点 避免重复访问
            if (root.right == null || root.right == prev) {
                res.add(root.val);
                prev = root;
                root = null;
            } else {
                stack.push(root);
                root = root.right;
            }
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
    public List<Integer> postorderTraversal(TreeNode root) {
        List<Integer> res = new ArrayList<Integer>();
        if (root == null) {
            return res;
        }

        Deque<TreeNode> stack = new LinkedList<TreeNode>();
        TreeNode prev = null;
        while (root != null || !stack.isEmpty()) {
            while (root != null) {
                stack.push(root);
                root = root.left;
            }
            root = stack.pop();
            //使用prev记录上次访问的右子节点 避免重复访问
            if (root.right == null || root.right == prev) {
                res.add(root.val);
                prev = root;
                root = null;
            } else {
                stack.push(root);
                root = root.right;
            }
        }
        return res;
    }
}

```





## 114. 二叉树展开为链表
### Description
* [LeetCode-114. 二叉树展开为链表](https://leetcode-cn.com/problems/flatten-binary-tree-to-linked-list/)

### Approach 1-前序遍历

#### Analysis


参考 `leetcode-cn` 官方题解。



可以发现，展开的顺序即树的前序遍历结果。因为解决思路为
1. 先对树进行前序遍历，得到一个数组
2. 再遍历数组，对结点的指向进行修正。

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
    public void flatten(TreeNode root) {
        List<TreeNode> list = new ArrayList<TreeNode>();
        preorderTraversal(root, list); //前序遍历
        int size = list.size();
        //修改结点的指向
        for (int i = 1; i < size; i++) {
            TreeNode prev = list.get(i - 1);
            TreeNode curr = list.get(i);
            prev.left = null;
            prev.right = curr;
        }
    }
    public void preorderTraversal(TreeNode root, List<TreeNode> list) {
        if (root != null) {
            list.add(root);
            preorderTraversal(root.left, list);
            preorderTraversal(root.right, list);
        }
    }
}

```


