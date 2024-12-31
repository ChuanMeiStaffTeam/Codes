package com.hxapp.hxmanage.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hxapp.hxmanage.dao.ImageMapper;
import com.hxapp.hxmanage.dao.PostMapper;
import com.hxapp.hxmanage.dao.UserMapper;
import com.hxapp.hxmanage.model.SysImage;
import com.hxapp.hxmanage.model.SysPost;
import com.hxapp.hxmanage.model.User;
import com.hxapp.hxmanage.service.IpostService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import javax.annotation.Resource;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/11/18/16:38
 * @Description:
 */
@Service
public class PostServiceImpl extends ServiceImpl<PostMapper, SysPost> implements IpostService  {
   @Resource
   private PostMapper postMapper;
   @Resource
   private ImageMapper imageMapper;
    @Autowired
    private UserMapper userMapper;


    @Override
    public Long getPostCount() {
        QueryWrapper<SysPost> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("is_deleted", false);
        return postMapper.selectCount(queryWrapper);
    }

    @Override
    public List<SysPost> getPostList(Page<SysPost> page) {
        // 倒序排序 根据created_at
        QueryWrapper<SysPost> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("created_at");
        return postMapper.selectPage(page, queryWrapper).getRecords();
    }

    @Override
    public int updatePost(SysPost sysPost) {
        return postMapper.updateById(sysPost);
    }

    @Override
    public List<SysPost> searchPost(String postName, Page<SysPost> page) {
        QueryWrapper<SysPost> queryWrapper = new QueryWrapper<>();
        queryWrapper.like("caption", postName);
        // 倒序排序 根据created_at
        queryWrapper.orderByDesc("created_at");
        return postMapper.selectPage(page,queryWrapper).getRecords(); // 返回查询结果 当前页数据
    }

    @Override
    public List<SysPost> getAllPost() {
        QueryWrapper<SysPost> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("is_deleted", false);
        // 倒序排序 根据created_at
        queryWrapper.orderByDesc("created_at");
        List<SysPost> sysPosts = postMapper.selectList(queryWrapper); // sql : select * from sys_post where is_deleted = 0
        for (SysPost sysPost : sysPosts) {
            List<String> imageList = getImageList(sysPost.getPostId());
            sysPost.setImagesUrl(imageList);
        }
        return sysPosts;
    }

    @Override
    public List<String> getImageList(Integer postId) {
        QueryWrapper<SysImage> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("post_id", postId);
        // 只返回其中的一个字段 image_url 查询结果用List<String>接收
        queryWrapper.select("image_url");
        List<String> imageList = imageMapper.selectObjs(queryWrapper);
        return imageList;
    }

    @Override
    public List<SysPost> getPostById(Integer postId,Page<SysPost> page) {
        QueryWrapper<SysPost> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("post_id", postId);
        return postMapper.selectPage(page, queryWrapper).getRecords();
    }

    @Override
    public String getTitleById(Integer postId) {
        LambdaQueryWrapper<SysPost> queryWrapper = new LambdaQueryWrapper<>();
        SysPost sysPost = postMapper.selectOne(queryWrapper.select(SysPost::getCaption).eq(SysPost::getPostId, postId));
        return sysPost.getCaption();
    }

    @Override
    public SysPost selectPostById(Integer postId) {
        return postMapper.selectById(postId);
    }

    @Override
    public void updatePostCommentCount(Integer postId, int commentsCount) {
        //comments_count 修改为 commentsCount
        UpdateWrapper<SysPost> queryWrapper = new UpdateWrapper<>();
        queryWrapper.eq("post_id", postId);
        queryWrapper.set("comments_count", commentsCount);
        this.update(queryWrapper); // sql : update sys_post set comments_count = commentsCount where post_id = postId
    }

//
//    @Override
//    public int updatePost(SysPost sysPost) {
//        return postMapper.updateById(sysPost);
//    }
    @Override
    public int removePost(SysPost post) {
        // 根据帖子id查询userId
        postMapper.updateById(post);
        Integer userId = postMapper.getPostById(post.getPostId());
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", userId);
        User user = userMapper.selectOne(queryWrapper.eq("user_id", userId));
        if(user.getPostCount() != null  || user.getPostCount() > 0) {
            userMapper.updateUserPostCount(userId, user.getPostCount() - 1);
        } else {
            userMapper.updateUserPostCount(userId, 0);
        }
        return 1;
    }

    @Override
    public int unlockPost(SysPost post) {
        postMapper.updateById(post);
        Integer userId = postMapper.getPostById(post.getPostId());
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", userId);
        User user = userMapper.selectOne(queryWrapper.eq("user_id", userId));
        if(user.getPostCount() == null) {
            userMapper.updateUserPostCount(userId, 1);
        } else {
            userMapper.updateUserPostCount(userId, user.getPostCount() + 1);
        }
        return 1;
    }
}
