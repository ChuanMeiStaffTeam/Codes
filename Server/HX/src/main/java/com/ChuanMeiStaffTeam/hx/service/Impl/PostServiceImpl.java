package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.dao.ImageMapper;
import com.ChuanMeiStaffTeam.hx.dao.PostMapper;
import com.ChuanMeiStaffTeam.hx.model.SysImage;
import com.ChuanMeiStaffTeam.hx.model.SysPost;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.model.vo.SysPostImage;
import com.ChuanMeiStaffTeam.hx.service.IImage;
import com.ChuanMeiStaffTeam.hx.service.IPostsImage;
import com.ChuanMeiStaffTeam.hx.service.IUserService;
import com.ChuanMeiStaffTeam.hx.util.RedisUtil;
import com.ChuanMeiStaffTeam.hx.util.UploadUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/29/9:21
 * @Description:
 */
@Service
public class PostServiceImpl extends ServiceImpl<PostMapper, SysPost>implements IPostsImage {

    @Autowired
    private PostMapper postMapper;

    @Autowired
    private ImageMapper imageMapper;

    @Resource
    private IUserService userService;

    @Resource
    private IPostsImage postsImageService;

    @Resource
    private IImage imageService;


    @Autowired
    private RedisUtil redisUtil;

    @Override
    public boolean insertPost(SysPost sysPost, User user, List<String> images) {
        // 插入文章 并获取文章id
        postMapper.insert(sysPost);
        int postId = sysPost.getPostId(); // 返回文章id
        //更新用户帖子数量
        userService.updateUserPostCount(user);
        // 保存图片
        for (String image : images) {
            SysImage sysImage = new SysImage();
            sysImage.setPostId(postId);
            sysImage.setImageUrl(image);
            insertPostImage(sysImage);
        }
        return true;
    }

    @Override
    public int insertPostImage(SysImage sysImages) {
        return imageMapper.insert(sysImages);
    }

    @Override
    public SysPostImage selectPostById(Integer postId) {
        SysPost sysPost = postMapper.selectById(postId);
        // 将sysPost转换为SysPostImage
        if(sysPost == null) {
            return null;
        }
        SysPostImage sysPostImage = new SysPostImage();
        sysPostImage.setPostId(sysPost.getPostId());
        sysPostImage.setUserId(sysPost.getUserId());
        sysPostImage.setCaption(sysPost.getCaption());
        sysPostImage.setLocation(sysPost.getLocation());
        sysPostImage.setLikesCount(sysPost.getLikesCount());
        sysPostImage.setCreatedAt(sysPost.getCreatedAt());
        sysPostImage.setUpdatedAt(sysPost.getUpdatedAt());
        sysPostImage.setCommentsCount(sysPost.getCommentsCount());
        sysPostImage.setPublic(sysPost.isPublic());
        sysPostImage.setTags(sysPost.getTags());
        sysPostImage.setDeleted(sysPost.isDeleted());
        sysPostImage.setVisibility(sysPost.getVisibility());
        sysPostImage.setFavoriteCount(sysPost.getFavoriteCount());
        return sysPostImage;
    }

    @Override
    public List<SysImage> selectPostImagesByPostId(Integer postId) {
        HashMap<String,Object> map = new HashMap<>();
        map.put("post_id",postId);
        return imageMapper.selectByMap(map);
    }

    @Override
    public List<SysPostImage> selectAllPosts() {
        // 查询所有 按照时间降序
        QueryWrapper<SysPost> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("created_at");
        List<SysPost> sysPosts = postMapper.selectList(queryWrapper);  // sql: select * from sys_post order by created_at desc
        // 将sysPosts转换为SysPostImage  并设置图片
        List<SysPostImage> sysPostImages = new ArrayList<>();
        for (SysPost sysPost : sysPosts) {
            SysPostImage sysPostImage = new SysPostImage();
            sysPostImage.setPostId(sysPost.getPostId());
            sysPostImage.setUserId(sysPost.getUserId());
            sysPostImage.setCaption(sysPost.getCaption());
            sysPostImage.setLocation(sysPost.getLocation());
            sysPostImage.setLikesCount(sysPost.getLikesCount());
            sysPostImage.setCreatedAt(sysPost.getCreatedAt());
            sysPostImage.setUpdatedAt(sysPost.getUpdatedAt());
            sysPostImage.setCommentsCount(sysPost.getCommentsCount());
            sysPostImage.setPublic(sysPost.isPublic());
            sysPostImage.setTags(sysPost.getTags());
            sysPostImage.setDeleted(sysPost.isDeleted());
            sysPostImage.setVisibility(sysPost.getVisibility());
            sysPostImage.setFavoriteCount(sysPost.getFavoriteCount());
            // 设置图片
            List<SysImage> sysImages = selectPostImagesByPostId(sysPostImage.getPostId());
            sysPostImage.setImages(sysImages);
            sysPostImages.add(sysPostImage);
        }
        return sysPostImages;
    }

    @Override
    public boolean deletePost(Integer postId, User user) {
        // 删除文章
        // 先根据文章id删除图片  然后再删除文章   最后更新用户帖子数量

        Map<String,Object> map = new HashMap<>();
        map.put("post_id",postId);
        imageMapper.deleteByMap(map);  // 删除图片
        postMapper.deleteById(postId);  // 删除文章
        // 更新用户帖子数量
        userService.updateUserReplyCount(user);
        return true;
    }

    @Override
    public boolean updatePostLikeCount(Integer postId, Integer likeCount) {
        QueryWrapper<SysPost> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("post_id",postId);
        SysPost sysPost = new SysPost();
        sysPost.setLikesCount(likeCount);
        int update = postMapper.update(sysPost, queryWrapper);
        return update > 0;

    }

    @Override
    public boolean updatePostCollectCount(Integer postId, Integer collectCount) {
        QueryWrapper<SysPost> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("post_id",postId);
        SysPost sysPost = new SysPost();
        sysPost.setFavoriteCount(collectCount);
        int update = postMapper.update(sysPost, queryWrapper);
        // sql: update sys_post set favorite_count = #{collectCount} where post_id = #{postId}
        return update > 0;
    }

    @Override
    public boolean updatePostCommentCount(Integer postId, Integer commentCount) {
        QueryWrapper<SysPost> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("post_id",postId);
        SysPost sysPost = new SysPost();
        sysPost.setCommentsCount(commentCount);
        int update = postMapper.update(sysPost, queryWrapper);
        // sql: update sys_post set comments_count = #{commentCount} where post_id = #{postId}
        return update > 0;
    }

    @Override
    public List<SysPostImage> getPostListByUserId(Integer userId) {
        QueryWrapper<SysPost> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id",userId);
        List<SysPost> sysPosts = postMapper.selectList(queryWrapper);
        List<SysPostImage> sysPostImages = new ArrayList<>();
        for (SysPost sysPost : sysPosts) {
            SysPostImage sysPostImage = new SysPostImage();
            sysPostImage.setPostId(sysPost.getPostId());
            sysPostImage.setUserId(sysPost.getUserId());
            sysPostImage.setCaption(sysPost.getCaption());
            sysPostImage.setLocation(sysPost.getLocation());
            sysPostImage.setLikesCount(sysPost.getLikesCount());
            sysPostImage.setCreatedAt(sysPost.getCreatedAt());
            sysPostImage.setUpdatedAt(sysPost.getUpdatedAt());
            sysPostImage.setCommentsCount(sysPost.getCommentsCount());
            sysPostImage.setPublic(sysPost.isPublic());
            sysPostImage.setTags(sysPost.getTags());
            sysPostImage.setDeleted(sysPost.isDeleted());
            sysPostImage.setVisibility(sysPost.getVisibility());
            sysPostImage.setFavoriteCount(sysPost.getFavoriteCount());
            // 设置图片
            List<SysImage> sysImages = selectPostImagesByPostId(sysPostImage.getPostId());
            sysPostImage.setImages(sysImages);
            sysPostImages.add(sysPostImage);
        }
        return sysPostImages;
    }

    @Override
    public List<SysPostImage> searchPosts(String keyword) {
        QueryWrapper<SysPost> queryWrapper = new QueryWrapper<>();
        String key = "%" + keyword + "%";
        queryWrapper.like("caption",key);
        List<SysPost> sysPosts = postMapper.selectList(queryWrapper);  // sql: select * from sys_post where caption like '%keyword%'
        if(sysPosts == null || sysPosts.size() == 0) {
            return null;
        }
        List<SysPostImage> sysPostImages = new ArrayList<>();
        for (SysPost sysPost : sysPosts) {
            SysPostImage sysPostImage = new SysPostImage();
            sysPostImage.setPostId(sysPost.getPostId());
            sysPostImage.setUserId(sysPost.getUserId());
            sysPostImage.setCaption(sysPost.getCaption());
            sysPostImage.setLocation(sysPost.getLocation());
            sysPostImage.setLikesCount(sysPost.getLikesCount());
            sysPostImage.setCreatedAt(sysPost.getCreatedAt());
            sysPostImage.setUpdatedAt(sysPost.getUpdatedAt());
            sysPostImage.setCommentsCount(sysPost.getCommentsCount());
            sysPostImage.setPublic(sysPost.isPublic());
            sysPostImage.setTags(sysPost.getTags());
            sysPostImage.setDeleted(sysPost.isDeleted());
            sysPostImage.setVisibility(sysPost.getVisibility());
            sysPostImage.setFavoriteCount(sysPost.getFavoriteCount());
            // 设置图片
            List<SysImage> sysImages = selectPostImagesByPostId(sysPostImage.getPostId());
            sysPostImage.setImages(sysImages);
            sysPostImages.add(sysPostImage);
        }
        return sysPostImages;
    }
}
