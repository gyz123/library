package action.pay;

import java.util.ArrayList;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

import po.book.BookInShoppingcart;

import util.sql.SQL4PersonalInfo;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class HandleOrder extends ActionSupport{
	private static final long serialVersionUID=1L;

	// ���ö�����Ϣ
	public void success() throws Exception{
		System.out.println("ִ��HandleOrder��success����");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		
		HttpSession session = request.getSession(false);
		String subscribenum = (String)session.getAttribute("subscribenum");
		String weid = (String)session.getAttribute("weid");
		
		// ֧���ɹ���������
		successOperation(subscribenum,weid);
		
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		
		HttpServletResponse response = ServletActionContext.getResponse();
        response.setCharacterEncoding("utf-8");
		String url = response.encodeURL("/library/back_to_main.action?weid=" + weid);  
		response.sendRedirect(url);
		
		return ;
	}
	
	
	private void successOperation(String subscribenum,String weid){
		// ɾ���嵥�ж�Ӧ����
		ArrayList<BookInShoppingcart> list = SQL4PersonalInfo.confirmOrder(subscribenum);
		Iterator<BookInShoppingcart> i = list.iterator();
		while(i.hasNext()){
			BookInShoppingcart book = (BookInShoppingcart)i.next();
			SQL4PersonalInfo.deleteBookFromCart(weid,book.getBookno());
		}
		// ��ӵ��ѽ���
		SQL4PersonalInfo.addToBorrow(weid, subscribenum);
		// �����û�֧��״̬Ϊtrue
		SQL4PersonalInfo.setWhetherPay(subscribenum);	
	}
	
}
