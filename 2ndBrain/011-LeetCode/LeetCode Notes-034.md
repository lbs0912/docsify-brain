
# LeetCode Notes-034


[TOC]



## 更新
* 2021/06/21，撰写
* 2021/06/22，完成


## Overview


* [LeetCode-796. 旋转字符串](https://leetcode-cn.com/problems/rotate-string/)
* [LeetCode-67. 二进制求和](https://leetcode-cn.com/problems/add-binary/)
* [LeetCode-203. 移除链表元素](https://leetcode-cn.com/problems/remove-linked-list-elements/description/)
* [LeetCode-83. 删除排序链表中的重复元素](https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list/description/)
* [LeetCode-82. 删除排序链表中的重复元素 II](https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list-ii/solution/)


## 796. 旋转字符串   
### Description
* [LeetCode-796. 旋转字符串](https://leetcode-cn.com/problems/rotate-string/)

### Approach 1-模拟竖式计算
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public boolean rotateString(String A, String B) {
        if (A.length() != B.length())
            return false;
        if (A.length() == 0)
            return true;

        search:
            for (int s = 0; s < A.length(); ++s) {
                for (int i = 0; i < A.length(); ++i) {
                    if (A.charAt((s+i) % A.length()) != B.charAt(i))
                        continue search;
                }
                return true;
            }
        return false;
    }
}
```


### Approach 2-判断子串
#### Analysis

参考 `leetcode-cn` 官方题解。


**由于 `A + A` 包含了所有可以通过旋转操作从 A 得到的字符串，因此我们只需要判断 B 是否为 A + A 的子串即可。**


复杂度分析
* 时间复杂度：`O(N^2)`，其中 N 是字符串 A 的长度。
* 空间复杂度：`O(N)`，即 A + A 需要的空间。


#### Solution



```java
class Solution {
    public boolean rotateString(String A, String B) {
        return A.length() == B.length() && (A + A).contains(B);
    }
}

```





## 67. 二进制求和   
### Description
* [LeetCode-67. 二进制求和](https://leetcode-cn.com/problems/add-binary/)

### Approach 1-模拟竖式计算
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public String addBinary(String a, String b) {
        StringBuffer ans = new StringBuffer();

        int n = Math.max(a.length(), b.length()), carry = 0;
        for (int i = 0; i < n; ++i) {
            carry += i < a.length() ? (a.charAt(a.length() - 1 - i) - '0') : 0;
            carry += i < b.length() ? (b.charAt(b.length() - 1 - i) - '0') : 0;
            ans.append((char) (carry % 2 + '0'));
            carry /= 2;
        }

        if (carry > 0) {
            ans.append('1');
        }
        ans.reverse();

        return ans.toString();
    }
}
```






## 203. 移除链表元素
### Description
* [LeetCode-203. 移除链表元素](https://leetcode-cn.com/problems/remove-linked-list-elements/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public ListNode removeElements(ListNode head, int val) {
        if(null == head){
            return head;
        }
        ListNode dummy = new ListNode(-1,head);
        ListNode cur = dummy;
        while(null != cur.next){
            if(val == cur.next.val){
                cur.next = cur.next.next;
            } else{
                cur = cur.next;
            }
        } 
        return dummy.next;
    }
}
```




## 83. 删除排序链表中的重复元素
### Description
* [LeetCode-83. 删除排序链表中的重复元素](https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public ListNode deleteDuplicates(ListNode head) {
        if(null == head || null == head.next){
            return head;
        }
        ListNode cur = head;
        while(null != cur.next){
            if(cur.val == cur.next.val){
                
                cur.next = cur.next.next;
            } else{
                cur = cur.next;
            }
        }
        return head;

    }
}
```



## 82. 删除排序链表中的重复元素 II
### Description
* [LeetCode-82. 删除排序链表中的重复元素 II](https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list-ii/solution/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public ListNode deleteDuplicates(ListNode head) {
        if (head == null) {
            return head;
        }
        
        ListNode dummy = new ListNode(0, head);

        ListNode cur = dummy;
        while (cur.next != null && cur.next.next != null) {
            if (cur.next.val == cur.next.next.val) {
                int x = cur.next.val;
                while (cur.next != null && cur.next.val == x) {
                    cur.next = cur.next.next;
                }
            } else {
                cur = cur.next;
            }
        }

        return dummy.next;
    }
}
```




