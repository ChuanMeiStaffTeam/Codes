package com.ChuanMeiStaffTeam.hx.controller;

import com.ChuanMeiStaffTeam.hx.common.AppResult;
import com.ChuanMeiStaffTeam.hx.model.SysComment;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.model.vo.SysPostImage;
import com.ChuanMeiStaffTeam.hx.service.ICommentService;
import com.ChuanMeiStaffTeam.hx.service.IPostsImage;
import com.ChuanMeiStaffTeam.hx.service.Impl.PostServiceImpl;
import com.ChuanMeiStaffTeam.hx.util.AuthUtil;
import com.ChuanMeiStaffTeam.hx.util.RedisUtil;
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

    @Resource
    private IPostsImage postService;


    // 发布评论
    @PostMapping("/addComment")
// 发布评论 评论内容 帖子id 用户id 父评论id
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
        // 判断帖子是否存在
        Integer postId = (Integer) params.get("postId");
        if (postId == null) {
            return AppResult.failed("帖子id不能为空");
        }
        SysPostImage sysPostImage = postService.selectPostById(postId);
        if(sysPostImage == null) {
            return AppResult.failed("帖子不存在");
        }
        Integer parentCommentId = (Integer) params.get("parentCommentId");
        commentService.delComment(commentId,postId,parentCommentId);
        return AppResult.success("删除成功");
    }


    // 获取帖子评论列表 帖子id
    @GetMapping("/getCommentsByPostId")
    public AppResult getCommentsByPostId(@RequestBody Map<String,Object> params) {
        Integer postId = (Integer) params.get("postId");
        if (postId == null) {
            return AppResult.failed("帖子ID不能为空");
        }

        List<SysComment> comments = commentService.getCommentsByPostId(postId);
        Map<String, Object> result = new HashMap<>();
        result.put("comments", comments);
        return AppResult.success(result);
    }
}
