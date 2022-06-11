
# LeetCode Notes-081


[TOC]



## 更新
* 2021/01/19，撰写
* 2022/01/20，完成



## Overview
* [LeetCode-1317. 将整数转换为两个无零整数的和](https://leetcode-cn.com/problems/convert-integer-to-the-sum-of-two-no-zero-integers/description/)
* 【水题】[LeetCode-1323. 6 和 9 组成的最大数字](https://leetcode-cn.com/problems/maximum-69-number/description/)
* [LeetCode-1309. 解码字母到整数映射](https://leetcode-cn.com/problems/decrypt-string-from-alphabet-to-integer-mapping/description/)
* [LeetCode-1313. 解压缩编码列表](https://leetcode-cn.com/problems/decompress-run-length-encoded-list/description/)
* 【经典好题】[LeetCode-394. 字符串解码](https://leetcode-cn.com/problems/decode-string/)




## 1317. 将整数转换为两个无零整数的和
### Description
* [LeetCode-1317. 将整数转换为两个无零整数的和](https://leetcode-cn.com/problems/convert-integer-to-the-sum-of-two-no-zero-integers/description/)

### Approach 1-常规


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public int[] getNoZeroIntegers(int n) {
        //2 <= n <= 10^4  范围较小 直接暴力枚举
        for(int A=1; A < n/2 + 1;A++){
            int B  = n - A;
            if(!String.valueOf(A).contains("0") && !String.valueOf(B).contains("0")){
                return new int[]{A,B};
            }
        }
        return new int[2];
    }
}
```


## 【水题】1323. 6 和 9 组成的最大数字
### Description
* 【水题】[LeetCode-1323. 6 和 9 组成的最大数字](https://leetcode-cn.com/problems/maximum-69-number/description/)

### Approach 1-常规


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public int maximum69Number (int num) {
        String str = String.valueOf(num);
        StringBuffer sBuffer = new StringBuffer();
        boolean hasRotate = false;
        for(int i=0;i<str.length();i++){
            if(str.charAt(i) == '6' && !hasRotate){
                sBuffer.append('9');
                hasRotate = true;
            } else {
                sBuffer.append(str.charAt(i));
            }
        }
        return Integer.parseInt(sBuffer.toString());

    }
}
```


## 1309. 解码字母到整数映射
### Description
* [LeetCode-1309. 解码字母到整数映射](https://leetcode-cn.com/problems/decrypt-string-from-alphabet-to-integer-mapping/description/)

### Approach 1-常规


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution



```java
class Solution {
    public String freqAlphabets(String s) {
        StringBuffer sBuffer = new StringBuffer();
        int i = 0;
        int len = s.length();
        while(i < len){
            int val = 0;
            //XX#格式
            if(i+2 < len && s.charAt(i+2) == '#'){
                val = 10 * (s.charAt(i) - '0') + s.charAt(i+1) - '0';
                i += 3;
            } else {
                //X格式
                val = s.charAt(i) - '0';
                i++;
            }
            char c = (char) ('a' + val - 1);  //转换 由于 'a' 对应的是1 不是0  所以是val-1
            sBuffer.append(c);
        }
        return sBuffer.toString();
    }
}
```




## 1313. 解压缩编码列表
### Description
* [LeetCode-1313. 解压缩编码列表](https://leetcode-cn.com/problems/decompress-run-length-encoded-list/description/)

### Approach 1-常规


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public int[] decompressRLElist(int[] nums) {
        int len = nums.length;
        List<Integer> list = new ArrayList<>();
        for(int i=0;i<len;i+=2){
            int count = nums[i];
            int val = nums[i+1];
            while(count >0){
                list.add(val);
                count--;
            }
        }
        return list.stream().mapToInt(i->i).toArray();
    }
}
```


## 【经典好题】394. 字符串解码
### Description
* 【经典好题】[LeetCode-394. 字符串解码](https://leetcode-cn.com/problems/decode-string/)

### Approach 1-栈操作


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    int ptr;

    public String decodeString(String s) {
        LinkedList<String> stk = new LinkedList<String>();
        ptr = 0;

        while (ptr < s.length()) {
            char cur = s.charAt(ptr);
            if (Character.isDigit(cur)) {
                // 获取一个数字并进栈
                // 此处获取的是一个数字 而不是数字的单个字符 如"100" 要将100入栈  
                // 在获取一个完整的数字时 为了方便计算字符串遍历的位置 将ptr作为全局变量
                String digits = getDigits(s); 
                stk.addLast(digits);
            } else if (Character.isLetter(cur) || cur == '[') {
                // 获取一个字母并进栈
                stk.addLast(String.valueOf(s.charAt(ptr++)));
            } else {
                ++ptr;
                LinkedList<String> sub = new LinkedList<String>();
                while (!"[".equals(stk.peekLast())) {
                    sub.addLast(stk.removeLast());
                }
                Collections.reverse(sub);
                // 左括号出栈
                stk.removeLast();
                // 此时栈顶为当前 sub 对应的字符串应该出现的次数
                int repTime = Integer.parseInt(stk.removeLast());
                StringBuffer t = new StringBuffer();
                String o = getString(sub);
                // 构造字符串
                while (repTime-- > 0) {
                    t.append(o);
                }
                // 将构造好的字符串入栈
                stk.addLast(t.toString());
            }
        }

        return getString(stk);
    }

    public String getDigits(String s) {
        StringBuffer ret = new StringBuffer();
        while (Character.isDigit(s.charAt(ptr))) {
            ret.append(s.charAt(ptr++));
        }
        return ret.toString();
    }

    public String getString(LinkedList<String> v) {
        StringBuffer ret = new StringBuffer();
        for (String s : v) {
            ret.append(s);
        }
        return ret.toString();
    }
}
```