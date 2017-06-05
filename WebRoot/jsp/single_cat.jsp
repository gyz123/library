<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>单类书籍</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">
<script src="js/zepto.min.js"></script>
      <script>
  $(function(){
 
 $('.weui-comment-icon').click(function(){
 if($(this).parent().hasClass('checked')){
 $(this).parent().removeClass('checked');
 var  val = $(this).next().html();
  $(this).next().html(parseInt(val)-1);
 }else{
 $(this).parent().addClass('checked');
  var  val = $(this).next().html();
  $(this).next().html(parseInt(val)+1);
 }
 });
	  
	  });    
      
      </script>



</head>

<body ontouchstart style="background-color: #f8f8f8;">
	<%-- 
	category:<%=request.getParameter("id") %><br/>
	pageNum:<%=request.getParameter("pagenum") %><br/>  
	EL:${booklist[0].bookname }<br/>  --%>
	<%-- 使用EL和S标签均可以从列表中获取到数据，
			如：${booklist[0].bookname} 
			和   <s:property value="#booklist[3].bookname"/>
		如果是对列表进行操作，必须加#号；普通参数可以不加 --%>
	
	<a href="/library/back_to_main.action?weid=${weid }">
	<div class="weui-header bg-blue" style="height:56px;background-color:#01164b">
		<div class="weui-header-left">
		</div>
		<h1 class="weui-header-title" style="margin-top:5px">
			<span class="">超新星智能图书馆</span>
		</h1>
	</div>
	</a>
	
	<div class="weui_cells_title" style="margin-top:2%">
		<div><span class="f10">当前类别 > ${cat }</span></div>
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
				<span class="f14">剩余量：${booklist.leftNum}</span></div>
			</div>
		</a> 
		</c:forEach>
	</div>

	<div class='pager'>
		<div class="pager-left">
			<div class="pager-first">
				<a class="pager-nav" 
					href="/library/show_singleCat.action?id=${catid }&pagenum=1&weid=${weid }">
				首页
				</a>
			</div>
			<div class="pager-pre">
				<a class="pager-nav" 
					href="/library/show_singleCat.action?id=${catid }&pagenum=${pagenum-1 }&weid=${weid }">
				上一页
				</a>
			</div>
		</div>
		<div class="pager-cen">${pagenum }/120</div>
		<div class="pager-right">
			<div class="pager-next">
				<a class="pager-nav" 
					href="/library/show_singleCat.action?id=${catid }&pagenum=${pagenum+1 }&weid=${weid }">
				下一页
				</a>
			</div>
			<div class="pager-end">
				<a class="pager-nav" href="">尾页</a>
			</div>
		</div>
	</div>
	
</body>
</html>
