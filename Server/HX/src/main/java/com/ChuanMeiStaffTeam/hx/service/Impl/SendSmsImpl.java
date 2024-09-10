package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.service.SendSms;
import com.aliyun.dysmsapi20170525.Client;
import com.aliyun.dysmsapi20170525.models.SendSmsRequest;
import com.aliyun.dysmsapi20170525.models.SendSmsResponse;
import com.aliyun.teaopenapi.models.Config;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.aliyun.teaopenapi.models.Config;
import com.aliyun.dysmsapi20170525.Client;
import com.aliyun.dysmsapi20170525.models.SendSmsRequest;
import com.aliyun.dysmsapi20170525.models.SendSmsResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

import static com.aliyun.teautil.Common.toJSONString;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/09/10/13:40
 * @Description:
 */
@Service
@Slf4j
public class SendSmsImpl implements SendSms {


    @Value("${aly.accessKeyId}")
    private String accessKeyId;

    @Value("${aly.accessKeySecret}")
    private String accessKeySecret;

    @Override
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
