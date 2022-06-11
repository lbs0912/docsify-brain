
# LeetCode Notes-012


[TOC]


## 更新
* 2020/11/01，撰写
* 2020/11/07，完成


## Overview
* [LeetCode-1408. 数组中的字符串匹配](https://leetcode-cn.com/problems/string-matching-in-an-array/description/)
* [LeetCode-704. 二分查找](https://leetcode-cn.com/problems/binary-search/)
* [LeetCode-20. 有效的括号](https://leetcode-cn.com/problems/valid-parentheses/)
* [LeetCode-21. 合并两个有序链表](https://leetcode-cn.com/problems/merge-two-sorted-lists/)
* [LeetCode-1475. 商品折扣后的最终价格](https://leetcode-cn.com/problems/final-prices-with-a-special-discount-in-a-shop/)




## 1408. 数组中的字符串匹配
### Description
* [LeetCode-1408. 数组中的字符串匹配](https://leetcode-cn.com/problems/string-matching-in-an-array/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public List<String> stringMatching(String[] words) {
        Set<String> set = new HashSet<>();
        int len = words.length;
        for(int i=0;i<len;i++){
            for(int j=0;j<words.length;j++){
                if(i == j){
                    continue;
                }
                if(words[i].contains(words[j])){
                    set.add(words[j]);
                }

            } 
        }
        return new ArrayList<>(set);
    }
}
```


## 704. 二分查找
### Description

* [LeetCode-704. 二分查找](https://leetcode-cn.com/problems/binary-search/)



### Approach 1-基本操作

#### Analysis
复杂度分析
* 时间复杂度: `O(logn)`
* 空间复杂度: `O(1)`



#### Solution


* Java


```java
class Solution {
    public int search(int[] nums, int target) {
        int low = 0;
        int high = nums.length-1;
        while(low <= high){
            int mid = low + (high-low)/2;
            if(nums[mid] > target){
                high = mid-1;
            }else if(nums[mid] < target){
                low = mid+1;
            } else{
                return mid;
            }
        }
        return -1;
    }
}
```


## 20. 有效的括号

### Description

* [LeetCode-20. 有效的括号](https://leetcode-cn.com/problems/valid-parentheses/)






### Approach 1-入栈操作

#### Analysis

参考 `leetcode-cn` 官方题解。


需要说明的是
1. 先判断字符串的长度，若为奇数，则直接返回 `false`。
2. 遇见左括号，进行入栈操作。
3. 遇见右括号，查询栈顶元素是否和当前右括号匹配。
4. 出于性能考虑，使用 `Deque` 代替 `Vector` 和 `Stack`

复杂度分析
* 时间复杂度：`O(n)`，其中 `n` 是字符串 `s` 的长度。
* 空间复杂度：`O(n+∣Σ∣)`，其中 `Σ` 表示字符集，本题中字符串只包含 6 种括号，`∣Σ∣=6`。栈中的字符数量为 `O(n)`，而哈希映射使用的空间为 `O(∣Σ∣)`，相加即可得到总空间复杂度。



#### Solution

```java
class Solution {
    public boolean isValid(String s) {
        int n = s.length();
        //奇数直接返回false
        if (n % 2 == 1) {
            return false;
        }

        Map<Character, Character> pairs = new HashMap<Character, Character>() {{
            put(')', '(');
            put(']', '[');
            put('}', '{');
        }};
        //出于性能考虑，使用 Deque 代替 Vector 和 Stack
        Deque<Character> stack = new LinkedList<Character>();
        for (int i = 0; i < n; i++) {
            char ch = s.charAt(i);
            if (pairs.containsKey(ch)) {
                //遇见右括号 在栈中查找匹配的左括号
                if (stack.isEmpty() || stack.peek() != pairs.get(ch)) {
                    return false;
                }
                stack.pop();
            } else {
                 //遇见左括号 入栈
                stack.push(ch);
            }
        }
        return stack.isEmpty();
    }
}
```


## 21. 合并两个有序链表

### Description

* [LeetCode-21. 合并两个有序链表](https://leetcode-cn.com/problems/merge-two-sorted-lists/)









### Approach 1-迭代法

#### Analysis


参考 `leetcode-cn` 官方题解。**注意哨兵节点的使用。**

复杂度分析
* 时间复杂度：`O(m+n)`，其中 `n` 和 `m` 分别为两个链表的长度。因为每次循环迭代中，`l1` 和 `l2` 只有一个元素会被放进合并链表中， 因此 `while` 循环的次数不会超过两个链表的长度之和。所有其他操作的时间复杂度都是常数级别的，因此总的时间复杂度为 `O(n+m)`。
* 空间复杂度：`O(1)`，只需要常数的空间存放若干变量。



#### Solution


* Java


```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode() {}
 *     ListNode(int val) { this.val = val; }
 *     ListNode(int val, ListNode next) { this.val = val; this.next = next; }
 * }
 */
class Solution {
    public ListNode mergeTwoLists(ListNode l1, ListNode l2) {
        ListNode res = new ListNode(-1);
        ListNode head  = res;
        while(l1 != null && l2 != null){
            if(l1.val <= l2.val){
                res.next = l1;
                l1 = l1.next;
            }else{
                res.next = l2;
                l2 = l2.next;
            }
            res = res.next;
        }
        // 合并后 l1 和 l2 最多只有一个还未被合并完，我们直接将链表末尾指向未合并完的链表即可
        res.next = (null == l1)? l2:l1; 

        return head.next;
    }
}
```




## 1475. 商品折扣后的最终价格

### Description

* [LeetCode-1475. 商品折扣后的最终价格](https://leetcode-cn.com/problems/final-prices-with-a-special-discount-in-a-shop/)



### Approach 1-暴力法

#### Analysis

复杂度分析
* 时间复杂度：`O(n^2)`
* 空间复杂度：`O(n)`

#### Solution

* Java

```java
class Solution {
    public int[] finalPrices(int[] prices) {
            int length = prices.length;
            int[] res = new int[length];
            int discount = 0;
            for(int i=0;i<length;i++){
                discount = 0;
                for(int j=i+1;j<length;j++){
                    if(prices[j] <= prices[i]){
                        discount = prices[j];
                        break;
                    }
                }
                res[i] = prices[i] - discount;
            }
            return res;
    }
}
```