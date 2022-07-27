# LeetCode Notes-180-并查集


[TOC]



## 更新
* 2021/07/24，撰写
* 2021/07/25，**并查集** 专题汇总


## 总览

* [LeetCode-990. 等式方程的可满足性](https://leetcode-cn.com/problems/satisfiability-of-equality-equations/)
* [LeetCode-399. 除法求值](https://leetcode-cn.com/problems/evaluate-division/)





## 990. 等式方程的可满足性
### Description
* [LeetCode-990. 等式方程的可满足性](https://leetcode-cn.com/problems/satisfiability-of-equality-equations/)


### Approach 1-并查集
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution

```java
class Solution {
    public boolean equationsPossible(String[] equations) {
        int[] parent = new int[26];
        //初始化  初始状态节点的根节点为自身
        for (int i = 0; i < 26; i++) {
            parent[i] = i;
        }
        // 等式 -> 节点联通
        for (String str : equations) {
            if (str.charAt(1) == '=') {
                int index1 = str.charAt(0) - 'a';
                int index2 = str.charAt(3) - 'a';
                union(parent, index1, index2);
            }
        }

        //不等式判断
        for (String str : equations) {
            if (str.charAt(1) == '!') {
                int index1 = str.charAt(0) - 'a';
                int index2 = str.charAt(3) - 'a';
                //寻找各自的根节点 判断是否相等
                if (find(parent, index1) == find(parent, index2)) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * 将index1 和index2 链接起来
     * @param parent
     * @param index1
     * @param index2
     */
    public void union(int[] parent, int index1, int index2) {
        parent[find(parent, index1)] = find(parent, index2);
    }

    /**
     * 找到第index个元素的根节点
     * @param parent 数组
     * @param index 索引值
     * @return 根节点
     */
    public int find(int[] parent, int index) {
        //根节点满足parent[index] = index
        while (parent[index] != index) {
            parent[index] = parent[parent[index]]; //路径压缩
            index = parent[index];  
        }
        return index;
    }
}

```




## 399. 除法求值
### Description
* [LeetCode-399. 除法求值](https://leetcode-cn.com/problems/evaluate-division/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution




