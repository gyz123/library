package po.message;

public class ReturnRemind {

	private String weid;
	private int bookno;
	private String bookname;
	private String borrowtime;
	private String returntime;
	private int counttime;
	
	public String getWeid() {
		return weid;
	}
	public void setWeid(String weid) {
		this.weid = weid;
	}
	public int getBookno() {
		return bookno;
	}
	public void setBookno(int bookno) {
		this.bookno = bookno;
	}
	public String getBookname() {
		return bookname;
	}
	public void setBookname(String bookname) {
		this.bookname = bookname;
	}
	public String getBorrowtime() {
		return borrowtime;
	}
	public void setBorrowtime(String borrowtime) {
		this.borrowtime = borrowtime;
	}
	public String getReturntime() {
		return returntime;
	}
	public void setReturntime(String returntime) {
		this.returntime = returntime;
	}
	public int getCounttime() {
		return counttime;
	}
	public void setCounttime(int counttime) {
		this.counttime = counttime;
	}
}
