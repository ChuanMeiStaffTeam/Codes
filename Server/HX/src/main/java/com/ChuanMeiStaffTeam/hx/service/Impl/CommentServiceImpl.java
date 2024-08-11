package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.dao.CommentMapper;
import com.ChuanMeiStaffTeam.hx.exception.ApplicationException;
import com.ChuanMeiStaffTeam.hx.model.SysComment;
import com.ChuanMeiStaffTeam.hx.model.vo.SysPostImage;
import com.ChuanMeiStaffTeam.hx.service.ICommentService;
import com.ChuanMeiStaffTeam.hx.service.IPostsImage;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

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
        if(comment.getParentCommentId() == null || comment.getParentCommentId() == 0) {
            comment.setParentCommentId(0);  // 根评论 父评论ID为0
        } else {
            // 不是父评论
            SysComment sysComment = commentMapper.selectById(comment.getParentCommentId());
            if (sysComment == null || !sysComment.getCommentId().equals(comment.getParentCommentId())) {
                log.error("父评论不存在或状态异常");
                throw new ApplicationException("父评论不存在或状态异常");
            }
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
        return userId.equals(sysComment.getUserId());
    }
    @Override
    public void delComment(Integer commentId, Integer postId, Integer parentCommentId) {
        int deletedCommentsCount = 0;
        if (parentCommentId == null || parentCommentId.equals(0)) {
            // 父评论为0，表示这是一个根评论，递归删除所有子评论及当前评论
            deletedCommentsCount = deleteCommentAndChildren(commentId);
            // 删除当前根评论
            commentMapper.deleteById(commentId);
            // 将根评论计入删除的数量
            deletedCommentsCount++;
            log.info("删除根评论及其子评论成功");
        } else {
            // 只删除当前评论
            commentMapper.deleteById(commentId);
            // 计数增加1
            deletedCommentsCount = 1;

            log.info("删除评论成功");
        }
        // 更新帖子评论数量
        updatePostCommentCount(postId, deletedCommentsCount);
    }

    private int deleteCommentAndChildren(Integer parentCommentId) {
        // 获取所有子评论
        List<SysComment> childComments = commentMapper.selectList(
                new QueryWrapper<SysComment>().eq("parent_comment_id", parentCommentId)
        );
        int count = 0;
        // 递归删除所有子评论，并累积删除的评论数量
        for (SysComment child : childComments) {
            count += deleteCommentAndChildren(child.getCommentId());
            // 每删除一个子评论，计数增加1
            commentMapper.deleteById(child.getCommentId());
            count++;
        }
        // 返回删除的评论数量
        return count;
    }

    private void updatePostCommentCount(Integer postId, int deletedCommentsCount) {
        SysPostImage sysPostImage = postsImage.selectPostById(postId);
        if (sysPostImage == null) {
            log.error("该帖子不存在或状态异常");
            throw new ApplicationException("该帖子不存在或状态异常");
        }
        // 更新评论数量，确保不小于0
        int currentCount = sysPostImage.getCommentsCount() - deletedCommentsCount;
        sysPostImage.setCommentsCount(Math.max(currentCount, 0));
        postsImage.updatePostCommentCount(postId, sysPostImage.getCommentsCount());
    }


}
