package com.hxapp.hxmanage.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.hxapp.hxmanage.model.User;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/11/10/15:25
 * @Description:
 */

@Service
public interface IUserService extends IService<User> {

    List<User> getAllUser(Page<User> page);


    List<User> getUserByAccount(String account, Page<User> page);


    Long getUserCount();


    int updateUser(User user);
}
