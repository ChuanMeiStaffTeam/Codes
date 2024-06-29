package com.ChuanMeiStaffTeam.hx.controller;

import com.ChuanMeiStaffTeam.hx.common.AppResult;
import com.ChuanMeiStaffTeam.hx.config.ConfigKey;
import com.ChuanMeiStaffTeam.hx.model.SysPost;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.service.IPostsImage;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import jdk.nashorn.internal.runtime.regexp.joni.Config;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/postImage")
@Api(value = "Post Image Controller", tags = "帖子图片接口")
public class PostImageController {

    @Resource
    private IPostsImage postsImageService;

    @ApiOperation(value = "用户发帖接口")
    @PostMapping(value = "/article")
    public AppResult upload(
            @ApiParam(value = "用户帖子信息") @RequestBody SysPost post, HttpServletRequest request) {
        log.info(post.toString());
        HttpSession session = request.getSession(false);
        if (session == null) { // 未登录
            return AppResult.failed("请先登录");
        }
        User user = (User) session.getAttribute(ConfigKey.USER_SESSION_KEY);
        post.setUserId(user.getUserId());
        postsImageService.insertPost_image(post);
        return AppResult.success();
    }

    @ApiOperation(value = "用户帖子下的图片上传接口")
    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)  // 上传图片接口
    public AppResult uploadImage(@ApiParam(value = "图片文件") @RequestParam("file") MultipartFile file,
                                 HttpServletRequest request) {
        log.info(file.getOriginalFilename());
        return AppResult.success();
    }

}
