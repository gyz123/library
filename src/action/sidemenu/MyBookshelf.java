package action.sidemenu;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;

import po.Book;
import po.BookInCategory;
import util.SQL4PersonalInfo;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class MyBookshelf extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	@Override 
	public String execute() throws Exception {
		ArrayList<BookInCategory> bookList = new ArrayList<BookInCategory>();
		
		// 获取前台传来的参数weid
		HttpServletRequest request = ServletActionContext.getRequest();
		String weid = request.getParameter("weid");
		// 获取用户的收藏列表
		bookList = SQL4PersonalInfo.queryMyBookshelf(weid);
		BookInCategory book = new BookInCategory();
		book.setBookno("123456");
		book.setBookname("测试用例");
		book.setAuthor("马哲");
		bookList.add(book);
		bookList.add(book);
		bookList.add(book);
		bookList.add(book);
		bookList.add(book);
		
		ActionContext context = ActionContext.getContext();
		context.put("pagenum","1");
		context.put("booklist", bookList);
		
		return SUCCESS;
	}
	
}
