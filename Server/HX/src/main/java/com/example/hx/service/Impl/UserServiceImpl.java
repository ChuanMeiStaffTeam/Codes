package com.example.hx.service.Impl;

import com.example.hx.dao.UserMapper;
import com.example.hx.model.User;
import com.example.hx.service.IUserService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.sql.Timestamp;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/05/20/15:32
 * @Description:
 */
@Service
public class UserServiceImpl implements IUserService {

    @Resource
    private UserMapper userMapper;

    @Override
    public User getUserByUserName(String userName) {
        return userMapper.selectByUserName(userName);
    }

    @Override
    public int insertUser(User user) {
        return userMapper.insertUser(user);
    }

    @Override
    public int updateUserLastLoginTime(User user) {
        // 更新用户最后登录时间 Timestamp 类型
        // Timestamp
        user.setLastLoginAt(new Timestamp(System.currentTimeMillis()));
        return userMapper.updateLastLoginTime(user);
    }

    @Override
    public int updateUserLoginCount(User user) {
        Integer UserLoginCount = user.getLoginAttempts() + 1;
        if(UserLoginCount >= 6) {
            UserLoginCount = 1;
        }
        user.setLoginAttempts(UserLoginCount);
        return userMapper.updateLoginCount(user);
    }

    @Override
    public int updateUserLoginCountToZero(User user) {
        user.setLoginAttempts(0);
        return userMapper.updateLoginCount(user);

    }

    @Override
    public User getUserByUserId(User user) {
        Integer userId = user.getUserId();
        return userMapper.selectByUserId(userId);
    }
}
