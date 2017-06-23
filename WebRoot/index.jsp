<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>侧边导航栏</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">

<style type="text/css">
	
</style>

</head>

<body ontouchstart style="background-color: #f8f8f8;">

	<div>
		<img src="image/picture.jpg" class="weui-avatar-url"
			style="height:75px; width:75px; margin:70px 15px 10px 25px; ">
		<p style="display:inline-block; ">
			<font size="8px">qxk</font>
		</p>
	</div>
	<hr align="center">

	<a class="weui_cell" href="/library/show_show_bookshelf.action?${weid }">
		<div class="weui_cell_hd" style="margin: 7px 0;">
			<img
				src=""
				alt="" style="width:25px; margin-left:25px; margin-right:40px; display:block">
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<p><span class="f25 f-black">我的书架</span></p>
		</div> <span class="weui_cell_ft"></span>
    </a>
    
    <a class="weui_cell" href="">
		<div class="weui_cell_hd" style="margin: 7px 0;">
			<img
				src=""
				alt="" style="width:25px; margin-left:25px; margin-right:40px; display:block">
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<p><span class="f25 f-black">借书历史</span></p>
		</div> <span class="weui_cell_ft"></span>
    </a>
    
    <a class="weui_cell" href="">
		<div class="weui_cell_hd" style="margin: 7px 0;">
			<img
				src=""
				alt="" style="width:25px; margin-left:25px; margin-right:40px; display:block">
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<p><span class="f25 f-black">当前借阅</span></p>
		</div> <span class="weui_cell_ft"></span>
    </a>
    
    <a class="weui_cell" href="">
		<div class="weui_cell_hd" style="margin: 7px 0;">
			<img
				src=""
				alt="" style="width:25px; margin-left:25px; margin-right:40px; display:block">
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<p><span class="f25 f-black">购物车</span></p>
		</div> <span class="weui_cell_ft"></span>
    </a>
    
    <a class="weui_cell" href="">
		<div class="weui_cell_hd" style="margin: 7px 0;">
			<img
				src=""
				alt="" style="width:25px; margin-left:25px; margin-right:40px; display:block">
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<p><span class="f25 f-black">个人设置</span></p>
		</div> <span class="weui_cell_ft"></span>
    </a>
    

</body>
</html>
