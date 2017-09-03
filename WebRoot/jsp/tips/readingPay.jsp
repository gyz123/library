<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>付费提示</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">

<script src="js/zepto.min.js"></script>
</head>
  
<body ontouchstart style="background-color: #ffffff;">
    
     <div class="weui-header bg-blue" style="height:56px;background-color:#01164b">
		<div class="weui-header-left" style="margin-top:6px;">
			<a class="icon icon-109 f-white" 
				href="/library/show_singleItem.action?weid=${weid }&bookno=${bookno}">&nbsp;&nbsp;&nbsp;</a>
		</div>
		<h1 class="weui-header-title" style="margin-top:16px">
			<span class="f20">在线阅读</span>
		</h1>
	</div>
    
    <div class="weui_cell_bd" style="width:100%;text-align:center;margin-top:40%">
			<p>
				<i class="icon icon-40 f20 f-green"></i>付费后才能继续阅读哦~
			</p>
			<p>
				点击这里<a href="/library/payEbook.action?bookno=${bookno }&weid=${weid }">快速支付</a>
			</p>
			<br/>
			<p>
				若已支付，点此进入<a href="/library/enterEbook.action?weid=${weid }">我的电子书</a>
			</p>
			
		</div>


  </body>
</html>
