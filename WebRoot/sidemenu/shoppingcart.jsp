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
	<script src="js/zepto.min.js"></script>
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
	<script src="js/qrcode.js"></script>
	
	
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
									id="${booklist.bookno }" > 
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
								<span class="booknum" style="display:none;">${booklist.bookno }</span>
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
			<a href="javascript:void(0);"> <span style="margin-bottom:4%">生成二维码</span> </a>
		</div>
	</section>
	</c:if>

	<c:if var="flag" test="${booklist[5].bookno != null }" scope="page">
		<div style="height:49px"><
		<section class="weui-menu">
			<div class="weui-menu-inner">
				<a href="javascript:void(0);" id='qr'> 
					<span>生成二维码</span>
				</a>
				<div id="qrcodeimg" class='tcenter'></div>
			</div>
		</section>
	</c:if>
	
	<script>
		var txt = "BEGIN:VCARD\r\nVERSION:3.0\r\nN:太白\r\nFN:李\r\nTITLE:工程师\r\nNICKNAME:昵称\r\nTEL;CELL;VOICE:移动18291448888\r\nTEL;WORK;VOICE:工作电话18291449999\r\nORG:组织机构\r\nEMAIL;PREF;INTERNET:logove@qq.com\r\nADR;TYPE=WORK:;;具体地址;汉中;陕西省;2324200;中国\r\nADR;TYPE=HOME:;;具体地址;汉中;陕西省;2324200;中国\r\nNOTE;ENCODING=QUOTED-PRINTABLE:备注来自名片通讯录\r\nEND:VCARD";
		$("#qr").click(function() {
			$("#qrcodeimg").empty().qrcode({
				render : "image",
				ecLevel : "L",
				size : 300,
				background : "#fff",
				fill : "#000",
				text : txt
			});
		});
	</script>
	
	
	<script>
	var that;
    $('.delete_box').on('click',function(){
            $(this).children('.delete_up').css(
                {
                    transition :'all 1s',
                    'transformOrigin':"0 5px" ,
                    transform :'rotate(-30deg) translateY(2px)'
                }

            );
            $('.jd_win').show();
            that = $(this);
    });

    $('.cancle').on('click',function(){
        $('.jd_win').hide();
        $('.delete_up').css('transform','none');
        return;
    });
    
    $('.submit').on('click',function(){
        //异步提交到后台进行删除
        var booknum =  that.find("span.booknum").html();//获取子元素span标签下clas为booknum的值
        
        $.ajax({    
            type:'post',        
            url:'/library/show_shoppingcart_delete.action',    //servlet名
            data:"weid=" + "<%=request.getParameter("weid") %>" + "&bookno=" + booknum,   //参数 
            cache:false,    
            //dataType:'json',    
            success:function(data){ 
            	console.log(booknum);
            	alert(booknum + "删除成功");
            	that.parent().parent().parent().parent().remove(); //删除节点
        		$('.jd_win').hide();
            }    
        }); 
           
    });
	</script>

<script type="text/javascript">
	$(document).ready(function() { 
		$('input[type=checkbox]').click(function() {
			if ($("input[name=checkbox1]:checked").length > 2){
      			//最多可以选择2个 
      			$.toast("最多借两本哦！", "cancel");
				return false;
			}
      		return true; 
      	}); 
	}) 
</script>

</body>
</html>
