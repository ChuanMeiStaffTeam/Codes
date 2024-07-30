package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.dao.CommentMapper;
import com.ChuanMeiStaffTeam.hx.exception.ApplicationException;
import com.ChuanMeiStaffTeam.hx.model.SysComment;
import com.ChuanMeiStaffTeam.hx.model.vo.SysPostImage;
import com.ChuanMeiStaffTeam.hx.service.ICommentService;
import com.ChuanMeiStaffTeam.hx.service.IPostsImage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/11/21:52
 * @Description:
 */
@Service
@Slf4j
public class CommentServiceImpl extends ServiceImpl<CommentMapper, SysComment> implements ICommentService {


    @Resource
    private IPostsImage postsImage;

    @Autowired
    private CommentMapper commentMapper;

    @Override
    public void addComment(SysComment comment) {
        SysPostImage sysPostImage = postsImage.selectPostById(comment.getPostId());
        if(sysPostImage == null) {
            log.error("该帖子不存在或状态异常");
            throw new ApplicationException("该帖子不存在或状态异常");
        }
        commentMapper.insert(comment);  // 插入评论
        // 更新文章评论数量
        // 获取当前文章评论数
        if(sysPostImage.getCommentsCount() < 0) {
            sysPostImage.setCommentsCount(1);
        } else {
            sysPostImage.setCommentsCount(sysPostImage.getCommentsCount() + 1);
        }
        postsImage.updatePostCommentCount(comment.getPostId(),sysPostImage.getCommentsCount());
        log.info("新增评论成功");
    }

    @Override
    public boolean checkUser(Integer userId, Integer commentId) {
        if(userId == null || commentId == null) {
            log.error("用户或评论ID为空");
            throw new ApplicationException("用户或评论ID为空");
        }
        SysComment sysComment = commentMapper.selectById(commentId);
        if(sysComment == null) {
            log.error("评论不存在,无法进行删除");
            throw new ApplicationException("评论不存在,无法进行删除");
        }
        return userId.equals(commentId);
    }
}
