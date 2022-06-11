
# LeetCode Notes-026


[TOC]



## 更新
* 2021/03/13，撰写
* 2021/03/13，完成


## Overview
* [LeetCode-917. 仅仅反转字母](https://leetcode-cn.com/problems/reverse-only-letters/)
* [LeetCode-812. 最大三角形面积](https://leetcode-cn.com/problems/largest-triangle-area/)
* [LeetCode-543. 二叉树的直径](https://leetcode-cn.com/problems/diameter-of-binary-tree/)
* [LeetCode-1748. 唯一元素的和](https://leetcode-cn.com/problems/sum-of-unique-elements/description/)
* [LeetCode-1668. 最大重复子字符串](https://leetcode-cn.com/problems/maximum-repeating-substring/)



## 917. 仅仅反转字母
### Description
* [LeetCode-917. 仅仅反转字母](https://leetcode-cn.com/problems/reverse-only-letters/)

### Approach 1-双指针
#### Analysis

参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度：`O(N)`，其中 N 是 S 的长度。
* 空间复杂度：`O(N)`。


#### Solution


```java
class Solution {
    public String reverseOnlyLetters(String S) {
        String[] arr = S.split("");
        int left = 0;
        int length = S.length();
        int right = length - 1;
       while(left < right){
           while( left < length && !Character.isAlphabetic(S.charAt(left))){
               left++;
           }
           while(right >= left && !Character.isAlphabetic(S.charAt(right))){
               right--;
           }
           if(left < right) {
               String tmp = arr[left];
               arr[left] = arr[right];
               arr[right] = tmp;
               left++;
               right--;
           }
        }
        return String.join("",arr);
    }
}
```


## 812. 最大三角形面积
### Description
* [LeetCode-812. 最大三角形面积](https://leetcode-cn.com/problems/largest-triangle-area/)

### Approach 1-三角形构成条件
#### Analysis

参考 `leetcode-cn` 官方题解。

1. 构成三角形的条件：`(a + b) > c && (a + c) > b && (b + c) > a`
2. 三角形面积公式

```
s = (a + b + c) / 2;
area = sqrt(s*(s -a) * (s -b) * (s - c));
```

复杂度分析
* 时间复杂度： `O(n^3)`
* 空间复杂度： `O(1)`


#### Solution


```java
class Solution {
    public double largestTriangleArea(int[][] points) {
        if(points.length < 3){
            return 0.0;
        }
        int n = points.length;
        double res = 0.0;
        for(int i=0;i<n;i++){
            for(int j=i+1;j<n;j++){
                for(int k=j+1;k<n;k++){
                    res = Math.max(res,getArea(points[i],points[j],points[k]));
                }
            }
        }
        return res;
    }
    private double getDistance(int[] a, int[] b){
        return Math.sqrt(Math.pow(a[0]-b[0],2.0) + Math.pow(a[1]-b[1],2.0));
    }
    private double getArea(int[] p1, int[] p2,int[] p3){
        double res = 0.0;
        double sideP1P2 = getDistance(p1, p2);
        double sideP1P3 = getDistance(p1, p3);
        double sideP2P3 = getDistance(p2, p3);
        if (sideP1P2 + sideP1P3 > sideP2P3 && sideP1P2 + sideP2P3 > sideP1P3 && sideP1P3 + sideP2P3 > sideP1P2) {
           double s = (sideP1P2 + sideP1P3 + sideP2P3) / 2.0;
           return Math.sqrt(s * (s - sideP1P2) * (s - sideP1P3) * (s - sideP2P3));
        }
        return res;
    }
}
```






## 543. 二叉树的直径
### Description
* [LeetCode-543. 二叉树的直径](https://leetcode-cn.com/problems/diameter-of-binary-tree/)

### Approach 1-深度遍历
#### Analysis

参考 `leetcode-cn` 官方题解。


**首先我们知道一条路径的长度为该路径经过的节点数减一，所以求直径（即求路径长度的最大值）等效于求路径经过节点数的最大值减一。**

**而任意一条路径均可以被看作由某个节点为起点，从其左儿子和右儿子向下遍历的路径拼接得到。**

假设我们知道对于该节点的左儿子向下遍历经过最多的节点数 L （即以左儿子为根的子树的深度） 和其右儿子向下遍历经过最多的节点数 R（即以右儿子为根的子树的深度），那么以该节点为起点的路径经过节点数的最大值即为 `L+R+1`。


我们记节点 node 为起点的路径经过节点数的最大值为 `$d_{\textit{node}}$`，那么二叉树的直径就是所有节点 `$d_{\textit{node}}$`的最大值减一。

最后的算法流程为：我们定义一个递归函数 `depth(node)` 计算 `$d_{\textit{node}}$`，函数返回该节点为根的子树的深度。先递归调用左儿子和右儿子求得它们为根的子树的深度 L 和 R，则该节点为根的子树的深度即为

```math
max(L,R)+1
```


该节点的 `$d_{\textit{node}}$` 值为

```
L+R+1
```

递归搜索每个节点并设一个全局变量 `ans` 记录 `$d_\textit{node}$`的最大值，最后返回 `ans-1`，即为树的直径。

复杂度分析
* 时间复杂度：`O(N)`其中 N 为二叉树的节点数，即遍历一棵二叉树的时间复杂度，每个结点只被访问一次。
* 空间复杂度：`O(Height)`，其中 `Height` 为二叉树的高度。由于递归函数在递归过程中需要为每一层递归函数分配栈空间，所以这里需要额外的空间且该空间取决于递归的深度，而递归的深度显然为二叉树的高度，并且每次递归调用的函数里又只用了常数个变量，所以所需空间复杂度为 `O(Height)`。




#### Solution


```java
class Solution {
    int ans;
    public int diameterOfBinaryTree(TreeNode root) {
        if(null == root){
            return 0;
        }
        ans = 1; 
        getDepth(root);
        return ans - 1;
    }
    private int getDepth(TreeNode node){
        if(null == node){
            return 0;
        }
        int L = getDepth(node.left); // 左儿子为根的子树的深度
        int R = getDepth(node.right); // 右儿子为根的子树的深度
        ans = Math.max(ans, L+R+1); // 计算d_node即L+R+1 并更新ans
        return Math.max(L, R) + 1; // 返回该节点为根的子树的深度
    }
}
```


## 1748. 唯一元素的和
### Description
* [LeetCode-1748. 唯一元素的和](https://leetcode-cn.com/problems/sum-of-unique-elements/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

创建一个标记数组 `arr`，`arr[i]` 等于0，表示初始化值，1表示只出现了1次，-1表示出现了多次。

复杂度分析
* 时间复杂度：`O(n)`
* 空间复杂度：`O(n)`


#### Solution

```java
class Solution {
    public int sumOfUnique(int[] nums) {
        int sum = 0;
        //标记数组  0-初始化值 1-只出现1次  -1-出现多次
        int[] arr = new int[101]; 
        for(int val:nums){
            if(arr[val] == 1){
                arr[val] = -1;
            } else if(arr[val] == 0){
                arr[val] = 1;
            }
        }
        for(int i=1; i < arr.length;i++){
            if(1 == arr[i]){
                sum += i;
            }
        }
        return sum;

    }
}
```

## 1668. 最大重复子字符串
### Description
* [LeetCode-1668. 最大重复子字符串](https://leetcode-cn.com/problems/maximum-repeating-substring/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

注意是连续的重复出现。当不符合时候，注意 `i = i - length2` 的回溯。


#### Solution


```java
class Solution {
    public int maxRepeating(String sequence, String word) {
        int length1 = sequence.length();
        int length2 = word.length();
        if(length1 == length2){
            return sequence.equals(word)? 1:0;
        }
        int count = 0;
        int i=0;
        int maxCount = 0; //连续
        while(i <= length1-length2){ //若 length1 == length2，则该while条件不满足
            String str = sequence.substring(i,i+length2);
            if(word.equals(str)){
                count++;
                i += length2;
                maxCount = Math.max(count,maxCount);
            } else{
                if(count > 0){
                    i = i - length2; //回溯
                }
                i++;
                count = 0;
            }

        }
        return maxCount;
    }
}
```


