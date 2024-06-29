package com.ChuanMeiStaffTeam.hx.util;

import com.ChuanMeiStaffTeam.hx.model.User;
import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTCreator;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * @Author: DongGuoZhen
 * @Date: 2024/06/27/21:43
 * @Description:
 */

public class JwtUtil {


    private static final String SING = "1qQW^ERGx3eWWE*^%&#@TdW%#ER%#4rDF$FG!DFGfvD@F#HJJ^DFH$G";   // 密钥 复杂 且随机

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


    public static Map<String, String> getPayload(User user) {
        HashMap<String, String> map = new HashMap<>();
        map.put("userid", String.valueOf(user.getUserId()));
        map.put("username", user.getUsername());
        map.put("fullName", user.getFullName());
        map.put("email", user.getEmail());
        map.put("phoneNumber", user.getPhoneNumber());
        map.put("postCount", String.valueOf(user.getPostCount()));
        map.put("followerCount", String.valueOf(user.getFollowerCount()));
        map.put("followingCount", String.valueOf(user.getFollowingCount()));
        map.put("favoriteCount", String.valueOf(user.getFavoriteCount()));
        map.put("bio", user.getBio());
        map.put("profilePictureUrl", user.getProfilePictureUrl());
        map.put("websiteUrl", user.getWebsiteUrl());
        return map;
    }


    // 封装JWT工具类
    // 1. 生成token    header    payload    signature
    public static String getToken(Map<String, String> map) {
        Calendar instance = Calendar.getInstance(); // 获取当前时间
        instance.add(Calendar.DATE, 7); // 设置过期时间为7天
        // 创建builder对象
        JWTCreator.Builder builder = JWT.create();
        map.forEach((k, v) -> {
            builder.withClaim(k, v);  // 设置payload信息
        });

        String token = builder.withExpiresAt(instance.getTime()) // 设置过期时间  7天
                .sign(Algorithm.HMAC256(SING));// 加密算法和密钥
        return token;
    }


    // 2. 验证token
    public static void verifyToken(String token) {
        JWT.require(Algorithm.HMAC256(SING)).build().verify(token); // 根据密钥和加密算法创建验证对象，验证token
    }

    // 3. 解析token
    public static DecodedJWT getTokenInfo(String token) {
        DecodedJWT verify = JWT.require(Algorithm.HMAC256(SING)).build().verify(token);// 根据密钥和加密算法创建验证对象，验证token
        return verify; // 返回解析后的token信息
    }
}
