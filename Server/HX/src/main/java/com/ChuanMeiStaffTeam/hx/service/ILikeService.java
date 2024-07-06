package com.ChuanMeiStaffTeam.hx.service;

import com.ChuanMeiStaffTeam.hx.model.SysLike;
import com.baomidou.mybatisplus.extension.service.IService;
import io.swagger.models.auth.In;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/06/16:38
 * @Description:
 */
@Service
public interface ILikeService extends IService<SysLike> {

    // 判断当前用户是否已经点赞过该文章
    boolean isLiked( Integer postId, Integer userId);

    // 点赞
    boolean like(Integer postId, Integer userId);

    // 取消点赞
    boolean unlike(Integer postId, Integer userId);

    // 查询当前用户点赞的帖子id
    List<Integer> getLikedPostIds(Integer userId);
}
