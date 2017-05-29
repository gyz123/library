package action.sidemenu;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;

import po.BorrowedBook;
import util.SQL4PersonalInfo;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

// 正在借的书
public class Borrow extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	public String getPastTime(){
		HttpServletRequest request = ServletActionContext.getRequest();
		String bookno = request.getParameter("bookno");
		String borrowtime = "";
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://127.0.0.1:3306/library" , "root", "root");
			Statement s = con.createStatement();
			
			String query = "select borrowtime from borrow where bookno = " + bookno + 
							" and returntime is null;"; 
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {  
				borrowtime = ret.getString(1);
            }
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		String datas[];
		int month = 1,day = 1;
		if(!borrowtime.isEmpty()){
			datas = borrowtime.split("-");
			month = Integer.parseInt(datas[1]);
			day = Integer.parseInt(datas[1]);
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String nowDate = sdf.format(new Date());
		String datas1[] = nowDate.split("-");
		int nowMonth = Integer.parseInt(datas1[1]);
		int nowDay = Integer.parseInt(datas1[2]);
		
		int temp = 1;
		if(nowDay >= day){
			temp = nowDay - day + 1;
		}else{
			switch(month){
				case 2: temp = 28-day+1+nowDay; break;
				case 4:
				case 6:
				case 9:
				case 11:temp = 28-day+1+nowDay; break;
				default: temp = 31-day+1+nowDay; break;
			}
		}
		// 这本书已经借阅的时间
		int rate = (int)(100*temp*1.0/30);
		ActionContext context = ActionContext.getContext();
		context.put("rate", rate);
		
		return "ok";
	}
	
	@Override 
	public String execute() throws Exception {
		ArrayList<BorrowedBook> bookList = new ArrayList<BorrowedBook>();
		
		// 获取前台传来的参数weid
		HttpServletRequest request = ServletActionContext.getRequest();
		String weid = request.getParameter("weid");
		if(weid == null){
			weid = "1";
		}
		// 获取用户曾经借阅的书
		bookList = SQL4PersonalInfo.queryMyBorrow2(weid);
		ActionContext context = ActionContext.getContext();
		context.put("booklist", bookList);
		
		return SUCCESS;
	}
	
}
