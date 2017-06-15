package po;

public class BookWithoutImg {
	private String bookno;
	private String bookname;
	
	public BookWithoutImg(){
	}
	
	public String getBookno() {
		return bookno;
	}
	public void setBookno(String bookno) {
		this.bookno = bookno;
	}
	public String getBookname() {
		return bookname;
	}
	public void setBookname(String bookname) {
		this.bookname = bookname;
	}

	@Override
	public String toString() {
		return "BookWithoutImg [bookno=" + bookno + ", bookname=" + bookname
				+ "]";
	}
	
}

