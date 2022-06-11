
# LeetCode Notes-036


[TOC]



## 更新
* 2021/06/28，撰写
* 2021/06/30，完成

## Overview
* [LeetCode-1796. 字符串中第二大的数字](https://leetcode-cn.com/problems/second-largest-digit-in-a-string/description/)
* [LeetCode-1446. 连续字符](https://leetcode-cn.com/problems/consecutive-characters/description/)
* [LeetCode-328. 奇偶链表](https://leetcode-cn.com/problems/odd-even-linked-list/description/)
* [LeetCode-876. 链表的中间结点](https://leetcode-cn.com/problems/middle-of-the-linked-list/description/)
* [LeetCode-143. 重排链表](https://leetcode-cn.com/problems/reorder-list/description/)




## 1796. 字符串中第二大的数字
### Description
* [LeetCode-1796. 字符串中第二大的数字](https://leetcode-cn.com/problems/second-largest-digit-in-a-string/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public int secondHighest(String s) {
        int length = s.length();
        int maxVal = -1;
        int secondaryVal = -1;
        for(int i=0;i<length;i++){
            if(Character.isDigit(s.charAt(i))){
                int val = Integer.parseInt(String.valueOf(s.charAt(i)));
                if(val > maxVal){
                    secondaryVal = maxVal;
                    maxVal = val;
                } else if(val < maxVal && val > secondaryVal){
                    secondaryVal = val;
                }
            }
        }
        return secondaryVal;
    }
}
```


## 1446. 连续字符
### Description
* [LeetCode-1446. 连续字符](https://leetcode-cn.com/problems/consecutive-characters/description/)

### Approach 1-一次遍历
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public int maxPower(String s) {
        int maxPower = 1;
        if(s.isEmpty()){
            return 0;
        }
        char prev = s.charAt(0);
        int length = s.length();
        char cur;
        int tempCount = 1;
        for(int i=1;i<length;i++){
            cur = s.charAt(i);
            if(prev == cur){
                tempCount++;
            } else{
                tempCount = 1;
            }
            prev = cur;
            maxPower = Math.max(maxPower, tempCount);
        }
        return maxPower;

    }
}
```





## 328. 奇偶链表
### Description
* [LeetCode-328. 奇偶链表](https://leetcode-cn.com/problems/odd-even-linked-list/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(n)`，其中 n 是链表的节点数。需要遍历链表中的每个节点，并更新指针。
* 空间复杂度：`O(1)`。只需要维护有限的指针。


#### Solution



```java
class Solution {
    public ListNode  oddEvenList(ListNode head) {
        if(null == head || null == head.next){
            return head;
        }
        ListNode oddList = head;
        ListNode evenList = head.next;
        ListNode evenHead = evenList;
        ListNode oddHead = oddList;
        head = head.next.next;
        while(null != head){
            oddList.next = head;
            oddList = oddList.next;
            head = head.next;

            evenList.next = head;
            evenList = evenList.next;
            if(null != head){
                head = head.next;
            }
        }
        oddList.next = evenHead;
        return oddHead;

    }
}
```

如上代码所示，维护一个奇数链表指针 `oddList`，维护一个偶数链表指针 `evenList`。最后将两个链表拼接在一起。


下述代码更加简洁【官方版本】，直接在原链表上操作，存储奇数链表信息。


```java
class Solution {
    public ListNode  oddEvenList(ListNode head) {
        if(null == head || null == head.next){
            return head;
        }
        ListNode oddList = head;
        ListNode evenList = head.next;
        ListNode evenHead = evenList;
        while(null != evenList && null != evenList.next){
            oddList.next = evenList.next;
            oddList = oddList.next;
            evenList.next  = oddList.next;
            evenList = evenList.next;
        }
        oddList.next = evenHead;
        return head;

    }
}
```








## 876. 链表的中间结点
### Description
* [LeetCode-876. 链表的中间结点](https://leetcode-cn.com/problems/middle-of-the-linked-list/description/)

### Approach 1-双指针
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(N)，其中 N 是给定链表的结点数目。
* 空间复杂度：`O(1)`，只需要常数空间存放 slow 和 fast 两个指针。


需要注意的是，对于中间节点有两个的情况
1. 若要返回第2个节点，代码对应的循环终止条件为 `while(null != fast && null != fast.next)`
1. 若要返回第1个节点，代码对应的循环终止条件为 `while(null != fast.next && null != fast.next.next)`


#### Solution


```java
class Solution {
    public ListNode middleNode(ListNode head) {
        ListNode slow = head;
        ListNode fast = head;
        while(null != fast && null != fast.next){  //若有两个中间节点，返回第2个节点
            slow = slow.next;
            fast = fast.next.next;
        }
        return slow;
    }
}
```





## 143. 重排链表
### Description
* [LeetCode-143. 重排链表](https://leetcode-cn.com/problems/reorder-list/description/)

### Approach 1-线性表
#### Analysis

参考 `leetcode-cn` 官方题解。


因为链表不支持下标访问，所以我们无法随机访问链表中任意位置的元素。

因此比较容易想到的一个方法是，我们利用线性表存储该链表，然后利用线性表可以下标访问的特点，直接按顺序访问指定元素，重建该链表即可。

**需要注意的是，在重排链表结束后，记得将最新链表尾元素的 `next` 设置为 `null`。**


复杂度分析
* 时间复杂度：`O(N)`，其中 N 是链表中的节点数。
* 空间复杂度：`O(N)`，其中 N 是链表中的节点数。主要为线性表的开销。


#### Solution


```java
class Solution {
    public void reorderList(ListNode head) {
        if(null == head){
            return;
        }
        List<ListNode> list = new ArrayList<>();
        ListNode node = head;
        while(null != node){
            list.add(node);
            node = node.next;
        }
        int begin = 0, end = list.size()-1;
        while(begin < end){
            list.get(begin).next = list.get(end);
            begin++;
        
            list.get(end).next = list.get(begin);
            end--;
        }
        list.get(begin).next = null; //注意尾元素的next 设置为null
    }
}
```



### Approach 2-寻找链表中点 + 链表逆序 + 合并链表
#### Analysis

参考 `leetcode-cn` 官方题解。


**注意到目标链表即为将原链表的左半端和反转后的右半端合并后的结果。** 这样我们的任务即可划分为 3 步
1. 找到原链表的中点（参考「876. 链表的中间结点」）。我们可以使用快慢指针来 `O(N)` 地找到链表的中间节点。
2. 将原链表的右半端反转（参考「206. 反转链表」）。我们可以使用迭代法实现链表的反转。
3. 将原链表的两端合并。因为两链表长度相差不超过 1，因此直接合并即可。

**需要注意的是，在重排链表结束后，记得将最新链表尾元素的 `next` 设置为 `null`。**



复杂度分析
* 时间复杂度：`O(N)`，其中 N 是链表中的节点数。
* 空间复杂度：`O(1)`。


#### Solution


```java
class Solution {

    private ListNode middleNode(ListNode head){
        ListNode slow = head;
        ListNode fast = head;
        while(null != fast.next && null != fast.next.next){
            slow = slow.next;
            fast = fast.next.next;
        }
        return slow;
    }

    private ListNode reverseList(ListNode head){
        ListNode prev = null;
        ListNode cur = head;
        while(null != cur){
            ListNode nextTemp = cur.next;
            cur.next = prev;
            prev = cur;
            cur = nextTemp;
        }
        return prev;
    }
 
    private void mergeList(ListNode l1, ListNode l2){
        ListNode l1_tmp;
        ListNode l2_tmp;
        while(null != l1 && null != l2){
            l1_tmp = l1.next;
            l2_tmp = l2.next;

            l1.next = l2;
            l1 = l1_tmp;

            l2.next = l1;
            l2 = l2_tmp;
        }
    }

    public void reorderList(ListNode head) {
        if (null == head) {
            return;
        }
        ListNode mid = middleNode(head);
        ListNode l1 = head;
        ListNode l2 = mid.next;
        mid.next = null; //注意尾元素的next 设置为null
        l2 = reverseList(l2);
        mergeList(l1, l2);
    }

}
```
