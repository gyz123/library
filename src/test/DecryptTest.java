package test;

import util.EncryptUtil;

public class DecryptTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String content = "test";  
		String password = "12345678";  
		//加密  
		System.out.println("加密前：" + content);  
		byte[] encryptResult = EncryptUtil.encrypt(content);  
		String encryptResultStr = EncryptUtil.parseByte2HexStr(encryptResult);  
		System.out.println("加密后：" + encryptResultStr);
		
		
		//解密  
		byte[] decryptFrom = EncryptUtil.parseHexStr2Byte(encryptResultStr);  
		byte[] decryptResult = EncryptUtil.decrypt(decryptFrom);  
		System.out.println("解密后：" + new String(decryptResult));
		
		if(new String(decryptResult).equals(content)){
			System.out.println("解密成功");
		}
	}

}
