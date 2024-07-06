package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.dao.LikeMapper;
import com.ChuanMeiStaffTeam.hx.model.SysLike;
import com.ChuanMeiStaffTeam.hx.service.ILikeService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.IService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import io.swagger.models.auth.In;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/06/16:40
 * @Description:
 */
@Service
public class LikeService extends ServiceImpl<LikeMapper,SysLike> implements ILikeService {


    @Autowired
    private LikeMapper likeMapper;

    @Override
    public boolean isLiked(Integer postId, Integer userId) {
        if(postId == null || userId == null) {
            return false;
        }
        Map<String, Object> map = new HashMap<>();
        map.put("post_id", postId);
        map.put("user_id", userId);
        List<SysLike> sysLikes = likeMapper.selectByMap(map);
        return sysLikes == null || sysLikes.size() == 0;


    }

    @Override
    public boolean like(Integer postId, Integer userId) {
        SysLike sysLike = new SysLike();
        sysLike.setPostId(postId);
        sysLike.setUserId(userId);
        int insert = likeMapper.insert(sysLike);
        return insert == 1;


    }

    @Override
    public boolean unlike(Integer postId, Integer userId) {
        // 2024/07/06 取消点赞功能  根据 postid 和 userid 删除记录
        Map<String, Object> map = new HashMap<>();
        map.put("post_id", postId);
        map.put("user_id", userId);
        int delete = likeMapper.deleteByMap(map);
        return delete == 1;
    }

    @Override
    public List<Integer> getLikedPostIds(Integer userId) {
        Map<String, Object> map = new HashMap<>();
        map.put("user_id", userId);
        List<SysLike> sysLikes = likeMapper.selectByMap(map);

        if(sysLikes == null || sysLikes.size() == 0) {
            return null;
        }
        List<Integer> integers = new ArrayList<>();
        for(SysLike sysLike : sysLikes) {
            integers.add(sysLike.getPostId());
        }
        return integers;
    }
}
