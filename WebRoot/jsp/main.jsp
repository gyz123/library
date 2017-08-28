<%@ page language="java" import="java.util.*" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

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
.slideout-menu {
	left: auto;
}

.btn-hamburger {
	left: auto;
	right: 12px;
}

.box {
	height: 1500px;
}
</style>

<style type="text/css">
#mocha-stats {
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
	//将关键词提交
	function add(){
		var keyword = document.getElementById("search").value;
		var his = new History('library');
		his.add("library", keyword, "历史记录");
		location.href = "/library/show_searchInfo.action?keyword=" + encodeURI(encodeURI(keyword)) + 
		"&weid=" + "<%=request.getParameter("weid")%>";
	}
</script>

<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="js/jquery-3.1.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/icon.css">
<script>
	var $j = jQuery.noConflict(); //自定义一个比较短的快捷方式
</script>
<script type="text/javascript">

		//console.log(encodeURIComponent(location.href.split('#')[0]));
		$j(document).ready((function(){
			//异步请求jsapi
				$j.ajax({    
		            type:'post',        
		            url:'/library/get_jssdk.action',    //servlet名
		            data:"url=" + encodeURIComponent(location.href.split('#')[0]),  //参数 
		            cache:false,    
		            //dataType:'json',
		            success:function(data){
		        	
						var jsonObj = jQuery.parseJSON(data);//将json字符串解析成json对象
						//console.log(jsonObj[0].url)
						//验证
						wx.config({
					    	debug: false,
					    	appId: jsonObj[0].appid,
					    	timestamp: jsonObj[0].timestamp,
					    	nonceStr: jsonObj[0].nonceStr,
					    	signature: jsonObj[0].signature,
					    	jsApiList: [
					    	'checkJsApi',
					    	'translateVoice',
					    	'startRecord',
					    	'stopRecord',
					    	'onRecordEnd',
					    	'scanQRCode',
					    	]
					    });
 					},
 					error:function(){
 						console.log("ajax请求失败");
 					}
		        }); 

		})    
	);
    
</script>

<script type="text/javascript">
	//步骤四：通过ready接口处理成功验证
	wx.ready(function() {
		// 3 智能接口
		var voice = {
			localId : '',
			serverId : ''
		};

		$j('#talk_btn').on('touchstart', function(event){
			console.log("手指按下了");
			event.preventDefault();
			START = new Date().getTime();

			recordTimer = setTimeout(function(){
				wx.startRecord({
					success: function(){
						localStorage.rainAllowRecord = 'true';
					},
					cancel: function () {
						alert('用户拒绝授权录音');
					}
				});
			},300);
		});

		$j('#talk_btn').on('touchend', function(event){
			console.log("手指松开了");
			event.preventDefault();
			END = new Date().getTime();

			if((END - START) < 300){
				END = 0;
				START = 0;
        	//小于300ms，不录音
        	clearTimeout(recordTimer);
        }else{
        	wx.stopRecord({
        		success: function (res) {
        			voice.localId = res.localId;
        			if (voice.localId == '') {
        				alert('请先使用 startRecord 接口录制一段声音');
        				return;
        			}
        			wx.translateVoice({
        				localId : voice.localId,
        				complete : function(res) {
        					if (res.hasOwnProperty('translateResult')) {
        						//alert('识别结果：' + res.translateResult);
        						var str = res.translateResult;
        						
        						$j("#search").attr("value", str.substring(0,str.length-1));
        					} else {
        						alert('无法识别');
        					}
        				}
        			});
        			//uploadVoice();
        		},
        		fail: function (res) {
        			//alert(JSON.stringify(res));
        			alert("出错啦...");
        			console.log(JSON.stringify(res));
        		}
        	});
        }
       // alert("手指松开了");
    });

});

	wx.error(function(res) {
		//alert(res.errMsg);
	});
</script>


</head>

<body>

	<!--侧边栏-->
	<nav id="menu" class="menu"
		style="position:absolute;left:0;width:300px;background-color:#2B2F3E;">
	<header class="menu-header"
		style="background-color:#2B2F3E;margin-right:20px; "> <c:if
		var="flag" test="${flag == true }" scope="page">
		<div class="weui_panel_bd">
			<div class="weui_media_box weui_media_appmsg"
				style="margin-left:0px;">
				<div class="weui_media_hd">
					<img class="circle" src="${user.headimgurl }" alt=""
						style="width:64px; height:64px; margin-top:16px ">
				</div>
				<div class="weui_media_bd" style="margin-left:4px">
					<br>
					<br> <span style="font-family:'微软雅黑'; font-size:20px"
						class="f-white"> ${user.nickname } </span>
				</div>
			</div>
		</div>
	</c:if> <c:if var="flag" test="${flag == false }" scope="page">
		<div class="weui_panel_bd">
			<a href="javascript:void(0);"
				class="weui_media_box weui_media_appmsg" style="margin-left:0px;">
				<div class="weui_media_hd">
					<img class="circle" src="" alt=""
						style="width:64px; height:64px; margin-top:16px ">
				</div>
				<div class="weui_media_bd" style="margin-left:4px">
					<br>
					<br> <span style="font-family:'微软雅黑'; font-size:20px"
						class="f-white"> 游客账号 </span>
				</div> </a>
		</div>
	</c:if> </header> <section class="menu-section" style="background-color:#2B2F3E">
	<h3 class="menu-section-title">我的图书馆</h3>
	<ul class="menu-section-list">
		<li><a href="/library/show_mylibrary.action?weid=${weid }">个人中心</a>
		</li>
		<li><a href="/library/show_shoppingcart.action?weid=${weid }">待借清单</a>
		</li>
		<li><a href="/library/show_settings.action?weid=${weid }">推送设置</a>
		</li>
	<!--  
		<li><a href="/library/show_bookshelf.action?weid=${weid }">我的收藏</a>
		</li>
		<li><a href="/library/show_history.action?weid=${weid }">我的借阅</a>
		</li>
	-->
	</ul>
	</section> <section class="menu-section" style="background-color:#2B2F3E">

	<h3 class="menu-section-title">更多功能</h3>
	<ul class="menu-section-list">
		<li><a href="/library/initialWordPage.action?weid=${weid }">图书索引</a>
		</li>
		<li><a href="/library/shake.action?weid=${weid }">摇一摇</a>
		</li>
		<li><a href="/library/start_scan.action?weid=${weid }">扫一扫</a>
		</li>
	</ul>
	</section> </nav>

	<main id="panel" class="panel"
		style="position:position:absolute;top:0;padding:0px;"> <header
		class="panel-header" style="display:none;">
	<button class="btn-hamburger js-slideout-toggle"></button>
	<h1 class="title" style="display:none"></h1>
	</header> <!-- 标题栏   -->
	<div class="weui-header bg-blue"
		style="height:78px;background-color:#01164b">
		<div class="weui-header-left">
			<a class=" f-white">
				<div class="weui-avatar-circle">
					<!--<img src="/library/image/myicon/book.svg" class="weui-avatar-url">-->
					<img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNDkzMjA0NDg5OTc5IiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjIzODgiIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCI+PGRlZnM+PHN0eWxlIHR5cGU9InRleHQvY3NzIj48L3N0eWxlPjwvZGVmcz48cGF0aCBkPSJNOTAuMDM1MiAyMDMuNjMzNjY0Yy0xMy4yMTY3NjggMC0yMy45NTQ0MzIgMTAuNzM2NjQtMjMuOTU0NDMyIDIzLjkyOTg1NmwwIDU2OS4zNzY3NjhjMCA2Ljc2MDQ0OCAyLjg3MDI3MiAxMy4yNTM2MzIgNy45MTU1MiAxNy44MDIyNCA0Ljk4NDgzMiA0LjQ3Mzg1NiAxMS4xMDExODQgNi43MzU4NzIgMTguNTE4MDE2IDYuMDMwMzM2IDAuNDg2NC0wLjA0ODEyOCA1My4wODcyMzItNS4zNTA0IDEyMS45NDUwODgtNS4zNTA0IDcwLjQ1MTIgMCAxNjkuMjkzODI0IDUuNjY1NzkyIDI0MC4wOTgzMDQgMzIuNTg3Nzc2IDIuNzM1MTA0IDEuMDQ0NDggNS41OTMwODggMS41ODAwMzIgOC40OTkyIDEuNTgwMDMyIDMuODE4NDk2IDAgNy4zODA5OTItMS4xNjgzODQgMTAuNjYzOTM2LTIuODQ1Njk2IDcuMDAzMTM2IDIuNzIzODQgMTQuMDE4NTYgNS41Njk1MzYgMjEuMDU5NTg0IDguNjU3OTIgMi41ODg2NzIgMS4xNDE3NiA1LjMzNzA4OCAxLjcyNjQ2NCA4LjE1ODIwOCAxLjcyNjQ2NCAzLjU3NDc4NCAwIDcuMDE2NDQ4LTEuMjE2NTEyIDEwLjE1Mjk2LTMuMDQwMjU2IDMuMTM3NTM2IDEuODIzNzQ0IDYuNTc5MiAzLjA0MDI1NiAxMC4xNTI5NiAzLjA0MDI1NiAyLjgwODgzMiAwIDUuNTY4NTEyLTAuNTgzNjggOC4xMzQ2NTYtMS43MDE4ODggNy4wNC0zLjExMTkzNiAxNC4wOC01Ljk1NzYzMiAyMS4wODQxNi04LjY4MjQ5NiAzLjI3MDY1NiAxLjY3ODMzNiA2Ljg0NjQ2NCAyLjg0NTY5NiAxMC42NTE2NDggMi44NDU2OTYgMi45MTg0IDAgNS43NjMwNzItMC41MzU1NTIgOC41MjI3NTItMS41ODAwMzIgNzAuNzc5OTA0LTI2LjkyMTk4NCAxNjkuNjIyNTI4LTMyLjU4Nzc3NiAyNDAuMDg2MDE2LTMyLjU4Nzc3NiA2OC44NTc4NTYgMCAxMjEuNDU4Njg4IDUuMzAyMjcyIDEyMi4wMTc3OTIgNS4zNTA0IDYuODQ2NDY0IDAuNjA4MjU2IDEzLjQ2MTUwNC0xLjU1NjQ4IDE4LjQ1NzYtNi4wMzAzMzYgNS4wMzM5ODQtNC41NDc1ODQgNy45MDQyNTYtMTEuMDQxNzkyIDcuOTA0MjU2LTE3LjgwMjI0TDk2MC4xMDM0MjQgMjI3LjU2MzUyYzAtMTMuMTkzMjE2LTEwLjc0ODkyOC0yMy45Mjk4NTYtMjMuOTU0NDMyLTIzLjkyOTg1Ni0xMy4xOTMyMTYgMC0yMy45NDIxNDQgMTAuNzM2NjQtMjMuOTQyMTQ0IDIzLjkyOTg1NmwwIDU0My4zNTY5MjhjLTE2LjE4NDMyLTEuMTY4Mzg0LTM3LjU3MTU4NC0yLjM2MDMyLTYyLjM4OTI0OC0zLjA0MDI1Nkw4NDkuODE3NiAxOTUuOTAwNDE2YzAtMTIuMzI5OTg0LTguNDM4Nzg0LTIyLjU3OTItMTkuNjM3MjQ4LTIzLjgzMTU1Mi0xNy43NjUzNzYtMS45NTc4ODgtMzUuOTA2NTYtMi45NjY1MjgtNTMuOTI2OTEyLTIuOTY2NTI4LTE0Ny4xODc3MTIgMC0yNTAuNTkxMjMyIDY1LjE2MTIxNi0yNjMuMTYzOTA0IDczLjQ2Njg4LTEyLjU4MzkzNi04LjMwNDY0LTExNS45NzUxNjgtNzMuNDY2ODgtMjYzLjE2Mjg4LTczLjQ2Njg4LTE4LjAyMDM1MiAwLTM2LjE2MTUzNiAxLjAwOTY2NC01My45MzkyIDIuOTY2NTI4LTExLjE4NjE3NiAxLjI1MjM1Mi0xOS42MjQ5NiAxMS41MDI1OTItMTkuNjI0OTYgMjMuODMxNTUyTDE3Ni4zNjI0OTYgNzY3Ljg4MDE5MmMtMjQuODE2NjQgMC42Nzk5MzYtNDYuMjA1OTUyIDEuODcxODcyLTYyLjQwMTUzNiAzLjA0MDI1NkwxMTMuOTYwOTYgMjI3LjU2MzUyQzExMy45NjUwNTYgMjE0LjM3MDMwNCAxMDMuMjI4NDE2IDIwMy42MzM2NjQgOTAuMDM1MiAyMDMuNjMzNjY0ek01NDUuMDk3NzI4IDI3Ny45MDIzMzZjMjguMzkyNDQ4LTE2LjM3ODg4IDExNi4zMTYxNi02MC44OTQyMDggMjMxLjE1OTgwOC02MC44OTQyMDggOS45NTk0MjQgMCAxOS45ODk1MDQgMC4zNDA5OTIgMjkuODg4NTEyIDAuOTg1MDg4TDgwNi4xNDYwNDggNzYwLjM2NDAzMmMtMTEuNTQwNDgtMC43MDQ1MTItMjMuNjczODU2LTEuMDcwMDgtMzYuMTYxNTM2LTEuMDcwMDgtNTQuODUwNTYgMC0xMzcuNzE1NzEyIDYuOTU2MDMyLTIyNC44ODU3NiAzOS40NzAwOEw1NDUuMDk4NzUyIDI3Ny45MDIzMzZ6TTIyMC4wNDIyNCAyMTcuOTk0MjRjOS44ODU2OTYtMC42NDQwOTYgMTkuOTE2OC0wLjk4NTA4OCAyOS44ODg1MTItMC45ODUwODggMTE0LjgzMjM4NCAwIDIwMi43NjgzODQgNDQuNTE1MzI4IDIzMS4xNTk4MDggNjAuODk0MjA4TDQ4MS4wOTA1NiA3OTguNzY0MDMyYy04Ny4xODIzMzYtMzIuNTE0MDQ4LTE3MC4wMzUyLTM5LjQ3MDA4LTIyNC44ODU3Ni0zOS40NzAwOC0xMi40ODc2OCAwLTI0LjYyMzEwNCAwLjM2NTU2OC0zNi4xNjE1MzYgMS4wNzAwOEwyMjAuMDQzMjY0IDIxNy45OTQyNHoiIHAtaWQ9IjIzODkiPjwvcGF0aD48L3N2Zz4=" class="weui-avatar-url">
				</div> </a>
		</div>
		<h1 class="weui-header-title" style="margin-top:15px">
			<span style="font-family:''; font-size:"> 超新星智能图书馆 </span>
		</h1>
	</div>
	<section>
	<h2 class="box-title" style="display:none;"></h2>

	<div id="mocha">
		<div class="weui_search_bar">
			<!--输入框-->
			<input type="text" size="50" class="search-input " id="search"
				onkeyup="getMoreContents()" placeholder='关键字/拼音/ISBN'
				onblur="keywordBlur()" onfocus="getMoreContents()">
			<button class="weui_btn weui_btn_mini weui_btn_default "
				id="talk_btn" ontouchstart="return false;" style="height:32px">
				<i class="icon icon-44"></i>
			</button>
			<button class="weui_btn weui_btn_mini weui_btn_default"
				id="searchaction" onclick="add();" style="margin-top:0px">
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
			<c:forEach var="annolist" items="${annolist}">
				<li>
					<a href="/library/enter_anno.action?weid=${weid }&anno_id=${annolist.annoid }"> 
						<img data-src="${annolist.img }" alt=""> 
					</a>
					<div class="slide-desc">${annolist.title }</div>
				</li>
			</c:forEach>
			<!--  
				<li><a href="#"> <img
						data-src="/library/image/announcement/2.jpg" alt=""> </a>
					<div class="slide-desc">图书馆借书流程及守则</div></li>
				<li><a href="/library/enter_anno.action?weid=${weid }"> <img
						data-src="/library/image/announcement/3.jpg" alt=""> </a>
					<div class="slide-desc">每月好书推荐</div></li>
			-->
			</ul>
			<div class="dot">
				<span></span> <span></span> <span></span>
			</div>
		</div>

		<!-- 书籍分类  -->
		<div class="weui_grids">
			<a
				href="/library/show_singleCat.action?id=wenxue&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<!--<img src="/library/image/myicon/wenxue.svg" alt="文学">-->
					<img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNDkzMTk1NTgyNDA1IiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjQ0MDgiIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCI+PGRlZnM+PHN0eWxlIHR5cGU9InRleHQvY3NzIj48L3N0eWxlPjwvZGVmcz48cGF0aCBkPSJNMjAwLjU5NTY0NCA3NjcuNjE5ODQybDE4My45NTE1NjkgMCA2MzguNTYyNTExLTYzOC4xMzI3MjJjMCAwLTc0LjI2NTQyNC02Ni42Mzk3NDYtMjI4LjU2MjYwMy02Ni42Mzk3NDZzLTI5OC4zODg5MjQgNzcuMDI3MzI3LTM3OC4wNTUzNTggMTU2LjY5MjczOGMtNzkuNjY1NDExIDc5LjY2NTQxMS0yODguNzk1NDI5IDI5MS4zOTk3NDMtMjg4Ljc5NTQyOSAyOTEuMzk5NzQzbDAuOTQ5NjI4IDIzOC4yNzI3NTVMMC4wMjE0ODkgODgxLjg4MTE4OWwwLjE1NDUxOSA3OC4zODIxODUgNDQ3Ljg1MDk4MSAwIDAtNjQuNDY4MjlMNzYuMzI0MzE2IDg5NS43OTUwODMgMjAwLjU5NTY0NCA3NjcuNjE5ODQyek00NjIuMDc4MDA3IDI2NS4xMjYzNTZjMzYuNzY4NDE1LTM2Ljc2ODQxNSA4Ny4xMjUzMTMtNzAuNDk0NTQxIDE0MS43OTM0LTk0Ljk2NDg2MiA2Mi42MjEyMjMtMjguMDMwNDAzIDEyOC41NTU5MTEtNDIuODQ1ODMxIDE5MC42NzU3MTQtNDIuODQ1ODMxIDQ0LjUyNzEyMyAwIDg1LjQ3MjY3NCA2LjE4MzgzOSAxMjIuMDM1NDA0IDE4LjQwODI1NUwzNTcuODg1OTkzIDcwMy4xNTE1NTFsLTk0Ljc4NjgwNyAwIDMwNC45MTY1OTUtMzE0LjQ5OTg1Ny00Ni4yODYxODYtNDQuODc2MDdMMzg0LjU5MjIzOCA0ODUuMjIzMTQ3IDM4NC41OTIyMzggMzQzLjAxMjIzOEM0MTQuOTc2MjQ2IDMxMi4zODg3NzYgNDQyLjUyNTY5NiAyODQuNjc4NjY4IDQ2Mi4wNzgwMDcgMjY1LjEyNjM1NnpNMTkyLjI3MTA0OCA1MzcuMzEwNDU2YzI2LjEwNDU0MS0yNi40MTY2NSA3Ni4wODk5NzktNzYuOTgwMjU1IDEyNy44NTI5LTEyOS4yNTE3NTlsMCAxNDMuNjU5OTExTDE5Mi44NTIyODYgNjgyLjk5MDM3MyAxOTIuMjcxMDQ4IDUzNy4zMTA0NTZ6IiBwLWlkPSI0NDA5Ij48L3BhdGg+PC9zdmc+" alt="文学">

				</div>
				<p class="weui_grid_label">文学</p> </a> <a
				href="/library/show_singleCat.action?id=zhuanji&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<!--<img src="/library/image/myicon/zhuanji.svg" alt="传记">-->
					<img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNDkzMTk2Mjk0NDg3IiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjE3ODcxIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgd2lkdGg9IjIwMCIgaGVpZ2h0PSIyMDAiPjxkZWZzPjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+PC9zdHlsZT48L2RlZnM+PHBhdGggZD0iTTgxNS42NjMwNDQgOTEuMzk2NTkzSDIwOC4zMzY5NTZjLTY0LjU4MzkyNCAwLTExNi45NDAzNjIgNTIuMzU1NDE1LTExNi45NDAzNjMgMTE2Ljk0MDM2M3Y2MDcuMzI2MDg4YzAgNjQuNTgzOTI0IDUyLjM1NTQxNSAxMTYuOTQwMzYyIDExNi45NDAzNjMgMTE2Ljk0MDM2M2g2MDcuMzI2MDg4YzY0LjU4MzkyNCAwIDExNi45NDAzNjItNTIuMzU2NDM4IDExNi45NDAzNjMtMTE2Ljk0MDM2M1YyMDguMzM2OTU2Yy0wLjAwMTAyMy02NC41ODM5MjQtNTIuMzU2NDM4LTExNi45NDAzNjItMTE2Ljk0MDM2My0xMTYuOTQwMzYzeiBtLTQ1My42MjE0MDQgMzM3LjUzNjUyNmMwLTgyLjY1MjQ0MiA2Ny4yNDE0NS0xNDkuODkzODkyIDE0OS44OTI4NjgtMTQ5Ljg5Mzg5MlM2NjEuODI3Mzc3IDM0Ni4yODA2NzggNjYxLjgyNzM3NyA0MjguOTMzMTE5cy02Ny4yNDE0NSAxNDkuODkzODkyLTE0OS44OTI4NjkgMTQ5Ljg5Mzg5Mi0xNDkuODkyODY5LTY3LjI0MTQ1LTE0OS44OTI4NjgtMTQ5Ljg5Mzg5MnogbTM4Ni4wMzQwNzcgNDQ0Ljk4MDYwN0gyNzUuNzk0MzIzYzYuNTE0MzY3LTEyNC42MDc5OTYgMTA5LjkzODkwMS0yMjMuOTg0MzMxIDIzNi4xNDAxODUtMjIzLjk4NDMzczIyOS42MjY4NDEgOTkuMzc2MzM1IDIzNi4xNDEyMDkgMjIzLjk4NDMzeiBtMTI1LjgzODAwOS01OC4yNDk2NThjMCAzMi4xNzA3LTI2LjA3OTk4MiA1OC4yNTA2ODItNTguMjUxNzA1IDU4LjI1MDY4MmgtOC44NTA1NzVjLTUuMDYwMjQ5LTEyMC45NDc2My04My4yMzc3NzMtMjIzLjMwNzkyNS0xOTEuMzg4OTU4LTI2My45MzExMzUgNjIuNzM5OTI2LTM2LjAwMjk4MiAxMDUuMDk0NTctMTAzLjY3MjE3NCAxMDUuMDk0NTY5LTE4MS4wNTA0OTYgMC0xMTUuMDEzNDc3LTkzLjU3MDA5NS0yMDguNTgzNTcyLTIwOC41ODI1NDktMjA4LjU4MzU3MlMzMDMuMzUyOTgzIDMxMy45MTk2NDIgMzAzLjM1Mjk4MyA0MjguOTMzMTE5YzAgNzcuMzc4MzIxIDQyLjM1MzYyIDE0NS4wNDc1MTQgMTA1LjA5NDU3IDE4MS4wNTA0OTYtMTA4LjE1MDE2MiA0MC42MjQyMzMtMTg2LjMyNzY4NiAxNDIuOTgzNTA1LTE5MS4zODc5MzUgMjYzLjkzMTEzNWgtOC43MjE2MzljLTMyLjE3MTcyNCAwLTU4LjI1MTcwNS0yNi4wNzk5ODItNTguMjUxNzA1LTU4LjI1MDY4MlYyMDguMzM1OTMyYzAtMzIuMTcwNyAyNi4wNzk5ODItNTguMjUwNjgyIDU4LjI1MTcwNS01OC4yNTA2ODJoNjA3LjMyNjA4OWMzMi4xNzE3MjQgMCA1OC4yNTE3MDUgMjYuMDc5OTgyIDU4LjI1MTcwNSA1OC4yNTA2ODJ2NjA3LjMyODEzNnoiIGZpbGw9IiMyNzI2MzYiIHAtaWQ9IjE3ODcyIj48L3BhdGg+PC9zdmc+" alt="传记">
				</div>
				<p class="weui_grid_label">传记</p> </a> <a
				href="/library/show_singleCat.action?id=lishi&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<!--<img src="/library/image/myicon/lishi.svg" alt="历史">-->
					<img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNDkzMTk1OTQ5NjE4IiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDExMTcgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjEwNzA5IiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgd2lkdGg9IjIxOC4xNjQwNjI1IiBoZWlnaHQ9IjIwMCI+PGRlZnM+PHN0eWxlIHR5cGU9InRleHQvY3NzIj48L3N0eWxlPjwvZGVmcz48cGF0aCBkPSJNNzMzLjQ2MjkzOSA4NjcuNDY3MjQybDUxLjY2NTQzMSA3Ny40OTgxNDdBNTEwLjQxNzIyMyA1MTAuNDE3MjIzIDAgMCAxIDUxMS41MzQzMTMgMTAyMy45OTk1MzVDMjI4Ljg2Mzg5NiAxMDIzLjk5OTUzNSAwIDc5NC42MjM2MzkgMCA1MTEuOTk5NzY3UzIyOC44NjM4OTYgMCA1MTEuNDg3NzY4IDBDNzk0LjYyMzYzOSAwIDEwMjMuOTk5NTM1IDIyOS4zNzU4OTYgMTAyMy45OTk1MzUgNTExLjk5OTc2N2MwIDcuODE5NjMzLTAuMTg2MTgyIDE1LjU0NjE3NS0wLjUxMiAyMy4yNzI3MTdoLTkzLjIzMDUwM2MwLjQ2NTQ1NC03LjcyNjU0MiAwLjY1MTYzNi0xNS40NTMwODQgMC42NTE2MzYtMjMuMjcyNzE3IDAtMjMxLjI4NDI1OS0xODcuNzY0Mjc4LTQxOC45MDg5LTQxOS40MjA5LTQxOC45MDg5QzI4MC4zODk2OTEgOTMuMDkwODY3IDkzLjA5MDg2NyAyODAuNjY4OTYzIDkzLjA5MDg2NyA1MTEuOTk5NzY3czE4Ny4yOTg4MjQgNDE4LjkwODkgNDE4LjM5NjkwMSA0MTguOTA4OTAxYzgxLjUwMTA1NCAwIDE1Ny42MDI4MzctMjMuMjcyNzE3IDIyMi4wMjE3MTctNjMuNDQxNDI2eiIgZmlsbD0iIzUxNTE1MSIgcC1pZD0iMTA3MTAiIGNsYXNzPSJzZWxlY3RlZCI+PC9wYXRoPjxwYXRoIGQ9Ik01MzUuMjcyNDg0IDI3OS4yNzI2SDQ2NS40NTQzMzR2Mjc5LjI3MjYwMWwyNDQuMzYzNTI1IDE0Ni42MTgxMTUgMzQuOTA5MDc1LTU3LjI1MDg4My0yMDkuNDU0NDUtMTI0LjI3NjMwN3pNODM3LjgxNzgwMSA1MTEuOTk5NzY3aDI3OS4yNzI2bC0xMzkuNjM2MyAxODYuMTgxNzM0eiIgZmlsbD0iIzUxNTE1MSIgcC1pZD0iMTA3MTEiIGNsYXNzPSIiPjwvcGF0aD48L3N2Zz4=" alt="历史">
				</div>
				<p class="weui_grid_label">历史</p> </a> <a
				href="/library/show_singleCat.action?id=zhexue&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<!--<img src="/library/image/myicon/zhexue.svg" alt="哲学">-->
					<img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNDkzMTk2NDM5MzEwIiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjIzODg5IiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgd2lkdGg9IjIwMCIgaGVpZ2h0PSIyMDAiPjxkZWZzPjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+PC9zdHlsZT48L2RlZnM+PHBhdGggZD0iTTc1NS4yIDUxNy42MzJjMC0yNjkuMzEyLTEwMS44ODgtNDg5LjQ3Mi0yMzcuNTY4LTQ4OS40NzJzLTIzNy41NjggMjIwLjY3Mi0yMzcuNTY4IDQ4OS40NzIgMTAxLjg4OCA0ODkuNDcyIDIzNy41NjggNDg5LjQ3MiAyMzcuNTY4LTIyMC4xNiAyMzcuNTY4LTQ4OS40NzJ6IG0tNDMzLjE1MiAwYzAtMjQ4LjgzMiA5Mi4xNi00NDggMTk1LjU4NC00NDhzMTk1LjU4NCAxOTkuMTY4IDE5NS41ODQgNDQ4LTkyLjE2IDQ0OC0xOTUuNTg0IDQ0OC0xOTUuNTg0LTE5OS4xNjgtMTk1LjU4NC00NDh6IiBwLWlkPSIyMzg5MCI+PC9wYXRoPjxwYXRoIGQ9Ik05My42OTYgNzYyLjM2OGM2Ny41ODQgMTE3LjI0OCAzMDkuNzYgOTUuMjMyIDU0Mi43Mi0zOS40MjRzMzczLjI0OC0zMzIuOCAzMDUuNjY0LTQ1MC41NmMtNDguNjQtODMuOTY4LTE4Ny4zOTItOTcuNzkyLTM1My43OTItNDUuMDU2LTEwLjc1MiAzLjU4NC0xNi44OTYgMTUuMzYtMTIuOCAyNi42MjQgMy41ODQgMTAuNzUyIDE0Ljg0OCAxNi4zODQgMjUuNiAxMy4zMTIgMTUwLjAxNi00Ny42MTYgMjY5LjMxMi0zNS44NCAzMDUuMTUyIDI2LjExMiA1MS43MTIgODkuNi03NC43NTIgMjY4LjgtMjkwLjMwNCAzOTMuMjE2cy00MzQuMTc2IDE0NC4zODQtNDg1Ljg4OCA1NC43ODRTMjA0LjI4OCA0NzIuNTc2IDQxOS44NCAzNDguMTZjOS43MjgtNS42MzIgMTMuMzEyLTE4LjQzMiA3LjY4LTI4LjY3Mi01LjYzMi05LjcyOC0xOC40MzItMTMuMzEyLTI4LjE2LTcuNjgtMjMzLjQ3MiAxMzQuNjU2LTM3My4yNDggMzMzLjMxMi0zMDUuNjY0IDQ1MC41NnoiIHAtaWQ9IjIzODkxIj48L3BhdGg+PHBhdGggZD0iTTkzLjY5NiAyNzIuODk2QzI2LjExMiAzOTAuMTQ0IDE2NS44ODggNTg4LjggMzk5LjM2IDcyMy40NTZjMTAuMjQgNS42MzIgMjIuNTI4IDIuMDQ4IDI4LjE2LTcuNjggNS42MzItOS43MjggMi4wNDgtMjIuNTI4LTcuNjgtMjguMTZDMjA0LjI4OCA1NjMuMiA3Ny44MjQgMzg0IDEyOS41MzYgMjk0LjRTMzk5Ljg3MiAyMjMuNzQ0IDYxNS40MjQgMzQ4LjE2YzEwLjI0IDUuNjMyIDIyLjUyOCAyLjA0OCAyOC4xNi03LjY4IDUuNjMyLTkuNzI4IDIuMDQ4LTIyLjUyOC03LjY4LTI4LjE2LTIzMi40NDgtMTM0LjY1Ni00NzQuNjI0LTE1Ni42NzItNTQyLjIwOC0zOS40MjR6IG04NDcuODcyIDQ4OS40NzJjNDUuNTY4LTc4LjMzNi0xLjUzNi0xOTQuNTYtMTEzLjY2NC0zMDUuNjY0LTguMTkyLTguMTkyLTIwLjk5Mi04LjE5Mi0yOS42OTYtMC41MTItOC4xOTIgOC4xOTItOC4xOTIgMjAuOTkyLTAuNTEyIDI5LjY5NmwwLjUxMiAwLjUxMmMxMDAuMzUyIDk5Ljg0IDE0MC4yODggMTk4LjE0NCAxMDcuMDA4IDI1NS40ODgtMzUuODQgNjEuOTUyLTE1NC42MjQgNzMuNzI4LTMwNC4xMjggMjYuNjI0LTEwLjc1Mi0zLjU4NC0yMi41MjggMi41Ni0yNi4xMTIgMTMuODI0LTMuNTg0IDEwLjc1MiAyLjU2IDIyLjUyOCAxMy44MjQgMjYuMTEyIDE2Ni40IDUxLjcxMiAzMDQuNjQgMzcuODg4IDM1Mi43NjgtNDYuMDh6IiBwLWlkPSIyMzg5MiI+PC9wYXRoPjwvc3ZnPg==" alt="哲学">
				</div>
				<p class="weui_grid_label">哲学</p> </a> <a
				href="/library/show_singleCat.action?id=ertong&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<!--<img src="/library/image/myicon/ertong.svg" alt="儿童">-->
					<img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNDkzMTk1NjkyMzczIiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjUwOTYiIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCI+PGRlZnM+PHN0eWxlIHR5cGU9InRleHQvY3NzIj48L3N0eWxlPjwvZGVmcz48cGF0aCBkPSJNNTYyLjMyMDU3MSAxMzEuNzcwMTE2Yy0xNC4yMTk4NjMtMS42NTA1OTMtMjguNjY0ODUzLTIuNDc2NDAxLTQzLjI3MzU3My0yLjQ3NjQwMS0yMDkuNDIyNjgzIDAtMzgxLjE0OTgzNiAxNzIuNjEyMzEzLTM4OS4yMDIyMzMgMzkwLjA4NzM5M2wxNy4xNTU3MjgtMjUuMzAxMjQ2Yy00Ny4xNjcyNTMgMTkuNTY5NzA4LTc4Ljc3NTEzNCA2Ny4yNjcwMzMtNzguNzc1MTM0IDEyMS4wODc4MjIgMCA3MS45NTE3MjkgNTUuOTU3NDUzIDEzMC4yODkzOTIgMTI0Ljk5ODg5OSAxMzAuMjg5MzkyIDMuNDYxODQ1IDAgNi45MDAxNTQtMC4xNDQyODYgMTAuMzExODU3LTAuNDM0OTA1bC0yLjIxNzUwNS0yOC4zMTY5MjktMjMuODkxMTMgMTMuNjc1NDY0YzY3LjkzNzI5OSAxMjguOTYxMTQgMTk3Ljg3Nzc0MyAyMTAuODUyMjQyIDM0MS42MjA1NDEgMjEwLjg1MjI0MiAxNDEuOTIwMjkgMCAyNzAuNDczMTMxLTc5LjgzMDE2MyAzMzkuMTMxODYxLTIwNi4yMDk1MDJsLTIzLjQxMzI0NiAxNC40MDkxNzVjNjguNDU5MTg1LTAuODAwMjI1IDEyMy42MDMxMDktNTguODYxNTk2IDEyMy42MDMxMDktMTMwLjI4ODM2OCAwLTQ3LjU3ODYyMi0yNC43MjEwMzEtOTAuNjg0MzcyLTYzLjc3ODU4Mi0xMTMuNTc0NzA4bDEzLjg5NTQ3NSAyNC40MDY4NzZjLTEuMDI5NDQ2LTg0Ljk2NTExNC0yNy4yMDQ1OTUtMTY1LjgyMjY3Ni03NC4xOTU4MzktMjMzLjE3ODczNy04Ljg1MzY0NS0xMi42OTAwMi0yNS45MDA5MDMtMTUuNDk2OTQ5LTM4LjA3NTE3Ny02LjI2ODc3NC0xMi4xNzMyNTEgOS4yMjgxNzUtMTQuODY2NTkyIDI2Ljk5Njg2NC02LjAxMjk0NyAzOS42ODY4ODQgNDAuNDA2MjY5IDU3LjkxODEwOCA2Mi44OTAzNTIgMTI3LjM3MDkyMyA2My43NzQ0ODkgMjAwLjQ3Njk0MWwwLjE5ODUyMSAxNi4zNzgwMTYgMTMuNjk3OTc3IDguMDI3ODM3YzIyLjA1NjM0MiAxMi45Mjc0MjcgMzUuOTgwNDY5IDM3LjIwNzQxMyAzNS45ODA0NjkgNjQuMDQ2Njg4IDAgNDAuMjgxNDI1LTMxLjA5NDE4MiA3My4wMjAwNi02OS43MDA0NTUgNzMuNDcxMzM4bC0xNS42ODMxOTEgMC4xODMxNzItNy43MjgwMDggMTQuMjI3MDI2Yy01OS4wNzU0NjcgMTA4Ljc0MzY4LTE2OS42MTUwNDkgMTc3LjM4NzA2LTI5MS42OTU0NzggMTc3LjM4NzA2LTEyMy42NDgxMzUgMC0yMzUuMzgwODkyLTcwLjQxNjc2OS0yOTMuODM3MjU4LTE4MS4zODEwMjRsLTguNTAyNjUxLTE2LjEzOTU4NS0xNy42MDcwMDYgMS40OTgxMmMtMS45MzA5NzkgMC4xNjM3MjktMy44ODg1NjQgMC4yNDY2MTctNS44Nzc4NzEgMC4yNDY2MTctMzguOTMwNjYxIDAtNzAuNDg1MzMxLTMyLjg5NTIwMS03MC40ODUzMzEtNzMuNDY5MjkyIDAtMzAuMzU3NDAyIDE3LjgyOTA2NC01Ny4yNjIxNjggNDQuNDIzNzY5LTY4LjI5NTQ1NmwxNi40NzIxNi02LjgzMzYzOSAwLjY4MzU2OS0xOC40NjY1ODRjNi45MjM2OS0xODYuOTk2OTI4IDE1NC42MjI1OS0zMzUuNDU3MTY4IDMzNC43Mjk1OTctMzM1LjQ1NzE2OCAxMi42MDYxMDkgMCAyNS4wMzgyNTYgMC43MTAxNzUgMzcuMjQyMjA2IDIuMTI3NDU0IDE0Ljk2MTc2IDEuNzM2NTUxIDI4LjQ0MDc0OS05LjQ5ODMyOCAzMC4xMDY2OTItMjUuMDkyNDkxQzU4OC4wNTk3OTEgMTQ3LjU1NTYzNyA1NzcuMjgyMzMxIDEzMy41MDY2NjYgNTYyLjMyMDU3MSAxMzEuNzcwMTE2TDU2Mi4zMjA1NzEgMTMxLjc3MDExNnpNNjk5Ljc5MzU3MiA2NDQuNDY4MDExYy0xLjYyNjAzNCAzLjQxMjcyNi0zLjQyOTA5OSA2LjkxNDQ4LTUuNDAxMDEgMTAuNTA5MzU1LTM2Ljg5NjMyOCA2Ny4yMzUzMS0xMDUuNDMyMjYxIDEwOS41NzI1NTgtMTgxLjA5NzU2OCAxMDkuNTcyNTU4LTc5Ljc3Mjg1OCAwLTE1MS40Mjk4NzUtNDcuMTA3OTAxLTE4Ni41NDA1MzQtMTIwLjE3MTk2My02Ljc0MTU0MS0xNC4wMjk1MjgtMjMuMTE3NTEtMTkuNzA0Nzg0LTM2LjU3NzA1Ny0xMi42Nzg3NjQtMTMuNDU5NTQ2IDcuMDI3MDQ0LTE4LjkwNDU1OSAyNC4wOTY4MTQtMTIuMTYzMDE3IDM4LjEyNTMxOSA0NC4yNjIwODYgOTIuMTEwODYxIDEzNC42NzExODkgMTUxLjU0NjUzMSAyMzUuMjgwNjA4IDE1MS41NDY1MzEgOTUuNDE3MTYzIDAgMTgxLjkwODAyNi01My40Mjg4NjMgMjI4LjQxMDEzLTEzOC4xNzM5NjYgMi40ODc2NTctNC41MjcxMDcgNC43OTQxOS05LjAxMDIxMSA2LjkxMzQ1Ny0xMy40NjA1NyA2LjY5NDQ2OS0xNC4wNTMwNjQgMS4xOTIxNTItMzEuMTAzMzkyLTEyLjI4OTkwNy0zOC4wODEzMTdDNzIyLjg0NDU2NyA2MjQuNjc3MjY5IDcwNi40ODgwNDEgNjMwLjQxMzkyMyA2OTkuNzkzNTcyIDY0NC40NjgwMTFMNjk5Ljc5MzU3MiA2NDQuNDY4MDExek02NDIuOTQ3ODg5IDEyMi4xODc4NzdjMTguOTgxMzA3IDAuMzQxNzg0IDM3LjEwNDA1OSA4LjE0NzU2NCA1MC45MzQwNDMgMjIuMzgwNzMgMjkuMTg3NzYzIDMwLjA1MTQzMyAyOS40NTk5NjIgNzkuMTAwNTQ2IDAuNTg5NDI0IDEwOS41Mjc1MzItMjguODQ1OTc4IDMwLjQ0MTMxMy03NS45MDg4NTQgMzAuNzI5ODg1LTEwNS4xMDM3OCAwLjY1Mjg2OS0xMC43MDY4NTMtMTEuMDI5MTk0LTI3Ljk2Mzg4OC0xMC45MjQ4MTctMzguNTQ1ODk4IDAuMjM0MzM3cy0xMC40ODA3MDIgMjkuMTQ3ODU0IDAuMjI0MTA0IDQwLjE3ODA3MWM1MC42MTA2NzggNTIuMTQwNTIxIDEzMi4xOTk5MDQgNTEuNjM4MDc3IDE4Mi4xOTQ1NTItMS4xMjI1NjcgNTAuMDM5NjczLTUyLjczNDAzOCA0OS41Njk5NzYtMTM3Ljc4MTAxNi0xLjA1NTAyOS0xODkuOTAwMDQ4LTIzLjg5NDItMjQuNTg5MDI1LTU1LjQyNjM1Ny0zOC4xNjkzMjEtODguMjkzOTI5LTM4Ljc2MTgxNS0xNS4wNTE4MTEtMC4yNzExNzYtMjcuNDY1NTM4IDEyLjIyNjQ2Mi0yNy43MjU0NTggMjcuOTE0NzdDNjE1LjkwNDk3NiAxMDguOTc4MDE3IDYyNy44OTYwNzggMTIxLjkxNjcgNjQyLjk0Nzg4OSAxMjIuMTg3ODc3TDY0Mi45NDc4ODkgMTIyLjE4Nzg3N3pNNzE2LjE3MTU4OCA0NzkuMzY5ODM1YzEwLjA4Nzc1MyAxMC4zMTI4OCAxNi4zNDgzNCAyNC42ODAwOTkgMTYuMzQ4MzQgNDAuNTY2OTI4IDAgMzEuMzczNTQ1LTI0LjQxNDAzOSA1Ni44MjAxLTU0LjUxMjU0NCA1Ni44MjAxLTMwLjA5NzQ4MiAwLTU0LjUxMjU0NC0yNS40NDY1NTUtNTQuNTEyNTQ0LTU2LjgyMDEgMC0zMS4zNzM1NDUgMjQuNDE0MDM5LTU2LjgyMDEgNTQuNTEyNTQ0LTU2LjgyMDFDNjkyLjg2NTc4OSA0NjMuMTE2NjYzIDcwNi4zMzY1OTIgNDY5LjMxNjg3NSA3MTYuMTcxNTg4IDQ3OS4zNjk4MzV6TTM5MS4zNTU3ODEgNDc5LjM2OTgzNWMxMC4wODg3NzYgMTAuMzEyODggMTYuMzQ5MzYzIDI0LjY4MDA5OSAxNi4zNDkzNjMgNDAuNTY2OTI4IDAgMzEuMzczNTQ1LTI0LjQxNDAzOSA1Ni44MjAxLTU0LjUxMzU2OCA1Ni44MjAxLTMwLjA5ODUwNSAwLTU0LjUxMjU0NC0yNS40NDY1NTUtNTQuNTEyNTQ0LTU2LjgyMDEgMC0zMS4zNzM1NDUgMjQuNDE0MDM5LTU2LjgyMDEgNTQuNTEyNTQ0LTU2LjgyMDFDMzY4LjA0ODk1OSA0NjMuMTE2NjYzIDM4MS41MjE4MDggNDY5LjMxNjg3NSAzOTEuMzU1NzgxIDQ3OS4zNjk4MzV6IiBwLWlkPSI1MDk3Ij48L3BhdGg+PC9zdmc+" alt="儿童">
				</div>
				<p class="weui_grid_label">儿童</p> </a> <a
				href="/library/show_singleCat.action?id=xiaoshuo&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<!--<img src="/library/image/myicon/xiaoshuo.svg" alt="小说">-->
					<img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNDkzMTk1NzY3MTEzIiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjY0OTMiIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCI+PGRlZnM+PHN0eWxlIHR5cGU9InRleHQvY3NzIj48L3N0eWxlPjwvZGVmcz48cGF0aCBkPSJNODM3LjEyIDE1MS41NTJoLTI2Ny4yNjRjLTMyLjc2OCAwLTU4Ljg4IDI2LjExMi01OC44OCA1OC44OCAwLTMyLjc2OC0yNi42MjQtNTguODgtNTguODgtNTguODhIMTg2Ljg4Yy0zMi43NjggMC01OC44OCAyNi4xMTItNTguODggNTguODh2NTI5LjkyYzAgMzIuNzY4IDI2LjExMiA1OC44OCA1OC44OCA1OC44OGgyNjUuMjE2YzE5Ljk2OCAwIDQwLjk2IDIwLjk5MiA0NC41NDQgNDUuMDU2IDIuNTYgMTYuODk2IDAuNTEyIDI4LjY3MiAwLjUxMiAyOC42NzJoMjguNjcyYy0zLjU4NC0xNi44OTYgMC0yNy42NDggMC0yNy42NDggNS4xMi0xNi44OTYgMjQuNTc2LTQ2LjA4IDQ0LjU0NC00Ni4wOGgyNjcuMjY0YzMyLjc2OCAwIDU4Ljg4LTI2LjYyNCA1OC44OC01OC44OFYyMTAuNDMyYy0wLjUxMi0zMi43NjgtMjcuMTM2LTU4Ljg4LTU5LjM5Mi01OC44OHpNNDg4LjQ0OCA3ODEuODI0cy0yNi4xMTItMjkuNjk2LTU4Ljg4LTI5LjY5NkgyMDAuMTkyYy0yLjU2IDAtMjQuMDY0LTguNzA0LTI0LjA2NC0yNC4wNjRWMjIzLjc0NGMwLTEyLjI4OCAxNi4zODQtMjQuMDY0IDI0LjA2NC0yNC4wNjRoMjI5LjM3NmMzMi43NjggMCA1OC44OCAyNi42MjQgNTguODggNTguODh2NTIzLjI2NHogbTM2MC45Ni01My4yNDhjMCA5LjcyOC0xNy45MiAyNC4wNjQtMjQuMDY0IDI0LjA2NGgtMjMwLjRjLTMyLjc2OCAwLTU4Ljg4IDI5LjY5Ni01OC44OCAyOS42OTZWMjU4LjA0OGMwLTMyLjc2OCAyNi42MjQtNTguODggNTguODgtNTguODhINjgwLjk2djE5NC4wNDhsNDguNjQtNDkuNjY0IDQ3LjEwNCA0OC42NFYxOTkuMTY4aDQ4LjEyOGMxMi4yODggMCAyNC4wNjQgMTUuMzYgMjQuMDY0IDI0LjA2NGwwLjUxMiA1MDUuMzQ0eiIgcC1pZD0iNjQ5NCI+PC9wYXRoPjwvc3ZnPg==" alt="小说">
				</div>
				<p class="weui_grid_label">小说</p> </a> <a
				href="/library/show_singleCat.action?id=xinli&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<!--<img src="/library/image/myicon/xinli.svg" alt="心理">-->
					<img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNDkzMTk2MzA4NDYzIiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjE4Mzk4IiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgd2lkdGg9IjIwMCIgaGVpZ2h0PSIyMDAiPjxkZWZzPjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+PC9zdHlsZT48L2RlZnM+PHBhdGggZD0iTTUxMiA5MjUuMTg0Yy02LjE0NCAwLTkuNzI4LTIuMDQ4LTE1LjM2LTQuNjA4LTExNy43Ni02OC42MDgtMjE3LjYtMTQ4LjQ4LTI4OC43NjgtMjMwLjRsLTAuNTEyLTAuNTEyLTAuNTEyLTAuNTEyYy00LjYwOC00LjYwOC05LjIxNi05LjcyOC0xMy44MjQtMTUuMzYtNC42MDgtNS42MzItOS43MjgtMTEuMjY0LTE0Ljg0OC0xNi4zODQtMi41Ni00LjA5Ni0zLjU4NC05LjcyOC0yLjU2LTE0LjMzNiAwLjUxMi0zLjU4NCAyLjU2LTYuMTQ0IDUuMTItOC4xOTJsMS41MzYtMS4wMjQgMS41MzYtMS41MzZjMi41Ni0yLjU2IDUuNjMyLTMuNTg0IDguNzA0LTMuNTg0IDQuMDk2IDAgNy42OCAyLjA0OCAxMC4yNCA1LjEyIDcuMTY4IDEwLjc1MiAxNy45MiAyMS41MDQgMjcuNjQ4IDMxLjIzMiA5My4xODQgMTA1LjQ3MiAyMDYuODQ4IDE3Ny42NjQgMjYyLjE0NCAyMTIuOTkyIDQuMDk2IDIuNTYgNy42OCA1LjEyIDExLjI2NCA3LjE2OGw4LjE5MiA1LjEyIDguMTkyLTQuNjA4YzcuMTY4LTQuMDk2IDE4MS43Ni0xMDQuOTYgMzAxLjA1Ni0yNTAuODggNzEuNjgtODguNTc2IDEwNS45ODQtMTc3LjE1MiAxMDIuNC0yNjQuMTkyLTMuNTg0LTExMy4xNTItOTAuMTEyLTIxMS45NjgtMjAxLjIxNi0yMjkuMzc2LTE1Ljg3Mi0zLjA3Mi0zMi4yNTYtNC42MDgtNDguNjQtNC42MDgtNTUuODA4IDAtMTA4LjAzMiAxOC40MzItMTUxLjU1MiA1My43Ni0zLjU4NCAyLjU2LTcuNjggNC4wOTYtMTEuNzc2IDQuMDk2LTQuMDk2IDAtOC4xOTItMS41MzYtMTEuNzc2LTQuMDk2LTQzLjUyLTM1LjMyOC05Ni43NjgtNTMuNzYtMTU0LjExMi01My43Ni0xNi4zODQgMC0zMy4yOCAxLjUzNi00OS42NjQgNC42MDgtMTA5LjA1NiAyMi4wMTYtMTk0LjA0OCAxMjUuNDQtMTk0LjA0OCAyMzYuNTQ0IDAgMzEuMjMyIDUuNjMyIDY4LjA5NiAxNi44OTYgMTA5LjU2OGw3LjE2OCAyNi4xMTIgMTA4LjAzMi0xMDguMDMyYzMuNTg0LTMuNTg0IDcuNjgtNS4xMiAxMS43NzYtNS4xMiA0LjA5NiAwIDguMTkyIDIuMDQ4IDExLjc3NiA1LjEybDExOS44MDggMTE5LjgwOCAxNTMuMDg4LTE1My4wODhjMy41ODQtMy41ODQgNy42OC01LjEyIDExLjc3Ni01LjEyIDQuMDk2IDAgOC4xOTIgMi4wNDggMTEuNzc2IDUuMTIgMy41ODQgMy41ODQgNS4xMiA3LjY4IDUuMTIgMTEuNzc2IDAgNC4wOTYtMi4wNDggOC4xOTItNS4xMiAxMS43NzZsLTE2NC44NjQgMTY0Ljg2NGMtMy41ODQgMy41ODQtNy42OCA1LjEyLTExLjc3NiA1LjEyLTQuMDk2IDAtOC4xOTItMi4wNDgtMTEuNzc2LTUuMTJMMjQ4LjgzMiA0MzcuMjQ4bC0xMTMuNjY0IDExMy42NjRjLTMuMDcyIDMuMDcyLTguMTkyIDUuMTItMTUuODcyIDUuMTItNi4xNDQtMi41Ni0xMC43NTItNi4xNDQtMTEuNzc2LTcuNjgtMjcuMTM2LTUzLjc2LTQwLjk2LTExMy4xNTItNDAuOTYtMTcxLjAwOCAzLjA3Mi0xMzQuMTQ0IDk1LjIzMi0yNDUuNzYgMjI0LjI1Ni0yNzEuMzYgMTguOTQ0LTQuMDk2IDM4LjQtNi4xNDQgNTcuODU2LTYuMTQ0IDU0LjI3MiAwIDEwOC4wMzIgMTUuODcyIDE1NC42MjQgNDYuNTkybDguNzA0IDUuNjMyIDguNzA0LTUuNjMyYzQ4LjEyOC0zMS4yMzIgMTAzLjkzNi00OC4xMjggMTYwLjc2OC00OC4xMjggMTYuMzg0IDAgMzIuNzY4IDEuNTM2IDQ4LjY0IDQuMDk2IDEyNy40ODggMjUuNiAyMjEuMTg0IDEzMy4xMiAyMjcuMzI4IDI2Mi42NTYgMy4wNzIgOTYuNzY4LTM0LjMwNCAxOTMuMDI0LTExMS42MTYgMjg1LjY5Ni0xMDIuNCAxMjkuNTM2LTI1MS4zOTIgMjIzLjc0NC0zMDcuMiAyNTkuNTg0LTQuMDk2IDIuNTYtOC4xOTIgNS4xMi0xMS43NzYgNy42OGwtMS41MzYgMS4wMjQtMS4wMjQgMS4wMjRjLTQuNjA4IDQuMDk2LTcuMTY4IDUuMTItMTIuMjg4IDUuMTJ6IiBmaWxsPSIiIHAtaWQ9IjE4Mzk5Ij48L3BhdGg+PC9zdmc+" alt="心理">
				</div>
				<p class="weui_grid_label">心理</p> </a> <a
				href="/library/show_singleCat.action?id=shehui&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<!--<img src="/library/image/myicon/guanli.svg" alt="社会">-->
					<img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNDkzMTk2MzUxNjA2IiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjE5MDcxIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgd2lkdGg9IjIwMCIgaGVpZ2h0PSIyMDAiPjxkZWZzPjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+PC9zdHlsZT48L2RlZnM+PHBhdGggZD0iTTM4Mi44OSAyODQuNTQ5YzAtODIuMDQ1LTY2LjY0MS0xNDguMzUxLTE0OC4zNS0xNDguMzUxLTgyLjA0NSAwLTE0OC4zNTEgNjYuNjQtMTQ4LjM1MSAxNDguMzUxIDAgMzkuODUxIDE1Ljc0IDc2LjAxNyA0MS41MjQgMTAyLjgwOC03LjAzMiAyOS4xMzMtMTAuNzE1IDU5LjYwOC0xMC43MTUgOTEuMDg2IDAgMTQxLjMxOCA3NC4zNDIgMjY0Ljg4OCAxODUuODU2IDMzNC4yMDhsMjkuODA0LTEyMS44OTZjLTYwLjYxMS01MC45MDEtOTkuMTIzLTEyNy4yNTMtOTkuMTIzLTIxMi4zMTIgMC0xNS40MDQgMS4zMzktMzAuODA5IDMuNjgzLTQ1LjU0M0MzMTcuNTg5IDQzMS41NjEgMzgyLjg5IDM2NS45MjQgMzgyLjg5IDI4NC41NDlMMzgyLjg5IDI4NC41NDkgMzgyLjg5IDI4NC41NDl6TTUxMC4xNDQgMjAxLjVjNTEuMjM1IDAgOTkuNDU4IDE0LjA2NSAxNDAuNjQ3IDM4LjE3NS02LjM2MSAxNi43NDQtMTAuMDQ1IDM0LjgyOC0xMC4wNDUgNTMuNTgxIDAgODIuMDQ1IDY2LjYzOSAxNDguMzUxIDE0OC4zNSAxNDguMzUxczE0OC4zNS02Ni42NCAxNDguMzUtMTQ4LjM1MWMwLTgxLjcwOS02Ni4zMDMtMTQ4LjAxNS0xNDguMzUtMTQ4LjAxNS0xOS4wODggMC0zNy41MDYgMy42ODMtNTQuNTg0IDEwLjM4MS02My42MjctNDQuMjA0LTE0MC45ODQtNzAuMzI0LTIyNC43MDQtNzAuMzI0LTU2LjU5NSAwLTExMC41MDkgMTIuMDU1LTE1OS4wNjYgMzMuNDg3bDY3Ljk4IDk4LjQ1M0M0NDcuNTIxIDIwNi44NTcgNDc4LjMzMSAyMDEuNSA1MTAuMTQ0IDIwMS41TDUxMC4xNDQgMjAxLjUgNTEwLjE0NCAyMDEuNXpNNzg2Ljc1MiA0OTEuMTY4Yy00LjM1NCAxMDEuMTMyLTYyLjk1NyAxODcuODY3LTE0Ny4zNDggMjMyLjQwNS0yNC40NDUtNDguMjIzLTc0LjY3Ni04MS4wNDEtMTMyLjI3NS04MS4wNDEtODIuMDQ0IDAtMTQ4LjM1IDY2LjY0Mi0xNDguMzUgMTQ4LjM1MiAwIDgxLjcwOSA2Ni42NDEgMTQ4LjM1MSAxNDguMzUgMTQ4LjM1MSA2MS42MTcgMCAxMTQuMTkzLTM3LjUwNyAxMzYuOTY1LTkwLjc1MSAxNTEuMzY1LTU0LjkyMiAyNTkuNTI5LTE5OS45MjIgMjU5LjUyOS0zNzAuMDQxIDAtOC43MDctMC4zMzQtMTcuNDE0LTEuMDA0LTI2LjEyMUw3ODYuNzUyIDQ5MS4xNjggNzg2Ljc1MiA0OTEuMTY4IDc4Ni43NTIgNDkxLjE2OHoiIHAtaWQ9IjE5MDcyIj48L3BhdGg+PC9zdmc+" alt="社会">
				</div>
				<p class="weui_grid_label">社会</p> </a> <a
				href="/library/show_singleCat.action?id=keji&pagenum=1&weid=${weid }"
				class="weui_grid js_grid">
				<div class="weui_grid_icon">
					<!--<img src="/library/image/myicon/jisuanji.svg" alt="科技">-->
					<img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNDkzMTk2NDYxMDE3IiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjI0NjE0IiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgd2lkdGg9IjIwMCIgaGVpZ2h0PSIyMDAiPjxkZWZzPjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+PC9zdHlsZT48L2RlZnM+PHBhdGggZD0iTTg3Ny41NDU0NCA4MDAuNjc2NzI1YzAgMCA4MS4yMzMxMTYgMCA4MS4yMzMxMTYtODEuMjMzMTE2TDk1OC43Nzg1NTYgMTUwLjgxNjkxNGMwLTgxLjIzMzExNi04MS4yMzMxMTYtODEuMjMzMTE2LTgxLjIzMzExNi04MS4yMzMxMTZMMTQ2LjQ1MzUzNyA2OS41ODM3OThjMCAwLTgxLjIzMjA5MyAwLTgxLjIzMjA5MyA4MS4yMzMxMTZsMCA1NjguNjI2Njk1YzAgODEuMjMzMTE2IDgxLjIzMjA5MyA4MS4yMzMxMTYgODEuMjMyMDkzIDgxLjIzMzExNmwyMzUuNTc0Mjk3IDAgMCA4MS4yMzIwOTMtNzMuMTEwMTExIDgxLjIzMjA5MyA0MDAuNzA4Mjg4IDBMNjI1LjcyNTEzNCA4ODEuOTA4ODE4bDAtODEuMjMyMDkzTDg3Ny41NDU0NCA4MDAuNjc2NzI1IDg3Ny41NDU0NCA4MDAuNjc2NzI1ek0xMDUuODM3NDkgMTUyLjQ0MTkyNGMwLTQyLjI0MTA1NyA0MC42MTYwNDYtNDIuMjQxMDU3IDQwLjYxNjA0Ni00Mi4yNDEwNTdsNzMxLjA5MTkwNCAwYzAgMCA0MC42MTcwNyAwIDQwLjYxNzA3IDQyLjI0MTA1N2wwIDQ0NS4xNTM1NDZMMTA1LjgzNzQ5IDU5Ny41OTU0NyAxMDUuODM3NDkgMTUyLjQ0MTkyNCAxMDUuODM3NDkgMTUyLjQ0MTkyNHpNMzk3Ljk5MDM4NyA5MTguMDE2MTc3bDI0LjM2OTAxNC0zNi4xMDczNTkgMC04MS4yMzIwOTMgMTYyLjc0ODY2NCAwIDAgODEuMjMyMDkzIDMzLjU5MDAyNiAzNi4xMDczNTlMMzk3Ljk5MDM4NyA5MTguMDE2MTc3IDM5Ny45OTAzODcgOTE4LjAxNjE3N3pNMTQ2LjQ1MzUzNyA3NjAuMDU5NjU2YzAgMC00MC42MTYwNDYgMC00MC42MTYwNDYtNDIuMjQxMDU3bDAtNzkuNjA3MDgyIDgxMi4zMjM5OTYgMCAwIDc5LjYwNzA4MmMwIDQyLjI0MTA1Ny00MC42MTcwNyA0Mi4yNDEwNTctNDAuNjE3MDcgNDIuMjQxMDU3TDE0Ni40NTM1MzcgNzYwLjA1OTY1NiAxNDYuNDUzNTM3IDc2MC4wNTk2NTZ6IiBwLWlkPSIyNDYxNSI+PC9wYXRoPjxwYXRoIGQ9Ik0yMzEuMDEyMzk4IDc4LjMxMDU1M2wtNjcuNjE1OTggMGMtNC41MDI1NDcgMC04LjE4NjQ1LTMuNjgzOTAyLTguMTg2NDUtOC4xODY0NWwwLTEuMDc5NTg4YzAtNC41MDI1NDcgMy42ODM5MDItOC4xODY0NSA4LjE4NjQ1LTguMTg2NDVsNjcuNjE1OTggMGM0LjUwMjU0NyAwIDguMTg2NDUgMy42ODM5MDIgOC4xODY0NSA4LjE4NjQ1bDAgMS4wNzk1ODhDMjM5LjE5ODg0NyA3NC42MjY2NTEgMjM1LjUxNDk0NSA3OC4zMTA1NTMgMjMxLjAxMjM5OCA3OC4zMTA1NTN6IiBwLWlkPSIyNDYxNiI+PC9wYXRoPjwvc3ZnPg==" alt="科技">
				</div>
				<p class="weui_grid_label">科技</p> </a>
		</div>
	</div>
	</section> </main>




	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/mocha/1.13.0/mocha.min.js"></script>
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
