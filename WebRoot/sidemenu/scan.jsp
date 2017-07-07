<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="utf-8">
<title>扫一扫</title>
<meta name="viewport"
	content="width=device-width, initial-scale=1, user-scalable=0">
<link rel="stylesheet"
	href="http://demo.open.weixin.qq.com/jssdk/css/style.css?ts=1420774989">
</head>

<body style="background-color:#ffffff">
	<div class="wxapi_container">
		
		<div class="lbox_close wxapi_form">
			<h3 id="menu-basic" style="display:none">基础接口</h3>
			<button class="btn btn_primary" id="checkJsApi" style="display:none">checkJsApi</button>

			<h3 id="menu-scan" style="display:none">微信扫一扫</h3>
			<div style="margin-top:24px;margin-bottom:16px">
				<span class="f16" style="margin-left:16px">
					悄悄告诉你~<br>&nbsp;&nbsp;&nbsp;&nbsp;扫描书后的二维码可以直接加入购物车哦
				</span>
			</div>
			<button class="btn btn_primary" id="scanQRCode0" style="display:none">scanQRCode(微信处理结果)</button>
			<button class="btn btn_primary" id="scanQRCode1">扫一扫</button>

		</div>
	</div>
</body>
<script type="text/javascript" src="js/jquery-3.1.1.min.js"></script>
<script>
	var $j = jQuery.noConflict(); //自定义一个比较短的快捷方式
</script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>

  
  $j(document).ready((function(){
			//异步请求jsapi
				$j.ajax({    
		            type:'post',        
		            url:'/library/get_jssdk.action',    //servlet名
		            data:"url=" + encodeURIComponent(location.href.split('#')[0]),  //参数 
		            cache:false,    
		            //dataType:'json',
		            success:function(data){
		        	
						var jsonObj = jQuery.parseJSON(data);//将json字符串解析成json对象
						console.log(jsonObj[0].url)
						//验证
						wx.config({
					    	debug: false,
					    	appId: jsonObj[0].appid,
					    	timestamp: jsonObj[0].timestamp,
					    	nonceStr: jsonObj[0].nonceStr,
					    	signature: jsonObj[0].signature,
					    	jsApiList: [
						        'checkJsApi',
						        'scanQRCode',
						      ]
					    });
 					},
 					error:function(){
 						console.log("ajax请求失败");
 					}
		        }); 

		})    
	);
</script>
<script> 

//步骤四：通过ready接口处理成功验证
	wx.ready(function() {
		// 1 判断当前版本是否支持指定 JS 接口，支持批量判断
		document.querySelector('#checkJsApi').onclick = function() {
			wx.checkJsApi({
				jsApiList : [ 'getNetworkType', 'previewImage' ],
				success : function(res) {
					alert(JSON.stringify(res));
				}
			});
		};

		// 9 微信原生接口
		// 9.1.1 扫描二维码并返回结果
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
					//alert(JSON.stringify(res));  EAN_13,9787 EAN_1
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
