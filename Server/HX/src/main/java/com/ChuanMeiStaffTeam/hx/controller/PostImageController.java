package com.ChuanMeiStaffTeam.hx.controller;

import com.ChuanMeiStaffTeam.hx.common.AppResult;
import com.ChuanMeiStaffTeam.hx.config.ConfigKey;
import com.ChuanMeiStaffTeam.hx.model.SysImage;
import com.ChuanMeiStaffTeam.hx.model.SysPost;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.model.vo.SysPostImage;
import com.ChuanMeiStaffTeam.hx.service.IPostsImage;
import com.ChuanMeiStaffTeam.hx.service.IUserService;
import com.ChuanMeiStaffTeam.hx.util.JwtUtil;
import com.ChuanMeiStaffTeam.hx.util.RedisUtil;
import com.ChuanMeiStaffTeam.hx.util.UploadUtil;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import jdk.nashorn.internal.runtime.regexp.joni.Config;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.FutureTask;

@Slf4j
@RestController
@RequestMapping("/api/postImage")
@Api(value = "Post Image Controller", tags = "帖子图片接口")
public class PostImageController {

    @Autowired
    private RedisUtil redisUtil;

    @Resource
    private IUserService userService;

    @Resource
    private IPostsImage postsImageService;

    @Resource
    private ThreadPoolTaskExecutor taskExecutor;


    @ApiOperation(value = "用户发帖接口")
    @PostMapping(value = "/article", consumes = "multipart/form-data")
    public AppResult upload(
            @ApiParam("用户帖子信息") @RequestParam("post") String postJson,
            @RequestParam("images") List<MultipartFile> images,
            HttpServletRequest request) {
        // 将 JSON 字符串转换为 SysPost 对象
        SysPost post = null;
        try {
            post = new ObjectMapper().readValue(postJson, SysPost.class);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }

        if(images.isEmpty()) {  // 图片为空
            return AppResult.failed("请上传图片");
        }
        // 获取当前登录用户id和username 从token中获取
        String token = request.getHeader("token");
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
        String username = tokenInfo.getClaim("username").asString();
        // 从 redis 中获取当前登录用户
        User user = (User) redisUtil.get(username);
        post.setUserId(user.getUserId());
//        log.error(user.toString());
//        log.error(post.toString());
        // 插入帖子信息,用户帖子数量加1,保存图片
        boolean b = postsImageService.insertPost(post, user, images);
        // 后续添加redis缓存 todo
        if(!b) {
            return AppResult.failed("发帖失败");
        }
        return AppResult.success();
    }


    // 用户查询帖子详情接口
    @GetMapping(value = "/queryPost")
    @ApiOperation(value = "用户查询帖子接口")
    public AppResult queryPost(@ApiParam("帖子id") @RequestParam("postId") Integer postId) {
        if(postId == null) {
            return AppResult.failed("帖子id不能为空");
        }
        // 查询帖子信息
        SysPostImage sysPostImage = postsImageService.selectPostById(postId);
        if(sysPostImage == null) {
            return AppResult.failed("帖子不存在");
        }
        // 查询图片信息
        List<SysImage> sysImages = postsImageService.selectPostImagesByPostId(postId);
        if(sysImages == null || sysImages.isEmpty()) {
            return AppResult.failed("帖子图片不存在");
        }
        sysPostImage.setImages(sysImages);
        return AppResult.success(sysPostImage);
    }

    // 获取主页帖子信息接口
    @GetMapping(value = "/queryHomePosts")
    @ApiOperation(value = "获取主页帖子接口")
    public AppResult queryHomePosts() {
        // 查询帖子信息
        // 查询所有的帖子信息,并将帖子信息中的图片信息查询出来,设置到SysPostImage对象中
        List<SysPostImage> sysPostImages = postsImageService.selectAllPosts();
        if (sysPostImages == null || sysPostImages.isEmpty()) {
            return AppResult.failed("帖子为空");
        }
        // 后续添加分页功能 redis缓存 todo
        return AppResult.success(sysPostImages);
    }


    // 用户删除帖子接口
    @DeleteMapping(value = "/deletePost")
    @ApiOperation(value = "用户删除帖子接口")
    public AppResult deletePost(@ApiParam("帖子id") @RequestParam("postId") Integer postId,HttpServletRequest request) {
        if (postId == null) {
            return AppResult.failed("帖子id不能为空");
        }
        // 判断当前登录用户是否为帖子作者
        String token = request.getHeader("token");
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
        String username = tokenInfo.getClaim("username").asString();
        // 从 redis 中获取当前登录用户
        System.out.println(username);
        User user = (User) redisUtil.get(username);
        System.out.println(user.toString());
        // 查询帖子信息
        SysPostImage sysPostImage = postsImageService.selectPostById(postId);
        int userId = user.getUserId();
        System.out.println(user.toString());
        if (sysPostImage.getUserId() != userId) {
            return AppResult.failed("你没有权限删除该帖子");
        }
        // 删除帖子信息,根据帖子id删除图片信息,用户帖子数量减1
        boolean b = postsImageService.deletePost(postId,user);
        if(!b) {
            return AppResult.failed("删除帖子失败");
        }
        return AppResult.success();
    }

}
