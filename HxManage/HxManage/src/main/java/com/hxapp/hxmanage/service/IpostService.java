package com.hxapp.hxmanage.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.hxapp.hxmanage.model.SysImage;
import com.hxapp.hxmanage.model.SysPost;
import com.hxapp.hxmanage.model.User;
import lombok.NonNull;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/11/18/16:37
 * @Description:
 */
@Service
public interface IpostService extends IService<SysPost> {

    Long getPostCount();


    List<SysPost> getPostList(Page<SysPost> page);


    int updatePost(SysPost sysPost);


    List<SysPost> searchPost(String postName,Page<SysPost> page);


    List<SysPost> getAllPost();


    List<String> getImageList(Integer PostId);

    List<SysPost> getPostById(Integer postId,Page<SysPost> page);

    String getTitleById(Integer postId);

    SysPost selectPostById(Integer postId);

    void updatePostCommentCount(Integer postId, int commentsCount);

    @Transactional
    int removePost(SysPost post);

    @Transactional
    int unlockPost(SysPost post);
}
