package action.sidemenu;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import po.BookWithouImg;
import util.SQL4PersonalInfo;
import util.WeixinUtil;

import com.opensymphony.xwork2.ActionSupport;

public class Pay extends ActionSupport{
	private static final long serialVersionUID=1L;
	private static final String GetCode = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code";
	
	@Override
	public String execute() throws Exception {
		System.out.println("执行Pay的execute方法");
//		HttpServletRequest request = ServletActionContext.getRequest();
//		String weid = request.getParameter("weid");
//		StringBuffer sb = new StringBuffer(); // 二维码的内容
//		
//		BookWithouImg book1 = new BookWithouImg();
//		book1.setBookno(request.getParameter("bookno1"));
//		book1.setBookname(request.getParameter("bookname1"));
//		sb.append( book1.getBookno() + "||" );
//		
//		BookWithouImg book2 = new BookWithouImg();
//		if(request.getParameter("bookno2") != null){
//			book2.setBookno(request.getParameter("bookno2"));
//			book2.setBookname(request.getParameter("bookname2"));
//			sb.append(book2.getBookno());
//		}
//		// 添加借阅
//		SQL4PersonalInfo.addToBorrow(weid, book1, book2);
		
		// 获取用户OPENID
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
        //用户授权后获取code
//        String code = request.getParameter("code");
//        System.out.println("code: " + code);
//        String openid = "";
//        String url = GetCode.replace("APPID", WeixinUtil.APPID).replace("SECRET", WeixinUtil.APPSECRET).replace("CODE", code);
//		JSONObject jsonObject = WeixinUtil.doGetStr(url);
//		if(jsonObject != null){
//			openid = jsonObject.getString("openid");
//			System.out.println("openid: " + openid);
//		}
		String openid = "otE_a1Ep3DV9r4kbFu7LDTTXhK6A";
		request.setAttribute("openid", openid);
		
		return SUCCESS;
	}
}
