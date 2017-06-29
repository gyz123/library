package action.page;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

import po.Comment;
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
        
		return SUCCESS;
	}
	
}
