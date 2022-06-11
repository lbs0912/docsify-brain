
# LeetCode Notes-037


[TOC]



## 更新
* 2021/07/05，撰写
* 2021/07/10，完成
* 2021/07/10，「215. 数组中的第K个最大元素」，「347. 前 K 个高频元素」和「剑指 Offer 40. 最小的k个」三道题目解法类似，使用堆排序或快速排序进行解决

## Overview
* [LeetCode-215. 数组中的第K个最大元素](https://leetcode-cn.com/problems/kth-largest-element-in-an-array/)
* [LeetCode-347. 前 K 个高频元素](https://leetcode-cn.com/problems/top-k-frequent-elements/)
* [LeetCode-剑指 Offer 40. 最小的k个数](https://leetcode-cn.com/problems/zui-xiao-de-kge-shu-lcof/)
* [LeetCode-392. 判断子序列](https://leetcode-cn.com/problems/is-subsequence/)
* [LeetCode-645. 错误的集合](https://leetcode-cn.com/problems/set-mismatch/)




## 215. 数组中的第K个最大元素
### Description
* [LeetCode-215. 数组中的第K个最大元素](https://leetcode-cn.com/problems/kth-largest-element-in-an-array/)

### Approach 1-暴力

#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution

```java
class Solution {
    public int findKthLargest(int[] nums, int k) {
        Arrays.sort(nums);
        return nums[nums.length-k];
    }
}
```


### Approach 2-基于快速排序的选择方法

#### Analysis

参考 `leetcode-cn` 官方题解。

参考资料
* [手写算法并记住它：快速排序 | 掘金](https://juejin.cn/post/6844903938915827725)

#### Solution



```java
class Solution {
    Random random = new Random();

    public int findKthLargest(int[] nums,int k){
        return quickSelect(nums,0,nums.length-1,nums.length-k);

    }

    /**
     * 在数组[l,r]区间范围内 查找在整个数组排序后第index位置处的元素
     */
    public int quickSelect(int[] a,int l,int r,int index){
        //分区元素的索引值
        int q = randomPartition(a,l,r);
        if(q == index){
            return a[q];
        }
        return q < index ? quickSelect(a,q+1,r,index):quickSelect(a,l,q-1,index);
    }

    public int randomPartition(int[] a, int l, int r){
        //产生区间[l,r] 之间的随机数
        //此处若固定选取数组最右边或者最左边的元素 效果是一样的
        int i = random.nextInt(r-l+1)+l;
        swap(a,i,r); //将分区元素放置到数组最右侧
        return partition(a,l,r);
    }

    public int partition(int[] a, int l, int r){

        // 官方版本如下
        // int j = l-1;  //记录小于分区元素的最大索引
        // int pivot = a[r]; //分区元素
        // for(int i=l;i<r;i++){
        //     if(a[i] < pivot){
        //         swap(a,i,++j);
        //     }
        // }
        // swap(a,j+1,r); //将分区元素放在分界位置
        // return j+1;


        // 自己实现的版本 更好理解
        int j = l;  //记录小于分区元素的最大索引
        int pivot = a[r]; //分区元素
        for(int i=l;i<=r;i++){
            if(a[i] <= pivot){
                swap(a,i,j++);
            }
        }
        return j-1; //记得最后-1
    }

    //交换a[i] 和 a[j]
    public void swap(int[] a, int i, int j) {
        int temp = a[i];
        a[i] = a[j];
        a[j] = temp;
    }
}
```



### Approach 3-基于堆排序的选择方法

#### Analysis

参考 `leetcode-cn` 官方题解。

**使用堆排序来解决这个问题——建立一个大根堆，做 `k−1` 次删除操作后堆顶元素就是我们要找的答案。**


参考资料
* [Java 借助 PriorityQueue 实现小根堆和大根堆 | CSDN](https://blog.csdn.net/zcf1784266476/article/details/68961473)




#### Solution


* 使用Java自带的优先级队列 `PriorityQueue` 实现小根堆。


```java
class Solution {
    public int findKthLargest(int[] nums, int k) {
        //使用优先级队列实现小根堆
        PriorityQueue<Integer> heap = new PriorityQueue<>();
        for(int num : nums){
            heap.offer(num); //插入元素
            if(heap.size() > k){ 
                //移除掉nums.length-K个元素，则剩下的堆顶的元素为第k大的元素
                heap.poll();
            }
        }
        //返回堆顶部的元素
        return heap.peek();
    }
}
```

* 自定义比较器，使用Java自带的优先级队列 `PriorityQueue` 实现大根堆。


```java
class Solution {
    public int findKthLargest(int[] nums, int k) {
        int size = nums.length;
        PriorityQueue <Integer> maxHeap = new PriorityQueue<Integer>(size, new Comparator<Integer>() {
		    @Override
		    public int compare(Integer o1, Integer o2) {
				return o2.compareTo(o1);
		    }
	    });
        for(int num:nums){
            maxHeap.offer(num);
        }
        for(int i=1;i<k;i++){
            maxHeap.poll();
        }
        return maxHeap.poll();

    }
}
```


* 不使用现有的数据结构，手动实现大根堆

```java
class Solution {
    public int findKthLargest(int[] nums, int k) {
        int heapSize = nums.length;
        //构建堆
        buildMaxHeap(nums, heapSize);
        for (int i = nums.length - 1; i >= nums.length - k + 1; --i) {
            //删除堆顶元素 并将堆尾的元素放置到堆顶
            //之后再调整堆 使之成为大根堆
            swap(nums, 0, i);
            --heapSize;
            maxHeapify(nums, 0, heapSize);
        }
        return nums[0];
    }

    public void buildMaxHeap(int[] a, int heapSize) {
        // 已知完全二叉树的总节点数为 n，其父节点个数 n/2
        for (int i = heapSize / 2; i >= 0; --i) { //对父节点进行调整
            maxHeapify(a, i, heapSize);
        } 
    }

    public void maxHeapify(int[] a, int i, int heapSize) {
        // 对于任意一节点指针 i（从0开始计数）
        // 父节点：i==0 ? null : (i-1)/2
        // 左孩子：2*i + 1
        // 右孩子：2*i + 2
        int l = i * 2 + 1;
        int r = i * 2 + 2;
        int largest = i;
        if (l < heapSize && a[l] > a[largest]) {
            largest = l;
        } 
        if (r < heapSize && a[r] > a[largest]) {
            largest = r;
        }
        if (largest != i) {
            swap(a, i, largest);
            maxHeapify(a, largest, heapSize); //改变了之前largest的元素 所以此处继续递归调整largest的位置的元素
        }
    }

    public void swap(int[] a, int i, int j) {
        int temp = a[i];
        a[i] = a[j];
        a[j] = temp;
    }
}
```






## 347. 前 K 个高频元素
### Description
* [LeetCode-347. 前 K 个高频元素](https://leetcode-cn.com/problems/top-k-frequent-elements/)

### Approach 1-堆排序

#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


* 大根堆


```java
package com.lbs0912.java.demo;

import java.util.*;

public class Solution {
    public int[] topKFrequent(int[] nums, int k) {
        // map 记录出现次数
        Map<Integer,Integer> occurrences = new HashMap<Integer,Integer>();
        for(int num : nums){
            occurrences.put(num,occurrences.getOrDefault(num,0) + 1);
        }
        // 使用优先级队列创建一个大根堆 并自定义比较器
        // int[] 的第一个元素代表数组的值，第二个元素代表了该值出现的次数
        PriorityQueue<int[]> queue = new PriorityQueue<int[]>(new Comparator<int[]>(){
            @Override
            public int compare(int[] m, int[] n){
                return n[1]-m[1];
            }
        });

        //填充大根堆
        for(Map.Entry<Integer,Integer> entry : occurrences.entrySet()){
            int num = entry.getKey(); //数组的值
            int count = entry.getValue(); //该值出现的次数
            queue.offer(new int[]{num,count});
        }

    

        //删除大根堆的元素 重复k次 记录数据
        int[] ret = new int[k];
        for(int i=0;i<k;i++){
            ret[i] = (queue.poll()[0]);
        }
        return ret;
    }

    public static void main(String[] args) {
        int[] arr = {3,2,3,1,2,4,5,5,6};
        int[] res  = new Solution().topKFrequent(arr,2);

        for(int val:res){
            System.out.println(val);
        }
    }

}
```


* 小根堆


```java
class Solution {
    public int[] topKFrequent(int[] nums, int k) {
        // map 记录出现次数
        Map<Integer,Integer> occurrences = new HashMap<Integer,Integer>();
        for(int num : nums){
            occurrences.put(num,occurrences.getOrDefault(num,0) + 1);
        }
        // 使用优先级队列创建一个小根堆 并自定义比较器
        // int[] 的第一个元素代表数组的值，第二个元素代表了该值出现的次数
        PriorityQueue<int[]> queue = new PriorityQueue<int[]>(new Comparator<int[]>(){
            @Override
            public int compare(int[] m, int[] n){
                return m[1]-n[1];
            }
        });

        //填充小根堆
        for(Map.Entry<Integer,Integer> entry : occurrences.entrySet()){
            int num = entry.getKey(); //数组的值
            int count = entry.getValue(); //该值出现的次数
            if (queue.size() == k) { //小根堆中 若出现次数小于堆顶元素 直接删除堆顶元素
                if (queue.peek()[1] < count) {
                    queue.poll();
                    queue.offer(new int[]{num, count});
                }
            } else {
                queue.offer(new int[]{num, count});
            }
        }

        //删除小根堆的元素 重复k次 记录数据
        int[] ret = new int[k];
        for(int i=0;i<k;i++){
            ret[i] = (queue.poll()[0]);
        }
        return ret;
    }
}
```

### Approach 2-快速排序

#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public int[] topKFrequent(int[] nums, int k) {
        Map<Integer, Integer> occurrences = new HashMap<Integer, Integer>();
        for (int num : nums) {
            occurrences.put(num, occurrences.getOrDefault(num, 0) + 1);
        }

        List<int[]> values = new ArrayList<int[]>();
        for (Map.Entry<Integer, Integer> entry : occurrences.entrySet()) {
            int num = entry.getKey(), count = entry.getValue();
            values.add(new int[]{num, count});
        }
        int[] ret = new int[k];
        qsort(values, 0, values.size() - 1, ret, 0, k);
        return ret;
    }

    public void qsort(List<int[]> values, int start, int end, int[] ret, int retIndex, int k) {
        int picked = (int) (Math.random() * (end - start + 1)) + start;
        Collections.swap(values, picked, start);
        
        int pivot = values.get(start)[1];
        int index = start;
        for (int i = start + 1; i <= end; i++) {
            if (values.get(i)[1] >= pivot) {
                Collections.swap(values, index + 1, i);
                index++;
            }
        }
        Collections.swap(values, start, index);

        if (k <= index - start) {
            qsort(values, start, index - 1, ret, retIndex, k);
        } else {
            for (int i = start; i <= index; i++) {
                ret[retIndex++] = values.get(i)[0];
            }
            if (k > index - start + 1) {
                qsort(values, index + 1, end, ret, retIndex, k - (index - start + 1));
            }
        }
    }
}
```


## 剑指 Offer 40. 最小的k个数
### Description
* [LeetCode-剑指 Offer 40. 最小的k个数](https://leetcode-cn.com/problems/zui-xiao-de-kge-shu-lcof/)

### Approach 1-常规-数组排序

#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution

```java
class Solution {
    public int[] getLeastNumbers(int[] arr, int k) {
        int[] vec = new int[k];
        Arrays.sort(arr);
        for (int i = 0; i < k; ++i) {
            vec[i] = arr[i];
        }
        return vec;
    }
}
```



### Approach 2-堆排序

#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int[] getLeastNumbers(int[] arr, int k) {
        int[] vec = new int[k];
        if (k == 0) { // 排除 0 的情况
            return vec;
        }
        //大根堆
        PriorityQueue<Integer> queue = new PriorityQueue<Integer>(new Comparator<Integer>() {
            public int compare(Integer num1, Integer num2) {
                return num2 - num1;
            }
        });
        for (int i = 0; i < k; ++i) {
            queue.offer(arr[i]);
        }
        for (int i = k; i < arr.length; ++i) {
            if (queue.peek() > arr[i]) {
                queue.poll();
                queue.offer(arr[i]);
            }
        }
        for (int i = 0; i < k; ++i) {
            vec[i] = queue.poll();
        }
        return vec;
    }
}
```



### Approach 3-快排

#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public int[] getLeastNumbers(int[] arr, int k) {
        randomizedSelected(arr, 0, arr.length - 1, k);
        int[] vec = new int[k];
        for (int i = 0; i < k; ++i) {
            vec[i] = arr[i];
        }
        return vec;
    }

    private void randomizedSelected(int[] arr, int l, int r, int k) {
        if (l >= r) {
            return;
        }
        int pos = randomizedPartition(arr, l, r);
        int num = pos - l + 1;
        if (k == num) {
            return;
        } else if (k < num) {
            randomizedSelected(arr, l, pos - 1, k);
        } else {
            randomizedSelected(arr, pos + 1, r, k - num);
        }
    }

    // 基于随机的划分
    private int randomizedPartition(int[] nums, int l, int r) {
        int i = new Random().nextInt(r - l + 1) + l;
        swap(nums, r, i);
        return partition(nums, l, r);
    }

    private int partition(int[] nums, int l, int r) {
        int pivot = nums[r];
        int i = l - 1;
        for (int j = l; j <= r - 1; ++j) {
            if (nums[j] <= pivot) {
                i = i + 1;
                swap(nums, i, j);
            }
        }
        swap(nums, i + 1, r);
        return i + 1;
    }

    private void swap(int[] nums, int i, int j) {
        int temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
    }
}

```








## 392. 判断子序列
### Description
* [LeetCode-392. 判断子序列](https://leetcode-cn.com/problems/is-subsequence/)

### Approach 1-哈希表

#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(n+m)`，其中 n 为 s 的长度，m 为 t 的长度。每次无论是匹配成功还是失败，都有至少一个指针发生右移，两指针能够位移的总距离为 `n+m`。
* 空间复杂度：`O(1)`。


#### Solution

* 官方

```java
class Solution {
    public boolean isSubsequence(String s, String t) {
        int n = s.length(), m = t.length();
        int i = 0, j = 0;
        while (i < n && j < m) {
            if (s.charAt(i) == t.charAt(j)) {
                i++;
            }
            j++;
        }
        return i == n;
    }
}
```

* 自解

```java
class Solution {
    public boolean isSubsequence(String s, String t) {
        int n1 = s.length();
        int n2 = t.length();
        int p1 = 0;
        int p2 = 0;
        
        while(p1 < n1 && p2 < n2){
            if(s.charAt(p1) == t.charAt(p2)){
                p1++;
                p2++;
            } else {
                p2++;
            }
        }
        return p1 == n1;
    }
}
```


### Approach 2-动态规划

#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution

```java
class Solution {
    public boolean isSubsequence(String s, String t) {
        int n = s.length(), m = t.length();

        int[][] f = new int[m + 1][26];
        for (int i = 0; i < 26; i++) {
            f[m][i] = m;
        }

        for (int i = m - 1; i >= 0; i--) {
            for (int j = 0; j < 26; j++) {
                if (t.charAt(i) == j + 'a')
                    f[i][j] = i;
                else
                    f[i][j] = f[i + 1][j];
            }
        }
        int add = 0;
        for (int i = 0; i < n; i++) {
            if (f[add][s.charAt(i) - 'a'] == m) {
                return false;
            }
            add = f[add][s.charAt(i) - 'a'] + 1;
        }
        return true;
    }
}
```


## 645. 错误的集合
### Description
* [LeetCode-645. 错误的集合](https://leetcode-cn.com/problems/set-mismatch/)

### Approach 1-哈希表

#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(n)`，其中 n 是数组 nums 的长度。需要遍历数组并填入哈希表。
* 空间复杂度：`O(n)`，需要创建大小为 `O(n)` 的哈希表。



#### Solution

使用 Map 实现哈希表，同官方题解。

```java
class Solution {
    public int[] findErrorNums(int[] nums) {
        int[] errorNums = new int[2];
        int n = nums.length;
        Map<Integer,Integer> map = new HashMap<>();
        for(int num:nums){
            map.put(num,map.getOrDefault(num,0) + 1);
        }
        for(int i=1;i<=n;i++){
            int val = map.getOrDefault(i,0);
            if(2 == val){
                errorNums[0] = i;
            } else if(0 == val){
                errorNums[1] = i;
            }
        }
        return errorNums;
    }
}
```


也可以使用数组去实现，代码如下。


```java
class Solution {
       public int[] findErrorNums(int[] nums) {
        int n = nums.length;
        int[] list = new int[n+1];
        int duplicateVal = 0;
        int missVal = 0;
        for(int i=0;i<n;i++){
            if(1 == list[nums[i]]){
                duplicateVal = nums[i];
            } else {
                list[nums[i]] = 1;
            }
        }
        for(int j=1;j<list.length;j++){
            if(0 == list[j]){
                missVal = j;
                break;
            }
        }

        return new int[]{duplicateVal, missVal};
    }
}
```

### Approach 2-数组排序

#### Analysis

参考 `leetcode-cn` 官方题解。




将数组排序之后，比较每对相邻的元素，即可找到错误的集合。

如果相邻的两个元素相等，则该元素为重复的数字。

寻找丢失的数字相对复杂，可能有以下两种情况
1. 如果丢失的数字大于 1 且小于 n，则一定存在相邻的两个元素的差等于 2，这两个元素之间的值即为丢失的数字；
2. 如果丢失的数字是 1 或 n，则需要另外判断。



复杂度分析
* 时间复杂度：`O(nlogn)`，其中 n 是数组的长度。排序需要 `O(nlogn)` 的时间，遍历数组找到错误的集合需要 `O(n)` 的时间，因此总时间复杂度是 `O(nlogn)`。
* 空间复杂度：`O(logn)`，排序需要 `O(logn)` 的空间。

#### Solution


```java
class Solution {
    public int[] findErrorNums(int[] nums) {
        int[] errorNums = new int[2];
        int n = nums.length;
        Arrays.sort(nums);
        int prev = 0;
        for(int i=0;i<n;i++){
            int cur = nums[i];
            if(prev == cur){
                errorNums[0] = prev;
            } else if(cur-prev > 1){
                errorNums[1] = cur-1;
            }
            prev = cur;
        }
        if (nums[n - 1] != n) {
            errorNums[1] = n;
        }
        return errorNums;
    }
}
```
