package com.ChuanMeiStaffTeam.hx.model.message;

import lombok.Data;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/20/22:37
 * @Description:
 */

@Data
public class Message {
    private String toName; // 接收者姓名

    private String message; // 发送的消息内容
}
