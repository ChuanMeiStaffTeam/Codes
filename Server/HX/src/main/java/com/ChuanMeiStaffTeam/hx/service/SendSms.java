package com.ChuanMeiStaffTeam.hx.service;

import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/09/10/13:39
 * @Description:
 */
@Service
public interface SendSms {
    boolean send(String phoneNum, String templateCode, Map<String,Object> code) throws Exception;
}
