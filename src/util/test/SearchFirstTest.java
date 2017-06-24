package util.test;

import java.util.ArrayList;

import po.book.BookInCategory;
import util.SearchFirstUtil;

public class SearchFirstTest {

	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		ArrayList<BookInCategory> books = new ArrayList<BookInCategory>();
		books = SearchFirstUtil.SearchFirstBooks("B");
		System.out.println(books);
	}

}
