package com.ChuanMeiStaffTeam.hx.dao;

import com.ChuanMeiStaffTeam.hx.model.SysPost;
import com.ChuanMeiStaffTeam.hx.model.vo.SysPostImage;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

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


    // 获取帖子数量最多的前5个帖子标签
    List<String> selectTop5PostTags();
}
