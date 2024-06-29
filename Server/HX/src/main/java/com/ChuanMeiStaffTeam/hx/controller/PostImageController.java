package com.ChuanMeiStaffTeam.hx.controller;

import com.ChuanMeiStaffTeam.hx.common.AppResult;
import com.ChuanMeiStaffTeam.hx.service.IPostsImage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/29/9:52
 * @Description:
 */
@Slf4j
@RestController
@RequestMapping("api/postImage")
public class PostImageController {


    @Autowired
    private IPostsImage postsImageService;

    // 用户发布帖子,并上传图片,图片有可能是单张或多张

}
