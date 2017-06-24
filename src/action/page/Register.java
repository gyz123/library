package action.page;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import po.user.UserDetailInfo;
import util.sql.SQLUtil;
import util.weixin.WeixinUtil;

import com.opensymphony.xwork2.ActionSupport;

public class Register extends ActionSupport{
	private static final long serialVersionUID=1L;
	private static final String GetWeixinInfo = "https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID&lang=zh_CN";
	private static final String GetCode = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code";
	
	@Override
	public String execute() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        
        //用户授权后获取code
        String code = request.getParameter("code");	        
        
        // 通过code获取基本信息
		String userID = "";
		String access_token = "";
		String refresh_token = "";
		String url = GetCode.replace("APPID", WeixinUtil.APPID).replace("SECRET", WeixinUtil.APPSECRET).replace("CODE", code);
		JSONObject jsonObject = WeixinUtil.doGetStr(url);
		if(jsonObject != null){
			userID = jsonObject.getString("openid");
			access_token = jsonObject.getString("access_token");
			refresh_token = jsonObject.getString("refresh_token");
		}
		
		// 获取用户基本信息
		String url2 = GetWeixinInfo.replace("ACCESS_TOKEN", access_token).replace("OPENID", userID);
		JSONObject jsonObject2 = WeixinUtil.doGetStr(url2);
		UserDetailInfo user = new UserDetailInfo();
		String openID = "";
		String nickname = "";
		String headimgurl = "";
		if(jsonObject2 != null){
			openID = jsonObject2.getString("openid");
			nickname = jsonObject2.getString("nickname");
			headimgurl = jsonObject2.getString("headimgurl");
			// 获取用户微信账户
			user.setOpenid(openID);
			user.setNickname(nickname);
			user.setHeadimgurl(headimgurl);
		}
		
		// 添加用户的微信账户信息到数据库
		if(!SQLUtil.judgeReg("library",openID)){
			// 用户未注册
			SQLUtil.addUserWXInfo("library",openID,nickname,headimgurl);
		}else{
			// 用户已注册
			return "haveReg"; // 返回失败页面
		}
		
		request.setAttribute("user", user);
			
//        UserDetailInfo user = new UserDetailInfo();
//        user.setOpenid("gyz123");
//        user.setNickname("耿元哲");
//        request.setAttribute("user", user);
        
		return SUCCESS;
	}
}
