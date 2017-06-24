package remind;

import java.util.ArrayList;
import java.util.TimerTask;

import po.AccessToken;
import po.ReturnRemindMes;
import util.MessageUtil;
import util.WeixinUtil;
import action.sidemenu.Borrow;

public class MyTask extends TimerTask{
	
	public void run(){
		System.out.println("定时触发了");
		ArrayList<ReturnRemindMes> needRemind =  Borrow.needRemind();
		AccessToken access_token = WeixinUtil.getAccessToken();
		for (ReturnRemindMes returnRemindMes : needRemind) {
			String weid = returnRemindMes.getWeid();
			String message = returnRemindMes.getMessage();
			//String messageXML =  MessageUtil.initText(weid, "", message);
			String JSONMessage = MessageUtil.generateServiceMsg("otE_a1OD_NOC7jvIz_vIe5heSIAA", "text", message);
			int errcode = WeixinUtil.Cus_Service(access_token.getToken(), JSONMessage);
			System.out.println("用户weid：" + returnRemindMes.getWeid());
			System.out.println(errcode);
		}
	}
}
