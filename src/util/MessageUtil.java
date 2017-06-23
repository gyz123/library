package util;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import po.Image;
import po.ImageMessage;
import po.News;
import po.NewsMessage;
import po.TextMessage;

import com.thoughtworks.xstream.XStream;

public class MessageUtil {
	
	public static final String MESSAGE_TEXT = "text";
	public static final String MESSAGE_IMAGE = "image";
	public static final String MESSAGE_VOICE = "voice";
	public static final String MESSAGE_VIDEO = "video";
	public static final String MESSAGE_LINK = "link";
	public static final String MESSAGE_LOCATION = "location";
	public static final String MESSAGE_EVENT = "event";
	public static final String MESSAGE_SUBSCRIBE = "subscribe";
	public static final String MESSAGE_UNSUBSCRIBE = "unsubscribe";
	public static final String MESSAGE_CLICK = "CLICK";   //CLICK大写！！！！
	public static final String MESSAGE_VIEW = "VIEW";   //VIEW大写！！！！
	public static final String MESSAGE_NEWS = "news";	
	public static final String MESSAGE_SCANCODE = "scancode_push";
	
	/**
	 * XML转MAP
	 * @param request
	 * @return
	 * @throws IOException
	 * @throws DocumentException
	 */
	public static Map<String, String> xmlToMap(HttpServletRequest request) throws IOException, DocumentException{
		Map<String,String> map = new HashMap<String,String>();
		SAXReader reader = new SAXReader();
		
		InputStream ins = request.getInputStream();
		Document doc = reader.read(ins);
		
		Element root = doc.getRootElement();
		
		List<Element> list = root.elements();
		
		for(Element e:list){
			map.put(e.getName(), e.getText());
		}
		
		ins.close();
		return map;
	}
	
	/**
	 * 文本转XML
	 * @param textMessage
	 * @return
	 */
	public static String textMessageToXml(TextMessage textMessage){
		XStream xstream = new XStream();
		// 替换根元素（将类名称替换为"xml"）
		xstream.alias("xml", textMessage.getClass());   
		
		return xstream.toXML(textMessage);
		
	}
	
	/**
	 * 组装文本消息
	 * @param toUserName
	 * @param fromUserName
	 * @param content
	 * @return
	 */
	public static String initText(String toUserName,String fromUserName,String content){
		po.TextMessage text = new po.TextMessage();
		text.setFromUserName(toUserName);
		text.setToUserName(fromUserName);
		text.setMsgType(MessageUtil.MESSAGE_TEXT);
		text.setCreateTime(String.valueOf(new Date().getTime()));
		text.setContent(content);
		
		return textMessageToXml(text);
	}
	
	
	// 主菜单
	public static String menuText(){
		StringBuffer sb = new StringBuffer();
		sb.append("欢迎关注~\n\n");
		sb.append("1.课程介绍\n");
		sb.append("2.慕课网介绍\n");
		sb.append("回复?调出此菜单");
		return sb.toString();
	}
	
	// 子菜单1
	public static String firstMenu(){
		StringBuffer sb = new StringBuffer();
		sb.append("教授微信公众号的开发");
		return sb.toString();
	}

	//子菜单2
	public static String secondMenu(){
		StringBuffer sb = new StringBuffer();
		sb.append("免费公开课");
		return sb.toString();
	}
	
	
	
	/**
	 * 图文转XML
	 * @param newsMessage
	 * @return
	 */
	public static String newsMessageToXml(NewsMessage newsMessage){
		XStream xstream = new XStream();
		xstream.alias("xml", newsMessage.getClass());
		xstream.alias("item", new News().getClass());
		return xstream.toXML(newsMessage);
	}
	
	/**
	 * 组装图文消息
	 * @param toUserName
	 * @param fromUserName
	 * @return
	 */
	public static String initNewsMessage(String toUserName,String fromUserName){
		String message = null;
		List<News> newsList = new ArrayList<News>();
		NewsMessage newsMessage = new NewsMessage();
		
		News news = new News();
		news.setTitle("IMOOC介绍");
		news.setDescription("这是一个学习交流的地方");
		news.setPicUrl("http://www.iotesta.cn/Weixin/image/picture.jpg");  
		news.setUrl("www.imooc.com");
		
		newsList.add(news);
		
		newsMessage.setFromUserName(toUserName);
		newsMessage.setToUserName(fromUserName);
		newsMessage.setCreateTime(String.valueOf(new Date().getTime()));
		newsMessage.setMsgType(MESSAGE_NEWS);
		newsMessage.setArticles(newsList);
		newsMessage.setArticleCount(newsList.size());
		
		message = newsMessageToXml(newsMessage);
		return message;
	}
	
	
	/**
	 * 图片转XML
	 * @param imageMessage
	 * @return
	 */
	public static String imageMessageToXml(ImageMessage imageMessage){
		XStream xstream = new XStream();
		xstream.alias("xml", imageMessage.getClass());
		return xstream.toXML(imageMessage);
	}
	
	/**
	 * 组装图片消息
	 * @param fromUserName
	 * @param toUserName
	 * @return
	 */
	public static String initImageMessage(String toUserName,String fromUserName){
		String message = null;
		Image image = new Image();
		image.setMediaId("Q7QGASb0NanbxPqaPF__OkUHMEGcSOSD9qYfxL98Mww4tDTNa3inYGpNN_1vLKrX");
		
		ImageMessage imageMassage = new ImageMessage();
		imageMassage.setFromUserName(toUserName);
		imageMassage.setToUserName(fromUserName);
		imageMassage.setMsgType(MESSAGE_IMAGE);
		imageMassage.setCreateTime(String.valueOf(new Date().getTime()));
		imageMassage.setImage(image);
		
		message = imageMessageToXml(imageMassage);
		return message;
	}
	
	
	public static String generateServiceMsg(String openid,String type,String content){
		StringBuffer sb = new StringBuffer();
		sb.append("{");
		sb.append("\"touser\":\"").append(openid).append("\",");
		sb.append("\"msgtype\":\"").append(type).append("\",");
		sb.append("\"text\":");
		sb.append("{");
		sb.append("\"content\":\"").append(content).append("\"");
		sb.append("}");
		sb.append("}");
		return sb.toString();
	}
	
}
