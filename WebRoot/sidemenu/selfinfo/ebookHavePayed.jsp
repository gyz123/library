<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>《${bookname }》</title>

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
				href="/library/enterEbook.action?weid=${weid }">&nbsp;&nbsp;&nbsp;</a>
		</div>
		<h1 class="weui-header-title" style="margin-top:16px">
			<span class="f20">在线阅读</span>
		</h1>
	</div>

  <!--页面开始-->
	<div class="weui-weixin">
		<div class="weui-weixin-ui">
			<!--页面开始-->
			<div class="weui-weixin-page">
				<h2 class="weui-weixin-title">第${pagenum}章</h2>

				<div class="weui-weixin-content">
					<!--内容-->
					<c:forEach var="contentlist" items="${contentlist}">
						<p>${contentlist}</p>
					</c:forEach>
				</div>
				<!--内容结束-->
			</div>
			<!--页面结束-->
		</div>
	</div>


	<div class='pager' style="position:fixed;bottom:0;left:0;right:0">
		<div class="pager-left">
			<div class="pager-first">
				<a class="pager-nav" 
					href="/library/startReading.action?bookno=${bookno }&weid=${weid }&chapter=1">
				首章
				</a>
			</div>
			<div class="pager-pre">
				<a class="pager-nav" 
					href="/library/startReading.action?bookno=${bookno }&chapter=${pagenum-1 }&weid=${weid }">
				上一章
				</a>
			</div>
		</div>
		<div class="pager-cen" style="backgroud-color:#ffffff">
			${pagenum}
		</div>
		<div class="pager-right">
			<div class="pager-next">
				<a class="pager-nav" 
					href="/library/startReading.action?bookno=${bookno }&chapter=${pagenum+1 }&weid=${weid }">
				下一章
				</a>
			</div>
			<div class="pager-end">
				<a class="pager-nav" 
					href="/library/startReading.action?bookno=${bookno }&weid=${weid }&chapter=35">
				终章
				</a>
			</div>
		</div>
	</div>



  </body>
  
</html>
