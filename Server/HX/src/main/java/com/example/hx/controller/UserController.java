package com.example.hx.controller;

import com.example.hx.common.AppResult;
import com.example.hx.common.ResultCode;
import com.example.hx.exception.ApplicationException;
import com.example.hx.model.User;
import com.example.hx.service.IUserService;
import com.example.hx.util.MD5util;
import com.example.hx.util.Uuid;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
@Api(tags = "用户注册登录接口")
public class UserController {


    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Resource
    private IUserService userService;


    // 登录接口
    @ApiOperation(value = "用户名密码登录接口")
    @PostMapping("/login/username")
    public AppResult login(@NonNull @ApiParam(value = "用户名") @RequestParam("username") String username,
                           @NonNull @ApiParam(value = "密码") @RequestParam("password") String password,
                           HttpServletRequest request) {
        User user = userService.getUserByUserName(username);
        if (user == null) {
            log.error(ResultCode.FAILED_USER_NOT_EXISTS.getMessage());
            throw new ApplicationException(ResultCode.FAILED_USER_NOT_EXISTS.getMessage());
        }
        String salt = user.getSalt();  // 获取盐
        String s = MD5util.md5Salt(password, salt);  // 验证密码
        if (!s.equals(user.getPasswordHash())) {
            log.error(ResultCode.FAILED_LOGIN.getMessage());
            throw new ApplicationException(ResultCode.FAILED_LOGIN.getMessage());
        }
        // 登录成功，创建session
        HttpSession session = request.getSession(true);
        session.setAttribute(username, user);
        log.info("登录成功 username: " + username);
        redisTemplate.opsForValue().set(username, user);  // 设置redis缓存
        return AppResult.success();
    }


    // 注册接口用户名密码注册
    @ApiOperation(value = "用户名密码注册接口")
    @PostMapping("/register/username")
    public AppResult register(@NonNull @ApiParam(value = "昵称") @RequestParam("nickname")  String nickname,
                              @NonNull @ApiParam(value = "用户名") @RequestParam("username") String username,
                              @NonNull @ApiParam(value = "密码") @RequestParam("password") String password,
                              @NonNull @ApiParam(value = "确认密码") @RequestParam("password2") String password2) {
        // 判断两次密码是否相同
        if (!password.equals(password2)) {
            log.error(ResultCode.FAILED_TWO_PWD_NOT_SAME.getMessage());
            throw new ApplicationException(ResultCode.FAILED_TWO_PWD_NOT_SAME.getMessage());
        }
        User user = userService.getUserByUserName(username);
        // 判断用户名是否已经注册
        if (user != null) {
            log.error(ResultCode.FAILED_USER_EXISTS.getMessage());
            throw new ApplicationException(ResultCode.FAILED_USER_EXISTS.getMessage());
        }
        String salt = Uuid.UUID_32();  // 生成盐
        String s = MD5util.md5Salt(password, salt);  // 加密密码
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPasswordHash(s);
        newUser.setSalt(salt);
        newUser.setNickName(nickname);
        int result = userService.insertUser(newUser);
        if (result != 1) {
            log.error(ResultCode.ERROR_SERVICES.getMessage());
            throw new ApplicationException(ResultCode.ERROR_SERVICES.getMessage());
        }
        log.info("注册成功 username: " + username + ",nickname: " + nickname);
        return AppResult.success();   //注册成功
    }

    // 注册接口手机号验证码注册
    @PostMapping("/register/phone")
    public AppResult registerByPhone(String phone, String code) {
        // TODO: 2024/06/06 手机号验证码注册逻辑
        return AppResult.success();
    }

    // 注册接口邮箱验证码注册
    @PostMapping("/register/email")
    public AppResult registerByEmail(String email, String code) {
        // TODO: 2024/06/06 邮箱验证码注册逻辑
        return AppResult.success();
    }


    // 注销接口
    @PostMapping("/logout")
    public AppResult logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();  // 销毁session
        }
        log.info("注销成功");
        return AppResult.success();
    }

}
