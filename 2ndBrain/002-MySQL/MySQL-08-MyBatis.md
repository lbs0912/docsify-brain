
# MySQL-08-Mybatis


[TOC]


## 更新
* 2022/05/30，撰写




## 参考资料
* [MyBatis | W3CSchool](https://www.w3cschool.cn/mybatis/)





## 前言

MyBatis 是一个 Java 持久化框架，它通过 XML 描述符或注解，把对象与存储过程或 SQL 语句关联起来。MyBatis 是支持定制化 SQL、存储过程以及高级映射的优秀的持久层框架。



## MyBatis 工作流程

1. 通过 Reader 对象读取 Mybatis 映射文件
2. 通过 `SqlSessionFactoryBuilder` 对象创建 `SqlSessionFactory` 对象
3. 获取当前线程的 `SQLSession`
4. 事务默认开启
5. 通过 `SQLSession` 读取映射文件中的操作编号，从而读取 SQL 语句
6. 提交事务
7. 关闭资源


下面，结合具体的代码对上述步骤进行说明。

* 创建 XML 映射文件

```xml
<!-- CountryMapper.xml -->
<!-- 定义当前XML的命名空间 -->
<mapper namespace="com.lbs0912.model.mapper.CountryMapper">
    <!-- ID属性，定义当前select查询的唯一ID；resultType，定义当前查询的返回值类型，如果没有设置别名，则需要写成cn.mybatis.model.Country -->
    <select id="selectAll" resultType="Country">
		select id, countryname, countrycode from country
	</select>
</mapper>
```

* 通过 `new SqlSessionFactoryBuilder().build(reader)` 创建 `SqlSessionFactory` 对象；再通过 `sqlSessionFactory.openSession()` 获取当前线程的 `SQLSession`，核心代码如下

```java
public class MyBatisDemo {

    private static SqlSessionFactory sqlSessionFactory;

    /**
     * 初始化sqlSessionFactory
     */
    public static void init() {
        try {
            //1.通过 Reader 对象读取 Mybatis 映射文件
            Reader reader = Resources.getResourceAsReader("mybatis-config.xml");
            //2. 通过 SqlSessionFactoryBuilder 对象创建 SqlSessionFactory 对象
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
            reader.close();
        } catch (IOException ignore) {
            ignore.printStackTrace();
        }
    }

    public static void main(String[] args) {

        // 连接数据库
        init();
        // 3.获取当前线程的 SQLSession
        SqlSession sqlSession = sqlSessionFactory.openSession();
        try {
            //5. 通过 SQLSession 读取映射文件中的操作编号，读取 SQL 语句
            List<Country> countryList = sqlSession.selectList("selectAll");
            printCountryList(countryList);
        } finally {
            sqlSession.close();
        }
    }

}
```



## MyBatis XML 映射文件

### DynamicSQL


当需要根据传入参数的值来动态组装 SQL 时，可以使用 `<dynamic>` 标签。 `<dynamic>` 标签中可以包含多个条件比较元素。

```xml

<mapper namespace="com.lbs0912.model.mapper.PersonMapper">
    <select id="selectPerson" resultType="Person">
		select * from Person
        <dynamic prepend="where"> 
        <isNotNull property="name" prepend="and">
            name=#name#
        </isNotNull>
        <isNotNull property="sex" prepend="and">
            sex=#sex#
        </isNotNull>               
    </dynamic>
	</select>
</mapper>
```

在上面的例子中，当 `name` 和 `sex` 都非 `null` 时，执行的 SQL 语句为

```sql
select * from Person where name = xxx  and sex = xxx
```


### #{}和${}

* ref 1-[#{}如何防止SQL注入 | 掘金](https://juejin.cn/post/7064740474057146398)




`#{}` 和 `${}` 的区别如下
* **`#{}` 采用预编译方式，将传入的值作为字符串处理，可以防止 SQL 注入。`${}` 采用直接赋值方式，无法阻止 SQL 注入攻击。**
* 使用 `#{}` 时，会根据传进来的值自动选择是否加上双引号。使用 `${}` 时则不会，只会进行普通的传值。



> `#{}` 在底层使用了 `PreparedStatement` 类的 `setString()` 方法来设置参数。此方法会获取传递进来的参数的每个字符，然后进行循环对比，如果发现有敏感字符，如单引号、双引号等，会在前面加上一个转义字符 `\`，让其变为一个普通的字符串，不参与 SQL 语句的生成，达到防止 SQL 注入的效果。



下面结合一个示例进行说明。

```sql
select * from t_user where username = ?;
```

上述查询语句中，分别使用 `#{}` 和 `${}` 传入查询参数 `username`。

1. 传入 `username` 为 `a'or'1=1`，使用 `#{}`，经过 SQL 动态解析和预编译，会在单引号前面添加转义字符 `\'`，SQL 最终解析为

```sql
select * from t_user where username = "a\' or \'1=1";
```


2. 如果使用 `${}` 接收参数，会直接进行参数的替换，SQL 最终解析为


```sql
select * from t_user where username = 'a' or '1=1';
```


这样会查询所有的用户信息，并不是预期的效果。



### `<iterate>`


使用 `<iterate>` 标签遍历入参，如下代码所示。

```xml
<update id="batchUpdateTitle" parameterClass="java.util.HashMap">
    UPDATE
    material_doc_center_title
    SET
    last_update_time = now()
    <dynamic prepend=",">
        <isNotNull prepend="," property="status">
            status = #status#
        </isNotNull>
        <isNotNull prepend="," property="erpNo">
            last_update_erp = #erpNo#
        </isNotNull>
    </dynamic>
    WHERE
        id in <iterate open="(" close=")" conjunction="," property="idArr">#idArr[]#</iterate>
</update>
```






## MyBatis-Plus

* [MyBatis-Plus](https://baomidou.com/)


`MyBatis-Plus`（简称 MP）是一个 MyBatis 的增强工具，在 MyBatis 的基础上只做增强不做改变，为简化开发、提高效率而生。



## FAQ

### 时间格式出现`.0`的解决

使用 MyBatis 存储时间时，常常会遇到下发的时间戳最后包含 `.0` 的情况，如下所示。

```s
2020-09-03 22:53:34.0
```

解决办法是使用 SQL 的时间格式化函数进行处理。

```s
DATE_FORMAT(create_time,'%Y-%m-%d %H:%i:%S') AS createTime

DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%S') AS createTime
```



其实，时间戳最后的 `.0` 表示纳秒数，详情参考 [SQL Timestamp | Oracle](https://docs.oracle.com/javase/7/docs/api/java/sql/Timestamp.html#toString())

```s
Formats a timestamp in JDBC timestamp escape format. yyyy-mm-dd hh:mm:ss.fffffffff, where ffffffffff indicates nanoseconds.
```