# LeetCode Notes-004


[TOC]



## 更新
* 2020/02/23，撰写
* 2020/02/23，整理完成

## Overview

* [LeetCode-1342. Number of Steps to Reduce a Number to Zero（将数字变成 0 的操作次数）](https://leetcode.com/problems/number-of-steps-to-reduce-a-number-to-zero/)
* [LeetCode-1281. 整数的各位积和之差](https://leetcode-cn.com/problems/subtract-the-product-and-sum-of-digits-of-an-integer/)
* [LeetCode-326. 3的幂](https://leetcode-cn.com/problems/power-of-three/)
* [LeetCode-231. 2的幂](https://leetcode-cn.com/problems/power-of-two/)
* [LeetCode-342. 4的幂](https://leetcode-cn.com/problems/power-of-four/)

## 1342. Number of Steps to Reduce a Number to Zero（将数字变成 0 的操作次数）
### Description
* [LeetCode-1342. Number of Steps to Reduce a Number to Zero（将数字变成 0 的操作次数）](https://leetcode.com/problems/number-of-steps-to-reduce-a-number-to-zero/)

### Approach 1

#### Analysis
题目较为简单，直接求解即可，不再赘述。

#### Solution

* Java

```java
class Solution {
    public int numberOfSteps (int num) {
        int sum = 0;
        while(num>0){
            sum++;
            num = (num%2 == 0) ? num>>1:num-1;
        }
        return sum;
    }
}
```




## 1281. 整数的各位积和之差
### Description
* [LeetCode-1281. 整数的各位积和之差](https://leetcode-cn.com/problems/subtract-the-product-and-sum-of-digits-of-an-integer/)

### Approach 1

#### Analysis
题目较为简单，直接求解即可，不再赘述。

通过取模运算得到数字 `n` 的最后一位，依次进行乘法和加法运算。
* 时间复杂度：`O(log N)`。整数 N 的位数如下公式所示。根据换底公式，它和时间复杂度中常用的以 2 为底的 `log` 只相差一个常数，因此时间复杂度可以表示为 `O(log N)`

```math
⌈log10(N+1)⌉
```

* 空间复杂度：`O(1)`


#### Solution

* Java

```
class Solution {
    public int subtractProductAndSum(int n) {
        int mul = 1;
        int add = 0;
        while(n>0){
            mul *= n%10;
            add += n%10;
            n = n/10;
        }
        return mul-add;
    }
}
```




## 326. 3的幂
### Description
* [LeetCode-326. 3的幂](https://leetcode-cn.com/problems/power-of-three/)


### Approach 1-循环迭代

#### Analysis
常规基本方法，使用循环求解。

如果数字 `num` 是3的幂，则对 `num` 不断除3，并对3取模都是0，直到 `num=1` 停止。

需要注意，1是3的0次幂，在判断时候不要忘记对1的处理。

* 时间复杂度：如下，`b` 表示进制基数，此处为3


```math
O(log_{b}(N))
```

* 空间复杂度：`O(1)`


#### Solution

* Java


```java
public class Solution {
    public boolean isPowerOfThree(int n) {
        if (n < 1) {
            return false;
        }

        while (n % 3 == 0) {
            n /= 3;
        }

        return n == 1;  //1是3的0次幂
    }
}
```


* C++

```cpp
class Solution {
public:
    bool isPowerOfThree(int n) {
        if(n<3 && n != 1) return false;
        bool flag = true;
        while(n>0){
            if(n == 1){
                //1是3的0次幂
                flag = true;
                break;
            }
            if(n%3 != 0){
                flag = false;
                break;
            }
            n = n/3;
        }
        return flag;
    }
};
```


### Approach 2-基准转换

#### Analysis

对于10的次幂，其10进制格式为1，10，100，1000……

对于2的次幂，其2进制格式为1，10，100，1000……

类比可得，

对于3的次幂，其3进制格式为1，10，100，1000……

因此，对于给定的数字，如果其3进制格式可以表示为 `^10*$` （即以数字1开头，以0个或者多个0结尾），则该数字就是3的次幂。


* 时间复杂度：如下，`b` 表示进制基数，此处为3


```math
O(log_{b}(N))
```


* 空间复杂度：如下，`b` 表示进制基数，此处为3。此处，我们使用2个附加变量，一个是正则表达式的字符串（常量大小），一个是以3为基数表示数字的字符串，大小为 `O(log3(N))`


```math
O(log_{b}(N))
```


#### Solution

* Java

> Java 内置的 `Integer.toString(number,base)`可以将数字转换为 `base` 进制的字符串
>
> Java 内置的 `matches` 方法可以用于正则匹配

本方法中，使用Java内置的字符串转换和正则匹配实现，相比于方法1的迭代求解，内存消耗方面两种方法基本一样，但是该方法的执行用时（37ms）是大于迭代求解的（17ms）。

```
public class Solution {
    public boolean isPowerOfThree(int n) {
        return Integer.toString(n, 3).matches("^10*$");
    }
}
```



### Approach 3-换底公式


#### Analysis

```math
n=3^i

i = log_{3}(n) = log_{b}(n)/log_{b}(3)  
```

如果 n 是3的次幂，即可以表示为 `3^i`的形式。如上所示，可以根据换底公式求解出 `i`。

因此若 `i` 是整数，则可以判断 n 是3的次幂。



* 时间复杂度：`Unknown`。消耗时间的运算主要是 `Math.log`，它限制了我们算法的时间复杂性。实现依赖于我们使用的语言和编译器。
* 空间复杂度： `O(1)`。没有使用任何额外的内存。`epsilon` 变量可以是内联的。


**需要注意的是，这个解决方案是有问题的，因为如果数值类型为 `double`，这意味着我们会遇到精度错误，在比较双精度数时不应使用 `==`。**

这是因为 `Math.log10(n)/Math.log10(3)` 的结果可能是 `5.0000001` 或 `4.9999999`。使用 `Math.log()` 函数而不是 `Math.log10()` 可以观察到这种效果。

为了解决这个问题，我们需要将结果与 `epsilon` 进行比较。


```
return (Math.log(n) / Math.log(3) + epsilon) % 1 <= 2 * epsilon;
```


#### Solution

* Java

```java
public class Solution {
    public boolean isPowerOfThree(int n) {
        return (Math.log10(n) / Math.log10(3)) % 1 == 0;
    }
}
```



### Approach 4-整数限制



#### Analysis

题目限定了输入数值为 `int` 类型，最大为32位，因此输入数值的最大值为 `2^31`，在此范围内3的最大次幂为 `3^19=1162261467`。
* 因此，本题中可能返回 `true` 的数值只能是 `3^0`，`3^1` …… `3^19`
* 如果使用 `3^19` 除以数值 `n`，若余数为0，则表示数值 `n`是3的次幂
* 需要注意的是，这种方式只适合基数为质数的情况。此处，3为质数，`3^19` 的约数字只有 `3^0`，`3^1` …… `3^19`。如果对于基数为偶数的情况，如 `4`，`4^4`的约数除了 `4^0`，`4^1`，`4^2`，`4^3`，`4^4`外，还有数字 `2`。


#### Solution

* Java

```java
public class Solution {
    public boolean isPowerOfThree(int n) {
    	return ((n > 0) && ((1162261467 % n) == 0));
    	// or
        //return (n>0) && (Math.pow(3,19) % n ==0);
    }
}
```






## 231. 2的幂

### Description
* [LeetCode-231. 2的幂](https://leetcode-cn.com/problems/power-of-two/)

本题同 [LeetCode-326. 3的幂](https://leetcode-cn.com/problems/power-of-three/)，对于相同的原理，此处不再赘述。

此处仅补充 `Approach 5-二进制位运算` 特解方法。



### Approach 1-循环迭代

* Java

```
public class Solution {
    public boolean isPowerOfTwo(int n) {
        if (n < 1) {
            return false;
        }

        while (n % 2 == 0) {
            n /= 2;
        }

        return n == 1;  //1是2的0次幂
    }
}
```

### Approach 2-基准转换

* Java

```
public class Solution {
    public boolean isPowerOfTwo(int n) {
        return Integer.toString(n, 2).matches("^10*$");
    }
}
```


### Approach 3-换底公式

* Java


```
public class Solution {
    public boolean isPowerOfTwo(int n) {
        return (Math.log10(n) / Math.log10(2)) % 1 == 0;
    }
}
```

### Approach 4-整数限制

* Java

```java
public class Solution {
    public boolean isPowerOfTwo(int n) {
        return (n>0) && (Math.pow(2,32) % n ==0);
    }
}
```


### Approach 5-二进制位运算（特解）

#### Analysis
若 `num` 是 2 的整数幂，则其二进制数值为 `100..00` 的形式，`num-1` 的二进制数值为 `011...1` 的形式。因此，`n & (n-1)` 一定为0。利用该方法可以求解。

需要注意的是，该方法使用了位运算，因此只适用于2的次幂求解，不具有通用性。


#### Solution
* Java


```
class Solution {
    public boolean isPowerOfTwo(int n) {
        return (n>0) && ((n & (n-1)) == 0);
    }
}
```

* C++

```cpp
class Solution {
public:
    bool isPowerOfTwo(int n) {
        return (n>0) && ((n & (n-1)) == 0);
    }
};
```
 
 
 
 
 
## 342. 4的幂

### Description
* [LeetCode-342. 4的幂](https://leetcode-cn.com/problems/power-of-four/)
 

本题同 [LeetCode-326. 3的幂](https://leetcode-cn.com/problems/power-of-three/)，对于相同的原理，此处不再赘述。

该方法只适合基数为质数的情况。此处，3为质数，`3^19` 的约数字只有 `3^0`，`3^1` …… `3^19`。如果对于基数为偶数的情况，如 `4`，`4^4`的约数除了 `4^0`，`4^1`，`4^2`，`4^3`，`4^4`外，还有数字 `2` 和数字 `8` 等。


### Approach 1-循环迭代

* Java

```
public class Solution {
    public boolean isPowerOfFour(int n) {
        if (n < 1) {
            return false;
        }

        while (n % 4 == 0) {
            n /= 4;
        }

        return n == 1;  //1是2的0次幂
    }
}
```

### Approach 2-基准转换

* Java

```
public class Solution {
    public boolean isPowerOfFour(int n) {
        return Integer.toString(n, 4).matches("^10*$");
    }
}
```


### Approach 3-换底公式

* Java


```
public class Solution {
    public boolean isPowerOfFour(int n) {
        return (Math.log10(n) / Math.log10(4)) % 1 == 0;
    }
}
```


 