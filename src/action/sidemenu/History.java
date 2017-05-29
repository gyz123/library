package action.sidemenu;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;

import po.BorrowedBook;

import util.SQL4PersonalInfo;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;


public class History extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	@Override
	public String execute() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		String weid = request.getParameter("weid");
		
		Map<String, HashMap<String,Integer>> info = new HashMap<String, HashMap<String,Integer>>();
		info = SQL4PersonalInfo.getPersonalBookInfo(weid);
		
		Set<String> mapKey = info.keySet();
		for(String str:mapKey){
			// 种类分类文本
			if(str.equals("cat")){
				createCat(info.get(str));
			}
			// 年度分类文本
			else if(str.equals("year")){
				createYear(info.get(str));
			}
			// 月度分类文本
			else if(str.equals("month")){
				createMonth(info.get(str));
			}
		}
		
		ArrayList<BorrowedBook> bookList = SQL4PersonalInfo.queryMyBorrow(weid);
		ActionContext context = ActionContext.getContext();
		context.put("booklist", bookList);
		
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
	
	
}
