# LeetCode Notes-045


[TOC]



## 更新
* 2021/07/19，撰写
* 2021/07/22，完成


## Overview
* [LeetCode-1507. 转变日期格式](https://leetcode-cn.com/problems/reformat-date/description/)
* [LeetCode-1502. 判断能否形成等差数列](https://leetcode-cn.com/problems/can-make-arithmetic-progression-from-sequence/description/)
* [LeetCode-1496. 判断路径是否相交](https://leetcode-cn.com/problems/path-crossing/description/)
* [LeetCode-1491. 去掉最低工资和最高工资后的工资平均值](https://leetcode-cn.com/problems/average-salary-excluding-the-minimum-and-maximum-salary/description/)
* [LeetCode-1455. 检查单词是否为句中其他单词的前缀](https://leetcode-cn.com/problems/check-if-a-word-occurs-as-a-prefix-of-any-word-in-a-sentence/description/)



## 【水题】1507. 转变日期格式
### Description
* [LeetCode-1507. 转变日期格式](https://leetcode-cn.com/problems/reformat-date/description/)
 
### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution



```java
class Solution {
    private static Map<String,String> monthMap = new HashMap<>();

    static {
        monthMap.put("Jan", "01");
        monthMap.put("Feb", "02");
        monthMap.put("Mar", "03");
        monthMap.put("Apr", "04");
        monthMap.put("May", "05");
        monthMap.put("Jun", "06");
        monthMap.put("Jul", "07");
        monthMap.put("Aug", "08");
        monthMap.put("Sep", "09");
        monthMap.put("Oct", "10");
        monthMap.put("Nov", "11");
        monthMap.put("Dec", "12");
    }

    public String reformatDate(String date) {
        String[] arr = date.split(" ");
        StringBuffer sBuffer = new StringBuffer();
        sBuffer.append(arr[2]).append("-"); //year
        sBuffer.append(monthMap.get(arr[1])).append("-"); //month
        sBuffer.append(getDay(arr[0])); //day
        return sBuffer.toString();
    }

    private String getDay(String dayStr){
        String day = "";
        if(Character.isDigit(dayStr.charAt(1))){
            day = dayStr.substring(0,2);
        } else{
            day = "0" + dayStr.charAt(0);
        }
        return day;
    }
}
```

### Approach 2-String.format
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public String reformatDate(String date) {
        String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        Map<String, Integer> s2month = new HashMap<String, Integer>();
        for (int i = 1; i <= 12; i++) {
            s2month.put(months[i - 1], i);
        }
        String[] array = date.split(" ");
        int year = Integer.parseInt(array[2]);
        int month = s2month.get(array[1]);
        int day = Integer.parseInt(array[0].substring(0, array[0].length() - 2));
        return String.format("%d-%02d-%02d", year, month, day);
    }
}
```

## 【水题】1502. 判断能否形成等差数列
### Description
* [LeetCode-1502. 判断能否形成等差数列](https://leetcode-cn.com/problems/can-make-arithmetic-progression-from-sequence/description/)
 

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public boolean canMakeArithmeticProgression(int[] arr) {
        Arrays.sort(arr);
        //2 <= arr.length <= 1000
        int distance = arr[1] - arr[0];
        for(int i=2;i<arr.length;i++){
            if(arr[i]-arr[i-1] != distance){
                return false;
            }
        }
        return true;

    }
}
```

## 1496. 判断路径是否相交
### Description
* [LeetCode-1496. 判断路径是否相交](https://leetcode-cn.com/problems/path-crossing/description/)

### Approach 1-哈希表
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public boolean isPathCrossing(String path) {
        int length = path.length();
        Map<List<Integer>,Integer> map = new HashMap<>();
        List<Integer> point = new ArrayList<>();
        point.add(0);
        point.add(0);
        map.put(point, 1);
        for(int i=0;i<length;i++){
            List<Integer> curPoint = getCurPoint(path.charAt(i),point);
            map.put(curPoint, map.getOrDefault(curPoint, 0)+1);
            if(map.get(curPoint) == 2){
                return true;
            }
            point = curPoint;
        }
        return false;

    }
    private List<Integer> getCurPoint(char c,List<Integer> point){
        
        switch(c){
            case 'N': //0 1
                point.set(1, point.get(1) + 1);
                break;
            case 'E': //1 0
                point.set(0, point.get(0) + 1);
                break;
            case 'W': // -1 0
                point.set(0, point.get(0)-1);
                break;
            case 'S': // 0 -1
                point.set(1, point.get(1)-1);
                break;
        }
        return point;

    }

}
```

## 【水题】1491. 去掉最低工资和最高工资后的工资平均值
### Description
* [LeetCode-1491. 去掉最低工资和最高工资后的工资平均值](https://leetcode-cn.com/problems/average-salary-excluding-the-minimum-and-maximum-salary/description/)
 

### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution

```java
class Solution {
    public double average(int[] salary) {
        
        int max = salary[0];
        int min = salary[0];
        int sum = 0;
        for(int val:salary){
            sum += val;
            max = Math.max(max,val);
            min = Math.min(min,val);
        }
        //3 <= salary.length <= 100
        return (double) (sum-min-max)/(salary.length-2);

    }
}
```


## 【水题】1455. 检查单词是否为句中其他单词的前缀
### Description
* [LeetCode-1455. 检查单词是否为句中其他单词的前缀](https://leetcode-cn.com/problems/check-if-a-word-occurs-as-a-prefix-of-any-word-in-a-sentence/description/)


### Approach 1-常规
#### Analysis

参考 `leetcode-cn` 官方题解。

#### Solution


```java
class Solution {
    public int isPrefixOfWord(String sentence, String searchWord) {
    
        String[] arr = sentence.split(" ");
        int length = searchWord.length();
        for(int i=0;i<arr.length;i++){
            if(arr[i].length() >= length && searchWord.equals(arr[i].substring(0,length))){
                return i+1;
            }
        }
        return -1;

    }
}
```





