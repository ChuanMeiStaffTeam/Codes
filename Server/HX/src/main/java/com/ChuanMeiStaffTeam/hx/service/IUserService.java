package com.ChuanMeiStaffTeam.hx.service;

import com.ChuanMeiStaffTeam.hx.model.SysFollows;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/05/20/15:31
 * @Description:
 */
@Service
public interface IUserService extends IService<User> {


    // 根据用户名获取用户信息
    User getUserByUserName(String userName);


    // 插入用户信息
    int insertUser(User user);

    // 更新用户最后登录时间
    int updateUserLastLoginTime(User user);

    // 更新用户登录失败次数
    int updateUserLoginCount(User user);

    // 更新用户登录次数为0
    int updateUserLoginCountToZero(User user);


    // 根据用户id获取用户信息
    User getUserByUserId(User user);
    // 根据用户id获取用户信息
    User getUserByUserId(Integer userId);

    //用户修改头像
    int updateUserAvatar(User user,String fileUrl);

    // 用户更新个人基本信息
    int updateUserBaseInfo(User user);


    // 用户更新密码
    int updateUserPassword(User user);


    // 更新用户帖子数量+1
    int updateUserPostCount(User user);

    // 更新用户帖子数量-1
    int updateUserReplyCount(User user);

    // 更新用户收藏数量
    int updateUserFavoriteCount(Integer userId,Integer favoriteCount);



    // 更新用户关注数量
    int updateUserFollowCount(User user);


    // 更新用户粉丝数量
    int updateUserFansCount(User user);

    // 获取用户关注列表
    List<User> getUserListByUserIds(List<SysFollows> sysFollowsList);

    // 获取用户粉丝列表
    List<User> getUserListByFansIds(List<SysFollows> sysFollowsList);

    User getUserByPhone(String phone);


    //随机获取用户数量count个
    List<User> RandomUser(int count);
}
