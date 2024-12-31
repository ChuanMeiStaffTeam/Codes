package com.hxapp.hxmanage.util;

import com.hxapp.hxmanage.common.AppResult;
import com.hxapp.hxmanage.config.AppConfig;
import com.hxapp.hxmanage.model.AdminUser;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/10/28/10:45
 * @Description:
 */
public class CurrentUser {

    public static AdminUser getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        AdminUser user = (AdminUser) session.getAttribute(AppConfig.USER_SESSION);
        return user;
    }
}
