package recom.util;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.mahout.cf.taste.common.TasteException;
import org.apache.mahout.cf.taste.impl.model.jdbc.MySQLJDBCDataModel;
import org.apache.mahout.cf.taste.impl.model.jdbc.ReloadFromJDBCDataModel;
import org.apache.mahout.cf.taste.impl.neighborhood.NearestNUserNeighborhood;
import org.apache.mahout.cf.taste.impl.recommender.GenericUserBasedRecommender;
import org.apache.mahout.cf.taste.impl.similarity.PearsonCorrelationSimilarity;
import org.apache.mahout.cf.taste.model.JDBCDataModel;
import org.apache.mahout.cf.taste.neighborhood.UserNeighborhood;
import org.apache.mahout.cf.taste.recommender.RecommendedItem;
import org.apache.mahout.cf.taste.recommender.Recommender;
import org.apache.mahout.cf.taste.similarity.UserSimilarity;
import org.apache.struts2.ServletActionContext;

import po.BookInShoppingcart;

import util.SQL4PersonalInfo;
import util.SQLUtil;

import com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class RecomUtil extends ActionSupport{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Override 
	public String execute() throws Exception {
		
		return SUCCESS;
	}
	
	public void recomOutput() throws ClassNotFoundException, TasteException, IOException{
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        
        int userid = 2;
       // if(request.getParameter("weid").isEmpty()){
        if(request.getParameter("weid") == null){
        	userid = 15;
        }else{
        	//String weid = request.getSession().getAttribute("weid").toString();
        	String weid = request.getParameter("weid");
        	userid = Integer.parseInt(SQLUtil.getUserId(weid));//string转int
        }
        int bookid = recomResult(userid, 10);
        
        PrintWriter pw = response.getWriter();
        pw.write(String.valueOf(bookid));
        pw.flush();
        pw.close();
        
	}

	/**
	 * 
	 * @param user_id 推荐的用户号
	 * @param number 基于用户的推荐数量
	 * @return 从number个结果中随机推荐一个
	 * @throws ClassNotFoundException
	 * @throws TasteException
	 */
	private int recomResult(int user_id, int number) throws ClassNotFoundException, TasteException {
        
		// (1)----连接数据库部分
		Class.forName("com.mysql.jdbc.Driver");
		MysqlConnectionPoolDataSource dataSource = new MysqlConnectionPoolDataSource(); // 需要引入数据库的maven，数据库连接池对象
		String jdbcUrl = "jdbc:mysql://localhost:3306/library?serverTimezone=UTC";
		dataSource.setServerName("127.0.0.1");
		dataSource.setUser("root");
		dataSource.setPassword("root");
		dataSource.setDatabaseName("library");
		dataSource.setUrl(jdbcUrl);
		// (2)----使用MySQLJDBCDataModel数据源读取MySQL里的数据
		// JDBCDataModel dataModel = new MySQLJDBCDataModel(dataSource,
		// "interest", "userid", "bookid", "preference",null);
		JDBCDataModel dataModel = new MySQLJDBCDataModel(dataSource,
				"taste_interest", "user_id", "book_id", "preference", null);

		// (3)----数据模型部分
		// 把MySQLJDBCDataModel对象赋值给DataModel
		// DataModel model = dataModel;

		// 利用ReloadFromJDBCDataModel包裹jdbcDataModel,可以把输入加入内存计算，加快计算速度。
		ReloadFromJDBCDataModel model = new ReloadFromJDBCDataModel(dataModel);

		// 用户相似度UserSimilarity:包含相似性度量和邻居参数
		UserSimilarity similarity = new PearsonCorrelationSimilarity(model);
		// 相邻用户UserNeighborhood
		UserNeighborhood neighborhood = new NearestNUserNeighborhood(number,
				similarity, model);
		// 一旦确定相邻用户,一个普通的user-based推荐器被构建,构建一个GenericUserBasedRecommender推荐器需要数据源DataModel,用户相似性UserSimilarity,相邻用户相似度UserNeighborhood
		Recommender recommender = new GenericUserBasedRecommender(model,
				neighborhood, similarity);
		// 向用户userid推荐5个商品//注意获得的推荐号从0开始
		List<RecommendedItem> recommendations = recommender.recommend(user_id, number);

		System.out.println("userid:" + user_id);
		System.out.println("recommendNumber:" + number);
		int bookid = 2;//数据库中为bigint
		int count = 0;
		List<Integer> books = new ArrayList<Integer>();
		for (RecommendedItem recommendation : recommendations) {
			// 输出推荐结果
			System.out.println(recommendation.getItemID());
			//bookid = (int) recommendation.getItemID();
			books.add((int) recommendation.getItemID());
			count++;
		}
		System.out.println("booksLength:" + books.size());
		int ran = (int)(Math.random() * count);
		bookid = books.get(ran-1);
		
		System.out.println("bookid:" + bookid);
		
		return  bookid;
		//return 0;
	}
}
