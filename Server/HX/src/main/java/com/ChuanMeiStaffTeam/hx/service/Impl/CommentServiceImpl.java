package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.dao.CommentMapper;
import com.ChuanMeiStaffTeam.hx.model.SysComment;
import com.ChuanMeiStaffTeam.hx.service.ICommentService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/11/21:52
 * @Description:
 */
@Service
public class CommentServiceImpl extends ServiceImpl<CommentMapper, SysComment> implements ICommentService {


    @Autowired
    private CommentMapper commentMapper;

    @Override
    public void addComment(SysComment comment) {
        commentMapper.insert(comment);
    }
}
