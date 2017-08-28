<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>公告详情</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">
<script src="js/zepto.min.js"></script>

</head>

  <body ontouchstart style="background-color: #f8f8f8;">
  
<div class="weui-weixin">
<div class="weui-weixin-ui">
  <!--页面开始-->
    <div class="weui-weixin-page">
   <h2 class="weui-weixin-title">${anno.title}</h2>
   <div class="weui-weixin-info"><!--meta-->
                     <span class="weui-weixin-em">发布时间</span>
                      <em class="weui-weixin-em" >${anno.time}</em>
                    </div><!--meta结束-->
                    
    <div class="weui-weixin-img"><!--图片开始-->
    <img src="${anno.img}">
    </div><!--图片结束-->
                                        
    <div class="weui-weixin-content"><!--内容-->
    	<c:forEach var="contentlist" items="${contentlist}">
         	<p>${contentlist}</p>
        </c:forEach>
    </div><!--内容结束-->
	</div><!--页面结束-->
  </div>
</div>        
  </body>
  
</html>
