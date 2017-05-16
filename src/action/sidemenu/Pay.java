package action.sidemenu;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;

import po.BookWithouImg;
import util.SQL4PersonalInfo;

import com.opensymphony.xwork2.ActionSupport;

public class Pay extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	@Override
	public String execute() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		String weid = request.getParameter("weid");
		StringBuffer sb = new StringBuffer(); // 二维码的内容
		
		BookWithouImg book1 = new BookWithouImg();
		book1.setBookno(request.getParameter("bookno1"));
		book1.setBookname(request.getParameter("bookname1"));
		sb.append( book1.getBookno() + "||" );
		
		BookWithouImg book2 = new BookWithouImg();
		if(request.getParameter("bookno2") != null){
			book2.setBookno(request.getParameter("bookno2"));
			book2.setBookname(request.getParameter("bookname2"));
			sb.append(book2.getBookno());
		}
		// 添加借阅
		SQL4PersonalInfo.addToBorrow(weid, book1, book2);
		return SUCCESS;
	}
}
