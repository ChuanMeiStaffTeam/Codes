package com.example.hx;

import com.ChuanMeiStaffTeam.hx.HxApplication;
import com.ChuanMeiStaffTeam.hx.dao.UserMapper;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.service.IUserService;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import javax.annotation.Resource;
import java.util.List;

@SpringBootTest(classes = HxApplication.class)
class HxApplicationTests {

    @Resource
    private IUserService userService;

    @Resource
    private UserMapper userMapper;

    @Test
    void contextLoads() {


    }

    @Test
    void test1() {
        List<User> users = userMapper.selectList(null);
        for (User user : users) {
                System.out.println(user);
        }
        System.out.println("========================================");
        User user = users.get(0);
        System.out.println(userService.getUserByUserId(user));
    }

    @Test
    void test2() {
        User admin = userMapper.selectByUserName("admin");
        System.out.println(admin);
    }

}
