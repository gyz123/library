<%@ page language="java" import="java.util.*" contentType="text/html; charset=utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>摇一摇</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
	<link rel="stylesheet" href="css/weui.css"/>
	<link rel="stylesheet" href="css/weui2.css"/>
	<link rel="stylesheet" href="css/weui3.css"/>
	<script src="js/zepto.min.js"></script>
	<script src="js/jquery-1.11.3.js"></script>
  </head>
  
  <body ontouchstart class="page-bg">
    <div class="page-hd">
	    <h1 class="page-hd-title">
	      摇一摇
	    </h1>
    	<p class="page-hd-desc">摇一摇效果</p>
  	</div>
  <audio  id="musicBox"  src="http://weixin.yoby123.cn/weui/c/v4.mp3"></audio>
  <img alt="摇一摇" src="images/1.jpg" style="height:100px;width:100px;" id="shakeImg">
  </body>
</html>
<script>
  $(function(){

    var SHAKE_THRESHOLD = 1300;
    var last_update = 0;
    var x = y = z = last_x = last_y = last_z = 0;
    if(window.DeviceMotionEvent) {
    	window.addEventListener('devicemotion', deviceMotionHandler, false);
    }
    function deviceMotionHandler(eventData) {
      var acceleration = eventData.accelerationIncludingGravity;
      var curTime = new Date().getTime();
      if((curTime - last_update) > 100) {
        var diffTime = curTime - last_update;
        last_update = curTime;
        x = acceleration.x;
        y = acceleration.y;
        z = acceleration.z;
        var speed = Math.abs(x + y + z - last_x - last_y - last_z) / diffTime * 5000;
        if(speed > SHAKE_THRESHOLD) {

         WeixinJSBridge.invoke('getNetworkType', {}, function (res) {
           document.getElementById('musicBox').play();
         });
         //alert('摇一摇');
         console.log("摇一摇");
         console.log("speed = " + speed);
         console.log("SHAKE_THRESHOLD = " + SHAKE_THRESHOLD);
         $.ajax({    
            type:'post',        
            url:'/library/recommend.action',    //servlet名
            data:"weid=" + "<%=request.getParameter("weid") %>",   //参数 
            cache:false,    
            //dataType:'json',    
            success:function(data){ 
            	console.log("ajax请求成功");
            	console.log(data);
            	location.href = "/library/show_singleItem.action?bookno=" + data +"&weid=" + "<%=request.getParameter("weid") %>";
            },
            error:function(){
            	console.log("ajax请求失败");
            }
        }); 
       };
       last_x = x;
       last_y = y;
       last_z = z;
     };
   };


 });    

</script>
