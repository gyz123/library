package tag;

import java.io.IOException;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;

public class ForeachTag extends SimpleTagSupport{
	
	private Object items;
	private String var;
	private Collection collection;

	//统一转为单列集合
	public void setItems(Object items) {
		this.items = items;
		//判断items的类型
		if(items instanceof Collection){  //list set
			collection = (Collection) items;
		}
		
		if(items instanceof Map){
			Map map = (Map) items;
			collection = map.entrySet();  // set
		}
		/*
		if(items instanceof Object[]){
			Object obj[] = (Object[]) items;
			collection = Arrays.asList(obj);
		}
		
		if(items instanceof int[]){
			int arr[] = (int[])items;
			this.collection = new ArrayList();
			for(int i:arr){
				this.collection.add(i);
			}
		}
		*/
		
		// 判断是否为数组
		if(items.getClass().isArray()){
			this.collection = new ArrayList();
			// 反射(此Array可操作任意类型的数组) ***********************************************
			int length = Array.getLength(items);  
			for(int i=0;i<length;i++){
				Object value = Array.get(items, i);  // 获取数组items中第i个位置的元素
				this.collection.add(value);  
			}
			//******************************************************************************
		}
		
		
	}
	
	public void setVar(String var) {
		this.var = var;
	}
	
	@Override
	public void doTag() throws JspException, IOException {

		Iterator it = this.collection.iterator();
		while(it.hasNext()){
			Object value = it.next();
			
			// 将数据存入域中后，在jsp输出
			this.getJspContext().setAttribute(var, value);
			this.getJspBody().invoke(null);
		}
		
	}
	
	
}
