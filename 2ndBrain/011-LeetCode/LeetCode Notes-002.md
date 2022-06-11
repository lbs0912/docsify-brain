# LeetCode Notes-002


[TOC]



## 更新
* 2019/10/28，撰写
* 2019/11/22，整理完成

## Overview

* [LeetCode-206. Reverse Linked List（反转链表）](https://leetcode.com/problems/reverse-linked-list/) - 链表操作
* [LeetCode-617. Merge Two Binary Trees](https://leetcode.com/problems/merge-two-binary-trees/) - 二叉树
* [LeetCode-104. Maximum Depth of Binary Tree（二叉树的最大深度）](https://leetcode.com/problems/maximum-depth-of-binary-tree/) - 遍历二叉树
* [LeetCode-1290. Convert Binary Number in a Linked List to Integer（二进制链表转整数）](https://leetcode.com/problems/convert-binary-number-in-a-linked-list-to-integer/)
* [LeetCode-709. To Lower Case（转换成小写字母）](https://leetcode.com/problems/to-lower-case/)

##  206. Reverse Linked List（反转链表）
### Description
* [LeetCode-206.Reverse Linked List（反转链表）](https://leetcode.com/problems/reverse-linked-list/)



### Approach 1-迭代

#### Analysis

* 遍历列表，将当前节点的 `next` 指针改为指向前一个元素，实现对列表的反转。最后，返回新的头引用。
* 时间复杂度：`O(n)`
* 空间复杂度：`O(1)`

#### Solution

* Java

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
    public ListNode reverseList(ListNode head) {
        ListNode prev = null;
        ListNode curr = head;
        while (curr != null) {
            ListNode nextTemp = curr.next;
            curr.next = prev;
            prev = curr;
            curr = nextTemp;
        }
        return prev;

    }
}
```

* C++

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        ListNode *curr = head;
        ListNode *prev = NULL;
        while(curr != NULL){
            ListNode *tmpNext = curr->next;
            curr->next = prev;
            prev= curr;
            curr = tmpNext;
        }
        return prev;
    }
};
```




### Approach 2-递归 

#### Analysis
* [LeetCode-206.反转列表 | 官方题解](https://leetcode-cn.com/problems/reverse-linked-list/solution/fan-zhuan-lian-biao-by-leetcode/)
* 从递归角度分析该问题，假设列表的其余部分已经被反转，现考虑该如何反转
* 对于列表，假设其 `$[n_{k-1},n_{m}]$` 部分已完成反转，当前对节点 `$n_{k}$` 进行操作，使得 `$n_{k+1}$` 的下一个节点指向 `$n_{k}$`，即 `$n_{k}.next.next = n_{k}$`。

```math

n_{1}\rightarrow ... \rightarrow n_{k-1} \rightarrow n_{k} \rightarrow n_{k+1} \leftarrow ... \leftarrow n_{m} \leftarrow null
 
```

* 需要小心的是节点 `$n_{1}$` 的 `next` 指针需要指向 `null`。若忽略了这一点，链表中可能会产生循环。（使用大小为 2 的链表测试，可能会捕获此错误）
* 时间复杂度：`O(n)`
* 空间复杂度：`O(n)`：由于使用递归，将会使用隐式栈空间，递归深度可能会达到 `n` 层


#### Solution

* Java

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
    public ListNode reverseList(ListNode head) {
        if(head == null || head.next == null){
            return head;
        }
        ListNode reverseTmpList = reverseList(head.next);
        head.next.next = head;
        head.next = null;
        return reverseTmpList;
        
    }
}
```

* C++

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
       if(head == NULL || head->next == NULL){
           return head;
       }
        ListNode *reverseTmpList = reverseList(head->next);
        head->next->next = head;
        head->next = NULL;
        return reverseTmpList;
    }
};
```








## 617. Merge Two Binary Trees（合并二叉树）
### Description
* [LeetCode-617.Merge Two Binary Trees（合并二叉树）](https://leetcode.com/problems/merge-two-binary-trees/)

### Approach 1-递归

#### Analysis
* 使用递归方法求解
* 时间复杂度：`O(m)` 。递归方法中，共有 `m` 个节点需要遍历（`m` 为给定的两个二叉树节点数目的最小值）
* 空间复杂度：`O(m)` 。递归栈的深度，最差情况下最大值可为 `m`。递归深度平均值为 `log(m)`

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
    public TreeNode mergeTrees(TreeNode t1, TreeNode t2) {
        if(t1 == null) return t2;
        if(t2 == null) return t1;
        t1.val += t2.val;
        t1.left = mergeTrees(t1.left,t2.left);
        t1.right = mergeTrees(t1.right,t2.right);
        return t1;
    }
}
```






## 104. Maximum Depth of Binary Tree（二叉树的最大深度）
### Description
* [LeetCode-104. Maximum Depth of Binary Tree（二叉树的最大深度）](https://leetcode.com/problems/maximum-depth-of-binary-tree/)

### Approach 1-递归

#### Analysis

* 使用递归方法求解
* 时间复杂度：`O(n)` ：每个节点均遍历一次，其中 `n` 为节点数
* 空间复杂度：`O(n)`：最糟糕情况下，树是完全不平衡的，例如每个节点只有左子节点，递归将被调用 `n` 次（树的高度），最差空间复杂度为 `O(n)`。最好情况下（树是完全平衡的），树的高度为 `log(n)`
* 递归栈的深度，最差情况下最大值可为 `m`。递归深度平均值为 `log(n)`，此时空间复杂度是 `O(log(n))`。

#### Solution

```
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
  public int maxDepth(TreeNode root) {
    if (root == null) {
      return 0;
    } else {
      int left_height = maxDepth(root.left);
      int right_height = maxDepth(root.right);
      return java.lang.Math.max(left_height, right_height) + 1;
    }
  }
}
```






## 1290. Convert Binary Number in a Linked List to Integer（二进制链表转整数）
### Description
* [LeetCode-1290. Convert Binary Number in a Linked List to Integer（二进制链表转整数）](https://leetcode.com/problems/convert-binary-number-in-a-linked-list-to-integer/)

### Approach 1-模拟二进制转十进制+位操作

#### Analysis
* 由于链表中从高位到低位存放了数字的二进制表示，因此可以使用二进制转十进制的方法，在遍历一遍链表的同时，得到数字的十进制值。
* 时间复杂度：`O(n)`，其中 `n` 是链表中的节点个数
* 空间复杂度：`O(1)`

需要注意的是，在求解过程中（如下）

```
int sum = 0;
while(head != null){
    //sum = 2*sum + head.val;
    sum = sum<<1 | head.val;
    head = head.next;
}
return sum;
```

使用 `sum = 2*sum + head.val` 计算，乘法操作耗时是大于位操作的。因此，该步骤可优化为

```
//sum = 2*sum + head.val;
sum = sum<<1 | head.val;
```
> LeetCode平台，C++语言，使用乘法操作 `sum = 2*sum + head.val`，耗时4ms，内存消耗8.4M；使用位操作 `sum = sum<<1 | head.val;`，耗时0ms，内存消耗8.3M

#### Solution

* Java


```
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
class Solution {
    public int getDecimalValue(ListNode head) {
        int sum = 0;
        while(head != null){
            //sum = 2*sum + head.val;
            sum = sum<<1 | head.val;
            head = head.next;
        }
        return sum;
    }
}
```
* C++

```
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    int getDecimalValue(ListNode* head) {
        int sum = 0;
        while(head){
            sum = sum<<1 | head->val;
            head = head->next;
        }
        return sum;
    }
};
```



## 709. To Lower Case（转换成小写字母）
### Description
* [LeetCode-709. To Lower Case（转换成小写字母）](https://leetcode.com/problems/to-lower-case/)

### Approach 1-ASCII编码转换

#### Analysis

* 使用 ASCII 编码进行大小写字母转换。大写字母 `A~Z` 的 ASCII值为 `65~90`;小写字母 `a~z` 的 ASCII值为 `97~122`。小写字母 `a` 和大写字母 `A` 的 ASCII 码差值为 32。
* 时间复杂度：`O(n)`，其中 `n` 是字符串长度
* 空间复杂度：`O(1)`

更进一步，观察大小写字母 ASCII 码的二进制

```
A----65-----1000001
a----97-----1100001
```

因此，在大小转换时，可使用位运算，进行或操作

```
char c = (char)(str.charAt(i) | (char)(32));
```

#### Solution

* Java

```
class Solution {
    public String toLowerCase(String str) {
        StringBuilder res = new StringBuilder();
        for(int i=0;i<str.length();i++){
            char c = (char)(str.charAt(i) | (char)(32));
            res.append(c);
        }
        return res.toString();
    }
}
```

上述方法，耗时0ms，内存34.2MB。如果使用Java内置的 `toLowerCase()` 方法，耗时0ms，内存34.1MB。

```
class Solution {
    public String toLowerCase(String str) {
        return str.toLowerCase();
    }
}
```

* C++

```
class Solution {
public:
    string toLowerCase(string str) {
        for(int i=0;i<str.length();i++){
            if(str[i] >= 'A' && str[i] <= 'Z'){
                str[i] += 32;
            }
        }
        return str;
    }
};
```
