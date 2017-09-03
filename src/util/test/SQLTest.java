package util.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

import util.weixin.WeixinUtil;

public class SQLTest {
	public static void main(String[] args) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "";
			for(int i=11;i<=649;i++){
				int random = (int)(Math.random()*1000) + 500;
				query = "insert into point_book(point,bookno,time) values " +
						"('" + random + "','" + i + "','2017-05-04');";
				System.out.println(query);
				s.execute(query);
				
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
