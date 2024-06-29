package com.ChuanMeiStaffTeam.hx.service;

import com.ChuanMeiStaffTeam.hx.model.SysImage;
import com.ChuanMeiStaffTeam.hx.model.SysPost;
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

    // 用户发帖上传图片
    boolean insertPost_image(SysPost sysPost, List<SysImage> sysImages);

}
