package util.weixin;

public class MapUtil {

	public static String MarkLocation(){
		//http://apis.map.qq.com/tools/poimarker?type=0&marker=coord:31.77597,119.9635133;title:常州图书馆;addr:中国江苏省常州市天宁区关河东路商圈和平北路35号 &key=7C5BZ-YF6RW-3B4RX-RG2XH-4HWLH-N6FBS&referer=library
		String url = "http://apis.map.qq.com/tools/poimarker?type=0&marker=coord:31.77597,119.9635133;title:超新星智能图书馆;addr:中国江苏省常州市天宁区关河东路商圈和平北路35号&key=7C5BZ-YF6RW-3B4RX-RG2XH-4HWLH-N6FBS&referer=library";
		return url;
	}
}
