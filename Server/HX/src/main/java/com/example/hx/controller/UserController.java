package com.example.hx.controller;

import com.example.hx.common.AppResult;
import com.example.hx.common.ResultCode;
import com.example.hx.exception.ApplicationException;
import com.example.hx.model.User;
import com.example.hx.service.IUserService;
import com.example.hx.util.MD5util;
import com.example.hx.util.Uuid;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.jdbc.SQL;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import static com.example.hx.common.ResultCode.FAILED_TWO_PWD_NOT_SAME;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/05/20/15:31
 * @Description:
 */
@Slf4j
@RestController
@RequestMapping("/user")
public class UserController {


    @Resource
    private IUserService userService;


    // 登录接口
    @RequestMapping("/login")
    public AppResult login(String username, String password) {
        // TODO: 2024/05/20 登录逻辑
        return AppResult.success();
    }


    // 注册接口用户名密码注册
    @RequestMapping("/register/username")
    public AppResult register(String username, String password,String password2,
                              String nickname) {

        // 判断两次密码是否相同
        if(!password.equals(password2)) {
            log.error(ResultCode.FAILED_TWO_PWD_NOT_SAME.getMessage());
            throw new ApplicationException(FAILED_TWO_PWD_NOT_SAME.getMessage());
        }
        User user = userService.getUserByUserName(username);
        // 判断用户名是否已经注册
        if(user!= null) {
            log.error(ResultCode.FAILED_USER_EXISTS.getMessage());
            throw new ApplicationException(ResultCode.FAILED_USER_EXISTS.getMessage());
        }
        String salt = Uuid.UUID_32();  // 生成盐
        String s = MD5util.md5Salt(salt, password);  // 加密密码
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPasswordHash(s);
        newUser.setSalt(salt);
        newUser.setNickName(nickname);

        int result = userService.insertUser(newUser);
        if(result != 1) {
            log.error(ResultCode.ERROR_SERVICES.getMessage());
            throw new ApplicationException(ResultCode.ERROR_SERVICES.getMessage());
        }
        // 注册成功后，返回token
        // TODO: 2024/06/06 生成token
        // TODO: 2024/06/06 保存token到redis

        // TODO: 2024/06/06 返回token
        log.info("注册成功 username:, nickname:" + username, nickname );
        return AppResult.success();   // 注册成功 返回AppResult.success() 需要把token返回
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
