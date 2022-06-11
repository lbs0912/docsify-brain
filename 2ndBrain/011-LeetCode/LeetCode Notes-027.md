
# LeetCode Notes-027


[TOC]



## 更新
* 2021/03/15，撰写
* 2021/03/17，完成


## Overview
* [LeetCode-115. 不同的子序列](https://leetcode-cn.com/problems/distinct-subsequences/description/)
* [LeetCode-647. 回文子串](https://leetcode-cn.com/problems/palindromic-substrings/)
* [LeetCode-56. 合并区间](https://leetcode-cn.com/problems/merge-intervals/description/)
* [LeetCode-22. 括号生成](https://leetcode-cn.com/problems/generate-parentheses/description/)
* [LeetCode-238. 除自身以外数组的乘积](https://leetcode-cn.com/problems/product-of-array-except-self/)





## 115. 不同的子序列
### Description
* [LeetCode-115. 不同的子序列](https://leetcode-cn.com/problems/distinct-subsequences/description/)

### Approach 1-动态规划
#### Analysis

参考 `leetcode-cn` 官方题解。



假设字符串 `s` 和 `t` 的长度分别为 `m` 和 `n`。如果 `t` 是 `s` 的子序列，则 `s` 的长度一定大于或等于 `t` 的长度，即只有当 `m≥n` 时，`t` 才可能是 `s` 的子序列。如果 `m<n`，则 `t` 一定不是 `s` 的子序列，因此直接返回 0。


当 `m≥n` 时，可以通过动态规划的方法计算在 `s` 的子序列中 `t` 出现的个数。

创建二维数组 `dp`，其中 `dp[i][j]` 表示在 `s[i:]` 的子序列中 `t[j:]` 出现的个数。

上述表示中，`s[i:]` 表示 `s` 从下标 `i` 到末尾的子字符串，`t[j:]` 表示 `t` 从下标 `j` 到末尾的子字符串。

考虑动态规划的边界情况。
1. 当 `j=n` 时，`t[j:]` 为空字符串，由于空字符串是任何字符串的子序列，因此对任意 `0≤i≤m`，有 `dp[i][n]=1`
2. 当 `i=m` 且 `j<n` 时，`s[i:]` 为空字符串，`t[j:]` 为非空字符串，由于非空字符串不是空字符串的子序列，因此对任意 `0≤j<n`，有 `dp[m][j]=0`。


下面进行动态方程的推导。当 `i<m` 且 `j<n` 时，考虑 `dp[i][j]` 的计算

1. 当 `s[i]` 不等于 `t[j]` 时，`s[i]` 不能和 `t[j]` 匹配，因此只考虑 `t[j:]` 作为 `s[i+1:]` 的子序列，子序列数为 `dp[i+1][j]`。此时有 `dp[i][j]=dp[i+1][j]`
2. 当 `s[i]=t[j]` 时，`dp[i][j]` 由两部分组成
    * 首先，同情况1，考虑 `t[j+1:]` 作为子序列，此时有 `dp[i][j]=dp[i+1][j+1]`
    * 然后，考虑 `t[j:]` 作为子序列，此时有 `dp[i][j]=dp[i+1][j]`
    * 综上，`dp[i][j]=dp[i+1][j+1]+dp[i+1][j]`


由此可以得到如下状态转移方程

```math
\textit{dp}[i][j] = \begin{cases} \textit{dp}[i+1][j+1]+\textit{dp}[i+1][j], & s[i]=t[j]\\ \textit{dp}[i+1][j], & s[i] \ne t[j] \end{cases}
```




复杂度分析
* 时间复杂度：`O(mn)`，其中 `m` 和 `n` 分别是字符串 `s` 和 `t` 的长度。二维数组 `dp` 有 `m+1` 行和 `n+1` 列，需要对 `dp` 中的每个元素进行计算。
* 空间复杂度：`O(mn)`，其中 `m` 和 `n` 分别是字符串 `s` 和 `t` 的长度。创建了 `m+1` 行 `n+1` 列的二维数组 `dp`。



#### Solution


```java
class Solution {
    public int numDistinct(String s, String t) {
        int m = s.length(), n = t.length();
        if(m < n) {
            return 0;
        }
        int[][] dp = new int[m+1][n+1];
        for(int i=0;i<=m;i++){
            dp[i][n] = 1;
        }
        for(int i=m-1;i>=0;i--){
            char sChar = s.charAt(i);
            for(int j=n-1;j>=0;j--){
                char tChar = t.charAt(j);
                if(sChar == tChar){
                    dp[i][j] = dp[i+1][j+1] + dp[i+1][j];
                } else{
                    dp[i][j] = dp[i+1][j];
                }
            }
        }
    
        return dp[0][0];
    }
}
```



## 647. 回文子串
### Description
* [LeetCode-647. 回文子串](https://leetcode-cn.com/problems/palindromic-substrings/)

### Approach 1-中心拓展

#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

* Java


```java
class Solution {
    public int countSubstrings(String s) {
        int n = s.length();
        int ans = 0;
        for(int i=0;i<2*n-1;i++){
            int l = i/2;
            int r = i/2 + i%2;
            while(l>=0 && r<n && s.charAt(l) == s.charAt(r)){
                --l;
                ++r;
                ans++;
            }
        }
        return ans;
    }
}

```


## 56. 合并区间
### Description
* [LeetCode-56. 合并区间](https://leetcode-cn.com/problems/merge-intervals/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int[][] merge(int[][] intervals) {
        if (intervals.length == 0) {
            return new int[0][2];
        }
        Arrays.sort(intervals, new Comparator<int[]>() {
            public int compare(int[] interval1, int[] interval2) {
                return interval1[0] - interval2[0];
            }
        });
        List<int[]> merged = new ArrayList<int[]>();
        for (int i = 0; i < intervals.length; ++i) {
            int L = intervals[i][0], R = intervals[i][1];
            if (merged.size() == 0 || merged.get(merged.size() - 1)[1] < L) {
                merged.add(new int[]{L, R});
            } else {
                merged.get(merged.size() - 1)[1] = Math.max(merged.get(merged.size() - 1)[1], R);
            }
        }
        return merged.toArray(new int[merged.size()][]);
    }
}
```


## 22. 括号生成
### Description
* [LeetCode-22. 括号生成](https://leetcode-cn.com/problems/generate-parentheses/description/)

### Approach 1-暴力法
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public List<String> generateParenthesis(int n) {
        List<String> combinations = new ArrayList<String>();
        generateAll(new char[2 * n], 0, combinations);
        return combinations;
    }
    public void generateAll(char[] current, int pos, List<String> result) {
        if (pos == current.length) {
            if (valid(current)) {
                result.add(new String(current));
            }
        } else {
            current[pos] = '(';
            generateAll(current, pos + 1, result);
            current[pos] = ')';
            generateAll(current, pos + 1, result);
        }
    }

    public boolean valid(char[] current) {
        int balance = 0;
        for (char c: current) {
            if (c == '(') {
                ++balance;
            } else {
                --balance;
            }
            if (balance < 0) { //允许出现((）+ ) 不允许出现 ))( + )
                return false;
            }
        }
        return balance == 0;
    }
}
```


### Approach 2-回溯法
#### Analysis

参考 `leetcode-cn` 官方题解。


对方法1进行改进，我们可以只在序列仍然保持有效时才添加 `'('` or `')'`，而不是像「方法一」那样每次添加。我们可以通过跟踪到目前为止放置的左括号和右括号的数目来做到这一点，

如果左括号数量不大于 n，我们可以放一个左括号。如果右括号数量小于左括号的数量，我们可以放一个右括号。



#### Solution


```java
class Solution {
    public List<String> generateParenthesis(int n) {
        List<String> ans = new ArrayList<String>();
        backtrack(ans, new StringBuilder(), 0, 0, n);
        return ans;
    }

    public void backtrack(List<String> ans, StringBuilder cur, int open, int close, int max) {
        if (cur.length() == max * 2) {
            ans.add(cur.toString());
            return;
        }
        if (open < max) {
            cur.append('(');
            backtrack(ans, cur, open + 1, close, max);
            cur.deleteCharAt(cur.length() - 1);
        }
        if (close < open) {
            cur.append(')');
            backtrack(ans, cur, open, close + 1, max);
            cur.deleteCharAt(cur.length() - 1);
        }
    }
}
```


## 238. 除自身以外数组的乘积
### Description
* [LeetCode-238. 除自身以外数组的乘积](https://leetcode-cn.com/problems/product-of-array-except-self/)

### Approach 1-左右乘积列表
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int[] productExceptSelf(int[] nums) {
        int length = nums.length;

        // L 和 R 分别表示左右两侧的乘积列表
        int[] L = new int[length];
        int[] R = new int[length];

        int[] answer = new int[length];

        // L[i] 为索引 i 左侧所有元素的乘积
        // 对于索引为 '0' 的元素，因为左侧没有元素，所以 L[0] = 1
        L[0] = 1;
        for (int i = 1; i < length; i++) {
            L[i] = nums[i - 1] * L[i - 1];
        }

        // R[i] 为索引 i 右侧所有元素的乘积
        // 对于索引为 'length-1' 的元素，因为右侧没有元素，所以 R[length-1] = 1
        R[length - 1] = 1;
        for (int i = length - 2; i >= 0; i--) {
            R[i] = nums[i + 1] * R[i + 1];
        }

        // 对于索引 i，除 nums[i] 之外其余各元素的乘积就是左侧所有元素的乘积乘以右侧所有元素的乘积
        for (int i = 0; i < length; i++) {
            answer[i] = L[i] * R[i];
        }

        return answer;
    }
}
```


### Approach 2-继续优化
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int[] productExceptSelf(int[] nums) {
        int length = nums.length;
        int[] answer = new int[length];

        // answer[i] 表示索引 i 左侧所有元素的乘积
        // 因为索引为 '0' 的元素左侧没有元素， 所以 answer[0] = 1
        answer[0] = 1;
        for (int i = 1; i < length; i++) {
            answer[i] = nums[i - 1] * answer[i - 1];
        }

        // R 为右侧所有元素的乘积
        // 刚开始右边没有元素，所以 R = 1
        int R = 1;
        for (int i = length - 1; i >= 0; i--) {
            // 对于索引 i，左边的乘积为 answer[i]，右边的乘积为 R
            answer[i] = answer[i] * R;
            // R 需要包含右边所有的乘积，所以计算下一个结果时需要将当前值乘到 R 上
            R *= nums[i];
        }
        return answer;
    }
}
```