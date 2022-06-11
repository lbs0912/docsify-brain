



# LeetCode Notes-017


[TOC]


## 更新
* 2021/01/13，撰写
* 2021/01/13，完成


## Overview
* [LeetCode-2. 两数相加](https://leetcode-cn.com/problems/add-two-numbers/)
* [LeetCode-445. 两数相加 II](https://leetcode-cn.com/problems/add-two-numbers-ii/)
* [LeetCode-415. 字符串相加](https://leetcode-cn.com/problems/add-strings/)
* [LeetCode-43. 字符串相乘](https://leetcode-cn.com/problems/multiply-strings/)
* [LeetCode-66. 加一](https://leetcode-cn.com/problems/plus-one/)




## 2. 两数相加
### Description
* [LeetCode-2. 两数相加](https://leetcode-cn.com/problems/add-two-numbers/)

### Approach 1-数学进位模拟

#### Analysis


参考 `leetcode-cn` 官方题解。


注意处理最高位的进位情况。即

```java
//最高位进位
if (carry > 0) {
    tail.next = new ListNode(carry);
}
```

复杂度分析
* 时间复杂度：`O(max(m,n))`，其中 `m`,`n` 为两个链表的长度。我们要遍历两个链表的全部位置，而处理每个位置只需要 `O(1)` 的时间。
* 空间复杂度：`O(max(m,n))`。答案链表的长度最多为较长链表的长度+1。



#### Solution


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
    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        ListNode head = null, tail = null;
        int carry = 0;
        while (l1 != null || l2 != null) {
            int n1 = l1 != null ? l1.val : 0;
            int n2 = l2 != null ? l2.val : 0;
            int sum = n1 + n2 + carry;
            if (head == null) {  //最后结果需要返回头节点 因此此处保存head值
                head = tail = new ListNode(sum % 10);
            } else {
                tail.next = new ListNode(sum % 10);
                tail = tail.next;
            }
            carry = sum / 10;
            if (l1 != null) {
                l1 = l1.next;
            }
            if (l2 != null) {
                l2 = l2.next;
            }
        }
        //最高位进位
        if (carry > 0) {
            tail.next = new ListNode(carry);
        }
        return head;
    }
}
```



## 445. 两数相加 II
### Description
* [LeetCode-445. 两数相加 II](https://leetcode-cn.com/problems/add-two-numbers-ii/)

### Approach 1-栈

#### Analysis


参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(max(m,n))`，其中 `m` 与 `n` 分别为两个链表的长度。我们需要遍历每个链表。
* 空间复杂度：`O(m+n)`，其中 `m` 与 `n` 分别为两个链表的长度。这是我们把链表内容放入栈中所用的空间。




#### Solution

```java
class Solution {
    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        Deque<Integer> stack1 = new LinkedList<Integer>();
        Deque<Integer> stack2 = new LinkedList<Integer>();
        while (l1 != null) {
            stack1.push(l1.val);
            l1 = l1.next;
        }
        while (l2 != null) {
            stack2.push(l2.val);
            l2 = l2.next;
        }
        int carry = 0;
        ListNode ans = null;
        while (!stack1.isEmpty() || !stack2.isEmpty() || carry != 0) {
            //注意最高位进位!=0的情况
            int a = stack1.isEmpty() ? 0 : stack1.pop();
            int b = stack2.isEmpty() ? 0 : stack2.pop();
            int cur = a + b + carry;
            carry = cur / 10;
            cur %= 10;
            ListNode curnode = new ListNode(cur);
            curnode.next = ans;
            ans = curnode;
        }
        return ans;
    }
}
```


## 415. 字符串相加
### Description
* [LeetCode-415. 字符串相加](https://leetcode-cn.com/problems/add-strings/)

### Approach 1-模拟加法

#### Analysis


参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`$O(\max(\textit{len}_1,\textit{len}_2))$`，其中 `len1=num1.length`，`len2=num2.length`。
* 空间复杂度：`O(n)`。除答案外我们只需要常数空间存放若干变量。在 Java 解法中使用到了 `StringBuffer`，故 Java 解法的空间复杂度为 `O(n)`。



#### Solution

```java
class Solution {
    public String addStrings(String num1, String num2) {
        int i = num1.length()-1;
        int j = num2.length()-1;
        int carry =0;
        StringBuffer ans = new StringBuffer();
        while(i>=0 || j>=0 || carry != 0){ //注意最高位进位!=0的情况
            int x = i>=0? num1.charAt(i) - '0': 0;
            int y = j>=0? num2.charAt(j) - '0': 0;
            int result = x + y + carry;
            carry = result/10;
            result %= 10;
            ans.append(result);
            i--;
            j--;
        }
        ans.reverse(); //翻转
        return ans.toString();
    }
}
```



## 43. 字符串相乘
### Description
* [LeetCode-43. 字符串相乘](https://leetcode-cn.com/problems/multiply-strings/)

### Approach 1-回溯法

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution




## 66. 加一
### Description
* [LeetCode-66. 加一](https://leetcode-cn.com/problems/plus-one/)

### Approach 1

#### Analysis

根据题意，因为只存在加1，所以可能的情况就只有2种
* 除 99 之外的数字加一
* 数字 99

**加 1 运算，如不出现进位，则运算结束了，且进位只会是一。**


#### Solution



```java
class Solution {
    public int[] plusOne(int[] digits) {
        for (int i = digits.length - 1; i >= 0; i--) {
            digits[i]++;
            digits[i] = digits[i] % 10;
            if (digits[i] != 0) return digits; //若任何一位不产生进位 直接返回
        }
        //若执行到此，则一定为9999+1的情况，返回结果一定为10000
        digits = new int[digits.length + 1];
        digits[0] = 1;
        return digits;
    }
}
```



