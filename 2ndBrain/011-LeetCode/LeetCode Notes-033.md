
# LeetCode Notes-033


[TOC]



## 更新
* 2021/05/03，撰写
* 2021/06/08，完成


## Overview
* [LeetCode-19. 删除链表的倒数第 N 个结点](https://leetcode-cn.com/problems/remove-nth-node-from-end-of-list/description/)
* [LeetCode-24. 两两交换链表中的节点](https://leetcode-cn.com/problems/swap-nodes-in-pairs/description/)
* [LeetCode-530. 二叉搜索树的最小绝对差](https://leetcode-cn.com/problems/minimum-absolute-difference-in-bst/)
* [LeetCode-28. 实现 strStr()](https://leetcode-cn.com/problems/implement-strstr/)
* [LeetCode-345. 反转字符串中的元音字母](https://leetcode-cn.com/problems/reverse-vowels-of-a-string/)




## 19. 删除链表的倒数第 N 个结点
### Description
* [LeetCode-19. 删除链表的倒数第 N 个结点](https://leetcode-cn.com/problems/remove-nth-node-from-end-of-list/description/)


<font color="red">**在对链表进行操作时，一种常用的技巧是添加一个哑节点（dummy node），它的 `next` 指针指向链表的头节点。这样一来，我们就不需要对头节点进行特殊的判断了。**</font>


### Approach 1-计算链表长度
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public ListNode removeNthFromEnd(ListNode head, int n) {
        ListNode dummy = new ListNode(0, head);
        int length = getLength(head);
        ListNode cur = dummy;
        for (int i = 1; i < length - n + 1; ++i) {
            cur = cur.next;
        }
        cur.next = cur.next.next;
        ListNode ans = dummy.next;
        return ans;
    }

    public int getLength(ListNode head) {
        int length = 0;
        while (head != null) {
            ++length;
            head = head.next;
        }
        return length;
    }
}
```

复杂度分析
* 时间复杂度：`O(L)`，其中 L 是链表的长度。
* 空间复杂度：`O(1)`。


### Approach 2-栈
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public ListNode removeNthFromEnd(ListNode head, int n) {
        ListNode dummy = new ListNode(0, head);
        Deque<ListNode> stack = new LinkedList<ListNode>();
        ListNode cur = dummy;
        while (cur != null) {
            stack.push(cur);
            cur = cur.next;
        }
        for (int i = 0; i < n; ++i) {
            stack.pop();
        }
        ListNode prev = stack.peek();
        prev.next = prev.next.next;
        ListNode ans = dummy.next;
        return ans;
    }
}
```

复杂度分析
* 时间复杂度：`O(L)`，其中 L 是链表的长度。
* 空间复杂度：`O(L)`，其中 L 是链表的长度。主要为栈的开销。


### Approach 3-双指针
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public ListNode removeNthFromEnd(ListNode head, int n) {
        ListNode dummy = new ListNode(0, head);
        ListNode first = head;
        ListNode second = dummy;
        for (int i = 0; i < n; ++i) {
            first = first.next;
        }
        while (first != null) {
            first = first.next;
            second = second.next;
        }
        second.next = second.next.next;
        ListNode ans = dummy.next;
        return ans;
    }
}
```

复杂度分析
* 时间复杂度：`O(L)`，其中 L 是链表的长度。
* 空间复杂度：`O(1)`。



## 24. 两两交换链表中的节点

* [LeetCode-24. 两两交换链表中的节点](https://leetcode-cn.com/problems/swap-nodes-in-pairs/description/)

### Approach 1-双指针-节点交换
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public ListNode swapPairs(ListNode head) {
        if(null == head || null == head.next){
            return head;
        }

        ListNode begin = head;
        ListNode end = head.next;
        ListNode dummy = new ListNode(0,end);
        swapNode(begin,end,dummy);

        while(null != begin.next && null != begin.next.next){
            ListNode prev = begin;
            begin = begin.next;
            end = begin.next;
            swapNode(begin,end,prev);
        }
        return dummy.next;

    }

    // 1->2->3->4
    // 2->1->3->4
    // 2->1->4->3
    private void swapNode(ListNode begin, ListNode end,ListNode prev){
        ListNode nextNode = end.next;
        begin.next = nextNode;
        end.next = begin;
        prev.next = end;
    }
}
```

## 530. 二叉搜索树的最小绝对差
### Description
* [LeetCode-530. 二叉搜索树的最小绝对差](https://leetcode-cn.com/problems/minimum-absolute-difference-in-bst/)

### Approach 1-暴力
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
    int pre;
    int ans;

    public int getMinimumDifference(TreeNode root) {
        ans = Integer.MAX_VALUE;
        pre = -1;
        dfs(root);
        return ans;
    }

    public void dfs(TreeNode root) {
        if (root == null) {
            return;
        }
        dfs(root.left);
        if (pre == -1) {
            pre = root.val;
        } else {
            ans = Math.min(ans, root.val - pre);
            pre = root.val;
        }
        dfs(root.right);
    }
}
```



## 28. 实现 strStr()
### Description
* [LeetCode-28. 实现 strStr()](https://leetcode-cn.com/problems/implement-strstr/)

### Approach 1-暴力
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution




```java
class Solution {
    public int strStr(String haystack, String needle) {
        int m = haystack.length();
        int n = needle.length();
        if(n == 0){
            return 0;
        }
        if(n > m){
            return -1;
        }
        for(int i=0;i<=(m-n);i++){
            char beginC = needle.charAt(0);
            if(haystack.charAt(i) == beginC){
                boolean flag = true;
                for(int j=1;j<n;j++){  
                    if(haystack.charAt(i+j) != needle.charAt(j)){
                        flag = false;
                        break;
                    }
                }
                if(flag){
                    return i;
                }
                
            }
        }
        return -1;
    
    }
}
```




## 345. 反转字符串中的元音字母
### Description
* [LeetCode-345. 反转字符串中的元音字母](https://leetcode-cn.com/problems/reverse-vowels-of-a-string/)

### Approach 1-暴力
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public String reverseVowels(String s) {
        int length = s.length();
        if(length == 0 || length == 1){
            return s;
        }

        char[] arr = s.toCharArray();
        int left = 0;
        int right = length-1;
        while(left < right){
            char beginC = arr[left];
            char endC = arr[right];
            if(!isVowel(arr[left])){
                left++;
                continue;
            }
            if(!isVowel(arr[right])){
                right--;
                continue;
            }
            char temp = arr[left];
            arr[left] = arr[right];
            arr[right] = temp;

            left++;
            right--;
        }
        return new String(arr);
    }
    private boolean isVowel(char c){
        c = String.valueOf(c).toLowerCase().charAt(0); //使用此char -> String -> char 转换后，耗时7ms
        return c == 'a' || c == 'e' || c == 'i' ||  c == 'o' || c == 'u';
        // 使用下述判断  耗时3ms
        // return c == 'a' || c == 'e' || c == 'i' ||  c == 'o' || c == 'u' || c == 'A' || c == 'E' || c == 'I' ||  c == 'O' || c == 'U';
    }
}
```