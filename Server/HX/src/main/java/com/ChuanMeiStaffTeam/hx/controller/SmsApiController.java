package com.ChuanMeiStaffTeam.hx.controller;

import com.ChuanMeiStaffTeam.hx.common.AppResult;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.service.IUserService;
import com.ChuanMeiStaffTeam.hx.service.SendSms;
import com.ChuanMeiStaffTeam.hx.util.RedisUtil;
import com.ChuanMeiStaffTeam.hx.util.Uuid;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/09/10/13:49
 * @Description:
 */
@RestController
@RequestMapping("/api/sms")
@Slf4j
@Api(tags = "短信接口")
public class SmsApiController {

    @Resource
    private SendSms sendSms;

    @Resource
    private RedisUtil redisUtil;

    @Resource
    private IUserService userService;

    @ApiOperation(value = "发送用户登录/注册验证码")
    @PostMapping("/send")
    public AppResult sendCode(@RequestBody Map<String, String> params) throws Exception {
        String phone = params.get("phone");
        String redisCode = redisUtil.getString(phone);
        if (redisCode != null) {
            return AppResult.success("当前验证码还没有过期,请继续使用当前验证码操作");
        }
        // 生成验证码并存储到redis中
        String code = Uuid.UUID_6();
        log.info("验证码生成成功,手机号:{},验证码:{}", phone, code);
        Map<String, Object> data = new HashMap<>();
        data.put("code", code);
        boolean isSuccess = sendSms.send(phone, "SMS_472800186", data);
        if (isSuccess) {
            log.info("验证码发送成功,手机号:{},验证码:{}", phone, code);
            redisUtil.set(phone, code, 300);
            return AppResult.success("验证码发送成功,5分钟内有效");
        }
        return AppResult.failed("验证码发送失败");
    }
}
