package util.test;

import util.weixin.WeixinUtil;

public class RegTest {
	private static final String SCOPE = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=APPID&redirect_uri=REDIRECT_URI&response_type=code&scope=SCOPE&state=STATE#wechat_redirect";
	public static final String DN = "http://www.iotesta.cn";
	private static final String registerAction = DN + "/library/show_register.action";

	public static void main(String[] args) {
		String url23 = SCOPE.replace("APPID", WeixinUtil.APPID).replace("REDIRECT_URI", registerAction)
				.replace("SCOPE", "snsapi_userinfo").replace("STATE", "123");
		System.out.println(url23);
	}
	
	//https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx6b71cb3f69dd9a86&redirect_uri=http://www.iotesta.cn/library/show_register.action&response_type=code&scope=snsapi_userinfo&state=123#wechat_redirect

}
