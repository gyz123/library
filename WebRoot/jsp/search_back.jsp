<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>搜索结果</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">
<script src="js/zepto.min.js"></script>
      <script>

$(function() {

	$('.weui-comment-icon')
			.click(
					function() {
						if ($(this)
								.parent()
								.hasClass('checked')) {
							$(this)
									.parent()
									.removeClass(
											'checked');
							var val = $(this)
									.next().html();
							$(this)
												.next()
												.html(
														parseInt(val) - 1);
									} else {
										$(this)
												.parent()
												.addClass(
														'checked');
										var val = $(this)
												.next().html();
										$(this)
												.next()
												.html(
														parseInt(val) + 1);
									}
								});

			});
</script>



</head>

<body ontouchstart style="">
	<a href="/library/show_main.action">
	<div class="weui-header bg-blue" style="height:56px;background-color:#01164b">
		<div class="weui-header-left">
		</div>
		<h1 class="weui-header-title" style="margin-top:5px">
			<span class="">超新星智能图书馆</span>
		</h1>
	</div>
	</a>

	<div class="weui_cells_title">
		<span class="f10">关键词 > ${keyword }</span>
	</div>
	<div class="weui_cells weui_cells_access">
		<c:forEach  var="booklist" items="${booklist }">
			<a class="weui_cell" href="/library/show_singleItem.action?bookno=${booklist.bookno }">
				<div class="weui_cell_hd">
					<img src="${booklist.bookimg}" alt=""
						style="width:72px;margin-right:8px;display:block;margin-right:16px">
				</div>
				<div class="weui_cell_bd weui_cell_primary">
					<div>
						<span class="f24">${booklist.bookname}</span>
					</div>
					<div style="margin-top:16px">
						<span class="f14">${booklist.publisher}</span>
					</div>
					<div style="margin-top:4px">
						<span class="f14">作者：${booklist.author}</span>&nbsp;&nbsp;&nbsp;
						<span class="f14">剩余量：${booklist.leftNum}</span>
					</div>
				</div> 
			</a>
		</c:forEach> 
	</div>
	
	<c:if var="flag" test="${booklist[3].bookno != null }" scope="page">
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
	
	<c:if var="flag" test="${booklist[3].bookno == null }" scope="page">
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
