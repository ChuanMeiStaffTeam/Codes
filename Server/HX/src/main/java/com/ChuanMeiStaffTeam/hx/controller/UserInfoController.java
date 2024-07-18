package com.ChuanMeiStaffTeam.hx.controller;

import com.ChuanMeiStaffTeam.hx.common.AppResult;
import com.ChuanMeiStaffTeam.hx.exception.ApplicationException;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.service.IUserService;
import com.ChuanMeiStaffTeam.hx.util.*;
import com.auth0.jwt.interfaces.DecodedJWT;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.models.auth.In;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/23/11:00
 * @Description:
 */

@Slf4j
@RestController
@RequestMapping("/api/userinfo")
@Api(tags = "用户个人信息")
public class UserInfoController {


    @Value("${spring.servlet.multipart.location}")
    String path;
    @Autowired
    private RedisUtil redisUtil;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Resource
    private IUserService userService;

    // 更新用户头像
    @ApiOperation(value = "更新用户头像")
    @PostMapping("/updateAvatar")
    public AppResult updateAvatar(MultipartFile file, HttpServletRequest request) {
        if (file.isEmpty()) {
            log.error("图片不能为空");
            throw new ApplicationException("图片不能为空");
        }
        String s = UploadUtil.uploadFile(file);
        String token = request.getHeader("token");
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
        String username = tokenInfo.getClaim("username").asString();
        // 从 redis 中获取当前登录用户
        User user = (User) redisUtil.get(username);
        if (user == null || user.getUserId() == null) {
            return AppResult.failed("登录信息已过期,请重新登录");
        }
        userService.updateUserAvatar(user, s);
        log.info("用户头像更新成功, 图片路径为{}" + s);
        return AppResult.success(s);
    }

    // 更新用户信息
    @ApiOperation(value = "更新用户基本信息")
    @PostMapping("/updateInfo")
//    public AppResult updateInfo(@NonNull @ApiParam(value = "用户ID", example = "1") @RequestParam("userId") Integer userId,
//                                @NonNull @ApiParam(value = "用户姓名") @RequestParam("fullName") String fullName,
//                                @NonNull @ApiParam(value = "用户网站") @RequestParam("websiteUrl") String websiteUrl,
//                                @NonNull @ApiParam(value = "用户简介") @RequestParam("bio")String bio) {
    public AppResult updateInfo(@RequestBody User user,HttpServletRequest request) {
        String token = request.getHeader("token");
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
       // 从token中获取用户名
        String username = tokenInfo.getClaim("username").asString();
        // 从 redis 中获取当前登录用户
        User loginUser = (User) redisUtil.get(username);
        if( loginUser == null || loginUser.getUserId() == null) {
            log.error("登录信息已过期,请重新登录");
            throw new ApplicationException("用户不存在");
        }
        User updateUser = userService.getById(loginUser.getUserId());
        if(updateUser == null) {
            log.error("用户不存在");
            throw new ApplicationException("用户不存在");
        }
        user.setUserId(loginUser.getUserId());
        user.setUpdatedAt(new Timestamp(System.currentTimeMillis())); // 更新用户的更新时间
        int i = userService.updateUserBaseInfo(user);
        if(i == 0) {
            log.error("更新用户信息失败");
            throw new ApplicationException("更新用户信息失败");
        }
        log.info("用户信息更新成功");
        User resultUser = userService.getUserByUserId(user);
        // 更新 redis 中的用户信息
        redisTemplate.opsForValue().set(username, resultUser, 7, TimeUnit.DAYS);  // 设置redis缓存 过期时间为7天
        return AppResult.success(resultUser);
    }

    // 获取用户详细信息
    @ApiOperation(value = "获取用户详细信息")
    @GetMapping("/getUserInfo")
    public AppResult<User> getUserInfo(HttpServletRequest request) {
        String token = request.getHeader("token");
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
        // 从token中获取用户名
        String username = tokenInfo.getClaim("username").asString();
        // 从 redis 中获取当前登录用户
        User loginUser = (User) redisUtil.get(username);
        if(loginUser == null || loginUser.getUserId() == null) {
            log.error("登录信息已过期,请重新登录");
            throw new ApplicationException("用户不存在");
        }
        return AppResult.success(loginUser);
    }

    //更新用户密码
    @ApiOperation(value = "更新用户密码")
    @PostMapping("/updatePassword")
//    public AppResult updatePassword(@NonNull @ApiParam(value = "用户ID", example = "1") @RequestParam("userId") Integer userId,
//                                    @NonNull @ApiParam(value = "旧密码") @RequestParam("oldPassword") String oldPassword,
//                                    @NonNull @ApiParam(value = "新密码") @RequestParam("newPassword") String newPassword) {
    public AppResult updatePassword(@RequestBody Map<String,String> params, HttpServletRequest request) {

        String token = request.getHeader("token");
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
        // 从token中获取用户名
        String username = tokenInfo.getClaim("username").asString();
        // 从 redis 中获取当前登录用户
        User loginUser = (User) redisUtil.get(username);
        if(loginUser == null || loginUser.getUserId() == null) {
            log.error("登录信息已过期,请重新登录");
            throw new ApplicationException("用户不存在");
        }
        Integer userId = loginUser.getUserId();
        String oldPassword = params.get("oldPassword");
        String newPassword = params.get("newPassword");
        if (oldPassword == null || newPassword == null) {
            log.error("密码不能为空");
            throw new ApplicationException("密码不能为空");
        }

        User user = userService.getById(userId);
        if (user == null) {
            log.error("用户不存在");
            throw new ApplicationException("用户不存在");
        }
        String oldSalt = user.getSalt();
        String oldPasswordMd5 = MD5util.md5Salt(oldPassword, oldSalt);
        if (!user.getPasswordHash().equals(oldPasswordMd5)) {
            log.error("旧密码错误");
            throw new ApplicationException("旧密码错误");
        }
        String newSalt = Uuid.UUID_32();
        String newPasswordMd5 = MD5util.md5Salt(newPassword, newSalt);
        user.setSalt(newSalt);
        user.setPasswordHash(newPasswordMd5);
        user.setUpdatedAt(TimeUtil.getCurrentTime()); // 更新用户的更新时间
        int i = userService.updateUserPassword(user);
        // todo 用户密码更新之后是否需要重新登录
        return AppResult.success();
    }
    // TEST CODE END
}
