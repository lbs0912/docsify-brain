# MySQL-11-MySQL编程


[TOC]



## 更新
* 2022/05/22，撰写


## 统计平均分大于60的学生

* [一张学生表，有名字、科目、成绩，写出平均分大于 60 的学生](https://wenku.baidu.com/view/1b592c04a9ea998fcc22bcd126fff705cc175cfa.html)



```s
| id | name | subjects | score |
| 1  | 张三  |  语文    |   58  |
| 2  | 张三  |  数学    |   60  |
| 3  | 李四  |  语文    |   68  |
| 4  | 李四  |  数学    |   88  |
```


对应的 SQL 如下。

```s
SELECT
    id AS 编号
    name AS 姓名
    SUM(score) AS 总成绩
    SUM(score)/COUNT(subjects) AS 平均成绩
FROM
    student
GROUP BY
    name
HAVING 
    SUM(score)/COUNT(subject) > 60
```


## 用一句SQL语句查询成绩优良中差的人数
* [用一句SQL语句查询成绩优良中差的人数](https://www.freesion.com/article/7027844333/)


```s
| id | sname | clazz |  snum |
| 1  | 张三  |  语文    |   58  |
| 2  | 张三  |  数学    |   60  |
| 3  | 李四  |  语文    |   68  |
| 4  | 李四  |  数学    |   88  |
```


如上一个 SQL 表格

1. 查询出每门课程的成绩都大于80的学生姓名


```sql
-- 通过分组聚合函数，最小的分数都大于80
SELECT sname
FROM test.Score
group by sname 
having min(snum)>80;

-- 通过all 关键字 all要放到比较的右侧
select sname
from test.Score t1
where 80 < all(select snum from test.Score t2 where t2.sname=t1.sname);

-- 逆向思维
select sname
from test.Score t1
where not exists(select 1 from test.Score t2 where t2.sname=t1.sname and t2.snum<=80);
```

2. 用一句 SQL 语句查询成绩优良中差的人数

```sql
SELECT 
sum(case when snum<60 then 1 else 0 end) AS 不合格,
sum(case when snum>=60 AND snum<70 then 1 else 0 end) AS 中,
sum(case when snum>=70 AND snum< 90 then 1 else 0 end) AS 良,
sum(case when snum>=90 then 1 else 0 end) AS 优
FROM test.Score;
```

对应的输出结果如下。


```s
| 不合格 | 中 | 良 | 优 |
|  1    | 2  | 2  |  2 |
```


3. 按姓名分组，查看每个学生的优良中差统计


```sql
SELECT sname, count(snum) 总数,
sum(case when snum<60 then 1 else 0 end) AS 不合格,
sum(case when snum>=60 AND snum<70 then 1 else 0 end) AS 中,
sum(case when snum>=70 AND snum< 90 then 1 else 0 end) AS 良,
sum(case when snum>=90 then 1 else 0 end) AS 优
FROM test.Score
group by sname;
```


4. 按科目分组，查看优良中差

```sql

SELECT clazz, count(snum) 总数,
sum(case when snum<60 then 1 else 0 end) AS 不合格,
sum(case when snum>=60 AND snum<70 then 1 else 0 end) AS 中,
sum(case when snum>=70 AND snum< 90 then 1 else 0 end) AS 良,
sum(case when snum>=90 then 1 else 0 end) AS 优
FROM test.Score
group by clazz;
```


## IF(expr,v1,v2)的使用

* [LeetCode-1873. 计算特殊奖金](https://leetcode.cn/problems/calculate-special-bonus/)


表 Employees 的信息如下。

```s
+-------------+---------+
| 列名        | 类型     |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
| salary      | int     |
+-------------+---------+
```

写出一个 SQL 查询语句，计算每个雇员的奖金。如果一个雇员的 id 是奇数并且他的名字不是以 'M' 开头，那么他的奖金是他工资的 100%，否则奖金为 0。


**在实现时，可以使用 `IF(expr,v1,v2)` 表达式。**

* 使用 `NOT LIKE`
  
```sql
SELECT  
    employee_id,
    IF(employee_id%2 = 1 AND name NOT LIKE "M%",salary,0) AS bonus
FROM
    Employees
ORDER BY
    employee_id;
```

* 使用 `LEFT(str,length)`

> `LEFT(str,length);` 是一个字符串函数，它返回具有指定长度的字符串的左边部分。

```sql
SELECT  
    employee_id,
    IF(employee_id%2 = 1 AND LEFT(name,1) <> 'M',salary,0) AS bonus
FROM
    Employees
ORDER BY
    employee_id;
```


## 196. 删除重复的电子邮箱

* [LeetCode-196. 删除重复的电子邮箱](https://leetcode.cn/problems/delete-duplicate-emails/)


表 Person 字段如下。

```s
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
+-------------+---------+
```


编写一个 SQL 删除语句来「删除」所有重复的电子邮件，只保留一个 id 最小的唯一电子邮件。以任意顺序返回结果表。 


代码实现如下。



```s
DELETE 
    p1 
FROM 
    Person AS p1,
    Person AS p2
WHERE
    p1.Email = p2.Email AND p1.Id > p2.ID;
```

## 608. 树节点

* [LeetCode-608. 树节点](https://leetcode.cn/problems/tree-node/)


求解树的节点类型。



* UNION 实现


```sql
SELECT
    id, 'Root' AS Type
FROM
    tree
WHERE
    p_id IS NULL

UNION

SELECT
    id, 'Leaf' AS Type
FROM
    tree
WHERE
    id NOT IN (SELECT DISTINCT
            p_id
        FROM
            tree
        WHERE
            p_id IS NOT NULL)
        AND p_id IS NOT NULL

UNION

SELECT
    id, 'Inner' AS Type
FROM
    tree
WHERE
    id IN (SELECT DISTINCT
            p_id
        FROM
            tree
        WHERE
            p_id IS NOT NULL)
        AND p_id IS NOT NULL
ORDER BY id;
```


* CASE 语句实现

```sql
SELECT
    id AS `Id`,
    CASE
        WHEN tree.id = (SELECT id FROM tree  WHERE p_id IS NULL)
          THEN 'Root'
        WHEN tree.id IN (SELECT p_id FROM tree)
          THEN 'Inner'
        ELSE 'Leaf'
    END AS Type
FROM
    tree
ORDER BY `Id`
;
```





## 176. 第二高的薪水
### Description

* [LeetCode-176. 第二高的薪水](https://leetcode.cn/problems/second-highest-salary/)

### Approach 1-临时表

#### Analysis


参考 `leetcode-cn` 官方题解。

将不同的薪资按降序排序，然后使用 LIMIT 子句获得第二高的薪资。

```sql
SELECT DISTINCT
    Salary AS SecondHighestSalary
FROM
    Employee
ORDER BY Salary DESC
LIMIT 1 OFFSET 1
```

然而，如果没有这样的第二最高工资，这个解决方案将被判断为 “错误答案”，因为本表可能只有一项记录。为了克服这个问题，我们可以将其作为临时表。


> **当只有一条记录时，上面的查询会返回空，而正确答案是返回 `null`。**

#### Solution


```sql
SELECT
    (SELECT DISTINCT
            Salary
        FROM
            Employee
        ORDER BY Salary DESC
        LIMIT 1 OFFSET 1) AS SecondHighestSalary
;

```


### Approach 2-IFNULL

#### Analysis

参考 `leetcode-cn` 官方题解。

参考 [MySQL IFNULL函数简介](https://www.yiibai.com/mysql/ifnull.html)，`IFNULL` 的语法如下。

```s
IFNULL(expression_1,expression_2);
```


#### Solution


```sql
SELECT
    IFNULL(
      (SELECT DISTINCT Salary
       FROM Employee
       ORDER BY Salary DESC
        LIMIT 1 OFFSET 1),
    NULL) AS SecondHighestSalary
;
```



##  197. 上升的温度
### Description
* [LeetCode-197. 上升的温度](https://leetcode-cn.com/problems/rising-temperature/)

### Approach 1-DATEDIFF实现
#### Analysis
`DATEDIFF(A,B)` 函数可以返回 A 和 B 之间的天数

```s
DATEDIFF('2007-12-31','2007-12-30');   # 1
DATEDIFF('2010-12-30','2010-12-31');   # -1
```

本题中，查询的条件有2个
1. 与之前的日期相差为 1
2. 比之前的温度高

#### Solution

```sql
select 
    w1.id
from 
    Weather w1,
    Weather w2
where 
    datediff(w1.recordDate,w2.recordDate) = 1 
and  
    w1.Temperature > w2.Temperature
;
```
