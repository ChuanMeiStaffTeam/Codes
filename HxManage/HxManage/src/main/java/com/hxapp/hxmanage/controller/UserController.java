package com.hxapp.hxmanage.controller;

import com.hxapp.hxmanage.common.AppResult;
import com.hxapp.hxmanage.config.AppConfig;
import com.hxapp.hxmanage.model.AdminUser;
import com.hxapp.hxmanage.model.User;
import com.hxapp.hxmanage.service.IUserService;
import com.hxapp.hxmanage.service.IadminService;
import com.hxapp.hxmanage.util.CurrentUser;
import com.hxapp.hxmanage.util.TimeUtil;
import com.hxapp.hxmanage.util.UploadUtil;



import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/10/26/17:48
 * @Description:
 */
@Slf4j
@RestController
@RequestMapping("/api/user")
public class UserController {


    @Autowired
    private IadminService adminService;

    @Autowired
    private UploadUtil uploadUtil;

    @Autowired
    private IUserService userService;

    @GetMapping("/getUser")
    public AppResult<AdminUser> getUser(HttpServletRequest request) {
        // 获取用户信息 从session中获取
        AdminUser adminUser = new AdminUser();
        HttpSession session = request.getSession(false);
        if (session != null) {
            AdminUser user = (AdminUser) session.getAttribute(AppConfig.USER_SESSION);
            if (user != null) {
                return AppResult.success(user);
            }
        }
        return AppResult.failed("用户未登录");
    }

    // 更新用户邮箱 电话
    @PostMapping("/updateUser")
    public AppResult<AdminUser> updateUser(HttpServletRequest request, String email, String phone) {
        AdminUser adminUser = new AdminUser();
        HttpSession session = request.getSession(false);
        if (session != null) {
            AdminUser user = (AdminUser) session.getAttribute(AppConfig.USER_SESSION);
            if (user != null) {
                user.setEmail(email);
                user.setPhone(phone);
                adminService.updateUser(user);
                // 更新session
                session.setAttribute(AppConfig.USER_SESSION, user);
            }
        }
        return AppResult.failed("用户未登录");
    }

    //    更换头像
    @PostMapping("/updateAvatar")
    public AppResult updateAvatar(HttpServletRequest request, @RequestParam("avatar") MultipartFile avatar) {
        if (avatar.isEmpty()) {
            log.info("请上传图片");
            return AppResult.failed("请上传图片");
        }
        AdminUser user = CurrentUser.getCurrentUser(request);
        if (user == null) {
            return AppResult.failed("用户未登录");
        }
        String avatarUrl = uploadUtil.uploadFile(avatar);
        user.setAvatarUrl(avatarUrl);
        adminService.updateAvatar(user);
        HttpSession session = request.getSession(false);
        session.setAttribute(AppConfig.USER_SESSION, user);
        return AppResult.success("头像更新成功", avatarUrl);
    }

    //    退出登录
    @PostMapping("/logout")
    public AppResult logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return AppResult.success("退出成功");
    }


    // 获取普通用户信息
    @GetMapping("/getUserAll")
    public AppResult getUserAll(@RequestParam(defaultValue = "1") Integer page,
                                @RequestParam(defaultValue = "10") Integer limit) {
        Page<User> userPage = new Page<>(page, limit);
        List<User> pageUser = userService.getAllUser(userPage);
        log.info("获取普通用户信息成功");
        Map<String, Object> map = new HashMap<>();
        // 返回岗位列表
        map.put("total", userPage.getTotal());  // 总条数
        map.put("records", pageUser);  // 岗位列表 当前页数据
        return AppResult.success(map);
    }


    // 根据账号搜索用户
    @GetMapping("/getUserByAccount")
    public AppResult getUserByAccount(@NonNull String accountName, @RequestParam(defaultValue = "1") Integer page,
                                      @RequestParam(defaultValue = "10") Integer limit) {
        Page<User> userPage = new Page<>(page, limit);
        List<User> userByAccount = userService.getUserByAccount(accountName,userPage);
        log.info("搜索用户");
        // 将查询结果包装成 AppResult 返回给前端
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("total", userPage.getTotal()); // 总记录数
        resultMap.put("records", userByAccount); // 当前页数据列表
        return AppResult.success(resultMap);
    }


    // 拉黑用户  锁定用户
    @PostMapping("/lockUser")
    public AppResult lockUser(@NonNull Integer userId) {
        User updateUser = new User();
        updateUser.setUserId(userId);
        updateUser.setAccountLocked(1);
        updateUser.setLockoutTime(TimeUtil.getCurrentTime());
        int i = userService.updateUser(updateUser);
        return i == 0? AppResult.failed("锁定失败") : AppResult.success("锁定成功");
    }


    // 解锁用户
    @PostMapping("/unlockUser")
    public AppResult unlockUser(@NonNull Integer userId) {
        User updateUser = new User();
        updateUser.setUserId(userId);
        updateUser.setAccountLocked(0);
        int i = userService.updateUser(updateUser);
        return i == 0? AppResult.failed("解锁失败") : AppResult.success("解锁成功");
    }
}
