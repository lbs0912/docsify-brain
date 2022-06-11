
# LeetCode Notes-022


[TOC]



## 更新
* 2021/03/07，撰写
* 2021/03/07，完成


## Overview
* [LeetCode-482. 密钥格式化](https://leetcode-cn.com/problems/license-key-formatting/)
* [LeetCode-506. 相对名次](https://leetcode-cn.com/problems/relative-ranks/)
* [LeetCode-189. 旋转数组](https://leetcode-cn.com/problems/rotate-array/)
* [LeetCode-151. 翻转字符串里的单词](https://leetcode-cn.com/problems/reverse-words-in-a-string/)
* [LeetCode-105. 从前序与中序遍历序列构造二叉树](https://leetcode-cn.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/)



## 482. 密钥格式化
### Description
* [LeetCode-482. 密钥格式化](https://leetcode-cn.com/problems/license-key-formatting/)

### Approach 1-常规

#### Analysis


参考 `leetcode-cn` 官方题解。




#### Solution

```java
public class Solution {
    public String licenseKeyFormatting(String s, int k) {
        StringBuilder sb = new StringBuilder();
        for (int i = s.length() - 1; i >= 0; i--)
            if (s.charAt(i) != '-'){
                sb.append(sb.length() % (k + 1) == k ? '-' : "").append(s.charAt(i));
            }
               
        return sb.reverse().toString().toUpperCase();
    } 
}
```



## 506. 相对名次
### Description
* [LeetCode-506. 相对名次](https://leetcode-cn.com/problems/relative-ranks/)

### Approach 1-排序+二分查找

#### Analysis


参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度： `O(n)`，其中 n 为数组的长度。
* 空间复杂度： `O(n)`。


#### Solution

```java
class Solution {
    public String[] findRelativeRanks(int[] nums) {
        int[] numArrCopy = Arrays.copyOf(nums,nums.length);
        Arrays.sort(nums);
        Map<Integer,Integer> map = new HashMap<>();
        for(int i=0,j=nums.length;i<nums.length;i++,j--){
            map.put(nums[i],j);
        }
        String [] res = new String[map.size()];
        for(int i=0;i<numArrCopy.length;i++){
            Integer j = map.get(numArrCopy[i]);
            switch(j){
                case 1:
                    res[i] = "Gold Medal";
                    break;
                case 2:
                    res[i] = "Silver Medal";
                    break;
                case 3:
                    res[i] = "Bronze Medal";
                    break;
                default:
                    res[i] = j.toString();
                    break;
            }
        }
        return res;
    }
}
```






## 189. 旋转数组
### Description
* [LeetCode-189. 旋转数组](https://leetcode-cn.com/problems/rotate-array/)

### Approach 1-使用额外的数组

#### Analysis


参考 `leetcode-cn` 官方题解。


复杂度分析
* 时间复杂度： `O(n)`，其中 n 为数组的长度。
* 空间复杂度： `O(n)`。


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



该方法基于如下的事实：当我们将数组的元素向右移动 k 次后，尾部 `$k\bmod n$` 个元素会移动至数组头部，其余元素向后移动 `%k\bmod n%` 个位置。

该方法为数组的翻转：我们可以先将所有元素翻转，这样尾部的 `$k\bmod n$` 个元素就被移至数组头部，然后我们再翻转 `$[0, k\bmod n-1]$` 区间的元素和 `$[k\bmod n, n-1]$` 区间的元素即能得到最后的答案。

我们以 n=7，k=3 为例进行如下展示

| 操作  |	结果 |
|-------|--------|
|原始数组 | 	1 2 3 4 5 6 7 |
| 翻转所有元素	| 7 6 5 4 3 2 1 |
| 翻转 `$[0, k\bmod n-1]$` 区间的元素 | 	5 6 7 4 3 2 1 | 
| 翻转 `$[k\bmod n, n - 1]$`区间的元素 | 	5 6 7 1 2 3 4 |





复杂度分析
* 时间复杂度： `O(n)`，其中 n 为数组的长度。每个元素被翻转两次，一共 n 个元素，因此总时间复杂度为 `O(2n)=O(n)`。
* 空间复杂度： `O(1)`。


#### Solution

```java
class Solution {
    public void rotate(int[] nums, int k) {
        k %= nums.length;
        reverse(nums, 0, nums.length - 1);
        reverse(nums, 0, k - 1);
        reverse(nums, k, nums.length - 1);
    }

    public void reverse(int[] nums, int start, int end) {
        while (start < end) {
            int temp = nums[start];
            nums[start] = nums[end];
            nums[end] = temp;
            start += 1;
            end -= 1;
        }
    }
}
```





## 151. 翻转字符串里的单词
### Description
* [LeetCode-151. 翻转字符串里的单词](https://leetcode-cn.com/problems/reverse-words-in-a-string/)

### Approach 1-常规

#### Analysis


参考 `leetcode-cn` 官方题解。

正则表达式中， `\s` 表示空格，后面添加 `+` 表示匹配1次或多次。



复杂度分析
* 时间复杂度：`O(N)`，其中 N 为输入字符串的长度。
* 空间复杂度：`O(N)`，用来存储字符串分割之后的结果。

#### Solution

```java
class Solution {
    public String reverseWords(String s) {
        // 除去开头和末尾的空白字符
        s = s.trim();
        // 正则匹配连续的空白字符作为分隔符分割
        List<String> wordList = Arrays.asList(s.split("\\s+"));
        Collections.reverse(wordList);
        return String.join(" ", wordList);
    }
}
```




## 105. 从前序与中序遍历序列构造二叉树
### Description
* [LeetCode-105. 从前序与中序遍历序列构造二叉树](https://leetcode-cn.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/)

### Approach 1-递归

#### Analysis

参考 `leetcode-cn` 官方题解。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/leetcode-105-hashmap-imporve-1.png)

复杂度分析
* 时间复杂度：`O(n)`，其中 n 是树中的节点个数。
* 空间复杂度：`O(n)`，除去返回的答案需要的 `O(n)` 空间之外，我们还需要使用 `O(n)` 的空间存储哈希映射，以及 `O(h)`（其中 h 是树的高度）的空间表示递归时栈空间。这里 `h < n`，所以总空间复杂度为 `O(n)`。



#### Solution

```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */

class Solution {
    private Map<Integer, Integer> indexMap;

    public TreeNode myBuildTree(int[] preorder, int[] inorder, int preorder_left, int preorder_right, int inorder_left, int inorder_right) {
        if (preorder_left > preorder_right) {
            return null;
        }

        // 前序遍历中的第一个节点就是根节点
        int preorder_root = preorder_left;
        // 在中序遍历中定位根节点
        int inorder_root = indexMap.get(preorder[preorder_root]);
        
        // 先把根节点建立出来
        TreeNode root = new TreeNode(preorder[preorder_root]);
        // 得到左子树中的节点数目
        int size_left_subtree = inorder_root - inorder_left;
        // 递归地构造左子树，并连接到根节点
        // 先序遍历中「从 左边界+1 开始的 size_left_subtree」个元素就对应了中序遍历中「从 左边界 开始到 根节点定位-1」的元素
        root.left = myBuildTree(preorder, inorder, preorder_left + 1, preorder_left + size_left_subtree, inorder_left, inorder_root - 1);
        // 递归地构造右子树，并连接到根节点
        // 先序遍历中「从 左边界+1+左子树节点数目 开始到 右边界」的元素就对应了中序遍历中「从 根节点定位+1 到 右边界」的元素
        root.right = myBuildTree(preorder, inorder, preorder_left + size_left_subtree + 1, preorder_right, inorder_root + 1, inorder_right);
        return root;
    }

    public TreeNode buildTree(int[] preorder, int[] inorder) {
        int n = preorder.length;
        // 构造哈希映射，帮助我们快速定位根节点
        indexMap = new HashMap<Integer, Integer>();
        for (int i = 0; i < n; i++) {
            indexMap.put(inorder[i], i);
        }
        return myBuildTree(preorder, inorder, 0, n - 1, 0, n - 1);
    }
}
```