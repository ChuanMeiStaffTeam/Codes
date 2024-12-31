package com.hxapp.hxmanage.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hxapp.hxmanage.dao.AdminMapper;

import com.hxapp.hxmanage.model.AdminUser;
import com.hxapp.hxmanage.service.IadminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/10/19/16:34
 * @Description:
 */
@Service
public class AdminServiceImpl extends ServiceImpl<AdminMapper, AdminUser> implements IadminService {

    @Autowired
    private AdminMapper adminMapper;

    @Override
    public AdminUser selectUserByPhone(String phone) {
        QueryWrapper<AdminUser> wrapper = new QueryWrapper<>();
        wrapper.eq("phone", phone);
        return adminMapper.selectOne(wrapper);
    }

    @Override
    public AdminUser selectUserById(Long id) {
        return adminMapper.selectById(id);
    }

    @Override
    public AdminUser login(String phone, String username, String password) {

        QueryWrapper<AdminUser> wrapper = new QueryWrapper<>();
        wrapper.eq("phone", phone);
        AdminUser adminUser = adminMapper.selectOne(wrapper);
        if (adminUser == null) {
            return null;
        }
        QueryWrapper<AdminUser> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username);
        queryWrapper.eq("password", password);
        return adminMapper.selectOne(queryWrapper);
    }

    @Override
    public int updateUser(AdminUser adminUser) {
        QueryWrapper<AdminUser> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("id", adminUser.getId());
        AdminUser updateUser = new AdminUser();
        updateUser.setEmail(adminUser.getEmail());
        updateUser.setPhone(adminUser.getPhone());
        return adminMapper.update(updateUser, queryWrapper); // 根据id更新用户信息 sql: update admin_user set email = ?, phone = ? where id = ?
    }

    @Override
    public int updateAvatar(AdminUser user) {
        QueryWrapper<AdminUser> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("id", user.getId());
        AdminUser updateUser = new AdminUser();
        updateUser.setAvatarUrl(user.getAvatarUrl());
        return adminMapper.update(updateUser, queryWrapper);
    }

    @Override
    public int updatePassword(AdminUser user) {
        QueryWrapper<AdminUser> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("id", user.getId());
        AdminUser updateUser = new AdminUser();
        updateUser.setEmail(user.getPassword());
        return adminMapper.update(updateUser, queryWrapper);
    }

}
