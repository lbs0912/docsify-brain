



# LeetCode Notes-025


[TOC]



## 更新
* 2021/03/11，撰写
* 2021/03/11，完成


## Overview

* [LeetCode-367. 有效的完全平方数](https://leetcode-cn.com/problems/valid-perfect-square/description/)
* [LeetCode-69. x 的平方根](https://leetcode-cn.com/problems/sqrtx/description/)
* [LeetCode-7. 整数反转](https://leetcode-cn.com/problems/reverse-integer/description/)
* [LeetCode-175. 组合两个表](https://leetcode-cn.com/problems/combine-two-tables/description/) 
* [LeetCode-58. 最后一个单词的长度](https://leetcode-cn.com/problems/length-of-last-word/description/)



## 367. 有效的完全平方数
### Description
* [LeetCode-367. 有效的完全平方数](https://leetcode-cn.com/problems/valid-perfect-square/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public boolean isPerfectSquare(int num) {
        if(num == 1){
            return true;
        }
        int high = num / 2;
        int low = 1;
        int mid = 0;
        while(low <= high){
            mid = low + ((high - low) >> 1);  //记得带括号
            long val =  (long) mid * mid;
            if(val == num){
                return true;
            } else if(val < num){
                low = mid+1;
            } else {
               high = mid-1;
            }
        }
        return false;
    }
}
```

## 69. x 的平方根
### Description
* [LeetCode-69. x 的平方根](https://leetcode-cn.com/problems/sqrtx/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

注意数据溢出问题，使用 `long` 扩充支持的数据范围。


复杂度分析
* 时间复杂度：`O(n)`。
* 空间复杂度：`O(1)`。

#### Solution

```java
class Solution {
    public int mySqrt(int x) {
        long res = 1; //注意数据溢出
        while(res * res <= x){
            res++;
        }
        return (int)--res;
    }
}
```

### Approach 2-二分查找
#### Analysis

参考 `leetcode-cn` 官方题解。



复杂度分析
* 时间复杂度：`O(logx)`，即为二分查找需要的次数。
* 空间复杂度：`O(1)`。

#### Solution

```java
class Solution {
    public int mySqrt(int x) {
        int l = 0, r = x, ans = -1;
        while (l <= r) {
            int mid = l + (r - l) / 2;
            if ((long) mid * mid <= x) {
                ans = mid;
                l = mid + 1;
            } else {
                r = mid - 1;
            }
        }
        return ans;
    }
}
```



## 7. 整数反转
### Description
* [LeetCode-7. 整数反转](https://leetcode-cn.com/problems/reverse-integer/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。


我们可以一次构建反转整数的一位数字。在这样做的时候，我们可以预先检查向原整数附加另一位数字是否会导致溢出。

反转整数的方法可以与反转字符串进行类比。

我们想重复 “弹出” xx 的最后一位数字，并将它 “推入” 到 `rev` 的后面。最后，`rev` 将与 `xx` 相反。

要在没有辅助堆栈/数组的帮助下 “弹出” 和 “推入” 数字，我们可以使用数学方法。

```java
//pop operation:
pop = x % 10;
x /= 10;

//push operation:
temp = rev * 10 + pop;
rev = temp;
```

但是，这种方法很危险，因为当 `$\text{temp} = \text{rev} \cdot 10 + \text{pop}$` 时会导致溢出。

幸运的是，事先检查这个语句是否会导致溢出很容易。

为了便于解释，我们假设 `rev` 是正数。

如果 `$temp = \text{rev} \cdot 10 + \text{pop}$` 导致溢出，那么一定有 `$\text{rev} \geq \frac{INTMAX}{10}$`
* 如果 `$\text{rev} > \frac{INTMAX}{10}$`，那么 `$temp = \text{rev} \cdot 10 + \text{pop}$` 一定会溢出。
* 如果 `$\text{rev} == \frac{INTMAX}{10}$`，那么只要 `$\text{pop} > 7$`，`$temp = \text{rev} \cdot 10 + \text{pop}$` 就会溢出。

当 `rev` 为负时可以应用类似的逻辑。

7或8是因为最大值2的31次方是2147483648，最小值负2的31次方减一是-2147483647，这两个数值的个位数是7和8.



#### Solution


```java
class Solution {
    public int reverse(int x) {
        int rev = 0;
        while (x != 0) {
            int pop = x % 10;
            x /= 10;
            //大于7是因为 正数最大值 2^31 = 2147483648，数值的个位是7
            if (rev > Integer.MAX_VALUE/10 || (rev == Integer.MAX_VALUE / 10 && pop > 7)) return 0;
            //小于-8是因为 负数最大值 (2^31)-1 = -2147483647，数值的个位是8
            if (rev < Integer.MIN_VALUE/10 || (rev == Integer.MIN_VALUE / 10 && pop < -8)) return 0;
            rev = rev * 10 + pop;
        }
        return rev;
    }
}
```




## 175. 组合两个表
### Description
* [LeetCode-175. 组合两个表](https://leetcode-cn.com/problems/combine-two-tables/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

考虑到可能不是每个人都有地址信息，我们应该使用 `outer join` 而不是默认的 `inner join`。

如果没有某个人的地址信息，使用 `where` 子句过滤记录将失败，因为它不会显示姓名信息。



#### Solution




```sql
SELECT 
    FirstName,LastName,City,State
FROM 
    Person 
LEFT JOIN 
    Address
ON 
    Person.PersonId = Address.PersonId;
```



## 58. 最后一个单词的长度
### Description
* [LeetCode-58. 最后一个单词的长度](https://leetcode-cn.com/problems/length-of-last-word/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int lengthOfLastWord(String s) {
        String[] arr = s.split(" ");
        if(arr.length > 0){
            return arr[arr.length-1].length();
        }
        return 0;
    }
}
```


此处，对 `String.split()` 方法进行说明。

* [String.split() 方法介绍](https://www.runoob.com/java/java-string-split.html)

1. 对于字符串，可以调用其 `split()` 方法，按照传入的正则表达式，对字符串进行分割，返回值类型为一个字符串型数组 `String[]`。方法参数如下。

```java
public String[] split(String regex) {
    return split(regex, 0);
}

public String[] split(String regex, int limit);
```

2. 对于入参中的 `limit`，表示正则匹配应用的个数，对于目标字符串，会应用 `limit - 1` 次正则匹配，下面给出示例进行说明。对于字符串 `"boo:and:foo"`, 正则表达式为 `:`，当 `limit` 传不同的值，，返回结果如下。
* limit=2，返回 `{ "boo", "and:foo" }`
* limit=5，返回 `{ "boo", "and", "foo" }`
* limit=-2，返回 `{ "boo", "and", "foo" }`



3. 当 `limit > 0` 时，会应用 `limit - 1` 次正则匹配。若 `limit <= 0`，则会对字符串全部应用应用正则匹配（不限制次数）。因此，上述示例中，`limit = -2` 和 `limit = 5` 的返回结果相同。


4. 若正则匹配无相符的，则返回整个原字符串。

```java
    String str = "abccd";
    String[] arr = str.split("o");
    System.out.println(JsonUtil.write2JsonStr(arr)); // "abccd"
```


5. 此处给出一个常用例子，将一句英文语句分割成具体的单次，即按照空格进行分割。

```java
    String str = "SADA Systems uses cookies to improve your website experience";
    String[] arr = str.split(" ");
    System.out.println(JsonUtil.write2JsonStr(arr));  
    // ["SADA","Systems","uses","cookies","to","improve","your","website","experience"]
```

可以直接使用空格作为正则表达式，即 `str.split(" ")`（只能匹配单次之间一个空格符的情况），也可以使用 `str.split("\\s+")`（可以匹配单次之间多个空格符的情况）。


> 转义字符 `\s` 表示匹配空白符，包括换行。
>
> 转义字符 `\S` 表示非空白符，不包括换行。
> 
> 对于该转义字符，前面需要加 `\\`。`+` 表示匹配1次或多次。 -- [正则表达式 | 菜鸟教程](https://www.runoob.com/regexp/regexp-syntax.html)


转义字符 `\S` 表示非空白符，不包括换行。如果使用该匹配，返回如下。


```java
    String str = "SADA Systems uses cookies to improve your website experience";
    String[] arr = str.split(" ");
    System.out.println(JsonUtil.write2JsonStr(arr));  
    // [""," "," "," "," "," "," "," "," "]
```



