



# LeetCode Notes-062


[TOC]



## 更新
* 2021/08/17，撰写
* 2021/08/20，撰写



## Overview
* [LeetCode-1331. 数组序号转换](https://leetcode-cn.com/problems/rank-transform-of-an-array/description/)
* [LeetCode-1646. 获取生成数组中的最大值](https://leetcode-cn.com/problems/get-maximum-in-generated-array/description/)
* [LeetCode-1967. 作为子字符串出现在单词中的字符串数目](https://leetcode-cn.com/problems/number-of-strings-that-appear-as-substrings-in-word/description/)
* [LeetCode-1952. 三除数](https://leetcode-cn.com/problems/three-divisors/description/)
* [LeetCode-836. 矩形重叠](https://leetcode-cn.com/problems/rectangle-overlap/description/)





## 1331. 数组序号转换
### Description
* [LeetCode-1331. 数组序号转换](https://leetcode-cn.com/problems/rank-transform-of-an-array/description/)

### Approach 1-哈希表
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int[] arrayRankTransform(int[] arr) {
        int len = arr.length;
        int[] tmpArr = arr.clone(); //数组是个对象 要使用clone深拷贝 不能直接赋值
        Arrays.sort(tmpArr);
        Map<Integer,Integer> map = new HashMap<>();
        int index = 1;
        for(int i=0;i<len;i++) {
        	if(i>0 && tmpArr[i] != tmpArr[i-1]){
        		map.put(tmpArr[i], index);
        		index++;
        	}
        	if(i==0) {
        		map.put(tmpArr[i], index);
        		index++;
        	}
        }
        for(int i=0;i<len;i++) {
        	arr[i]=map.get(arr[i]);
        }
        return arr;
    }
}
```


## 1646. 获取生成数组中的最大值
### Description
* [LeetCode-1646. 获取生成数组中的最大值](https://leetcode-cn.com/problems/get-maximum-in-generated-array/description/)

### Approach 1-常规遍历
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int getMaximumGenerated(int n) {
        if(n == 1){
            return 1;
        } 
        if(n == 0){
            return 0;
        }

        int max = 0;
        int[] arr = new int[n+1];
        arr[0] = 0;
        arr[1] = 1;
        for(int i=2;i<=n;i++){
            if(i%2 == 0){
                arr[i] = arr[i/2];
            } else{
                arr[i] = arr[(i-1)/2] + arr[1+(i-1)/2];
            }
            max = Math.max(max,arr[i]);
        }
        return max;
    }
}
```











## 1967. 作为子字符串出现在单词中的字符串数目
### Description
* [LeetCode-1967. 作为子字符串出现在单词中的字符串数目](https://leetcode-cn.com/problems/number-of-strings-that-appear-as-substrings-in-word/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int numOfStrings(String[] patterns, String word) {
        int count = 0;
        for(int i=0;i<patterns.length;i++){
            if(word.contains(patterns[i])){
                count++;
            }
        }
        return count;
    }
}
```


## 1952. 三除数
### Description
* [LeetCode-1952. 三除数](https://leetcode-cn.com/problems/three-divisors/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public boolean isThree(int n) {
        int count = 2; //1 和 本身
        if(n == 1 || n == 2){
            return false;
        }
        for(int i=2;(i*i) <= n;i++){
            if(count == 3){
                return true;
            }
            int val = n/i;
            if(val * i == n){
                if(val != i){
                    count += 2;
                } else {
                    count ++;
                }
            }
        }
        return (count == 3);
        // return false;   //不能直接返回false 若最后一层循环后 count=3 此时没有执行for循环中的 count == 3判断

    }
}
```







## 836. 矩形重叠
### Description
* [LeetCode-836. 矩形重叠](https://leetcode-cn.com/problems/rectangle-overlap/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public boolean isRectangleOverlap(int[] rec1, int[] rec2) {
        //若出现面积为0
        if (rec1[0] == rec1[2] || rec1[1] == rec1[3] || rec2[0] == rec2[2] || rec2[1] == rec2[3]) {
            return false;
        }
        return !(rec1[2] <= rec2[0] ||   // left
                 rec1[3] <= rec2[1] ||   // bottom
                 rec1[0] >= rec2[2] ||   // right
                 rec1[1] >= rec2[3]);    // top

    }
}
```


### Approach 2-线段投影
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public boolean isRectangleOverlap(int[] rec1, int[] rec2) {
        return (Math.min(rec1[2], rec2[2]) > Math.max(rec1[0], rec2[0]) &&
                Math.min(rec1[3], rec2[3]) > Math.max(rec1[1], rec2[1]));
    }
}
```