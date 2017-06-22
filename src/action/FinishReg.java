package action;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import po.UserDetailInfo;
import util.SQLUtil;
import util.VericodeUtil;

import com.opensymphony.xwork2.ActionSupport;
import com.taobao.api.DefaultTaobaoClient;
import com.taobao.api.TaobaoClient;
import com.taobao.api.request.AlibabaAliqinFcSmsNumSendRequest;
import com.taobao.api.response.AlibabaAliqinFcSmsNumSendResponse;

public class FinishReg extends ActionSupport {
	private static final long serialVersionUID = 1L;

	public String GetVeriCode() throws IOException {
		System.out.println("执行getvericode方法");
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=utf-8");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		String weID = request.getParameter("weID");
		String tel = request.getParameter("tel");

		String str = "前台传来了参数：weID=" + weID + "，tel=" + tel;

		System.out.println(str);
		
		String vericode = VericodeUtil.sendSMS(tel);
		
		pw.write(vericode);
		System.out.println(vericode);
		pw.flush();
		pw.close();
		return SUCCESS;
	}

	public String CompleteReg() throws IOException {
		// System.out.println("执行completereg方法");
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=utf-8");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");

		// 获取用户身份信息
		String weID = request.getParameter("weID"); // 微信ID
		String name = request.getParameter("name");
		String IDNumber = request.getParameter("IDNumber");
		String tel = request.getParameter("tel");
		String veriCode = request.getParameter("veriCode");
		// 添加用户的身份信息到数据库
		SQLUtil.addUserRealInfo("library", name, IDNumber, tel, weID);

		// String str = "前台传来了参数：weID=" + weID + "，name=" + name + "，IDNumber="
		// + IDNumber + "，tel=" + tel + "，veriCode=" + veriCode;
		// PrintWriter pw = response.getWriter();
		// pw.print(str);
		// System.out.println(str);
		// pw.flush();
		// pw.close();
		return SUCCESS; // 注册成功界面（由于是异步处理，所以此处的跳转无效）
	}

	public String RegSuccess() {
		return SUCCESS;
	}

	public String RegFailure() {
		return SUCCESS;
	}

	@Override
	public String execute() throws Exception {
		return SUCCESS;
	}

}
