<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
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
</head>
  
<body ontouchstart style="background-color: #ffffff;">
    
    <div class="weui-header bg-blue" style="height:56px;background-color:#01164b">
		<div class="weui-header-left" style="margin-top:6px;">
			<a class="icon icon-109 f-white" 
				href="/library/show_singleItem.action?weid=${weid }&bookno=${bookno}">&nbsp;&nbsp;&nbsp;</a>
		</div>
		<h1 class="weui-header-title" style="margin-top:16px">
			<span class="f20">序言</span>
		</h1>
	</div>
    
	<div class="weui_article">
            <section>
                <section>
                    <span style="font-size:18px">${xu }</span>
                </section>
            </section>
        </div>

  </body>
</html>
