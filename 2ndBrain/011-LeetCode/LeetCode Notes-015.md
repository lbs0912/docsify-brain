
# LeetCode Notes-015


[TOC]


## 更新
* 2020/11/20，撰写
* 2020/11/29，完成


## Overview
* [LeetCode-287. 寻找重复数](https://leetcode-cn.com/problems/find-the-duplicate-number/)
* [LeetCode-90. 子集 II](https://leetcode-cn.com/problems/subsets-ii/)
* [LeetCode-78. 子集](https://leetcode-cn.com/problems/subsets/)
* [LeetCode-228. 汇总区间](https://leetcode-cn.com/problems/summary-ranges/)
* [LeetCode-189. 旋转数组](https://leetcode-cn.com/problems/rotate-array/)



## 287. 寻找重复数
### Description
* [LeetCode-287. 寻找重复数](https://leetcode-cn.com/problems/find-the-duplicate-number/)

### Approach 1-回溯法

#### Analysis


参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(nlogn)`，其中 `n` 为 `nums[]` 数组的长度。二分查找最多需要二分 `O(logn)` 次，每次判断的时候需要 `O(n)` 遍历 `nums[]` 数组求解小于等于 `mid` 的数的个数，因此总时间复杂度为 `O(nlogn)`。
* 空间复杂度：`O(1)`。我们只需要常数空间存放若干变量。




#### Soluion


* Java


```java
class Solution {
    public int findDuplicate(int[] nums) {
        int ans = -1;
        int n = nums.length;
        int l=0;
        int r = n-1;
        while(l<=r){
            int mid = l + (r-l)/2;
            int cnt = 0;
            for(int i=0;i<n;i++){
                if(nums[i] <= mid){
                    cnt++;
                }
            }
            if(cnt <= mid){
                l = mid+1;
            }
            else{
                r = mid-1;
                ans = mid;
            }
        }
        return ans; 
    }
}
```


### Approach 2-快慢指针

#### Analysis

本方法需要读者对 「Floyd 判圈算法」（又称龟兔赛跑算法）有所了解，它是一个检测链表是否有环的算法，LeetCode 中相关例题有 `141. 环形链表`，`142. 环形链表 II`。



我们对 `nums[]` 数组建图，每个位置 `i` 连一条 `i → nums[i]` 的边。由于存在的重复的数字 `target`，因此 `target` 这个位置一定有起码两条指向它的边，因此整张图一定存在环，且我们要找到的 `target` 就是这个环的入口，那么整个问题就等价于 `142. 环形链表 II`。

我们先设置慢指 `slow` 和快指针 `fast`，慢指针每次走一步，快指针每次走两步，根据「Floyd 判圈算法」两个指针在有环的情况下一定会相遇，此时我们再将 `slow` 放置起点 `0`，两个指针每次同时移动一步，相遇的点就是答案。


复杂度分析
* 时间复杂度：`O(n)`。「Floyd 判圈算法」时间复杂度为线性的时间复杂度。
* 空间复杂度：`O(1)`。我们只需要常数空间存放若干变量。




#### Solution
* Java

```java
class Solution {
    public int findDuplicate(int[] nums) {
        int slow = 0,fast = 0;
        do {
            slow = nums[slow];
            fast = nums[nums[fast]];
        }while(slow != fast);
        slow = 0;
        while(slow != fast){
            slow = nums[slow];
            fast = nums[fast];
        }
        return slow;
    }
}
```



## 90. 子集 II
### Description
* [LeetCode-90. 子集 II](https://leetcode-cn.com/problems/subsets-ii/)

### Approach 1-回溯法

#### Analysis


参考 [78. 子集](https://leetcode-cn.com/problems/subsets/)，我们只需要判断当前数字和上一个数字是否相同，相同的话跳过即可。当然，要把数字首先进行排序。


**需要注意的是，在同一层级，不允许出现相同的元素；但是在不同层级之间，允许出现相同的元素。** 即代码中限制 `i>start`。


复杂度分析
* 时间复杂度：`O(n×2^n)`。若无重复元素，则一共 `2^n` 个状态，每种状态需要 `O(n)` 的时间来构造子集。
* 空间复杂度：`O(n)`。临时数组 `t` 的空间代价是 `O(n)`，递归时栈空间的代价为 `O(n)`。


#### Solution


* Java


```java
class Solution {
    public List<List<Integer>> subsetsWithDup(int[] nums) {
        List<List<Integer>> ans = new ArrayList<>();
        Arrays.sort(nums); //排序
        getAns(nums, 0, new ArrayList<>(), ans);
        return ans;
    }

    private void getAns(int[] nums, int start, ArrayList<Integer> temp, List<List<Integer>> ans) {
        ans.add(new ArrayList<>(temp));
        for (int i = start; i < nums.length; i++) {
            //同一层级之间  和上个数字相等就跳过
            if (i > start && nums[i] == nums[i - 1]) {
                continue;
            }
            temp.add(nums[i]);
            getAns(nums, i + 1, temp, ans);
            temp.remove(temp.size() - 1);
        }
    }
}
```





## 78. 子集
### Description
* [LeetCode-78. 子集](https://leetcode-cn.com/problems/subsets/)

### Approach 1-迭代法实现子集枚举

#### Analysis

参考 `leetcode-cn` 官方题解。


记原序列中元素的总数为 `n`。原序列中的每个数字 `$a_i%` 的状态可能有两种，即「在子集中」和「不在子集中」。我们用 1 表示「在子集中」，0 表示不在子集中，那么每一个子集可以对应一个长度为 `n` 的 `0/1` 序列，第 `i` 位表示 `$a_i$` 是否在子集中。例如，`n=3` ，`a={5,2,9}` 时

| 0/1 序列	| 子集	| 0/1 序列对应的二进制数 |
|-----------|-------|------------------------|
| 000  |   {}	| 0 |
|   001 |	{9} |	1 |
|   010 | 	{2} | 2|
|   011	|  {2,9}	| 3 |
|   100	| {5} |	4 |
|  101 | {5,9}	| 5 | 
|  110 | {5,2} |	6 |
| 111 | {5,2,9}	| 7 |


可以发现 `0/1` 序列对应的二进制数正好从 0 到 `2^n-1`。我们可以枚举 `mask ∈ [0,2^n−1]`，`mask` 的二进制表示是一个 `0/1` 序列，我们可以按照这个 `0/1` 序列在原集合当中取数。当我们枚举完所有 `2^n` 个 `mask`，我们也就能构造出所有的子集。

复杂度分析
* 时间复杂度：`O(n×2^n)`。一共 `2^n` 个状态，每种状态需要 `O(n)` 的时间来构造子集。
* 空间复杂度：`O(n)`。即构造子集使用的临时数组 `t` 的空间代价。

#### Solution


* Java


```java
class Solution {
    List<Integer> t = new ArrayList<Integer>();
    List<List<Integer>> ans = new ArrayList<List<Integer>>();

    public List<List<Integer>> subsets(int[] nums) {
        int n = nums.length;
        for (int mask = 0; mask < (1 << n); ++mask) {
            t.clear();
            for (int i = 0; i < n; ++i) {
                if ((mask & (1 << i)) != 0) {
                    t.add(nums[i]);
                }
            }
            ans.add(new ArrayList<Integer>(t));
        }
        return ans;
    }
}
```



### Approach 2-递归法实现子集枚举

#### Analysis

参考 `leetcode-cn` 官方题解。


我们也可以用递归来实现子集枚举。

假设我们需要找到一个长度为 `n` 的序列 `a` 的所有子序列，代码框架是这样的

```cpp
//c++

vector<int> t;
void dfs(int cur, int n) {
    if (cur == n) {
        // 记录答案
        // ...
        return;
    }
    // 考虑选择当前位置
    t.push_back(cur);
    dfs(cur + 1, n, k);
    t.pop_back();
    // 考虑不选择当前位置
    dfs(cur + 1, n, k);
}
```

上面的代码中，`dfs(cur,n)` 参数表示当前位置是 `cur`，原序列总长度为 `n`。原序列的每个位置在答案序列中的状态有被选中和不被选中两种，我们用 `t` 数组存放已经被选出的数字。在进入 `dfs(cur,n)` 之前 `[0,cur−1]` 位置的状态是确定的，而 `[cur,n−1]` 内位置的状态是不确定的，`dfs(cur,n)` 需要确定 `cur` 位置的状态，然后求解子问题 `dfs(cur+1,n)`。

对于 `cur` 位置，我们需要考虑 `a[cur]` 取或者不取，如果取，我们需要把 `a[cur]` 放入一个临时的答案数组中（即上面代码中的 `t`），再执行 `dfs(cur+1,n)`，执行结束后需要对 `t` 进行回溯；如果不取，则直接执行 `dfs(cur+1,n)`。在整个递归调用的过程中，`cur` 是从小到大递增的，当 `cur` 增加到 `n` 的时候，记录答案并终止递归。可以看出二进制枚举的时间复杂度是 `O(2^n)`。


复杂度分析
* 时间复杂度：`O(n×2^n)`。一共 `2^n` 个状态，每种状态需要 `O(n)` 的时间来构造子集。
* 空间复杂度：`O(n)`。临时数组 `t` 的空间代价是 `O(n)`，递归时栈空间的代价为 `O(n)`。



#### Solution

* Java


```java
class Solution {
    List<Integer> t = new ArrayList<Integer>();
    List<List<Integer>> ans = new ArrayList<List<Integer>>();

    public List<List<Integer>> subsets(int[] nums) {
        dfs(0, nums);
        return ans;
    }

    public void dfs(int cur, int[] nums) {
        if (cur == nums.length) {
            ans.add(new ArrayList<Integer>(t));
            return;
        }
        t.add(nums[cur]);
        dfs(cur + 1, nums);
        t.remove(t.size() - 1);
        dfs(cur + 1, nums);
    }
}
```


### Approach 3-回溯法


#### Analysis


参考 `leetcode-cn` 官方题解。


本题与 [剑指 Offer II 079. 所有子集](https://leetcode-cn.com/problems/TVdhkn/) 相同，笔记位于「LeetCode Notes-083-回溯」





#### Solution

```java
class Solution {

    public List<List<Integer>> subsets(int[] nums) {
        //对于每个元素 有选择当前元素和不选择当前元素两种方案
        List<List<Integer>> resList = new ArrayList<>();
        List<Integer> tempList = new ArrayList<>();
        backTrack(0,nums,resList,tempList);
        return resList;
    }

    private void backTrack(int index,int[] nums,List<List<Integer>> resList,List<Integer> tempList){
        if(index == nums.length){
            resList.add(new ArrayList<>(tempList));
            //resList.add(tempList);   //需要注意的是 此处应深拷贝一个List进行赋值 不能直接插入tempList 因为tempList会在后续回溯中发生变化
            return;
        }
        tempList.add(nums[index]);
        backTrack(index+1,nums,resList,tempList);
        tempList.remove(tempList.size()-1);
        backTrack(index+1,nums,resList,tempList);
    }
}
```

## 228. 汇总区间
### Description
* [LeetCode-228. 汇总区间](https://leetcode-cn.com/problems/summary-ranges/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution



```java

class Solution {
    public List<String> summaryRanges(int[] nums) {
        List<String> list = new ArrayList<>();
        if(nums.length == 0){
            return list;
        }
        int left = nums[0];
        int right = nums[0];
        int count = 1;
        for(int i=1;i<nums.length;i++){
            if(nums[i] == 1 + nums[i-1]){
                count++;
                left = nums[i];
            } else {
                if(count > 1){
                    String str = String.valueOf(right) + "->" + String.valueOf(left);
                    list.add(str);
                } else {
                    list.add(String.valueOf(right));
                }
                count = 1;
                right = nums[i];
                left = right;
            }
        }
        //最后一个元素
        if(count > 1){
            String str = String.valueOf(right) + "->" + String.valueOf(left);
            list.add(str);
        } else {
            list.add(String.valueOf(right));
        }
        return list;
    }
}
```


## 189. 旋转数组
### Description
* [LeetCode-189. 旋转数组](https://leetcode-cn.com/problems/rotate-array/)



### Approach 1-暴力法

#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(n*k)`。
* 空间复杂度：`O(1)`。没有额外空间被使用。





#### Solution


* Java


```java
class Solution {
    public void rotate(int[] nums, int k) {
        int size = nums.length;
        int endVal;
        while(k>0){
            endVal = nums[size-1];
            for(int j=size-1;j>0;j--){
                nums[j] = nums[j-1];
            }
            nums[0] = endVal;
            k--;
        }
    }
}
```





### Approach 2-使用额外的数组

#### Analysis

参考 `leetcode-cn` 官方题解。



我们可以用一个额外的数组来将每个元素放到正确的位置上，也就是原本数组里下标为 `i` 的我们把它放到 `(i+k)%数组长度` 的位置。然后把新的数组拷贝到原数组中。





复杂度分析
* 时间复杂度：`O(n)`。将数字放到新的数组中需要一遍遍历，另一边来把新数组的元素拷贝回原数组。
* 空间复杂度：`O(n)`。另一个数组需要原数组长度的空间。





#### Solution


* Java


```java
public class Solution {
    public void rotate(int[] nums, int k) {
        int[] a = new int[nums.length];
        for (int i = 0; i < nums.length; i++) {
            a[(i + k) % nums.length] = nums[i];
        }
        for (int i = 0; i < nums.length; i++) {
            nums[i] = a[i];
        }
    }
}
```



### Approach 3-使用环状替换

#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(n)`。只遍历了每个元素一次。
* 空间复杂度：`O(1)`。使用了常数个额外空间。





#### Solution


* Java

```java
public class Solution {
    public void rotate(int[] nums, int k) {
        int size = nums.length;
        int  count = 0;
        k = k%size;
        for(int start=0;count<size;start++){
            int current = start;
            int prev = nums[start];
            do{ //执行第1次时 start=end
                int next = (current+k)%size;
                int temp = nums[next];
                nums[next] = prev;
                prev = temp;
                current = next;
                count++;
            }while(start != current);
        }
    }
}
```


### Approach 4-使用反转

#### Analysis

参考 `leetcode-cn` 官方题解。


这个方法基于这个事实：**当我们旋转数组 `k` 次， `k%n` 个尾部元素会被移动到头部，剩下的元素会被向后移动。**

在这个方法中，我们首先将所有元素反转。然后反转前 `k` 个元素，再反转后面 `n-k` 个元素，就能得到想要的结果。

假设 `n=7, k=3`。

```
原始数组                  : 1 2 3 4 5 6 7
反转所有数字后             : 7 6 5 4 3 2 1
反转前 k 个数字后          : 5 6 7 4 3 2 1
反转后 n-k 个数字后        : 5 6 7 1 2 3 4 --> 结果
```




复杂度分析
* 时间复杂度：`O(n)`。 `n` 个元素被反转了总共 3 次。
* 空间复杂度：`O(1)`。没有使用额外的空间。





#### Solution


* Java

```java
public class Solution {
    public void rotate(int[] nums, int k) {
        k %= nums.length;
        reverse(nums, 0, nums.length - 1);
        reverse(nums, 0, k - 1);
        reverse(nums, k, nums.length - 1);
    }
    public void reverse(int[] nums, int start, int end) {
        while (start < end) {
            int temp = nums[start];
            nums[start] = nums[end];
            nums[end] = temp;
            start++;
            end--;
        }
    }
}
```



