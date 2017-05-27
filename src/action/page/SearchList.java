package action.page;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import po.Book;
import po.BookDetailInfo;
import po.BookInCategory;
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
        String keyword = request.getParameter("search");
        if(keyword == null){
        	keyword = "历史";
        }
        
        ArrayList<BookInCategory> searchList = SQLUtil.querySingleBookFromSearch(keyword, pageNum);
        ActionContext context = ActionContext.getContext();
        context.put("keyword",keyword);
        context.put("pagenum", pageNum);
        context.put("booklist", searchList);
        
        return SUCCESS;
	}
}
