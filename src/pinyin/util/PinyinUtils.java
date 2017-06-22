package pinyin.util;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class PinyinUtils {

	//分词正则表达式  
    public static String regEx  = "[^aoeiuv]?h?[iuv]?(ai|ei|ao|ou|er|ang?|eng?|ong|a|o|e|i|u|ng|n)?";  
  
    public static String split(String input) {  
        int tag = 0;  
        StringBuffer sb = new StringBuffer();  
        String formatted = "";  
        List<String> tokenResult = new ArrayList<String>();  
        for (int i = input.length(); i > 0; i = i - tag) {  
            Pattern pat = Pattern.compile(regEx);  
            Matcher matcher = pat.matcher(input);  
            boolean rs = matcher.find();  
            sb.append(matcher.group());  
            sb.append("\\\'"); 
            tag = matcher.end() - matcher.start();  
            tokenResult.add(input.substring(0, 1));  
            input = input.substring(tag);  
        }  
        if (sb.length() > 0) {  
            formatted = sb.toString().substring(0, sb.toString().length() -2);  
        }  
        return formatted;  
    }  
  
  
    public static void main(String[] args) {  
        String str = "xiaowangzi";  
        System.out.println(PinyinUtils.split(str));  
    }  
}
