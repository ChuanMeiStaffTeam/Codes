package com.hxapp.hxmanage.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hxapp.hxmanage.model.SysComment;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SysCommentMapper extends BaseMapper<SysComment> {
    // 你可以根据需要在这里定义一些自定义的查询方法
}
