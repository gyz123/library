<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>借阅历史</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">

<style type="text/css">
	
</style>

</head>
  
  <body ontouchstart style="background-color: #f8f8f8;">
  
  	<div class="weui_cells_title">
		<span class="f10">我读过的书</span>
	</div>
	<table class="weui-table weui-border-tb">
		<thead>
			<tr>
				<th><span>编号</span>
				</th>
				<th><span>书名</span>
				</th>
				<th>借阅日期</th>
				<th>归还日期</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="booklist" items="${booklist}">
				<tr>
					<td>${booklist.bookno }</td>
					<td>${booklist.bookname }</td>
					<td>${booklist.borrowtime }</td>
					<td>${booklist.returntime }</td>
				</tr>
			</c:forEach>

		</tbody>
	</table>


</body>
</html>
