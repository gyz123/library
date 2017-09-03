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

<link rel="stylesheet" type="text/css" href="css/love_normalize.css" />
<link rel="stylesheet" type="text/css" href="css/love_default.css">
<link rel="stylesheet" type="text/css" href="css/love_style.css"/>

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
					paragraphExtender.html('展开'); // 收缩时显示的提示文字
					paragraph.html(paragraphText.substring(0,
							maxParagraphLength)
							+ '...');
				} else {
					toggleFullParagraph = true;
					paragraphExtender.html('收起');  // 展开时显示的提示文字
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


</head>

<body ontouchstart style="background-color: #ffffff;">

	<%-- <a href="/library/back_to_main.action?weid=${weid }"></a>--%>
	<div class="weui-header bg-blue" style="height:56px;background-color:#01164b">
		<div class="weui-header-left" style="margin-top:6px;">
			<c:if var="flag" test="${cat!=null }" scope="page">
			<a class="icon icon-109 f-white" 
				href="/library/show_singleCat.action?weid=<%=request.getSession().getAttribute("weid") %>&pagenum=1&id=<%=request.getSession().getAttribute("cat") %>">
				&nbsp;&nbsp;&nbsp;
			</a>
			</c:if>
			<c:if var="flag" test="${cat==null }" scope="page">
			<a class="icon icon-109 f-white" 
				href="/library/back_to_main.action?weid=<%=request.getSession().getAttribute("weid") %>">
				&nbsp;&nbsp;&nbsp;
			</a>
			</c:if>
		</div>
		<h1 class="weui-header-title" style="margin-top:5px">
			<span class="">超新星智能图书馆</span>
		</h1>
	</div>
	

	<div style="height:16px;width:100%"></div>
	<div class="weui_cell">
		<div class="weui_cell_hd"> 
			<img	
			src="${book.bookimg }"
			alt="" style="width:96px;margin-left:4px;display:block">
		</div>
		<div class="weui_cell_bd weui_cell_primary" style="margin-left:16px;margin-bottom:2pxs">
			<span class="f24" >${book.bookname }</span>
			<br><hr style="color:gray;width:100%;size:1px;margin-top:4px"><br>
			<span class="f16" style="margin-left:4px">分类：${book.category }
					<br><br>&nbsp;出版社：${book.publisher }
					<br><br>&nbsp;版本：${book.version }
					<br><br>&nbsp;剩余量：${book.leftnum }</span>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<!-- <a><span class="icon icon-96 f-red" ></span></a> -->
					<span class="heart " id="like1" rel="like" style="margin-left:0px;"></span>
					<!-- <span class="likeCount" id="likeCount1">14</span> -->
					<br>
		</div>
	</div>

	<div style="height:16px;width:100%;background-color:#f8f8f8"></div>

	<div class="weui_cell">
		<div class="weui_cell_bd weui_cell_primary" style="margin-top:4px">
			<span class="f16" style="margin-left:8px">
				简介<br>
				<div style="margin-top:8px; margin-left:8px"><span class="f14">${book.bookAbstract }</span></div>
			</span>
		</div>
	</div>

	<div class="weui_cell" style="height:4%">
		<div class="weui_cell_bd weui_cell_primary" style="margin-top:16px">
			<span class="f16" style="margin-left:8px">
				<div style="margin-top:0px; margin-left:8px">
				<span class="f16">标签</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<c:forEach  var="tag" items="${tags }">
					<span class="f14 f-blue">${tag}</span>&nbsp;&nbsp;
				</c:forEach>
				</div>
			</span>
		</div>
	</div>

	<div class="weui_cells weui_cells_access" style="height:44px">
		<a class="weui_cell " style="height:24px;margin-top:8px" 
				href="/library/get_book_xu.action?weid=${weid }&bookno=${book.bookno}" >
			<div class="weui_cell_bd weui_cell_primary">
				<span class="f16" style="margin-left:8px">序言</span>
			</div>
			<div class="weui_cell_ft">
				<span class="f16 f-gray">点此查看</span>
			</div> 
		</a>
	</div>

	<div class="weui_cells weui_cells_access" style="height:44px;margin-top:-1px">
		<a class="weui_cell " style="height:24px;margin-top:8px" 
				href="/library/get_book_outline.action?weid=${weid }&bookno=${book.bookno}" >
			<div class="weui_cell_bd weui_cell_primary">
				<span class="f16" style="margin-left:8px">目录</span>
			</div>
			<div class="weui_cell_ft">
				<span class="f16 f-gray">点此查看</span>
			</div> 
		</a>
	</div>



	<div style="height:16px;width:100%;background-color:#f8f8f8"></div>
	<div style="height:40px;width:100%;margin-left:24px;padding-top:12px">
		<span class="f16">导读</span>
	</div>
	<div class="weui_cell" >
		<span style="margin-left:8px">
		<p id="paragraph" class="paragraph">
			${book.guide }
		</p>
		</span>
		<!-- 伸张链接 -->
		<a id="paragraphExtender" class="paragraphExtender" 
			style="position:relative; top:4px; left:6px">展开</a>
	</div>
	
	<div class="weui_cells weui_cells_access" style="height:44px;margin-top:4px">
		<a class="weui_cell " style="" 
				href="/library/get_book_comments.action?bookno=${book.bookno }&weid=${weid }" >
			<div class="weui_cell_bd weui_cell_primary">
				<span class="f16" style="margin-left:8px">评论</span>
			</div>
			<div class="weui_cell_ft">
				<span class="f16 f-gray">${book.readingnum }人读过</span>
			</div> 
		</a>
	</div>
	
	<c:if test="${book.dianzi == 'Y' }">
	<div class="weui_cells weui_cells_access" style="height:44px;margin-top:-1px">
		<a class="weui_cell " style="" 
			href="/library/onlineReading.action?bookno=${book.bookno }&weid=${weid }&chapter=1" >
			<div class="weui_cell_bd weui_cell_primary" style="margin-top:4px">
				<span class="f16" style="margin-left:8px">在线阅读</span>
			</div>
			<div class="weui_cell_ft" style="margin-top:8px">
				<span class="f16 f-gray"></span>
			</div> 
		</a>
	</div>
	</c:if>
	
	
	<div style="height:16px;width:100%;background-color:#f8f8f8"></div>
	<div style="height:40px;width:100%;margin-left:24px;padding-top:12px">
		<span class="f16">价格一览</span>
	</div>
	<c:forEach var="price_list" items="${price_list }">
	<div class="weui_cells weui_cells_access" style="margin-left:12px;height:44px;margin-top:-1px">
		<a class="weui_cell " style="" href="${price_list.url }" >
			<div class="weui_cell_bd weui_cell_primary" style="margin-top:0px">
				<span class="f16" style="margin-left:0px">${price_list.site }</span>
			</div>
			<div class="weui_cell_ft" style="margin-top:0px">
				<span class="f16 f-gray">${price_list.price }</span>
			</div> 
		</a>
	</div>
	</c:forEach>
	
	


	<div style="height:16px;width:100%;background-color:#f8f8f8"></div>
	<div style="height:40px;width:100%;margin-left:24px;padding-top:12px">
		<span class="f16">相关推荐</span>
	</div>
	<div class="weui_cell" style="height">
		<a href="/library/show_singleItem.action?bookno=${book1.bookno }&amp;weid=${weid }"> 
		<div class="weui_cell_hd" style="width: 50%; text-align: center; "> 
			<img src="${book1.bookimg }" onerror="this.src='/library/image/default.png'" 
					style="width: 100%; margin-left: 32px; display: block; padding-left: ; padding-bottom: 8px;"> 
			<div style="width:100%;margin-top: 8px;margin-left:32px">
			<span><p>${book1.bookname }</p></span> 
			</div> 
		</div> 
		</a> 
		<a href="/library/show_singleItem.action?bookno=${book2.bookno }&amp;weid=${weid }"> 
		<div class="weui_cell_hd" style="width: 50%; text-align: center; "> 
			<img src="${book2.bookimg }" onerror="this.src='/library/image/default.png'" 
					style="width: 100%; margin-left: 32px; display: block; padding-left: ; padding-bottom: 8px;"> 
			<div style="width:100%;margin-top:8px;margin-left:32px">
			<span><p>${book2.bookname }</p></span> 
			</div>
		</div> 
		</a> 
	</div>
	
	<div style="height:51px"></div>
	
	<c:if var="flag" test="${book.leftnum > 0 && book.dianzi == 'N' }" scope="page">
	<section class="weui-menu" style="">
        <div class="weui-menu-inner" >
            <a href="/library/add_to_reserve.action?bookno=${book.bookno }&weid=${weid }&orderFlag=yes" 
            			style="display:block;padding-top:12px" id="reserveSuccess">
            	我要预定
            </a>
        </div>
        <div class="weui-menu-inner" >
            <a href="/library/add_to_shoppingcart.action?bookno=${book.bookno }&weid=${weid }" 
            			style="display:block;padding-top:12px" id="addSuccess">
            	加入待借清单
            </a>
        </div>
    </section>
	</c:if>
	
	<c:if var="flag" test="${book.leftnum == 0 && book.dianzi == 'N' }" scope="page">
	<section class="weui-menu" style="">
        <div class="weui-menu-inner" >
            <a href="/library/add_to_reserve.action?bookno=${book.bookno }&weid=${weid }&orderFlag=no" 
            			style="display:block;padding-top:12px" id="reserveSuccess">
            	我要预定
            </a>
        </div>
    </section>
	</c:if>
	
	
	<c:if var="flag" test="${book.leftnum > 0 && book.dianzi == 'Y' }" scope="page">
	<section class="weui-menu" style="">
        <div class="weui-menu-inner" >
            <a href="/library/add_to_reserve.action?bookno=${book.bookno }&weid=${weid }&orderFlag=yes" 
            			style="display:block;padding-top:12px" id="reserveSuccess">
            	我要预定
            </a>
        </div>
        <div class="weui-menu-inner" >
            <a href="/library/add_to_shoppingcart.action?bookno=${book.bookno }&weid=${weid }" 
            			style="display:block;padding-top:12px" id="addSuccess">
            	加入待借清单
            </a>
        </div>
        <div class="weui-menu-inner" >
            <a href="/library/payEbook.action?bookno=${book.bookno }&weid=${weid }" 
            			style="display:block;padding-top:12px" id="addSuccess">
            	借阅电子版
            </a>
        </div>
    </section>
	</c:if>
	
	<c:if var="flag" test="${book.leftnum == 0 && book.dianzi == 'Y' }" scope="page">
	<section class="weui-menu" style="">
        <div class="weui-menu-inner" >
            <a href="/library/add_to_reserve.action?bookno=${book.bookno }&weid=${weid }&orderFlag=no" 
            			style="display:block;padding-top:12px" id="reserveSuccess">
            	我要预定
            </a>
        </div>
        <div class="weui-menu-inner" >
            <a href="/library/payEbook.action?bookno=${book.bookno }&weid=${weid }" 
            			style="display:block;padding-top:12px" id="addSuccess">
            	借阅电子版
            </a>
        </div>
    </section>
	</c:if>
	

	<script>
	$(document).ready(function()
	{
    
		var likeFlag = "<%=request.getSession().getAttribute("likeFlag")%>";
		if(likeFlag == 'Y'){
			$(".heart").addClass("heartAnimation").attr("rel","unlike");
			console.log("like");
		}
	$('body').on("click",'.heart',function()
    {
    	
        var heart = $(this).attr("rel");
       
        if(heart === 'like'){      
	        $(this).addClass("heartAnimation").attr("rel","unlike"); 
        	
        	$.ajax({    
            type:'post',        
            url:'/library/add_to_like.action',    //servlet名
            data:"weid=" + "<%=request.getParameter("weid") %>" 
            + "&bookno=" + "<%=request.getParameter("bookno") %>" 
            + "&flag=" + "Y",   //参数，flag=N从数据库中取消喜欢 
            cache:false,    
            //dataType:'json',    
            success:function(data){ 
            	console.log("添加喜欢成功");
            },
            error:function(){
            	console.log("添加喜欢error");
            }    
        	}); 
        }
        else{
    	    $(this).removeClass("heartAnimation").attr("rel","like");
			$(this).css("background-position","left");
			
			$.ajax({    
            type:'post',        
            url:'/library/add_to_like.action',    //servlet名
            data:"weid=" + "<%=request.getParameter("weid") %>" 
            + "&bookno=" + "<%=request.getParameter("bookno") %>" 
            + "&flag=" + "N",   //参数，flag=Y从数据库中增加喜欢
            cache:false,    
            //dataType:'json',    
            success:function(data){ 
            	console.log("取消喜欢成功");
            },
            error:function(){
            	console.log("取消喜欢error");
            }    
        	}); 
        }

		
    });


	});
	</script>

</body>
</html>
