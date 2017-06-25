<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>扫一扫</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">

<script src="js/zepto.min.js"></script>
<script src="js/jquery-1.11.3.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
<link rel="stylesheet" 	href="http://demo.open.weixin.qq.com/jssdk/css/style.css?ts=1420774989">
</head>
  
<body>
	<div class="wxapi_container">
		<div class="lbox_close wxapi_form" style="margin-top:0px">
			<div>
				<span class="f18">微信扫一扫</span>
			</div>
			<button class="btn btn_primary" id="scanQRCode1">scanQRCode(直接返回结果)</button>
		</div>
	</div>
</body>

<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>
 
  wx.config({
      debug: false,
      appId: '<%=request.getAttribute("appId")%>',
      timestamp: <%=request.getAttribute("timeStamp")%>,
      nonceStr: '<%=request.getAttribute("nonceStr")%>',
      signature: '<%=request.getAttribute("signature")%>',
      jsApiList: [
        'scanQRCode',
      ]
  });
</script>
<script> 
	wx.ready(function() {
		// 直接跳转
		document.querySelector('#scanQRCode0').onclick = function() {
			wx.scanQRCode();
		};
		
		// 需要处理
		var QRCodetxt ="";
		document.querySelector('#scanQRCode1').onclick = function() {
			wx.scanQRCode({
				needResult : 1,
				desc : 'scanQRCode desc',
				success : function(res) {
					// alert(JSON.stringify(res));
					QRCodetxt = JSON.stringify(res);
					location.href = "/library/verify_code.action?QRCodetxt=" + QRCodetxt;
				}
			});
		};

		var shareData = {
			title : '微信JS-SDK Demo',
			desc : '微信JS-SDK,帮助第三方为用户提供更优质的移动web服务',
			link : 'http://demo.open.weixin.qq.com/jssdk/',
			imgUrl : 'http://mmbiz.qpic.cn/mmbiz/icTdbqWNOwNRt8Qia4lv7k3M9J1SKqKCImxJCt7j9rHYicKDI45jRPBxdzdyREWnk0ia0N5TMnMfth7SdxtzMvVgXg/0'
		};
		wx.onMenuShareAppMessage(shareData);
		wx.onMenuShareTimeline(shareData);
	});

	wx.error(function(res) {
		alert(res.errMsg);
	});
</script>
</html>
