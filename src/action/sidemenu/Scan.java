package action.sidemenu;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import util.CheckUtil;
import util.PastUtil;
import util.WeixinUtil;

import com.opensymphony.xwork2.ActionSupport;

public class Scan extends ActionSupport{
	private static final long serialVersionUID=1L;
	
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

}
