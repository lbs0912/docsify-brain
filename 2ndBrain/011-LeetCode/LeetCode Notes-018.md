# LeetCode Notes-018


[TOC]


## 更新
* 2021/02/18，撰写
* 2021/02/25，完成


## Overview
* [LeetCode-167. 两数之和 II - 输入有序数组](https://leetcode-cn.com/problems/two-sum-ii-input-array-is-sorted/)
* [LeetCode-125. 验证回文串](https://leetcode-cn.com/problems/valid-palindrome/)
* [LeetCode-230. 二叉搜索树中第K小的元素](https://leetcode-cn.com/problems/kth-smallest-element-in-a-bst/)
* [LeetCode-378. 有序矩阵中第 K 小的元素](https://leetcode-cn.com/problems/kth-smallest-element-in-a-sorted-matrix/)
* [LeetCode-977. 有序数组的平方](https://leetcode-cn.com/problems/squares-of-a-sorted-array/)




## 167. 两数之和 II - 输入有序数组
### Description
* [LeetCode-167. 两数之和 II - 输入有序数组](https://leetcode-cn.com/problems/two-sum-ii-input-array-is-sorted/)

### Approach 1-二分法

#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(nlogn)`，其中 `n` 是数组的长度。需要遍历数组一次确定第一个数，时间复杂度是 `O(n)`，寻找第二个数使用二分查找，时间复杂度是 `O(logn)`，因此总时间复杂度是 `O(nlogn)`。\
* 空间复杂度：`O(1)`。




#### Solution

```java
class Solution {
    public int[] twoSum(int[] numbers, int target) {
        for(int i=0;i<numbers.length;i++){
            int low = i+1, high = numbers.length -1;
            while(low <= high){
               int mid = (high-low)/2 + low;
               if(numbers[mid] == target - numbers[i]){
                   return new int[]{i+1,mid+1};
               } else if (numbers[mid] > target - numbers[i]){
                   high = mid -1;
               } else {
                    low = mid + 1;
               }
            }
        }
        return new int[]{-1,-1};
    }
}
```

### Approach 2-双指针

#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(n)`，其中 `n` 是数组的长度。两个指针移动的总次数最多为 n 次。
* 空间复杂度：`O(1)`。




#### Solution

```java
class Solution {
    public int[] twoSum(int[] numbers, int target) {
        int low = 0, high = numbers.length - 1;
        while (low < high) {
            int sum = numbers[low] + numbers[high];
            if (sum == target) {
                return new int[]{low + 1, high + 1};
            } else if (sum < target) {
                ++low;
            } else {
                --high;
            }
        }
        return new int[]{-1, -1};
    }
}
```




## 125. 验证回文串
### Description
* [LeetCode-125. 验证回文串](https://leetcode-cn.com/problems/valid-palindrome/)

### Approach 1-双指针

#### Analysis

参考 `leetcode-cn` 官方题解。


注意使用 `Character.isLetterOrDigit()` 判断字符串是否为字母或数字，空格和标点符号不进行判断。


复杂度分析
* 时间复杂度：`O(n)`，其中 `n` 是字符串 `s` 的长度。
* 空间复杂度：`O(1)`。


#### Solution

```java
class Solution {
    public boolean isPalindrome(String s) {
        int n = s.length();
        int left = 0, right = n - 1;
        while (left < right) {
            while (left < right && !Character.isLetterOrDigit(s.charAt(left))) {
                ++left;
            }
            while (left < right && !Character.isLetterOrDigit(s.charAt(right))) {
                --right;
            }
            if (left < right) {
                if (Character.toLowerCase(s.charAt(left)) != Character.toLowerCase(s.charAt(right))) {
                    return false;
                }
                ++left;
                --right;
            }
        }
        return true;
    }
}
```



## 230. 二叉搜索树中第K小的元素
### Description
* [LeetCode-230. 二叉搜索树中第K小的元素](https://leetcode-cn.com/problems/kth-smallest-element-in-a-bst/)

### Approach 1-BST中序搜索+递归

#### Analysis

参考 `leetcode-cn` 官方题解。


**注意审题，题目为二叉搜索树（BST），而二叉搜索树的中序遍历结果为一个升序序列。**



二叉查找树（`Binary Search Tree`），（又：二叉搜索树，二叉排序树）它或者是一棵空树，或者是具有下列性质的二叉树
1. 若它的左子树不空，则左子树上所有结点的值均小于它的根结点的值； 
2. 若它的右子树不空，则右子树上所有结点的值均大于它的根结点的值；
3. 它的左、右子树也分别为二叉排序树。




复杂度分析
* 时间复杂度：`O(N)`，遍历了整个树。
* 空间复杂度：`O(N)`，用了一个数组存储中序序列。


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
    public int kthSmallest(TreeNode root, int k) {
        ArrayList<Integer> arr = new ArrayList<>();
        inorder(root,arr);
        return arr.size() >=k? arr.get(k-1):-1;   
    }
    public void inorder (TreeNode root, ArrayList<Integer> arr){
        if(null == root){
            return;
        }
        inorder(root.left,arr);
        arr.add(root.val);
        inorder(root.right,arr);
    }
}
```

### Approach 2-BST中序搜索+迭代

#### Analysis

参考 `leetcode-cn` 官方题解。

**在栈的帮助下，可以将方法1的递归转换为迭代，这样可以加快速度，因为这样可以不用遍历整个树，可以在找到答案后停止。**


复杂度分析
* 时间复杂度：`O(H+k)`，其中 H 指的是树的高度。由于我们开始遍历之前，要先向下达到叶，当树是一个平衡树时：复杂度为 `O(logN+k)`。当树是一个不平衡树时，复杂度为 `O(N+k)`，此时所有的节点都在左子树。
* 空间复杂度：`O(H+k)`。当树是一个平衡树时，`O(logN+k)`。当树是一个非平衡树时，`O(N+k)`。



#### Solution


迭代遍历BST，全部遍历后返回计算结果。


```java
class Solution {
    public int kthSmallest(TreeNode root, int k) {
        List<Integer> res = inorderTraversal(root);
        return res.get(k-1);
    }
     public List<Integer> inorderTraversal(TreeNode root) {
        List<Integer> res = new ArrayList<Integer>();
        Deque<TreeNode> stk = new LinkedList<TreeNode>();
        while(null != root || !stk.isEmpty()){
            while(root != null){
                stk.push(root);
                root = root.left;
            }
            root = stk.pop();
            res.add(root.val);
            root = root.right;
        } 
        return res;
    }
}
```


更进一步的优化，若遍历的序列的长度等于 `k`，则直接结束BST的遍历。

```java
class Solution {
    public int kthSmallest(TreeNode root, int k) {
        List<Integer> res = new ArrayList<Integer>();
        Deque<TreeNode> stk = new LinkedList<TreeNode>();
        while(null != root || !stk.isEmpty()){
            while(root != null){
                stk.push(root);
                root = root.left;
            }
            root = stk.pop();
            res.add(root.val);
            if(res.size() == k){
                return res.get(k-1);
            }
            root = root.right;
        }
        return -1; //error
    }
   
}
```



## 378. 有序矩阵中第 K 小的元素
### Description
* [LeetCode-378. 有序矩阵中第 K 小的元素](https://leetcode-cn.com/problems/kth-smallest-element-in-a-sorted-matrix/)

### Approach 1-暴力

#### Analysis

参考 `leetcode-cn` 官方题解。

最直接的做法是将这个二维数组转成一维数组，并对该一维数组进行排序。最后这个一维数组中的第 k 个数即为答案。

复杂度分析
* 时间复杂度：`$O(n^2\log{n})$`，对 `$n^2$` 个数排序。
* 空间复杂度：`O(n^2)`，一维数组需要存储这 `n^2` 个数。


#### Solution





```java
class Solution {
    public int kthSmallest(int[][] matrix, int k) {
        int rows = matrix.length, columns = matrix[0].length;
        int[] sorted = new int[rows * columns];
        int index = 0;
        for (int[] row : matrix) {
            for (int num : row) {
                sorted[index++] = num;
            }
        }
        Arrays.sort(sorted);
        return sorted[k - 1];
    }
}
```

### Approach 2-归并排序

#### Analysis

参考 `leetcode-cn` 官方题解。



由题目给出的性质可知，这个矩阵的每一行均为一个有序数组。问题即转化为从这 n 个有序数组中找第 k 大的数，可以想到利用归并排序的做法，归并到第 k 个数即可停止。

一般归并排序是两个数组归并，而本题是 n 个数组归并，**所以需要用小根堆维护**，以优化时间复杂度。


对于小根堆方法的实现，参考如下链接，将在 *LeetCode Notes-019* 中给出 `23. 合并K个升序链表` 的题解，此处不再赘述。

* [数据结构——堆，大根堆、小根堆](https://www.cnblogs.com/wangchaowei/p/8288216.html)
* [LeetCode-23. 合并K个升序链表](https://leetcode-cn.com/problems/merge-k-sorted-lists/)



复杂度分析
* 时间复杂度：`O(klogn)`，归并 k 次，每次堆中插入和弹出的操作时间复杂度均为 `O(logn)`。
* 空间复杂度：`O(n)`，堆的大小始终为 `n`。

需要注意的是，k 在最坏情况下是 `n^2`，因此该解法最坏时间复杂度为 `$O(n^2\log{n})$`。





#### Solution


首先给出，不使用小根堆维护的解法，即将 n 个数组归并。此时，时间复杂度为 `$O(n^2\log{n})$`。


```java
class Solution {
    public int kthSmallest(int[][] matrix, int k) {
        int rows = matrix.length;
        int[] arr = matrix[0];
        for(int i=1;i<rows;i++){
            arr = merge(arr,matrix[i]);
        }
        return arr[k-1];
    }

    public int[] merge(int[] left,int[] right){
        int length1 = left.length;
        int length2 = right.length;
        int[] arr = new int[length1+length2];
        int index1 = 0;
        int index2 = 0;
        int count = 0;
        while(index1 < length1 && index2 < length2){
            if(left[index1] <= right[index2]){
                arr[count++] = left[index1++];
            } else {
                arr[count++] = right[index2++];
            }
        }
        while(index1<length1){
            arr[count++] = left[index1++];
        }
        while(index2<length2){
            arr[count++] = right[index2++];
        }
        return arr;
    }
}
```


此处，给出使用小根堆的解法。


```java
class Solution {
    public int kthSmallest(int[][] matrix, int k) {
        PriorityQueue<int[]> pq = new PriorityQueue<int[]>(new Comparator<int[]>() {
            public int compare(int[] a, int[] b) {
                return a[0] - b[0];
            }
        });
        int n = matrix.length;
        for (int i = 0; i < n; i++) {
            pq.offer(new int[]{matrix[i][0], i, 0});
        }
        for (int i = 0; i < k - 1; i++) {
            int[] now = pq.poll();
            if (now[2] != n - 1) {
                pq.offer(new int[]{matrix[now[1]][now[2] + 1], now[1], now[2] + 1});
            }
        }
        return pq.poll()[0];
    }
}
```




## 977. 有序数组的平方
### Description
* [LeetCode-977. 有序数组的平方](https://leetcode-cn.com/problems/squares-of-a-sorted-array/)

### Approach 1-双指针

#### Analysis

参考 `leetcode-cn` 官方题解。



根据题意，数组非递减排序，于是有
1. 数组中的所有数都是非负数，那么将每个数平方后，数组仍然保持升序；
2. 如果数组中的所有数都是负数，那么将每个数平方后，数组会保持降序；
3. **如果我们能够找到数组中负数与非负数的分界线，那么就可以用类似「归并排序」的方法了。将负数部分有序数列和非负数部分的有序数列进行合并。**


复杂度分析
* 时间复杂度：`O(n)`，其中 `n` 是数组 `nums` 的长度
* 空间复杂度：`O(1)`。除了存储答案的数组以外，我们只需要维护常量空间。



#### Solution



```java

class Solution {
    public int[] sortedSquares(int[] nums) {
       int n = nums.length;
       int negative = -1; //数组中索引值最大的负数，标记数组中负数和非负数的分界线
       for(int i=0;i<n;i++){
           if(nums[i]<0){
               negative = i;
           }else{
               break; //数组非递减 
           }
       }
       int[] ans = new int[n];
       int index = 0;
       int i = negative;  //指针1（指向负数部分）
       int j = negative+1; //指针2 (指向非负数部分)

       while(i>=0 || j<n){
            if(i<0){ //数组全部非负数
               ans[index] = nums[j]* nums[j];
               j++;
            }
            else if(j== n){ //非负数部分计算完了，处理负数部分
               ans[index] = nums[i]*nums[i];
               i--;
            }
            else if (nums[i] * nums[i] < nums[j] * nums[j]) { 
                ans[index] = nums[i] * nums[i];
                --i;
            } else {
                ans[index] = nums[j] * nums[j];
                ++j;
            }
            index++;
       }
       return ans;
    }
}
```

