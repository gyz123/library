package action.page;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

import po.Comment;
import po.ComparePriceEntity;
import po.book.Book;
import po.book.BookDetailInfo;
import po.user.UserDetailInfo;
import util.recommend.InterestUtil;
import util.sql.SQL4PersonalInfo;
import util.sql.SQLUtil;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class SingleItem extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	// ��������嵥
	public String addToShoppingCart() throws Exception{
		System.out.println("ִ��SingleItem��addToShoppingCart����");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		if(weid == null){
			return "reg";	// ��Ҫ��ע��
		}
		Boolean flag = SQL4PersonalInfo.addToShoppingCart(bookno, weid);
		if(flag){
			return "ok";
		}
		return "fail";
	}
	
	
	// Ԥ��
	public String addToReserve() throws Exception{
		System.out.println("ִ��SingleItem��addToReserve����");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		String orderFlag = request.getParameter("orderFlag");
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		context.put("bookno", bookno);
		if(orderFlag.equals("yes")){
			UserDetailInfo user = SQLUtil.querySingleUser("weid", weid);
			context.put("user", user);
			return "order";
		}else{
			if(weid.isEmpty() || weid.equals("null")){
				return "reg";	
			}
			Boolean flag = SQL4PersonalInfo.addToReserve(weid, bookno);
			if(flag){
				return "ok";
			}
			return "fail";
		}
	}
	
	// Ԥ���ɹ���ת
	public String setOrderSuccess(){
		return "ok";
	}
	
	
	// ����
	public String getBookComments() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		HttpSession session = request.getSession();
		session.setAttribute("weid", weid);
		session.setAttribute("commentbookno", bookno);
		
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		context.put("bookno", bookno);
		ArrayList<Comment> list = SQLUtil.getBookComments(bookno);
		context.put("commentlist", list);
		
		String bookname = "";
		String score = "";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://127.0.0.1:3306/library" , "root", "root");
			Statement s = con.createStatement();
			String query = "select bookname,score from book where bookno = " + bookno +";";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {  
				bookname = ret.getString(1);
				score = ret.getString(2);
            }
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		context.put("bookname", bookname);
		context.put("score",score);
		
		return "ok";
	}
	
	
	// �û��������
	public void createNewComment() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		
		String weid = request.getParameter("weid");
		String bookno = (String) request.getSession().getAttribute("commentbookno");
		String comment = request.getParameter("comment");
		SQLUtil.handleNewComment(weid, bookno, comment);
		
//		PrintWriter pw = response.getWriter();
//		pw.write("success");
//		pw.flush();
//		pw.close();
		
		String url = response.encodeURL("/library/get_book_comments?weid=" + weid + "&bookno=" + bookno);  
		System.out.println("url:" + url);
		response.sendRedirect(url);
	}
	
	
	// Ŀ¼
	public String getBookOutline() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		HashMap<String,String> bookInfo = SQLUtil.getBookOutline(bookno);
		
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		context.put("bookno",bookno);
		context.put("outline", bookInfo.get("outline"));
		context.put("bookname",bookInfo.get("bookname"));
		
		return "ok";
	}
	
	
	// �鿴�鼮����
	public String getBookXu() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		HashMap<String,String> bookInfo = SQLUtil.getBookXu(bookno);
		
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		context.put("bookno",bookno);
		context.put("xu", bookInfo.get("xu"));
		context.put("bookname",bookInfo.get("bookname"));
		
		return "ok";
	}
	
	
	// ��ӡ�ȡ���ղ�,�����ӻ����ϲ����
	public void addToLike() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String flag = request.getParameter("flag");
		String bookno = request.getParameter("bookno");
		String weid = request.getParameter("weid");
		if(flag.equals("Y")){
			SQL4PersonalInfo.addToLike(weid, bookno);
			InterestUtil.clickLike(weid, bookno, true);
		}else if(flag.equals("N")){
			SQL4PersonalInfo.deleteLike(weid, bookno);
			InterestUtil.clickLike(weid, bookno, false);
		}
	}
	
	
	// ��ʾ�����鼮
	@Override
	public String execute() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        String weid = request.getParameter("weid");
        
        String bookno = request.getParameter("bookno");
        //����¼������û�ϲ����
        InterestUtil.clickBook(weid, bookno);
		if(bookno == null){ 
			bookno = "1";  // ������������ʾ���Ϊ1���鼮��Ϣ
		}
		// ��ȡ�鼮��Ϣ
        BookDetailInfo book = SQLUtil.querySingleBookFromCat(bookno);
        ActionContext context = ActionContext.getContext();
        context.put("weid", weid);
        context.put("book", book);
        // ��ȡ��ǩ
        ArrayList<String> tags = SQLUtil.getBookTags(bookno);
        context.put("tags", tags);
        // ��ȡ����鼮��Ϣ
        ArrayList<Book> relativeBooks = SQLUtil.relativeBooks(bookno, book.getCategory());
        int size = relativeBooks.size();
        int a = (int)(Math.random()*size);
        int b = (int)(Math.random()*size);
        context.put("book1", relativeBooks.get(a));
        context.put("book2", relativeBooks.get(b));
        // �Ƿ��ѱ��ղ�
        String likeFlag = SQL4PersonalInfo.judgeLike(weid, bookno);
        System.out.println(likeFlag);
        HttpSession session = request.getSession();
        session.setAttribute("weid", weid);
        session.setAttribute("likeFlag", likeFlag);
        
        // �۸�
        String bookname = book.getBookname();
        bookname = URLEncoder.encode(bookname, "gbk");	// ����
        //��ȡ����վ��ؼ���
  		String catchUrl = "http://book.manmanbuy.com/Search.aspx?key=" + bookname;
  		System.out.println("URL��" + bookname);
  		
  		List<ComparePriceEntity> myEntity = new ArrayList<ComparePriceEntity>();
  		myEntity = getEntity(catchUrl);
  		context.put("price_list", myEntity);
        
		return SUCCESS;
	}
	
	public static String catchData(String url){
		//����洢��ҳ���ݵ��ַ���
		String result = "";
		//���建���ַ�������
		BufferedReader in = null;
		try {
			//��stringת����url����
			URL realUrl = new URL(url);
			//��ʼ������
			URLConnection connection = realUrl.openConnection();
			//��������
			connection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36");
			//��ʼʵ�ʵ�����
			connection.connect();
			//��ʼ��BufferedReader����������ȡURL����Ӧ
			in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			//������ʱ�洢ÿһ������
			String line;
			while((line = in.readLine()) != null){
				//����ÿһ�д洢��result
				result += line + "\n";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (in != null) {
					in.close();
				}
			} catch (Exception e2){
				e2.printStackTrace();
			}
		}
	
		return result;
	}
	
	
	public static List<ComparePriceEntity> getEntity(String catchUrl){
		//�洢��ȡ������
		//"http://book.manmanbuy.com/Search.aspx?key=%BB%FA%C6%F7%D1%A7%CF%B0%D3%EBR%D3%EF%D1%D4"
		String result = catchData(catchUrl);
		//��ȡ��վ����
		List<String> site = new ArrayList<String>();
		Pattern pattern = Pattern.compile("<div class='sitediv'>(.+?)��</div>");
		Matcher matcher = pattern.matcher(result);
		while(matcher.find()){
			System.out.println("�ҵ�����վ");
			System.out.println(matcher.group(1));
			site.add(matcher.group(1));
		}
		//��ȡ�۸�
		List<String> price = new ArrayList<String>();
		pattern = Pattern.compile("<div class='pricediv'>(.+?)</div>");
		matcher = pattern.matcher(result);
		while(matcher.find()){
			System.out.println("�ҵ��˼۸�");
			System.out.println(matcher.group(1));
			price.add(matcher.group(1));
		}
		//��ȡ��վ����
		List<String> url = new ArrayList<String>();
		pattern = Pattern.compile("href=\"(.+?)\" target='_blank'");
		matcher = pattern.matcher(result);
		while(matcher.find()){
			System.out.println("�ҵ�������");
			System.out.println(matcher.group(1));
			String[] nets = matcher.group(1).split("=");
			url.add(nets[2]);
		}
		//����List��
		List<ComparePriceEntity> entity = new ArrayList<ComparePriceEntity>();
		for(int i = 0; i < site.size(); i++){
			ComparePriceEntity comparePriceEntity = new ComparePriceEntity();
			comparePriceEntity.setSite(site.get(i));
			comparePriceEntity.setPrice(price.get(i));
			comparePriceEntity.setGoodUrl(url.get(i));
			entity.add(comparePriceEntity);
		}
		return entity;
	}
	
}
