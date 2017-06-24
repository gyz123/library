package action.sidemenu;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import po.BorrowedBook;
import po.UserDetailInfo;

import util.EncryptUtil;
import util.SQL4PersonalInfo;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;


public class History extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	@Override
	public String execute() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		
//		Map<String, HashMap<String,Integer>> info = new HashMap<String, HashMap<String,Integer>>();
//		info = SQL4PersonalInfo.getPersonalBookInfo(weid);
//		
//		Set<String> mapKey = info.keySet();
//		for(String str:mapKey){
//			// 种类分类文本
//			if(str.equals("cat")){
//				createCat(info.get(str));
//			}
//			// 年度分类文本
//			else if(str.equals("year")){
//				createYear(info.get(str));
//			}
//			// 月度分类文本
//			else if(str.equals("month")){
//				createMonth(info.get(str));
//			}
//		}
//		
		ActionContext context = ActionContext.getContext();
		// 获取正在看的书
		ArrayList<BorrowedBook> nowList = SQL4PersonalInfo.queryMyBorrow2(weid);
		context.put("nowlist", nowList);
		// 获取借过的书
		ArrayList<BorrowedBook> bookList = SQL4PersonalInfo.queryMyBorrow(weid);
		context.put("booklist", bookList);
		// 获取用户信息
		UserDetailInfo user = SQL4PersonalInfo.queryUser(weid);		
		context.put("user", user);
		
		return SUCCESS;
	}
	
	
	private void createCat(HashMap<String,Integer> bookcat) throws IOException{
		StringBuffer sb = new StringBuffer();
		// 构建json串
		sb.append("{");
		sb.append("\"data\":[");
		sb.append("{\"value\":" + bookcat.get("a") + ",\"name\":\"文学、历史\"},");
		sb.append("{\"value\":" + bookcat.get("b") + ",\"name\":\"哲学、心理\"},");
		sb.append("{\"value\":" + bookcat.get("c") + ",\"name\":\"社会、励志\"},");
		sb.append("{\"value\":" + bookcat.get("d") + ",\"name\":\"科技\"}");
		sb.append("]");
		sb.append("}");
		
		// 将json串写入本地的txt中，供前台读取
		final String filename = "C:\\cat.txt";  
		FileWriter fw = new FileWriter(filename);
		BufferedWriter bw = new BufferedWriter(fw);
		// 将json串写入文本中
		bw.write(sb.toString());
		bw.newLine();
		bw.flush();
		bw.close();
		fw.close();
		
//		ActionContext context = ActionContext.getContext();
//		context.put("bookcat", sb.toString());
		
	}

	
	private void createYear(HashMap<String,Integer> bookYear) throws IOException{
		StringBuffer sb = new StringBuffer();
		sb.append("{");
		sb.append("\"title\":[\"2015\", \"2016\", \"2017\"],");
		sb.append("\"num\" : [" + bookYear.get("2015") + "," + bookYear.get("2016") + "," + bookYear.get("2017") + "]");
		sb.append("}");
		
		final String filename = "C:\\year.txt";  
		FileWriter fw = new FileWriter(filename);
		BufferedWriter bw = new BufferedWriter(fw);
		bw.write(sb.toString());
		bw.newLine();
		bw.flush();
		bw.close();
		fw.close();
		
	}
	
	
	private void createMonth(HashMap<String,Integer> bookMonth) throws IOException{
		StringBuffer sb = new StringBuffer();
		sb.append("{");
		sb.append("\"year\" : 2017,");
		sb.append("\"data\": [");
		Set<String> keySet = bookMonth.keySet();
		for(String month:keySet){
			sb.append(bookMonth.get(month) + ",");
		}
		sb.deleteCharAt(sb.toString().length()-1);
		sb.append("]");
		sb.append("}");
		
		final String filename = "C:\\month.txt";  
		FileWriter fw = new FileWriter(filename);
		BufferedWriter bw = new BufferedWriter(fw);
		bw.write(sb.toString());
		bw.newLine();
		bw.flush();
		bw.close();
		fw.close();
	}
	
	
	// 续借
	public void continueReading() throws Exception{
		System.out.println("执行History的continueReading方法");
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        
		String weid = request.getSession().getAttribute("weid").toString();
		String bookno = request.getParameter("bookno");
		SQL4PersonalInfo.setBorrowDate(weid, bookno);
		
		PrintWriter pw = response.getWriter();
		pw.write("续借成功");
		pw.flush();
		pw.close();
	}
	
	// 生成还书二维码
	public void returnBookCode() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getSession().getAttribute("weid").toString();
		String bookno = request.getParameter("bookno");
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		
		StringBuffer sb = new StringBuffer();
		sb.append("return,");
		sb.append(weid + ",");
		sb.append(bookno);
		
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		//进行AES加密
		String encryptResult = EncryptUtil.parseByte2HexStr(EncryptUtil.encrypt(sb.toString()));
		pw.write(encryptResult);
		pw.flush();
		pw.close();
	}
	
	// 监听归还状态
	public void listen_return_Status() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		
		// 获取书本归还状态
		String status = "N";
		if(SQL4PersonalInfo.listenReturn(weid,bookno) != null){
			status = "Y";
		}
		System.out.println("归还状态:" + status);
		
		// 返回状态给前台
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.write(status);
		pw.flush();
		pw.close();
	}
	
	public String returnSuccess(){
		return "OK";
	}
	
}
