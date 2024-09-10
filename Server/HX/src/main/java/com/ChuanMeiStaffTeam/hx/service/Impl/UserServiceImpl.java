package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.exception.ApplicationException;
import com.ChuanMeiStaffTeam.hx.model.SysFollows;
import com.ChuanMeiStaffTeam.hx.service.IUserService;
import com.ChuanMeiStaffTeam.hx.dao.UserMapper;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.util.RedisUtil;
import com.ChuanMeiStaffTeam.hx.util.TimeUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import io.swagger.models.auth.In;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/05/20/15:32
 * @Description:
 */
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {

    @Resource
    private UserMapper userMapper;

    @Autowired
    private RedisUtil redisUtil;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;


    @Override
    public User getUserByUserName(String userName) {
        return userMapper.selectByUserName(userName);
    }

    @Override
    public int insertUser(User user) {
        return userMapper.insertUser(user);
    }

    @Override
    public int updateUserLastLoginTime(User user) {
        // 更新用户最后登录时间 Timestamp 类型
        // Timestamp
        user.setLastLoginAt(new Timestamp(System.currentTimeMillis()));
        return userMapper.updateLastLoginTime(user);
    }

    @Override
    public int updateUserLoginCount(User user) {
        Integer UserLoginCount = user.getLoginAttempts() + 1;
        if (UserLoginCount >= 6) {
            UserLoginCount = 1;
        }
        user.setLoginAttempts(UserLoginCount);
        return userMapper.updateLoginCount(user);
    }

    @Override
    public int updateUserLoginCountToZero(User user) {
        user.setLoginAttempts(0);
        return userMapper.updateLoginCount(user);

    }

    @Override
    public User getUserByUserId(User user) {
        Integer userId = user.getUserId();
        return userMapper.selectByUserId(userId);
    }

    @Override
    public User getUserByUserId(Integer userId) {
        if(userId == null) {
            return null;
        }
        return userMapper.selectById(userId); // sql: select * from user where user_id = 'userId'
    }

    @Override
    public int updateUserAvatar(User user, String avatarUrl) {
        System.out.println(user);
        user.setProfilePictureUrl(avatarUrl);
        user.setUpdatedAt(new Timestamp(System.currentTimeMillis()));  // 更新用户的更新时间
        // 更新redis缓存
        redisTemplate.opsForValue().set(user.getUsername(), user, 7, TimeUnit.DAYS);
        return userMapper.updateById(user);  // 更新用户头像
    }

    // 更新用户基本信息
    @Override
    public int updateUserBaseInfo(User user) {
        // 判断用户邮箱和电话号码是否已存在
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("email", user.getEmail()).or().eq("phone_number", user.getPhoneNumber());
        User existUser = userMapper.selectOne(queryWrapper);
        // sql : select * from user where email = 'user.getEmail()' or phone_number = 'user.getPhoneNumber()'
        if(existUser != null) {
            throw new ApplicationException("邮箱或电话号码已存在");  // 邮箱或电话号码已存在，返回0
        }
        return userMapper.updateById(user);

    }

    @Override
    public int updateUserPassword(User user) {
        return userMapper.updateById(user);
    }

    @Override
    public int updateUserPostCount(User user) {
        if (user.getPostCount() == null) {
            user.setPostCount(0);
        }
        Integer postCount = user.getPostCount() + 1;
        user.setPostCount(postCount);
        // 更新用户的更新时间
        user.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        // 更新redis缓存
        redisTemplate.opsForValue().set(user.getUsername(), user, 7, TimeUnit.DAYS);  // 设置redis缓存 过期时间为7天
        return userMapper.updateById(user);
    }

    @Override
    public int updateUserReplyCount(User user) {
        if (user.getPostCount() == null) {
            user.setPostCount(0);
        }
        int postCount = user.getPostCount() - 1;
        if (postCount < 0) {
            postCount = 0;
        }
        user.setPostCount(postCount);
        user.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        // 更新redis缓存
        redisTemplate.opsForValue().set(user.getUsername(), user, 7, TimeUnit.DAYS);
        return userMapper.updateById(user);
    }

    @Override
    public int updateUserFavoriteCount(Integer userId, Integer favoriteCount) {
        // 更新用户收藏数
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", userId);
        User user = new User();
        user.setFavoriteCount(favoriteCount);
        user.setUpdatedAt(TimeUtil.getCurrentTime());
        return userMapper.update(user, queryWrapper);

    }

    @Override
    public int updateUserFollowCount(User user) {
       userMapper.updateById(user);
        return 0;
    }

    @Override
    public int updateUserFansCount(User user) {
        userMapper.updateById(user);
        return 0;
    }

    @Override
    public List<User> getUserListByUserIds(List<SysFollows> sysFollowsList) {
       List<User> userList = new ArrayList<>();
        for (SysFollows sysFollows : sysFollowsList) {
            User user = getUserByUserId(sysFollows.getFollowingId());
            userList.add(user);
        }
        return userList;
    }

    @Override
    public List<User> getUserListByFansIds(List<SysFollows> sysFollowsList) {
        List<User> userList = new ArrayList<>();
        for (SysFollows sysFollows : sysFollowsList) {
            User user = getUserByUserId(sysFollows.getFollowerId());
            userList.add(user);
        }
        return userList;
    }

    @Override
    public User getUserByPhone(String phone) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("phone_number", phone);
        return userMapper.selectOne(queryWrapper);
    }
}
