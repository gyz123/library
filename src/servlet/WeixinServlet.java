package servlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dom4j.DocumentException;

import po.AccessToken;
import util.CheckUtil;
import util.MessageUtil;
import util.WeixinUtil;

public class WeixinServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		String signature = req.getParameter("signature");
		String timestamp = req.getParameter("timestamp");
		String nonce = req.getParameter("nonce");
		String echostr = req.getParameter("echostr");
	
		PrintWriter out = resp.getWriter();
		
		if(CheckUtil.checkSignature(signature, timestamp, nonce)){
			out.print(echostr);
		}
		
		doPost(req,resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");
		PrintWriter out = resp.getWriter();
		
		try {
			Map<String, String> map = MessageUtil.xmlToMap(req);
			String fromUserName = map.get("FromUserName");
			String toUserName = map.get("ToUserName");
			String msgType = map.get("MsgType");
			String content = map.get("Content");
			
			
			//***************************************************************
			AccessToken token = WeixinUtil.getAccessToken();  //获取access_token
			
			String message = null;
			
			// 判断消息类型
			if(MessageUtil.MESSAGE_TEXT.equals(msgType)){
				if("1".equals(content)){
					message = MessageUtil.initText(toUserName, fromUserName, MessageUtil.firstMenu());
				}
				else if ("2".equals(content)){
					message = MessageUtil.initNewsMessage(toUserName, fromUserName);
				}
				else if ("3".equals(content)){
					message = MessageUtil.initImageMessage(toUserName, fromUserName);
				}
				else if ("?".equals(content) || "？".equals(content)){
					message = MessageUtil.initText(toUserName, fromUserName, MessageUtil.menuText());
				}else if("查询ID".equals(content) || "查询id".equals(content)){
					message = MessageUtil.initText(toUserName, fromUserName, fromUserName);
				}else{
					message = MessageUtil.initText(toUserName, fromUserName,content);
				}
			}
			else if(MessageUtil.MESSAGE_EVENT.equals(msgType)){
				String eventType  = map.get("Event");
				
				if(MessageUtil.MESSAGE_SUBSCRIBE.equals(eventType)){
					// 显示欢迎界面
					message = MessageUtil.initText(toUserName, fromUserName, MessageUtil.menuText());
				}else if(MessageUtil.MESSAGE_CLICK.equals(eventType)){
					
					String key = map.get("EventKey");
					//报名
					if(key.equals("33")){
						boolean result1 = WeixinUtil.checkSubscribe(fromUserName);
						
						if(result1 == false){ // 未注册
							message = MessageUtil.initText(toUserName, fromUserName, "你还未注册，无法报名" );
						}else{
							boolean result2 = WeixinUtil.checkBaoming(fromUserName);
							
							if(result2 == false){ //未报名
								message = MessageUtil.initText(toUserName, fromUserName, "报名成功~");
							}else{
								message = MessageUtil.initText(toUserName, fromUserName, "你已经报过名，无需重复操作");
							}
						}
					}
					
					//显示主菜单
					else if(key.equals("11")){
						message = MessageUtil.initText(toUserName, fromUserName, MessageUtil.menuText());		
					}
							
				}else if(MessageUtil.MESSAGE_VIEW.equals(eventType)){
					// VIEW事件：同时访问servlet和url 
					String url = map.get("EventKey");
//					message = MessageUtil.initText(toUserName, fromUserName, url);
				}else if(MessageUtil.MESSAGE_SCANCODE.equals(eventType)){
					String key = map.get("EventKey");
//					message = MessageUtil.initText(toUserName, fromUserName, key);
				}
			}
			else if(MessageUtil.MESSAGE_LOCATION.equals(msgType)){
				String label = map.get("Label");
				message = MessageUtil.initText(toUserName, fromUserName, label);
			}
			out.print(message);
			
		} catch (DocumentException e) {
			e.printStackTrace();
		}finally{
			out.close();
		}
		
	}
	
	
}
