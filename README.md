# “无微不至”的借阅伴侣
## 微信端（客户端）代码说明
---

## 演示视频
["无微不至"的借阅伴侣.mp4](https;//www.baidu.com)

---

目录  
* [1 公众号](#1)

  * [1.1 公众号二维码](#1.1)
  * [1.2 公众号说明](#1.2)  

* [2 项目框架说明](#2)
  * [2.1 后台说明](#2.1)
  * [2.2 前端说明](#2.2)
  * [2.3 交互说明](#2.3)
  * [2.4 第三方库](#2.4)
* [3 源代码说明](#3)
  * [3.1 action说明](#3.1)


---
<h3 id = "1">1 公众号 </h3>

<h4 id = "1.1">1.1 公众号二维码</h4>
&emsp;&emsp;![pic](/markdown/qrcode.jpg)

<h4 id = "1.2">1.2 关注公众号</h4>
&emsp;&emsp;本项目使用微信公众平台***服务号***进行开发。  
&emsp;&emsp;用户可以通过扫描上方***二维码***，或者搜索***太平彩虹文化***（微信公众号）对平台进行关注。

<h3 id = "2">2 项目说明</h3>
<h4 id = "2.1">2.1 后台开发</h4>
&emsp;&emsp;该微信号使用***Java***作为后台的开发语言， 采用***Struts2***框架进行网页开发，分离前后台，使微信开发更加规范化。
<h4 id = "2.2">2.2 前端开发</h4>
&emsp;&emsp;前端主要采用了采用了基于微信官方提供的[WeUI](https://weui.io/)扩展的第三方样式[WeUI++](https://github.com/logoove/weui)进行页面设计，同时使用**jQuery**对节点进行动态的操作与更新。   
<h4 id = "2.3">2.3 交互说明</h4>
&emsp;&emsp;主要采用了**ajax**技术，利用**jQuery**对页面的各类事件进行监听，满足触发条件时进行异步请求。  
&emsp;&emsp;在微信网页端使用了**JSSDK**，调用手机硬件实现平台的功能。
<h4 id = "2.4">2.4 第三方库</h4>
<h5>2.4.1 WeUI++</h5>
&emsp;&emsp;github地址：[WeUI++](https://github.com/logoove/weui)。  
&emsp;&emsp;weui+是在weui0.44基础上,采用zepto作为基础库,兼容weui1.1所有效果,目前分为表单,基础,布局,组件,js函数五大类。  


<h5>2.4.2 Apache Mahout</h5>
&emsp;&emsp;github地址：[Apache Mahout](https://github.com/apache/mahout)。  
&emsp;&emsp;Apache Mahout 是 Apache Software Foundation (ASF) 开发的一个开源项目。Mahout 包含许多实现，包括集群、分类、CP 和进化程序。  
&emsp;&emsp;本项目主要使用了Mahout的***协同过滤***(CF)算法进行推荐。


<h3 id = "3">3 源代码说明</h3>
&emsp;&emsp;该微信公众号主要提供了客户端的界面，实现了用户注册、图书导航、搜索书籍、书籍详情、相关书籍、推荐阅读、在线预订、借书还书以及还书提醒等需求。  

<h4 id = "3.1">3.1 action说明</h4>
&emsp;&emsp;由于使用了**Struts2**作为开发框架，因此通过配置[struts.xml](/src/struts.xml)文件，对用户action进行集中管理并调用不同的方法。

<h5 id = "3.1.1">action</h5>
