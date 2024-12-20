package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.service.IPostsImage;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/12/20/09:45
 * @Description:
 */
@SpringBootTest
class PostServiceImplTest {

    @Autowired
    private IPostsImage postService;

    @Test
    void test() {
        System.out.println(postService.getPostTagList());
    }

}