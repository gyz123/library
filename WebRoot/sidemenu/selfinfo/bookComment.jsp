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
<script type="text/javascript">
function upDownOperation(element)
{
    var _input = element.parent().find('input'),
        _value = _input.val(),
        _step = _input.attr('data-step') || 1;
    //检测当前操作的元素是否有disabled，有则去除
    element.hasClass('disabled') && element.removeClass('disabled');
    //检测当前操作的元素是否是操作的添加按钮（.input-num-up）‘是’ 则为加操作，‘否’ 则为减操作
    if ( element.hasClass('weui-number-plus') )
    {
        var _new_value = parseInt( parseFloat(_value) + parseFloat(_step) ),
            _max = _input.attr('data-max') || false,
            _down = element.parent().find('.weui-number-sub');
        
        //若执行‘加’操作且‘减’按钮存在class='disabled'的话，则移除‘减’操作按钮的class 'disabled'
        _down.hasClass('disabled') && _down.removeClass('disabled');
        if (_max && _new_value >= _max) {
            _new_value = _max;
            element.addClass('disabled');
        }
    } else {
        var _new_value = parseInt( parseFloat(_value) - parseFloat(_step) ),
            _min = _input.attr('data-min') || false,
            _up = element.parent().find('.weui-number-plus');
        //若执行‘减’操作且‘加’按钮存在class='disabled'的话，则移除‘加’操作按钮的class 'disabled'
        _up.hasClass('disabled') && _up.removeClass('disabled');
        if (_min && _new_value <= _min) {
            _new_value = _min;
            element.addClass('disabled');
        }
    }
    _input.val( _new_value );
}
  
     
$(function(){
$('.weui-number-plus').click(function(){
    upDownOperation( $(this) );
});
$('.weui-number-sub').click(function(){
    upDownOperation( $(this) );
});

//评分js
var arr = ["2分","4分","6分","8分","10分"];
var num = -1;
$(".weui-rater a").mouseover(function(){
	var thisL = $(this).index();
	for(var i = 0;i < thisL;i++){
		$(".weui-rater a").eq(i).addClass('checked');
	}
	for(var i = thisL; i < 5;i++){
		$(".weui-rater a").eq(i).removeClass('checked');
	}
	$(this).addClass('checked');
});
$(".weui-rater a").mouseout(function(){
	var thisL = $(this).index();
	for(var i = thisL; i < 5;i++){
		$(".weui-rater a").eq(i).removeClass('checked');
	}
});
$(".weui-rater").mouseout(function(){
	
	for(var i = 0; i < num;i++){
		$(".weui-rater a").eq(i).addClass('checked');
	}
});
$(".weui-rater a").click(function(){
	var thisL = $(this).index();
	$("#fen").html(arr[thisL]);
	$(this).addClass('checked');
	num = thisL+1;
	console.log(num);
});

});  
</script>
  </head>
  
  <body ontouchstart style="background-color: #ffffff;">
  	<div class="weui-header bg-blue" style="height:56px;background-color:#01164b">
		<div class="weui-header-left" style="margin-top:6px;">
			<a class="icon icon-109 f-white" 
				href="/library/show_mylibrary.action?weid=${weid }">&nbsp;&nbsp;&nbsp;</a>
		</div>
		<h1 class="weui-header-title" style="margin-top:16px">
			<span class="f20">阅读评价</span>
		</h1>
	</div>
	
	
	<div class="weui_cell"  style="padding-left:20%">
		<div class="weui_cell_hd">
			<img src="${book.bookimg}" alt=""
				style="width:64px;display:block;margin-right:24px">
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<span class="f24">${book.bookname}</span> <br>
			<div style="margin-top:16px">
				<span class="f14">作者：${book.author}</span>
			</div>
		</div> 
	</div>
	

	<div class="weui_cell" style="height:30px; width:100%">
		<div class="weui_cell_bd " style="margin-top:2px; width:80px">
			<span class="f18" style="margin-left:8px">
				<div style="margin-top:0px; padding-left:8px;">
				<span class="f18">评分</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</div>
			</span>
		</div>
			<div class="page_hd" style="height:25px">
 				<div class="weui-rater">
  					<a data-num = "0" class="weui-rater-box"> <span class="weui-rater-inner">★</span> </a>
  					<a data-num = "1" class="weui-rater-box"> <span class="weui-rater-inner">★</span> </a>
  					<a data-num = "2" class="weui-rater-box"> <span class="weui-rater-inner">★</span> </a>
  					<a data-num = "3" class="weui-rater-box"> <span class="weui-rater-inner">★</span> </a>
  					<a data-num = "4" class="weui-rater-box"> <span class="weui-rater-inner">★</span> </a>
  					</div>
				<div id='fen' class="weui_cells_title" 
						style="margin-top:2px;margin-left:4px;float:right"></div>
			</div>
	</div>

	<div class="weui_cells weui_cells_form" style="padding-left:8px;margin-top:4px">
        <div class="weui_cell">
            <div class="weui_cell_bd weui_cell_primary">
                <textarea id="textarea" class="weui_textarea" placeholder="阅读感想" rows="3"></textarea>
                <div class="weui_textarea_counter"><span id='count'>0</span>/<span id='count_max'>200</span></div>
            </div>
        </div>
    </div>
	<script>
	$(function(){
  		var max = $('#count_max').text();
  		$('#textarea').on('input', function(){
    		 var text = $(this).val();
     		 var len = text.length;   
    		 $('#count').text(len);    
    		 if(len > max){
    	     $(this).closest('.weui_cell').addClass('weui_cell_warn');
    		 }
     		 else{
      		 $(this).closest('.weui_cell').removeClass('weui_cell_warn');
     	}     
  	});
	})
	</script>       
	
	
	<div class="weui_btn_area">
        <a id="showToast" class="weui_btn weui_btn_primary" href="javascript:;">提交</a>
    </div>
	
	<script>
	$(document).on("click", "#showToast", function() {
        $.toast("提交成功");
      }); 
	</script>
	
	<script>
	$(document).ready(function(){
		$("#showToast").click(function() {
			console.log("点击了");
			var text = $("#textarea").val();
			var score = $("#fen").val();
			$.ajax({
				type : 'post',
				url : '/library/submit_comment.action', 
				data : {
					fen : score,
					comment : text,
					weid : "<%=request.getSession().getAttribute("weid")%>" ,
					bookno : "<%=request.getSession().getAttribute("commentbookno")%>"
				}, //参数 
				cache : false,
				dataType : 'json',
				success : function(data) {
					console.log("回调成功");
					window.location.href="/library/enter_history.action?weid=<%=request.getSession().getAttribute("weid")%>";
				},
				error : function() {
					console.log("回调失败");
					window.location.href="/library/enter_history.action?weid=<%=request.getSession().getAttribute("weid")%>";
				}
	
			});
		});
	});
</script>

	
	
  </body>
</html>
