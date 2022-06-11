# LeetCode Notes-052-回溯+剪枝


[TOC]



## 更新
* 2021/07/24，撰写
* 2021/07/25，**回溯+剪枝** 专题汇总


## Overview
* [LeetCode-39. 组合总和](https://leetcode-cn.com/problems/combination-sum/)
* [LeetCode-40. 组合总和 II](https://leetcode-cn.com/problems/combination-sum-ii/description/)
* [LeetCode-46. 全排列](https://leetcode-cn.com/problems/permutations/)
* [LeetCode-47. 全排列 II](https://leetcode-cn.com/problems/permutations-ii/)
* [LeetCode-77. 组合](https://leetcode-cn.com/problems/combinations/)



## 回溯+剪枝-剖析


下面结合 [LeetCode-39. 组合总和](https://leetcode-cn.com/problems/combination-sum/) 题目，对**回溯+剪枝** 方法进行剖析。




### 步骤分析


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/leetcode/leetcode-39-3.png)


#### 回溯


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/leetcode/leetcode-39-1.png)



结合如上树形图，进行分析，从根结点到结点 0 的路径，就是题目要找的一个结果。

这棵树有 4 个叶子结点的值 0，对应的路径列表是 `[[2, 2, 3], [2, 3, 2], [3, 2, 2], [7]]`，而示例中给出的输出只有 `[[7], [2, 2, 3]]`。即题目中要求每一个符合要求的解是**不计算顺序 的**。


下面我们分析为什么会产生重复。


产生重复的原因是在每一个结点「做减法」展开分支的时候，由于题目中说每一个元素可以重复使用，我们考虑了 所有的候选数，因此出现了重复的列表。


一种简单的去重方案是借助哈希表的天然去重的功能，但实际操作一下，就会发现并没有那么容易。

可不可以在搜索的时候就去重呢？答案是可以的。遇到这一类相同元素不计算顺序的问题，我们在搜索的时候就需要**按某种顺序搜索**。


**具体的做法是每一次搜索的时候设置「下一轮搜索」的起点 `begin`，请看下图。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/leetcode/leetcode-39-2.png)


即从每一层的第 2 个结点开始，都不能再搜索产生同一层结点已经使用过的 `candidate` 里的元素。



```java

public class Solution {

    public List<List<Integer>> combinationSum(int[] candidates, int target) {
        int len = candidates.length;
        List<List<Integer>> res = new ArrayList<>();
        if (len == 0) {
            return res;
        }

        Deque<Integer> path = new ArrayDeque<>();
        dfs(candidates, 0, len, target, path, res);
        return res;
    }

    private void dfs(int[] candidates, int begin, int len, int target, Deque<Integer> path, List<List<Integer>> res) {
        if (target < 0) {
            return;
        }
        if (target == 0) {
            res.add(new ArrayList<>(path));
            return;
        }

        for (int i = begin; i < len; i++) {
            path.addLast(candidates[i]);
            System.out.println("递归之前 => " + path + "，剩余 = " + (target - candidates[i]));

            dfs(candidates, i, len, target - candidates[i], path, res);

            path.removeLast();
            System.out.println("递归之后 => " + path);

        }
    }

    public static void main(String[] args) {
        Solution solution = new Solution();
        int[] candidates = new int[]{2, 3, 6, 7};
        int target = 7;
        List<List<Integer>> res = solution.combinationSum(candidates, target);
        System.out.println("输出 => " + res);
    }
}

```


执行上述代码，查看递归前后的变化。


```s
递归之前 => [2]，剩余 = 5
递归之前 => [2, 2]，剩余 = 3
递归之前 => [2, 2, 2]，剩余 = 1
递归之前 => [2, 2, 2, 2]，剩余 = -1
递归之后 => [2, 2, 2]
递归之前 => [2, 2, 2, 3]，剩余 = -2
递归之后 => [2, 2, 2]
递归之前 => [2, 2, 2, 6]，剩余 = -5
递归之后 => [2, 2, 2]
递归之前 => [2, 2, 2, 7]，剩余 = -6
递归之后 => [2, 2, 2]
递归之后 => [2, 2]
递归之前 => [2, 2, 3]，剩余 = 0
递归之后 => [2, 2]
递归之前 => [2, 2, 6]，剩余 = -3
递归之后 => [2, 2]
递归之前 => [2, 2, 7]，剩余 = -4
递归之后 => [2, 2]
递归之后 => [2]
递归之前 => [2, 3]，剩余 = 2
递归之前 => [2, 3, 3]，剩余 = -1
递归之后 => [2, 3]
递归之前 => [2, 3, 6]，剩余 = -4
递归之后 => [2, 3]
递归之前 => [2, 3, 7]，剩余 = -5
递归之后 => [2, 3]
递归之后 => [2]
递归之前 => [2, 6]，剩余 = -1
递归之后 => [2]
递归之前 => [2, 7]，剩余 = -2
递归之后 => [2]
递归之后 => []
递归之前 => [3]，剩余 = 4
递归之前 => [3, 3]，剩余 = 1
递归之前 => [3, 3, 3]，剩余 = -2
递归之后 => [3, 3]
递归之前 => [3, 3, 6]，剩余 = -5
递归之后 => [3, 3]
递归之前 => [3, 3, 7]，剩余 = -6
递归之后 => [3, 3]
递归之后 => [3]
递归之前 => [3, 6]，剩余 = -2
递归之后 => [3]
递归之前 => [3, 7]，剩余 = -3
递归之后 => [3]
递归之后 => []
递归之前 => [6]，剩余 = 1
递归之前 => [6, 6]，剩余 = -5
递归之后 => [6]
递归之前 => [6, 7]，剩余 = -6
递归之后 => [6]
递归之后 => []
递归之前 => [7]，剩余 = 0
递归之后 => []
输出 => [[2, 2, 3], [7]]
```


#### 剪枝提速

* 根据上面画树形图的经验，如果 `target` 减去一个数得到负数，那么减去一个更大的树依然是负数，同样搜索不到结果。基于这个想法，我们可以对输入数组进行排序，添加相关逻辑达到进一步剪枝的目的；
* 排序是为了提高搜索速度，对于解决这个问题来说非必要。但是搜索问题一般复杂度较高，能剪枝就尽量剪枝。实际工作中如果遇到两种方案拿捏不准的情况，都试一下。


```java

public class Solution {

    public List<List<Integer>> combinationSum(int[] candidates, int target) {
        int len = candidates.length;
        List<List<Integer>> res = new ArrayList<>();
        if (len == 0) {
            return res;
        }

        Arrays.sort(candidates);
        Deque<Integer> path = new ArrayDeque<>();
        dfs(candidates, 0, len, target, path, res);
        return res;
    }

    private void dfs(int[] candidates, int begin, int len, int target, Deque<Integer> path, List<List<Integer>> res) {
        if (target == 0) {
            res.add(new ArrayList<>(path));
            return;
        }

        for (int i = begin; i < len; i++) {
            if (target - candidates[i] < 0) {
                break;
            }

            path.addLast(candidates[i]);
            System.out.println("递归之前 => " + path + "，剩余 = " + (target - candidates[i]));

            dfs(candidates, i, len, target - candidates[i], path, res);
            path.removeLast();
            System.out.println("递归之后 => " + path);
        }
    }

    public static void main(String[] args) {
        Solution solution = new Solution();
        int[] candidates = new int[]{2, 3, 6, 7};
        int target = 7;
        List<List<Integer>> res = solution.combinationSum(candidates, target);
        System.out.println("输出 => " + res);
    }
}
```


执行上述代码，查看递归前后的变化。


```java
递归之前 => [2]，剩余 = 5
递归之前 => [2, 2]，剩余 = 3
递归之前 => [2, 2, 2]，剩余 = 1
递归之后 => [2, 2]
递归之前 => [2, 2, 3]，剩余 = 0
递归之后 => [2, 2]
递归之后 => [2]
递归之前 => [2, 3]，剩余 = 2
递归之后 => [2]
递归之后 => []
递归之前 => [3]，剩余 = 4
递归之前 => [3, 3]，剩余 = 1
递归之后 => [3]
递归之后 => []
递归之前 => [6]，剩余 = 1
递归之后 => []
递归之前 => [7]，剩余 = 0
递归之后 => []
输出 => [[2, 2, 3], [7]]
```

可以很清楚地看到有「剪枝」的代码考虑的路径数会更少一些。


#### 补充说明



此处对代码中 `for (int i = begin; i < len; i++)` 语句进行分析。

1. 若结果输出为排列问题，讲究顺序，则代码应改为

```java
for (int i = 0; i < len; i++){
    // ...
}
```

此时输出结果为 `[[2, 2, 3], [2, 3, 2], [3, 2, 2], [7]]`。


2. 若结果输出为组合问题，不讲究顺序，则代码应改为

```java
for (int i = begin; i < len; i++){
    // ...
}
```

此时输出结果为 `[[2, 2, 3], [7]]`。



**如 [LeetCode-46. 全排列](https://leetcode-cn.com/problems/permutations/) 题目中，输出结果为排列问题，讲究顺序，故代码为 `for (int i = 0; i < len; i++)`。**







### 题目赏析
* [LeetCode-39. 组合总和](https://leetcode-cn.com/problems/combination-sum/)
* [LeetCode-40. 组合总和 II](https://leetcode-cn.com/problems/combination-sum-ii/description/)
* [LeetCode-46. 全排列](https://leetcode-cn.com/problems/permutations/)
* [LeetCode-剑指 Offer II 080. 含有 k 个元素的组合](https://leetcode-cn.com/problems/uUsW3B/)



## 【经典】39. 组合总和
### Description
* [LeetCode-39. 组合总和](https://leetcode-cn.com/problems/combination-sum/)

### Approach 1-回溯法
#### Analysis

参考 `leetcode-cn` 官方题解。

* [回溯法+减枝 | 图解](https://leetcode-cn.com/problems/combination-sum/solution/hui-su-suan-fa-jian-zhi-python-dai-ma-java-dai-m-2/)


【经典】题目，仔细体会理解。




此处对代码中 `for (int i = begin; i < len; i++)` 语句进行分析。

1. 若结果输出为排列问题，讲究顺序，则代码应改为

```java
for (int i = 0; i < len; i++){
    // ...
}
```

此时输出结果为 `[[2, 2, 3], [2, 3, 2], [3, 2, 2], [7]]`。


2. 若结果输出为组合问题，不讲究顺序，则代码应改为

```java
for (int i = begin; i < len; i++){
    // ...
}
```

此时输出结果为 `[[2, 2, 3], [7]]`。


#### Solution


```java
public class Solution {

    public List<List<Integer>> combinationSum(int[] candidates, int target) {
        int len = candidates.length;
        List<List<Integer>> res = new ArrayList<>();
        if (len == 0) {
            return res;
        }

        Deque<Integer> path = new ArrayDeque<>();
        dfs(candidates, 0, len, target, path, res);
        return res;
    }

    /**
     * @param candidates 候选数组
     * @param begin      搜索起点
     * @param len        冗余变量，是 candidates 里的属性，可以不传
     * @param target     每减去一个元素，目标值变小
     * @param path       从根结点到叶子结点的路径，是一个栈
     * @param res        结果集列表
     */
    private void dfs(int[] candidates, int begin, int len, int target, Deque<Integer> path, List<List<Integer>> res) {
        // target 为负数和 0 的时候不再产生新的孩子结点
        if (target < 0) {
            return;
        }
        if (target == 0) {
            res.add(new ArrayList<>(path));
            return;
        }

        // 重点理解这里从 begin 开始搜索的语意
        for (int i = begin; i < len; i++) {
            path.addLast(candidates[i]);

            // 注意：由于每一个元素可以重复使用，下一轮搜索的起点依然是 i，这里非常容易弄错
            dfs(candidates, i, len, target - candidates[i], path, res);

            // 状态重置
            path.removeLast();
        }
    }
}
```


### Approach 2-回溯法+剪枝
#### Analysis

参考 `leetcode-cn` 官方题解。

* [回溯法+减枝 | 图解](https://leetcode-cn.com/problems/combination-sum/solution/hui-su-suan-fa-jian-zhi-python-dai-ma-java-dai-m-2/)


【经典】题目，仔细体会理解。







#### Solution


```java


public class Solution {

    public List<List<Integer>> combinationSum(int[] candidates, int target) {
        int len = candidates.length;
        List<List<Integer>> res = new ArrayList<>();
        if (len == 0) {
            return res;
        }

        // 排序是剪枝的前提
        Arrays.sort(candidates);
        Deque<Integer> path = new ArrayDeque<>();
        dfs(candidates, 0, len, target, path, res);
        return res;
    }

    private void dfs(int[] candidates, int begin, int len, int target, Deque<Integer> path, List<List<Integer>> res) {
        // 由于进入更深层的时候，小于 0 的部分被剪枝，因此递归终止条件值只判断等于 0 的情况
        if (target == 0) {
            res.add(new ArrayList<>(path));
            return;
        }

        for (int i = begin; i < len; i++) {
            // 重点理解这里剪枝，前提是候选数组已经有序，
            if (target - candidates[i] < 0) {
                break;
            }
            
            path.addLast(candidates[i]);
            dfs(candidates, i, len, target - candidates[i], path, res);
            path.removeLast();
        }
    }
}

```









## 40. 组合总和 II
### Description
* [LeetCode-40. 组合总和 II](https://leetcode-cn.com/problems/combination-sum-ii/description/)

### Approach 1-回溯+剪枝
#### Analysis

参考 `leetcode-cn` 官方题解。


* [回溯+剪枝 | 图解](https://leetcode-cn.com/problems/combination-sum-ii/solution/hui-su-suan-fa-jian-zhi-python-dai-ma-java-dai-m-3/)


本题和 [LeetCode-39. 组合总和](https://leetcode-cn.com/problems/combination-sum/) 的比较如下
* 相同点是相同数字列表的不同排列视为一个结果
* 不同点是，40题中 candidates 的每个数字在每个组合中只能使用一次，39题中的数字可以无限制重复被选择。



结合如下图解加深理解。
  

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/leetcode/leetcode-40-1.png)


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/leetcode/leetcode-40-2.png)






#### Solution

```java
public class Solution {

    public List<List<Integer>> combinationSum2(int[] candidates, int target) {
        int len = candidates.length;
        List<List<Integer>> res = new ArrayList<>();
        if (len == 0) {
            return res;
        }

        // 关键步骤
        Arrays.sort(candidates);

        Deque<Integer> path = new ArrayDeque<>(len);
        dfs(candidates, len, 0, target, path, res);
        return res;
    }

    /**
     * @param candidates 候选数组
     * @param len        冗余变量
     * @param begin      从候选数组的 begin 位置开始搜索
     * @param target     表示剩余，这个值一开始等于 target，基于题目中说明的"所有数字（包括目标数）都是正整数"这个条件
     * @param path       从根结点到叶子结点的路径
     * @param res
     */
    private void dfs(int[] candidates, int len, int begin, int target, Deque<Integer> path, List<List<Integer>> res) {
        if (target == 0) {
            res.add(new ArrayList<>(path));
            return;
        }
        for (int i = begin; i < len; i++) {
            // 大剪枝：减去 candidates[i] 小于 0，减去后面的 candidates[i + 1]、candidates[i + 2] 肯定也小于 0，因此用 break
            if (target - candidates[i] < 0) {
                break;
            }

            // 小剪枝：同一层相同数值的结点，从第 2 个开始，候选数更少，结果一定发生重复，因此跳过，用 continue
            if (i > begin && candidates[i] == candidates[i - 1]) {
                continue;
            }

            path.addLast(candidates[i]);
            // 调试语句 ①
            // System.out.println("递归之前 => " + path + "，剩余 = " + (target - candidates[i]));

            // 因为元素不可以重复使用，这里递归传递下去的是 i + 1 而不是 i
            dfs(candidates, len, i + 1, target - candidates[i], path, res);

            path.removeLast();
            // 调试语句 ②
            // System.out.println("递归之后 => " + path + "，剩余 = " + (target - candidates[i]));
        }
    }

    public static void main(String[] args) {
        int[] candidates = new int[]{10, 1, 2, 7, 6, 1, 5};
        int target = 8;
        Solution solution = new Solution();
        List<List<Integer>> res = solution.combinationSum2(candidates, target);
        System.out.println("输出 => " + res);
    }
}
```





## 46. 全排列
### Description
* [LeetCode-46. 全排列](https://leetcode-cn.com/problems/permutations/)

### Approach 1-回溯

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


* Java


```java

class Solution {
        public List<List<Integer>> permute(int[] nums) {
        int len = nums.length;
        List<List<Integer>> res = new ArrayList<>();
        if (len == 0) {
            return res;
        }

        Deque<Integer> path = new ArrayDeque<>();
        dfs(nums, 0, len,path, res);
        return res;
    }


    private void dfs(int[] candidates, int begin, int len, Deque<Integer> path, List<List<Integer>> res) {

        if (path.size() == len) {
            res.add(new ArrayList<>(path));
            return;
        }
        // 结果和排列顺序有关 因此i=0 而不是i=begin
        for (int i = 0; i < len; i++) {
            if(path.contains(candidates[i])){
                continue;
            }
            path.addLast(candidates[i]);
            System.out.println("递归之前 => " + path + ", i=" + i);
            //元素不能重复使用，因此为i+1
            dfs(candidates, i+1, len, path, res);

            // 状态重置
            path.removeLast();
            System.out.println("递归之后 => " + path);
        }
    }

}
```


## 47. 全排列 II
### Description
* [LeetCode-47. 全排列 II](https://leetcode-cn.com/problems/permutations-ii/)

### Approach 1-回溯

#### Analysis


参考 `leetcode-cn` 官方题解。



此处对 `!vis[i-1]` 进行解释。


```java
if(vis[i] || (i>0 && candidates[i] == candidates[i-1]) && !vis[i-1]){
    continue;
}
```

加上 `!vis[i-1]` 来去重主要是通过限制一下两个相邻的重复数字的访问顺序。举个栗子，对于两个相同的数 1，我们将其命名为 `1a1b`,`1a` 表示第一个 1，`1b` 表示第二个 1。

那么，不做去重的话，会有两种重复排列 `1a1b`, `1b1a`，我们只需要取其中任意一种排列。为了达到这个目的，限制一下 `1a`, `1b` 访问顺序即可。 比如我们只取 `1a1b` 那个排列的话，只有当 `visit nums[i-1]` 之后我们才去 `visit nums[i]`， 也就是如果 `!visited[i-1]` 的话则 `continue`。





#### Solution


```java
class Solution {
    public List<List<Integer>> permuteUnique(int[] nums) {
        int len = nums.length;
        List<List<Integer>> res = new ArrayList<>();
        if (len == 0) {
            return res;
        }
        Arrays.sort(nums);
        boolean[] vis = new boolean[nums.length];
        Deque<Integer> path = new ArrayDeque<>();
        dfs(nums, 0, len,path, res,vis);
        return res;
    }

    private void dfs(int[] candidates, int begin, int len, Deque<Integer> path, List<List<Integer>> res,boolean[] vis) {

        if (path.size() == len) {

            res.add(new ArrayList<>(path));
            return;
        }
        // 结果和排列顺序有关 因此i=0 而不是i=begin
        for (int i = 0; i < len; i++) {

            if(vis[i] || (i>0 && candidates[i] == candidates[i-1]) && !vis[i-1]){
                continue;
            }
            path.addLast(candidates[i]);
            vis[i] = true;
            System.out.println("递归之前 => " + path + ", i=" + i);
            //元素不能重复使用，因此为i+1
            dfs(candidates, i+1, len, path, res,vis);

            // 状态重置
            path.removeLast();
            vis[i] = false;
            System.out.println("递归之后 => " + path);
        }
    }
}
```



## 77. 组合
### Description
* [LeetCode-77. 组合](https://leetcode-cn.com/problems/combinations/)

### Approach 1-回溯

#### Analysis

参考 `leetcode-cn` 官方题解。


#### Solution

```java
class Solution {
    public List<List<Integer>> combine(int n, int k) {
        List<List<Integer>> list = new ArrayList<>();
        List<Integer> path = new ArrayList<>();
        int begin = 1;
        dfs(list,path,n,k,begin);
        return list;
    }

    private void dfs(List<List<Integer>> list,List<Integer> path, int n, int k, int begin){
        if(path.size() == k){
            list.add(new ArrayList<>(path));
            return;
        }
        //组合问题 和顺序无关 故为i=begin 不是i=0
        for(int i=begin;i<=n;i++){
            path.add(i);
            dfs(list,path,n,k,i+1); //数字只能取1次 故为i+1
            path.remove(path.size()-1);
        }
    }
}
```