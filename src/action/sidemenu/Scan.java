package action.sidemenu;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import util.weixin.CheckUtil;
import util.weixin.PastUtil;
import util.weixin.WeixinUtil;

import com.opensymphony.xwork2.ActionSupport;

public class Scan extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	// 识别二维码
	public void handleCodeScan() throws Exception{
		System.out.println("执行了Scan的handleCodeScan方法");
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String bookno = decodeString(request.getParameter("QRCodetxt"));
		String weid = request.getSession(false).getAttribute("weid").toString();
		HttpServletResponse response = ServletActionContext.getResponse();
        response.setCharacterEncoding("utf-8");
		String url = response.encodeURL("/library/add_to_shoppingcart.action?weid=" + weid + "&bookno=" + bookno);  
		response.sendRedirect(url);
		return ;
	}
	
	
	// 显示扫一扫
	@Override
	public String execute() throws Exception {
		HttpServletRequest req = ServletActionContext.getRequest();
		req.setCharacterEncoding("utf-8");
		HttpServletResponse resp = ServletActionContext.getResponse();
		resp.setCharacterEncoding("utf-8");
		
		Map<String,String> map = PastUtil.getParam(WeixinUtil.APPID, WeixinUtil.APPSECRET, req);		
		String noncestr = map.get("nonceStr");
		String jsapi_ticket = map.get("jsapi_ticket");
		String timestamp = map.get("timestamp");
		String url = map.get("url");
		System.out.println(map.toString());
		// 生成签名
		String signature = CheckUtil.generateSignature(noncestr, jsapi_ticket, timestamp, url);
		
		// 设置参数
		req.setAttribute("appId", WeixinUtil.APPID);
		req.setAttribute("timeStamp", timestamp);
		req.setAttribute("nonceStr", noncestr);
		req.setAttribute("signature", signature);
		req.setAttribute("url", url);
		
		return SUCCESS;
	}

	//{"resultStr":"http://qm.qq.com/cgi-bin/qm/qr?k=9GIwDKDm9sMEf_dNiQokQKdhP5fSYY6s",
	//"errMsg":"scanQRCode:ok"}
	private String decodeString(String message){
		String[] datas = message.split(",");
		String[] temp = datas[0].split("\":\"");
		StringBuffer sb = new StringBuffer(temp[1]);
		sb.deleteCharAt(sb.length()-1);
		System.out.println(sb.toString());
		return sb.toString();
	}
	
}
