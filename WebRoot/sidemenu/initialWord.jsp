<%@ page language="java" import="java.util.*" contentType="text/html; charset=utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>英文侧边提示栏</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
<link rel="stylesheet" href="css/initialWord.css">
<link rel="stylesheet" href="css/weui.css">
<link rel="stylesheet" href="css/weui2.css">
<link rel="stylesheet" href="css/weui3.css">
<link rel="stylesheet" href="css/weui.min.css">
<link rel="stylesheet" href="css/icon.css">

</head>

<body>
	<header>图书索引
		 <!-- <div class="weui_search_bar" style="position:absolute;top:11%;z-index:1;margin-left:50%;background-color:#2FC9DA;">--> 
				<!--输入框-->
				<!-- <input type="text" size="50" class="search-input" id="search"
					 placeholder='输入ISBN' style="z-index:50">
				<button class="weui_btn weui_btn_mini weui_btn_default"
					id="searchaction" onclick="searchISBN();" style="z-index:50">
					<i class="icon icon-4"></i>
				</button>
			</div>  -->
	</header>
	
	<div id="item-container">
		<ul>

		</ul>
	</div>

	<script src="js/initialWord.js"></script>
	<!-- <script src="data.js"></script> -->
	<script>
		var app = app || {};

		app.ItemList = function(data) {
			var list = [];
			var map = {};
			var html;

			/*html = data.map(
					function(item) {
						var i = item.lastIndexOf(' ')
						var en = item.slice(0, i)
						var cn = item.slice(i + 1)
						var ch = en[0]
						if (map[ch]) {
							return '<li>' + en + '<br>' + cn + '</li>'
						} else {
							map[ch] = true
							return '<li data-ch="' + ch + '">' + en + '<br>'
									+ cn + '</li>'
						}
					}).join('')*/
			html = "<ul id='container'><li>选择首字母，查看你想要的图书</li></ul>";

			var elItemList = document.querySelector('#item-container ul');
			elItemList.innerHTML = html;

			return {
				gotoChar : function(ch) {
					if (ch === '*') {
						elItemList.scrollTop = 0;
					} else if (ch === '#') {
						elItemList.scrollTop = elItemList.scrollHeight;
					} else {
						reg(ch);
					}
				}
			};
		};

		app.main = function() {
			var itemList = app.ItemList(app.data);
			new IndexSidebar().on('charChange', itemList.gotoChar);
		};

		app.main();

		function reg(ch) {
			var request = new XMLHttpRequest();//创建XHR对象
			request.open("POST", "/library/initialWord.action");//post方式发送，默认异步
			var data = "word=" + ch;
			request.setRequestHeader("Content-type",
					"application/x-www-form-urlencoded");
			request.send(data);
			request.onreadystatechange = function() {
				if (request.readyState === 4)//表示请求已经完成
				{
					if (request.status === 200)//用户请求被正确接收
					{
						var back = request.responseText;
						//解析获得的数据
						var json = eval("(" + back + ")");
						console.log(json);
						setContent(json);

						console.log(back);
					} else {
						alert("发生错误：" + request.status);
					}
				}
			};
		}

		//设置关联数据展示，参数代表的是服务器传递过来的关联数据
		function setContent(contents) {
			//首先清空集合
			clearContent();

			//获得关联数据长度，确定生成表单长度
			var size = contents.length;
			var otest = document.getElementById("container");

			//判断为空
			if (size == 0) {
				var newnode = document.createElement("li");
				var code = "不存在书籍";
				newnode.innerHTML = code;
				otest.appendChild(newnode);
			}
			//设置内容
			for ( var i = 0; i < size; i++) {
				var nextNode = contents[i];//代表的是json格式的第i个元素
				var name = nextNode.bookname;
				var publisher = nextNode.publisher;
				var author = nextNode.author;
				var bookno = nextNode.bookno;
				
				var newnode = document.createElement("li");
				//newnode.innerHTML = nextNode;
				newnode.setAttribute("style", "height:7%;");
				var url = "/library/show_singleItem.action?bookno=" + bookno + "&weid=" + "<%=request.getSession().getAttribute("weid")%>";
				newnode.setAttribute("onclick",
						"window.location.href='" + url + "';");
				
				var code = " <span>" + name + "</span><br>";
				code = code + "<span style='float:right;'>" + publisher
						+ "&nbsp;</span>";
				code = code + "<span style='float:left;'>" + author
						+ "&nbsp;</span>"
				newnode.innerHTML = code;
				otest.appendChild(newnode);

			}
		}

		//清空之前的数据
		function clearContent() {
			var contentTableBody = document.getElementById("container");
			var size = contentTableBody.childNodes.length;//获得子节点的长度
			for ( var i = size - 1; i >= 0; i--) {
				contentTableBody.removeChild(contentTableBody.childNodes[i]);//获取子节点并清空
			}
			//document.getElementById("popDiv").style.border = "none";//清空边框
		}
	</script>
</body>
</html>
