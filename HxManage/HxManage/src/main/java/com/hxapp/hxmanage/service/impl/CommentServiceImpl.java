package com.hxapp.hxmanage.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hxapp.hxmanage.dao.CommentMapper;
import com.hxapp.hxmanage.exception.ApplicationException;
import com.hxapp.hxmanage.model.SysComment;
import com.hxapp.hxmanage.model.SysPost;
import com.hxapp.hxmanage.service.IcommentService;
import com.hxapp.hxmanage.service.IpostService;


import org.springframework.stereotype.Service;


import javax.annotation.Resource;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/11/18/17:14
 * @Description:
 */
@Service
public class CommentServiceImpl extends ServiceImpl<CommentMapper, SysComment> implements IcommentService {

    @Resource
    private CommentMapper commentMapper;

    @Resource
    private IpostService postService;

    @Override
    public Long getCommentCount() {
        return commentMapper.selectCount(null);
    }

    @Override
    public List<SysComment> getComments(Page<SysComment> page) {
        Page<SysComment> sysCommentPage = commentMapper.selectPage(page, null);
        List<SysComment> records = sysCommentPage.getRecords();
        for (SysComment sysComment : records) {
            sysComment.setPostTitle(postService.getTitleById(sysComment.getPostId()));
        }
        return records;
    }


    // 删除评论
    @Override
    public boolean deleteComment(Integer commentId,Integer postId,Integer parentCommentId) {
        int deletedCommentsCount = 0;
        if (parentCommentId == null || parentCommentId.equals(0)) {  // 根评论
            // 父评论为0，表示这是一个根评论，递归删除所有子评论及当前评论
            deletedCommentsCount = deleteCommentAndChildren(commentId);
            // 删除当前根评论
            commentMapper.deleteById(commentId);
            // 将根评论计入删除的数量
            deletedCommentsCount++;
        } else {
            // 不是根评论, 递归删除当前评论及其子评论
            deletedCommentsCount = deleteCommentAndChildren(commentId);
            commentMapper.deleteById(commentId);
            deletedCommentsCount++;
        }
        // 更新帖子评论数量
        updatePostCommentCount(postId, deletedCommentsCount);
        return deletedCommentsCount > 0;
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
        SysPost sysPostImage = postService.selectPostById(postId);
        if (sysPostImage == null) {
            log.error("该帖子不存在或状态异常");
            throw new ApplicationException("该帖子不存在或状态异常");
        }
        // 更新评论数量，确保不小于0
        int currentCount = sysPostImage.getCommentsCount() - deletedCommentsCount;
        sysPostImage.setCommentsCount(Math.max(currentCount, 0)); // 确保不小于0
        postService.updatePostCommentCount(postId, sysPostImage.getCommentsCount());
    }
}
