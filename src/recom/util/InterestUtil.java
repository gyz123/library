package recom.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

import util.SQLUtil;
import util.WeixinUtil;

/**
 * 基于用户各种行为的分析
 * @author mzy
 *
 */
public class InterestUtil {
	
	/**
	 * 用户点击喜欢之后，对这本书的用户喜爱度+3
	 * @param weid 传入的weid为字符串
	 * @param book_id 传入的图书id
	 * @param like 标志是添加喜欢，还是取消喜欢
	 */
	public static void clickLike(String weid, String book_id, boolean like){
		String user_id = SQLUtil.getUserId(weid);//从weid获取user_id
		float preference = 0;
		if(like){
			preference = 3;
		}else{
			preference = -3;
		}
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			//数据库中为int所以不需要单引号
			String query = "update taste_interest set preference = (preference+" + preference +") " +
					"where user_id= " + user_id + 
					" and book_id= " + book_id;
			System.out.println(query);
			s.executeUpdate(query);
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	/**
	 * 点击单本图书时，对该图书的喜爱度+0.5
	 * @param weid 传入用户的weid
	 * @param book_id 传入图书id
	 */
	public static void clickBook(String weid, String book_id){
		String user_id = SQLUtil.getUserId(weid);//从weid获取user_id
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			//数据库中为int所以不需要单引号,不存在则创建存在则新增
			String query1 = "insert ignore into taste_interest (user_id, book_id, preference) values (" + 
			user_id +"," + book_id + ", 0 )";
			
			
			String query2 = "update taste_interest set preference = (preference+0.5) " +
					"where user_id= " + user_id + 
					" and book_id= " + book_id;
			System.out.println("query1:" + query1);
			System.out.println("query2:" + query2);
			s.executeUpdate(query1);
			s.executeUpdate(query2);
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		InterestUtil.clickLike("oDRhGwipEfLgIMjPB-ZywcisFVxk", "31", false);
		
		//InterestUtil.clickBook("oDRhGwipEfLgIMjPB-ZywcisFVxk", "60");
	}
}
