<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
	
	<link rel="stylesheet" href="css/weui.css" />
	<link rel="stylesheet" href="css/weui2.css" />
	<link rel="stylesheet" href="css/weui3.css" />
	<link rel="stylesheet" type="text/css" href="css/weuix.min.css">

	<title>添加成功</title>

	<script type="text/javascript"> 
		var t = 5;
		function show()
		{
			document.getElementById("time").innerHTML = t + "秒后自动跳转页面";

			if(t <= 0)
			{
				window.location.href="/library/back_to_main.action?weid=" + "<%=request.getSession(false).getAttribute("weid") %>";
				//alert("时间到");
			}
			else{
				t--;
			}
			
			setTimeout("show()", 1000);
		}
  		//获取显示秒数的元素，通过定时器来更改秒数。
  		setTimeout("show()", 0);
  	</script>
  </head>
  <body ontouchstart style="background-color: #ffffff;height:90%;">
  	<div class="page-bd">
  		<div class="weui_msg" id="msg1" style="margin-top:10%;">
  			<div class="weui_icon_area"><i class="weui_icon_success weui_icon_msg"></i></div>
  			<div class="weui_text_area">
  				<h2 class="weui_msg_title f-green">已加入待借清单</h2>
  				
  				<p class="weui_msg_desc f11" id="time">5秒后自动跳转</p>
  			</div>
  			<div class="weui_opr_area">
  				<p class="weui_btn_area">
  					<a href="/library/show_shoppingcart.action?weid=${weid }" 
  						class="weui_btn weui_btn_primary">查看清单</a>
  					<a href="/library/back_to_main.action?weid=${weid }" 
  						class="weui_btn weui_btn_default">返回首页</a>
  				</p>
  			</div>
  			<div class="weui_extra_area">

  			</div>
  		</div>

  	</div>
  </body>
  </html>