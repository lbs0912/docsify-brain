
# LeetCode Notes-079


[TOC]



## 更新
* 2021/12/28，撰写
* 2022/01/07，完成



## Overview
* 【sql】[LeetCode-596. 超过5名学生的课](https://leetcode-cn.com/problems/classes-more-than-5-students/)
* [LeetCode-581. 最短无序连续子数组](https://leetcode-cn.com/problems/shortest-unsorted-continuous-subarray/description/)
* [LeetCode-75. 颜色分类](https://leetcode-cn.com/problems/sort-colors/description/)
* 【水题】[LeetCode-2011. 执行操作后的变量值](https://leetcode-cn.com/problems/final-value-of-variable-after-performing-operations/description/)
* [LeetCode-1160. 拼写单词](https://leetcode-cn.com/problems/find-words-that-can-be-formed-by-characters/description/)






## 596. 超过5名学生的课
### Description
* 【sql】[LeetCode-596. 超过5名学生的课](https://leetcode-cn.com/problems/classes-more-than-5-students/)

### Approach 1-GROUP BY + HAVING


#### Analysis


参考 `leetcode-cn` 官方题解。

使用 `DISTINCT` 防止在同一门课中学生被重复计算。

#### Solution


```s
SELECT
    class
FROM
    courses
GROUP BY class
HAVING COUNT(DISTINCT student) >= 5
;
```



### Approach 2-GROUP BY + 子查询


#### Analysis


参考 `leetcode-cn` 官方题解。

使用 `DISTINCT` 防止在同一门课中学生被重复计算。

#### Solution



```s
SELECT
    class
FROM
    (SELECT
        class, COUNT(DISTINCT student) AS num
    FROM
        courses
    GROUP BY class) AS temp_table
WHERE
    num >= 5
;
```


-----

```s
SELECT
    class, COUNT(DISTINCT student)
FROM
    courses
GROUP BY class
;
```

上述语句查询后，得到的临时表为


```s
| class    | COUNT(student) |
|----------|----------------|
| Biology  | 1              |
| Computer | 1              |
| English  | 1              |
| Math     | 6              |

```

## 581. 最短无序连续子数组
### Description
* [LeetCode-581. 最短无序连续子数组](https://leetcode-cn.com/problems/shortest-unsorted-continuous-subarray/description/)

### Approach 1-常规


#### Analysis

参考 `leetcode-cn` 官方题解。


1. 拷贝一份数组并对其排序，注意使用深拷贝。
2. 对排序后的数组 `numsSorted` 和原数组 `nums` 进行遍历，发现其最长公共前缀 [0,left] 和最长公共后缀 [right,len-1]
3. 则所需答案为 `right - left + 1`


复杂度分析
* 时间复杂度：`O(nlogn)`
* 空间复杂度：`O(n)`


#### Solution




```java
class Solution {
    public int findUnsortedSubarray(int[] nums) {

        int length = nums.length;
        //int[] copyNums = nums; //浅拷贝
        //执行数组深拷贝
        int[] numsSorted = new int[nums.length];
        System.arraycopy(nums, 0, numsSorted, 0,length);
        Arrays.sort(numsSorted);

        int left = 0;
        //添加 left < length 防止数组越界（数组本身升序时会产生越界）
        while(left < length && nums[left] == numsSorted[left]){
            left++;
        }
        if(left == length){
            return 0;  //本身升序
        }
        int right = nums.length - 1;
        while(right >=0 && nums[right] == numsSorted[right]){
            right--;
        }
        return right - left + 1;
    }
}
```

### Approach 2-双指针


#### Analysis

参考 `leetcode-cn` 官方题解。

ref
* https://leetcode-cn.com/problems/shortest-unsorted-continuous-subarray/solution/java-shuang-zhi-zhen-dai-ma-jian-ji-yi-d-pfn5/
* 

复杂度分析
* 时间复杂度：`O(n)`
* 空间复杂度：`O(1)`


#### Solution




```java
class Solution {
    public int findUnsortedSubarray(int[] nums) {
        int len = nums.length;
        int left = 0; //左边界
        int right = len - 1; //右边界
        int max = nums[left];
        int min = nums[right];

        //根据最大值关系确定左边界left
        for(int i=0;i<len;i++){
            if(max > nums[i]){
                //如果最大值比当前值还大  说明当前值位置错乱了 更新左边界位置
                left = i;
            } else {
                max = nums[i];
            }
        }

        //根据最小值关系确定右边界right
        for(int j=len-1;j>=0;j--){
            if(min < nums[j]){
                //如果当前值比最小值还小  说明当前值位置错乱了 更新右边界位置
                right = j;
            } else {
                min = nums[j];
            }
        }
    
        //数组本身有序  指针未移动
        if(left == 0 && right == len - 1){
            return 0;
        }
        return left - right + 1; //注意 上述移动过程中 将left移动到了最右边 right移动到了最左边  所以最后是 left-right  不是right-left
    }
}
```



## 75. 颜色分类
### Description
* [LeetCode-75. 颜色分类](https://leetcode-cn.com/problems/sort-colors/description/)

### Approach 1-常规


#### Analysis

参考 `leetcode-cn` 官方题解。

统计出三种颜色的个数。


#### Solution


```java
class Solution {
    public void sortColors(int[] nums) {
        int redCount = 0;
        int whiteCount = 0;
        for(int i=0;i<nums.length;i++){
            if(nums[i] == 0){
                redCount++;
            } else if(nums[i] == 1){
                whiteCount++;
            }
        }

        for(int i=0;i<nums.length;i++){
            if(i < redCount){
               nums[i] = 0;
            } else if(i - redCount < whiteCount){
                nums[i] = 1;
            } else{
                nums[i] = 2;
            }
        }
    }
}
```





### Approach 2-双指针


#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution

```java
class Solution {
    public void sortColors(int[] nums) {

        // all in [0,p0) == 0
        // all in [p0,i) == 1
        // all in [p2,len) == 2
        int p0 = 0;
        int p2 = nums.length - 1;
        int i = 0;
        while(i <= p2){
            if(nums[i] == 0){
                swap(nums,i,p0);
                p0++;
                i++;
            } else if(nums[i] == 2){
                swap(nums,i,p2);
                p2--;  //交换之后 nums[i]的值未知 需重新进行判断 故不执行i++
            } else { //nums[i] ==  1
                i++;
            }
        }
    }

    private void swap(int[] nums,int index1,int index2){
        int temp = nums[index1];
        nums[index1] = nums[index2];
        nums[index2] = temp;
    }
}
```



## 1160. 拼写单词
### Description
* [LeetCode-1160. 拼写单词](https://leetcode-cn.com/problems/find-words-that-can-be-formed-by-characters/description/)

### Approach 1-常规


#### Analysis

参考 `leetcode-cn` 官方题解。

哈希表计数。


#### Solution

```java
class Solution {
    public int countCharacters(String[] words, String chars) {
        Map<Character,Integer> charMap = new HashMap<>();
        for(char c:chars.toCharArray()){
            charMap.put(c,1+charMap.getOrDefault(c, 0));
        }

        int total = 0;
        boolean containFlag = true;
        for(String word:words){
            containFlag = true;
            Map<Character,Integer> wordMap = new HashMap<>();
            for(char c:word.toCharArray()){
                wordMap.put(c,1+wordMap.getOrDefault(c, 0));
            }
            for(Map.Entry<Character,Integer> entry:wordMap.entrySet()){
                //chars 中的每个字母都只能用一次
                if(!(charMap.containsKey(entry.getKey()) && entry.getValue() <= charMap.get(entry.getKey()))){
                    containFlag = false;
                    break;
                }
            }
            if(containFlag){
                total += word.length();
            }
        }
        return total;
    }
}
```



## 【水题】2011. 执行操作后的变量值
### Description
* 【水题】[LeetCode-2011. 执行操作后的变量值](https://leetcode-cn.com/problems/final-value-of-variable-after-performing-operations/description/)

### Approach 1-常规


#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public int finalValueAfterOperations(String[] operations) {
        int count = 0;
        for(String str:operations){
            if(str.equals("++X") || str.equals("X++")){
                count++;
            } else {
                count--;
            }
        }
        return count;
    }
}
```