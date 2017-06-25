# “无微不至”的借阅伴侣
## 微信端（客户端）代码说明

## 目录

- ### [1 公众号](#1)
  - #### [1.1 公众号二维码](#1.1)
  - #### [1.2 关注公众号](#1.2)
- ### [2 项目说明](#2)
  - #### [2.1 后台开发](#2.1)
  - #### [2.2 前端开发](#2.2)
  - #### [2.3 交互说明](#2.3)
  - #### [2.4 第三方库](#2.4)
    - ##### [2.4.1 WeUI+](#2.4.1)
    - ##### [2.4.2 Apache Mahout](#2.4.2)
    - ##### [2.4.3 pinyin4j](#2.4.3)
- ### [3 源代码说明](#3)
  - #### [3.1 action包方法说明](#3.1)
  - #### [3.2 po包方法说明](#3.2)
  - #### [3.3 servlet](#3.3)
  - #### [3.4 tag](#3.4)
  - #### [3.5 util包方法说明](#3.5)
- ### [4 页面说明](#4)
  - #### [4.1 jsp文件夹](#4.1)
  - #### [4.2 sidemenu文件夹](#4.2)


## 演示视频
["无微不至"的借阅伴侣(微信端).mp4](https;//www.baidu.com)

### <h3 id="1">1 公众号</h3>
#### <h4 id="1.1">1.1 公众号二维码</h4>
![二维码](/markdown/qrcode.jpg)

#### <h4 id="1.2">1.2 关注公众号</h4>  
- 本项目使用微信公众平台**服务号**进行开发。  
- 用户可以通过扫描上方**二维码**，或者搜索**太平彩虹文化**（微信公众号）对平台进行关注。  

### <h3 id="2">2 项目说明</h3>
#### <h4 id="2.1">2.1 后台开发</h4>
![java](/markdown/java.png)
- 该微信号使用**Java**作为后台的开发语言
- 采用**Struts2**框架进行网页开发，分离前后台，使微信开发更加规范化。  

#### <h4 id="2.2">2.2 前端开发</h4>
- 前端主要采用了采用了基于微信官方提供的[WeUI](https://weui.io/)扩展的第三方样式[WeUI+](https://github.com/logoove/weui)进行页面设计
- 使用**jQuery**对节点进行动态的操作与更新。  

#### <h4 id="2.3">2.3 交互说明</h4>
- 主要采用了**ajax**技术，利用**jQuery**对页面的各类事件进行监听，满足触发条件时进行异步请求。  
- 在微信网页端使用了**JSSDK**，调用手机硬件实现平台的功能。

#### <h4 id="2.4">2.4 第三方库 </h4>

##### <h5 id="2.4.1">2.4.1 WeUI+</h5>
- github地址：[WeUI+](https://github.com/logoove/weui)
- WeUI+说明：**WeUI+** 是在weui0.44基础上,采用zepto作为基础库,兼容weui1.1所有效果,目前分为表单,基础,布局,组件,js函数五大类。

##### <h5 id="2.4.2">2.4.2 Apache Mahout</h5>
![mahout](/markdown/mahout.png)
- github地址：[Apache Mahout](https://github.com/apache/mahout)
- Mahout说明：**Apache Mahout** 是 Apache Software Foundation (ASF) 开发的一个开源项目。   
Mahout 包含许多实现，包括集群、分类、CP 和进化程序。  
- 本项目主要使用了该开源库基于用户的**协同过滤**算法

##### <h5 id="2.4.3">2.4.3 pinyin4j</h5>
- github地址：[pinyin4j](https://github.com/belerweb/pinyin4j)
- pinyin4j说明：是一个支持将简体和繁体**中文转换到成拼音**的Java开源类库

### <h3 id="3">3 源代码说明</h3>
- 该微信公众号主要提供了客户端的界面，实现了用户注册、图书导航、搜索书籍、书籍详情、相关书籍、推荐阅读、在线预订、借书还书以及还书提醒等需求。
- 实现的Java代码位于[src](/src)目录中

#### <h4 id="3.1">3.1 action包方法说明</h4>
采用了**Struts2**框架，因此[struts.xml](/src/struts.xml)控制各action的交互调用，接下来解释各类方法。
##### <h5 id="3.1.1">3.1.1 action<h5>
- FinishReg.java 完成注册方法
  - GetVeriCode  获取验证码方法
  - CompleteReg  完成注册方法

##### <h5 id="3.1.2">3.1.2 action.manager<h5>
- ComfirmPay.java 管理员确认支付方法

- SearchBook.java 管理员查找书籍方法

- SearchUser.java 管理员搜索用户方法

##### <h5 id="3.1.3">3.1.3 action.page</h5>
- Library_main.java 主菜单界面方法

- Register.java 启动注册方法

- SearchList.java 搜索方法
  - getKeywords 自动补全方法
  - execute 根据关键字进行搜索

- SingleItem 单本书籍方法
  - addToShoppingCart 加入待借清单
  - addToReserve 预订
  - getBookComments 获取书评方法
  - createNewComment 用户添加评论
  - getBookOutline 获取目录
  - addToLike 添加或取消喜欢
  - execute 显示单本书籍

##### <h5 id="3.1.4">3.1.4 action.pay</h5>
- HandleOrder.java 处理订单方法
  - success 支付成功操作
  - successOperation 支付成功对书籍进行操作

- Pay.java 支付方法
  - generateCode 生成支付二维码
  - listenStatus 前端监听后台信息
  - execute 进入支付

- PayAction.java 支付动作
  - postParam 生成订单参数
  - paySuccess 异步接收微信支付结果
  - successBack 支付成功跳转

##### <h5 id="3.1.5">3.1.5 action.sidemenu</h5>
- Borrow.java 已借书籍操作方法
 - getAllBorrow 获得所有在借书籍
 - getCountTime 计算单本书籍借阅时间
 - needRemind 获取所有需要提醒的用户并封装消息

- History.java 借阅历史方法
  - continueReading 续借方法
  - returnBookCode 生成还书二维码方法
  - listen_return_Status 监听归还状态
  - returnSuccess 还书成功标志

- IniitalWord.java 首字母查询方法
  - SearchFirst 根据关键字查询
  - execute 查询成功跳转

- MyBookshelf.java 获取用户的收藏列表

- Scan.java 扫一扫方法

- Setting.java 跳转设置页面

- ShoppingCart.java 购物车方法
  - delete 删除购物车里的书
  - execute 获取用户的购物车

- WifiAction.java 跳转Wifi页面

#### <h4 id="3.2">3.2 po包方法说明</h4>
依据Java**面向对象**的特点，实现了各个对象的**实体类**，对对象的属性及动作进行封装。
##### <h5 id="3.2.1">3.2.1 po</h5>
- Comment.java 评论实体
- PayList.java 支付实体  

##### <h5 id="3.2.2">3.2.2 po.book</h5>
- Book.java 图书实体
- BookDetailInfo.java 图书具体信息实体
- BookInCategory.java 分类查询图书实体
- BookInShoppingcart.java 购物车内图书实体
- BookWithoutImg.java 无图片的图书实体
- BorrowedBook.java 已借图书实体

##### <h5 id="3.2.3">3.2.3 po.menu</h5>
- Button.java 微信按钮
- ClickButton.java 点击事件按钮
- Menu.java 微信菜单
- ViewButton.java 跳转事件按钮

##### <h5 id="3.2.4">3.2.4 po.message</h5>
- BaseMessage.java 微信消息实体
- Image.java 微信图片实体
- ImageMessage.java 图片消息实体
- News.java 单图文消息实体
- NewsMessage.java 多图文消息实体
- ReturnRemind.java 提醒还书对象实体
- ReturnRemindMes.java 提醒还书消息实体
- TextMessage.java 文本消息实体

##### <h5 id="3.2.5">3.2.5 po.user</h5>
- AccessToken.java access_token实体
- User.java 用户实体
- UserDetailInfo 用户具体信息实体

#### <h4 id="3.3">3.3 servlet</h4>
- WeixinServlet.java 微信消息处理

#### <h4 id="3.4">3.4 tag</h4>
- ForeachTag.java 自定义foreach标签
- IfTag.java 自定义if标签

#### <h4 id="3.5">3.5 util包方法说明</h4>
util为各个工具类，实现了各个工具类的封装。

##### <h5 id="3.5.1">3.5.1 util</h5>
- EncryptUtil.java 对称加解密算法
- SearchFirstUtil.java 拼音首字母查询工具类
- Vericode.java 短信验证码工具类

##### <h5 id="3.5.2">3.5.2 util.pay</h5>
- AddressUtil.java 获取用户IP地址
- CommonUtil.java 获取token方法
- ConfigUtil.java 服务号基本配置
- MD5Util.java MD5加密算法
- MyX509TrustManager.java 支付信任管理
- PayCommonUtil.java 支付权限工具类
- XMLUtil.java XML工具类

##### <h5 id="3.5.3">3.5.3 util.pinyin</h5>
- Chinese.java 中文转拼音分词
- ChineseUtil.java 判断是否包含中文
- KeyWordUtil.java 关键词分词
- PinyinUtils.java 拼音分词

##### <h5 id="3.5.4">3.5.4 util.recommend</h5>
- InterestUtil.java 基于用户行为的喜爱度分析
- RemonUtil.java Mahout推荐方法

##### <h5 id="3.5.5">3.5.5 util.recommend</h5>
- MyTask.java 线程任务
- RemindInit.java 初始化方法
- TimerManager.java 定时触发方法

##### <h5 id="3.5.6">3.5.6 util.sql</h5>
- SQL4PersonalInfo.java 个人信息搜索
- SQLUtil.java 各类数据库操作方法

##### <h5 id="3.5.7">3.5.7 util.test</h5>
- 各类方法的测试类

##### <h5 id="3.5.8">3.5.8 util.weixin</h5>
- CheckUtil.java 身份验证方法
- MessageUtil.java 微信消息处理方法
- PastUtil.java JSAPI调用方法
- WeixinUtil.java 微信的基本配置

### <h3 id="4">4 页面说明</h3>
- 此项目主要以微信网页平台进行展示，因此前端由各个JSP页面构成。
- 页面存储于WebRoot下的jsp与sidemenu文件夹中。

#### <h4 id="4.1">4.1 jsp文件夹</h4>

##### <h5 id="4.1.1">4.1.1 jsp</h5>
- Exception.jsp 出错页面
- main.jsp 主界面
- register1.jsp 注册界面
- search_back.jsp 搜索结果界面
- single_cat 单本书籍界面

##### <h5 id="4.1.2">4.1.2 singlebook</h5>
- outline.jsp 书籍概要界面
- remark.jsp 书籍评价界面
- single_item 书籍详情界面

##### <h5 id="4.1.3">4.1.3 tips</h5>
信息提示界面
- addCart_fail.jsp 加入购物车失败界面
- addCart_success.jsp 加入购物车成功界面
- hintReg.jsp 注册提醒界面
- register_failure.html 注册失败界面
- register_success.html 注册成功界面
- reserve_fail 预订失败界面
- reserve_success 预订成功界面
- returnSuccess.jsp 归还成功界面

#### <h4 id="4.2">4.2 sidemenu文件夹</h4>
- history.jsp 历史记录页面
- initialWord.jsp 单个字母图书索引界面
- myBookshelf.jsp 用户书架界面
- pay.jsp 用户支付界面
- scan.jsp 扫一扫界面
- setting.jsp 用户设置界面
- shake.jsp 摇一摇界面
- shoppingcart 购物车界面
- wifi.jsp 免费wifi界面
