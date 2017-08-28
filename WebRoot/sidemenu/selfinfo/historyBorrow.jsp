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
var arr = ["1分","2分","3分","4分","5分"];
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
})
$(".weui-rater a").mouseout(function(){
	var thisL = $(this).index();
	for(var i = thisL; i < 5;i++){
		$(".weui-rater a").eq(i).removeClass('checked');
	}
})
$(".weui-rater").mouseout(function(){
	
	for(var i = 0; i < num;i++){
		$(".weui-rater a").eq(i).addClass('checked');
	}
})
$(".weui-rater a").click(function(){
	var thisL = $(this).index();
	$("#fen").html(arr[thisL]);
	$(this).addClass('checked');
	num = thisL+1;
	console.log(num);
})

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
			<span class="f20">历史记录</span>
		</h1>
	</div>
  
     <div class="weui_cells weui_cells_access" >
		<c:forEach  var="booklist" items="${booklist}">
			<a class="weui_cell"  href="/library/show_singleItem.action?bookno=${booklist.bookno }&weid=${weid }">
				<div class="weui_cell_hd">
					<img src="${booklist.bookimg}" alt=""
						style="width:64px;display:block;margin-right:24px">
				</div>
				<div class="weui_cell_bd weui_cell_primary">
					<span class="f24">${booklist.bookname}</span> <br>
					<div style="margin-top:16px">
						<span class="f14">作者：${booklist.author}</span>
					</div>
				</div> 
				<!--  
				<div class="page_hd">
 					<div class="weui-rater">
  					<a data-num = "0" class="weui-rater-box"> <span class="weui-rater-inner">★</span> </a>
  					<a data-num = "1" class="weui-rater-box"> <span class="weui-rater-inner">★</span> </a>
  					<a data-num = "2" class="weui-rater-box"> <span class="weui-rater-inner">★</span> </a>
  					<a data-num = "3" class="weui-rater-box"> <span class="weui-rater-inner">★</span> </a>
  					<a data-num = "4" class="weui-rater-box"> <span class="weui-rater-inner">★</span> </a>
  				 	</div>
					<div id='fen' class="weui_cells_title"></div>
				</div>
				-->
			</a>
		</c:forEach>
	</div>

  </body>
</html>
