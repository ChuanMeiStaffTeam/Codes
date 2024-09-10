package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.aliyun.teaopenapi.models.Config;
import com.aliyun.dysmsapi20170525.Client;
import com.aliyun.dysmsapi20170525.models.SendSmsRequest;
import com.aliyun.dysmsapi20170525.models.SendSmsResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import static com.aliyun.teautil.Common.toJSONString;

public class Sample {

    private static ObjectMapper mapper = new ObjectMapper();

    public static Client createClient() throws Exception {
        Config config = new Config()
                // 配置 AccessKey ID
                .setAccessKeyId("")
                // 配置 AccessKey Secret
                .setAccessKeySecret("");
        // 配置 Endpoint
        config.endpoint = "dysmsapi.aliyuncs.com";
        return new Client(config);
    }

    public static void main(String[] args) throws Exception {
        // 初始化请求客户端
        Client client = Sample.createClient();

        // 构造请求对象，请填入请求参数值
        Map<String, String> templateParam = new HashMap<>();
        templateParam.put("code", "123456");
        SendSmsRequest sendSmsRequest = new SendSmsRequest()
                .setPhoneNumbers("18719566054")
                .setSignName("欢喜")
                .setTemplateCode("SMS_472680156")
                .setTemplateParam(toJSONString(templateParam));

        // 获取响应对象
        SendSmsResponse sendSmsResponse = client.sendSms(sendSmsRequest);
        // 响应包含服务端响应的 body 和 headers
        System.out.println(toJSONString(sendSmsResponse));
    }
}