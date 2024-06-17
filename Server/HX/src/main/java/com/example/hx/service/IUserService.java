package com.example.hx.service;

import com.example.hx.model.User;
import org.springframework.stereotype.Service;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/05/20/15:31
 * @Description:
 */
@Service
public interface IUserService {


    // 根据用户名获取用户信息
    User getUserByUserName(String userName);


    // 插入用户信息
    int insertUser(User user);

    // 更新用户最后登录时间
    int updateUserLastLoginTime(User user);

    // 更新用户登录失败次数
    int updateUserLoginCount(User user);

    // 更新用户登录次数为0
    int updateUserLoginCountToZero(User user);

}
