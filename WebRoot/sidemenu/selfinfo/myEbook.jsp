<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

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

<script src="js/zepto.min.js"></script>
</head>
  
<body ontouchstart style="background-color: #ffffff;">
    <div class="weui-header bg-blue" style="height:56px;background-color:#01164b">
		<div class="weui-header-left" style="margin-top:6px;">
			<a class="icon icon-109 f-white" 
				href="/library/show_mylibrary.action?weid=${weid }">&nbsp;&nbsp;&nbsp;</a>
		</div>
		<h1 class="weui-header-title" style="margin-top:16px">
			<span class="f20">我的电子书</span>
		</h1>
	</div>
	
	
	<div class="weui_cells weui_cells_access" >
		<c:forEach  var="booklist" items="${booklist}">
			<a class="weui_cell" href="/library/startReading.action?bookno=${booklist.bookno }&weid=${weid }&chapter=1">
				<div class="weui_cell_hd">
					<img src="${booklist.bookimg}" alt=""
						style="width:64px;display:block;margin-right:24px">
				</div>
				<div class="weui_cell_bd weui_cell_primary">
					<span class="f24">${booklist.bookname}</span> <br>
					<div style="margin-top:16px">
						<span class="f14">作者：${booklist.author}</span>
					</div>
				</div> 
			</a>
		</c:forEach>
	</div>
	
	
	
  </body>
</html>
