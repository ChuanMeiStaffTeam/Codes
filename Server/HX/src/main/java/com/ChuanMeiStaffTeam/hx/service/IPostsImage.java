package com.ChuanMeiStaffTeam.hx.service;

import com.ChuanMeiStaffTeam.hx.model.SysImage;
import com.ChuanMeiStaffTeam.hx.model.SysPost;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.model.vo.SysPostImage;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

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
    @Transactional // 事务注解
    boolean insertPost(SysPost sysPost, User user, List<String> images);

    // 保存帖子下的图片
    int insertPostImage(SysImage sysImages);


    // 根据帖子ID查询帖子
    SysPostImage selectPostById(Integer postId);

    // 根据帖子ID查询帖子图片
    List<SysImage> selectPostImagesByPostId(Integer postId);


    // 查询所有帖子
    List<SysPostImage> selectAllPosts();



    // 删除帖子
    @Transactional // 事务注解
    boolean deletePost(Integer postId, User user);


    // 更新帖子点赞数
    boolean updatePostLikeCount(Integer postId, Integer likeCount);

    // 更新帖子收藏数
    boolean updatePostCollectCount(Integer postId, Integer collectCount);

    // 更新帖子评论数
    boolean updatePostCommentCount(Integer postId, Integer commentCount);


    // 根据用户id查询帖子列表
    List<SysPostImage> getPostListByUserId(Integer userId);

    // 搜索帖子
    List<SysPostImage> searchPosts(String keyword);
}
