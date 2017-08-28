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
			<span class="f20">我的预定</span>
		</h1>
	</div>
	
	
	<div class="weui_cells " >
		<c:forEach  var="booklist" items="${booklist}">
			<div class="weui_cell">
				<div class="weui_cell_hd">
					<img src="${booklist.bookimg}" alt=""
						style="width:64px;display:block;margin-right:24px">
				</div>
				<div class="weui_cell_bd weui_cell_primary">
					<div style="margin-top:6px">
					<span class="f24">${booklist.bookname}</span> 
					</div>
					<div style="margin-top:20px">
						<span class="f14">取书时间：${booklist.time}</span>
						<div style="margin-top:8px">
							<span class="f14" >状态：${booklist.status}</span>
						</div>
						
						<c:if var="flag" test="${booklist.flag == 0 }" scope="page">
							<div style="float:right;margin-right:12px">
								<a id="showToast" href="/library/cancel_order.action?weid=${weid }&bookno=${booklist.bookno }">
									<span class="f15 f-blue">取消预定</span>
								</a>
							</div>
						</c:if>
						<c:if var="flag" test="${booklist.flag > 0 }" scope="page">
							<div style="float:right;margin-right:12px">
								<span class="f15 f-gray">取消预定</span>
							</div>
						</c:if>
						
					</div>
				</div> 
			</div>
		</c:forEach>
	</div>
	
	<script>
	$(document).on("click", "#showToast", function() {
        $.toast("取消预定成功");
      }); 
		
	</script>

  </body>
</html>
