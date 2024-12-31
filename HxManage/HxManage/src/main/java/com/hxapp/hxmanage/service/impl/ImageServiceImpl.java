package com.hxapp.hxmanage.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hxapp.hxmanage.dao.ImageMapper;
import com.hxapp.hxmanage.model.SysImage;
import com.hxapp.hxmanage.service.IimageService;

import org.springframework.stereotype.Service;

import javax.annotation.Resource;


/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/11/18/16:45
 * @Description:
 */
@Service
public class ImageServiceImpl extends ServiceImpl<ImageMapper, SysImage> implements IimageService {


    @Resource
    private ImageMapper imageMapper;
    @Override
    public Long getImagesCount() {
        return imageMapper.selectCount(null);

    }
}
