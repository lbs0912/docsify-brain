



# LeetCode Notes-067


[TOC]



## 更新
* 2021/09/06，撰写
* 2021/11/15，完成



## Overview
* 【水题】[LeetCode-1299. 将每个元素替换为右侧最大元素](https://leetcode-cn.com/problems/replace-elements-with-greatest-element-on-right-side/)
* 【水题】[LeetCode-2000. 反转单词前缀](https://leetcode-cn.com/problems/reverse-prefix-of-word/description/)
* [LeetCode-2006. 差的绝对值为 K 的数对数目](https://leetcode-cn.com/problems/count-number-of-pairs-with-absolute-difference-k/description/)
* [LeetCode-423. 从英文中重建数字](https://leetcode-cn.com/problems/reconstruct-original-digits-from-english/description/)
* [LeetCode-424. 替换后的最长重复字符](https://leetcode-cn.com/problems/longest-repeating-character-replacement/description/)







## 【水题】1299. 将每个元素替换为右侧最大元素
### Description
* 【水题】[LeetCode-1299. 将每个元素替换为右侧最大元素](https://leetcode-cn.com/problems/replace-elements-with-greatest-element-on-right-side/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int[] replaceElements(int[] arr) {
        int length = arr.length;
        int[] res = new int[length];
        int preMax = arr[length-1];
        int tmp = preMax;
        res[length-1] = -1;
        for(int i=length-2;i>=0;i--){
            tmp = arr[i];
            res[i] = preMax;
            preMax = Math.max(preMax,tmp);
        }
        return res;

    }
}
```





## 【水题】2000. 反转单词前缀
### Description
* 【水题】[LeetCode-2000. 反转单词前缀](https://leetcode-cn.com/problems/reverse-prefix-of-word/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public String reversePrefix(String word, char ch) {
        int index = word.indexOf(ch);
        return (-1 == index) ? word:new StringBuffer(word.substring(0, index+1)).reverse().append(word.substring(index+1)).toString();
    }
}
```




## 2006. 差的绝对值为 K 的数对数目
### Description
* [LeetCode-2006. 差的绝对值为 K 的数对数目](https://leetcode-cn.com/problems/count-number-of-pairs-with-absolute-difference-k/description/)

### Approach 1-暴力O(n^2)
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int countKDifference(int[] nums, int k) {
        Arrays.sort(nums);
        int sum = 0;
        int size = nums.length;
        for(int i=0;i<size-1;i++){
            for(int j=i+1;j<size;j++){
                if(nums[j] - nums[i] == k){
                    sum++;
                }
            }
        }

        return sum;

    }
}
```


### Approach 2-O(n^2)
#### Analysis

参考 `leetcode-cn` 官方题解。


题目限制了 `1 <= nums[i] <= 100`，因此
* 可以创建一个长度为100的数组，存储对应元素出现的次数。
* 最后根据入参 `k` 计算出对数 `hole[i]*hole[i+k]`。
* 此方法可以将复杂度优化至 `O(n^2)`。

#### Solution


```java
class Solution {
    public int countKDifference(int[] nums, int k) {
        int[] hole = new int[101];
        for(int i=0;i<nums.length;i++){
            hole[nums[i]] += 1;
        }
        //O(n)
        int res = 0;
        for(int i=1;i+k<101;i++){
            res += hole[i]*hole[i+k];
        }
        return res;

    }
}
```






## 423. 从英文中重建数字
### Description
* [LeetCode-423. 从英文中重建数字](https://leetcode-cn.com/problems/reconstruct-original-digits-from-english/description/)

### Approach 1-哈希表
#### Analysis

参考 `leetcode-cn` 官方题解，对字母可能出现在哪个数字进行分析。



#### Solution

```java
class Solution {
    public String originalDigits(String s) {
      // building hashmap letter -> its frequency
      char[] count = new char[26 + (int)'a'];
      for(char letter: s.toCharArray()) {
        count[letter]++;
      }
  
      // building hashmap digit -> its frequency
      int[] out = new int[10];
      // letter "z" is present only in "zero"
      out[0] = count['z'];
      // letter "w" is present only in "two"
      out[2] = count['w'];
      // letter "u" is present only in "four"
      out[4] = count['u'];
      // letter "x" is present only in "six"
      out[6] = count['x'];
      // letter "g" is present only in "eight"
      out[8] = count['g'];
      // letter "h" is present only in "three" and "eight"
      out[3] = count['h'] - out[8];
      // letter "f" is present only in "five" and "four"
      out[5] = count['f'] - out[4];
      // letter "s" is present only in "seven" and "six"
      out[7] = count['s'] - out[6];
      // letter "i" is present in "nine", "five", "six", and "eight"
      out[9] = count['i'] - out[5] - out[6] - out[8];
      // letter "n" is present in "one", "nine", and "seven"
      out[1] = count['n'] - out[7] - 2 * out[9];
  
      // building output string
      StringBuilder output = new StringBuilder();
      for(int i = 0; i < 10; i++)
        for (int j = 0; j < out[i]; j++)
          output.append(i);
      return output.toString();
    }
  }
```


## 【经典好题】424. 替换后的最长重复字符
### Description
* [LeetCode-424. 替换后的最长重复字符](https://leetcode-cn.com/problems/longest-repeating-character-replacement/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

* ref-[题解参考](https://leetcode-cn.com/problems/longest-repeating-character-replacement/solution/tong-guo-ci-ti-liao-jie-yi-xia-shi-yao-shi-hua-don/)



**仔细阅读上述题解，学习滑动窗口的解决思路。**


**本题可以先退化成考虑 `K=0` 的情况，此时题目就变成了求解字符串中最长连续子串长度问题了。**

#### Solution


```java
class Solution {
    private int[] map = new int[26];

    public int characterReplacement(String s, int k) {
        if (s == null) {
            return 0;
        }
        char[] chars = s.toCharArray();
        int left = 0;
        int right = 0;
        int historyCharMax = 0;
        for (right = 0; right < chars.length; right++) {
            int index = chars[right] - 'A';
            map[index]++;
            historyCharMax = Math.max(historyCharMax, map[index]);
            if (right - left + 1 > historyCharMax + k) {
                map[chars[left] - 'A']--;
                left++;
            }
        }
        return chars.length - left;
    }
}
```




