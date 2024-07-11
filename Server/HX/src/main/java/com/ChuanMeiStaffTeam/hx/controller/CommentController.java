package com.ChuanMeiStaffTeam.hx.controller;

import com.ChuanMeiStaffTeam.hx.model.SysComment;
import com.ChuanMeiStaffTeam.hx.service.ICommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/11/21:50
 * @Description:
 */
@RestController
@RequestMapping("/api/comment")
public class CommentController {


    @Resource
    private ICommentService commentService;

    @PostMapping("/addComment")
    public String addComment(String content) {

        SysComment  comment = new SysComment();
        comment.setCommentText(content);
        comment.setPostId(34);
        comment.setUserId(16);
        commentService.addComment(comment);
        return "success";
    }

}
