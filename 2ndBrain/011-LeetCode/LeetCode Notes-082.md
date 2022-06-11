
# LeetCode Notes-082


[TOC]



## 更新
* 2021/01/20，撰写
* 2022/01/21，完成



## Overview
* [LeetCode-2138. 将字符串拆分为若干长度为 k 的组](https://leetcode-cn.com/problems/divide-a-string-into-groups-of-size-k/description/)
* 【水题】[LeetCode-2124. 检查是否所有 A 都在 B 之前](https://leetcode-cn.com/problems/check-if-all-as-appears-before-all-bs/description/)
* 【水题】[LeetCode-2133. 检查是否每一行每一列都包含全部整数](https://leetcode-cn.com/problems/check-if-every-row-and-column-contains-all-numbers/description/)
* [LeetCode-2129. 将标题首字母大写](https://leetcode-cn.com/problems/capitalize-the-title/description/)
* [LeetCode-1304. 和为零的N个唯一整数](https://leetcode-cn.com/problems/find-n-unique-integers-sum-up-to-zero/description/)





## 2138. 将字符串拆分为若干长度为 k 的组
### Description
* [LeetCode-2138. 将字符串拆分为若干长度为 k 的组](https://leetcode-cn.com/problems/divide-a-string-into-groups-of-size-k/description/)

### Approach 1-常规


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution





```java
class Solution {
    public String[] divideString(String s, int k, char fill) {
        int len = s.length();
        int size = (len + k-1) /k;
        String[] arr = new String[size];
        int index = 0;
        for(int i=0;i<size;i++){
            arr[i] = s.substring(index,Math.min(index+k,len));
            if(index + k > len){
                StringBuilder sb = new StringBuilder(arr[i]);
                int count  = k - (len%k);
                while(count > 0){
                    sb.append(fill);
                    count--;
                }
                arr[i] = sb.toString();
            }
            index += k;
        }
        return arr;
    }
}
```


## 【水题】2124. 检查是否所有 A 都在 B 之前
### Description
* 【水题】[LeetCode-2124. 检查是否所有 A 都在 B 之前](https://leetcode-cn.com/problems/check-if-all-as-appears-before-all-bs/description/)

### Approach 1-常规


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution



```java
class Solution {
    public boolean checkString(String s) {
        int len = s.length();
        int indexA = -1;
        int indexB = len;
      
        for(int i=0;i<len;i++){
            //记录a出现的最大索引
            //记录b出现的最小索引
            if(s.charAt(i) == 'a'){
                indexA = Math.max(indexA, i);
            } else {
                indexB = Math.min(indexB, i);
            }
        }
        if(indexA == -1 || indexB == len) { //全a或者全b
            return true;
        }
        if(indexA < indexB){
            return true;
        }

        return false;
    }
}
```



## 【水题】2133. 检查是否每一行每一列都包含全部整数
### Description
* 【水题】[LeetCode-2133. 检查是否每一行每一列都包含全部整数](https://leetcode-cn.com/problems/check-if-every-row-and-column-contains-all-numbers/description/)

### Approach 1-常规


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution



```java
class Solution {
    public boolean checkValid(int[][] matrix) {
        int n = matrix.length;
    
        Set<Integer> setRow = new HashSet<>();
        Set<Integer> setColumn = new HashSet<>();

        for(int i=0;i<n;i++){
            setRow.clear();
            setColumn.clear();
            for(int j=0;j<n;j++){
                setRow.add(matrix[i][j]);
                setColumn.add(matrix[j][i]);
            }
            if(setRow.size() != n || setColumn.size() != n){
                return false;
            }
        }
        return true;
    }
}
```



## 2129. 将标题首字母大写
### Description
* [LeetCode-2129. 将标题首字母大写](https://leetcode-cn.com/problems/capitalize-the-title/description/)

### Approach 1-常规


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution




```java
class Solution {
    public String capitalizeTitle(String title) {
        String[] arr = title.split(" ");
        StringBuilder sBuilder = new StringBuilder();
        for(int i=0,len=arr.length;i<len;i++){
            String str = arr[i];
            if(str.length() <= 2){
                sBuilder.append(str.toLowerCase());
            } else {
                sBuilder.append(toTitleCase(str.toLowerCase()));
            }
            if(i != len - 1){
                sBuilder.append(" ");
            }
        }
        return sBuilder.toString();
    }

    private String toTitleCase(String str){
        return str.substring(0,1).toUpperCase() + str.substring(1 );
    }
}
```

代码优化版本

```java
class Solution {
    public String capitalizeTitle(String title) {
        // 分割单词
        String[] words = title.split(" ");
        StringBuilder ans = new StringBuilder();
        for (int j = 0; j < words.length; j++) {
            String word = words[j];
            // 长度小于等于2的单词全部改为小写
            if (word.length() <= 2) {
                ans.append(word.toLowerCase());
            // 长度大于2的单词首字母大写，其余字母小写
            } else {
                ans.append(Character.toUpperCase(word.charAt(0)));
                ans.append(word.substring(1).toLowerCase());
            }
            // 最后一个单词后不加空格
            if (j != words.length - 1) {
                ans.append(" ");
            }
        }
        return ans.toString();
    }
}
```


## 1304. 和为零的N个唯一整数
### Description
* [LeetCode-1304. 和为零的N个唯一整数](https://leetcode-cn.com/problems/find-n-unique-integers-sum-up-to-zero/description/)

### Approach 1-常规


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution



```java
class Solution {
    public int[] sumZero(int n) {
        if(n == 1){
            return new int[]{0};
        }

        int[] arr = new int[n];

        int index = 0;
        if(n%2 != 0){
            arr[0] = 0;
            index++;
        }
        int val = 1;
        for(;index<n;index+=2){
            arr[index] = val;
            arr[index+1] = 0 - val;
            val++; 
        }
        return arr;

    }
}
```