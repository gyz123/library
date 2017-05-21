package po;

public class BookDetailInfo {
	private String bookno;
	private String isbn;
	private String bookname;
	private String category;
	private String publisher;
	private String version;
	private String bookimg;
	private String outline;
	private String bookAbstract;
	private String guide;
	private String leftnum;
	private String price;
	private String tag1;
	private String tag2;
	private String tag3;
	
	public BookDetailInfo() {
	}
	
	public String getBookno() {
		return bookno;
	}
	public void setBookno(String bookno) {
		this.bookno = bookno;
	}
	public String getIsbn() {
		return isbn;
	}
	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}
	public String getBookname() {
		return bookname;
	}
	public void setBookname(String bookname) {
		this.bookname = bookname;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getPublisher() {
		return publisher;
	}
	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getBookimg() {
		return bookimg;
	}
	public void setBookimg(String bookimg) {
		this.bookimg = bookimg;
	}
	public String getOutline() {
		return outline;
	}
	public void setOutline(String outline) {
		this.outline = outline;
	}
	public String getBookAbstract() {
		return bookAbstract;
	}
	public void setBookAbstract(String bookAbstract) {
		this.bookAbstract = bookAbstract;
	}
	public String getGuide() {
		return guide;
	}
	public void setGuide(String guide) {
		this.guide = guide;
	}
	public String getLeftnum() {
		return leftnum;
	}
	public void setLeftnum(String leftnum) {
		this.leftnum = leftnum;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}

	public String getTag1() {
		return tag1;
	}

	public void setTag1(String tag1) {
		this.tag1 = tag1;
	}

	public String getTag2() {
		return tag2;
	}

	public void setTag2(String tag2) {
		this.tag2 = tag2;
	}

	public String getTag3() {
		return tag3;
	}

	public void setTag3(String tag3) {
		this.tag3 = tag3;
	}

	@Override
	public String toString() { // Î´Êä³ötag
		return "bookno=" + bookno + ",isbn=" + isbn
				+ ",bookname=" + bookname + ",category=" + category
				+ ",publisher=" + publisher + ",version=" + version
				+ ",bookimg=" + bookimg + ",outline=" + outline
				+ ",bookAbstract=" + bookAbstract + ",guide=" + guide
				+ ",leftnum=" + leftnum + ",price=" + price + "}";
	}

	
	
	
	
}
