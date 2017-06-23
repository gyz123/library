<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
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
<script src="js/jquery-1.11.3.js"></script>
</head>
  
<body ontouchstart style="background-color: #ffffff;">

	<div class="weui-header bg-blue" style="height:56px;background-color:#01164b">
		<div class="weui-header-left" style="margin-top:6px;">
			<a class="icon icon-109 f-white" 
				href="/library/show_singleItem.action?weid=${weid }&bookno=${bookno}">&nbsp;&nbsp;&nbsp;</a>
		</div>
		<h1 class="weui-header-title" style="margin-top:16px">
			<span class="f20">用户评论</span>
		</h1>
	</div>

	<%-- 
	<div class="weui_cell">
		<div class="weui_cell_bd weui_cell_primary" style="width:100%;text-align:center; margin-top:8px">
			<span class="f24" >《${bookname }》</span>
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_bd weui_cell_primary" style="width:100%;text-align:center; margin-top:0px">
			<span class="f16" >评分: ${score}
		</div>
	</div>
	--%>
	
	<c:if var="flag" test="${commentlist[0].bookno == null }" scope="page"> 
		<div class="weui_cell_bd" style="width:100%;text-align:center;margin-top:48px">
			<p><i class="icon icon-40 f20 f-green"></i>现在还没有人评论</p>
		</div>
	</c:if>

	<c:if var="flag" test="${commentlist[0].bookno != null }" scope="page"> 
	<ul class="weui-comment" style="margin-left:18px; margin-right:18px; margin-top:8px">
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
			<div class="weui-comment-msg"  style="margin-top:10px; margin-left:16px">
				<span class="status f15 f-black"> ${co.comment }</span>
			</div>
			<div style="margin-top:10px; margin-bottom:4px; margin-left:16px">
				<p class="time">${co.time }</p>
			</div>
		</li>
		<div style="height:2px; width:100%"></div>
		<hr style="width:100%">
	</c:forEach>
	</ul>
	<div style="width:100%;height:44px"></div>
	</c:if>

	<div class="weui_panel" style="position:fixed;bottom:0px;width:100%;background-color:#f6f6f6">
		<div class="weui_panel_bd">
			<div class="weui_media_box weui_media_small_appmsg">
				<div class="weui_cells weui_cells_access" id="remark"
						style="margin-top:4px;padding-bottom:4px;background-color:#f6f6f6">
					<a href="javascript:;" class="weui_cell" onclick="selectmenu('1');">
						<div class="weui_cells_bd weui_cell_primary" style="text-align:center">
							<p><span class="f18">我要评论</span></p>
						</div> 
					</a>
				</div>
			</div>
		</div>
		<%-- 折叠项 --%>
		<div style="display: none;" id="menu_1">
			<div style="position:fixed;bottom:2px;width:100%">
				<!-- <div class="weui_cells_title" style="background-color:#f9f9f9;height:20px;padding-top:8px;margin-bottom:0px">
						<span class="f15">评论</span>
					</div>       
				-->
				<div class="weui_cells weui_cells_form" style="margin-top:2px">
					<div class="weui_cell">
						<div class="weui_cell_bd weui_cell_primary">
							<textarea id="textarea" class="weui_textarea"
								placeholder="说点什么吧..." rows="3"></textarea>
							<div class="weui_textarea_counter">
								<span id='count'>0</span>/<span id='count_max'>140</span>
							</div>
						</div>
					</div>
				</div>
				<div style="margin-top:0px;margin-bottom:0px;background-color:#ffffff">
					<div style="position:relative;left:218px">
						<a href="javascript:;" onclick="selectmenu('1');"
							class="weui_btn weui_btn_mini weui_btn_default"
							style="width:60px;height:28px;margin-right:8px">取消</a> 
						<a id="writecomment"  href="javascript:;"
							class="weui_btn weui_btn_mini weui_btn_primary" style="width:60px;height:28px">
							发表</a>
					</div>
				</div>
			</div>
		</div>
	</div>
    
	<script>
		$(function() {
			var max = $('#count_max').text();
			$('#textarea').on(
					'input',
					function() {
						var text = $(this).val();
						var len = text.length;
						$('#count').text(len);
						if (len > max) {
							$(this).closest('.weui_cell').addClass(
									'weui_cell_warn');
						} else {
							$(this).closest('.weui_cell').removeClass(
									'weui_cell_warn');
						}
					});
		})
	</script>

<script type="text/javascript">
function selectmenu(n){
	var eleMore = document.getElementById("menu_"+n);
	var test = document.getElementById("remark");

	if(eleMore.style.display=="none"){
		eleMore.style.display = 'block';
		test.style.display = 'none';
		$("#cell_"+n).removeClass("icon-74");
		$("#cell_"+n).addClass("icon-35 ");
	}
	else{
		eleMore.style.display = 'none';
		test.style.display = 'block';
		$("#cell_"+n).removeClass("icon-35");
		$("#cell_"+n).addClass("icon-74");
	}
}
</script> 

<script>
  $(function(){
	  $('.js-category').click(function(){
			$parent = $(this).parent('li');
		   if($parent.hasClass('js-show')){
                        $parent.removeClass('js-show');
                        $(this).children('i').removeClass('icon-35').addClass('icon-74');
                    }else{
                        $parent.siblings().removeClass('js-show');
                        $parent.addClass('js-show');
                        $(this).children('i').removeClass('icon-74').addClass('icon-35');
                         $parent.siblings().find('i').removeClass('icon-35').addClass('icon-74');
                    }
		  });
	  
	  });    
      
      </script>
      
<script>
$(document).ready(function(){
		$("#writecomment").click(function() {
			console.log("点击了");
			var text = $("#textarea").val();
			$.ajax({
				type : 'post',
				url : '/library/handle_comment.action', 
				data : {
					comment : text,
					weid : "<%=request.getSession().getAttribute("weid")%>" ,
					bookno : "<%=request.getSession().getAttribute("commentbookno")%>"
				}, //参数 
				cache : false,
				dataType : 'json',
				success : function(data) {
					console.log("回调成功");
					location.reload();
				},
				error : function() {
					console.log("回调失败");
					location.reload();
				}
	
			});
		});
	});
</script>

</body>
</html>
