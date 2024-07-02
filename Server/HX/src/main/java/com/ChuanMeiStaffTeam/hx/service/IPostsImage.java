package com.ChuanMeiStaffTeam.hx.service;

import com.ChuanMeiStaffTeam.hx.model.SysImage;
import com.ChuanMeiStaffTeam.hx.model.SysPost;
import com.ChuanMeiStaffTeam.hx.model.vo.SysPostImage;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/29/9:05
 * @Description:
 */

@Service
public interface IPostsImage extends IService<SysPost> {


    // 保存帖子信息
    int insertPost(SysPost sysPost);

    // 保存帖子下的图片
    int insertPostImage(SysImage sysImages);


    // 根据帖子ID查询帖子
    SysPostImage selectPostById(Integer postId);

    // 根据帖子ID查询帖子图片
    List<SysImage> selectPostImagesByPostId(Integer postId);
}
