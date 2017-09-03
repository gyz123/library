<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>我的图书馆</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">

  <script src="js/jquery-3.1.1.min.js"></script>
  <script>
		var $j = jQuery.noConflict(); //自定义一个比较短的快捷方式
  </script>
  <!-- 引入 ECharts 文件 -->
  <!-- <script src="js/echarts.js" charset="utf-8"></script> -->
  <script src="https://cdn.bootcss.com/echarts/3.6.2/echarts.js"></script>
  <!-- 引入 shine 主题 -->
  <!-- <script src="theme/shine.js"></script> -->
  
</head>
<style type="text/css">
  body{
    font-size: 100px;
  }
</style>


  
  <body ontouchstart style="background-color: #ffffff;">
  
  <div class="weui-header bg-blue" style="height:56px;background-color:#01164b">
		<div class="weui-header-left" style="margin-top:6px;">
			<a class="icon icon-109 f-white" 
				href="/library/back_to_main.action?weid=${weid }">&nbsp;&nbsp;&nbsp;</a>
		</div>
		<h1 class="weui-header-title" style="margin-top:16px">
			<span class="f20">个人中心</span>
		</h1>
	</div>
  
  <!-- 用户身份信息  -->
    <div class="weui_cells_title" style="background:#ffffff;margin-bottom:8px">
		<span class="f14" >我的资料</span>
	</div>
  	<hr />
  <div class="weui_panel_bd" style="margin-top:4px; margin-bottom:0px">
    <div class="weui_media_box weui_media_appmsg">
      <div class="weui_media_hd" style="margin-left:24px;margin-right:24px; height:64px">
        <img class="weui_media_appmsg_thumb" style="width:64px;height:64px" 
        		alt="" class="weui-avatar-url"
        		src="${user.headimgurl }" >
      </div>
      <div class="weui_media_bd" style="height:64px; padding-top:12px">
        <h4 class="weui_media_title f22" style="height:30px; padding-top:4px">${user.nickname }</h4>
        <p class="weui_media_desc f16" style="margin-top:4px">真实姓名: ${user.realName }</p>
      </div>
    </div>
  </div>
  
  
  
  
  
  <!-- 功能列表   -->
  <div style="height:12px;width:100%;background-color:#f8f8f8"></div>
   <div class="weui_cells_title" style="background:#ffffff;margin-bottom:8px">
		<span class="f14" >更多功能</span>
	</div>
  	<hr />
  <div class="weui_tab " style="height:80px;" id="tab1">
		<div class="weui_navbar" style="height:80px;background:#ffffff">
			<a class="weui_navbar_item" href="/library/show_bookshelf.action?weid=${weid }">
			<div>
				<img style="margin-top:0px;width:28px;height:28px" 
						src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNTAzNzM4MDc5MzM1IiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwMzYgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjIzNzgiIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iMzYuNDIxODc1IiBoZWlnaHQ9IjM2Ij48ZGVmcz48c3R5bGUgdHlwZT0idGV4dC9jc3MiPjwvc3R5bGU+PC9kZWZzPjxwYXRoIGQ9Ik0xMDMwLjgxMTgyNiAzOTUuOTU0MDg3Yy0xMS4yODYyNjEtMzIuMDExMTMtMzkuNzEzMzkxLTU1LjA1MTEzLTc0LjE5NTQ3OC02MC4xMjY2MDlsLTI0My4yMjIyNjEtMzUuNjM5NjUyLTEwNS42Mjc4MjYtMjE2LjAxOTQ3OGMtMTUuMjcwOTU3LTMxLjI3NjUyMi00OC4yNjE1NjUtNTEuNDg5MzkxLTg0LjA1NzA0My01MS40ODkzOTEtMzUuNzA2NDM1IDAtNjguNjUyNTIyIDIwLjIxMjg3LTgzLjk2OCA1MS40ODkzOTFsLTEwNS42NzIzNDggMjE2LjA0MTczOUw5MC44Njg4NyAzMzUuODk0MjYxYy0zNC41MDQzNDggNC45NjQxNzQtNjIuOTUzNzM5IDI3Ljk4MTkxMy03NC4yNCA2MC4xNzExMy0xMS4yNjQgMzIuNTAwODctMi44NzE2NTIgNjcuODA2NjA5IDIxLjg4MjQzNSA5Mi4xMzc3MzlsMTc4LjUwOTkxMyAxNzUuNjM4MjYxLTQxLjQwNTIxNyAyNDMuMzc4MDg3Yy01LjgxMDA4NyAzMy45MjU1NjUgOS4yODI3ODMgNjguNzE5MzA0IDM4LjU1NTgyNiA4OC42ODczMDQgMjguNjI3NDc4IDE5LjI1NTY1MiA2Ny4wMDUyMTcgMjEuMzcwNDM1IDk3LjgzNjUyMiA1LjE2NDUyMmwyMTEuNzQ1MzkxLTExMi4zOTUxMyAyMTEuODc4OTU3IDExMi40MTczOTFjMTMuNzEyNjk2IDcuMjM0NzgzIDI5LjA5NDk1NyAxMS4wNjM2NTIgNDQuNTIxNzM5IDExLjA2MzY1MiAxOS4wMTA3ODMgMCAzNy40MjA1MjItNS42MDk3MzkgNTMuMzM3MDQzLTE2LjMxNzIxNyAyOS4xMzk0NzgtMTkuODc4OTU3IDQ0LjIxMDA4Ny01NC42NTA0MzUgMzguNC04OC41NzZsLTQxLjM4Mjk1Ny0yNDMuNDAwMzQ4IDE3OC41MzIxNzQtMTc1LjYzODI2MUMxMDMzLjc1MDI2MSA0NjMuODQ5NzM5IDEwNDIuMTQyNjA5IDQyOC41NDQgMTAzMC44MTE4MjYgMzk1Ljk1NDA4N3pNOTc3Ljc2NDE3NCA0NTYuNDU5MTNsLTE5NS4wOTQyNjEgMTkxLjk1NTQ3OCA0NS4yNzg2MDkgMjY2LjMyOTA0M2MyLjkzODQzNSAxNy4wOTYzNDgtNC41ODU3MzkgMzQuMDU5MTMtMTkuNDc4MjYxIDQ0LjIzMjM0OC0xNS4yNDg2OTYgMTAuMjQtMzUuODE3NzM5IDExLjMzMDc4My01Mi4wNDU5MTMgMi43ODI2MDlsLTIzMi42OTI4Ny0xMjMuNDgxMDQzLTIzMi41MzcwNDMgMTIzLjQzNjUyMmMtMTYuNDA2MjYxIDguNjM3MjE3LTM2Ljk5NzU2NSA3LjQ3OTY1Mi01Mi4wNDU5MTMtMi42NzEzMDQtMTUuMDQ4MzQ4LTEwLjI2MjI2MS0yMi41NzI1MjItMjcuMjQ3MzA0LTE5LjYzNDA4Ny00NC4zNDM2NTJsNDUuMzAwODctMjY2LjI4NDUyMi0xOTUuMDcyLTE5MS45NTU0NzhjLTEyLjM3NzA0My0xMi4xNTQ0MzUtMTYuNjA2NjA5LTI5LjcxODI2MS0xMS4wNjM2NTItNDUuNzIzODI2IDUuNzY1NTY1LTE2LjM4NCAyMC41MjQ1MjItMjguMTgyMjYxIDM4LjYyMjYwOS0zMC43ODY3ODNsMjY2LjQ4NDg3LTM5LjExMjM0OCAxMTUuOTc5MTMtMjM3LjEyMjc4M2M3Ljg4MDM0OC0xNi4xMTY4NyAyNS4xNTQ3ODMtMjYuNTM0OTU3IDQzLjk4NzQ3OC0yNi41MzQ5NTcgMTguODk5NDc4IDAgMzYuMTczOTEzIDEwLjM5NTgyNiA0NC4wNTQyNjEgMjYuNTEyNjk2bDExNS45NTY4NyAyMzcuMTIyNzgzIDI2Ni40MTgwODcgMzkuMDIzMzA0YzE4LjA3NTgyNiAyLjY3MTMwNCAzMi45MDE1NjUgMTQuNTE0MDg3IDM4LjY0NDg3IDMwLjgwOTA0M0M5OTQuMzcwNzgzIDQyNi43NDA4NyA5OTAuMTQxMjE3IDQ0NC4yODI0MzUgOTc3Ljc2NDE3NCA0NTYuNDU5MTN6TTUyMC43NzA3ODMgMzg4Ljg1Mjg3Yy00NS41OTAyNjEgMC04Mi4zMjA2OTYgMTMuOTEzMDQzLTEwOS4xMjI3ODMgNDEuMzE2MTc0LTQ0Ljc0NDM0OCA0NS43NDYwODctNDMuNzg3MTMgMTEyLjE5NDc4My00My43MjAzNDggMTE1LjAyMTkxMyAwLjI2NzEzIDEyLjEwOTkxMyAxMC4xNzMyMTcgMjEuNzI2NjA5IDIyLjIzODYwOSAyMS43MjY2MDkgMC4xMzM1NjUgMCAwLjI4OTM5MSAwIDAuNDIyOTU3IDAgMTIuMjY1NzM5LTAuMjIyNjA5IDIyLjAxNi0xMC4zNzM1NjUgMjEuODM3OTEzLTIyLjYzOTMwNCAwLTAuNTEyLTAuNDAwNjk2LTUxLjA2NjQzNSAzMS4yNTQyNjEtODMuMTg4ODcgMTguMDk4MDg3LTE4LjM4NzQ3OCA0NC4wNTQyNjEtMjcuNjkyNTIyIDc3LjA2NzEzLTI3LjY5MjUyMiAxMi4yODggMCAyMi4yNjA4Ny05Ljk3Mjg3IDIyLjI2MDg3LTIyLjI2MDg3UzUzMy4wNTg3ODMgMzg4Ljg1Mjg3IDUyMC43NzA3ODMgMzg4Ljg1Mjg3eiIgcC1pZD0iMjM3OSIgZmlsbD0iIzhhOGE4YSI+PC9wYXRoPjwvc3ZnPg=="/>
				<div style="margin-top:8px">
					<span class="f16 f-black" >我的收藏</span>
				</div>
			</div>
			</a>
			
			<a class="weui_navbar_item" href="/library/enter_current.action?weid=${weid }">
			<div>
				<img style="margin-top:0px;width:28px;height:28px" 
						src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNTAzNzM2ODIxNjk5IiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjUxMjciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iMzYiIGhlaWdodD0iMzYiPjxkZWZzPjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+PC9zdHlsZT48L2RlZnM+PHBhdGggZD0iTTEwMTkuNTYyNjY3IDQ0Ny4xNDY2NjdsLTcxLjE2OC0xMTcuNzYgNzAuODI2NjY2LTExMC4wOGEzMi43NjggMzIuNzY4IDAgMCAwLTI3LjY0OC01MS4yaC0zOS41OTQ2NjZWOTguNDc0NjY3QTk4LjY0NTMzMyA5OC42NDUzMzMgMCAwIDAgODUzLjMzMzMzMyAwSDk4LjQ3NDY2N0E5OC42NDUzMzMgOTguNjQ1MzMzIDAgMCAwIDAgOTguNDc0NjY3djgyNy4wNTA2NjZBOTguNjQ1MzMzIDk4LjY0NTMzMyAwIDAgMCA5OC40NzQ2NjcgMTAyNEg4NTMuMzMzMzMzYTk4LjY0NTMzMyA5OC42NDUzMzMgMCAwIDAgOTguNDc0NjY3LTk4LjQ3NDY2N1Y0OTYuOTgxMzMzaDM5Ljc2NTMzM2EzMi43NjggMzIuNzY4IDAgMCAwIDI4LjE2LTQ5LjgzNDY2NnogbS0yNjQuNTMzMzM0LTIxMi44MjEzMzRoMTc2LjI5ODY2N2wtNDkuMzIyNjY3IDc2LjhhMzIuNzY4IDMyLjc2OCAwIDAgMCAwIDM0LjEzMzMzNGw1MS4yIDg1LjMzMzMzM0g3NTUuMDI5MzMzeiBtMTMxLjI0MjY2Ny0xMzYuNTMzMzMzdjcwLjgyNjY2N2gtMTMxLjI0MjY2N1Y5OC40NzQ2NjdhOTcuNzkyIDk3Ljc5MiAwIDAgMC01LjgwMjY2Ni0zMi43NjhIODUzLjMzMzMzM2EzMi45Mzg2NjcgMzIuOTM4NjY3IDAgMCAxIDMyLjkzODY2NyAzMi43Njh6IG0tODIwLjU2NTMzMyAwYTMyLjkzODY2NyAzMi45Mzg2NjcgMCAwIDEgMzIuNzY4LTMyLjA4NTMzM2g1NTguMDhhMzIuOTM4NjY3IDMyLjkzODY2NyAwIDAgMSAzMi43NjggMzIuNzY4djYxNC40YTMyLjkzODY2NyAzMi45Mzg2NjcgMCAwIDEtMzIuNzY4IDMyLjc2OEg5OC40NzQ2NjdhMzIuOTM4NjY3IDMyLjkzODY2NyAwIDAgMS0zMi43NjgtMzIuNzY4eiBtODIwLjU2NTMzMyA4MjcuNzMzMzMzQTMyLjkzODY2NyAzMi45Mzg2NjcgMCAwIDEgODUzLjMzMzMzMyA5NTguMjkzMzMzSDk4LjQ3NDY2N2EzMi45Mzg2NjcgMzIuOTM4NjY3IDAgMCAxLTMyLjc2OC0zMi43Njh2LTExOS40NjY2NjZhOTcuNzkyIDk3Ljc5MiAwIDAgMCAzMi43NjggNS44MDI2NjZoNTU4LjA4YTk4LjY0NTMzMyA5OC42NDUzMzMgMCAwIDAgOTguNDc0NjY2LTk4LjQ3NDY2NlY0OTYuOTgxMzMzaDEzMS4yNDI2Njd6IiBmaWxsPSIjOGE4YThhIiBwLWlkPSI1MTI4Ij48L3BhdGg+PC9zdmc+"/>
				<div style="margin-top:8px">
					<span class="f16 f-black" >当前借阅</span>
				</div>
			</div>
			</a>
			
			<a class="weui_navbar_item" href="/library/enter_history.action?weid=${weid }">
			<div>
				<img style="margin-top:0px;width:28px;height:28px" 
						src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNTAzNzM2NzY0NzAxIiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwNTYgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjQ2MDciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iMzcuMTI1IiBoZWlnaHQ9IjM2Ij48ZGVmcz48c3R5bGUgdHlwZT0idGV4dC9jc3MiPjwvc3R5bGU+PC9kZWZzPjxwYXRoIGQ9Ik0xNDQuMDUwNDMyIDMxMS4xMjAxMjhDMTUwLjcyMDE2IDI5OC4xNDUyOCAxNTkuNDgzNzQ0IDI4MS42NTc1NjggMTY1Ljk3MjI1NiAyNzEuNDgwNzM2IDI0NS41MDY1OTIgMTQ2LjczNTcxMiAzODUuMDkxMzI4IDY0IDU0NCA2NCA3OTEuNDIzNTUyIDY0IDk5MiAyNjQuNTc2NDQ4IDk5MiA1MTIgOTkyIDc1OS40MjM1NTIgNzkxLjQyMzU1MiA5NjAgNTQ0IDk2MCAzODMuMTI1MjggOTYwIDI0Mi4wNTU2NDggODc1LjIwNDQxNiAxNjMuMDQ3OTA0IDc0Ny44NzAwMTYgMTUyLjI2MDM4NCA3MzAuNDg0MDY0IDE0OC42MDg2MDggNzIxLjg3NzAyNCAxNDguNjA4NjA4IDcyMS44NzcwMjQgMTQwLjUyNjkxMiA3MDYuMDc4MjQgMTIxLjAwMzUyIDY5OC44ODcyMzIgMTA0LjY0NjE0NCA3MDUuNjA1OTUyIDg4LjE3NDY4OCA3MTIuMzcxNDg4IDgxLjMzMTc0NCA3MzAuNDkwMzA0IDg5LjEwNzI2NCA3NDYuMTgwMDY0IDg5LjEwNzI2NCA3NDYuMTgwMDY0IDk0LjI3OTg0IDc1Ny45MzYwNjQgMTA1Ljc0NTUzNiA3NzYuODY2ODE2IDE5NS40NjUxODQgOTI1LjAwMDkyOCAzNTguMTcxMzYgMTAyNCA1NDQgMTAyNCA4MjYuNzY5NzkyIDEwMjQgMTA1NiA3OTQuNzY5NzkyIDEwNTYgNTEyIDEwNTYgMjI5LjIzMDIwOCA4MjYuNzY5NzkyIDAgNTQ0IDAgMzYwLjc5NzM0NCAwIDIwMC4wNjgyNTYgOTYuMjIwODk2IDEwOS41OTI2NzIgMjQwLjg4MjgxNiAxMDUuMDE1MjY0IDI0OC4yMDE2MzIgOTkuMzg2MzA0IDI1OC40NDY4OCA5NC4wMTAyMDggMjY4LjY1Nzc2TDc2LjcxOTkwNCAxNTkuNDkxMDRDNzMuOTgwNzA0IDE0Mi4xOTY0OCA1Ny43MzEzNiAxMzAuMzk4NDMyIDQwLjE1NDE0NCAxMzMuMTgyMzY4IDIyLjY5ODU5MiAxMzUuOTQ3MDcyIDEwLjgxNTk2OCAxNTIuNTA2OTQ0IDEzLjUzOTEzNiAxNjkuNzAwNDQ4TDM4LjU5MzAyNCAzMjcuODg0NDQ4QzQ0LjExNzE1MiAzNjIuNzYyMzY4IDc2LjYyMDU3NiAzODYuNTk3NzI4IDExMS43NDczNiAzODEuMDM0MjA4TDI2OS45MzEzOTIgMzU1Ljk4MDMyQzI4Ny4zMzUwNzIgMzUzLjIyMzg0IDI5OS4yMjE2IDMzNi45NjA0OCAyOTYuNDM3NjMyIDMxOS4zODMyMzIgMjkzLjY3Mjk2IDMwMS45Mjc3MTIgMjc3LjE3ODIwOCAyOTAuMDM0NzUyIDI2MC4xMTcxODQgMjkyLjczNjk2TDE0NC4wNTA0MzIgMzExLjEyMDEyOCAxNDQuMDUwNDMyIDMxMS4xMjAxMjggMTQ0LjA1MDQzMiAzMTEuMTIwMTI4Wk01NDQgMjIzLjg1MjczNkM1NDQgMjA2LjI2MDk2IDUyOS43OTYzMiAxOTIgNTEyIDE5MiA0OTQuMzI2ODggMTkyIDQ4MCAyMDYuNTg0MzUyIDQ4MCAyMjQuMDc5MTM2TDQ4MCA1MTEuNzI3MDRDNDgwIDU0Ny4yMjQgNTA4Ljg2MjQgNTc2IDU0NC4yNzI5NiA1NzZMODMxLjkyMDg2NCA1NzZDODQ5LjYzNzY2NCA1NzYgODY0IDU2MS43OTYzMiA4NjQgNTQ0IDg2NCA1MjYuMzI2ODggODQ5LjQxODc1MiA1MTIgODMyLjE0NzI2NCA1MTJMNTc1Ljg1MjczNiA1MTJDNTU4LjI2MDk2IDUxMiA1NDQgNDk3LjQxODc1MiA1NDQgNDgwLjE0NzI2NEw1NDQgMjIzLjg1MjczNiA1NDQgMjIzLjg1MjczNiA1NDQgMjIzLjg1MjczNloiIHAtaWQ9IjQ2MDgiIGZpbGw9IiM4YThhOGEiPjwvcGF0aD48L3N2Zz4="/>
				<div style="margin-top:8px">
					<span class="f16 f-black" >历史记录</span>
				</div>
			</div>
			</a>
		</div>
  </div>
  <div class="weui_tab " style="height:80px;" id="tab1">
		<div class="weui_navbar" style="height:80px;background:#ffffff">
			<a class="weui_navbar_item" href="/library/enter_order.action?weid=${weid }">
			<div>
				<img style="margin-top:0px;width:28px;height:28px" 
						src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNTAzODg4MDk0NzQ3IiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9Ijc0ODIiIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iMzYiIGhlaWdodD0iMzYiPjxkZWZzPjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+PC9zdHlsZT48L2RlZnM+PHBhdGggZD0iTTgzOC44MzIgMjIuNTQ0aC02NjguMjc1Yy05My42MjggMC05My42MjggOTMuMjI5LTkzLjYyOCA5My4yMjl2NzkyLjQ1MWMwIDAgMCA5My4yMjkgOTUuMDU3IDkzLjIyOWg1NTMuMDU3bDIwNC41MTUtMTYzLjE1MnYtNzIyLjUzYzAgMC0xLjQzLTkzLjIyOS05MC43MjQtOTMuMjI5djB6TTg4My40NjkgODE0Ljk5N2wtMTg0LjM1MiAxMzkuODQ1aC01MDYuOTY5Yy02OS4xMzMgMC02OS4xMzMtNjkuOTIyLTY5LjEzMy02OS45MjJ2LTc0NS44MzZjMCAwIDAtNjkuOTIyIDY5LjEzMy02OS45MjJoNjIyLjE4OWM2OS4xMzMgMCA2OS4xMzMgNjkuOTIyIDY5LjEzMyA2OS45MjJ2Njc1LjkxNXpNMjM4LjIzOCA1MzUuMzA3aDUzMC4wMTJ2NDYuNjE1aC01MzAuMDEydi00Ni42MTV6TTIzOC4yMzggMzQ4Ljg0OGg1MzAuMDEydjQ2LjYxNWgtNTMwLjAxMnYtNDYuNjE1ek0yMzguMjM4IDE2Mi4zODloMjUzLjQ4NHY0Ni42MTVoLTI1My40ODR2LTQ2LjYxNXpNODM3LjM4MSA2OTguNDU4aC0yMDcuMzk3djIwOS43NjZoNDYuMDg3di0xNjMuMTUyaDE2MS4zMDl2LTQ2LjYxNXoiIHAtaWQ9Ijc0ODMiIGZpbGw9IiM4YThhOGEiPjwvcGF0aD48L3N2Zz4=">
				<div style="margin-top:8px">
					<span class="f16 f-black" >我的预定</span>
				</div>
			</div>
			</a>
			
			<a class="weui_navbar_item" href="/library/enter_info.action?weid=${weid }">
			<div>
				<img style="margin-top:0px;width:30px;height:30px" 
						src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNTAzODg4MTU3Mzc2IiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9Ijg5MjUiIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iMzYiIGhlaWdodD0iMzYiPjxkZWZzPjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+PC9zdHlsZT48L2RlZnM+PHBhdGggZD0iTTQwNi42NDA2NCA1NzIuMjUyMTZjODQuMTI2NzItMzIuNjg2MDggMTQzLjk4NDY0LTExNC4zMTkzNiAxNDMuOTg0NjQtMjA5Ljg2ODggMC0xMjQuMjUyMTYtMTAxLjA0ODMyLTIyNS4zMTA3Mi0yMjUuMjk1MzYtMjI1LjMxMDcyLTEyNC4yNTIxNiAwLTIyNS4yOTUzNiAxMDEuMDU4NTYtMjI1LjI5NTM2IDIyNS4zMTA3MiAwIDk1LjU1NDU2IDU5Ljg1MjggMTc3LjE4MjcyIDE0My45Nzk1MiAyMDkuODY4OEMxMDMuOTA1MjggNjA4LjUzMjQ4LTAuMDMwNzIgNzM1LjY1MTg0LTAuMDMwNzIgODg2LjkzNzZINDQuODUxMmMwLTE1NC42ODU0NCAxMjUuODEzNzYtMjgwLjQ5NDA4IDI4MC40Nzg3Mi0yODAuNDk0MDhzMjgwLjQ3ODcyIDEyNS44MDg2NCAyODAuNDc4NzIgMjgwLjQ5NDA4aDQ0Ljg3NjhjLTAuMDA1MTItMTUxLjI4NTc2LTEwMy45MzYtMjc4LjQwNTEyLTI0NC4wNDQ4LTMxNC42ODU0NHpNMTQ0Ljg5MDg4IDM2Mi4zNzgyNGMwLTk5LjUwMjA4IDgwLjk1MjMyLTE4MC40MzM5MiAxODAuNDM5MDQtMTgwLjQzMzkyIDk5LjQ4MTYgMCAxODAuNDMzOTIgODAuOTM2OTYgMTgwLjQzMzkyIDE4MC40MzM5MiAwIDk5LjQ3MTM2LTgwLjk1MjMyIDE4MC40Mjg4LTE4MC40MzM5MiAxODAuNDI4OC05OS40ODY3MiAwLjAwNTEyLTE4MC40MzkwNC04MC45NTc0NC0xODAuNDM5MDQtMTgwLjQyODh6IG04MjAuMTQyMDggNTMwLjcxODcyaC0yMDEuNzY4OTZ2LTQwLjgzMmgyMDEuNzY4OTZhMTguMjAxNiAxOC4yMDE2IDAgMCAwIDE4LjE3MDg4LTE4LjE4MTEyVjE4OS44OTU2OGExOC4xODYyNCAxOC4xODYyNCAwIDAgMC0xOC4xNzA4OC0xOC4xNjU3Nkg0OTEuMDU0MDh2LTQwLjgyNjg4aDQ3My45Nzg4OGMzMi41NDI3MiAwIDU4Ljk5MjY0IDI2LjQ1NTA0IDU4Ljk5MjY0IDU4Ljk5MjY0djY0NC4xODgxNmMwLjAwNTEyIDMyLjU0Nzg0LTI2LjQ0NDggNTkuMDEzMTItNTguOTkyNjQgNTkuMDEzMTJ6TTU4Ny4xMTA0IDI2NS44NTZoMzE4LjgyMjR2NDYuNDg5NmgtMzE4LjgyMjR2LTQ2LjQ4OTZ6IG0wIDE0NS4xOTgwOGgzMTguODIyNHY0Ni40OTk4NGgtMzE4LjgyMjR2LTQ2LjQ5OTg0eiBtODMuODk2MzIgMTU0Ljc5ODA4aDIzNC45MjYwOHY0Ni40OTk4NGgtMjM0LjkyNjA4di00Ni40OTk4NHoiIHAtaWQ9Ijg5MjYiIGZpbGw9IiM4YThhOGEiPjwvcGF0aD48L3N2Zz4=">
				<div style="margin-top:8px">
					<span class="f16 f-black" >资料编辑</span>
				</div>
			</div>
			</a>
			
			<a class="weui_navbar_item" href="/library/enterEbook.action?weid=${weid }">
			<div>
				<img style="margin-top:0px;width:30px;height:30px" 
						src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNTA0MzU4NzExMDg5IiBjbGFzcz0iaWNvbiIgc3R5bGU9IiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjIzMzciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iMzYiIGhlaWdodD0iMzYiPjxkZWZzPjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+PC9zdHlsZT48L2RlZnM+PHBhdGggZD0iTTgyMy41MjI1MjY2Njc3NzgzIDQuNjA2MTg2OTcyMTEwMTdIMjAwLjQ2OTEwNzEyMjEwNDVhNzcuODA1NzU0MDg2Mzk5MTYgNzcuODA1NzU0MDg2Mzk5MTYgMCAwIDAtNzcuODgyNzIzMjE5NDczODcgNzcuODgyNzIzMjE5NDczODd2ODU2LjY5OTkxNTk2MjA3MjdhNzcuODE0MTIwMjk2NTE1OTcgNzcuODE0MTIwMjk2NTE1OTcgMCAwIDAgNzcuODgyNzIzMjE5NDczODcgNzcuODg5NDE2MTg3NTY3MzJIODIzLjUyNDE5OTkwOTgwMmE3Ny44MjI0ODY1MDY2MzI3OSA3Ny44MjI0ODY1MDY2MzI3OSAwIDAgMCA3Ny44ODk0MTYxODc1NjczMi03Ny44ODk0MTYxODc1NjczMnYtODU2LjY5OTkxNTk2MjA3MjdhNzcuODE0MTIwMjk2NTE1OTcgNzcuODE0MTIwMjk2NTE1OTcgMCAwIDAtNzcuODg5NDE2MTg3NTY3MzItNzcuODgyNzIzMjE5NDczODd6IG0wIDc3OC44MDg4MjY1MzI0ODE4SDIwMC40NjkxMDcxMjIxMDQ1VjgyLjQ3ODg3MDczOTQ0Mzg1SDgyMy41MjQxOTk5MDk4MDJWNzgzLjQxNjY4Njc0NjYxNTN6IG0tMzEyLjMwMjI1NzQ1MDY2NjE2LTE1NS4yMDk5MzAwODcxOTExYzYyLjE1NDI0ODE5OTg1NzcwNSAwIDExMi4yOTYyOTE5MTM5ODkzOS0xMC44Mjc1NDkxMzMxODQ3MDcgMTUwLjYxNjg4MDczMzA1ODU0LTMyLjMyMjAxNjE2NTMxMTI0VjUwNS43NzU2Mzc4MDk5MjI3Yy0zNS41MTEyMTU0NjE4NDE5MiAyMi44MTI5ODE3NDY1MzY5MS03Ni40MDAyMzA3ODY3NzM4OSAzNC4xODA5ODgwNTMyNjc5OTUtMTIyLjgxNTk2NDUxNDg3NTIyIDM0LjE4MDk4ODA1MzI2Nzk5NS03NC4yOTM2MTkwNzkzNTkzNyAwLTExMy41NDc4NzY5NDc0NjUyMy0zMi41NTQ1OTY4MDY1NTg3NTYtMTE3LjkwODM0NTY2MDM1MDM0LTk3Ljc0MDc1OTU1Mjc1MTAySDY5Ny45ODA4NTA4OTY4NDQzdi01Mi4xMDQ3NTY2MDc1MzdjMC02My4xNjQ4ODYzODE5NjkyMjUtMTYuODE2MDgyMzM0ODAyNDAyLTExMi43NzY1MTIzNzQ2OTQ3LTUwLjM5MTM1Njc3NTYxMjg1Ni0xNDguODM0ODc3OTc4MTc2NDUtMzMuNTY1MjM0OTg4NjcwMjU1LTM2LjIyMDY3MDA3OTc0ODAxLTgwLjEzNDkwNjk4MjkyMTA1LTU0LjIxMTM2ODMxNDk1MTU1LTEzOS43MTkwNTU0MzQ4OTI1NC01NC4yMTEzNjgzMTQ5NTE1NS01OS44OTIwMjQ5ODQyNzAzNCAwLTEwOS41MDM2NTA5NzY5OTU4NCAyMS4wMzI2NTIyMzM2NzgyMjQtMTQ5LjA2NTc4NTM3NzQwMDU0IDYyLjkzMzk3ODk4Mjc0NTA1LTM5LjU2MjEzNDQwMDQwNDc2NiA0MS45ODY2NjIwOTIyNTgzOC01OS4zNDMyMDE2MDA2MDcxNiA5Ni41ODQ1NDkzMTQ2MDY4Ni01OS4zNDMyMDE2MDA2MDcxNiAxNjMuNzkzNjYxNjY3MDQ1NDggMCA2Ny40NDY3MTI3MTk3NTYxOSAxOC41Mzk1MjE2MTg4NjY3MjYgMTIwLjAxMzI4NDEyNTc0MTUyIDU1LjY4NTQ5NDUzNzUzNDcxIDE1Ny43ODY3MjI4MDMxNzA3NiAzNy4xNDU5NzI5MTg2Njc5OSAzNy43NzAwOTIxOTMzODI1MyA4OS4xNzM3NjAzOTMxMzAyNCA1Ni42Mjc1Mjk3OTY2ODgzMzYgMTU2LjA3MzMyMjk3MTI0NjY1IDU2LjYyNzUyOTc5NjY4ODMzNnogbS02MC4wNDU5NjMyNTA0MTk3OS0zMzEuMjM0OTkwOTQ1MDIzMmMxNi4yMDAzMjkyNzAyMDQ2NjItMTcuMjk0NjI5NTUzNDg0MzM4IDM0LjgxNjgyMDAyMjE0NjEtMjUuODYxNjI4NzEzMTA1MDY2IDU1LjkxNjQwMTkzNjc1ODg2LTI1Ljg2MTYyODcxMzEwNTA2NiA1MC45NDAxODAxNTkyNzYwNDYgMCA3Ni40MDAyMzA3ODY3NzM4OSAzMS4zOTAwMjAzNTgyOTc4MSA3Ni40MDAyMzA3ODY3NzM4OSA5NC4zMTM5NTk4ODg5MDI2OWgtMTYyLjc3Mjk4NDAzMjc5MzhjNC4wNTI1OTIxODA1ODYyMS0yOC4zMzk3MDAxNDk3MDYyOTIgMTQuMTc5MDUyOTA1OTgxNjQ3LTUxLjE2MjcyMTM0ODM4MzM3IDMwLjQ1NjM1MTMwOTI2MTAyNC02OC40NTIzMzExNzU3OTc2NHoiIHAtaWQ9IjIzMzgiIGZpbGw9IiM4YThhOGEiPjwvcGF0aD48L3N2Zz4=">
				<div style="margin-top:8px">
					<span class="f16 f-black" >我的电子书</span>
				</div>
			</div>
			</a>
		</div>
  </div>
  
  
  
  
  <!-- 图表展示   -->
  <div style="height:12px;width:100%;background-color:#f8f8f8"></div>
	
	<div class="weui_cells_title" style="background:#ffffff;margin-bottom:8px">
		<span class="f14" >阅读统计</span>
	</div>
  <hr />
  <!-- 为ECharts准备一个具备大小（宽高）的Dom -->

  <div id="category" style="width: 80%;height:43%;margin-left:auto;margin-right:auto;"></div><!-- style="width: 600px;height:400px;" -->
  <hr />
  <!-- 为ECharts准备一个具备大小（宽高）的Dom -->

  <div id="year" style="width: 80%;height:43%;margin-left:auto;margin-right:auto;"></div><!-- style="width: 600px;height:400px;" -->
  <hr />
  <!-- 为ECharts准备一个具备大小（宽高）的Dom -->

  <div id="month" style="width: 80%;height:55%;margin-left:auto;margin-right:auto;"></div><!-- style="width: 600px;height:400px;" -->
  
  
  <script type="text/javascript">
//<![CDATA[
                // 基于准备好的dom，初始化echarts实例
        // 第二个参数可以指定前面引入的主题 , 'shine'
        var myChart1 = echarts.init(document.getElementById('category'));

        var giftImageUrl = "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/PjxzdmcgaGVpZ2h0PSIzMnB4IiB2ZXJzaW9uPSIxLjEiIHZpZXdCb3g9IjAgMCAzMiAzMiIgd2lkdGg9IjMycHgiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6c2tldGNoPSJodHRwOi8vd3d3LmJvaGVtaWFuY29kaW5nLmNvbS9za2V0Y2gvbnMiIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIj48dGl0bGUvPjxkZXNjLz48ZGVmcy8+PGcgZmlsbD0ibm9uZSIgZmlsbC1ydWxlPSJldmVub2RkIiBpZD0iUGFnZS0xIiBzdHJva2U9Im5vbmUiIHN0cm9rZS13aWR0aD0iMSI+PGcgZmlsbD0iIzE1N0VGQiIgaWQ9Imljb24tMzAtYm9vayI+PHBhdGggZD0iTTguOTk0MjAyMDgsMjkgQzcuMzQzMzExOTcsMjkgNiwyNy42NTcwOTc4IDYsMjYuMDAwNTQzOSBMNiw2LjUgQzYsNS4xMDk2NjIwNiA3LjExNTk2NCw0IDguNDkyNTc1MzUsNCBMMjYsNCBMMjYsNSBMMjUuNDk1MzE1Niw1IEMyNC42NzcxMDg4LDUgMjQsNS42NzE1NzI4OCAyNCw2LjUgQzI0LDcuMzM0MjAyNzcgMjQuNjY5NDc1Niw4IDI1LjQ5NTMxNTYsOCBMMjYsOCBMMjYsMjkgTDExLDI5IEwxMSw4IEwyMy41LDggQzIzLjUsOCAyMyw3LjIxMDQ4NDUzIDIzLDYuNDczNTU0NDkgQzIzLDUuNzM2NjI0NDUgMjMuNSw1IDIzLjUsNSBMOC40OTMzNjYyNSw1IEM3LjY2ODYwMjg0LDUgNyw1LjY2NTc5NzIzIDcsNi41IEM3LDcuMzI4NDI3MTIgNy42NjcyNTU0Niw4IDguNDkzMzY2MjUsOCBMMTAsOCBMMTAsMjkgTDguOTk0MjAyMDgsMjkgWiIgaWQ9ImJvb2siLz48L2c+PC9nPjwvc3ZnPg==";

        myChart1.showLoading();

        $j.getJSON("category.json", function(data) {
          myChart1.hideLoading();
        // 填入数据
        myChart1.setOption({
          title:{
            text: '阅读分布',
            left: '25%',
                textStyle:{//标题样式
                  fontSize: 30,
                  color : '#2FC9DA'
                }
              },
              graphic: {
                elements: [{
                  type: 'image',
                  style: {
                    image: giftImageUrl,
                    width: 30,
                     height: 30//矢量图大小
                   },
                   left: 'center',
                   top: 'center'
                 }]
               },
               series: [{
                type: 'pie',
             radius: [25, '55%'],//中心小圆圈
             center: ['50%', '50%'],
             roseType: 'radius',
               //color: ['#f2c955', '#00a69d', '#46d185', '#ec5845'],
               data: data.data,
               label: {
                normal: {
                  textStyle: {
                         fontSize: 20,//文字大小
                         fontFamily : '微软雅黑',
                       },
                       formatter: function(param) {
                        return param.name + '\n' + Math.round(param.percent) + '%';
                      }
                    }
                  },
                  labelLine: {
                    normal: {
                      smooth: true,
                      lineStyle: {
                        width: 2
                      }
                    }
                  },
                  itemStyle: {
                    normal: {
                      shadowBlur: 50,
                      shadowColor: 'rgba(0, 0, 0, 0.4)'
                    }
                  },

                  animationType: 'scale',
                  animationEasing: 'elasticOut',
                  animationDelay: function(idx) {
                    return Math.random() * 200;
                  }
                }]
              });
        console.log(data.data);
      });
  //]]>
</script>
<script type="text/javascript">
//<![CDATA[
                // 基于准备好的dom，初始化echarts实例
        // 第二个参数可以指定前面引入的主题 , 'shine'
        var myChart2 = echarts.init(document.getElementById('year'));

        myChart2.showLoading();

        $j.getJSON("year.json", function(data) {
          myChart2.hideLoading();
            // 填入数据
            myChart2.setOption({
              color: ['#3398DB'],
              tooltip : {
                trigger: 'axis',
                axisPointer : {            
                // 坐标轴指示器，坐标轴触发有效
                type : 'shadow'        
                // 默认为直线，可选为：'line' | 'shadow'
              }
            },
            title:{
              text: '年度统计',
              left: '20%',
                textStyle:{//标题样式
                  fontSize: 30,
                  color : '#2FC9DA'
                }
              },
              grid: {
               left: '3%',
               right: '4%',
               bottom: '3%',
               containLabel: true
             },
             xAxis : [
             {
               type : 'category',
               data : data.title,
                //['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                axisTick:
                {
                 alignWithLabel: true,
               },
               axisLabel: {
                textStyle:{//坐标轴样式
                  fontSize: 12,
                  color : '#90979c',
                  fontWeight : 'bold'
                }
              }
            }
            ],
            yAxis : [
            {
             type : 'value',
             axisLabel: {
                textStyle:{//坐标轴样式
                  fontSize: 15,
                  color : '#90979c',
                  fontWeight : 'bold'
                }
              }
            }
            ],
            series : [
            {
             name:'num',
             type:'bar',
             barWidth: '60%',
             label: {
              normal: {
               show: true,
               position: 'top',
               textStyle : {
                fontSize : '20',
                fontFamily : '微软雅黑',
                fontWeight : 'bold'
              }
            }

          },
          data:data.num,
                //[110, 52, 80, 130, 150, 130, 100]

              }],



            });
            console.log(data.title);
            console.log(data.num);
          });
  //]]>
</script><script type="text/javascript">
//<![CDATA[
                // 基于准备好的dom，初始化echarts实例
        // 第二个参数可以指定前面引入的主题 , 'shine'
        var myChart3 = echarts.init(document.getElementById('month'));

        var xData = function() {
          var data = [];
          for (var i = 1; i < 13; i++) {
            data.push(i + "月");
          }
          return data;
        }();

        myChart3.showLoading();

        $j.getJSON("month.json", function(data) {
          myChart3.hideLoading();
            var year = data.year;//"2015";
            var option = {
               // backgroundColor: "#ffffff",//#344b58
               "title": {
                "text": year + "年借书统计",
                x: "4%",
                textStyle: {
                  color: '#2FC9DA',
                  fontSize: '30'
                },

              },
              "tooltip": {
                "trigger": "axis",
                "axisPointer": {
                  "type": "shadow",
                  textStyle: {
                    color: "#fff"
                  }

                },
              },
              "grid": {
                "borderWidth": 0,
                "top": 110,
                "bottom": 95,
                textStyle: {
                  color: "#fff",
                  fontSize : 15
                }
              },
              "legend": {
                x: '4%',
                top: '11%',
                left:'12%',
                textStyle: {
                 color: '#90979c',
                 fontSize : 20
               },
               "data": ['柱状图',  '折线图']
             },


             "calculable": true,
             "xAxis": [{
              "type": "category",
              "axisLine": {
               lineStyle: {
                color: '#90979c',
                           // fontSize: 50
                         }
                       },

                       "splitLine": {
                         "show": false
                       },
                       "axisTick": {
                         "show": false
                       },
                       "splitArea": {
                         "show": false
                       },
                       "axisLabel": {
                         "interval": 0,
                         "textStyle":
                         {
                    //坐标轴样式
                    fontSize: 15,
                    color : '#90979c',
                    fontWeight : 'bold'
                  }
                },
                "data": xData,
              }],
              "yAxis": [{
                "type": "value",
                "splitLine": {
                 "show": false
               },
               "axisLine": {
                 lineStyle: {
                  color: '#90979c'
                }
              },
              "axisTick": {
               "show": false
             },
             "axisLabel": {
               "interval": 0,
               "textStyle":
               {
                    //坐标轴样式
                    fontSize: 15,
                    color : '#90979c',
                    fontWeight : 'bold'
                  }
                },
                "splitArea": {
                 "show": false
               },

             }],
             "dataZoom": [{
              "show": true,
              "height": 30,
              "xAxisIndex": [
              0
              ],
              bottom: 30,
              "start": 10,
              "end": 80,
              handleIcon: 'path://M306.1,413c0,2.2-1.8,4-4,4h-59.8c-2.2,0-4-1.8-4-4V200.8c0-2.2,1.8-4,4-4h59.8c2.2,0,4,1.8,4,4V413z',
              handleSize: '110%',
              handleStyle:{
               color:"#d3dee5",

             },
             textStyle:{
               color:"#fff"},
               borderColor:"#90979c",

             }, {
               "type": "inside",
               "show": true,
               "height": 15,
               "start": 1,
               "end": 35
             }],
             "series": [{
               "name": "柱状图",
               "type": "bar",
               "stack": "总量",
               "barMaxWidth": 35,
               "barGap": "10%",
               "itemStyle": {
                "normal": {
                 "color": "rgba(255,144,128,1)",//柱状图色
                 "label": {
                  "show": true,
                  "textStyle": {
                   "color": "#fff",
                   "fontSize" : 20
                 },
                 "position": "top",
                 formatter: function(p) {
                   return p.value > 0 ? (p.value) : '';
                 }
               }
             }
           },
           "data": data.data,
         },


         {
           "name": "折线图",
           "type": "line",
           "stack": "总量",
           symbolSize:10,
           symbol:'circle',
           "itemStyle": {
            "normal": {
             "color": "rgba(0,230,48,1)",//折线色
             "barBorderRadius": 0,
             "label": {
              "show": true,
              "textStyle": {
                "fontSize" : 15
              },
              "position": "top",
              formatter: function(p) {
               return p.value > 0 ? (p.value) : '';
             }
           }
         }
       },
       "data": data.data,
     },
     ],
     markLine : {
       data : [
       {type : 'average', name: '平均值'}
       ]
     }
   };

   myChart3.setOption(option);
 });
  //]]>
</script>
  
  
  </body>
</html>
