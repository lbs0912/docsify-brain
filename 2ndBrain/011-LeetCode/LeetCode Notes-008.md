
# LeetCode Notes-008


[TOC]



## 更新
* 2020/05/12，撰写
* 2020/06/13，整理完成

## Overview

* [LeetCode-1371. 每个元音包含偶数次的最长子字符串](https://leetcode-cn.com/problems/find-the-longest-substring-containing-vowels-in-even-counts/)
* [LeetCode-5. 最长回文子串](https://leetcode-cn.com/problems/longest-palindromic-substring/)
* [LeetCode-207. 课程表](https://leetcode-cn.com/problems/course-schedule/)
* [LeetCode-70. 爬楼梯](https://leetcode-cn.com/problems/climbing-stairs/)
* [LeetCode-739. 每日温度](https://leetcode-cn.com/problems/daily-temperatures/)




## 1371. 每个元音包含偶数次的最长子字符串

### Description
* [LeetCode-1371. 每个元音包含偶数次的最长子字符串](https://leetcode-cn.com/problems/find-the-longest-substring-containing-vowels-in-even-counts/)


### Approach 1-前缀和+状态压缩

#### Analysis


参考 `leetcode-cn` 官方题解。


我们先来考虑暴力方法怎么做。最直观的方法无非就是枚举所有子串，遍历子串中的所有字符，统计元音字母出现的个数。如果符合条件，我们就更新答案，但这样肯定会因为超时而无法通过所有测试用例。

再回顾一下上面的操作，其实每个子串对应着一个区间，那么有什么方法可以在不重复遍历子串的前提下，快速求出这个区间里元音字母出现的次数呢？**答案就是前缀和，对于一个区间，我们可以用两个前缀和的差值，得到其中某个字母的出现次数。**

我们对每个元音字母维护一个前缀和，定义 `pre[i][k]` 表示在字符串前 `i` 个字符中，第 `k` 个元音字母一共出现的次数。假设我们需要求出 `[l,r]` 这个区间的子串是否满足条件，那么我们可以用 `pre[r][k] - pre[l-1][k]`，在 `O(1)` 的时间得到第 `k` 个元音字母出现的次数。对于每一个元音字母，我们都判断一下其是否出现偶数次即可。

我们利用前缀和优化了统计子串的时间复杂度，然而枚举所有子串的复杂度仍需要 `O(n^2)`，不足以通过本题，还需要继续进行优化，避免枚举所有子串。我们考虑枚举字符串的每个位置 `i` ，计算以它结尾的满足条件的最长字符串长度。其实我们要做的就是快速找到最小的 `$j \in [0,i)$`，满足 `pre[i][k]-pre[j][k]`（即每一个元音字母出现的次数）均为偶数，那么以 `i` 结尾的最长字符串 `s[j+1,i]` 长度就是 `i-j`。

有经验的读者可能马上就想到了利用哈希表来优化查找的复杂度，但是单单利用前缀和，我们无法找到 `i` 和 `j` 相关的恒等式，像 [1248. 统计优美子数组](https://leetcode-cn.com/problems/count-number-of-nice-subarrays/)  这道题我们是能明确知道两个前缀的差值是恒定的。那难道就没办法了么？

其实不然，这道题我们还有一个性质没有充分利用：我们需要找的子串中，每个元音字母都恰好出现了偶数次。

**偶数这个条件其实告诉了我们，对于满足条件的子串而言，两个前缀和 `pre[i][k]` 和 `pre[j][k]` 的奇偶性一定是相同的，因为小学数学的知识告诉我们：奇数减奇数等于偶数，偶数减偶数等于偶数。因此我们可以对前缀和稍作修改，从维护元音字母出现的次数改作维护元音字母出现次数的奇偶性。**

这样我们只要实时维护每个元音字母出现的奇偶性，那么 `s[j+1,i]` 满足条件当且仅当对于所有的 `k`，`pre[i][k]` 和 `pre[j][k]` 的奇偶性都相等，此时我们就可以利用哈希表 **存储每一种奇偶性（即考虑所有的元音字母）对应最早出现的位置**，边遍历边更新答案。

题目做到这里基本上做完了，但是我们还可以进一步优化我们的编码方式，如果直接以每个元音字母出现次数的奇偶性为哈希表中的键，难免有些冗余，我们可能需要额外定义一个状态

```java
{
  a: cnta, // a 出现次数的奇偶性
  e: cnte, // e 出现次数的奇偶性
  i: cnti, // i 出现次数的奇偶性
  o: cnto, // o 出现次数的奇偶性
  u: cntu  // u 出现次数的奇偶性
}
```

将这么一个结构当作我们哈希表存储的键值，如果题目稍作修改扩大了字符集，那么维护起来可能会比较吃力。考虑到出现次数的奇偶性其实无非就两个值，`0` 代表出现了偶数次，`1` 代表出现了奇数次，我们可以将其压缩到一个二进制数中，第 `k` 位的 `0` 或 `1` 代表了第 `k` 个元音字母出现的奇偶性。

举一个例子，假如到第 `i` 个位置，`u o i e a` 出现的奇偶性分别为 `1 1 0 0 1`，那么我们就可以将其压成一个二进制数 `$(11001)_2=(25)_{10}$` 作为它的状态。这样我们就可以将 5 个元音字母出现次数的奇偶性压缩到了一个二进制数中，且连续对应了二进制数的  `$[(00000)_2,(11111)_2]$` 的范围，转成十进制数即 `[0,31]`。因此我们也不再需要使用哈希表，**直接用一个长度为 32 的数组来存储对应状态出现的最早位置即可**。


复杂度分析

1. 时间复杂度：`O(n)`，其中 n 为字符串的长度。我们只需要遍历一遍字符串即可求得答案。
2. 空间复杂度：`O(S)`，其中 S 表示元音字母压缩成一个状态数的最大值，在本题中 `S = 32`。我们需要对应 `S` 大小的空间来存放每个状态第一次出现的位置，因此需要 `O(S)` 的空间复杂度。


#### Solution

* Java


```java
class Solution {
    public int findTheLongestSubstring(String s) {
        int length = s.length();
        //共5个字母，奇偶状态排列 计数最大值为1<<5
        //用一个32为数组pos，存放从0到i，第一次出现[a,e,i,o,u]各种奇偶情况的位置
        //从00000-11111种状态，代表5个元音字母的个数是否为偶数，0代表偶数，1代表奇数
        int[] bitNumArr = new int[1<<5];
        //初始化填充为-1，区分00000的情况
        Arrays.fill(bitNumArr,-1);
        //aeiou 都不出现，即bitNumArr[0]
        //即空字符串，字符串下标i=0 
        bitNumArr[0] = 0; 
        //最大子串长度
        int maxSubStrLength = 0;  
        int status = 0;
        for(int i=0;i<length;i++){
            char c = s.charAt(i);
            if(c == 'a'){
                //与1异或，相同为0，不同为1
                status ^= (1<<0);
            }
            else if(c == 'e'){
                 status ^= (1<<1);
            }
            else if(c == 'i'){
                 status ^= (1<<2);
            }
            else if(c == 'o'){
                 status ^= (1<<3);
            }
            else if(c == 'u'){
                 status ^= (1<<4);
            }
            //如果status对应的bitNumArr[status]大于0 说明已经找到符合要求的子串
            //因为两个子串的奇偶性相等，说明中间子串是符合要求的
            //奇偶性相同的两个数的差，必定为偶数 只会有一个偶数00000
            //因此出现两个相同状态的数，他们中间必定出现了偶数次数的aeiou
            if(bitNumArr[status] >= 0){
                maxSubStrLength = Math.max(maxSubStrLength,i+1-bitNumArr[status]);
            }
            else{
                //bitNumArr[status]==-1 说明status是第一次出现，只保存这个值
                bitNumArr[status] = i+1;  //i<length  此处保存的是字符串的长度  所以是i+1 不是i
            }
        }
        return maxSubStrLength;
    }
}
```


在这里需要说明的是，在代码中

```java
if(bitNumArr[status] >= 0){
    maxSubStrLength = Math.max(maxSubStrLength,i+1-bitNumArr[status]);
}
else{
    bitNumArr[status] = i+1;  //i<length  此处保存的是字符串的长度  所以是i+1 不是i
}
```

`bitNumArr[status]` 存储的是 `i+1`，不是 `i`，其原因如下
1. 为了保证第一个字母是辅音字母时也可以输出正确的值
2. 因为如果改为 `bitNumArr[status] = i;` 那相应的 `if` 语句要改为 `maxSubStrLength = max(maxSubStrLength, i - bitNumArr[status]);`，这样当第一个字母为辅音时，`status = 0`, `if` 判为真，`maxSubStrLength` 就会被赋值为 0，这显然不是正确的。
3. 同时题解中是用 `bitNumArr[status]` 是不是等于 -1 来判断前面是否出现过与 status 相同的奇偶性，所以也不能初始化为 `bitNumArr[0] = -1`。就只好多加一个 1。




## 5. 最长回文子串
### Description
* [LeetCode-5. 最长回文子串](https://leetcode-cn.com/problems/longest-palindromic-substring/)

### Approach 1-动态规划

#### Analysis

对于一个子串而言，如果它是回文串，并且长度大于 2，那么将它首尾的两个字母去除之后，它仍然是个回文串。例如对于字符串 `"ababa"`，如果我们已经知道 `"bab"` 是回文串，那么 `"ababa"` 一定是回文串，这是因为它的首尾两个字母都是 `"a"`。

根据这样的思路，我们就可以用动态规划的方法解决本题。我们用 `P(i,j)` 表示字符串 `s` 的第 `i` 到 `j` 个字母组成的串（下文表示成 `s[i:j]`）是否为回文串

```math
P(i,j) = \begin{cases} \text{true,} &\quad\text{如果子串~} S_i \dots S_j \text{~是回文串}\\ \text{false,} &\quad\text{其它情况} \end{cases}
```

这里的「其它情况」包含两种可能性
1. `s[i,j]` 本身不是一个回文串
2. `i > j`，此时 `s[i,j]` 本身不合法

那么我们就可以写出动态规划的状态转移方程

```math
P(i, j) = P(i+1, j-1) \wedge (S_i == S_j)
```

也就是说，只有 `s[i+1:j-1]` 是回文串，并且 `s` 的第 `i` 和 `j` 个字母相同时，`s[i:j]` 才会是回文串。

上文的所有讨论是建立在子串长度大于 2 的前提之上的，我们还需要考虑动态规划中的边界条件，即子串的长度为 `1` 或 `2`。对于长度为 1 的子串，它显然是个回文串；对于长度为 2 的子串，只要它的两个字母相同，它就是一个回文串。因此我们就可以写出动态规划的边界条件

```math
\begin{cases} P(i, i) = \text{true} \\ P(i, i+1) = ( S_i == S_{i+1} ) \end{cases}
```


根据这个思路，我们就可以完成动态规划了，最终的答案即为所有 `P(i,j) = true` 中 `j-i+1`（即子串长度）的最大值。

**注意，在状态转移方程中，我们是从长度较短的字符串向长度较长的字符串进行转移的，因此一定要注意动态规划的循环顺序。**



复杂度分析
1. 时间复杂度：`O(n^2)`，其中 `n` 是字符串的长度。动态规划的状态总数为 `O(n^2)`，对于每个状态，我们需要转移的时间为 `O(1)`。
2. 空间复杂度：`O(n^2)`，即存储动态规划状态需要的空间。




（待后续加深补充）



#### Solution

* C++


```java
class Solution {
public:
    string longestPalindrome(string s) {
        int n = s.size();
        vector<vector<int>> dp(n, vector<int>(n));
        string ans;
        for (int l = 0; l < n; ++l) {
            for (int i = 0; i + l < n; ++i) {
                int j = i + l;
                if (l == 0) {
                    dp[i][j] = 1;
                }
                else if (l == 1) {
                    dp[i][j] = (s[i] == s[j]);
                }
                else {
                    dp[i][j] = (s[i] == s[j] && dp[i + 1][j - 1]);
                }
                if (dp[i][j] && l + 1 > ans.size()) {
                    ans = s.substr(i, l + 1);
                }
            }
        }
        return ans;
    }
};
```

### Approach 2-中心扩展算法

#### Analysis



我们仔细观察一下方法一中的状态转移方程

```math
\begin{cases} P(i, i) &=\quad \text{true} \\ P(i, i+1) &=\quad ( S_i == S_{i+1} ) \\ P(i, j) &=\quad P(i+1, j-1) \wedge (S_i == S_j) \end{cases}
```



找出其中的状态转移链

```math
P(i, j) \leftarrow P(i+1, j-1) \leftarrow P(i+2, j-2) \leftarrow \cdots \leftarrow \text{某一边界情况}
```

**可以发现，所有的状态在转移的时候的可能性都是唯一的。也就是说，我们可以从每一种边界情况开始「扩展」，也可以得出所有的状态对应的答案。**

**边界情况即为子串长度为 1 或 2 的情况。我们枚举每一种边界情况，并从对应的子串开始不断地向两边扩展。如果两边的字母相同，我们就可以继续扩展，例如从 `P(i+1,j-1)` 扩展到 `P(i,j)`；如果两边的字母不同，我们就可以停止扩展，因为在这之后的子串都不能是回文串了。**



聪明的读者此时应该可以发现，**「边界情况」对应的子串实际上就是我们「扩展」出的回文串的「回文中心」。方法二的本质即为：我们枚举所有的「回文中心」并尝试「扩展」，直到无法扩展为止，此时的回文串长度即为此「回文中心」下的最长回文串长度。我们对所有的长度求出最大值，即可得到最终的答案。**


复杂度分析
1. 时间复杂度：`O(n^2)`，其中 `n` 是字符串的长度。长度为 1 和 2 的回文中心分别有 n 和 `n-1` 个，每个回文中心最多会向外扩展 `O(n)` 次。
2. 空间复杂度：`O(1)`。




#### Solution

* Java

```java
class Solution {
    public String longestPalindrome(String s) {
        if (s == null || s.length() < 1) return "";
        int start = 0, end = 0;
        for (int i = 0; i < s.length(); i++) {
            int len1 = expandAroundCenter(s, i, i);
            int len2 = expandAroundCenter(s, i, i + 1);
            int len = Math.max(len1, len2);
            if (len > end - start) {
                start = i - (len - 1) / 2;
                end = i + len / 2;
            }
        }
        return s.substring(start, end + 1);
    }

    private int expandAroundCenter(String s, int left, int right) {
        int L = left, R = right;
        while (L >= 0 && R < s.length() && s.charAt(L) == s.charAt(R)) {
            L--;
            R++;
        }
        return R - L - 1;
    }
}
```


## 207. 课程表
### Description
* [LeetCode-207. 课程表](https://leetcode-cn.com/problems/course-schedule/)

### Approach 1-拓扑排序

#### Analysis

本题的实质问题是判断是否是有向无环图（DAG）（即不能存在环）。

即课程间规定了前置条件，但不能构成任何环路，否则课程前置条件将不成立。

可以使用拓扑排序求解。


思路是通过 **拓扑排序** 判断此课程安排图是否是**有向无环图(DAG)** 。 


具体分析，参考`《数据结构 Notes 2-图》`笔记中的 `拓扑排序` 章节。


#### Solution


```java
class Solution {
    public boolean canFinish(int numCourses, int[][] prerequisites) {
        // 定义一个数组来存储课程的入度
        int[] indegree = new int[numCourses];
        // 定义一个队列用来排序
        Queue<Integer> queue = new LinkedList<>();
        // 初始化所有课程的入度
        for(int [] arr:prerequisites){
            //比如对于[1,0]，表示学习课程1之前，需要先完成课程0
            //因此课程1的入度需要加1 
            indegree[arr[0]]++;
        }
        // 将所有入度为0的课程入队, 然后将入度标记为-1，防止后面重复入队
        for(int i=0;i<indegree.length;i++){
            if(indegree[i] == 0){
                queue.add(i);
                indegree[i] --;
            }
        }
        // 开始出队，每出队一门课，就维护入度数组
        // 然后将所有入度为0的数组入队，然后将入度标记为-1，防止后面重复入队
        while (!queue.isEmpty()) {
            //移除并返问队列头部的元素。如果队列为空，则返回null
            int course = queue.poll();
            for(int[] arr:prerequisites){
                if(arr[1] == course){
                    indegree[arr[0]]--;
                }
            }
            for(int i=0;i<indegree.length;i++){
                if(indegree[i] == 0){
                    queue.add(i);
                    indegree[i] --;
                }
            }
        }
        
        // 遍历indegree中入度为-1的数量，也就是已经完成的课程数
        // 和numCourses一样就返回true，否则返回false
        int res = 0;
        for(int i = 0; i < indegree.length; i++){
            if (indegree[i] == -1){
                res++;
            }
        }
        return res == numCourses ? true : false;        
    }
}
```


### Approach 2-拓扑排序（广度优先）


#### Analysis

1. 统计课程安排图中每个节点的入度，生成 *入度表* `indegrees`。
2. 借助一个队列 `queue`，将所有入度为 0 的节点入队。
3. 当 `queue` 非空时，依次将队首节点出队，在课程安排图中删除此节点 pre
    * 并不是真正从邻接表中删除此节点 `pre`，而是将此节点对应所有邻接节点 `cur` 的入度 −1，即 `indegrees[cur] -= 1`
    * 当入度 `-1` 后邻接节点 `cur` 的入度为 0，说明 `cur` 所有的前驱节点已经被 “删除”，此时将 `cur` 入队
4. 在每次 `pre` 出队时，执行 `numCourses--`
    * 若整个课程安排图是有向无环图（即可以安排），则所有节点一定都入队并出队过，即完成拓扑排序。换个角度说，若课程安排图中存在环，一定有节点的入度始终不为 0
    * 因此，拓扑排序出队次数等于课程个数，返回 `numCourses == 0` 判断课程是否可以成功安排

复杂度分析
1. 时间复杂度 `O(N + M)`： 遍历一个图需要访问所有节点和所有邻边，N 和 M 分别为节点数量和邻边数量
2. 空间复杂度 `O(N + M)`： 为建立邻接表所需额外空间，`adjacency` 长度为 N ，并存储 M 条邻边的数据

参考 `leetcode-cn` 官方题解动画辅助理解。


#### Solution


* Java


```java
class Solution {
    public boolean canFinish(int numCourses, int[][] prerequisites) {
        int[] indegrees = new int[numCourses];
        List<List<Integer>> adjacency = new ArrayList<>();
        Queue<Integer> queue = new LinkedList<>();
        for(int i=0;i<numCourses;i++){
            //邻接表
            adjacency.add(new ArrayList<>());
        }
        // Get the indegree and adjacency of every course.
        for(int[] cp:prerequisites){
            indegrees[cp[0]]++;
            adjacency.get(cp[1]).add(cp[0]);
        }
        // Get all the courses with the indegree of 0.
        for(int i = 0; i < numCourses; i++){
            if(indegrees[i] == 0) {
                queue.add(i);
            }

        }
        // BFS TopSort.
        while(!queue.isEmpty()) {
            int pre = queue.poll();
            numCourses--;
            for(int cur : adjacency.get(pre)){
                if(--indegrees[cur] == 0) {
                    queue.add(cur);
                }
            }
                
        }
        return numCourses == 0;
    }
}
```



### Approach 2-拓扑排序（深度优先）


#### Analysis

1. 借助一个标志列表 `flags`，用于判断每个节点 i （课程）的状态
    * 未被 DFS 访问：`i == 0`
    * 已被其他节点启动的 DFS 访问：`i == -1`
    * 已被当前节点启动的 DFS 访问：`i == 1`
2. 对 `numCourses` 个节点依次执行 DFS，判断每个节点起步 DFS 是否存在环，若存在环直接返回 `False`。

DFS 流程如下
1. 终止条件
    * 当 `flag[i] == -1`，说明当前访问节点已被其他节点启动的 DFS 访问，无需再重复搜索，直接返回 `True`
    * 当 `flag[i] == 1`，说明在本轮 DFS 搜索中节点 i 被第 2 次访问，即课程安排图有环 ，直接返回 `False`
2. 将当前访问节点 i 对应 `flag[i]` 置 1，即标记其被本轮 DFS 访问过
3. 递归访问当前节点 i 的所有邻接节点 j，当发现环直接返回 `False`
4. 当前节点所有邻接节点已被遍历，并没有发现环，则将当前节点 `flag` 置为 `−1` 并返回 `True`
5. 若整个图 DFS 结束并未发现环，返回 `True`


算法复杂度分析
1. 时间复杂度 `O(N + M)`： 遍历一个图需要访问所有节点和所有临边，N 和 M 分别为节点数量和临边数量
2. 空间复杂度 `O(N + M)`： 为建立邻接表所需额外空间，`adjacency` 长度为 N ，并存储 M 条临边的数据



参考 `leetcode-cn` 官方题解动画辅助理解。

（待后续补充）


#### Solution

（待后续补充）


## 70. 爬楼梯

### Description
* [LeetCode-70. 爬楼梯](https://leetcode-cn.com/problems/climbing-stairs/)

### Approach 1-动态规划

#### Analysis


* [ref-1-爬楼梯图解斐波那契数列](https://juejin.cn/post/6993096471792844813)

用 `$f(x)$` 表示爬到第 `x` 级台阶的方案数。

```
x=1时，f(x)=1
    1

x=2时，f(x)=2
    1+1
    2

x=3时，f(x)=3=f(x-1)+f(x-2)
    1+1+1
    1+2
    2+1

x=4时，f(x)=5=f(x-1)+f(x-2)
    -------------
    1+1+1+1      |
    2+1+1        |  
    1+2+1        |   f(3)的方案数，后面再走1步
    1+2+1        |
    -------------
    2+2          |   f(2)的方案数，后面再走2步
    -------------

x=5时，f(x)=8=f(x-1)+f(x-2)
    -------------
    1+1+1+1+1    |
    2+1+1+1      |  
    1+2+1+1      |   f(4)的方案数，后面再走1步
    1+2+1+1      |
    2+2+1        |   
    -------------
    1+1+1+2      |
    1+2+2        |   f(3)的方案数，后面再走1步
    2+1+2        |
    -------------
```

**区分方案最后一步是1步，还是2步，对x=1,2,3,4,5的方案数进行比较，可以发现，考虑最后 1 步可能跨了 1 级台阶，也可能跨了 2 级台阶，有如下表达式**


```math
f(x)=f(x−1)+f(x−2)
```

它意味着爬到第 `x` 级台阶的方案数是爬到第 `x - 1` 级台阶的方案数和爬到第 `x - 2` 级台阶的方案数的和。很好理解，因为每次只能爬 1 级或 2 级，所以 `f(x)` 只能从 `f(x-1)` 和 `f(x-2)` 转移过来，而这里要统计方案总数，我们就需要对这两项的贡献求和。



复杂度分析
* 时间复杂度：循环执行 `n` 次，每次花费常数的时间代价，故渐进时间复杂度为 `O(n)`
* 空间复杂度：`O(n)`



#### Solution

* java


```java
class Solution {
    public int climbStairs(int n) {
        int[] res = new int[n+1];
        //init value
        if(n == 1 || n ==2 ) return n;
  
        res[1] = 1;
        res[2] = 2;
        for(int i=3;i<=n;i++){
            res[i] = res[i-1] + res[i-2];
        }
        return res[n];
    }
}
```



### Approach 2-动态规划+滚动数组


#### Analysis

在 * Approach 1* 的基础上进行优化，可以发现，动态规划求解 `f(x)`，只和前面2项有关，即 `f(x-1)` 和 `f(x-2)`，因此不用创建一个长度为 `n` 的数组去存储全部的计算结果。

使用滚定数组实现，可以将空间复杂度从 `O(n)` 优化至 `O(1)`。





复杂度分析
* 时间复杂度：`O(n)`
* 空间复杂度：`O(1)`

#### Solution


* java

```java
class Solution {
    public int climbStairs(int n) {
        //init value
        if(n == 1 || n ==2 ) return n;
        int res = 0;
        int prev1 = 1;  //f(x-2) 初始值为f(1)
        int prev2 = 2;  //f(x-1) 初始值为f(2)
        for(int i=3;i<=n;i++){
            res = prev1 + prev2;
            prev1 = prev2;
            prev2 = res;
        }
        return res;
    }
}
```


### Approach 3-斐波那契数列+公式求解


#### Analysis


```math
f(x)=f(x−1)+f(x−2)
```

考虑上述动态转移方程，满足斐波那契额，可以直接使用公式求解。对上述动态转移方程求解，可以写出下述特征方程。

```math
x^2=x+1
```


求得 `$x_1 = \frac{1+\sqrt{5}}{2}$`，`$x_2 = \frac{1-\sqrt{5}}{2}$`，设通解为 `$f(n) = c_1 x_1 ^n + c_2 x_2 ^ n$`，代入初始条件 `f(1) = 1`，`f(2) = 1`，得 `$c_1 = \frac{1}{\sqrt{5}}$`，`$c_2 = -\frac{1}{\sqrt{5}}$`，我们得到了这个递推数列的通项公式


```math
f(n) = \frac{1}{\sqrt{5}}\left[ \left(\frac{1+\sqrt{5}}{2}\right)^{n} - \left(\frac{1-\sqrt{5}}{2}\right)^{n} \right]
```

算法复杂度分析
* 时间复杂度：`$O(\log n)$`，`pow` 方法将会用去 `$O(\log n)$` 的时间
* 空间复杂度：`O(1)`



#### Solution 

* java



```java
public class Solution {
    public int climbStairs(int n) {
        double sqrt5 = Math.sqrt(5);
        double fibn = Math.pow((1 + sqrt5) / 2, n + 1) - Math.pow((1 - sqrt5) / 2, n + 1);
        return (int)(fibn / sqrt5);
    }
}
```

### Approach 4-回溯+剪枝

#### Analysis


参考 `leetcode-cn 官方题解`。

注意，此方法会出现超时，此处仅做记录。

#### Solution


```java
class Solution {
    public int climbStairs(int n) {
         List<Integer> list = new ArrayList<>();
        dfs(n,list);

        return list.size();
    }

    private void dfs(int sum,List<Integer> list){
        if(sum < 0){
            return; //终止条件
        }
        if(sum == 0){
            list.add(1);
        }
        if(sum - 1 >= 0){
            dfs(sum-1,list);
        }
        if(sum - 2 >= 0){
            dfs(sum-2,list);
        }
    }
}
```



## 739. 每日温度

### Description
* [LeetCode-739. 每日温度](https://leetcode-cn.com/problems/daily-temperatures/)

### Approach 1-暴力求解-双重for循环

#### Analysis

暴力求解，使用双重 for 循环。
* 外层循环，反向遍历数组，数组最后一个元素对应的值一定是0
* 内层循环，遍历数组，对于第 `i` 个元素，在遇到第一个大于改元素的时候，记录对应的天数，并结束内层循环


算法复杂度分析
* 时间复杂度：`$O(n^2)$`
* 空间复杂度：`O(n)`，创建一个长度为 `n` 的数组，用于存放结果


#### Solution

* java


```java
class Solution {
    public int[] dailyTemperatures(int[] T) {
        int length = T.length;
        int[] res = new int[length];
        res[length-1] = 0;
        int max = 0;
        int day = 0;
        for(int i=length-2;i>=0;i--){
            max = T[i];
            day = 0;
            for(int j=i+1;j<length;j++){
                day++;
                if(T[j] > max){
                    max = T[j];
                    res[i] = day;
                    break;
                }
            }
        }
        return res;
    }
}
```


### Approach 2-单调栈

#### Analysis


参考 `leetcode-cn 官方题解`。



可以维护一个存储下标的单调栈，从栈底到栈顶的下标对应的温度列表中的温度依次递减。如果一个下标在单调栈里，则表示尚未找到下一次温度更高的下标。

正向遍历温度列表。对于温度列表中的每个元素 `T[i]`，如果栈为空，则直接将 `i` 进栈，如果栈不为空，则比较栈顶元素 `prevIndex` 对应的温度 `T[prevIndex]` 和当前温度 `T[i]`，如果 `T[i]` > `T[prevIndex]`，则将 `prevIndex` 移除，并将 `prevIndex` 对应的等待天数赋为 `i - prevIndex`，重复上述操作直到栈为空或者栈顶元素对应的温度小于等于当前温度，然后将 `i` 进栈。


**为什么可以在弹栈的时候更新 `ans[prevIndex]` 呢？因为在这种情况下，即将进栈的 `i` 对应的 `T[i]` 一定是 `T[prevIndex]` 右边第一个比它大的元素**，试想如果 `prevIndex` 和 `i` 有比它大的元素，假设下标为 `j`，那么 `prevIndex` 一定会在下标 `j` 的那一轮被弹掉。

**由于单调栈满足从栈底到栈顶元素对应的温度递减，因此每次有元素进栈时，会将温度更低的元素全部移除，并更新出栈元素对应的等待天数，这样可以确保等待天数一定是最小的。**

以下用一个具体的例子帮助读者理解单调栈。对于温度列表 `[73,74,75,71,69,72,76,73]`，单调栈 `stack` 的初始状态为空，答案 `ans` 的初始状态是 `[0,0,0,0,0,0,0,0]`，按照以下步骤更新单调栈和答案，其中单调栈内的元素都是下标，括号内的数字表示下标在温度列表中对应的温度。

1. 当 `i=0` 时，单调栈为空，因此将 0 进栈。
* `stack=[0(73)]`
* `ans=[0,0,0,0,0,0,0,0]`

2. 当 `i=1` 时，由于 74 大于 73，因此移除栈顶元素 0，赋值 `ans[0]:=1-0`，将 1 进栈
* `stack=[1(74)]`
* `ans=[1,0,0,0,0,0,0,0]`

3. 当 `i=2` 时，由于 75 大于 74，因此移除栈顶元素 1，赋值 `ans[1]:=2-1`，将 2 进栈
* `stack=[2(75)]`
* `ans=[1,1,0,0,0,0,0,0]`

4. 当 `i=3` 时，由于 71 小于 75，因此将 3 进栈
* `stack=[2(75),3(71)]`
* `ans=[1,1,0,0,0,0,0,0]`

5. 当 `i=4` 时，由于 69 小于 71，因此将 4 进栈
* `stack=[2(75),3(71),4(69)]`
* `ans=[1,1,0,0,0,0,0,0]`

6. 当 `i=5` 时，由于 72 大于 69 和 71，因此依次移除栈顶元素 4 和 3，赋值 `ans[4]:=5-4` 和 `ans[3]:=5-3`，将 5 进栈
* `stack=[2(75),5(72)]`
* `ans=[1,1,0,2,1,0,0,0]`

7. 当 `i=6` 时，由于 76 大于 72 和 75，因此依次移除栈顶元素 5 和 2，赋值 `ans[5]:=6-5` 和 `ans[2]:=6-2`，将 6 进栈
* `stack=[6(76)]`
* `ans=[1,1,4,2,1,1,0,0]`

8. 当 `i=7` 时，由于 73 小于 76，因此将 7 进栈
* `stack=[6(76),7(73)]`
* `ans=[1,1,4,2,1,1,0,0]`


算法复杂度分析
* 时间复杂度：`$O(n)$`。**在leetcode-cn平台上测试，方法1中时间复杂度为`$O(n^2)$`，耗时821ms；方法2的时间复杂度是 `O(n)`，耗时为 15ms，优化效果十分明显。**
* 空间复杂度：`O(n)`，需要维护一个单调栈存储温度列表中的下标


#### Solution


```java
class Solution {
    public int[] dailyTemperatures(int[] T) {
        int length = T.length;
        int[] res = new int[length];
        Deque<Integer>  stack =  new LinkedList<Integer>();
        for(int i=0;i<length;i++){
            int temperature = T[i];
            while(!stack.isEmpty() && temperature > T[stack.peek()]){
                int prevIndex = stack.pop();
                res[prevIndex] = i - prevIndex;
            }
            stack.push(i);
        }
        return res;
    }
}
```

