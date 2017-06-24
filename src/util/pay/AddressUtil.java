package util.pay;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;

public class AddressUtil {
    /**
     * 获取HttpServletRequest中包含的ipv4地址,获取不到返回127.0.0.1
     *
     * @param request
     * @return
     */
    public static String getIpByRequest(HttpServletRequest request) {
        String xForwardedFor = request.getHeader( "x-forwarded-for");
        String ip = null;
        if (xForwardedFor != null) {
            ip = StringUtils. split(xForwardedFor, ",")[0];
            if ( isIpValid(ip)) {
                return ip;
            }
        }
        ip = request.getHeader("Proxy-Client-IP");
        if (isIpValid(ip )) {
            return ip;
        }
        ip = request.getHeader("WL-Proxy-Client-IP");
        if (isIpValid(ip )) {
            return ip;
        }
        ip = request.getRemoteAddr();
        if (isIpValid(ip )) {
            return ip;
        }
        return "127.0.0.1";
    }

    private static boolean isIpValid(String ip) {
        if (ip == null || ip.length() == 0 || "unkown".equalsIgnoreCase(ip ) || ip .split("\\." ).length != 4) {
            return false;
        }
        return true;
    }
}
