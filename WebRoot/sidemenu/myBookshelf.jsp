<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>我的收藏</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">

<style type="text/css">
</style>
</head>

<body ontouchstart style="background-color: #f8f8f8;">
	<div class="weui_cells weui_cells_access">
		<c:forEach  var="booklist" items="${booklist}">
			<a class="weui_cell" href="/library/show_singleItem.action?bookno=${booklist.bookno }&weid=${weid }">
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
	
	<c:if var="flag" test="${booklist[7].bookno != null }" scope="page">
	<div class='pager'>
		<div class="pager-left">
			<div class="pager-first">
				<a class="pager-nav" href="">首页</a>
			</div>
			<div class="pager-pre">
				<a class="pager-nav" href="">上一页</a>
			</div>
		</div>
		<div class="pager-cen" >${pagenum }/1</div>
		<div class="pager-right">
			<div class="pager-next">
				<a class="pager-nav" href="">下一页</a>
			</div>
			<div class="pager-end">
				<a class="pager-nav" href="">尾页</a>
			</div>
		</div>
	</div>
	</c:if>

	<c:if var="flag" test="${booklist[7].bookno == null }" scope="page">
	<div class='pager' style="position:fixed;bottom:0;width:100%">
		<div class="pager-left">
			<div class="pager-first">
				<a class="pager-nav" href="">首页</a>
			</div>
			<div class="pager-pre">
				<a class="pager-nav" href="">上一页</a>
			</div>
		</div>
		<div class="pager-cen" >${pagenum }/1</div>
		<div class="pager-right">
			<div class="pager-next">
				<a class="pager-nav" href="">下一页</a>
			</div>
			<div class="pager-end">
				<a class="pager-nav" href="">尾页</a>
			</div>
		</div>
	</div>
	</c:if>
	
</body>
</html>
