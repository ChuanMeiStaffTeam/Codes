package com.ChuanMeiStaffTeam.hx.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/17/17:22
 * @Description:
 */
@Slf4j
@RestController
@RequestMapping("/msg")
@Api(tags = "消息发送接收接口")
public class MsgController {


    @ApiOperation(value = "发送消息")
    @GetMapping("/send")
    public String sendMsg(@NonNull @ApiParam(value = "消息内容") @RequestParam("msg") String msg) {
       // TODO: 发送消息到指定用户

        log.info(msg);
        return msg;
    }
}
