package util;

import com.taobao.api.DefaultTaobaoClient;
import com.taobao.api.TaobaoClient;
import com.taobao.api.request.AlibabaAliqinFcSmsNumSendRequest;
import com.taobao.api.response.AlibabaAliqinFcSmsNumSendResponse;

public class VericodeUtil {

	/**
	 * 短信验证码
	 * @param tel 传入用户手机号
	 * @return 生成的六位随机数（String）
	 */
	public static String sendSMS(String tel) {
		// 短信模块
		String url = "http://gw.api.taobao.com/router/rest";
		String appkey = "24487251";
		String secret = "7b411904fa227f20bf5243e255205599";
		String vericode = String.valueOf(generateRandomArray(6));//生成验证码
		TaobaoClient client = new DefaultTaobaoClient(url, appkey, secret);
		AlibabaAliqinFcSmsNumSendRequest req = new AlibabaAliqinFcSmsNumSendRequest();
		req.setExtend("");
		req.setSmsType("normal");
		req.setSmsFreeSignName("超新星智能图书馆");
		req.setSmsParamString("{'number':'" + vericode + "'}");
		req.setRecNum(tel);
		req.setSmsTemplateCode("SMS_71805105");
		AlibabaAliqinFcSmsNumSendResponse rsp = null;
		try {
			rsp = client.execute(req);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(rsp.getBody());
		System.out.println(vericode);
		return vericode;
	}
	
	/** 
     * 随机生成 num位数字字符数组 
     * @param num 
     * @return 
     */  
    public static char[] generateRandomArray(int num) {  
        String chars = "0123456789";  
        char[] rands = new char[num];  
        for (int i = 0; i < num; i++) {  
            int rand = (int) (Math.random() * 10);  
            rands[i] = chars.charAt(rand);  
        }  
        return rands;  
    }  
  
    public static void main(String[] args) {  
  
        // 随机生成6位数字  
       // System.out.println(String.valueOf(generateRandomArray(6)));  
        sendSMS("15995085680");
    }  
	
}
