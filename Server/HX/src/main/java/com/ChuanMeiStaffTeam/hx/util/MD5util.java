package com.ChuanMeiStaffTeam.hx.util;


import org.apache.commons.codec.digest.DigestUtils;

/**
 * 用于MD5加密的工具类
 */
public class MD5util {
    /**
     * 对字符串进行md5加密
     * @param str  明文
     * @return 密文
     */
    public static String md5(String str) {
        return DigestUtils.md5Hex(str);
    }


    /**
     *对用户密码进行加密
     * @param str 密码明文
     * @param salt 扰动字符
     * @return 加密后的密文
     */
    public static String md5Salt (String str,String salt) {
        return md5(md5(str)+salt);

    }
}
