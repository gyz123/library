package action.page;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import po.Book;
import po.BookInCategory;

import util.SQLUtil;
import util.WeixinUtil;

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
        String catName = request.getParameter("id");
        String pageNum = request.getParameter("pagenum");
        String target = request.getParameter("target");
        if(pageNum == null || pageNum.equals("0")){
        	pageNum = "1";
        }
        if(target == null){
        	target = "bookno";
        }
        
        ActionContext context = ActionContext.getContext();
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
       		bookList = SQLUtil.querySingleCat("('计算机')", pageNum, target);
       		context.put("catid","keji");
       		context.put("cat", "科技");
       		context.put("booklist", bookList);
       	}
		return "ok";
	}
	
	@Override // 进入首页
	public String execute() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        
        String weid = "";
        // 获取用户微信id
//        String code = request.getParameter("code");	 
//		String url = GetCode.replace("APPID", WeixinUtil.APPID).replace("SECRET", WeixinUtil.APPSECRET).replace("CODE", code);
//		JSONObject jsonObject = WeixinUtil.doGetStr(url);
//		if(jsonObject != null){
//			weid = jsonObject.getString("openid");
//		}
		
		ActionContext context = ActionContext.getContext();
		if(weid == null){
			weid = "1";  // 测试数据
		}
		context.put("weid",weid);
		
		return SUCCESS;
	}

}
