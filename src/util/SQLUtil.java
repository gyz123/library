package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import com.opensymphony.xwork2.ActionContext;

import po.Book;
import po.BookDetailInfo;
import po.UserDetailInfo;

public class SQLUtil {
	// 判断重复注册
	public static boolean judgeReg(String database,String openID){
		boolean flag = false;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://127.0.0.1:3306/library" , "root", "root");
			Statement s = con.createStatement();
			String query = "select * from user";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {  
            	String weid = ret.getString(1);  
                if(weid.equals(openID)){
                	flag = true;  // true 代表用户已经注册，将返回错误界面
                	break;
                }
            }
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag; 
	}
	
	// 添加用户微信信息
	public static void addUserWXInfo(String database,UserDetailInfo user){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://127.0.0.1:3306/library" , "root", "root");
			Statement s = con.createStatement();
			String query = "insert into user (weid,wename,weimg) values ('" + user.getOpenid() + "','" 
					+ user.getNickname()+ "','" + user.getHeadimgurl() + "');";
//			System.out.println(query);
			s.executeUpdate(query);
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 添加用户身份信息
	public static void addUserRealInfo(String database,String userName,String idCard,String phone,String weID){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://127.0.0.1:3306/library" , "root", "root");
			Statement s = con.createStatement();
			String query = "update user set username = '" + userName + "',idcard = '" + idCard + "',phone = '" 
						+ phone + "' where weid = '" + weID + "';";
//			System.out.println(query);
			s.executeUpdate(query);
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 查找单类书籍的简要信息
	public static ArrayList<Book> querySingleCat(String category,String pageNum){
		ArrayList<Book> bookList = new ArrayList<Book>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://127.0.0.1:3306/library" , "root", "root");
			Statement s = con.createStatement();
			
			String query = "select bookno,bookname,bookimg from book where category in " + category + " limit "
								+ (9*((Integer.parseInt(pageNum))-1)) + ",9;";
			System.out.println(query);
			ResultSet ret = s.executeQuery(query);
			// 将搜索到的9本书放入ArrayList中
			while (ret.next()) {  
				System.out.println("bookno" + ret.getString(1));
				System.out.println("bookname" + ret.getString(2));
				System.out.println("bookimg" + ret.getString(3));
				Book book = new Book();
            	book.setBookno(ret.getString(1));
            	book.setBookname(ret.getString(2));
            	book.setBookimg(ret.getString(3));
            	bookList.add(book);
            }
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bookList;
	}
	
	// 查找单本书籍的详细信息（由类别进入）
	public static BookDetailInfo querySingleBookFromCat(String bookNo){
		BookDetailInfo book = new BookDetailInfo();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://127.0.0.1:3306/library" , "root", "root");
			Statement s = con.createStatement();
			
			String query = "select * from book where bookno = " + bookNo +";";
			System.out.println(query);
			ResultSet ret = s.executeQuery(query);
			// 获取书籍信息
			while (ret.next()) {  
            	String bookno = ret.getString(1);
            	book.setBookno(bookno);
            	String isbn = ret.getString(2);
            	book.setIsbn(isbn);
            	String bookname = ret.getString(3);
            	book.setBookname(bookname);
            	book.setCategory(ret.getString(4));
            	book.setPublisher(ret.getString(5));
            	book.setVersion(ret.getString(6));
            	book.setBookimg(ret.getString(7));
            	book.setOutline(ret.getString(8));
            	book.setBookAbstract(ret.getString(9));
            	book.setGuide(ret.getString(10));
            	book.setLeftnum(ret.getString(11));
            	book.setPrice(ret.getString(12));
            }
			query = "select tag1,tag2,tag3 from booktag where bookno = " + bookNo +";";
			ret = s.executeQuery(query);
			while (ret.next()) {  
            	if(ret.getString(1)!=null)
            		book.setTag1(ret.getString(1));
            	if(ret.getString(2)!=null)
            		book.setTag2(ret.getString(2));
            	if(ret.getString(3)!=null)
            		book.setTag3(ret.getString(3));
            }
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return book;
	}
	
	// 搜索返回结果
	public static ArrayList<Book> querySingleBookFromSearch(String bookName,String pageNum){
		ArrayList<Book> bookSearchList = new ArrayList<Book>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://127.0.0.1:3306/library" , "root", "root");
			Statement s = con.createStatement();
			
			String query = "select bookno,bookname,bookimg from book " +
								"where bookname like %" + bookName +"% limit "
								+ (9*((Integer.parseInt(pageNum))-1)) + ",9;";
			System.out.println(query);
			ResultSet ret = s.executeQuery(query);
			// 获取书籍信息
			while (ret.next()) {  
				Book book = new Book();
            	book.setBookno(ret.getString(1));
            	book.setBookname(ret.getString(2));
            	book.setBookimg(ret.getString(3));
            	bookSearchList.add(book);
            }
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return bookSearchList;
	}
	
	// 查找单类书籍的简要信息
	public static String querySingleCat2(String category,String pageNum){
		StringBuffer sb = new StringBuffer();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://127.0.0.1:3306/library" , "root", "root");
			Statement s = con.createStatement();
			
			String query = "select bookno,bookname,bookimg from book where category in " + category + " limit "
					+ (9*((Integer.parseInt(pageNum))-1)) + ",9;";
			System.out.println(query);
			ResultSet ret = s.executeQuery(query);
			// 获取书籍信息
			while (ret.next()) {  
            	sb.append(ret.getString(1)+";;").append(ret.getString(2)+";;").append(ret.getString(3)+"##");
            }
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return sb.toString();
	}
}
