
# 技术杂谈-02-Nginx



[TOC]


## 更新
* 2022/05/15，撰写



## 参考资料
* [一文弄懂前端跨域是什么 | 掘金](https://juejin.cn/post/6844904160811286536)
* [Nginx 极简教程 | github](https://github.com/dunwu/nginx-tutorial)
* [Nginx 知识点 | 掘金](https://juejin.cn/post/7068455704863965191)



## 跨域

* 「跨域」指的是在某一网站下，浏览器不能执行其他网站的脚本。浏览器采用了同源策略（`Same Origin Policy`），对 JavaScript 实施了安全限制。
* 一个 URL 由协议（Protoco）、域名（Host）、端口（Port）三部分组成，如 `https://xxx.com:80`。当一个 URL的协议、域名、端口中的任意一个，和当前页面 URL 不同时，即为「跨域」。




### 同源策略

浏览器采用了同源策略（`Same Origin Policy`），对于非同源，会有如下限制
1. 无法读取非同源网页的 `cookie`、`localstorage` 
2. 无法接触非同源网页的 DOM 和 JS  对象
3. 无法向非同源地址发送 Ajax 请求


> 只要非同源的请求都会受限制么?
> 
> 答案是否定的。只是浏览器采用了同源策略，对于一些 API请求工具（如 Postman），在调用接口时候没有该跨域限制。火狐浏览器（Firefox）提供了一款开发版浏览器，可以关闭同源策略。


### 响应返回

在浏览器接收到响应后，会校验以下响应头中的字段，确认服务端是否允许本次跨域请求。
* `Access-Control-Allow-Origin`
* `Access-Control-Allow-Methods`
* `Access-Control-Allow-Headers`
* `Access-Allow-Max-Age`


### 浏览器允许嵌入跨域资源的请求
* `<script src= "...">` 嵌入跨域脚本
* `<img>`
* `<video>`、`<audio>`
* `<iframe>`
* `<link rel= "stylesheet" href= "..." >` 嵌入 CSS
* 字体跨域


### 如何解决跨域

解决跨域的方式如下
1. JSONP
   * JSOP 根据 `<script>` 标签可以嵌入跨域脚本这一特性，在 `<script>` 标签里填入跨域资源 URL，可以指定一个回调函数（Callback），用于接收返回的跨域资源。
   * JSONP 目前仅支持 GET 请求。
2. CORS（推荐）
   * 服务端设置 `Access-Control-Allow-Origin`，将需要发送跨域请求的请求源设置到该字段中，便可支持跨域请求。
3. 服务器代理
   * 使用 Nginx 反向代理
4. 基于 `iframe` 跨域



## Nginx

### 什么是Nginx

Nginx 是一个高性能的 http 和反向代理服务器，其特点是占用内存小，并发能力强。Nginx 专为性能优化而开发，性能是其最重要的考量，能经受高负载的考验，根据官方性能测试报告，1s 中可支持 5W 个并发连接数。
1. 非阻塞、高并发连接
2. 反向代理
3. 负载均衡
4. 动静分离




### Nginx如何实现高并发

* Nginx 采用异步非阻塞的工作方式，每进来一个请求（Request），会有一个 `worker` 进程去处理。当请求未返回时，`worker` 进程会注册一个回调事件，转而去处理别的任务，这也就是「Nginx的基于事件模型」。


### 正向代理和反向代理

**一句话总结，「正向代理」是对客户端进行代理，「反向代理」是对服务端进行代理。**


### 负载均衡

Nginx 负载均衡，有如下 5 种 策略
1. 轮询策略（默认）
   * 每个请求按时间顺序逐一分配到不同的后端服务器
   * 如果后端某个服务器宕机，能自动剔除故障系统
2. 权重策略（weight）
   * 权重值越大，分配到的访问概率越高
   * 该策略主要用于后端每台服务器性能不均衡的情况下
3. IP绑定策略
   * 对请求的 IP 进行哈希，映射到对应的机器
   * 来自同一 IP 的请求会固定访问一台服务器，可以解决集群环境下共享 Session 问题
4. 使用第三方插件 `fair`
   * 需要安装 `upstream_fair` 模块
   * 是一种更智能的负载均衡算法，可以根据页面大小、加载时间长短，智能地进行负载均衡，对响应时间短的机器，优先分配请求
5. 使用第三方插件 `url_hash`
   * 需要安装 Nginx 的 hash 软件包
   * 按访问 URL 的 `hash` 结果来分配请求，使每个 URL 定向到同一个后端服务器，可以进一步提高后端缓存服务器的效率
  


### 动静分离

* 把动态页面和静态页面交给不同的服务器来解析，加快解析速度，降低原来单个服务器的压力。