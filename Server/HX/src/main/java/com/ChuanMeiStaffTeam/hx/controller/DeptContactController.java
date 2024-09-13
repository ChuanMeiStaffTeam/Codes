package com.ChuanMeiStaffTeam.hx.controller;

import com.ChuanMeiStaffTeam.hx.common.AppResult;
import com.ChuanMeiStaffTeam.hx.model.DeptContact;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.service.IDeptContactService;
import com.ChuanMeiStaffTeam.hx.util.AuthUtil;
import com.ChuanMeiStaffTeam.hx.util.RedisUtil;
import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/09/13/18:47
 * @Description:
 */
@RestController
@Slf4j
@Api(tags = "企业信息管理")
@RequestMapping("/api/deptContact")
public class DeptContactController {

    @Resource
    private RedisUtil redisUtil;

    @Resource
    private IDeptContactService deptContactService;


    @PostMapping("/addDeptContact")
    public AppResult addDeptContact(@RequestBody Map<String, String> params, HttpServletRequest request) {
        String currentUserName = AuthUtil.getCurrentUserName(request);
        User user = (User) redisUtil.get(currentUserName);
        if (user == null) {
            return AppResult.failed("操作失败");
        }
        String deptName = params.get("deptName");
        String deptCode = params.get("deptCode");
        String userName = params.get("userName");
        String phoneNumber = params.get("phoneNumber");
        if (deptName != null && userName != null && phoneNumber != null) {
            DeptContact deptContact = new DeptContact();
            deptContact.setUserId(user.getUserId());
            deptContact.setDeptName(deptName);
            deptContact.setDeptCode(deptCode);
            deptContact.setUserName(userName);
            deptContact.setPhoneNumber(phoneNumber);
            int i = deptContactService.insertDeptContact(deptContact);
            return i > 0? AppResult.success("添加成功") : AppResult.failed("添加失败,请联系管理员");
        } else {
            return AppResult.failed("参数不能为空");
        }

    }

}
