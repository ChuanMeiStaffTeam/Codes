package com.hxapp.hxmanage.controller;

import com.hxapp.hxmanage.common.AppResult;
import com.hxapp.hxmanage.config.AppConfig;
import com.hxapp.hxmanage.model.AdminUser;
import com.hxapp.hxmanage.model.vo.LoginVo;
import com.hxapp.hxmanage.service.IadminService;



import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/10/18/16:59
 * @Description:
 */
@Slf4j
@RestController
@RequestMapping("/api/login")
public class loginController {

    @Resource
    private RedisTemplate<String,Object> redisTemplate;

    @Resource
    private IadminService loginService;

    @RequestMapping("/login")
    public AppResult login(@RequestBody LoginVo loginVo, HttpServletRequest request) {
        // 登录逻辑
        log.info("loginVo: {}",loginVo);
        String phone = loginVo.getPhone();
        String code = (String) redisTemplate.opsForValue().get(phone + "_code");
        if(code == null) {
            return AppResult.failed("验证码已过期，请重新获取");
        }
        if(!code.equals(loginVo.getCaptcha())) {
            // 验证码错误
            return AppResult.failed("验证码错误,请重新输入");
        }
        AdminUser login = loginService.login(phone,loginVo.getUsername(), loginVo.getPassword());
        if(login == null) {
            return AppResult.failed("用户名或密码错误");
        }
        // 创建session
        HttpSession session = request.getSession(true);
        session.setAttribute(AppConfig.USER_SESSION, login);
        // 设置session过期时间 为 12小时
        session.setMaxInactiveInterval(12 * 60 * 60);
        // 存入redis缓存
        // 删除redis中的验证码
        redisTemplate.delete(phone + "_code");
        return AppResult.success("登录成功");
    }


    @GetMapping("/logout")
    public AppResult logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();  // 销毁session
        }
        return AppResult.success();
    }
}
