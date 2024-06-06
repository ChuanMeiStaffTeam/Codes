package com.example.hx.controller;

import com.example.hx.common.AppResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/05/20/15:31
 * @Description:
 */
@RestController
@RequestMapping("/user")
public class UserController {


    // 登录接口
    @RequestMapping("/login")
    public AppResult login(String username, String password) {
        // TODO: 2024/05/20 登录逻辑
        return AppResult.success();
    }


    // 注册接口用户名密码注册
    @RequestMapping("/register/username")
    public AppResult register(String username, String password) {
        // TODO: 2024/05/20 注册逻辑
        return AppResult.success();
    }

    // 注册接口手机号验证码注册
    @RequestMapping("/register/phone")
    public AppResult registerByPhone(String phone, String code) {
        // TODO: 2024/06/06 手机号验证码注册逻辑
        return AppResult.success();
    }

    // 注册接口邮箱验证码注册
    @RequestMapping("/register/email")
    public AppResult registerByEmail(String email, String code) {
        // TODO: 2024/06/06 邮箱验证码注册逻辑
        return AppResult.success();
    }


    // 注销接口
    @RequestMapping("/logout")
    public AppResult logout() {
        // TODO: 2024/05/20 注销逻辑
        return AppResult.success();
    }

}
