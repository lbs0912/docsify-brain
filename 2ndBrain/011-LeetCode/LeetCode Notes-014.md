
# LeetCode Notes-014


[TOC]


## 更新
* 2020/11/12，撰写
* 2020/11/18，完成


## Overview
* [LeetCode-101. 对称二叉树](https://leetcode-cn.com/problems/symmetric-tree/)
* [LeetCode-18. 四数之和](https://leetcode-cn.com/problems/4sum/)
* [LeetCode-402. 移掉K位数字](https://leetcode-cn.com/problems/remove-k-digits/)
* [LeetCode-41. 缺失的第一个正数](https://leetcode-cn.com/problems/first-missing-positive/)
* [LeetCode-1013. 将数组分成和相等的三个部分](https://leetcode-cn.com/problems/partition-array-into-three-parts-with-equal-sum/)





## 101. 对称二叉树
### Description
* [LeetCode-101. 对称二叉树](https://leetcode-cn.com/problems/symmetric-tree/)

### Approach 1-递归

#### Analysis

参考 `leetcode-cn` 官方题解。

使用两个指针分别指向镜像的左侧节点和镜像的右侧节点，进行遍历。


复杂度分析（假设树上一共 `n` 个节点）
* 时间复杂度：这里遍历了这棵树，渐进时间复杂度为 `O(n)`。
* 空间复杂度：这里的空间复杂度和递归使用的栈空间有关，这里递归层数不超过 `n`，故渐进空间复杂度为 `O(n)`。



#### Solution

* Java

```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
 class Solution {
    public boolean isSymmetric(TreeNode root) {
        if(null == root){
            return true;
        }
        // return check(root,root);
        return check(root.left,root.right);
    }
     private boolean check(TreeNode p,TreeNode q) {
        if(null == p && null == q){
            return true;
        }
        if (null == p  || null == q) {
            return false;
        }
        return p .val == q.val && check(p.left,q.right) && check(p.right,q.left);
     }
}
```


### Approach 2-迭代

#### Analysis

参考递归方法的实现，使用一个队列来存储节点信息。


复杂度分析
* 时间复杂度：`O(n)`，同「方法一」。
* 空间复杂度：这里需要用一个队列来维护节点，每个节点最多进队一次，出队一次，队列中最多不会超过 `n` 个点，故渐进空间复杂度为 `O(n)`。



#### Solution

* Java

```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
class Solution {
    public boolean isSymmetric(TreeNode root) {
        if(null == root){
            return true;
        }
        return check(root.left,root.right);
    }
     private boolean check(TreeNode u,TreeNode v) {
        Queue<TreeNode> queue = new LinkedList<TreeNode>();
        queue.offer(u);
        queue.offer(v);
        while(!queue.isEmpty()){
            u = queue.poll();
            v = queue.poll();
            if(u == null && v == null){
                continue;
            }
            if((u== null || v == null) || (u.val != v.val)){
                return false;
            }

            queue.offer(u.left);
            queue.offer(v.right);

            queue.offer(u.right);
            queue.offer(v.left);
        }
        return true;
     }
}
```



## 18. 四数之和
### Description 
* [LeetCode-18. 四数之和](https://leetcode-cn.com/problems/4sum/)

### Approach 1-排序 + 双指针


#### Analysis


参考 `leetcode-cn` 官方题解。


本题求解思路同 [LeetCode-18. 四数之和](https://leetcode-cn.com/problems/3sum/)，参考 *LeetCode Notes-010* 笔记的思路分析，此处不再赘述。


复杂度分析
* 时间复杂度：`O(n^3)`，其中 `n` 是数组的长度。排序的时间复杂度是 `O(nlogn)`，枚举四元组的时间复杂度是 `O(n^3)`，因此总时间复杂度为 `O(n^3)`。
* 空间复杂度：`O(logn)`，其中 `n` 是数组的长度。空间复杂度主要取决于排序额外使用的空间。此外排序修改了输入数组 `nums`，实际情况中不一定允许，因此也可以看成使用了一个额外的数组存储了数组 `nums` 的副本并排序，空间复杂度为 `O(n)`。





#### Solution

* Java


```java
class Solution {
    public List<List<Integer>> fourSum(int[] nums, int target) {
        List<List<Integer>> ans = new ArrayList<List<Integer>>();
        if (null == nums || nums.length < 4) {
            return ans;
        }
        int size = nums.length;
        Arrays.sort(nums);
        //枚举i
        for (int i = 0; i < size - 3; i++) {
            //两次相邻枚举的元素不能重复
            if (i > 0 && nums[i] == nums[i - 1]) {
                continue;
            }
            //剪枝操作
            if (nums[i] + nums[i + 1] + nums[i + 2] + nums[i + 3] > target) {
                continue;
            }
            //剪枝操作
            if (nums[i] + nums[size - 3] + nums[size - 2] + nums[size - 1] < target) {
                continue;
            }

            //枚举j
            for (int j = i + 1; j < size - 2; j++) {
                //两次相邻枚举的元素不能重复
                if (j > i + 1 && nums[j] == nums[j - 1]) {
                    continue;
                }
                //剪枝操作
                if (nums[i] + nums[j] + nums[j + 1] + nums[j + 2] > target) {
                    continue;
                }
                //剪枝操作
                if (nums[i] + nums[j] + nums[size - 2] + nums[size - 1] < target) {
                    continue;
                }
                //双指针
                int left = j + 1;
                int right = size - 1;
                while (left < right) {
                    int sum = nums[i] + nums[j] + nums[left] + nums[right];
                    if (sum == target) {
                        ans.add(Arrays.asList(nums[i], nums[j], nums[left], nums[right]));
                        while (left < right && nums[left] == nums[left + 1]) {
                            left++;
                        }
                        left++;
                        while (left < right && nums[right] == nums[right - 1]) {
                            right--;
                        }
                        right--;
                    } else if (sum < target) {
                        left++;
                    } else {
                        right--;
                    }
                }
            }
        }
        return ans;
    }
}
```




## 402. 移掉K位数字
### Description 
* [LeetCode-402. 移掉K位数字](https://leetcode-cn.com/problems/remove-k-digits/)

### Approach 1-贪心+单调栈


#### Analysis


参考 `leetcode-cn` 官方题解。


基于题意分析，我们可以得出「删除一个数字」的贪心策略

**给定一个长度为 `n` 的数字序列 `$[D_0D_1D_2D_3\ldots D_{n-1}]$`，从左往右找到第一个位置 `i（i>0）`使得 `$D_i<D_{i-1}$`，并删去 `$D_{i-1}$`；如果不存在，说明整个数字序列单调不降，删去最后一个数字即可。**

基于此，我们可以每次对整个数字序列执行一次这个策略；删去一个字符后，剩下的 `n-1` 长度的数字序列就形成了新的子问题，可以继续使用同样的策略，直至删除 `k` 次。


然而暴力的实现，复杂度最差会达到 `O(nk)`（考虑整个数字序列是单调不降的），因此我们需要加速这个过程。


考虑从左往右增量的构造最后的答案。我们可以用一个栈维护当前的答案序列，栈中的元素代表截止到当前位置，删除不超过 `k` 次个数字后，所能得到的最小整数。根据之前的讨论：在使用 `k` 个删除次数之前，栈中的序列从栈底到栈顶单调不降。

因此，对于每个数字，如果该数字小于栈顶元素，我们就不断地弹出栈顶元素，直到
* 栈为空
* 或者新的栈顶元素不大于当前数字
* 或者我们已经删除了 `k` 位数字


上述步骤结束后我们还需要针对一些情况做额外的处理
* 如果我们删除了 m 个数字且 `m<k`，这种情况下我们需要从序列尾部删除额外的 `k-m` 个数字。
* 如果最终的数字序列存在前导零，我们要删去前导零。
* 如果最终数字序列为空，我们应该返回 00。

最终，从栈底到栈顶的答案序列即为最小数。

考虑到栈的特点是后进先出，如果通过栈实现，则需要将栈内元素依次弹出然后进行翻转才能得到最小数。为了避免翻转操作，可以使用双端队列代替栈的实现。




使用前缀和求解，复杂度分析如下
* 时间复杂度：`O(n)`。其中 n 为字符串的长度。尽管存在嵌套循环，但内部循环最多运行 k 次。由于 `0<k≤n`，主循环的时间复杂度被限制在 `2n` 以内。对于主循环之外的逻辑，它们的时间复杂度是 `O(n)`，因此总时间复杂度为 `O(n)`。
* 空间复杂度：`O(n)`。栈存储数字需要线性的空间。


#### Solution

* Java


```java
class Solution {
    public String removeKdigits(String num, int k) {
        Deque<Character> deque = new LinkedList<Character>();
        int length = num.length();
        for (int i = 0; i < length; i++) {
            char digit = num.charAt(i);
            while (!deque.isEmpty() && k > 0 && deque.peekLast() > digit) { //队尾元素大于当前digit  说明不单调
                deque.pollLast(); //移除队尾元素
                k--;
            }
            //插入到尾部
            deque.offerLast(digit);
        }
        //若num为单调不减或者还未移除k个元素 则移除队列尾部元素
        for (int i = 0; i < k; i++) {
            //移除尾部元素
            deque.pollLast();
        }

        StringBuilder ret = new StringBuilder();
        boolean leadingZero = true;
        while (!deque.isEmpty()) {
            char digit = deque.pollFirst(); //头部元素
            if (leadingZero && digit == '0') {
                continue;
            }
            leadingZero = false;
            ret.append(digit);
        }
        return ret.length() == 0 ? "0" : ret.toString();
    }
}
```


## 41. 缺失的第一个正数
### Description
* [LeetCode-41. 缺失的第一个正数](https://leetcode-cn.com/problems/first-missing-positive/)

### Approach 1-基本法




#### Analysis



分析题目，**可知缺失的正数一定在 `[1,N+1]` 范围内。** 对于长度为 N 的数组，
* 若数组元素恰好为 `[1,2,3, ... ,N]`，则缺失的第一个正数为 `N+1`
* 若数组元素不是上面的情况，则缺失的第一个正数一定在 `[1,N]` 区间内。

基于上述结论，可以创建一个长度为 `N+1` 的数组 `arr`，遍历测试数组，对于在 `[1,N]` 范围内的数组，令 `arr[i] = i`。后续再遍历 `arr` 数组，若遇到 `arr[i] != i`，则缺失的第一个正数为 `i`。


复杂度分析如下
* 时间复杂度：`O(n)`
* 空间复杂度：`O(n)`


#### Solution

* Java


```java
class Solution {
    public int firstMissingPositive(int[] nums) {
        int size = nums.length;
        int res = size + 1;
        int[] arr = new int[size+1];
        for (int i = 0; i < size; i++) {
            if (nums[i] > 0 && nums[i] <= size) {
                arr[nums[i]] = nums[i];
            }
        }
        for(int i=1;i<size+1;i++){
            if(arr[i] != i){
                res = i;
                break;
            }
        }
        return res;
    }
}
```



### Approach 2-in-place优化


#### Analysis

在方法1的基础上，使用 `in-place` 思想，使用数组本身记录结果，将空间复杂度优化至 `O(1)`。首先需要明确的是，**缺失的正数一定在 `[1,N+1]` 范围内。** 实现步骤如下
1. 第1次遍历数组，**将原数组中的负数和0，更新为 `N+1`，这个时候数组值全部为正数，下面就可以通过元素是否为负数来进行标记。**
2. 第2次遍历数组，对于在 `[1,N]` 区间内的数 `val`，将 `nums[val-1]` 值标记为负数。
3. 第3次遍历数组，对于存在的正数 `val`，其 `nums[val-1]` 一定为负数。若遇到 `nums[i]` 大于0，则第一个缺失的正数为 `i-1`。



复杂度分析如下
* 时间复杂度：`O(n)`
* 空间复杂度：`O(1)`


#### Solution

* Java



```java
class Solution {
    public int firstMissingPositive(int[] nums) {
        int size = nums.length;
        int res = size + 1;
        //负数和0 转换为 N+1
        for (int i = 0; i < size; i++) {
            if(nums[i] <= 0){
                nums[i] = size+1;
            }
        }
        for (int i = 0; i < size; i++) {
            int val = Math.abs(nums[i]);
            if(val > 0 && val <= size){
                nums[val-1] = -Math.abs(nums[val-1]);
            }
        }
        for(int i=0;i<size;i++){
            if(nums[i] > 0){
                res = i+1;
                break;
            }
        }
        return res;
    }
}


```



## 1013. 将数组分成和相等的三个部分
### Description
* [LeetCode-1013. 将数组分成和相等的三个部分](https://leetcode-cn.com/problems/partition-array-into-three-parts-with-equal-sum/)

### Approach 1-前缀和


#### Analysis


使用前缀和求解，复杂度分析如下
* 时间复杂度：`O(n)`
* 空间复杂度：`O(n)`


#### Solution

* Java

```java
class Solution {
    public boolean canThreePartsEqualSum(int[] A) {
        int size = A.length;
        if (size < 3) {
            return false;
        }
        int sum = 0;
        int[] preSum = new int[size]; //前缀和
        for (int i = 0; i < size; i++) {
            sum += A[i];
            preSum[i] = sum;
        }
        if (sum % 3 != 0) {
            return false;
        }
        int avg = sum / 3;
        int left = -1;
        int right = -1;
        for (int i = 0; i < size; i++) {
            if (preSum[i] == avg * 1 && -1 == left) {
                left = i;
                continue;
            }
            if (preSum[i] == avg * 2 && -1 == right && -1 != left) {
                right = i;
            }
            if (-1 != left && -1 != right) {
                break;
            }
        }
        if (left + 1 <= right && right != size-1) {
            return true;
        }
        return false;
    }
}
```


### Approach 2-寻找切分点

#### Analysis

参考 `leetcode-cn` 官方题解。复杂度分析如下
* 时间复杂度：`O(n)`
* 空间复杂度：`O(1)`


下面就 “贪心地选择最小的索引 `i0`” 进行说明。

由于数组中的数有正有负，我们可能会得到若干个索引 `i0`, `i1`, `i2`, ...，从 `A[0]` 到这些索引的数之和均为 `sum(A) / 3`。那么我们应该选取那个索引呢？直觉告诉我们，应该贪心地选择最小的那个索引 `i0`，这也是可以证明的：假设最终的答案中我们选取了某个不为 `i0` 的索引 `ik` 以及另一个索引 `j`，那么根据上面的两条要求，有
* `A[0] + A[1] + ... + A[ik] = sum(A) / `
* `A[0] + A[1] + ... + A[j] = sum(A) / 3 * 2` 且 `j > ik`

然而 `i0` 也是满足第一条要求的一个索引，因为 `A[0] + A[1] + ... + A[i0] = sum(A) / 3` 并且 `j > ik > i0`，我们可以将 `ik` 替换为 `i0`，因此选择最小的那个索引是合理的。





#### Solution

* Java


```java
class Solution {
    public boolean canThreePartsEqualSum(int[] A) {
        int s = 0;
        for (int num : A) {
            s += num;
        }
        if (s % 3 != 0) {
            return false;
        }
        int target = s / 3;
        int n = A.length, i = 0, cur = 0;
        while (i < n) {
            cur += A[i];
            if (cur == target) {
                break;
            }
            ++i;
        }
        if (cur != target) {
            return false;
        }
        int j = i + 1;
        while (j + 1 < n) {  // 需要满足最后一个数组非空
            cur += A[j];
            if (cur == target * 2) {
                return true;
            }
            ++j;
        }
        return false;
    }
}
```