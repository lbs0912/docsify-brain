
# LeetCode Notes-053


[TOC]



## 更新
* 2021/07/24，撰写
* 2021/07/31，撰写


## Overview
* [LeetCode-1805. 字符串中不同整数的数目](https://leetcode-cn.com/problems/number-of-different-integers-in-a-string/description/)
* [LeetCode-1827. 最少操作使数组递增](https://leetcode-cn.com/problems/minimum-operations-to-make-the-array-increasing/description/)
* [LeetCode-1935. 可以输入的最大单词数](https://leetcode-cn.com/problems/maximum-number-of-words-you-can-type/description/)
* [LeetCode-1743. 从相邻元素对还原数组](https://leetcode-cn.com/problems/restore-the-array-from-adjacent-pairs/)
* [LeetCode-989. 数组形式的整数加法](https://leetcode-cn.com/problems/add-to-array-form-of-integer/description/)



## 1805. 字符串中不同整数的数目
### Description
* [LeetCode-1805. 字符串中不同整数的数目](https://leetcode-cn.com/problems/number-of-different-integers-in-a-string/description/)

### Approach 1-数据溢出+BigInteger
#### Analysis

参考 `leetcode-cn` 官方题解。


注意数据溢出问题，使用 `Integeer` 或者 `Long` 都会数据溢出，在这里使用 `BigInteger`。

在提交时需要手动导入 `import java.math.BigInteger;`。

#### Solution


```java
import java.math.BigInteger;

class Solution {
    public int numDifferentIntegers(String word) {
        int length = word.length();
        int len = 0;
        Set<BigInteger> set = new HashSet<>();
        for(int i=0;i<length;i++){
            char c = word.charAt(i);
            if(!Character.isDigit(c)){
                if(len != 0){
                    String subStr = word.substring(i-len,i);
                    set.add(new BigInteger(subStr));
                    len  = 0;
                }
            } else {
                len++;
            } 
        }
        //注意处理末尾是数字的情况
        if(len > 0){
            String subStr = word.substring(length-len);
            set.add(new BigInteger(subStr));
        }
        return set.size();
    }
}
```


### Approach 2-数据溢出+String
#### Analysis

参考 `leetcode-cn` 官方题解。

为了避免数据溢出问题，使用 String 存储数据结果，注意数字前导0的去除。

#### Solution


```java
class Solution {
    public int numDifferentIntegers(String word) {
        int length = word.length();
        int len = 0;
        Set<String> set = new HashSet<>();
        for(int i=0;i<length;i++){
            char c = word.charAt(i);
            if(!Character.isDigit(c)){
                if(len != 0){
                    String subStr = word.substring(i-len,i);
                    subStr = delPrefixZero(subStr);
                    set.add(subStr);
                    len  = 0;
                }
            } else {
                len++;
            } 
        }
        //注意处理末尾是数字的情况
        if(len > 0){
            String subStr = word.substring(length-len);
            subStr = delPrefixZero(subStr);
            set.add(subStr);
        }
        return set.size();
    }

    private String delPrefixZero(String str){
        if(str.length() <= 1){ //单独一个0
            return str;
        }
        int i = 0;
        while(i < str.length() && str.charAt(i) == '0'){
            i++;
        }
        
        return (i == str.length()) ? "0": str.substring(i); //注意全为0的情况
    }
}
```



## 【水题】1827. 最少操作使数组递增
### Description
* [LeetCode-1827. 最少操作使数组递增](https://leetcode-cn.com/problems/minimum-operations-to-make-the-array-increasing/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution




```java
class Solution {
    public int minOperations(int[] nums) {
        int count = 0;
        for(int i=1;i<nums.length;i++){
            if(nums[i] > nums[i-1]){
                continue;
            } else if(nums[i] == nums[i-1]){
                count++;
                nums[i]++;
            } else{
                count += (nums[i-1] - nums[i]) + 1;
                nums[i] = nums[i-1] + 1;
            }
        }
        return count;

    }
}
```


-------------------------------------






## 1935. 可以输入的最大单词数 
### Description
* [LeetCode-1935. 可以输入的最大单词数](https://leetcode-cn.com/problems/maximum-number-of-words-you-can-type/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int canBeTypedWords(String text, String brokenLetters) {
        int count = 0;
        int len = brokenLetters.length();
        String[] arr = text.split(" ");
        for(int i=0;i<arr.length;i++){
            for(int j=0;j<len;j++){
                if(arr[i].indexOf(brokenLetters.charAt(j)) != -1){
                    count++;
                    break;
                }
            }
            
        }
        return arr.length - count;
    }
}
```



## 1743. 从相邻元素对还原数组
### Description
* [LeetCode-1743. 从相邻元素对还原数组](https://leetcode-cn.com/problems/restore-the-array-from-adjacent-pairs/)


### Approach 1-哈希表
#### Analysis

参考 `leetcode-cn` 官方题解。

**对于一维数组 `nums` 中的元素 `nums[i]`，若其为数组的第一个或最后一个元素，则该元素有且仅有一个元素与其相邻；若其为数组的中间元素，则该元素有且仅有两个元素与其相邻。**

我们可以对每个元素记录与它相邻的元素有哪些，然后依次检查每个元素的相邻元素数量，即可找到原数组的第一个元素和最后一个元素。

#### Solution


```java
class Solution {
    public int[] restoreArray(int[][] adjacentPairs) {
        //哈希表  key为元素  value为该元素相邻的元素  
        //边界元素的list长度为1 中间元素的list长度为2
        Map<Integer,List<Integer>> map = new HashMap<>();
        for(int[] adjacentPair : adjacentPairs){
            map.putIfAbsent(adjacentPair[0],new ArrayList<Integer>());
            map.putIfAbsent(adjacentPair[1],new ArrayList<Integer>());
            map.get(adjacentPair[0]).add(adjacentPair[1]);
            map.get(adjacentPair[1]).add(adjacentPair[0]);
        }

        //寻找数组的边界
        int n = adjacentPairs.length + 1;
        int[] ret = new int[n];
        for(Map.Entry<Integer,List<Integer>> entry : map.entrySet()){
            List<Integer> adj = entry.getValue();
            if(adj.size() == 1){ //边界元素只有1个元素和它相邻
                ret[0] = entry.getKey();
                ret[1]  = adj.get(0);
                break;
            }
        }

        for(int i=2;i<n;i++){
            List<Integer> adj = map.get(ret[i-1]);
            ret[i] = ret[i-2] == adj.get(0)? adj.get(1):adj.get(0);
        }

        return ret;
    }
}
```






## 989. 数组形式的整数加法
### Description
* [LeetCode-989. 数组形式的整数加法](https://leetcode-cn.com/problems/add-to-array-form-of-integer/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public List<Integer> addToArrayForm(int[] num, int k) {
        int length = num.length;
        if(k == 0){
            return Arrays.stream(num).boxed().collect(Collectors.toList());
        }
        List<Integer> list = new ArrayList<>();
        int carry = 0; //进位值
        int index = length-1;
        int val;
        while(k>0 || index >=0){
            if(index >= 0){
                val = carry + num[index] + k%10;
            } else{
                val = carry + k%10;
            }
            // list.add(0,(carry + num[index] + val)%10);  //注 也可以采用此语法  省去后续翻转数组
            list.add(val%10);
            carry = val/10;
            index--;
            k = k/10;
        }
        if(carry > 0){ //注意处理最高位的进位
            list.add(carry);
        }
        Collections.reverse(list);
        return list;
    }
}
```


