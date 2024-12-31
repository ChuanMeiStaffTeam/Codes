package com.hxapp.hxmanage.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;


import com.hxapp.hxmanage.model.AdminUser;
import org.apache.ibatis.annotations.Mapper;

/**
 * Created with IntelliJ IDEA.
 * @Author: DongGuoZhen
 * @Date: 2024/10/19/16:32
 * @Description:
 */
@Mapper
public interface AdminMapper extends BaseMapper<AdminUser> {
}
