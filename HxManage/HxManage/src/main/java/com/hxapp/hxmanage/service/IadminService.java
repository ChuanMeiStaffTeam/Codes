package com.hxapp.hxmanage.service;

import com.baomidou.mybatisplus.extension.service.IService;

import com.hxapp.hxmanage.model.AdminUser;
import org.springframework.stereotype.Service;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/10/19/16:33
 * @Description:
 */
@Service
public interface IadminService extends IService<AdminUser> {

    // 根据手机号查询用户信息
    AdminUser selectUserByPhone(String phone);

    // 根据id查询用户信息
    AdminUser selectUserById(Long id);

    AdminUser login(String phone,String username, String password);

    // 更新用户信息
    int updateUser(AdminUser user);

    // 更新头像
    int updateAvatar(AdminUser user);

    // 更新密码
    int updatePassword(AdminUser user);
}
