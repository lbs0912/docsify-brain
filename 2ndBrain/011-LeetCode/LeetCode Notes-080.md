
# LeetCode Notes-080


[TOC]



## 更新
* 2021/01/07，撰写
* 2022/01/12，完成



## Overview
* [LeetCode-538. 把二叉搜索树转换为累加树](https://leetcode-cn.com/problems/convert-bst-to-greater-tree/)
* [LeetCode-1038. 把二叉搜索树转换为累加树](https://leetcode-cn.com/problems/binary-search-tree-to-greater-sum-tree/)
* [LeetCode-539. 最小时间差](https://leetcode-cn.com/problems/minimum-time-difference/)
* [LeetCode-2094. 找出 3 位偶数](https://leetcode-cn.com/problems/finding-3-digit-even-numbers/)
* [LeetCode-1779. 找到最近的有相同 X 或 Y 坐标的点](https://leetcode-cn.com/problems/find-nearest-point-that-has-the-same-x-or-y-coordinate/description/)






## 538. 把二叉搜索树转换为累加树
### Description
* [LeetCode-538. 把二叉搜索树转换为累加树](https://leetcode-cn.com/problems/convert-bst-to-greater-tree/)

### Approach 1-常规


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution

```java
class Solution {
    private int sum;
    public TreeNode convertBST(TreeNode root) {
        //累加树  右 -> 中 -> 左
        sum  = 0;
        middleOrderDfs(root);
        return root;
    }

    private void middleOrderDfs(TreeNode node){
        if(null == node){
            return;
        }
        middleOrderDfs(node.right);
        node.val += sum;
        sum = node.val;
        middleOrderDfs(node.left);
    }
}
```



## 1038. 把二叉搜索树转换为累加树
### Description
* [LeetCode-1038. 把二叉搜索树转换为累加树](https://leetcode-cn.com/problems/binary-search-tree-to-greater-sum-tree/)

### Approach 1-常规


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution



```java
class Solution {
    private int sum;
    public TreeNode bstToGst(TreeNode root) {
        //累加树  右 -> 中 -> 左
        sum  = 0;
        middleOrderDfs(root);
        return root;
    }

    private void middleOrderDfs(TreeNode node){
        if(null == node){
            return;
        }
        middleOrderDfs(node.right);
        node.val += sum;
        sum = node.val;
        middleOrderDfs(node.left);
    }
}
```



## 539. 最小时间差
### Description
* [LeetCode-539. 最小时间差](https://leetcode-cn.com/problems/minimum-time-difference/)

### Approach 1-常规


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public int findMinDifference(List<String> timePoints) {
        Collections.sort(timePoints); //字符串排序
        //最小时间差出现在相邻的元素 或者 首尾部元素!!!
        int ans = Integer.MAX_VALUE;
        int t0Minutes = getMinutes(timePoints.get(0));
        int preMinutes = t0Minutes;
        for(int i=1;i<timePoints.size();i++){
            int minutes = getMinutes(timePoints.get(i));
            ans = Math.min(ans, minutes - preMinutes); // 相邻时间的时间差
            preMinutes = minutes;
        }
        ans = Math.min(ans, t0Minutes + 1440 - preMinutes); // 首尾时间的时间差 !!!
        return ans;
    }
    public int getMinutes(String t) {
        return ((t.charAt(0) - '0') * 10 + (t.charAt(1) - '0')) * 60 + (t.charAt(3) - '0') * 10 + (t.charAt(4) - '0');
    }
}
```




## 2094. 找出 3 位偶数
### Description
* [LeetCode-2094. 找出 3 位偶数](https://leetcode-cn.com/problems/finding-3-digit-even-numbers/)

### Approach 1-三重for循环


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution



```java
class Solution {
    public int[] findEvenNumbers(int[] digits) {
        int len = digits.length;
        Arrays.sort(digits); //sort
        Set<Integer> set = new HashSet<>();

        for(int i=0;i<len;i++){
            for(int j=0;j<len;j++){
                for(int k=0;k<len;k++){
                    if(i == j || i == k || j == k){
                        continue;
                    }
                    int num = digits[i]*100 + digits[j]*10 + digits[k];
                    if(num >= 100 && num%2 == 0){
                        set.add(num);
                    }
                }
            }
        }
        List<Integer> list = new ArrayList<>(set);
        Collections.sort(list);
        return list.stream().mapToInt(i->i).toArray();
    }
}
```





## 1779. 找到最近的有相同 X 或 Y 坐标的点
### Description
* [LeetCode-1779. 找到最近的有相同 X 或 Y 坐标的点](https://leetcode-cn.com/problems/find-nearest-point-that-has-the-same-x-or-y-coordinate/description/)

### Approach 1-常规


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution



```java
class Solution {
    public int nearestValidPoint(int x, int y, int[][] points) {
        int index = -1;
        int minDistance = Integer.MAX_VALUE;
        for(int i=0;i<points.length;i++){
            if(points[i][0] == x || points[i][1] == y){
                int distance = Math.abs(x-points[i][0]) + Math.abs(y-points[i][1]);
                if(distance < minDistance){
                    minDistance = distance;
                    index = i;
                }
            }
        }
        return index;
    }

}
```