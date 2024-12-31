package com.hxapp.hxmanage.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hxapp.hxmanage.common.AppResult;
import com.hxapp.hxmanage.model.SysComment;
import com.hxapp.hxmanage.model.SysPost;
import com.hxapp.hxmanage.service.IcommentService;
import lombok.extern.slf4j.Slf4j;
import lombok.NonNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/12/13/13:12
 * @Description:
 */
@Slf4j
@RestController
@RequestMapping("/api/comment")
public class CommentController {


    @Autowired
    private IcommentService commentService;

    // 获取指定帖子下的所有评论
    @GetMapping("/list")
    public AppResult getCommentsByPostId(@RequestParam(defaultValue = "1") Integer page,
                                                @RequestParam(defaultValue = "10") Integer limit) {
        Page<SysComment> pageInfo = new Page<>(page, limit);
        List<SysComment> comments = commentService.getComments(pageInfo);
        log.info("获取评论列表信息成功");
        Map<String, Object> map = new HashMap<>();
        map.put("total", pageInfo.getTotal());  // 总条数
        map.put("records", comments);
        return AppResult.success(map);
    }

    // 删除评论
    @DeleteMapping("/DeleteComment")
    public AppResult deleteComment(@NonNull Integer commentId,@NonNull Integer postId, @NonNull Integer parentCommentId) {
        boolean isDeleted = commentService.deleteComment(commentId, postId, parentCommentId);
        if (isDeleted) {
            log.info("删除评论成功");
            return AppResult.success();
        }
        return AppResult.failed("服务器繁忙，请稍后再试");
    }
}
