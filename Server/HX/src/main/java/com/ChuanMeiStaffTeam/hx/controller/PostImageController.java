package com.ChuanMeiStaffTeam.hx.controller;

import com.ChuanMeiStaffTeam.hx.common.AppResult;
import com.ChuanMeiStaffTeam.hx.config.ConfigKey;
import com.ChuanMeiStaffTeam.hx.model.SysImage;
import com.ChuanMeiStaffTeam.hx.model.SysPost;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.model.vo.SysPostImage;
import com.ChuanMeiStaffTeam.hx.model.vo.paramPost;
import com.ChuanMeiStaffTeam.hx.service.IFavoriteService;
import com.ChuanMeiStaffTeam.hx.service.ILikeService;
import com.ChuanMeiStaffTeam.hx.service.IPostsImage;
import com.ChuanMeiStaffTeam.hx.service.IUserService;
import com.ChuanMeiStaffTeam.hx.util.JwtUtil;
import com.ChuanMeiStaffTeam.hx.util.RedisUtil;
import com.ChuanMeiStaffTeam.hx.util.UploadUtil;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.models.auth.In;
import jdk.nashorn.internal.runtime.regexp.joni.Config;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.MediaType;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;
import java.util.concurrent.FutureTask;

@Slf4j
@RestController
@RequestMapping("/api/postImage")
@Api(value = "Post Image Controller", tags = "帖子图片接口")
public class PostImageController {

    @Autowired
    private RedisUtil redisUtil;

    @Resource
    private IPostsImage postsImageService;

    @Resource
    private ThreadPoolTaskExecutor taskExecutor;

    @Resource
    private ILikeService likeService;

    @Resource
    private RedisTemplate<String, Object> redisTemplate;


    @Resource
    private IFavoriteService favoriteService;

    @ApiOperation(value = "用户发帖图片接口")
    @PostMapping(value = "/article", consumes = "multipart/form-data")
    public AppResult upload(
            @RequestParam("images") List<MultipartFile> images,
            HttpServletRequest request) {

        if (images.isEmpty()) {  // 图片为空
            log.info("请上传图片");
            return AppResult.failed("请上传图片");
        }
        Map<String, Object> params = new HashMap<>();
        // 获取当前登录用户id和username 从token中获取
        String token = request.getHeader("token");
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
        String username = tokenInfo.getClaim("username").asString();
        // 从 redis 中获取当前登录用户
        User user = (User) redisUtil.get(username);
        if (user == null) {
            log.info("登录信息已过期,请重新登录");
            return AppResult.failed("登录信息已过期,请重新登录");
        }
        List<String> imageUrls = new ArrayList<>();
        for (MultipartFile image : images) {
            String imageUrl = UploadUtil.uploadFile(image);
            imageUrls.add(imageUrl);
        }
        params.put("list",imageUrls);
        return AppResult.success(params);


      //  post.setUserId(user.getUserId());
//        log.error(user.toString());
//        log.error(post.toString());
        // 插入帖子信息,用户帖子数量加1,保存图片
       // long start = System.currentTimeMillis();
      //  boolean b = postsImageService.insertPost(post, user, images);
       // long end = System.currentTimeMillis();
       // log.error("插入帖子信息耗时:" + (end - start) + "毫秒");
        // 后续添加redis缓存 todo
//        if (!b) {
//            log.info("发帖失败");
//            return AppResult.failed("发帖失败");
//        }
    //    return AppResult.success();
    }

        // 用户发帖接口
        @PostMapping("/createPost")
        public AppResult createPost(@RequestBody SysPost post, HttpServletRequest request) {
            // 获取当前登录用户id和username 从token中获取
            String token = request.getHeader("token");
            DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
            String username = tokenInfo.getClaim("username").asString();
            // 从 redis 中获取当前登录用户
            User user = (User) redisUtil.get(username);
            if (user == null) {
                log.info("登录信息已过期,请重新登录");
                return AppResult.failed("登录信息已过期,请重新登录");
            }
            post.setUserId(user.getUserId());
            log.error(post.toString());

            // 插入帖子信息,用户帖子数量加1,保存图片
            boolean b = postsImageService.insertPost(post, user, post.getImagesUrl());
            if(!b) {
                log.info("发帖失败");
                return AppResult.failed("发帖失败");
            }
            return AppResult.success();
        }

    // 用户查询帖子详情接口
    @GetMapping(value = "/queryPost")
    @ApiOperation(value = "用户查询帖子接口")
    public AppResult queryPost(@RequestBody Map<String, Object> params) {
        Integer postId = (Integer) params.get("postId");
        if (postId == null) {
            log.info("帖子id不能为空");
            return AppResult.failed("帖子id不能为空");
        }
        // 查询帖子信息
        SysPostImage sysPostImage = postsImageService.selectPostById(postId);
        if (sysPostImage == null) {
            log.info("帖子不存在");
            return AppResult.failed("帖子不存在");
        }
        // 查询图片信息
        List<SysImage> sysImages = postsImageService.selectPostImagesByPostId(postId);
        if (sysImages == null || sysImages.isEmpty()) {
            log.info("帖子图片不存在");
            //return AppResult.failed("帖子图片不存在");
        }
        sysPostImage.setImages(sysImages);
        Map<String, Object> map = new HashMap<>();
        map.put("post", sysPostImage);
        return AppResult.success(map);
    }

    // 获取主页帖子信息接口
    @GetMapping(value = "/queryHomePosts")
    @ApiOperation(value = "获取主页帖子接口")
    public AppResult queryHomePosts() {
        // 查询帖子信息
        // 查询所有的帖子信息,并将帖子信息中的图片信息查询出来,设置到SysPostImage对象中
        List<SysPostImage> sysPostImages = postsImageService.selectAllPosts();
        if (sysPostImages == null || sysPostImages.isEmpty()) {
            log.info("帖子为空");
            return AppResult.failed("帖子为空");
        }
        Map<String, Object> map = new HashMap<>();
        map.put("list", sysPostImages);
        // 后续添加分页功能 redis缓存 todo
        return AppResult.success(map);
    }


    // 用户删除帖子接口
    @DeleteMapping(value = "/deletePost")
    @ApiOperation(value = "用户删除帖子接口")
    public AppResult deletePost(@RequestBody Map<String, Object> params, HttpServletRequest request) {
        Integer postId = (Integer) params.get("postId");
        if (postId == null) {
            log.info("帖子id不能为空");
            return AppResult.failed("帖子id不能为空");
        }
        // 判断当前登录用户是否为帖子作者
        String token = request.getHeader("token");
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
        String username = tokenInfo.getClaim("username").asString();
        // 从 redis 中获取当前登录用户
        System.out.println(username);
        User user = (User) redisUtil.get(username);
        if (user == null) {
            log.info("登录信息已过期,请重新登录");
            return AppResult.failed("登录信息已过期,请重新登录");
        }
        System.out.println(user.toString());
        // 查询帖子信息
        SysPostImage sysPostImage = postsImageService.selectPostById(postId);
        int userId = user.getUserId();
        System.out.println(user.toString());
        if (!sysPostImage.getUserId().equals(userId)) {
            log.info("你没有权限删除该帖子");
            return AppResult.failed("你没有权限删除该帖子");
        }
        // 删除帖子信息,根据帖子id删除图片信息,用户帖子数量减1
        boolean b = postsImageService.deletePost(postId, user);
        if (!b) {
            log.info("删除帖子失败");
            return AppResult.failed("删除帖子失败");
        }
        // todo 删除该帖子下的所有评论信息
        return AppResult.success();
    }

    // 用户修改帖子接口 todo

    // 点赞帖子接口
    @PostMapping(value = "/likePost")
    @ApiOperation(value = "点赞帖子接口")
    public AppResult likePost(@RequestBody Map<String,Object> params, HttpServletRequest request) {
        Integer postId = (Integer) params.get("postId");
        if (postId == null) {
            log.info("帖子id不能为空");
            return AppResult.failed("帖子id不能为空");
        }
        String token = request.getHeader("token");
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
        String username = tokenInfo.getClaim("username").asString();
        // 从 redis 中获取当前登录用户
        User user = (User) redisUtil.get(username);
        if (user == null || user.getUserId() == null) {
            log.info("登录信息已过期,请重新登录");
            return AppResult.failed("登录信息已过期,请重新登录");
        }
        // 判断当前登录用户是否已经点赞
        boolean liked = likeService.isLiked(postId, user.getUserId());
        if (!liked) {
            log.info("你已经点赞过该帖子");
            return AppResult.failed("你已经点赞过该帖子");
        }
        // 查询帖子信息
        SysPostImage sysPostImage = postsImageService.selectPostById(postId);
        if (sysPostImage == null) {
            log.info("帖子不存在");
            return AppResult.failed("帖子不存在");
        }
        int userId = user.getUserId();
        if (sysPostImage.getUserId().equals(userId)) {
            log.info("不能给自己点赞");
            return AppResult.failed("不能给自己点赞");
        }
        // 点赞帖子
        boolean b = likeService.like(postId, user.getUserId());
        if (!b) {
            log.info("点赞失败");
            return AppResult.failed("点赞失败");
        }
        // 更新帖子点赞数
        if (sysPostImage.getLikesCount() == null) {
            sysPostImage.setLikesCount(0);
        }
        Integer likeCount = sysPostImage.getLikesCount() + 1;
        postsImageService.updatePostLikeCount(postId, likeCount);
        return AppResult.success("点赞成功");
    }

    // 取消点赞帖子接口
    @PostMapping(value = "/cancelLikePost")
    @ApiOperation(value = "取消点赞帖子接口")
    public AppResult cancelLikePost(@RequestBody Map<String,Object> params, HttpServletRequest request) {
        Integer postId = (Integer) params.get("postId");
        if (postId == null) {
            log.info("帖子id不能为空");
            return AppResult.failed("帖子id不能为空");
        }

        String token = request.getHeader("token");
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
        String username = tokenInfo.getClaim("username").asString();
        // 从 redis 中获取当前登录用户
        User user = (User) redisUtil.get(username);
        if (user == null || user.getUserId() == null) {
            log.info("登录信息已过期,请重新登录");
            return AppResult.failed("登录信息已过期,请重新登录");
        }
        // 判断当前登录用户是否已经点赞
        boolean liked = likeService.isLiked(postId, user.getUserId());
        if (liked) {
            log.info("你还没有点赞过该帖子");
            return AppResult.failed("你还没有点赞过该帖子");
        }
        // 查询帖子信息
        SysPostImage sysPostImage = postsImageService.selectPostById(postId);
        if (sysPostImage == null) {
            log.info("帖子不存在");
            return AppResult.failed("帖子不存在");
        }
        int userId = user.getUserId();
        if (sysPostImage.getUserId().equals(userId)) {
            log.info("不能给自己取消点赞");
            return AppResult.failed("不能给自己取消点赞");
        }
        // 取消点赞帖子
        boolean b = likeService.unlike(postId, user.getUserId());
        if (!b) {
            log.info("取消点赞失败");
            return AppResult.failed("取消点赞失败");
        }
        // 更新帖子点赞数
        if (sysPostImage.getLikesCount() == null) {
            sysPostImage.setLikesCount(0);
        }
        Integer likeCount = 0;
        postsImageService.updatePostLikeCount(postId, likeCount);
        return AppResult.success("取消点赞成功");
    }

    // 查询当前用户点赞过的帖子信息接口
    @GetMapping(value = "/queryLikedPosts")
    @ApiOperation(value = "查询当前用户点赞过的帖子信息接口")
    public AppResult queryLikedPosts(HttpServletRequest request) {
        String token = request.getHeader("token");
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
        String username = tokenInfo.getClaim("username").asString();
        // 从 redis 中获取当前登录用户
        User user = (User) redisUtil.get(username);
        if (user == null || user.getUserId() == null) {
            log.info("登录信息已过期,请重新登录");
            return AppResult.failed("登录信息已过期,请重新登录");
        }
        // 查询当前用户点赞过的帖子信息
        // 查询当前用户都是点赞过那些帖子,拿到帖子id,再根据帖子id查询帖子信息
        List<Integer> likedPostIds = likeService.getLikedPostIds(user.getUserId());
        if (likedPostIds == null || likedPostIds.isEmpty()) {
            log.info("没有点赞过的帖子");
            return AppResult.failed("没有点赞过的帖子");
        }
        List<SysPostImage> postImages = new ArrayList<>();
        // 根据帖子id查询帖子信息  图片信息
        for (Integer likedPostId : likedPostIds) {
            SysPostImage sysPostImage = postsImageService.selectPostById(likedPostId);
            if(sysPostImage == null) {
                continue;
            }
            List<SysImage> sysImages = postsImageService.selectPostImagesByPostId(likedPostId);
            sysPostImage.setImages(sysImages);
            postImages.add(sysPostImage);
        }
        Map<String, Object> map = new HashMap<>();
        map.put("list",postImages);
        return AppResult.success(map);
    }


    // 收藏帖子接口
    @PostMapping(value = "/collectPost")
    @ApiOperation(value = "收藏帖子接口")
    public AppResult collectPost(@RequestBody Map<String ,Object> params, HttpServletRequest request) {
       Integer postId = (Integer) params.get("postId");
        if (postId == null) {
            log.info("帖子id不能为空");
            return AppResult.failed("帖子id不能为空");
        }
        String token = request.getHeader("token");
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
        String username = tokenInfo.getClaim("username").asString();
        // 从 redis 中获取当前登录用户
        User user = (User) redisUtil.get(username);
        if (user == null || user.getUserId() == null) {
            log.info("登录信息已过期,请重新登录");
            return AppResult.failed("登录信息已过期,请重新登录");
        }
        Integer userId = user.getUserId();
        // 判断当前用户是否已经收藏
        boolean favorite = favoriteService.isFavorite(postId, userId);
        if (favorite) {
            log.info("你已经收藏过该帖子");
            return AppResult.failed("你已经收藏过该帖子");
        }
        // 查询帖子信息
        SysPostImage sysPostImage = postsImageService.selectPostById(postId);
        if(sysPostImage == null) {
            log.info("帖子不存在");
            return AppResult.failed("帖子不存在");
        }
        if (sysPostImage.getUserId().equals(userId)) {
            log.info("不能收藏自己的帖子");
            return AppResult.failed("不能收藏自己的帖子");
        }
        // 收藏帖子
        favoriteService.insertFavorite(sysPostImage, user);
        return AppResult.success();
    }


    // 取消收藏帖子接口
    @DeleteMapping(value = "/cancelCollectPost")
    @ApiOperation(value = "取消收藏帖子接口")
    public AppResult cancelCollectPost(@RequestBody Map<String,Object> params, HttpServletRequest request) {
        Integer postId = (Integer) params.get("postId");
        if (postId == null) {
            log.info("帖子id不能为空");
            return AppResult.failed("帖子id不能为空");
        }
        String token = request.getHeader("token");
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
        String username = tokenInfo.getClaim("username").asString();
        // 从 redis 中获取当前登录用户
        User user = (User) redisUtil.get(username);
        if (user == null || user.getUserId() == null) {
            log.info("登录信息已过期,请重新登录");
            return AppResult.failed("登录信息已过期,请重新登录");
        }
        // 查询帖子信息
        SysPostImage sysPostImage = postsImageService.selectPostById(postId);
        if (sysPostImage == null) {
            log.info("帖子不存在");
            return AppResult.failed("帖子不存在");
        }
        Integer userId = user.getUserId();
        if (sysPostImage.getUserId().equals(userId)) {
            log.info("不能取消收藏自己的帖子");
            return AppResult.failed("不能取消收藏自己的帖子");
        }
        // 判断当前登录用户是否收藏该帖子
        boolean favorite = favoriteService.isFavorite(postId, userId);
        if (!favorite) {
            // 没有收藏过 不能取消收藏
            log.info("你没有收藏过该帖子");
            return AppResult.failed("你没有收藏过该帖子");
        }
        // 取消收藏帖子
        favoriteService.deleteFavorite(sysPostImage, user);
        return AppResult.success();
    }


    // 获取当前用户收藏的帖子信息
    @GetMapping(value = "/queryCollectedPosts")
    @ApiOperation(value = "获取当前用户收藏的帖子信息")
    public AppResult queryCollectedPosts(HttpServletRequest request) {
        String token = request.getHeader("token");
        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
        String username = tokenInfo.getClaim("username").asString();
        // 从 redis 中获取当前登录用户
        User user = (User) redisUtil.get(username);
        if (user == null || user.getUserId() == null) {
            log.info("登录信息已过期,请重新登录");
            return AppResult.failed("登录信息已过期,请重新登录");
        }
        // 查询当前用户收藏的帖子信息
        List<SysPostImage> collectedPosts = favoriteService.getFavoriteList(user.getUserId());
        if (collectedPosts == null || collectedPosts.isEmpty()) {
            log.info("没有收藏的帖子");
            return AppResult.failed("没有收藏的帖子");
        }
        Map<String, Object> map = new HashMap<>();
        map.put("list", collectedPosts);
        return AppResult.success(map);
    }


//    // 评论帖子接口 todo
//    @PostMapping(value = "/commentPost")
//    @ApiOperation(value = "评论帖子接口")
//    public AppResult commentPost(@ApiParam("帖子id") @RequestParam("postId") Integer postId,
//                                 @ApiParam("评论内容") @RequestParam("content") String content,
//                                 @ApiParam("评论图片") @RequestParam(value = "images", required = false) List<MultipartFile> images,
//                                 HttpServletRequest request) {
//        if (postId == null) {
//            return AppResult.failed("帖子id不能为空");
//        }
//        if (content == null || content.trim().isEmpty()) {
//            return AppResult.failed("评论内容不能为空");
//        }
//        // 判断当前登录用户是否已经评论
//        String token = request.getHeader("token");
//        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
//        String username = tokenInfo.getClaim("username").asString();
//        // 从 redis 中获取当前登录用户
//        User user = (User) redisUtil.get(username);
//        // 查询帖子信息
//        SysPostImage sysPostImage = postsImageService.selectPostById(postId);
//        int userId = user.getUserId();
//        if (sysPostImage.getUserId() == userId) {
//            return AppResult.failed("不能评论自己的帖子");
//        }
//        // 评论帖子
//        boolean b = postsImageService.commentPost(postId, user, content, images);
//        if (!b) {
//            return AppResult.failed("评论失败");
//        }
//        return AppResult.success();
//    }
//
//    // 回复评论接口 todo
//    @PostMapping(value = "/replyComment")
//    @ApiOperation(value = "回复评论接口")
//    public AppResult replyComment(@ApiParam("评论id") @RequestParam("commentId") Integer commentId,
//                                  @ApiParam("回复内容") @RequestParam("content") String content,
//                                  @ApiParam("回复图片") @RequestParam(value = "images", required = false) List<MultipartFile> images,
//                                  HttpServletRequest request) {
//
//
//        if (commentId == null) {
//            return AppResult.failed("评论id不能为空");
//
//
//        }
//        if (content == null || content.trim().isEmpty()) {
//            return AppResult.failed("回复内容不能为空");
//
//        }
//
//
//        // 判断当前登录用户是否已经评论   todo
//        String token = request.getHeader("token");
//        DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
//        String username = tokenInfo.getClaim("username").asString();
//        // 从 redis 中获取当前登录用户
//        User user = (User) redisUtil.get(username);
//        // 回复评论
//        boolean b = postsImageService.replyComment(commentId, user, content, images);
//        if (!b) {
//            return AppResult.failed("回复失败");
//        }
//        return AppResult.success();
//    }
//
//    // 删除评论接口  todo
//
//    // 举报评论接口 todo
//
//
//    // 举报帖子接口 todo
//
//    // 搜索帖子接口 todo
//
//
//    // 关注用户接口 todo

}