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
				<input class="weui_switch" type="checkbox" id="check0" />
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
				<input class="weui_switch" type="checkbox" id="check1_1" />
			</div>
		</div>
		<div class="weui_cell weui_cell_switch" style="height:40px">
			<div class="weui_cell_hd weui_cell_primary">震动提示</div>
			<div class="weui_cell_ft">
				<input class="weui_switch" type="checkbox" id="check1_2" />
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
				<input class="weui_switch" type="checkbox" id="check2_1" />
			</div>
		</div>
		<div class="weui_cell weui_cell_switch" style="height:40px">
			<div class="weui_cell_hd weui_cell_primary">精选好书</div>
			<div class="weui_cell_ft">
				<input class="weui_switch" type="checkbox" id="check2_2"/>
			</div>
		</div>
		<div class="weui_cell weui_cell_switch" style="height:40px">
			<div class="weui_cell_hd weui_cell_primary">系统通知</div>
			<div class="weui_cell_ft">
				<input class="weui_switch" type="checkbox" id="check2_3" />
			</div>
		</div>
		<div class="weui_cell weui_cell_switch" style="height:40px">
			<div class="weui_cell_hd weui_cell_primary">相关热评</div>
			<div class="weui_cell_ft">
				<input class="weui_switch" type="checkbox" id="check2_4" checked/>
			</div>
		</div>
	</div>
	
	<script type="text/javascript" src="js/jquery-1.11.3.js"></script>
	<script src="https://cdn.bootcss.com/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
	<script>
		var $j = jQuery.noConflict(); //自定义一个比较短的快捷方式
	</script>
	<script>
		
		$j(document).ready(function(){
			//cookie初始化
			if($j.cookie("check0") == "unchecked"){
				$j('#check0').removeAttr("checked");
			}else{
				$j('#check0').prop("checked", true);
				$j('#check0').attr("checked", true);
			}
			
			if($j.cookie("check1_1") == "unchecked"){
				$j('#check1_1').removeAttr("checked");
			}else{
				$j('#check1_1').prop("checked", true);
				$j('#check1_1').attr("checked", true);
			}
			
			if($j.cookie("check1_2") == "unchecked"){
				$j('#check1_2').removeAttr("checked");
			}else{
				$j('#check1_2').prop("checked", true);
				$j('#check1_2').attr("checked", true);
			}
			
			if($j.cookie("check2_1") == "unchecked"){
				$j('#check2_1').removeAttr("checked");
			}else{
				$j('#check2_1').prop("checked", true);
				$j('#check2_1').attr("checked", true);
			}
			
			if($j.cookie("check2_2") == "unchecked"){
				$j('#check2_2').removeAttr("checked");
			}else{
				$j('#check2_2').prop("checked", true);
				$j('#check2_2').attr("checked", true);
			}
			
			if($j.cookie("check2_3") == "unchecked"){
				$j('#check2_3').removeAttr("checked");
			}else{
				$j('#check2_3').prop("checked", true);
				$j('#check2_3').attr("checked", true);
			}
			
			if($j.cookie("check2_4") == "unchecked"){
				$j('#check2_4').removeAttr("checked");
			}else{
				$j('#check2_4').prop("checked", true);
				$j('#check2_4').attr("checked", true);
			}
			
			var time1 = decodeURI(decodeURI($j.cookie("time1")));
			var time2 = decodeURI(decodeURI($j.cookie("time2")));
			var time3 = decodeURI(decodeURI($j.cookie("time3")));
			if(time1 == "undefined"){
				$j("#time1").attr("value", "上午 00：00");
			}else{
				$j("#time1").attr("value", time1);
			}
			
			if(time2 == "undefined"){
				$j("#time2").attr("value", "上午 00：00");
			}else{
				$j("#time2").attr("value", time2);
			}
			
			if(time3 == "undefined"){
				$j("#time3").attr("value", "每天一次");
			}else{
				$j("#time3").attr("value", time3);
			}
			
			
			//点击存储cookie
			$j('#check0').click(function(){
				var status = $j('#check0').attr("checked");
				if(status == "checked"){
					$j.cookie("check0","unchecked",{expires:7,path:'/'});
				}else{
					$j.cookie("check0","checked",{expires:7,path:'/'});
				}

		  	});
		  	
		  	$j('#check1_1').click(function(){
		  		var status = $j('#check1_1').attr("checked");
				if(status == "checked"){
					$j.cookie("check1_1","unchecked",{expires:7,path:'/'});
				}else{
					$j.cookie("check1_1","checked",{expires:7,path:'/'});
				}
				
		  	});
		  	
		  	$j('#check1_2').click(function(){
				var status = $j('#check1_2').attr("checked");
				if(status == "checked"){
					$j.cookie("check1_2","unchecked",{expires:7,path:'/'});
				}else{
					$j.cookie("check1_2","checked",{expires:7,path:'/'});
				}
		  	});
		  	
		  	$j('#check2_1').click(function(){
				var status = $j('#check2_1').attr("checked");
				if(status == "checked"){
					$j.cookie("check2_1","unchecked",{expires:7,path:'/'});
				}else{
					$j.cookie("check2_1","checked",{expires:7,path:'/'});
				}
		  	});
		  	
		  	$j('#check2_2').click(function(){
				var status = $j('#check2_2').attr("checked");
				if(status == "checked"){
					$j.cookie("check2_2","unchecked",{expires:7,path:'/'});
				}else{
					$j.cookie("check2_2","checked",{expires:7,path:'/'});
				}
		  	});
		  	
		  	$j('#check2_3').click(function(){
				var status = $j('#check2_3').attr("checked");
				if(status == "checked"){
					$j.cookie("check2_3","unchecked",{expires:7,path:'/'});
				}else{
					$j.cookie("check2_3","checked",{expires:7,path:'/'});
				}
		  	});
		  	
		  	$j('#check2_4').click(function(){
				var status = $j('#check2_4').attr("checked");
				if(status == "checked"){
					$j.cookie("check2_4","unchecked",{expires:7,path:'/'});
				}else{
					$j.cookie("check2_4","checked",{expires:7,path:'/'});
				}
		  	});
		  	
		  
		});
		
		
	</script>
	
	<script>
		
		var time1 = document.getElementById("time1");
		var time2 = document.getElementById("time2");
		var time3 = document.getElementById("time3");
			
		time1.addEventListener("change", function(){
			setCookie("time1", time1.value, "d7");
		});
		
		time2.addEventListener("change", function(){
			setCookie("time2", time2.value, "d7");
		});
		
		time3.addEventListener("change", function(){
			setCookie("time3", time3.value, "d7");
		});
		
	
		
		//程序代码
		function setCookie(name,value,time){
			var strsec = getsec(time);
			var exp = new Date();
			exp.setTime(exp.getTime() + strsec*1);
			document.cookie = name + "="+ encodeURI(encodeURI(value)) + ";expires=" + exp.toGMTString() + ";path=" + '/';
		}
		function getsec(str){
		    //alert(str);
		    var str1=str.substring(1,str.length)*1; 
		    var str2=str.substring(0,1); 
		    if (str2=="s"){
		    return str1*1000;
		    }else if (str2=="h"){
		    return str1*60*60*1000;
		    }else if (str2=="d"){
		    return str1*24*60*60*1000;
		    }
		}
		//这是有设定过期时间的使用示例：
		//s20是代表20秒
		//h是指小时，如12小时则是：h12
		//d是天数，30天则：d30
	</script>
	
	
</body>
</html>
