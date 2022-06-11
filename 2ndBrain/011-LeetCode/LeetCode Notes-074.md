
# LeetCode Notes-074


[TOC]



## 更新
* 2021/12/19，撰写
* 2021/12/20，完成



## Overview
* [LeetCode-49. 字母异位词分组](https://leetcode-cn.com/problems/group-anagrams/)
* 【经典好题】[LeetCode-494. 目标和](https://leetcode-cn.com/problems/target-sum/)
* [LeetCode-64. 最小路径和](https://leetcode-cn.com/problems/minimum-path-sum/description/)
* [LeetCode-62. 不同路径](https://leetcode-cn.com/problems/unique-paths/description/)
* [LeetCode-63. 不同路径 II](https://leetcode-cn.com/problems/unique-paths-ii/description/)




## 49. 字母异位词分组
### Description
* [LeetCode-49. 字母异位词分组](https://leetcode-cn.com/problems/group-anagrams/)

### Approach 1-排序
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public List<List<String>> groupAnagrams(String[] strs) {
        Map<String,List<String>> map = new HashMap<>();
        for(String str:strs){
            String key = getOrderedStr(str);
            if(map.containsKey(key)){
                map.get(key).add(str);
            } else{
                List<String> list = new ArrayList<>();
                list.add(str);
                map.put(key,list);
            }
        }
        List<List<String>> resList = new ArrayList<>();
        for(Map.Entry<String,List<String>> entry:map.entrySet()){
            resList.add(entry.getValue());
        }
        return resList;

    }

    private String getOrderedStr(String str){
        char[] ar = str.toCharArray();
        Arrays.sort(ar);
        return String.valueOf(ar);
    }
}
```



* 官方代码简洁版

使用 `map.values()` 直接取出 map 的值。


```java
class Solution {
    public List<List<String>> groupAnagrams(String[] strs) {
        Map<String, List<String>> map = new HashMap<String, List<String>>();
        for (String str : strs) {
            char[] array = str.toCharArray();
            Arrays.sort(array);
            String key = new String(array);
            List<String> list = map.getOrDefault(key, new ArrayList<String>());
            list.add(str);
            map.put(key, list);
        }
        return new ArrayList<List<String>>(map.values());
    }
}
```




## 【经典好题】494. 目标和
### Description
* 【经典好题】[LeetCode-494. 目标和](https://leetcode-cn.com/problems/target-sum/)

### Approach 1-DFS
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    private int count = 0;
    public int findTargetSumWays(int[] nums, int target) {
        int len = nums.length;
        int sum = 0;
        dfs(nums,0,len,target,sum+nums[0],"+");
        dfs(nums,0,len,target,sum-nums[0],"-");

        return count;
    }

    private void dfs(int[] nums,int index,int len,int target,int sum,String operator){
        if(index == len-1){
            if(sum == target){
                count++;
            }
            return;
        }
        dfs(nums,index+1,len,target,sum+nums[index+1],"+");
        dfs(nums,index+1,len,target,sum-nums[index+1],"-");

    }
}
```


## 64. 最小路径和
### Description
* [LeetCode-64. 最小路径和](https://leetcode-cn.com/problems/minimum-path-sum/description/)

### Approach 1-动态规划
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public int minPathSum(int[][] grid) {
        int row = grid.length;
        int column = grid[0].length;

        int[][] dp = new int[row][column];
        dp[0][0] = grid[0][0];
        //边界条件
        for(int i=1;i<row;i++){
            dp[i][0] = dp[i-1][0] + grid[i][0]; 
        }
        for(int j=1;j<column;j++){
            dp[0][j] = dp[0][j-1] + grid[0][j]; 
        }
  
        //dp
        for(int i=1;i<row;i++){
            for(int j=1;j<column;j++){
                dp[i][j] = grid[i][j] + Math.min(dp[i][j-1], dp[i-1][j]);
            }
        }
        return dp[row-1][column-1];
    }
}
```





## 62. 不同路径
### Description
* [LeetCode-62. 不同路径](https://leetcode-cn.com/problems/unique-paths/description/)

### Approach 1-动态规划
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public int uniquePaths(int m, int n) {
        int[][] dp = new int[m][n];
        dp[0][0] = 1;
        //边界条件
        for(int i=1;i<m;i++){
            dp[i][0] = 1; 
        }
        for(int j=1;j<n;j++){
            dp[0][j] = 1; 
        }
        //dp
        for(int i=1;i<m;i++){
            for(int j=1;j<n;j++){
                dp[i][j] = dp[i][j-1] + dp[i-1][j];
            }
        }
        return dp[m-1][n-1];
    }
}
```



## 63. 不同路径 II
### Description
* [LeetCode-63. 不同路径 II](https://leetcode-cn.com/problems/unique-paths-ii/description/)

### Approach 1-动态规划
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution




```java
class Solution {
    public int uniquePathsWithObstacles(int[][] obstacleGrid) {
        int row = obstacleGrid.length;
        int column = obstacleGrid[0].length;

        int[][] dp = new int[row][column];
        dp[0][0] = obstacleGrid[0][0] == 1 ? 0:1;
        //边界条件
        for(int i=1;i<row;i++){
            dp[i][0] =  (obstacleGrid[i][0] == 1)? 0:dp[i-1][0];
        }
        for(int j=1;j<column;j++){
            dp[0][j] =  (obstacleGrid[0][j] == 1)? 0:dp[0][j-1];
        }
        //dp
        for(int i=1;i<row;i++){
            for(int j=1;j<column;j++){
                if(obstacleGrid[i][j] == 1){
                    dp[i][j] = 0;
                } else {
                    dp[i][j] = dp[i][j-1] +  dp[i-1][j];
                }
            }
        }
        return dp[row-1][column-1];

    }
}
```



