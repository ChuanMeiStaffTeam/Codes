package com.ChuanMeiStaffTeam.hx.util;

import com.auth0.jwt.interfaces.DecodedJWT;

import javax.servlet.http.HttpServletRequest;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/24/20:36
 * @Description:
 */
// 获取当前用户名工具类
public class AuthUtil {

    // 获取当前用户名
    public static String getCurrentUserName(HttpServletRequest request) {
        String token = request.getHeader("token");
        if (token == null) {
            return null;
        }
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
        return tokenInfo.getClaim("username").asString();
    }
}
