package po;

public class User {
	private String openID;
	private String num;
	private String name;
	private String tel;
	
	public User(){
		
	}
	
	public User(String openID, String num, String name, String tel) {
		super();
		this.openID = openID;
		this.num = num;
		this.name = name;
		this.tel = tel;
	}
	
	
	
	public String getOpenID() {
		return openID;
	}



	public void setOpenID(String openID) {
		this.openID = openID;
	}



	public String getNum() {
		return num;
	}



	public void setNum(String num) {
		this.num = num;
	}



	public String getName() {
		return name;
	}



	public void setName(String name) {
		this.name = name;
	}



	public String getTel() {
		return tel;
	}



	public void setTel(String tel) {
		this.tel = tel;
	}



	@Override
	public String toString() {
		return "User [openID=" + openID + ", name=" + num + ", password="
				+ name + ", tel=" + tel + "]";
	}
	
	
}
