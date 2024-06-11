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

    User getUserByUserName(String userName);


    int insertUser(User user);
}
