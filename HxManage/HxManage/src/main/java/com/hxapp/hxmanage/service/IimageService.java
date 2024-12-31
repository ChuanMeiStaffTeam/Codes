package com.hxapp.hxmanage.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.hxapp.hxmanage.model.SysImage;
import org.springframework.stereotype.Service;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/11/18/16:44
 * @Description:
 */
@Service
public interface IimageService extends IService<SysImage> {

    Long getImagesCount();
}
