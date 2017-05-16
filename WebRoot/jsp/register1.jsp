<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="po.UserDetailInfo" %>
<%@ page import="util.SQLUtil" %>
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>用户注册界面</title>

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

<script type="text/javascript">
	
	var wait = 60; //倒计时时间

	function time(obj) {  
        if (wait == 0) {  
            obj.href = "javascript:getVeriCode();";
            obj.className = "weui-vcode-btn";            
            obj.innerHTML="获取验证码";  
            wait = 60;
        } else {  
            obj.className = "weui_btn weui_btn_disabled weui_btn_default";  
            obj.href = "javascript:void(0);";//禁用超链接
            obj.innerHTML="重新发送(" + wait + ")";  
            wait--;  
            setTimeout(function() {  
                time(obj);  
            },  
            1000);
        }  
    }  

	function getVeriCode(){
		var getCode = document.getElementById("getCode");
		
		var weID = document.getElementById("weID").value;
		var name = document.getElementById("name").value;
		var IDNumber = document.getElementById("IDNumber").value;
		var tel = document.getElementById("tel").value;
		var veriCode = document.getElementById("veriCode").value;
		
		if( weID == "" || tel == "" || tel.match(/^1\d{10}$/) == null){
			alert("请正确填写手机号");
		}else{
		
			time(getCode);
			
			var request = new XMLHttpRequest();//创建XHR对象
			request.open("POST", "/library/getVeriCode.action");//post方式发送，默认异步
			var data = "weID=" + document.getElementById("weID").value 
						+ "&tel=" + document.getElementById("tel").value;//获取数据
			request.setRequestHeader("Content-type","application/x-www-form-urlencoded");
			
			request.send(data);
			request.onreadystatechange = function()
			{
				if(request.readyState===4)//表示请求已经完成
				{
					if(request.status===200)//用户请求被正确接收
					{ 
						//alert(request.responseText); 
						alert("验证码已发送，请注意查收");
						//获取响应的报文，使用innerHTML向searchResult中插入,通过上边判断请求成功之后，在html中显示提示
					} 
					else
				 	{
						alert("发生错误：" + request.status);
					}
				} 
			};	
		}
	}

	function reg(){
	
		var weID = document.getElementById("weID").value;
		var name = document.getElementById("name").value;
		var IDNumber = document.getElementById("IDNumber").value;
		var tel = document.getElementById("tel").value;
		var veriCode = document.getElementById("veriCode").value;

		var judge = document.getElementsByName("box");
		
		if (weID == "" || name == "" || IDNumber == "" || tel == ""
				|| veriCode == "") {
			alert("请填写完整信息");
			return;
		}
		
		if (judge[0].checked != true) {
			alert("请同意条款");
			return;
		}
	
		var request = new XMLHttpRequest();//创建XHR对象
		request.open("POST", "/library/completeReg.action");//post方式发送，默认异步
		var data = "weID=" + weID + "&name=" + name + "&IDNumber=" + IDNumber
				+ "&tel=" + tel + "&veriCode=" + veriCode;//获取数据
		request.setRequestHeader("Content-type",
				"application/x-www-form-urlencoded");
		request.send(data);
		request.onreadystatechange = function() {
			if (request.readyState === 4)//表示请求已经完成
			{
				if (request.status === 200)//用户请求被正确接收
				{
				//由于是异步操作，所以只能在这里设置页面的跳转；在action的方法中配置了无效
					//alert(request.responseText);
					//location.href = "http://localhost:8080/library/regSuccess.action";
					location.href = "http://www.iotesta.cn/library/regSuccess.action";
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

</head>

<body ontouchstart style="background-color: #f8f8f8;">
	<div class="weui_cells_title">
		<h3>用户注册</h3>
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
				<input class="weui_input" type="text" placeholder="请输入姓名" id="name" style="width:85%;"/>
			</div>
		</div>

		<div class="weui_cell">
			<div class="weui_cell_hd">
				<label class="weui_label">身份证</label>
			</div>
			<div class="weui_cell_bd weui_cell_primary">
				<input class="weui_input" style="width:85%;" type="text"
					placeholder="请输入身份证号" id="IDNumber" onKeyUp="judgeID();"
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
					pattern="[0-9]*{11}" placeholder="请输入手机号" id="tel"
					onKeyUp="judgeTel();"  />
				<i class="weui_icon_success_circle" id="telSuccess" style="display:none;"></i> 
				<i class="weui_icon_cancel" id="telCancel" style="display:none;"></i>

			</div>

		</div>

		<div class="weui_cell weui_vcode">
			<div class="weui_cell_hd">
				<label class="weui_label">验证码</label>
			</div>
			<div class="weui_cell_bd weui_cell_primary">
				<input class="weui_input" type="number" placeholder="请输入验证码"
					id="veriCode" style="width:80%;" />
			</div>
			<div class="weui_cell_ft">
				<a href="javascript:getVeriCode();" class="weui-vcode-btn"
					id="getCode">获取验证码</a>
			</div>
		</div>

		<label for="weuiAgree" class="weui-agree"> <input
			id="weuiAgree" class="weui-agree-checkbox" type="checkbox" name="box">
			<span class="weui-agree-text"> 阅读并同意<a
				href="javascript:void(0);">《相关条款》</a> </span> </label>

		<div class="weui_cells_tips">请遵守图书借阅行为规范</div>

		<div class="weui_btn_area">
			<a class="weui_btn weui_btn_primary" href="javascript:reg();"
				id="submit">确定</a>
		</div>
		
	</div>

</body>
</html>
