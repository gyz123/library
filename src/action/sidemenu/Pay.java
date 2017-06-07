package action.sidemenu;

import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import po.BookInShoppingcart;
import po.PayList;
import po.UserDetailInfo;
import util.SQL4PersonalInfo;
import util.SQLUtil;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class Pay extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	// 生成二维码
	public void generateCode() throws Exception{
		System.out.println("执行Pay的generateCode方法");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		request.setAttribute("openid", weid);
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);

		// 保存订单
		String subscribenum = weid + System.currentTimeMillis();	// 生成订单号
		String bookno1 = request.getParameter("bookno1");
		String bookno2 = request.getParameter("bookno2");
		if (bookno1.isEmpty()) {
			bookno1 = "1"; // 测试数据
		}
		StringBuffer sb = new StringBuffer();
		PayList list1 = SQL4PersonalInfo.setPayList(weid, bookno1, subscribenum);
		SQL4PersonalInfo.saveOrder(weid, list1);
		sb.append(list1.getSubsribenum() + "," + list1.getBookno() + "||"); // 第一本书
		
		if (!( bookno2.isEmpty() || bookno2.equals("undefined") )) {
			PayList list2 = SQL4PersonalInfo.setPayList(weid, bookno2, subscribenum);
			SQL4PersonalInfo.saveOrder(weid, list2);
			sb.append(list2.getSubsribenum() + "," + list2.getBookno()); // 第二本书
		}
	
		// 返回二维码信息给前台
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.write(sb.toString());
		pw.flush();
		pw.close();
	}
	
	
	// 监听订单确认状态
	public void listenStatus() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String subscribenum = request.getParameter("num");
//		String openid = request.getParameter("openid");
		
		// 获取
		String status = SQL4PersonalInfo.judgeManagerConfirm(subscribenum);
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.write(status);
		pw.flush();
		pw.close();
		
//		ActionContext context = ActionContext.getContext();
//		context.put("openid", openid);
//		context.put("num", subscribenum);
		
//		return "ok";
	}
	
	
	// 进入支付
	@Override
	public String execute() throws Exception {
		System.out.println("执行Pay的execute方法");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String subscribenum = request.getParameter("num");
		
		
		
		ActionContext context = ActionContext.getContext();
		context.put("openid", weid);
		UserDetailInfo user = SQLUtil.querySingleUser(weid);
		context.put("user",user);
		context.put("num", subscribenum);
		SimpleDateFormat df = new SimpleDateFormat("yyyy年MM月dd日 hh:mm:ss");
		String date = df.format(new Date());
		context.put("date", date);
		
		
		// 测试数据
		BookInShoppingcart book1 = new BookInShoppingcart();
		book1.setBookno("1");
		book1.setBookname("微观历史");
		book1.setPrice("0.01");
		BookInShoppingcart book2 = new BookInShoppingcart();
		book2.setBookno("2");
		book2.setBookname("梦里花落知多少");
		book2.setPrice("0.02");
		ArrayList<BookInShoppingcart> list = new ArrayList<BookInShoppingcart>();
		list.add(book1);
		list.add(book2);
		context.put("booklist", list);
		
		
//		sb.append(weid + "||");
//		
//		BookWithouImg book1 = new BookWithouImg();
//		book1.setBookno(request.getParameter("bookno1"));
//		book1.setBookname(request.getParameter("bookname1"));
//		sb.append( book1.getBookno() + "||" );
//		
//		BookWithouImg book2 = null;
//		if(request.getParameter("bookno2") != null){
//			book2 = new BookWithouImg();
//			book2.setBookno(request.getParameter("bookno2"));
//			book2.setBookname(request.getParameter("bookname2"));
//			sb.append(book2.getBookno());
//		}
//		// 添加借阅
//		SQL4PersonalInfo.addToBorrow(weid, book1, book2);
		
		return SUCCESS;
	}
	
}
