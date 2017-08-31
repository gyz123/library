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
			for(int i=648;i<=649;i++){
				query = "update bookcontent a,bookcontent b "
						+ "set b.bookcontent = a.bookcontent, b.chapter = a.chapter " +
						"where a.bookno = 647 and b.bookno = " + i + " " +
						"and a.chapter = '2';";
				System.out.println(query);
				s.executeUpdate(query);
				
//				query = "insert into bookcontent(bookno,chapter) values ('" + i + "','" + 2 + "');";
//				System.out.println(query);
//				s.execute(query);
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
