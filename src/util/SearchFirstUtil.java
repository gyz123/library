package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import po.Book;
import po.BookInCategory;

public class SearchFirstUtil {

	static Map<String, String> firstMap = new HashMap<String, String>();
	private static String getValue(String start){
		firstMap.put("A", "吖");
		firstMap.put("B", "八");
		firstMap.put("C", "嚓");
		firstMap.put("D", "咑");
		firstMap.put("E", "妸");
		firstMap.put("F", "发");
		firstMap.put("G", "旮");
		firstMap.put("H", "铪");
		firstMap.put("J", "丌");
		firstMap.put("K", "咔");
		firstMap.put("L", "垃");
		firstMap.put("M", "嘸");
		firstMap.put("N", "拏");
		firstMap.put("O", "噢");
		firstMap.put("P", "妑");
		firstMap.put("Q", "七");
		firstMap.put("R", "呥");
		firstMap.put("S", "仨");
		firstMap.put("T", "他");
		firstMap.put("W", "屲");
		firstMap.put("X", "夕");
		firstMap.put("Y", "丫");
		firstMap.put("Z", "咋");
		
		//遍历Map
		Iterator<String> iter = firstMap.keySet().iterator();
		String key, value = null;
		while(iter.hasNext()){
			key = iter.next();
			value = firstMap.get(key);
			if(key.equals(start)){
				return value;
			}
		}
		return value;
	}
	
	public static Connection getConnection(){
		Connection con = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return con;
	}
	
	/**
	 * 根据首字母查询
	 * @param start 开始的标识符（中文），如：八（ba）
	 * @param end 结束的标识符（中文），如：擦（ca）
	 * @return
	 */
	public static ArrayList<BookInCategory> SearchFirstBooks(String start){
		//end 结束的标识符（中文），如：擦（ca）
		String end; 
		
		ArrayList<BookInCategory> books = new ArrayList<BookInCategory>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query;
			if(!start.equals(getValue("Z"))){
				//A后面为B,ASCII码+1
				char endch = start.charAt(0);
				endch = (char) (endch + 1);
				end = String.valueOf(endch);
				end = getValue(end);
				start = getValue(start);
				
				query = "SELECT bookno, bookname, publisher, author FROM book WHERE " +
						"CONVERT( bookname USING gbk ) COLLATE gbk_chinese_ci >='" + start +"' " +
						"AND CONVERT( bookname USING gbk ) COLLATE gbk_chinese_ci < '" + end + "'";
			}else{
				query = "SELECT bookno, bookname, publisher, author FROM book WHERE " +
						"CONVERT( bookname USING gbk ) COLLATE gbk_chinese_ci >='" + start +"' " ;
				System.out.println(query);
			}
			
			ResultSet ret = s.executeQuery(query);
			// 获取书籍信息
			while (ret.next()) {  
				BookInCategory book = new BookInCategory();
				book.setBookno(ret.getString(1));
				book.setBookname(ret.getString(2));
				book.setPublisher(ret.getString(3));
				book.setAuthor(ret.getString(4));
				books.add(book);
	           }
	           con.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			return books;
		}
}
