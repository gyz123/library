<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>支付</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">

<script type="text/javascript" src="js/jquery-1.11.3.js">
</script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js">
</script>

</head>
  
  <body ontouchstart style="background-color: #f8f8f8;">
  	<input type="hidden" value="" id="userid" />
  	
  	<div style="height:16px;width:100%"></div>

	<span class="weui-media-title f22" 
				style="margin-left:16px;">订单详情</span>
	<div class="weui-form-preview" style="margin-top:12px">
		<div class="weui-form-preview-hd">
			<label class="weui-form-preview-label">应付押金</label> 
			<em class="weui-form-preview-value">${booklist[0].price + booklist[1].price }</em>
		</div>
		<div class="weui-form-preview-bd">
			<p>
				<label class="weui-form-preview-label">借书清单</label>
				<c:forEach  var="booklist" items="${booklist }">
					<span class="weui-form-preview-value" style="margin-left:24px" >
						《${booklist.bookname }》
					</span>
				</c:forEach>
			</p>
			<div style="margin-top:8px">
			<p>
				<label class="weui-form-preview-label">借阅人</label> <span
					class="weui-form-preview-value">${user.realName }</span><br>
			</p>
			</div>
			<div style="margin-top:8px">
			<p>
				<label class="weui-form-preview-label">借书时间</label> <span
					class="weui-form-preview-value">${date }</span>
			</p>
			</div>
			
		</div>
		<div class="weui-form-preview-ft">
			<a class="weui-form-preview-btn weui-form-preview-btn-primary"
				href="javascript:" id="test" name="ajaxLoadId">确认订单</a>
		</div>
	</div>
	
	<%-- 支付测试按钮  
	<a class="weui-form-preview-btn weui-form-preview-btn-primary"
				href="/library/set_order.action">确认订单</a>

	<form action="" method="post" >  
        <input type="button" value="确认支付" name="ajaxLoadId" id="test"/>  
    </form>  
    --%>
    
    <script type="text/javascript">  
    var basePath = "<%=basePath%>";  
    var openid = "<%=request.getParameter("openid")%>";
					$("#test")
							.one(
									"click",
									function() {
										$
												.ajax(
														{
															url : basePath
																	+ "post_param.action"
														//<span style="font-family:微软雅黑;">ajax调用微信统一接口获取prepayId</span>  
														//url:"http://localhost:8080/library/post_param.action"
														})
												.done(
														function(data) {
															var obj = eval('('
																	+ data
																	+ ')');
															alert("获取到obj:"
																	+ obj.appId);
															if (parseInt(obj.agent) < 5) {
																alert("您的微信版本低于5.0无法使用微信支付");
																return;
															}
															WeixinJSBridge
																	.invoke(
																			'getBrandWCPayRequest',
																			{
																				"appId" : obj.appId, //公众号名称，由商户传入  
																				"timeStamp" : obj.timeStamp, //时间戳，自 1970 年以来的秒数  
																				"nonceStr" : obj.nonceStr, //随机串  
																				"package" : obj.packageValue, //<span style="font-family:微软雅黑;">商品包信息</span>  
																				"signType" : obj.signType, //微信签名方式:  
																				"paySign" : obj.paySign
																			//微信签名  
																			},
																			function(
																					res) {
																				alert(res.err_msg);
																				if (res.err_msg == "get_brand_wcpay_request:ok") {
																					// 支付成功
																					window.location.href = obj.sendUrl;
																				} else {
																					// 支付失败
																					alert("fail");
																					window.location.href = "/library/regFailure.action";
																					//<span style="font-family:微软雅黑;">当失败后，继续跳转该支付页面让用户可以继续付款，贴别注意不能直接调转jsp，</span><span style="font-size:10.5pt">不然会报</span><span style="font-size:12.0pt"> system:access_denied。</span>  
																				}
																			});

														});
									});
				</script>  
  </body>
</html>
