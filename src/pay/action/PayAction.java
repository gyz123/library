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

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import pay.util.AddressUtil;
import pay.util.CommonUtil;
import pay.util.ConfigUtil;
import pay.util.PayCommonUtil;
import pay.util.XMLUtil;

import com.opensymphony.xwork2.ActionSupport;

public class PayAction extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	public void postParam() throws Exception, IOException{
		System.out.println("执行postParam方法");
		HttpServletRequest request = ServletActionContext.getRequest();
        request.setCharacterEncoding("UTF-8");
        
		SortedMap<String,String> parameters = new TreeMap<String,String>();
		parameters.put("appid", ConfigUtil.APPID);
		parameters.put("mch_id", ConfigUtil.MCH_ID);
		parameters.put("nonce_str", PayCommonUtil.CreateNoncestr());
		parameters.put("body", "test");
		String str = "" + (System.currentTimeMillis() + (int)(Math.random()*100) + 100);
		parameters.put("out_trade_no", str);
		parameters.put("total_fee", "1");
		// 获取用户地址
		parameters.put("spbill_create_ip", AddressUtil.getIpByRequest(request));  
		parameters.put("notify_url", ConfigUtil.NOTIFY_URL);  // 改成自己的支付action
		parameters.put("trade_type", "JSAPI");
		// 此处需要获取用户的openid *****************************************************************************************
		String openid = request.getParameter("openid");
		if(openid == null){
			openid = "otE_a1Ep3DV9r4kbFu7LDTTXhK6A";  // 耿元哲的id，用于测定时使用
		}
		parameters.put("openid", openid);
		// ***************************************************************************************************************
		String sign = PayCommonUtil.createSign("UTF-8", parameters);
		parameters.put("sign", sign);
		System.out.println("map " + parameters.toString());
		// map转String
		String requestXML = PayCommonUtil.getRequestXml(parameters);  
		System.out.println("requestXML: " + requestXML);

		// 发送参数并获取结果
		String result = CommonUtil.httpsRequest(ConfigUtil.UNIFIED_ORDER_URL, "POST", requestXML);
		System.out.println("result: " + result);
		
		// 解析微信返回的信息
		Map<String, String> map = XMLUtil.doXMLParse(result);
		// 组装信息，填入新的map中
		SortedMap<String,String> params = new TreeMap<String,String>();
        params.put("appId", ConfigUtil.APPID);
        params.put("timeStamp", "" + Long.toString(new Date().getTime()));
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
        System.out.println("json: " + json);
		
        // 输出给前端
        HttpServletResponse response = ServletActionContext.getResponse();
		response.setCharacterEncoding("UTF-8");
        PrintWriter pw = response.getWriter();
        pw.write(json);
        pw.flush();
        pw.close();
		
	}
	
	// 异步接收微信支付结果
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
        String result  = new String(outSteam.toByteArray(),"utf-8"); // 获取微信调用我们notify_url的返回信息
        Map<Object, Object> map = XMLUtil.doXMLParse(result);
        for(Object keyValue : map.keySet()){
            System.out.println(keyValue+"="+map.get(keyValue));
        }
        if (map.get("result_code").toString().equalsIgnoreCase("SUCCESS")) {
            //TODO 对数据库的操作
            response.getWriter().write(PayCommonUtil.setXML("SUCCESS", ""));   //告诉微信服务器，我收到信息了，不要在调用回调action了
            System.out.println("-------------"+PayCommonUtil.setXML("SUCCESS", ""));

            
            System.out.println("微信支付订单号:　" + map.get("transaction_id"));
            System.out.println("支付完成时间: " + map.get("time_end"));
        }
        
        
    }
	
}
