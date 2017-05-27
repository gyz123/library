package action.manager;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import po.Book;
import po.BookDetailInfo;
import util.SQLUtil;

import com.opensymphony.xwork2.ActionSupport;

public class SearchBook extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	// 管理员点开一本书后，依据bookno，返回该本书的详细信息
	public String searchSingle() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		String bookNo = request.getParameter("bookno");
		BookDetailInfo book = SQLUtil.querySingleBookFromCat(bookNo);

		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("UTF-8");
		PrintWriter pw = response.getWriter();
		pw.write(book.toString()); // 返回当前书本信息
		pw.flush();
		pw.close();
		
		return null;
	}
	
	// 管理员输入书的名字，依据bookname，返回具有关键字的书的简略信息
//	public String searchList() throws IOException{
//		HttpServletRequest request = ServletActionContext.getRequest();
//		String bookName = request.getParameter("bookname");
//		ArrayList<Book> bookSearchList = new ArrayList<Book>();
//		bookSearchList = SQLUtil.querySingleBookFromSearch(bookName, "1");
//		
//		StringBuffer sb = new StringBuffer();
//		Iterator<Book> iterator = bookSearchList.iterator();
//		while(iterator.hasNext()){
//			Book book = iterator.next();
//			sb.append(book.toString());
//		}
//		
//		HttpServletResponse response = ServletActionContext.getResponse();
//		response.setCharacterEncoding("UTF-8");
//		PrintWriter pw = response.getWriter();
//		pw.write(sb.toString());
//		pw.flush();
//		pw.close();
//		
//		return null;
//	}
	
	public String searchList() throws IOException {
		HttpServletRequest request = ServletActionContext.getRequest();
		String bookName = request.getParameter("bookname");
		BookDetailInfo book = SQLUtil.querySingleBookByKeyword(bookName);

		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("UTF-8");
		PrintWriter pw = response.getWriter();
		pw.write(book.toString());
		pw.flush();
		pw.close();

		return null;
	}
	
	// 获取初始书籍列表
	public String bookList() throws IOException{
		ArrayList<BookDetailInfo> bookList = new ArrayList<BookDetailInfo>();
		bookList = SQLUtil.querySingleCat3("('成功励志','教育','管理')", "1");
		
		StringBuffer sb = new StringBuffer();
		Iterator<BookDetailInfo> iterator = bookList.iterator();
		while(iterator.hasNext()){
			BookDetailInfo book = iterator.next();
			sb.append(book.toString());
		}
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("UTF-8");
		PrintWriter pw = response.getWriter();
		pw.write(sb.toString());
		pw.flush();
		pw.close();
		
		return null;
	}

}
