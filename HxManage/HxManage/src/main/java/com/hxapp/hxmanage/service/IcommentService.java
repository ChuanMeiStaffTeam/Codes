package com.hxapp.hxmanage.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.hxapp.hxmanage.model.SysComment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/11/18/17:13
 * @Description:
 */
@Service
public interface IcommentService extends IService<SysComment> {

    Long getCommentCount();

    // 获取评论列表
    List<SysComment> getComments(Page<SysComment> page);

    // 删除单条评论
    @Transactional
    boolean deleteComment(Integer commentId,Integer postId,Integer parentId);

//    // 批量删除评论
//    boolean deleteBatchComments(List<Integer> commentIds);
}
