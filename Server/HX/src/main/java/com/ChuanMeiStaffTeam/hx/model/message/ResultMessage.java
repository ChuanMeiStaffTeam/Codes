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
public class ResultMessage {

    private boolean isSystem;  // 是否是系统消息
    private String fromName;    // 接收 message 的用户名称
    private Object message;    // 消息内容
}
