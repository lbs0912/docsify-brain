


# LeetCode Notes-059


[TOC]



## 更新
* 2021/08/08，撰写
* 2021/08/10，撰写


## Overview

* [LeetCode-1619. 删除某些元素后的数组均值](https://leetcode-cn.com/problems/mean-of-array-after-removing-some-elements/description/)
* [LeetCode-1961.检查字符串是否为数组前缀](https://leetcode-cn.com/problems/check-if-string-is-a-prefix-of-array/description/)
* [LeetCode-1957. 删除字符使字符串变好](https://leetcode-cn.com/problems/delete-characters-to-make-fancy-string/description/)
* [LeetCode-1945. 字符串转化后的各位数字之和](https://leetcode-cn.com/problems/sum-of-digits-of-string-after-convert/description/)
* [LeetCode-1941. 检查是否所有字符出现次数相同](https://leetcode-cn.com/problems/check-if-all-characters-have-equal-number-of-occurrences/description/)


## 1619. 删除某些元素后的数组均值
### Description
* [LeetCode-1619. 删除某些元素后的数组均值](https://leetcode-cn.com/problems/mean-of-array-after-removing-some-elements/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public double trimMean(int[] arr) {
        int n = (int) (arr.length*0.05);
        double sum = 0 ;
        Arrays.sort(arr);
        for ( int i = n;i < arr.length - n;i ++){
            sum += arr[i];
        }
        return  (sum / ( arr.length-2*n));
    }
}
```


```java
class Solution {
    public double trimMean(int[] arr) {
        Arrays.sort(arr);
        int len = arr.length;
        int sum = 0;
        for(int i=0;i<len;i++){
            sum += arr[i];
        }
        int removeCount = (int)(len*0.05);
        int removedNum = 0;
        while(removedNum < removeCount){
            sum -= arr[removedNum];
            sum -= arr[len-1-removedNum];
            removedNum++;
        }
        return (double)(1.0 * sum / (len - 2*removeCount)); //注意 若定义sum为int 此处需要1.0 转换为double  也可以直接定义sum为double

    }
}
```






## 1961. 检查字符串是否为数组前缀
### Description
* [LeetCode-1961.检查字符串是否为数组前缀](https://leetcode-cn.com/problems/check-if-string-is-a-prefix-of-array/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public boolean isPrefixString(String s, String[] words) {
        int arrLen = words.length;
        int len = s.length();
        int index = 0;
        for(int i=0;i<arrLen;i++){
            if(index == len){
                return true;
            }
            String str = words[i];
            if(str.length() > (len-index)){
                return false;
            }
            if(!s.substring(index, str.length()+index).equals(str)){
                return false;
            }
            index += str.length();
        }
        return index == len;
    }
}
```




## 1957. 删除字符使字符串变好
### Description
* [LeetCode-1957. 删除字符使字符串变好](https://leetcode-cn.com/problems/delete-characters-to-make-fancy-string/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



```java
class Solution {
    public String makeFancyString(String s) {
        StringBuffer sb = new StringBuffer();
        if(s.length() < 3){
            return s;
        }
        int count = 1;
        sb.append(s.charAt(0));
        for(int i=1;i<s.length();i++){
            if(s.charAt(i) == s.charAt(i-1)){
                if(count == 2){
                    continue;
                }
                sb.append(s.charAt(i));
                count++;
            } else {
                sb.append(s.charAt(i));
                count = 1;
            }
        }
        return sb.toString();

    }
}
```



## 1945. 字符串转化后的各位数字之和
### Description
* [LeetCode-1945. 字符串转化后的各位数字之和](https://leetcode-cn.com/problems/sum-of-digits-of-string-after-convert/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


需要注意的是，
1. `StringBuffer` 或 `StringBuilder` 清空的方法为 `sb.setLength(0)`。
2. 字符 char 隐式转换为int， 会得到对应的ASCII值，例如 `'9' -> 56`。可以使用 `'9' - '0'` 或者 `Character.getNumericValue(char)` 进行转换。
#### Solution


 
```java
class Solution {
    public int getLucky(String s, int k) {
        StringBuffer sb = new StringBuffer();
        int sum  = 0;
        int count = 0;

        for(int i=0;i<s.length();i++){
            sb.append(String.valueOf(s.charAt(i) - 'a' + 1));
        }
        
        while(count < k){
            count++;
         
            for(int i=0;i<sb.length();i++){
                // sum += s.charAt(i) - '0';
                sum += Character.getNumericValue(sb.charAt(i));
            }
            if(count < k){
                sb.setLength(0);
                sb.append(String.valueOf(sum));
                sum = 0;
            }
        }
        return sum;
    }
}
```



## 1941. 检查是否所有字符出现次数相同


### Description
* [LeetCode-1941. 检查是否所有字符出现次数相同](https://leetcode-cn.com/problems/check-if-all-characters-have-equal-number-of-occurrences/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public boolean areOccurrencesEqual(String s) {
        if(s.length() == 1){
            return true;
        }
        Map<Character,Integer> map = new HashMap<>();
        for(int i=0;i<s.length();i++){
            map.put(s.charAt(i),1 + map.getOrDefault(s.charAt(i),0));
        }
        int count = map.get(s.charAt(0));
        for(Map.Entry<Character,Integer> entry:map.entrySet()){
            if(entry.getValue() != count){
                return false;
            }
        }
        return true;
    }
}
```