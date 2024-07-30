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


    // 发布评论
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
        // 发布评论 评论内容 帖子id 用户id 父评论id
        comment.setUserId(user.getUserId());
        log.info("评论参数为:" + comment.toString());
        // 调用评论服务
        commentService.addComment(comment);
        return AppResult.success("评论成功");
    }


    // 删除评论
    @PostMapping("/deleteComment")
    // params: {commentId: 评论id,  postId: 帖子id,  parentCommentId: 父评论id}
    public AppResult deleteComment(@RequestBody Map<String, Object> params, HttpServletRequest request) {
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
        Integer commentId = (Integer) params.get("commentId");
        if (commentId == null) {
            return AppResult.failed("评论id不能为空");
        }
        // 调用评论服务  不能删除别人的评论 校验用户是否为评论者
        boolean b = commentService.checkUser(user.getUserId(), commentId);
        if(!b) {
            return AppResult.failed("不能删除别人的评论");
        }
       // todo 判断是否为父评论  如果是父评论 则删除所有子评论   否则只删除当前评论
        // todo 判断当前帖子是否删除  如果帖子删除 则删除所有评论  否则只删除当前评论

        // todo
        return AppResult.success("删除成功");
    }
    // 校验参数 评论id 帖子id 父评论id
}
