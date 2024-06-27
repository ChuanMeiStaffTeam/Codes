package com.ChuanMeiStaffTeam.hx.util;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;

import java.util.Calendar;
import java.util.HashMap;

/**
 * Created with IntelliJ IDEA.
 * @Author: DongGuoZhen
 * @Date: 2024/06/27/21:43
 * @Description:
 */

public class JwtUtil {


    public static String generateToken() {
        Calendar instance = Calendar.getInstance(); // 获取当前时间
        instance.add(Calendar.SECOND, 30); // 设置过期时间为30秒

        HashMap<String, Object> map = new HashMap<>();
        String sign = JWT.create()
               .withHeader(map)  // 设置头部信息 可以不写
                .withClaim("userid",1)
                .withClaim("username","admin")
                .withExpiresAt(instance.getTime()) // 设置过期时间  30秒
                .sign(Algorithm.HMAC256("WERWG!$#%SDFMN"));  // 加密算法和密钥
        return sign;
    }

    public static void main(String[] args) {
        String token = generateToken();  // 生成token
        System.out.println(token);  // 输出token


        // 验证token  创建验证对象
        JWTVerifier jwtVerifier = JWT.require(Algorithm.HMAC256("WERWG!$#%SDFMN")).build(); // 根据密钥和加密算法创建验证对象
        // 验证token
        DecodedJWT verify = jwtVerifier.verify(token);// 验证通过
        System.out.println(verify.getClaim("userid").asInt());  // 获取token中的userid
        System.out.println(verify.getClaim("username").asString());  // 获取token中的username
        System.out.println(verify.getExpiresAt());   // 获取token的过期时间
    }

}
