package com.hxapp.hxmanage.model;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/10/18/16:37
 * @Description:
 */

@Data
@TableName("sys_admin")
public class AdminUser implements Serializable {

    private Long id;               // 管理员ID
    private String username;       // 管理员用户名
//  任何情况下,不参与序列化,防止泄露密码信息
    private transient String password;       // 密码
    private String avatarUrl;     // 头像地址
    private String email;          // 管理员邮箱
    private String phone;          // 管理员电话
    private Integer status;        // 状态，1表示正常，0表示禁用
    private Timestamp createTime;  // 创建时间
    private Timestamp updateTime;  // 更新时间

}
