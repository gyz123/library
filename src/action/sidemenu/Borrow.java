package action.sidemenu;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
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
		String borrowtime = "";
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://127.0.0.1:3306/library" , "root", "root");
			Statement s = con.createStatement();
			
			String query = "select borrowtime from borrow where bookno = " + bookno + 
							"and returntime is null;"; 
			ResultSet ret = s.executeQuery(query);
			// 将搜索到的9本书放入ArrayList中
			while (ret.next()) {  
				borrowtime = ret.getString(1);
            }
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		String datas[];
		String month,day;
		if(!borrowtime.isEmpty()){
			datas = borrowtime.split("-");
			month = datas[1];
			day = datas[2];
		}
		
		
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
