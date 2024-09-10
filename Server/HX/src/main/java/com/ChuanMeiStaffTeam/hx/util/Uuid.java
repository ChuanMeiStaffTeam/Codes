package com.ChuanMeiStaffTeam.hx.util;

import java.util.UUID;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/11/20:08
 * @Description:
 */
public class Uuid {


    public static String UUID_32() {
        return UUID.randomUUID().toString().replace("-", "");
    }

    public static String UUID_6() {
        // 6位随机数 纯数字类型
        String uuid = UUID.randomUUID().toString().replaceAll("[^0-9]", "");
        // 保证生成的字符串有至少6位
        while (uuid.length() < 6) {
            uuid += UUID.randomUUID().toString().replaceAll("[^0-9]", "");
        }
        // 截取前6位数字
        return uuid.substring(0, 6);
    }
}
