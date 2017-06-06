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

	<title>添加失败</title>
  </head>

  <body ontouchstart style="background-color: #ffffff;height:90%;">
  	<div class="page-bd">

  		<div class="weui_msg" id="msg1" style="margin-top:10%;">
  			<div class="weui_icon_area"><i class="weui_icon_warn weui_icon_msg"></i></div>
  			<div class="weui_text_area">
  				<h2 class="weui_msg_title f-red">这本书已经在你的清单里啦~</h2>
  			</div>
  			<div class="weui_opr_area">
  				<p class="weui_btn_area">
  					<a href="/library/show_shoppingcart.action?weid=${weid }" 
  						class="weui_btn weui_btn_primary">查看清单</a>
  					<a href="/library/back_to_main.action?weid=${weid }" 
  					class="weui_btn weui_btn_default">返回首页</a>
  				</p>
  			</div>
  			
  		</div>

  	</div>
  </body>
  </html>