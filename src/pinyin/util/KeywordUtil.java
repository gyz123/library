package pinyin.util;

public class KeywordUtil {

	public static String keywordToPinyin(String keyword) {
		if (ChineseUtil.isChinese(keyword)) {
			// 中文转拼音分词
			Chinese chinese = new Chinese();
			
			keyword = chinese.getStringPinYin(keyword);
		} else {
			// 拼音分词
			keyword = PinyinUtils.split(keyword);
		}
		return keyword;
	}

	public static void main(String[] args) {
		System.out.println(keywordToPinyin("xiaogouqianqian"));
	}
}
