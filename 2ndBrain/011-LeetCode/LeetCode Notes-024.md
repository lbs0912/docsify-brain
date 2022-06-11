
# LeetCode Notes-024


[TOC]



## 更新
* 2021/03/09，撰写
* 2021/03/09，完成


## Overview
* [LeetCode-1534. 统计好三元组](https://leetcode-cn.com/problems/count-good-triplets/)
* [LeetCode-118. 杨辉三角](https://leetcode-cn.com/problems/pascals-triangle/)
* [LeetCode-1572. 矩阵对角线元素的和](https://leetcode-cn.com/problems/matrix-diagonal-sum/)
* [LeetCode-1684. 统计一致字符串的数目](https://leetcode-cn.com/problems/count-the-number-of-consistent-strings/)
* [LeetCode-1047. 删除字符串中的所有相邻重复项](https://leetcode-cn.com/problems/remove-all-adjacent-duplicates-in-string/)





## 1534. 统计好三元组
### Description
* [LeetCode-1534. 统计好三元组](https://leetcode-cn.com/problems/count-good-triplets/)

### Approach 1-O(n^3)
#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(n^3)`。
* 空间复杂度：`O(1)`。



#### Solution


```java
class Solution {
    public int countGoodTriplets(int[] arr, int a, int b, int c) {
        int length = arr.length;
        int sum = 0;
        for(int i=0;i<length;i++){
            for(int j=i+1;j<length;j++){
                for(int k=j+1;k<length;k++){
                    if (Math.abs(arr[i] - arr[j]) <= a && Math.abs(arr[j] - arr[k]) <= b && Math.abs(arr[i] - arr[k]) <= c) {
                        ++sum;
                    }
                }
            }
        }
        return sum;
    }
}
```



### Approach 2-枚举优化
#### Analysis

参考 `leetcode-cn` 官方题解。



我们考虑 `O(n^2)` 枚举满足 `$|\rm arr[j]-\rm arr[k]|\le b∣$` 的二元组 `(j,k)`，统计这个二元组下有多少 `i` 满足条件。由题目已知 `i` 的限制条件为 `$|\rm arr[i]-\rm arr[j]|\le a \ \&\&\ |\rm arr[i]-\rm arr[k]|\le c∣$`，我们可以拆开绝对值，得到符合条件的值一定是 `$[\rm arr[j]-a,\rm arr[j]+a]$` 和 `$[\rm arr[k]-c,\rm arr[k]+c]$` 两个区间的交集，我们记为 `[l,r]`。因此，在枚举 `(j,k)` 这个二元组的时候，我们只需要快速统计出满足 `i<j` 且 `$\rm arr[i]$` 的值域范围在 `[l,r]` 的 `i` 的个数即可。



复杂度分析
* 时间复杂度：`O(n^2+nS)`，其中 n 是数组的长度，`S` 为数组的值域上限，这里为 1000。
* 空间复杂度：`O(S)`。我们需要 `O(S)` 的空间维护 `arr[i]` 频次数组的前缀和。


#### Solution


```java
class Solution {
    public int countGoodTriplets(int[] arr, int a, int b, int c) {
        int ans = 0, n = arr.length;
        int[] sum = new int[1001];
        for (int j = 0; j < n; ++j) {
            for (int k = j + 1 ; k < n; ++k) {
                if (Math.abs(arr[j] - arr[k]) <= b) {
                    int lj = arr[j] - a, rj = arr[j] + a;
                    int lk = arr[k] - c, rk = arr[k] + c;
                    int l = Math.max(0, Math.max(lj, lk)), r = Math.min(1000, Math.min(rj, rk));
                    if (l <= r) {
                        if (l == 0) {
                            ans += sum[r];
                        }
                        else {
                            ans += sum[r] - sum[l - 1];
                        }
                    }
                }
            }
            for (int k = arr[j]; k <= 1000; ++k) {
                ++sum[k];
            }
        }
        return ans;
    }
}
```



## 118. 杨辉三角
### Description
* [LeetCode-118. 杨辉三角](https://leetcode-cn.com/problems/pascals-triangle/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(numRows^2)`。
* 空间复杂度：`O(1)`。不考虑返回值的空间占用。


#### Solution



```java
class Solution {
    public List<List<Integer>> generate(int numRows) {
        List<List<Integer>> ret = new ArrayList<List<Integer>>();
        for (int i = 0; i < numRows; ++i) {
            List<Integer> row = new ArrayList<Integer>();
            for (int j = 0; j <= i; ++j) {
                if (j == 0 || j == i) {
                    row.add(1);
                } else {
                    row.add(ret.get(i - 1).get(j - 1) + ret.get(i - 1).get(j));
                }
            }
            ret.add(row);
        }
        return ret;
    }
}
```



## 1572. 矩阵对角线元素的和
### Description
* [LeetCode-1572. 矩阵对角线元素的和](https://leetcode-cn.com/problems/matrix-diagonal-sum/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(n)`。
* 空间复杂度：`O(1)`。

#### Solution


```java
class Solution {
    public int diagonalSum(int[][] mat) {
        int rows = mat.length;
        int sum = 0;
        for(int i=0;i<rows;i++){
            sum += mat[i][i];
        }
        for(int i=0,j=rows-1;i<rows;i++,j--){
            if(i == j){
                continue;
            }
            sum += mat[i][j];
        }
        return sum;

    }
}
```


## 1684. 统计一致字符串的数目
### Description
* [LeetCode-1684. 统计一致字符串的数目](https://leetcode-cn.com/problems/count-the-number-of-consistent-strings/)

### Approach 1-两重循环
#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(n^2)`。
* 空间复杂度：`O(1)`。

#### Solution


```java

class Solution {
    public int countConsistentStrings(String allowed, String[] words) {
        int result = words.length;
        for (int i = 0; i < words.length; i++) {
            for (int j = 0; j < words[i].length(); j++) {
                if (!allowed.contains(String.valueOf(words[i].charAt(j)))) {
                    result--;
                    break;
                }
            }
        }
        return result;
    }
}
```

### Approach 2-状态压缩（位运算）
#### Analysis

参考 `leetcode-cn` 官方题解。


由于 `allowed` 字符都是不相同的，那么可以取一个 `int` 类型整数的后 26 位作为标记，比如如果 `allowed = "ac"`，那么可以转为一个数：`00....000101` (26位），最低位 1 表示 `'a'` ，另一个 1 表示 `'c'` ，这样就可以表示一个字符都不相同的字符串 `allowed` 了，它具有字符 `(char)(0 + 'a')` 以及 `(char)(2 + 'a')`，将 `allowed` 对应的数称为 `ans`。

那么将 `words` 里的字符串都这样处理，都会获得一个对应的数 `res`。
当求得一个字符串 `word` 中的所有字符都出现于 `allowed` 时，就相当于 `word` 所对应的数 `res` 二进制位为 1 的那些位，在 `ans` 上这些位也都为 1。



#### Solution

```java
class Solution {
    public int countConsistentStrings(String allowed, String[] words) {
        int ans = solve(allowed);
        int total = 0;
        for (String word : words) {
            int res = solve(word);
            if((res & ans) == res){
                total ++;
            }
        }
        return total;
    }

    public int solve(String s) {
        int ans = 0;
        for(int i = 0; i < s.length(); i++) {
            int x = s.charAt(i) - 'a';
            ans |= (1 << x);
        }
        return ans;
    }
}
```


## 1047. 删除字符串中的所有相邻重复项
### Description
* [LeetCode-1047. 删除字符串中的所有相邻重复项](https://leetcode-cn.com/problems/remove-all-adjacent-duplicates-in-string/)

### Approach 1-栈
#### Analysis

参考 `leetcode-cn` 官方题解。



复杂度分析
* 时间复杂度：`O(n)`，其中 n 是字符串的长度。我们只需要遍历该字符串一次。
* 空间复杂度：`O(n)` 或 `O(1)`，取决于使用的语言提供的字符串类是否提供了类似「入栈」和「出栈」的接口。注意返回值不计入空间复杂度。



#### Solution



```java
class Solution {
    public String removeDuplicates(String S) {
        int length = S.length();
        Deque<Character> stack = new LinkedList<>();
        for(int i=0;i<length;i++){
            if(!stack.isEmpty() && (stack.peek() == S.charAt(i))){
                stack.pop();
            } else {
                stack.addFirst(S.charAt(i));
            }
        }
        StringBuilder sb = new StringBuilder();
        while(!stack.isEmpty()){
            sb.append(stack.pop());
        }
        return sb.reverse().toString(); //对stringbuilder取反
    }
}
```


下面给出一个官方优化版本，使用 `deleteCharAt()` 进行优化。



```java
class Solution {
    public String removeDuplicates(String S) {
        StringBuffer stack = new StringBuffer();
        int top = -1;
        for (int i = 0; i < S.length(); ++i) {
            char ch = S.charAt(i);
            if (top >= 0 && stack.charAt(top) == ch) {
                stack.deleteCharAt(top);
                --top;
            } else {
                stack.append(ch);
                ++top;
            }
        }
        return stack.toString();
    }
}
```