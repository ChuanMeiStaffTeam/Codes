package com.hxapp.hxmanage.controller;

import com.aliyun.dysmsapi20170525.Client;
import com.aliyun.dysmsapi20170525.models.SendSmsRequest;
import com.aliyun.dysmsapi20170525.models.SendSmsResponse;
import com.aliyun.teaopenapi.models.Config;
import com.hxapp.hxmanage.common.AppResult;
import com.hxapp.hxmanage.model.AdminUser;
import com.hxapp.hxmanage.service.IadminService;
import com.hxapp.hxmanage.util.UUidUtil;


import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import static com.aliyun.teautil.Common.toJSONString;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/10/19/15:27
 * @Description:
 */

@Slf4j
@RestController
@RequestMapping("/api/sms")
public class SmsController {


    @Value("${aly.accessKeyId}")
    private String accessKeyId;

    @Value("${aly.accessKeySecret}")
    private String accessKeySecret;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Resource
    private IadminService adminService;

    // 发送短信验证码
    @PostMapping("/send")
    public AppResult sendSms(@RequestBody Map<String, String> params) throws Exception {
        String phone = params.get("phone");

        AdminUser adminUser = adminService.selectUserByPhone(phone);
        if (adminUser == null) {
            return AppResult.failed("该手机号未注册");
        }
        String redisCode = (String) redisTemplate.opsForValue().get(phone + "_code");
        if (redisCode != null) {
            return AppResult.failed("当前验证码还没有过期,请继续使用当前验证码操作");
        }
        // 生成验证码并存储到redis中
        String code = UUidUtil.UUID_6();
        log.info("验证码生成成功,手机号:{},验证码:{}", phone, code);
        Map<String, Object> data = new HashMap<>();
        data.put("code", code);
        boolean isSuccess = send(phone, "SMS_472800186", data);
        if (isSuccess) {
            log.info("验证码发送成功,手机号:{},验证码:{}", phone, code);
            redisTemplate.opsForValue().set(phone + "_code", code, 300, TimeUnit.SECONDS);
            return AppResult.success("验证码发送成功,5分钟内有效");
        }
        return AppResult.failed("验证码发送失败");
    }

    public boolean send(String phoneNum, String templateCode, Map<String, Object> code) throws Exception {
        // 初始化请求客户端
        Client client = createClient();
        // 构造请求对象，请填入请求参数值
        SendSmsRequest sendSmsRequest = new SendSmsRequest()
                .setPhoneNumbers(phoneNum)
                .setSignName("欢喜app")
                .setTemplateCode(templateCode)
                .setTemplateParam(toJSONString(code));
        // 获取响应对象
        SendSmsResponse sendSmsResponse = client.sendSms(sendSmsRequest);
        // 响应包含服务端响应的 body 和 headers
        log.info(toJSONString(sendSmsResponse));
        // 判断是否发送成功
        return sendSmsResponse.getBody().getCode() != null && sendSmsResponse.getBody().getCode().equals("OK");
    }


    private Client createClient() throws Exception {
        Config config = new Config()
                // 配置 AccessKey ID
                .setAccessKeyId(accessKeyId)
                // 配置 AccessKey Secret
                .setAccessKeySecret(accessKeySecret);
        // 配置 Endpoint
        config.endpoint = "dysmsapi.aliyuncs.com";
        return new Client(config);
    }

}
