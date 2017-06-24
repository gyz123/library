package util.test;

import java.io.IOException;

import org.apache.mahout.cf.taste.common.TasteException;

import util.recommend.RecomUtil;

public class RecomTest {
	public static void main(String[] args) throws ClassNotFoundException, TasteException, IOException {
		RecomUtil re = new RecomUtil();
		re.recomOutput();
	}
}
