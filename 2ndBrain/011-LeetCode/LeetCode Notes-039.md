# LeetCode Notes-039


[TOC]



## 更新
* 2021/07/08，撰写
* 2021/07/16，完成


## Overview
* [LeetCode-1422. 分割字符串的最大得分](https://leetcode-cn.com/problems/maximum-score-after-splitting-a-string/description/)
* [LeetCode-1351. 统计有序矩阵中的负数](https://leetcode-cn.com/problems/count-negative-numbers-in-a-sorted-matrix/description/)
* [LeetCode-671. 二叉树中第二小的节点](https://leetcode-cn.com/problems/second-minimum-node-in-a-binary-tree/description/)
* [LeetCode-724. 寻找数组的中心下标](https://leetcode-cn.com/problems/find-pivot-index/)
* [LeetCode-697. 数组的度](https://leetcode-cn.com/problems/degree-of-an-array/)






## 1422. 分割字符串的最大得分
### Description
* [LeetCode-1422. 分割字符串的最大得分](https://leetcode-cn.com/problems/maximum-score-after-splitting-a-string/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int maxScore(String s) {
        int max = 0;
        int length = s.length();
        //arr[i][0] 表示从0~i范围内，字符串0的个数 
        //arr[i][1] 表示从0~i范围内，字符串1的个数
        int[][] arr = new int[length][2];   
        for(int i=0;i<length;i++){
            char c = s.charAt(i);
            if('1' == c){
                if(i == 0){
                    arr[i][1] = 1;
                } else{
                    arr[i][1] = 1 + arr[i-1][1];
                    arr[i][0] = arr[i-1][0];
                }
            } else {
                if(i == 0){
                    arr[i][0] = 1;
                } else{
                    arr[i][0] = 1 + arr[i-1][0];
                    arr[i][1] = arr[i-1][1];
                }
            }
        }

        for(int i=0;i<length-1;i++){ //由于字符串不能为空 故循环终止条件为length-1
            max = Math.max(max,arr[i][0] + (arr[length-1][1] - arr[i][1]));
        }
        return max;
    }
}
```



## 1351. 统计有序矩阵中的负数
### Description
* [LeetCode-1351. 统计有序矩阵中的负数](https://leetcode-cn.com/problems/count-negative-numbers-in-a-sorted-matrix/description/)

### Approach 1-暴力
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int countNegatives(int[][] grid) {
        int num = 0;
        int m = grid.length;
        int n = grid[0].length;
        for(int i=0;i<m;i++){
            for(int j=0;j<n;j++){
                if(grid[i][j] < 0){
                    num += (n-j);
                    break;
                }
            }
        }
        return num;

    }
}
```


### Approach 2-倒遍历
#### Analysis

参考 `leetcode-cn` 官方题解。


在方法1的基础上，继续优化。

整个矩阵是每行每列均非递增，这说明了一个更重要的性质：每一行从前往后第一个负数的位置是不断递减的，即我们设第 `i` 行的第一个负数的位置为 `pos_i`，不失一般性，我们把一行全是正数的 `pos` 设为 `m`，则

```s
pos_0 >= pos_1 >= pos_2 >= ... >= pos_(n-1)
```

因此，对于列，可以进行倒遍历，如第 `i` 行的最后一个非负的索引为 `j`，则第 `i+1` 行的最后一个非负索引范围一定是在 `[0,j]` 范围内。

#### Solution



```java
class Solution {
    public int countNegatives(int[][] grid) {
        int num = 0;
        int m = grid.length;
        int n = grid[0].length;
        int j = n-1;
        for(int i=0;i<m;i++){
            while(j>=0){
                if(grid[i][j] >= 0){
                    break;
                }
                j--;
            }
            num += (n-1-j);
        }
        return num;
    }
}
```
## 671. 二叉树中第二小的节点
### Description
* [LeetCode-671. 二叉树中第二小的节点](https://leetcode-cn.com/problems/second-minimum-node-in-a-binary-tree/description/)

### Approach 1-暴力
#### Analysis

参考 `leetcode-cn` 官方题解。

通过深度优先搜索遍历树，并使用集合结构唯一性记录树中的每个唯一值。然后，我们将查看第二个最小值的记录值。

可以使用 `TreeSet` 数据结构，参考 [Java中HashSet和TreeSet的区别 |CSDN](https://blog.csdn.net/u013709270/article/details/53670956)。

> TreeSet是SortedSet接口的唯一实现类，TreeSet可以确保集合元素处于排序状态。TreeSet支持两种排序方式，自然排序和定制排序。
>
> TreeSet 是二差树实现的，Treeset中的数据是自动排好序的，不允许放入 null 值。
>
> HashSet 是哈希表实现的，HashSet中的数据是无序的，可以放入null，但只能放入一个null，两者中的值都不能重复，就如数据库中唯一约束。HashSet要求放入的对象必须实现HashCode()方法，放入的对象，是以 hashcode 码作为标识的，而具有相同内容的 String 对象，hashcode 是一样，所以放入的内容不能重复。但是同一个类的对象可以放入不同的实例。



复杂度分析
* 时间复杂度：`O(N)`。其中 N 是给定树中的节点总数。我们只访问每个节点一次。
* 空间复杂度：`O(N)`。
 

#### Solution

```java
class Solution {
    public int findSecondMinimumValue(TreeNode root){
        TreeSet<Integer> set  = new TreeSet<>();
        dfs(root,set);
        if(set.size() < 2){
            return -1;
        }
        ArrayList<Integer> list = new ArrayList<>(set);  //由于TreeSet本身已经有序，此处可以优化
        return list.get(1);
    }

    public void dfs(TreeNode node,TreeSet<Integer> set){
        if(null == node){
            return;
        }
        set.add(node.val);
        dfs(node.left,set);
        dfs(node.right,set);
    }
}
```


使用 `TreeSet` 优化后的代码如下。

```java
class Solution {
    public int findSecondMinimumValue(TreeNode root){
        TreeSet<Integer> set  = new TreeSet<>();
        dfs(root,set);
        if(set.size() < 2){
            return -1;
        }
        set.pollFirst();   //TreeNode本身有序 升序排列  返回第2个元素
        return  set.pollFirst();
    }

    public void dfs(TreeNode node,TreeSet<Integer> set){
        if(null == node){
            return;
        }
        set.add(node.val);
        dfs(node.left,set);
        dfs(node.right,set);
    }
}
```



### Approach 2-分析题目条件
#### Analysis

参考 `leetcode-cn` 官方题解。

本题中，二叉树有 `root.val = min(root.left.val, root.right.val)` 的性质。



> 分析题意，可知题目中的树，其实是一个**最小堆**，返回树的第2小的元素，即返回除堆顶元素外的最小的元素。


因此，让 `min = root.val`。当遍历结点 `node`，如果 `node.val > min1`，我们知道在 `node` 处的子树中的所有值都至少是 `node.val`，因此在该子树中不此存在第二个最小值。因此，我们不需要搜索这个子树。

此外，由于我们只关心第二个最小值 `ans`，因此我们不需要记录任何大于当前第二个最小值的值，因此与方法 1 不同，我们可以完全不用集合存储数据。

复杂度分析
* 时间复杂度：`O(N)`。其中 `N` 是给定树中的节点总数。我们最多访问每个节点一次。
* 空间复杂度：`O(N)`，存储在 `ans` 和 `min1` 中的信息为 `O(1)`，但我们的深度优先搜索可能会在调用堆栈中存储多达 `O(h) = O(N)` 的信息，其中 `h` 是树的高度。


#### Solution 



```java
class Solution {
    public int findSecondMinimumValue(TreeNode root) {
        return findSecond(root);
    }
    public int findSecond(TreeNode root){
        if(null == root || null == root.left){ //若没有节点则不存在第二小的数
            //子节点只可能为0或者2
            return -1;
        }
        if(root.val == root.left.val && root.val == root.right.val){ //根节点和两子节点值相等，递归返回两子节点各第二小的值，并取其最小值
            int leftMinVal = findSecond(root.left);
            int rightMinVal = findSecond(root.right);
            if(leftMinVal == -1){
                return  rightMinVal;
            }
            if(rightMinVal == -1){
                return  leftMinVal;
            }
            return Math.min(leftMinVal, rightMinVal);
        }
        //除了以上情况之外的简单判断
        if(root.val == root.left.val){
            if(findSecond(root.left) == -1) return root.right.val;
            return Math.min(root.right.val,findSecond(root.left));
        }else {
            if(findSecond(root.right)== -1)return root.left.val;
            return Math.min(root.left.val,findSecond(root.right));
        }           
    }
}
```





## 724. 寻找数组的中心下标
### Description
* [LeetCode-724. 寻找数组的中心下标](https://leetcode-cn.com/problems/find-pivot-index/)


本题同 [LeetCode-1991. 找到数组的中间位置](https://leetcode-cn.com/problems/find-the-middle-index-in-array/description/)。


### Approach 1-前缀和
#### Analysis

参考 `leetcode-cn` 官方题解。


记数组的全部元素之和为 `total`，当遍历到第 `i` 个元素时，设其左侧元素之和为 `sum`，则其右侧元素之和为 `total−nums 
i−sum`。左右侧元素相等即为 `sum=total−numsi−sum`，即 `2×sum+nums 
i=total`。

当中心索引左侧或右侧没有元素时，即为零个项相加，这在数学上称作「空和」。在程序设计中我们约定「空和是零」。


#### Solution


* 我的版本

```java
class Solution {
    public int pivotIndex(int[] nums) {
        int length = nums.length;
        if(-1 == length){
            return -1;
        }
        //前缀和
        int[] preFixSumArr = new int[length];
        preFixSumArr[0] = nums[0]; 
        for(int i=1;i<length;i++){
            preFixSumArr[i] = preFixSumArr[i-1] + nums[i]; 
        }
        //左侧元素判断
        //由于要返回最靠近左边的中心坐标 因此最右侧元素最后判断
        if(0 == preFixSumArr[length-1] - preFixSumArr[0]){
            return 0;
        }
        int totalSum = preFixSumArr[length-1];
        for(int i=1;i<length-1;i++){
            if(preFixSumArr[i-1] == totalSum - preFixSumArr[i]){
                return i;
            }
        }
        //右侧元素判断
        if(preFixSumArr[length-2] == 0){
            return length-1;
        }
        return -1;
    }
}
```

* 官方优化版本：**没必要分两次遍历数组，在前缀和数组求解过程中即可进行判断。**


```java
class Solution {
    public int pivotIndex(int[] nums) {
        int total = Arrays.stream(nums).sum();
        int sum = 0;
        for (int i = 0; i < nums.length; ++i) {
            if (2 * sum + nums[i] == total) {
                return i;
            }
            sum += nums[i];
        }
        return -1;
    }
}
```



* 前缀和+后缀和



```java
class Solution {
    public int findMiddleIndex(int[] nums) {
        int len = nums.length;
        int[] prefixSum = new int[len]; //前缀和
        int[] suffixSum = new int[len]; //后缀和
        for(int i=0;i<len;i++){
            prefixSum[i] = nums[i] + prefixSum[Math.max(0,i-1)];
            suffixSum[len-1-i] = nums[len-1-i] + suffixSum[Math.min(len-1,len-i)];
        }
        for(int i=0;i<len;i++){
            if(prefixSum[i] == suffixSum[i]){
                return i;
            }
        }
        return -1; //无符合要求的
    }
}
```



## 697. 数组的度
### Description
* [LeetCode-697. 数组的度](https://leetcode-cn.com/problems/degree-of-an-array/)

### Approach 1-哈希表
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

* 自我实现版本

哈希表中没有记录元素出现的第一次和最后一次位置，导致后续需要遍历数组。可参考官方版本进行优化。

```java
class Solution {
    public int findShortestSubArray(int[] nums) {
        int minLength = nums.length;
        Map<Integer,Integer> occuranceMap = new HashMap<>();
        int maxOccurance = 1; //记录最大出现的次数
        Set<Integer> set = new HashSet<>(); //存储最大出现次数对应的元素 会有多个
        for(int num:nums){
            occuranceMap.put(num,occuranceMap.getOrDefault(num, 0)+1);
            if(maxOccurance > occuranceMap.get(num)){
                continue;
            }
            if(maxOccurance < occuranceMap.get(num)){  
                set.clear();
            } 
            maxOccurance = occuranceMap.get(num);
            set.add(num);
        }
        if(maxOccurance == 1){
            return 1;
        }

        //Set遍历
        // 方法1
        // Iterator<Integer> it = set.iterator();
        // while(it.hasNext()){ ... }
        // 方法2
        // for(String val:set){ ... }

    



        Iterator<Integer> it = set.iterator();
        while(it.hasNext()){
            Integer val = it.next();
            int begin = -1; //元素最先出现的索引
            int end = -1;  //元素最后出现的索引
            for(int i = 0; i < nums.length;i++){
                if(nums[i] == val && begin ==  -1){
                    begin = i;
                    break;
                }
            }
            for(int i = nums.length-1; i > begin;i--){
                if(nums[i] == val && end ==  -1){
                    end = i;
                    break;
                }
            }
            minLength = Math.min(minLength,(end-begin+1));

            
        }
        return minLength;

    }
}
```


* 官方实现版本

使用哈希表实现该功能，**每一个数映射到一个长度为 3 的数组，数组中的三个元素分别代表这个数出现的次数、这个数在原数组中第一次出现的位置和这个数在原数组中最后一次出现的位置。** 当我们记录完所有信息后，我们需要遍历该哈希表，找到元素出现次数最多，且前后位置差最小的数。

```java
class Solution {
    public int findShortestSubArray(int[] nums) {
        Map<Integer, int[]> map = new HashMap<Integer, int[]>();
        int n = nums.length;
        for (int i = 0; i < n; i++) {
            if (map.containsKey(nums[i])) {
                map.get(nums[i])[0]++;
                map.get(nums[i])[2] = i;
            } else {
                map.put(nums[i], new int[]{1, i, i});
            }
        }
        int maxNum = 0, minLen = 0;
        for (Map.Entry<Integer, int[]> entry : map.entrySet()) {
            int[] arr = entry.getValue();
            if (maxNum < arr[0]) {
                maxNum = arr[0];
                minLen = arr[2] - arr[1] + 1;
            } else if (maxNum == arr[0]) {
                if (minLen > arr[2] - arr[1] + 1) {
                    minLen = arr[2] - arr[1] + 1;
                }
            }
        }
        return minLen;
    }
}
```



