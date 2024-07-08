package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.dao.FavoriteMapper;
import com.ChuanMeiStaffTeam.hx.model.SysFavorite;
import com.ChuanMeiStaffTeam.hx.model.SysImage;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.model.vo.SysPostImage;
import com.ChuanMeiStaffTeam.hx.service.IFavoriteService;
import com.ChuanMeiStaffTeam.hx.service.IPostsImage;
import com.ChuanMeiStaffTeam.hx.service.IUserService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.lang.model.element.VariableElement;
import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/07/21:29
 * @Description:
 */
@Service
@Slf4j
public class FavoriteServiceImpl extends ServiceImpl<FavoriteMapper, SysFavorite> implements IFavoriteService {

    @Autowired
    private FavoriteMapper favoriteMapper;


    @Resource
    private IPostsImage postsImage;

    @Resource
    private IUserService userService;

    @Override
    public void insertFavorite(SysPostImage post, User user) {
        SysFavorite sysFavorite = new SysFavorite();
        sysFavorite.setPostId(post.getPostId());
        sysFavorite.setUserId(user.getUserId());
        favoriteMapper.insert(sysFavorite);
        // 该帖子的收藏数+1
        if (post.getFavoriteCount() == null) {
            post.setFavoriteCount(0);
        }
        postsImage.updatePostCollectCount(post.getPostId(), post.getFavoriteCount() + 1);
        // 用户收藏数量+1
        if(user.getFavoriteCount() == null) {
            user.setFavoriteCount(0);
        }
        userService.updateUserFavoriteCount(user.getUserId(), user.getFavoriteCount() + 1);
    }

    @Override
    public void deleteFavorite(SysPostImage post, User user) {
        QueryWrapper<SysFavorite> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("post_id", post.getPostId()).eq("user_id", user.getUserId());
        favoriteMapper.delete(queryWrapper); // 执行删除操作
        // 该帖子的收藏数-1
        if (post.getFavoriteCount() == null || post.getFavoriteCount() == 0) {
            post.setFavoriteCount(0);
        }
        postsImage.updatePostCollectCount(post.getPostId(), 0);
        // 删除sql：DELETE FROM sys_favorite WHERE post_id = #{postId} AND user_id = #{userId}
        // 用户收藏数量-1
        if(user.getFavoriteCount() == null || user.getFavoriteCount() == 0) {
            user.setFavoriteCount(0);
        }
        userService.updateUserFavoriteCount(user.getUserId(), 0);
    }

    @Override
    public boolean isFavorite(Integer postId, Integer userId) {
        // 判断当前用户是否已经收藏
        QueryWrapper<SysFavorite> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("post_id", postId).eq("user_id", userId);
        SysFavorite sysFavorite = favoriteMapper.selectOne(queryWrapper);
        return sysFavorite != null;  // 返回true表示已经收藏，false表示未收藏
    }

    @Override
    public List<SysPostImage> getFavoriteList(Integer userId) {
        // 查询当前用户收藏的所有帖子
        // 获取到当前用户收藏的所有帖子id
        QueryWrapper<SysFavorite> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", userId);
        List<SysFavorite> sysFavorites = favoriteMapper.selectList(queryWrapper);
        if(sysFavorites == null || sysFavorites.size() == 0) {
            log.info("当前用户没有收藏帖子");
            return null;
        }
        // 查询这些帖子的详细信息
        List<SysPostImage> sysPostImageList = new ArrayList<>();
        for (SysFavorite sysFavorite : sysFavorites) {
            SysPostImage post = postsImage.selectPostById(sysFavorite.getPostId());
            List<SysImage> sysImages = postsImage.selectPostImagesByPostId(sysFavorite.getPostId());
            post.setImages(sysImages);
            sysPostImageList.add(post);
        }
        return sysPostImageList;   // 返回收藏列表
    }

}
