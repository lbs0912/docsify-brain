# LeetCode Notes-043


[TOC]



## 更新
* 2021/07/19，撰写
* 2021/07/22，完成


## Overview
* [LeetCode-1544. 整理字符串](https://leetcode-cn.com/problems/make-the-string-great/description/)
* [LeetCode-1816. 截断句子](https://leetcode-cn.com/problems/truncate-sentence/description/)
* [LeetCode-1832. 判断句子是否为全字母句](https://leetcode-cn.com/problems/check-if-the-sentence-is-pangram/description/)
* [LeetCode-1880. 检查某单词是否等于两单词之和](https://leetcode-cn.com/problems/check-if-word-equals-summation-of-two-words/description/)
* [LeetCode-1897. 重新分配字符使所有字符串都相等](https://leetcode-cn.com/problems/redistribute-characters-to-make-all-strings-equal/description/)



## 1544. 整理字符串
### Description
* [LeetCode-1544. 整理字符串](https://leetcode-cn.com/problems/make-the-string-great/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public String makeGood(String s) {
        if(s.length() < 2){
            return s;
        }
        StringBuilder sb = new StringBuilder();
        int length = s.length();
        for(int index = 0;index<length;index++){
            int sbLength = sb.length();
            if(sbLength > 0 && Character.toLowerCase(s.charAt(index)) == Character.toLowerCase(sb.charAt(sbLength-1)) &&  sb.charAt(sbLength-1) != s.charAt(index)){
                sb.deleteCharAt(sbLength-1);
            } else{
                sb.append(s.charAt(index));
            }
        }

        return sb.toString();
        
    }
}
```




## 1816. 截断句子
### Description
* [LeetCode-1816. 截断句子](https://leetcode-cn.com/problems/truncate-sentence/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution
```java
class Solution {
    public String truncateSentence(String s, int k) {
        String[] arr = s.split(" ");
        StringBuffer sb = new StringBuffer();
        if(k < s.length()){
            for(int i=0;i<k;i++){
                sb.append(arr[i]);
                if(i != k-1){
                    sb.append(" "); //最后一个不要插入空格
                }
            }
            return sb.toString();
        }
        return s;

    }
}
```


### Approach 2-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public String truncateSentence(String s, int k) {
        int count = 0;
        int index = 0;
        while(count < k){
            int tmpIndex = s.indexOf(" ",index+1); //记得加1
            if(tmpIndex != -1){
                count++;
                index = tmpIndex;
            } else {
                return s;
            }
        }
        return s.substring(0, index);

    }
}
```





## 1832. 判断句子是否为全字母句
### Description
* [LeetCode-1832. 判断句子是否为全字母句](https://leetcode-cn.com/problems/check-if-the-sentence-is-pangram/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public boolean checkIfPangram(String sentence) {
        if(sentence.length() < 26){
            return false;
        }
        Set<Character> set = new HashSet<>();
        int index = 0;
        while(index < sentence.length()){
            char c = Character.toLowerCase(sentence.charAt(index));
            set.add(c);
            index++;
        }
        return set.size() == 26;


    }
}
```



## 1880. 检查某单词是否等于两单词之和
### Description
* [LeetCode-1880. 检查某单词是否等于两单词之和](https://leetcode-cn.com/problems/check-if-word-equals-summation-of-two-words/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

【水题】
#### Solution



```java
class Solution {
    public boolean isSumEqual(String firstWord, String secondWord, String targetWord) {

        int firstVal = 0;
        int secondVal = 0;
        int targetVal = 0;
        int index = 0;
        while(index < firstWord.length()){
            firstVal = 10*firstVal + (firstWord.charAt(index)-'a');
            index++;
        }
        index = 0;
        while(index < secondWord.length()){
            secondVal = 10*secondVal + (secondWord.charAt(index)-'a');
            index++;
        }
        index = 0;
        while(index < targetWord.length()){
            targetVal = 10*targetVal + (targetWord.charAt(index)-'a');
            index++;
        }
        return (firstVal + secondVal) ==  targetVal;

    }
}
```




## 1897. 重新分配字符使所有字符串都相等
### Description
* [LeetCode-1897. 重新分配字符使所有字符串都相等](https://leetcode-cn.com/problems/redistribute-characters-to-make-all-strings-equal/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


我们可以**任意**进行移动字符的操作。因此，假设 words 的长度为 n，我们只需要使得每种字符的总出现次数能够被 n 整除，即可以存在一种操作，使得操作后所有字符串均相等。

#### Solution

```java
class Solution {
    public boolean makeEqual(String[] words) {
        
        Map<Character,Integer> map = new HashMap<>();
        int length = words.length;
        for(int i=0;i<length;i++){
            for(int j=0;j<words[i].length();j++){
                char c = words[i].charAt(j);
                map.put(c,1+ map.getOrDefault(c, 0));
            }
        }
        for(Map.Entry<Character,Integer> entry:map.entrySet()){
            if(entry.getValue() % length != 0){
                return false;
            }
        }
        return true;

    }
}
```


