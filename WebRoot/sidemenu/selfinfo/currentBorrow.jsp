<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
	<title>个人中心</title>

	<link rel="stylesheet" href="css/weui.css" />
	<link rel="stylesheet" href="css/weui2.css" />
	<link rel="stylesheet" href="css/weui3.css" />
	<link rel="stylesheet" type="text/css" href="css/weuix.min.css">
	
<script src="js/zepto.min.js"></script>
<script src="js/jquery-3.1.1.min.js"></script>
  <script>
		var $j = jQuery.noConflict(); //自定义一个比较短的快捷方式
	</script>

  </head>
  
  <body ontouchstart style="background-color: #ffffff;">
  	<div class="weui-header bg-blue" style="height:56px;background-color:#01164b">
		<div class="weui-header-left" style="margin-top:6px;">
			<a class="icon icon-109 f-white" 
				href="/library/show_mylibrary.action?weid=${weid }">&nbsp;&nbsp;&nbsp;</a>
		</div>
		<h1 class="weui-header-title" style="margin-top:16px">
			<span class="f20">当前借阅</span>
		</h1>
	</div>
  
    <div class="weui_cells " >
		<c:forEach  var="booklist" items="${booklist}">
			<div class="weui_cell">
				<div class="weui_cell_hd">
					<img src="${booklist.bookimg}" alt=""
						style="width:64px;display:block;margin-right:24px">
				</div>
				<div class="weui_cell_bd weui_cell_primary">
					<div>
					<span class="f24">${booklist.bookname}</span> 
					<span style="float:right;margin-right:4px;margin-top:8px"
							class="f16 f-gray" >剩余${booklist.leftTime}天</span>
					</div>
					<div style="margin-top:20px">
						<span class="f14">作者：${booklist.author}</span>
						<div class="return" style="float:right;margin-right:4px" value="${booklist.bookno }">
							<span class="f16 f-blue" >归还</span>
						</div>
						<div class="continue" style="float:right;margin-right:12px" value="${booklist.bookno }">
							<span class="f16 f-blue">续借</span>
						</div>
					</div>
				</div> 
			</div>
		</c:forEach>
	</div>

	
	<!-- 弹框图 -->
	<div class="weui_msg_img hide" id='pop_up'>
		<div class="weui_msg_com">
			<div onclick="$('#pop_up').fadeOut();window.clearInterval(stop);" class="weui_msg_close">
				<i class="icon icon-95"></i>
			</div>
			<div class="weui_msg_src" id="myqrcodeimg" style="padding:20px;">
			</div>
			<p class="f-blue f15">请出示此二维码给管理员</p>
		</div>
	</div>   
	
	<script src="js/zepto.min.js"></script>
	<script src="js/qrcode.js"></script>
	<script>
		var QRCodetxt ="";//二维码内容
		var stop;
		
		//continue_reading
		$j(document).ready((function(){
			$j('.continue').click(function(){
				console.log("continue方法触发了");
				bookno = $(this).attr("value");
				console.log(bookno);
				
				//异步请求生成订单
				$j.ajax({    
		            type:'post',        
		            url:'/library/continue_reading.action',    //servlet名
		            data:"bookno=" + bookno,
		            cache:false,    
		            //dataType:'json',
		            success:function(data){
		        		alert("续借成功");
		        		location.reload();//刷新页面
 					},
 					error:function(data){
 						alert("续借失败");
 					}
		        });
		        
			});
			
			$j('.return').click(function(){
				console.log("return方法触发了");
				bookno = $(this).attr("value");
				console.log(bookno);
				
				//异步请求生成还书二维码
				$j.ajax({    
		            type:'post',        
		            url:'/library/generate_return_code.action',    //servlet名
		            data:"bookno=" + bookno,
		            cache:false,    
		            //dataType:'json',
		            success:function(data){
		        		
		        		QRCodetxt = data;
		        		console.log(QRCodetxt);
		        		//jQuery.noConflict(); //将变量$的控制权转让
		        		//弹窗显示二维码
		        		$(function(){
							$('#pop_up').fadeIn();
							$("#myqrcodeimg").empty().qrcode({
								render:"image",
								ecLevel:"L",
								size:300,
								background:"#fff",
								fill:"#000",
								text:QRCodetxt
							});
			            });
 						stop =  setInterval(monitor,3000);//返回值为停止定时器的参数
 					}
		        });
				
			});
		})    
	);
		
	</script>
	
	<script>
		//定时触发监听器
		// ************此处有问题，不应该用session（数据时效性滞后）
		var count = 1;
		function monitor(){
			$j.ajax({    
            type:'post',        
            url:'/library/listen_return_status.action',    //servlet名
            data:"weid=" + "<%=request.getParameter("weid")%>" +
            "&bookno=" + bookno ,   //参数 
            
            cache:false,    
           // dataType:'json',    
            success:function(data){ 
            	//var obj = eval ("(" + data + ")");
            	console.log("回调成功");
            	if(count++ >= 20){
            		count = 1;
            		alert("二维码已经过期，请重新生成");
            		window.clearInterval(stop); //停止触发
            	}
            	if(data === "Y"){
            		window.clearInterval(stop); //停止触发
            		location.href = "/library/return_success.action"; //成功跳转确认订单
            	}
            	if(count === 7){
            		window.clearInterval(stop); //停止触发
            		location.href = "/library/return_success.action"; //成功跳转确认订单
            	}
        		console.log(count);
            },
            error:function(){
            	console.log("回调失败");
            }    
        }); 
		}
	</script>
		
  </body>
</html>
