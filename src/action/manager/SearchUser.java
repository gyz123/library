package action.manager;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import po.UserDetailInfo;
import util.SQLUtil;

import com.opensymphony.xwork2.ActionSupport;

public class SearchUser extends ActionSupport{
	private static final long serialVersionUID=1L;

	// 获取所有用户的的详细信息
	public String searchList() throws IOException{
		ArrayList<UserDetailInfo> userList = new ArrayList<UserDetailInfo>();
		userList = SQLUtil.queryUserList();
		
		StringBuffer sb = new StringBuffer();
		Iterator<UserDetailInfo> iterator = userList.iterator();
		while(iterator.hasNext()){
			UserDetailInfo user = iterator.next();
			sb.append(user.toString());
		}
		
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("UTF-8");
		PrintWriter pw = response.getWriter();
		pw.write(sb.toString());
		pw.flush();
		pw.close();
		
		return null;
	}
	
	// 通过微信昵称搜索用户
	public String searchSingle() throws IOException{
		HttpServletRequest request = ServletActionContext.getRequest();
		String wename = request.getParameter("wename");
		UserDetailInfo user = SQLUtil.querySingleUser(wename); // 获取用户信息
		// 返回数据
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("UTF-8");
		PrintWriter pw = response.getWriter();
		pw.write(user.toString());
		pw.flush();
		pw.close();
		return null;
	}
	
}
