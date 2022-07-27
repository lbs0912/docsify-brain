
# LeetCode Notes-181-回溯


[TOC]



## 更新
* 2022/01/21，撰写
* 2022/03/06，完成



## 总览
* 【经典好题】[131. 分割回文串](https://leetcode-cn.com/problems/palindrome-partitioning/)
* 【经典好题】[剑指 Offer II 079. 所有子集](https://leetcode-cn.com/problems/TVdhkn/)
* 【经典好题】[17. 电话号码的字母组合](https://leetcode-cn.com/problems/letter-combinations-of-a-phone-number/)






## 【经典好题】131. 分割回文串
### Description
* 【经典好题】[131. 分割回文串](https://leetcode-cn.com/problems/palindrome-partitioning/)


### Approach 1-回溯法


#### Analysis


参考 `leetcode-cn` 官方题解。

参考题解 [回溯算法 + 动态规划优化](https://leetcode-cn.com/problems/palindrome-partitioning/solution/hui-su-you-hua-jia-liao-dong-tai-gui-hua-by-liweiw/)


#### Solution



```java
class Solution {
    public List<List<String>> partition(String s) {
        List<List<String>> res = new ArrayList<>();
        int len = s.length();
        if(len == 0){
            return res;
        }
        // Stack 这个类 Java 的文档里推荐写成 Deque<Integer> stack = new ArrayDeque<Integer>();
        // 注意：只使用 stack 相关的接口
        Deque<String> stack = new ArrayDeque<>();
        char[] charArray = s.toCharArray();
        dfs(charArray,0,len,stack,res);
        return res;
    }

    /**
     * @param charArray
     * @param index     起始字符的索引
     * @param len       字符串 s 的长度，可以设置为全局变量
     * @param path      记录从根结点到叶子结点的路径
     * @param res       记录所有的结果
     */
    private void dfs(char[] charArray,int index,int len,Deque<String> path,List<List<String>> res){
        if(index == len){
            res.add(new ArrayList<>(path));
            return;
        }
        for(int i=index;i<len;i++){
            // 因为截取字符串是消耗性能的，因此，采用传子串下标的方式判断一个子串是否是回文子串
            if(!checkPalindrome(charArray,index,i)){
                continue;
            }
            path.add(new String(charArray,index,i+1-index));
            dfs(charArray,i+1,len,path,res);
            path.removeLast();
        }
    }

    /**
     * 这一步的时间复杂度是 O(N)，优化的解法是，先采用动态规划，把回文子串的结果记录在一个表格里
     *
     * @param charArray
     * @param left      子串的左边界，可以取到
     * @param right     子串的右边界，可以取到
     * @return
     */
    private boolean checkPalindrome(char[] charArray, int left, int right) {
        while (left < right) {
            if (charArray[left] != charArray[right]) {
                return false;
            }
            left++;
            right--;
        }
        return true;
    }
}
```


### Approach 2-回溯法+动态规划优化


#### Analysis


参考 `leetcode-cn` 官方题解。

参考题解 [回溯算法 + 动态规划优化](https://leetcode-cn.com/problems/palindrome-partitioning/solution/hui-su-you-hua-jia-liao-dong-tai-gui-hua-by-liweiw/)


方法 1 中，验证回文串的时候，每一次都得使用「双指针」的方式验证子串是否是回文子串。利用 [LeetCode-5. 最长回文子串](https://leetcode-cn.com/problems/longest-palindromic-substring/)的思路，可以先用动态规划把结果算出来，这样就可以以 `O(1)` 的时间复杂度直接得到一个子串是否是回文。




#### Solution


```java
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.List;

public class Solution {

    public List<List<String>> partition(String s) {
        int len = s.length();
        List<List<String>> res = new ArrayList<>();
        if (len == 0) {
            return res;
        }

        char[] charArray = s.toCharArray();
        // 预处理
        // 状态：dp[i][j] 表示 s[i][j] 是否是回文
        boolean[][] dp = new boolean[len][len];
        // 状态转移方程：在 s[i] == s[j] 的时候，dp[i][j] 参考 dp[i + 1][j - 1]
        for (int right = 0; right < len; right++) {
            // 注意：left <= right 取等号表示 1 个字符的时候也需要判断
            for (int left = 0; left <= right; left++) {
                if (charArray[left] == charArray[right] && (right - left <= 2 || dp[left + 1][right - 1])) {
                    dp[left][right] = true;
                }
            }
        }

        Deque<String> stack = new ArrayDeque<>();
        dfs(s, 0, len, dp, stack, res);
        return res;
    }

    private void dfs(String s, int index, int len, boolean[][] dp, Deque<String> path, List<List<String>> res) {
        if (index == len) {
            res.add(new ArrayList<>(path));
            return;
        }

        for (int i = index; i < len; i++) {
            if (dp[index][i]) {
                path.addLast(s.substring(index, i + 1));
                dfs(s, i + 1, len, dp, path, res);
                path.removeLast();
            }
        }
    }
}
```




## 【经典好题】剑指 Offer II 079. 所有子集
### Description
* 【经典好题】[剑指 Offer II 079. 所有子集](https://leetcode-cn.com/problems/TVdhkn/)


本题与主站 [LeetCode-78. 子集](https://leetcode-cn.com/problems/subsets/) 相同，笔记位于「LeetCode Notes-015」


### Approach 1-回溯法


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution

```java
class Solution {

    public List<List<Integer>> subsets(int[] nums) {
        //对于每个元素 有选择当前元素和不选择当前元素两种方案
        List<List<Integer>> resList = new ArrayList<>();
        List<Integer> tempList = new ArrayList<>();
        backTrack(0,nums,resList,tempList);
        return resList;
    }

    private void backTrack(int index,int[] nums,List<List<Integer>> resList,List<Integer> tempList){
        if(index == nums.length){
            resList.add(new ArrayList<>(tempList));
            //resList.add(tempList);   //需要注意的是 此处应深拷贝一个List进行赋值 不能直接插入tempList 因为tempList会在后续回溯中发生变化
            return;
        }
        tempList.add(nums[index]);
        backTrack(index+1,nums,resList,tempList);
        tempList.remove(tempList.size()-1);
        backTrack(index+1,nums,resList,tempList);
    }
}
```



## 【经典好题】17. 电话号码的字母组合
### Description
* 【经典好题】[17. 电话号码的字母组合](https://leetcode-cn.com/problems/letter-combinations-of-a-phone-number/)

### Approach 1-回溯法


#### Analysis


参考 `leetcode-cn` 官方题解。


#### Solution


```java
class Solution {
    public List<String> letterCombinations(String digits) {
        List<String> resList = new ArrayList<>();
        if(digits.length() == 0){
            return resList;
        }
        Map<Character,String> phoneMap = new HashMap<>(){{
            put('2', "abc");
            put('3', "def");
            put('4', "ghi");
            put('5', "jkl");
            put('6', "mno");
            put('7', "pqrs");
            put('8', "tuv");
            put('9', "wxyz");
        }};
        backtrack(resList,phoneMap,digits,0,new StringBuffer());
        return resList;
    }

    public void backtrack(List<String> resList,Map<Character,String> phoneMap,String digits,int index,StringBuffer combination){
        if(index == digits.length()){
            resList.add(combination.toString());
            return;
        }
        char digit = digits.charAt(index);
        String letters = phoneMap.get(digit);
        for(int i=0;i<letters.length();i++){
            combination.append(letters.charAt(i));
            backtrack(resList, phoneMap, digits, index + 1, combination);
            combination.deleteCharAt(index); //deleteCharAt
        }
    }
}
```


