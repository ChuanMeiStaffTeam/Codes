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
}
