
# LeetCode Notes-061


[TOC]



## 更新
* 2021/08/15，撰写
* 2021/08/16，撰写



## Overview

* [LeetCode-1636. 按照频率将数组升序排序](https://leetcode-cn.com/problems/sort-array-by-increasing-frequency/description/)
* [LeetCode-1640. 能否连接形成数组](https://leetcode-cn.com/problems/check-array-formation-through-concatenation/description/)
* [LeetCode-139. 单词拆分](https://leetcode-cn.com/problems/word-break/description/)
* [LeetCode-140. 单词拆分 II](https://leetcode-cn.com/problems/word-break-ii/description/)
* [LeetCode-561. 数组拆分 I](https://leetcode-cn.com/problems/array-partition-i/description/)




## 1636. 按照频率将数组升序排序
### Description
* [LeetCode-1636. 按照频率将数组升序排序](https://leetcode-cn.com/problems/sort-array-by-increasing-frequency/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

考虑数组的取值范围

```s
1 <= nums.length <= 100
-100 <= nums[i] <= 100
```

数值 `nums[i]` 的取值种类共有 201 种，因此可以创建一个长度为 201 的数组，记作 `cnts[201]`。为了表示负数，将整体数值加上100，即

```s
 val      cnts[i]中的索引值i
-100   ->       0
0      ->       100
100    ->       200
```

计算出数值的出现频率并存储在 `cnts[201]` 后，下面考虑使用 `nums[i]` 同时存储数组的值和数值出现的频率。

因为数值出现频率最大为100，即占用了3个位数。因此可以考虑使用 `nums[i]` 的低3位存储数组的值，使用高3位存储数值出现的频率。即

```s
nums[i] = 1000 * cnts[nums[i] + 100] + nums[i];
```

继续，考虑题目中的 *「如果有多个值的频率相同，请你按照数值本身将它们 降序 排序。」*，**可以对数值 `nums[i]` 映射为 `100 - nums[i]`，这样出现频率相同的时候，将数组排序后，数值大的就会先被遍历到。**
 

```s
nums[i] = 1000 * cnts[nums[i] + 100] + (100-nums[i]);
```

#### Solution


```java
class Solution {
    public int[] frequencySort(int[] nums) {
        int[] cnts = new int[201];
        for (int n : nums){
            cnts[n + 100] ++;
        }
        for (int i = 0; i < nums.length; i ++){
            nums[i] = 1000 * cnts[nums[i] + 100] + (100 - nums[i]);
        }
        Arrays.sort(nums);

        for (int i = 0; i < nums.length; i ++){
            nums[i] = 100 - nums[i] % 1000 ;
        }

        return nums;
    }
}
```


## 1640. 能否连接形成数组
### Description
* [LeetCode-1640. 能否连接形成数组](https://leetcode-cn.com/problems/check-array-formation-through-concatenation/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public boolean canFormArray(int[] arr, int[][] pieces) {
        HashMap<Integer,int[]> map = new HashMap<>();
        for(int[] piece:pieces){
            map.put(piece[0],piece);
        }
        for(int i=0;i<arr.length;){
            int curVal = arr[i];
            if(map.containsKey(curVal)){
                int[] piece = map.get(curVal);
                for(int x : piece){
                    if(arr[i] == x){
                        i++;
                    }else{
                        return false;
                    }
                }
            } else {
                return false;
            }
        }
        return true;
    }
}
```




## 【经典好题】139. 单词拆分  
### Description
* [LeetCode-139. 单词拆分](https://leetcode-cn.com/problems/word-break/description/)

### Approach 1-遍历-算法错误
#### Analysis

参考 `leetcode-cn` 官方题解。


遍历求解，该算法是错误。此处分析错误原因。

```s
s = "aaaaaaa"
wordDict = ["aaaa","aaa"]
```


如上测试用例，字符串 s 为 7 个 "a" 组成。在代码中遍历 Set 时候，由于 Set 本身无序列
* 可能会匹配到 aaa + aaa + a，此时结果为 false
* 可能会匹配到 aaa + aaaa，则此时结果为 true

#### Solution


```java
class Solution {
    public boolean wordBreak(String s, List<String> wordDict) {
        Set<String> set  = new HashSet<>(wordDict);
        int len = s.length();
        int index = 0;
    

        while(index < len){
            boolean hasFind = false;
            for(String str:set){
                if(hasFind){
                    break;
                }
                int tempIndex = s.indexOf(str,index);
                if(-1 != tempIndex){
                    index = s.indexOf(str,index) + str.length();
                   hasFind = true;
                }
            }
            //for循环后 若还未找到 返回false 退出循环 否则会死循环
            if(!hasFind){
                return false;
            }
        }
       
        return true;
    }
}
```


### Approach 2-动态规划
#### Analysis

参考 `leetcode-cn` 官方题解。

仔细理解动态规划的思路。


#### Solution


```java
public class Solution {
    public boolean wordBreak(String s, List<String> wordDict) {
        Set<String> wordDictSet = new HashSet<>(wordDict);
        boolean[] dp  = new boolean[s.length() + 1];  //dp[i] 表示字符串 s[0,i-1] 是否满足条件
        dp[0] = true; //边界条件

        for(int i=1;i<=s.length();i++){
            for(int j=0;j<i;j++){
                if(dp[j] && wordDictSet.contains(s.substring(j,i))) {
                    dp[i] = true;
                    break;
                }
            }
        }
        return dp[s.length()];
    }
}
```

## 【经典好题-hard】140. 单词拆分 II
### Description
* [LeetCode-140. 单词拆分 II](https://leetcode-cn.com/problems/word-break-ii/description/)

### Approach 1-回溯+剪枝
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    Map<Character, Set<String>> map = new HashMap<>();
    List<String> result = new LinkedList<>();
    public List<String> wordBreak(String s, List<String> wordDict) {
        // 将单词按首字母划分存储
        for(String word: wordDict) {
            char header = word.charAt(0);
            if(map.containsKey(header)) {
                map.get(header).add(word);
            } else {
                Set<String> set = new HashSet<>();
                set.add(word);
                map.put(header, set);
            }
        }
        backtrack(-1, 1, new StringBuilder(s));
        return result;
    }
    
    //回溯+剪枝
    public void backtrack(int prev, int pos, StringBuilder sb) {
        for(int i = pos; i <= sb.length(); i++) {
            String str = sb.substring(prev+1, i);
            char h = str.charAt(0);
            // 如果有这个单词
            if(map.containsKey(h) && map.get(h).contains(str)) {
                // 已经读取完了，加入到结果中，返回
                if(i == sb.length()) {
                    result.add(sb.toString());
                    return;
                }
                // 分隔单词，继续遍历
                sb.insert(i, " ");
                backtrack(i, i+2, sb); // 因为加了一个空格，所以需要+2
                sb.deleteCharAt(i);
            }
        }
    }
}

```


## 561. 数组拆分 I
### Description
* [LeetCode-561. 数组拆分 I](https://leetcode-cn.com/problems/array-partition-i/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int arrayPairSum(int[] nums) {
        Arrays.sort(nums);
        int sum = 0;
        for(int i=0;i<nums.length;i += 2){
            sum += nums[i];
        }
        return sum;
    }
}
```




