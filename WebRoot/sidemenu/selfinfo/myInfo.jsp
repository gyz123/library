<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="po.user.UserDetailInfo" %>
<%@ page import="util.sql.SQLUtil" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
	<title>个人中心</title>

	<link rel="stylesheet" href="css/weui.css" />
	<link rel="stylesheet" href="css/weui2.css" />
	<link rel="stylesheet" href="css/weui3.css" />
	<link rel="stylesheet" type="text/css" href="css/weuix.min.css">
	
<style type="text/css">
.weui_cell_bd weui_cell_primary p {
	weight: 30px;
}

.weixinID {
	float: left;
}
</style>
	
	<script src="js/zepto.min.js"></script>

  </head>
  
  <body ontouchstart style="background-color: #ffffff;">
  	<div class="weui-header bg-blue" style="height:56px;background-color:#01164b">
		<div class="weui-header-left" style="margin-top:6px;">
			<a class="icon icon-109 f-white" 
				href="/library/show_mylibrary.action?weid=${weid }">&nbsp;&nbsp;&nbsp;</a>
		</div>
		<h1 class="weui-header-title" style="margin-top:16px">
			<span class="f20">资料编辑</span>
		</h1>
	</div>
	
	<div class="weui_cells weui_cells_form">
		<div class="weui_cell">
			<div class="weui_cell_hd">
				<label class="weui_label">微信ID</label>
			</div>
			<div class="weui_cell_bd weui_cell_primary">
				<input class="weui_input" type="text" value="${user.openid }" 
				 id="weID" readonly="readonly" />
			</div>
		</div>
	
		<div class="weui_cell">
			<div class="weui_cell_hd">
				<label class="weui_label">姓名</label>
			</div>
			<div class="weui_cell_bd weui_cell_primary">
				<input class="weui_input" type="text" value="${user.realName }" id="name" style="width:85%;"/>
			</div>
		</div>

		<div class="weui_cell">
			<div class="weui_cell_hd">
				<label class="weui_label">身份证</label>
			</div>
			<div class="weui_cell_bd weui_cell_primary">
				<input class="weui_input" style="width:85%;" type="text"
					value="${user.idCard }" id="IDNumber" onKeyUp="judgeID();"
					maxlength="18" />
				<i class="weui_icon_success_circle" id="IDSuccess" style="display:none;"></i> 
				<i class="weui_icon_cancel" id="IDCancel" style="display:none;"></i>
			</div>
		</div>

		<div class="weui_cell">
			<div class="weui_cell_hd">
				<label class="weui_label">手机号</label>
			</div>
			<div class="weui_cell_bd weui_cell_primary">
				<input class="weui_input" style="width:85%;" type="number"
					pattern="[0-9]*{11}" value="${user.tel }" id="tel"
					onKeyUp="judgeTel();"  />
				<i class="weui_icon_success_circle" id="telSuccess" style="display:none;"></i> 
				<i class="weui_icon_cancel" id="telCancel" style="display:none;"></i>

			</div>

		</div>

		<div class="weui_btn_area">
			<a class="weui_btn weui_btn_primary" href="javascript:reg();"
				id="submit">确认修改</a>
		</div>
	</div>
	<script>
	$(document).on("click", "#submit", function() {
        $.toast("修改成功");
      }); 
		
	</script>
	
	<script type="text/javascript">
	
	var wait = 60; //倒计时时间

	var veriCode_back;
	

	function reg(){
	
		var weID = document.getElementById("weID").value;
		var name = document.getElementById("name").value;
		var IDNumber = document.getElementById("IDNumber").value;
		var tel = document.getElementById("tel").value;

		var judge = document.getElementsByName("box");
		
		if (weID == "" || name == "" || IDNumber == "" || tel == "") {
			alert("请填写完整信息");
			return;
		}
	
		var request = new XMLHttpRequest();//创建XHR对象
		request.open("POST", "/library/confirm_modify.action");//post方式发送，默认异步
		var data = "weID=" + weID + "&name=" + name + "&IDNumber=" + IDNumber
				+ "&tel=" + tel ;//获取数据
		request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		request.send(data);
		request.onreadystatechange = function() {
			if (request.readyState === 4)//表示请求已经完成
			{
				if (request.status === 200)//用户请求被正确接收
				{
				//由于是异步操作，所以只能在这里设置页面的跳转；在action的方法中配置了无效
					//alert(request.responseText);
					location.href = "/library/show_mylibrary.action?weid=" + weID;
					//获取响应的报文，使用innerHTML向searchResult中插入,通过上边判断请求成功之后，在html中显示提示
				} else {
					alert("发生错误：" + request.status);
				}
			}
		};

	}

	function judgeID() {
		var tel = document.getElementById("IDNumber").value;
		var success = document.getElementById("IDSuccess");
		var cancel = document.getElementById("IDCancel");
		if (tel.match(/^\d{17}(\d|X)$/) == null) {
			success.style.display = "none";
			cancel.style.display = "inline";
			//alert("不符合要求");
		} else {
			success.style.display = "inline";
			cancel.style.display = "none";
			//alert("符合要求");
		}
	}

	function judgeTel() {
		var tel = document.getElementById("tel").value;
		var success = document.getElementById("telSuccess");
		var cancel = document.getElementById("telCancel");
		if (tel.match(/^1\d{10}$/) == null) {
			success.style.display = "none";
			cancel.style.display = "inline";
			//alert("不符合要求");
		} else {
			success.style.display = "inline";
			cancel.style.display = "none";
			//alert("符合要求");
		}
	}
</script>
  </body>
</html>
