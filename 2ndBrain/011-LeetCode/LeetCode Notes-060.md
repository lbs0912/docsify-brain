
# LeetCode Notes-060


[TOC]



## 更新
* 2021/08/10，撰写
* 2021/08/15，撰写



## Overview
* [LeetCode-1624. 两个相同字符之间的最长子字符串](https://leetcode-cn.com/problems/largest-substring-between-two-equal-characters/description/)
* [LeetCode-867. 转置矩阵](https://leetcode-cn.com/problems/transpose-matrix/description/)
* [LeetCode-868. 二进制间距](https://leetcode-cn.com/problems/binary-gap/description/)
* [LeetCode-1608. 特殊数组的特征值](https://leetcode-cn.com/problems/special-array-with-x-elements-greater-than-or-equal-x/description/)
* [LeetCode-1022. 从根到叶的二进制数之和](https://leetcode-cn.com/problems/sum-of-root-to-leaf-binary-numbers/description/)







## 1624. 两个相同字符之间的最长子字符串
### Description
* [LeetCode-1624. 两个相同字符之间的最长子字符串](https://leetcode-cn.com/problems/largest-substring-between-two-equal-characters/description/)

### Approach 1-双重for循环
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public int maxLengthBetweenEqualCharacters(String s) {
        int count = -1;
        int len = s.length();
        for(int i=0;i<len;i++){
            for(int j=len-1;j>i;j--){
                if(s.charAt(i) == s.charAt(j)){
                    count = Math.max(j-i-1,count);
                }
            }
        }
        return count;
    }
}
```


### Approach 2- lastIndexOf()

#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int maxLengthBetweenEqualCharacters(String s) {
        int count = -1;
        int len = s.length();
        for(int i=0;i<len;i++){
            int index = s.lastIndexOf(s.charAt(i));
            count = Math.max(index-i-1,count);  
        }
        return count;
    }
}
```


## 867. 转置矩阵
### Description
* [LeetCode-867. 转置矩阵](https://leetcode-cn.com/problems/transpose-matrix/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int[][] transpose(int[][] matrix) {
        int m = matrix.length;
        int n = matrix[0].length;
        //对于m*n的矩阵，转置后为n*m的矩阵
        // 输入：matrix = [[1,2,3],[4,5,6]]
        // 输出：[[1,4],[2,5],[3,6]]
        int[][] transposed = new int[n][m];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                transposed[j][i] = matrix[i][j];
            }
        }
        return transposed;

    }
}
```



## 868. 二进制间距
### Description
* [LeetCode-868. 二进制间距](https://leetcode-cn.com/problems/binary-gap/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int binaryGap(int n) {
        if(n == 1){
            return 0;
        }
        int maxDistance = 0;
        StringBuffer sb = new StringBuffer();
        while(n>0){
            sb.append(n%2);
            n = n/2;
        }
        String str = sb.toString();
      

        int len  = str.length();
        int index = str.indexOf("1");;

        while(-1 != index  && index < len){
            if(-1 == index || index == len-1){
                return maxDistance;
            }
            int tmpIndex = str.indexOf("1",index+1);
            if(-1 == tmpIndex){
                return maxDistance;
            }
            maxDistance = Math.max(maxDistance,tmpIndex-index);
            index = tmpIndex;
        }

        return maxDistance;
    }
}
```




## 1608. 特殊数组的特征值
### Description
* [LeetCode-1608. 特殊数组的特征值](https://leetcode-cn.com/problems/special-array-with-x-elements-greater-than-or-equal-x/description/)

### Approach 1-暴力枚举O(N^2)
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int specialArray(int[] nums) {
        int len = nums.length;
        //双重for循环 暴力枚举 特征值最大为nums.length
        for(int i=1;i<=len;i++){
            int count = 0;
            for(int num:nums){
                if(num >= i){
                    count++;
                }
            }
            if(count == i){
                return i;
            }
        }
        return  -1;
    }
}
```


### Approach 2-计数+后缀和O(N)
#### Analysis

参考 `leetcode-cn` 官方题解。


先对元素进行计数， >=N 的元素可视为N计数，因为特征值最大为 N。然后再计算数数组的后缀和。


```java
//原数组
arr = [0,3,0,4,4]
//计数
cnt = [0,0,0,1,2]
//后缀和
sum = [3,3,3,3,2]

// sum[3] == 3  故特征值为3
```



#### Solution

```java
class Solution {
    public int specialArray(int[] nums) {
        int len = nums.length;
        int[] cnt = new int[len+1];
        //先对元素进行计数 >=N的元素可视为N计数 因为特征值最大为N
        for(int num:nums){
            cnt[Math.min(num,len)]++;
        }
        //计算数数组的后缀和
        for(int i=len;i>=0;i--){
            if(i < len){
                cnt[i] += cnt[i+1];
            }
            if(cnt[i] == i){
                return i;
            }
        }
        return  -1;
    }
}
```





## 【经典好题】1022. 从根到叶的二进制数之和


### Description
* [LeetCode-1022. 从根到叶的二进制数之和](https://leetcode-cn.com/problems/sum-of-root-to-leaf-binary-numbers/description/)

### Approach 1-BFS
#### Analysis

参考 `leetcode-cn` 官方题解。

```s
* 输入：root = [1,0,1,0,1,0,1]
* 输出：22
* 解释：(100) + (101) + (110) + (111) = 4 + 5 + 6 + 7 = 22
```

虽然官方给出的求解过程如上，给人感觉是要深度优先遍历，然后获取到每个路径的二进制值，最后再将二进制转化为十进制求和。但仔细分析会发现，采用广度优先遍历效果更好，树的上一层的值需要全部乘以2，再加上下一层的值，如下所示


```s
* 输入：root = [1,0,1,0,1,0,1]
* 输出：22
* 解释：(100) + (101) + (110) + (111) 
    = {(1*2 + 0)*2 + 0} + {(1*2 + 0)*2 + 1} + {(1*2 + )*2 + 0} + {(1*2 + 1)*2 + 1}
```




#### Solution



```java
class Solution {
    public int sumRootToLeaf(TreeNode root) {
        if(root == null){
            return 0;
        }
        int res = 0;
        Queue<TreeNode> nodeQueue = new LinkedList<>(); //维护节点关系
        Queue<Integer> queue = new LinkedList<>(); //维护二进制值
        nodeQueue.add(root);
        queue.add(root.val);

        while(!nodeQueue.isEmpty()){
            TreeNode node = nodeQueue.poll();
            int tmp = queue.poll();

            // 如果该节点是叶子节点，加到res中
            if(node.left == null && node.right == null){
                res += tmp;
            } else {
                // 左节点不为空时，左节点进入队列，左节点对应的值是当前节点tmp<<1+node.left.val
                if(node.left != null){
                    nodeQueue.add(node.left);
                    queue.add((tmp<<1) + node.left.val);
                }
                if(node.right != null){
                    nodeQueue.add(node.right);
                    queue.add((tmp<<1) + node.right.val);
                }
            }
        }
        return res;

    }
}
```




### Approach 2-DFS
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    int res = 0; //定义的res为类的变量，调用preOrder会改变res
    public int sumRootToLeaf(TreeNode root){
        preOrder(root,0);
        return res;
    }
    public void preOrder(TreeNode root, int val){
        if(root != null){
            // 值先移位，后相加
            int tmp = (val<<1) + root.val;
                
            // 当前节点是叶子节点
            if(root.left == null && root.right == null){
                res += tmp;
            } else {
                // 当前节点的左子节点不为空，继续递归，val的值是父节点的值，也就是tmp
                if(root.left != null){
                    preOrder(root.left, tmp);
                }
                if(root.right != null){
                    preOrder(root.right, tmp);
                }
            }
        }
    }
}
```