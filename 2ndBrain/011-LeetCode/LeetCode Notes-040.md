

# LeetCode Notes-040


[TOC]



## 更新
* 2021/07/16，撰写
* 2021/07/16，完成


## Overview
* [LeetCode-1844. 将所有数字用字符替换](https://leetcode-cn.com/problems/replace-all-digits-with-characters/description/)
* [LeetCode-1925. 统计平方和三元组的数目](https://leetcode-cn.com/problems/count-square-sum-triples/description/)
* [LeetCode-1869. 哪种连续子字符串更长](https://leetcode-cn.com/problems/longer-contiguous-segments-of-ones-than-zeros/description/)
* [LeetCode-1929. 数组串联](https://leetcode-cn.com/problems/concatenation-of-array/description/)
* [LeetCode-1528. 重新排列字符串](https://leetcode-cn.com/problems/shuffle-string/description/)





## 1844. 将所有数字用字符替换
### Description
* [LeetCode-1844. 将所有数字用字符替换](https://leetcode-cn.com/problems/replace-all-digits-with-characters/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


此处，对于 `char` 转 `int`，进行简单分析总结。

* [Java中char 转化为int 的两种方法](https://blog.csdn.net/sxb0841901116/article/details/20623123)
* [Java 实例 char到int的转换](https://geek-docs.com/java/java-examples/char-to-int.html)


`char` 转 `int`，常用的有以下四种方案

1. 隐式转换->ASCII值


```java
char c1 = 'A';
char c2 = 'a';
char c3 = '9';
//隐式转换 转为对应的ASCII值
int val1 = c1;  //65
int val2 = c2;  //97
int val3 = c3;  //57
```


2. Character.getNumericValue -> 数值

* [Character.getNumericValue(..) in Java returns same number for upper and lower case characters | StackOv erflow](https://stackoverflow.com/questions/31888001/character-getnumericvalue-in-java-returns-same-number-for-upper-and-lower-ca)

```java
char c1 = 'A';
char c2 = 'a';
char c3 = '9';
    
int val1 = Character.getNumericValue(c1);  //10
int val2 = Character.getNumericValue(c2);  //10
int val3 = Character.getNumericValue(c2);  //9
```

需要注意的是，该方法对于字母 `A-Z`, `a-z` 以及全宽变体的数值，返回的结果都是在 [10.35] 范围内。

因此，对于大写字母 `A` 和小写字母 `a`，该方法的返回结果是一样的。

3. Integer.parseInt() -> 数值



```java
char c1 = 'A';
char c2 = '9';

int val1 = Integer.parseInt(String.valueOf(c1));  //NumberFormatException
int val2 = Integer.parseInt(String.valueOf(c2));  //9
```

可以看到，使用 `Integer.parseInt()` 直接对于非数字的字符进行转换，会抛出 `NumberFormatException` 异常。为了保证代码健壮性，可以使用 `Character.isDigit()` 进行条件判断。

```java 
if(Character.isDigit(c1)){
    System.out.println(Integer.parseInt(String.valueOf(c1)));
}
```

4. char - '0' -> 数值

```java
char c2 = '9';
if(Character.isDigit(c1)){
    int val  = c2 - '0';  // 9
}
```
     



#### Solution

```java
class Solution {
    final String ALPHABET = "abcdefghijklmnopqrstuvwxyz";

    public String replaceDigits(String s) {
        StringBuilder sb = new StringBuilder();

        int i = 0;
        while(i<s.length()){
            if(i%2 == 0){
                sb.append(s.charAt(i));
            } else{
                sb.append(shift(s.charAt(i-1),s.charAt(i) - '0')); //注意char转int
            }
            i++;
        }
        return sb.toString();
    }

    private char shift(char source,int offset){
        char target = source;
        int index = ALPHABET.indexOf(source);
        if(-1 != index){
            target = ALPHABET.charAt(index+offset);
        }
        return target;
    }

}
```





## 1925. 统计平方和三元组的数目
### Description
* [LeetCode-1925. 统计平方和三元组的数目](https://leetcode-cn.com/problems/count-square-sum-triples/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

水题。
#### Solution


```java
class Solution {
    public int countTriples(int n) {
        int res=0;
        for(int i=1;i<=n;i++){
            for(int j=1;j<=n;j++){
                int k = (int)(Math.sqrt(i*i+j*j));
                if( k <= n && k * k == i * i + j * j){
                    res++;
                }
            }
        }
        return res;

    }
}
```


## 1869. 哪种连续子字符串更长
### Description
* [LeetCode-1869. 哪种连续子字符串更长](https://leetcode-cn.com/problems/longer-contiguous-segments-of-ones-than-zeros/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public boolean checkZeroOnes(String s) {
        int maxOne = 0;
        int preMaxOne = 0;
        int maxZero = 0;
        int preMaxZero = 0;
        if(s.length() == 0){
            return false;
        }
        if('1' == s.charAt(0)){
            maxOne = 1;
            preMaxOne = 1;
        } else{
            maxZero = 1;
            preMaxZero = 1;
        }
        for(int i=1;i<s.length();i++){
            if('1' == s.charAt(i)){
                maxOne = Math.max(maxOne, 1 + preMaxOne);
                preMaxOne++;
                preMaxZero = 0;
            } else{
                maxZero = Math.max(maxZero, 1+ preMaxZero);
                preMaxZero++;
                preMaxOne = 0;
            }
        }

        return maxOne > maxZero;

    }
}
```






## 1929. 数组串联
### Description
* [LeetCode-1929. 数组串联](https://leetcode-cn.com/problems/concatenation-of-array/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

水题。
#### Solution

```java
class Solution {
    public int[] getConcatenation(int[] nums) {
        int length = nums.length;
        if(length == 0){
            return nums;
        }
        int[] arr = new int[2*length];
        for(int i=0;i<length;i++){
            arr[i] = nums[i];
            arr[i+length] = nums[i];
        }
        return arr;
    }
}
```


## 1528. 重新排列字符串
### Description
* [LeetCode-1528. 重新排列字符串](https://leetcode-cn.com/problems/shuffle-string/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public String restoreString(String s, int[] indices) {
        StringBuilder sb = new StringBuilder(indices.length);
        for(int i=0;i<indices.length;i++){
            sb.insert(indices[i],s.charAt(i));
        }
        return sb.toString();
    }
}
```



