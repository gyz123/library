<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
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
			<span class="f20">历史记录</span>
		</h1>
	</div>
  
     <div class="weui_cells weui_cells_access" >
		<c:forEach  var="booklist" items="${booklist}">
			<c:if var="flag" test="${booklist.whetherComment == 0 }" scope="page">
			<a class="weui_cell"  href="/library/enter_comment.action?bookno=${booklist.bookno }&weid=${weid }">
				<div class="weui_cell_hd">
					<img src="${booklist.bookimg}" alt=""
						style="width:64px;display:block;margin-right:24px">
				</div>
				<div class="weui_cell_bd weui_cell_primary">
					<span class="f24">${booklist.bookname}</span> <br>
					<div style="margin-top:16px">
						<span class="f14">作者：${booklist.author}</span>
						<span style="float:right;margin-right:4px;margin-top:8px"
								class="f16 f-gray" >待评论</span>
					</div>
				</div> 
			</a>
			</c:if>
			
			<c:if var="flag" test="${booklist.whetherComment == 1 }" scope="page">
				<a class="weui_cell"  href="/library/show_singleItem.action?bookno=${booklist.bookno }&weid=${weid }">
				<div class="weui_cell_hd">
					<img src="${booklist.bookimg}" alt=""
						style="width:64px;display:block;margin-right:24px">
				</div>
				<div class="weui_cell_bd weui_cell_primary">
					<span class="f24">${booklist.bookname}</span> <br>
					<div style="margin-top:16px">
						<span class="f14">作者：${booklist.author}</span>
						<span style="float:right;margin-right:4px;margin-top:8px"
								class="f16 f-blue" >已评论</span>
					</div>
				</div> 
				</a>			
			</c:if>
		</c:forEach>
	</div>

  </body>
</html>
