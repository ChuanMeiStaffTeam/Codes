package com.hxapp.hxmanage.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hxapp.hxmanage.dao.UserMapper;
import com.hxapp.hxmanage.model.User;
import com.hxapp.hxmanage.service.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/11/10/15:26
 * @Description:
 */

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public List<User> getAllUser(Page<User> page) {
        // 分页查询所有用户
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("last_login_at");// 按最后登录时间倒序排序
        Page<User> userPage = userMapper.selectPage(page, queryWrapper);
        return userPage.getRecords(); // 返回用户列表 当前页数据
    }

    @Override
    public List<User> getUserByAccount(String account, Page<User> page) {
        // 根据账号查询用户

        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", account);
        Page<User> userPage = userMapper.selectPage(page, queryWrapper);
        return userPage.getRecords();
    }

    @Override
    public Long getUserCount() {
        // 查询用户总数 sql: select count(*) from user
        return userMapper.selectCount(null);
    }

    @Override
    public int updateUser(User user) {
        // 更新用户信息
        return userMapper.updateById(user);
    }
}
