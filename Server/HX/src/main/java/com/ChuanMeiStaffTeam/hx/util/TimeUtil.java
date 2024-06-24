package com.ChuanMeiStaffTeam.hx.util;

import java.sql.Timestamp;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/24/21:24
 * @Description:
 */
public class TimeUtil {
    public static void main(String[] args) {
        System.out.println(getCurrentTime());
    }

    public static Timestamp getCurrentTime() {
        return new Timestamp(System.currentTimeMillis());
    }
}
