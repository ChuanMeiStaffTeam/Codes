package com.example.hx.dao;

import com.example.hx.model.User;
import org.apache.ibatis.annotations.Mapper;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/11/19:08
 * @Description:
 */

@Mapper
public interface UserMapper {

    User selectByUserName(String userName);

    int insertUser(User user);


    // 更新用户最后登录时间
    int updateLastLoginTime(User user);

    // 更新用户登录次数
    int updateLoginCount(User user);
}
