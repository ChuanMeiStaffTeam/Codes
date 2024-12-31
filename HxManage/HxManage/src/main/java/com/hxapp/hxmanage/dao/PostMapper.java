package com.hxapp.hxmanage.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hxapp.hxmanage.model.SysPost;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/11/18/16:39
 * @Description:
 */
@Mapper
public interface PostMapper extends BaseMapper<SysPost> {

    List<SysPost> getAllPost();


    Integer  getPostById(Integer postId);
}
