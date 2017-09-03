package action.page;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import po.Announcement;
import po.AnnouncementInList;
import po.book.Book;
import po.book.BookDetailInfo;
import po.book.BookInCategory;
import po.user.UserDetailInfo;

import util.sql.SQL4PersonalInfo;
import util.sql.SQLUtil;
import util.weixin.CheckUtil;
import util.weixin.PastUtil;
import util.weixin.WeixinUtil;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class Library_main extends ActionSupport{
	private static final long serialVersionUID=1L;
	private static final String GetCode = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code";
	
	// ���뵥���鼮ҳ��
	public String enterWenxue() throws UnsupportedEncodingException{
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
		
        // ��ȡ��������
        String weid = request.getParameter("weid");
        String catName = request.getParameter("id");
        String pageNum = request.getParameter("pagenum");
        String target = request.getParameter("target");	// ����������Ĭ�ϰ��������
        
        HttpSession session = request.getSession();
		session.setAttribute("weid", weid);
        session.setAttribute("cat", catName);
		
        if(pageNum == null || pageNum.equals("0")){
        	pageNum = "1";
        }
        if(target == null){
        	target = "bookno";
        }
        
        ActionContext context = ActionContext.getContext();
        context.put("weid", weid);
        context.put("pagenum", pageNum);
        ArrayList<BookInCategory> bookList = new ArrayList<BookInCategory>();
		// ��ѧ���й���ѧ�������ѧ
       	if(catName.equals("wenxue")){
       		bookList = SQLUtil.querySingleCat("('�й���ѧ','�����ѧ')", pageNum, target);
       		context.put("catid","wenxue");
       		context.put("cat", "��ѧ");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("��ѧ");
       	}
       	// ����
       	else if(catName.equals("zhuanji")){
       		bookList = SQLUtil.querySingleCat("('���ﴫ��')", pageNum, target);
       		if (bookList.size() > 0) {
				context.put("booklist", bookList);
			}
       		context.put("catid","zhuanji");
       		context.put("cat", "����");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("����");
       	}
       	// ��ʷ
       	else if(catName.equals("lishi")){
       		bookList = SQLUtil.querySingleCat("('��ʷ')", pageNum, target);
       		context.put("catid","lishi");
       		context.put("cat", "��ʷ");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("��ʷ");
       	}
       	// ��ѧ
       	else if(catName.equals("zhexue")){
       		bookList = SQLUtil.querySingleCat("('��ѧ')", pageNum, target);
       		context.put("catid","zhexue");
       		context.put("cat", "��ѧ");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("��ѧ");
       	}
       	// ��ͯ
       	else if(catName.equals("ertong")){
       		bookList = SQLUtil.querySingleCat("('��ͯ��ѧ')", pageNum, target);
       		context.put("catid","ertong");
       		context.put("cat", "�ٶ�");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("��ͯ");
       	}
       	// С˵
       	else if(catName.equals("xiaoshuo")){
       		bookList = SQLUtil.querySingleCat("('С˵')", pageNum, target);
       		context.put("catid","xiaoshuo");
       		context.put("cat", "С˵");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("С˵");
       	}
       	// ��������������
       	else if(catName.equals("xinli")){
       		bookList = SQLUtil.querySingleCat("('���鼦��','����ѧ')", pageNum, target);
       		context.put("catid","xinli");
       		context.put("cat", "����");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("����");
       	}
       	// ��᣺�ɹ���־������������
       	else if(catName.equals("shehui")){
       		bookList = SQLUtil.querySingleCat("('�ɹ���־','����','����')", pageNum, target);
       		context.put("catid","shehui");
       		context.put("cat", "���");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("���");
       	}
       	// �Ƽ�
       	else if(catName.equals("keji")){
       		bookList = SQLUtil.querySingleCat("('�����','�Ƽ�','������')", pageNum, target);
       		context.put("catid","keji");
       		context.put("cat", "�Ƽ�");
       		context.put("booklist", bookList);
       		SQLUtil.updateCatPoint("�Ƽ�");
       	}
		return "ok";
	}
	
	// ������ҳ
	public String backToMain() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
		String weid = request.getParameter("weid");
		if(weid == null || weid.isEmpty() || weid.equals("null")){
			weid = request.getSession(false).getAttribute("weid").toString();
		}
		ActionContext context = ActionContext.getContext();
		context.put("weid", weid);
		
		UserDetailInfo user = SQL4PersonalInfo.queryUser(weid);
		if(user != null){
			context.put("flag", true);
			context.put("user",user);
			System.out.println("��ע��:" + user.getRealName() + " " + user.getOpenid());
		}
		else{
			context.put("flag", false);	// ˵���û���û��ע��
			System.out.println("δע��:"  + " " + weid);
		}
		
//		// ************************
//		Map<String,String> map = PastUtil.getParam(WeixinUtil.APPID, WeixinUtil.APPSECRET, request, url);		
//		String noncestr = map.get("nonceStr");
//		String jsapi_ticket = map.get("jsapi_ticket");
//		String timestamp = map.get("timestamp");
//		String url = map.get("url");
//		System.out.println(map.toString());
//		// ����ǩ��
//		String signature = CheckUtil.generateSignature(noncestr, jsapi_ticket, timestamp, url);
//		
//		// ���ò���
//		request.setAttribute("appId", WeixinUtil.APPID);
//		request.setAttribute("timeStamp", timestamp);
//		request.setAttribute("nonceStr", noncestr);
//		request.setAttribute("signature", signature);
//		request.setAttribute("url", url);
		
		// �����б�
		ArrayList<AnnouncementInList> annolist = SQLUtil.queryAllAnno();
		context.put("annolist", annolist);
		
		return "ok";
	}
	
	
	@Override // �ɹ��ںŽ�����ҳ
	public String execute() throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        
        String weid = "";
        // ��ȡ�û�΢��id
        String code = request.getParameter("code");	 
        if(code != null){
        	String url = GetCode.replace("APPID", WeixinUtil.APPID).replace("SECRET", WeixinUtil.APPSECRET).replace("CODE", code);
        	JSONObject jsonObject = WeixinUtil.doGetStr(url);
        	if(jsonObject != null){
        		weid = jsonObject.getString("openid");
        	}
        }
		
		ActionContext context = ActionContext.getContext();
		if(weid.isEmpty()){
			weid = "oDRhGwscPxkgWHa0pzSVcRxveNSw";  // ��������
//			weid = "guest";  // δע�������ͳһ����̶����ο��˺�
		}
		context.put("weid", weid);
		
		HttpSession session = request.getSession();
		session.setAttribute("weid", weid);
		
		UserDetailInfo user = SQL4PersonalInfo.queryUser(weid);
		if(user != null){
			context.put("flag", true);
			context.put("user",user);
			System.out.println("��ע��:" + user.getRealName() + " " + user.getOpenid());
		}
		else{
			context.put("flag", false);	// ˵���û���û��ע��
			System.out.println("δע��:"  + " " + weid);
		}
		
		// ************************
//		Map<String,String> map = PastUtil.getParam(WeixinUtil.APPID, WeixinUtil.APPSECRET, request);		
//		String noncestr = map.get("nonceStr");
//		String jsapi_ticket = map.get("jsapi_ticket");
//		String timestamp = map.get("timestamp");
//		String url = map.get("url");
//		System.out.println(map.toString());
//		// ����ǩ��
//		String signature = CheckUtil.generateSignature(noncestr, jsapi_ticket, timestamp, url);
//		
//		// ���ò���
//		request.setAttribute("appId", WeixinUtil.APPID);
//		request.setAttribute("timeStamp", timestamp);
//		request.setAttribute("nonceStr", noncestr);
//		request.setAttribute("signature", signature);
//		request.setAttribute("url", url);
//		
		
		// �����б�
		ArrayList<AnnouncementInList> annolist = SQLUtil.queryAllAnno();
	    context.put("annolist", annolist);
		
		return SUCCESS;
	}
	
	// ��������
	public String enterAnno() throws Exception{
		HttpServletRequest request = ServletActionContext.getRequest();
		request.setCharacterEncoding("utf-8");
//        HttpSession session = request.getSession(false);
//		String weid = (String)session.getAttribute("weid");
//        System.out.println("��session��õ�weid:" + weid);
        
        String weid = request.getParameter("weid");
        ActionContext context = ActionContext.getContext();
        context.put("weid", weid);
        
        String anno_id = request.getParameter("anno_id");
        Announcement anno = SQLUtil.queryAnno(anno_id);
        context.put("anno", anno);
        
        // ����������ʾ
        String annoContent = anno.getContent();
        String[] strs = annoContent.split("\n");
        ArrayList<String> contentlist = new ArrayList<String>();
        for(int i=0; i<strs.length; i++){
        	contentlist.add(strs[i].trim());
        }
	    context.put("contentlist", contentlist);
        
		return "ok";
	}
	
	
	/**
	 * ��ҳajax��̬����jssdk
	 * @throws IOException 
	 */
	public void jssdkConfig() throws IOException{
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		
		//String url = map.get("url");
		String url = request.getParameter("url");//��ǰ̨����
		
		// ************************
		Map<String,String> map = PastUtil.getParam(WeixinUtil.APPID, WeixinUtil.APPSECRET, request, url);		
		String noncestr = map.get("nonceStr");
		String jsapi_ticket = map.get("jsapi_ticket");
		String timestamp = map.get("timestamp");
		
		System.out.println(url);
		System.out.println(map.toString());
		
		map.remove("url");
		map.put("url", url);
		// ����ǩ��
		String signature = CheckUtil.generateSignature(noncestr, jsapi_ticket, timestamp, url);
				
		// ���ò���
//		request.setAttribute("appId", WeixinUtil.APPID);
//		request.setAttribute("timeStamp", timestamp);
//		request.setAttribute("nonceStr", noncestr);
//		request.setAttribute("signature", signature);
//		request.setAttribute("url", url);
		
		out.write(JSONArray.fromObject(map).toString());
		out.flush();
		out.close();
	}
}
