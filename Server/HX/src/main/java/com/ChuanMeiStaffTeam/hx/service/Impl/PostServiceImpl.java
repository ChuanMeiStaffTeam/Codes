package com.ChuanMeiStaffTeam.hx.service.Impl;

import com.ChuanMeiStaffTeam.hx.dao.ImageMapper;
import com.ChuanMeiStaffTeam.hx.dao.PostMapper;
import com.ChuanMeiStaffTeam.hx.model.SysImage;
import com.ChuanMeiStaffTeam.hx.model.SysPost;
import com.ChuanMeiStaffTeam.hx.service.IImage;
import com.ChuanMeiStaffTeam.hx.service.IPostsImage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
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

    @Resource
    private IImage imageService;


    @Transactional
    @Override
    public boolean insertPost_image(SysPost sysPost, List<SysImage> sysImages) {
        int insert = postMapper.insert(sysPost);
        boolean b = imageService.saveBatch(sysImages);
        return insert == 1 && b;
    }
}
