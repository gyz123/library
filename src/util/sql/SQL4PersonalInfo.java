package util.sql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import po.PayList;
import po.book.BookInCategory;
import po.book.BookInShoppingcart;
import po.book.BookWithoutImg;
import po.book.BorrowedBook;
import po.user.UserDetailInfo;
import util.weixin.WeixinUtil;

// 定义了个人信息搜索的SQL函数
public class SQL4PersonalInfo {
	// 获取用户信息
	public static UserDetailInfo queryUser(String openid){
		UserDetailInfo user = new UserDetailInfo();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select * from user where weid = '" + openid + "'";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {  
            	String weid = ret.getString(1);  
            	String phone = ret.getString(2);
            	String wename  = ret.getString(3);
            	String weimg = ret.getString(4);
            	String idcard = ret.getString(5);
            	String username = ret.getString(6);
            	user.setOpenid(weid);
            	user.setTel(phone);
            	user.setNickname(wename);
            	user.setHeadimgurl(weimg);
            	user.setIdCard(idcard);
            	user.setRealName(username);
            }
            con.close();
            if(user.getIdCard()!=null){
            	return user;
            }
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	// 添加收藏
	public static void addToLike(String weid,String bookno){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "insert into bookshelf (weid,bookno) " +
								"values ('" + weid + "'," + bookno + ");";
			s.executeUpdate(query);
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 取消收藏
	public static void deleteLike(String weid,String bookno){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "delete from bookshelf where weid = '" + weid 
									+ "' and bookno = " + bookno + ";";
			s.executeUpdate(query);
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 判断是否已经收藏
	public static String judgeLike(String weid,String bookno){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select * from bookshelf where weid = '" + weid + "' and bookno =" + bookno + ";";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {  
				return "Y";
			}
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "N";
	}
	
	
	// 获取我的书架中收藏的书 (编号，书名，图片，出版社，作者，剩余量)
	public static ArrayList<BookInCategory> queryMyBookshelf(String weid){
		ArrayList<BookInCategory> bookList = new ArrayList<BookInCategory>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			
			String query = "select book.bookno,book.bookname,book.bookimg,book.publisher,book.author " +
							"from bookshelf,book " +
							"where book.bookno = bookshelf.bookno and weid = '" + weid + "';"; 
			ResultSet ret = s.executeQuery(query);
			// 将搜索到的9本书放入ArrayList中
			while (ret.next()) {  
				BookInCategory book = new BookInCategory();
				book.setBookno(ret.getString(1));
            	book.setBookname(ret.getString(2));
            	book.setBookimg(ret.getString(3));
            	book.setPublisher(ret.getString(4));
            	book.setAuthor(ret.getString(5));
            	bookList.add(book);
            }
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bookList;
	}
	
	
	// 获取个人借书情况（借过的书，现在已经还了）
	public static ArrayList<BorrowedBook> queryMyBorrow(String weid){
		ArrayList<BorrowedBook> bookList = new ArrayList<BorrowedBook>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			
			String query = "select bookno,bookname,borrowtime,returntime from borrow " +
								"where returntime IS NOT NULL and weid = '" + weid + "';"; 
			ResultSet ret = s.executeQuery(query);
			// 将搜索到的9本书放入ArrayList中
			while (ret.next()) {  
				BorrowedBook book = new BorrowedBook();
            	book.setBookno(ret.getString(1));
            	book.setBookname(ret.getString(2));
            	book.setBorrowtime(ret.getString(3));
            	book.setReturntime(ret.getString(4));
            	bookList.add(book);
            }
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bookList;
	}
	
	
	// 预定
	public static Boolean addToReserve(String weid,String bookno){
		Boolean whetherSuccess = false;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			// 先判断用户是否已经预定
			Boolean flag = true;
			String query = "select bookno from reserve where weid = '" + weid + "'";
			ResultSet ret = s.executeQuery(query);
			while(ret.next()){
				if(ret.getString(1).equals(bookno)){
					// 已经预定
					flag = false;	
					break;
				}
			}
			
			if(flag){
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				String time = df.format(new Date());
				query = "insert into reserve (weid,bookno,reservetime) values ('" + weid + "','" + bookno + "','" + time + "');";
				s.executeUpdate(query);
				// 预定成功
				whetherSuccess = true; 
			}
			
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return whetherSuccess;
	}
	
	
	// 添加书本到购物车（不可添加同一本书多次到购物车）
	public static Boolean addToShoppingCart(String bookno,String weid){
		Boolean whetherSuccess = false;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			// 先判断用户是否已经预定
			Boolean flag = true;
			String query = "select bookno from shoppingcart where weid = '" + weid + "'";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {
				if (ret.getString(1).equals(bookno)) {
					// 已经加入了购物车
					flag = false;
					break;
				}
			}
			
			if(flag){
				query = "insert into shoppingcart (weid,bookno) values ('" + weid + "','" + bookno + "');";
				s.executeUpdate(query);
				whetherSuccess = true;
			}
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return whetherSuccess;
	}
	
	
	// 获取个人购物车详情
	public static ArrayList<BookInShoppingcart> queryShoppingCart(String weid){
		ArrayList<BookInShoppingcart> bookList = new ArrayList<BookInShoppingcart>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			
			String query = "select book.bookno,book.bookname,book.bookimg,book.price " +
							"from shoppingcart,book " +
							"where book.bookno = shoppingcart.bookno and shoppingcart.weid = '" + weid + "';"; 
			ResultSet ret = s.executeQuery(query);
			// 将搜索到的9本书放入ArrayList中
			while (ret.next()) {  
				BookInShoppingcart book = new BookInShoppingcart();
            	book.setBookno(ret.getString(1));
            	book.setBookname(ret.getString(2));
            	book.setBookimg(ret.getString(3));
            	book.setPrice(ret.getString(4));
            	bookList.add(book);
            }
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bookList;
	}
	
	
	// 删除购物车中的商品
	public static void deleteBookFromCart(String weid,String bookno){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "delete from shoppingcart where weid = '" + weid + "' and bookno = " + bookno + ";";
			s.executeUpdate(query);
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 处理借阅历史的相关数据
	public static Map<String, HashMap<String,Integer>> getPersonalBookInfo(String weid){
		Map<String, HashMap<String,Integer>> personalBookInfo = new HashMap<String, HashMap<String,Integer>>();
		int cnt1=0,cnt2=0,cnt3=0,cnt4=0,cnt5=0,cnt6=0,cnt7=0,cnt8=0,cnt9=0,
					cnt10=0,cnt11=0,cnt12=0,cnt13=0,cnt14=0,cnt15=0,cnt16=0,cnt17=0,cnt18=0,cnt19=0;
		// 种类分类
		HashMap<String,Integer> bookCat = new HashMap<String,Integer>();
		bookCat.put("a",cnt1);
		bookCat.put("b",cnt2);
		bookCat.put("c",cnt3);
		bookCat.put("d",cnt4);
		// 年份分类
		HashMap<String,Integer> yearCnt = new HashMap<String,Integer>();
		yearCnt.put("2015", cnt5);
		yearCnt.put("2016", cnt6);
		yearCnt.put("2017", cnt7);
		// 过去一年月度分类
		HashMap<String,Integer> monthCnt = new HashMap<String,Integer>();
		monthCnt.put("1", cnt8);
		monthCnt.put("2", cnt9);
		monthCnt.put("3", cnt10);
		monthCnt.put("4", cnt11);
		monthCnt.put("5", cnt12);
		monthCnt.put("6", cnt13);
		monthCnt.put("7", cnt14);
		monthCnt.put("8", cnt15);
		monthCnt.put("9", cnt16);
		monthCnt.put("10", cnt17);
		monthCnt.put("11", cnt18);
		monthCnt.put("12", cnt19);
		
		// 1.获取用户所有的借阅情况
		ArrayList<BorrowedBook> booklist = queryMyBorrow(weid);
		// 2.遍历每本书，在对应的分类中+1
		Iterator<BorrowedBook> iterator = booklist.iterator();
		while(iterator.hasNext()){
			BorrowedBook book = (BorrowedBook) iterator.next();
			String bookNo = book.getBookno();
			String cat = "";
			try {
				Class.forName("com.mysql.jdbc.Driver");
				Connection con = DriverManager.getConnection(
						"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
				Statement s = con.createStatement();
				
				String query = "select category from book where bookno = " + bookNo +  ";";
				ResultSet ret = s.executeQuery(query);
				while (ret.next()) {  
					cat = ret.getString(1);  // 获取借阅的书的类别
	            }
				// 种类分类计数
				if(cat.contains("文学") || cat.equals("小说") || cat.contains("儿童") || cat.equals("散文") || cat.equals("历史")){
					cnt1++;
					bookCat.remove("a");
					bookCat.put("a", cnt1);
				}else if(cat.equals("哲学") || cat.contains("心理") || cat.contains("鸡汤")){
					cnt2++;
					bookCat.remove("b");
					bookCat.put("b", cnt2);
				}else if(cat.contains("传记") || cat.equals("教育") || cat.equals("成功励志") || cat.equals("管理")){
					cnt3++;
					bookCat.remove("c");
					bookCat.put("c", cnt3);
				}else if(cat.contains("计算机")){
					cnt4++;
					bookCat.remove("d");
					bookCat.put("d", cnt4);
				}
				
	            con.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			// 借阅日期格式：yyyy-MM-dd
			String borrowTime[] = book.getBorrowtime().split("-");
			String year = borrowTime[0];
			String month = borrowTime[1];
			
			// 年份分类计数  
			if(year.trim().equals("2015")){
				cnt5++;
				bookCat.remove("2015");
				bookCat.put("2015", cnt5);
			}else if(year.trim().equals("2016")){
				cnt6++;
				bookCat.remove("2016");
				bookCat.put("2016", cnt6);
			}else if(year.trim().equals("2017")){
				cnt7++;
				bookCat.remove("2017");
				bookCat.put("2017", cnt7);
			}
			
			
			// 月份分类计数
			if(month.trim().equals("01")){
				cnt8++;
				bookCat.remove("1");
				bookCat.put("1", cnt8);
			}else if(month.trim().equals("02")){
				cnt9++;
				bookCat.remove("2");
				bookCat.put("2", cnt9);
			}else if(month.trim().equals("03")){
				cnt10++;
				bookCat.remove("3");
				bookCat.put("3", cnt10);
			}else if(month.trim().equals("04")){
				cnt11++;
				bookCat.remove("4");
				bookCat.put("4", cnt11);
			}else if(month.trim().equals("05")){
				cnt12++;
				bookCat.remove("5");
				bookCat.put("5", cnt12);
			}else if(month.trim().equals("06")){
				cnt13++;
				bookCat.remove("6");
				bookCat.put("6", cnt13);
			}else if(month.trim().equals("07")){
				cnt14++;
				bookCat.remove("7");
				bookCat.put("7", cnt14);
			}else if(month.trim().equals("08")){
				cnt15++;
				bookCat.remove("8");
				bookCat.put("8", cnt15);
			}else if(month.trim().equals("09")){
				cnt16++;
				bookCat.remove("9");
				bookCat.put("9", cnt16);
			}else if(month.trim().equals("10")){
				cnt17++;
				bookCat.remove("10");
				bookCat.put("10", cnt17);
			}else if(month.trim().equals("11")){
				cnt18++;
				bookCat.remove("11");
				bookCat.put("11", cnt18);
			}else if(month.trim().equals("12")){
				cnt19++;
				bookCat.remove("12");
				bookCat.put("12", cnt19);
			}
		}
		
		// 将单个map存入大map中
		personalBookInfo.put("cat", bookCat);
		personalBookInfo.put("year", yearCnt);
		personalBookInfo.put("month", monthCnt);
		
		return personalBookInfo;
	}
	
	
	// 获取正在借阅的书（查找returntime为空的行）
	public static ArrayList<BorrowedBook> queryMyBorrow2(String weid){
		ArrayList<BorrowedBook> bookList = new ArrayList<BorrowedBook>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			
			String query = "select bookno,bookname,borrowtime from borrow where weid = '" + weid + 
							"' and returntime is null;"; 
			ResultSet ret = s.executeQuery(query);
			// 将搜索到的9本书放入ArrayList中
			while (ret.next()) {  
				BorrowedBook book = new BorrowedBook();
            	book.setBookno(ret.getString(1));
            	book.setBookname(ret.getString(2));
            	book.setBorrowtime(ret.getString(3));
            	bookList.add(book);
            }
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bookList;
	}
	
	
	// 续借
	public static void setBorrowDate(String weid,String bookno){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			String time = df.format(new Date());
			String query = "update borrow set borrowtime = '" + time + "' where weid = '" + weid + 
							"' and bookno = " + bookno + " ;"; 
			s.executeUpdate(query);
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 添加到已借阅
	public static void addToBorrow(String weid,String subscribenum){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			// 标准化借书日期
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			String time = df.format(new Date());
			String query = "select bookno,bookname from paylist where subscribenum = '" + subscribenum + "';";
			ResultSet ret = s.executeQuery(query);
			ArrayList<BookWithoutImg> list = new ArrayList<BookWithoutImg>();
			while (ret.next()) {  
				BookWithoutImg book = new BookWithoutImg();
				book.setBookno(ret.getString(1));
				book.setBookname(ret.getString(2));
				list.add(book);
            }
			Iterator<BookWithoutImg> iterator = list.iterator();
			while(iterator.hasNext()){
				BookWithoutImg book = (BookWithoutImg)iterator.next();
				query = "insert into borrow (weid,bookno,bookname,borrowtime) values ('" + weid + "','" 
						+ book.getBookno() + "','" + book.getBookname() + "','" + time + "');";
				s.executeUpdate(query);
			}
			
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 保存订单
	public static void saveOrder(String weid,PayList list){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "insert into paylist values ('" + list.getWeid() + "','" + list.getSubsribenum() + "','" 
					+ list.getMoney() + "','" + list.getBookname() +  "','" + list.getBookno() + "','" 
					+ list.getStatus() + "','" + list.getWhetherPay() + "');";
			s.executeUpdate(query);
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 组装订单
	public static PayList setPayList(String weid,String bookno,String subscribenum){
		PayList list = new PayList();
		list.setWeid(weid);
		list.setBookno(bookno);
		list.setSubsribenum(subscribenum);  // 订单号
		list.setStatus("N");  // 管理员确认状态
		list.setWhetherPay("N");	// 用户支付状态
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select price,bookname from book where bookno = " + bookno + ";";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {  
            	list.setMoney(ret.getString(1));
            	list.setBookname(ret.getString(2));
            }
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	
	// 监听status状态
	public static String judgeManagerConfirm(String weid){
		String status = "";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select status,subscribenum from paylist where weid = '" + weid + "';";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {  
            	status = ret.getString(1);	// 不断刷新，得到最新订单的状态
            }
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return status;
	}
	
	
	// 管理员确认订单
	public static void setBorrowConfirm(String subscribenum){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "update paylist set status = 'Y' where subscribenum = '" + subscribenum + "';";
			s.executeUpdate(query);
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 用户完成订单支付
	public static void setWhetherPay(String subscribenum){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "update paylist set whetherpay = 'Y' where subscribenum = '" + subscribenum + "';";
			s.executeUpdate(query);
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 获取用户的当前订单号
	public static String getSubscribeNum(String weid){
		String num = "";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select subscribenum from paylist " +
								"where weid = '" + weid + "';";	
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {  
            	num = ret.getString(1);	// 不断刷新，得到最新订单的状态
            }
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return num;
	}
	
	
	// 返回用户确认订单
	public static ArrayList<BookInShoppingcart> confirmOrder(String subscribenum){
		ArrayList<BookInShoppingcart> list = new ArrayList<BookInShoppingcart>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select book.bookno,book.bookname,book.bookimg,book.price " +
							"from paylist,book " +
							"where paylist.bookno=book.bookno and paylist.whetherpay = 'N' " +
							"and paylist.subscribenum = '" + subscribenum + "';";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {  
            	BookInShoppingcart book = new BookInShoppingcart();
            	book.setBookno(ret.getString(1));
            	book.setBookname(ret.getString(2));
            	book.setBookimg(ret.getString(3));
            	book.setPrice(ret.getString(4));
            	list.add(book);
            }
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	
	// 管理员确认还书
	public static void setReturnConfirm(String weid,String bookno){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			String time = df.format(new Date());
			String query = "update borrow set returntime = '" + time +
							"' where weid = '" + weid + "' and bookno = '"+ bookno + "';";
			s.executeUpdate(query);
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 监听归还状态
	public static String listenReturn(String weid,String bookno){
		String status = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select returntime from borrow where weid = '" 
									+ weid + "' and bookno = '"+ bookno + "';";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {  
            	if(ret.getString(1) != null){
            		status = "Y";
            	}
            }
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return status;
	}
	
}
