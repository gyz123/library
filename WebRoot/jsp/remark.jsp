<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>评论</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">

<script src="js/zepto.min.js"></script>
</head>
  
<body ontouchstart style="background-color: #ffffff;">
<div class="weui_cell">
		<div class="weui_cell_bd weui_cell_primary" style="margin-left:36px; margin-top:16px">
			<span class="f24" >《${bookname }》</span>
			<span class="f16" style="margin-left:18%">评分: ${score}
		</div>
	</div>


	<ul class="weui-comment" style="margin-left:18px; margin-right:18px; margin-top:16px">
    <c:forEach var="co" items="${commentlist }">
		<li class="weui-comment-item">
			<div class="weui-comment-li">
				<span class="check"> <i class="weui-comment-icon"></i> <span
					class="weui-comment-num">${co.goodnum }</span> </span>
			</div>
			<div class="userinfo" style="margin-left:0px">
				<strong class="nickname f20" style="margin-left:14px">${co.wename }</strong> 
				<img class="avatar" style="width:48px; height:48px" src="${co.weimg }">
			</div>
			<div class="weui-comment-msg"  style="margin-top:8px; margin-left:16px">
				<span class="status f12 f-black"> ${co.comment }</span>
			</div>
			<div style="margin-top:8px; margin-bottom:4px; margin-left:16px">
				<p class="time">${co.time }</p>
			</div>
		</li>
		<div style="height:2px; width:100%"></div>
		<hr style="width:100%">
	</c:forEach>
	</ul>
</body>
</html>
