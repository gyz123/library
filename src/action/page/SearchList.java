package action.page;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import po.Book;
import util.SQLUtil;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class SearchList extends ActionSupport{
	private static final long serialVersionUID=1L;

	@Override
	public String execute() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        
        // 获得搜索条件
        String pageNum = request.getParameter("pagenum");
        if(pageNum == null){
        	pageNum = "1";
        }
        String bookName = request.getParameter("bookname");
        
        ArrayList<Book> searchList = SQLUtil.querySingleBookFromSearch(bookName, pageNum);
        ActionContext context = ActionContext.getContext();
        context.put("searchlist", searchList);
        
        return SUCCESS;
	}
}
