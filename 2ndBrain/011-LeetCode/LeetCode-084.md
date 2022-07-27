
# LeetCode Notes-084


[TOC]



## 更新
* 2022/06/10，撰写
* 2022/06/10，完成



## 总览
* [LeetCode-剑指 Offer II 105. 岛屿的最大面积](https://leetcode.cn/problems/ZL6zAn/)
* [LeetCode-147. 对链表进行插入排序](https://leetcode.cn/problems/insertion-sort-list/)
* [LeetCode-剑指 Offer 53 - I. 在排序数组中查找数字 I](https://leetcode.cn/problems/zai-pai-xu-shu-zu-zhong-cha-zhao-shu-zi-lcof/)
* [LeetCode-1143. 最长公共子序列](https://leetcode.cn/problems/longest-common-subsequence/)
* [LeetCode-4. 在排序数组中查找元素的第一个和最后一个位置](https://leetcode.cn/problems/find-first-and-last-position-of-element-in-sorted-array/)




## 【经典好题】剑指 Offer II 010. 和为 k 的子数组

### Description

* [LeetCode-剑指 Offer II 010. 和为 k 的子数组](https://leetcode.cn/problems/QTMn0o/)

### Approach 1-前缀和

#### Analysis


参考 `leetcode-cn` 官方题解。



#### Solution

```java
public class Solution {
    public int subarraySum(int[] nums, int k) {
        int count = 0, pre = 0;
        //key为前缀和 value为前缀和出现的次数
        HashMap < Integer, Integer > mp = new HashMap < > ();
        mp.put(0, 1); //插入前缀和=0 出现次数=1 方便后续计算
        for (int i = 0; i < nums.length; i++) {
            pre += nums[i];
            if (mp.containsKey(pre - k)) {
                count += mp.get(pre - k);
            }
            mp.put(pre, mp.getOrDefault(pre, 0) + 1);
        }
        return count;
    }
}
```



## 剑指 Offer II 105. 岛屿的最大面积

### Description

* [LeetCode-剑指 Offer II 105. 岛屿的最大面积](https://leetcode.cn/problems/ZL6zAn/)

### Approach 1-动态规划 

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution

```java
class Solution {
    public int maxAreaOfIsland(int[][] grid) {
        int ans = 0;
        for(int i=0;i<grid.length;i++){
            for(int j=0;j<grid[0].length;j++){
                //对每一个点[i,j] 进行广度优先遍历
                ans = Math.max(ans,dfs(grid,i,j));
            }
        }
        return ans;
    }

    public int dfs(int[][] grid,int i,int j){
        //边界条件
        if(i < 0 || j< 0 || i == grid.length || j == grid[0].length || grid[i][j] != 1){
            return 0;
        }
      
        // 左(0,1) 右(0,-1)  下(1,0)  上(-1,0)
        int[] di = {0,0,1,-1};
        int[] dj = {1,-1,0,0};

        int ans = 1; //因为grid[i][j] =1 所以记录 ans=1
        
        //设为0  标记已经访问过了   
        grid[i][j] = 0;
    
        for(int index=0;index<4;index++){
            int next_i = i + di[index];
            int next_j = j + dj[index];
            ans += dfs(grid, next_i, next_j);
        }
        return ans;
    }
}
```



## 72. 编辑距离
### Description

* [LeetCode-72. 编辑距离](https://leetcode.cn/problems/edit-distance/)

### Approach 1-动态规划 

#### Analysis


参考 `leetcode-cn` 官方题解。


本质不同的操作实际上只有三种
1. 在单词 A 中插入一个字符；
2. 在单词 B 中插入一个字符；
3. 修改单词 A 的一个字符


#### Solution


```java
class Solution {
    public int minDistance(String word1, String word2) {
        int len1 = word1.length();
        int len2 = word2.length();

        // 有一个字符串为空串
        if (len1 * len2 == 0) {
            return len1 + len2;
        }

        // DP 数组
        int[][] dp = new int[len1 + 1][len2 + 1];

        // 边界状态初始化
        for (int i = 0; i < len1 + 1; i++) {
            dp[i][0] = i;
        }
        for (int j = 0; j < len2 + 1; j++) {
            dp[0][j] = j;
        }

        // 计算所有 DP 值
        for (int i = 1; i < len1 + 1; i++) {
            for (int j = 1; j < len2 + 1; j++) {
                int left = dp[i - 1][j] + 1;
                int down = dp[i][j - 1] + 1;
                int left_down = dp[i - 1][j - 1];
                if (word1.charAt(i - 1) != word2.charAt(j - 1)) {
                    left_down += 1;
                }
                dp[i][j] = Math.min(left, Math.min(down, left_down));
            }
        }
        return dp[len1][len2];
    }
}
```


## 147. 对链表进行插入排序
### Description

* [LeetCode-147. 对链表进行插入排序](https://leetcode.cn/problems/insertion-sort-list/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。



#### Solution



```java
class Solution {
    public ListNode insertionSortList(ListNode head) {
        if(head ==  null || head.next == null){
            return head;
        }
        ListNode dummyHead = new ListNode(0);
        dummyHead.next = head;
        ListNode lastSorted = head; //已排序的区间的最后一个节点
        ListNode currentNode = head.next; //当前节点
        while(currentNode != null){
            if(lastSorted.val <= currentNode.val){
                //已经有序 增加已排序区间 lastSorted向后移动
                lastSorted = lastSorted.next;
            } else {
                ListNode prev = dummyHead;
                while(prev.next.val <= currentNode.val){
                    prev = prev.next;
                }
                // | prev| ... | lastSorted| currentNode | -> | prev| currentNode| ... |  lastSorted |
                // |2,3(prev) | 7(...)| 8(lastSorted) | 4 | -> |2,3(prev) | 4| 7(...) | 8(lastSorted) |
                lastSorted.next = currentNode.next;
                currentNode.next = prev.next;
                prev.next = currentNode;
            }
            currentNode = lastSorted.next;
        }
        return dummyHead.next;
    }
}
```


## 剑指 Offer 53 - I. 在排序数组中查找数字 I
### Description

* [LeetCode-剑指 Offer 53 - I. 在排序数组中查找数字 I](https://leetcode.cn/problems/zai-pai-xu-shu-zu-zhong-cha-zhao-shu-zi-lcof/)

### Approach 1-二分法

#### Analysis


参考 `leetcode-cn` 官方题解。

强烈建议，此题观看官方视频讲解。

#### Solution

```java
class Solution {
    public int search(int[] nums, int target) {
        int len = nums.length;

        if(len == 0 || nums[0] > target || nums[len-1] < target){
            return 0;
        }
        //搜索左边界
        int leftIndex = findLeftPosition(nums,target);

        if(leftIndex == -1){
            return 0;
        }
        //搜索右边界
        int rightIndex = findRightPosition(nums,target);
        return rightIndex - leftIndex + 1;
    }

    public int findLeftPosition(int[] nums, int target){
        int low = 0;
        int high = nums.length -1;
        while(low < high){
            int mid = (low + high)/2;
            if(nums[mid] < target){
                //[mid+1,high]
                low = mid + 1;
            } else if(nums[mid] == target) {
                //[low, mid]  mid有可能是左边界
                high = mid;
            } else {
                //nums[mid] > target
                //[low, mid-1]
                high = mid -1;
            }
        }
        //结束while循环时 low = high
        if(nums[low] == target){
            return low;
        }
        return -1;
    }
               
     public int findRightPosition(int[] nums, int target){
        int low = 0;
        int high = nums.length -1;
        while(low < high){
            int mid = (low + high + 1)/2;  //向上取整
            if(nums[mid] < target){
                //[mid+1,high]
                low = mid + 1;
            } else if(nums[mid] == target) {
                //[mid, left]  mid有可能是右边界
                low = mid;
            } else {
                //nums[mid] > target
                //[low, mid-1]
                high = mid-1;
            }
        }
        //结束while循环时 low = high
        if(nums[low] == target){
            return low;
        }
        return -1;
    }
}
```

#### Tip

上述代码，有几处需要注意。

> 向上取整


```java
public int findRightPosition(int[] nums, int target){
    int low = 0;
    int high = nums.length -1;
    while(low < high){
        int mid = (low + high + 1)/2;  //向上取整
        ...     
    }
}
```


`findRightPosition` 右边界判断这里，在计算 `mid` 的时候，使用了向上取整，否则会出现死循环。此处，以 `nums = [5,7,7,8,8,10]`，`target=8` 为例进行说明，若不采用向上取整，使用 `mid = (low+high)/2`。
* 第 1 次查找时，区间为 `[0,5]`，mid = 2
* 第 2 次查找时，区间为 `[3,5]`，mid = 4
* 第 3 次查找时，区间为 `[4,5]`，mid = 4
* 第 4 次查找时，区间为 `[4,5]`，mid = 4
* ... 
* 产生了死循环


> 向上取整后可能造成 `low > high`

上述代码中，在右边界判断时，对 mid 进行了向上取整，会有可能造成 `low > high` 的情况，以 `nums = [2,2]`，`target=3` 为例进行说明。
* 第 1 次查找时，区间为 `[0,1]`，mid = 0
* 第 2 次查找时，区间为 `[1,1]`，mid = 1
* while 循环结束时，`low = 2`，`high = 1`，这会导致数组越界访问


数组越界访问，只在找不到左右边界（即数组中不存在 `target` ）时候存在。上述代码中，因为先判断了左边界是否存在，若存在，才会执行有边界的判断，所以上述代码不会产生数组越界异常。但是在本文下面的「LeetCode-4. 在排序数组中查找元素的第一个和最后一个位置」题目中，`target` 是有可能不在数组中的。

所以，更安全更合理的写法为

```java
//结束while循环时 low >= high
if(low <= high && nums[low] == target){
    return low;
}

//或者使用high进行判断
if(nums[high] == target){
    return low;
}
```





> `nums[mid] == target` 时，左右边界的处理


上述代码中，寻找左边界和寻找有边界两个函数，最大的不同处是在 `nums[mid] == target` 时的处理，注意理解和体会。


> 分支简化


上述代码中，寻找左边界中 `if ... else ...` 为三个分支，其实可以合并为两个分支。

```java
//寻找左边界
while(low < high){
    int mid = (low + high)/2;
    if(nums[mid] < target){
        //[mid+1,high]
        low = mid + 1;
    } else if(nums[mid] == target) {
        //[low, mid]  mid有可能是左边界
        high = mid;
    } else {
        //nums[mid] > target
        //[low, mid-1]
        high = mid -1;
    }
}

//上述代码可以合并为两个分支，如下所示
//high = mid -1;  可以改成 high = mid;  
//只是让区间[low,hight]收缩速度变慢点而已
while(low < high){
    int mid = (low + high)/2;
    if(nums[mid] < target){
        //[mid+1,high]
        low = mid + 1;
    } else  {
        //[low, mid]  mid有可能是左边界
        high = mid;
    }
}
```



精简后的完整代码如下。


```java
class Solution {
    public int search(int[] nums, int target) {
        int len = nums.length;

        if(len == 0 || nums[0] > target || nums[len-1] < target){
            return 0;
        }
        //搜索左边界
        int leftIndex = findLeftPosition(nums,target);

        if(leftIndex == -1){
            return 0;
        }
        //搜索右边界
        int rightIndex = findRightPosition(nums,target);
        return rightIndex - leftIndex + 1;
    }

    public int findLeftPosition(int[] nums, int target){
        int low = 0;
        int high = nums.length -1;
        while(low < high){
            int mid = (low + high)/2;
            if(nums[mid] < target){
                //[mid+1,high]
                low = mid + 1;
            } else  {
                //[low, mid]  mid有可能是左边界
                high = mid;
            } 
        }
        //结束while循环时 low = high
        if(nums[low] == target){
            return low;
        }
        return -1;
    }
               
     public int findRightPosition(int[] nums, int target){
        int low = 0;
        int high = nums.length -1;
        while(low < high){
            int mid = (low + high + 1)/2;  //向上取整
            if(nums[mid] <= target){
                //[mid+1,high]
                low = mid;
            } else {
                //nums[mid] > target
                //[low, mid-1]
                high = mid-1;
            }
        }
        //结束while循环时 low = high
        if(nums[low] == target){
            return low;
        }
        return -1;
    }
}
```




### Approach 2-推荐自我实现版本（思路更清晰）

#### Analysis

推荐自我实现版本（思路更清晰）。



在如下自我实现代码版本中，寻找左边界的函数和寻找右边界的函数基本一样，只有两处不同
1. **对 `nums[mid] == target` 的情况**
   * 寻找左边界时候，是 `high = mid`
   * 寻找右边界时候，是 `low = mid`
2. 寻找右边界时候，为了防止死循环，对 `mid` 进行向上取整。当然，也可以在寻找左边界时候，向下取整。

#### Solution


```java
class Solution {
    public int search(int[] nums, int target) {
        if(nums.length == 0 || target > nums[nums.length-1] || target < nums[0]){
            return 0;
        }
        int len = nums.length;
        //寻找左边界
        int leftPosition = findLeftPosition(nums,0,len-1,target);
        
        // System.out.println(leftPosition);

        if(leftPosition == -1){
            return 0;
        }
        //寻找右边界
        int rightPosition = findRightPosition(nums,0,len-1,target);

        // System.out.println(rightPosition);

        return rightPosition - leftPosition + 1;
    }

    //左边界
    private int findLeftPosition(int[] nums, int low,int high,int target){
        while(low  < high){
            int mid = low + (high-low)/2;
            if(nums[mid] == target){
                //注意 因为是寻找左边界，这里不能直接返回 mid
                high = mid;
            } else if(nums[mid] > target){
                high = mid -1;
            } else {
                //nums[mid] < target
                low = mid + 1;
            }
        }
        if(nums[low] == target){
            return low;
        }
        return -1; //找不到的话 返回-1
    }

    //右边界
    private int findRightPosition(int[] nums, int low,int high,int target){
        while(low  < high){
            int mid = low + (high-low + 1)/2;  //向上取整 防止循环  [5,7,7,8,8,10]  8
            // System.out.println(low + " " + mid + " ");
            if(nums[mid] == target){
                //注意 因为是寻找左边界，这里不能直接返回 mid
                low = mid;
            } else if(nums[mid] > target){
                high = mid -1;
            } else {
                //nums[mid] < target
                low = mid + 1;
            }
        }
        //因为本题中仅在寻找到左边界时候才会查找右边节 所以这里一定可以找到  最后return -1 永远走不到 可以直接retrun high
        if(nums[high] == target){
            return high;
        }
        return -1; //找不到的话 返回-1
    }

}
```


## 34. 在排序数组中查找元素的第一个和最后一个位置
### Description

* [LeetCode-4. 在排序数组中查找元素的第一个和最后一个位置](https://leetcode.cn/problems/find-first-and-last-position-of-element-in-sorted-array/)

### Approach 1-二分法

#### Analysis


参考 `leetcode-cn` 官方题解。

此题的解法「LeetCode-剑指 Offer 53 - I. 在排序数组中查找数字 I」，只是返回值不同。

#### Solution



```java
class Solution {
    public int[] searchRange(int[] nums, int target) {
        int[] indexArr = new int[2];
        if(nums.length == 0){
            return new int[]{-1,-1};
        }
        //搜索左边界
        int leftIndex = findLeftPosition(nums,target);
        //搜索右边界
        int rightIndex = findRightPosition(nums,target);
        indexArr[0] = leftIndex;
        indexArr[1] = rightIndex;
        return indexArr;
    }
    
    public int findLeftPosition(int[] nums, int target){
        int low = 0;
        int high = nums.length -1;
        while(low < high){
            int mid = (low + high)/2;
            if(nums[mid] < target){
                //[mid+1,high]
                low = mid + 1;
            } else if(nums[mid] == target) {
                //[low, mid]  mid有可能是左边界
                high = mid;
            } else {
                //nums[mid] > target
                //[low, mid-1]
                high = mid -1;
            }
        }
        //结束while循环时 low = high
        if(nums[low] == target){
            return low;
        }
        return -1;
    }
               
    public int findRightPosition(int[] nums, int target){
        int low = 0;
        int high = nums.length -1;
        while(low < high){
            int mid = (low + high + 1)/2;  //向上取整
            if(nums[mid] < target){
                //[mid+1,high]
                low = mid + 1;
            } else if(nums[mid] == target) {
                //[mid, left]  mid有可能是右边界
                low = mid;
            } else {
                //nums[mid] > target
                //[low, mid-1]
                high = mid-1;
            }
        }
        //结束while循环时 low = high
        // if(low <= high && nums[low] == target){
        //     return low;
        // }
        //注意此处的逻辑
        if(nums[high] == target){
            return low;
        }
        return -1;
    }
}

```


## 1143. 最长公共子序列
### Description

* [LeetCode-1143. 最长公共子序列](https://leetcode.cn/problems/longest-common-subsequence/)

### Approach 1-DP


#### Analysis


参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int longestCommonSubsequence(String s1, String s2) {
        if(s1.length() == 0 || s2.length() == 0){
            return 0;
        }

        int len1 = s1.length();
        int len2 = s2.length();
        //dp[i][j]表示第一个字符串到第i位，第二个字符串到第j位为止的最长公共子序列长度
        int[][] dp = new int[len1+1][len2+1]; 

        for(int i = 1; i <= len1; i++){
            for(int j = 1; j <= len2; j++){
                if(s1.charAt(i - 1) == s2.charAt(j - 1)) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                }else {
                    dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
                }  
            }
        }
        return dp[len1][len2];
    }
}
```


### 扩展-输出最长公共子序列

* [最长公共子序列 | 牛客网](https://www.nowcoder.com/practice/6d29638c85bb4ffd80c020fe244baf11)

上题中只要求输出最长公共子序列的长度，此处进一步扩展，输出最长公共子序列。


```java
import java.util.*;
public class Solution {
    public String LCS (String s1, String s2) {
        //只要有一个空字符串便不会有子序列
        if(s1.length() == 0 || s2.length() == 0) 
            return "-1";
        int len1 = s1.length();
        int len2 = s2.length();
        //dp[i][j]表示第一个字符串到第i位，第二个字符串到第j位为止的最长公共子序列长度
        int[][] dp = new int[len1 + 1][len2 + 1]; 
        //遍历两个字符串每个位置求的最长长度
        for(int i = 1; i <= len1; i++){
            for(int j = 1; j <= len2; j++){
                //遇到两个字符相等
                if(s1.charAt(i - 1) == s2.charAt(j - 1))
                    //来自于左上方
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                //遇到的两个字符不同
                else
                    //来自左边或者上方的最大值
                    dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
        //从动态规划数组末尾开始
        int i = len1, j = len2;
        Stack<Character> s = new Stack<Character>();
        while(dp[i][j] != 0){
            //来自于左方向
            if(dp[i][j] == dp[i - 1][j])
                i--;
            //来自于上方向
            else if(dp[i][j] == dp[i][j - 1])
                j--;
            //来自于左上方向
            else if(dp[i][j] > dp[i - 1][j - 1]){
                i--;
                j--;
                //只有左上方向才是字符相等的情况，入栈，逆序使用
                s.push(s1.charAt(i)); 
           }
        }
        String res = "";
        //拼接子序列
        while(!s.isEmpty())
            res += s.pop();
        //如果两个完全不同，返回字符串为空，则要改成-1
        return !res.isEmpty() ? res : "-1";  
    }
}
```