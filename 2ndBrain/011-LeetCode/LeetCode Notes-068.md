
# LeetCode Notes-068


[TOC]



## 更新
* 2021/11/15，撰写
* 2021/11/21，完成



## Overview
* [LeetCode-1002. 查找共用字符](https://leetcode-cn.com/problems/find-common-characters/)
* [LeetCode-559. N 叉树的最大深度](https://leetcode-cn.com/problems/maximum-depth-of-n-ary-tree/)
* [LeetCode-572. 另一棵树的子树](https://leetcode-cn.com/problems/subtree-of-another-tree/description/)
* [LeetCode-501. 二叉搜索树中的众数](https://leetcode-cn.com/problems/find-mode-in-binary-search-tree/description/)
* [LeetCode-1005. K 次取反后最大化的数组和](https://leetcode-cn.com/problems/maximize-sum-of-array-after-k-negations/)



## 1002. 查找共用字符
### Description
* [LeetCode-1002. 查找共用字符](https://leetcode-cn.com/problems/find-common-characters/)



### Approach 1-哈希表
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    public List<String> commonChars(String[] words) {
        int[] alphabet = new int[26];  // 用来统计所有字符串里字符出现的最小频率
        List<String> result = new ArrayList<>();
        if(words.length == 0){
            return result;
        }
        for (int i = 0; i < words[0].length(); i++) { // 用第一个字符串对alphabet进行初始化
            alphabet[words[0].charAt(i)- 'a'] ++;
        }
        // 统计除第一个字符串外字符的出现频率
        for (int i = 1; i < words.length; i++) {
            int[] hashOtherStr= new int[26];
            for (int j = 0; j < words[i].length(); j++) {
                hashOtherStr[words[i].charAt(j)- 'a']++;
            }
            // 更新alphabet，保证alphabet里统计26个字符在所有字符串里出现的最小次数
            for (int k = 0; k < 26; k++) {
                alphabet[k] = Math.min(alphabet[k], hashOtherStr[k]);
            }
        }
        // 将hash统计的字符次数，转成输出形式
        for (int i = 0; i < 26; i++) {
            while (alphabet[i] != 0) { // 注意这里是while，多个重复的字符
                char c= (char) (i+'a'); 
                result.add(String.valueOf(c));//注意char强制指定类型
                //or
                //list.add(String.valueOf((char)('a'+i))); 
                alphabet[i]--;
            }
        }
    
        return result;
    }
}
```


## 【经典好题】559. N 叉树的最大深度
### Description
* [LeetCode-559. N 叉树的最大深度](https://leetcode-cn.com/problems/maximum-depth-of-n-ary-tree/)


`「104. 二叉树的最大深度」` 要求计算二叉树的最大深度，这道题是第 104 题的推广，从二叉树推广到 N 叉树。

### Approach 1-DFS递归
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int maxDepth(Node root) {
        if (root == null) {
            return 0;
        }
        int maxChildDepth = 0;
        List<Node> children = root.children;
        for (Node child : children) {
            int childDepth = maxDepth(child);
            maxChildDepth = Math.max(maxChildDepth, childDepth);
        }
        return maxChildDepth + 1;
    }
}
```

### Approach 2-BFS
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int maxDepth(Node root) {
        if (root == null) {
            return 0;
        }
        Queue<Node> queue = new LinkedList<Node>();
        queue.offer(root);
        int ans = 0;
        while (!queue.isEmpty()) {
            int size = queue.size();
            while (size > 0) {
                Node node = queue.poll();
                List<Node> children = node.children;
                for (Node child : children) {
                    queue.offer(child);
                }
                size--;
            }
            ans++;
        }
        return ans;
    }
}

```




## 【经典好题】572. 另一棵树的子树
### Description
* [LeetCode-572. 另一棵树的子树](https://leetcode-cn.com/problems/subtree-of-another-tree/description/)

### Approach 1-深度优先遍历+递归
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public boolean isSubtree(TreeNode s, TreeNode t) {
        return dfs(s, t);
    }

    public boolean dfs(TreeNode s, TreeNode t) {
        if (s == null) {
            return false;
        }
        return check(s, t) || dfs(s.left, t) || dfs(s.right, t);
    }

    public boolean check(TreeNode s, TreeNode t) {
        if (s == null && t == null) { //递归终止条件
            return true;
        }
        if (s == null || t == null || s.val != t.val) {
            return false;
        }
  
        return check(s.left, t.left) && check(s.right, t.right); //注意此处仍要递归
    }
}
```



## 【经典好题】501. 二叉搜索树中的众数
### Description
* [LeetCode-501. 二叉搜索树中的众数](https://leetcode-cn.com/problems/find-mode-in-binary-search-tree/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int[] findMode(TreeNode root) {
        Map<Integer,Integer> map = new HashMap<>(); //使用额外空间
        dfs(root,map);

        int maxCount = 0;
        List<Integer> resList = new ArrayList();
        for(Map.Entry<Integer,Integer> entry : map.entrySet()){
            if(entry.getValue() > maxCount){
                resList.clear();
                resList.add(entry.getKey());
                maxCount = entry.getValue();
            } else if(entry.getValue() == maxCount){
                resList.add(entry.getKey());
            }
        }
        
        return resList.stream().mapToInt(i->i).toArray();   //注意此处List<Integer> -> int[] 的方法

        // int[] res = new int[resList.size()];
        // for(int i=0;i<resList.size();i++){
        //     res[i] = resList.get(i);
        // }
        // return res;
    }

    private void dfs(TreeNode node, Map<Integer,Integer> map){
        if(null == node){
            return;
        }
        map.put(node.val,1 + map.getOrDefault(node.val, 0));
        dfs(node.left,map);
        dfs(node.right,map);
    }
}
```







## 1005. K 次取反后最大化的数组和
### Description
* [LeetCode-1005. K 次取反后最大化的数组和](https://leetcode-cn.com/problems/maximize-sum-of-array-after-k-negations/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int largestSumAfterKNegations(int[] nums, int k) {
        Arrays.sort(nums);
        int sum = 0;
        int length = nums.length;
        int negativeCount = 0;
        int index = -1; //标记负数元素的索引
        for(int i=0;i<length;i++){
            sum += Math.abs(nums[i]);
            if(nums[i] < 0){
                negativeCount++;
                index ++;
            }
        }
       
        //全部整数
        if(index == -1){
            return (k%2) == 0? sum:sum - 2*nums[0];  //只把最小的非负数转为负数
        } else{ //有负数
             //计算出绝对值最小的元素
            int minEle = Math.abs(nums[index]);
            minEle = Math.min(minEle,Math.abs(nums[Math.min(index+1,length-1)]));
    
            if(negativeCount <= k){
                if((k-negativeCount)%2 == 0){
                    //数组全部求和 负数转正
                    return sum;
                } else { //只把最小的非负数转为负数
                    return sum - 2*minEle;
                }
            } else {
                sum = 0;
                for(int i=0;i<length;i++){
                    if(i < k){
                        sum += Math.abs(nums[i]);
                    } else {
                        sum += nums[i];
                    }
                }
                return sum;
            }
        }
    }
}
```