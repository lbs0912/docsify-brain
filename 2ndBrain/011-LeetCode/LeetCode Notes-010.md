
# LeetCode Notes-010


[TOC]


## 更新
* 2020/06/24，撰写
* 2020/06/27，整理完成



## Overview
* [LeetCode-771. 宝石与石头](https://leetcode-cn.com/problems/jewels-and-stones/)
* [LeetCode-1486. 数组异或操作](https://leetcode-cn.com/problems/xor-operation-in-an-array/)
* [LeetCode-16. 最接近的三数之和](https://leetcode-cn.com/problems/3sum-closest/)
* [LeetCode-15. 三数之和](https://leetcode-cn.com/problems/3sum/)
* [LeetCode-1. 两数之和](https://leetcode-cn.com/problems/two-sum/)

> 第16，15，1题为同一类型题目。





## 771. 宝石与石头

### Description

* [LeetCode-771. 宝石与石头](https://leetcode-cn.com/problems/jewels-and-stones/)



### Approach 1-暴力求解

#### Analysis

遍历每块石头，检查是不是宝石。检查步骤用简单的线性搜索来实现。



复杂度分析
* 时间复杂度：`O(J.length * S.length))`
* 空间复杂度：`O(J.length ∗ S.length))`





#### Solution

* Java


```java
class Solution {
    public int numJewelsInStones(String J, String S) {
        int count = 0;
        for(char s:S.toCharArray()){
            for(char j:J.toCharArray()){
                if(j == s){
                    count++;
                    break;   //因为字符串J中无重复，因此此处可直接break结束循环
                }
            }
        }
        return count;
    }
}
```



### Approach 2-哈希集合
#### Analysis

遍历每块石头，检查是不是宝石。检查步骤用 **哈希集合** 来高效完成。



复杂度分析
* 时间复杂度：`O(J.length + S.length))`
* 空间复杂度：`O(J.length)`




#### Solution

* Java

```
class Solution {
    public int numJewelsInStones(String J, String S) {
        Set<Character> jSet = new HashSet();
        int count = 0;
        for(char j:J.toCharArray()){
            jSet.add(j);
        }
        for(char s:S.toCharArray()){
            if(jSet.contains(s)){
                count++;
            }
        }
        return count;
    }
}
```


## 1486. 数组异或操作

### Description

* [LeetCode-1486. 数组异或操作](https://leetcode-cn.com/problems/xor-operation-in-an-array/)



### Approach 1-暴力求解

#### Analysis

送分题，不再赘述。

#### Solution

* Java

```java
class Solution {
    public int xorOperation(int n, int start) {
        int res = start + 2*0;
        for(int i=1;i<n;i++){
            int value = start + 2*i;
            res = res ^ value;
        }
        return res;
    }
}
```





## 16. 最接近的三数之和

### Description

* [LeetCode-16. 最接近的三数之和](https://leetcode-cn.com/problems/3sum-closest/)

> 本题和 [LeetCode-15. 三数之和](https://leetcode-cn.com/problems/3sum/) 类似。

### Approach 1-排序+双指针


#### Analysis

本题和 [LeetCode-15. 三数之和](https://leetcode-cn.com/problems/3sum/) 类似，可以使用「双指针」的方法来解决。

题目要求找到与目标值 `target` 最接近的三元组，这里的「最接近」即为差值的绝对值最小。我们可以考虑直接使用三重循环枚举三元组，找出与目标值最接近的作为答案，时间复杂度为 `O(N^3)`。然而本题的 `N` 最大为 1000，会超出时间限制。

那么如何进行优化呢？我们首先考虑枚举第一个元素 `a`，对于剩下的两个元素 `b` 和 `c`，我们希望它们的和最接近 `target−a`。对于 `b` 和 `c`，如果它们在原数组中枚举的范围（既包括下标的范围，也包括元素值的范围）没有任何规律可言，那么我们还是只能使用两重循环来枚举所有的可能情况。因此，我们可以考虑对整个数组进行升序排序，这样一来
* 假设数组的长度为 `n`，我们先枚举 `a`，它在数组中的位置为 `i`；
* 为了防止重复枚举，我们在位置 `[i+1, n)` 的范围内枚举 `b` 和 `c`。


当我们知道了 `b` 和 `c` 可以枚举的下标范围，并且知道这一范围对应的数组元素是有序（升序）的，那么我们是否可以对枚举的过程进行优化呢？

答案是可以的。借助双指针，我们就可以对枚举的过程进行优化。我们用 `$p_b$` 和 `$p_c$` 分别表示指向 `b` 和 `c` 的指针，初始时，`$p_b$` 指向位置 `i+1`，即左边界；`$p_c$` 指向位置 `n-1`，即右边界。在每一步枚举的过程中，我们用 `a+b+c` 来更新答案，并且
* 如果 `$a+b+c == target$`，那么直接返回 `target`，并结束循环；
* 如果 `$a+b+c \geq target$`，那么就将 `$p_c$` 向左移动一个位置；
* 如果 `$a+b+c \leq target$`，那么就将 `$p_b$` 向右移动一个位置；




实际上，`$p_c$` 和 `$p_b$` 就表示了我们当前可以选择的数的范围，而每一次枚举的过程中，我们尝试边界上的两个元素，根据它们与 `target` 的值的关系，选择「抛弃」左边界的元素还是右边界的元素，从而减少了枚举的范围。这种思路与 [11. 盛最多水的容器](https://leetcode-cn.com/problems/container-with-most-water/) 中的双指针解法也是类似的。



**小优化**

本题也有一些可以减少运行时间（但不会减少时间复杂度）的小优化。当我们枚举到恰好等于 `target` 的 `a+b+c` 时，可以直接返回 `target` 作为答案，因为不会有再比这个更接近的值了。

另一个优化与 [15. 三数之和](https://leetcode-cn.com/problems/3sum/solution/san-shu-zhi-he-by-leetcode-solution/) 的官方题解中提到的类似。当我们枚举 `a,b,c` 中任意元素并移动指针时，可以直接将其移动到下一个与这次枚举到的不相同的元素，减少枚举的次数。



复杂度分析
* 时间复杂度：`O(N^2)`，其中 `N` 是数组 `nums` 的长度。我们首先需要 `$O(N \log N)$` 的时间对数组进行排序，随后在枚举的过程中，使用一重循环 `O(N)` 枚举 `a`，双指针 `O(N)` 枚举 `b` 和 `c`，故一共是 `O(N^2)`
* 空间复杂度：`O(logN)`。排序需要使用 `O(logN)` 的空间。然而我们修改了输入的数组 `nums`，在实际情况下不一定允许，因此也可以看成使用了一个额外的数组存储了 `nums` 的副本并进行排序，此时空间复杂度为 `O(N)`



#### Solution


* Java-1：基于 [LeetCode-15. 三数之和](https://leetcode-cn.com/problems/3sum/) 的题解实现。

```java
class Solution {
    public int threeSumClosest(int[] nums, int target) {
        int n = nums.length;
        Arrays.sort(nums); //数组排序
        int minAbsValue = Integer.MAX_VALUE;
        int res = 0;
        //枚举a
        for(int first =0;first<n;first++){
            // 需要和上一次枚举的数不相同
            if(first >0 && nums[first] == nums[first-1]){
                continue;
            }
            // c 对应的指针初始指向数组的最右端
            int third = n-1;
            int remainder = target - nums[first];
            //枚举b
            for(int second = first+1;second<n;second++){
                // 需要和上一次枚举的数不相同
                if(second > first+1 && nums[second] == nums[second-1]){
                    continue;
                }
                // 需要保证 b 的指针在 c 的指针的左侧
                while(second < third){
                    if(Math.abs(target-nums[first]-nums[second]-nums[third]) < Math.abs(minAbsValue)){
                        minAbsValue = Math.abs(target-nums[first]-nums[second]-nums[third]);
                        res = nums[first]+nums[second]+nums[third];
                    }
                    if(nums[second] + nums[third] == remainder){
                        return target; //直接返回
                    }
                    else if(nums[second] + nums[third] > remainder){
                        --third;
                    }
                    else{
                        ++second;
                    }

                }
                // 如果指针重合，随着 b 后续的增加
                // 就不会有满足 a+b+c=0 并且 b<c 的 c 了，可以退出循环
                if(second == third){
                    break;
                }
            }
        }
        return res;
    }
}

```



* Java-2：leetcode-cn 官方题解


```java
class Solution {
    public int threeSumClosest(int[] nums, int target) {
        Arrays.sort(nums);
        int n = nums.length;
        int best = 10000000;

        // 枚举 a
        for (int i = 0; i < n; ++i) {
            // 保证和上一次枚举的元素不相等
            if (i > 0 && nums[i] == nums[i - 1]) {
                continue;
            }
            // 使用双指针枚举 b 和 c
            int j = i + 1, k = n - 1;
            while (j < k) {
                int sum = nums[i] + nums[j] + nums[k];
                // 如果和为 target 直接返回答案
                if (sum == target) {
                    return target;
                }
                // 根据差值的绝对值来更新答案
                if (Math.abs(sum - target) < Math.abs(best - target)) {
                    best = sum;
                }
                if (sum > target) {
                    // 如果和大于 target，移动 c 对应的指针
                    int k0 = k - 1;
                    // 移动到下一个不相等的元素
                    while (j < k0 && nums[k0] == nums[k]) {
                        --k0;
                    }
                    k = k0;
                } else {
                    // 如果和小于 target，移动 b 对应的指针
                    int j0 = j + 1;
                    // 移动到下一个不相等的元素
                    while (j0 < k && nums[j0] == nums[j]) {
                        ++j0;
                    }
                    j = j0;
                }
            }
        }
        return best;
    }
}
```


## 15. 三数之和

### Description
* [LeetCode-15. 三数之和](https://leetcode-cn.com/problems/3sum/)

> 本题和 [LeetCode-1. 两数之和](https://leetcode-cn.com/problems/two-sum/) 类似，是比较经典的面试题，但是做法不尽相同。

### Approach 1-排序+双指针

#### Analysis

参考 *leetcode-cn* 官方题解。




题目中要求找到所有「不重复」且和为 0 的三元组，这个「不重复」的要求使得我们无法简单地使用三重循环枚举所有的三元组。这是因为在最坏的情况下，数组中的元素全部为 0，即


```
[0, 0, 0, 0, 0, ..., 0, 0, 0]
```

任意一个三元组的和都为 0。如果我们直接使用三重循环枚举三元组，会得到 `O(N^3)` 个满足题目要求的三元组（其中 `N` 是数组的长度），时间复杂度至少为 `O(N^3)`。在这之后，我们还需要使用哈希表进行去重操作，得到不包含重复三元组的最终答案，又消耗了大量的空间。这个做法的时间复杂度和空间复杂度都很高，因此我们要换一种思路来考虑这个问题。


**「不重复」的本质是什么？我们保持三重循环的大框架不变，只需要保证**
* **第二重循环枚举到的元素不小于当前第一重循环枚举到的元素**
* **第三重循环枚举到的元素不小于当前第二重循环枚举到的元素**

也就是说，我们枚举的三元组 `(a,b,c)` 满足 `$a \leq b \leq c$`，保证了只有 `(a,b,c)` 这个顺序会被枚举到，而 `(b,a,c)`、`(c,b,a)` 等等这些不会，这样就减少了重复。要实现这一点，我们可以将数组中的元素从小到大进行排序，随后使用普通的三重循环就可以满足上面的要求。



**同时，对于每一重循环而言，相邻两次枚举的元素不能相同，否则也会造成重复。** 举个例子，如果排完序的数组为


```
[0, 1, 2, 2, 2, 3]
 ^  ^  ^
```
我们使用三重循环枚举到的第一个三元组为 `(0,1,2)`，如果第三重循环继续枚举下一个元素，那么仍然是三元组 `(0,1,2)`，产生了重复。**因此我们需要将第三重循环「跳到」下一个不相同的元素**，即数组中的最后一个元素 3，枚举三元组 `(0,1,3)`。

下面给出了改进的方法的伪代码实现


```java
nums.sort()
for first = 0 .. n-1
    // 只有和上一次枚举的元素不相同，我们才会进行枚举
    if first == 0 or nums[first] != nums[first-1] then
        for second = first+1 .. n-1
            if second == first+1 or nums[second] != nums[second-1] then
                for third = second+1 .. n-1
                    if third == second+1 or nums[third] != nums[third-1] then
                        // 判断是否有 a+b+c==0
                        check(first, second, third)
```


这种方法的时间复杂度仍然为 `O(N^3)`，毕竟我们还是没有跳出三重循环的大框架。然而它是很容易继续优化的。


**可以发现，如果我们固定了前两重循环枚举到的元素 `a` 和 `b`，那么只有唯一的 `c` 满足 `a+b+c=0`。当第二重循环往后枚举一个元素 `b'` 时，由于 `b' > b`，那么满足 `a+b'+c'=0` 的 `c'`， 一定有 `c' < c`，即 `c'` 在数组中一定出现在 `c` 的左侧。也就是说，我们可以从小到大枚举 `b`，同时从大到小枚举 `c`，即第二重循环和第三重循环实际上是并列的关系。**



有了这样的发现，我们就可以保持第二重循环不变，而**将第三重循环变成一个从数组最右端开始向左移动的指针**，从而得到下面的伪代码


```
nums.sort()
for first = 0 .. n-1
    if first == 0 or nums[first] != nums[first-1] then
        // 第三重循环对应的指针
        third = n-1
        for second = first+1 .. n-1
            if second == first+1 or nums[second] != nums[second-1] then
                // 向左移动指针，直到 a+b+c 不大于 0
                while nums[first]+nums[second]+nums[third] > 0
                    third = third-1
                // 判断是否有 a+b+c==0
                check(first, second, third)
```

<font color='red'>这个方法就是我们常说的「双指针」，当我们需要枚举数组中的两个元素时，如果我们发现随着第一个元素的递增，第二个元素是递减的，那么就可以使用双指针的方法，将枚举的时间复杂度从 `O(N^2)` 减少至 `O(N)`。</font>





**为什么是 `O(N)` 呢？这是因为在枚举的过程每一步中，「左指针」会向右移动一个位置（也就是题目中的 `b`），而「右指针」会向左移动若干个位置，这个与数组的元素有关，但我们知道它一共会移动的位置数为 `O(N)`，均摊下来，每次也向左移动一个位置，因此时间复杂度为 `O(N)`。**

注意到我们的伪代码中还有第一重循环，时间复杂度为 `O(N)`，因此枚举的总时间复杂度为 `O(N^2)`。由于排序的时间复杂度为 `$O(N \log N)$`，在渐进意义下小于前者，因此算法的总时间复杂度为 `O(N^2)`。


#### Solution


* Java

```java
class Solution {
    public List<List<Integer>> threeSum(int[] nums) {
        int n = nums.length;
        Arrays.sort(nums); //数组排序
        List<List<Integer>> ans = new ArrayList<List<Integer>>();
        //枚举a
        for(int first =0;first<n;first++){
            // 需要和上一次枚举的数不相同
            if(first >0 && nums[first] == nums[first-1]){
                continue;
            }
            // c 对应的指针初始指向数组的最右端
            int third = n-1;
            int target = 0 - nums[first];
            //枚举b
            for(int second = first+1;second<n;second++){
                // 需要和上一次枚举的数不相同
                if(second > first+1 && nums[second] == nums[second-1]){
                    continue;
                }
                // 需要保证 b 的指针在 c 的指针的左侧
                while(second < third && nums[second] + nums[third] > target){
                    --third;
                }
                // 如果指针重合，随着 b 后续的增加
                // 就不会有满足 a+b+c=0 并且 b<c 的 c 了，可以退出循环
                if(second == third){
                    break;
                }
                if(nums[second] + nums[third] == target){
                    List<Integer> list = new ArrayList<Integer>();
                    list.add(nums[first]);
                    list.add(nums[second]);
                    list.add(nums[third]);
                    ans.add(list);
                }
            }
        }
        return ans;
    }
}
```

## 1. 两数之和

### Description
* [LeetCode-1. 两数之和](https://leetcode-cn.com/problems/two-sum/)


### Approach 1-暴力法

#### Analysis

遍历每个元素 `x`，并查找是否存在一个值与 `target - x` 相等的目标元素。



复杂度分析
* 时间复杂度：`O(n^2)`
* 空间复杂度：`O(1)`




#### Solution

* Java


```java
class Solution {
    public int[] twoSum(int[] nums, int target) {
        for (int i = 0; i < nums.length; i++) {
            for (int j = i + 1; j < nums.length; j++) {
                if (nums[j] == target - nums[i]) {
                    return new int[] { i, j };
                }
            }
        }
        throw new IllegalArgumentException("No two sum solution");
    }
}
```


### Approach 2-两遍哈希表

#### Analysis

为了对运行时间复杂度进行优化，我们需要一种更有效的方法来检查数组中是否存在目标元素。如果存在，我们需要找出它的索引。**保持数组中的每个元素与其索引相互对应的最好方法是什么？哈希表。**

通过以空间换取速度的方式，我们可以将查找时间从 `O(n)` 降低到 `O(1)`。哈希表正是为此目的而构建的，它支持以 "近似" 恒定的时间进行快速查找。我用 "近似" 来描述，是因为一旦出现冲突，查找用时可能会退化到 `O(n)`。但只要你仔细地挑选哈希函数，在哈希表中进行查找的用时应当被摊销为 `O(1)`。

一个简单的实现使用了两次迭代。在第一次迭代中，我们将每个元素的值和它的索引添加到表中。然后，在第二次迭代中，我们将检查每个元素所对应的目标元素（`target - nums[i]`）是否存在于表中。注意，该目标元素不能是 `nums[i]` 本身！


复杂度分析
* 时间复杂度：`O(n)`，我们把包含有 `n` 个元素的列表遍历两次。由于哈希表将查找时间缩短到 `O(1)`，所以时间复杂度为 `O(n)`
* 空间复杂度：`O(n)`，所需的额外空间取决于哈希表中存储的元素数量，该表中存储了 `n` 个元素



#### Solution

* Java

```java
class Solution {
    public int[] twoSum(int[] nums, int target) {
        Map<Integer,Integer> map = new HashMap<>();
        for(int i=0;i<nums.length;i++){
            map.put(nums[i],i);
        }
        for(int i=0;i<nums.length;i++){
            int complement = target - nums[i];
            if(map.containsKey(complement) && map.get(complement) != i){
                return new int[] {i,map.get(complement)}; 
            }
        }
        throw new IllegalArgumentException("No two sum solution");
    }
}
```



### Approach 3-一遍哈希表

#### Analysis

事实证明，我们可以一次完成。在进行迭代并将元素插入到表中的同时，我们还会回过头来检查表中是否已经存在当前元素所对应的目标元素。如果它存在，那我们已经找到了对应解，并立即将其返回


复杂度分析
* 时间复杂度：`O(n)`，我们只遍历了包含有 `n` 个元素的列表一次。在表中进行的每次查找只花费 `O(1)` 的时间。
* 空间复杂度：`O(n)`，所需的额外空间取决于哈希表中存储的元素数量，该表最多需要存储 `n` 个元素。


#### Solution


* Java


```java
class Solution {
    public int[] twoSum(int[] nums, int target) {
        Map<Integer, Integer> map = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            int complement = target - nums[i];
            if (map.containsKey(complement)) {
                return new int[] { map.get(complement), i };
            }
            map.put(nums[i], i);
        }
        throw new IllegalArgumentException("No two sum solution");
    }
}
```

