package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.dao.FollowsMapper;
import com.ChuanMeiStaffTeam.hx.dao.UserMapper;
import com.ChuanMeiStaffTeam.hx.model.SysFollows;
import com.ChuanMeiStaffTeam.hx.model.SysPost;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.model.vo.SysPostImage;
import com.ChuanMeiStaffTeam.hx.service.IFollowsService;
import com.ChuanMeiStaffTeam.hx.service.IPostsImage;
import com.ChuanMeiStaffTeam.hx.service.IUserService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

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

    @Resource
    private IUserService userService;

    @Resource
    private IPostsImage postService;

    @Override
    public boolean isAlreadyFollowed(Integer followerId, Integer followingId) {
        QueryWrapper<SysFollows> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("follower_id", followerId).eq("following_id", followingId);
        SysFollows follows = followsMapper.selectOne(queryWrapper);
        return follows != null;
    }

    // 关注
    @Override
    public int follow(Integer followerId, Integer followingId) {
        SysFollows follows = new SysFollows();
        follows.setFollowerId(followerId);
        follows.setFollowingId(followingId);
        int row = followsMapper.insert(follows);
        if (row > 0) {
            // TODO 通知被关注用户 推送消息
            //当前用户关注数量+1, 被关注用户粉丝数量+1
            User followerUser = userService.getUserByUserId(followerId);
            if (followerUser != null) {
                if (followerUser.getFollowingCount() == null) {
                    followerUser.setFollowingCount(1);
                } else {
                    followerUser.setFollowingCount(followerUser.getFollowingCount() + 1);
                }
                userService.updateUserFollowCount(followerUser);
            }
            User followingUser = userService.getUserByUserId(followingId);
            if (followingUser != null) {
                if (followingUser.getFollowerCount() == null) {
                    followingUser.setFollowerCount(1);
                } else {
                    followingUser.setFollowerCount(followingUser.getFollowerCount() + 1);
                }
                userService.updateUserFansCount(followingUser);
            }
        }
        return row;
    }

    // 取消关注
    @Override
    public int unfollow(Integer followerId, Integer followingId) {
        QueryWrapper<SysFollows> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("follower_id", followerId).eq("following_id", followingId);
        int row = followsMapper.delete(queryWrapper);
        if (row > 0) {
            //当前用户关注数量-1, 被关注用户粉丝数量-1
            User followerUser = userService.getUserByUserId(followerId);
            if (followerUser != null) {
                if (followerUser.getFollowingCount() != null && followerUser.getFollowingCount() > 0) {
                    followerUser.setFollowingCount(followerUser.getFollowingCount() - 1);
                } else {
                    followerUser.setFollowingCount(0);
                }
                userService.updateUserFansCount(followerUser);
            }
            User followingUser = userService.getUserByUserId(followingId);
            if (followingUser != null) {
                if (followingUser.getFollowerCount() != null && followingUser.getFollowerCount() > 0) {
                    followingUser.setFollowerCount(followingUser.getFollowerCount() - 1);
                } else {
                    followingUser.setFollowerCount(0);
                }
                userService.updateUserFansCount(followingUser);
            }
        }
        return row;
    }

    @Override
    public List<User> getFollowsList(Integer userId) {
        // 查询关注列表 follower_id = userId
        QueryWrapper<SysFollows> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("follower_id", userId);
        List<SysFollows> followsList = followsMapper.selectList(queryWrapper);
        if (followsList != null && followsList.size() > 0) {
            return userService.getUserListByUserIds(followsList);
        }
        return null;
    }

    @Override
    public List<User> getFansList(Integer userId) {
        // 查询粉丝列表 following_id = userId
        QueryWrapper<SysFollows> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("following_id", userId);
        List<SysFollows> fansList = followsMapper.selectList(queryWrapper);
        if (fansList != null && fansList.size() > 0) {
            return userService.getUserListByFansIds(fansList);
        }
        return null;

    }

    @Override
    public List<List<SysPostImage>> getFollowPostList(List<User> userList) {
        List<List<SysPostImage>> postList = new ArrayList<>();
        if (userList != null && userList.size() > 0) {
            for (User user : userList) {
                List<SysPostImage> userPostList = postService.getPostListByUserId(user.getUserId());
                if(userPostList!= null && userPostList.size() > 0) {
                    postList.add(userPostList);
                }
            }
        }
        return postList;
    }
}
