package action.sidemenu;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;

import po.BorrowedBook;
import util.SQL4PersonalInfo;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

// 正在借的书
public class Borrow extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	public String getLeftTime(){
		HttpServletRequest request = ServletActionContext.getRequest();
		String bookno = request.getParameter("bookno");
		
		return "ok";
	}
	
	@Override 
	public String execute() throws Exception {
		ArrayList<BorrowedBook> bookList = new ArrayList<BorrowedBook>();
		
		// 获取前台传来的参数weid
		HttpServletRequest request = ServletActionContext.getRequest();
		String weid = request.getParameter("weid");
		// 获取用户曾经借阅的书
		bookList = SQL4PersonalInfo.queryMyBorrow2(weid);
		ActionContext context = ActionContext.getContext();
		context.put("booklist", bookList);
		
		return SUCCESS;
	}
	
}
