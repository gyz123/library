package action.page;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

import po.book.BookInCategory;
import util.pinyin.Chinese;
import util.pinyin.ChineseUtil;
import util.pinyin.KeywordUtil;
import util.pinyin.PinyinUtils;
import util.sql.SQLUtil;
import util.weixin.WeixinUtil;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class SearchList extends ActionSupport{
	private static final long serialVersionUID=1L;

	// �Զ���ȫ
	public void getKeywords() throws IOException{
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        String keyword = URLDecoder.decode(request.getParameter("keyword"),"utf-8");//���������������
        keyword = KeywordUtil.keywordToPinyin(keyword);//ƴ���ִ�
        System.out.println("keyword=" + keyword);
        StringBuffer sb = new StringBuffer();
//      ��ʽ��['�ٶ�1', '�ٶ�2', '�ٶ�3', '�ٶ�4', '�ٶ�5', '�ٶ�6', '�ٶ�7','a4','b1','b2','b3','b4' ]
        sb.append("['");
        try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select bookname from pinyin " + " where pinyin like '" + keyword + "%' limit " + " 0,5;";
			System.out.println(query);
//			Connection con = DriverManager.getConnection(
//					"jdbc:mysql://127.0.0.1:3306/library" , "root", "root");
//			Statement s = con.createStatement();
//			String query = "select bookname from book " + "where bookname like '" + keyword +"%' limit " + " 0,5;";
			ResultSet ret = s.executeQuery(query);
			// ��ȡ�鼮��Ϣ
			while (ret.next()) {  
				String bookname = ret.getString(1);
				if(!sb.toString().contains(bookname)){
					sb.append(bookname);
					sb.append("','");  
				}
            }
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
        if(sb.toString().contains(",")){
        	sb.deleteCharAt(sb.lastIndexOf(","));
        }
        sb.deleteCharAt(sb.lastIndexOf("'"));
        sb.append("]");
        
        ActionContext context = ActionContext.getContext();
        context.put("var",sb.toString());
        PrintWriter pw = response.getWriter();
        pw.write(sb.toString());
        pw.flush();
        pw.close();
	}
	
	
	// ����
	@Override
	public String execute() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        String weid = request.getParameter("weid");
        if(weid == null || weid.isEmpty() || weid.equals("null")){
        	HttpSession session = request.getSession(false);
        	weid = (String)session.getAttribute("weid");
        }
        
        // �����������
        String pageNum = request.getParameter("pagenum");
        if(pageNum == null){
        	pageNum = "1";
        }
        String keyword = URLDecoder.decode(request.getParameter("keyword"),"utf-8");
        if(keyword == null){
        	keyword = "��ʷ";
        }
        String numRegex = "[0-9]{8,}";
        
        String flag = "pinyin";
        //keyword = KeywordUtil.keywordToPinyin(keyword);//ƴ���ִ�
        if(ChineseUtil.isChinese(keyword)){
        	flag = "chinese";
        }
        if(keyword.matches(numRegex)){
        	flag = "isbn";
        }
        
        ArrayList<BookInCategory> searchList = SQLUtil.querySingleBookFromSearch(flag,keyword, pageNum);
        ActionContext context = ActionContext.getContext();
        context.put("weid", weid);
        context.put("keyword",keyword);
        context.put("pagenum", pageNum);
        context.put("booklist", searchList);
        
        return SUCCESS;
	}
}
