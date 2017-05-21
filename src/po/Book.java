package po;

public class Book {
	private String bookno;
	private String bookname;
	private String bookimg;
	
	public Book(){
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
	public String getBookimg() {
		return bookimg;
	}
	public void setBookimg(String bookimg) {
		this.bookimg = bookimg;
	}

	@Override  // bookno=001,bookname=Œ¢π€¿˙ ∑,bookimg=************}
	public String toString() {
		return "bookno=" + bookno + ",bookname=" + bookname
				+ ",bookimg=" + bookimg + "}";
	}
	
	
	
}
