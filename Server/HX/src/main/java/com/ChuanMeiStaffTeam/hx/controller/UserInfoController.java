package com.ChuanMeiStaffTeam.hx.controller;

import com.ChuanMeiStaffTeam.hx.common.AppResult;
import com.ChuanMeiStaffTeam.hx.exception.ApplicationException;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.service.IUserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.models.auth.In;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/23/11:00
 * @Description:
 */

@Slf4j
@RestController
@RequestMapping("/api/userinfo")
@Api(tags = "用户个人信息")
public class UserInfoController {


    @Value("${spring.servlet.multipart.location}")
    String path;

    @Resource
    private IUserService userService;

    // 更新用户头像
    @ApiOperation(value = "更新用户头像")
    @PostMapping("/updateAvatar")
    public AppResult updateAvatar(@ApiParam(value = "用户ID", example = "1") @RequestParam("userId") Integer userId,
                                  @ApiParam(value = "图片文件") @RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            log.error("图片不能为空");
            throw new ApplicationException("图片不能为空");
        }
        // 读取配置文件中图片上传路径
        File destinationFile = null;
        try {
            destinationFile = new File(path + File.separator + file.getOriginalFilename());
            file.transferTo(destinationFile);
        } catch (IOException e) {
            e.printStackTrace();
        }
        userService.updateUserAvatar(userId, destinationFile.getAbsolutePath());
        log.info("用户头像更新成功, 图片路径为{}" + destinationFile.getAbsolutePath());
        return AppResult.success(destinationFile.getAbsolutePath());
    }

    // 更新用户信息
    @ApiOperation(value = "更新用户基本信息")
    @PostMapping("/updateInfo")
    public AppResult updateInfo(@NonNull @ApiParam(value = "用户ID", example = "1") @RequestParam("userId") Integer userId,
                                @NonNull @ApiParam(value = "用户姓名") @RequestParam("fullName") String fullName,
                                @NonNull @ApiParam(value = "用户网站") @RequestParam("websiteUrl") String websiteUrl,
                                @NonNull @ApiParam(value = "用户简介") @RequestParam("bio")String bio) {

        User user = userService.getById(userId);
        if(user == null) {
            log.error("用户不存在");
            throw new ApplicationException("用户不存在");
        }
        user.setFullName(fullName);
        user.setWebsiteUrl(websiteUrl);
        user.setBio(bio);
        user.setUpdatedAt(new Timestamp(System.currentTimeMillis())); // 更新用户的更新时间
        int i = userService.updateUserBaseInfo(user);
        return AppResult.success(user);
    }
}
