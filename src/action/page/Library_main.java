package action.page;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import po.Announcement;
import po.AnnouncementInList;
import po.book.Book;
import po.book.BookDetailInfo;
import po.book.BookInCategory;
import po.user.UserDetailInfo;

import util.sql.SQL4PersonalInfo;
import util.sql.SQLUtil;
import util.weixin.CheckUtil;
import util.weixin.PastUtil;
import util.weixin.WeixinUtil;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class Library_main extends ActionSupport{
	private static final long serialVersionUID=1L;
	private static final String GetCode = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code";
	
	// 进入单类书籍页面
	public String enterWenxue() throws UnsupportedEncodingException{
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
		
        // 获取搜索条件
        String weid = request.getParameter("weid");
        String catName = request.getParameter("id");
        String pageNum = request.getParameter("pagenum");
        String target = request.getParameter("target");	// 排序条件，默认按编号排序
        
        HttpSession session = request.getSession();
		session.setAttribute("weid", weid);
        session.setAttribute("cat", catName);
		
        if(pageNum == null || pageNum.equals("0")){
        	pageNum = "1";
        }
        if(target == null){
        	target = "bookno";
        }
        
        ActionContext context = ActionContext.getContext();
        context.put("weid", weid);
        context.put("pagenum", pageNum);
        ArrayList<BookInCategory> bookList = new ArrayList<BookInCategory>();
		// 文学：中国文学、外国文学
       	if(catName.equals("wenxue")){
       		bookList = SQLUtil.querySingleCat("('中国文学','外国文学')", pageNum, target);
       		context.put("catid","wenxue");
       		context.put("cat", "文学");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("文学");
       	}
       	// 传记
       	else if(catName.equals("zhuanji")){
       		bookList = SQLUtil.querySingleCat("('人物传记')", pageNum, target);
       		if (bookList.size() > 0) {
				context.put("booklist", bookList);
			}
       		context.put("catid","zhuanji");
       		context.put("cat", "传记");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("传记");
       	}
       	// 历史
       	else if(catName.equals("lishi")){
       		bookList = SQLUtil.querySingleCat("('历史')", pageNum, target);
       		context.put("catid","lishi");
       		context.put("cat", "历史");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("历史");
       	}
       	// 哲学
       	else if(catName.equals("zhexue")){
       		bookList = SQLUtil.querySingleCat("('哲学')", pageNum, target);
       		context.put("catid","zhexue");
       		context.put("cat", "哲学");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("哲学");
       	}
       	// 儿童
       	else if(catName.equals("ertong")){
       		bookList = SQLUtil.querySingleCat("('儿童文学')", pageNum, target);
       		context.put("catid","ertong");
       		context.put("cat", "少儿");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("儿童");
       	}
       	// 小说
       	else if(catName.equals("xiaoshuo")){
       		bookList = SQLUtil.querySingleCat("('小说')", pageNum, target);
       		context.put("catid","xiaoshuo");
       		context.put("cat", "小说");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("小说");
       	}
       	// 心理：鸡汤、心理
       	else if(catName.equals("xinli")){
       		bookList = SQLUtil.querySingleCat("('心灵鸡汤','心理学')", pageNum, target);
       		context.put("catid","xinli");
       		context.put("cat", "心理");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("心理");
       	}
       	// 社会：成功励志、教育、管理
       	else if(catName.equals("shehui")){
       		bookList = SQLUtil.querySingleCat("('成功励志','教育','管理')", pageNum, target);
       		context.put("catid","shehui");
       		context.put("cat", "社会");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("社会");
       	}
       	// 科技
       	else if(catName.equals("keji")){
       		bookList = SQLUtil.querySingleCat("('计算机','科技','互联网')", pageNum, target);
       		context.put("catid","keji");
       		context.put("cat", "科技");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("科技");
       	}
		return "ok";
	}
	
	// 返回首页
	public String backToMain() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		if(weid == null || weid.isEmpty() || weid.equals("null")){
			weid = request.getSession(false).getAttribute("weid").toString();
		}
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		
		UserDetailInfo user = SQL4PersonalInfo.queryUser(weid);
		if(user != null){
			context.put("flag", true);
			context.put("user",user);
			System.out.println("已注册:" + user.getRealName() + " " + user.getOpenid());
		}
		else{
			context.put("flag", false);	// 说明用户还没有注册
			System.out.println("未注册:"  + " " + weid);
		}
		
//		// ************************
//		Map<String,String> map = PastUtil.getParam(WeixinUtil.APPID, WeixinUtil.APPSECRET, request, url);		
//		String noncestr = map.get("nonceStr");
//		String jsapi_ticket = map.get("jsapi_ticket");
//		String timestamp = map.get("timestamp");
//		String url = map.get("url");
//		System.out.println(map.toString());
//		// 生成签名
//		String signature = CheckUtil.generateSignature(noncestr, jsapi_ticket, timestamp, url);
//		
//		// 设置参数
//		request.setAttribute("appId", WeixinUtil.APPID);
//		request.setAttribute("timeStamp", timestamp);
//		request.setAttribute("nonceStr", noncestr);
//		request.setAttribute("signature", signature);
//		request.setAttribute("url", url);
		
		// 公告列表
		ArrayList<AnnouncementInList> annolist = SQLUtil.queryAllAnno();
		context.put("annolist", annolist);
		
		return "ok";
	}
	
	
	@Override // 由公众号进入首页
	public String execute() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        
        String weid = "";
        // 获取用户微信id
        String code = request.getParameter("code");	 
        if(code != null){
        	String url = GetCode.replace("APPID", WeixinUtil.APPID).replace("SECRET", WeixinUtil.APPSECRET).replace("CODE", code);
        	JSONObject jsonObject = WeixinUtil.doGetStr(url);
        	if(jsonObject != null){
        		weid = jsonObject.getString("openid");
        	}
        }
		
		ActionContext context = ActionContext.getContext();
		if(weid.isEmpty()){
			weid = "oDRhGwscPxkgWHa0pzSVcRxveNSw";  // 测试数据
//			weid = "guest";  // 未注册的用于统一分配固定的游客账号
		}
		context.put("weid", weid);
		
		HttpSession session = request.getSession();
		session.setAttribute("weid", weid);
		
		UserDetailInfo user = SQL4PersonalInfo.queryUser(weid);
		if(user != null){
			context.put("flag", true);
			context.put("user",user);
			System.out.println("已注册:" + user.getRealName() + " " + user.getOpenid());
		}
		else{
			context.put("flag", false);	// 说明用户还没有注册
			System.out.println("未注册:"  + " " + weid);
		}
		
		// ************************
//		Map<String,String> map = PastUtil.getParam(WeixinUtil.APPID, WeixinUtil.APPSECRET, request);		
//		String noncestr = map.get("nonceStr");
//		String jsapi_ticket = map.get("jsapi_ticket");
//		String timestamp = map.get("timestamp");
//		String url = map.get("url");
//		System.out.println(map.toString());
//		// 生成签名
//		String signature = CheckUtil.generateSignature(noncestr, jsapi_ticket, timestamp, url);
//		
//		// 设置参数
//		request.setAttribute("appId", WeixinUtil.APPID);
//		request.setAttribute("timeStamp", timestamp);
//		request.setAttribute("nonceStr", noncestr);
//		request.setAttribute("signature", signature);
//		request.setAttribute("url", url);
//		
		
		// 公告列表
		ArrayList<AnnouncementInList> annolist = SQLUtil.queryAllAnno();
	    context.put("annolist", annolist);
		
		return SUCCESS;
	}
	
	// 单个公告
	public String enterAnno() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
//        HttpSession session = request.getSession(false);
//		String weid = (String)session.getAttribute("weid");
//        System.out.println("由session获得到weid:" + weid);
        
        String weid = request.getParameter("weid");
        ActionContext context = ActionContext.getContext();
        context.put("weid", weid);
        
        String anno_id = request.getParameter("anno_id");
        Announcement anno = SQLUtil.queryAnno(anno_id);
        context.put("anno", anno);
        
        // 处理内容显示
        String annoContent = anno.getContent();
        String[] strs = annoContent.split("\n");
        ArrayList<String> contentlist = new ArrayList<String>();
        for(int i=0; i<strs.length; i++){
        	contentlist.add(strs[i].trim());
        }
	    context.put("contentlist", contentlist);
        
		return "ok";
	}
	
	
	/**
	 * 首页ajax动态请求jssdk
	 * @throws IOException 
	 */
	public void jssdkConfig() throws IOException{
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		
		//String url = map.get("url");
		String url = request.getParameter("url");//从前台传来
		
		// ************************
		Map<String,String> map = PastUtil.getParam(WeixinUtil.APPID, WeixinUtil.APPSECRET, request, url);		
		String noncestr = map.get("nonceStr");
		String jsapi_ticket = map.get("jsapi_ticket");
		String timestamp = map.get("timestamp");
		
		System.out.println(url);
		System.out.println(map.toString());
		
		map.remove("url");
		map.put("url", url);
		// 生成签名
		String signature = CheckUtil.generateSignature(noncestr, jsapi_ticket, timestamp, url);
				
		// 设置参数
//		request.setAttribute("appId", WeixinUtil.APPID);
//		request.setAttribute("timeStamp", timestamp);
//		request.setAttribute("nonceStr", noncestr);
//		request.setAttribute("signature", signature);
//		request.setAttribute("url", url);
		
		out.write(JSONArray.fromObject(map).toString());
		out.flush();
		out.close();
	}
}
