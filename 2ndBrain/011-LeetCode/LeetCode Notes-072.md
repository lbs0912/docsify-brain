
# LeetCode Notes-072


[TOC]



## 更新
* 2021/12/12，撰写
* 2021/12/13，完成



## Overview
* [LeetCode-2062. 统计字符串中的元音子字符串](https://leetcode-cn.com/problems/count-vowel-substrings-of-a-string/description/)
* [LeetCode-2068. 检查两个字符串是否几乎相等](https://leetcode-cn.com/problems/check-whether-two-strings-are-almost-equivalent/description/)
* [LeetCode-2042. 检查句子中的数字是否递增](https://leetcode-cn.com/problems/check-if-numbers-are-ascending-in-a-sentence/description/)
* [LeetCode-2032. 至少在两个数组中出现的值](https://leetcode-cn.com/problems/two-out-of-three/description/)
* [LeetCode-2027. 转换字符串的最少操作次数](https://leetcode-cn.com/problems/minimum-moves-to-convert-string/description/)








## 2062. 统计字符串中的元音子字符串
### Description
* [LeetCode-2062. 统计字符串中的元音子字符串](https://leetcode-cn.com/problems/count-vowel-substrings-of-a-string/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int countVowelSubstrings(String word) {
        if(word.length() < 5){
            return 0;
        }

        Set<Character> set = new HashSet<>();
        set.add('a');
        set.add('e');
        set.add('i');
        set.add('o');
        set.add('u');

        int size = word.length();
        int count = 0;
        for(int i=0;i<size;i++){
            Set<Character> charSet = new HashSet<>();
            for(int j=i;j<size;j++){
                if(!set.contains(word.charAt(j))){
                    break;
                }
                charSet.add(word.charAt(j));
                if(set.size() == charSet.size()){
                    count++;
                }
            }
        }
        return count;
    }
}
```


## 2068. 检查两个字符串是否几乎相等
### Description
* [LeetCode-2068. 检查两个字符串是否几乎相等](https://leetcode-cn.com/problems/check-whether-two-strings-are-almost-equivalent/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution




```java
class Solution {
    public boolean checkAlmostEquivalent(String word1, String word2) {
        int[] arr = new int[26];
        
        for(int i=0,len1 = word1.length();i<len1;i++){
            arr[word1.charAt(i) - 'a']++;
        }
        for(int j=0,len2 = word2.length();j<len2;j++){
            arr[word2.charAt(j) - 'a']--;
        }
        for(int k=0,len3=arr.length;k<len3;k++){
            if(Math.abs(arr[k]) > 3){
                return false;
            }
        }
        return true;
    }
}
```


## 2042. 检查句子中的数字是否递增
### Description
* [LeetCode-2042. 检查句子中的数字是否递增](https://leetcode-cn.com/problems/check-if-numbers-are-ascending-in-a-sentence/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

注意 `str.toCharArray()` 的使用。
#### Solution


```java
class Solution {
    public boolean areNumbersAscending(String s) {
        String[] strArr = s.split(" ");
        int min = 0;
        boolean firstNum = true;
        for(String str:strArr){
            if(Character.isDigit(str.toCharArray()[0])){
                if(Integer.parseInt(str) <= min && !firstNum){
                    return false;
                } 
                min = Integer.parseInt(str);
                firstNum = false;
            }
        }
        return true;
    }
}
```


## 2032. 至少在两个数组中出现的值
### Description
* [LeetCode-2032. 至少在两个数组中出现的值](https://leetcode-cn.com/problems/two-out-of-three/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。




#### Solution


```java
class Solution {
    public List<Integer> twoOutOfThree(int[] nums1, int[] nums2, int[] nums3) {
        List<Integer> resList = new ArrayList<>();
        int len1 = nums1.length;
        int len2 = nums2.length;
        int len3 = nums3.length;
        int[] cnt1 = new int[101];
        int[] cnt2 = new int[101];
        int[] cnt3 = new int[101];
        //注意数组本身有重复的字段
        for(int i=0;i<len1;i++){
            cnt1[nums1[i]] = 1;  //不能++  注意数组本身可能会有重复的字段                               
        }
        for(int i=0;i<len2;i++){
            cnt2[nums2[i]] = 1;
        }
        for(int i=0;i<len3;i++){
            cnt3[nums3[i]] = 1;
        }
        for(int i=1;i<cnt1.length;i++){
            if(cnt1[i] + cnt2[i] + cnt3[i] > 1){
                resList.add(i);
            }
        }
        return resList;
    }
}
```


## 【水题】2027. 转换字符串的最少操作次数
### Description
* [LeetCode-2027. 转换字符串的最少操作次数](https://leetcode-cn.com/problems/minimum-moves-to-convert-string/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution




```java
class Solution {
    public int minimumMoves(String s) {
        int count = 0;
        int index = 0;
        int len = s.length();
        while(index < len){
            if(s.charAt(index) == 'X'){
                count++;
                index += 3;
            } else {
                index++;
            }
        }
        return count;
    }
}
```

