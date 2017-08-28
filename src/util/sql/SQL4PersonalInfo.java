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
import po.ReserveOrder;
import po.book.BookInCategory;
import po.book.BookInCurrentList;
import po.book.BookInShoppingcart;
import po.book.BookWithoutImg;
import po.book.BorrowedBook;
import po.user.UserDetailInfo;
import util.weixin.WeixinUtil;

// �����˸�����Ϣ������SQL����
public class SQL4PersonalInfo {
	// ��ȡ�û���Ϣ
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
	
	
	// �޸��û���Ϣ
	public static void modifyUserInfo(String weid,String username,String phone,String idcard){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "update user" 
					+ " set phone = '" + phone 
					+ "' , username = '" + username 
					+ "' , idcard = '" + idcard + "' " 
					+ "where weid = '" + weid + "';";
			//System.out.println(query);
            s.executeUpdate(query);
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	
	// ����ղ�
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
	
	
	// ȡ���ղ�
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
	
	
	// �ж��Ƿ��Ѿ��ղ�
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
	
	
	// ��ȡ�ҵ�������ղص��� (��ţ�������ͼƬ�������磬���ߣ�ʣ����)
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
			// ����������9�������ArrayList��
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
	
	
	// ��ȡ���˽��������������飬�����Ѿ����ˣ�
	public static ArrayList<BorrowedBook> queryMyBorrow(String weid){
		ArrayList<BorrowedBook> bookList = new ArrayList<BorrowedBook>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			
			String query = "select bookno,bookname,borrowtime,returntime from borrow " +
								"where returntime IS NOT NULL and weid = '" + weid + "'" +
								" order by borrowtime desc;"; 
			ResultSet ret = s.executeQuery(query);
			// ����������9�������ArrayList��
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
	
	
	// Ԥ��
	public static Boolean addToReserve(String weid,String bookno){
		Boolean whetherSuccess = false;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			// ���ж��û��Ƿ��Ѿ�Ԥ��
			Boolean flag = true;
			String query = "select bookno from reserve where weid = '" + weid + "'";
			ResultSet ret = s.executeQuery(query);
			while(ret.next()){
				if(ret.getString(1).equals(bookno)){
					// �Ѿ�Ԥ��
					flag = false;	
					break;
				}
			}
			
			if(flag){
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				String time = df.format(new Date());
				query = "insert into reserve (weid,bookno,reservetime) values ('" + weid + "','" + bookno + "','" + time + "');";
				s.executeUpdate(query);
				// Ԥ���ɹ�
				whetherSuccess = true; 
			}
			
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return whetherSuccess;
	}
	
	
	// ����鱾�����ﳵ���������ͬһ�����ε����ﳵ��
	public static Boolean addToShoppingCart(String bookno,String weid){
		Boolean whetherSuccess = false;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			// ���ж��û��Ƿ��Ѿ�Ԥ��
			Boolean flag = true;
			String query = "select bookno from shoppingcart where weid = '" + weid + "'";
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {
				if (ret.getString(1).equals(bookno)) {
					// �Ѿ������˹��ﳵ
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
	
	
	// ��ȡ���˹��ﳵ����
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
			// ����������9�������ArrayList��
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
	
	
	// ɾ�����ﳵ�е���Ʒ
	public static void deleteBookFromCart(String weid,String bookno){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "delete from shoppingcart where weid = '" + weid + "' and bookno = " + bookno + ";";
			System.out.println(query);
			s.executeUpdate(query);
            con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// ���������ʷ���������
	public static Map<String, HashMap<String,Integer>> getPersonalBookInfo(String weid){
		Map<String, HashMap<String,Integer>> personalBookInfo = new HashMap<String, HashMap<String,Integer>>();
		int cnt1=0,cnt2=0,cnt3=0,cnt4=0,cnt5=0,cnt6=0,cnt7=0,cnt8=0,cnt9=0,
					cnt10=0,cnt11=0,cnt12=0,cnt13=0,cnt14=0,cnt15=0,cnt16=0,cnt17=0,cnt18=0,cnt19=0;
		// �������
		HashMap<String,Integer> bookCat = new HashMap<String,Integer>();
		bookCat.put("a",cnt1);
		bookCat.put("b",cnt2);
		bookCat.put("c",cnt3);
		bookCat.put("d",cnt4);
		// ��ݷ���
		HashMap<String,Integer> yearCnt = new HashMap<String,Integer>();
		yearCnt.put("2015", cnt5);
		yearCnt.put("2016", cnt6);
		yearCnt.put("2017", cnt7);
		// ��ȥһ���¶ȷ���
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
		
		// 1.��ȡ�û����еĽ������
		ArrayList<BorrowedBook> booklist = queryMyBorrow(weid);
		// 2.����ÿ���飬�ڶ�Ӧ�ķ�����+1
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
					cat = ret.getString(1);  // ��ȡ���ĵ�������
	            }
				// ����������
				if(cat.contains("��ѧ") || cat.equals("С˵") || cat.contains("��ͯ") || cat.equals("ɢ��") || cat.equals("��ʷ")){
					cnt1++;
					bookCat.remove("a");
					bookCat.put("a", cnt1);
				}else if(cat.equals("��ѧ") || cat.contains("����") || cat.contains("����")){
					cnt2++;
					bookCat.remove("b");
					bookCat.put("b", cnt2);
				}else if(cat.contains("����") || cat.equals("����") || cat.equals("�ɹ���־") || cat.equals("����")){
					cnt3++;
					bookCat.remove("c");
					bookCat.put("c", cnt3);
				}else if(cat.contains("�����")){
					cnt4++;
					bookCat.remove("d");
					bookCat.put("d", cnt4);
				}
				
	            con.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			// �������ڸ�ʽ��yyyy-MM-dd
			String borrowTime[] = book.getBorrowtime().split("-");
			String year = borrowTime[0];
			String month = borrowTime[1];
			
			// ��ݷ������  
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
			
			
			// �·ݷ������
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
		
		// ������map�����map��
		personalBookInfo.put("cat", bookCat);
		personalBookInfo.put("year", yearCnt);
		personalBookInfo.put("month", monthCnt);
		
		return personalBookInfo;
	}
	
	
	// ��ȡ���ڽ��ĵ��飨����returntimeΪ�յ��У�
	public static ArrayList<BorrowedBook> queryMyBorrow2(String weid){
		ArrayList<BorrowedBook> bookList = new ArrayList<BorrowedBook>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			
			String query = "select bookno,bookname,borrowtime from borrow where weid = '" + weid + 
							"' and returntime is null " +
							"order by borrowtime desc;"; 
			ResultSet ret = s.executeQuery(query);
			// ����������9�������ArrayList��
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
	
	
	// ����
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
	
	
	// ��ӵ��ѽ���
	public static void addToBorrow(String weid,String subscribenum){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			// ��׼����������
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
	
	
	// ���涩��
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
	
	
	// ��װ����
	public static PayList setPayList(String weid,String bookno,String subscribenum){
		PayList list = new PayList();
		list.setWeid(weid);
		list.setBookno(bookno);
		list.setSubsribenum(subscribenum);  // ������
		list.setStatus("N");  // ����Աȷ��״̬
		list.setWhetherPay("N");	// �û�֧��״̬
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
	
	
	// ����status״̬
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
            	status = ret.getString(1);	// ����ˢ�£��õ����¶�����״̬
            }
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return status;
	}
	
	
	// ����Աȷ�϶���
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
	
	
	// �û���ɶ���֧��
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
	
	
	// ��ȡ�û��ĵ�ǰ������
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
            	num = ret.getString(1);	// ����ˢ�£��õ����¶�����״̬
            }
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return num;
	}
	
	
	// �����û�ȷ�϶���
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
	
	
	// ����Աȷ�ϻ���
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
	
	
	// �����黹״̬
	public static String listenReturn(String weid,String bookno){
		String status = "N";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select returntime from borrow where weid = '" 
									+ weid + "' and bookno = '"+ bookno + "';";
			System.out.println(query);
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {  
				System.out.println(ret.getString(1));
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
	
	
	// ��ǰ���� or ��ʷ��¼
	public static ArrayList<BookInCurrentList> getCurrentReading(String category,String weid){
		ArrayList<BookInCurrentList> list = new ArrayList<BookInCurrentList>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ WeixinUtil.MYSQL_DN, WeixinUtil.MYSQL_NAME,
					WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "";
			if(category.equals("now")){
				query = "select book.bookno,book.bookname,book.bookimg,book.author,borrow.borrowtime " +
						"from book,borrow " +
						"where borrow.weid = '" + weid +"' " +
						"and borrow.returntime is null and borrow.bookno = book.bookno;";
			}else if(category.equals("history")){
				query = "select book.bookno,book.bookname,book.bookimg,book.author,borrow.borrowtime " +
						"from book,borrow " +
						"where borrow.weid = '" + weid +"' " +
						"and borrow.returntime is not null and borrow.bookno = book.bookno;";
			}
			System.out.println(query);
			ResultSet ret = s.executeQuery(query);
			// ��ȡ�鼮��Ϣ
			while (ret.next()) {
				BookInCurrentList book = new BookInCurrentList();
				book.setBookno(ret.getString(1));
				book.setBookname(ret.getString(2));
				book.setBookimg(ret.getString(3));
				book.setAuthor(ret.getString(4));
				if(category.equals("now")){
					// ����ʣ��ʱ��
					String borrowtime = ret.getString(5);
					String datas[];
					int month = 1,day = 1;
					if(!borrowtime.isEmpty()){
						datas = borrowtime.split("-");
						month = Integer.parseInt(datas[1]);
						day = Integer.parseInt(datas[2]);
					}
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					String nowDate = sdf.format(new Date());
					String datas1[] = nowDate.split("-");
					
					int nowDay = Integer.parseInt(datas1[2]);
					int temp = 1;
					if(nowDay >= day){
						temp = nowDay - day + 1 ;
					}else{
						switch(month){
							case 2: temp = 28-day+1+nowDay; break;
							case 4:
							case 6:
							case 9:
							case 11:temp = 28-day+1+nowDay; break;
							default: temp = 31-day+1+nowDay; break;
						}
					}
					int leftTime = 31 - temp;
					book.setLeftTime(leftTime + "");
				}
				
				list.add(book);
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	
	// �ҵ�Ԥ��
	public static ArrayList<ReserveOrder> getReserveOrder(String weid){
		ArrayList<ReserveOrder> list = new ArrayList<ReserveOrder>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query = "select book.bookno,book.bookname,book.bookimg,reserve.reservetime,reserve.status "
							+ "from book,reserve "
							+ "where book.bookno = reserve.bookno and reserve.weid = '" + weid + "';";
//			System.out.println(query);
			ResultSet ret = s.executeQuery(query);
			while (ret.next()) {  
				ReserveOrder order = new ReserveOrder();
				order.setBookno(ret.getString(1));
				order.setBookname(ret.getString(2));
				order.setBookimg(ret.getString(3));
				order.setTime(ret.getString(4));
				if(!ret.getString(5).equals("Y")){
					order.setStatus("�ȴ����");
					order.setFlag(0);
				}else{
					order.setStatus("�����");
					order.setFlag(1);
				}
				
				list.add(order);
            }
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	// ȡ��Ԥ��
	public static void cancelReserveOrder(String weid, String bookno){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://" + WeixinUtil.MYSQL_DN , WeixinUtil.MYSQL_NAME, WeixinUtil.MYSQL_PASSWORD);
			Statement s = con.createStatement();
			String query="delete from reserve " +
						"where weid = '" + weid + "' and bookno = " + bookno + ";";
//			System.out.println(query);
			s.executeUpdate(query);
            
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
}
