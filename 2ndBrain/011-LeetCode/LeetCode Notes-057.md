# LeetCode Notes-057


[TOC]



## 更新
* 2021/08/05，撰写
* 2021/08/08，撰写


## Overview
* [LeetCode-剑指 Offer II 024. 反转链表](https://leetcode-cn.com/problems/UHnkqh/)
* [LeetCode-1266. 访问所有点的最小时间](https://leetcode-cn.com/problems/minimum-time-visiting-all-points/)
* [LeetCode-剑指 Offer II 041. 滑动窗口的平均值](https://leetcode-cn.com/problems/qIsx9U/)
* [LeetCode-剑指 Offer II 042. 最近请求次数](https://leetcode-cn.com/problems/H8086Q/)
* [LeetCode-1773. 统计匹配检索规则的物品数量](https://leetcode-cn.com/problems/count-items-matching-a-rule/)




## 剑指 Offer II 024. 反转链表
### Description
* [LeetCode-剑指 Offer II 024. 反转链表](https://leetcode-cn.com/problems/UHnkqh/)

### Approach 1-原地翻转
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution




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
    public ListNode reverseList(ListNode head) {
        if(head == null || head.next == null){
            return head;
        }
        ListNode dummpNode = new ListNode(0);
        dummpNode.next = head;

        ListNode prevNode = null; //记录上一个节点
        while(head != null){
            ListNode temp = head.next;
            head.next = prevNode;
            prevNode = head;
            head = temp;
        }
        return prevNode;
    }
}



```




## 1266. 访问所有点的最小时间
### Description
* [LeetCode-1266. 访问所有点的最小时间](https://leetcode-cn.com/problems/minimum-time-visiting-all-points/)

### Approach 1-切比雪夫距离
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution




```java
class Solution {
    public int minTimeToVisitAllPoints(int[][] points) {
        int x0 = points[0][0];
        int y0 = points[0][1];
        int ans = 0;
        for(int i=1;i<points.length;i++){
            int x1 = points[i][0];
            int y1 = points[i][1];
            ans += Math.max(Math.abs(x1-x0),Math.abs(y1-y0));
            x0 = x1;
            y0 = y1; 
        }
        return ans;
    }
}
```




## 剑指 Offer II 041. 滑动窗口的平均值
### Description
* [LeetCode-剑指 Offer II 041. 滑动窗口的平均值](https://leetcode-cn.com/problems/qIsx9U/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution



```java
class MovingAverage {

    int size;
    Queue<Integer> stream;
    double total = 0;

    /** Initialize your data structure here. */
    public MovingAverage(int size) {
        this.size = size;
        stream = new LinkedList<>();
    }
    
    public double next(int val) {
        if(stream.size() < size){
            total += val;
            //stream.add(val);   //若队列有大小限制 队列已满时 使用add会抛出异常 使用offer只会返回false
            stream.offer(val);
        } else {
            total += val;
            total -= stream.poll();
            stream.offer(val);
        }
         return total/stream.size();
    }
}



/**
 * Your MovingAverage object will be instantiated and called as such:
 * MovingAverage obj = new MovingAverage(size);
 * double param_1 = obj.next(val);
 */

```




## 剑指 Offer II 042. 最近请求次数
### Description
* [LeetCode-剑指 Offer II 042. 最近请求次数](https://leetcode-cn.com/problems/H8086Q/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class RecentCounter {
    Deque<Integer> queue; //建立队列

    public RecentCounter() {
       queue =  new LinkedList<>();
    }

    public int ping(int t) {
        queue.add(t); //添加到队列
        while(t-3000 > queue.peek()){ //超过3000差值即队头出列
            queue.poll(); //pop时若队列为空 会抛出异常 建议使用poll()
        }
        return queue.size();
    }
}

/**
 * Your RecentCounter object will be instantiated and called as such:
 * RecentCounter obj = new RecentCounter();
 * int param_1 = obj.ping(t);
 */

```



## 1773. 统计匹配检索规则的物品数量
### Description
* [LeetCode-1773. 统计匹配检索规则的物品数量](https://leetcode-cn.com/problems/count-items-matching-a-rule/)

### Approach 1-暴力
#### Analysis

参考 `leetcode-cn` 官方题解。


该方法会超时，此处仅做记录。

#### Solution

```java
class Solution {
    public int countMatches(List<List<String>> items, String ruleKey, String ruleValue) {
        Map<String,Integer> typeMap = new HashMap<>();
        Map<String,Integer> colorMap = new HashMap<>();
        Map<String,Integer> nameMap = new HashMap<>();
        for(List<String> list:items){
            typeMap.put(list.get(0),1 + typeMap.getOrDefault(list.get(0),0));
            colorMap.put(list.get(1),1 + colorMap.getOrDefault(list.get(1),0));
            nameMap.put(list.get(2),1 + nameMap.getOrDefault(list.get(2),0));
        }
        if("type".equals(ruleKey)){
            return typeMap.getOrDefault(ruleValue,0);
        } else if("color".equals(ruleKey)){
            return colorMap.getOrDefault(ruleValue,0);
        } else if("name".equals(ruleKey)){
            return nameMap.getOrDefault(ruleValue,0);
        }
        return 0;
    }
}
```


