package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.dao.ImageMapper;
import com.ChuanMeiStaffTeam.hx.dao.PostMapper;
import com.ChuanMeiStaffTeam.hx.model.SysImage;
import com.ChuanMeiStaffTeam.hx.model.SysPost;
import com.ChuanMeiStaffTeam.hx.model.vo.SysPostImage;
import com.ChuanMeiStaffTeam.hx.service.IImage;
import com.ChuanMeiStaffTeam.hx.service.IPostsImage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import io.swagger.models.auth.In;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;

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
    private IImage imageService;



    @Override
    public int insertPost(SysPost sysPost) {
        // 插入文章 并获取文章id
        postMapper.insert(sysPost);
        return sysPost.getPostId(); // 返回文章id
    }

    @Override
    public int insertPostImage(SysImage sysImages) {
        return imageMapper.insert(sysImages);
    }

    @Override
    public SysPostImage selectPostById(Integer postId) {
        SysPost sysPost = postMapper.selectById(postId);
        // 将sysPost转换为SysPostImage
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

}
