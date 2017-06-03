package pay.action;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Date;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.jdom.JDOMException;

import net.sf.json.JSONObject;

import pay.util.AddressUtil;
import pay.util.CommonUtil;
import pay.util.ConfigUtil;
import pay.util.PayCommonUtil;
import pay.util.XMLUtil;

import com.opensymphony.xwork2.ActionSupport;

public class PayAction extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	public void PostParam() throws Exception, IOException{
		HttpServletRequest request = ServletActionContext.getRequest();
        request.setCharacterEncoding("UTF-8");
        
		SortedMap<Object,Object> parameters = new TreeMap<Object,Object>();
		parameters.put("appid", ConfigUtil.APPID);
		parameters.put("mch_id", ConfigUtil.MCH_ID);
		parameters.put("nonce_str", PayCommonUtil.CreateNoncestr());
		parameters.put("body", "LEO测试");
		parameters.put("out_trade_no", "201412051510");
		parameters.put("total_fee", "1");
		// 获取用户地址
		parameters.put("spbill_create_ip", AddressUtil.getIpByRequest(request));  
		parameters.put("notify_url", ConfigUtil.NOTIFY_URL);  // 改成自己的支付action
		parameters.put("trade_type", "JSAPI");
		parameters.put("openid", "o7W6yt9DUOBpjEYogs4by1hD_OQE");
		String sign = PayCommonUtil.createSign("UTF-8", parameters);
		parameters.put("sign", sign);
		// map转String
		String requestXML = PayCommonUtil.getRequestXml(parameters);  
		// 发送参数并获取结果
		String result =CommonUtil.httpsRequest(ConfigUtil.UNIFIED_ORDER_URL, "POST", requestXML);
		
		
		// 解析微信返回的信息
		Map<String, String> map = XMLUtil.doXMLParse(result);
		// 组装信息，填入新的map中
		SortedMap<Object,Object> params = new TreeMap<Object,Object>();
        params.put("appId", "wxde3504dfb219fc20");
        params.put("timeStamp", Long.toString(new Date().getTime()));
        params.put("nonceStr", PayCommonUtil.CreateNoncestr());
        params.put("package", "prepay_id="+map.get("prepay_id"));
        params.put("signType", ConfigUtil.SIGN_TYPE);
        String paySign =  PayCommonUtil.createSign("UTF-8", params);
        params.put("packageValue", "prepay_id="+map.get("prepay_id"));    //这里用packageValue是预防package是关键字在js获取值出错
        params.put("paySign", paySign);                             //paySign的生成规则和Sign的生成规则一致
        //付款成功后跳转的页面
        params.put("sendUrl", ConfigUtil.SUCCESS_URL);          

        String userAgent = request.getHeader("user-agent");
        char agent = userAgent.charAt(userAgent.indexOf("MicroMessenger")+15);
        params.put("agent", new String(new char[]{agent}));//微信版本号，用于前面提到的判断用户手机微信的版本是否是5.0以上版本。
        String json = JSONObject.fromObject(params).toString();
		
        // 输出给前端
        HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("UTF-8");
        PrintWriter pw = response.getWriter();
        pw.write(json);
        pw.flush();
        pw.close();
		
	}
	
	// 支付成功页面
	public void paySuccess() throws Exception{
        HttpServletRequest request = ServletActionContext.getRequest();
        HttpServletResponse response = ServletActionContext.getResponse();
        InputStream inStream = request.getInputStream();
        ByteArrayOutputStream outSteam = new ByteArrayOutputStream();
        byte[] buffer = new byte[1024];
        int len = 0;
        while ((len = inStream.read(buffer)) != -1) {
            outSteam.write(buffer, 0, len);
        }
        System.out.println("~~~~~~~~~~~~~~~~付款成功~~~~~~~~~");
        outSteam.close();
        inStream.close();
        String result  = new String(outSteam.toByteArray(),"utf-8");//获取微信调用我们notify_url的返回信息
        Map<Object, Object> map = XMLUtil.doXMLParse(result);
        for(Object keyValue : map.keySet()){
            System.out.println(keyValue+"="+map.get(keyValue));
        }
        if (map.get("result_code").toString().equalsIgnoreCase("SUCCESS")) {
            //TODO 对数据库的操作
            response.getWriter().write(PayCommonUtil.setXML("SUCCESS", ""));   //告诉微信服务器，我收到信息了，不要在调用回调action了
            System.out.println("-------------"+PayCommonUtil.setXML("SUCCESS", ""));
        }
        
    }
	
}
