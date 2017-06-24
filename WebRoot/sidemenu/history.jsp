<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib  uri= "http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>借阅历史</title>

<link rel="stylesheet" href="css/weui.css" />
<link rel="stylesheet" href="css/weui2.css" />
<link rel="stylesheet" href="css/weui3.css" />
<link rel="stylesheet" type="text/css" href="css/weuix.min.css">

  <script src="js/jquery-3.1.1.min.js"></script>
  <script>
		var $j = jQuery.noConflict(); //自定义一个比较短的快捷方式
	</script>
  <!-- 引入 ECharts 文件 -->
  <script src="js/echarts.js" charset="utf-8"></script>
  <!-- 引入 shine 主题 -->
  <!-- <script src="theme/shine.js"></script> -->
  <title>借阅历史</title>
</head>
<style type="text/css">
  body{
    font-size: 100px;
  }
</style>


<body ontouchstart style="background-color: #ffffff;">

	<div class="weui_cells_title" style="background:#ffffff;margin-bottom:8px">
		<span class="f14" >个人信息</span>
	</div>
  	<hr />
  <div class="weui_panel_bd" style="margin-top:4px; margin-bottom:0px">
    <div class="weui_media_box weui_media_appmsg">
      <div class="weui_media_hd" style="margin-left:24px;margin-right:24px; height:64px">
        <img class="weui_media_appmsg_thumb" style="width:64px;height:64px" 
        		alt="" class="weui-avatar-url"
        		src="${user.headimgurl }" >
      </div>
      <div class="weui_media_bd" style="height:64px; padding-top:12px">
        <h4 class="weui_media_title f22" style="height:30px; padding-top:4px">${user.nickname }</h4>
        <p class="weui_media_desc f16" style="margin-top:4px">真实姓名: ${user.realName }</p>
      </div>
    </div>
  </div>
	
	<div style="height:12px;width:100%;background-color:#f8f8f8"></div>
	
	<div class="weui_cells_title" style="background:#ffffff;margin-bottom:8px">
		<span class="f14" >阅读统计</span>
	</div>
  <hr />
  <!-- 为ECharts准备一个具备大小（宽高）的Dom -->

  <div id="category" style="width: 80%;height:43%;margin-left:auto;margin-right:auto;"></div><!-- style="width: 600px;height:400px;" -->
  <hr />
  <!-- 为ECharts准备一个具备大小（宽高）的Dom -->

  <div id="year" style="width: 80%;height:43%;margin-left:auto;margin-right:auto;"></div><!-- style="width: 600px;height:400px;" -->
  <hr />
  <!-- 为ECharts准备一个具备大小（宽高）的Dom -->

  <div id="month" style="width: 80%;height:55%;margin-left:auto;margin-right:auto;"></div><!-- style="width: 600px;height:400px;" -->
  
  
  <script type="text/javascript">
//<![CDATA[
                // 基于准备好的dom，初始化echarts实例
        // 第二个参数可以指定前面引入的主题 , 'shine'
        var myChart1 = echarts.init(document.getElementById('category'));

        var giftImageUrl = "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/PjxzdmcgaGVpZ2h0PSIzMnB4IiB2ZXJzaW9uPSIxLjEiIHZpZXdCb3g9IjAgMCAzMiAzMiIgd2lkdGg9IjMycHgiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6c2tldGNoPSJodHRwOi8vd3d3LmJvaGVtaWFuY29kaW5nLmNvbS9za2V0Y2gvbnMiIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIj48dGl0bGUvPjxkZXNjLz48ZGVmcy8+PGcgZmlsbD0ibm9uZSIgZmlsbC1ydWxlPSJldmVub2RkIiBpZD0iUGFnZS0xIiBzdHJva2U9Im5vbmUiIHN0cm9rZS13aWR0aD0iMSI+PGcgZmlsbD0iIzE1N0VGQiIgaWQ9Imljb24tMzAtYm9vayI+PHBhdGggZD0iTTguOTk0MjAyMDgsMjkgQzcuMzQzMzExOTcsMjkgNiwyNy42NTcwOTc4IDYsMjYuMDAwNTQzOSBMNiw2LjUgQzYsNS4xMDk2NjIwNiA3LjExNTk2NCw0IDguNDkyNTc1MzUsNCBMMjYsNCBMMjYsNSBMMjUuNDk1MzE1Niw1IEMyNC42NzcxMDg4LDUgMjQsNS42NzE1NzI4OCAyNCw2LjUgQzI0LDcuMzM0MjAyNzcgMjQuNjY5NDc1Niw4IDI1LjQ5NTMxNTYsOCBMMjYsOCBMMjYsMjkgTDExLDI5IEwxMSw4IEwyMy41LDggQzIzLjUsOCAyMyw3LjIxMDQ4NDUzIDIzLDYuNDczNTU0NDkgQzIzLDUuNzM2NjI0NDUgMjMuNSw1IDIzLjUsNSBMOC40OTMzNjYyNSw1IEM3LjY2ODYwMjg0LDUgNyw1LjY2NTc5NzIzIDcsNi41IEM3LDcuMzI4NDI3MTIgNy42NjcyNTU0Niw4IDguNDkzMzY2MjUsOCBMMTAsOCBMMTAsMjkgTDguOTk0MjAyMDgsMjkgWiIgaWQ9ImJvb2siLz48L2c+PC9nPjwvc3ZnPg==";

        myChart1.showLoading();

        $j.getJSON("category.json", function(data) {
          myChart1.hideLoading();
        // 填入数据
        myChart1.setOption({
          title:{
            text: '阅读分布',
            left: '25%',
                textStyle:{//标题样式
                  fontSize: 30,
                  color : '#2FC9DA'
                }
              },
              graphic: {
                elements: [{
                  type: 'image',
                  style: {
                    image: giftImageUrl,
                    width: 30,
                     height: 30//矢量图大小
                   },
                   left: 'center',
                   top: 'center'
                 }]
               },
               series: [{
                type: 'pie',
             radius: [25, '55%'],//中心小圆圈
             center: ['50%', '50%'],
             roseType: 'radius',
               //color: ['#f2c955', '#00a69d', '#46d185', '#ec5845'],
               data: data.data,
               label: {
                normal: {
                  textStyle: {
                         fontSize: 20,//文字大小
                         fontFamily : '微软雅黑',
                       },
                       formatter: function(param) {
                        return param.name + '\n' + Math.round(param.percent) + '%';
                      }
                    }
                  },
                  labelLine: {
                    normal: {
                      smooth: true,
                      lineStyle: {
                        width: 2
                      }
                    }
                  },
                  itemStyle: {
                    normal: {
                      shadowBlur: 50,
                      shadowColor: 'rgba(0, 0, 0, 0.4)'
                    }
                  },

                  animationType: 'scale',
                  animationEasing: 'elasticOut',
                  animationDelay: function(idx) {
                    return Math.random() * 200;
                  }
                }]
              });
        console.log(data.data);
      });
  //]]>
</script>
<script type="text/javascript">
//<![CDATA[
                // 基于准备好的dom，初始化echarts实例
        // 第二个参数可以指定前面引入的主题 , 'shine'
        var myChart2 = echarts.init(document.getElementById('year'));

        myChart2.showLoading();

        $j.getJSON("year.json", function(data) {
          myChart2.hideLoading();
            // 填入数据
            myChart2.setOption({
              color: ['#3398DB'],
              tooltip : {
                trigger: 'axis',
                axisPointer : {            
                // 坐标轴指示器，坐标轴触发有效
                type : 'shadow'        
                // 默认为直线，可选为：'line' | 'shadow'
              }
            },
            title:{
              text: '年度统计',
              left: '20%',
                textStyle:{//标题样式
                  fontSize: 30,
                  color : '#2FC9DA'
                }
              },
              grid: {
               left: '3%',
               right: '4%',
               bottom: '3%',
               containLabel: true
             },
             xAxis : [
             {
               type : 'category',
               data : data.title,
                //['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                axisTick:
                {
                 alignWithLabel: true,
               },
               axisLabel: {
                textStyle:{//坐标轴样式
                  fontSize: 12,
                  color : '#90979c',
                  fontWeight : 'bold'
                }
              }
            }
            ],
            yAxis : [
            {
             type : 'value',
             axisLabel: {
                textStyle:{//坐标轴样式
                  fontSize: 15,
                  color : '#90979c',
                  fontWeight : 'bold'
                }
              }
            }
            ],
            series : [
            {
             name:'num',
             type:'bar',
             barWidth: '60%',
             label: {
              normal: {
               show: true,
               position: 'top',
               textStyle : {
                fontSize : '20',
                fontFamily : '微软雅黑',
                fontWeight : 'bold'
              }
            }

          },
          data:data.num,
                //[110, 52, 80, 130, 150, 130, 100]

              }],



            });
            console.log(data.title);
            console.log(data.num);
          });
  //]]>
</script><script type="text/javascript">
//<![CDATA[
                // 基于准备好的dom，初始化echarts实例
        // 第二个参数可以指定前面引入的主题 , 'shine'
        var myChart3 = echarts.init(document.getElementById('month'));

        var xData = function() {
          var data = [];
          for (var i = 1; i < 13; i++) {
            data.push(i + "月");
          }
          return data;
        }();

        myChart3.showLoading();

        $j.getJSON("month.json", function(data) {
          myChart3.hideLoading();
            var year = data.year;//"2015";
            var option = {
               // backgroundColor: "#ffffff",//#344b58
               "title": {
                "text": year + "年借书统计",
                x: "4%",
                textStyle: {
                  color: '#2FC9DA',
                  fontSize: '30'
                },

              },
              "tooltip": {
                "trigger": "axis",
                "axisPointer": {
                  "type": "shadow",
                  textStyle: {
                    color: "#fff"
                  }

                },
              },
              "grid": {
                "borderWidth": 0,
                "top": 110,
                "bottom": 95,
                textStyle: {
                  color: "#fff",
                  fontSize : 15
                }
              },
              "legend": {
                x: '4%',
                top: '11%',
                left:'12%',
                textStyle: {
                 color: '#90979c',
                 fontSize : 20
               },
               "data": ['柱状图',  '折线图']
             },


             "calculable": true,
             "xAxis": [{
              "type": "category",
              "axisLine": {
               lineStyle: {
                color: '#90979c',
                           // fontSize: 50
                         }
                       },

                       "splitLine": {
                         "show": false
                       },
                       "axisTick": {
                         "show": false
                       },
                       "splitArea": {
                         "show": false
                       },
                       "axisLabel": {
                         "interval": 0,
                         "textStyle":
                         {
                    //坐标轴样式
                    fontSize: 15,
                    color : '#90979c',
                    fontWeight : 'bold'
                  }
                },
                "data": xData,
              }],
              "yAxis": [{
                "type": "value",
                "splitLine": {
                 "show": false
               },
               "axisLine": {
                 lineStyle: {
                  color: '#90979c'
                }
              },
              "axisTick": {
               "show": false
             },
             "axisLabel": {
               "interval": 0,
               "textStyle":
               {
                    //坐标轴样式
                    fontSize: 15,
                    color : '#90979c',
                    fontWeight : 'bold'
                  }
                },
                "splitArea": {
                 "show": false
               },

             }],
             "dataZoom": [{
              "show": true,
              "height": 30,
              "xAxisIndex": [
              0
              ],
              bottom: 30,
              "start": 10,
              "end": 80,
              handleIcon: 'path://M306.1,413c0,2.2-1.8,4-4,4h-59.8c-2.2,0-4-1.8-4-4V200.8c0-2.2,1.8-4,4-4h59.8c2.2,0,4,1.8,4,4V413z',
              handleSize: '110%',
              handleStyle:{
               color:"#d3dee5",

             },
             textStyle:{
               color:"#fff"},
               borderColor:"#90979c",

             }, {
               "type": "inside",
               "show": true,
               "height": 15,
               "start": 1,
               "end": 35
             }],
             "series": [{
               "name": "柱状图",
               "type": "bar",
               "stack": "总量",
               "barMaxWidth": 35,
               "barGap": "10%",
               "itemStyle": {
                "normal": {
                 "color": "rgba(255,144,128,1)",//柱状图色
                 "label": {
                  "show": true,
                  "textStyle": {
                   "color": "#fff",
                   "fontSize" : 20
                 },
                 "position": "top",
                 formatter: function(p) {
                   return p.value > 0 ? (p.value) : '';
                 }
               }
             }
           },
           "data": data.data,
         },


         {
           "name": "折线图",
           "type": "line",
           "stack": "总量",
           symbolSize:10,
           symbol:'circle',
           "itemStyle": {
            "normal": {
             "color": "rgba(0,230,48,1)",//折线色
             "barBorderRadius": 0,
             "label": {
              "show": true,
              "textStyle": {
                "fontSize" : 15
              },
              "position": "top",
              formatter: function(p) {
               return p.value > 0 ? (p.value) : '';
             }
           }
         }
       },
       "data": data.data,
     },
     ],
     markLine : {
       data : [
       {type : 'average', name: '平均值'}
       ]
     }
   };

   myChart3.setOption(option);
 });
  //]]>
</script>
  
    <div style="height:12px;width:100%;background-color:#f8f8f8"></div>

  	<div class="weui_cells_title">
		<span class="f14">我读过的书</span>
	</div>
	<hr style="color:gray;width:100%;size:1px;margin-top:8px">
	
	<table class="weui-table weui-border-tb" style="margin-bottom:16px">
		<thead>
			<tr>
				<th><span>书名</span></th>
				<th>借阅日期</th>
				<th>是否续借</th>
				<th>是否归还</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="nowlist" items="${nowlist}">
				<tr>
					<td>${nowlist.bookname }</td>
					<td>${nowlist.borrowtime }</td>
					<td class="continue" style="color:#90979c;" value="${nowlist.bookno }">
						续借
					</td>
					<td class="return" style="color:#2FC9DA;" value="${nowlist.bookno }">
						归还
					</td>
				</tr>
			</c:forEach>
			<c:forEach var="booklist" items="${booklist}">
				<tr>
					<td>${booklist.bookname }</td>
					<td>${booklist.borrowtime }</td>
					<td>已归还</td>
					<td>${booklist.returntime }</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	
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
				var bookno = $(this).attr("value");
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
				var bookno = $(this).attr("value");
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
            		location.href = "/library/return_success.action";//成功跳转确认订单
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
