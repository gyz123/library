package test;

import java.io.IOException;

import org.apache.mahout.cf.taste.common.TasteException;

import recom.util.RecomUtil;

public class RecomTest {
	public static void main(String[] args) throws ClassNotFoundException, TasteException, IOException {
		RecomUtil re = new RecomUtil();
		re.recomOutput();
	}
}
