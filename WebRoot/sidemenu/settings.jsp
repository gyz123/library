<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>个人设置</title>
<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">

<script src="js/zepto.min.js"></script>
<script src="js/picker.js"></script>
<script >
	$(function() {
		$("#time1").picker({
			title : "选择时间",
			cols : [ 
			{
				textAlign : 'center',
				values : (function() {
					var arr = [];
					arr.push('上午','下午');
					return arr;
				})()
			},
			{
				textAlign : 'center',
				values : (function() {
					var arr = [];
					for ( var i = 0; i <= 11; i++) {
						arr.push(i < 10 ? '0' + i : i);
					}
					return arr;
				})()

			},
			{
				textAlign : 'center',
				values : ':',
			},
			{
				textAlign : 'center',
				values : (function() {
					var arr = [];
					for ( var i = 0; i <= 59; i++) {
						arr.push(i < 10 ? '0' + i : i);
					}
					return arr;
				})(),
			} ]
		});
	});
</script>

<script >
	$(function() {
		$("#time2").picker({
			title : "选择时间",
			cols : [ 
			{
				textAlign : 'center',
				values : (function() {
					var arr = [];
					arr.push('上午','下午');
					return arr;
				})()
			},
			{
				textAlign : 'center',
				values : (function() {
					var arr = [];
					for ( var i = 0; i <= 11; i++) {
						arr.push(i < 10 ? '0' + i : i);
					}
					return arr;
				})()

			},
			{
				textAlign : 'center',
				values : ':',
			},
			{
				textAlign : 'center',
				values : (function() {
					var arr = [];
					for ( var i = 0; i <= 59; i++) {
						arr.push(i < 10 ? '0' + i : i);
					}
					return arr;
				})(),
			} ]
		});
	});
</script>

<script >
	$(function() {
		$("#time3").picker({
			title : "选择频率",
			cols : [ 
			{
				textAlign : 'center',
				values : (function() {
					var arr = [];
					arr.push('每天一次','三天一次','一周一次','两周一次','一月一次','从不');
					return arr;
				})(),
			} ]
		});
	});
</script>

</head>
  
 <body style="background-color:#f9f9f9">
   
  	<div class="weui_cells" style="margin-top:0px">
		<div class="weui-header-left" style="height:36px;padding-top:18px;padding-left:12px">
			<a class="icon icon-109 f-black" 
			href="/library/back_to_main.action?weid=<%=request.getSession().getAttribute("weid") %>">&nbsp;&nbsp;</a> 
			<span class="f18">推送设置</span>  
		</div>
	</div>
	
	<%-- 免打扰 --%>
	<div class="weui_cells" style="margin-top:0px">
		<div class="weui_cell weui_cell_switch">
			<div class="weui_cell_hd weui_cell_primary">
				<div class="weui_media_bd">
                    <div style="margin-top:6px"><span class="weui_media_title f18">免打扰</span></div>
                    <div style="margin-top:8px;margin-bottom:6px"><span class="f13 f-gray">开启后将在设定时间内不接受推送消息</span></div>
                </div>
			</div>
			<div class="weui_cell_ft">
				<input class="weui_switch" type="checkbox" checked />
			</div>
		</div>
	</div>
	<div class="weui_cell" style="margin-top:0px;background-color:#ffffff;height:32px">
        <div class="weui_cell_hd"><label for="" class="weui_label">开始时间</label></div>
        <div class="weui_cell_bd weui_cell_primary" style="margin-left:38%;">
            <span class="f18 f-gray"><input class="weui_input" type="text" value="上午 00 : 00" id='time1'/></span>
        </div>
    </div>  
	<div class="weui_cell" style="margin-top:0px;background-color:#ffffff;height:32px">
        <div class="weui_cell_hd"><label for="" class="weui_label">结束时间</label></div>
        <div class="weui_cell_bd weui_cell_primary" style="margin-left:38%;">
            <span class="f18 f-gray"><input class="weui_input" type="text" value="上午 00 : 00" id='time2'/></span>
        </div>
    </div> 
    <div class="weui_cell" style="margin-top:0px;background-color:#ffffff;height:32px">
        <div class="weui_cell_hd"><label for="" class="weui_label">推荐频率</label></div>
        <div class="weui_cell_bd weui_cell_primary" style="margin-left:45%;">
            <span class="f18 f-gray"><input class="weui_input" type="text" value="每天一次" id='time3'/></span>
        </div>
    </div> 
	
	
	<%-- 提醒方式 --%>
	<div class="weui_cell_hd" style="margin-top:24px;margin-left:12px;margin-bottom:6px">
		<span class="f14 f-gray">提醒方式</span>
	</div>
	<div class="weui_cells weui_cells_form" style="margin-top:0px">
		<div class="weui_cell weui_cell_switch" style="height:40px">
			<div class="weui_cell_hd weui_cell_primary">声音提示</div>
			<div class="weui_cell_ft">
				<input class="weui_switch" type="checkbox" checked />
			</div>
		</div>
		<div class="weui_cell weui_cell_switch" style="height:40px">
			<div class="weui_cell_hd weui_cell_primary">震动提示</div>
			<div class="weui_cell_ft">
				<input class="weui_switch" type="checkbox" checked />
			</div>
		</div>
	</div>
	
	
	<%-- 推送内容--%>
	<div class="weui_cell_hd" style="margin-top:24px;margin-left:12px;margin-bottom:6px">
		<span class="f14 f-gray">推送内容</span>
	</div>
	<div class="weui_cells weui_cells_form" style="margin-top:0px">
		<div class="weui_cell weui_cell_switch" style="height:40px">
			<div class="weui_cell_hd weui_cell_primary">兴趣书籍</div>
			<div class="weui_cell_ft">
				<input class="weui_switch" type="checkbox" checked />
			</div>
		</div>
		<div class="weui_cell weui_cell_switch" style="height:40px">
			<div class="weui_cell_hd weui_cell_primary">精选好书</div>
			<div class="weui_cell_ft">
				<input class="weui_switch" type="checkbox" checked />
			</div>
		</div>
		<div class="weui_cell weui_cell_switch" style="height:40px">
			<div class="weui_cell_hd weui_cell_primary">系统通知</div>
			<div class="weui_cell_ft">
				<input class="weui_switch" type="checkbox" checked />
			</div>
		</div>
		<div class="weui_cell weui_cell_switch" style="height:40px">
			<div class="weui_cell_hd weui_cell_primary">相关热评</div>
			<div class="weui_cell_ft">
				<input class="weui_switch" type="checkbox" checked />
			</div>
		</div>
	</div>
	
</body>
</html>
