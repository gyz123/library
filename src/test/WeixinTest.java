package test;

import net.sf.json.JSONObject;
import po.AccessToken;
import util.WeixinUtil;

public class WeixinTest {
	//测试类
	public static void main(String[] args) {
		try{
				AccessToken token = WeixinUtil.getAccessToken();  //获取access_token
				System.out.println("票据  " + token.getToken());
				System.out.println("有效时间  " + token.getExpiresIn());
		
				
//				String path = "E:/JAVA测试用/3A.jpg";
//				String mediaId = WeixinUtil.upLoad(path, token.getToken(), "image");
//				System.out.println(mediaId);
				
				
				String menu = JSONObject.fromObject(WeixinUtil.initMenu()).toString();
				int result = WeixinUtil.createMenu(token.getToken(), menu);
				if(result == 0){
					System.out.println("创建菜单成功");
				}else{
					System.out.println("错误码: " + result);
				}
				
				
		}catch(Exception e){
			e.printStackTrace();
		}

	}
}
