
# LeetCode Notes-077


[TOC]



## 更新
* 2021/12/26，撰写
* 2021/12/28，完成



## Overview
* [LeetCode-1441. 用栈操作构建数组](https://leetcode-cn.com/problems/build-an-array-with-stack-operations/)
* [LeetCode-5963. 反转两次的数字](https://leetcode-cn.com/problems/a-number-after-a-double-reversal/description/)
* [LeetCode-5946. 统计特殊四元组](https://leetcode-cn.com/problems/maximum-number-of-words-found-in-sentences/description/)
* 【经典好题】[LeetCode-1995. 统计特殊四元组](https://leetcode-cn.com/problems/count-special-quadruplets/description/)
* [LeetCode-6. Z 字形变换](https://leetcode-cn.com/problems/zigzag-conversion/)


## 1441. 用栈操作构建数组
### Description
* [LeetCode-1441. 用栈操作构建数组](https://leetcode-cn.com/problems/build-an-array-with-stack-operations/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public List<String> buildArray(int[] target, int n) {
        List<String> list = new ArrayList<>();
        int index = 0;
        for(int i=1;i<=n;i++){
            if(index == target.length){
                break;
            }
            if(i == target[index]){
                list.add("Push");
                index++;
            } else {
                list.add("Push");
                list.add("Pop");
            }
        }
        return list;

    }
}
```



## 5963. 反转两次的数字
### Description
* [LeetCode-5963. 反转两次的数字](https://leetcode-cn.com/problems/a-number-after-a-double-reversal/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public boolean isSameAfterReversals(int num) {
        if(0 == num){
            return true;
        }
        //609576
        boolean zeroFlag = true;
        while(num > 0){
            if(!zeroFlag){
                break;
            }
            if(num%10 == 0){
                return false;
            } else {
                zeroFlag = false;
            }
            num /= 10;
        }
        return true;
    }
}
```



## 5946. 统计特殊四元组
### Description
* [LeetCode-5946. 统计特殊四元组](https://leetcode-cn.com/problems/maximum-number-of-words-found-in-sentences/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int mostWordsFound(String[] sentences) {
        int maxCount = 0;
        for(String str : sentences){
            maxCount = Math.max(maxCount,str.split(" ").length);
        }
        return maxCount;
    }
}
```


## 【经典好题】1995. 统计特殊四元组
### Description
* 【经典好题】[LeetCode-1995. 统计特殊四元组](https://leetcode-cn.com/problems/count-special-quadruplets/description/)

### Approach 1-常规-O(n^4)
#### Analysis

参考 `leetcode-cn` 官方题解。

由于数组长度较小，` 4 <= nums.length <= 50`，因此可用常规暴力，四重循环解决。


#### Solution


```java
class Solution {

    public int countQuadruplets(int[] nums) {
        int len = nums.length;
        int count = 0;
        for(int a=0;a<len-3;a++){
            for(int b=a+1;b<len-2;b++){
                for(int c=b+1;c<len-1;c++){
                    for(int d=c+1;d<len;d++){
                        if(nums[a] + nums[b] + nums[c] == nums[d]){
                            count++;
                        }
                    }
                }
            }
        }
        return count;
    }
}
```



### Approach 2-使用哈希表存储nums[d]-O(n^3)
#### Analysis

参考 `leetcode-cn` 官方题解。




#### Solution

```java
class Solution {
    public int countQuadruplets(int[] nums) {
        int n = nums.length;
        int ans = 0;
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        for (int c = n - 2; c >= 2; --c) {
            //使用map存储nums[d]
            cnt.put(nums[c + 1], cnt.getOrDefault(nums[c + 1], 0) + 1);
            for (int a = 0; a < c; ++a) {
                for (int b = a + 1; b < c; ++b) {
                    //nums[a] + nums[b] + nums[c] == nums[d]
                    //满足上述等式的d 取值范围在 [c+1,n-1] 
                    //逆序遍历c  从 c+1 减小到 c 时，d 的取值范围中多了 c+1 这一项，而其余的项不变
                    ans += cnt.getOrDefault(nums[a] + nums[b] + nums[c], 0);
                }
            }
        }
        return ans;
    }
}
```




### Approach 3-使用哈希表存储nums[d]-nms[c]-O(n^2)
#### Analysis

参考 `leetcode-cn` 官方题解。




#### Solution

```java
class Solution {
    //nums[a] + nums[b] = nums[d] − nums[c]
    //使用哈希表存储 nums[d] − nums[c]
    public int countQuadruplets(int[] nums) {
        int n = nums.length;
        int ans = 0;
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        //逆序取b
        for (int b = n - 3; b >= 1; --b) {
            //在 b 减小的过程中，c 的取值范围是逐渐增大的：即从 b+1 减小到 b 时，c 的取值范围中多了 b+1 这一项，而其余的项不变
            //因此我们只需要将所有满足 c=b+1 且 d>c 的 c,d 对应的 nums[d]−nums[c] 加入哈希表即可。
            for (int d = b + 2; d < n; ++d) {
                //c=b+1
                cnt.put(nums[d] - nums[b + 1], cnt.getOrDefault(nums[d] - nums[b + 1], 0) + 1);
            }
            for (int a = 0; a < b; ++a) {
                ans += cnt.getOrDefault(nums[a] + nums[b], 0);
            }
        }
        return ans;
    }
}
```


## 6. Z 字形变换
### Description
* [LeetCode-6. Z 字形变换](https://leetcode-cn.com/problems/zigzag-conversion/)


### Approach 1-常规
#### Analysis


参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution{
    public String convert(String s, int numRows) {
        if(numRows < 2){
            return s;
        }
        List<StringBuilder> rows = new ArrayList<StringBuilder>();
        int i = 0; //行索引
        int flag = -1; //方向
        //init
        for(int index=0;index<numRows;index++){
            rows.add(new StringBuilder());
        }
        for(char c : s.toCharArray()){
            rows.get(i).append(c);
            if(i == 0 || i == numRows - 1){
                flag = -flag;
            }
            i += flag;
        }
        StringBuilder res = new StringBuilder();
        for(StringBuilder row : rows){
            res.append(row);
        }
        return res.toString();
    }
}
```