package po;

public class BookInCategory {
	private String bookno;
	private String bookname;
	private String bookimg;
	private String publisher;
	private String author;
	private String leftNum;
	
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
	public String getAuthor() {
		return author;
	}
	public void setAuthor(String author) {
		this.author = author;
	}
	public String getLeftNum() {
		return leftNum;
	}
	public void setLeftNum(String leftNum) {
		this.leftNum = leftNum;
	}
	public String getPublisher() {
		return publisher;
	}
	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}
	
	@Override
	public String toString() {
		return "bookno=" + bookno + ",bookname=" + bookname
				+ ",bookimg=" + bookimg + ",publisher=" + publisher + ",author=" + author + ",leftNum="
				+ leftNum + "}";
	}
	
}
