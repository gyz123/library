package po.user;

public class UserDetailInfo {
	private String openid;  // 微信号
	private String nickname;  // 昵称
	private String headimgurl;  // 微信头像url
	private String realName;  // 用户真实姓名
	private String idCard;  // 身份证号码
	private String tel;  // 电话号码
	private String unionid;  // 微信联合ID（可选）
	
	public UserDetailInfo(){
	}

	public String getOpenid() {
		return openid;
	}

	public void setOpenid(String openid) {
		this.openid = openid;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getHeadimgurl() {
		return headimgurl;
	}

	public void setHeadimgurl(String headimgurl) {
		this.headimgurl = headimgurl;
	}

	public String getRealName() {
		return realName;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

	public String getIdCard() {
		return idCard;
	}

	public void setIdCard(String idCard) {
		this.idCard = idCard;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public String getUnionid() {
		return unionid;
	}

	public void setUnionid(String unionid) {
		this.unionid = unionid;
	}

	@Override  // 格式：openid=1,nickname=gyz,headimgurl=***,realName=GYZ,idCard=123456,tel=110}
	public String toString() {
		return "openid=" + openid + ",nickname=" + nickname
				+ ",headimgurl=" + headimgurl + ",realName=" + realName
				+ ",idCard=" + idCard + ",tel=" + tel + "}";
	}
	
}
