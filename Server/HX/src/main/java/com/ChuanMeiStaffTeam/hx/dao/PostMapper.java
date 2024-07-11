package com.ChuanMeiStaffTeam.hx.dao;

import com.ChuanMeiStaffTeam.hx.model.SysPost;
import com.ChuanMeiStaffTeam.hx.model.vo.SysPostImage;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/29/9:25
 * @Description:
 */
@Mapper
public interface PostMapper extends BaseMapper<SysPost> {

    // 根据帖子id 查询帖子信息
    SysPostImage selectPostById(Long postId);
}