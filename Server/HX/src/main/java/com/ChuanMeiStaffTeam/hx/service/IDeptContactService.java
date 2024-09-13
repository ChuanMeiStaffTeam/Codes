package com.ChuanMeiStaffTeam.hx.service;

import com.ChuanMeiStaffTeam.hx.model.DeptContact;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.stereotype.Service;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/09/13/18:43
 * @Description:
 */
@Service
public interface IDeptContactService extends IService<DeptContact> {

    // 插入企业登记信息
    int insertDeptContact(DeptContact deptContact);

}
