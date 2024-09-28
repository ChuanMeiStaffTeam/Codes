package com.ChuanMeiStaffTeam.hx.controller;

import com.ChuanMeiStaffTeam.hx.common.AppResult;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.model.excel.ppass;
import com.ChuanMeiStaffTeam.hx.model.excel.tag;
import com.ChuanMeiStaffTeam.hx.service.IUserService;
import com.ChuanMeiStaffTeam.hx.service.SendSms;
import com.ChuanMeiStaffTeam.hx.util.RedisUtil;
import com.ChuanMeiStaffTeam.hx.util.Uuid;
import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.ExcelWriter;
import com.alibaba.excel.write.metadata.WriteSheet;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

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


    @ApiOperation("导出excel文件")
    @GetMapping("/export-excel")
    public void exportExcel(HttpServletResponse response) throws IOException{
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=data.xlsx"); // 设置头信息
        // 模拟数据
        // 写入excel文件
        List<ppass> list = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            ppass p = new ppass();
            p.setEmail("" + i + "@qq.com");
            p.setName("" + i);
            p.setPhone("1234567890");
            list.add(p);
        }

        List<tag> list1 = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            tag t = new tag();
            t.setName("name" + i);
            t.setValue("value" + i);
            list1.add(t);
        }

//        生成excel文件 工作簿对象
        try (ExcelWriter writer = EasyExcel.write(response.getOutputStream(), ppass.class).build()) {
//            对于第一个sheet，指定ppass.class
            WriteSheet writeSheet1 = EasyExcel.writerSheet("test").build();
            writer.write(list, writeSheet1);

            // 对于第二个sheet，指定tag.class
            WriteSheet writeSheet2 = EasyExcel.writerSheet("tag").head(tag.class).build();
            writer.write(list1, writeSheet2);
        }

    }
}
