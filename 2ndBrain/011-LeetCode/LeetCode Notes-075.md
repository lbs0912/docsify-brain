
# LeetCode Notes-075


[TOC]



## 更新
* 2021/12/19，撰写
* 2021/12/20，完成



## Overview
* [LeetCode-2078. 两栋颜色不同且距离最远的房子](https://leetcode-cn.com/problems/two-furthest-houses-with-different-colors/)
* 【经典好题】[LeetCode-406. 根据身高重建队列](https://leetcode-cn.com/problems/queue-reconstruction-by-height/)
* [LeetCode-1154. 一年中的第几天](https://leetcode-cn.com/problems/day-of-the-year/)
* [LeetCode-620. 有趣的电影](https://leetcode-cn.com/problems/not-boring-movies/)
* [LeetCode-595. 大的国家](https://leetcode-cn.com/problems/big-countries/)




## 2078. 两栋颜色不同且距离最远的房子
### Description
* [LeetCode-2078. 两栋颜色不同且距离最远的房子](https://leetcode-cn.com/problems/two-furthest-houses-with-different-colors/)

### Approach 1-常规-O(n^2)
#### Analysis

参考 `leetcode-cn` 官方题解。



#### Solution


```java
class Solution {
    public int maxDistance(int[] colors) {
        int len = colors.length;
        int maxDistance = 0;
        for(int i=0;i<len-1;i++){
            for(int j=len-1;j>i;j--){
                if(colors[i] != colors[j]){
                    maxDistance = Math.max(maxDistance,j-i);
                }
            }
        }
        return maxDistance;
    }
}
```


### Approach 2-贪心-O(n^2)
#### Analysis

参考 `leetcode-cn` 官方题解。

因为至少存在 2 种颜色，所以必然有与第 0 号不同的颜色，也必然有与第 `len-1` 号不同的颜色，因而可以得到（至少包含 1 个端点的）2 个答案，最优答案必为两者之一。




#### Solution


```java
class Solution {
    public int maxDistance(int[] colors) {
        int len = colors.length;
        int ans1 = 0;
        int ans2 = 0;
        // 计算距离开始位置最远的答案
        for(int i = len - 1; i > 0; i --){
            if(colors[0] != colors[i]){
                ans1 = i - 0;
                break;
            }
        }
        // 计算距离结束位置最远的答案
        for(int i = 0; i < len - 1; i ++){
            if(colors[len - 1] != colors[i]){
               ans2 = len-1-i;
                break;
            }
        }
        // 返回两者最大值
        return Math.max(ans1,ans2);
    }
}
```





## 【经典好题】406. 根据身高重建队列
### Description
* 【经典好题】[LeetCode-406. 根据身高重建队列](https://leetcode-cn.com/problems/queue-reconstruction-by-height/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。



```s
[[7,0],[4,4],[7,1],[5,0],[6,1],[5,2]]
```


结合上述测试数据，对算法步骤进行说明。


1. 先对数组按照身高进行降序排列。
2. 若身高 `h` 相同，则按照 `[h,k]` 中的 `k` 值进行升序排列。
3. 第1，2步骤结束后，会得到如下顺序的数组。

```s
 [7,0], [7,1], [6,1], [5,0], [5,2], [4,4]
```

4. `[h,k]` 中的 `k` 表示该元素前面存在的身高 `h` 大于它的个数。**所以可以先让身高大的元素先插入队列，身高小的元素后插入队列，因为插入一个比 `$h_i$` 更小的身高 `h`，并不会影响 `$h_i$` 在队列中的位置，`$h_i$` 只受比它身高大的元素的影响。**


```s
// 再一个一个插入
// [7,0]
// [7,0], [7,1]
// [7,0], [6,1], [7,1]
// [5,0], [7,0], [6,1], [7,1]
// [5,0], [7,0], [5,2], [6,1], [7,1]
// [5,0], [7,0], [5,2], [6,1], [4,4], [7,1]
```



#### Solution


```java
class Solution {
    public int[][] reconstructQueue(int[][] people) {
        // [7,0], [7,1], [6,1], [5,0], [5,2], [4,4]
        // 再一个一个插入。
        // [7,0]
        // [7,0], [7,1]
        // [7,0], [6,1], [7,1]
        // [5,0], [7,0], [6,1], [7,1]
        // [5,0], [7,0], [5,2], [6,1], [7,1]
        // [5,0], [7,0], [5,2], [6,1], [4,4], [7,1]
        Arrays.sort(people, new Comparator<int[]>() {
            @Override
            public int compare(int[] o1, int[] o2) {
                if(o1[0] == o2[0]){
                    return   o1[1] - o2[1]; //按照第2个元素升序
                } else {
                    return o2[0] - o1[0]; //按照第1个元素降序
                }
                
            }
        });
        //or
        Arrays.sort(people,(o1,o2) -> {
            return o1[0] == o2[0] ? o1[1] - o2[1] : o2[0] - o1[0];
        });
        //or
        Arrays.sort(people, (o1, o2) -> o1[0] == o2[0] ? o1[1] - o2[1] : o2[0] - o1[0]);

        LinkedList<int[]> list = new LinkedList<>();
        for (int[] i : people) {
            list.add(i[1], i);
        }

//        return list.toArray(new int[list.size()][2]);
        return list.toArray(people);
    }
}
```





## 1154. 一年中的第几天
### Description
* [LeetCode-1154. 一年中的第几天](https://leetcode-cn.com/problems/day-of-the-year/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

闰年判断

```java
(yearVal%400 == 0 ||(yearVal%4 == 0 && yearVal%100 != 0))
```

#### Solution


```java
class Solution {
    public int dayOfYear(String date) {
        String[] dateArr = date.split("-");
        List<Integer> monthDayList = new ArrayList<>();
        monthDayList.add(31);//1
        monthDayList.add(28);//2
        monthDayList.add(31);//3
        monthDayList.add(30);//4
        monthDayList.add(31);//5
        monthDayList.add(30);//6
        monthDayList.add(31);//7
        monthDayList.add(31);//8
        monthDayList.add(30);//9
        monthDayList.add(31);//10
        monthDayList.add(30);//11
        monthDayList.add(31);//12

        int dayCount = Integer.valueOf(dateArr[2]);
        int monthVal = Integer.valueOf(dateArr[1]);
        int yearVal = Integer.valueOf(dateArr[0]);
        System.out.println(monthVal);
        for(int i=0;i<monthVal-1;i++){
            if(i == 1){
                //2月份 闰年判断
                dayCount += (yearVal%400 == 0 ||(yearVal%4 == 0 && yearVal%100 != 0))? 29:28;
            } else {
                dayCount += monthDayList.get(i);
            }
            
        }
        return dayCount;

    }
}
```





## 620. 有趣的电影
### Description
* [LeetCode-620. 有趣的电影](https://leetcode-cn.com/problems/not-boring-movies/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```s
select * from cinema
where description != "boring" AND id%2 = 1
order by rating desc
```




## 595. 大的国家
### Description
* [LeetCode-595. 大的国家](https://leetcode-cn.com/problems/big-countries/)

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```s
SELECT
    name, population, area
FROM
    world
WHERE
    area >= 3000000 OR population >= 25000000
;
```


### Approach 2-UNION
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```s
SELECT
    name, population, area
FROM
    world
WHERE
    area >= 3000000

UNION

SELECT
    name, population, area
FROM
    world
WHERE
    population >= 25000000
;
```





