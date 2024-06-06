package com.example.hx.model;

import lombok.Data;

import java.sql.Timestamp;
import java.util.Date;



/**
 * 用户实体类
 */
@Data
public class User {

    private Integer userId; // 用户ID，自增主键
    private String username; // 用户名，唯一且不能为空
    private String email; // 邮箱地址，唯一且不能为空
    private String passwordHash; // 密码哈希值，不能为空
    private String fullName; // 全名
    private String bio; // 简介
    private String profilePictureUrl; // 头像图片URL
    private String websiteUrl; // 个人网站URL
    private String phoneNumber; // 电话号码
    private String gender; // 性别
    private Date dateOfBirth; // 出生日期
    private String address; // 地址
    private String city; // 城市
    private String state; // 省/州
    private String country; // 国家
    private String postalCode; // 邮政编码
    private Timestamp createdAt; // 账户创建时间
    private Timestamp updatedAt; // 账户更新时间
    private Timestamp lastLogin; // 上次登录时间
    private Boolean isActive; // 账户是否激活
    private Boolean isVerified; // 账户是否验证
    private Boolean twoFactorEnabled; // 是否启用双因素认证
    private String preferredLanguage; // 首选语言，默认为英语
    private String timezone; // 时区，默认为UTC
    private Integer loginAttempts; // 登录尝试次数
    private Boolean accountLocked; // 账户是否被锁定
    private Timestamp lockoutTime; // 账户锁定时间
    private String facebookUrl; // Facebook URL
    private String twitterUrl; // Twitter URL
    private String privacySettings; // 隐私设置

    // 省略Getter和Setter方法


}
