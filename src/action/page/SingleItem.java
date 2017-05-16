package action.page;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import po.BookDetailInfo;
import util.SQLUtil;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class SingleItem extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	@Override
	public String execute() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        
        String bookno = request.getParameter("bookno");
		if(bookno == null){ 
			bookno = "1";  // 测试用例：显示编号为1的书籍信息
		}
        BookDetailInfo book = SQLUtil.querySingleBookFromCat(bookno);
        ActionContext context = ActionContext.getContext();
        context.put("book", book);
        
		return SUCCESS;
	}

}
