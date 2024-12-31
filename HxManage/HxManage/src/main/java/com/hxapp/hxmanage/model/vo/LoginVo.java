package com.hxapp.hxmanage.model.vo;

import lombok.Data;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/10/19/16:24
 * @Description:
 */
@Data
public class LoginVo {

    private String username;
    private String password;
    private String captcha; // 验证码
    private String phone;
}
