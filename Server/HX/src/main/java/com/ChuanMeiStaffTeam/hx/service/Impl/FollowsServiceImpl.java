package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.dao.FollowsMapper;
import com.ChuanMeiStaffTeam.hx.model.SysFollows;
import com.ChuanMeiStaffTeam.hx.service.IFollowsService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/09/03/20:27
 * @Description:
 */
@Service
public class FollowsServiceImpl extends ServiceImpl<FollowsMapper, SysFollows> implements IFollowsService {

    @Autowired
    private FollowsMapper followsMapper;

    @Override
    public boolean isAlreadyFollowed(Integer followerId, Integer followingId) {
        QueryWrapper<SysFollows> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("follower_id", followerId).eq("following_id", followingId);
        SysFollows follows = followsMapper.selectOne(queryWrapper);
        return follows != null;
    }

    // 关注 TODO 当前用户关注数量+1, 被关注用户粉丝数量+1
    @Override
    public int follow(Integer followerId, Integer followingId) {
        SysFollows follows = new SysFollows();
        follows.setFollowerId(followerId);
        follows.setFollowingId(followingId);
        int row = followsMapper.insert(follows);
        if (row > 0) {
            // TODO 当前用户关注数量+1, 被关注用户粉丝数量+1
            return 1;
        }
        return 0; // 关注失败


    }

    // 取消关注 TODO 当前用户关注数量-1, 被关注用户粉丝数量-1
    @Override
    public int unfollow(Integer followerId, Integer followingId) {
        QueryWrapper<SysFollows> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("follower_id", followerId).eq("following_id", followingId);
        int row = followsMapper.delete(queryWrapper);
        if (row > 0) {
            // TODO 当前用户关注数量-1, 被关注用户粉丝数量-1
            return 1;
        }
        return 0; // 取消关注失败
    }
}
