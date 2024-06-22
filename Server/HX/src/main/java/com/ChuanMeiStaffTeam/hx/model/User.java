package com.ChuanMeiStaffTeam.hx.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;



/**
 * 用户实体类
 */
@Data
@TableName("sys_user")
public class User implements Serializable {

    private static final long serialVersionUID = 1L; // 序列化ID



//   主键ID 使用自增主键注解
    @TableId(value = "user_id", type = IdType.AUTO)
    private Integer userId; // 用户ID，自增主键
    private String username; // 用户名，唯一且不能为空
    private String email; // 邮箱地址，唯一且不能为空
    @JsonIgnore  //不参与json序列化
    private String salt; // 密码盐值，不能为空
    @JsonIgnore  //不参与json序列化
    private String passwordHash; // 密码哈希值，不能为空
    private String bio; // 个性签名
    private String profilePictureUrl; // 头像图片URL
    private String websiteUrl; // 个人网站URL
    private String phoneNumber; // 电话号码
    private String gender; // 性别
    private Date dateOfBirth; // 出生日期
    private String address; // 地址
    private String city; // 城市
    private String state; // 省/州
    private String country; // 国家
    private Timestamp lastLoginAt; // 最后登录时间
    private String postalCode; // 邮政编码
    private Timestamp createdAt; // 账户创建时间
    private Timestamp updatedAt; // 账户更新时间
    private Integer loginAttempts; // 登录尝试次数
    private Boolean accountLocked; // 账户是否被锁定
    private Timestamp lockoutTime; // 账户锁定时间
    private String facebookUrl; // Facebook URL
    private String twitterUrl; // Twitter URL
    private String privacySettings; // 隐私设置

    // 省略Getter和Setter方法


}
