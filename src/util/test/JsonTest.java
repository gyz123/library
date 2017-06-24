package util.test;

import java.util.HashMap;
import java.util.Set;


public class JsonTest {
	public static void main(String[] args) {
		HashMap<String,Integer> monthCnt = new HashMap<String,Integer>();
		monthCnt.put("1", 0);
		monthCnt.put("2", 0);
		monthCnt.put("3", 0);
		monthCnt.put("4", 1);
		monthCnt.put("5", 2);
		monthCnt.put("6", 3);
		monthCnt.put("7", 14);
		monthCnt.put("8", 15);
		monthCnt.put("9", 6);
		monthCnt.put("10", 17);
		monthCnt.put("11", 18);
		monthCnt.put("12", 19);
		
		
		StringBuffer sb = new StringBuffer();
		sb.append("{");
		sb.append("\"year\" : 2017,");
		sb.append("\"data\": [");
		Set<String> keySet = monthCnt.keySet();
		for(String month:keySet){
			sb.append(monthCnt.get(month) + ",");
		}
		sb.deleteCharAt(sb.toString().length()-1);
		sb.append("]");
		sb.append("}");
		
		System.out.println(sb.toString());
	}
}
