package action.pay;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

import po.PayList;
import po.book.BookInShoppingcart;
import po.user.UserDetailInfo;
import util.EncryptUtil;
import util.sql.SQL4PersonalInfo;
import util.sql.SQLUtil;

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
		System.out.println("生成的订单号：" + subscribenum);
		String bookno1 = request.getParameter("bookno1");
		String bookno2 = request.getParameter("bookno2");
		if (bookno1.isEmpty()) {
			bookno1 = "1"; // 测试数据
		}
		StringBuffer sb = new StringBuffer();
		sb.append("borrow,");	// 二维码类型：借阅
		PayList list1 = SQL4PersonalInfo.setPayList(weid, bookno1, subscribenum);
		sb.append(list1.getSubsribenum() + ",");	// 订单号
		SQL4PersonalInfo.saveOrder(weid, list1);
		sb.append(list1.getBookno() + ","); 	// 第一本书
		
		if (!( bookno2.isEmpty() || bookno2.equals("undefined") )) {
			PayList list2 = SQL4PersonalInfo.setPayList(weid, bookno2, subscribenum);
			SQL4PersonalInfo.saveOrder(weid, list2);
			sb.append(list2.getBookno());	 // 第二本书
		}
	
		// 保存session
		HttpSession session = request.getSession(false);
		session.setMaxInactiveInterval(60);
		session.setAttribute("subscribenum", subscribenum);
		session.setAttribute("weid", weid);
		session.setAttribute("ebookno", "");
		
		// 返回二维码信息给前台
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		//进行AES加密
//		String encryptResult = EncryptUtil.parseByte2HexStr(EncryptUtil.encrypt(sb.toString()));
//		pw.write(encryptResult);
		pw.write(sb.toString());
		pw.flush();
		pw.close();
	}
	
	
	// 监听订单确认状态
	public void listenStatus() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		
		// 获取用户最新的订单
		String status = SQL4PersonalInfo.judgeManagerConfirm(weid);
		System.out.println("管理员确认状态:" + status);
		
		// 返回状态给前台
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.write(status);
		pw.flush();
		pw.close();
	}
	
	
	// 进入支付
	@Override
	public String execute() throws Exception {
		System.out.println("执行Pay的execute方法");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getSession().getAttribute("weid").toString();
		String subscribenum = SQL4PersonalInfo.getSubscribeNum(weid);
		
		ActionContext context = ActionContext.getContext();
		context.put("openid", weid);
		UserDetailInfo user = SQLUtil.querySingleUser("weid",weid);
		context.put("user",user);
		context.put("num", subscribenum);
		SimpleDateFormat df = new SimpleDateFormat("yyyy年MM月dd日 hh:mm:ss");
		String date = df.format(new Date());
		context.put("date", date);
		ArrayList<BookInShoppingcart> booklist = SQL4PersonalInfo.confirmOrder(subscribenum);
		context.put("booklist", booklist);

		return SUCCESS;
	}
	

	// 电子书支付
	public String payEbook() throws Exception {
		System.out.println("执行Pay的payEbook方法");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		
		ActionContext context = ActionContext.getContext();
		context.put("openid", weid);
		UserDetailInfo user = SQLUtil.querySingleUser("weid", weid);
		context.put("user",user);
		SimpleDateFormat df = new SimpleDateFormat("yyyy年MM月dd日 hh:mm:ss");
		String date = df.format(new Date());
		context.put("date", date);
		ArrayList<BookInShoppingcart> booklist = SQL4PersonalInfo.getEBookInfo(bookno);
		context.put("booklist", booklist);
		
		// 设置session
		HttpSession session = request.getSession(false);
		session.setAttribute("subscribenum", "");
		session.setAttribute("weid", weid);
		session.setAttribute("ebookno", bookno);
		
		return "ok";
	}
	
}
