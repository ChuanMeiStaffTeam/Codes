//package com.hxapp.hxmanage.util;
//import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
//
//
///**
// * Created with IntelliJ IDEA.
// *
// * @Author: DongGuoZhen
// * @Date: 2024/12/05/14:08
// * @Description:
// */
//public class BCryptUtils {
//    /**
//     * ⽣成加密后密⽂
//     *
//     * @param password 密码
//     * @return 加密字符串
//     */
//    public static String encryptPassword(String password) {
//        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
//        return passwordEncoder.encode(password);
//    }
//    /**
//     * 判断密码是否相同
//     *
//     * @param rawPassword 真实密码
//     * @param encodedPassword 加密后密⽂
//     * @return 结果
//     */
//
//    // 判断密码是否相同
//    public static boolean matchesPassword(String rawPassword, String encodedPassword) {
//        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
//        return passwordEncoder.matches(rawPassword, encodedPassword);
//    }
//
//    public static void main(String[] args) {
//        String password = "123456";
//        String encodedPassword = BCryptUtils.encryptPassword(password);
//        System.out.println(encodedPassword);
////        boolean matches = BCryptUtils.matchesPassword("123456", encodedPassword);
////        System.out.println(matches);
//    }
//}
