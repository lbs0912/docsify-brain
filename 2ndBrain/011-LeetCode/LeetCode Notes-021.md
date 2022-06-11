
# LeetCode Notes-021


[TOC]



## 更新
* 2021/03/03，撰写
* 2021/03/03，完成


## Overview
* [LeetCode-509. 斐波那契数](https://leetcode-cn.com/problems/fibonacci-number/description/)
* [LeetCode-1768. 交替合并字符串](https://leetcode-cn.com/problems/merge-strings-alternately/)
* [LeetCode-1370. 上升下降字符串](https://leetcode-cn.com/problems/increasing-decreasing-string/)
* [LeetCode-557. 反转字符串中的单词 III](https://leetcode-cn.com/problems/reverse-words-in-a-string-iii/)
* [LeetCode-541. 反转字符串 II](https://leetcode-cn.com/problems/reverse-string-ii/)





## 509. 斐波那契数
### Description
* [LeetCode-509. 斐波那契数](https://leetcode-cn.com/problems/fibonacci-number/description/)

### Approach 1-迭代
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(n)`
* 空间复杂度：`O(n)`

#### Solution

```java
class Solution {
    public int fib(int n) {
        if(n < 2){
            return  (n == 1)? 1:0;
        }
        return fib(n-1) + fib(n-2);
    }
}
```


### Approach 2-滚动数组优化
#### Analysis

参考 `leetcode-cn` 官方题解。


根据状态转移方程和边界条件，可以得到时间复杂度和空间复杂度都是 `O(n)` 的实现。由于 `F(n)` 只和 `F(n-1)` 与 `F(n-2)` 有关，因此可以使用 **「滚动数组思想」** 把空间复杂度优化成 `O(1)`。


复杂度分析
* 时间复杂度：`O(n)`
* 空间复杂度：`O(1)`

#### Solution

```java
class Solution {
    public int fib(int n) {
        if (n < 2) {
            return n;
        }
        int fp = 0;
        int fq = 1;
        int res = fp + fq;
        int p = 0, q = 0, r = 1;
        for (int i = 2; i <= n; i++) {
            res = fp + fq;
            fp = fq;
            fq = res;
        }
        return res;
    }
}
```


## 1768. 交替合并字符串
### Description
* [LeetCode-1768. 交替合并字符串](https://leetcode-cn.com/problems/merge-strings-alternately/)

### Approach 1-双指针
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(n)`
* 空间复杂度：`O(n)`

#### Solution


```java
class Solution {
    public String mergeAlternately(String word1, String word2) {
        int index1 = 0;
        int index2 = 0;
        int length1 = word1.length();
        int length2 = word2.length();
        StringBuilder sb = new StringBuilder();
        while(index1 < length1 && index2 < length2){
            sb.append(word1.charAt(index1++));
            sb.append(word2.charAt(index2++));
        }
        while(index1 < length1){
            sb.append(word1.charAt(index1++));
        }
        while(index2 < length2){
            sb.append(word2.charAt(index2++));
        }
        return sb.toString();

    }
}
```



## 1370. 上升下降字符串
### Description
* [LeetCode-1370. 上升下降字符串](https://leetcode-cn.com/problems/increasing-decreasing-string/)

### Approach 1-桶计数
#### Analysis

参考 `leetcode-cn` 官方题解。


**注意到在构造结果时，我们只关注字符本身，而不关注字符在原字符串中的位置。** 因此我们可以直接创建一个大小为 26 的桶，记录每种字符的数量。每次提取最长的上升或下降字符串时，我们直接顺序或逆序遍历这个桶。

具体地，在遍历桶的过程中，如果当前桶的计数值不为零，那么将当前桶对应的字符加入到答案中，并将当前桶的计数值减一即可。我们重复这一过程，直到答案字符串的长度与传入的字符串的长度相等。


复杂度分析
* 时间复杂度：`$O(|\Sigma|\times|s|)$`，其中 `$\Sigma$` 为字符集，`s` 为传入的字符串。在这道题中，字符集为全部小写字母，`$|\Sigma|=26$`。最坏情况下字符串中所有字符都相同，那么对于每一个字符，我们需要遍历一次整个桶。
* 空间复杂度：`$O(|\Sigma|)$`，其中 `$\Sigma$` 为字符集。我们需要和 `$|\Sigma|$` 等大的桶来记录每一类字符的数量。



#### Solution

```java
class Solution {
    public String sortString(String s) {
        int[] num = new int[26];
        for (int i = 0; i < s.length(); i++) {
            num[s.charAt(i) - 'a']++;
        }

        StringBuffer ret = new StringBuffer();
        while (ret.length() < s.length()) {
            //升序
            for (int i = 0; i < 26; i++) {
                if (num[i] > 0) {
                    ret.append((char) (i + 'a'));
                    num[i]--;
                }
            }
            //降序
            for (int i = 25; i >= 0; i--) {
                if (num[i] > 0) {
                    ret.append((char) (i + 'a'));
                    num[i]--;
                }
            }
        }
        return ret.toString();
    }
}
```


## 557. 反转字符串中的单词 III
### Description
* [LeetCode-557. 反转字符串中的单词 III](https://leetcode-cn.com/problems/reverse-words-in-a-string-iii/)



### Approach 1-使用额外空间
#### Analysis

参考 `leetcode-cn` 官方题解。


开辟一个新字符串。然后从头到尾遍历原字符串，直到找到空格为止，此时找到了一个单词，并能得到单词的起止位置。随后，根据单词的起止位置，可以将该单词逆序放到新字符串当中。如此循环多次，直到遍历完原字符串，就能得到翻转后的结果。





复杂度分析
* 时间复杂度：`O(N)`
* 空间复杂度：`O(N)`



#### Solution


```java
class Solution {
    public String reverseWords(String s) {
        StringBuilder sb = new StringBuilder();
        int length = s.length();
        int index = 0;
        while(index < length){
            int start = index;
            //计算出一个单词的的索引区间
            while(index < length && s.charAt(index)  != ' '){
                index++;
            }
            //字符串翻转
            //注意  end = index - 1 要减去1（最后一次while循环后 会执行一次index++）
            for(int end = index - 1; end >= start; end--){
                sb.append(s.charAt(end));
            }
            //插入空格
            while(index < length && s.charAt(index) == ' '){
                index++;
                sb.append(' ');
            }
        }
        return sb.toString();
    }
}
```



### Approach 2-原地解法
#### Analysis

参考 `leetcode-cn` 官方题解。


此题也可以直接在原字符串上进行操作，避免额外的空间开销。当找到一个单词的时候，我们交换字符串第一个字符与倒数第一个字符，随后交换第二个字符与倒数第二个字符……如此反复，就可以在原空间上翻转单词。

需要注意的是，原地解法在某些语言（比如 Java，JavaScript）中不适用，因为在这些语言中 String 类型是一个不可变的类型。



复杂度分析
* 时间复杂度：`O(N)`
* 空间复杂度：`O(1)`



#### Solution


此处给出 C++ 版本的实现，Java 中不适用。


* C++

```cpp
class Solution {
public: 
    string reverseWords(string s) {
        int length = s.length();
        int i = 0;
        while (i < length) {
            int start = i;
            while (i < length && s[i] != ' ') {
                i++;
            }

            int left = start, right = i - 1;
            while (left < right) {
                swap(s[left], s[right]);
                left++;
                right--;
            }
            while (i < length && s[i] == ' ') {
                i++;
            }
        }
        return s;
    }
};
```


## 541. 反转字符串 II
### Description
* [LeetCode-541. 反转字符串 II](https://leetcode-cn.com/problems/reverse-string-ii/)

> 相似题目: [LeetCode-344. 反转字符串](https://leetcode-cn.com/problems/reverse-string/description/) - 双指针求解



### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(N)`
* 空间复杂度：`O(N)`



#### Solution

```java
class Solution {
    public String reverseStr(String s, int k) {
        char[] a = s.toCharArray();
        for(int start = 0; start < a.length; start += 2 * k){
            int i = start;
            int j = Math.min(start + k - 1, a.length - 1);
            while(i < j){
                char tmp = a[i];
                a[i++] = a[j];
                a[j--] = tmp;
            }
        }
        return new String(a);
    }
}
```

