package util.test;



public class JsonTest {
	public static void main(String[] args) {
		String str = "{\"resultStr\":\"http://qm.qq.com/cgi-bin/qm/qr?k=9GIwDKDm9sMEf_dNiQokQKdhP5fSYY6s\",\"errMsg\":\"scanQRCode:ok\"}";
		String[] datas = str.split(",");
		String[] temp = datas[0].split("\":\"");
		StringBuffer sb = new StringBuffer(temp[1]);
		sb.deleteCharAt(sb.length()-1);
		System.out.println(sb.toString());
	}
}
