<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>首页</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">

<script src="js/zepto.min.js"></script>
<script src="js/swipe.js"></script>

<link rel="stylesheet" href="css/test.css">
<link rel="stylesheet" href="css/index.css">

<style type="text/css">

#mydiv {
	position: absolute;
	margin: auto 0px;
}

.mouseOver {
	background: #708090;
	color: #FFFAFA;
}

.mouseOut {
	background: #FFFAFA;
	color: #000000;
}
</style>

<style type="text/css">
.slideout-menu { left: auto; }
.btn-hamburger { left: auto; right: 12px;}
.box { height: 1500px; }
</style>

<style type="text/css">
#mocha-stats{
	display: none;
}
</style>

<script>
        $(function(){
            $('#slide1').swipeSlide({
                autoSwipe:true,//自动切换默认是
                speed:3000,//速度默认4000
                continuousScroll:true,//默认否
                transitionType:'cubic-bezier(0.22, 0.69, 0.72, 0.88)',//过渡动画linear/ease/ease-in/ease-out/ease-in-out/cubic-bezier
                lazyLoad:true,//懒加载默认否
                firstCallback : function(i,sum,me){
                    me.find('.dot').children().first().addClass('cur');
                },
                callback : function(i,sum,me){
                    me.find('.dot').children().eq(i).addClass('cur').siblings().removeClass('cur');
                }
            });
        });
    </script>

<script>
	/**
		 * History
		 * 用法
		 * var his = new History('key');  // 参数标示cookie的键值
		 * his.add("标题", "连接 比如 http://www.baidu.com", "其他内容")；
		 * 得到历史数据 返回的是json数据
		 * var data = his.getList();  // [{title:"标题", "link": "http://www.baidu.com"}]
		 *
		 */
		 function History(key) {
		    this.limit = 10;  // 最多10条记录
		    this.key = key || 'y_his';  // 键值
		    this.jsonData = null;  // 数据缓存
		    this.cacheTime = 24;  // 24 小时
		    this.path = '/';  // cookie path
		}
		History.prototype = {
			constructor : History
			,setCookie: function(name, value, expiresHours, options) {
				options = options || {};
				var cookieString = name + '=' + encodeURIComponent(value);
		        //判断是否设置过期时间
		        if(undefined != expiresHours){
		        	var date = new Date();
		        	date.setTime(date.getTime() + expiresHours * 3600 * 1000);
		        	cookieString = cookieString + '; expires=' + date.toUTCString();
		        }

		        var other = [
		        options.path ? '; path=' + options.path : '',
		        options.domain ? '; domain=' + options.domain : '',
		        options.secure ? '; secure' : ''
		        ].join('');
				//解决tomcat不支持中文cookie问题
		        document.cookie = cookieString + other;
		    }
		    ,getCookie: function(name) {
		        // cookie 的格式是个个用分号空格分隔
		       // var arrCookie = URLDecoder.decode(document.cookie, "utf-8") ? URLDecoder.decode(document.cookie,"utf-8").split('; ') : [],
		        var arrCookie = document.cookie? document.cookie.split('; ') : [],
		        val = '',
		        tmpArr = '';

		        for(var i=0; i<arrCookie.length; i++) {
		        	tmpArr = arrCookie[i].split('=');
		            tmpArr[0] = tmpArr[0].replace(' ', '');  // 去掉空格
		            if(tmpArr[0] == name) {
		            	val = decodeURIComponent(tmpArr[1]);
		            	break;
		            }
		        }
		        return val.toString();
		    }
		    ,deleteCookie: function(name) {
		    	this.setCookie(name, '', -1, {"path" : this.path});
		        //console.log(document.cookie);
		    }
		    ,initRow : function(title, link, other) {
		    	return '{"title":"'+title+'", "link":"'+link+'", "other":"'+other+'"}';
		    }
		    ,parse2Json : function(jsonStr) {
		    	var json = [];
		    	try {
		    		json = JSON.parse(jsonStr);
		    	} catch(e) {
		            //alert('parse error');return;
		            json = eval(jsonStr);
		        }

		        return json;
		    }

		    // 添加记录
		    ,add : function(title, link, other) {
		    	var jsonStr = this.getCookie(this.key);
		        //alert(jsonStr); return;

		        if("" != jsonStr) {
		        	this.jsonData = this.parse2Json(jsonStr);

		            // 排重
		            for(var x=0; x<this.jsonData.length; x++) {
		            	if(link == this.jsonData[x]['link']) {
		            		return false;
		            	}
		            }
		            // 重新赋值 组装 json 字符串
		            jsonStr = '[' + this.initRow(title, link, other) + ',';
		            for(var i=0; i<this.limit-1; i++) {
		            	if(undefined != this.jsonData[i]) {
		            		jsonStr += this.initRow(this.jsonData[i]['title'], this.jsonData[i]['link'], this.jsonData[i]['other']) + ',';
		            	} else {
		            		break;
		            	}
		            }
		            jsonStr = jsonStr.substring(0, jsonStr.lastIndexOf(','));
		            jsonStr += ']';

		        } else {
		        	jsonStr = '['+ this.initRow(title, link, other) +']';
		        }

		        //alert(jsonStr);
		        this.jsonData = this.parse2Json(jsonStr);
		        this.setCookie(this.key, jsonStr, this.cacheTime, {"path" : this.path});
		    }
		    // 得到记录
		    ,getList : function() {
		        // 有缓存直接返回
		        if(null != this.jsonData) {
		            return this.jsonData;  // Array
		        }
		        // 没有缓存从 cookie 取
		        var jsonStr = this.getCookie(this.key);
		        if("" != jsonStr) {
		        	this.jsonData = this.parse2Json(jsonStr);
		        }

		        return this.jsonData;
		    }
		    // 清空历史
		    ,clearHistory : function() {
		    	this.deleteCookie(this.key);
		    	this.jsonData = null;
		    }
		    //获得Cookie名称
		    ,getTitle : function(key){
		    	var his = new History(key);
		    	var data = his.getList();
		    	//拼接字符串
		    	var nameStr = "[";
		    	for(var i=0;i<data.length;i++){
		    		if(data[i].link != ""){
		    			nameStr = nameStr +  "'" + data[i].link ;
		    			if(i != data.length - 1 && data[i+1].link != ""){
		    				nameStr = nameStr + "', ";
		    			}else{
		    				nameStr = nameStr + "'";
		    			}
		    		}

		    	}
		    	var nameStr = nameStr + "]";

		    	this.jsonData = this.parse2Json(nameStr);
		    	return this.jsonData;
		    }
		};
</script>

<script>
	var xmlHttp;
	var his = new History('library');
	his.add("library", "历史", "其他");
	//his.setCookie("history", "历史", "其他");
	his.add("library", "小王子", "其他");
	his.add("library", "文学", "其他");
	//获得用户输入内容的关联信息的函数
	function getMoreContents() {


		var history = his.getTitle('library');
		//console.log(history);
		//his.clearHistory();
		//首先获得用户的输入
		var content = document.getElementById("search");
		if (content.value == "") {//判断内容是否为空
			clearContent();//删除原有的
			//为空显示历史记录
			setContent(history);
			return;
		}
		clearContent();//删除原有的
		//Ajax异步向服务器发送数据
		xmlHttp = createXMLHttp();//创建XMLHttp对象

		//给服务器发送数据 encodeURI二次转码解决中文乱码
		var url = "/library/complete_search.action?" + "keyword=" + encodeURI(encodeURI(content.value));
		//alert("中文乱码测试");
		//True 表示脚本会在 send()方法之后继续执行，而不等待来自服务器的响应
		xmlHttp.open("POST", url, true);
		//xmlHttp绑定回调方法，xmlHttp状态（0-4），4（complete）
		xmlHttp.onreadystatechange = callback;//状态改变即触发函数
		xmlHttp.send(null);

	}

	//获得XmlHttp对象
	function createXMLHttp() {
		//对于大多数的浏览器都适用
		var xmlHttp2;
		if (window.XMLHttpRequest) {//如果存在对象则返回true
			xmlHttp2 = new XMLHttpRequest();
		}
		//考虑浏览器兼容性(IE)
		if (window.ActiveXObject) {
			xmlHttp2 = new ActiveXObject("Microsoft.XMLHTTP");
			if (!xmlHttp2) {
				xmlHttp2 = new ActiveXObject("Msxml2.XMLHTTP");
			}
		}
		return xmlHttp2;
	}

	//回调函数
	function callback() {
		//4代表完成
		if (xmlHttp.readyState == 4) {
			if (xmlHttp.status == 200) {
				//交互成功，获得相应的数据，是文本格式
				var result = xmlHttp.responseText;
				//	alert(result);
				//解析获得的数据
				var json = eval("(" + result + ")");//JS的json有一点不同需要加()
				//获得数据之后，动态展示在输入框下方
				setContent(json);
			}

		}
	}

	//设置关联数据展示，参数代表的是服务器传递过来的关联数据
	function setContent(contents) {
		setLocation();//设置关联数据边框
		//首先清空集合
		clearContent();
		//获得关联数据长度，确定生成表单长度
		var size = contents.length;
		//设置内容
		for ( var i = 0 ; i < size; i++) {
			var nextNode = contents[i];//代表的是json格式的第i个元素
			var tr = document.createElement("tr");
			var td = document.createElement("td");
			//创建td
			td.setAttribute("border", "0");
			td.setAttribute("bgcolor", "#FFFAFA");
			td.setAttribute("border", "solid black 1px");
			td.setAttribute("style", "position:relative;z-index:5;");
			td.onmouseover = function() {
				this.className = 'mouseOver';
				//console.log("mousuover");
				document.getElementById("search").value = this.innerHTML;
			};
			td.onmouseout = function() {
				this.className = 'mouseOut';
			};
			td.onclick = function() {
				//鼠标点击时，关联数据自动设置为输入框数据
				console.log("click");
			};
			//创建子节点
			var text = document.createTextNode(nextNode);//创建文本内容
			td.appendChild(text);
			tr.appendChild(td);
			document.getElementById("content_table_body").appendChild(tr);
		}
	}

	//清空之前的数据
	function clearContent() {
		var contentTableBody = document.getElementById("content_table_body");
		var size = contentTableBody.childNodes.length;//获得子节点的长度
		for ( var i = size - 1; i >= 0; i--) {
			contentTableBody.removeChild(contentTableBody.childNodes[i]);//获取子节点并清空
		}
		document.getElementById("popDiv").style.border = "none";//清空边框
	}

	//当输入框失去焦点的时候，关联信息清空
	function keywordBlur() {
		setTimeout(clearContent(), "1000");
	}

	//设置显示关联信息的位置
	function setLocation(){
	//关联信息的显示位置要和输入框一致
	var content = document.getElementById("search");
	var width = content.offsetWidth;//输入框的宽度
	var left = content["offsetLeft"];//到左边框的距离
	var top = content["offsetTop"] ;//到顶部的距离
	//获取显示数据的div
	var popDiv = document.getElementById("popDiv");
	popDiv.style.border = "black 1px solid";
	popDiv.style.left =  "10px";
	popDiv.style.margin = 0 + "px";
	popDiv.style.width = width + "px";
	document.getElementById("content_table").style.width = width + "px";


	var posi = document.getElementById("myDiv");
	posi.style = "margin-top:32px";
	}
</script>

<script>
	function add(){
		var keyword = document.getElementById("search").value;
		var his = new History('library');
		his.add("library", keyword, "历史记录");
		location.href = "/library/show_searchInfo.action?keyword=" + encodeURI(encodeURI(keyword)) + 
		"&weid=" + "<%=request.getParameter("weid")%>";
	}
</script>
</head>

<body>

	<!--侧边栏-->
	<nav id="menu" class="menu" style="position:absolute;left:0;width:300px;background-color:#2B2F3E;">
        <header class="menu-header" style="background-color:#2B2F3E;margin-right:20px; ">

          <c:if var="flag" test="${flag == true }" scope="page">
          <div class="weui_panel_bd">
                <div class="weui_media_box weui_media_appmsg" style="margin-left:0px;">
                    <div class="weui_media_hd" >
                        <img class="circle" src="${user.headimgurl }" alt=""
                        	style="width:64px; height:64px; margin-top:16px ">
                    </div>
                    <div class="weui_media_bd" style="margin-left:4px">
                    	<br><br>
                        <span style="font-family:'微软雅黑'; font-size:20px" class="f-white">
                        	${user.nickname }
                        </span>
                    </div>
                </div>
          </div>
          </c:if>
          
          <c:if var="flag" test="${flag == false }" scope="page">
          <div class="weui_panel_bd">
                <a href="javascript:void(0);" class="weui_media_box weui_media_appmsg" style="margin-left:0px;">
                    <div class="weui_media_hd" >
                        <img class="circle" src="" alt=""
                        	style="width:64px; height:64px; margin-top:16px ">
                    </div>
                    <div class="weui_media_bd" style="margin-left:4px">
                    	<br><br>
                        <span style="font-family:'微软雅黑'; font-size:20px" class="f-white">
                        	游客账号
                        </span>
                    </div>
                </a>
          </div>
          </c:if>
          
        </header>	

      <section class="menu-section" style="background-color:#2B2F3E">
        <h3 class="menu-section-title">我的图书馆</h3>
        <ul class="menu-section-list">
          <li><a href="/library/show_bookshelf.action?weid=${weid }">我的书架</a></li>
          <li><a href="/library/show_history.action?weid=${weid }">借阅历史</a></li>
          <li><a href="/library/show_shoppingcart.action?weid=${weid }">购物车</a></li>
          <li><a href="/library/initialWordPage.action?weid=${weid }">图书索引</a></li>
        </ul>
      </section>

      <section class="menu-section" style="background-color:#2B2F3E">
      	
        <h3 class="menu-section-title">设置</h3>
        <ul class="menu-section-list">
		  <li><a href="/library/shake.action?weid=${weid }">摇一摇</a></li>
		  <li><a href="/library/start_scan.action?weid=${weid }">扫一扫</a></li>
          <li><a href="#">我的设置</a></li>
        </ul>
      </section>

      
    </nav>

	<main id="panel" class="panel" style="position:position:absolute;top:0;padding:0px;">
		<header class="panel-header" style="display:none;">
        	<button class="btn-hamburger js-slideout-toggle"></button>
        	<h1 class="title" style="display:none"></h1>
		</header>
		<!-- 标题栏   -->
			<div class="weui-header bg-blue" style="height:78px;background-color:#01164b">
				<div class="weui-header-left">
					<a class=" f-white">
						<div class="weui-avatar-circle">
							<img src="/library/image/myicon/book.svg" class="weui-avatar-url">
						</div> </a>
				</div>
				<h1 class="weui-header-title" style="margin-top:15px">
						<span style="font-family:''; font-size:">
                        	超新星智能图书馆
                        </span>
				</h1>
			</div>
 <section>
    <h2 class="box-title" style="display:none;"></h2>
        
	<div id="mocha">
		<div class="weui_search_bar">
			<!--输入框-->
			<input type="text" size="50" class="search-input" id="search"
				onkeyup="getMoreContents()" placeholder='关键字' onblur="keywordBlur()"
				onfocus="getMoreContents()">
			<button class="weui_btn weui_btn_mini weui_btn_default"
				id="searchaction" onclick="add();">
				<i class="icon icon-4"></i>
			</button>

			<div id="myDiv">
				<div id="popDiv">
					<table id="content_table" bgcolor="#FFFAFA" border="0"
						cellspacing="0" cellpadding="0">
						<tbody id="content_table_body">
							<!-- 数据显示处 -->
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<!-- 轮播  -->
		<div class="slide" id="slide1" style="position:relative;z-index:0;">
			<ul>
				<li><a href="#"> <img
						src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"
						data-src="http://7xr193.com1.z0.glb.clouddn.com/1.jpg" alt="">
				</a>
					<div class="slide-desc">帅帅的轮播~~</div></li>
				<li><a href="#"> <img
						src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"
						data-src="http://7xr193.com1.z0.glb.clouddn.com/2.jpg" alt="">
				</a>
					<div class="slide-desc">小柯的轮播~~</div></li>
				<li><a href="#"> <img
						src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"
						data-src="http://7xr193.com1.z0.glb.clouddn.com/3.jpg" alt="">
				</a>
					<div class="slide-desc">大师的轮播~~</div></li>
			</ul>
			<div class="dot">
				<span></span> <span></span> <span></span>
			</div>
		</div>

		<!-- 书籍分类  -->
		<div class="weui_grids">
			<a	href="/library/show_singleCat.action?id=wenxue&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<img src="/library/image/myicon/wenxue.svg" alt="文学">
				</div>
				<p class="weui_grid_label">文学</p> 
			</a> 
			<a	href="/library/show_singleCat.action?id=zhuanji&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<img src="/library/image/myicon/zhuanji.svg" alt="传记">
				</div>
				<p class="weui_grid_label">传记</p> 
			</a> 
			<a	href="/library/show_singleCat.action?id=lishi&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<img src="/library/image/myicon/lishi.svg" alt="历史">
				</div>
				<p class="weui_grid_label">历史</p> 
			</a> 
			<a	href="/library/show_singleCat.action?id=zhexue&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<img src="/library/image/myicon/zhexue.svg" alt="哲学">
				</div>
				<p class="weui_grid_label">哲学</p> 
			</a> 
			<a  href="/library/show_singleCat.action?id=ertong&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<img src="/library/image/myicon/ertong.svg" alt="儿童">
				</div>
				<p class="weui_grid_label">儿童</p> 
			</a> 
			<a	href="/library/show_singleCat.action?id=xiaoshuo&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<img src="/library/image/myicon/xiaoshuo.svg" alt="小说">
				</div>
				<p class="weui_grid_label">小说</p> 
			</a> 
			<a	href="/library/show_singleCat.action?id=xinli&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<img src="/library/image/myicon/xinli.svg" alt="心理">
				</div>
				<p class="weui_grid_label">心理</p> 
			</a> 
			<a	href="/library/show_singleCat.action?id=shehui&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<img src="/library/image/myicon/guanli.svg" alt="社会">
				</div>
				<p class="weui_grid_label">社会</p> 
			</a> 
			<a	href="/library/show_singleCat.action?id=keji&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<img src="/library/image/myicon/jisuanji.svg" alt="科技">
				</div>
				<p class="weui_grid_label">科技</p> 
			</a>
		</div>
	</div>
      </section>

    </main>




   <script src="https://cdnjs.cloudflare.com/ajax/libs/mocha/1.13.0/mocha.min.js"></script>
    <script>
      //mocha.setup('bdd');
      var exports = null;
      // function assert(expr, msg) {
      //   if (!expr) throw new Error(msg || 'failed');
      // }
    </script>
    <script src="js/slideout.js"></script>
    <script src="js/test.js"></script>
    <script>
      window.onload = function() {
        document.querySelector('.js-slideout-toggle').addEventListener('click', function() {
          slideout.toggle();
        });

        document.querySelector('#menu').addEventListener('click', function(eve) {
          if (eve.target.nodeName === 'A') { slideout.close(); }
        });

        var runner = mocha.run();
      };
    </script>

</body>
</html>
