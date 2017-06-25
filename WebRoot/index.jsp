<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport"content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
	<title>触摸测试</title>
	<link rel="stylesheet" type="text/css" href="css/icon.css">
	<script type="text/javascript" src="js/jquery-3.1.1.min.js"></script>
	<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
</head>
<body>
	<!--解决微信长按复制问题-->
	<button id="talk_btn" ontouchstart = "return false;"><i class="icon icon-44"></i></button>
</body>
<script type="text/javascript">

    //步骤三：通过config接口注入权限验证配置
    wx.config({
    	debug: false,
    	appId: '<%=request.getAttribute("appId")%>',
    	timestamp: '<%=request.getAttribute("timeStamp")%>',
    	nonceStr: '<%=request.getAttribute("nonceStr")%>',
    	signature: '<%=request.getAttribute("signature")%>',
    	jsApiList: [
    	'checkJsApi',
    	'onMenuShareTimeline',
    	'onMenuShareAppMessage',
    	'onMenuShareQQ',
    	'onMenuShareWeibo',
    	'hideMenuItems',
    	'showMenuItems',
    	'hideAllNonBaseMenuItem',
    	'showAllNonBaseMenuItem',
    	'translateVoice',
    	'startRecord',
    	'stopRecord',
    	'onRecordEnd',
    	'playVoice',
    	'pauseVoice',
    	'stopVoice',
    	'uploadVoice',
    	'downloadVoice',
    	'chooseImage',
    	'previewImage',
    	'uploadImage',
    	'downloadImage',
    	'getNetworkType',
    	'openLocation',
    	'getLocation',
    	'hideOptionMenu',
    	'showOptionMenu',
    	'closeWindow',
    	'scanQRCode',
    	'chooseWXPay',
    	'openProductSpecificView',
    	'addCard',
    	'chooseCard',
    	'openCard'
    	]
    });
</script>

<script type="text/javascript">
	//步骤四：通过ready接口处理成功验证
	wx.ready(function() {


				// 3 智能接口
		var voice = {
			localId : '',
			serverId : ''
		};

		$('#talk_btn').on('touchstart', function(event){
			console.log("手指按下了");
			event.preventDefault();
			START = new Date().getTime();

			recordTimer = setTimeout(function(){
				wx.startRecord({
					success: function(){
						localStorage.rainAllowRecord = 'true';
					},
					cancel: function () {
						alert('用户拒绝授权录音');
					}
				});
			},300);
		});

		$('#talk_btn').on('touchend', function(event){
			console.log("手指松开了");
			event.preventDefault();
			END = new Date().getTime();

			if((END - START) < 300){
				END = 0;
				START = 0;
        	//小于300ms，不录音
        	clearTimeout(recordTimer);
        }else{
        	wx.stopRecord({
        		success: function (res) {
        			voice.localId = res.localId;
        			if (voice.localId == '') {
        				alert('请先使用 startRecord 接口录制一段声音');
        				return;
        			}
        			wx.translateVoice({
        				localId : voice.localId,
        				complete : function(res) {
        					if (res.hasOwnProperty('translateResult')) {
        						alert('识别结果：' + res.translateResult);
        					} else {
        						alert('无法识别');
        					}
        				}
        			});
        			//uploadVoice();
        		},
        		fail: function (res) {
        			alert(JSON.stringify(res));
        		}
        	});
        }
        alert("手指松开了");
    });

});

	wx.error(function(res) {
		alert(res.errMsg);
	});
</script>

</html>