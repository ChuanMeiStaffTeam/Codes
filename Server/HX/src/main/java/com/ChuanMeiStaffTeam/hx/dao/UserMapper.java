package com.ChuanMeiStaffTeam.hx.dao;

import com.ChuanMeiStaffTeam.hx.model.User;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/11/19:08
 * @Description:
 */

@Mapper
public interface UserMapper extends BaseMapper<User> {

    User selectByUserName(String userName);

    int insertUser(User user);


    // 更新用户最后登录时间
    int updateLastLoginTime(User user);

    // 更新用户登录次数
    int updateLoginCount(User user);


    // 根据用户id查询用户信息
    User selectByUserId(Integer userId);
}
