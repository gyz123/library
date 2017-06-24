package util.pinyin;

import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;


public class Chinese {

	private static HanyuPinyinOutputFormat format = null;
	private static String[] pinyin;

	public Chinese() {
		format = new HanyuPinyinOutputFormat();
		format.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
		pinyin = null;
	}

	// 转换单个中文字符
	public String getCharacterPinYin(char c) {
		try {
			pinyin = PinyinHelper.toHanyuPinyinStringArray(c, format);
		} catch (BadHanyuPinyinOutputFormatCombination e) {
			e.printStackTrace();
		}

		// 如果c不是汉字，返回null
		if (null == pinyin)
			return null;

		// 多音字取第一个值
		return pinyin[0];
	}

	// 转换一个字符串
	public String getStringPinYin(String str) {
		StringBuilder sb = new StringBuilder();

		for (int i = 0; i < str.length(); ++i) {
			String tmp = getCharacterPinYin(str.charAt(i));
			if (null == tmp) {
				// 如果str.charAt(i)不是汉字，则保持原样
				sb.append(str.charAt(i));
			} else {
				sb.append(tmp);
				// 分词
				if (i < str.length() - 1
						&& null != getCharacterPinYin(str.charAt(i + 1))) {
					sb.append("\\\'");//解决数据库单引号问题
				}
			}
		}
		return sb.toString().trim();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Chinese chinese = new Chinese();
		String str = "生命不能承受之轻";
		str = "1945年的恋人";
		String pinYin = chinese.getStringPinYin(str);
		System.out.println(pinYin);
		
	}
}
