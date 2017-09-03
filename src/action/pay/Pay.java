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
	
	// ���ɶ�ά��
	public void generateCode() throws Exception{
		System.out.println("ִ��Pay��generateCode����");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		request.setAttribute("openid", weid);
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);

		// ���涩��
		String subscribenum = weid + System.currentTimeMillis();	// ���ɶ�����
		System.out.println("���ɵĶ����ţ�" + subscribenum);
		String bookno1 = request.getParameter("bookno1");
		String bookno2 = request.getParameter("bookno2");
		if (bookno1.isEmpty()) {
			bookno1 = "1"; // ��������
		}
		StringBuffer sb = new StringBuffer();
		sb.append("borrow,");	// ��ά�����ͣ�����
		PayList list1 = SQL4PersonalInfo.setPayList(weid, bookno1, subscribenum);
		sb.append(list1.getSubsribenum() + ",");	// ������
		SQL4PersonalInfo.saveOrder(weid, list1);
		sb.append(list1.getBookno() + ","); 	// ��һ����
		
		if (!( bookno2.isEmpty() || bookno2.equals("undefined") )) {
			PayList list2 = SQL4PersonalInfo.setPayList(weid, bookno2, subscribenum);
			SQL4PersonalInfo.saveOrder(weid, list2);
			sb.append(list2.getBookno());	 // �ڶ�����
		}
	
		// ����session
		HttpSession session = request.getSession(false);
		session.setMaxInactiveInterval(60);
		session.setAttribute("subscribenum", subscribenum);
		session.setAttribute("weid", weid);
		session.setAttribute("ebookno", "");
		
		// ���ض�ά����Ϣ��ǰ̨
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		//����AES����
//		String encryptResult = EncryptUtil.parseByte2HexStr(EncryptUtil.encrypt(sb.toString()));
//		pw.write(encryptResult);
		pw.write(sb.toString());
		pw.flush();
		pw.close();
	}
	
	
	// ��������ȷ��״̬
	public void listenStatus() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		
		// ��ȡ�û����µĶ���
		String status = SQL4PersonalInfo.judgeManagerConfirm(weid);
		System.out.println("����Աȷ��״̬:" + status);
		
		// ����״̬��ǰ̨
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.write(status);
		pw.flush();
		pw.close();
	}
	
	
	// ����֧��
	@Override
	public String execute() throws Exception {
		System.out.println("ִ��Pay��execute����");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getSession().getAttribute("weid").toString();
		String subscribenum = SQL4PersonalInfo.getSubscribeNum(weid);
		
		ActionContext context = ActionContext.getContext();
		context.put("openid", weid);
		UserDetailInfo user = SQLUtil.querySingleUser("weid",weid);
		context.put("user",user);
		context.put("num", subscribenum);
		SimpleDateFormat df = new SimpleDateFormat("yyyy��MM��dd�� hh:mm:ss");
		String date = df.format(new Date());
		context.put("date", date);
		ArrayList<BookInShoppingcart> booklist = SQL4PersonalInfo.confirmOrder(subscribenum);
		context.put("booklist", booklist);

		return SUCCESS;
	}
	

	// ������֧��
	public String payEbook() throws Exception {
		System.out.println("ִ��Pay��payEbook����");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		String bookno = request.getParameter("bookno");
		
		ActionContext context = ActionContext.getContext();
		context.put("openid", weid);
		UserDetailInfo user = SQLUtil.querySingleUser("weid", weid);
		context.put("user",user);
		SimpleDateFormat df = new SimpleDateFormat("yyyy��MM��dd�� hh:mm:ss");
		String date = df.format(new Date());
		context.put("date", date);
		ArrayList<BookInShoppingcart> booklist = SQL4PersonalInfo.getEBookInfo(bookno);
		context.put("booklist", booklist);
		
		// ����session
		HttpSession session = request.getSession(false);
		session.setAttribute("subscribenum", "");
		session.setAttribute("weid", weid);
		session.setAttribute("ebookno", bookno);
		
		return "ok";
	}
	
}
