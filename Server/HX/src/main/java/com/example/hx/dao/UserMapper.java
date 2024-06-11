package com.example.hx.dao;

import com.example.hx.model.User;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/11/19:08
 * @Description:
 */
public interface UserMapper {

    User selectByUserName(String userName);

    int insertUser(User user);
}
