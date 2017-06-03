<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>书籍详情</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">

<script src="js/zepto.min.js"></script>
<script src="js/lazyimg.js"></script>
<script>
  $(function(){
  var lazyloadImg = new LazyloadImg({
            el: '.weui-updown [data-src]', //匹配元素
            top: 50, //元素在顶部伸出长度触发加载机制
            right: 50, //元素在右边伸出长度触发加载机制
            bottom: 50, //元素在底部伸出长度触发加载机制
            left: 50, //元素在左边伸出长度触发加载机制
            qriginal: false, // true，自动将图片剪切成默认图片的宽高；false显示图片真实宽高
            load: function(el) {
                el.style.cssText += '-webkit-animation: fadeIn 01s ease 0.2s 1 both;animation: fadeIn 1s ease 0.2s 1 both;';
            },
            error: function(el) {

            }
        });
	  });    
</script>     

<script>
	$(function() {
		//定义文本
		const
		paragraph = $('#paragraph');
		const
		paragraphText = paragraph.text();
		const
		paragraphLength = paragraph.text().length;
		//定义文章长度
		const
		maxParagraphLength = 80;
		//定义全文按钮
		const
		paragraphExtender = $('#paragraphExtender');
		var toggleFullParagraph = false;

		//定义全文按钮
		if (paragraphLength < maxParagraphLength) {
			paragraphExtender.hide();
		} else {
			paragraph.html(paragraphText.substring(0, maxParagraphLength)
					+ '...');
			paragraphExtender.click(function() {
				if (toggleFullParagraph) {
					toggleFullParagraph = false;
					paragraphExtender.html('↓'); // 收缩时显示的提示文字
					paragraph.html(paragraphText.substring(0,
							maxParagraphLength)
							+ '...');
				} else {
					toggleFullParagraph = true;
					paragraphExtender.html('↑');  // 展开时显示的提示文字
					paragraph.html(paragraphText);
				}
			});
		}
		;
		const
		menu = $('#actionMenu');
		const
		menuBtn = $('#actionToggle');
		menuBtn.click(function() {
			menu.toggleClass('active')
		});
	});
	
</script>
<script>
	$(function() {
		$('.weui-menu-inner')
				.click(
						function() {
							var $menu = $(this).find('ul'), height = $menu
									.find('li').length
									* 40 + 15 + 'px', opacity = $menu
									.css('opacity');

							$('.weui-menu-inner ul').css({
								'top' : '0',
								'opacity' : '0'
							});

							if (opacity == 0) {
								$menu.css({
									'top' : '-' + height,
									'opacity' : 1
								});
							} else {
								$menu.css({
									'top' : 0,
									'opacity' : 0
								});
							}
						});

	});
</script>

<script>
		$(document).on("click", "#reserveSuccess", function() {
			$.toast("预定成功");
			
			//location.href = "/library/show_main.action";
		});
</script>

<script>
		$(document).on("click", "#addSuccess", function() {
			$.toast("已加入购物车");
			
			//location.href = "/library/show_main.action";
		});
</script>

<script>
	
</script>

</head>

<body ontouchstart style="background-color: #ffffff;">

	<a href="/library/show_main.action">
	<div class="weui-header bg-blue" style="height:56px;background-color:#01164b">
		<div class="weui-header-left">
		</div>
		<h1 class="weui-header-title" style="margin-top:5px">
			<span class="">超新星智能图书馆</span>
		</h1>
	</div>
	</a>

	<div style="height:16px;width:100%"></div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<img	
			src="${book.bookimg }"
			alt="" style="width:96px;margin-left:4px;display:block">
		</div>
		<div class="weui_cell_bd weui_cell_primary" style="margin-left:16px">
			<span class="f24" >${book.bookname }</span>
			<br><hr style="color:gray;width:100%;size:1px"><br>
			<span class="f16" style="margin-left:4px">分类：${book.category }
					<br><br>&nbsp;出版社：${book.publisher }
					<br><br>&nbsp;版本：${book.version }
					<br><br>&nbsp;剩余量：${book.leftnum }</span><br>
		</div>
	</div>

	<div style="height:16px;width:100%;background-color:#f8f8f8"></div>

	<div class="weui_cell">
		<div class="weui_cell_bd weui_cell_primary" style="margin-top:8px">
			<span class="f16" style="margin-left:8px">
				简介<br>
				<div style="margin-top:8px"></div><span class="f14">${book.bookAbstract }</span></div>
			</span>
		</div>
	</div>

	<div class="weui_cells weui_cells_access" style="margin-top:8px">
		<a class="weui_cell " href="" style="height:24px">
			<div class="weui_cell_bd weui_cell_primary">
				<span class="f16" style="margin-left:8px">目录</span>
			</div>
			<div class="weui_cell_ft">
				<span class="f16 f-gray">点此查看</span>
			</div> </a>
	</div>

	<div style="height:16px;width:100%;background-color:#f8f8f8"></div>
	<div style="height:24px;width:100%;margin-left:24px;padding-top:12px">
		<span class="f16">导读</span>
	</div>
	<div class="weui_cell" >
		<span style="margin-left:8px">
		<p id="paragraph" class="paragraph">
			${book.guide }
		</p>
		</span>
		<!-- 伸张链接 -->
		<a id="paragraphExtender" class="paragraphExtender" style="position:relative; top:40px; ">↓</a>
	</div>

	<div style="height:16px;width:100%;background-color:#f8f8f8"></div>
	
	<div style="height:24px;width:100%;margin-left:16px;padding-top:12px">
		<span class="f16">相关推荐</span>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd" style="width:45%;text-align:center">
			<img	
			src="${book.bookimg }"
			alt="" style="width:60%;margin-left:4px;display:block;padding-left:25%;padding-bottom:8px">
			<span style="margin-top:8px"><p>${book.bookname }</p></span>
		</div>
		<div class="weui_cell_hd" style="width:45%;text-align:center">
			<img	
			src="${book.bookimg }"
			alt="" style="width:60%;margin-left:4px;display:block;padding-left:25%;padding-bottom:8px">
			<span><p>${book.bookname }</p></span>
		</div>
	</div>
	
	<div style="height:51px"></div>
	
	<c:if var="flag" test="${book.leftnum > 0 }" scope="page">
	<section class="weui-menu" style="">
        <div class="weui-menu-inner" >
            <a href="javascript:;" style="display:block;padding-top:12px" id="reserveSuccess">
            	我要预定
            </a>
        </div>
        <div class="weui-menu-inner" >
            <a href="javascript:;" style="display:block;padding-top:12px" id="addSuccess">
            	加入购物车
            </a>
        </div>
    </section>
	</c:if>
	
	<c:if var="flag" test="${book.leftnum == 0 }" scope="page">
	<section class="weui-menu" style="">
        <div class="weui-menu-inner" >
            <a href="javascript:;" style="display:block;padding-top:12px" id="reserveSuccess">
            	我要预定
            </a>
        </div>
    </section>
	</c:if>



</body>
</html>
