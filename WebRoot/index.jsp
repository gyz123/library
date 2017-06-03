<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"
contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>主界面</title>
  </head>
  
  <body>
    <s:a action="test">Test界面</s:a>
    <br>
    <s:a action="show_register">注册界面</s:a>
    <br>
    <s:a action="show_main">主界面</s:a>
    <br>
    <s:a action="show_singleCat">文学类书籍</s:a>
    <br>
    <s:a action="show_singleItem">单本书</s:a>
    <br>
    <s:a action="show_pay">支付测试页面</s:a>
    <br>
  </body>
</html>
