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
//       		String str = SQLUtil.querySingleCat2("('中国文学','外国文学')", pageNum);
//       		String[] dataList = str.split("##");
//       		System.out.println("共 " + dataList.length + " 本书");
//       		for(int i=0; i<dataList.length; i++){
//       			Book book = new Book();
//       			System.out.println("当前书本信息: " + dataList[i]);
//       			String[] bookdata = dataList[i].split(";;");
//       			System.out.println("每本书 " + bookdata.length + " 条数据: ");
//       			book.setBookno(bookdata[0]);
//            	book.setBookname(bookdata[1]);
//            	book.setBookimg(bookdata[2]);
//            	bookList.add(book);
//       		}
       		context.put("catid","wenxue");
       		context.put("cat", "文学");
       		context.put("booklist", bookList);
       		
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
       	}
       	// 历史
       	else if(catName.equals("lishi")){
       		bookList = SQLUtil.querySingleCat("('历史')", pageNum, target);
       		context.put("catid","lishi");
       		context.put("cat", "历史");
       		context.put("booklist", bookList);
       	}
       	// 哲学
       	else if(catName.equals("zhexue")){
       		bookList = SQLUtil.querySingleCat("('哲学')", pageNum, target);
       		context.put("catid","zhexue");
       		context.put("cat", "哲学");
       		context.put("booklist", bookList);
       	}
       	// 儿童
       	else if(catName.equals("ertong")){
       		bookList = SQLUtil.querySingleCat("('儿童文学')", pageNum, target);
       		context.put("catid","ertong");
       		context.put("cat", "少儿");
       		context.put("booklist", bookList);
       	}
       	// 小说
       	else if(catName.equals("xiaoshuo")){
       		bookList = SQLUtil.querySingleCat("('小说')", pageNum, target);
       		context.put("catid","xiaoshuo");
       		context.put("cat", "小说");
       		context.put("booklist", bookList);
       	}
       	// 心理：鸡汤、心理
       	else if(catName.equals("xinli")){
       		bookList = SQLUtil.querySingleCat("('心灵鸡汤','心理学')", pageNum, target);
       		context.put("catid","xinli");
       		context.put("cat", "心理");
       		context.put("booklist", bookList);
       	}
       	// 社会：成功励志、教育、管理
       	else if(catName.equals("shehui")){
       		bookList = SQLUtil.querySingleCat("('成功励志','教育','管理')", pageNum, target);
       		context.put("catid","shehui");
       		context.put("cat", "社会");
       		context.put("booklist", bookList);
       	}
       	// 计算机
       	else if(catName.equals("keji")){
       		bookList = SQLUtil.querySingleCat("('计算机','科技','互联网')", pageNum, target);
       		context.put("catid","keji");
       		context.put("cat", "科技");
       		context.put("booklist", bookList);
       	}
		return "ok";
	}
	
	// 返回首页
	public String backToMain() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		if(weid == null || weid.isEmpty()){
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
		
		return SUCCESS;
	}
	
	
	public String enterAnno() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        
        ArrayList<BookDetailInfo> bookList = new ArrayList<BookDetailInfo>();
        BookDetailInfo book = SQLUtil.querySingleBookFromCat("2");
        bookList.add(book);
        book = SQLUtil.querySingleBookFromCat("142");
        bookList.add(book);
        book = SQLUtil.querySingleBookFromCat("184");
        bookList.add(book);
        ActionContext context = ActionContext.getContext();
        context.put("booklist", bookList);
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
