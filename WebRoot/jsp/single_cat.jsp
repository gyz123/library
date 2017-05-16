<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>单类书籍</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">
</head>

<body>
	category:<%=request.getParameter("id") %><br/>
	pageNum:<%=request.getParameter("pagenum") %><br/>
	EL:${booklist[0].bookname }<br/>
	<%-- 使用EL和S标签均可以从列表中获取到数据，
			如：${booklist[0].bookname} 
			和   <s:property value="#booklist[3].bookname"/>
		如果是对列表进行操作，必须加#号；普通参数可以不加 --%>
	<br/>
</body>
</html>
