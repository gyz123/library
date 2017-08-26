package action.page;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

import po.Comment;
import po.ComparePriceEntity;
import po.book.Book;
import po.book.BookDetailInfo;
import po.user.UserDetailInfo;
import util.recommend.InterestUtil;
import util.sql.SQL4PersonalInfo;
import util.sql.SQLUtil;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class SingleItem extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	// 加入待借清单
	public String addToShoppingCart() throws Exception{
		System.out.println("执行SingleItem的addToShoppingCart方法");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		if(weid == null){
			return "reg";	// 需要先注册
		}
		Boolean flag = SQL4PersonalInfo.addToShoppingCart(bookno, weid);
		if(flag){
			return "ok";
		}
		return "fail";
	}
	
	
	// 预定
	public String addToReserve() throws Exception{
		System.out.println("执行SingleItem的addToReserve方法");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		String orderFlag = request.getParameter("orderFlag");
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		context.put("bookno", bookno);
		if(orderFlag.equals("yes")){
			UserDetailInfo user = SQLUtil.querySingleUser("weid", weid);
			context.put("user", user);
			return "order";
		}else{
			if(weid.isEmpty() || weid.equals("null")){
				return "reg";	
			}
			Boolean flag = SQL4PersonalInfo.addToReserve(weid, bookno);
			if(flag){
				return "ok";
			}
			return "fail";
		}
	}
	
	// 预定成功跳转
	public String setOrderSuccess(){
		return "ok";
	}
	
	
	// 书评
	public String getBookComments() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		HttpSession session = request.getSession();
		session.setAttribute("weid", weid);
		session.setAttribute("commentbookno", bookno);
		
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		context.put("bookno", bookno);
		ArrayList<Comment> list = SQLUtil.getBookComments(bookno);
		context.put("commentlist", list);
		
		String bookname = "";
		String score = "";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://127.0.0.1:3306/library" , "root", "root");
			Statement s = con.createStatement();
			String query = "select bookname,score from book where bookno = " + bookno +";";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {  
				bookname = ret.getString(1);
				score = ret.getString(2);
            }
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		context.put("bookname", bookname);
		context.put("score",score);
		
		return "ok";
	}
	
	
	// 用户添加评论
	public void createNewComment() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		
		String weid = request.getParameter("weid");
		String bookno = (String) request.getSession().getAttribute("commentbookno");
		String comment = request.getParameter("comment");
		SQLUtil.handleNewComment(weid, bookno, comment);
		
//		PrintWriter pw = response.getWriter();
//		pw.write("success");
//		pw.flush();
//		pw.close();
		
		String url = response.encodeURL("/library/get_book_comments?weid=" + weid + "&bookno=" + bookno);  
		System.out.println("url:" + url);
		response.sendRedirect(url);
	}
	
	
	// 目录
	public String getBookOutline() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		HashMap<String,String> bookInfo = SQLUtil.getBookOutline(bookno);
		
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		context.put("bookno",bookno);
		context.put("outline", bookInfo.get("outline"));
		context.put("bookname",bookInfo.get("bookname"));
		
		return "ok";
	}
	
	
	// 查看书籍序言
	public String getBookXu() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		HashMap<String,String> bookInfo = SQLUtil.getBookXu(bookno);
		
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		context.put("bookno",bookno);
		context.put("xu", bookInfo.get("xu"));
		context.put("bookname",bookInfo.get("bookname"));
		
		return "ok";
	}
	
	
	// 添加、取消收藏,并增加或减少喜爱度
	public void addToLike() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String flag = request.getParameter("flag");
		String bookno = request.getParameter("bookno");
		String weid = request.getParameter("weid");
		if(flag.equals("Y")){
			SQL4PersonalInfo.addToLike(weid, bookno);
			InterestUtil.clickLike(weid, bookno, true);
		}else if(flag.equals("N")){
			SQL4PersonalInfo.deleteLike(weid, bookno);
			InterestUtil.clickLike(weid, bookno, false);
		}
	}
	
	
	// 显示单本书籍
	@Override
	public String execute() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        String weid = request.getParameter("weid");
        
        String bookno = request.getParameter("bookno");
        //点击事件增加用户喜爱度
        InterestUtil.clickBook(weid, bookno);
		if(bookno == null){ 
			bookno = "1";  // 测试用例：显示编号为1的书籍信息
		}
		// 获取书籍信息
        BookDetailInfo book = SQLUtil.querySingleBookFromCat(bookno);
        ActionContext context = ActionContext.getContext();
        context.put("weid", weid);
        context.put("book", book);
        // 获取标签
        ArrayList<String> tags = SQLUtil.getBookTags(bookno);
        context.put("tags", tags);
        // 获取相关书籍信息
        ArrayList<Book> relativeBooks = SQLUtil.relativeBooks(bookno, book.getCategory());
        int size = relativeBooks.size();
        int a = (int)(Math.random()*size);
        int b = (int)(Math.random()*size);
        context.put("book1", relativeBooks.get(a));
        context.put("book2", relativeBooks.get(b));
        // 是否已被收藏
        String likeFlag = SQL4PersonalInfo.judgeLike(weid, bookno);
        System.out.println(likeFlag);
        HttpSession session = request.getSession();
        session.setAttribute("weid", weid);
        session.setAttribute("likeFlag", likeFlag);
        
        // 价格
        String bookname = book.getBookname();
        bookname = URLEncoder.encode(bookname, "gbk");	// 书名
        //爬取的网站与关键字
  		String catchUrl = "http://book.manmanbuy.com/Search.aspx?key=" + bookname;
  		System.out.println("URL：" + bookname);
  		
  		List<ComparePriceEntity> myEntity = new ArrayList<ComparePriceEntity>();
  		myEntity = getEntity(catchUrl);
  		context.put("price_list", myEntity);
        
		return SUCCESS;
	}
	
	public static String catchData(String url){
		//定义存储网页内容的字符串
		String result = "";
		//定义缓冲字符输入流
		BufferedReader in = null;
		try {
			//将string转化成url对象
			URL realUrl = new URL(url);
			//初始化连接
			URLConnection connection = realUrl.openConnection();
			//反反爬虫
			connection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36");
			//开始实际的连接
			connection.connect();
			//初始化BufferedReader输入流来读取URL的响应
			in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			//用于临时存储每一行数据
			String line;
			while((line = in.readLine()) != null){
				//遍历每一行存储到result
				result += line + "\n";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (in != null) {
					in.close();
				}
			} catch (Exception e2){
				e2.printStackTrace();
			}
		}
	
		return result;
	}
	
	
	public static List<ComparePriceEntity> getEntity(String catchUrl){
		//存储爬取的数据
		//"http://book.manmanbuy.com/Search.aspx?key=%BB%FA%C6%F7%D1%A7%CF%B0%D3%EBR%D3%EF%D1%D4"
		String result = catchData(catchUrl);
		//获取网站名称
		List<String> site = new ArrayList<String>();
		Pattern pattern = Pattern.compile("<div class='sitediv'>(.+?)：</div>");
		Matcher matcher = pattern.matcher(result);
		while(matcher.find()){
			System.out.println("找到了网站");
			System.out.println(matcher.group(1));
			site.add(matcher.group(1));
		}
		//获取价格
		List<String> price = new ArrayList<String>();
		pattern = Pattern.compile("<div class='pricediv'>(.+?)</div>");
		matcher = pattern.matcher(result);
		while(matcher.find()){
			System.out.println("找到了价格");
			System.out.println(matcher.group(1));
			price.add(matcher.group(1));
		}
		//获取网站连接
		List<String> url = new ArrayList<String>();
		pattern = Pattern.compile("href=\"(.+?)\" target='_blank'");
		matcher = pattern.matcher(result);
		while(matcher.find()){
			System.out.println("找到了链接");
			System.out.println(matcher.group(1));
			String[] nets = matcher.group(1).split("=");
			url.add(nets[2]);
		}
		//加入List中
		List<ComparePriceEntity> entity = new ArrayList<ComparePriceEntity>();
		for(int i = 0; i < site.size(); i++){
			ComparePriceEntity comparePriceEntity = new ComparePriceEntity();
			comparePriceEntity.setSite(site.get(i));
			comparePriceEntity.setPrice(price.get(i));
			comparePriceEntity.setGoodUrl(url.get(i));
			entity.add(comparePriceEntity);
		}
		return entity;
	}
	
}
