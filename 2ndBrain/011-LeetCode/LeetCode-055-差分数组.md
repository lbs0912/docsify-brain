# LeetCode Notes-055-差分数组


[TOC]



## 更新
* 2021/07/24，撰写
* 2021/07/25，**差分数组** 专题汇总


## 总览
* [LeetCode-1893. 检查是否区域内所有整数都被覆盖](https://leetcode-cn.com/problems/check-if-all-the-integers-in-a-range-are-covered/)
* [LeetCode-1845. 人口最多的年份](https://leetcode-cn.com/problems/maximum-population-year/description/)
* [LeetCode-1674. 使数组互补的最少操作次数](https://leetcode-cn.com/problems/minimum-moves-to-make-array-complementary/)
* [LeetCode-1109. 航班预订统计](https://leetcode-cn.com/problems/corporate-flight-bookings/)
* [LeetCode-1094. 拼车](https://leetcode.cn/problems/car-pooling/)
* [LeetCode-1122. 数组的相对排序](https://leetcode-cn.com/problems/relative-sort-array/description/)


## 差分数组

### 参考资料
* [什么是差分数组？ | 腾讯云](https://cloud.tencent.com/developer/article/1629357) 


### 经典题目赏析
* [LeetCode-1893. 检查是否区域内所有整数都被覆盖](https://leetcode-cn.com/problems/check-if-all-the-integers-in-a-range-are-covered/)
* [LeetCode-1674. 使数组互补的最少操作次数](https://leetcode-cn.com/problems/minimum-moves-to-make-array-complementary/)



### 差分数组-算法原型

#### 问题背景

如果给你一个包含 5000 万个元素的数组，然后会有频繁区间修改操作，比如让第 1 个数到第 1000 万个数每个数都加上 1，而且这种操作时频繁的。

此时你应该怎么做？很容易想到的是，从第 1 个数开始遍历，一直遍历到第 1000 万个数，然后每个数都加上 1，如果这种操作很频繁的话，那这种暴力的方法在一些实时的系统中可能就拉跨了。


**针对这种区间频繁修改的场景，可以使用差分数组求解。**



#### 差分数组定义

对于数组 `arr`，定义差分数组 `diff`，用于记录原数组中两个相邻元素的差。其中 `diff[i] = arr[i] - arr[i-1]`，`diff[0] = 0`。

看个例子，对于数组 `arr={0,2,5,4,9,7,10,0}`，对应的差分数组为 `diff={0,2,3,-1,5,-2,3,-10}`。



| index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|-------|---|---|---|---|---|---|---|---|
| arr   | 1 | 2 | 5 | 4 | 9 | 7 | 10| 0 |
| diff  | 0 | 1 | 3 |-1 | 5 | -2| 3 |-10 |



下面考虑一个实际的频繁操作区间的操作，对区间 `[1,4]` 上所有的数值都加上3。

我们不需要遍历数组 `[1,4]` 范围内的值，只需要改变差分数组位置 1 和位置 5 的值即可，即 `diff[1] +=3`，`diff[5] -= 3`，这大大降低了对区间的操作次数。

**<font color='red'>每次操作的复杂度从 `O(n)` 降低到了 `O(1)`。</font>**



| index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|-------|---|---|---|---|---|---|---|---|
| arr   | 1 | 2+3 | 5+3 | 4+3 | 9+3 | 7 | 10| 0 |
| diff  | 0 | 1+3 | 3 |-1 | 5 | -2-3 | 3 |-10 |



### 根据差分数组获取原数组中某个值

如何根据差分数组，获取原数组中某个值 `arr[i]` 呢？


需要从前往后遍历，计算差分数组的前缀和 `sum[i]`，则 `arr[i] = sum[i]`。其中 ` sum[0] = arr[0]`，而不是 ` sum[0] = diff[0]`，这点需要注意。



```java
//定义sum 表示差分数组diff的前缀和 其中 sum[0] = arr[0] 
int[] sum = new int[diff.length];
sum[0] = arr[0];  //tips

for(int i=1;i<diff.length;i++){
    sum[i] = sum[i-1] + diff[i];
}
```





### 差分数组题目-代码模板


```
// 构造差分数组
diff[0] = nums[0];
for (int i = 1; i < nums.length; i++) {
    diff[i] = nums[i] - nums[i - 1];
}

// 根据差分数组构造结果数组
res[0] = diff[0];
for (int i = 1; i < diff.length; i++) {
    res[i] = res[i - 1] + diff[i];
}
```


## 1893. 检查是否区域内所有整数都被覆盖
### Description
* [LeetCode-1893. 检查是否区域内所有整数都被覆盖](https://leetcode-cn.com/problems/check-if-all-the-integers-in-a-range-are-covered/)


### Approach 1-暴力遍历
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(n^2)`
* 空间复杂度：`O(n)`


#### Solution


```java
class Solution {
    public boolean isCovered(int[][] ranges, int left, int right) {
        Map<Integer,Integer> map = new HashMap<>();
        for(int i = left;i<=right;i++){
            map.put(i,0); //init  否则 需要在后续判断时添加 map.isEmpty() 判断  测试用例 [[1,10],[10,20]]  21  21
            for(int j=0;j<ranges.length;j++){
                if(1 == map.getOrDefault(i,0)){
                    break;
                }
                if(ranges[j][0] <= i && i <= ranges[j][1]){
                    map.put(i,1);
                }
            }
        }
        
        for(Map.Entry<Integer,Integer> entry:map.entrySet()){
            if(0 == entry.getValue()){
                return false;
            }
        }
        return true;

    }
}
```



### Approach 2-基于排序
#### Analysis

参考 `leetcode-cn` 官方题解。

* [基于排序的题解](https://leetcode-cn.com/problems/check-if-all-the-integers-in-a-range-are-covered/solution/yi-ti-san-jie-bao-li-you-hua-chai-fen-by-w7xv/)




1. 将区间的起始点从小到达排序
2. 遍历数组，如果拿到的区间 `[l,r]`，`left` 在区间内，即 `l <= left <= r`，那么可知 `[left,r]` 便已经被覆盖，接下来只需接续检查剩余空白部分，让 `left = r + 1`,
3. 继续步骤2，完成数组的遍历。 
4. 如果最后 `left` 可以超过 `right`，则区间全部被覆盖， 为 true。



复杂度分析
* 时间复杂度：`O(NlogN)`，数组排序中需要的时间复杂度为 `O(NlogN)`
* 空间复杂度：`O(logN)`，数组排序中需要的空间复杂度为 `O(logN)`



此处，对数组排序的必要性进行说明。考虑如下测试用例

```s
arr = {{36,50},{24,27}}
left = 35
right = 40
```

若不对数组排序，则返回结果为 false，实际结果为 true。




#### Solution


```java
class Solution {
    public boolean isCovered(int[][] ranges, int left, int right) {
        //按照区间起点大小排序
        Arrays.sort(ranges, (a1, a2) -> a1[0] - a2[0]);
        for(int[] range: ranges) {
            int l = range[0];
            int r = range[1];
            if(l <= left && left <= right && right <= r){
                //[left,right] 已经是range[i]的子集
                return true;
            } 
            if(l <= left && left <= r) {
                left = r + 1;
            }
        }
        return left > right;
    }
}
```


### Approach 3-区间标记
#### Analysis

参考 `leetcode-cn` 官方题解。

* [基于排序的题解](https://leetcode-cn.com/problems/check-if-all-the-integers-in-a-range-are-covered/solution/yi-ti-san-jie-bao-li-you-hua-chai-fen-by-w7xv/)


由于 `1 <= left <= right <= 50`，可用变量 `boolean[] flag = new boolean[51]` 标记每个数字是否在 range 数组中出现。

复杂度分析
* 时间复杂度：`O(N^2)`
* 空间复杂度：`O(1)`




#### Solution



```java
class Solution {
    public boolean isCovered(int[][] ranges, int left, int right) {
        boolean[] flag = new boolean[51];
        for(int[] range : ranges){
            int L = Math.max(range[0],left);
            int R = Math.min(range[1],right);
            for(int i = L; i <= R; i++){
                flag[i] = true;
            }
        }
        for(int i = left; i <= right; i++){
            if(flag[i] == false) return false;
        }
        return true;
    }
}
```




### Approach 4-差分数组
#### Analysis

参考 `leetcode-cn` 官方题解。

* [基于排序的题解](https://leetcode-cn.com/problems/check-if-all-the-integers-in-a-range-are-covered/solution/yi-ti-san-jie-bao-li-you-hua-chai-fen-by-w7xv/)


定义差分数组 `diff` 表示相邻数字之间是否被覆盖的变化量。

`diff[i]++` 表示在 `i` 位置上有了新的覆盖。若覆盖到 `j` 结束了呢？此时 `j` 依然是覆盖，但是 `j+1` 不在覆盖状态，所以在 `j+1` 处减去1，即 `diff[j+1]--`。


最后再对差分数组进行前缀求和，得到 `sum[i]`，就可以表示数字 `i` 被区间覆盖的次数。




复杂度分析
* 时间复杂度：`O(N)`
* 空间复杂度：`O(1)`




#### Solution

```java
class Solution {
    public boolean isCovered(int[][] ranges, int left, int right) {
        int[] diff = new int[52];
        //对差分数组进行处理
        for(int i = 0; i < ranges.length; i++){
            diff[ranges[i][0]]++;
            diff[ranges[i][1]+1]--;
        }
        //根据差分数组处理前缀和，为理解方便单独定义sum，可以原地做
        int[] sum = new int[52];
        for(int i = 1; i <= 51; i++){
            sum[i] = sum[i-1] + diff[i];
        }
        //从left到right判断是否满足sum > 0
        for(int i = left; i <= right; i++){
            if(sum[i] <= 0) return false;
        }
        return true;
    }
}
```


## 1845. 人口最多的年份
### Description
* [LeetCode-1845. 人口最多的年份](https://leetcode-cn.com/problems/maximum-population-year/description/)

### Approach 1-差分数组
#### Analysis

**【经典题目赏析】-差分数组**

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(m+n)`，其中 m 为 logs 的长度，n 为年份的跨度。建立变化量数组的时间复杂度为 `O(n)`，维护变化量数组的时间复杂度为 `O(m)`，遍历维护最大值的时间复杂度为 `O(n)`。
* 空间复杂度：`O(n)`，即为变化量数组的空间开销。
#### Solution


```java
class Solution {
    public int maximumPopulation(int[][] logs) {
        final int OFFSET = 1950;
        //差分数组
        //arr[i]++ 表示当前i处覆盖的区间增加1
        //[birthi, deathi] 由于deathi年份去世，不属于存货，故为arr[i]-- 不是arr[i+1]-- 
        //即右区间是开区间  覆盖区间为 [birthi, deathi)
        int[] arr = new int[101];
        for(int[] num:logs){
            arr[num[0]-OFFSET]++;
            arr[num[1]-OFFSET]--;
        }
        int[] sum = new int[101];
        sum[0] = arr[0];
        int max = sum[0];
        int index = 0;
        //前缀和
        for(int i=1;i<101;i++){
            sum[i] = sum[i-1] + arr[i];
            if(sum[i] > max){
                max = sum[i];
                index = i;
            }
        }
        return index+OFFSET;
    }
}
```





## 【经典题目赏析】1674. 使数组互补的最少操作次数
### Description
* [LeetCode-1674. 使数组互补的最少操作次数](https://leetcode-cn.com/problems/minimum-moves-to-make-array-complementary/)


### Approach 1-差分数组
#### Analysis

参考 `leetcode-cn` 官方题解。

* [ref-1](https://leetcode-cn.com/problems/minimum-moves-to-make-array-complementary/solution/jie-zhe-ge-wen-ti-xue-xi-yi-xia-chai-fen-shu-zu-on/)
* [ref-2](https://leetcode-cn.com/problems/minimum-moves-to-make-array-complementary/solution/javaonde-chai-fen-shu-zu-by-liusandao/)


**<font color='red'>【经典题目赏析】</font>**


假设 `res[x]` 表示 `nums[i] + nums[n-1-i]` 等于 `x` 的时候，需要的操作次数。由于 `nums[i] + nums[n-1-i]` 的取值范围是 `[2,2*limit]`，因此可以创建一个长度为 `2*limit+1` 的数组 `res[x]`。**此时问题变转化为求解数组 `res[x]` 的最小值。**


下面考虑如何求出每一个 `res[x]` 的值，即修改后互补的数字和为 `x` 时需要多少次操作？


为了叙述方便，将 `nums[i]` 和 `nums[n-1-i]` 中较小的数记做 `min`，较大的数记做 `max`，修改后的数字加和记做 `x`，显然有
1. `x` 在区间 `[2,min]` 时，我们需要修改2次，即数组区间 `res[2,limit]` 需要的操作次数+2；
2. `x` 在区间 `[min+1,min+max-1]` 时，我们需要修改1次，即 `res[min+1,min+max-1]` 需要的操作次数+1；
3. `x` 在区间 `[min+max,min+max]` 时，我们需要修改0次,即 `res[min+max]` 需要的操作次数+0；
4. `x` 在区间 `[min+max+1,limit+max]` 时，我们需要修改1次，即 `res[min+max+1,limit+max]` 需要的操作次数+1；
5. `x` 在区间 `[max+limit+1,limit+limit]` 时，我们需要修改2次，即数组区间 `res[max+limit+1,limit+limit]` 需要的操作次数+2；


**可以看到这是一个频繁操作区间的问题。频繁操作区间的问题，可以使用差分数组求解。**

使用差分数组 `diff[i] = res[i]-res[i-1]`，其中 `diff[0]`。

在得到差分数组后，再遍历一次差分数组，得到 `res[x]` 数组中的最小值，即是所需要的最小操作次数。


复杂度分析
* 时间复杂度是 `O(n)`
* 空间复杂度也是 `O(n)`。



#### Solution


```java
class Solution {
    public int minMoves(int[] nums, int limit) {
        //差分数组  nums[i]+nums[n-1-i]的取值范围是 [2,2*limit]
        //由于差分数组中需要操作diff[2*limit + 1] 故数组长度为2*limit+2
        int[] diff = new int[2*limit+2];
    

        int len = nums.length;
        for(int i=0;i<len/2;i++){
            int min = Math.min(nums[i],nums[len-1-i]);
            int max = Math.max(nums[i],nums[len-1-i]);
            //1. [2,min]时，需修改2次 此处记得判断下min是否小于2
            if(min >= 2){ //min小于2 
                diff[2] += 2;
                diff[min+1] -= 2;

                //2. [min+1,min+max-1]时，需修改1次
                diff[min+1] += 1;
                diff[min+max] -= 1;
            }  else {
                //若min<2 即min=1  此时区间 [2,min], [min+1,min+max-1] 可合并为 [2,max] 该区间需要修改1次
                diff[2] += 1;
                diff[max+1] -=1;
            }
            
            //3. [min+max,min+max] 时，需要修改0次

            //4. [min+max+1,limit+max] 时，需要修改1次
            diff[min+max+1] += 1;
            diff[max + limit + 1] -= 1;
            
            //5. [max+limit+1,limit+limit] 时，需要修改2次
            diff[max + limit + 1] += 2;
            diff[limit + limit + 1] -= 2;
        }

        int minValue = Integer.MAX_VALUE;
        int res = 0;
        //计算res[x]的最小值 区间是[2,2*limit]
        for(int i=2;i<=2*limit;i++){
            res += diff[i];
            minValue = Math.min(res,minValue);
        }
        return minValue;
    }
}


```








## 1109. 航班预订统计
### Description
* [LeetCode-1109. 航班预订统计](https://leetcode-cn.com/problems/corporate-flight-bookings/)



### Approach 1-暴力
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(n*m)`，其中 n 为要求的数组长度，m 为预定记录的数量
* 空间复杂度：`O(1)`


#### Solution


```java
class Solution {
    public int[] corpFlightBookings(int[][] bookings, int n) {
        int[] res = new int[n];
        for(int i=0;i<bookings.length;i++){
            int first = bookings[i][0];
            int last  = bookings[i][1];
            int seat  = bookings[i][2];
            for(int j=first;j<=last;j++){
                res[j-1] += seat;
            }
        }
        return res;
    }   
}
```
### Approach 2-差分数组
#### Analysis

参考 `leetcode-cn` 官方题解。

复杂度分析
* 时间复杂度：`O(n+m)`，其中 n 为要求的数组长度，m 为预定记录的数量
* 空间复杂度：`O(1)`



**差分数组的性质是，当我们希望对原数组的某一个区间 `[l,r]` 施加一个增量 `inc` 时，差分数组 d 对应的改变是 `d[l]` 增加 `inc`，`d[r+1]` 减少 `inc`。这样对于区间的修改就变为了对于两个位置的修改。并且这种修改是可以叠加的，即当我们多次对原数组的不同区间施加不同的增量，我们只要按规则修改差分数组即可。**
#### Solution


```java
class Solution {
    public int[] corpFlightBookings(int[][] bookings, int n) {
        //差分数组
        int[] dp = new int[n];
        for(int i=0;i<bookings.length;i++){
            int first = bookings[i][0];
            int last  = bookings[i][1];
            int seat  = bookings[i][2];
            dp[first - 1] += seat;
            if(last != n){
                dp[last] -= seat;
            }
            
        }
 
        int[] sum = new int[n];
        sum[0] = dp[0];
        for(int i=1;i<n;i++){
            sum[i] = sum[i-1] + dp[i];
        }
        return sum;
    }   
}
```





## 1094. 拼车

### Description
* [LeetCode-1094. 拼车](https://leetcode.cn/problems/car-pooling/)

### Approach 1-差分数组
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public boolean carPooling(int[][] trips, int capacity) {
        int len = trips.length;
        int[] dp = new int[1000]; //差分数组
        for(int i=0;i<len;i++){
            int passenger = trips[i][0];
            int from = trips[i][1];
            int to = trips[i][2];
            dp[from] += passenger;
            if(to != 1000){
                dp[to] -= passenger;
            }
        }
        //求最大值
        int sum = 0;
        for(int i=0;i<1000;i++){
            sum = sum + dp[i];
            if(sum > capacity){
                return false;
            }
        }
        return true;
    }
}
```

### 题目变形-公交车上人数

一辆公交车从站点0驾驶到站点N（N<1000），期间每个站点都可以正常上下客人，用 `[first, last, seats]` 表示，其中 `first` 表示上客的站点编号，`last` 表示下客的站点编号，`seat` 表示上客的人数。

请计算出公交车上人数最大是多少。

* 测试用例

```s
# 输入
[[1,2,10],[2,3,20],[2,5,25]]
# 输出
55
```




该题思路同「LeetCode-1109. 航班预订统计」和「LeetCode-1094. 拼车」，使用差分数组解决。




## 1122. 数组的相对排序

### Description
* [LeetCode-1122. 数组的相对排序](https://leetcode-cn.com/problems/relative-sort-array/description/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

1. 创建一个等长的数组 `arr`，用于存放结果
2. 双重循环遍历数组，按照 `arr2` 中元素出现的顺序，把 `arr1[i]` 元素放入到 `arr[index]` 中。同时，将 `arr1[i]` 标记为 -1，表示已经使用过
3. 然后，对 `arr1` 进行排序
4. 最后，将 `arr1` 中大于零的元素，插入到 `arr` 中


#### Solution


```java
class Solution {
    public int[] relativeSortArray(int[] arr1, int[] arr2) {
        int len = arr1.length;
        int index = 0;
        int[] arr = new int[len];
        for(int i=0;i<arr2.length;i++){
            for(int j=0;j<len;j++){
                if(arr1[j] != -1 && arr1[j] == arr2[i]){
                    arr[index] = arr1[j];
                    arr1[j] = -1;  //标记已经使用过
                    index++;
                }
            }
        }
        Arrays.sort(arr1);
        for(int i=0;i<len;i++){
            if(arr1[i] != -1){
                arr[index] = arr1[i];
                index++;
            }
        }
        return arr;
    }
}
```


### Approach 2-自定义排序

#### Analysis

参考 `leetcode-cn` 官方题解。



一种容易想到的方法是使用排序并自定义比较函数。

由于数组 `arr2` 规定了比较顺序，因此我们可以使用哈希表对该顺序进行映射，即对于数组 `arr2` 中的第 `i` 个元素，我们将 `(arr2[i],i)` 这一键值对放入哈希表 `rank` 中，就可以很方便地对数组 `arr1` 中的元素进行比较。

比较函数的写法有很多种，例如我们可以使用最基础的比较方法，对于元素 x 和 y
1. 如果 x 和 y 都出现在哈希表中，那么比较它们对应的值 `rank[x]` 和 `rank[y]`;
2. 如果 x 和 y 都没有出现在哈希表中，那么比较它们本身；
3. 对于剩余的情况，出现在哈希表中的那个元素较小。


#### Solution

```java
class Solution {
    public int[] relativeSortArray(int[] arr1, int[] arr2) {
        Map<Integer, Integer> rank = new HashMap<>();
        for(int i=0;i<arr2.length;i++){
            rank.put(arr2[i],i);
        }
        Map<String, String> map = new HashMap<>();
        Integer[] integerArr = Arrays.stream(arr1).boxed().toArray(Integer[]::new);
        Arrays.sort(integerArr,new Comparator<Integer>(){
            @Override
            public int compare(Integer x, Integer y) {
                // 如果 x 和 y 都出现在哈希表中，那么比较它们对应的值 rank[x] 和 rank[y];
                if(rank.containsKey(x) && rank.containsKey(y)){
                    return rank.get(x) - rank.get(y);
                } else if(!rank.containsKey(x) && !rank.containsKey(y)){
                    //如果 x 和 y 都没有出现在哈希表中，那么比较它们本身
                    return x-y;
                } else {
                    if(rank.containsKey(x)){
                        return -1;
                    } else{
                        return 1;
                    }
                }
            }
        });
        return Arrays.stream(integerArr).mapToInt(Integer::valueOf).toArray();
    }
}
```

### Approach 3-计数排序

#### Analysis

参考 `leetcode-cn` 官方题解。

注意到本题中元素的范围为 `[0, 1000]`，这个范围不是很大，我们也可以考虑不基于比较的排序，例如「计数排序」。

```s
arr1 = | 2| 3 | 4 | 4 | 5|     arr2 = | 4| 2 |

频率数组
| index | 0 | 1 | 2 | 3 | 4 | 5 |
| value | 0 | 0 | 1 | 1 | 2 | 1 |


第1次遍历，按照 arr2 中元素顺序遍历频率数组
结果数组 = | 4 | 4 | 2 | 0 | 0| 


第2次遍历，顺序遍历频率数组
结果数组 = | 4 | 4 | 2 | 3 | 5| 
```



#### Solution


```java
class Solution {
    public int[] relativeSortArray(int[] arr1, int[] arr2) {
        int maxValue = 0;

        for(int x: arr1){
            maxValue = Math.max(maxValue,x);
        }
        //频率数组
        int[] frequency = new int[maxValue + 1];
        for(int x: arr1){
            frequency[x]++;
        }
        //结果数组
        int[] ans = new int[arr1.length];
        int index = 0;
        for(int x: arr2){
           for (int i = 0; i < frequency[x]; ++i) {
                ans[index++] = x;
            }
            frequency[x] = 0; //记得清空
        }
        for (int x = 0; x <= maxValue; ++x) {
            for (int i = 0; i < frequency[x]; ++i) {
                ans[index++] = x;
            }
        }
        return ans;
    }
}
```






