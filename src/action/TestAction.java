package action;

import com.opensymphony.xwork2.ActionSupport;

public class TestAction extends ActionSupport{
	private static final long serialVersionUID=1L;
	
	private String hello;
	
	public String getHello() {
		return hello;
	}

	public void setHello(String hello) {
		this.hello = hello;
	}

	public String execute() throws Exception{
		hello="hello,world";
		return SUCCESS;
	}
}
