package com.ChuanMeiStaffTeam.hx.service;

import com.ChuanMeiStaffTeam.hx.model.SysFollows;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/09/03/20:25
 * @Description:
 */
@Service
public interface IFollowsService extends IService<SysFollows> {

    // 判断当前用户是否已经关注过该用户
    boolean isAlreadyFollowed(Integer followerId, Integer followingId);

    // 用户点击关注
    @Transactional
    int follow(Integer followerId, Integer followingId);

    // 用户点击取消关注
    @Transactional
    int unfollow(Integer followerId, Integer followingId);
}
