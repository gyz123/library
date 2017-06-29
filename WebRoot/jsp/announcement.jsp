<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>好书推荐</title>
<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">
</head>
  
  <body style="background-color: #ffffff">
	<div class="weui-header bg-blue" style="height:56px;background-color:#01164b">
		<div class="weui-header-left" style="margin-top:6px;">
			<a class="icon icon-109 f-white" 
				href="/library/back_to_main.action?weid=${weid }">
				&nbsp;&nbsp;&nbsp;
			</a>
		</div>
		<h1 class="weui-header-title" style="margin-top:5px">
			<span class="">超新星智能图书馆</span>
		</h1>
	</div>
	
	<div class="weui_cell" style="margin-top:0px;padding-top:12px;margin-left:12px;margin-bottom:6px">
		<span class="f14 f-gray">来看一看上周阅读量排名前三名的好书吧~</span>
	</div>
		
	<div class="weui_cells weui_cells_access">
		<c:forEach  var="booklist" items="${booklist }">
		<a class="weui_cell" href="/library/show_singleItem.action?bookno=${booklist.bookno }&weid=${weid }">
			<div class="weui_cell_hd" >
				<img
					src="${booklist.bookimg}"
					alt="" style="width:72px;margin-right:8px;display:block;margin-right:16px">
			</div>
			<div class="weui_cell_bd weui_cell_primary">
				<div><span class="f24">${booklist.bookname}</span></div>
				<div style="margin-top:16px"><span class="f14">${booklist.publisher}</span></div>
				<div style="margin-top:4px"><span class="f14">作者：${booklist.author}</span>&nbsp;&nbsp;&nbsp;
			</div>
		</a> 
		</c:forEach>
	</div>

  </body>
</html>
