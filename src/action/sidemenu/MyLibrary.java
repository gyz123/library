package action.sidemenu;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

import po.ReserveOrder;
import po.book.BookDetailInfo;
import po.book.BookInCategory;
import po.book.BookInCurrentList;
import po.book.BorrowedBook;
import po.user.UserDetailInfo;
import util.sql.SQL4PersonalInfo;
import util.sql.SQLUtil;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class MyLibrary extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	// 主界面
	@Override
	public String execute() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		if(weid == null || weid.isEmpty()){
			weid = (String)request.getSession(false).getAttribute("weid");
		}
		// 获取用户信息
		UserDetailInfo user = SQL4PersonalInfo.queryUser(weid);		
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		context.put("user", user);
		
		return SUCCESS;
	}
	
	// 当前借阅
	public String enterCurrent() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		// 正在看的书
		ArrayList<BookInCurrentList> bookList = SQL4PersonalInfo.getCurrentReading("now", weid);
		context.put("booklist", bookList);
		
		return "ok";
	}
	
	// 历史记录
	public String enterHistory() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		// 借过的书
		ArrayList<BookInCurrentList> bookList = SQL4PersonalInfo.getCurrentReading("history", weid);
		context.put("booklist", bookList);
		
		return "ok";
	}
	// 阅读评价
	public String enterComment() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		// 当前书籍
		BookDetailInfo book = SQLUtil.querySingleBookFromCat(bookno);
		context.put("book", book);
		
		HttpSession session = request.getSession();
		session.setAttribute("weid", weid);
		session.setAttribute("commentbookno", bookno);
		
		return "ok";
	}
	// 提交评价
	public void submitComment() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = (String) request.getSession().getAttribute("commentbookno");
		String comment = request.getParameter("comment");
		System.out.println("用户评分：" + request.getParameter("fen"));
		// 提交评价
		SQLUtil.handleNewComment(weid, bookno, comment);
		SQLUtil.updateCommentStatus(weid, bookno);
	}
	
	
	// 我的预定
	public String enterOrder() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		// 订单列表
		ArrayList<ReserveOrder> list = SQL4PersonalInfo.getReserveOrder(weid);
		context.put("booklist", list);
	
		return "ok";
	}
	// 取消订单
	public void cancelOrder() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		// 取消订单
		SQL4PersonalInfo.cancelReserveOrder(weid, bookno);

		// 刷新页面
		Thread.sleep(2000);
		HttpServletResponse response = ServletActionContext.getResponse();
        response.setCharacterEncoding("utf-8");
		String url = response.encodeURL("/library/enter_order.action?weid=" + weid);  
		response.sendRedirect(url);
	}
	
	
	// 资料修改
	public String enterInfo() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
	
		// 用户原始资料
		UserDetailInfo user = SQL4PersonalInfo.queryUser(weid);
		context.put("user", user);
		
		return "ok";
	}
	// 确认修改
	public String confirmModify() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weID");
		String username = request.getParameter("name");
		String phone = request.getParameter("tel");
		String idcard = request.getParameter("IDNumber");
		// 修改
		SQL4PersonalInfo.modifyUserInfo(weid, username, phone, idcard);
		// 延时刷新
		Thread.sleep(2000);
		return "ok";
	}
	
	
	// 我的电子书
	public String enterEbook() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		
		// 获取已借阅的电子书
		ArrayList<BookInCategory> bookList = SQL4PersonalInfo.queryMyEBook(weid);
		context.put("booklist", bookList);
		
		return "ok";
	}
	// 开始阅读
	public String startReading() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		String chapter = request.getParameter("chapter");
		
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		context.put("bookno",bookno);
		context.put("pagenum", chapter);
		if(chapter == null || chapter.isEmpty() || Integer.parseInt(chapter) <= 0){
			chapter = "1";
		}
		
		HashMap<String,String> bookInfo = SQLUtil.getBookXu(bookno);
		context.put("bookname",bookInfo.get("bookname"));
		
		// 处理内容显示
		String content = SQLUtil.getBookContent(bookno, chapter);
        String[] strs = content.split("\n");
        ArrayList<String> contentlist = new ArrayList<String>();
        for(int i=0; i<strs.length; i++){
        	contentlist.add(strs[i].trim());
        }
	    context.put("contentlist", contentlist);
		
		return "ok";
	}
	
	
}
