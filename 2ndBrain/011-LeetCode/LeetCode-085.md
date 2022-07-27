
# LeetCode Notes-085


[TOC]



## 更新
* 2022/06/10，撰写
* 2022/06/10，完成



## 总览
* 【经典好题】[LeetCode-316. 去除重复字母](https://leetcode.cn/problems/remove-duplicate-letters/)
* [LeetCode-452. 用最少数量的箭引爆气球](https://leetcode.cn/problems/minimum-number-of-arrows-to-burst-balloons/)
* 【水题】[LeetCode-1184. 公交站间的距离](https://leetcode.cn/problems/distance-between-bus-stops/)
* [LeetCode-151. 颠倒字符串中的单词](https://leetcode.cn/problems/reverse-words-in-a-string/)
* [LeetCode-8. 字符串转换整数 (atoi)](https://leetcode.cn/problems/string-to-integer-atoi/)
* [LeetCode-剑指 Offer 59 - II. 队列的最大值](https://leetcode.cn/problems/dui-lie-de-zui-da-zhi-lcof/)
* [LeetCode-781. 森林中的兔子](https://leetcode.cn/problems/rabbits-in-forest/)
* [LeetCode-剑指 Offer 45. 把数组排成最小的数](https://leetcode.cn/problems/ba-shu-zu-pai-cheng-zui-xiao-de-shu-lcof/)
* [LeetCode-85. 最大矩形](https://leetcode.cn/problems/maximal-rectangle/)
* [LeetCode-718. 最长重复子数组](https://leetcode.cn/problems/maximum-length-of-repeated-subarray/)
* [LeetCode-198. 打家劫舍](https://leetcode.cn/problems/house-robber/)
* [LeetCode-213. 打家劫舍 II](https://leetcode.cn/problems/house-robber-ii/)
* [LeetCode-剑指 Offer 38. 字符串的排列](https://leetcode.cn/problems/zi-fu-chuan-de-pai-lie-lcof/)
* [LeetCode-199. 二叉树的右视图](https://leetcode.cn/problems/binary-tree-right-side-view/)
* [LeetCode-45. 跳跃游戏 II](https://leetcode.cn/problems/jump-game-ii/)
* [LeetCode-55. 跳跃游戏](https://leetcode.cn/problems/jump-game/)
* [LeetCode-189. 轮转数组](https://leetcode.cn/problems/rotate-array/)
* [LeetCode-153. 寻找旋转排序数组中的最小值](https://leetcode.cn/problems/find-minimum-in-rotated-sorted-array/)
* [LeetCode-154. 寻找旋转排序数组中的最小值 II](https://leetcode.cn/problems/find-minimum-in-rotated-sorted-array-ii/)
* [LeetCode-面试题 10.03. 搜索旋转数组](https://leetcode.cn/problems/search-rotate-array-lcci/)





## 【经典好题】33. 搜索旋转排序数组
### Description

* 【经典好题】[LeetCode-33. 搜索旋转排序数组](https://leetcode.cn/problems/search-in-rotated-sorted-array/)

### Approach 1-二分查找

#### Analysis


参考 `leetcode-cn` 官方题解。

参考 [郭郭视频讲解](https://leetcode.cn/problems/search-in-rotated-sorted-array/solution/java-xiang-xi-pou-xi-dai-ma-jian-ji-si-l-vm8u/)。


#### Solution

```java
class Solution {
    public int search(int[] nums, int target) {
        int left = 0;
        int right = nums.length - 1;

        while(left <= right){
            int mid = (left + right) / 2;
            if(nums[mid] == target){
                return mid;
            }
            // left in order 左边有序
            if(nums[left] <= nums[mid]){
                if(nums[left] <= target && target < nums[mid]){
                    right = mid - 1;
                } else {
                    left = mid + 1;
                }
            }else{
                if(nums[mid] < target && target <= nums[right]){
                    left = mid + 1;
                }else{
                    right = mid - 1;
                }
            }
        }
        return -1;
    }
}
```


## 【经典好题】81. 搜索旋转排序数组 II
### Description

* 【经典好题】[LeetCode-81. 搜索旋转排序数组 II](https://leetcode.cn/problems/search-in-rotated-sorted-array-ii/)

### Approach 1-二分查找

#### Analysis


参考 `leetcode-cn` 官方题解。

参考 [郭郭视频讲解](https://leetcode.cn/problems/search-in-rotated-sorted-array-ii/solution/java-er-fen-cha-zhao-tao-lu-fen-xi-by-ve-pebb/)。


#### Solution


```java
class Solution {
    public boolean search(int[] nums, int target) {
        int left = 0;
        int right = nums.length - 1;

        while(left <= right){
            int mid = (left + right) / 2;
            if(nums[mid] == target){
                return true;
            }
            //1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,
            //left            |
            //0
            while(left <= mid && nums[left] == nums[mid]){
                left++;
            }
            if(left > mid){
                left = mid + 1;
                continue;
            }
            //左边有序
            if(nums[left] < nums[mid]){
                if(nums[left] <= target && target < nums[mid]){
                    right = mid - 1;
                } else {
                    left = mid + 1;
                }
            }else {
                if(nums[mid] < target && target <= nums[right]){
                    left = mid  + 1;
                } else {
                    right = mid - 1;
                }
            }

        }

        return false;
    }
}
//1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,
//left            |
//0

```


## 【经典好题】124. 二叉树中的最大路径和
### Description

* 【经典好题】[LeetCode-124. 二叉树中的最大路径和](https://leetcode.cn/problems/binary-tree-maximum-path-sum/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。

参考 [郭郭视频讲解](https://leetcode.cn/problems/binary-tree-maximum-path-sum/solution/java-zhuan-ti-jiang-jie-di-gui-si-lu-qin-qx8a/)。


> 本题求解思路可用于 [LeetCode-549. 二叉树中最长的连续序列](https://leetcode.cn/problems/binary-tree-longest-consecutive-sequence-ii/)



该问题使用递归求解，子问题有如下 4 种情况
1. 选择 node.val
2. 选择 node.val + left
3. 选择 node.val + right
4. 选择 node.val + left + right

其中，情况 1、2、3 都可以进行递归。但是情况 4 不能递归返回给上一次，所以需要一个全局变量来维护做大值。


#### Solution


```java
class Solution {
    //定义全局变量
    private int maxRes = Integer.MIN_VALUE;

    public int maxPathSum(TreeNode root) {
        postOrder(root); //后续遍历
        return maxRes; 
    }

    private int postOrder(TreeNode root){
        if(root == null){
            return 0;
        }
        //负数对结果无作用 
        int left = Math.max(postOrder(root.left),0);
        int right = Math.max(postOrder(root.right),0);

        //更新一下全局变量
        //对应情况 4  root.val + left + right
        maxRes = Math.max(maxRes,root.val + left + right);
   
        //对应三种情况
        // 1. val + left
        // 2. val + right
        // 3. val  由于上面限制了left 和right 都是非负数， 等效为 val + 0
        return root.val + Math.max(left, right); 
    }
}
```




## 【经典好题】549. 二叉树中最长的连续序列
### Description

* 【经典好题】[LeetCode-549. 二叉树中最长的连续序列](https://leetcode.cn/problems/binary-tree-longest-consecutive-sequence-ii/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。

参考 [郭郭视频讲解](https://leetcode.cn/problems/binary-tree-maximum-path-sum/solution/java-zhuan-ti-jiang-jie-di-gui-si-lu-qin-qx8a/)。



> 本题求解思路参考 [LeetCode-124. 二叉树中的最大路径和](https://leetcode.cn/problems/binary-tree-maximum-path-sum/)






#### Solution



```java

class Solution {
    //定义全局变量
    private int maxRes = Integer.MIN_VALUE;

    public int longestConsecutive(TreeNode root) {
        postOrder(root); //后续遍历
        return maxRes; 
    }


     /**
     *  arr[0] 表示包含root元素的递增序列长度
     *  arr[1] 表示包含root元素的递减序列长度
     */
    private int[] postOrder(TreeNode root){
        int[] arr = new int[2];
        
        if(root == null){
            return arr;
        }
        //至少已经找到了一个元素
        arr[0] = 1;
        arr[1] = 1;

        int[] left = postOrder(root.left);
        int[] right = postOrder(root.right);

        //left
        if(root.left != null){
            if(root.left.val + 1 == root.val){
                arr[0] = left[0] + 1;
            } else if(root.left.val - 1 == root.val){
                arr[1] = left[1] + 1;
            }
        }

        //right
        if(root.right != null){
            if(root.right.val + 1 == root.val){
                arr[0] = Math.max(arr[0],right[0] + 1);
            } else if(root.right.val - 1 == root.val){
                arr[1] = Math.max(arr[1],right[1] + 1);
            }
        }
        //更新一下全局变量
        //arr[0] 表示包含root元素的递增序列长度
        //arr[1] 表示包含root元素的递减序列长度
        maxRes = Math.max(maxRes,arr[0] + arr[1] - 1);
   
        return arr; 
    }
}
```


## 【经典好题】565. 数组嵌套
### Description

* 【经典好题】[LeetCode-565. 数组嵌套](https://leetcode.cn/problems/array-nesting/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution

* 如下版本，在提交后会超时，因为每次遍历，都会创建一个 Set。

```java
class Solution {
    public int arrayNesting(int[] nums) {
        int ans = 0;
        int len = nums.length;
        for(int i=0;i<len;i++){
            int val = nums[i];
            //每次遍历，都会创建一个 Set
            Set<Integer> set = new HashSet<>();
            while(!set.contains(val)){
                set.add(val);
                val = nums[val];
            }
            ans = Math.max(ans,set.size());
        }
        return ans;
    }
}
```

* 其实，如果这个元素在 Set 中出现过，后续遍历时候不需要再判断该元素了。可以将 Set 的创建放在 for 循环的外面，即只创建一个 Set


```java
class Solution {
    public int arrayNesting(int[] nums) {
        int ans = 0;
        int len = nums.length;
        //如果这个元素在 Set 中出现过，后续遍历时候不需要再判断该元素了。可以将 Set 的创建放在 for 循环的外面，即只创建一个 Set
        Set<Integer> set = new HashSet<>();
        for(int i=0;i<len;i++){
            int val = nums[i];
            int count = 0;   
            while(!set.contains(val)){
                set.add(val);
                count++;
                val = nums[val];
            }
            ans = Math.max(ans,count);
        }
        return ans;
    }
}
```


## 【经典好题】98. 验证二叉搜索树


### Description

* 【经典好题】[LeetCode-98. 验证二叉搜索树](https://leetcode.cn/problems/validate-binary-search-tree/)

### Approach 1-递归

#### Analysis


参考 `leetcode-cn` 官方题解。


注意，如下的二叉树不是二叉搜索树，因为节点 3 是小于其祖先节点 5。

```s
       5
    4    6
       3    7
```

#### Solution


```java
class Solution {
    public boolean isValidBST(TreeNode root) {
        return isValidBST(root, Long.MIN_VALUE, Long.MAX_VALUE);
    }

    public boolean isValidBST(TreeNode node, long lower, long upper) {
        if (node == null) {
            return true;
        }
        if (node.val <= lower || node.val >= upper) {
            return false;
        }
        return isValidBST(node.left, lower, node.val) && isValidBST(node.right, node.val, upper);
    }
}
```


### Approach 2-中序遍历

#### Analysis


参考 `leetcode-cn` 官方题解。

**二叉搜索树「中序遍历」得到的值构成的序列一定是升序的。**

#### Solution

```java
class Solution {
    public boolean isValidBST(TreeNode root) {
        Deque<TreeNode> stack = new LinkedList<TreeNode>();
        double inorder = -Double.MAX_VALUE;

        while (!stack.isEmpty() || root != null) {
            while (root != null) {
                stack.push(root);
                root = root.left;
            }
            root = stack.pop();
              // 如果中序遍历得到的节点的值小于等于前一个 inorder，说明不是二叉搜索树
            if (root.val <= inorder) {
                return false;
            }
            inorder = root.val;
            root = root.right;
        }
        return true;
    }
}
```

## 【经典好题】76. 最小覆盖子串


### Description

* 【经典好题】[LeetCode-76. 最小覆盖子串](https://leetcode.cn/problems/minimum-window-substring/)

### Approach 1-滑动窗口

#### Analysis


参考 `leetcode-cn` 官方题解。

#### Solution


```java
import java.util.*;

class Solution {
    public String minWindow(String s, String t) {
        int len1 = s.length();
        int len2 = t.length();
        if(len2 > len1){
            return "";
        }
        //统计s中字符出现的频率
        Map<Character,Integer> sMap = new HashMap<>();
        //统计t中字符出现的频率
        Map<Character,Integer> tMap = new HashMap<>();
        for(int i=0;i<len2;i++){
            Character c = t.charAt(i);
            tMap.put(c,1 + tMap.getOrDefault(c,0));
        }

        String res = ""; //结果
        int cnt = 0; //有多少个元素符合
        int minLen = Integer.MAX_VALUE; //最短子串长度
        //右窗口不断右移动
        for(int right=0,left = 0;right < len1;right++){
            Character c = s.charAt(right);
            sMap.put(c, sMap.getOrDefault(c, 0) + 1); //记录频率
            //如果是t中出现的字符，比较其在s 和 t 中的出现频率，若满足要求，则记录cnt++
            //t 中有可能出现重复字符，比如 s = "ABBDCSD" t = "ABB"。所以当sMap.get(c) <= tMap.get(c) 需要cnt++
            if(tMap.containsKey(c) && sMap.get(c) <= tMap.get(c)){
                cnt++;
            }
            //左窗口不断收紧
            //如果s[left]不在t中，或者当前窗口中的s[left]的出现频率 已经大于t中要求的频率，可以直接left++
            while(left < right && (!tMap.containsKey(s.charAt(left)) || sMap.get(s.charAt(left)) > tMap.get(s.charAt(left)))){
                int count = sMap.get(s.charAt(left));
                sMap.put(s.charAt(left), count - 1);
                left++;
            }
            //如果t的字符 都已经满足  则记录一个子串
            if(cnt == t.length() && right - left + 1 < minLen){
                minLen  = right - left + 1;
                res = s.substring(left,right + 1);
            }
        }
        return res;
    }
}
```



## 829. 连续整数求和


### Description

* [LeetCode-829. 连续整数求和](https://leetcode.cn/problems/consecutive-numbers-sum/)

### Approach 1-数论+等差数列

#### Analysis


参考 `leetcode-cn` 官方题解。

参考 [数论+等差数列 | 题解](https://leetcode.cn/problems/consecutive-numbers-sum/solution/lian-xu-zheng-shu-qiu-he-by-jiang-hui-4-miqf/)。


本题可以看做是一个公差 d=1 的等差数列。

1. k 的上限是 `sqrt(2*n)`
2. `2n / k` 是一个整数
3. `(2n / k) - k + 1` 是 2 的倍数
 

#### Solution

```java
class Solution {
    public int consecutiveNumbersSum(int n) {
        int ans = 0;
        //条件②
        for (int k = 1; k * k < 2 * n; k++) {
            //条件①和条件③
            if (2 * n % k == 0 && (2 * n / k - k + 1) % 2 == 0) {
                ans++;
            }
        }
        return ans;
    }
}
```

## 【经典好题】316. 去除重复字母

### Description

* 【经典好题】[LeetCode-316. 去除重复字母](https://leetcode.cn/problems/remove-duplicate-letters/)

### Approach 1-单调栈

#### Analysis


参考 `leetcode-cn` 官方题解。

参考官方视频讲解（视频讲解代码和官方文字代码略有不同）。


1. 创建一个单调栈记录要保留的元素。**该单调栈中，按照字典顺序升序。**
2. 创建一个 `lastIndex` 数组，统计每一个字母最后出现的下标。
3. **遍历字符串，如果该字符串已经被加入栈中，则可忽略（因为单调栈中的字母是按照字典顺序升序的，可以保证整体字符串的字典排序最小）。**
4. 如果该字符串不在栈中，则将其和栈顶元素 `topChar` 判断。
5. 如果栈顶元素 `topChar` 大于该字符串，并且该 `topChar` 在后续还会出现，即 `lastIndex[stack.peekLast() - 'a'] > i`，则可以将 `topChar` 弹出。



#### Solution

```java
class Solution {
    public String removeDuplicateLetters(String s) {
        int len = s.length();
        char[] charArray = s.toCharArray();
        int[] lastIndex = new int[26]; //记录字母最后出现的下标索引
        for(int i=0;i<len;i++){
            lastIndex[charArray[i] - 'a'] = i;
        }
        //单调栈
        Deque<Character> stack = new LinkedList<>();
        boolean[] visited = new boolean[26]; //标记字母是否在栈中
        for(int i=0;i<len;i++){
            char c = charArray[i];
            //如果已经被添加到了栈中 可忽略
            if(visited[c - 'a']){
                continue;
            }
            // while 循环 因为这段可能被执行多次
            // 如果栈顶元素 topChar 大于该字符串，并且该 topChar 在后续还会出现
            // 即 lastIndex[stack.peekLast() - 'a'] > i，则可以将 topChar 弹出

            while(!stack.isEmpty() && stack.peekLast() > c && lastIndex[stack.peekLast() - 'a'] > i){
                char topChar = stack.pollLast(); //移除栈顶元素
                visited[topChar - 'a'] = false; //标记该元素不在栈中
            }
            stack.addLast(c);
            visited[c - 'a'] = true;
        }
        StringBuilder sb = new StringBuilder();
        int size = stack.size();

        //size要先算出来 不然在for循环时 size是在变化的
        
        // for(int i=0;i<stack.size();i++){
        
        // for(int i=0;i<size;i++){
        //     sb.append(stack.pollFirst());
        // }

        //也可以不弹出栈元素  直接遍历栈
        for(Character c : stack){
            sb.append(c);
        }

        return sb.toString();
    }
}
```


## 32. 最长有效括号

### Description

* [LeetCode-32. 最长有效括号](https://leetcode.cn/problems/longest-valid-parentheses/)

### Approach 1-动态规划

#### Analysis


参考 `leetcode-cn` 官方题解。

建议观看视频讲解。

定义 `dp[i]` 表示以下标 i 字符结尾的最长有效括号的长度。
如果 `s[i] = '('`，则一定有 `dp[i] = 0`。

下面对 `s[i] = ')'` 的情况进行讨论
1. 如果 `s[i-1] = '('` 并且 `s[i] == ')'`，即字符串为 `xxx()`， 则有 `dp[i] = dp[i-2] + 2`
2. 如果 `s[i-1] = ')'` 并且 `s[i] == ')'`，即字符串为 `xxx))`
   * 如果 `s[i - dp[i-1] - 1]`，则有 `dp[i] = dp[i-1] + 2`
   * 此时，我们已经考虑了字符串 `[i-dp[i-1]-1,i]` 区间范围。但还需要考虑 `s[i - dp[i-1] - 1]` 前面的有效括号个数，即 `dp[i-dp[i-1]-1-1]`。所以有如下转移方程

```s
dp[i] = dp[i-2] + 2 + dp[i-dp[i-1]-1-1]
``` 

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/leetcode-32-1.png)


#### Solution


```java
class Solution {
    public int longestValidParentheses(String s) {
        int maxans = 0;
        int[] dp = new int[s.length()];
        for (int i = 1; i < s.length(); i++) {
            //如果s[i] = '(' 则dp[i] 一定为0 
            //所以下面只处理 s[i] = ')' 的情况
            if (s.charAt(i) == ')') {
                if (s.charAt(i - 1) == '(') {  //xxxx()格式
                    dp[i] = (i >= 2 ? dp[i - 2] : 0) + 2;
                } else if (i - dp[i - 1] > 0 && s.charAt(i - dp[i - 1] - 1) == '(') { //xxxx))格式
                    //dp[i] = dp[i-2] + 2 + dp[i-dp[i-1]-1-1]
                    dp[i] = dp[i - 1] + 2;
                    if(i - dp[i - 1] - 1 -1 >= 0){
                        dp[i] += dp[i-dp[i-1]-1-1];
                    }
                    //dp[i] = dp[i - 1] + ((i - dp[i - 1]) >= 2 ? dp[i - dp[i - 1] - 2] : 0) + 2;
                }
                maxans = Math.max(maxans, dp[i]);
            }
        }
        return maxans;
    }
}
```




## 50. Pow(x, n)

### Description

* [LeetCode-50. Pow(x, n)](https://leetcode.cn/problems/powx-n/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


* 暴力求解（会超时）
  
```java
class Solution {
    public double myPow(double x, int n) {
        if(n < 0){
            x = 1/x;
            n = -n;
        }
        double res = 1.0;
        for(int i=0;i<n;i++){
            res = res * x;
        }
        return res;
    }
}
```


* 临时变量折半查询


```java
class Solution {
    public double myPow(double x, int n) {
        if(n < 0){
            x = 1/x;
            n = -n;
        }
        return quickMul(x,n);
    }
    private double quickMul(double x,int n){
        if(n == 0){
            return 1.0;
        }
        //利用临时变量 halfVal 保存结果
        double halfVal = quickMul(x,n/2);
        double res = 1.0;
        if(n%2 == 0){
            res = halfVal * halfVal; 
        } else {
            res = halfVal * halfVal * x;
        }
        return res;

    }
}
```


## 665. 非递减数列

### Description

* [LeetCode-665. 非递减数列](https://leetcode.cn/problems/non-decreasing-array/)

### Approach 1

#### Analysis


参考 [郭郭视频讲解 | B站](https://www.bilibili.com/video/BV1654y1G79H?from=search&seid=14745142180713971786&vd_source=940dfe8509f57c2c8551d0a9c2f7f8d8)。




#### Solution


```java
class Solution {
    public boolean checkPossibility(int[] nums) {
        int len = nums.length;
        int left = 0;
        int right = len - 1;

        while(left < len-1  && nums[left] <= nums[left + 1]){
            left++;
        }
        //case 1 数组本身非递减数列  1 2 3 4
        if(left == len - 1){
            return true;
        }
            
        while(right >= 1 && nums[right] >= nums[right - 1]){
            right--;
        }
        //若left 和right 中间的元素大于1 则肯定为false
        if(left + 1 != right){
            return false;
        } 
        // 注意，如果left+1 = right，并不能认为是true
        // 比如 3 4 2 3 

        //因为下面用到了 left -1 和 right+1  
        //所以此处先对left -1 和right+1 进行越界判断
        //left =0  对应case 4 1 2 3
        //right = len-1 对应case 2 3 4 1 
        if(left == 0 || right == len-1){
            return true;
        }
        // nums[left - 1] <= nums[right]  对应case 3 5 4 6 -> 3 3 4 6 
        // nums[left] <= nums[right + 1]; 对应case 3 4 2 6 -> 3 4 4 6 
        return nums[left - 1] <= nums[right] || nums[left] <= nums[right + 1];
    }
}
```




## 827. 最大人工岛

### Description

* [LeetCode-827. 最大人工岛](https://leetcode.cn/problems/making-a-large-island/)

### Approach 1

#### Analysis


参考 [岛屿问题DFS | 题解](https://leetcode.cn/problems/making-a-large-island/solution/dao-yu-wen-ti-mei-you-na-yao-nan-du-li-x-cgbv/) 解题思路。


1. 给出一个如下图所示的岛屿海洋分布。

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/leetcode-827-1.png)


2. 遍历节点，并对岛屿进行编号（从 2 开始，因为 0 和 1 已经被使用了）

![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2023/leetcode-827-2.png)



```java
//结果记录
int resMax = 0;
for(int row=0;row<rowLen;row++){
    for(int col=0;col<colLen;col++){
        if(grid[row][col] == 1){
            //求解岛屿的面积 并将grid设为岛屿的编号
            int area = getIslandArea(grid,row,col,islandIndex);
            islandInfo.put(islandIndex,area);
            islandIndex++; //岛屿编号++
            resMax = Math.max(resMax,area); //如果岛屿全部是1  需要在此处记录最大面积
        }
    }
}
```



3. 在遍历岛屿过程中，计算出岛屿的面积。创建一个 Map，记录岛屿编号和岛屿面积的映射关系。

```s
| key   | 2 | 3 | 4 | 5 | 6 |
| value | 6 | 2 | 1 | 4 | 1 |
```


4. 再次遍历数组，若遇到岛屿，则将其变为1，遍历其邻居，若有岛屿，获取岛屿编号，并根据岛屿编号获得对应岛屿面积

```java
//再次遍历岛屿 找出 0 的点，将其变为1 添加上其邻居岛屿的面积
for(int row=0;row<rowLen;row++){
    for(int col=0;col<colLen;col++){
        if(grid[row][col] == 0){
            int area = 1;
            Set<Integer> islandIndexSet = new HashSet<>(); //存储岛屿编号 防止出现重复
            for(int index=0;index<4;index++){
                int next_row = row + di[index];
                int next_col = col + dj[index];
                if(validIndex(next_row,next_col,rowLen,colLen) && grid[next_row][next_col] != 0){
                    int islandIndexNum = grid[next_row][next_col];
                    if(!islandIndexSet.contains(islandIndexNum)){
                        //如果还没计算过该岛屿编号
                        islandIndexSet.add(islandIndexNum);
                        area += islandInfo.get(islandIndexNum); //根据岛屿编号 找到对应的面积
                    }
                }
            }
            resMax = Math.max(resMax,area);
        }
    }
}
```

#### Solution

```java
class Solution {
    private int[] di = {0,0,1,-1};
    private int[] dj = {1,-1,0,0};
    private int rowLen = 0;
    private int colLen = 0;

    public int largestIsland(int[][] grid) {
        rowLen = grid.length;
        colLen = grid[0].length;

        int islandIndex = 2; //岛屿编号 从2开始 因为 0 1 已经被使用了
        //岛屿信息 key-岛屿编号 value-岛屿面积
        Map<Integer,Integer> islandInfo = new HashMap<>(); 
        //结果记录
        int resMax = 0;
        for(int row=0;row<rowLen;row++){
            for(int col=0;col<colLen;col++){
                if(grid[row][col] == 1){
                    //求解岛屿的面积 并将grid设为岛屿的编号
                    int area = getIslandArea(grid,row,col,islandIndex);
                    islandInfo.put(islandIndex,area);
                    islandIndex++; //岛屿编号++
                    resMax = Math.max(resMax,area); //如果岛屿全部是1  需要在此处记录最大面积
                }
            }
        }
        
        //如果没有岛屿 1，则直接返回
        if(islandInfo.size() == 0){
            return 1;
        }
    
        //再次遍历岛屿 找出 0 的点，将其变为1 添加上其邻居岛屿的面积
        for(int row=0;row<rowLen;row++){
            for(int col=0;col<colLen;col++){
                if(grid[row][col] == 0){
                    int area = 1;
                    Set<Integer> islandIndexSet = new HashSet<>(); //存储岛屿编号 防止出现重复
                    for(int index=0;index<4;index++){
                        int next_row = row + di[index];
                        int next_col = col + dj[index];
                        if(validIndex(next_row,next_col,rowLen,colLen) && grid[next_row][next_col] != 0){
                            int islandIndexNum = grid[next_row][next_col];
                            if(!islandIndexSet.contains(islandIndexNum)){
                                //如果还没计算过该岛屿编号
                                islandIndexSet.add(islandIndexNum);
                                area += islandInfo.get(islandIndexNum); //根据岛屿编号 找到对应的面积
                            }
                        }
                    }
                    resMax = Math.max(resMax,area);
                }
            }
        }
        return resMax;
    }


    private boolean validIndex(int row,int col,int rowLen,int colLen){
        return (row >= 0 && col >=0 && row < rowLen && col < colLen);
    }

    private int getIslandArea(int[][] grid,int row,int col,int islandIndex){
        int area = 1;
        grid[row][col] = islandIndex;
        for(int index=0;index<4;index++){
            int next_row = row + di[index];
            int next_col = col + dj[index];
            if(validIndex(next_row,next_col,rowLen,colLen) && grid[next_row][next_col] == 1){
                area = area + getIslandArea(grid,next_row,next_col,islandIndex);          
            }
        }
        return area;
    }
}
```

## 剑指 Offer 64. 求1+2+…+n

### Description

* [LeetCode-剑指 Offer 64. 求1+2+…+n](https://leetcode.cn/problems/qiu-12n-lcof/)

### Approach 1-递归

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution

* 递归版本（题目限制了此写法）

```java
class Solution {
    public int sumNums(int n) {
        if(n == 0){
            return 0;
        } 
        return n + sumNums(n - 1);
    }
}
```


通常实现递归的时候，我们都会利用条件判断语句来决定递归的出口，但由于题目的限制我们不能使用条件判断语句，那么我们是否能使用别的办法来确定递归出口呢？答案就是逻辑运算符的短路性质。

以逻辑运算符 `&&` 为例，对于 `A && B` 这个表达式，如果 A 表达式返回 False ，那么 `A && B` 已经确定为 False，此时不会去执行表达式 B。同理，对于逻辑运算符 `||`， 对于 `A || B` 这个表达式，如果 A 表达式返回 True，那么 `A || B` 已经确定为 True ，此时不会去执行表达式 B。



```java
class Solution {
    public int sumNums(int n) {
        boolean flag = n > 0 && (n += sumNums(n - 1)) > 0;
        return n;
    }
}
```


## 485. 最大连续 1 的个数

### Description

* [LeetCode-485. 最大连续 1 的个数](https://leetcode.cn/problems/max-consecutive-ones/)

### Approach 1-双指针

#### Analysis


参考 `leetcode-cn` 官方题解。


双指针实现。
1. left 记录连续 1 区间的开始位置
2. right 记录连续 1 区间的结束位置


自我实现代码如下，感觉这样写代码反而复杂了，建议参考官方解答版本。

#### Solution


  

```java
class Solution {
    public int findMaxConsecutiveOnes(int[] nums) {
        int len = nums.length;
        int left = 0;
        int right = 0;
        int index = 0;
        //先找出1的开始位置
        while(index < len && nums[index] != 1){
            index++;
        }
        if(index == len){
            //没有1的话
            return 0; 
        }
        left = index;
        right = index;
        

        int maxValue = 0;
        while(right < len){
            index = right;
            while(index < len && nums[index] == 1){
                index++;
            }
            maxValue = Math.max(maxValue,index - right);
            //再找出下一个1区间的起始位置
            while(index < len && nums[index] != 1){
                index++;
            }
            left = index;
            right = index;
        }
        return maxValue;

    }
}
```



### Approach 2-计数

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public int findMaxConsecutiveOnes(int[] nums) {
        int maxCount = 0, count = 0;
        int n = nums.length;
        for (int i = 0; i < n; i++) {
            if (nums[i] == 1) {
                count++;
            } else {
                maxCount = Math.max(maxCount, count);
                count = 0;
            }
        }
        maxCount = Math.max(maxCount, count);
        return maxCount;
    }
}
```



## 剑指 Offer 17. 打印从1到最大的n位数

### Description

* [LeetCode-剑指 Offer 17. 打印从1到最大的n位数](https://leetcode.cn/problems/da-yin-cong-1dao-zui-da-de-nwei-shu-lcof/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。

不考虑大数溢出情况，是一道很简单的题目。

#### Solution

```java
class Solution {
    public int[] printNumbers(int n) {
        int maxValue = (int)Math.pow(10,n) - 1;
        int[] arr = new int[maxValue];
        for(int i=0;i<maxValue;i++){
            arr[i] = i+1;
        }
        return arr;
    }
}
```


### Approach 2-大数溢出

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


为了避免大数溢出，我们一般用 String 格式存储，如下代码所示。


```java
import java.util.ArrayList;
import java.util.List;

class Solution {
    List<String> list = new ArrayList<>();
    int length = 0;
    char[] loop = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};
    public List<String> printNumbers(int n) {
       this.length = n;
       char[] chars = new char[n];
       dfs(0,chars);
       return list;
    }
    void dfs(int size,char[] chars) {
        if (size == length){
            //终止条件 已固定完所有位
            list.add(new String(chars));
            return;
        }
        for(char c:loop){
            chars[size] = c;
            dfs(size+1,chars);
        }
    }

    public static void main(String[] args) {
        int n = 2;
        List<String> res = new Solution().printNumbers(n);
        for(String s:res){
            System.out.print(s + ",");
        }
        // res.forEach(System.out::println);
    }
}

```


执行上述代码，对应输出结果如下

```s
输入：n = 1
输出："0,1,2,3,4,5,6,7,8,9"

输入：n = 2
输出："00,01,02,...,10,11,12,...,97,98,99"

输入：n = 3
输出："000,001,002,...,100,101,102,...,997,998,999"
```

观察可知，当前的生成方法仍有以下问题
1. 诸如 00，01，02 应显示为 0，1，2。即应删除高位多余的 0
2. 此方法从 0 开始生成，而题目要求列表从 1 开始



对应代码如下。

```java
import java.util.ArrayList;
import java.util.List;

class Solution {
    List<String> list = new ArrayList<>();
    int length = 0;
    int nine = 0; //统计9出现的个数
    int start = 0;//明变量 start 规定字符串的左边界，以保证添加的数字字符串 num[start:] 中无高位多余的 0
    char[] loop = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};
    public List<String> printNumbers(int n) {
       this.length = n;
       char[] chars = new char[n];
       start = length - 1; //初始情况下 比如n=3 会生成000  这个时候只要截取最后一个0就行 即str.substring(length-1)
       dfs(0,chars);
       return list;
    }
    void dfs(int size,char[] chars) {
        if (size == length){
            //终止条件 已固定完所有位
            String str = new String(chars);
            str = str.substring(start); //比如 00 此时start =1 则截取后为0
            if(!str.equals("0")){
                //排除 0
                list.add(str);
            }
            if(length - start == nine){
                start--;
            }
            return;
        }

        for(char c:loop){
            if(c == '9'){
                nine++; //9的个数加1
            }
            chars[size] = c;
            dfs(size+1,chars);
        }
        //固定第 x 位时，当 i=9 则执行 nine=nine+1，并在回溯前恢复 nine=nine−1
        nine--; //记得nine-- !!!

    }

    public static void main(String[] args) {
        int n = 2;
        List<String> res = new Solution().printNumbers(n);
        for(String s:res){
            System.out.print(s + ",");
        }
    }
}
```

执行上述代码，对应输出结果如下

```s
输入：n = 1
输出："0,1,2,3,4,5,6,7,8,9"

输入：n = 2
输出："1,2,3,...,10,11,12,...,97,98,99"
```

最后，题目要求输出 `int[]` 格式，对输出结果的格式进行调整。


```java
    public int[] printNumbers(int n) {
       this.length = n;
       char[] chars = new char[n];
       start = length - 1; //初始情况下 比如n=3 会生成000  这个时候只要截取最后一个0就行 即str.substring(length-1)
       dfs(0,chars);
       int[] arr = new int[list.size()];
       for(int i=0;i<list.size();i++){
           arr[i] = Integer.parseInt(list.get(i));
       }
       return arr;
    }
```


## 31. 下一个排列

### Description

* [LeetCode-31. 下一个排列](https://leetcode.cn/problems/next-permutation/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。

参考 [郭郭视频讲解 - 排列组合](https://www.bilibili.com/video/BV1QU4y1P7n9?spm_id_from=333.999.0.0&vd_source=940dfe8509f57c2c8551d0a9c2f7f8d8)，学习解题思路。


测试用例主要分为下面三种情况
1. `[1,2,3,4,5]` -> `[1,2,3,5,4]`，交换数组中最后两个元素
2. `[5,4,3,2,1]` -> `[1,2,3,4,5]`，不存在下一个更大的排列时，将其重排为字典序最小的排列。这里可以使用 `reverse()` 操作，将其逆序。
3. `[1,3,4,3,2,1]` -> `[1,4,3,3,2,1]` -> `[1,4,1,2,3,3]`
   * 先从数组末尾开始遍历，找出一个单调递增区间的结束位置，比如单调递增区间是 `[4,3,2,1]`，单调递增区间结束的位置是 `3`，所以要更新元素的位置就是 `3`
   * 再遍历单调递增区间，找出第一个大于 `3` 的元素，此处为 `4`，将 `3` 和 `4` 交换位置。此时数组变成了 `[1,4,3,3,2,1]`。
   * 最后再对原单调递增区间位置 `[3,3,2,1]` 将其逆序，选出字典排序最小的排列，即转化为了情况 2。


#### Solution

```java
class Solution {
    public void nextPermutation(int[] nums) {
        int len = nums.length;
        if(len == 1){
            return;
        }
        int index = len -1;
        //寻找单调递增区间结束的位置
        while(index >= 1&& nums[index] <= nums[index-1]){
            index--;
        }

        // [1,3,4,3,2,1]  上述代码执行完 index指向元素4
        
        // case 1 
        // [1,2,3,4,5]  -> [1,2,3,5,4]，交换数组中最后两个元素
        if(index == len - 1){
            swap(nums,index-1,index);
            return; //注意直接return
        }
        // case 2
        // [5,4,3,2,1] -> [1,2,3,4,5]，不存在下一个更大的排列时，将其重排为字典序最小的排列。这里可以使用 reverse() 操作，将其逆序
        if(index == 0){
            reverse(nums,index,len-1);
            return; //注意直接return
        }

        //case 3
        /**
         * `[1,3,4,3,2,1]` -> `[1,4,3,3,2,1]` -> `[1,4,1,2,3,3]`
         * 1. 先从数组末尾开始遍历，找出一个单调递增区间的结束位置，比如单调递增区间是 `[4,3,2,1]`，单调递增区间结束的位置是 `3`，所以要更新元素的位置就是 `3`
         * 2. 再遍历单调递增区间，找出第一个大于 `3` 的元素，此处为 `4`，将 `3` 和 `4` 交换位置。此时数组变成了 `[1,4,3,3,2,1]`。
         * 3. 最后再对原单调递增区间位置 `[3,3,2,1]` 将其逆序，选出字典排序最小的排列，即转化为了情况 2。
         */
        int exchangeIndex = index;
        while(exchangeIndex < len && nums[exchangeIndex] > nums[index - 1]){
            exchangeIndex++;
        }

        System.out.println(index + "mmm" + exchangeIndex);
        //[1,3,4,3,2,1] 此时 index-1指向元素3 exchangeIndex-1指向元素4
        //交换 index-1 和 exchangeIndex
        swap(nums,index-1,exchangeIndex-1);
         //最后 对原单调递增区间的位置 [3,3,2,1] 将其逆序，选出字典排序最小的排列，即转化为了情况 2
        reverse(nums,index,len-1);

    }
    private void swap(int[] nums, int i, int j){
        int temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
    }

    private void reverse(int[] nums, int i, int j){
        while(i<j){
            swap(nums,i,j);
            i++;
            j--;
        }
    }

}

```


## 452. 用最少数量的箭引爆气球

### Description

* [LeetCode-452. 用最少数量的箭引爆气球](https://leetcode.cn/problems/minimum-number-of-arrows-to-burst-balloons/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。
1. 先按照数组的起点元素排序
2. 然后转化为合并区间问题


#### Solution

```java
class Solution {
    public int findMinArrowShots(int[][] points) {
        Arrays.sort(points,new Comparator<int[]>(){
            public int compare(int[] arr1,int[] arr2){
                if(arr1[0] != arr2[0]){
                    return arr1[0] - arr2[0];
                }
                return arr1[1] - arr2[1];
            }
        });

        List<int[]> list = new ArrayList<>();
        list.add(points[0]);
        for(int i=1;i<points.length;i++){
            int pre_left = list.get(list.size() - 1)[0];
            int pre_right = list.get(list.size() - 1)[1];
            int left = points[i][0];
            int right = points[i][1];
            if(pre_left <= left && left <= pre_right){
                //有交集
                int cur_left = Math.max(pre_left,left);
                int cur_right = Math.min(pre_right,right);
                list.set(list.size()-1,new int[]{cur_left,cur_right});
            } else {
                list.add(new int[]{left,right});
            }
        }
        return list.size();
    }
}
```

## 53. 最大子数组和



### Description

* [LeetCode-53. 最大子数组和](https://leetcode.cn/problems/maximum-subarray/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public int maxSubArray(int[] nums) {
        int res = nums[0];
        int[] pre = new int[nums.length];
        pre[0] = nums[0];
        for(int i=1;i<nums.length;i++){
            pre[i] = Math.max(pre[i-1]+nums[i],nums[i]);
            res = Math.max(pre[i],res);
        }
        return res;
    }
}
```


## 【水题】1184. 公交站间的距离


### Description

* 【水题】[LeetCode-1184. 公交站间的距离](https://leetcode.cn/problems/distance-between-bus-stops/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public int distanceBetweenBusStops(int[] distance, int start, int destination) {
        int len = distance.length;
        int sum1 = 0; //顺指针
        int sum2 = 0; //逆时针
        if(start > destination){
            int temp = start;
            start = destination;
            destination = temp;
        }
        int index = start;
        //顺指针
        while(index < destination){
            sum1 += distance[index];
            index++;
        }
        //逆时针
        int index1 = destination;
        while(index1 < len){
            sum2 += distance[index1];
            index1++;
        }
        int index2 = 0;
        while(index2 < start){
            sum2 += distance[index2];
            index2++;
        }
        return Math.min(sum1,sum2);
    }
}
```



## 151. 颠倒字符串中的单词


### Description

* [LeetCode-151. 颠倒字符串中的单词](https://leetcode.cn/problems/reverse-words-in-a-string/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public String reverseWords(String s) {
        s = s.trim(); //去除首尾空格
        String[] arr = s.split("\s+"); //\s表示空格  + 表示匹配多个
        StringBuilder sb = new StringBuilder();
        for(int i=arr.length-1;i>=0;i--){
            sb.append(arr[i]);
            if(i != 0){
                sb.append(" ");
            }
        }
        return sb.toString();
    }
}
```

## 845. 数组中的最长山脉

### Description

* [LeetCode-845. 数组中的最长山脉](https://leetcode.cn/problems/longest-mountain-in-array/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。

1. 使用数组维护一个元素左侧的单调递增元素个数，`ascend[i]`
2. 使用数组维护一个元素右侧的单调递减元素个数，`descend[i]`
3. 最后判断下 `a[i]` 是否是极值点，如果是的话，山峰长度为 `ascend[i] + descend[i] + 1`

#### Solution


```java
class Solution {
    public int longestMountain(int[] arr) {
        int n = arr.length;
        if (n == 0) {
            return 0;
        }
        int[] left = new int[n];//单调递增
        for (int i = 1; i < n; ++i) {
            left[i] = arr[i - 1] < arr[i] ? left[i - 1] + 1 : 0;
        }
        int[] right = new int[n]; //单调递减
        for (int i = n - 2; i >= 0; --i) {
            right[i] = arr[i + 1] < arr[i] ? right[i + 1] + 1 : 0;
        }

        int ans = 0;
        for (int i = 0; i < n; ++i) {
            if (left[i] > 0 && right[i] > 0) {
                ans = Math.max(ans, left[i] + right[i] + 1);
            }
        }
        return ans;
    }
}

```

下面给出一个自我实现版本。

```java
class Solution {
    public int longestMountain(int[] arr) {
        int len = arr.length;
        int[] ascend = new int[len]; //单调递增的区间长度
        int[] descend = new int[len]; //单调递减的区间长度
        ascend[0] = 0;
        descend[len-1] = 0;
        for(int i=1;i<len;i++){
            if(arr[i] > arr[i-1]){
                ascend[i] = ascend[i-1] + 1;
            } 
        }
        for(int j=len-2;j>=0;j--){
            if(arr[j] > arr[j+1]){
                descend[j] = descend[j+1] + 1;
            }
        }
  
        int maxLen = 0;
        for(int i=1;i<len-1;i++){
            if(arr[i-1] < arr[i] && arr[i] > arr[i+1]){
                //极值点
                //必须先增后降 不能单边
                if(ascend[i-1] >= 0 && descend[i+1] >= 0){
                    maxLen = Math.max(maxLen,ascend[i] + descend[i] + 1 );
                }
            }
        }
        return maxLen;
    }
}


```



## 8. 字符串转换整数 (atoi)

### Description

* [LeetCode-8. 字符串转换整数 (atoi)](https://leetcode.cn/problems/string-to-integer-atoi/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```java
public class Solution {

    public int myAtoi(String str) {
        int len = str.length();
        // str.charAt(i) 方法回去检查下标的合法性，一般先转换成字符数组
        char[] charArray = str.toCharArray();

        // 1、去除前导空格
        int index = 0;
        while (index < len && charArray[index] == ' ') {
            index++;
        }

        // 2、如果已经遍历完成（针对极端用例 "      "）
        if (index == len) {
            return 0;
        }

        // 3、如果出现符号字符，仅第 1 个有效，并记录正负
        int sign = 1;
        char firstChar = charArray[index];
        if (firstChar == '+') {
            index++;
        } else if (firstChar == '-') {
            index++;
            sign = -1;
        }

        // 4、将后续出现的数字字符进行转换
        // 不能使用 long 类型，这是题目说的
        int res = 0;
        while (index < len) {
            char currChar = charArray[index];
            // 4.1 先判断不合法的情况
            if (currChar > '9' || currChar < '0') {
                break;
            }

            // 题目中说：环境只能存储 32 位大小的有符号整数，因此，需要提前判：断乘以 10 以后是否越界
            if (res > Integer.MAX_VALUE / 10 || (res == Integer.MAX_VALUE / 10 && (currChar - '0') > Integer.MAX_VALUE % 10)) {
                return Integer.MAX_VALUE;
            }
            if (res < Integer.MIN_VALUE / 10 || (res == Integer.MIN_VALUE / 10 && (currChar - '0') > -(Integer.MIN_VALUE % 10))) {
                return Integer.MIN_VALUE;
            }

            // 4.2 合法的情况下，才考虑转换，每一步都把符号位乘进去
            res = res * 10 + sign * (currChar - '0');
            index++;
        }
        return res;
    }

    public static void main(String[] args) {
        Solution solution = new Solution();
        String str = "2147483646";
        int res = solution.myAtoi(str);
        System.out.println(res);

        System.out.println(Integer.MAX_VALUE);
        System.out.println(Integer.MIN_VALUE);
    }
}
```


## 51. N 皇后

### Description

* [LeetCode-51. N 皇后](https://leetcode.cn/problems/n-queens/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```java
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.List;

public class Solution {

    private int n;
    /**
     * 记录某一列是否放置了皇后
     */
    private boolean[] col;
    /**
     * 记录主对角线上的单元格是否放置了皇后
     * 主对角元素的特点是 row-col的值是固定的
     * 对n=4的情况，row-col 为-3 -2 -1 0 1 2 3，共7个值
     * 为了表示方便，在固定值的基础上统一加上n-1，将-3 变为0  即row-col+n-1
     */
    private boolean[] main;
    /**
     * 记录了副对角线上的单元格是否放置了皇后
     * 副对角元素的特点是 row+col的值是固定的
     * 对n=4的情况，row+col 为0 1 2 3 4 5 6 共7个值
     */
    private boolean[] sub;
    private List<List<String>> res;

    public List<List<String>> solveNQueens(int n) {
        res = new ArrayList<>();
        if (n == 0) {
            return res;
        }

        // 设置成员变量，减少参数传递，具体作为方法参数还是作为成员变量，请参考团队开发规范
        this.n = n;
        this.col = new boolean[n];
        this.main = new boolean[2 * n - 1];
        this.sub = new boolean[2 * n - 1];
        Deque<Integer> path = new ArrayDeque<>();
        dfs(0, path);
        return res;
    }

    private void dfs(int row, Deque<Integer> path) {
        if (row == n) {
            // 深度优先遍历到下标为 n，表示 [0.. n - 1] 已经填完，得到了一个结果
            List<String> board = convert2board(path);
            res.add(board);
            return;
        }

        // 针对下标为 row 的每一列，尝试是否可以放置
        for (int j = 0; j < n; j++) {
            //该列未被占用 并且主对角线 和副对角线 都没被占用
            if (!col[j] && !main[row - j + n - 1] && !sub[row + j]) {
                path.addLast(j);
                col[j] = true;
                main[row - j + n - 1] = true;
                sub[row + j] = true;

                dfs(row + 1, path);

                sub[row + j] = false;
                main[row - j + n - 1] = false;
                col[j] = false;
                
                path.removeLast();
            }
        }
    }

    private List<String> convert2board(Deque<Integer> path) {
        List<String> board = new ArrayList<>();
        for (Integer num : path) {
            StringBuilder row = new StringBuilder();
            row.append(".".repeat(Math.max(0, n)));
            row.replace(num, num + 1, "Q");
            board.add(row.toString());
        }
        return board;
    }
}

```


## 剑指 Offer 59 - II. 队列的最大值

### Description

* [LeetCode-剑指 Offer 59 - II. 队列的最大值](https://leetcode.cn/problems/dui-lie-de-zui-da-zhi-lcof/)

### Approach 1-暴力

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution

```java
class MaxQueue {
    int[] q = new int[20000];
    int begin = 0, end = 0;

    public MaxQueue() {

    }
    
    public int max_value() {
        int ans = -1;
        for (int i = begin; i != end; ++i) {
            ans = Math.max(ans, q[i]);
        }
        return ans;
    }
    
    public void push_back(int value) {
        q[end++] = value;
    }
    
    public int pop_front() {
        if (begin == end) {
            return -1;
        }
        return q[begin++];
    }
}

```

### Approach 2-单调双端队列

#### Analysis


参考 `leetcode-cn` 官方题解。
1. 创建一个队列用于记录元素的插入和删除
2. 创建一个单调队列，维护最大值关系

#### Solution

```java
class MaxQueue {
    //单调队列  队首元素为最大值 单调递减
    private Deque<Integer> monotonicDeque;
    //队列 记录元素
    private Deque<Integer> queue;

    public MaxQueue() {
        monotonicDeque = new LinkedList<Integer>();
        queue = new LinkedList<Integer>();
    }
    
    public int max_value() {
        if (monotonicDeque.isEmpty()) {
            return -1;
        }
        return monotonicDeque.peekFirst(); //队列单调递减 头部为最大 只返回头部元素 不弹出
    }
    
    public void push_back(int value) {
        //记录元素
        queue.offerLast(value);
        //更新单调队列
        while(!monotonicDeque.isEmpty() && monotonicDeque.peekLast() < value){
            //弹出
            monotonicDeque.pollLast();
        }
        monotonicDeque.offerLast(value);
    }
    
    public int pop_front() {
        if(queue.isEmpty()){
            return -1;
        }
        int ans = queue.pollFirst();
        //如果移除的元素 恰好是单调队列的头部元素
        if(ans == monotonicDeque.peekFirst()){
            monotonicDeque.pollFirst();
        }
        return ans;
    }
}

```





## 239. 滑动窗口最大值

### Description

* [LeetCode-239. 滑动窗口最大值](https://leetcode.cn/problems/sliding-window-maximum/)

### Approach 1-单调队列

#### Analysis


参考 `leetcode-cn` 官方题解。


参照「剑指 Offer 59 - II. 队列的最大值」的单调队列的求解思路。
#### Solution


先给出一个自我实现版本。


```java
import java.util.Deque;
import java.util.LinkedList;

class Solution {
    //单调队列  队首元素为最大值 单调递减
    private Deque<Integer> monotonicDeque;
    //队列 记录元素
    private Deque<Integer> queue;

    public Solution(){
        monotonicDeque = new LinkedList<Integer>();
        queue = new LinkedList<Integer>();
    }

    public int[] maxSlidingWindow(int[] nums, int k) {
        int len = nums.length;
        int[] resArr = new int[len - k + 1];
        int index = 0;
        for(int i=0;i<k;i++){
            push_back(nums[i]);
        }
        resArr[index] = max_value();
        index++;

        int end = k;
        while(end < len){
            pop_front();
            push_back(nums[end]);
            resArr[index] = max_value();
            index++;
            end++;
        }
        return resArr;

    }

    public int max_value() {
        if (monotonicDeque.isEmpty()) {
            return -1;
        }
        return monotonicDeque.peekFirst(); //队列单调递减 头部为最大 只返回头部元素 不弹出
    }
    public int pop_front() {
        if(queue.isEmpty()){
            return -1;
        }
        int ans = queue.pollFirst();
        //如果移除的元素 恰好是单调队列的头部元素
        if(ans == monotonicDeque.peekFirst()){
            monotonicDeque.pollFirst();
        }
        return ans;
    }

    public void push_back(int value) {
        //记录元素
        queue.offerLast(value);
        //更新单调队列
        while(!monotonicDeque.isEmpty() && monotonicDeque.peekLast() < value){
            //弹出
            monotonicDeque.pollLast();
        }
        monotonicDeque.offerLast(value);
    }

    public static void main(String[] args) {
        int[] arr = {1,3,-1,-3,5,3,6,7};
        int k = 3;
        new Solution().maxSlidingWindow(arr,k);
    }
}
```



## 93. 复原 IP 地址

### Description

* [LeetCode-93. 复原 IP 地址](https://leetcode.cn/problems/restore-ip-addresses/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution

```java
class Solution {
    static final int SEG_COUNT = 4;
    List<String> ans = new ArrayList<String>();
    int[] segments = new int[SEG_COUNT];

    public List<String> restoreIpAddresses(String s) {
        segments = new int[SEG_COUNT];
        dfs(s, 0, 0);
        return ans;
    }

    //dfs(segId,segStart) 表示我们正在从 s[segStart] 的位置开始，搜索 IP 地址中的第 segId 段，其中 segId∈{0,1,2,3}
    public void dfs(String s, int segId, int segStart) {
        // 如果找到了 4 段 IP 地址并且遍历完了字符串，那么就是一种答案
        if (segId == SEG_COUNT) {
            if (segStart == s.length()) {
                StringBuffer ipAddr = new StringBuffer();
                for (int i = 0; i < SEG_COUNT; ++i) {
                    ipAddr.append(segments[i]);
                    if (i != SEG_COUNT - 1) {
                        ipAddr.append('.');
                    }
                }
                ans.add(ipAddr.toString());
            }
            return;
        }

        // 如果还没有找到 4 段 IP 地址就已经遍历完了字符串，那么提前回溯
        if (segStart == s.length()) {
            return;
        }

        // 由于不能有前导零，如果当前数字为 0，那么这一段 IP 地址只能为 0
        if (s.charAt(segStart) == '0') {
            segments[segId] = 0;
            dfs(s, segId + 1, segStart + 1);
        }

        // 一般情况，枚举每一种可能性并递归
        int addr = 0;
        for (int segEnd = segStart; segEnd < s.length(); ++segEnd) {
            addr = addr * 10 + (s.charAt(segEnd) - '0');
            if (addr > 0 && addr <= 0xFF) {
                segments[segId] = addr;
                dfs(s, segId + 1, segEnd + 1);
            } else {
                break;
            }
        }
    }
}

```



## 781. 森林中的兔子

### Description

* [LeetCode-781. 森林中的兔子](https://leetcode.cn/problems/rabbits-in-forest/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。

一般地，如果有 x 只兔子都回答 y，则至少有 $\lceil\dfrac{x}{y+1}\rceil$ 种不同的颜色，且每种颜色有 y+1 只兔子，因此兔子数至少为

$$
\lceil\dfrac{x}{y+1}\rceil\cdot(y+1)
$$

我们可以用哈希表统计各个元素的出现次数，对每个元素套用上述公式计算，并将计算结果累加，即为最终答案。

在代码实现，若求 $\lceil\dfrac{x}{y}\rceil$，等价于求 `(x+y-1)/y`。
所以，若求 $\lceil\dfrac{x}{y+1}\rceil$，等价于求 `(x+(y+1)-1)/(y+1)` = `(x+y)/(y+1)`。

#### Solution


```java
class Solution {
    public int numRabbits(int[] answers) {
        Map<Integer, Integer> count = new HashMap<Integer, Integer>();
        for (int y : answers) {
            count.put(y, count.getOrDefault(y, 0) + 1);
        }
        int ans = 0;
        for (Map.Entry<Integer, Integer> entry : count.entrySet()) {
            int y = entry.getKey(), x = entry.getValue();
            //有x只兔子回答了y
            ans += (x + y) / (y + 1) * (y + 1);
        }
        return ans;
    }
}
```




## 剑指 Offer 45. 把数组排成最小的数

### Description

* [LeetCode-剑指 Offer 45. 把数组排成最小的数](https://leetcode.cn/problems/ba-shu-zu-pai-cheng-zui-xiao-de-shu-lcof/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。

此题求拼接起来的最小数字，本质上是一个排序问题。设数组 nums 中任意两数字的字符串为 x 和 y ，则规定排序判断规则为
* 若拼接字符串 x + y > y + x，则 x “大于” y；
* 反之，若 x + y < y + x，则 x “小于” y；
  
x “小于” y 代表在排序完成后，数组中 x 应在 y 左边；“大于” 则反之。


#### Solution



```java
class Solution {
    public String minNumber(int[] nums) {
        String[] strs = new String[nums.length];
        for(int i = 0; i < nums.length; i++)
            strs[i] = String.valueOf(nums[i]);
        Arrays.sort(strs, (x, y) -> (x + y).compareTo(y + x));
        StringBuilder res = new StringBuilder();
        for(String s : strs)
            res.append(s);
        return res.toString();
    }
}
```


或


```java
class Solution {
    public String minNumber(int[] nums) {
        String[] strs = new String[nums.length];
        for(int i = 0; i < nums.length; i++){
            strs[i] = String.valueOf(nums[i]);
        }
        quickSort(strs, 0, strs.length - 1);
        StringBuilder res = new StringBuilder();
        for(String s : strs){
            res.append(s);
        }
        return res.toString();
    }
    void quickSort(String[] strs, int l, int r) {
        if(l >= r) {
            return;
        }
        int i = l, j = r;
        String tmp = strs[i];
        
        while(i < j) {
            while((strs[j] + strs[l]).compareTo(strs[l] + strs[j]) >= 0 && i < j) {
                j--;
            }
            while((strs[i] + strs[l]).compareTo(strs[l] + strs[i]) <= 0 && i < j){
                i++;
            }
            tmp = strs[i];
            strs[i] = strs[j];
            strs[j] = tmp;
        }
        strs[i] = strs[l];
        strs[l] = tmp;
        quickSort(strs, l, i - 1);
        quickSort(strs, i + 1, r);
    }
}

```


## 85. 最大矩形


### Description

* [LeetCode-85. 最大矩形](https://leetcode.cn/problems/maximal-rectangle/)

### Approach 1-动态规划

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public int maximalRectangle(char[][] matrix) {
        int m = matrix.length;
        if (m == 0) {
            return 0;
        }
        int n = matrix[0].length;
        //统计该元素所在行 左侧连续1的个数
        int[][] left = new int[m][n];

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (matrix[i][j] == '1') {
                    left[i][j] = (j == 0 ? 0 : left[i][j - 1]) + 1;
                }
            }
        }

        int ret = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (matrix[i][j] == '0') {
                    continue;
                }
                //认定[i][j]为矩形的右小角
                int width = left[i][j];
                int area = width;
                for (int k = i - 1; k >= 0; k--) {
                    width = Math.min(width, left[k][j]);
                    area = Math.max(area, (i - k + 1) * width);
                }
                ret = Math.max(ret, area);
            }
        }
        return ret;
    }
}

```

## 718. 最长重复子数组


### Description

* [LeetCode-718. 最长重复子数组](https://leetcode.cn/problems/maximum-length-of-repeated-subarray/)

### Approach 1-动态规划

#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public int findLength(int[] A, int[] B) {
        int n = A.length, m = B.length;
        int[][] dp = new int[n + 1][m + 1]; //dp[i][j] 表示从i开始到末尾 从j开始到末尾的 最长公共子数组
        int ans = 0;
        for (int i = n - 1; i >= 0; i--) {
            for (int j = m - 1; j >= 0; j--) {
                dp[i][j] = A[i] == B[j] ? dp[i + 1][j + 1] + 1 : 0;
                ans = Math.max(ans, dp[i][j]);
            }
        }
        return ans;
    }
}
```


## 198. 打家劫舍


### Description

* [LeetCode-198. 打家劫舍](https://leetcode.cn/problems/house-robber/)

### Approach 1-动态规划

#### Analysis


参考 `leetcode-cn` 官方题解。


此题有个误区，不能认为取一次奇数位置元素的求和，再取一次偶数位置元素求和，返回两者的最大值，代码如下。

```java
class Solution {
    public int rob(int[] nums) {
        int len = nums.length;
        int sum1 = 0;
        int sum2 = 0;
        for(int i=0;i<len;i++){
            if(i%2 == 0){
                sum1 += nums[i];
            } else {
                sum2 += nums[i];
            }
        }
        return Math.max(sum1,sum2);
    }
}
```

这是不对的，如 `[2,1,1,4]`，最大价值为 `2+2 = 4`，即不是每间隔偷盗一次。



本题可以采用动态规划求解。用 `dp[i]` 表示前 `i` 间房屋能偷窃到的最高总金额，那么就有如下的状态转移方程

```s
dp[i]=max(dp[i−2]+nums[i],dp[i−1])
```


#### Solution



```java
class Solution {
    public int rob(int[] nums) {
        if (nums == null || nums.length == 0) {
            return 0;
        }
        int length = nums.length;
        if (length == 1) {
            return nums[0];
        }
        int[] dp = new int[length];
        dp[0] = nums[0];
        dp[1] = Math.max(nums[0], nums[1]);
        for (int i = 2; i < length; i++) {
            dp[i] = Math.max(dp[i - 2] + nums[i], dp[i - 1]);
        }
        return dp[length - 1];
    }
}
```





## 213. 打家劫舍 II


### Description

* [LeetCode-213. 打家劫舍 II](https://leetcode.cn/problems/house-robber-ii/)

### Approach 1-动态规划

#### Analysis


参考 `leetcode-cn` 官方题解。


和「198. 打家劫舍」相比，本题目找那个数组首尾是相连的。可以将问题拆分，拆分为两个子问题
1. 区间 [0,length-1]
2. 区间 [1,length]


对每个子问题，使用「198. 打家劫舍」方法求解。最后返回两个子问题的最大值。


#### Solution



```java
class Solution {
    public int rob(int[] nums) {
        if (nums == null || nums.length == 0) {
            return 0;
        }
        int length = nums.length;
        if (length == 1) {
            return nums[0];
        }
        int[] dp = new int[length]; //统计区间[0,length-1]
        int[] fp = new int[length]; //统计区间[1,length]
        dp[0] = nums[0];
        dp[1] = Math.max(nums[0], nums[1]);
        fp[0] = 0;
        fp[1] = nums[1];
        if(length > 2){
            fp[2] = Math.max(nums[1], nums[2]);
        }

        for (int i = 2; i < length; i++) {
            dp[i] = Math.max(dp[i - 2] + nums[i], dp[i - 1]);
            if(i > 2){
                fp[i] = Math.max(fp[i - 2] + nums[i], fp[i - 1]);
            }
        }
        return Math.max(dp[length - 2],fp[length-1]);
    }
}
```


## 剑指 Offer 38. 字符串的排列


### Description

* [LeetCode-剑指 Offer 38. 字符串的排列](https://leetcode.cn/problems/zi-fu-chuan-de-pai-lie-lcof/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。


1. 为了记录字符串使用过，创建一个访问数组进行标记
2. 为了防止出现重复排列，先对字符串排序，这样重复的字符就会出现在一起。然后使用如下进行判断。


```java
for(int i=0;i<len;i++){
    if(visited[i] || (i > 0 && arr[i] == arr[i-1] && visited[i - 1])){
        continue;
    }
    ...
}
```

#### Solution

```java
class Solution {
    List<String> list = new ArrayList<>();
    boolean[] visited;

    public String[] permutation(String s) {
       
        int len = s.length();
        if(len == 1){
            return new String[]{s};
        }
        visited = new boolean[len];
        //对字符串排序 保证重复字符相邻
        char[] arr = s.toCharArray();
        Arrays.sort(arr);
        StringBuffer sb = new StringBuffer();

        backtrack(arr,0,len,sb);

        int size = list.size();
        String[] recArr = new String[size];
        for (int i = 0; i < size; i++) {
            recArr[i] = list.get(i);
        }
        return recArr;
    }

    public void backtrack(char[] arr,int curLen,int len,StringBuffer sb){
        if(curLen == len){
            list.add(sb.toString());
            return;
        }
        for(int i=0;i<len;i++){
            if(visited[i] || (i > 0 && arr[i] == arr[i-1] && visited[i - 1])){
                continue;
            }
            visited[i] = true; //标记已经访问
            sb.append(arr[i]);
            backtrack(arr,curLen+1,len,sb);
            sb.deleteCharAt(sb.length() - 1);
            visited[i] = false; //标记清除
        }
    }
}
```


## 199. 二叉树的右视图


### Description

* [LeetCode-199. 二叉树的右视图](https://leetcode.cn/problems/binary-tree-right-side-view/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。

#### Solution


```java

class Solution {
    public List<Integer> rightSideView(TreeNode root) {
        List<Integer> list = new ArrayList<>();
        if(root == null){
            return list;
        }

        Deque<TreeNode> deque = new LinkedList<>();
        deque.addLast(root);
        while(!deque.isEmpty()){
            int size = deque.size();
            boolean hasInsert = false;
            for(int i=0;i<size;i++){
                TreeNode node = deque.pollFirst();
                if(!hasInsert){
                    list.add(node.val);
                    hasInsert = true;
                }
                if(node.right != null){
                    deque.addLast(node.right);
                }
                if(node.left != null){
                    deque.addLast(node.left);
                }
            }
           
        }
        return list;
    }
}
```


## 剑指 Offer 65. 不用加减乘除做加法


### Description

* [LeetCode-剑指 Offer 65. 不用加减乘除做加法](https://leetcode.cn/problems/bu-yong-jia-jian-cheng-chu-zuo-jia-fa-lcof/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。

#### Solution

自我实现版本，和官方版本不一样。


```java
class Solution {
    public int add(int a, int b) {
        if (b == 0) {
            return a;
        }
        // 转换成非进位和 + 进位
        return add(a ^ b, (a & b) << 1);
    }
}
```


## 45. 跳跃游戏 II

### Description

* [LeetCode-45. 跳跃游戏 II](https://leetcode.cn/problems/jump-game-ii/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。

#### Solution

自我实现版本，和官方版本不一样。



```java
class Solution {
    public int jump(int[] nums) {
        int len = nums.length;
        int[] dp = new int[len];
        dp[0] = 0;
        for(int i=0;i<len;i++){
            int step = nums[i];
            while(step > 0){
                if(i+step < len){
                    if(dp[i+step] == 0){
                        dp[i+step] = dp[i] + 1;
                    } else {
                        dp[i+step] = Math.min(dp[i+step],1+dp[i]);
                    }
                }
                step--;
                
            }
        }
        return dp[len-1];
    }
}
```

## 55. 跳跃游戏

### Description

* [LeetCode-55. 跳跃游戏](https://leetcode.cn/problems/jump-game/)

### Approach 1

#### Analysis


参考 `leetcode-cn` 官方题解。

#### Solution

自我实现版本，和官方版本不一样。



```java
class Solution {
    public boolean canJump(int[] nums) {
        int len = nums.length;
        if(len == 1){
            return true;
        }
        
        boolean[] dp = new boolean[len];
        dp[0] = true;
        
        for(int i=0;i<len;i++){
            int step = nums[i];
            if(step == 0){ //是continue 因为后续可能有可到达的节点
                continue;
            }
            while(step > 0 && dp[i]){ //只在dp[i]=true  可到达的时候才继续
                if(i+step < len){
                    dp[i+step] = true;
                }
                step--;
                
            }
        }
        return dp[len-1];
    }
}
```


## 189. 轮转数组

### Description

* [LeetCode-189. 轮转数组](https://leetcode.cn/problems/rotate-array/)

### Approach 1-额外空间数组

#### Analysis


参考 `leetcode-cn` 官方题解。


向右轮转 k 个位置，就是将第 `i` 个元素，移动到第 `i+k` 个位置，考虑数组长度后，移动公式为

```s
newArr[(i + k) % n] = nums[i];
```


复杂度分析
1. 时间复杂度：`O(n)`
2. 空间复杂度：`O(n)`


#### Solution


```java
class Solution {
    public void rotate(int[] nums, int k) {
        int n = nums.length;
        int[] newArr = new int[n];
        for (int i = 0; i < n; ++i) {
            newArr[(i + k) % n] = nums[i];
        }
        System.arraycopy(newArr, 0, nums, 0, n);
    }
}
```


### Approach 2-数组翻转

#### Analysis


参考 `leetcode-cn` 官方题解。


使用数组翻转求解
1. 先将整个数组翻转
2. 再将前 `k%n` 个元素翻转，即区间 `[0,k%n - 1]`
3. 最后将剩下的`n - k%n` 个元素翻转，即区间 `[k%n,n]`


复杂度分析
1. 时间复杂度：`O(n)`
2. 空间复杂度：`O(1)`


#### Solution

```java
class Solution {
    public void rotate(int[] nums, int k) {
        int n = nums.length;
        reverse(nums,0,n-1);
        reverse(nums,0,k%n -1);
        reverse(nums,k%n,n-1);       
    }

    private void reverse(int[] nums, int begin,int end){
        while(begin < end){
            int temp = nums[begin];
            nums[begin] = nums[end];
            nums[end] = temp;
            begin++;
            end--;
        }
    }
}
```


## 153. 寻找旋转排序数组中的最小值


### Description

* [LeetCode-153. 寻找旋转排序数组中的最小值](https://leetcode.cn/problems/find-minimum-in-rotated-sorted-array/)


### Approach 1-二分查找

#### Analysis


参考 `leetcode-cn` 官方题解。



**如果是两段有序的数组，虽然不是全局有序，依旧可以使用二分查找求解。**


**简化判断逻辑，只用 `arr[mid]` 和 `arr[high]` 判断，不考虑 `arr[low]`。**

#### Solution


```java
class Solution {
    public int findMin(int[] nums) {
        int low = 0;
        int high = nums.length - 1;
        while (low < high) {
            int pivot = low + (high - low) / 2;
            if (nums[pivot] < nums[high]) {
                high = pivot; //注意这里为 pivot 而不是 pivot-1  因为pivot可能就是最小的
            } else {
                low = pivot + 1;
            }
        }
        return nums[low];
    }
}
```



## 154. 寻找旋转排序数组中的最小值 II


### Description

* [LeetCode-154. 寻找旋转排序数组中的最小值 II](https://leetcode.cn/problems/find-minimum-in-rotated-sorted-array-ii/)


### Approach 1-二分查找

#### Analysis


参考 `leetcode-cn` 官方题解。



本题和「153. 寻找旋转排序数组中的最小值」的区别是，数组元素可能出现重复。
1. 对于 `arr[mid] != arr[high]` 的情况，正常二分查找
2. 对于 `arr[mid] == arr[high]` 的情况，基于贪心的思想，如果 `arr[high]` 是最小元素，那么在查找时一定可用 `arr[mid]` 代替，所以可以缩小边界，即 `high--`

**简化判断逻辑，只用 `arr[mid]` 和 `arr[high]` 判断，不考虑 `arr[low]`。**

#### Solution

```java
class Solution {
    public int findMin(int[] nums) {
        int low = 0;
        int high = nums.length - 1;
        while (low < high) {
            int pivot = low + (high - low) / 2;
            if (nums[pivot] < nums[high]) {
                high = pivot;
            } else if (nums[pivot] > nums[high]) {
                low = pivot + 1; //pivot 不可能是最小元素 可以直接抛弃 所以是 pivot + 1
            } else {
                //nums[pivot] == nums[high]
                //此时无法判断最小元素是在左边还是右边  
                //如果nums[high]是最小元素，那么在查找时一定可用nums[pivot] 代替
                //基于贪心暴力的思想 可以让 high--  缩小查找的区间
                high -= 1;
            }
        }
        return nums[low];
    }
}
```



## 面试题 10.03. 搜索旋转数组


### Description

* [LeetCode-面试题 10.03. 搜索旋转数组](https://leetcode.cn/problems/search-rotate-array-lcci/)


### Approach 1-二分查找

#### Analysis


参考 `leetcode-cn` 官方题解。




**简化判断逻辑，只用 `arr[mid]` 和 `arr[high]` 判断，不考虑 `arr[low]`。**

#### Solution


```java
class Solution {
    public int search(int[] arr, int target) {
        //题目已经限制数组长度最小为1
        if(arr[0] == target){
            return 0;
        }
        int high = arr.length -1;
        int low = 0;

        while(low <= high){ //注意此处可以取等  循环结束条件是 arr[mid] == target
            int mid = low + (high - low)/2;
            if(arr[mid] == target){
                while(mid > 0 && arr[mid-1] == target){
                    mid--; //找到最靠左边的相等的位置
                }
                return mid;
            }
          
            if(arr[mid] < arr[high]){
                // 右区间是递增的 判断target是否在中间
                if(target > arr[mid] && target <= arr[high]){
                    low = mid + 1;
                } else {
                    high = mid -1;
                }
            } else if(arr[mid] > arr[high]){
                //左边区间是递增的
                //判断target是否在中间
                if(target >= arr[low] && target < arr[mid]){
                    high = mid - 1;
                } else {
                    low = mid +1;
                }
            } else {
                //arr[mid] == arr[high] != target
                //此时无法判断是在左区间还是右区间
                //但是可以确认的是 arr[high] 一定是无用的，所以基于贪心暴力的思想 缩短边界
                high--;
            }
        }

        return -1;  //找不到的话 返回-1
 
    }
}

```