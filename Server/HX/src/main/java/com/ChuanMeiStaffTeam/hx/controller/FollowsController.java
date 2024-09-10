package com.ChuanMeiStaffTeam.hx.controller;

import com.ChuanMeiStaffTeam.hx.common.AppResult;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.service.IFollowsService;
import com.ChuanMeiStaffTeam.hx.service.IUserService;
import com.ChuanMeiStaffTeam.hx.util.AuthUtil;
import com.ChuanMeiStaffTeam.hx.util.RedisUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/09/03/20:12
 * @Description:
 */
@Slf4j
@RestController
@RequestMapping("/api/follows")
@Api(tags = "关注接口")
public class FollowsController {


    // TODO: 关注 取消关注 关注列表 粉丝列表

    @Resource
    private IUserService userService;

    @Autowired
    private RedisUtil redisUtil;

    @Resource
    private IFollowsService followsService;

    // TODO: 关注接口实现
    @ApiOperation(value = "关注接口")
    @PostMapping("/follow")
    public AppResult follow(@RequestBody Map<String, Object> params, HttpServletRequest request) {
        // 参数有 被关注者用户id  followingId
        Integer followingId = (Integer) params.get("followingId");
        if (followingId == null || followingId <= 0) {
            log.error("参数错误 followingId: " + followingId);
            return AppResult.failed("参数错误");
        }
        String currentUserName = AuthUtil.getCurrentUserName(request);
        if (currentUserName == null) {
            log.error("用户未登录");
            return AppResult.failed("用户未登录");
        }
        User user = (User) redisUtil.get(currentUserName);
        if (user == null) {
            log.error("用户未登录");
            return AppResult.failed("用户未登录");
        }
        Integer userId = user.getUserId();
        if(userId.equals(followingId)) {
            log.error("不能关注自己");
            return AppResult.failed("不能关注自己");
        }
        // 判断当前用户是否已经关注过该用户
        boolean alreadyFollowed = followsService.isAlreadyFollowed(userId, followingId);
        if (alreadyFollowed) {
            log.error("当前用户已经关注过该用户");
            return AppResult.failed("当前用户已经关注过该用户");
        }
        int follow = followsService.follow(userId, followingId);
        log.info(userId + "关注了" + followingId + "，关注结果：" + follow);
        return follow == 1 ? AppResult.success("关注成功") : AppResult.failed("关注失败");
    }


    @ApiOperation(value = "取消关注接口")
    @PostMapping("/unfollow")
    public AppResult unfollow(@RequestBody Map<String, Object> params, HttpServletRequest request) {
        // 参数有 被取消关注者用户id  unfollowingId
        Integer followingId = (Integer) params.get("unfollowingId");
        if (followingId == null || followingId <= 0) {
            log.error("参数错误 followingId: " + followingId);
            return AppResult.failed("参数错误");
        }
        String currentUserName = AuthUtil.getCurrentUserName(request);
        if (currentUserName == null) {
            log.error("用户未登录");
            return AppResult.failed("用户未登录");
        }
        User user = (User) redisUtil.get(currentUserName);
        if (user == null) {
            log.error("用户未登录");
            return AppResult.failed("用户未登录");
        }
        Integer userId = user.getUserId();
        if(userId.equals(followingId)) {
            log.error("不能取消关注自己");
            return AppResult.failed("不能取消关注自己");
        }
        // 判断当前用户是否已经关注过该用户
        boolean alreadyFollowed = followsService.isAlreadyFollowed(userId, followingId);
        if (!alreadyFollowed) {
            log.error("当前用户没有关注过该用户");
            return AppResult.failed("当前用户没有关注过该用户");
        }
        int unfollow = followsService.unfollow(userId, followingId);
        log.info(userId + "取消关注了" + followingId + "，取消关注结果：" + unfollow);
        return unfollow == 1 ? AppResult.success("取消关注成功") : AppResult.failed("取消关注失败");
    }


    //关注列表接口实现
    @GetMapping("/followslist")
    @ApiOperation(value = "关注列表接口")
    public AppResult follows(HttpServletRequest request) {
        String currentUserName = AuthUtil.getCurrentUserName(request);
        if (currentUserName == null) {
            log.error("用户未登录");
            return AppResult.failed("用户未登录");
        }
        User user = userService.getUserByUserName(currentUserName);
        if (user == null) {
            log.error("用户未登录");
            return AppResult.failed("用户未登录");
        }
        Integer userId = user.getUserId();
        // 查询关注列表
        List<User> followsList = followsService.getFollowsList(userId);
        log.info("关注列表：" + followsList);
        Map<String,Object> result = new HashMap<>();
        result.put("followsList", followsList);
        return AppResult.success(result);
    }


    //粉丝列表接口实现
    @GetMapping("/fanslist")
    @ApiOperation(value = "粉丝列表接口")
    public AppResult fans(HttpServletRequest request) {
        String currentUserName = AuthUtil.getCurrentUserName(request);
        if (currentUserName == null) {
            log.error("用户未登录");
            return AppResult.failed("用户未登录");
        }
        User user = userService.getUserByUserName(currentUserName);
        if (user == null) {
            log.error("用户未登录");
            return AppResult.failed("用户未登录");
        }
        Integer userId = user.getUserId();
        // 查询粉丝列表
        List<User> fansList = followsService.getFansList(userId);
        log.info("粉丝列表：" + fansList);
        Map<String,Object> result = new HashMap<>();
        result.put("fansList", fansList);
        return AppResult.success(result);
    }
}
