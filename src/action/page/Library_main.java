package action.page;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import po.Book;

import util.SQLUtil;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class Library_main extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	// 进入单类书籍页面
	public String enterWenxue() throws UnsupportedEncodingException{
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
		
        // 获取搜索条件
        String catName = request.getParameter("id");
        String pageNum = request.getParameter("pagenum");
        if(pageNum == null){
        	pageNum = "1";
        }
        System.out.println("pagenum:" + pageNum + " id:" + catName);
        
		ArrayList<Book> bookList = new ArrayList<Book>();
		ActionContext context = ActionContext.getContext();
		// 文学：中国文学、外国文学
       	if(catName.equals("wenxue")){
       		bookList = SQLUtil.querySingleCat("('中国文学','外国文学')", pageNum);
//       		String str = SQLUtil.querySingleCat2("('中国文学','外国文学')", pageNum);
//       		String[] dataList = str.split("##");
//       		System.out.println("共 " + dataList.length + " 本书");
//       		for(int i=0; i<dataList.length; i++){
//       			Book book = new Book();
//       			System.out.println("当前书本信息: " + dataList[i]);
//       			String[] bookdata = dataList[i].split(";;");
//       			System.out.println("每本书 " + bookdata.length + " 条数据: ");
//       			book.setBookno(bookdata[0]);
//            	book.setBookname(bookdata[1]);
//            	book.setBookimg(bookdata[2]);
//            	bookList.add(book);
//       		}
       		context.put("booklist", bookList);
       		
       	}
       	// 传记
       	else if(catName.equals("zhuanji")){
       		bookList = SQLUtil.querySingleCat("('人物传记')", pageNum);
       		if (bookList.size() > 0) {
				context.put("booklist", bookList);
			}
//       		String str = SQLUtil.querySingleCat2("('人物传记')", pageNum);
//       		String[] dataList = str.split("##");
//       		for(int i=0; i<dataList.length; i++){
//       			Book book = new Book();
//       			String[] bookdata = dataList[i].split(";;");
//       			book.setBookno(bookdata[0]);
//            	book.setBookname(bookdata[1]);
//            	book.setBookimg(bookdata[2]);
//            	bookList.add(book);
//       		}
       		context.put("booklist", bookList);
       	}
       	// 历史
       	else if(catName.equals("lishi")){
//       		bookList = SQLUtil.querySingleCat("('历史')", pageNum);
//       		if (bookList.size() > 0) {
//				context.put("booklist", bookList);
//			}
       		String str = SQLUtil.querySingleCat2("('历史')", pageNum);
       		String[] dataList = str.split("##");
       		for(int i=0; i<dataList.length; i++){
       			Book book = new Book();
       			String[] bookdata = dataList[i].split(";;");
       			book.setBookno(bookdata[0]);
            	book.setBookname(bookdata[1]);
            	book.setBookimg(bookdata[2]);
            	bookList.add(book);
       		}
       		context.put("booklist", bookList);
       	}
       	// 哲学
       	else if(catName.equals("zhexue")){
//       		bookList = SQLUtil.querySingleCat("('哲学')", pageNum);
//       		if (bookList.size() > 0) {
//				context.put("booklist", bookList);
//			}
       		String str = SQLUtil.querySingleCat2("('哲学')", pageNum);
       		String[] dataList = str.split("##");
       		for(int i=0; i<dataList.length; i++){
       			Book book = new Book();
       			String[] bookdata = dataList[i].split(";;");
       			book.setBookno(bookdata[0]);
            	book.setBookname(bookdata[1]);
            	book.setBookimg(bookdata[2]);
            	bookList.add(book);
       		}
       		context.put("booklist", bookList);
       	}
       	// 儿童
       	else if(catName.equals("ertong")){
//       		bookList = SQLUtil.querySingleCat("('儿童文学')", pageNum);
//       		if (bookList.size() > 0) {
//				context.put("booklist", bookList);
//			}
       		String str = SQLUtil.querySingleCat2("('儿童')", pageNum);
       		String[] dataList = str.split("##");
       		for(int i=0; i<dataList.length; i++){
       			Book book = new Book();
       			String[] bookdata = dataList[i].split(";;");
       			book.setBookno(bookdata[0]);
            	book.setBookname(bookdata[1]);
            	book.setBookimg(bookdata[2]);
            	bookList.add(book);
       		}
       		context.put("booklist", bookList);
       	}
       	// 小说
       	else if(catName.equals("xiaoshuo")){
//       		bookList = SQLUtil.querySingleCat("('小说')", pageNum);
//       		if (bookList.size() > 0) {
//				context.put("booklist", bookList);
//			}
       		String str = SQLUtil.querySingleCat2("('小说')", pageNum);
       		String[] dataList = str.split("##");
       		for(int i=0; i<dataList.length; i++){
       			Book book = new Book();
       			String[] bookdata = dataList[i].split(";;");
       			book.setBookno(bookdata[0]);
            	book.setBookname(bookdata[1]);
            	book.setBookimg(bookdata[2]);
            	bookList.add(book);
       		}
       		context.put("booklist", bookList);
       	}
       	// 心理：鸡汤、心理
       	else if(catName.equals("xinli")){
//       		bookList = SQLUtil.querySingleCat("('心灵鸡汤','心理学')", pageNum);
//       		if (bookList.size() > 0) {
//				context.put("booklist", bookList);
//			}
       		String str = SQLUtil.querySingleCat2("('心灵鸡汤','心理学')", pageNum);
       		String[] dataList = str.split("##");
       		for(int i=0; i<dataList.length; i++){
       			Book book = new Book();
       			String[] bookdata = dataList[i].split(";;");
       			book.setBookno(bookdata[0]);
            	book.setBookname(bookdata[1]);
            	book.setBookimg(bookdata[2]);
            	bookList.add(book);
       		}
       		context.put("booklist", bookList);
       	}
       	// 社会：成功励志、教育、管理
       	else if(catName.equals("zhexue")){
//       		bookList = SQLUtil.querySingleCat("('成功励志','教育','管理')", pageNum);
//       		if (bookList.size() > 0) {
//				context.put("booklist", bookList);
//			}
       		String str = SQLUtil.querySingleCat2("('成功励志','教育','管理')", pageNum);
       		String[] dataList = str.split("##");
       		for(int i=0; i<dataList.length; i++){
       			Book book = new Book();
       			String[] bookdata = dataList[i].split(";;");
       			book.setBookno(bookdata[0]);
            	book.setBookname(bookdata[1]);
            	book.setBookimg(bookdata[2]);
            	bookList.add(book);
       		}
       		context.put("booklist", bookList);
       	}
       	// 计算机
       	else if(catName.equals("jisuanji")){
//       		bookList = SQLUtil.querySingleCat("('计算机')", pageNum);
//       		if (bookList.size() > 0) {
//				context.put("booklist", bookList);
//			}
       		String str = SQLUtil.querySingleCat2("('计算机')", pageNum);
       		String[] dataList = str.split("##");
       		for(int i=0; i<dataList.length; i++){
       			Book book = new Book();
       			String[] bookdata = dataList[i].split(";;");
       			book.setBookno(bookdata[0]);
            	book.setBookname(bookdata[1]);
            	book.setBookimg(bookdata[2]);
            	bookList.add(book);
       		}
       		context.put("booklist", bookList);
       	}
		return "ok";
	}
	
	@Override // 进入首页
	public String execute() throws Exception {
		
		return SUCCESS;
	}

}
