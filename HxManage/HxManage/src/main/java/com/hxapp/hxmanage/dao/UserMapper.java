package com.hxapp.hxmanage.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hxapp.hxmanage.model.User;
import org.apache.ibatis.annotations.Mapper;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/11/10/15:27
 * @Description:
 */

@Mapper
public interface UserMapper extends BaseMapper<User> {


    int updateUserPostCount(Integer userId,int postCount);
}
