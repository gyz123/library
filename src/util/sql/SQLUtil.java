package util.sql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import po.Comment;
import po.book.Book;
import po.book.BookDetailInfo;
import po.book.BookInCategory;
import po.user.UserDetailInfo;
import util.pinyin.PinyinUtils;
import util.weixin.WeixinUtil;

public class SQLUtil {

	public static Connection getConnection() {
		Connection con = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return con;
	}

	// 判断重复注册
	public static boolean judgeReg(String database, String openID) {
		boolean flag = false;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			// Connection con = getConnection();
			Statement s = con.createStatement();
			String query = "select * from user";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {
				String weid = ret.getString(1);
				if (weid.equals(openID)) {
					flag = true; // true 代表用户已经注册，将返回错误界面
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
	public static void addUserWXInfo(String database, String openid,
			String nickname, String headimg) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "insert into user (weid,wename,weimg) values ('"
					+ openid + "','" + nickname + "','" + headimg + "');";
			System.out.println(query);
			s.executeUpdate(query);
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 添加用户身份信息
	public static void addUserRealInfo(String database, String userName,
			String idCard, String phone, String weID) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "update user set username = '" + userName
					+ "',idcard = '" + idCard + "',phone = '" + phone
					+ "' where weid = '" + weID + "';";
			// System.out.println(query);
			s.executeUpdate(query);
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 返回所有用户的详细信息
	public static ArrayList<UserDetailInfo> queryUserList() {
		ArrayList<UserDetailInfo> userList = new ArrayList<UserDetailInfo>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select * from user";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {
				String weid = ret.getString(1);
				String phone = ret.getString(2);
				String wename = ret.getString(3);
				String weimg = ret.getString(4);
				String idcard = ret.getString(5);
				String username = ret.getString(6);
				UserDetailInfo user = new UserDetailInfo();
				user.setOpenid(weid);
				user.setTel(phone);
				user.setNickname(wename);
				user.setHeadimgurl(weimg);
				user.setIdCard(idcard);
				user.setRealName(username);
				userList.add(user);
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return userList;
	}

	// 返回单个用户的详细信息
	public static UserDetailInfo querySingleUser(String type, String str) {
		UserDetailInfo user = new UserDetailInfo();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "";
			if (type.equals("wename")) {
				query = "select * from user where wename = '" + str + "';";
			} else if (type.equals("weid")) {
				query = "select * from user where weid = '" + str + "';";
			}
			ResultSet ret = s.executeQuery(query);
			// 获取用户信息
			while (ret.next()) {
				user.setOpenid(ret.getString(1));
				user.setTel(ret.getString(2));
				user.setNickname(ret.getString(3));
				user.setHeadimgurl(ret.getString(4));
				user.setIdCard(ret.getString(5));
				user.setRealName(ret.getString(6));
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}

	// 由weid获取用户id
	public static String getUserId(String weid) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select id from user where weid = '" + weid + "';";
			ResultSet ret = s.executeQuery(query);
			// 获取用户信息
			while (ret.next()) {
				String id = ret.getString(1);
				if (!id.isEmpty())
					return id;
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// 查找单类书籍（编号，书名，图片，作者，剩余，阅读量，评分）
	public static ArrayList<BookInCategory> querySingleCat(String category,
			String pageNum, String target) {
		ArrayList<BookInCategory> bookList = new ArrayList<BookInCategory>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();

			String query = "select bookno,bookname,bookimg,author,leftnum,publisher,readingnum,score from book where category in "
					+ category
					+ " ORDER BY "
					+ target
					+ " DESC"
					+ " limit "
					+ (5 * ((Integer.parseInt(pageNum)) - 1)) + ",5;";
			// System.out.println(query);
			ResultSet ret = s.executeQuery(query);
			// 将搜索到的9本书放入ArrayList中
			while (ret.next()) {
				BookInCategory book = new BookInCategory();
				book.setBookno(ret.getString(1));
				book.setBookname(ret.getString(2));
				book.setBookimg(ret.getString(3));
				book.setAuthor(ret.getString(4));
				book.setLeftNum(ret.getString(5));
				book.setPublisher(ret.getString(6));
				book.setReadingnum(ret.getString(7));
				book.setScore(ret.getString(8));
				bookList.add(book);
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bookList;
	}

	// 查找单本书籍（所有）（由类别进入）
	public static BookDetailInfo querySingleBookFromCat(String bookNo) {
		BookDetailInfo book = new BookDetailInfo();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();

			String query = "select * from book where bookno = " + bookNo + ";";
			// System.out.println(query);
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
				book.setAuthor(ret.getString(13));
				book.setReadingnum(ret.getString(14));
				book.setScore(ret.getString(15));
			}
			query = "select tag1,tag2,tag3 from booktag where bookno = "
					+ bookNo + ";";
			ret = s.executeQuery(query);
			while (ret.next()) {
				if (ret.getString(1) != null)
					book.setTag1(ret.getString(1));
				if (ret.getString(2) != null)
					book.setTag2(ret.getString(2));
				if (ret.getString(3) != null)
					book.setTag3(ret.getString(3));
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return book;
	}

	// 获取标签
	public static ArrayList<String> getBookTags(String bookno) {
		ArrayList<String> tags = new ArrayList<String>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select tag1,tag2,tag3 from booktag where bookno = "
					+ bookno + ";";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {
				if (ret.getString(1) != null)
					tags.add(ret.getString(1));
				if (ret.getString(2) != null)
					tags.add(ret.getString(2));
				if (ret.getString(3) != null)
					tags.add(ret.getString(3));
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return tags;
	}

	// 获取书评
	public static ArrayList<Comment> getBookComments(String bookno) {
		ArrayList<Comment> list = new ArrayList<Comment>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select bookcomment.bookno,bookcomment.comment,bookcomment.commentid,bookcomment.time,"
					+ "user.weid,user.wename,user.weimg,bookcomment.goodnum "
					+ "from bookcomment,user "
					+ "where bookcomment.weid = user.weid and bookcomment.bookno = '"
					+ bookno
					+ "' order by bookcomment.goodnum desc,bookcomment.time desc,bookcomment.commentid desc;";
			// "where bookcomment.bookno = " + bookno +";";
			System.out.println(query);
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {
				Comment comment = new Comment();
				comment.setBookno(ret.getString(1));
				comment.setComment(ret.getString(2));
				comment.setCommentid(ret.getString(3));
				comment.setTime(ret.getString(4));
				comment.setGoodnum(ret.getString(8)); // 点赞数

				comment.setWeid(ret.getString(5));
				comment.setWename(ret.getString(6));
				comment.setWeimg(ret.getString(7));
				list.add(comment);
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// 写书评
	public static void handleNewComment(String weid, String bookno,
			String comment) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			String time = df.format(new Date());
			String query = "insert into bookcomment (weid,bookno,comment,time,goodnum) "
					+ "values ('"
					+ weid
					+ "','"
					+ bookno
					+ "','"
					+ comment
					+ "','" + time + "','" + "0" + "');";
			System.out.println(query);
			s.executeUpdate(query);
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 目录
	public static HashMap<String, String> getBookOutline(String bookno) {
		HashMap<String, String> bookInfo = new HashMap<String, String>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select outline,bookname from book where bookno = "
					+ bookno + ";";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {
				bookInfo.put("outline", ret.getString(1));
				bookInfo.put("bookname", ret.getString(2));
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bookInfo;
	}

	
	// 序言
	public static HashMap<String, String> getBookXu(String bookno) {
		HashMap<String, String> bookInfo = new HashMap<String, String>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select xu,bookname from book where bookno = "
					+ bookno + ";";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {
				bookInfo.put("xu", ret.getString(1));
				bookInfo.put("bookname", ret.getString(2));
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bookInfo;
	}
	
	
	// 依据关键词搜索书籍列表 (编号，书名，图片，出版社，作者，剩余量, 阅读量，评分)
	public static ArrayList<BookInCategory> querySingleBookFromSearch(
			String type, String keyword, String pageNum) {
		ArrayList<BookInCategory> bookSearchList = new ArrayList<BookInCategory>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "";
			
			if(type.equals("chinese")){
				query = "select bookno,bookname,bookimg,publisher,author,leftnum,readingnum,score from book " +
						"where bookname like '%" + keyword +"%' limit "
						+ (5*((Integer.parseInt(pageNum))-1)) + ",5;";
			}else if(type.equals("pinyin")){
				keyword = PinyinUtils.split(keyword);//keyword拼音分词
				query = "select book.bookno, book.bookname, book.bookimg, book.publisher, " +
						"book.author, book.leftnum, book.readingnum, book.score " +
						"from book,pinyin " +
						"where book.bookno = pinyin.id and pinyin.pinyin like '%" + keyword +"%' limit "
						+ (5*((Integer.parseInt(pageNum))-1)) + ",5;";
			}else if(type.equals("isbn")){
				query = "select bookno,bookname,bookimg,publisher,author,leftnum,readingnum,score from book " +
						"where isbn = '" + keyword +"' limit "
						+ (5*((Integer.parseInt(pageNum))-1)) + ",5;";
			}

			System.out.println(query);
			ResultSet ret = s.executeQuery(query);
			// 获取书籍信息
			while (ret.next()) {
				BookInCategory book = new BookInCategory();
				book.setBookno(ret.getString(1));
				book.setBookname(ret.getString(2));
				book.setBookimg(ret.getString(3));
				book.setPublisher(ret.getString(4));
				book.setAuthor(ret.getString(5));
				book.setLeftNum(ret.getString(6));
				book.setReadingnum(ret.getString(7));
				book.setScore(ret.getString(8));
				bookSearchList.add(book);
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return bookSearchList;
	}

	// 依据bookname查找单本书籍 （所有信息）
	public static BookDetailInfo querySingleBookByKeyword(String keyword) {
		BookDetailInfo book = new BookDetailInfo();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();

			String query = "select * from book where bookname = '" + keyword
					+ "';";
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
				book.setAuthor(ret.getString(13));
				book.setReadingnum(ret.getString(14));
				book.setScore(ret.getString(15));
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return book;
	}

	// 查找单类书籍 （所有信息）
	public static ArrayList<BookDetailInfo> querySingleCat3(String category,
			String pageNum) {
		ArrayList<BookDetailInfo> bookList = new ArrayList<BookDetailInfo>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();

			String query = "select * from book where category in " + category
					+ " limit " + (5 * ((Integer.parseInt(pageNum)) - 1))
					+ ",5;";
			System.out.println(query);
			ResultSet ret = s.executeQuery(query);
			// 将搜索到的9本书放入ArrayList中
			while (ret.next()) {
				BookDetailInfo book = new BookDetailInfo();
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
				book.setAuthor(ret.getString(13));
				book.setReadingnum(ret.getString(14));
				book.setScore(ret.getString(15));
				bookList.add(book);
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bookList;
	}

	// 获取相关书籍
	public static ArrayList<Book> relativeBooks(String bookno, String category) {
		ArrayList<Book> books = new ArrayList<Book>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();

			String query = "select bookno,bookname,bookimg from book "
					+ "where category = '" + category + "' and bookno != "
					+ bookno + ";";
			ResultSet ret = s.executeQuery(query);
			// 获取书籍信息
			while (ret.next()) {
				Book book = new Book();
				book.setBookno(ret.getString(1));
				book.setBookname(ret.getString(2));
				book.setBookimg(ret.getString(3));
				books.add(book);
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return books;
	}

	/**
	 * 从bookno获取bookname
	 * 
	 * @param bookno
	 * @return
	 */
	public static String getBookName(String bookno) {

		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();

			String query = "select bookname from book " + "where bookno = "
					+ bookno + ";";
			ResultSet ret = s.executeQuery(query);
			// 获取书籍信息
			String bookname = null;
			while (ret.next()) {
				bookname = ret.getString(1);
			}

			con.close();
			return bookname;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "";
	}

	/**
	 * 获取书籍图片url
	 * @param bookno 图书id
	 * @return 返回图书url
	 */
	public static String getBookPicUrl(String bookno) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();

			String query = "select bookimg from book " + "where bookno = "
					+ bookno + ";";
			ResultSet ret = s.executeQuery(query);
			// 获取书籍信息
			String bookimg = null;
			while (ret.next()) {
				bookimg = ret.getString(1);
			}

			con.close();
			return bookimg;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "";
	}
	
	// 依据bookname获取bookno
	public static String getBooknoByBookname(String bookname){
		String bookno = "";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select bookno from book " + "where bookname = '" + bookname + "';";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {
				bookno = ret.getString(1);
				break;
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bookno;
	}
	
	// 根据isbn搜索bookno
	public static String getBooknoByISBN(String isbn){
		String bookno = "";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select bookno from book where isbn = '" + isbn + "';";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {
				bookno = ret.getString(1);
				break;
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bookno;
	}
	
}
