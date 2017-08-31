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

	// 设置订单信息
	public void success() throws Exception{
		System.out.println("执行HandleOrder的success方法");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		
		HttpSession session = request.getSession(false);
		String subscribenum = (String)session.getAttribute("subscribenum");
		String weid = (String)session.getAttribute("weid");
		
		// 支付成功后续操作
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
		// 删除清单中对应的书
		ArrayList<BookInShoppingcart> list = SQL4PersonalInfo.confirmOrder(subscribenum);
		Iterator<BookInShoppingcart> i = list.iterator();
		while(i.hasNext()){
			BookInShoppingcart book = (BookInShoppingcart)i.next();
			SQL4PersonalInfo.deleteBookFromCart(weid,book.getBookno());
		}
		// 添加到已借阅
		SQL4PersonalInfo.addToBorrow(weid, subscribenum);
		// 设置用户支付状态为true
		SQL4PersonalInfo.setWhetherPay(subscribenum);	
	}
	
}
