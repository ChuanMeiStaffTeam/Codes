package com.ChuanMeiStaffTeam.hx.service;

import com.ChuanMeiStaffTeam.hx.model.SysComment;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.stereotype.Service;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/11/21:51
 * @Description:
 */
@Service
public interface ICommentService extends IService<SysComment> {

    // 新增评论
    void addComment(SysComment comment);
}
