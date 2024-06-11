package com.example.hx.service.Impl;

import com.example.hx.dao.UserMapper;
import com.example.hx.model.User;
import com.example.hx.service.IUserService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

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
}
