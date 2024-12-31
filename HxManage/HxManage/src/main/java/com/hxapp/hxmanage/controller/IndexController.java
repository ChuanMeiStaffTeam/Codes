package com.hxapp.hxmanage.controller;

import com.hxapp.hxmanage.common.AppResult;
import com.hxapp.hxmanage.service.*;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/11/18/16:30
 * @Description:
 */
@RestController
@RequestMapping("/api/index")
public class IndexController {

    @Resource
    private IUserService userService;

    @Resource
    private IpostService postService;

    @Resource
    private IimageService imageService;

    @Resource
    private IcommentService commentService;

    @Resource
    private IdeptService deptService;

    @GetMapping("/getcount")
    public AppResult getCount(){
        Map<String, Long> map = new HashMap<>();

        Long userCount = userService.getUserCount();
        map.put("userCount",userCount);
        Long postCount = postService.getPostCount();
        map.put("postCount",postCount);
        Long imagesCount = imageService.getImagesCount();
        map.put("imagesCount",imagesCount);
        Long commentCount = commentService.getCommentCount();
        map.put("commentCount",commentCount);
        Long deptCount = deptService.getDeptCount();
        map.put("deptCount",deptCount);
        return AppResult.success(map);
    }

}
