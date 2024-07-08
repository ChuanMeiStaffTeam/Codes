package com.ChuanMeiStaffTeam.hx.service;

import com.ChuanMeiStaffTeam.hx.model.SysFavorite;
import com.ChuanMeiStaffTeam.hx.model.SysPost;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.model.vo.SysPostImage;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/07/21:28
 * @Description:
 */
@Service
public interface IFavoriteService extends IService<SysFavorite> {

    // 新增收藏
    @Transactional
    void insertFavorite(SysPostImage post, User user);

    // 删除收藏
    @Transactional
    void deleteFavorite(SysPostImage post, User user);

    // 判断是否收藏
    boolean isFavorite(Integer postId, Integer userId);

    // 获取收藏列表
    List<SysPostImage> getFavoriteList(Integer userId);
}
