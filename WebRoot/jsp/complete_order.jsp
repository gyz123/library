<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>订单填写</title>
<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">

<script src="js/zepto.min.js"></script>
<script src="js/picker.js"></script>
<script >
$(function(){
$("#time").datetimePicker({title:"选择日期时间",min:'2017-6-25',max:'2017-6-30'});
});
</script>

  </head>
  
  <body style="background-color:#ffffff">
    <div class="weui_cells" style="margin-top:0px">
		<div class="weui-header-left" style="height:36px;padding-top:18px;padding-left:12px">
			<a class="icon icon-109 f-black" 
			href="/library/show_singleItem.action?bookno=${bookno }&weid=<%=request.getSession().getAttribute("weid") %>">&nbsp;&nbsp;</a> 
			<span class="f18">订单填写</span>  
		</div>
	</div>
	
	<div class="weui_cells" style="margin-top:0px;height:16px;background-color:#f9f9f9"></div>
	
	<div class="weui_cells weui_cells_form" style="margin-top:0px">
		<div class="weui_cell">
			<div class="weui_cell_hd">
				<label class="weui_label">微信昵称</label>
			</div>
			<div class="weui_cell_bd weui_cell_primary">
				<input class="weui_input" type="text" value="${user.nickname }" 
				 id="weID" readonly="readonly" />
			</div>
		</div>
		
		<div class="weui_cell">
			<div class="weui_cell_hd">
				<label class="weui_label">真实姓名</label>
			</div>
			<div class="weui_cell_bd weui_cell_primary">
				<input class="weui_input" type="text" value="${user.realName }" 
				 id="weID" readonly="readonly" />
			</div>
		</div>
	
		<div class="weui_cell">
			<div class="weui_cell_hd">
				<label class="weui_label">联系电话</label>
			</div>
			<div class="weui_cell_bd weui_cell_primary">
				<input class="weui_input" type="text" value="${user.tel }" 
				 id="weID" readonly="readonly" />
			</div>
		</div>

		<div class="weui_cell">
			<div class="weui_cell_hd">
				<label class="weui_label">取书时间</label>
			</div>
			<div class="weui_cell_bd weui_cell_primary">
				 <input class="weui_input" type="text" value="" id='time'/>
			</div>
		</div>
	</div>
	
	<div class="weui_btn_area" style="margin-top:36px">
        <a href="/library/order_success.action?bookno=${bookno }&weid=<%=request.getSession().getAttribute("weid") %>" 
        	class="weui_btn weui_btn_primary">确认订单</a>
    </div>
		
  </body>
</html>
