package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.model.SysComment;
import com.ChuanMeiStaffTeam.hx.service.ICommentService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/11/21:54
 * @Description:
 */
@SpringBootTest
class CommentServiceImplTest {

    @Autowired
    private ICommentService commentService;

    @Test
    void sendComment() {
        SysComment comment = new SysComment();
        comment.setCommentText("测试评论");
        commentService.addComment(comment);
    }

}