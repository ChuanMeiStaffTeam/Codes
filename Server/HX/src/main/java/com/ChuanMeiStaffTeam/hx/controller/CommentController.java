package com.ChuanMeiStaffTeam.hx.controller;

import com.ChuanMeiStaffTeam.hx.common.AppResult;
import com.ChuanMeiStaffTeam.hx.model.SysComment;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.service.ICommentService;
import com.ChuanMeiStaffTeam.hx.util.AuthUtil;
import com.ChuanMeiStaffTeam.hx.util.RedisUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/11/21:50
 * @Description:
 */
@Slf4j
@RestController
@RequestMapping("/api/comment")
public class CommentController {

    @Autowired
    private RedisUtil redisUtil;

    @Resource
    private ICommentService commentService;


    @PostMapping("/addComment")
// 评论正文,帖子id,父评论id
    public AppResult addComment(@RequestBody SysComment comment, HttpServletRequest request) {
        String currentUserName = AuthUtil.getCurrentUserName(request);
        if (currentUserName == null || currentUserName.equals("")) {
            log.info("登录信息已过期,请重新登录");
            return AppResult.failed("登录信息已过期,请重新登录");
        }
        User user = (User) redisUtil.get(currentUserName);
        if (user == null) {
            log.info("登录信息已过期,请重新登录");
            return AppResult.failed("登录信息已过期,请重新登录");
        }
        // 发布评论 评论内容 帖子id 用户id 评论时间 父评论id
        comment.setUserId(user.getUserId());
        log.info("评论参数为:" + comment.toString());
        // 调用评论服务
        commentService.addComment(comment);
        return AppResult.success("评论成功");
    }



}
