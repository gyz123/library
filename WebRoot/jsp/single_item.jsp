<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>首页</title>

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


</head>

<body ontouchstart style="background-color: #f8f8f8;">
	<div class="weui_panel" style="background-color: #f8f8f8;">
	<div class="weui_cell_bd weui_cell_primary">
		<div class="weui_panel_bd">
			
				<div class="weui_media_box weui_media_text"
					style="display:inline-block;width=100px">
					<div style="display:inline-block;width=100px">
						<span class="f20"> 标题一  ${book.bookname }</span>
					</div>
				</div>
				<div style="width=100px; margin-top=10px;display:inline-block;">
					<span class="f15"> 由各种物质组成的巨型球状天体，叫做星球。星球有一定的形状，有自己的运行轨道。 </span>
				</div>

				<ul class="weui_media_info">
					<li class="weui_media_info_meta">文字来源</li>
					<li class="weui_media_info_meta">时间</li>
					<li class="weui_media_info_meta weui_media_info_meta_extra">其它信息</li>
				</ul>
			</div>
			<div class="weui_cell_ft">
				<div class="weui_cell_bd weui_cell_primary"
					style="margin-right=10px">
					<p class='weui-updown'>
						<img src="/library/image/picture.jpg"
							data-src="/library/image/picture.jpg" height='100' />
					</p>
				</div>
			</div>
		</div>
	</div>


	<div class="weui_cell" style="display:inline;">
		<div class="weui_cell_bd weui_cell_primary">
			<p class='weui-updown'>
				<img src="/library/image/picture.jpg"
					data-src="/library/image/picture.jpg" height='100' />
			</p>
		</div>
		<div class="weui_cell_ft"></div>
	</div>


</body>
</html>
