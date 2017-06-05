package action.page;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import po.BookDetailInfo;
import po.Comment;
import util.SQL4PersonalInfo;
import util.SQLUtil;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class SingleItem extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	// 待借清单
	public String addToShoppingCart() throws Exception{
		System.out.println("执行SingleItem的addToShoppingCart方法");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		SQL4PersonalInfo.addToShoppingCart(bookno, weid);
		ActionContext context = ActionContext.getContext();
        context.put("weid", weid);
		 
		return "ok";
	}
	
	
	// 预定
	public String addToReserve() throws Exception{
		System.out.println("执行SingleItem的addToReserve方法");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		ActionContext context = ActionContext.getContext();
        context.put("weid", weid);
		Boolean flag = SQL4PersonalInfo.addToReserve(weid, bookno);
		if(flag){
			return "ok";
		}
		return "fail";
	}
	
	
	// 书评
	public String getBookComments() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
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
	
	
	// 显示单本书籍
	@Override
	public String execute() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        String weid = request.getParameter("weid");
        
        String bookno = request.getParameter("bookno");
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
        
		return SUCCESS;
	}

}
