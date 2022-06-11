# LeetCode Notes-051


[TOC]



## 更新
* 2021/07/24，撰写
* 2021/07/24，完成


## Overview
* [LeetCode-1108. IP 地址无效化](https://leetcode-cn.com/problems/defanging-an-ip-address/)
* [LeetCode-1603. 设计停车系统](https://leetcode-cn.com/problems/design-parking-system/)
* [LeetCode-1431. 拥有最多糖果的孩子](https://leetcode-cn.com/problems/kids-with-the-greatest-number-of-candies/)
* [LeetCode-912. 排序数组](https://leetcode-cn.com/problems/sort-an-array/)
* 【经典好题】[LeetCode-148. 排序链表](https://leetcode-cn.com/problems/sort-list/)



## 【水题】1108. IP 地址无效化
### Description
* [LeetCode-1108. IP 地址无效化](https://leetcode-cn.com/problems/defanging-an-ip-address/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public String defangIPaddr(String address) {
        return address.replaceAll("\\.","[.]");  //注意\\

    }
}
```




## 【水题】1603. 设计停车系统
### Description
* [LeetCode-1603. 设计停车系统](https://leetcode-cn.com/problems/design-parking-system/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution

```java
 class ParkingSystem {
    int big, medium, small;

    public ParkingSystem(int big, int medium, int small) {
        this.big = big;
        this.medium = medium;
        this.small = small;
    }
    
    public boolean addCar(int carType) {
        if (carType == 1) {
            if (big > 0) {
                big--;
                return true;
            }
        } else if (carType == 2) {
            if (medium > 0) {
                medium--;
                return true;
            }
        } else if (carType == 3) {
            if (small > 0) {
                small--;
                return true;
            }
        }
        return false;
    }
}

```


## 【水题】1431. 拥有最多糖果的孩子
### Description
* [LeetCode-1431. 拥有最多糖果的孩子](https://leetcode-cn.com/problems/kids-with-the-greatest-number-of-candies/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution




```java
class Solution {
    public List<Boolean> kidsWithCandies(int[] candies, int extraCandies) {
        int max = candies[0];
        for(int i=0;i<candies.length;i++){
            max = Math.max(max,candies[i]);
        }
        List<Boolean> list = new ArrayList<>();
        for(int i=0;i<candies.length;i++){
            if(max <= candies[i] + extraCandies){
                list.add(true);
            } else{
                list.add(false);
            }
        }
        return list;
    }
}
```





## 912. 排序数组
### Description
* [LeetCode-912. 排序数组](https://leetcode-cn.com/problems/sort-an-array/)


### Approach 1-自我-快速排序
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution

```java
class Solution {
    public int[] sortArray(int[] nums) {
        if(nums.length <= 1){
            return nums;
        }
        quickSort(nums,0,nums.length-1);
        return nums;
    }
    private void quickSort(int[] arr, int low,int high){
        if(low >= high){
            //递归终止条件
            return;
        }
        int storeIndex = partition(arr, low, high);
		quickSort(arr, low, storeIndex - 1);
		quickSort(arr, storeIndex + 1, high);
    }

    private int partition(int[] arr, int low,int high){
        int storeIndex = low;
        int pivot = arr[high]; //直接选最右边的元素作为基准元素 
        for(int i=low;i<high;i++){
            if(arr[i] < pivot){
                swap(arr,storeIndex,i);
                storeIndex++; // 交换位置后，storeIndex 自增 1，代表下一个可能要交换的位置
            }
        }
        swap(arr, high, storeIndex); // 将基准元素放置到最后的正确位置上
        return storeIndex;
    }

    private void swap(int[] arr, int i,int j){
        int temp = arr[i];
		arr[i] = arr[j];
		arr[j] = temp;
    }
}


```


### Approach 2-归并排序
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution

```java
class Solution {
    int[] tmp;

    public int[] sortArray(int[] nums) {
        tmp = new int[nums.length];
        mergeSort(nums, 0, nums.length - 1);
        return nums;
    }

    public void mergeSort(int[] nums, int l, int r) {
        if (l >= r) {
            return;
        }
        int mid = (l + r) >> 1;
        mergeSort(nums, l, mid);
        mergeSort(nums, mid + 1, r);
        int i = l, j = mid + 1;
        int cnt = 0;
        while (i <= mid && j <= r) {
            if (nums[i] <= nums[j]) {
                tmp[cnt++] = nums[i++];
            } else {
                tmp[cnt++] = nums[j++];
            }
        }
        while (i <= mid) {
            tmp[cnt++] = nums[i++];
        }
        while (j <= r) {
            tmp[cnt++] = nums[j++];
        }
        for (int k = 0; k < r - l + 1; ++k) {
            nums[k + l] = tmp[k];
        }
    }
}
```





## 【经典好题】148. 排序链表
### Description
* 【经典好题】[LeetCode-148. 排序链表](https://leetcode-cn.com/problems/sort-list/)


### Approach 1-自我
#### Analysis

参考 `leetcode-cn` 官方题解。


将链表的值存放到数组或 List 中，对数组或 List 进行排序，然后构造排序后的链表。


使用Java自带的排序方法 `Collections.sort(list)`。


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
    public ListNode sortList(ListNode head) {
        if(null == head || null == head.next){
            return head;
        }
        List<Integer> list = new ArrayList<>();
        ListNode node  = head;
        while(null != node){
            list.add(node.val);
            node = node.next;
        }
        //快排
        Collections.sort(list);
        int index = 0;
        node = head;
        while(index < list.size()){
            node.val = list.get(index);
            node = node.next;
            index++;
        }
        return head;

    }
}
```



### Approach 2-快排
#### Analysis

参考 `leetcode-cn` 官方题解。

将链表的值存放到数组或 List 中，对数组或 List 进行排序，然后构造排序后的链表。在排序步骤中，使用快排实现。


#### Solution


* 下面的自我实现版本，会执行超时


```java
class Solution {
    public ListNode sortList(ListNode head) {
        if(null == head || null == head.next){
            return head;
        }
        List<Integer> list = new ArrayList<>();
        ListNode node  = head;
        while(null != node){
            list.add(node.val);
            node = node.next;
        }
        //快排
        quickSort(list,0,list.size()-1);
        int index = 0;
        node = head;
        while(index < list.size()){
            node.val = list.get(index);
            node = node.next;
            index++;
        }
        return head;

    }

    private void quickSort(List<Integer> list, int low,int high){
        if(low >= high){
            //递归终止条件
            return;
        }
        int storeIndex = partition(list, low, high);
		quickSort(list, low, storeIndex - 1);
		quickSort(list, storeIndex + 1, high);
       
    }
    private int partition(List<Integer> list, int low,int high){
        int storeIndex = low;
        int pivot = list.get(high); //直接选最右边的元素作为基准元素 
        for(int i=low;i<high;i++){
            if(list.get(i) < pivot){
                swap(list,storeIndex,i);
                storeIndex++; // 交换位置后，storeIndex 自增 1，代表下一个可能要交换的位置
            }
        }
        swap(list, high, storeIndex); // 将基准元素放置到最后的正确位置上
        return storeIndex;
    }

    private void swap(List<Integer> list, int i,int j){
        int temp = list.get(i);
		list.set(i,list.get(j));
		list.set(j,temp);
    }
}



```



* 下面给出一个AC的版本


```java
class Solution {
    public ListNode sortList(ListNode head) {
        return quickSort(head);
    }
    
    public ListNode quickSort(ListNode head) {
        if(head == null || head.next == null) {
            return head;
        }
        
        // 1 .使用快慢指针找到中点（因为取head容易被卡），取到划分值val
        // 2. 使用6个变量，分别表示小于部分的头(真正head的前一个节点)和尾，等于部分的头和尾，大于部分的头和尾
        // 3. 快排partition过程
        // 4. 对小于部分和大于部分递归
        // 5. 合并结果，等于部分一定不为空，注意小于部分可能为空


        ListNode slow = head, fast = head;
        while(fast.next != null && fast.next.next != null){
            fast = fast.next.next;
            slow = slow.next;
        }
        int val = slow.val; //slow为中点
        ListNode h1 = new ListNode(); //小于val的头
        ListNode h2 = new ListNode();//等于val的头
        ListNode h3 = new ListNode();//大于val的头
        ListNode t1 = h1, t2 = h2, t3 = h3, cur = head;

        while(cur != null) {
            ListNode next = cur.next;
            if(cur.val < val) {
                cur.next = t1.next;
                t1.next = cur;
                t1 = t1.next;
            } else if(cur.val > val) {
                cur.next = t2.next;
                t2.next = cur;
                t2 = t2.next;
            } else {
                cur.next = t3.next;
                t3.next = cur;
                t3 = t3.next;
            }
            cur = next;
        }

        h1 = quickSort(h1.next);
        h2 = quickSort(h2.next);
        h3 = h3.next;
        t3.next = h2;
        
        if(h1 == null) {
            return h3;
        } else {
            t1 = h1;
            while(t1.next != null) {
                t1 = t1.next;
            }
            t1.next = h3;
            return h1;
        }
    }
}


```


### Approach 3-官方归并排序-自顶向下
#### Analysis

参考 `leetcode-cn` 官方题解。



插入排序的时间复杂度是 `O(n^2)`，其中 `n` 是链表的长度。这道题考虑时间复杂度更低的排序算法。题目的进阶问题要求达到 `O(nlogn)` 的时间复杂度和 `O(1)` 的空间复杂度，**时间复杂度是 `O(nlogn)` 的排序算法包括归并排序、堆排序和快速排序（快速排序的最差时间复杂度是 `O(n^2)`，其中最适合链表的排序算法是归并排序。**

**归并排序基于分治算法。最容易想到的实现方式是自顶向下的递归实现，考虑到递归调用的栈空间，自顶向下归并排序的空间复杂度是 `O(logn)`。如果要达到 `O(1)` 的空间复杂度，则需要使用自底向上的实现方式。**


此处介绍自顶向下的归并排序过程。
1. 找到链表的中点，以中点为分界，将链表拆分成两个子链表。寻找链表的中点可以使用快慢指针的做法，快指针每次移动 2 步，慢指针每次移动 1 步，当快指针到达链表末尾时，慢指针指向的链表节点即为链表的中点。
2. 对两个子链表分别排序。
3. 将两个排序后的子链表合并，得到完整的排序后的链表。
4. 上述过程可以通过递归实现。递归的终止条件是链表的节点个数小于或等于 1，即当链表为空或者链表只包含 1 个节点时，不需要对链表进行拆分和排序。



复杂度分析
* 时间复杂度：`O(nlogn)`，其中 n 是链表的长度。
* 空间复杂度：`O(logn)`，其中 `n` 是链表的长度。空间复杂度主要取决于递归调用的栈空间。



#### Solution



```java
class Solution {
    public ListNode sortList(ListNode head) {
        return sortList(head, null);
    }

    public ListNode sortList(ListNode head, ListNode tail) {
        if (head == null) {
            return head;
        }
        if (head.next == tail) {
            head.next = null;
            return head;
        }
        ListNode slow = head, fast = head;
        //快慢指针找到链表的中点
        while (fast != tail) {
            slow = slow.next;
            fast = fast.next;
            if (fast != tail) {
                fast = fast.next;
            }
        }
        ListNode mid = slow;
        ListNode list1 = sortList(head, mid);
        ListNode list2 = sortList(mid, tail);
        ListNode sorted = merge(list1, list2);
        return sorted;
    }

    public ListNode merge(ListNode head1, ListNode head2) {
        ListNode dummyHead = new ListNode(0);
        ListNode temp = dummyHead, temp1 = head1, temp2 = head2;
        while (temp1 != null && temp2 != null) {
            if (temp1.val <= temp2.val) {
                temp.next = temp1;
                temp1 = temp1.next;
            } else {
                temp.next = temp2;
                temp2 = temp2.next;
            }
            temp = temp.next;
        }
        if (temp1 != null) {
            temp.next = temp1;
        } else if (temp2 != null) {
            temp.next = temp2;
        }
        return dummyHead.next;
    }
}

```


### Approach 4-官方归并排序-自底向上
#### Analysis

参考 `leetcode-cn` 官方题解。





**使用自底向上的方法实现归并排序，则可以达到 `O(1)` 的空间复杂度。**

首先求得链表的长度 `length`，然后将链表拆分成子链表进行合并。具体做法如下。
1. 用 `subLength` 表示每次需要排序的子链表的长度，初始时 `subLength=1`。
2. 每次将链表拆分成若干个长度为 `subLength` 的子链表（最后一个子链表的长度可以小于 `subLength`），按照每两个子链表一组进行合并，合并后即可得到若干个长度 `subLength×2` 的有序子链表
3. 将 `subLength` 的值加倍，重复第 2 步，对更长的有序子链表进行合并操作，直到有序子链表的长度大于或等于 `length`，整个链表排序完毕。




#### Solution


```java
class Solution {
    public ListNode sortList(ListNode head) {
        if (head == null) {
            return head;
        }
        int length = 0;
        ListNode node = head;
        while (node != null) {
            length++;
            node = node.next;
        }
        ListNode dummyHead = new ListNode(0, head);
        for (int subLength = 1; subLength < length; subLength <<= 1) {
            ListNode prev = dummyHead, curr = dummyHead.next;
            while (curr != null) {
                ListNode head1 = curr;
                for (int i = 1; i < subLength && curr.next != null; i++) {
                    curr = curr.next;
                }
                ListNode head2 = curr.next;
                curr.next = null;
                curr = head2;
                for (int i = 1; i < subLength && curr != null && curr.next != null; i++) {
                    curr = curr.next;
                }
                ListNode next = null;
                if (curr != null) {
                    next = curr.next;
                    curr.next = null;
                }
                ListNode merged = merge(head1, head2);
                prev.next = merged;
                while (prev.next != null) {
                    prev = prev.next;
                }
                curr = next;
            }
        }
        return dummyHead.next;
    }

    public ListNode merge(ListNode head1, ListNode head2) {
        ListNode dummyHead = new ListNode(0);
        ListNode temp = dummyHead, temp1 = head1, temp2 = head2;
        while (temp1 != null && temp2 != null) {
            if (temp1.val <= temp2.val) {
                temp.next = temp1;
                temp1 = temp1.next;
            } else {
                temp.next = temp2;
                temp2 = temp2.next;
            }
            temp = temp.next;
        }
        if (temp1 != null) {
            temp.next = temp1;
        } else if (temp2 != null) {
            temp.next = temp2;
        }
        return dummyHead.next;
    }
}
```