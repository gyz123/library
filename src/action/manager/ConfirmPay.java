package action.manager;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;

import util.SQL4PersonalInfo;

import com.opensymphony.xwork2.ActionSupport;

public class ConfirmPay extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	public void setStatus() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String subscribenum = request.getParameter("num");
		SQL4PersonalInfo.setManagerConfirm(subscribenum);
	}
	
}
