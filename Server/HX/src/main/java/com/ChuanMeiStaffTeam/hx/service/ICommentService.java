package com.ChuanMeiStaffTeam.hx.service;

import com.ChuanMeiStaffTeam.hx.model.SysComment;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/11/21:51
 * @Description:
 */
@Service
public interface ICommentService extends IService<SysComment> {

    // 新增评论 帖子评论数+1
    @Transactional
    void addComment(SysComment comment);

    // 校验用户是否是评论者

    boolean checkUser(Integer userId, Integer commentId);
}
