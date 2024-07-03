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
import com.ChuanMeiStaffTeam.hx.util.JwtUtil;
import com.ChuanMeiStaffTeam.hx.util.RedisUtil;
import com.ChuanMeiStaffTeam.hx.util.UploadUtil;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import io.swagger.models.auth.In;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
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
    public boolean insertPost(SysPost sysPost, User user, List<MultipartFile> images) {
        // 插入文章 并获取文章id
        postMapper.insert(sysPost);
        int postId = sysPost.getPostId(); // 返回文章id
        //更新用户帖子数量
        userService.updateUserPostCount(user);
        // 保存图片
        for (MultipartFile image : images) {
            String imageUrl = UploadUtil.uploadFile(image);
            SysImage sysImage = new SysImage();
            sysImage.setPostId(postId);
            sysImage.setImageUrl(imageUrl);
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
        List<SysPost> sysPosts = postMapper.selectList(queryWrapper);
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

}
