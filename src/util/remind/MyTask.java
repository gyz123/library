package util.remind;

import java.util.ArrayList;
import java.util.TimerTask;

import po.book.BookDetailInfo;
import po.message.News;
import po.message.ReturnRemindMes;
import po.user.AccessToken;
import util.recommend.DailyPush;
import util.sql.SQLUtil;
import util.weixin.MessageUtil;
import util.weixin.WeixinUtil;
import action.sidemenu.Borrow;

public class MyTask extends TimerTask{
	
	public void run(){
		System.out.println("定时触发了");
		DailyRemind();
		try {
			Thread.sleep(100000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		int bookno = (int)(Math.random()*600);
		System.out.println(bookno);
		DailyPush.recomBookDaily(bookno,"otE_a1OD_NOC7jvIz_vIe5heSIAA");
	}
	
	/**
	 * 每日提醒
	 */
	public void DailyRemind(){
		ArrayList<ReturnRemindMes> needRemind =  Borrow.needRemind();
		AccessToken access_token = WeixinUtil.getAccessToken();
		for (ReturnRemindMes returnRemindMes : needRemind) {
			String weid = returnRemindMes.getWeid();
			String message = returnRemindMes.getMessage();
			//String messageXML =  MessageUtil.initText(weid, "", message);
			String JSONMessage = MessageUtil.generateServiceMsg("otE_a1OD_NOC7jvIz_vIe5heSIAA", "text", message);
			int errcode = WeixinUtil.Cus_Service(access_token.getToken(), JSONMessage);
			System.out.println("用户weid：" + returnRemindMes.getWeid());
			System.out.println("remind_errcode:" + errcode);
		}
	}
}
