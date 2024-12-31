package com.hxapp.hxmanage.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hxapp.hxmanage.common.AppResult;
import com.hxapp.hxmanage.model.SysPost;
import com.hxapp.hxmanage.service.IpostService;

import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;


import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/12/02/10:36
 * @Description:
 */
@Slf4j
@RestController
@RequestMapping("/api/post")
public class PostController {


    @Resource
    private IpostService postService;

    @GetMapping("/getPostAll")
    public AppResult list(@RequestParam(defaultValue = "1") Integer page,
                          @RequestParam(defaultValue = "10") Integer limit){
        Page<SysPost> pageInfo = new Page<>(page, limit);
        List<SysPost> postList = postService.getPostList(pageInfo);

        log.info("获取帖子列表信息成功");
        Map<String, Object> map = new HashMap<>();
        // 返回岗位列表
        map.put("total", pageInfo.getTotal());  // 总条数
        map.put("records", postList);  // 帖子列表 当前页数据
        return AppResult.success(map);
    }




    // 下架帖子
    @PostMapping("/removePost")
    public AppResult removePost(@NonNull Integer postId){
        SysPost post = new SysPost();
        post.setPostId(postId);
        post.setDeleted(true);
        int i = postService.removePost(post);
//        int i = postService.updatePost(post);
        if (i == 1) {
            log.info("下架帖子成功");
            return AppResult.success();
        }
        log.info("帖子下架失败");
        return AppResult.failed("帖子下架失败");
    }


    // 解除下架帖子
    @PostMapping("/unlockPost")
    public AppResult recoverPost(@NonNull Integer postId){
        SysPost post = new SysPost();
        post.setPostId(postId);
        post.setDeleted(false);
        int i = postService.unlockPost(post);
        if (i == 1) {
            log.info("解除帖子下架成功");
            return AppResult.success();
        }
        log.info("帖子解除下架失败");
        return AppResult.failed("帖子解除下架失败");
    }


    // 搜索帖子
    @GetMapping("/serchPost")
    public AppResult serchPost(@RequestParam(defaultValue = "1") Integer page,
                               @RequestParam(defaultValue = "10") Integer limit,
                               @NonNull String postName){
        Page<SysPost> pageInfo = new Page<>(page, limit);
        List<SysPost> sysPosts = postService.searchPost(postName,pageInfo);
        Map<String, Object> map = new HashMap<>();
        // 返回岗位列表
        log.info("搜索帖子成功");
        map.put("total", pageInfo.getTotal());  // 总条数
        map.put("records", sysPosts);  // 帖子列表 当前页数据
        return AppResult.success(map);
    }


    // 查询所有帖子图片和用户信息
    @GetMapping("/getPostImages")
    public AppResult getPostImages(){
        List<SysPost> allPost = postService.getAllPost();
        log.info("查询所有帖子图片和用户信息成功");
        return AppResult.success(allPost);
    }

    @GetMapping("/serchPostById")
    public AppResult serchPostById(@RequestParam(defaultValue = "1") Integer page,
                                   @RequestParam(defaultValue = "10") Integer limit,
                                   @NonNull Integer postId){
        log.info("根据id查询帖子");
        Page<SysPost> pageInfo = new Page<>(page, limit);
        List<SysPost> sysPosts = postService.getPostById(postId,pageInfo);
        Map<String, Object> map = new HashMap<>();
        // 返回岗位列表
        log.info("搜索帖子成功");
        map.put("total", pageInfo.getTotal());  // 总条数
        map.put("records", sysPosts);  // 帖子列表 当前页数据
        return AppResult.success(map);
    }
}
