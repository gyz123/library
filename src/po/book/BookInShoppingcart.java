package po.book;

public class BookInShoppingcart {
	private String bookno;
	private String bookname;
	private String bookimg;
	private String price;
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
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	@Override
	public String toString() {
		return "BookInShoppingcart [bookno=" + bookno + ", bookname="
				+ bookname + ", bookimg=" + bookimg + ", price=" + price + "]";
	}
	
}
