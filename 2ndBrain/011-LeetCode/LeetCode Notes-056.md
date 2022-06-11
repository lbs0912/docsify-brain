
# LeetCode Notes-056


[TOC]



## 更新
* 2021/07/31，撰写
* 2021/07/31，撰写


## Overview

* [LeetCode-155. 最小栈](https://leetcode-cn.com/problems/min-stack/)
* [LeetCode-1137. 第 N 个泰波那契数](https://leetcode-cn.com/problems/n-th-tribonacci-number/)
* [LeetCode-507. 完美数](https://leetcode-cn.com/problems/perfect-number/description/)
* [LeetCode-349. 两个数组的交集](https://leetcode-cn.com/problems/intersection-of-two-arrays/)
* [LeetCode-350. 两个数组的交集 II](https://leetcode-cn.com/problems/intersection-of-two-arrays-ii/description/)





## 155. 最小栈
### Description
* [LeetCode-155. 最小栈](https://leetcode-cn.com/problems/min-stack/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



使用一个辅助站，栈内元素的最小值就存储在辅助栈的栈顶元素中。

#### Solution


```java
class MinStack {
    Deque<Integer> xStack;
    Deque<Integer> minStack;

    /** initialize your data structure here. */
    public MinStack() {
        xStack = new LinkedList<Integer>();
        minStack = new LinkedList<Integer>();
        minStack.push(Integer.MAX_VALUE);
    }
    
    public void push(int val) {
        xStack.push(val);
        minStack.push(Math.min(minStack.peek(),val));
    }
    
    public void pop() {
        xStack.pop();
        minStack.pop();
    }
    
    public int top() {
        //peek 和 pop 都会返回栈顶的元素  但是peek只返回，不改变栈  pop会移除栈顶元素
        return xStack.peek();
    }
    
    public int getMin() {
        return minStack.peek();
    }
}

    
   

```








## 1137. 第 N 个泰波那契数
### Description
* [LeetCode-1137. 第 N 个泰波那契数](https://leetcode-cn.com/problems/n-th-tribonacci-number/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int tribonacci(int n) {
        int val = 0;
        if(n == 0){
            return 0;
        }else if(n == 1){
            return 1;
        } else if(n == 2){
            return 1;
        } else{
            int i=2;
            int t0 = 0;
            int t1 = 1;
            int t2 = 1;
            while(i < n){
                i++;
                val = t0 + t1 + t2;
                t0 = t1;
                t1 = t2;
                t2 = val;
            }
        }
        return val;
    }
}
```



## 507. 完美数
### Description
* [LeetCode-507. 完美数](https://leetcode-cn.com/problems/perfect-number/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public boolean checkPerfectNumber(int num) {
        int sum = 0;
        if(num == 1){
            return false;
        }
        for(int i=1;(i*i)<=num;i++){
            int factor = num/i;
            if(factor * i == num){
                sum += i;
                if(i != factor && factor != num){
                    sum += factor;
                }
            }
        }

        return sum == num;

    }
}
```








## 349. 两个数组的交集
### Description

* [LeetCode-349. 两个数组的交集](https://leetcode-cn.com/problems/intersection-of-two-arrays/)


### Approach 1-排序+双指针
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int[] intersection(int[] nums1, int[] nums2) {
        Arrays.sort(nums1);
        Arrays.sort(nums2);

        List<Integer> list = new ArrayList<>();
        int index1 = 0;
        int index2 = 0;
        while(index1 < nums1.length && index2 < nums2.length){
            int num1 = nums1[index1];
            int num2 = nums2[index2];
            if(num1 == num2){ //保证加入元素的唯一性
                if(list.size() == 0 || (num1 != list.get(list.size()-1))){
                    list.add(num1);
                }
                index1++;
                index2++;
            } else if(num1 < num2){
                index1++;
            } else{
                index2++;
            }
        }
        // return list.stream().mapToInt(i-> i).toArray(); //或者
        return list.stream().mapToInt(Integer::valueOf).toArray();

    }
}
```





### Approach 2-哈希查找


#### Analysis

计算两个数组的交集，直观的方法是遍历数组 `nums1`，对于其中的每个元素，遍历数组 `nums2` 判断该元素是否在数组 `nums2` 中，如果存在，则将该元素添加到返回值。假设数组 `nums1` 和 `nums2` 的长度分别是 `m` 和 `n`，则遍历数组 `nums1` 需要 `O(m)` 的时间，判断 `nums1` 中的每个元素是否在数组 `nums2` 中需要 `O(n)` 的时间，因此总时间复杂度是 `O(mn)`。

**如果使用哈希集合存储元素，则可以在 `O(1)` 的时间内判断一个元素是否在集合中，从而降低时间复杂度。**

首先使用两个集合分别存储两个数组中的元素，**然后遍历较小的集合**，判断其中的每个元素是否在另一个集合中，如果元素也在另一个集合中，则将该元素添加到返回值。该方法的时间复杂度可以降低到 `O(m+n)`。



复杂度分析
* 时间复杂度: `O(m+n)`，其中 `m` 和 `n` 分别是两个数组的长度。使用两个集合分别存储两个数组中的元素需要 `O(m+n)` 的时间，遍历较小的集合并判断元素是否在另一个集合中需要 `O(min(m,n))` 的时间，因此总时间复杂度是 `O(m+n)`。
* 空间复杂度：`O(m+n)`，其中 `m` 和 `n` 分别是两个数组的长度。空间复杂度主要取决于两个集合。



#### Solution

* Java


```java
class Solution {
    public int[] intersection(int[] nums1, int[] nums2) {
        Set<Integer> set1 = new HashSet<Integer>();
        Set<Integer> set2 = new HashSet<Integer>();
        for(int num:nums1){
            set1.add(num);
        }
        for(int num:nums2){
            set2.add(num);
        }
        return getIntersection(set1,set2);
    }
    public int[] getIntersection(Set<Integer> set1,Set<Integer> set2){
        if(set1.size() > set2.size()){
            return getIntersection(set2,set1);
        }
        Set<Integer> intersectionSet = new HashSet<Integer>();
        for(int num:set1){
            if(set2.contains(num)){
                intersectionSet.add(num);
            }
        }
        int[] intersection = new int[intersectionSet.size()];
        int index = 0;
        for(int num : intersectionSet){
            intersection[index++] = num;
        }
        return intersection;
    }
}
```




## 350. 两个数组的交集 II
### Description
* [LeetCode-350. 两个数组的交集 II](https://leetcode-cn.com/problems/intersection-of-two-arrays-ii/description/)

### Approach 1-排序+双指针
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public int[] intersect(int[] nums1, int[] nums2) {
        Arrays.sort(nums1);
        Arrays.sort(nums2);
        List<Integer> list = new ArrayList<>();
        int index1 = 0;
        int index2 = 0;
        while(index1 < nums1.length && index2 < nums2.length){
            int num1 = nums1[index1];
            int num2 = nums2[index2];
            if(num1 == num2){ //保证加入元素的唯一性
                list.add(num1);
                index1++;
                index2++;
            } else if(num1 < num2){
                index1++;
            } else{
                index2++;
            }
        }
        // return list.stream().mapToInt(i-> i).toArray(); //或者
        return list.stream().mapToInt(Integer::valueOf).toArray();
    }
}


```


### Approach 2-哈希表
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public int[] intersect(int[] nums1, int[] nums2) {
        Map<Integer,Integer> map1 = new HashMap<>();
        Map<Integer,Integer> map2 = new HashMap<>();
        for(int val1:nums1){
            map1.put(val1,1 + map1.getOrDefault(val1,0));
        }
        for(int val2:nums2){
            map2.put(val2,1 + map2.getOrDefault(val2,0));
        }

        List<Integer> list = new ArrayList<>();

        for(Map.Entry<Integer,Integer> entry:map1.entrySet()){
            int key = entry.getKey();
            if(map2.containsKey(key)){
                int count = Math.min(entry.getValue(),map2.get(key));
                for(int i=0;i<count;i++){
                    list.add(key);
                }
            }
        }
        return list.stream().mapToInt(Integer::valueOf).toArray();
    }
}


```
