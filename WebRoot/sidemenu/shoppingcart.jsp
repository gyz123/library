<%@ page language="java" import="java.util.*" contentType="text/html; charset=utf-8"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
    <head lang = "en">
    <base href="<%=basePath%>">
	<meta charset="UTF-8">
	<meta name="viewport"content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <title>待借清单</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<link rel="stylesheet" href="css/weui.css" />
	<link rel="stylesheet" href="css/weui2.css" />
	<link rel="stylesheet" href="css/weui3.css" />
	<link rel="stylesheet" type="text/css" href="css/weuix.min.css">
	<link rel="stylesheet" href="css/reset.css">
	<link rel="stylesheet" href="css/animate.css">
	<link rel="stylesheet" href="css/jd_cart.css">
	
	<script src="js/jquery.js" charset="utf-8"></script>
	<script>
		var $j = jQuery.noConflict(); //自定义一个比较短的快捷方式
	</script>
	<script src="js/zepto.min.js"></script>
	<script src="js/qrcode.js"></script>
	<style type="text/css">
		#footer {
			position: absolute;
			bottom: 0;
			width: 100%;
			height: 60px; /*脚部的高度*/
			background: #6cf;
			clear:both;
		}
	</style>
	
	
	
  </head>

<body>
	<!--安全提示-->
	<div class="safety-tip">
		<p class="fadeInDown animated">
			请勾选您喜爱的书籍，点击<strong>生成二维码</strong>供管理员扫码
		</p>
	</div>

	<c:forEach var="booklist" items="${booklist}">
	<div class="jd_shop">
		<div class="jd_shop_con">
			<div class="product">
				<div class="check_box" >
					<div class="weui_cells weui_cells_checkbox" 
							style="margin-top:0px; ">
						<label class="weui_cell weui_check_label" for="${booklist.bookno }"
								style="margin-top:24px; margin-bottom:32px">
							<div class="weui_cell_hd">
								<input type="checkbox" class="weui_check" name="checkbox1"
									id="${booklist.bookno }" value="${booklist.bookno }"> 
								<i class="weui_icon_checked"></i>
							</div> 
						</label>
					</div>
				</div>
				<div class="shop_info clearfix" style="margin-left:22px; width:90%">
					<div class="img_box f_left">
						<img src="${booklist.bookimg }" style="width:56px;height:80px"  alt="">
					</div>
					<div class="info_box" style="padding-top:20px">
						<span class="p_name f20" style="padding-top:4px;margin-bottom:4px">${booklist.bookname } </span>
						<span class="p_price f14" style="margin-top:8px">预定金额： &yen;${booklist.price }</span>
						<div class="p_opition">
							<div class="delete_box f_right">
								<span class="delete_up"></span> 
								<span class="delete_down"></span>
								
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	</c:forEach>
	
	<div class="jd_win">
		<div class="jd_win_box">
			<div class="jd_win_tit">你确定删除该图书吗？</div>
			<div class="jd_btn clearfix">
				<a href="javascript:void(0);" class="cancle f_left">取消</a>
				<a href="javascript:void(0);" class="submit f_right">确定</a>
			</div>
		</div>
	</div>
	
	<c:if var="flag" test="${booklist[5].bookno == null }" scope="page">
	<section class="weui-menu">
		<div class="weui-menu-inner" >
			<a href="javascript:;" class="weui_btn weui_btn_default" id='getQRCode'> 
				<span style="margin-bottom:4%" >生成二维码</span> 
			</a>
		</div>
	</section>
	</c:if>

	<c:if var="flag" test="${booklist[5].bookno != null }" scope="page">
		<div style="height:49px"><
		<section class="weui-menu">
			<div class="weui-menu-inner">
				<a href="javascript:;" class="weui_btn weui_btn_default" id='getQRCode'> 
					<span >生成二维码</span>
				</a>
				<!-- <div id="qrcodeimg" class='tcenter'></div> -->
			</div>
		</section>
	</c:if>

	<!-- 弹框图 -->
	<div class="weui_msg_img hide" id='pop_up'>
		<div class="weui_msg_com">
			<div onclick="$('#pop_up').fadeOut();" class="weui_msg_close">
				<i class="icon icon-95"></i>
			</div>
			<div class="weui_msg_src" id="myqrcodeimg" style="padding:20px;">
			</div>
			<p class="f-blue">请出示此二维码给管理员</p>
		</div>
	</div>   
	
	<script>
		var QRCodetxt ="";//二维码内容
		var bookno = new Array();
		var noIndex = 0;
		var stop;
		
		$j(document).ready((function(){
			$j('#getQRCode').click(function(){
				console.log("方法触发了");
			
				$j('input:checkbox').each(function() { 
					if ($j(this).prop('checked')) { 
						bookno[noIndex++] = $j(this).val();
						//alert($j(this).val()); 
					} 
				}); 
				noIndex = 0;
				
				//异步请求生成订单
				$j.ajax({    
		            type:'post',        
		            url:'/library/generate_code.action',    //servlet名
		            data:"weid=" + "<%=request.getParameter("weid")%>"
		             + "&bookno1=" + bookno[0] 
		             + "&bookno2=" + bookno[1],   //参数 
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
            url:'/library/listen_status.action',    //servlet名
            data:"weid=" + "<%=request.getParameter("weid")%>",   //参数 
            cache:false,    
           // dataType:'json',    
            success:function(data){ 
            	//var obj = eval ("(" + data + ")");
            	console.log("回调成功");
            	if(count++ >= 20){
            		count = 1;
            		alert("二维码已经过期，请重新生成");
            		window.clearInterval(stop);//停止触发
            	}
            	if(data === "Y"){
            		window.clearInterval(stop);//停止触发
            		location.href = "/library/show_pay.action";//成功跳转确认订单
            	}
        		console.log(count);
            },
            error:function(){
            	console.log("回调失败");
            }    
        }); 
		}
	</script>
	
	<script>
	var that;
    $j('.delete_box').on('click',function(){
            $j(this).children('.delete_up').css(
                {
                    transition :'all 1s',
                    'transformOrigin':"0 5px" ,
                    transform :'rotate(-30deg) translateY(2px)'
                }

            );
            $j('.jd_win').show();
            that = $j(this);
    });

    $j('.cancle').on('click',function(){
        $j('.jd_win').hide();
        $j('.delete_up').css('transform','none');
        return;
    });
    
    $j('.submit').on('click',function(){
        //异步提交到后台进行删除
        var booknum =  that.find("span.booknum").html();//获取子元素span标签下clas为booknum的值
        
        $j.ajax({    
            type:'post',        
            url:'/library/show_shoppingcart_delete.action',    //servlet名
            data:"weid=" + "<%=request.getParameter("weid") %>" + "&bookno=" + booknum,   //参数 
            cache:false,    
            //dataType:'json',    
            success:function(data){ 
            	console.log(booknum);
            	alert(booknum + "删除成功");
            	that.parent().parent().parent().parent().remove(); //删除节点
        		$j('.jd_win').hide();
            }    
        }); 
           
    });
	</script>

<script type="text/javascript">
	$j(document).ready(function() { 
		$j('input[type=checkbox]').click(function() {
			if ($j("input[name=checkbox1]:checked").length > 2){
      			//最多可以选择2个 
      			$j.toast("最多借两本哦！", "cancel");
				return false;
			}
      		return true; 
      	}); 
	});
</script>

</body>
</html>
